package com.talentportal.dto;

import lombok.Data;

@Data
public class ProjectDTO {
    private String projectCode;
    private String projectName;
    private int totalAssigned;
    private int activeCount;
    private int closedCount;
}
