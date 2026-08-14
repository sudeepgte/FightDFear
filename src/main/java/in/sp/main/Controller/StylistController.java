package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
@RequestMapping({"/stylists", "/stylist"})
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

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;

    @Value("${app.upload.profile-image.max-size-mb:2}")
    private int profileImageMaxSizeMb;

    @Value("${app.upload.profile-image.accepted:JPG, JPEG, PNG}")
    private String profileImageAccepted;

    private long profileImageMaxBytes() {
        return profileImageMaxSizeMb * 1024L * 1024L;
    }

    private void addProfileImageUploadHints(Model model) {
        model.addAttribute("profileImageMaxSizeMb", profileImageMaxSizeMb);
        model.addAttribute("profileImageAccepted", profileImageAccepted);
        model.addAttribute("profileImageMaxBytes", profileImageMaxBytes());
    }

    // ==============================
    // 1️⃣ Stylist Registration (self-register)
    // ==============================
    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        model.addAttribute("stylist", new Stylist());
        addProfileImageUploadHints(model);
        return "stylist/stylist-register";
    }

    @PostMapping("/register")
    public String registerStylist(@ModelAttribute Stylist stylist,
                                  @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImageFile,
                                  Model model) {
        addProfileImageUploadHints(model);

        String firstName = stylist.getFirstName() == null ? "" : stylist.getFirstName().trim();
        String lastName = stylist.getLastName() == null ? "" : stylist.getLastName().trim();
        String email = stylist.getEmail() == null ? "" : stylist.getEmail().trim().toLowerCase();
        String phone = stylist.getContactNumber() == null ? "" : stylist.getContactNumber().trim();
        String specialization = stylist.getSpecialization() == null ? "" : stylist.getSpecialization().trim();
        String password = stylist.getPassword() == null ? "" : stylist.getPassword();

        if (!firstName.matches(Stylist.NAME_PATTERN)) {
            model.addAttribute("error", "First name must be 2–50 letters (spaces/hyphens allowed).");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        if (!lastName.matches(Stylist.NAME_PATTERN)) {
            model.addAttribute("error", "Last name must be 2–50 letters (spaces/hyphens allowed).");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        if (email.isEmpty() || email.length() > Stylist.EMAIL_MAX_LENGTH || !email.matches(Stylist.EMAIL_PATTERN)) {
            model.addAttribute("error", "Please enter a valid email address.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        if (!phone.matches(Stylist.PHONE_PATTERN)) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        if (password.length() < 6 || password.length() > 8
                || !password.matches(".*[A-Z].*") || !password.matches(".*\\d.*")) {
            model.addAttribute("error", "Password must be 6–8 characters with at least 1 uppercase letter and 1 number.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        if (specialization.length() < 3 || specialization.length() > Stylist.SPECIALIZATION_MAX_LENGTH) {
            model.addAttribute("error", "Specialization must be 3–" + Stylist.SPECIALIZATION_MAX_LENGTH + " characters.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }
        Integer exp = stylist.getExperienceInYears();
        if (exp == null || exp < 0 || exp > 50) {
            model.addAttribute("error", "Experience must be between 0 and 50 years.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }

        if (stylistRepository.findByEmail(email).isPresent()) {
            model.addAttribute("error", "Email already registered. Choose another.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-register";
        }

        if (profileImageFile != null && !profileImageFile.isEmpty()) {
            String imageError = fileUploadService.validatePngOrJpegImage(profileImageFile, profileImageMaxBytes());
            if (imageError != null) {
                model.addAttribute("error", imageError);
                model.addAttribute("stylist", stylist);
                return "stylist/stylist-register";
            }
            try {
                stylist.setProfileImage(fileUploadService.saveFile(profileImageFile));
            } catch (Exception e) {
                model.addAttribute("error", "Failed to upload profile photo. Please try again.");
                model.addAttribute("stylist", stylist);
                return "stylist/stylist-register";
            }
        }

        stylist.setFirstName(firstName);
        stylist.setLastName(lastName);
        stylist.setEmail(email);
        stylist.setContactNumber(phone);
        stylist.setSpecialization(specialization);
        stylist.setPassword(passwordService.encode(password));
        stylist.setAvailable(true);
        stylist.setRating(0.0);
        stylist.setIsIndependent(true);
        stylist.setApproved(false);
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
            if (passwordService.matchesAndUpgrade(password, stylist.getPassword(), hashed -> {
                stylist.setPassword(hashed);
                stylistRepository.save(stylist);
            })) {
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
        model.addAttribute("isAvailable", Boolean.TRUE.equals(stylist.getAvailable()));

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
            if (booking.getStylist() == null || !booking.getStylist().getId().equals(stylist.getId())) {
                return "redirect:/stylists/dashboard";
            }
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
            if (booking.getStylist() == null || !booking.getStylist().getId().equals(stylist.getId())) {
                return "redirect:/stylists/dashboard";
            }
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
            if (booking.getStylist() != null && booking.getStylist().getId().equals(stylist.getId())) {
                booking.setStatus(BookingStatus.COMPLETED);
                bookingRepository.save(booking);
            }
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
        addProfileImageUploadHints(model);
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
        if (stylistOpt.isEmpty()) {
            model.addAttribute("error", "Stylist not found!");
            return "stylist/stylist-profile";
        }

        Stylist stylist = stylistOpt.get();
        addProfileImageUploadHints(model);

        String firstName = updatedStylist.getFirstName() == null ? "" : updatedStylist.getFirstName().trim();
        String lastName = updatedStylist.getLastName() == null ? "" : updatedStylist.getLastName().trim();
        String email = updatedStylist.getEmail() == null ? "" : updatedStylist.getEmail().trim().toLowerCase();
        String phone = updatedStylist.getContactNumber() == null ? "" : updatedStylist.getContactNumber().trim();
        String specialization = updatedStylist.getSpecialization() == null ? "" : updatedStylist.getSpecialization().trim();
        String bio = updatedStylist.getBio() == null ? "" : updatedStylist.getBio().trim();
        String hours = updatedStylist.getAvailabilityHours() == null ? "" : updatedStylist.getAvailabilityHours().trim();

        if (!firstName.matches(Stylist.NAME_PATTERN)) {
            model.addAttribute("error", "First name must be 2–50 letters (spaces/hyphens allowed).");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (!lastName.matches(Stylist.NAME_PATTERN)) {
            model.addAttribute("error", "Last name must be 2–50 letters (spaces/hyphens allowed).");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (email.isEmpty() || email.length() > Stylist.EMAIL_MAX_LENGTH || !email.matches(Stylist.EMAIL_PATTERN)) {
            model.addAttribute("error", "Please enter a valid email address.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (!phone.matches(Stylist.PHONE_PATTERN)) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (!specialization.isEmpty() && specialization.length() > Stylist.SPECIALIZATION_MAX_LENGTH) {
            model.addAttribute("error", "Specialization cannot exceed " + Stylist.SPECIALIZATION_MAX_LENGTH + " characters.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        Integer exp = updatedStylist.getExperienceInYears();
        if (exp != null && (exp < 0 || exp > 50)) {
            model.addAttribute("error", "Experience must be between 0 and 50 years.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (bio.length() > Stylist.BIO_MAX_LENGTH) {
            model.addAttribute("error", "Bio cannot exceed " + Stylist.BIO_MAX_LENGTH + " characters.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }
        if (hours.length() > Stylist.AVAILABILITY_HOURS_MAX_LENGTH) {
            model.addAttribute("error", "Availability hours cannot exceed " + Stylist.AVAILABILITY_HOURS_MAX_LENGTH + " characters.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }

        Optional<Stylist> emailOwner = stylistRepository.findByEmail(email);
        if (emailOwner.isPresent() && !emailOwner.get().getId().equals(stylist.getId())) {
            model.addAttribute("error", "That email is already used by another stylist.");
            model.addAttribute("stylist", stylist);
            return "stylist/stylist-profile";
        }

        if (profileImageFile != null && !profileImageFile.isEmpty()) {
            String imageError = fileUploadService.validatePngOrJpegImage(profileImageFile, profileImageMaxBytes());
            if (imageError != null) {
                model.addAttribute("error", imageError);
                model.addAttribute("stylist", stylist);
                return "stylist/stylist-profile";
            }
            try {
                stylist.setProfileImage(fileUploadService.saveFile(profileImageFile));
            } catch (Exception e) {
                model.addAttribute("error", "Error uploading profile image. Please try again.");
                model.addAttribute("stylist", stylist);
                return "stylist/stylist-profile";
            }
        }

        stylist.setFirstName(firstName);
        stylist.setLastName(lastName);
        stylist.setSpecialization(specialization);
        stylist.setExperienceInYears(exp != null ? exp : stylist.getExperienceInYears());
        stylist.setContactNumber(phone);
        stylist.setEmail(email);
        stylist.setBio(bio.isEmpty() ? null : bio);
        stylist.setAvailabilityHours(hours.isEmpty() ? null : hours);
        stylist.setIsIndependent(updatedStylist.getIsIndependent() != null ? updatedStylist.getIsIndependent() : stylist.getIsIndependent());

        stylistRepository.save(stylist);
        session.setAttribute("loggedStylist", stylist);
        model.addAttribute("stylist", stylist);
        model.addAttribute("message", "Profile updated successfully!");
        return "stylist/stylist-profile";
    }



    // ==============================
    // 7️⃣ Toggle Availability
    // ==============================
    @GetMapping("/toggleAvailability")
    public String toggleAvailabilityGet(HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        return toggleAvailability(session, ra);
    }

    @PostMapping("/toggleAvailability")
    public String toggleAvailabilityPost(HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        return toggleAvailability(session, ra);
    }

    private String toggleAvailability(HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        Stylist sessionStylist = (Stylist) session.getAttribute("loggedStylist");
        if (sessionStylist == null) return "redirect:/stylists/login";

        Stylist stylist = stylistRepository.findById(sessionStylist.getId()).orElse(null);
        if (stylist == null) {
            ra.addFlashAttribute("error", "Unable to update status. Please sign in again.");
            return "redirect:/stylists/login";
        }

        Boolean current = stylist.getAvailable();
        boolean next = current == null || !current;
        stylist.setAvailable(next);
        stylistRepository.save(stylist);
        session.setAttribute("loggedStylist", stylist);
        ra.addFlashAttribute("statusMessage",
                next ? "You are now accepting requests." : "You are now offline.");
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
