package com.talentportal.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Associate — maps to the 'associates' database table.
 *
 * HOW JPA ENTITY MAPPING WORKS:
 * ─────────────────────────────
 * @Entity tells Hibernate "this class corresponds to a database table".
 * Each field annotated with @Column maps to a column in that table.
 * When you call associateRepository.findAll(), Hibernate runs:
 *   SELECT * FROM associates
 * and converts each row into an Associate Java object automatically.
 *
 * LOMBOK ANNOTATIONS:
 * ───────────────────
 * @Data       = generates getters, setters, toString(), equals(), hashCode()
 * @NoArgsConstructor = generates public Associate() {}
 * @AllArgsConstructor = generates public Associate(Long id, String empId, ...)
 * Without Lombok you would write ~80 lines of boilerplate by hand.
 */
@Entity
@Table(name = "associates")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Associate {

    /**
     * @Id marks this as the primary key column.
     * @GeneratedValue(IDENTITY) tells MySQL to auto-increment this value.
     * We never set this field manually — MySQL assigns it on INSERT.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * emp_id is the business key — the human-readable identifier (EMP1001).
     * unique=true → MySQL enforces no duplicate EmpIDs.
     * nullable=false → the column has a NOT NULL constraint.
     */
    @Column(name = "emp_id", unique = true, nullable = false, length = 20)
    private String empId;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(nullable = false, length = 50)
    private String department;

    @Column(nullable = false, length = 60)
    private String role;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    /**
     * ONE associate has MANY skills.
     *
     * mappedBy = "associate" → the Skill entity owns this relationship
     *   (i.e. the skills table has the foreign key column associate_id).
     *
     * cascade = ALL → if you save/delete an Associate, cascade to its Skills.
     *
     * fetch = LAZY → don't load skills from the database until they are accessed.
     *   This is critical for performance: loading 50 associates does NOT
     *   load all 250 skills unless you explicitly access associate.getSkills().
     */
    @OneToMany(mappedBy = "associate", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Skill> skills = new ArrayList<>();

    /**
     * MANY associates hold MANY certifications.
     * The join table is 'associate_certifications' (defined in schema.sql).
     *
     * @JoinTable specifies:
     *   name             → the join table name
     *   joinColumns      → the FK column pointing to THIS entity (associates.id)
     *   inverseJoinColumns → the FK column pointing to the OTHER entity (certifications.id)
     */
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "associate_certifications",
        joinColumns        = @JoinColumn(name = "associate_id"),
        inverseJoinColumns = @JoinColumn(name = "certification_id")
    )
    private List<Certification> certifications = new ArrayList<>();
}
