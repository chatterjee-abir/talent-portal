package com.talentportal.service;

import com.talentportal.dto.SkillSummaryDTO;
import com.talentportal.entity.Skill;
import com.talentportal.repository.SkillRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SkillService {

    private final SkillRepository skillRepo;

    public List<SkillSummaryDTO> getSummaries() {
        List<String> skillNames = List.of(
            "Gen AI", "Angular", "Java SpringBoot", "Domain", "AWS"
        );

        return skillNames.stream().map(name -> {
            List<Skill> skills = skillRepo.findBySkillName(name);

            SkillSummaryDTO dto = new SkillSummaryDTO();
            dto.setSkillName(name);

            double avg = skills.stream()
                               .mapToInt(Skill::getCurrentLevel)
                               .average()
                               .orElse(0.0);
            dto.setAverageLevel(Math.round(avg * 10.0) / 10.0);

            Map<Integer, Long> dist = skills.stream()
                .collect(Collectors.groupingBy(
                    Skill::getCurrentLevel,
                    Collectors.counting()
                ));
            dto.setLevelDistribution(dist);

            long l3plus = skills.stream()
                                .filter(s -> s.getCurrentLevel() >= 3)
                                .count();
            dto.setLevel3PlusCount(l3plus);

            return dto;
        }).collect(Collectors.toList());
    }
}
