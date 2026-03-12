package com.talentportal.dto;

import lombok.Data;
import java.util.List;

@Data
public class AssociateDTO {
    private String empId;
    private String fullName;
    private String department;
    private String role;
    private List<SkillDTO> skills;
    private List<String> certifications;
}
