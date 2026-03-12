package com.talentportal.service;

import com.talentportal.dto.DashboardSummaryDTO;
import com.talentportal.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardService {

    private final AssociateRepository     associateRepo;
    private final SkillRepository         skillRepo;
    private final CertificationRepository certRepo;
    private final ProjectRepository       projectRepo;

    public DashboardSummaryDTO getSummary() {
        DashboardSummaryDTO dto = new DashboardSummaryDTO();

        dto.setTotalAssociates((int) associateRepo.count());
        dto.setActiveProjects((int) projectRepo.count());

        dto.setTotalCertifications(
            certRepo.findAll().stream()
                    .mapToInt(c -> c.getAssociates().size())
                    .sum()
        );

        dto.setLevel3PlusSkills((int) skillRepo.countByCurrentLevelGreaterThanEqual(3));

        Double avg = skillRepo.findAverageLevel();
        dto.setAvgSkillLevel(avg != null ? (int) Math.round(avg) : 0);

        dto.setSkillsImproved((int) skillRepo.countImproved());

        long certified = associateRepo.findAll().stream()
            .filter(a -> !a.getCertifications().isEmpty())
            .count();
        dto.setCertifiedAssociates((int) certified);

        return dto;
    }
}
