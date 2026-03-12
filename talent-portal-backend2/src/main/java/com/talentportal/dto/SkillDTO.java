package com.talentportal.dto;

import lombok.Data;

@Data
public class SkillDTO {
    private String skillName;
    private int currentLevel;
    private int previousLevel;
    private int delta;
}
