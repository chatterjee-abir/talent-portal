package com.talentportal.controller;

import com.talentportal.dto.SkillSummaryDTO;
import com.talentportal.service.SkillService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/skills")
@RequiredArgsConstructor
public class SkillController {

    private final SkillService service;

    @GetMapping
    public ResponseEntity<List<SkillSummaryDTO>> getAll() {
        return ResponseEntity.ok(service.getSummaries());
    }
}
