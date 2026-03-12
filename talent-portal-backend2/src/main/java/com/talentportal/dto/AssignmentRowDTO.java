package com.talentportal.dto;

import lombok.Data;

@Data
public class AssignmentRowDTO {
    private String projectCode;
    private String projectName;
    private String empId;
    private String fullName;
    private String role;
    private String startDate;
    private String endDate;
    private String status;
}
