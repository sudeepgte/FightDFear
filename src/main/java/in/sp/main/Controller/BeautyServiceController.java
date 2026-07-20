package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.ServiceService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class BeautyServiceController {

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private StylistServiceRepository serviceRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private ReviewRepository reviewRepository;
    
	@Autowired
    private  ServiceService serviceService;
	
	@Autowired
    private  UserRepository userRepository;
	   @Autowired
	    private OfferBookingRepository offerbookingRepository;
	   @Autowired
	    private Booking1Repository booking1Repository;
	    
	   @Autowired
	    private in.sp.main.Repository.ServiceRepository service1Repository;
	   @Autowired
	    private in.sp.main.Repository.TreatmentRepository treatmentRepository;
	   @Autowired
	    private in.sp.main.Repository.OfferRepository offerRepository;
	   @Autowired
	    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepository;

    // 1️⃣ User Dashboard
	/*
	 * @GetMapping("/dashboard") public String userDashboard(Model model) {
	 * List<Salon> salons = salonRepository.findAll(); List<Stylist>
	 * independentStylists = stylistRepository.findByIsIndependent(true);
	 * 
	 * model.addAttribute("salons", salons);
	 * model.addAttribute("independentStylists", independentStylists);
	 * 
	 * return "user/beautyServices-dashboard"; }
	 */
    // 2️⃣ List All Stylists
    @GetMapping("/stylists")
    public String listAllStylists(Model model) {
        List<Stylist> allStylists = stylistRepository.findAll();
        model.addAttribute("stylists", allStylists);
        return "user/user-stylist-list";
    }

    @GetMapping("/stylist/view")
    public String viewStylistDetails(@RequestParam("id") Long stylistId, Model model, HttpSession session) {
        Optional<Stylist> stylistOpt = stylistRepository.findById(stylistId);
        if (stylistOpt.isEmpty()) return "redirect:/user/stylists";

        Stylist stylist = stylistOpt.get();
        List<StylistService> services = serviceRepository.findByStylistId(stylistId);
        List<Review> reviews = reviewRepository.findByStylistId(stylistId);

        double avgRating = reviews.isEmpty() ? 0.0 :
                reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
        stylist.setRating(avgRating);

        // Get all confirmed booking times
        List<Booking> confirmedBookings = bookingRepository.findByStylistIdAndStatus(stylistId, BookingStatus.CONFIRMED);

        // App login stores user as session attribute "user"
        User user = (User) session.getAttribute("user");
        boolean isLoggedIn = user != null;
        boolean canReview = false;
        boolean canViewContact = false;

        if (user != null) {
            // User can review only if booking COMPLETED
            canReview = bookingRepository.existsByUserIdAndStylistIdAndStatus(
                user.getId(), stylistId, BookingStatus.COMPLETED
            );
            
            // User can view contact only if booking CONFIRMED
            canViewContact = bookingRepository.existsByUserIdAndStylistIdAndStatus(
                user.getId(), stylistId, BookingStatus.CONFIRMED
            );
        }

        model.addAttribute("confirmedBookings", confirmedBookings);
        model.addAttribute("stylist", stylist);
        model.addAttribute("services", services);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("canReview", canReview);
        model.addAttribute("canViewContact", canViewContact);
        model.addAttribute("isLoggedIn", isLoggedIn);

        return "user/user-stylist-view";
    }


    // 4️⃣ Add Review
    @PostMapping("/stylist/review")
    public String addStylistReview(@RequestParam("stylistId") Long stylistId,
                                   @RequestParam("rating") Integer rating,
                                   @RequestParam("comment") String comment,
                                   HttpSession session) {

        User user = (User) session.getAttribute("user"); // ✅ CORRECT
        if (user == null) return "redirect:/login";

        stylistRepository.findById(stylistId).ifPresent(stylist -> {
            Review review = new Review();
            review.setUser(user);
            review.setStylist(stylist);
            review.setSalon(stylist.getSalon());
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedAt(LocalDateTime.now());
            reviewRepository.save(review);
        });

        return "redirect:/user/stylist/view?id=" + stylistId;
    }


 // Booking Form
    @GetMapping("/book")
    public String showBookingForm(@RequestParam("stylistId") Long stylistId,
                                  @RequestParam("serviceId") Long serviceId,
                                  Model model,
                                  HttpSession session) {

    	User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("redirectAfterLogin",
                "/user/book?stylistId=" + stylistId + "&serviceId=" + serviceId);
            return "redirect:/login";
        }

        Optional<Stylist> stylistOpt = stylistRepository.findById(stylistId);
        Optional<StylistService> serviceOpt = serviceRepository.findById(serviceId);

        if (stylistOpt.isEmpty() || serviceOpt.isEmpty()) return "redirect:/user/stylists";
        
        Stylist stylist = stylistOpt.get();
        
        // ✅ Check if stylist is available for booking
        if (Boolean.FALSE.equals(stylist.getAvailable())) {
            model.addAttribute("error", "This stylist is currently not available for bookings. Please try again later.");
            return "redirect:/user/stylist/view?id=" + stylistId;
        }

        model.addAttribute("stylist", stylist);
        model.addAttribute("service", serviceOpt.get());
        return "user/user-booking-form";
    }


    // 6️⃣ Confirm Booking
    @PostMapping("/book/confirm")
    public String confirmBooking(@RequestParam("stylistId") Long stylistId,
                                 @RequestParam("serviceId") Long serviceId,
                                 @RequestParam("bookingTime") String bookingTimeStr,
                                 @RequestParam(value = "coupon", required = false) String coupon,
                                 HttpSession session,
                                 Model model) {

    	User user = (User) session.getAttribute("user");

        if (user == null) return "redirect:/login";

        Optional<Stylist> stylistOpt = stylistRepository.findById(stylistId);
        Optional<StylistService> serviceOpt = serviceRepository.findById(serviceId);

        if (stylistOpt.isEmpty() || serviceOpt.isEmpty()) return "redirect:/user/stylists";

        Stylist stylist = stylistOpt.get();
        StylistService service = serviceOpt.get();
        
        // ✅ Double-check availability at booking confirmation
        if (Boolean.FALSE.equals(stylist.getAvailable())) {
            model.addAttribute("error", "This stylist is no longer available. Please choose another time or stylist.");
            model.addAttribute("stylist", stylist);
            model.addAttribute("service", service);
            return "user/user-booking-form";
        }

        LocalDateTime bookingTime = LocalDateTime.parse(bookingTimeStr);
        double finalPrice = service.getPrice() != null ? service.getPrice() : 0.0;
        if ("DISCOUNT10".equalsIgnoreCase(coupon)) finalPrice *= 0.9;

        Booking booking = new Booking();
        booking.setUser(user);
        booking.setStylist(stylist);
        booking.setService(service);
        booking.setBookingTime(bookingTime);
        booking.setStatus(BookingStatus.PENDING);
        booking.setPricePaid(finalPrice);
        booking.setSalon(Boolean.TRUE.equals(stylist.getIsIndependent()) ? null : stylist.getSalon());

        bookingRepository.save(booking);
        model.addAttribute("booking", booking);
        return "user/user-booking-confirmation";
    }

    // 7️⃣ User Bookings
	/*
	 * @GetMapping("/bookings") public String viewUserBookings(HttpSession session,
	 * Model model) { User user = (User) session.getAttribute("user");
	 * 
	 * if (user == null) return "redirect:/login";
	 * 
	 * List<Booking> bookings = bookingRepository.findByUserId(user.getId());
	 * model.addAttribute("bookings", bookings); return "user/user-booking-list"; }
	 */
    @GetMapping("/bookings")
    public String viewAllBookings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // ✅ Fetch Normal Bookings
        List<Booking> bookings = bookingRepository.findByUserId(user.getId());
        model.addAttribute("bookings", bookings);

        // ✅ Fetch All Booking1 records (Service & Treatment)
        List<Booking1> allBookings = booking1Repository.findByUser(user);

        List<Booking1> serviceBookings = allBookings.stream()
                .filter(b -> b.getService() != null)
                .toList();

        List<Booking1> treatmentBookings = allBookings.stream()
                .filter(b -> b.getTreatment() != null)
                .toList();

        model.addAttribute("serviceBookings", serviceBookings);
        model.addAttribute("treatmentBookings", treatmentBookings);

        // ✅ Fetch Offer Bookings
        List<OfferBooking> offerBookings = offerbookingRepository.findByUser(user);
        model.addAttribute("offerBookings", offerBookings);

        // ✅ Fetch Marketplace Worker Bookings
        List<in.sp.main.Entities.WorkerBooking> workerBookings = workerBookingRepository.findByClient_Id(user.getId());
        model.addAttribute("workerBookings", workerBookings);

        // ✅ Optional: Add discount offers to show in hero section
        List<String> discounts = List.of(
            "💅 20% off on Hair Spa this weekend!",
            "💇 Free haircut on your 5th booking!",
            "💆 15% discount on Facial + Massage combo!"
        );
        model.addAttribute("discounts", discounts);

        return "user/user-booking-list"; // You can show all bookings & offers in this JSP
    }

    // Lightweight endpoint for near real-time refresh checks
    @GetMapping("/bookings.meta")
    @ResponseBody
    public java.util.Map<String, Object> bookingsMeta(HttpSession session) {
        java.util.Map<String, Object> res = new java.util.HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            res.put("error", "LOGIN_REQUIRED");
            res.put("signature", "");
            return res;
        }

        List<Booking> bookings = bookingRepository.findByUserId(user.getId());
        List<Booking1> allBookings = booking1Repository.findByUser(user);
        List<OfferBooking> offerBookings = offerbookingRepository.findByUser(user);

        StringBuilder sb = new StringBuilder();
        for (Booking b : bookings) {
            sb.append("B:").append(b.getId()).append('|');
            if (b.getStatus() != null) sb.append(b.getStatus().name());
            sb.append(';');
        }
        for (Booking1 b : allBookings) {
            sb.append("B1:").append(b.getId()).append('|');
            if (b.getStatus() != null) sb.append(b.getStatus());
            sb.append(';');
        }
        for (OfferBooking o : offerBookings) {
            sb.append("O:").append(o.getId()).append('|');
            String st = o.getStatus();
            sb.append(st == null ? "" : st);
            sb.append(';');
        }

        res.put("signature", sb.toString());
        res.put("counts", java.util.Map.of(
                "bookings", bookings.size(),
                "booking1", allBookings.size(),
                "offers", offerBookings.size()
        ));
        return res;
    }

 // ===========================
 // List all salons for users
 // ===========================
 @GetMapping("/salons")
 public String listAllSalons(Model model) {
     List<Salon> salons = salonRepository.findAll();
     model.addAttribute("salons", salons);
     return "user/user-salon-list"; // JSP page
 }
 // 9️⃣ View Salon Details
 @GetMapping("/salon/view")
 public String viewSalon(@RequestParam("id") Long salonId, Model model) {
     Optional<Salon> salonOpt = salonRepository.findById(salonId);
     if (salonOpt.isEmpty()) {
         return "redirect:/user/salons";
     }

     Salon salon = salonOpt.get();

     // ✅ Fetch salon reviews safely
     List<SalonReview> reviews = salon.getReviews();
     double average = 0.0;

     if (reviews != null && !reviews.isEmpty()) {
         average = reviews.stream()
                 .mapToInt(SalonReview::getRating)
                 .average()
                 .orElse(0.0);
     }

     // ✅ Temporarily store average rating (not saved in DB)
     salon.setAverageRating(average);

     // ✅ Fetch stylists and their ratings
     List<Stylist> stylists = stylistRepository.findBySalonId(salonId);
     for (Stylist stylist : stylists) {
         List<Review> stylistReviews = reviewRepository.findByStylistId(stylist.getId());
         double avgRating = stylistReviews.isEmpty() ? 0.0 :
                 stylistReviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
         stylist.setRating(avgRating);
     }

     // ✅ Fetch salon services
     List<Service1> serviceList = service1Repository.findBySalonId(salonId);
     
     // ✅ Fetch salon treatments
     List<Treatment> treatmentList = treatmentRepository.findBySalonId(salonId);

     // ✅ Fetch salon offers
     List<Offer> offerList = offerRepository.findBySalonId(salonId);

     // ✅ Add all data to model
     model.addAttribute("salon", salon);
     model.addAttribute("stylists", stylists);
     model.addAttribute("serviceList", serviceList);
     model.addAttribute("treatmentList", treatmentList);
     model.addAttribute("offerList", offerList);
     model.addAttribute("averageRating", average);

     return "user/user-salon-view";
 }

 @PostMapping("/book/salonService")
 public String confirmSalonServiceBooking(
         @RequestParam("serviceId") Long serviceId,
         @RequestParam("bookingTime") String bookingTime,
         @RequestParam("paymentMode") String paymentMode,
         @RequestParam(value = "coupon", required = false) String coupon,
         HttpSession session,
         Model model) {

     User user = (User) session.getAttribute("user");
     if (user == null) {
         return "redirect:/user/login";
     }

     // ✅ Fetch the selected service
     Service1 service = serviceService.getServiceById(serviceId);
     if (service == null) {
         model.addAttribute("error", "Invalid service selection!");
         return "redirect:/user/salons";
     }

     // ✅ Apply coupon if applicable
     double finalPrice = service.getPrice();
     if (coupon != null && coupon.equalsIgnoreCase("DISCOUNT10")) {
         finalPrice = finalPrice * 0.9;
     }

     // ✅ Create booking
     Booking booking = new Booking();
     booking.setUser(user);
     booking.setSalon(service.getSalon());
     booking.setSalonService(service);
     booking.setPaymentMode(paymentMode);
     booking.setStatus(BookingStatus.CONFIRMED);
     booking.setPricePaid(finalPrice);
     booking.setIsInstant(false);

     try {
         LocalDateTime parsedTime = LocalDateTime.parse(bookingTime);
         booking.setBookingTime(parsedTime);
     } catch (Exception e) {
         booking.setBookingTime(LocalDateTime.now());
     }

     bookingRepository.save(booking);

     // ✅ Reload salon details
     Salon salon = service.getSalon();
     List<Stylist> stylists = stylistRepository.findBySalonId(salon.getId());
     List<Service1> serviceList = serviceService.getAllServicesWithSalonDetails();

     model.addAttribute("salon", salon);
     model.addAttribute("stylists", stylists);
     model.addAttribute("serviceList", serviceList);
     model.addAttribute("bookingSuccess", true);
     model.addAttribute("bookingMessage", "Booking confirmed successfully! Salon will assign a stylist soon.");
     model.addAttribute("finalPrice", finalPrice);

     return "user/user-salon-view";
 }

	/*-------------------------------------------------------------------------------------------------*/
	@GetMapping("/salon/viewServicesForUser")
	public String viewAllServicesForUser(Model model) {
	    List<Service1> serviceList = serviceService.getAllServicesWithSalonDetails();
	    model.addAttribute("serviceList", serviceList);
	    return "user/view-service"; // JSP name
	}
}
