package com.talentportal.repository;

import com.talentportal.entity.ProjectAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProjectAssignmentRepository extends JpaRepository<ProjectAssignment, Long> {

    List<ProjectAssignment> findByProjectId(Long projectId);

    List<ProjectAssignment> findByAssociateId(Long associateId);

    @Query("SELECT pa FROM ProjectAssignment pa " +
           "JOIN FETCH pa.project p " +
           "JOIN FETCH pa.associate a " +
           "ORDER BY p.projectCode, a.empId")
    List<ProjectAssignment> findAllWithDetails();

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
