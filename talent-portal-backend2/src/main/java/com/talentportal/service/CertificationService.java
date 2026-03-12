package com.talentportal.service;

import com.talentportal.dto.CertificationDTO;
import com.talentportal.entity.Associate;
import com.talentportal.repository.CertificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CertificationService {

    private final CertificationRepository certRepo;

    public List<CertificationDTO> getAll() {
        return certRepo.findAll().stream().map(cert -> {
            CertificationDTO dto = new CertificationDTO();
            dto.setName(cert.getName());
            dto.setHolderCount(cert.getAssociates().size());
            dto.setHolders(
                cert.getAssociates().stream()
                    .map(Associate::getEmpId)
                    .collect(Collectors.toList())
            );
            return dto;
        }).collect(Collectors.toList());
    }
}
