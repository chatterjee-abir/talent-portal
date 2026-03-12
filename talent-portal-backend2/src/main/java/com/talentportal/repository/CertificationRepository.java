package com.talentportal.repository;

import com.talentportal.entity.Certification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CertificationRepository extends JpaRepository<Certification, Long> {

    Optional<Certification> findByName(String name);

    @Query("SELECT c.name, COUNT(a) FROM Certification c " +
           "JOIN c.associates a GROUP BY c.name ORDER BY COUNT(a) DESC")
    List<Object[]> findCertificationCounts();
}
