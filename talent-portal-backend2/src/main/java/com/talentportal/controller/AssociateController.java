package com.talentportal.controller;

import com.talentportal.dto.AssociateDTO;
import com.talentportal.service.AssociateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/associates")
@RequiredArgsConstructor
public class AssociateController {

    private final AssociateService service;

    @GetMapping
    public ResponseEntity<List<AssociateDTO>> getAll(
            @RequestParam(required = false) String empId,
            @RequestParam(required = false) String name) {
        return ResponseEntity.ok(service.search(empId, name));
    }

    @GetMapping("/{empId}")
    public ResponseEntity<AssociateDTO> getOne(@PathVariable String empId) {
        return service.findByEmpId(empId)
                      .map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }
}
