package com.talentportal.controller;

import com.talentportal.dto.AssignmentRowDTO;
import com.talentportal.dto.ProjectDTO;
import com.talentportal.service.ProjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/projects")
@RequiredArgsConstructor
public class ProjectController {

    private final ProjectService service;

    @GetMapping
    public ResponseEntity<List<ProjectDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @GetMapping("/assignments")
    public ResponseEntity<List<AssignmentRowDTO>> getAssignments(
            @RequestParam(required = false) String projectCode,
            @RequestParam(required = false) String name) {
        return ResponseEntity.ok(service.getAssignments(projectCode, name));
    }
}
