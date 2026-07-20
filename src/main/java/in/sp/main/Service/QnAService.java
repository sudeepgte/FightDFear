package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.Answer;
import in.sp.main.Entities.Comment;
import in.sp.main.Entities.Question;
import in.sp.main.Repository.AnswerRepository;
import in.sp.main.Repository.CommentRepository;
import in.sp.main.Repository.QuestionRepository;
import in.sp.main.dto.AnswerSubmissionDTO;
import in.sp.main.dto.CommentSubmissionDTO;
import in.sp.main.dto.QuestionSubmissionDTO;
import jakarta.transaction.Transactional;

@Service
public class QnAService {

    @Autowired
    private QuestionRepository questionRepo;

    @Autowired
    private AnswerRepository answerRepo;

    @Autowired
    private CommentRepository commentRepo;

    // Create a new question
    public void createQuestion(QuestionSubmissionDTO dto, String displayName) {
        Question q = new Question();
        q.setContent(dto.getContent());
        q.setDisplayName(displayName);
        q.setPostedAt(LocalDateTime.now());
        questionRepo.save(q);
    }

    // Admin posts an answer
    @Transactional
    public void answerQuestion(AnswerSubmissionDTO dto) {
        Question question = questionRepo.findById(dto.getQuestionId()).orElse(null);

        if (question == null) {
            throw new RuntimeException("Question not found");
        }

        Answer existing = answerRepo.findByQuestionId(dto.getQuestionId());

        if (existing != null) {
            // 🔁 Update the existing answer
            existing.setContent(dto.getContent());
            existing.setAnsweredAt(LocalDateTime.now());
            answerRepo.save(existing);
        } else {
            // ➕ Create a new answer
            Answer newAnswer = new Answer();
            newAnswer.setContent(dto.getContent());
            newAnswer.setAnsweredAt(LocalDateTime.now());
            newAnswer.setQuestion(question);

            answerRepo.save(newAnswer);
        }
    }


    // Add a comment to thread (question, answer, or comment)
    public void addCommentToThread(Long questionId, CommentSubmissionDTO dto, String displayName) {
        Comment c = new Comment();
        c.setQuestion(questionRepo.findById(questionId).orElseThrow());
        c.setContent(dto.getContent());
        c.setParentId(dto.getParentId());
        c.setParentType(dto.getParentType());
        c.setDisplayName(displayName);
        c.setCommentedAt(LocalDateTime.now());
        commentRepo.save(c);
    }

    // List all questions (most recent first)
    public List<Question> getAllThreads() {
        return questionRepo.findAll(Sort.by(Sort.Direction.DESC, "postedAt"));
    }

    // View full thread by question ID
    public Question getFullThread(Long id) {
        return questionRepo.findById(id).orElseThrow();
    }
    public void saveQuestion(Question question) {
        questionRepo.save(question);
    }
    public void deleteQuestionById(Long questionId) {
        questionRepo.deleteById(questionId);
    }

}
