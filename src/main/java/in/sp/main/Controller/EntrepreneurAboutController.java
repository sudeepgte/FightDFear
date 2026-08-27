package in.sp.main.Controller;

import in.sp.main.Entities.BusinessProposal;
import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.EntrepreneurRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class EntrepreneurAboutController {

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private BusinessProposalRepository businessProposalRepository;

    @GetMapping({"/entrepreneurs/about/{id}", "/entrepreneur/about/{id}"})
    public String viewEntrepreneurAboutPage(@PathVariable("id") Long id, Model model, HttpSession session) {
        Optional<Entrepreneur> opt = entrepreneurRepository.findById(id);
        if (opt.isEmpty()) {
            Optional<BusinessProposal> propOpt = businessProposalRepository.findById(id);
            if (propOpt.isPresent() && propOpt.get().getEntrepreneur() != null) {
                opt = Optional.of(propOpt.get().getEntrepreneur());
            }
        }
        if (opt.isEmpty()) {
            List<Entrepreneur> allEnts = entrepreneurRepository.findAll();
            if (!allEnts.isEmpty()) {
                opt = Optional.of(allEnts.get(0));
            }
        }
        if (opt.isEmpty()) {
            return "redirect:/admin/pending-proposals";
        }
        Entrepreneur e = opt.get();
        e.setProfileCompletionPct(EntrepreneurController.calculateEntrepreneurCompletionPct(e));
        model.addAttribute("entrepreneur", e);

        List<BusinessProposal> proposals = null;
        try {
            proposals = businessProposalRepository.findByEntrepreneur(e);
        } catch (Exception ex) {
            proposals = new ArrayList<>();
        }
        model.addAttribute("proposals", proposals != null ? proposals : new ArrayList<>());

        return "aboutEntrepreneur";
    }
}
