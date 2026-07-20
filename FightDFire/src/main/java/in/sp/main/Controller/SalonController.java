package in.sp.main.Controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
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
    private StylistRepository stylistRepository;
    
    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private SalonService salonservice;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

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
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            @RequestParam("hygieneCertificate") MultipartFile hygieneCertificate,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "availabilityHours", required = false) String availabilityHours,
            Model model) {

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match!");
            return "salon/salon-register";
        }

        try {
            String hygieneCertificateUrl = fileUploadService.saveFile(hygieneCertificate);

            Salon salon = new Salon();
            salon.setName(name);
            salon.setUsername(username); // store username
            salon.setPassword(password); // store password
            salon.setHygieneCertificateUrl(hygieneCertificateUrl);
            salon.setBio(bio);
            salon.setAvailabilityHours(availabilityHours);

            salonRepository.save(salon);

            return "redirect:/salons/login"; // redirect to login page

        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to upload hygiene certificate.");
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

            if (salon.getPassword().equals(password)) {
                if (!salon.isApproved()) {
                    model.addAttribute("error", "Your account is pending admin approval. Please wait for the physical business audit.");
                    return "salon/salon-login";
                }
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
            return "salon/salon-profile"; // loads profile.jsp
        }

        return "redirect:/salons/login";
    }

    // Update profile
    @PostMapping("/salons/updateProfile")
    public String updateProfile(
            @ModelAttribute Salon updatedSalon,
            @RequestParam("profileImage") MultipartFile profileImage,
            HttpSession session,
            Model model) {

        Optional<Salon> salonOpt = salonRepository.findById(updatedSalon.getId());

        if (salonOpt.isPresent()) {
            Salon salon = salonOpt.get();

            // Update basic info
            salon.setName(updatedSalon.getName());
            salon.setEmail(updatedSalon.getEmail());
            salon.setPhone(updatedSalon.getPhone());
            salon.setAddress(updatedSalon.getAddress());
            salon.setCity(updatedSalon.getCity());
            salon.setState(updatedSalon.getState());
            salon.setPincode(updatedSalon.getPincode());
            salon.setWebsite(updatedSalon.getWebsite());

            // Update optional fields
            salon.setLatitude(updatedSalon.getLatitude());
            salon.setLongitude(updatedSalon.getLongitude());
            salon.setAverageRating(updatedSalon.getAverageRating());
            salon.setLongitude(updatedSalon.getLongitude());
            salon.setEstablishedYear(updatedSalon.getEstablishedYear());
            salon.setBio(updatedSalon.getBio());
            salon.setAvailabilityHours(updatedSalon.getAvailabilityHours());

            salon.setHygieneCertificateUrl(updatedSalon.getHygieneCertificateUrl());

            // Update checkboxes
            salon.setIsEcoFriendly(updatedSalon.getIsEcoFriendly() != null ? updatedSalon.getIsEcoFriendly() : false);
            salon.setIsCertified(updatedSalon.getIsCertified() != null ? updatedSalon.getIsCertified() : false);

            // Handle profile image using FileUploadService
            if (profileImage != null && !profileImage.isEmpty()) {
                try {
                    String profileImageUrl = fileUploadService.saveFile(profileImage);
                    salon.setProfileImageUrl(profileImageUrl);
                } catch (Exception e) {
                    e.printStackTrace();
                    model.addAttribute("error", "Failed to upload profile image.");
                }
            }

            salonRepository.save(salon);

            session.setAttribute("loggedSalon", salon);
            model.addAttribute("salon", salon);
            model.addAttribute("message", "Profile updated successfully!");
            return "salon/salon-profile";
        }

        model.addAttribute("error", "Salon not found!");
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
     stylist.setPassword(password);
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

