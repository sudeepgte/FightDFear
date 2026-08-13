package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.*;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/salon")
public class OfferController {

    @Autowired
    private OfferService offerService;

    @Autowired
    private OfferRepository offerRepository;

    @Autowired
    private SalonService salonService;

    @Autowired
    private OfferBookingRepository offerBookingRepository;

    // ✅ Salon adds an offer
    @GetMapping("/addOffer")
    public String addOfferPage(@RequestParam Long salonId, Model model, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        Salon salon = salonService.getSalonById(salonId);
        if (salon == null) {
            return "redirect:/salons/dashboard";
        }
        if (loggedSalon != null && !loggedSalon.getId().equals(salon.getId())) {
            salonId = loggedSalon.getId();
            salon = loggedSalon;
        }
        model.addAttribute("offer", new Offer());
        model.addAttribute("salon", salon);
        model.addAttribute("salonId", salonId);
        return "salon/add-offer";
    }

    // ✅ Save Offer
    @PostMapping("/saveOffer")
    public String saveOffer(@ModelAttribute Offer offer,
                            @RequestParam Long salonId,
                            HttpSession session,
                            Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }
        // Always bind to the logged-in salon (ignore spoofed salonId)
        salonId = loggedSalon.getId();
        Salon salon = salonService.getSalonById(salonId);
        if (salon == null) {
            return "redirect:/salons/dashboard";
        }

        String error = validateOffer(offer);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("offer", offer);
            model.addAttribute("salon", salon);
            model.addAttribute("salonId", salonId);
            return "salon/add-offer";
        }

        offer.setSalon(salon);
        offer.setActive(true);
        offerService.saveOffer(offer);
        return "redirect:/salon/viewOffers?salonId=" + salonId;
    }

    private static String validateOffer(Offer offer) {
        if (offer.getTitle() == null || offer.getTitle().isBlank()) {
            return "Offer Title is required.";
        }
        String title = offer.getTitle().trim();
        if (title.length() > 255) {
            return "Offer Title cannot exceed 255 characters.";
        }
        offer.setTitle(title);

        if (offer.getDescription() == null || offer.getDescription().isBlank()) {
            return "Detailed Description is required.";
        }
        String description = offer.getDescription().trim();
        if (description.length() > 500) {
            return "Detailed Description cannot exceed 500 characters.";
        }
        offer.setDescription(description);

        if (offer.getOriginalPrice() <= 0) {
            return "Original Price must be greater than zero.";
        }
        if (offer.getOfferPrice() < 0) {
            return "Offer Price cannot be negative.";
        }
        if (offer.getOfferPrice() >= offer.getOriginalPrice()) {
            return "Offer Price must be less than the Original Price.";
        }
        if (offer.getStartDate() == null) {
            return "Campaign Start Date is required.";
        }
        if (offer.getEndDate() == null) {
            return "Campaign End Date is required.";
        }
        // End date must be strictly after start date
        if (!offer.getEndDate().isAfter(offer.getStartDate())) {
            return "Campaign End Date must be after the Campaign Start Date.";
        }

        double discount = offer.getDiscountPercent();
        if (discount <= 0 || discount >= 100) {
            // Fall back to computing from prices when discount missing/invalid but prices are usable
            if (offer.getOfferPrice() >= 0 && offer.getOfferPrice() < offer.getOriginalPrice()) {
                discount = ((offer.getOriginalPrice() - offer.getOfferPrice()) / offer.getOriginalPrice()) * 100.0;
            }
        }
        if (discount <= 0 || discount >= 100) {
            return "Discount must be a number greater than 0 and less than 100.";
        }
        discount = Math.round(discount * 100.0) / 100.0;
        offer.setDiscountPercent(discount);

        // Keep offer price aligned with the entered discount
        double computedOffer = offer.getOriginalPrice() * (1.0 - (discount / 100.0));
        offer.setOfferPrice(Math.round(computedOffer * 100.0) / 100.0);
        return null;
    }

    // ✅ Salon views all offers
    @GetMapping("/viewOffers")
    public String viewOffers(@RequestParam Long salonId, Model model, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        Salon salon = salonService.getSalonById(salonId);
        if (salon == null) {
            return "redirect:/salons/dashboard";
        }
        List<Offer> offers = offerService.getOffersBySalonId(salonId);
        model.addAttribute("offers", offers);
        model.addAttribute("salonId", salonId);
        model.addAttribute("salon", loggedSalon != null ? loggedSalon : salon);
        return "salon/view-offers";
    }

    // ✅ User views all available offers
    @GetMapping("/offers")
    public String viewOffersForUser(Model model) {
        LocalDate today = LocalDate.now();
        List<Offer> offers = offerRepository.findByActiveTrueAndEndDateGreaterThanEqual(today);
        model.addAttribute("offers", offers);
        return "user/offers";
    }

    // ✅ Show booking page for an offer
    @GetMapping("/book")
    public String showOfferBookingPage(@RequestParam("offerId") Long offerId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Offer offer = offerService.getOfferById(offerId);
        model.addAttribute("offer", offer);
        return "user/book-offer";
    }

    // ✅ Save Offer Booking
    @PostMapping("/saveOfferBooking")
    public String saveOfferBooking(@RequestParam Long offerId, 
                                   @RequestParam String customerName,
                                   @RequestParam String customerPhone,
                                   HttpSession session,
                                   Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Offer offer = offerRepository.findById(offerId).orElse(null);
        if (offer == null) return "redirect:/salon/offers";

        if (customerName == null || customerName.trim().isEmpty() || 
            customerPhone == null || customerPhone.trim().isEmpty()) {
            model.addAttribute("error", "Name and Mobile Number are required.");
            model.addAttribute("offer", offer);
            return "user/book-offer";
        }

        OfferBooking booking = new OfferBooking();
        booking.setCustomerName(customerName);
        booking.setCustomerEmail(user.getEmail());
        booking.setOffer(offer);
        booking.setSalon(offer.getSalon());
        booking.setOriginalPrice(offer.getOriginalPrice());
        booking.setBookingDate(LocalDateTime.now());
        
        // Since there's no phone field in OfferBooking, we can put it in notes
        booking.setNotes("Phone: " + customerPhone);

        // ✅ Important line — link the logged-in user to this booking
        booking.setUser(user);

        // Optional: set default status if you want
        booking.setStatus("PENDING");

        offerBookingRepository.save(booking);

        return "redirect:/booking/myBookings";
    }

}
