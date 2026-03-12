package com.talentportal.dto;

import lombok.Data;

@Data
public class DashboardSummaryDTO {
    private int totalAssociates;
    private int activeProjects;
    private int totalCertifications;
    private int level3PlusSkills;
    private int avgSkillLevel;
    private int skillsImproved;
    private int certifiedAssociates;
}
