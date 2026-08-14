package in.sp.main.Controller;
 
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.ServiceService;
import jakarta.servlet.http.HttpSession;
 
@Controller
@RequestMapping("/booking")
public class BookingController {
 
    @Autowired
    private BookingRepository bookingRepository;
    @Autowired
    private Booking1Repository booking1Repository;
 
    @Autowired
    private ServiceRepository serviceRepository;
 
    @Autowired
    private SalonRepository salonRepository;
 
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ServiceService serviceService;
    @Autowired
    private OfferBookingRepository offerbookingRepository;

    @Autowired
    private TreatmentRepository treatmentRepository;
 
    @Autowired
    private OfferRepository offerRepository;
    
    @Autowired
    private SalonNotificationRepository salonNotificationRepository;

    // Show booking form
    @GetMapping("/new")
    public String showBookingForm(@RequestParam(required = false) Long serviceId,
                                  @RequestParam(required = false) Long treatmentId,
                                  @RequestParam(required = false) Long offerId,
                                  HttpSession session,
                                  Model model) {
 
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";
 
        if (serviceId != null) {
            Service1 service = serviceRepository.findById(serviceId).orElse(null);
            if (service == null) return "redirect:/user/salons";
            model.addAttribute("item", service);
            model.addAttribute("type", "SERVICE");
        } else if (treatmentId != null) {
            Treatment treatment = treatmentRepository.findById(treatmentId).orElse(null);
            if (treatment == null) return "redirect:/user/salons";
            model.addAttribute("item", treatment);
            model.addAttribute("type", "TREATMENT");
        } else if (offerId != null) {
            Offer offer = offerRepository.findById(offerId).orElse(null);
            if (offer == null) return "redirect:/user/salons";
            model.addAttribute("item", offer);
            model.addAttribute("type", "OFFER");
        } else {
            return "redirect:/user/salons";
        }
 
        model.addAttribute("user", loggedUser);
        return "user/bookingForm"; // Single JSP for all
    }
 
    // Handle booking submission
    @PostMapping("/new")
    public String createBooking(@RequestParam(required = false) Long serviceId,
                                @RequestParam(required = false) Long treatmentId,
                                @RequestParam(required = false) Long offerId,
                                @RequestParam String bookingType,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String notes,
                                @RequestParam String emergencyContact,
                                @RequestParam String bookingDate, 
                                @RequestParam 	LocalTime preferredTime, 
                                HttpSession session,
                                Model model) {
 
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";
 
        Booking1 booking = new Booking1();
        booking.setUser(loggedUser);
        booking.setPreferredTime(preferredTime); 
        booking.setBookingDate(LocalDate.parse(bookingDate)); 

        booking.setBookingType(bookingType.toUpperCase());
        booking.setEmergencyContact(emergencyContact);
        booking.setNotes(notes);
       
        if (serviceId != null) {
            Service1 service = serviceRepository.findById(serviceId).orElse(null);
            if (service == null) return "redirect:/user/salons";
            booking.setSalon(service.getSalon());
            booking.setService(service);
            booking.setPrice(service.getPrice());
        } else if (treatmentId != null) {
            Treatment treatment = treatmentRepository.findById(treatmentId).orElse(null);
            if (treatment == null) return "redirect:/user/salons";
            booking.setSalon(treatment.getSalon());
            booking.setTreatment(treatment);
            booking.setPrice(treatment.getPrice());
        } else if (offerId != null) {
            Offer offer = offerRepository.findById(offerId).orElse(null);
            if (offer == null) return "redirect:/user/salons";
            booking.setSalon(offer.getSalon());
            booking.setPrice(offer.getDiscountedPrice() > 0 ? offer.getDiscountedPrice() : offer.getOriginalPrice());
        }
 
        if ("DOOR".equalsIgnoreCase(bookingType)) {
            booking.setAddress(address != null ? address : loggedUser.getHomeAddress());
        } else {
            booking.setAddress(null);
        }
        booking1Repository.save(booking);
        
        SalonNotification notif = new SalonNotification();
        notif.setSalon(booking.getSalon());
        notif.setTitle("New Booking Alert");
        String serviceName = booking.getService() != null ? booking.getService().getName() : (booking.getTreatment() != null ? booking.getTreatment().getServiceName() : "a service");
        notif.setMessage("You have a new booking from " + loggedUser.getFullName() + " for " + serviceName + " on " + booking.getBookingDate() + " at " + booking.getPreferredTime() + ".");
        salonNotificationRepository.save(notif);
        
        return "redirect:/booking/myBookings";
    }
 
// Show logged-in user's bookings (both service & treatment)
    @GetMapping("/myBookings")
    public String viewMyBookings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
 
        List<Booking1> allBookings = booking1Repository.findByUser(user);
 
        // FIXED — correct separation
        List<Booking1> serviceBookings = allBookings.stream()
                .filter(b -> b.getService() != null)
                .toList();
 
        List<Booking1> treatmentBookings = allBookings.stream()
                .filter(b -> b.getTreatment() != null)
                .toList();
 
        List<OfferBooking> offerBookings = offerbookingRepository.findByUser(user);
 
        model.addAttribute("serviceBookings", serviceBookings);
        model.addAttribute("treatmentBookings", treatmentBookings);
        model.addAttribute("offerBookings", offerBookings);
 
        return "user/myBookings";
    }
 
 
 
 
    // Show logged-in user's bookings
// ✅ View all bookings for the logged-in salon
    @GetMapping("/list")
    public String viewSalonBookings(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        // Fetch bookings linked to this salon
        List<Booking1> allBookings = booking1Repository.findBySalon(loggedSalon);

        // Separate the bookings based on type
        List<Booking1> serviceBookings = allBookings.stream()
                .filter(b -> b.getService() != null)
                .toList();

        List<Booking1> treatmentBookings = allBookings.stream()
                .filter(b -> b.getTreatment() != null)
                .toList();

        // Fetch OfferBookings from another repository
        List<OfferBooking> offerBookings = offerbookingRepository.findBySalon(loggedSalon);

        // ✅ Merge all into one list for "bookings"
        List<Booking1> bookings = new ArrayList<>();
        bookings.addAll(serviceBookings);
        bookings.addAll(treatmentBookings);

        // Add to model
        model.addAttribute("bookings", bookings);  
        model.addAttribute("offerBookings", offerBookings); 
        model.addAttribute("salon", loggedSalon); // Added this line
        model.addAttribute("today", LocalDate.now()); // Added for date comparison

        return "salon/viewBookings";
    }

    @PostMapping("/updateStatus")
    public String updateBookingStatus(@RequestParam Long bookingId,
                                      @RequestParam String status,
                                      @RequestParam String bookingType,
                                      HttpSession session) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        // ✅ SERVICE / TREATMENT BOOKINGS
        if ("NORMAL".equalsIgnoreCase(bookingType)) {

            Booking1 booking = booking1Repository.findById(bookingId).orElse(null);

            if (booking != null && booking.getSalon().getId().equals(loggedSalon.getId())) {
                if ("COMPLETED".equalsIgnoreCase(status) && booking.getBookingDate() != null && booking.getBookingDate().isAfter(LocalDate.now())) {
                    // Cannot complete future booking
                } else {
                    booking.setStatus(status.toUpperCase());
                    booking1Repository.save(booking);
                }
            }
        }

        // ✅ OFFER BOOKINGS
        else if ("OFFER".equalsIgnoreCase(bookingType)) {

            OfferBooking offerBooking = offerbookingRepository.findById(bookingId).orElse(null);

            if (offerBooking != null && offerBooking.getSalon().getId().equals(loggedSalon.getId())) {
                if ("COMPLETED".equalsIgnoreCase(status) && offerBooking.getDate() != null && offerBooking.getDate().isAfter(LocalDate.now())) {
                    // Cannot complete future booking
                } else {
                    offerBooking.setStatus(status.toUpperCase());
                    offerbookingRepository.save(offerBooking);
                }
            }
        }

        return "redirect:/booking/list";
    }


 
}