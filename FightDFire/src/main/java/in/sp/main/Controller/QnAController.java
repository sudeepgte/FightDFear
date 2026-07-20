package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.Question;
import in.sp.main.Service.QnAService;
import in.sp.main.dto.AnswerSubmissionDTO;
import in.sp.main.dto.CommentSubmissionDTO;
import in.sp.main.dto.QuestionSubmissionDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/qna")
public class QnAController {

    @Autowired
    private QnAService qnaService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setDisallowedFields("session");
    }

    // Show list of all Q&A threads
    @RequestMapping(method = RequestMethod.GET)
    public String listAllThreads(Model model) {
        model.addAttribute("threads", qnaService.getAllThreads());
        return "questions/questions";
    }

    // Post a new anonymous question
    @RequestMapping(value = "/ask", method = RequestMethod.POST)
    public String postQuestion(@ModelAttribute QuestionSubmissionDTO dto, HttpServletRequest request) {
        HttpSession session = request.getSession();

        String name = dto.getDisplayName();
        if (name == null || name.trim().isEmpty()) {
            name = getOrGenerateDisplayName(session);
        } else {
            session.setAttribute("qaDisplayName", name);
        }

        Question question = new Question();
        question.setDisplayName(name);
        question.setContent(dto.getContent());
        question.setPostedAt(LocalDateTime.now());

        qnaService.saveQuestion(question);
        return "redirect:/qna";
    }

    // View a full Q&A thread with admin answer and comments
    @RequestMapping(value = "/thread/{id}", method = RequestMethod.GET)
    public String viewThread(@PathVariable Long id, Model model) {
        model.addAttribute("thread", qnaService.getFullThread(id));
        return "questions/qna-thread";
    }

    // Post a comment to a question or answer
    @RequestMapping(value = "/thread/{id}/comment", method = RequestMethod.POST)
    public String postComment(@PathVariable Long id,
                              @ModelAttribute CommentSubmissionDTO dto,
                              HttpSession session) {
        String displayName = getOrGenerateDisplayName(session);
        qnaService.addCommentToThread(id, dto, displayName);
        return "redirect:/qna/thread/" + id;
    }

    // Admin posts an answer to a question
    @RequestMapping(value = "/thread/{id}/answer", method = RequestMethod.POST)
    public String postAnswer(@PathVariable Long id, @ModelAttribute AnswerSubmissionDTO dto) {
        qnaService.answerQuestion(dto);
        return "redirect:/qna/thread/" + id;
    }

    // Helper: Generate or reuse display name per session
    private String getOrGenerateDisplayName(HttpSession session) {
        String name = (String) session.getAttribute("qaDisplayName");
        if (name == null) {
            name = "User" + new Random().nextInt(9999);
            session.setAttribute("qaDisplayName", name);
        }
        return name;
    }

    // Admin view all questions
    @RequestMapping(value = "/admin/questions", method = RequestMethod.GET)
    public String adminViewAllQuestions(Model model) {
        List<Question> questions = qnaService.getAllThreads();

        Map<Long, String> formattedTimestamps = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy 'at' hh:mm a");

        for (Question q : questions) {
            LocalDateTime postedAt = q.getPostedAt();
            if (postedAt != null) {
                formattedTimestamps.put(q.getId(), postedAt.format(formatter));
            } else {
                formattedTimestamps.put(q.getId(), "Not Available");
            }
        }

        model.addAttribute("questions", questions);
        model.addAttribute("formattedTimestamps", formattedTimestamps);

        return "questions/admin-questions";
    }

    // Admin post answer
    @RequestMapping(value = "/admin/qna/answer", method = RequestMethod.POST)
    public String adminPostAnswer(@ModelAttribute AnswerSubmissionDTO dto, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("userRole"))) {
            return "redirect:/access-denied";
        }
        qnaService.answerQuestion(dto);
        return "redirect:/qna/admin/questions";
    }

    // Admin delete question
    @RequestMapping(value = "/admin/qna/delete", method = RequestMethod.POST)
    public String deleteQuestion(@RequestParam Long questionId, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("userRole"))) {
            return "redirect:/access-denied";
        }
        qnaService.deleteQuestionById(questionId);
        return "redirect:/qna/admin/questions";
    }
}
