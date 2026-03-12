package com.talentportal.repository;

import com.talentportal.entity.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SkillRepository extends JpaRepository<Skill, Long> {

    List<Skill> findByAssociateId(Long associateId);

    List<Skill> findBySkillName(String skillName);

    @Query("SELECT COUNT(s) FROM Skill s WHERE s.currentLevel >= :minLevel")
    long countByCurrentLevelGreaterThanEqual(@Param("minLevel") int minLevel);

    @Query("SELECT AVG(s.currentLevel) FROM Skill s")
    Double findAverageLevel();

    @Query("SELECT COUNT(s) FROM Skill s WHERE s.currentLevel > s.previousLevel")
    long countImproved();
}
