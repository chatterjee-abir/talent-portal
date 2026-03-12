package com.talentportal.dto;

import lombok.Data;
import java.util.List;

@Data
public class CertificationDTO {
    private String name;
    private int holderCount;
    private List<String> holders;
}
