import { useState, useEffect, useMemo } from "react";

/* ─────────────────────────────────────────
   APEXCHARTS  (loaded via CDN in index.html)
   We access it via window.ApexCharts
───────────────────────────────────────── */

// ═══════════════════════════════════════════
//  DUMMY DATA
// ═══════════════════════════════════════════
const SKILLS = ["Gen AI", "Angular", "Java SpringBoot", "Domain", "AWS"];
const CERTS = [
  "AWS Solutions Architect",
  "AWS Developer Associate",
  "Azure Fundamentals",
  "Google Cloud Professional",
  "Kubernetes Administrator",
  "Terraform Associate",
  "Spring Professional",
  "Angular Certified Developer",
  "Gen AI Practitioner",
  "Scrum Master",
];
const ROLES = ["Developer", "Senior Developer", "Tech Lead", "Architect", "BA", "QA Engineer", "DevOps Engineer"];
// P&C Insurance domain projects
const PROJECTS = [
  { id: "PRJ001", name: "Policy Admin System Modernisation" },
  { id: "PRJ002", name: "Claims AI Automation" },
  { id: "PRJ003", name: "Underwriting Risk Engine" },
  { id: "PRJ004", name: "Customer Self-Service Portal" },
  { id: "PRJ005", name: "Reinsurance Data Platform" },
  { id: "PRJ006", name: "Fraud Detection & Analytics" },
];

const FIRST = ["Aiden","Priya","Marcus","Sofia","James","Mei","Carlos","Ananya","Ethan","Layla","Noah","Divya","Liam","Aisha","Omar","Yuki","Ryan","Fatima","Tyler","Nadia","Rohan","Elena","Kiran","Chloe","Dev","Sara","Arjun","Emily","Ravi","Zoe","Sanjay","Maya","Vikram","Rachel","Amit","Olivia","Raj","Hannah","Suresh","Lily","Kunal","Noor","Nikhil","Emma","Varun","Grace","Mihir","Isabelle","Aarav","Diana"];
const LAST = ["Chen","Sharma","Johnson","Patel","Williams","Tanaka","Rodriguez","Singh","Brown","Hassan","Davis","Gupta","Wilson","Khan","Taylor","Nakamura","Anderson","Ali","Jackson","Petrov","Mehta","Thompson","Nair","White","Kumar","Martin","Iyer","Moore","Bose","Clark","Joshi","Lewis","Reddy","Walker","Kapoor","Hall","Agarwal","Young","Pillai","King","Shah","Wright","Desai","Scott","Verma","Adams","Chandra","Baker","Malhotra","Nelson"];

function randInt(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function randFrom(arr) { return arr[randInt(0, arr.length - 1)]; }
function dateStr(y, m, d) { return `${y}-${String(m).padStart(2,"0")}-${String(d).padStart(2,"0")}`; }

// Seeded pseudo-random for determinism
const seed = (i) => ((i * 1103515245 + 12345) & 0x7fffffff) / 0x7fffffff;

const ASSOCIATES = Array.from({ length: 50 }, (_, i) => {
  const empId = `EMP${String(1001 + i).padStart(4, "0")}`;
  const name = `${FIRST[i]} ${LAST[i]}`;
  const skills = {};
  SKILLS.forEach((s, si) => {
    const base = Math.floor(seed(i * 7 + si * 13) * 5) + 1;       // 1-5 current
    const prev = Math.max(1, base - Math.floor(seed(i * 3 + si) * 2)); // prev month
    skills[s] = { current: base, previous: prev };
  });
  const certCount = Math.floor(seed(i * 11) * 4);
  const certs = CERTS.slice(0, CERTS.length)
    .sort(() => seed(i + certCount) - 0.5)
    .slice(0, certCount);
  return { empId, name, skills, certs, department: randFrom(["Engineering","QA","Architecture","DevOps","Analytics"]) };
});

// Project assignments — ~70% Active (end date 2026-12-31), ~30% Closed
// Role weights: DevOps intentionally less frequent than QA
const ROLE_WEIGHTS = [18, 14, 10, 6, 10, 12, 7]; // Dev, SrDev, TL, Arch, BA, QA, DevOps  (QA=12 > DevOps=7)
function weightedRole(i, p) {
  const total = ROLE_WEIGHTS.reduce((a, b) => a + b, 0);
  let r = Math.floor(seed(i * 9 + p + 3) * total);
  for (let ri = 0; ri < ROLES.length; ri++) { r -= ROLE_WEIGHTS[ri]; if (r < 0) return ROLES[ri]; }
  return ROLES[0];
}
const PROJECT_ROWS = [];
ASSOCIATES.forEach((a, i) => {
  const numProj = Math.floor(seed(i * 17) * 2) + 1;
  for (let p = 0; p < numProj; p++) {
    const proj = PROJECTS[Math.floor(seed(i * 5 + p) * PROJECTS.length)];
    const startYear = 2023 + Math.floor(seed(i + p) * 2);
    const startMonth = Math.floor(seed(i * 3 + p) * 12) + 1;
    // ~70% get future end date (Active), ~30% get past end date (Closed)
    const isActive = seed(i * 13 + p * 7) > 0.3;
    const endDate = isActive ? "2026-12-31" : dateStr(2023 + Math.floor(seed(i + p + 1) * 2), Math.floor(seed(i * 7 + p) * 12) + 1, 28);
    PROJECT_ROWS.push({
      projectId: proj.id,
      projectName: proj.name,
      associateId: a.empId,
      associateName: a.name,
      role: weightedRole(i, p),
      startDate: dateStr(startYear, startMonth, 1),
      endDate,
    });
  }
});
PROJECT_ROWS.sort((a, b) => a.projectId.localeCompare(b.projectId) || a.associateId.localeCompare(b.associateId));

// Month trend for certifications
const CERT_TREND = [
  { month: "Aug 24", count: 18 }, { month: "Sep 24", count: 22 },
  { month: "Oct 24", count: 27 }, { month: "Nov 24", count: 31 },
  { month: "Dec 24", count: 35 }, { month: "Jan 25", count: 40 },
  { month: "Feb 25", count: 44 }, { month: "Mar 25", count: 49 },
];

// ═══════════════════════════════════════════
//  STYLES  (CSS-in-JS via style tags injected)
// ═══════════════════════════════════════════
const STYLES = `
  @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap');

  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg: #f4f5f7;
    --surface: #ffffff;
    --surface2: #f9fafb;
    --border: #dde1e7;
    --border2: #c1c7d0;
    --text-primary: #172b4d;
    --text-secondary: #5e6c84;
    --text-muted: #97a0af;
    --accent: #0052cc;
    --accent-light: #deebff;
    --accent-hover: #0747a6;
    --success: #00875a;
    --success-light: #e3fcef;
    --warning: #ff8b00;
    --warning-light: #fffae6;
    --danger: #de350b;
    --danger-light: #ffebe6;
    --shadow-sm: 0 1px 3px rgba(9,30,66,.12), 0 0 0 1px rgba(9,30,66,.06);
    --shadow-md: 0 3px 8px rgba(9,30,66,.15), 0 0 0 1px rgba(9,30,66,.08);
    --radius: 6px;
    --radius-lg: 10px;
    --font: 'IBM Plex Sans', sans-serif;
    --mono: 'IBM Plex Mono', monospace;
  }

  body { font-family: var(--font); background: var(--bg); color: var(--text-primary); font-size: 14px; line-height: 1.5; }

  /* HEADER */
  .app-header {
    background: var(--accent);
    color: #fff;
    padding: 0 32px;
    height: 56px;
    display: flex;
    align-items: center;
    gap: 12px;
    box-shadow: 0 2px 8px rgba(0,82,204,.4);
    position: sticky;
    top: 0;
    z-index: 100;
  }
  .app-header .logo-mark {
    width: 32px; height: 32px;
    background: rgba(255,255,255,.2);
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-weight: 700; font-size: 16px; letter-spacing: -1px;
  }
  .app-header h1 { font-size: 17px; font-weight: 600; letter-spacing: .3px; }
  .app-header .subtitle { font-size: 12px; opacity: .7; margin-left: 4px; }
  .header-spacer { flex: 1; }
  .header-date { font-size: 12px; opacity: .75; font-family: var(--mono); }

  /* SEARCH BAR */
  .global-search {
    background: var(--surface);
    border-bottom: 1px solid var(--border);
    padding: 14px 32px;
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
  }
  .global-search label { font-size: 12px; font-weight: 600; color: var(--text-secondary); text-transform: uppercase; letter-spacing: .5px; }
  .search-field-wrap { display: flex; align-items: center; gap: 8px; }
  .search-input {
    border: 1px solid var(--border2);
    border-radius: var(--radius);
    padding: 7px 12px;
    font-family: var(--font);
    font-size: 13px;
    color: var(--text-primary);
    background: var(--surface2);
    outline: none;
    width: 200px;
    transition: border-color .15s, box-shadow .15s;
  }
  .search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 2px rgba(0,82,204,.15); background: #fff; }
  .btn {
    padding: 7px 16px;
    border-radius: var(--radius);
    font-family: var(--font);
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    border: none;
    transition: all .15s;
    display: inline-flex; align-items: center; gap: 6px;
  }
  .btn-primary { background: var(--accent); color: #fff; }
  .btn-primary:hover { background: var(--accent-hover); }
  .btn-secondary { background: var(--surface); color: var(--text-secondary); border: 1px solid var(--border2); }
  .btn-secondary:hover { background: var(--surface2); border-color: var(--accent); color: var(--accent); }
  .btn-sm { padding: 5px 12px; font-size: 12px; }

  /* TABS */
  .tab-bar {
    background: var(--surface);
    border-bottom: 2px solid var(--border);
    padding: 0 32px;
    display: flex;
    gap: 0;
  }
  .tab-item {
    padding: 14px 20px;
    font-size: 13px;
    font-weight: 500;
    color: var(--text-secondary);
    cursor: pointer;
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: all .15s;
    display: flex; align-items: center; gap: 8px;
    white-space: nowrap;
  }
  .tab-item:hover { color: var(--accent); background: var(--accent-light); }
  .tab-item.active { color: var(--accent); border-bottom-color: var(--accent); font-weight: 600; }
  .tab-icon { font-size: 15px; }

  /* CONTENT */
  .content { padding: 24px 32px; max-width: 1600px; }

  /* CARDS */
  .card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
  }
  .card-header {
    padding: 16px 20px 12px;
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; justify-content: space-between;
  }
  .card-title { font-size: 13px; font-weight: 600; color: var(--text-primary); text-transform: uppercase; letter-spacing: .5px; }
  .card-subtitle { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
  .card-body { padding: 20px; }

  /* KPI GRID */
  .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 24px; }
  .kpi-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 20px;
    position: relative;
    overflow: hidden;
    box-shadow: var(--shadow-sm);
  }
  .kpi-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 3px;
  }
  .kpi-card.blue::before { background: var(--accent); }
  .kpi-card.green::before { background: var(--success); }
  .kpi-card.orange::before { background: var(--warning); }
  .kpi-card.red::before { background: var(--danger); }
  .kpi-card.purple::before { background: #6554c0; }
  .kpi-label { font-size: 11px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: .5px; }
  .kpi-value { font-size: 32px; font-weight: 700; color: var(--text-primary); line-height: 1.1; margin: 8px 0 4px; font-family: var(--mono); }
  .kpi-delta { font-size: 12px; display: flex; align-items: center; gap: 4px; }
  .kpi-delta.up { color: var(--success); }
  .kpi-delta.down { color: var(--danger); }
  .kpi-icon { position: absolute; top: 16px; right: 16px; font-size: 28px; opacity: .15; }

  /* CHARTS GRID */
  .charts-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(380px, 1fr)); gap: 20px; margin-bottom: 24px; }
  .chart-wrap { min-height: 300px; }

  /* TABLE */
  .table-wrap { overflow-x: auto; border-radius: var(--radius-lg); border: 1px solid var(--border); box-shadow: var(--shadow-sm); }
  table { width: 100%; border-collapse: collapse; background: var(--surface); font-size: 13px; }
  thead tr { background: #f1f3f6; }
  th {
    padding: 11px 14px;
    text-align: left;
    font-size: 11px;
    font-weight: 700;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: .5px;
    border-bottom: 1px solid var(--border2);
    white-space: nowrap;
    cursor: pointer;
    user-select: none;
    transition: background .1s;
  }
  th:hover { background: #e8edf3; }
  td {
    padding: 10px 14px;
    border-bottom: 1px solid var(--border);
    color: var(--text-primary);
    vertical-align: middle;
  }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: #f5f7fa; }

  /* BADGES */
  .badge {
    display: inline-flex; align-items: center;
    padding: 2px 9px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
    font-family: var(--mono);
    letter-spacing: .2px;
  }
  .badge-blue { background: var(--accent-light); color: var(--accent); }
  .badge-green { background: var(--success-light); color: var(--success); }
  .badge-orange { background: var(--warning-light); color: var(--warning); }
  .badge-red { background: var(--danger-light); color: var(--danger); }
  .badge-grey { background: #ebecf0; color: var(--text-secondary); }
  .badge-purple { background: #eae6ff; color: #6554c0; }

  /* PAGINATION */
  .pagination {
    display: flex;
    align-items: center;
    gap: 4px;
    justify-content: flex-end;
    padding: 14px 0 4px;
    flex-wrap: wrap;
  }
  .page-info { font-size: 12px; color: var(--text-muted); margin-right: 8px; flex: 1; }
  .page-btn {
    width: 32px; height: 32px;
    border-radius: var(--radius);
    border: 1px solid var(--border2);
    background: var(--surface);
    color: var(--text-secondary);
    font-size: 13px;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    transition: all .15s;
    font-family: var(--font);
  }
  .page-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-light); }
  .page-btn.active { background: var(--accent); color: #fff; border-color: var(--accent); font-weight: 600; }
  .page-btn:disabled { opacity: .4; cursor: default; }
  .page-btn:disabled:hover { border-color: var(--border2); color: var(--text-secondary); background: var(--surface); }

  /* SEARCH ROW */
  .search-row {
    background: var(--surface2);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 14px 18px;
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    margin-bottom: 18px;
  }
  .search-row label { font-size: 12px; font-weight: 600; color: var(--text-secondary); white-space: nowrap; }
  .select-field {
    border: 1px solid var(--border2);
    border-radius: var(--radius);
    padding: 7px 10px;
    font-family: var(--font);
    font-size: 13px;
    background: #fff;
    color: var(--text-primary);
    outline: none;
    cursor: pointer;
    min-width: 180px;
  }
  .select-field:focus { border-color: var(--accent); }

  /* PIE MINI */
  .skill-pie-wrap { display: flex; align-items: center; gap: 6px; }
  .skill-pie-label { font-size: 11px; color: var(--text-muted); white-space: nowrap; }
  .skill-level { font-family: var(--mono); font-size: 12px; font-weight: 600; }

  /* LEVEL INDICATOR */
  .level-bar-wrap { display: flex; gap: 3px; align-items: center; }
  .level-dot { width: 10px; height: 10px; border-radius: 50%; }

  /* ALERT BANNER */
  .alert-banner {
    padding: 10px 16px;
    border-radius: var(--radius);
    font-size: 12px;
    font-weight: 500;
    display: flex; align-items: center; gap: 8px;
    margin-bottom: 16px;
  }
  .alert-info { background: var(--accent-light); color: var(--accent); border-left: 3px solid var(--accent); }
  .alert-warn { background: var(--warning-light); color: var(--warning); border-left: 3px solid var(--warning); }
  .alert-success { background: var(--success-light); color: var(--success); border-left: 3px solid var(--success); }

  /* CERT LIST */
  .cert-pills { display: flex; flex-wrap: wrap; gap: 4px; }

  /* SECTION TITLE */
  .section-title { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .7px; margin-bottom: 12px; }

  /* EMPTY STATE */
  .empty-state { text-align: center; padding: 48px 24px; color: var(--text-muted); }
  .empty-state .empty-icon { font-size: 48px; margin-bottom: 12px; opacity: .4; }
  .empty-state p { font-size: 14px; }

  /* SCROLLBAR */
  ::-webkit-scrollbar { width: 6px; height: 6px; }
  ::-webkit-scrollbar-track { background: var(--bg); }
  ::-webkit-scrollbar-thumb { background: var(--border2); border-radius: 3px; }

  /* REACT APEX */
  .apexcharts-tooltip { font-family: var(--font) !important; }
`;

// ═══════════════════════════════════════════
//  INJECT STYLES + APEXCHARTS CDN
// ═══════════════════════════════════════════
function injectDeps() {
  if (!document.getElementById("talent-styles")) {
    const s = document.createElement("style");
    s.id = "talent-styles";
    s.textContent = STYLES;
    document.head.appendChild(s);
  }
  if (!document.getElementById("apex-cdn")) {
    const script = document.createElement("script");
    script.id = "apex-cdn";
    script.src = "https://cdnjs.cloudflare.com/ajax/libs/apexcharts/3.45.1/apexcharts.min.js";
    document.head.appendChild(script);
  }
}

// ═══════════════════════════════════════════
//  APEX CHART COMPONENT
// ═══════════════════════════════════════════
function ApexChart({ id, options, height = 280 }) {
  const [ready, setReady] = useState(!!window.ApexCharts);
  useEffect(() => {
    if (window.ApexCharts) { setReady(true); return; }
    const interval = setInterval(() => {
      if (window.ApexCharts) { setReady(true); clearInterval(interval); }
    }, 100);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (!ready) return;
    const el = document.getElementById(id);
    if (!el) return;
    el.innerHTML = "";
    const chart = new window.ApexCharts(el, { ...options, chart: { ...options.chart, height } });
    chart.render();
    return () => chart.destroy();
  }, [ready, id, JSON.stringify(options)]);

  if (!ready) return <div style={{ height, display: "flex", alignItems: "center", justifyContent: "center", color: "var(--text-muted)", fontSize: 12 }}>Loading chart…</div>;
  return <div id={id} />;
}

// ═══════════════════════════════════════════
//  HELPER: LEVEL COLOR
// ═══════════════════════════════════════════
function levelColor(lvl) {
  return ["#de350b","#ff8b00","#0052cc","#00875a","#6554c0"][lvl - 1] || "#97a0af";
}
function levelBadgeClass(lvl) {
  return ["badge-red","badge-orange","badge-blue","badge-green","badge-purple"][lvl - 1] || "badge-grey";
}

// Mini horizontal bar showing current level (filled) vs previous (outline), replacing dots
function LevelBar({ current, previous }) {
  const maxLevel = 5;
  const barW = 56; // total bar width px
  const segW = barW / maxLevel;
  const improved = current > previous;
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
      <div style={{ position: "relative", width: barW, height: 10, background: "#ebecf0", borderRadius: 5, overflow: "hidden" }}>
        {/* Previous level fill */}
        {previous > 0 && (
          <div style={{
            position: "absolute", left: 0, top: 0, height: "100%",
            width: `${(previous / maxLevel) * 100}%`,
            background: levelColor(previous),
            opacity: 0.35,
            borderRadius: 5,
          }} />
        )}
        {/* Current level fill — incremental part in brighter color */}
        <div style={{
          position: "absolute", left: 0, top: 0, height: "100%",
          width: `${(current / maxLevel) * 100}%`,
          background: levelColor(current),
          borderRadius: 5,
        }} />
        {/* Segment dividers */}
        {[1,2,3,4].map(d => (
          <div key={d} style={{
            position: "absolute", left: `${(d / maxLevel) * 100}%`, top: 0,
            width: 1, height: "100%", background: "rgba(255,255,255,0.6)"
          }} />
        ))}
      </div>
      <span style={{ fontSize: 11, fontFamily: "var(--mono)", fontWeight: 700, color: levelColor(current), minWidth: 16 }}>L{current}</span>
      {improved && <span style={{ fontSize: 10, color: "var(--success)" }}>▲{current - previous}</span>}
    </div>
  );
}

// ═══════════════════════════════════════════
//  PAGINATION COMPONENT
// ═══════════════════════════════════════════
function Pagination({ total, page, perPage, onPage }) {
  const totalPages = Math.ceil(total / perPage);
  if (totalPages <= 1) return null;
  const pages = [];
  for (let i = 1; i <= totalPages; i++) {
    if (i === 1 || i === totalPages || (i >= page - 2 && i <= page + 2)) pages.push(i);
    else if (pages[pages.length - 1] !== "…") pages.push("…");
  }
  return (
    <div className="pagination">
      <span className="page-info">Showing {Math.min((page - 1) * perPage + 1, total)}–{Math.min(page * perPage, total)} of {total}</span>
      <button className="page-btn" disabled={page === 1} onClick={() => onPage(page - 1)}>‹</button>
      {pages.map((p, i) => p === "…"
        ? <span key={i} style={{ padding: "0 4px", color: "var(--text-muted)" }}>…</span>
        : <button key={p} className={`page-btn ${p === page ? "active" : ""}`} onClick={() => onPage(p)}>{p}</button>
      )}
      <button className="page-btn" disabled={page === totalPages} onClick={() => onPage(page + 1)}>›</button>
    </div>
  );
}

// ═══════════════════════════════════════════
//  TAB: SUMMARY DASHBOARD
// ═══════════════════════════════════════════
function SummaryTab() {
  // KPIs
  const totalAssoc = ASSOCIATES.length;
  const certified = ASSOCIATES.filter(a => a.certs.length > 0).length;
  const level3Plus = ASSOCIATES.filter(a => SKILLS.some(s => a.skills[s].current >= 3)).length;
  const avgSkill = (ASSOCIATES.flatMap(a => SKILLS.map(s => a.skills[s].current)).reduce((a, b) => a + b, 0) / (ASSOCIATES.length * SKILLS.length)).toFixed(1);
  const improved = ASSOCIATES.filter(a => SKILLS.some(s => a.skills[s].current > a.skills[s].previous)).length;
  const weakAreas = SKILLS.filter(s => {
    const avg = ASSOCIATES.reduce((sum, a) => sum + a.skills[s].current, 0) / ASSOCIATES.length;
    return avg < 3;
  });

  // Skill distribution per skill (avg level)
  const skillAvgs = SKILLS.map(s => ({
    name: s,
    current: (ASSOCIATES.reduce((sum, a) => sum + a.skills[s].current, 0) / ASSOCIATES.length).toFixed(2),
    previous: (ASSOCIATES.reduce((sum, a) => sum + a.skills[s].previous, 0) / ASSOCIATES.length).toFixed(2),
  }));

  // Level 3+ count per skill
  const level3Counts = SKILLS.map(s => ASSOCIATES.filter(a => a.skills[s].current >= 3).length);

  // Dept distribution
  const depts = {};
  ASSOCIATES.forEach(a => { depts[a.department] = (depts[a.department] || 0) + 1; });

  const skillBarOptions = {
    chart: { type: "bar", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
    series: [
      { name: "This Month", data: skillAvgs.map(s => +s.current) },
      { name: "Last Month", data: skillAvgs.map(s => +s.previous) },
    ],
    xaxis: { categories: SKILLS, labels: { style: { fontSize: "12px" } } },
    yaxis: { min: 0, max: 5, tickAmount: 5, labels: { formatter: v => `L${v}` } },
    colors: ["#0052cc", "#b3d4ff"],
    plotOptions: { bar: { borderRadius: 4, columnWidth: "55%", dataLabels: { position: "top" } } },
    dataLabels: { enabled: false },
    legend: { position: "top", fontSize: "12px" },
    tooltip: { y: { formatter: v => `Level ${v}` } },
    title: { text: "Average Skill Level — This vs Last Month", style: { fontSize: "13px", fontWeight: 600 } },
  };

  const level3BarOptions = {
    chart: { type: "bar", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
    series: [{ name: "Associates at Level 3+", data: level3Counts }],
    xaxis: { categories: SKILLS, labels: { style: { fontSize: "12px" } } },
    yaxis: { min: 0, max: 55, labels: { show: true } },
    colors: ["#00875a"],
    plotOptions: {
      bar: {
        borderRadius: 4,
        horizontal: true,
        barHeight: "55%",
        dataLabels: { position: "right" },
      }
    },
    dataLabels: {
      enabled: true,
      textAnchor: "start",
      offsetX: 6,
      style: { fontSize: "12px", fontWeight: 700, colors: ["#172b4d"] },
      formatter: (val) => `${val} associates`,
    },
    title: { text: "Associates at Level 3+ per Skill", style: { fontSize: "13px", fontWeight: 600 } },
    grid: { xaxis: { lines: { show: false } } },
  };

  const certTrendOptions = {
    chart: { type: "area", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
    series: [{ name: "Certified Associates", data: CERT_TREND.map(t => t.count) }],
    xaxis: { categories: CERT_TREND.map(t => t.month) },
    yaxis: { min: 0 },
    colors: ["#6554c0"],
    fill: { type: "gradient", gradient: { shadeIntensity: 1, opacityFrom: .4, opacityTo: .05 } },
    stroke: { width: 2 },
    markers: { size: 4 },
    title: { text: "Certification Growth Trend", style: { fontSize: "13px", fontWeight: 600 } },
    dataLabels: { enabled: false },
  };

  const DEPT_COLORS = ["#0052cc","#00875a","#ff8b00","#de350b","#6554c0"];
  const deptEntries = Object.entries(depts);
  const deptPieOptions = {
    chart: { type: "donut", fontFamily: "IBM Plex Sans", toolbar: { show: false } },
    series: deptEntries.map(([,v]) => v),
    labels: deptEntries.map(([k]) => k),
    colors: DEPT_COLORS,
    legend: { show: false },
    title: { text: "Team by Department", style: { fontSize: "13px", fontWeight: 600 } },
    plotOptions: {
      pie: {
        donut: {
          size: "62%",
          labels: {
            show: true,
            total: {
              show: true, label: "Total", color: "#172b4d",
              fontSize: "13px", fontWeight: 700,
              formatter: () => String(50),
            },
            value: { fontSize: "22px", fontWeight: 700, color: "#172b4d" },
          }
        }
      }
    },
    dataLabels: { enabled: false },
    tooltip: { y: { formatter: v => `${v} associates` } },
  };

  return (
    <div>
      {weakAreas.length > 0 && (
        <div className="alert-banner alert-warn">
          ⚠️ <strong>Weak Areas Detected:</strong> {weakAreas.join(", ")} — average level below 3.0. Consider scheduling training sessions.
        </div>
      )}
      <div className="alert-banner alert-success">
        📈 <strong>Progress Update:</strong> {improved} associates improved at least one skill level this month. Certification headcount up from {CERT_TREND[CERT_TREND.length-2].count} to {CERT_TREND[CERT_TREND.length-1].count}.
      </div>

      <div className="kpi-grid">
        <div className="kpi-card blue">
          <div className="kpi-icon">👥</div>
          <div className="kpi-label">Total Associates</div>
          <div className="kpi-value">{totalAssoc}</div>
          <div className="kpi-delta up">↑ 3 from last month</div>
        </div>
        <div className="kpi-card green">
          <div className="kpi-icon">🎓</div>
          <div className="kpi-label">Certified</div>
          <div className="kpi-value">{certified}</div>
          <div className="kpi-delta up">↑ {certified - 40} this month</div>
        </div>
        <div className="kpi-card purple">
          <div className="kpi-icon">⭐</div>
          <div className="kpi-label">Level 3+ (any skill)</div>
          <div className="kpi-value">{level3Plus}</div>
          <div className="kpi-delta up">↑ 5 from last month</div>
        </div>
        <div className="kpi-card orange">
          <div className="kpi-icon">📊</div>
          <div className="kpi-label">Avg Skill Level</div>
          <div className="kpi-value">{avgSkill}</div>
          <div className="kpi-delta up">↑ 0.2 improvement</div>
        </div>
        <div className="kpi-card blue">
          <div className="kpi-icon">🚀</div>
          <div className="kpi-label">Improved This Month</div>
          <div className="kpi-value">{improved}</div>
          <div className="kpi-delta">{Math.round(improved/totalAssoc*100)}% of team</div>
        </div>
      </div>

      <div className="charts-grid">
        <div className="card">
          <div className="card-body chart-wrap">
            <ApexChart id="apex-skill-bar" options={skillBarOptions} height={280} />
          </div>
        </div>
        <div className="card">
          <div className="card-body chart-wrap">
            <ApexChart id="apex-level3" options={level3BarOptions} height={280} />
          </div>
        </div>
        <div className="card">
          <div className="card-body chart-wrap">
            <ApexChart id="apex-cert-trend" options={certTrendOptions} height={280} />
          </div>
        </div>
        <div className="card">
          <div className="card-body" style={{ display: "flex", alignItems: "center", gap: 0 }}>
            {/* Donut takes left portion */}
            <div style={{ flex: "0 0 55%" }}>
              <ApexChart id="apex-dept-pie" options={deptPieOptions} height={280} />
            </div>
            {/* Custom legend on the right — no overlap */}
            <div style={{ flex: "0 0 45%", paddingLeft: 8 }}>
              <div style={{ fontSize: 12, fontWeight: 700, color: "var(--text-secondary)", textTransform: "uppercase", letterSpacing: ".5px", marginBottom: 14 }}>
                Team by Department
              </div>
              {deptEntries.map(([dept, count], idx) => (
                <div key={dept} style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 12 }}>
                  <div style={{ width: 12, height: 12, borderRadius: 3, background: DEPT_COLORS[idx % DEPT_COLORS.length], flexShrink: 0 }} />
                  <div style={{ flex: 1, fontSize: 13, color: "var(--text-primary)", fontWeight: 500 }}>{dept}</div>
                  <div style={{ fontSize: 13, fontFamily: "var(--mono)", fontWeight: 700, color: "var(--text-primary)" }}>{count}</div>
                  <div style={{ fontSize: 11, color: "var(--text-muted)", minWidth: 32 }}>{Math.round(count / 50 * 100)}%</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════
//  TAB: LEARNING
// ═══════════════════════════════════════════
const LEARNING_PER_PAGE = 10;

function LearningTab({ globalEmpId, globalName }) {
  const [empId, setEmpId] = useState(globalEmpId || "");
  const [name, setName] = useState(globalName || "");
  const [skill, setSkill] = useState("All");
  const [minLevel, setMinLevel] = useState("1");
  const [page, setPage] = useState(1);

  // "active" state = what's actually applied to the filter
  const [activeFilters, setActiveFilters] = useState({
    empId: globalEmpId || "", name: globalName || "", skill: "All", minLevel: "1"
  });

  useEffect(() => {
    setEmpId(globalEmpId || "");
    setName(globalName || "");
    setActiveFilters(f => ({ ...f, empId: globalEmpId || "", name: globalName || "" }));
    setPage(1);
  }, [globalEmpId, globalName]);

  const filtered = useMemo(() => ASSOCIATES.filter(a => {
    const { empId: aEmp, name: aName, skill: aSkill, minLevel: aMin } = activeFilters;
    if (aEmp && !a.empId.toLowerCase().includes(aEmp.toLowerCase())) return false;
    if (aName && !a.name.toLowerCase().includes(aName.toLowerCase())) return false;
    const lvl = +aMin;
    if (aSkill !== "All" && lvl > 1) {
      // Must have at least minLevel in the specified skill
      if ((a.skills[aSkill]?.current ?? 0) < lvl) return false;
    } else if (aSkill !== "All") {
      // Skill selected but no min level filter — show all (no filtering on level)
    } else if (lvl > 1) {
      // No specific skill, but min level set — must have >= minLevel in ANY skill
      if (!SKILLS.some(s => a.skills[s].current >= lvl)) return false;
    }
    return true;
  }), [activeFilters]);

  const paged = filtered.slice((page - 1) * LEARNING_PER_PAGE, page * LEARNING_PER_PAGE);

  const handleSearch = () => {
    setActiveFilters({ empId, name, skill, minLevel });
    setPage(1);
  };
  const handleReset = () => {
    setEmpId(""); setName(""); setSkill("All"); setMinLevel("1");
    setActiveFilters({ empId: "", name: "", skill: "All", minLevel: "1" });
    setPage(1);
  };

  return (
    <div>
      <div className="search-row">
        <label>Filter:</label>
        <input className="search-input" placeholder="Employee ID" value={empId} onChange={e => setEmpId(e.target.value)} onKeyDown={e => e.key === "Enter" && handleSearch()} />
        <input className="search-input" placeholder="Associate Name" value={name} onChange={e => setName(e.target.value)} onKeyDown={e => e.key === "Enter" && handleSearch()} />
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          <label>Skill:</label>
          <select className="select-field" value={skill} onChange={e => setSkill(e.target.value)}>
            <option value="All">All Skills</option>
            {SKILLS.map(s => <option key={s}>{s}</option>)}
          </select>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          <label>Min Level:</label>
          <select className="select-field" style={{ minWidth: 80 }} value={minLevel} onChange={e => setMinLevel(e.target.value)}>
            {[1,2,3,4,5].map(l => <option key={l} value={l}>L{l}</option>)}
          </select>
        </div>
        <button className="btn btn-primary btn-sm" onClick={handleSearch}>🔍 Search</button>
        <button className="btn btn-secondary btn-sm" onClick={handleReset}>✕ Reset</button>
        <span style={{ marginLeft: "auto", fontSize: 12, color: "var(--text-muted)" }}>{filtered.length} result{filtered.length !== 1 ? "s" : ""}</span>
      </div>

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Emp ID</th>
              <th>Associate Name</th>
              <th>Dept</th>
              {SKILLS.map(s => <th key={s}>{s}</th>)}
              <th>Avg Level</th>
            </tr>
          </thead>
          <tbody>
            {paged.length === 0 ? (
              <tr><td colSpan={SKILLS.length + 4} style={{ textAlign: "center", padding: 32, color: "var(--text-muted)" }}>No associates match your search.</td></tr>
            ) : paged.map(a => {
              const avg = (SKILLS.reduce((sum, s) => sum + a.skills[s].current, 0) / SKILLS.length).toFixed(1);
              return (
                <tr key={a.empId}>
                  <td><span className="badge badge-grey" style={{ fontFamily: "var(--mono)" }}>{a.empId}</span></td>
                  <td style={{ fontWeight: 500 }}>{a.name}</td>
                  <td><span className="badge badge-blue">{a.department}</span></td>
                  {SKILLS.map(s => (
                    <td key={s}>
                      <LevelBar current={a.skills[s].current} previous={a.skills[s].previous} />
                    </td>
                  ))}
                  <td>
                    <span className={`badge ${levelBadgeClass(Math.round(+avg))}`}>{avg}</span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
      <Pagination total={filtered.length} page={page} perPage={LEARNING_PER_PAGE} onPage={setPage} />

      <div style={{ marginTop: 16, fontSize: 11, color: "var(--text-muted)", display: "flex", gap: 20, flexWrap: "wrap" }}>
        <strong>Legend:</strong>
        {[1,2,3,4,5].map(l => (
          <span key={l} style={{ display: "inline-flex", alignItems: "center", gap: 5 }}>
            <span style={{ width: 24, height: 8, borderRadius: 4, background: levelColor(l), display: "inline-block" }} />
            L{l} — {["Beginner","Novice","Intermediate","Advanced","Expert"][l-1]}
          </span>
        ))}
        <span>▲ = improvement from last month &nbsp;|&nbsp; faded fill = prior level</span>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════
//  TAB: CERTIFICATION
// ═══════════════════════════════════════════
const CERT_PER_PAGE = 10;

function CertificationTab({ globalEmpId, globalName }) {
  const [selectedCert, setSelectedCert] = useState("All");
  const [empId, setEmpId] = useState(globalEmpId || "");
  const [name, setName] = useState(globalName || "");
  const [page, setPage] = useState(1);
  const [activeEmpId, setActiveEmpId] = useState(globalEmpId || "");
  const [activeName, setActiveName] = useState(globalName || "");
  const [activeCert, setActiveCert] = useState("All");

  useEffect(() => { setActiveEmpId(globalEmpId || ""); setActiveName(globalName || ""); setPage(1); }, [globalEmpId, globalName]);

  const certifiedAssocs = ASSOCIATES.filter(a => a.certs.length > 0);
  const certCounts = CERTS.map(c => ({ cert: c, count: ASSOCIATES.filter(a => a.certs.includes(c)).length }))
    .sort((a, b) => b.count - a.count);

  const filtered = useMemo(() => ASSOCIATES.filter(a => {
    if (activeCert !== "All" && !a.certs.includes(activeCert)) return false;
    if (activeEmpId && !a.empId.toLowerCase().includes(activeEmpId.toLowerCase())) return false;
    if (activeName && !a.name.toLowerCase().includes(activeName.toLowerCase())) return false;
    return true;
  }), [activeCert, activeEmpId, activeName]);

  const paged = filtered.slice((page - 1) * CERT_PER_PAGE, page * CERT_PER_PAGE);

  const handleSearch = () => { setActiveCert(selectedCert); setActiveEmpId(empId); setActiveName(name); setPage(1); };
  const handleReset = () => { setSelectedCert("All"); setEmpId(""); setName(""); setActiveCert("All"); setActiveEmpId(""); setActiveName(""); setPage(1); };

  const certBarOptions = {
    chart: { type: "bar", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
    series: [{ name: "Associates", data: certCounts.map(c => c.count) }],
    xaxis: { categories: certCounts.map(c => c.cert.replace(" ", "\n")), labels: { style: { fontSize: "11px" } } },
    colors: ["#6554c0"],
    plotOptions: { bar: { borderRadius: 4, columnWidth: "60%" } },
    dataLabels: { enabled: true, style: { fontSize: "11px" } },
    title: { text: "Associates per Certification", style: { fontSize: "13px", fontWeight: 600 } },
    yaxis: { min: 0 },
  };

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20, marginBottom: 20 }}>
        <div className="card">
          <div className="card-body" style={{ display: "flex", gap: 24, alignItems: "center" }}>
            <div style={{ textAlign: "center" }}>
              <div style={{ fontSize: 48, fontWeight: 700, color: "var(--accent)", fontFamily: "var(--mono)" }}>{certifiedAssocs.length}</div>
              <div style={{ fontSize: 12, color: "var(--text-muted)" }}>Associates Certified</div>
              <div style={{ fontSize: 12, color: "var(--success)", marginTop: 4 }}>▲ {CERT_TREND[CERT_TREND.length-1].count - CERT_TREND[CERT_TREND.length-2].count} this month</div>
            </div>
            <div style={{ flex: 1 }}>
              {certCounts.slice(0, 5).map((c, i) => (
                <div key={c.cert} style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
                  <div style={{ fontSize: 11, color: "var(--text-muted)", width: 14 }}>#{i+1}</div>
                  <div style={{ flex: 1, fontSize: 12, color: "var(--text-primary)", fontWeight: 500 }}>{c.cert}</div>
                  <div style={{ width: `${Math.round(c.count/ASSOCIATES.length*100)}%`, maxWidth: 80, height: 6, background: "var(--accent)", borderRadius: 3, minWidth: 4 }} />
                  <div style={{ fontSize: 12, fontFamily: "var(--mono)", color: "var(--text-secondary)", minWidth: 20 }}>{c.count}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card-body chart-wrap">
            <ApexChart id="apex-cert-trend-tab" options={{
              chart: { type: "area", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
              series: [{ name: "Certified Associates", data: CERT_TREND.map(t => t.count) }],
              xaxis: { categories: CERT_TREND.map(t => t.month) },
              colors: ["#6554c0"],
              fill: { type: "gradient", gradient: { opacityFrom: .35, opacityTo: .05 } },
              stroke: { width: 2 },
              markers: { size: 4 },
              title: { text: "Certification Trend (8 Months)", style: { fontSize: "13px", fontWeight: 600 } },
              dataLabels: { enabled: true, style: { fontSize: "11px" } },
            }} height={220} />
          </div>
        </div>
      </div>

      <div className="card" style={{ marginBottom: 20 }}>
        <div className="card-body chart-wrap">
          <ApexChart id="apex-cert-bar" options={certBarOptions} height={240} />
        </div>
      </div>

      <div className="search-row">
        <label>Certification:</label>
        <select className="select-field" value={selectedCert} onChange={e => setSelectedCert(e.target.value)}>
          <option value="All">All Certifications</option>
          {[...CERTS].sort().map(c => <option key={c}>{c}</option>)}
        </select>
        <input className="search-input" placeholder="Employee ID" value={empId} onChange={e => setEmpId(e.target.value)} />
        <input className="search-input" placeholder="Associate Name" value={name} onChange={e => setName(e.target.value)} />
        <button className="btn btn-primary btn-sm" onClick={handleSearch}>🔍 Search</button>
        <button className="btn btn-secondary btn-sm" onClick={handleReset}>✕ Reset</button>
        <span style={{ marginLeft: "auto", fontSize: 12, color: "var(--text-muted)" }}>{filtered.length} result{filtered.length !== 1 ? "s" : ""}</span>
      </div>

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Emp ID</th>
              <th>Associate Name</th>
              <th>Dept</th>
              <th># Certs</th>
              <th>Certifications Held</th>
            </tr>
          </thead>
          <tbody>
            {paged.length === 0 ? (
              <tr><td colSpan={5} style={{ textAlign: "center", padding: 32, color: "var(--text-muted)" }}>No associates match your search.</td></tr>
            ) : paged.map(a => (
              <tr key={a.empId}>
                <td><span className="badge badge-grey" style={{ fontFamily: "var(--mono)" }}>{a.empId}</span></td>
                <td style={{ fontWeight: 500 }}>{a.name}</td>
                <td><span className="badge badge-blue">{a.department}</span></td>
                <td><span className={`badge ${a.certs.length >= 3 ? "badge-green" : a.certs.length >= 1 ? "badge-orange" : "badge-grey"}`}>{a.certs.length}</span></td>
                <td>
                  <div className="cert-pills">
                    {a.certs.length === 0
                      ? <span style={{ color: "var(--text-muted)", fontSize: 12 }}>—</span>
                      : a.certs.map(c => <span key={c} className="badge badge-purple" style={{ marginBottom: 2 }}>{c}</span>)
                    }
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination total={filtered.length} page={page} perPage={CERT_PER_PAGE} onPage={setPage} />
    </div>
  );
}

// ═══════════════════════════════════════════
//  TAB: PROJECT DETAILS
// ═══════════════════════════════════════════
const PROJ_PER_PAGE = 12;

function ProjectTab({ globalEmpId, globalName }) {
  const [projId, setProjId] = useState("All");
  const [empId, setEmpId] = useState(globalEmpId || "");
  const [name, setName] = useState(globalName || "");
  const [role, setRole] = useState("All");
  const [page, setPage] = useState(1);
  const [activeProjId, setActiveProjId] = useState("All");
  const [activeEmpId, setActiveEmpId] = useState(globalEmpId || "");
  const [activeName, setActiveName] = useState(globalName || "");
  const [activeRole, setActiveRole] = useState("All");

  useEffect(() => { setActiveEmpId(globalEmpId || ""); setActiveName(globalName || ""); setPage(1); }, [globalEmpId, globalName]);

  const filtered = useMemo(() => PROJECT_ROWS.filter(r => {
    if (activeProjId !== "All" && r.projectId !== activeProjId) return false;
    if (activeEmpId && !r.associateId.toLowerCase().includes(activeEmpId.toLowerCase())) return false;
    if (activeName && !r.associateName.toLowerCase().includes(activeName.toLowerCase())) return false;
    if (activeRole !== "All" && r.role !== activeRole) return false;
    return true;
  }), [activeProjId, activeEmpId, activeName, activeRole]);

  const paged = filtered.slice((page - 1) * PROJ_PER_PAGE, page * PROJ_PER_PAGE);

  const handleSearch = () => { setActiveProjId(projId); setActiveEmpId(empId); setActiveName(name); setActiveRole(role); setPage(1); };
  const handleReset = () => { setProjId("All"); setEmpId(""); setName(""); setRole("All"); setActiveProjId("All"); setActiveEmpId(""); setActiveName(""); setActiveRole("All"); setPage(1); };

  const projSize = PROJECTS.map(p => ({
    name: p.name,
    count: PROJECT_ROWS.filter(r => r.projectId === p.id).length,
  }));

  const projPieOptions = {
    chart: { type: "donut", fontFamily: "IBM Plex Sans", toolbar: { show: false } },
    series: projSize.map(p => p.count),
    labels: projSize.map(p => p.name),
    colors: ["#0052cc","#00875a","#ff8b00","#de350b","#6554c0","#00b8d9"],
    legend: { position: "right", fontSize: "11px" },
    title: { text: "Headcount by Project", style: { fontSize: "13px", fontWeight: 600 } },
    plotOptions: { pie: { donut: { size: "60%" } } },
    dataLabels: { style: { fontSize: "11px" } },
  };

  const roleData = ROLES.map(r => PROJECT_ROWS.filter(x => x.role === r).length);
  const roleBarOptions = {
    chart: { type: "bar", toolbar: { show: false }, fontFamily: "IBM Plex Sans" },
    series: [{ name: "Assignments", data: roleData }],
    xaxis: { categories: ROLES, labels: { style: { fontSize: "11px" } } },
    colors: ["#0052cc"],
    plotOptions: { bar: { borderRadius: 4, horizontal: true } },
    dataLabels: { enabled: true, style: { fontSize: "11px" } },
    title: { text: "Assignments by Role", style: { fontSize: "13px", fontWeight: 600 } },
  };

  const isActive = (row) => row.endDate >= new Date().toISOString().slice(0, 10);

  return (
    <div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20, marginBottom: 20 }}>
        <div className="card"><div className="card-body chart-wrap"><ApexChart id="apex-proj-pie" options={projPieOptions} height={260} /></div></div>
        <div className="card"><div className="card-body chart-wrap"><ApexChart id="apex-role-bar" options={roleBarOptions} height={260} /></div></div>
      </div>

      <div className="search-row">
        <label>Project:</label>
        <select className="select-field" value={projId} onChange={e => setProjId(e.target.value)}>
          <option value="All">All Projects</option>
          {PROJECTS.map(p => <option key={p.id} value={p.id}>{p.id} — {p.name}</option>)}
        </select>
        <label>Role:</label>
        <select className="select-field" value={role} onChange={e => setRole(e.target.value)}>
          <option value="All">All Roles</option>
          {ROLES.map(r => <option key={r}>{r}</option>)}
        </select>
        <input className="search-input" placeholder="Employee ID" value={empId} onChange={e => setEmpId(e.target.value)} />
        <input className="search-input" placeholder="Associate Name" value={name} onChange={e => setName(e.target.value)} />
        <button className="btn btn-primary btn-sm" onClick={handleSearch}>🔍 Search</button>
        <button className="btn btn-secondary btn-sm" onClick={handleReset}>✕ Reset</button>
        <span style={{ marginLeft: "auto", fontSize: 12, color: "var(--text-muted)" }}>{filtered.length} record{filtered.length !== 1 ? "s" : ""}</span>
      </div>

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Project ID</th>
              <th>Project Name</th>
              <th>Emp ID</th>
              <th>Associate Name</th>
              <th>Role</th>
              <th>Start Date</th>
              <th>End Date</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {paged.length === 0 ? (
              <tr><td colSpan={8} style={{ textAlign: "center", padding: 32, color: "var(--text-muted)" }}>No records match your search.</td></tr>
            ) : paged.map((r, i) => (
              <tr key={i}>
                <td><span className="badge badge-blue" style={{ fontFamily: "var(--mono)" }}>{r.projectId}</span></td>
                <td style={{ fontWeight: 500 }}>{r.projectName}</td>
                <td><span className="badge badge-grey" style={{ fontFamily: "var(--mono)" }}>{r.associateId}</span></td>
                <td>{r.associateName}</td>
                <td><span className="badge badge-purple">{r.role}</span></td>
                <td style={{ fontFamily: "var(--mono)", fontSize: 12 }}>{r.startDate}</td>
                <td style={{ fontFamily: "var(--mono)", fontSize: 12 }}>{r.endDate}</td>
                <td><span className={`badge ${isActive(r) ? "badge-green" : "badge-grey"}`}>{isActive(r) ? "Active" : "Closed"}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination total={filtered.length} page={page} perPage={PROJ_PER_PAGE} onPage={setPage} />
    </div>
  );
}

// ═══════════════════════════════════════════
//  ROOT APP
// ═══════════════════════════════════════════
const TABS = [
  { id: "summary", label: "Summary Dashboard", icon: "📊" },
  { id: "learning", label: "Learning", icon: "📚" },
  { id: "certification", label: "Certification", icon: "🎓" },
  { id: "projects", label: "Project Details", icon: "🗂️" },
];

export default function TalentPortal() {
  useEffect(() => { injectDeps(); }, []);

  const [activeTab, setActiveTab] = useState("summary");
  const [globalEmpId, setGlobalEmpId] = useState("");
  const [globalName, setGlobalName] = useState("");
  const [searchEmpId, setSearchEmpId] = useState("");
  const [searchName, setSearchName] = useState("");

  const handleGlobalSearch = () => {
    setGlobalEmpId(searchEmpId);
    setGlobalName(searchName);
    if (searchEmpId || searchName) setActiveTab("learning");
  };
  const handleGlobalReset = () => {
    setSearchEmpId("");
    setSearchName("");
    setGlobalEmpId("");
    setGlobalName("");
  };

  const today = new Date().toLocaleDateString("en-GB", { day: "2-digit", month: "short", year: "numeric" });

  return (
    <div style={{ minHeight: "100vh", background: "var(--bg)" }}>
      {/* HEADER */}
      <header className="app-header">
        <div className="logo-mark">TP</div>
        <h1>Talent Portal</h1>
        <span className="subtitle">/ Team Intelligence Dashboard</span>
        <div className="header-spacer" />
        <span className="header-date">{today}</span>
      </header>

      {/* GLOBAL SEARCH */}
      <div className="global-search">
        <label>Global Search:</label>
        <div className="search-field-wrap">
          <input
            className="search-input"
            placeholder="Employee ID (e.g. EMP1001)"
            value={searchEmpId}
            onChange={e => setSearchEmpId(e.target.value)}
            onKeyDown={e => e.key === "Enter" && handleGlobalSearch()}
          />
        </div>
        <div className="search-field-wrap">
          <input
            className="search-input"
            placeholder="Associate Name"
            value={searchName}
            onChange={e => setSearchName(e.target.value)}
            onKeyDown={e => e.key === "Enter" && handleGlobalSearch()}
          />
        </div>
        <button className="btn btn-primary" onClick={handleGlobalSearch}>🔍 Search / Go</button>
        <button className="btn btn-secondary" onClick={handleGlobalReset}>✕ Clear</button>
        {(globalEmpId || globalName) && (
          <span style={{ fontSize: 12, color: "var(--accent)", fontWeight: 500 }}>
            Filtered: {[globalEmpId, globalName].filter(Boolean).join(" | ")}
          </span>
        )}
      </div>

      {/* TABS */}
      <nav className="tab-bar">
        {TABS.map(t => (
          <div key={t.id} className={`tab-item ${activeTab === t.id ? "active" : ""}`} onClick={() => setActiveTab(t.id)}>
            <span className="tab-icon">{t.icon}</span>
            {t.label}
          </div>
        ))}
      </nav>

      {/* CONTENT */}
      <main className="content">
        {activeTab === "summary" && <SummaryTab />}
        {activeTab === "learning" && <LearningTab globalEmpId={globalEmpId} globalName={globalName} />}
        {activeTab === "certification" && <CertificationTab globalEmpId={globalEmpId} globalName={globalName} />}
        {activeTab === "projects" && <ProjectTab globalEmpId={globalEmpId} globalName={globalName} />}
      </main>
    </div>
  );
}
