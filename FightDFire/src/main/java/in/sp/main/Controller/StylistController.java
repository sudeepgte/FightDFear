package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Entities.Booking;
import in.sp.main.Entities.BookingStatus;
import in.sp.main.Entities.Review;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.BookingRepository;
import in.sp.main.Repository.ReviewRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/stylists")
public class StylistController {

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private ReviewRepository reviewRepository;
    
    @Autowired
    private FileUploadService fileUploadService;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;


    // ==============================
    // 1️⃣ Stylist Registration (self-register)
    // ==============================
    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        model.addAttribute("stylist", new Stylist());
        return "stylist/stylist-register";
    }

    @PostMapping("/register")
    public String registerStylist(@ModelAttribute Stylist stylist, Model model) {
        if (stylistRepository.findByEmail(stylist.getEmail()).isPresent()) {
            model.addAttribute("error", "Email already registered. Choose another.");
            return "stylist/stylist-register";
        }
        stylist.setAvailable(true);
        stylist.setRating(0.0);
        stylist.setIsIndependent(true); // Self-registered stylist
        stylist.setApproved(false); // Explicitly set to false for verification
        stylistRepository.save(stylist);
        model.addAttribute("message", "Registration successful! Your account is pending admin approval.");
        return "stylist/stylist-login";
    }

    // ==============================
    // 2️⃣ Stylist Login
    // ==============================
    @GetMapping("/login")
    public String showLoginPage() {
        return "stylist/stylist-login";
    }

    @PostMapping("/login")
    public String loginStylist(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session,
                               jakarta.servlet.http.HttpServletResponse response,
                               Model model) {
        Optional<Stylist> stylistOpt = stylistRepository.findByEmail(email);
        if (stylistOpt.isPresent()) {
            Stylist stylist = stylistOpt.get();
            if (stylist.getPassword().equals(password)) {
                if (!stylist.isApproved()) {
                    model.addAttribute("error", "Your account is pending admin approval. Access denied.");
                    return "stylist/stylist-login";
                }
                session.setAttribute("loggedStylist", stylist);
                
                // Generate JWT and add to response
                String token = jwtUtil.generateToken(stylist.getEmail(), "STYLIST");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
                response.addCookie(cookie);
                
                return "redirect:/stylists/dashboard";
            } else {
                model.addAttribute("error", "Invalid password");
                return "stylist/stylist-login";
            }
        }
        model.addAttribute("error", "Stylist not found");
        return "stylist/stylist-login";
    }

    // ==============================
    // 3️⃣ Stylist Dashboard
    // ==============================
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        stylist = stylistRepository.findById(stylist.getId()).orElse(stylist);

        List<Booking> bookings = bookingRepository.findByStylistId(stylist.getId());
        List<Booking> pendingBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.PENDING)
            .toList();
        List<Booking> confirmedBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.CONFIRMED)
            .toList();
        List<Booking> completedBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.COMPLETED)
            .toList();

        double totalRevenue = completedBookings.stream()
            .mapToDouble(b -> b.getPricePaid() != null ? b.getPricePaid() : 0)
            .sum();

        model.addAttribute("stylist", stylist);
        model.addAttribute("pendingBookings", pendingBookings);
        model.addAttribute("confirmedBookings", confirmedBookings);
        model.addAttribute("completedBookings", completedBookings);
        model.addAttribute("totalRevenue", totalRevenue);

        session.setAttribute("loggedStylist", stylist);
        return "stylist/stylist-dashboard";
    }

    // ==============================
    // 4️⃣ Assign Available Timing for Booking (Confirm)
    // ==============================
    @PostMapping("/booking/confirm")
    public String confirmBooking(@RequestParam Long bookingId,
                                 HttpSession session) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        Optional<Booking> bookingOpt = bookingRepository.findById(bookingId);
        if (bookingOpt.isPresent()) {
            Booking booking = bookingOpt.get();
            booking.setStatus(BookingStatus.CONFIRMED);
            bookingRepository.save(booking);
        }
        return "redirect:/stylists/dashboard";
    }
    @PostMapping("/booking/reject")
    public String rejectBooking(@RequestParam Long bookingId,
                                HttpSession session) {

        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        Optional<Booking> bookingOpt = bookingRepository.findById(bookingId);
        if (bookingOpt.isPresent()) {
            Booking booking = bookingOpt.get();
            booking.setStatus(BookingStatus.REJECTED);
            bookingRepository.save(booking);
        }
        return "redirect:/stylists/dashboard";
    }

    @PostMapping("/booking/complete")
    public String completeBooking(@RequestParam Long bookingId, HttpSession session, Model model) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        bookingRepository.findById(bookingId).ifPresent(booking -> {
            booking.setStatus(BookingStatus.COMPLETED);
            bookingRepository.save(booking);
        });

        // Reload all bookings after completion
        List<Booking> bookings = bookingRepository.findByStylistId(stylist.getId());
        List<Booking> pendingBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.PENDING)
            .toList();
        List<Booking> confirmedBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.CONFIRMED)
            .toList();
        List<Booking> completedBookings = bookings.stream()
            .filter(b -> b.getStatus() == BookingStatus.COMPLETED)
            .toList();

        double totalRevenue = completedBookings.stream()
            .mapToDouble(b -> b.getPricePaid() != null ? b.getPricePaid() : 0)
            .sum();

        model.addAttribute("stylist", stylist);
        model.addAttribute("pendingBookings", pendingBookings);
        model.addAttribute("confirmedBookings", confirmedBookings);
        model.addAttribute("completedBookings", completedBookings);
        model.addAttribute("totalRevenue", totalRevenue);

        return "stylist/stylist-dashboard";
    }

    // ==============================
    // 6️⃣ Update Stylist Profile
    // ==============================
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
        if (stylist == null) return "redirect:/stylists/login";

        model.addAttribute("stylist", stylistRepository.findById(stylist.getId()).orElse(stylist));
        return "stylist/stylist-profile";
    }

    // ✅ Update Profile
    @PostMapping("/profile/update")
    public String updateProfile(
            @ModelAttribute Stylist updatedStylist,
            @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImageFile,
            HttpSession session,
            Model model) {

        Stylist loggedStylist = (Stylist) session.getAttribute("loggedStylist");
        if (loggedStylist == null) {
            return "redirect:/stylists/login";
        }

        Optional<Stylist> stylistOpt = stylistRepository.findById(loggedStylist.getId());

        if (stylistOpt.isPresent()) {
            Stylist stylist = stylistOpt.get();

            // ✅ Update fields
            stylist.setFirstName(updatedStylist.getFirstName());
            stylist.setLastName(updatedStylist.getLastName());
            stylist.setSpecialization(updatedStylist.getSpecialization());
            stylist.setExperienceInYears(updatedStylist.getExperienceInYears());
            stylist.setContactNumber(updatedStylist.getContactNumber());
            stylist.setEmail(updatedStylist.getEmail());
            stylist.setBio(updatedStylist.getBio());
            stylist.setAvailabilityHours(updatedStylist.getAvailabilityHours());
            stylist.setIsIndependent(updatedStylist.getIsIndependent() != null ? updatedStylist.getIsIndependent() : false);

            // ✅ File upload handled safely
            if (profileImageFile != null && !profileImageFile.isEmpty()) {
                try {
                    String uploadedUrl = fileUploadService.saveFile(profileImageFile);
                    stylist.setProfileImage(uploadedUrl);
                } catch (Exception e) {
                    e.printStackTrace();
                    model.addAttribute("error", "❌ Error uploading profile image. Please try again.");
                }
            }

            stylistRepository.save(stylist);
            session.setAttribute("loggedStylist", stylist);
            model.addAttribute("stylist", stylist);
            model.addAttribute("message", "✅ Profile updated successfully!");

            return "stylist/stylist-profile";
        }

        model.addAttribute("error", "❌ Stylist not found!");
        return "stylist/stylist-profile";
    }



    // ==============================
    // 7️⃣ Toggle Availability
    // ==============================
    @GetMapping("/toggleAvailability")
    public String toggleAvailability(HttpSession session) {
        Stylist sessionStylist = (Stylist) session.getAttribute("loggedStylist");
        if (sessionStylist == null) return "redirect:/stylists/login";

        Stylist stylist = stylistRepository.findById(sessionStylist.getId()).orElse(null);
        if (stylist != null) {
            Boolean current = stylist.getAvailable();
            stylist.setAvailable(current == null ? true : !current);
            stylistRepository.save(stylist);
            session.setAttribute("loggedStylist", stylist);
        }
        return "redirect:/stylists/dashboard";
    }
 // ==============================
 // 9️⃣ View Reviews & Ratings
 // ==============================
 @GetMapping("/reviews")
 public String viewReviews(HttpSession session, Model model) {
     Stylist stylist = (Stylist) session.getAttribute("loggedStylist");
     if (stylist == null) return "redirect:/stylists/login";

     // Fetch stylist latest info
     stylist = stylistRepository.findById(stylist.getId()).orElse(stylist);

     // Get all reviews for this stylist
     List<Review> reviews = reviewRepository.findByStylistId(stylist.getId());

     // Calculate average rating
     double avgRating = reviews.isEmpty() ? 0.0 :
             reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
     stylist.setRating(avgRating);

     model.addAttribute("stylist", stylist);
     model.addAttribute("reviews", reviews);
     model.addAttribute("avgRating", avgRating);

     return "stylist/stylist-reviews";
 }

    // ==============================
    // 8️⃣ Logout
    // ==============================
    @GetMapping("/logout")
    public String logout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.invalidate();
        
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        return "redirect:/stylists/login";
    } 
}
