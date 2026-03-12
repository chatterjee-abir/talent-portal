-- ══════════════════════════════════════════════════════════════
--  TALENT PORTAL — Database Schema
--  File: src/main/resources/schema.sql
--
--  Run this ONCE manually in MySQL Workbench or the mysql CLI
--  before starting the Spring Boot app for the first time.
--
--  Command:  mysql -u root -p < schema.sql
-- ══════════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS talent_portal
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE talent_portal;

-- ── ASSOCIATES ────────────────────────────────────────────────
-- Core entity: one row per team member.
-- emp_id is the business key (e.g. EMP1001) — human-readable and unique.
-- id is the surrogate primary key — used for all foreign key relationships.
CREATE TABLE IF NOT EXISTS associates (
    id          BIGINT       AUTO_INCREMENT PRIMARY KEY,
    emp_id      VARCHAR(20)  NOT NULL UNIQUE,   -- e.g. EMP1001
    full_name   VARCHAR(100) NOT NULL,
    department  VARCHAR(50)  NOT NULL,
    role        VARCHAR(60)  NOT NULL DEFAULT 'Developer',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── SKILLS ────────────────────────────────────────────────────
-- One row per (associate, skill) combination.
-- An associate with 5 skills has 5 rows in this table.
-- ON DELETE CASCADE: if an associate is deleted, their skills are deleted too.
CREATE TABLE IF NOT EXISTS skills (
    id              BIGINT      AUTO_INCREMENT PRIMARY KEY,
    associate_id    BIGINT      NOT NULL,
    skill_name      VARCHAR(60) NOT NULL,
    current_level   TINYINT     NOT NULL DEFAULT 1,   -- 1 to 5
    previous_level  TINYINT     NOT NULL DEFAULT 1,   -- last month's level
    CONSTRAINT fk_skills_associate
        FOREIGN KEY (associate_id) REFERENCES associates(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_associate_skill
        UNIQUE (associate_id, skill_name)   -- one row per associate+skill pair
);

-- ── CERTIFICATIONS ────────────────────────────────────────────
-- Lookup table: the master list of certifications the company tracks.
-- Only 10 rows — one per certification name.
CREATE TABLE IF NOT EXISTS certifications (
    id    BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(150) NOT NULL UNIQUE
);

-- ── ASSOCIATE_CERTIFICATIONS ──────────────────────────────────
-- Many-to-many join table: links associates to certifications they hold.
-- An associate holding 3 certs has 3 rows here.
-- Composite PK (associate_id + certification_id) prevents duplicate entries.
CREATE TABLE IF NOT EXISTS associate_certifications (
    associate_id     BIGINT NOT NULL,
    certification_id BIGINT NOT NULL,
    earned_date      DATE,
    PRIMARY KEY (associate_id, certification_id),
    CONSTRAINT fk_ac_associate
        FOREIGN KEY (associate_id) REFERENCES associates(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ac_certification
        FOREIGN KEY (certification_id) REFERENCES certifications(id)
        ON DELETE CASCADE
);

-- ── PROJECTS ──────────────────────────────────────────────────
-- Master list of P&C Insurance projects.
-- Only 6 rows — one per project.
CREATE TABLE IF NOT EXISTS projects (
    id           BIGINT       AUTO_INCREMENT PRIMARY KEY,
    project_code VARCHAR(20)  NOT NULL UNIQUE,   -- e.g. PRJ001
    project_name VARCHAR(200) NOT NULL
);

-- ── PROJECT_ASSIGNMENTS ───────────────────────────────────────
-- Many-to-many with extra columns: links associates to projects.
-- One associate can appear on multiple projects.
-- One project has many associates.
-- end_date determines Active vs Closed status:
--   future or NULL end_date → Active
--   past end_date           → Closed
CREATE TABLE IF NOT EXISTS project_assignments (
    id           BIGINT      AUTO_INCREMENT PRIMARY KEY,
    project_id   BIGINT      NOT NULL,
    associate_id BIGINT      NOT NULL,
    role         VARCHAR(60),
    start_date   DATE,
    end_date     DATE,
    CONSTRAINT fk_pa_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pa_associate
        FOREIGN KEY (associate_id) REFERENCES associates(id)
        ON DELETE CASCADE
);
