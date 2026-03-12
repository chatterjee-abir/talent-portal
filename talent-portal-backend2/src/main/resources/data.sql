-- ══════════════════════════════════════════════════════════════
--  TALENT PORTAL — Seed Data
--  File: src/main/resources/data.sql
--
--  Spring Boot runs this automatically on startup when:
--    spring.sql.init.mode=always
--  It is IDEMPOTENT: INSERT IGNORE means re-running it is safe.
-- ══════════════════════════════════════════════════════════════

USE talent_portal;

-- ── CERTIFICATIONS (10 rows — master lookup) ──────────────────
INSERT IGNORE INTO certifications (name) VALUES
    ('AWS Solutions Architect'),
    ('AWS Developer'),
    ('Azure Fundamentals'),
    ('Google Cloud Professional'),
    ('Kubernetes Administrator'),
    ('Terraform Associate'),
    ('Spring Professional'),
    ('Angular Developer'),
    ('Generative AI Fundamentals'),
    ('Certified Scrum Master');

-- ── PROJECTS (6 P&C Insurance projects) ──────────────────────
INSERT IGNORE INTO projects (project_code, project_name) VALUES
    ('PRJ001', 'Policy Admin System Modernisation'),
    ('PRJ002', 'Claims AI Automation'),
    ('PRJ003', 'Underwriting Risk Engine'),
    ('PRJ004', 'Customer Self-Service Portal'),
    ('PRJ005', 'Reinsurance Data Platform'),
    ('PRJ006', 'Fraud Detection & Analytics');

-- ── ASSOCIATES (50 rows) ──────────────────────────────────────
INSERT IGNORE INTO associates (emp_id, full_name, department, role) VALUES
    ('EMP1001', 'Aiden Chen',        'Engineering',   'Developer'),
    ('EMP1002', 'Priya Sharma',      'Engineering',   'Senior Developer'),
    ('EMP1003', 'Marcus Johnson',    'QA',            'QA Engineer'),
    ('EMP1004', 'Sofia Reyes',       'Engineering',   'Tech Lead'),
    ('EMP1005', 'James Okafor',      'DevOps',        'DevOps Engineer'),
    ('EMP1006', 'Lin Wei',           'Engineering',   'Developer'),
    ('EMP1007', 'Amara Osei',        'Analytics',     'Business Analyst'),
    ('EMP1008', 'David Kim',         'Engineering',   'Senior Developer'),
    ('EMP1009', 'Nadia Petrov',      'QA',            'QA Engineer'),
    ('EMP1010', 'Carlos Mendez',     'Engineering',   'Architect'),
    ('EMP1011', 'Yuki Tanaka',       'Engineering',   'Developer'),
    ('EMP1012', 'Fatima Al-Hassan',  'Analytics',     'Business Analyst'),
    ('EMP1013', 'Ryan O''Brien',     'Engineering',   'Senior Developer'),
    ('EMP1014', 'Mei Liu',           'DevOps',        'DevOps Engineer'),
    ('EMP1015', 'Isaac Adeyemi',     'Engineering',   'Developer'),
    ('EMP1016', 'Sara Johansson',    'QA',            'QA Engineer'),
    ('EMP1017', 'Omar Farooq',       'Engineering',   'Tech Lead'),
    ('EMP1018', 'Anya Kapoor',       'Engineering',   'Developer'),
    ('EMP1019', 'Luca Romano',       'Analytics',     'Business Analyst'),
    ('EMP1020', 'Keiko Yamamoto',    'Engineering',   'Senior Developer'),
    ('EMP1021', 'Ben Adkins',        'Engineering',   'Developer'),
    ('EMP1022', 'Zara Ahmed',        'QA',            'QA Engineer'),
    ('EMP1023', 'Felix Wagner',      'Engineering',   'Architect'),
    ('EMP1024', 'Grace Obi',         'Engineering',   'Developer'),
    ('EMP1025', 'Sam Torres',        'DevOps',        'DevOps Engineer'),
    ('EMP1026', 'Hana Park',         'Engineering',   'Senior Developer'),
    ('EMP1027', 'Tariq Malik',       'Analytics',     'Business Analyst'),
    ('EMP1028', 'Elena Volkov',      'Engineering',   'Developer'),
    ('EMP1029', 'Josh Williams',     'QA',            'QA Engineer'),
    ('EMP1030', 'Chioma Nwosu',      'Engineering',   'Tech Lead'),
    ('EMP1031', 'Alex Rivera',       'Engineering',   'Developer'),
    ('EMP1032', 'Soo-Jin Lee',       'Engineering',   'Senior Developer'),
    ('EMP1033', 'Mikhail Orlov',     'DevOps',        'DevOps Engineer'),
    ('EMP1034', 'Fatou Diallo',      'QA',            'QA Engineer'),
    ('EMP1035', 'Noah Brennan',      'Engineering',   'Developer'),
    ('EMP1036', 'Kavya Reddy',       'Analytics',     'Business Analyst'),
    ('EMP1037', 'Dante Ferreira',    'Engineering',   'Senior Developer'),
    ('EMP1038', 'Ingrid Holm',       'Engineering',   'Architect'),
    ('EMP1039', 'Jerome Dupont',     'Engineering',   'Developer'),
    ('EMP1040', 'Aisha Bello',       'QA',            'QA Engineer'),
    ('EMP1041', 'Ravi Nair',         'Engineering',   'Tech Lead'),
    ('EMP1042', 'Mia Schulz',        'Engineering',   'Developer'),
    ('EMP1043', 'Daniel Okonkwo',    'Analytics',     'Business Analyst'),
    ('EMP1044', 'Leila Ahmadi',      'Engineering',   'Senior Developer'),
    ('EMP1045', 'Tom Nguyen',        'DevOps',        'DevOps Engineer'),
    ('EMP1046', 'Bianca Costa',      'Engineering',   'Developer'),
    ('EMP1047', 'Kwame Asante',      'QA',            'QA Engineer'),
    ('EMP1048', 'Yuna Kim',          'Engineering',   'Senior Developer'),
    ('EMP1049', 'Patrick Dube',      'Engineering',   'Developer'),
    ('EMP1050', 'Diana Nelson',      'Analytics',     'Business Analyst');

-- ── SKILLS (5 skills × 50 associates = 250 rows) ─────────────
-- Using a helper pattern: for each associate insert all 5 skills in one block.
-- current_level and previous_level vary per person for realistic chart data.

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1001' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1001' UNION ALL
SELECT id, 'Java SpringBoot', 4, 3 FROM associates WHERE emp_id = 'EMP1001' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1001' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1001';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1002' UNION ALL
SELECT id, 'Angular',         5, 5 FROM associates WHERE emp_id = 'EMP1002' UNION ALL
SELECT id, 'Java SpringBoot', 5, 4 FROM associates WHERE emp_id = 'EMP1002' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1002' UNION ALL
SELECT id, 'AWS',             3, 2 FROM associates WHERE emp_id = 'EMP1002';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1003' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1003' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1003' UNION ALL
SELECT id, 'Domain',          4, 3 FROM associates WHERE emp_id = 'EMP1003' UNION ALL
SELECT id, 'AWS',             2, 1 FROM associates WHERE emp_id = 'EMP1003';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1004' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1004' UNION ALL
SELECT id, 'Java SpringBoot', 5, 5 FROM associates WHERE emp_id = 'EMP1004' UNION ALL
SELECT id, 'Domain',          5, 4 FROM associates WHERE emp_id = 'EMP1004' UNION ALL
SELECT id, 'AWS',             4, 3 FROM associates WHERE emp_id = 'EMP1004';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1005' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1005' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1005' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1005' UNION ALL
SELECT id, 'AWS',             5, 4 FROM associates WHERE emp_id = 'EMP1005';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 1 FROM associates WHERE emp_id = 'EMP1006' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1006' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1006' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1006' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1006';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1007' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1007' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1007' UNION ALL
SELECT id, 'Domain',          5, 4 FROM associates WHERE emp_id = 'EMP1007' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1007';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 4 FROM associates WHERE emp_id = 'EMP1008' UNION ALL
SELECT id, 'Angular',         4, 3 FROM associates WHERE emp_id = 'EMP1008' UNION ALL
SELECT id, 'Java SpringBoot', 5, 5 FROM associates WHERE emp_id = 'EMP1008' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1008' UNION ALL
SELECT id, 'AWS',             4, 4 FROM associates WHERE emp_id = 'EMP1008';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1009' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1009' UNION ALL
SELECT id, 'Java SpringBoot', 2, 1 FROM associates WHERE emp_id = 'EMP1009' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1009' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1009';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          5, 4 FROM associates WHERE emp_id = 'EMP1010' UNION ALL
SELECT id, 'Angular',         5, 5 FROM associates WHERE emp_id = 'EMP1010' UNION ALL
SELECT id, 'Java SpringBoot', 5, 5 FROM associates WHERE emp_id = 'EMP1010' UNION ALL
SELECT id, 'Domain',          5, 5 FROM associates WHERE emp_id = 'EMP1010' UNION ALL
SELECT id, 'AWS',             5, 4 FROM associates WHERE emp_id = 'EMP1010';

-- EMP1011 - EMP1020
INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1011' UNION ALL
SELECT id, 'Angular',         3, 2 FROM associates WHERE emp_id = 'EMP1011' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1011' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1011' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1011';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1012' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1012' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1012' UNION ALL
SELECT id, 'Domain',          5, 4 FROM associates WHERE emp_id = 'EMP1012' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1012';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1013' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1013' UNION ALL
SELECT id, 'Java SpringBoot', 4, 3 FROM associates WHERE emp_id = 'EMP1013' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1013' UNION ALL
SELECT id, 'AWS',             3, 2 FROM associates WHERE emp_id = 'EMP1013';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1014' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1014' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1014' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1014' UNION ALL
SELECT id, 'AWS',             4, 4 FROM associates WHERE emp_id = 'EMP1014';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 1 FROM associates WHERE emp_id = 'EMP1015' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1015' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1015' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1015' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1015';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1016' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1016' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1016' UNION ALL
SELECT id, 'Domain',          3, 2 FROM associates WHERE emp_id = 'EMP1016' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1016';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1017' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1017' UNION ALL
SELECT id, 'Java SpringBoot', 4, 4 FROM associates WHERE emp_id = 'EMP1017' UNION ALL
SELECT id, 'Domain',          4, 3 FROM associates WHERE emp_id = 'EMP1017' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1017';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1018' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1018' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1018' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1018' UNION ALL
SELECT id, 'AWS',             2, 1 FROM associates WHERE emp_id = 'EMP1018';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1019' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1019' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1019' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1019' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1019';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 4 FROM associates WHERE emp_id = 'EMP1020' UNION ALL
SELECT id, 'Angular',         4, 3 FROM associates WHERE emp_id = 'EMP1020' UNION ALL
SELECT id, 'Java SpringBoot', 4, 4 FROM associates WHERE emp_id = 'EMP1020' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1020' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1020';

-- EMP1021 - EMP1030
INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1021' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1021' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1021' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1021' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1021';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1022' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1022' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1022' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1022' UNION ALL
SELECT id, 'AWS',             2, 1 FROM associates WHERE emp_id = 'EMP1022';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          5, 4 FROM associates WHERE emp_id = 'EMP1023' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1023' UNION ALL
SELECT id, 'Java SpringBoot', 5, 5 FROM associates WHERE emp_id = 'EMP1023' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1023' UNION ALL
SELECT id, 'AWS',             4, 4 FROM associates WHERE emp_id = 'EMP1023';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1024' UNION ALL
SELECT id, 'Angular',         3, 2 FROM associates WHERE emp_id = 'EMP1024' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1024' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1024' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1024';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1025' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1025' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1025' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1025' UNION ALL
SELECT id, 'AWS',             4, 3 FROM associates WHERE emp_id = 'EMP1025';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1026' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1026' UNION ALL
SELECT id, 'Java SpringBoot', 4, 3 FROM associates WHERE emp_id = 'EMP1026' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1026' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1026';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1027' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1027' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1027' UNION ALL
SELECT id, 'Domain',          5, 5 FROM associates WHERE emp_id = 'EMP1027' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1027';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1028' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1028' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1028' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1028' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1028';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1029' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1029' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1029' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1029' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1029';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1030' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1030' UNION ALL
SELECT id, 'Java SpringBoot', 4, 4 FROM associates WHERE emp_id = 'EMP1030' UNION ALL
SELECT id, 'Domain',          4, 3 FROM associates WHERE emp_id = 'EMP1030' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1030';

-- EMP1031 - EMP1050 (abbreviated pattern for remaining 20)
INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1031' UNION ALL
SELECT id, 'Angular',         3, 2 FROM associates WHERE emp_id = 'EMP1031' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1031' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1031' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1031';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 4 FROM associates WHERE emp_id = 'EMP1032' UNION ALL
SELECT id, 'Angular',         4, 3 FROM associates WHERE emp_id = 'EMP1032' UNION ALL
SELECT id, 'Java SpringBoot', 5, 4 FROM associates WHERE emp_id = 'EMP1032' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1032' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1032';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 2 FROM associates WHERE emp_id = 'EMP1033' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1033' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1033' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1033' UNION ALL
SELECT id, 'AWS',             4, 4 FROM associates WHERE emp_id = 'EMP1033';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 1 FROM associates WHERE emp_id = 'EMP1034' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1034' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1034' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1034' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1034';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1035' UNION ALL
SELECT id, 'Angular',         3, 2 FROM associates WHERE emp_id = 'EMP1035' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1035' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1035' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1035';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1036' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1036' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1036' UNION ALL
SELECT id, 'Domain',          5, 5 FROM associates WHERE emp_id = 'EMP1036' UNION ALL
SELECT id, 'AWS',             3, 2 FROM associates WHERE emp_id = 'EMP1036';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1037' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1037' UNION ALL
SELECT id, 'Java SpringBoot', 4, 4 FROM associates WHERE emp_id = 'EMP1037' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1037' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1037';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          5, 5 FROM associates WHERE emp_id = 'EMP1038' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1038' UNION ALL
SELECT id, 'Java SpringBoot', 5, 5 FROM associates WHERE emp_id = 'EMP1038' UNION ALL
SELECT id, 'Domain',          5, 4 FROM associates WHERE emp_id = 'EMP1038' UNION ALL
SELECT id, 'AWS',             4, 4 FROM associates WHERE emp_id = 'EMP1038';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1039' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1039' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1039' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1039' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1039';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1040' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1040' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1040' UNION ALL
SELECT id, 'Domain',          3, 2 FROM associates WHERE emp_id = 'EMP1040' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1040';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1041' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1041' UNION ALL
SELECT id, 'Java SpringBoot', 4, 4 FROM associates WHERE emp_id = 'EMP1041' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1041' UNION ALL
SELECT id, 'AWS',             3, 3 FROM associates WHERE emp_id = 'EMP1041';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1042' UNION ALL
SELECT id, 'Angular',         3, 2 FROM associates WHERE emp_id = 'EMP1042' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1042' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1042' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1042';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1043' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1043' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1043' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1043' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1043';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1044' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1044' UNION ALL
SELECT id, 'Java SpringBoot', 4, 3 FROM associates WHERE emp_id = 'EMP1044' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1044' UNION ALL
SELECT id, 'AWS',             3, 2 FROM associates WHERE emp_id = 'EMP1044';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1045' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1045' UNION ALL
SELECT id, 'Java SpringBoot', 3, 3 FROM associates WHERE emp_id = 'EMP1045' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1045' UNION ALL
SELECT id, 'AWS',             5, 4 FROM associates WHERE emp_id = 'EMP1045';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1046' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1046' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1046' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1046' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1046';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 1 FROM associates WHERE emp_id = 'EMP1047' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1047' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1047' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1047' UNION ALL
SELECT id, 'AWS',             1, 1 FROM associates WHERE emp_id = 'EMP1047';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          4, 3 FROM associates WHERE emp_id = 'EMP1048' UNION ALL
SELECT id, 'Angular',         4, 4 FROM associates WHERE emp_id = 'EMP1048' UNION ALL
SELECT id, 'Java SpringBoot', 5, 4 FROM associates WHERE emp_id = 'EMP1048' UNION ALL
SELECT id, 'Domain',          3, 3 FROM associates WHERE emp_id = 'EMP1048' UNION ALL
SELECT id, 'AWS',             4, 3 FROM associates WHERE emp_id = 'EMP1048';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          2, 2 FROM associates WHERE emp_id = 'EMP1049' UNION ALL
SELECT id, 'Angular',         3, 3 FROM associates WHERE emp_id = 'EMP1049' UNION ALL
SELECT id, 'Java SpringBoot', 3, 2 FROM associates WHERE emp_id = 'EMP1049' UNION ALL
SELECT id, 'Domain',          2, 2 FROM associates WHERE emp_id = 'EMP1049' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1049';

INSERT IGNORE INTO skills (associate_id, skill_name, current_level, previous_level)
SELECT id, 'Gen AI',          3, 3 FROM associates WHERE emp_id = 'EMP1050' UNION ALL
SELECT id, 'Angular',         2, 2 FROM associates WHERE emp_id = 'EMP1050' UNION ALL
SELECT id, 'Java SpringBoot', 2, 2 FROM associates WHERE emp_id = 'EMP1050' UNION ALL
SELECT id, 'Domain',          4, 4 FROM associates WHERE emp_id = 'EMP1050' UNION ALL
SELECT id, 'AWS',             2, 2 FROM associates WHERE emp_id = 'EMP1050';

-- ── ASSOCIATE CERTIFICATIONS (realistic distribution) ─────────
-- Approx 60% of associates hold at least one cert
INSERT IGNORE INTO associate_certifications (associate_id, certification_id, earned_date)
SELECT a.id, c.id, '2024-03-15' FROM associates a, certifications c WHERE a.emp_id='EMP1002' AND c.name='AWS Solutions Architect' UNION ALL
SELECT a.id, c.id, '2024-06-20' FROM associates a, certifications c WHERE a.emp_id='EMP1002' AND c.name='Spring Professional' UNION ALL
SELECT a.id, c.id, '2023-11-10' FROM associates a, certifications c WHERE a.emp_id='EMP1004' AND c.name='AWS Solutions Architect' UNION ALL
SELECT a.id, c.id, '2024-01-15' FROM associates a, certifications c WHERE a.emp_id='EMP1004' AND c.name='Kubernetes Administrator' UNION ALL
SELECT a.id, c.id, '2023-09-05' FROM associates a, certifications c WHERE a.emp_id='EMP1005' AND c.name='AWS Developer' UNION ALL
SELECT a.id, c.id, '2024-02-28' FROM associates a, certifications c WHERE a.emp_id='EMP1005' AND c.name='Terraform Associate' UNION ALL
SELECT a.id, c.id, '2024-05-10' FROM associates a, certifications c WHERE a.emp_id='EMP1008' AND c.name='Spring Professional' UNION ALL
SELECT a.id, c.id, '2024-07-22' FROM associates a, certifications c WHERE a.emp_id='EMP1008' AND c.name='AWS Developer' UNION ALL
SELECT a.id, c.id, '2023-12-01' FROM associates a, certifications c WHERE a.emp_id='EMP1010' AND c.name='AWS Solutions Architect' UNION ALL
SELECT a.id, c.id, '2024-01-20' FROM associates a, certifications c WHERE a.emp_id='EMP1010' AND c.name='Kubernetes Administrator' UNION ALL
SELECT a.id, c.id, '2024-03-30' FROM associates a, certifications c WHERE a.emp_id='EMP1010' AND c.name='Generative AI Fundamentals' UNION ALL
SELECT a.id, c.id, '2024-04-15' FROM associates a, certifications c WHERE a.emp_id='EMP1013' AND c.name='Angular Developer' UNION ALL
SELECT a.id, c.id, '2024-08-01' FROM associates a, certifications c WHERE a.emp_id='EMP1014' AND c.name='Terraform Associate' UNION ALL
SELECT a.id, c.id, '2023-10-10' FROM associates a, certifications c WHERE a.emp_id='EMP1017' AND c.name='Certified Scrum Master' UNION ALL
SELECT a.id, c.id, '2024-06-05' FROM associates a, certifications c WHERE a.emp_id='EMP1020' AND c.name='Angular Developer' UNION ALL
SELECT a.id, c.id, '2024-02-14' FROM associates a, certifications c WHERE a.emp_id='EMP1020' AND c.name='Spring Professional' UNION ALL
SELECT a.id, c.id, '2024-09-01' FROM associates a, certifications c WHERE a.emp_id='EMP1023' AND c.name='Google Cloud Professional' UNION ALL
SELECT a.id, c.id, '2024-05-20' FROM associates a, certifications c WHERE a.emp_id='EMP1023' AND c.name='Kubernetes Administrator' UNION ALL
SELECT a.id, c.id, '2024-07-10' FROM associates a, certifications c WHERE a.emp_id='EMP1025' AND c.name='AWS Developer' UNION ALL
SELECT a.id, c.id, '2024-03-01' FROM associates a, certifications c WHERE a.emp_id='EMP1026' AND c.name='Spring Professional' UNION ALL
SELECT a.id, c.id, '2024-08-15' FROM associates a, certifications c WHERE a.emp_id='EMP1030' AND c.name='Certified Scrum Master' UNION ALL
SELECT a.id, c.id, '2024-01-05' FROM associates a, certifications c WHERE a.emp_id='EMP1032' AND c.name='AWS Solutions Architect' UNION ALL
SELECT a.id, c.id, '2024-06-30' FROM associates a, certifications c WHERE a.emp_id='EMP1037' AND c.name='Angular Developer' UNION ALL
SELECT a.id, c.id, '2024-04-22' FROM associates a, certifications c WHERE a.emp_id='EMP1038' AND c.name='Generative AI Fundamentals' UNION ALL
SELECT a.id, c.id, '2024-09-10' FROM associates a, certifications c WHERE a.emp_id='EMP1038' AND c.name='AWS Solutions Architect' UNION ALL
SELECT a.id, c.id, '2024-02-05' FROM associates a, certifications c WHERE a.emp_id='EMP1041' AND c.name='Certified Scrum Master' UNION ALL
SELECT a.id, c.id, '2024-07-01' FROM associates a, certifications c WHERE a.emp_id='EMP1044' AND c.name='Spring Professional' UNION ALL
SELECT a.id, c.id, '2024-05-05' FROM associates a, certifications c WHERE a.emp_id='EMP1045' AND c.name='Terraform Associate' UNION ALL
SELECT a.id, c.id, '2024-08-20' FROM associates a, certifications c WHERE a.emp_id='EMP1048' AND c.name='Azure Fundamentals';

-- ── PROJECT ASSIGNMENTS ───────────────────────────────────────
-- ~70% Active (end_date 2026-12-31), ~30% Closed (past end dates)
INSERT IGNORE INTO project_assignments (project_id, associate_id, role, start_date, end_date)
SELECT p.id, a.id, 'Developer',       '2024-01-15', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1001' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2024-01-15', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1002' UNION ALL
SELECT p.id, a.id, 'Tech Lead',       '2024-01-15', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1004' UNION ALL
SELECT p.id, a.id, 'QA Engineer',     '2024-01-15', '2025-06-30' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1003' UNION ALL
SELECT p.id, a.id, 'Business Analyst','2024-01-15', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1007' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-01-15', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1011' UNION ALL
SELECT p.id, a.id, 'DevOps Engineer', '2024-01-15', '2025-09-30' FROM projects p, associates a WHERE p.project_code='PRJ001' AND a.emp_id='EMP1005' UNION ALL

SELECT p.id, a.id, 'Architect',       '2024-03-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1010' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2024-03-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1008' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-03-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1015' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-03-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1018' UNION ALL
SELECT p.id, a.id, 'QA Engineer',     '2024-03-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1016' UNION ALL
SELECT p.id, a.id, 'Business Analyst','2024-03-01', '2025-12-31' FROM projects p, associates a WHERE p.project_code='PRJ002' AND a.emp_id='EMP1012' UNION ALL

SELECT p.id, a.id, 'Tech Lead',       '2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1017' UNION ALL
SELECT p.id, a.id, 'Architect',       '2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1023' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1020' UNION ALL
SELECT p.id, a.id, 'Developer',       '2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1021' UNION ALL
SELECT p.id, a.id, 'Developer',       '2023-09-01', '2025-03-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1024' UNION ALL
SELECT p.id, a.id, 'QA Engineer',     '2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1022' UNION ALL
SELECT p.id, a.id, 'DevOps Engineer', '2023-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ003' AND a.emp_id='EMP1025' UNION ALL

SELECT p.id, a.id, 'Tech Lead',       '2024-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1030' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2024-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1026' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1028' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1031' UNION ALL
SELECT p.id, a.id, 'Business Analyst','2024-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1027' UNION ALL
SELECT p.id, a.id, 'QA Engineer',     '2024-06-01', '2025-11-30' FROM projects p, associates a WHERE p.project_code='PRJ004' AND a.emp_id='EMP1029' UNION ALL

SELECT p.id, a.id, 'Architect',       '2023-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ005' AND a.emp_id='EMP1038' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2023-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ005' AND a.emp_id='EMP1032' UNION ALL
SELECT p.id, a.id, 'Developer',       '2023-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ005' AND a.emp_id='EMP1035' UNION ALL
SELECT p.id, a.id, 'DevOps Engineer', '2023-06-01', '2025-06-30' FROM projects p, associates a WHERE p.project_code='PRJ005' AND a.emp_id='EMP1033' UNION ALL
SELECT p.id, a.id, 'Business Analyst','2023-06-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ005' AND a.emp_id='EMP1036' UNION ALL

SELECT p.id, a.id, 'Tech Lead',       '2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1041' UNION ALL
SELECT p.id, a.id, 'Senior Developer','2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1044' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1046' UNION ALL
SELECT p.id, a.id, 'Developer',       '2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1049' UNION ALL
SELECT p.id, a.id, 'QA Engineer',     '2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1047' UNION ALL
SELECT p.id, a.id, 'Business Analyst','2024-09-01', '2026-12-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1043' UNION ALL
SELECT p.id, a.id, 'DevOps Engineer', '2024-09-01', '2025-08-31' FROM projects p, associates a WHERE p.project_code='PRJ006' AND a.emp_id='EMP1045';
