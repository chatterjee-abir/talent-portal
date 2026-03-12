package com.talentportal.service;

import com.talentportal.dto.AssignmentRowDTO;
import com.talentportal.dto.ProjectDTO;
import com.talentportal.entity.ProjectAssignment;
import com.talentportal.repository.ProjectAssignmentRepository;
import com.talentportal.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProjectService {

    private final ProjectRepository projectRepo;
    private final ProjectAssignmentRepository assignmentRepo;

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

    private AssignmentRowDTO toRowDTO(ProjectAssignment pa) {
        AssignmentRowDTO dto = new AssignmentRowDTO();
        dto.setProjectCode(pa.getProject().getProjectCode());
        dto.setProjectName(pa.getProject().getProjectName());
        dto.setEmpId(pa.getAssociate().getEmpId());
        dto.setFullName(pa.getAssociate().getFullName());
        dto.setRole(pa.getRole());
        dto.setStartDate(pa.getStartDate() != null ? pa.getStartDate().toString() : "");
        dto.setEndDate(pa.getEndDate()   != null ? pa.getEndDate().toString()   : "");

        boolean active = pa.getEndDate() == null || pa.getEndDate().isAfter(LocalDate.now());
        dto.setStatus(active ? "Active" : "Closed");

        return dto;
    }
}
