package in.sp.main.Controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.ServiceCategory;
import in.sp.main.Entities.Stylist;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.SalonService;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceRepository;
import in.sp.main.Repository.StylistRepository;
import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.Optional;

@Controller
public class SalonController {

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private FileUploadService fileUploadService;
    
    @Autowired
    private in.sp.main.Service.PasswordService passwordService;
    
    @Autowired
    private StylistRepository stylistRepository;
    
    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private SalonService salonservice;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Value("${app.upload.profile-image.max-size-mb:2}")
    private int profileImageMaxSizeMb;

    @Value("${app.upload.profile-image.accepted:JPG, JPEG, PNG}")
    private String profileImageAccepted;

    // Show registration form
    @GetMapping("/salons/register")
    public String showSalonRegister() {
        return "salon/salon-register";
    }

    // Handle registration
    @PostMapping("/salons/register")
    public String registerSalon(
            @RequestParam("name") String name,
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            @RequestParam("hygieneCertificate") MultipartFile hygieneCertificate,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "availabilityHours", required = false) String availabilityHours,
            Model model) {

        String cleanedName = name == null ? "" : name.trim();
        String cleanedUsername = username == null ? "" : username.trim();
        String cleanedEmail = email == null ? "" : email.trim().toLowerCase();
        String cleanedPhone = phone == null ? "" : phone.trim();

        if (cleanedName.length() < 3) {
            model.addAttribute("error", "Salon name must be at least 3 characters.");
            return "salon/salon-register";
        }
        if (cleanedName.length() > Salon.NAME_MAX_LENGTH) {
            model.addAttribute("error",
                    "Salon name cannot exceed " + Salon.NAME_MAX_LENGTH + " characters.");
            return "salon/salon-register";
        }
        if (!cleanedUsername.matches(Salon.USERNAME_PATTERN)) {
            model.addAttribute("error",
                    "Username must be 3–20 characters and may only contain letters, numbers, and underscores (no spaces or special characters).");
            return "salon/salon-register";
        }
        if (salonRepository.findByUsername(cleanedUsername).isPresent()) {
            model.addAttribute("error", "Username is already taken. Please choose another.");
            return "salon/salon-register";
        }
        if (cleanedEmail.isEmpty() || cleanedEmail.length() > Salon.EMAIL_MAX_LENGTH
                || !cleanedEmail.matches(Salon.EMAIL_PATTERN)) {
            model.addAttribute("error", "Please enter a valid email address.");
            return "salon/salon-register";
        }
        if (!cleanedPhone.matches(Salon.PHONE_PATTERN)) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "salon/salon-register";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match!");
            return "salon/salon-register";
        }

        try {
            String hygieneCertificateUrl = fileUploadService.saveFile(hygieneCertificate);

            Salon salon = new Salon();
            salon.setName(cleanedName);
            salon.setUsername(cleanedUsername);
            salon.setEmail(cleanedEmail);
            salon.setPhone(cleanedPhone);
            salon.setPassword(passwordService.encode(password));
            salon.setHygieneCertificateUrl(hygieneCertificateUrl);
            salon.setBio(bio);
            salon.setAvailabilityHours(availabilityHours);

            salonRepository.save(salon);

            return "redirect:/salons/login"; // redirect to login page

        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to upload hygiene certificate.");
            return "salon/salon-register";
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("error", "Username is already taken. Please choose another.");
            return "salon/salon-register";
        }
    }

    // Optional: Salon login page
    @GetMapping("/salons/login")
    public String showSalonLogin() {
        return "salon/salon-login";
    }
    @PostMapping("/salons/login")
    public String loginSalon(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            jakarta.servlet.http.HttpServletResponse response,
            Model model) {

        Optional<Salon> salonOpt = salonRepository.findByUsername(username);

        if (salonOpt.isPresent()) {
            Salon salon = salonOpt.get();

            if (passwordService.matchesAndUpgrade(password, salon.getPassword(), hashed -> {
                salon.setPassword(hashed);
                salonRepository.save(salon);
            })) {
                if (!salon.isApproved()) {
                    model.addAttribute("error", "Your account is pending admin approval. Please wait for the physical business audit.");
                    return "salon/salon-login";
                }
                // Clear user/other portals so contact/header "My Dashboard" routes to salon correctly
                session.removeAttribute("user");
                session.removeAttribute("loggedDoctor");
                session.removeAttribute("loggedStylist");
                session.removeAttribute("loggedProvider");
                session.removeAttribute("loggedCentre");
                session.removeAttribute("loggedSeller");
                session.removeAttribute("admin");
                session.setAttribute("loggedSalon", salon);
                
                // Generate JWT and add to response
                String token = jwtUtil.generateToken(salon.getUsername(), "SALON");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
                response.addCookie(cookie);
                
                return "redirect:/salons/dashboard";
            } else {
                model.addAttribute("error", "Invalid password");
                return "salon/salon-login";
            }
        } else {
            model.addAttribute("error", "Salon not found with this username");
            return "salon/salon-login";
        }
    }
    @GetMapping("/salons/logout")
    public String logoutSalon(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {

        // Remove salon session
        session.removeAttribute("loggedSalon");

        // Invalidate entire session
        session.invalidate();

        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);

        // Redirect to login page
        return "redirect:/salons/login";
    }

    @GetMapping("/salons/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }
        model.addAttribute("salon", loggedSalon);
        return "salon/salon-dashboard";
    }
 // View profile page
    @GetMapping("/salons/profile")
    public String viewProfile(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");

        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        // Fetch fresh data from DB
        Optional<Salon> salonOpt = salonRepository.findById(loggedSalon.getId());
        
        if (salonOpt.isEmpty()) {
            session.invalidate();
            return "redirect:/salons/login";
        }
        if (salonOpt.isPresent()) {
            model.addAttribute("salon", salonOpt.get());
            addProfileImageUploadHints(model);
            return "salon/salon-profile"; // loads profile.jsp
        }

        return "redirect:/salons/login";
    }

    private void addProfileImageUploadHints(Model model) {
        model.addAttribute("profileImageMaxSizeMb", profileImageMaxSizeMb);
        model.addAttribute("profileImageAccepted", profileImageAccepted);
        model.addAttribute("profileImageMaxBytes", profileImageMaxSizeMb * 1024L * 1024L);
    }

    private long profileImageMaxBytes() {
        return profileImageMaxSizeMb * 1024L * 1024L;
    }

    // Update profile
    @PostMapping("/salons/updateProfile")
    public String updateProfile(
            @RequestParam("id") Long id,
            @RequestParam("name") String name,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "establishedYear", required = false) String establishedYearRaw,
            @RequestParam(value = "website", required = false) String website,
            @RequestParam(value = "availabilityHours", required = false) String availabilityHours,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            HttpSession session,
            Model model) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }
        if (id == null || !id.equals(loggedSalon.getId())) {
            model.addAttribute("error", "Unauthorized profile update.");
            return "redirect:/salons/profile";
        }

        Optional<Salon> salonOpt = salonRepository.findById(id);
        if (salonOpt.isEmpty()) {
            model.addAttribute("error", "Salon not found!");
            return "redirect:/salons/login";
        }

        Salon salon = salonOpt.get();
        String cleanedName = name == null ? "" : name.trim();
        String cleanedEmail = email == null ? "" : email.trim().toLowerCase();
        String cleanedPhone = phone == null ? "" : phone.trim();
        String cleanedAddress = address == null ? "" : address.trim();
        String cleanedCity = city == null ? "" : city.trim();
        String cleanedState = state == null ? "" : state.trim();
        String cleanedPincode = pincode == null ? "" : pincode.trim();
        String cleanedBio = bio == null ? "" : bio.trim();
        String cleanedWebsite = website == null ? "" : website.trim();
        String cleanedHours = availabilityHours == null ? "" : availabilityHours.trim();
        String cleanedYearRaw = establishedYearRaw == null ? "" : establishedYearRaw.trim();

        if (cleanedName.length() < 3 || cleanedName.length() > Salon.NAME_MAX_LENGTH) {
            return profileFormError(model, salon, "Salon name must be 3–" + Salon.NAME_MAX_LENGTH + " characters.");
        }
        if (cleanedEmail.isEmpty() || cleanedEmail.length() > Salon.EMAIL_MAX_LENGTH
                || !cleanedEmail.matches(Salon.EMAIL_PATTERN)) {
            return profileFormError(model, salon, "Please enter a valid email address.");
        }
        if (!cleanedPhone.matches(Salon.PHONE_PATTERN)) {
            return profileFormError(model, salon, "Phone number must be exactly 10 digits.");
        }
        if (cleanedAddress.isEmpty()) {
            return profileFormError(model, salon, "Full Address is required.");
        }
        if (cleanedAddress.length() > Salon.ADDRESS_MAX_LENGTH) {
            return profileFormError(model, salon, "Address cannot exceed " + Salon.ADDRESS_MAX_LENGTH + " characters.");
        }
        if (cleanedCity.isEmpty() || cleanedCity.length() < Salon.CITY_STATE_MIN_LENGTH) {
            return profileFormError(model, salon, "City is required (at least " + Salon.CITY_STATE_MIN_LENGTH + " characters).");
        }
        if (cleanedCity.length() > Salon.CITY_STATE_MAX_LENGTH) {
            return profileFormError(model, salon, "City cannot exceed " + Salon.CITY_STATE_MAX_LENGTH + " characters.");
        }
        if (cleanedState.isEmpty() || cleanedState.length() < Salon.CITY_STATE_MIN_LENGTH) {
            return profileFormError(model, salon, "State is required (at least " + Salon.CITY_STATE_MIN_LENGTH + " characters).");
        }
        if (cleanedState.length() > Salon.CITY_STATE_MAX_LENGTH) {
            return profileFormError(model, salon, "State cannot exceed " + Salon.CITY_STATE_MAX_LENGTH + " characters.");
        }
        if (!cleanedPincode.isEmpty() && !cleanedPincode.matches(Salon.PINCODE_PATTERN)) {
            return profileFormError(model, salon, "Pincode must be exactly " + Salon.PINCODE_LENGTH + " digits.");
        }
        if (cleanedBio.length() > Salon.BIO_MAX_LENGTH) {
            return profileFormError(model, salon, "Bio cannot exceed " + Salon.BIO_MAX_LENGTH + " characters.");
        }
        if (cleanedWebsite.length() > Salon.WEBSITE_MAX_LENGTH) {
            return profileFormError(model, salon, "Website URL cannot exceed " + Salon.WEBSITE_MAX_LENGTH + " characters.");
        }
        if (!cleanedWebsite.isEmpty()
                && !cleanedWebsite.matches("^(https?://)?([\\w-]+\\.)+[\\w-]+(/\\S*)?$")) {
            return profileFormError(model, salon, "Please enter a valid website URL.");
        }
        if (cleanedHours.length() > Salon.HOURS_MAX_LENGTH) {
            return profileFormError(model, salon, "Working hours cannot exceed " + Salon.HOURS_MAX_LENGTH + " characters.");
        }

        Integer establishedYear = null;
        int currentYear = java.time.Year.now().getValue();
        if (!cleanedYearRaw.isEmpty()) {
            if (!cleanedYearRaw.matches(Salon.ESTABLISHED_YEAR_PATTERN)) {
                return profileFormError(model, salon, "Established Year must be exactly 4 digits.");
            }
            establishedYear = Integer.parseInt(cleanedYearRaw);
            if (establishedYear < Salon.ESTABLISHED_YEAR_MIN || establishedYear > currentYear) {
                return profileFormError(model, salon,
                        "Established Year must be between " + Salon.ESTABLISHED_YEAR_MIN + " and " + currentYear + ".");
            }
        }

        salon.setName(cleanedName);
        salon.setEmail(cleanedEmail);
        salon.setPhone(cleanedPhone);
        salon.setAddress(cleanedAddress);
        salon.setCity(cleanedCity);
        salon.setState(cleanedState);
        salon.setPincode(cleanedPincode.isEmpty() ? null : cleanedPincode);
        salon.setBio(cleanedBio.isEmpty() ? null : cleanedBio);
        salon.setEstablishedYear(establishedYear);
        salon.setWebsite(cleanedWebsite.isEmpty() ? null : cleanedWebsite);
        salon.setAvailabilityHours(cleanedHours.isEmpty() ? null : cleanedHours);

        if (profileImage != null && !profileImage.isEmpty()) {
            String imageError = fileUploadService.validatePngOrJpegImage(profileImage, profileImageMaxBytes());
            if (imageError != null) {
                return profileFormError(model, salon, imageError);
            }
            try {
                String profileImageUrl = fileUploadService.saveFile(profileImage);
                salon.setProfileImageUrl(profileImageUrl);
            } catch (Exception e) {
                e.printStackTrace();
                return profileFormError(model, salon, "Failed to upload profile image.");
            }
        }

        salonRepository.save(salon);
        session.setAttribute("loggedSalon", salon);
        model.addAttribute("salon", salon);
        addProfileImageUploadHints(model);
        model.addAttribute("message", "Profile updated successfully!");
        return "salon/salon-profile";
    }

    private String profileFormError(Model model, Salon salon, String error) {
        model.addAttribute("salon", salon);
        addProfileImageUploadHints(model);
        model.addAttribute("error", error);
        return "salon/salon-profile";
    }

    // Delete profile
    @PostMapping("/salons/deleteProfile")
    public String deleteProfile(@RequestParam Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        try {
            salonservice.deleteSalon(id); // actual deletion
            session.invalidate(); // remove session after successful deletion
            redirectAttributes.addFlashAttribute("successMessage", "Profile deleted successfully!");
            return "redirect:/salons/login";
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Cannot delete profile because some bookings or services exist!");
            return "redirect:/salons/profile"; // stay on profile page
        }
    }


 // ===========================
 // Add Stylist form
 // ===========================
 @GetMapping("/addStylist")
 public String showAddStylistForm(HttpSession session, Model model) {
     Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
     if (loggedSalon == null) return "redirect:/salons/login";

     model.addAttribute("stylist", new Stylist());
     model.addAttribute("salon", loggedSalon);
     return "salon/salon-add-stylist";
 }

 // ===========================
 // Save Stylist
 // ===========================
 @PostMapping("/saveStylist")
 public String saveStylist(@RequestParam("firstName") String firstName,
                           @RequestParam("lastName") String lastName,
                           @RequestParam("email") String email,
                           @RequestParam("password") String password,
                           @RequestParam(value = "specialization", required = false) String specialization,
                           @RequestParam(value = "experienceInYears", required = false) Integer experienceInYears,
                           @RequestParam(value = "contactNumber", required = false) String contactNumber,
                           @RequestParam(value = "bio", required = false) String bio,
                           @RequestParam(value = "availabilityHours", required = false) String availabilityHours,
                           @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
                           HttpSession session,
                           Model model) {

     Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
     if (loggedSalon == null) return "redirect:/salons/login";

     if (email == null || password == null) {
         model.addAttribute("error", "Email and Password are required.");
         return "salon/salon-add-stylist";
     }

     Stylist stylist = new Stylist();
     stylist.setFirstName(firstName);
     stylist.setLastName(lastName);
     stylist.setEmail(email);
     stylist.setPassword(passwordService.encode(password));
     stylist.setSpecialization(specialization);
     stylist.setExperienceInYears(experienceInYears);
     stylist.setContactNumber(contactNumber);
     stylist.setBio(bio);
     stylist.setAvailabilityHours(availabilityHours);
     stylist.setSalon(loggedSalon);
     stylist.setAvailable(true);
     stylist.setRating(0.0);
     stylist.setIsIndependent(false);
     stylist.setApproved(false); // New stylists added by salon also need admin approval

     // Optional profile image
     if (profileImage != null && !profileImage.isEmpty()) {
         try {
             String profileImageUrl = fileUploadService.saveFile(profileImage);
             stylist.setProfileImage(profileImageUrl);
         } catch (IOException e) {
             e.printStackTrace();
             model.addAttribute("error", "Failed to upload profile image.");
             return "salon/salon-add-stylist";
         }
     }

     stylistRepository.save(stylist);
     model.addAttribute("message", "Stylist added successfully!");
     return "redirect:/myStylists";
 }

    // ===========================
    // 3️⃣ List all stylists of this salon
    // ===========================
    @GetMapping("/myStylists")
    public String listSalonStylists(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<Stylist> stylists = stylistRepository.findBySalonId(loggedSalon.getId());
        model.addAttribute("stylists", stylists);
        return "salon/salon-stylist-list"; // JSP page
    }

    // ===========================
    // 4️⃣ View a Stylist profile
    // ===========================
    @GetMapping("/stylist/view")
    public String viewStylist(@RequestParam("id") Long stylistId,
                              HttpSession session,
                              Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<Stylist> stylistOpt = stylistRepository.findById(stylistId);
        if (stylistOpt.isPresent()) {
            Stylist stylist = stylistOpt.get();

            // Only salon's own stylists
            if (stylist.getSalon() != null && stylist.getSalon().getId().equals(loggedSalon.getId())) {
                model.addAttribute("stylist", stylist);
                return "salon/salon-stylist-view"; // JSP page
            } else {
                model.addAttribute("error", "You cannot view this stylist.");
                return "redirect:/salons/myStylists";
            }
        }
        model.addAttribute("error", "Stylist not found.");
        return "redirect:/salons/myStylists";
    }

    // ===========================
    // 5️⃣ Optional: Delete stylist
    // ===========================
    @GetMapping("/stylist/delete")
    public String deleteStylist(@RequestParam("id") Long stylistId,
                                HttpSession session,
                                Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<Stylist> stylistOpt = stylistRepository.findById(stylistId);
        if (stylistOpt.isPresent()) {
            Stylist stylist = stylistOpt.get();
            if (stylist.getSalon() != null && stylist.getSalon().getId().equals(loggedSalon.getId())) {
                stylistRepository.delete(stylist);
            }
        }

        return "redirect:/salons/myStylists";
    }
	/*--------------------------------------------------------------------------------------------------*/
    
    @GetMapping("/salon/addService")
    public String showAddServiceForm(Model model) {
        model.addAttribute("service", new Service1());
        model.addAttribute("categories", ServiceCategory.values());
        return "salon/add-services";
    }
 // Handle Add Service
    @PostMapping("/salon/addService")
    public String addService(@ModelAttribute Service1 service,
                             @RequestParam("photo") MultipartFile photo,
                             HttpSession session, Model model) throws IOException {
 
        Salon salon = (Salon) session.getAttribute("loggedSalon");
        if (salon != null) {
            service.setSalon(salon);
 
            if (photo != null && !photo.isEmpty()) {
                String photoUrl = fileUploadService.saveFile(photo);
                service.setPhotoUrl(photoUrl);
            }
 
            serviceRepository.save(service);
            return "redirect:/salon/viewServices";
        }
 
        model.addAttribute("error", "Salon not logged in");
        return "salon/add-services";
    }
 
 
    // View All Services
    @GetMapping("/salon/viewServices")
    public String viewServices(@RequestParam(value = "category", required = false) String categoryStr,
                               HttpSession session,
                               Model model) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        Long salonId = loggedSalon.getId(); // ✅ ONLY use ID

        List<Service1> services;

        if (categoryStr == null || categoryStr.isEmpty() || categoryStr.equalsIgnoreCase("ALL")) {
            services = serviceRepository.findBySalonId(salonId);
        } else {
            try {
                ServiceCategory category = ServiceCategory.valueOf(categoryStr.toUpperCase());
                services = serviceRepository.findBySalonIdAndCategory(salonId, category);
            } catch (IllegalArgumentException e) {
                services = serviceRepository.findBySalonId(salonId);
            }
        }

        model.addAttribute("services", services);
        model.addAttribute("selectedCategory",
                categoryStr != null ? categoryStr.toUpperCase() : "ALL");
        model.addAttribute("categories", ServiceCategory.values());

        return "salon/view-services";
    }

 
    // Edit Service Form
    @GetMapping("/salon/editService/{id}")
    public String editServiceForm(@PathVariable Long id, Model model) {
        Optional<Service1> serviceOpt = serviceRepository.findById(id);
        if (serviceOpt.isPresent()) {
            model.addAttribute("service", serviceOpt.get());
            model.addAttribute("categories", ServiceCategory.values());
            return "salon/add-services"; // reuse add-service.jsp for editing
        }
        return "redirect:/salon/viewServices";
    }
 
    // Delete Service
   
    
  
    @PostMapping("/salon/deleteService")
    public String deleteService(@RequestParam Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) {
            return "redirect:/salons/login";
        }

        try {
        	 salonservice.deleteService(id, loggedSalon.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Service deleted successfully!");
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                "Cannot delete this service because it has existing bookings!");
        }

        return "redirect:/salon/viewServices";
    }


    @GetMapping("/services/search")
    public String searchServices(@RequestParam("category") String categoryStr, HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        List<Service1> services;
 
        if (categoryStr == null || categoryStr.isEmpty() || categoryStr.equalsIgnoreCase("ALL")) {
            // Show all services
            services = serviceRepository.findBySalon(loggedSalon);
        } else {
            try {
                // Convert string to enum
                ServiceCategory category = ServiceCategory.valueOf(categoryStr.toUpperCase());
                services = serviceRepository.findBySalonAndCategory(loggedSalon, category);
            } catch (IllegalArgumentException e) {
                // Invalid category sent, fallback to all
                services = serviceRepository.findBySalon(loggedSalon);
            }
        }
 
        model.addAttribute("services", services);
        return "salon/view-services";
    }
}

