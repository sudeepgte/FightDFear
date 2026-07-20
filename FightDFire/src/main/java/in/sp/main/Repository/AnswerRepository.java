package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.Answer;

public interface AnswerRepository extends JpaRepository<Answer, Long> {

	Answer findByQuestionId(Long questionId);}
