package in.sp.main.Controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.Offer;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonPromotion;
import in.sp.main.Repository.OfferRepository;
import in.sp.main.Repository.SalonPromotionRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/salon/promotions")
public class SalonPromotionController {

    @Autowired
    private SalonPromotionRepository salonPromotionRepository;

    @Autowired
    private OfferRepository offerRepository;

    @GetMapping
    public String viewPromotions(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<SalonPromotion> promotions = salonPromotionRepository.findBySalonId(loggedSalon.getId());
        List<Offer> existingOffers = offerRepository.findBySalonId(loggedSalon.getId());
        
        int total = promotions.size();
        int active = 0;
        int scheduled = 0;
        int expired = 0;

        for (SalonPromotion p : promotions) {
            String status = p.getDynamicStatus();
            if ("Active".equals(status)) active++;
            else if ("Scheduled".equals(status)) scheduled++;
            else if ("Expired".equals(status)) expired++;
        }

        model.addAttribute("promotions", promotions);
        model.addAttribute("existingOffers", existingOffers);
        model.addAttribute("totalCount", total);
        model.addAttribute("activeCount", active);
        model.addAttribute("scheduledCount", scheduled);
        model.addAttribute("expiredCount", expired);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            model.addAttribute("error", errorMsg);
            session.removeAttribute("errorMsg");
        }

        return "salon/salon-promotions";
    }

    @GetMapping("/new")
    public String newPromotionPage(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<Offer> existingOffers = offerRepository.findBySalonId(loggedSalon.getId());
        model.addAttribute("existingOffers", existingOffers);

        return "salon/salon-add-promotion";
    }

    @PostMapping("/add")
    public String addPromotion(@RequestParam("promotionName") String promotionName,
                               @RequestParam("description") String description,
                               @RequestParam("headline") String headline,
                               @RequestParam("ctaText") String ctaText,
                               @RequestParam(value = "bannerUrl", required = false) String bannerUrl,
                               @RequestParam("category") String category,
                               @RequestParam("targetAudience") String targetAudience,
                               @RequestParam("startDate") String startDateStr,
                               @RequestParam("endDate") String endDateStr,
                               @RequestParam(value = "startTime", required = false) String startTimeStr,
                               @RequestParam(value = "endTime", required = false) String endTimeStr,
                               @RequestParam(value = "status", required = false, defaultValue = "Active") String status,
                               @RequestParam(value = "offerIds", required = false) List<Integer> offerIds,
                               HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        SalonPromotion promotion = new SalonPromotion();
        promotion.setSalon(loggedSalon);
        promotion.setPromotionName(promotionName);
        promotion.setDescription(description);
        promotion.setHeadline(headline);
        promotion.setCtaText(ctaText);
        promotion.setBannerUrl(bannerUrl);
        promotion.setCategory(category);
        promotion.setTargetAudience(targetAudience);
        
        promotion.setStartDate(LocalDate.parse(startDateStr));
        promotion.setEndDate(LocalDate.parse(endDateStr));
        
        if (startTimeStr != null && !startTimeStr.isEmpty()) {
            promotion.setStartTime(LocalTime.parse(startTimeStr));
        }
        if (endTimeStr != null && !endTimeStr.isEmpty()) {
            promotion.setEndTime(LocalTime.parse(endTimeStr));
        }

        List<Offer> linkedOffers = new ArrayList<>();
        if (offerIds != null) {
            for (Integer id : offerIds) {
                offerRepository.findById(id).ifPresent(linkedOffers::add);
            }
        }
        promotion.setPromotedOffers(linkedOffers);

        if ("Draft".equals(status)) {
            promotion.setExplicitStatus("Draft");
        }

        salonPromotionRepository.save(promotion);
        session.setAttribute("successMsg", "Marketing campaign created successfully!");

        return "redirect:/salon/promotions";
    }

    @PostMapping("/status")
    public String updateStatus(@RequestParam("promotionId") Long promotionId,
                               @RequestParam("status") String status,
                               HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonPromotion> promoOpt = salonPromotionRepository.findById(promotionId);
        if (promoOpt.isPresent() && promoOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            SalonPromotion promo = promoOpt.get();
            // If the user chooses to Resume from Paused/Draft, we set explicitStatus back to null so dynamic calculation takes over.
            if ("Resume".equals(status)) {
                promo.setExplicitStatus(null);
                session.setAttribute("successMsg", "Promotion resumed and will follow its scheduled dates.");
            } else {
                promo.setExplicitStatus(status);
                session.setAttribute("successMsg", "Promotion status updated to " + status + ".");
            }
            salonPromotionRepository.save(promo);
        } else {
            session.setAttribute("errorMsg", "Promotion not found.");
        }

        return "redirect:/salon/promotions";
    }

    @PostMapping("/delete")
    public String deletePromotion(@RequestParam("promotionId") Long promotionId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonPromotion> promoOpt = salonPromotionRepository.findById(promotionId);
        if (promoOpt.isPresent() && promoOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            salonPromotionRepository.delete(promoOpt.get());
            session.setAttribute("successMsg", "Promotion archived successfully.");
        } else {
            session.setAttribute("errorMsg", "Promotion not found.");
        }

        return "redirect:/salon/promotions";
    }
}
