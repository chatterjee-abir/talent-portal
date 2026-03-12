package com.talentportal.repository;

import com.talentportal.entity.Associate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface AssociateRepository extends JpaRepository<Associate, Long> {

    Optional<Associate> findByEmpId(String empId);

    List<Associate> findByEmpIdContainingIgnoreCase(String empId);

    List<Associate> findByFullNameContainingIgnoreCase(String name);

    @Query("SELECT a FROM Associate a WHERE " +
           "LOWER(a.empId) LIKE LOWER(CONCAT('%', :term, '%')) OR " +
           "LOWER(a.fullName) LIKE LOWER(CONCAT('%', :term, '%'))")
    List<Associate> searchByTerm(@Param("term") String term);
}
