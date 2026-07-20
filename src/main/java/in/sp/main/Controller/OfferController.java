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
    public String addOfferPage(@RequestParam Long salonId, Model model) {
        model.addAttribute("offer", new Offer());
        model.addAttribute("salon", salonService.getSalonById(salonId));
        return "salon/add-offer";
    }

    // ✅ Save Offer
    @PostMapping("/saveOffer")
    public String saveOffer(@ModelAttribute Offer offer, @RequestParam Long salonId) {
        Salon salon = salonService.getSalonById(salonId);
        offer.setSalon(salon);
        offer.setActive(true);
        offerService.saveOffer(offer);
        return "redirect:/salon/viewOffers?salonId=" + salonId;
    }

    // ✅ Salon views all offers
    @GetMapping("/viewOffers")
    public String viewOffers(@RequestParam Long salonId, Model model) {
        List<Offer> offers = offerService.getOffersBySalonId(salonId);
        model.addAttribute("offers", offers);
        model.addAttribute("salonId", salonId);
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
