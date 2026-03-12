package com.talentportal.dto;

import lombok.Data;
import java.util.Map;

@Data
public class SkillSummaryDTO {
    private String skillName;
    private double averageLevel;
    private Map<Integer, Long> levelDistribution;
    private long level3PlusCount;
}
