package com.talentportal.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * Skill — maps to the 'skills' table.
 * One row per (associate, skill_name) combination.
 * An associate with 5 skills has 5 Skill rows linked to them.
 */
@Entity
@Table(name = "skills")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Skill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * MANY skills belong to ONE associate.
     * This is the "owning" side of the OneToMany relationship —
     * this entity has the actual foreign key column (associate_id) in the table.
     *
     * @JoinColumn(name = "associate_id") tells Hibernate which column is the FK.
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "associate_id", nullable = false)
    private Associate associate;

    @Column(name = "skill_name", nullable = false, length = 60)
    private String skillName;

//    @Column(name = "current_level", nullable = false)
  //  private Integer currentLevel;
    @Column(name = "current_level", nullable = false, columnDefinition = "TINYINT")
    private Integer currentLevel;

    //@Column(name = "previous_level", nullable = false)
    //private Integer previousLevel;
    @Column(name = "previous_level", nullable = false, columnDefinition = "TINYINT")
    private Integer previousLevel;
}
