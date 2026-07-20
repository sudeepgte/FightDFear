package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Question;

public interface QuestionRepository extends JpaRepository<Question, Long> {}
