package com.talentportal.dto;

import lombok.Data;
import java.util.List;
import java.util.Map;

/**
 * DTO = Data Transfer Object
 *
 * WHY DTOs INSTEAD OF SENDING ENTITIES DIRECTLY?
 * ────────────────────────────────────────────────
 * If you serialised the Associate entity directly to JSON:
 *   1. Lazy-loaded collections (skills, certifications) would cause
 *      LazyInitializationException or N+1 query problems.
 *   2. Bidirectional relationships (Associate → Skill → Associate)
 *      cause infinite recursion in JSON serialisation.
 *   3. You expose internal database IDs and implementation details.
 *   4. Adding a sensitive database column automatically exposes it in the API.
 *
 * DTOs solve all four problems — you control exactly what shape the API returns.
 *
 * All DTOs live in this file for simplicity. In a larger project each
 * DTO would be in its own file.
 */

/** Returned by GET /api/associates */
@Data
public class AssociateDTO {
    private String empId;
    private String fullName;
    private String department;
    private String role;
    private List<SkillDTO> skills;
    private List<String> certifications;
}

/** Embedded in AssociateDTO — one per skill */
@Data
public class SkillDTO {
    private String skillName;
    private int currentLevel;
    private int previousLevel;
    private int delta;          // currentLevel - previousLevel (calculated in service)
}

/** Returned by GET /api/certifications */
@Data
public class CertificationDTO {
    private String name;
    private int holderCount;        // how many associates hold this cert
    private List<String> holders;   // list of empIds who hold it
}

/** Returned by GET /api/projects */
@Data
public class ProjectDTO {
    private String projectCode;
    private String projectName;
    private int totalAssigned;
    private int activeCount;
    private int closedCount;
}

/** Returned by GET /api/projects/assignments — one row per assignment */
@Data
public class AssignmentRowDTO {
    private String projectCode;
    private String projectName;
    private String empId;
    private String fullName;
    private String role;
    private String startDate;
    private String endDate;
    private String status;   // "Active" or "Closed"
}

/**
 * Returned by GET /api/skills — aggregated stats per skill.
 * Used by the Summary tab bar chart and level-3+ chart.
 */
@Data
public class SkillSummaryDTO {
    private String skillName;
    private double averageLevel;
    private Map<Integer, Long> levelDistribution;  // {1: 12, 2: 18, 3: 11, 4: 7, 5: 2}
    private long level3PlusCount;                  // associates at level 3 or above
}

/**
 * Returned by GET /api/dashboard/summary — the 5 KPI cards on the Summary tab.
 */
@Data
public class DashboardSummaryDTO {
    private int totalAssociates;
    private int activeProjects;
    private int totalCertifications;
    private int level3PlusSkills;      // count of associate-skill combos at level >= 3
    private int avgSkillLevel;         // rounded average across all skills
    private int skillsImproved;        // count of skills where current > previous
    private int certifiedAssociates;   // count of associates with at least one cert
}
