package in.sp.main.Controller;

import java.io.IOException;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ProviderBookingStatus;
import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.ProviderReviewRepository;
import in.sp.main.Service.OtpVerificationService;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Util.MobileValidation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.util.LinkedHashMap;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Config.JwtUtil;
import in.sp.main.Service.PasswordService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/lawyer")
public class LawyerController {

    @Autowired
    private ServiceProviderRepository providerRepo;

    @Autowired
    private ProviderBookingRepository bookingRepo;

    @Autowired
    private ProviderReviewRepository reviewRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    private void validateDocumentUpload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Please upload a document (PDF or image).");
        }
        if (file.getSize() > 5L * 1024 * 1024) {
            throw new IllegalArgumentException("Document must be 5MB or smaller.");
        }
        String contentType = file.getContentType() != null ? file.getContentType().toLowerCase() : "";
        String name = file.getOriginalFilename() != null ? file.getOriginalFilename().toLowerCase() : "";
        boolean okType = contentType.startsWith("image/") || contentType.equals("application/pdf")
                || name.endsWith(".pdf") || name.endsWith(".png") || name.endsWith(".jpg")
                || name.endsWith(".jpeg") || name.endsWith(".webp");
        if (!okType) {
            throw new IllegalArgumentException("Only PDF or image files are allowed.");
        }
    }

    @GetMapping("/register")
    public String lawyerRegisterPage(Model model) {
        return "lawyer/register";
    }

    @PostMapping("/register")
    public String lawyerRegister(
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam(required = false) String otp,
            RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match!");
            return "redirect:/lawyer/register";
        }
        
        if (otp == null || otp.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "OTP is required!");
            return "redirect:/lawyer/register";
        }
        
        try {
            otpVerificationService.verifyOtp(email, otp, OtpPurpose.MARKETPLACE_REGISTER);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid or expired OTP!");
            return "redirect:/lawyer/register";
        }

        ServiceProvider p = new ServiceProvider();
        p.setFullName(fullName);
        p.setPhone(phone);
        p.setEmail(email);
        p.setPassword(passwordService.encode(password));
        p.setCategory(ProviderCategory.WOMEN_LAWYER);
        p.setVerificationStatus(VerificationStatus.VERIFIED);
        p.setRating(0.0);
        p.setIdentityDocumentPath("web-pending");
        p.setPartnerProfileStatus(in.sp.main.Entities.PartnerProfileStatus.REGISTERED);

        providerRepo.save(p);
        
        redirectAttributes.addFlashAttribute("success", "Registration successful. Please login.");
        return "redirect:/lawyer/login";
    }

    @PostMapping("/otp/send-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        String email = body != null ? body.get("email") : null;
        if (email != null) email = email.trim();
        
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", emailErr));
        }
        
        if (providerRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Email already registered"));
        }
        
        try {
            otpVerificationService.sendOtp(email, OtpPurpose.MARKETPLACE_REGISTER, OtpChannel.EMAIL);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Verification code sent to your email");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("success", false, "message", ex.getMessage()));
        }
    }

    @PostMapping("/otp/verify-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        String email = body != null ? body.get("email") : null;
        String otp = body != null ? body.get("otp") : null;
        if (email != null) email = email.trim();
        if (otp != null) otp = otp.trim();
        
        try {
            otpVerificationService.verifyOtp(email, otp, OtpPurpose.MARKETPLACE_REGISTER);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified successfully");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("success", false, "message", "Invalid or expired OTP"));
        }
    }

    @GetMapping("/login")
    public String lawyerLoginPage() {
        return "lawyer/login";
    }

    @PostMapping("/login")
    public String lawyerLogin(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              jakarta.servlet.http.HttpServletResponse response,
                              Model model) {
        Optional<ServiceProvider> pOpt = providerRepo.findByEmail(email.trim().toLowerCase());
        if (pOpt.isEmpty()) {
            model.addAttribute("error", "Lawyer profile not found.");
            return "lawyer/login";
        }
        ServiceProvider p = pOpt.get();
        
        if (p.getCategory() != ProviderCategory.WOMEN_LAWYER) {
            model.addAttribute("error", "This login is specifically for Women Lawyers.");
            return "lawyer/login";
        }

        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            providerRepo.save(p);
        });
        
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            return "lawyer/login";
        }
        
        session.setAttribute("loggedLawyer", p);
        
        // Generate JWT token
        String token = jwtUtil.generateToken(p.getEmail(), "LAWYER");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);
        
        if (p.getPartnerProfileStatus() == in.sp.main.Entities.PartnerProfileStatus.REGISTERED || p.getProfileCompletionPct() == null || p.getProfileCompletionPct() < 100) {
            return "redirect:/lawyer/profile-completion";
        }
        return "redirect:/lawyer/dashboard";
    }

    @GetMapping("/dashboard")
    public String lawyerDashboard(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";

        p = providerRepo.findById(p.getId()).orElse(p);
        model.addAttribute("lawyer", p);
        model.addAttribute("bookings", bookingRepo.findByProviderOrderByRequestedTimeDesc(p));
        model.addAttribute("reviews", reviewRepo.findByProviderIdOrderByCreatedAtDesc(p.getId()));
        
        return "lawyer/dashboard";
    }

    @PostMapping("/profile/update")
    public String updateLawyerProfile(@RequestParam String fullName,
                                      @RequestParam String phone,
                                      @RequestParam(required = false) String designation,
                                      @RequestParam(required = false) String barCouncilId,
                                      @RequestParam(required = false) String address,
                                      @RequestParam(required = false) String city,
                                      @RequestParam(required = false) String state,
                                      @RequestParam(required = false) String pincode,
                                      @RequestParam(required = false) String practiceAreas,
                                      @RequestParam(required = false) String audience,
                                      @RequestParam(required = false) String openDays,
                                      @RequestParam(required = false) String openTime,
                                      @RequestParam(required = false) String closeTime,
                                      @RequestParam(required = false) String bio,
                                      @RequestParam(required = false) Double consultationFee,
                                      @RequestParam(required = false) String serviceMode,
                                      @RequestParam(required = false) Integer durationMinutes,
                                      @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
                                      HttpSession session, RedirectAttributes ra) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";
        
        try {
            ServiceProvider existing = providerRepo.findById(p.getId()).orElse(null);
            if (existing != null) {
                existing.setFullName(fullName != null ? fullName.trim() : "");
                existing.setPhone(phone != null ? phone.trim() : "");
                existing.setDesignation(designation != null ? designation.trim() : "");
                existing.setBarCouncilId(barCouncilId != null ? barCouncilId.trim() : "");
                existing.setAddress(address != null ? address.trim() : "");
                existing.setCity(city != null ? city.trim() : "");
                existing.setState(state != null ? state.trim() : "");
                existing.setPincode(pincode != null ? pincode.trim() : "");
                existing.setPracticeAreas(practiceAreas != null ? practiceAreas.trim() : "");
                existing.setAudience(audience != null ? audience.trim() : "");
                existing.setOpenDays(openDays != null ? openDays.trim() : "");
                
                java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
                if (openTime != null && !openTime.isEmpty()) {
                    existing.setOpenTime(java.time.LocalTime.parse(openTime, fmt));
                }
                if (closeTime != null && !closeTime.isEmpty()) {
                    existing.setCloseTime(java.time.LocalTime.parse(closeTime, fmt));
                }
                
                existing.setBio(bio != null ? bio.trim() : "");
                if (consultationFee != null) existing.setConsultationFee(consultationFee);
                existing.setServiceMode(serviceMode != null ? serviceMode.trim() : "");
                if (durationMinutes != null) existing.setDurationMinutes(durationMinutes);
                
                existing.setLocationText(city != null ? city.trim() : "");
                
                if (profilePhoto != null && !profilePhoto.isEmpty()) {
                    String originalFilename = profilePhoto.getOriginalFilename();
                    if (originalFilename != null) {
                        String lower = originalFilename.toLowerCase();
                        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp")) {
                            existing.setProfilePhoto(fileUploadService.saveFile(profilePhoto));
                        } else {
                            ra.addFlashAttribute("error", "Invalid photo format. Please upload JPG, JPEG, PNG or WEBP.");
                            return "redirect:/lawyer/dashboard";
                        }
                    }
                }
                
                providerRepo.save(existing);
                session.setAttribute("loggedLawyer", existing);
                ra.addFlashAttribute("message", "Profile updated successfully!");
            }
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to update profile photo.");
        }
        return "redirect:/lawyer/dashboard";
    }

    @PostMapping("/bookings/{id}/status")
    @ResponseBody
    public Map<String, Object> updateBookingStatus(@PathVariable Long id,
                                                   @RequestParam String status,
                                                   HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) {
            response.put("success", false);
            response.put("message", "Not logged in");
            return response;
        }

        ProviderBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getProvider() == null || !b.getProvider().getId().equals(p.getId())) {
            response.put("success", false);
            response.put("message", "Booking not found");
            return response;
        }

        try {
            ProviderBookingStatus newStatus = ProviderBookingStatus.valueOf(status);
            b.setStatus(newStatus);
            bookingRepo.save(b);
            response.put("success", true);
            response.put("newStatus", newStatus.name());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Invalid status");
        }
        return response;
    }

    @GetMapping("/profile-completion")
    public String lawyerProfileCompletion(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";
        p = providerRepo.findById(p.getId()).orElse(p);
        model.addAttribute("lawyer", p);
        return "lawyer/profileCompletion";
    }

    @PostMapping("/profile-completion/save")
    public String saveProfileCompletion(@RequestParam String fullName,
                                      @RequestParam String phone,
                                      @RequestParam(required = false) String designation,
                                      @RequestParam(required = false) String barCouncilId,
                                      @RequestParam(required = false) String city,
                                      @RequestParam(required = false) String state,
                                      @RequestParam(required = false) String practiceAreas,
                                      @RequestParam(required = false) String openDays,
                                      @RequestParam(required = false) String openTime,
                                      @RequestParam(required = false) String closeTime,
                                      @RequestParam(required = false) String bio,
                                      @RequestParam(required = false) String serviceMode,
                                      @RequestParam(required = false) Integer experienceYears,
                                      @RequestParam(required = false) String languages,
                                      HttpSession session, RedirectAttributes ra) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";
        
        ServiceProvider existing = providerRepo.findById(p.getId()).orElse(null);
        if (existing != null) {
            existing.setFullName(fullName != null ? fullName.trim() : "");
            existing.setPhone(phone != null ? phone.trim() : "");
            existing.setDesignation(designation != null ? designation.trim() : "");
            existing.setBarCouncilId(barCouncilId != null ? barCouncilId.trim() : "");
            existing.setCity(city != null ? city.trim() : "");
            existing.setState(state != null ? state.trim() : "");
            existing.setPracticeAreas(practiceAreas != null ? practiceAreas.trim() : "");
            existing.setOpenDays(openDays != null ? openDays.trim() : "");
            
            java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
            if (openTime != null && !openTime.isEmpty()) {
                existing.setOpenTime(java.time.LocalTime.parse(openTime, fmt));
            }
            if (closeTime != null && !closeTime.isEmpty()) {
                existing.setCloseTime(java.time.LocalTime.parse(closeTime, fmt));
            }
            
            existing.setBio(bio != null ? bio.trim() : "");
            existing.setServiceMode(serviceMode != null ? serviceMode.trim() : "");
            if (experienceYears != null) existing.setExperienceYears(experienceYears);
            existing.setLanguages(languages != null ? languages.trim() : "");
            
            existing.setLocationText(city != null ? city.trim() : "");
            existing.setProfileCompletionPct(100);
            existing.setPartnerProfileStatus(in.sp.main.Entities.PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
            
            providerRepo.save(existing);
            session.setAttribute("loggedLawyer", existing);
            ra.addFlashAttribute("message", "Profile saved successfully!");
        }
        return "redirect:/lawyer/dashboard";
    }
}

