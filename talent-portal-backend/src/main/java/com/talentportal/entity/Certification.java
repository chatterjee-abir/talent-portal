package com.talentportal.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.ArrayList;
import java.util.List;

/**
 * Certification — maps to the 'certifications' lookup table.
 * Only 10 rows — one per certification name (AWS SA, Azure, etc.)
 *
 * The ManyToMany back-reference to associates is optional here
 * (mappedBy="certifications" means Associate owns the relationship).
 * We include it so we can query "which associates hold this cert".
 */
@Entity
@Table(name = "certifications")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Certification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 150)
    private String name;

    /**
     * The inverse side of the ManyToMany.
     * mappedBy = "certifications" means the Associate entity manages
     * the join table — Certification doesn't need to define @JoinTable again.
     */
    @ManyToMany(mappedBy = "certifications", fetch = FetchType.LAZY)
    private List<Associate> associates = new ArrayList<>();
}
