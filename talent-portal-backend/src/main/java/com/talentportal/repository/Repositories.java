package com.talentportal.repository;

import com.talentportal.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * REPOSITORY PATTERN — What is a Repository?
 * ────────────────────────────────────────────
 * A Repository is an interface that gives you database operations for free.
 * By extending JpaRepository<EntityClass, PrimaryKeyType> you automatically get:
 *
 *   save(entity)          → INSERT or UPDATE
 *   findById(id)          → SELECT WHERE id = ?
 *   findAll()             → SELECT *
 *   deleteById(id)        → DELETE WHERE id = ?
 *   count()               → SELECT COUNT(*)
 *   existsById(id)        → SELECT EXISTS(...)
 *
 * Spring Boot generates the full implementation at startup — you never write SQL
 * for these basic operations.
 *
 * DERIVED QUERY METHODS:
 * ──────────────────────
 * Spring Data JPA reads the method NAME and generates the SQL automatically.
 * Rules: findBy + FieldName + Condition
 *
 *   findByEmpId("EMP1001")
 *   → SELECT * FROM associates WHERE emp_id = 'EMP1001'
 *
 *   findByFullNameContainingIgnoreCase("priya")
 *   → SELECT * FROM associates WHERE LOWER(full_name) LIKE '%priya%'
 *
 * All repositories are in this one file for simplicity.
 */

@Repository
public interface AssociateRepository extends JpaRepository<Associate, Long> {

    Optional<Associate> findByEmpId(String empId);

    List<Associate> findByEmpIdContainingIgnoreCase(String empId);

    List<Associate> findByFullNameContainingIgnoreCase(String name);

    List<Associate> findByDepartment(String department);

    /**
     * Custom JPQL query for combined search.
     * JPQL uses entity class names (Associate), not table names (associates).
     * :term is a named parameter — passed in via @Param.
     */
    @Query("SELECT a FROM Associate a WHERE " +
           "LOWER(a.empId) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
           "LOWER(a.fullName) LIKE LOWER(CONCAT('%', :term, '%'))")
    List<Associate> searchByTerm(@Param("term") String term);
}

@Repository
interface SkillRepository extends JpaRepository<Skill, Long> {

    List<Skill> findByAssociateId(Long associateId);

    /**
     * Find all skills with a specific name across all associates.
     * Used by the skills summary endpoint to calculate averages.
     */
    List<Skill> findBySkillName(String skillName);

    /** Count how many associate-skill combinations have level >= minLevel */
    @Query("SELECT COUNT(s) FROM Skill s WHERE s.currentLevel >= :minLevel")
    long countByCurrentLevelGreaterThanEqual(@Param("minLevel") int minLevel);

    /** Average skill level across ALL skills (used for KPI card) */
    @Query("SELECT AVG(s.currentLevel) FROM Skill s")
    Double findAverageLevel();

    /** Count skills where the associate improved (current > previous) */
    @Query("SELECT COUNT(s) FROM Skill s WHERE s.currentLevel > s.previousLevel")
    long countImproved();
}

@Repository
interface CertificationRepository extends JpaRepository<Certification, Long> {

    Optional<Certification> findByName(String name);

    /**
     * Count how many associates hold each certification.
     * Returns Object[] rows: [certificationName, count]
     * Used by the Certification tab summary.
     */
    @Query("SELECT c.name, COUNT(a) FROM Certification c " +
           "JOIN c.associates a GROUP BY c.name ORDER BY COUNT(a) DESC")
    List<Object[]> findCertificationCounts();
}

@Repository
interface ProjectRepository extends JpaRepository<Project, Long> {

    Optional<Project> findByProjectCode(String projectCode);
}

@Repository
interface ProjectAssignmentRepository extends JpaRepository<ProjectAssignment, Long> {

    List<ProjectAssignment> findByProjectId(Long projectId);

    List<ProjectAssignment> findByAssociateId(Long associateId);

    /**
     * Load all assignments with their project and associate data in one query.
     * JOIN FETCH prevents N+1 queries: without it, accessing pa.getProject()
     * on each row would trigger a separate SELECT for each assignment.
     */
    @Query("SELECT pa FROM ProjectAssignment pa " +
           "JOIN FETCH pa.project p " +
           "JOIN FETCH pa.associate a " +
           "ORDER BY p.projectCode, a.empId")
    List<ProjectAssignment> findAllWithDetails();

    /**
     * Filter assignments by project code or associate name.
     * Both filters are optional — if null/empty, that filter is ignored.
     */
    @Query("SELECT pa FROM ProjectAssignment pa " +
           "JOIN FETCH pa.project p " +
           "JOIN FETCH pa.associate a " +
           "WHERE (:projectCode IS NULL OR p.projectCode = :projectCode) " +
           "AND (:name IS NULL OR LOWER(a.fullName) LIKE LOWER(CONCAT('%', :name, '%'))) " +
           "ORDER BY p.projectCode, a.empId")
    List<ProjectAssignment> findFiltered(
        @Param("projectCode") String projectCode,
        @Param("name") String name
    );
}
