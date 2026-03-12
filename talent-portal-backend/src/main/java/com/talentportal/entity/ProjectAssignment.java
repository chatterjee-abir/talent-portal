package com.talentportal.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDate;

/**
 * ProjectAssignment — maps to 'project_assignments' table.
 *
 * This is a "rich" many-to-many join entity — it adds extra columns
 * (role, start_date, end_date) to the relationship between Project and Associate.
 *
 * A plain @ManyToMany only creates the join table with two FK columns.
 * When you need extra columns on the join, you model it as its own entity
 * with two @ManyToOne relationships instead.
 *
 * STATUS LOGIC:
 * ─────────────
 * Active  = end_date is in the future (or null)
 * Closed  = end_date is in the past
 * This logic lives in ProjectAssignmentService.toDTO(), not in the entity.
 */
@Entity
@Table(name = "project_assignments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProjectAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "associate_id", nullable = false)
    private Associate associate;

    @Column(length = 60)
    private String role;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;
}
