package com.talentportal.controller;

import com.talentportal.dto.CertificationDTO;
import com.talentportal.service.CertificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/certifications")
@RequiredArgsConstructor
public class CertificationController {

    private final CertificationService service;

    @GetMapping
    public ResponseEntity<List<CertificationDTO>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }
}
