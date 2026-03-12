package com.talentportal.controller;

import com.talentportal.dto.*;
import com.talentportal.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * CONTROLLERS — The Public Face of the API
 * ─────────────────────────────────────────
 * Controllers receive HTTP requests, extract parameters,
 * call the appropriate Service, and return HTTP responses.
 *
 * RULES FOR CONTROLLERS:
 *   ✅ Route incoming requests to the right service method
 *   ✅ Extract and validate request parameters (@RequestParam, @PathVariable)
 *   ✅ Set the HTTP status code (200 OK, 404 Not Found, etc.)
 *   ❌ NO business logic (that lives in Services)
 *   ❌ NO database queries (that lives in Repositories)
 *
 * KEY ANNOTATIONS:
 * ─────────────────
 * @RestController  = @Controller + @ResponseBody
 *   Every method returns JSON automatically (no need to write JSON manually).
 *
 * @RequestMapping("/api/associates")
 *   Sets the base URL for all methods in this class.
 *   Every method path is relative to this base.
 *
 * @CrossOrigin(...)
 *   Tells the browser: "requests from these origins are allowed".
 *   Without this, React on localhost:3000 calling localhost:8080 would be
 *   blocked by the browser's Same-Origin Policy (CORS error).
 *   In production this is replaced by CorsConfig.java which covers all controllers.
 *
 * ResponseEntity<T>
 *   A wrapper that lets you control both the response BODY and the HTTP STATUS.
 *   ResponseEntity.ok(data)             → 200 OK with data as body
 *   ResponseEntity.notFound().build()   → 404 Not Found with empty body
 */

// ─────────────────────────────────────────────────────────────
//  ASSOCIATE CONTROLLER
// ─────────────────────────────────────────────────────────────
@RestController
@RequestMapping("/api/associates")
@RequiredArgsConstructor
public class AssociateController {

    private final AssociateService service;

    /**
     * GET /api/associates              → all 50 associates
     * GET /api/associates?empId=EMP1   → filter by EmpID (partial match)
     * GET /api/associates?name=Priya  → filter by name  (partial match)
     *
     * @RequestParam(required = false) means the parameter is optional.
     * If the caller doesn't include ?empId=... then empId = null.
     */
    @GetMapping
    public ResponseEntity<List<AssociateDTO>> getAll(
            @RequestParam(required = false) String empId,
            @RequestParam(required = false) String name) {
        return ResponseEntity.ok(service.search(empId, name));
    }

    /**
     * GET /api/associates/EMP1001 → one associate by exact EmpID
     *
     * @PathVariable reads the {empId} segment from the URL path.
     * service.findByEmpId returns Optional<AssociateDTO>.
     * .map(ResponseEntity::ok) converts it to 200 OK if present.
     * .orElse(ResponseEntity.notFound().build()) returns 404 if not found.
     */
    @GetMapping("/{empId}")
    public ResponseEntity<AssociateDTO> getOne(@PathVariable String empId) {
        return service.findByEmpId(empId)
                      .map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }
}


// ─────────────────────────────────────────────────────────────
//  SKILL CONTROLLER
// ─────────────────────────────────────────────────────────────
@RestController
@RequestMapping("/api/skills")
@RequiredArgsConstructor
class SkillController {

    private final SkillService service;

    /**
     * GET /api/skills
     * Returns aggregated skill summaries: average level, distribution, level3+ count.
     * Used by the Summary tab's grouped bar chart and level-3+ bar chart.
     */
    @GetMapping
    public ResponseEntity<List<SkillSummaryDTO>> getAll() {
        return ResponseEntity.ok(service.getSummaries());
    }
}


// ─────────────────────────────────────────────────────────────
//  CERTIFICATION CONTROLLER
// ─────────────────────────────────────────────────────────────
@RestController
@RequestMapping("/api/certifications")
@RequiredArgsConstructor
class CertificationController {

    private final CertificationService service;

    /**
     * GET /api/certifications
     * Returns all certifications with holder counts and empId lists.
     * Used by the Certification tab summary panel + bar chart.
     */
    @GetMapping
    public ResponseEntity<List<CertificationDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }
}


// ─────────────────────────────────────────────────────────────
//  PROJECT CONTROLLER
// ─────────────────────────────────────────────────────────────
@RestController
@RequestMapping("/api/projects")
@RequiredArgsConstructor
class ProjectController {

    private final ProjectService service;

    /**
     * GET /api/projects
     * Returns project-level summaries (code, name, active/closed counts).
     * Used by the Project tab donut chart and role bar chart.
     */
    @GetMapping
    public ResponseEntity<List<ProjectDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    /**
     * GET /api/projects/assignments
     * GET /api/projects/assignments?projectCode=PRJ001
     * GET /api/projects/assignments?name=Priya
     * Returns the flat assignment table. Used by the Project tab table.
     */
    @GetMapping("/assignments")
    public ResponseEntity<List<AssignmentRowDTO>> getAssignments(
            @RequestParam(required = false) String projectCode,
            @RequestParam(required = false) String name) {
        return ResponseEntity.ok(service.getAssignments(projectCode, name));
    }
}


// ─────────────────────────────────────────────────────────────
//  DASHBOARD CONTROLLER
// ─────────────────────────────────────────────────────────────
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
class DashboardController {

    private final DashboardService service;

    /**
     * GET /api/dashboard/summary
     * Returns the 7 KPI numbers for the Summary tab's card row.
     */
    @GetMapping("/summary")
    public ResponseEntity<DashboardSummaryDTO> getSummary() {
        return ResponseEntity.ok(service.getSummary());
    }
}
