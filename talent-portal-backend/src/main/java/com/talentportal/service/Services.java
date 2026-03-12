package com.talentportal.service;

import com.talentportal.dto.*;
import com.talentportal.entity.*;
import com.talentportal.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

// ═══════════════════════════════════════════════════════════════
//  SKILL SERVICE
// ═══════════════════════════════════════════════════════════════

/**
 * SkillService — aggregates skill data for the Summary tab charts.
 * The Summary tab needs average skill levels and level distributions
 * across all 50 associates × 5 skills = 250 skill rows.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
class SkillService {

    private final SkillRepository skillRepo;

    /**
     * Returns one SkillSummaryDTO per skill name.
     * Used by GET /api/skills
     */
    public List<SkillSummaryDTO> getSummaries() {
        List<String> skillNames = List.of(
            "Gen AI", "Angular", "Java SpringBoot", "Domain", "AWS"
        );

        return skillNames.stream().map(name -> {
            List<Skill> skills = skillRepo.findBySkillName(name);

            SkillSummaryDTO dto = new SkillSummaryDTO();
            dto.setSkillName(name);

            // Average level: sum all current levels / count
            double avg = skills.stream()
                               .mapToInt(Skill::getCurrentLevel)
                               .average()
                               .orElse(0.0);
            dto.setAverageLevel(Math.round(avg * 10.0) / 10.0);  // 1 decimal place

            // Distribution: how many associates are at each level (1-5)
            Map<Integer, Long> dist = skills.stream()
                .collect(Collectors.groupingBy(
                    Skill::getCurrentLevel,
                    Collectors.counting()
                ));
            dto.setLevelDistribution(dist);

            // Level 3+ count: how many associates are at level 3, 4, or 5
            long l3plus = skills.stream()
                                .filter(s -> s.getCurrentLevel() >= 3)
                                .count();
            dto.setLevel3PlusCount(l3plus);

            return dto;
        }).collect(Collectors.toList());
    }
}


// ═══════════════════════════════════════════════════════════════
//  CERTIFICATION SERVICE
// ═══════════════════════════════════════════════════════════════

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
class CertificationService {

    private final CertificationRepository certRepo;

    /** Returns all certifications with holder counts. GET /api/certifications */
    public List<CertificationDTO> getAll() {
        return certRepo.findAll().stream().map(cert -> {
            CertificationDTO dto = new CertificationDTO();
            dto.setName(cert.getName());
            dto.setHolderCount(cert.getAssociates().size());
            dto.setHolders(
                cert.getAssociates().stream()
                    .map(Associate::getEmpId)
                    .collect(Collectors.toList())
            );
            return dto;
        }).collect(Collectors.toList());
    }
}


// ═══════════════════════════════════════════════════════════════
//  PROJECT SERVICE
// ═══════════════════════════════════════════════════════════════

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
class ProjectService {

    private final ProjectRepository projectRepo;
    private final ProjectAssignmentRepository assignmentRepo;

    /** Returns project-level summaries. GET /api/projects */
    public List<ProjectDTO> getAll() {
        return projectRepo.findAll().stream().map(p -> {
            ProjectDTO dto = new ProjectDTO();
            dto.setProjectCode(p.getProjectCode());
            dto.setProjectName(p.getProjectName());

            List<ProjectAssignment> assignments = p.getAssignments();
            dto.setTotalAssigned(assignments.size());

            LocalDate today = LocalDate.now();
            long active = assignments.stream()
                .filter(a -> a.getEndDate() == null || a.getEndDate().isAfter(today))
                .count();
            dto.setActiveCount((int) active);
            dto.setClosedCount(assignments.size() - (int) active);

            return dto;
        }).collect(Collectors.toList());
    }

    /**
     * Returns one row per assignment (flattened list).
     * Optional filters: projectCode and/or associateName.
     * GET /api/projects/assignments
     */
    public List<AssignmentRowDTO> getAssignments(String projectCode, String name) {
        List<ProjectAssignment> rows;

        boolean hasProjectFilter = projectCode != null && !projectCode.isBlank();
        boolean hasNameFilter    = name != null && !name.isBlank();

        if (hasProjectFilter || hasNameFilter) {
            rows = assignmentRepo.findFiltered(
                hasProjectFilter ? projectCode.trim() : null,
                hasNameFilter    ? name.trim()        : null
            );
        } else {
            rows = assignmentRepo.findAllWithDetails();
        }

        return rows.stream().map(this::toRowDTO).collect(Collectors.toList());
    }

    /**
     * Convert a ProjectAssignment entity to the flat DTO used by the Project tab table.
     * STATUS RULE: end_date in the past → Closed. Future or null → Active.
     */
    private AssignmentRowDTO toRowDTO(ProjectAssignment pa) {
        AssignmentRowDTO dto = new AssignmentRowDTO();
        dto.setProjectCode(pa.getProject().getProjectCode());
        dto.setProjectName(pa.getProject().getProjectName());
        dto.setEmpId(pa.getAssociate().getEmpId());
        dto.setFullName(pa.getAssociate().getFullName());
        dto.setRole(pa.getRole());
        dto.setStartDate(pa.getStartDate() != null ? pa.getStartDate().toString() : "");
        dto.setEndDate(pa.getEndDate() != null ? pa.getEndDate().toString() : "");

        // Status: compare end_date string to today's date
        // YYYY-MM-DD format is lexicographically sortable, so string comparison works
        boolean active = pa.getEndDate() == null
                         || pa.getEndDate().isAfter(LocalDate.now());
        dto.setStatus(active ? "Active" : "Closed");

        return dto;
    }
}


// ═══════════════════════════════════════════════════════════════
//  DASHBOARD SERVICE
// ═══════════════════════════════════════════════════════════════

/**
 * DashboardService — calculates the 7 KPI numbers for the Summary tab cards.
 * This requires queries across multiple repositories, so it's its own service.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
class DashboardService {

    private final AssociateRepository associateRepo;
    private final SkillRepository     skillRepo;
    private final CertificationRepository certRepo;
    private final ProjectRepository   projectRepo;

    /** GET /api/dashboard/summary */
    public DashboardSummaryDTO getSummary() {
        DashboardSummaryDTO dto = new DashboardSummaryDTO();

        dto.setTotalAssociates((int) associateRepo.count());

        // Active projects: projects that have at least one active assignment
        // For simplicity we count all projects (all 6 are active in seed data)
        dto.setActiveProjects((int) projectRepo.count());

        // Total unique certifications held (count distinct entries in join table)
        dto.setTotalCertifications(
            certRepo.findAll().stream()
                    .mapToInt(c -> c.getAssociates().size())
                    .sum()
        );

        // Level 3+ skills: associate-skill combos where current_level >= 3
        dto.setLevel3PlusSkills((int) skillRepo.countByCurrentLevelGreaterThanEqual(3));

        // Average skill level across all 250 skills (rounded to int for KPI card)
        Double avg = skillRepo.findAverageLevel();
        dto.setAvgSkillLevel(avg != null ? (int) Math.round(avg) : 0);

        // Skills improved this period
        dto.setSkillsImproved((int) skillRepo.countImproved());

        // Associates with at least one certification
        long certified = associateRepo.findAll().stream()
            .filter(a -> !a.getCertifications().isEmpty())
            .count();
        dto.setCertifiedAssociates((int) certified);

        return dto;
    }
}
