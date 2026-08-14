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
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/salon")
public class OfferController {

    @Autowired
    private OfferService offerService;

    @Autowired
    private OfferRepository offerRepository;

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SalonNotificationRepository salonNotificationRepository;

    @Autowired
    private SalonService salonService;

    @Autowired
    private OfferBookingRepository offerBookingRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    // ✅ Salon adds an offer
    @GetMapping("/addOffer")
    public String addOfferPage(@RequestParam Long salonId, HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null || !loggedSalon.getId().equals(salonId)) {
            return "redirect:/salons/login";
        }
        
        List<Service1> salonServices = serviceRepository.findBySalonId(salonId);
        
        model.addAttribute("offer", new Offer());
        model.addAttribute("salonId", salonId);
        model.addAttribute("salonServices", salonServices);
        return "salon/add-offer";
    }

    // ✅ Save Offer
    @PostMapping("/saveOffer")
    public String saveOffer(@ModelAttribute Offer offer, 
                            @RequestParam Long salonId,
                            @RequestParam(value = "serviceIds", required = false) List<Long> serviceIds,
                            @RequestParam(value = "startTimeStr", required = false) String startTimeStr,
                            @RequestParam(value = "endTimeStr", required = false) String endTimeStr,
                            HttpSession session) {
        
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null || !loggedSalon.getId().equals(salonId)) return "redirect:/salons/login";
        
        Salon salon = salonService.getSalonById(salonId);
        offer.setSalon(salon);
        
        if (startTimeStr != null && !startTimeStr.isEmpty()) {
            offer.setStartTime(LocalTime.parse(startTimeStr));
        }
        if (endTimeStr != null && !endTimeStr.isEmpty()) {
            offer.setEndTime(LocalTime.parse(endTimeStr));
        }
        
        List<Service1> linkedServices = new ArrayList<>();
        if (serviceIds != null) {
            for (Long sid : serviceIds) {
                serviceRepository.findById(sid).ifPresent(linkedServices::add);
            }
        }
        offer.setApplicableServices(linkedServices);
        
        offerService.saveOffer(offer);
        session.setAttribute("successMsg", "Offer created successfully!");
        return "redirect:/salon/viewOffers?salonId=" + salonId;
    }

    // ✅ Salon views all offers
    @GetMapping("/viewOffers")
    public String viewOffers(@RequestParam Long salonId, HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null || !loggedSalon.getId().equals(salonId)) return "redirect:/salons/login";
        
        List<Offer> offers = offerService.getOffersBySalonId(salonId);
        
        int total = offers.size();
        int active = 0;
        int scheduled = 0;
        int expired = 0;

        for (Offer o : offers) {
            String status = o.getDynamicStatus();
            if ("Active".equals(status)) active++;
            else if ("Scheduled".equals(status)) scheduled++;
            else if ("Expired".equals(status)) expired++;
        }

        model.addAttribute("offers", offers);
        model.addAttribute("salonId", salonId);
        model.addAttribute("totalCount", total);
        model.addAttribute("activeCount", active);
        model.addAttribute("scheduledCount", scheduled);
        model.addAttribute("expiredCount", expired);
        
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }
        
        return "salon/view-offers";
    }

    @PostMapping("/updateOfferStatus")
    public String updateOfferStatus(@RequestParam("offerId") Integer offerId,
                                    @RequestParam("status") String status,
                                    @RequestParam("salonId") Long salonId,
                                    @RequestParam(value = "redirect", required = false) String redirect,
                                    HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null || !loggedSalon.getId().equals(salonId)) return "redirect:/salons/login";

        Optional<Offer> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isPresent() && offerOpt.get().getSalon().getId().equals(salonId)) {
            Offer offer = offerOpt.get();
            if ("Resume".equals(status)) {
                offer.setExplicitStatus(null);
                session.setAttribute("successMsg", "Offer resumed.");
            } else {
                offer.setExplicitStatus(status);
                session.setAttribute("successMsg", "Offer status updated to " + status + ".");
            }
            offerRepository.save(offer);
        }
        return redirect != null && !redirect.isEmpty() ? "redirect:" + redirect : "redirect:/salon/viewOffers?salonId=" + salonId;
    }

    @PostMapping("/deleteOffer")
    public String deleteOffer(@RequestParam("offerId") Integer offerId,
                              @RequestParam("salonId") Long salonId,
                              @RequestParam(value = "redirect", required = false) String redirect,
                              HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null || !loggedSalon.getId().equals(salonId)) return "redirect:/salons/login";

        Optional<Offer> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isPresent() && offerOpt.get().getSalon().getId().equals(salonId)) {
            offerRepository.delete(offerOpt.get());
            session.setAttribute("successMsg", "Offer deleted successfully.");
        }
        return redirect != null && !redirect.isEmpty() ? "redirect:" + redirect : "redirect:/salon/viewOffers?salonId=" + salonId;
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
        
        SalonNotification notif = new SalonNotification();
        notif.setSalon(offer.getSalon());
        notif.setTitle("New Offer Booked");
        notif.setMessage(customerName + " has just booked your offer: " + offer.getTitle() + ".");
        salonNotificationRepository.save(notif);

        return "redirect:/booking/myBookings";
    }

}
