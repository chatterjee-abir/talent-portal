package com.talentportal.service;

import com.talentportal.dto.*;
import com.talentportal.entity.*;
import com.talentportal.repository.AssociateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * AssociateService — business logic for the associates domain.
 *
 * THE SERVICE LAYER'S JOB:
 * ────────────────────────
 * Controllers handle HTTP (routing, params, status codes).
 * Repositories handle SQL (database reads/writes).
 * Services handle BUSINESS LOGIC — the "rules" layer between them.
 *
 * Examples of business logic that belongs HERE (not in Controller or Repository):
 *   - "Only return associates whose department matches the caller's access level"
 *   - "Calculate skill delta (current - previous) before sending to the client"
 *   - "Convert entity to DTO so internal DB fields are never exposed"
 *
 * @Service marks this class as a Spring-managed component (bean).
 * Spring creates one instance at startup and injects it wherever needed.
 *
 * @RequiredArgsConstructor (Lombok) generates a constructor that injects
 * all final fields — this is constructor injection, the recommended style.
 *
 * @Transactional means the method runs inside a database transaction.
 * If any exception is thrown, all DB changes in that method are rolled back.
 * readOnly=true is an optimisation hint for read-only queries.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AssociateService {

    private final AssociateRepository associateRepo;

    /**
     * Search associates by empId or name, or return all if neither is provided.
     * Called by GET /api/associates?empId=...&name=...
     */
    public List<AssociateDTO> search(String empId, String name) {
        List<Associate> results;

        if (empId != null && !empId.isBlank()) {
            results = associateRepo.findByEmpIdContainingIgnoreCase(empId.trim());
        } else if (name != null && !name.isBlank()) {
            results = associateRepo.findByFullNameContainingIgnoreCase(name.trim());
        } else {
            results = associateRepo.findAll();
        }

        // .stream() — create a stream from the list
        // .map(this::toDTO) — convert each Associate entity to an AssociateDTO
        // .collect(Collectors.toList()) — collect the results back into a List
        return results.stream()
                      .map(this::toDTO)
                      .collect(Collectors.toList());
    }

    /** Get a single associate by EmpID. Called by GET /api/associates/{empId} */
    public Optional<AssociateDTO> findByEmpId(String empId) {
        return associateRepo.findByEmpId(empId).map(this::toDTO);
    }

    /**
     * toDTO — converts an Associate entity into an AssociateDTO.
     *
     * WHY THIS METHOD EXISTS:
     * The entity has @OneToMany and @ManyToMany collections. Serialising
     * the entity directly would cause Jackson (the JSON library) to follow
     * every relationship, potentially loading thousands of rows.
     * The DTO is a flat, safe snapshot of exactly what we want to send.
     *
     * This method is private — it's an implementation detail of this service.
     */
    private AssociateDTO toDTO(Associate a) {
        AssociateDTO dto = new AssociateDTO();
        dto.setEmpId(a.getEmpId());
        dto.setFullName(a.getFullName());
        dto.setDepartment(a.getDepartment());
        dto.setRole(a.getRole());

        // Map each Skill entity to a SkillDTO
        dto.setSkills(
            a.getSkills().stream().map(s -> {
                SkillDTO sd = new SkillDTO();
                sd.setSkillName(s.getSkillName());
                sd.setCurrentLevel(s.getCurrentLevel());
                sd.setPreviousLevel(s.getPreviousLevel());
                sd.setDelta(s.getCurrentLevel() - s.getPreviousLevel());  // business rule
                return sd;
            }).collect(Collectors.toList())
        );

        // Certifications: just send the name string, not the full Certification object
        dto.setCertifications(
            a.getCertifications().stream()
             .map(Certification::getName)
             .collect(Collectors.toList())
        );

        return dto;
    }
}
