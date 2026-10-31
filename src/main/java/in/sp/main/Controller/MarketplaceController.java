package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ProviderBookingStatus;
import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ProviderReview;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.ProviderClass;
import in.sp.main.Entities.MarketplaceEnrollment;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.ProviderReviewRepository;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Repository.ProviderClassRepository;
import in.sp.main.Repository.MarketplaceEnrollmentRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.OtpVerificationService;
import in.sp.main.Service.ServiceProviderRegistrationService;
import in.sp.main.Service.ServiceProviderProfileService;
import in.sp.main.Service.PartnerLifecycleSupport;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/marketplace")
public class MarketplaceController {

    @Autowired
    private ServiceProviderRepository providerRepo;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private ServiceProviderRegistrationService providerRegistrationService;

    @Autowired
    private ServiceProviderProfileService providerProfileService;

    @Autowired
    private ProviderBookingRepository bookingRepo;

    @Autowired
    private ProviderReviewRepository reviewRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private ProviderClassRepository classRepo;

    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    
    @Autowired
    private in.sp.main.Repository.JobApplicationRepository jobAppRepo;

    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @Autowired
    private in.sp.main.Service.LocationDirectoryService locationDirectoryService;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    private boolean razorpayConfigured() {
        return razorpayKeyId != null && !razorpayKeyId.isBlank()
                && razorpayKeySecret != null && !razorpayKeySecret.isBlank();
    }

    private static String formatCategoryLabel(ProviderCategory cat) {
        if (cat == null) return "";
        return cat.getDisplayName();
    }

    private void validateMarketplaceUpload(MultipartFile file) {
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

    public static boolean isProfileIncomplete(ServiceProvider p) {
        if (p == null) return true;
        if (p.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED) {
            return false;
        }
        if (p.getPartnerProfileStatus() == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || p.getPartnerProfileStatus() == PartnerProfileStatus.READY_FOR_VERIFICATION) {
            return false;
        }
        if (p.getPartnerProfileStatus() == PartnerProfileStatus.PROFILE_INCOMPLETE
                || p.getPartnerProfileStatus() == PartnerProfileStatus.REGISTERED
                || p.getPartnerProfileStatus() == null) {
            return true;
        }
        return p.getPhone() == null || p.getPhone().trim().isEmpty()
                || p.getLocationText() == null || p.getLocationText().trim().isEmpty()
                || p.getDescription() == null || p.getDescription().trim().isEmpty();
    }

    @GetMapping(value = "/api/categories", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, String>> getCategories() {
        return java.util.Arrays.stream(ProviderCategory.values())
                .map(c -> Map.of("code", c.name(), "displayName", c.getDisplayName()))
                .collect(java.util.stream.Collectors.toList());
    }

    @PostMapping(value = "/provider/otp/send-email", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> sendRegistrationEmailOtp(@org.springframework.web.bind.annotation.RequestBody(required = false) Map<String, String> body) {
        Map<String, Object> res = new HashMap<>();
        String email = body != null ? body.get("email") : null;
        if (email == null || email.trim().isBlank()) {
            res.put("success", false);
            res.put("error", "Email is required");
            return res;
        }
        String normEmail = email.trim().toLowerCase();
        if (providerRepo.findByEmail(normEmail).isPresent()) {
            res.put("success", false);
            res.put("error", "Email already registered");
            return res;
        }
        try {
            otpVerificationService.sendOtp(normEmail, OtpPurpose.MARKETPLACE_REGISTER, OtpChannel.EMAIL);
            res.put("success", true);
            res.put("message", "OTP sent to your email");
        } catch (IllegalStateException ex) {
            res.put("success", false);
            res.put("error", ex.getMessage());
        } catch (Exception ex) {
            res.put("success", false);
            res.put("error", "Failed to send OTP. Please check your email and try again.");
        }
        return res;
    }

    @PostMapping(value = "/provider/otp/verify-email", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> verifyRegistrationEmailOtp(@org.springframework.web.bind.annotation.RequestBody(required = false) Map<String, String> body) {
        Map<String, Object> res = new HashMap<>();
        String email = body != null ? body.get("email") : null;
        String otp = body != null ? body.get("otp") : null;
        if (email == null || email.trim().isBlank() || otp == null || otp.trim().isBlank()) {
            res.put("success", false);
            res.put("error", "Email and OTP are required");
            return res;
        }
        String normEmail = email.trim().toLowerCase();
        boolean valid = otpVerificationService.verifyOtp(normEmail, otp.trim(), OtpPurpose.MARKETPLACE_REGISTER);
        if (valid) {
            res.put("success", true);
            res.put("message", "Email verified successfully");
        } else {
            res.put("success", false);
            res.put("error", "Invalid or expired OTP");
        }
        return res;
    }

    // ==============================
    // Provider registration + login
    // ==============================
    @GetMapping("/provider/register")
    public String providerRegisterPage(Model model) {
        model.addAttribute("providerCategories", ProviderCategory.values());
        return "marketplace/provider-register";
    }

    @PostMapping("/provider/register")
    public String providerRegister(@RequestParam("fullName") String fullName,
                                   @RequestParam("email") String email,
                                   @RequestParam("password") String password,
                                   @RequestParam("confirmPassword") String confirmPassword,
                                   @RequestParam("category") String category,
                                   @RequestParam(value = "emailOtp", required = false) String emailOtp,
                                   @RequestParam(value = "acceptedTerms", defaultValue = "false") boolean acceptedTerms,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        String normEmail = email != null ? email.trim().toLowerCase() : "";
        if (normEmail.isBlank()) {
            model.addAttribute("error", "Email is required.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        if (providerRepo.findByEmail(normEmail).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        if (fullName == null || fullName.trim().isBlank()) {
            model.addAttribute("error", "Full name is required.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        if (password == null || password.length() < 6) {
            model.addAttribute("error", "Password must be at least 6 characters.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Password and confirm password do not match.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        ProviderCategory parsedCat = ProviderCategory.fromFlexible(category);
        if (parsedCat == null) {
            model.addAttribute("error", "Please select a valid service category.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        if (!acceptedTerms) {
            model.addAttribute("error", "You must agree to the Terms & Conditions and Privacy Policy.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        // Verify/consume OTP
        boolean otpConsumed = otpVerificationService.consumeVerifiedOtp(normEmail, OtpPurpose.MARKETPLACE_REGISTER, 15);
        if (!otpConsumed && emailOtp != null && !emailOtp.isBlank()) {
            if (otpVerificationService.verifyOtp(normEmail, emailOtp.trim(), OtpPurpose.MARKETPLACE_REGISTER)) {
                otpVerificationService.consumeVerifiedOtp(normEmail, OtpPurpose.MARKETPLACE_REGISTER, 15);
                otpConsumed = true;
            }
        }

        if (!otpConsumed) {
            model.addAttribute("error", "Email not verified. Please verify your email OTP first.");
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }

        try {
            ServiceProvider p = new ServiceProvider();
            p.setFullName(fullName.trim());
            p.setEmail(normEmail);
            p.setPassword(passwordService.encode(password));
            p.setCategory(parsedCat);
            p.setVerificationStatus(VerificationStatus.PENDING);
            p.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
            p.setProfileCompletionPct(25);
            p.setAcceptedTermsAt(LocalDateTime.now());
            p.setRating(0.0);

            providerRepo.save(p);

            redirectAttributes.addFlashAttribute("message", "Registration successful. Please sign in to continue.");
            redirectAttributes.addFlashAttribute("registeredEmail", normEmail);
            return "redirect:/marketplace/provider/login";
        } catch (Exception e) {
            model.addAttribute("error", "A database error occurred: " + e.getMessage());
            model.addAttribute("providerCategories", ProviderCategory.values());
            return "marketplace/provider-register";
        }
    }

    @GetMapping("/provider/login")
    public String providerLoginPage() {
        return "marketplace/provider-login";
    }

    @PostMapping("/provider/login")
    public String providerLogin(@RequestParam("email") String email,
                                @RequestParam("password") String password,
                                HttpSession session,
                                jakarta.servlet.http.HttpServletResponse response,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        String normEmail = email != null ? email.trim().toLowerCase() : "";
        Optional<ServiceProvider> pOpt = providerRepo.findByEmail(normEmail);
        if (pOpt.isEmpty()) {
            model.addAttribute("error", "Invalid email or password.");
            model.addAttribute("registeredEmail", normEmail);
            return "marketplace/provider-login";
        }
        ServiceProvider p = pOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            providerRepo.save(p);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid email or password.");
            model.addAttribute("registeredEmail", normEmail);
            return "marketplace/provider-login";
        }

        session.setAttribute("loggedProvider", p);

        // Generate JWT and add to response
        String token = jwtUtil.generateToken(p.getEmail(), "PROVIDER");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);

        if (isProfileIncomplete(p)
                || p.getPartnerProfileStatus() == PartnerProfileStatus.CHANGES_REQUESTED
                || p.getVerificationStatus() == VerificationStatus.CHANGES_REQUESTED) {
            return "redirect:/marketplace/provider/profile-completion";
        } else {
            return "redirect:/marketplace/provider/dashboard";
        }
    }

    public static int calculateProfileCompletionPct(ServiceProvider p) {
        if (p == null) return 0;
        int score = 0;
        if (p.getFullName() != null && !p.getFullName().trim().isBlank()) score += 10;
        if (p.getEmail() != null && !p.getEmail().trim().isBlank()) score += 10;
        if (p.getCategory() != null) score += 10;
        if (p.getPhone() != null && p.getPhone().trim().matches("^\\d{10}$")) score += 10;
        if (p.getState() != null && !p.getState().trim().isBlank()) score += 10;
        if (p.getCity() != null && !p.getCity().trim().isBlank()) score += 10;
        if ((p.getServiceArea() != null && !p.getServiceArea().trim().isBlank())
                || (p.getAddress() != null && !p.getAddress().trim().isBlank())
                || (p.getLocationText() != null && !p.getLocationText().trim().isBlank())) score += 10;
        if (p.getDescription() != null && p.getDescription().trim().length() >= 15) score += 10;
        if ((p.getQualification() != null && !p.getQualification().trim().isBlank())
                || (p.getExperience() != null && !p.getExperience().trim().isBlank())
                || (p.getBusinessName() != null && !p.getBusinessName().trim().isBlank())) score += 10;
        if ((p.getIdentityDocumentPath() != null && !p.getIdentityDocumentPath().trim().isBlank())
                || (p.getProfilePhoto() != null && !p.getProfilePhoto().trim().isBlank())) score += 10;
        return Math.min(100, score);
    }

    @GetMapping("/provider/profile-completion")
    public String providerProfileCompletionPage(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) {
            return "redirect:/marketplace/provider/login";
        }
        p = providerRepo.findById(p.getId()).orElse(p);

        int pct = calculateProfileCompletionPct(p);
        boolean changed = false;
        if (p.getPartnerProfileStatus() == null) {
            p.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
            changed = true;
        }
        if (p.getProfileCompletionPct() == null || p.getProfileCompletionPct() != pct) {
            p.setProfileCompletionPct(pct);
            changed = true;
        }
        if (changed) {
            providerRepo.save(p);
        }
        session.setAttribute("loggedProvider", p);

        model.addAttribute("provider", p);
        model.addAttribute("providerCategories", ProviderCategory.values());
        model.addAttribute("indianStates", locationDirectoryService.getStates());
        return "marketplace/provider-profile-completion";
    }

    @PostMapping("/provider/profile-completion")
    public String providerProfileCompletionSubmit(
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "serviceArea", required = false) String serviceArea,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "locationText", required = false) String locationText,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "businessName", required = false) String businessName,
            @RequestParam(value = "qualification", required = false) String qualification,
            @RequestParam(value = "experience", required = false) String experience,
            @RequestParam(value = "availableDays", required = false) String availableDays,
            @RequestParam(value = "workingHoursFrom", required = false) String workingHoursFrom,
            @RequestParam(value = "workingHoursTo", required = false) String workingHoursTo,
            @RequestParam(value = "languagesSpoken", required = false) String languagesSpoken,
            @RequestParam(value = "consultationFee", required = false) Double consultationFee,
            @RequestParam(value = "action", required = false) String formAction,
            @RequestParam(value = "identityDoc", required = false) MultipartFile identityDoc,
            @RequestParam(value = "profilePhotoFile", required = false) MultipartFile profilePhotoFile,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        ServiceProvider sessionProvider = (ServiceProvider) session.getAttribute("loggedProvider");
        if (sessionProvider == null) {
            return "redirect:/marketplace/provider/login";
        }
        Optional<ServiceProvider> optP = providerRepo.findById(sessionProvider.getId());
        if (optP.isEmpty()) {
            return "redirect:/marketplace/provider/login";
        }
        ServiceProvider p = optP.get();

        String resolvedState = (state != null && !state.trim().isBlank()) ? state.trim() : (p.getState() != null ? p.getState() : "");
        String resolvedCity = (city != null && !city.trim().isBlank()) ? city.trim() : (p.getCity() != null ? p.getCity() : "");
        String resolvedArea = (serviceArea != null && !serviceArea.trim().isBlank()) ? serviceArea.trim() : (p.getServiceArea() != null ? p.getServiceArea() : "");
        String resolvedAddress = (address != null && !address.trim().isBlank()) ? address.trim() : (p.getAddress() != null ? p.getAddress() : "");
        String resolvedPincode = (pincode != null && !pincode.trim().isBlank()) ? pincode.trim() : (p.getPincode() != null ? p.getPincode() : "");

        boolean isDraft = "draft".equalsIgnoreCase(formAction);

        if (!isDraft) {
            if (phone == null || !phone.trim().matches("^\\d{10}$")) {
                model.addAttribute("error", "Official contact phone must be a valid 10-digit number.");
                model.addAttribute("provider", p);
                model.addAttribute("providerCategories", ProviderCategory.values());
                model.addAttribute("indianStates", locationDirectoryService.getStates());
                return "marketplace/provider-profile-completion";
            }
            if (resolvedState.isBlank()) {
                model.addAttribute("error", "State is a required location field.");
                model.addAttribute("provider", p);
                model.addAttribute("providerCategories", ProviderCategory.values());
                model.addAttribute("indianStates", locationDirectoryService.getStates());
                return "marketplace/provider-profile-completion";
            }
            if (resolvedCity.isBlank()) {
                model.addAttribute("error", "City / District is a required location field.");
                model.addAttribute("provider", p);
                model.addAttribute("providerCategories", ProviderCategory.values());
                model.addAttribute("indianStates", locationDirectoryService.getStates());
                return "marketplace/provider-profile-completion";
            }
            if (description == null || description.trim().length() < 15) {
                model.addAttribute("error", "Profile Bio / Description is required (minimum 15 characters).");
                model.addAttribute("provider", p);
                model.addAttribute("providerCategories", ProviderCategory.values());
                model.addAttribute("indianStates", locationDirectoryService.getStates());
                return "marketplace/provider-profile-completion";
            }
        }

        try {
            if (phone != null && !phone.trim().isBlank()) {
                p.setPhone(phone.trim());
            }

            p.setState(resolvedState);
            p.setCity(resolvedCity);
            p.setServiceArea(resolvedArea);
            p.setAddress(resolvedAddress);
            p.setPincode(resolvedPincode);

            // Construct unified locationText for backward compatibility and display
            StringBuilder locBuilder = new StringBuilder();
            if (!resolvedArea.isBlank()) locBuilder.append(resolvedArea).append(", ");
            if (!resolvedCity.isBlank()) locBuilder.append(resolvedCity).append(", ");
            if (!resolvedState.isBlank()) locBuilder.append(resolvedState);
            String calculatedLoc = locBuilder.toString().trim();
            if (calculatedLoc.endsWith(",")) calculatedLoc = calculatedLoc.substring(0, calculatedLoc.length() - 1);
            if (!calculatedLoc.isBlank()) {
                p.setLocationText(calculatedLoc);
            } else if (locationText != null && !locationText.trim().isBlank()) {
                p.setLocationText(locationText.trim());
            }

            if (description != null && !description.trim().isBlank()) {
                p.setDescription(description.trim());
            }

            if (category != null && !category.trim().isBlank()) {
                ProviderCategory cat = ProviderCategory.fromFlexible(category.trim());
                if (cat != null) {
                    p.setCategory(cat);
                }
            }

            if (businessName != null && !businessName.trim().isBlank()) {
                p.setBusinessName(businessName.trim());
            }
            if (qualification != null && !qualification.trim().isBlank()) {
                p.setQualification(qualification.trim());
            }
            if (experience != null && !experience.trim().isBlank()) {
                p.setExperience(experience.trim());
            }
            if (availableDays != null && !availableDays.trim().isBlank()) {
                p.setAvailableDays(availableDays.trim());
            }
            if (workingHoursFrom != null && !workingHoursFrom.trim().isBlank()) {
                p.setWorkingHoursFrom(workingHoursFrom.trim());
            }
            if (workingHoursTo != null && !workingHoursTo.trim().isBlank()) {
                p.setWorkingHoursTo(workingHoursTo.trim());
            }
            if (languagesSpoken != null && !languagesSpoken.trim().isBlank()) {
                p.setLanguagesSpoken(languagesSpoken.trim());
            }
            if (consultationFee != null && consultationFee >= 0) {
                p.setConsultationFee(consultationFee);
            }

            if (identityDoc != null && !identityDoc.isEmpty()) {
                validateMarketplaceUpload(identityDoc);
                String docPath = fileUploadService.saveFile(identityDoc);
                p.setIdentityDocumentPath(docPath);
            }

            if (profilePhotoFile != null && !profilePhotoFile.isEmpty()) {
                validateMarketplaceUpload(profilePhotoFile);
                String photoPath = fileUploadService.saveFile(profilePhotoFile);
                p.setProfilePhoto(photoPath);
            }

            // Calculate actual dynamic profile completion percentage
            int actualPct = calculateProfileCompletionPct(p);
            p.setProfileCompletionPct(actualPct);

            if (isDraft) {
                p.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
                providerRepo.save(p);
                session.setAttribute("loggedProvider", p);
                redirectAttributes.addFlashAttribute("message", "Profile draft saved successfully (" + actualPct + "% complete).");
                return "redirect:/marketplace/provider/profile-completion";
            }

            boolean isResubmission = p.getPartnerProfileStatus() == PartnerProfileStatus.CHANGES_REQUESTED
                    || p.getVerificationStatus() == VerificationStatus.CHANGES_REQUESTED
                    || p.getPartnerProfileStatus() == PartnerProfileStatus.READY_FOR_VERIFICATION
                    || p.getVerificationStatus() == VerificationStatus.RE_VERIFICATION;

            if (isResubmission) {
                p.setPartnerProfileStatus(PartnerProfileStatus.READY_FOR_VERIFICATION);
                p.setVerificationStatus(VerificationStatus.RE_VERIFICATION);
            } else {
                p.setPartnerProfileStatus(PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
                p.setVerificationStatus(VerificationStatus.PENDING);
            }
            p.setSubmittedForVerificationAt(LocalDateTime.now());

            providerRepo.save(p);
            session.setAttribute("loggedProvider", p);

            String successMsg = isResubmission
                    ? "Updated profile details submitted successfully! Your application has been moved to the re-verification queue."
                    : "Profile details submitted successfully! Your application has been submitted for administrator verification. Admin needs to verify your details before dashboard features are unlocked.";
            redirectAttributes.addFlashAttribute("message", successMsg);
            return "redirect:/marketplace/provider/dashboard";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("provider", p);
            model.addAttribute("providerCategories", ProviderCategory.values());
            model.addAttribute("indianStates", locationDirectoryService.getStates());
            return "marketplace/provider-profile-completion";
        } catch (Exception e) {
            model.addAttribute("error", "Error saving profile details: " + e.getMessage());
            model.addAttribute("provider", p);
            model.addAttribute("providerCategories", ProviderCategory.values());
            model.addAttribute("indianStates", locationDirectoryService.getStates());
            return "marketplace/provider-profile-completion";
        }
    }

    @GetMapping("/provider/dashboard")
    public String providerDashboard(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";

        p = providerRepo.findById(p.getId()).orElse(p);
        // Providers who click "Skip for now" can access the dashboard in read-only / locked mode.
        // Protected actions (creating classes, updating bookings, public listings) are strictly gated.
        model.addAttribute("provider", p);
        model.addAttribute("bookings", bookingRepo.findByProviderOrderByRequestedTimeDesc(p));
        // Using findByProviderId from MarketplaceEnrollmentRepository
        model.addAttribute("enrollments", enrollmentRepo.findByProviderId(p.getId()));
        model.addAttribute("classes", classRepo.findByProvider_Id(p.getId()));
        
        // Calculate total earnings from PAID enrollments
        double totalEarnings = enrollmentRepo.findByProviderId(p.getId()).stream()
                .filter(e -> "PAID".equals(e.getPaymentStatus()))
                .mapToDouble(e -> {
                    if (e.getProviderClass() == null || e.getProviderClass().getPrice() == null) {
                        return 0.0;
                    }
                    return e.getProviderClass().getPrice();
                })
                .sum();
        model.addAttribute("totalEarnings", totalEarnings);
        return "marketplace/provider-dashboard";
    }

    @PostMapping("/provider/profile/update")
    public String updateProviderProfile(@RequestParam("fullName") String fullName,
                                       @RequestParam(value = "businessName", required = false) String businessName,
                                       @RequestParam("phone") String phone,
                                       @RequestParam(value = "locationText", required = false) String locationText,
                                       @RequestParam(value = "serviceArea", required = false) String serviceArea,
                                       @RequestParam(value = "description", required = false) String description,
                                       @RequestParam(value = "qualification", required = false) String qualification,
                                       @RequestParam(value = "experience", required = false) String experience,
                                       @RequestParam(value = "availableDays", required = false) String availableDays,
                                       @RequestParam(value = "workingHoursFrom", required = false) String workingHoursFrom,
                                       @RequestParam(value = "workingHoursTo", required = false) String workingHoursTo,
                                       @RequestParam(value = "languagesSpoken", required = false) String languagesSpoken,
                                       @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
                                       HttpSession session, RedirectAttributes ra) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";
        
        try {
            ServiceProvider existing = providerRepo.findById(p.getId()).orElse(null);
            if (existing != null) {
                existing.setFullName(fullName != null ? fullName.trim() : "");
                existing.setBusinessName(businessName != null ? businessName.trim() : "");
                existing.setPhone(phone != null ? phone.trim() : "");
                existing.setLocationText(locationText != null ? locationText.trim() : "");
                existing.setServiceArea(serviceArea != null ? serviceArea.trim() : "");
                existing.setDescription(description != null ? description.trim() : "");
                existing.setQualification(qualification != null ? qualification.trim() : "");
                existing.setExperience(experience != null ? experience.trim() : "");
                existing.setAvailableDays(availableDays != null ? availableDays.trim() : "");
                existing.setWorkingHoursFrom(workingHoursFrom != null ? workingHoursFrom.trim() : "");
                existing.setWorkingHoursTo(workingHoursTo != null ? workingHoursTo.trim() : "");
                existing.setLanguagesSpoken(languagesSpoken != null ? languagesSpoken.trim() : "");
                
                if (profilePhoto != null && !profilePhoto.isEmpty()) {
                    String originalFilename = profilePhoto.getOriginalFilename();
                    if (originalFilename != null) {
                        String lower = originalFilename.toLowerCase();
                        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp")) {
                            existing.setProfilePhoto(fileUploadService.saveFile(profilePhoto));
                        } else {
                            ra.addFlashAttribute("error", "Invalid photo format. Please upload JPG, JPEG, PNG or WEBP.");
                            return "redirect:/marketplace/provider/dashboard";
                        }
                    }
                }
                
                providerRepo.save(existing);
                session.setAttribute("loggedProvider", existing);
                ra.addFlashAttribute("message", "Profile updated successfully!");
            }
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to update profile photo.");
        }
        return "redirect:/marketplace/provider/dashboard";
    }

    @PostMapping("/provider/bookings/{id}/status")
    @ResponseBody
    public Map<String, Object> updateBookingStatus(@PathVariable("id") Long id,
                                                  @RequestParam("status") String status,
                                                  HttpSession session) {
        Map<String, Object> response = new HashMap();
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) {
            response.put("success", false);
            response.put("message", "Not logged in");
            return response;
        }

        p = providerRepo.findById(p.getId()).orElse(p);
        if (p.getVerificationStatus() != VerificationStatus.VERIFIED
                && p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            response.put("success", false);
            response.put("message", "Account verification pending. Access to booking actions is restricted.");
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

    // ==============================
    // Users: browse + book + review
    // ==============================
    @GetMapping
    public String categories(Model model) {
        List<String> dynamicCategories = jobAppRepo.findDistinctJobCategoriesByStatus(VerificationStatus.VERIFIED);
        model.addAttribute("dynamicCategories", dynamicCategories);
        model.addAttribute("providerCategories", ProviderCategory.values());
        return "marketplace/marketplace-home";
    }

    @GetMapping("/workers")
    public String workersList(@RequestParam("category") String category, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        List<in.sp.main.Entities.JobApplication> workers = jobAppRepo.findByJobCategoryAndStatus(category, VerificationStatus.VERIFIED);
        model.addAttribute("category", category);
        model.addAttribute("workers", workers);
        return "marketplace/worker-list";
    }

    @GetMapping("/worker/{id}")
    public String workerDetails(@PathVariable("id") Long id, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) {
            return "redirect:/marketplace";
        }

        List<in.sp.main.Entities.WorkerBooking> bookings = workerBookingRepo.findByJobApplication_Id(id);
        List<String> bookedTimes = bookings.stream()
                .filter(b -> !"REJECTED".equals(b.getStatus()))
                .map(b -> b.getBookingDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")))
                .collect(java.util.stream.Collectors.toList());

        boolean revealContact = bookings.stream().anyMatch(b ->
                b.getClient() != null && b.getClient().getId().equals(u.getId())
                        && ("ACCEPTED".equals(b.getStatus()) || "PAID".equals(b.getStatus()) || "COMPLETED".equals(b.getStatus())));

        User workerOwner = app.getUser();
        boolean ownWorkerProfile = workerOwner != null
                && workerOwner.getId() != null
                && u.getId() != null
                && workerOwner.getId().equals(u.getId());

        model.addAttribute("workerApp", app);
        model.addAttribute("bookedTimes", bookedTimes);
        model.addAttribute("revealContact", revealContact);
        model.addAttribute("ownWorkerProfile", ownWorkerProfile);
        return "marketplace/worker-details";
    }

    @PostMapping("/worker/{id}/book")
    public String bookWorker(@PathVariable("id") Long id,
                             @RequestParam("bookingDate") String bookingDate,
                             @RequestParam(value = "hours", required = false) Integer hours,
                             @RequestParam(value = "totalAmount", required = false) Double totalAmount,
                             @RequestParam(value = "note", required = false) String note,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("message", "Worker not found or not verified.");
            return "redirect:/marketplace";
        }

        if (app.getUser() != null && app.getUser().getId().equals(u.getId())) {
            redirectAttributes.addFlashAttribute("error", "You cannot book your own services.");
            return "redirect:/marketplace/worker/" + id;
        }

        try {
            LocalDateTime reqTime = LocalDateTime.parse(bookingDate, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            if (reqTime.isBefore(LocalDateTime.now())) {
                redirectAttributes.addFlashAttribute("error", "Booking date/time cannot be in the past.");
                return "redirect:/marketplace/worker/" + id;
            }
            if (reqTime.isAfter(LocalDateTime.now().plusDays(2))) {
                redirectAttributes.addFlashAttribute("error", "Bookings can only be made up to 2 days in advance.");
                return "redirect:/marketplace/worker/" + id;
            }

            // Check if slot is already booked (within 1 hour)
            List<in.sp.main.Entities.WorkerBooking> existingBookings = workerBookingRepo.findByJobApplication_Id(id);
            boolean isBooked = existingBookings.stream()
                .filter(b -> !"REJECTED".equals(b.getStatus()))
                .anyMatch(b -> java.time.Duration.between(b.getBookingDate(), reqTime).abs().toMinutes() < 60);

            if (isBooked) {
                redirectAttributes.addFlashAttribute("error", "This time slot is already booked.");
                return "redirect:/marketplace/worker/" + id;
            }

            in.sp.main.Entities.WorkerBooking booking = new in.sp.main.Entities.WorkerBooking();
            booking.setClient(u);
            booking.setJobApplication(app);
            booking.setBookingDate(reqTime);
            booking.setHours(hours);
            booking.setTotalAmount(totalAmount != null ? totalAmount : 0.0);
            booking.setNote(note);
            booking.setStatus("PENDING");
            
            workerBookingRepo.save(booking);
            
            // Broadcast live refresh to worker dashboard
            try {
                if (booking.getJobApplication() != null && booking.getJobApplication().getUser() != null) {
                    Long workerUserId = booking.getJobApplication().getUser().getId();
                    messagingTemplate.convertAndSend("/topic/worker-bookings/" + workerUserId, "REFRESH");
                }
            } catch (Exception ignored) {}

            redirectAttributes.addFlashAttribute("success", "Booking request sent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format or booking failed.");
        }

        return "redirect:/marketplace/worker/" + id;
    }

    @GetMapping("/list")
    public String list(@RequestParam("category") String category, Model model, HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderCategory cat = ProviderCategory.fromFlexible(category);
        if (cat == null) {
            redirectAttributes.addFlashAttribute("error", "Invalid marketplace category.");
            return "redirect:/marketplace";
        }
        model.addAttribute("category", cat);
        model.addAttribute("categoryLabel", formatCategoryLabel(cat));
        model.addAttribute("providers", providerRepo.findByCategoryAndVerificationStatus(cat, VerificationStatus.VERIFIED));
        return "marketplace/provider-list";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable("id") Long id, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return "redirect:/marketplace";
        }

        model.addAttribute("provider", p);
        model.addAttribute("categoryLabel", formatCategoryLabel(p.getCategory()));
        model.addAttribute("reviews", reviewRepo.findByProviderIdOrderByCreatedAtDesc(id));

        boolean alreadyReviewed = reviewRepo.existsByUserIdAndProviderId(u.getId(), id);
        boolean completedSession = bookingRepo.findByUserOrderByRequestedTimeDesc(u).stream()
                .anyMatch(b -> b.getProvider() != null && b.getProvider().getId().equals(id)
                        && b.getStatus() == ProviderBookingStatus.COMPLETED);
        boolean paidClass = enrollmentRepo.findByUser_Id(u.getId()).stream()
                .anyMatch(e -> e.getProviderClass() != null
                        && e.getProviderClass().getProvider() != null
                        && e.getProviderClass().getProvider().getId().equals(id)
                        && "PAID".equals(e.getPaymentStatus()));
        model.addAttribute("canReview", !alreadyReviewed && (completedSession || paidClass));
        
        // Load available classes
        model.addAttribute("classes", classRepo.findByProvider_Id(id));
        
        return "marketplace/provider-view";
    }

    @PostMapping("/classes/enroll")
    public String enrollClass(@RequestParam("classId") Long classId, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null || pc.getAvailableSeats() == null || pc.getAvailableSeats() <= 0) {
            redirectAttributes.addFlashAttribute("error", "Class not available or full.");
            return "redirect:/marketplace";
        }

        if (pc.getDateTime() != null && pc.getDateTime().isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Cannot enroll in a class that has already started or ended.");
            Long providerId = pc.getProvider() != null ? pc.getProvider().getId() : null;
            return providerId != null ? "redirect:/marketplace/view/" + providerId : "redirect:/marketplace";
        }

        if (enrollmentRepo.findByUser_Id(u.getId()).stream().anyMatch(e ->
                e.getProviderClass() != null
                        && classId.equals(e.getProviderClass().getId())
                        && !"CANCELLED".equals(e.getPaymentStatus()))) {
            redirectAttributes.addFlashAttribute("message", "You are already enrolled.");
            return "redirect:/marketplace/my-classes";
        }

        boolean paidClass = pc.getPrice() != null && pc.getPrice() > 0;

        MarketplaceEnrollment enrollment = new MarketplaceEnrollment();
        enrollment.setUser(u);
        enrollment.setProviderClass(pc);
        enrollment.setStatus("ENROLLED");
        enrollment.setPaymentStatus(paidClass ? "PENDING" : "PAID");
        enrollment.setEnrollmentTime(LocalDateTime.now());
        
        enrollmentRepo.save(enrollment);
        
        // Hold seat immediately; restored if user cancels unpaid checkout
        pc.setAvailableSeats(pc.getAvailableSeats() - 1);
        classRepo.save(pc);

        if (paidClass) {
            if (!razorpayConfigured()) {
                redirectAttributes.addFlashAttribute("error",
                        "Payment gateway is not configured. Please contact support or try again later.");
            }
            return "redirect:/marketplace/payment/" + enrollment.getId();
        }

        redirectAttributes.addFlashAttribute("message", "Enrolled successfully!");
        return "redirect:/marketplace/my-classes";
    }

    @GetMapping("/payment/{enrollmentId}")
    public String paymentPage(@PathVariable Long enrollmentId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        MarketplaceEnrollment e = enrollmentRepo.findById(enrollmentId).orElse(null);
        if (e == null || !e.getUser().getId().equals(u.getId())) return "redirect:/marketplace";

        model.addAttribute("enrollment", e);
        model.addAttribute("razorpayConfigured", razorpayConfigured());
        return "marketplace/payment";
    }

    @PostMapping("/payment/{enrollmentId}/cancel")
    public String cancelPayment(@PathVariable Long enrollmentId, HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        MarketplaceEnrollment e = enrollmentRepo.findById(enrollmentId).orElse(null);
        if (e == null || e.getUser() == null || !e.getUser().getId().equals(u.getId())) {
            return "redirect:/marketplace";
        }

        if ("PENDING".equals(e.getPaymentStatus())) {
            ProviderClass pc = e.getProviderClass();
            if (pc != null && pc.getAvailableSeats() != null) {
                pc.setAvailableSeats(pc.getAvailableSeats() + 1);
                classRepo.save(pc);
            }
            e.setStatus("CANCELLED");
            e.setPaymentStatus("CANCELLED");
            enrollmentRepo.save(e);
            redirectAttributes.addFlashAttribute("message", "Checkout cancelled. Your seat was released.");
        }
        return "redirect:/marketplace/my-classes";
    }

    /**
     * Fake "confirm paid" without Razorpay — disabled. Use /payment/create-order + /payment/verify.
     */
    @PostMapping("/payment/confirm")
    public String confirmPayment(HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        redirectAttributes.addFlashAttribute("error", "Direct payment confirmation is disabled. Complete payment via Razorpay.");
        return "redirect:/marketplace";
    }

    @GetMapping("/my-classes")
    public String myClasses(HttpSession session, Model model,
                            @RequestParam(value = "message", required = false) String message) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("enrollments", enrollmentRepo.findByUser_Id(u.getId()));
        model.addAttribute("now", LocalDateTime.now());
        if (message != null && !message.isBlank() && !model.containsAttribute("message")) {
            model.addAttribute("message", message.replace('-', ' '));
        }
        return "marketplace/my-classes";
    }

    // Provider creates classes (for testing/dashboard)
    @PostMapping("/provider/classes/add")
    public String addClass(@RequestParam("className") String className,
                           @RequestParam("description") String description,
                           @RequestParam("duration") String duration,
                           @RequestParam("dateTime") String dateTime,
                           @RequestParam("mode") String mode,
                           @RequestParam("price") Double price,
                           @RequestParam(value = "seats", required = false) Integer seats,
                           @RequestParam(value = "meetingLink", required = false) String meetingLink,
                           @RequestParam(value = "serviceLocation", required = false) String serviceLocation,
                           @RequestParam("category") String category,
                           @RequestParam(value = "serviceProvided", required = false) String serviceProvided,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";

        p = providerRepo.findById(p.getId()).orElse(p);
        if (p.getVerificationStatus() != VerificationStatus.VERIFIED
                && p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            redirectAttributes.addFlashAttribute("error", "Your account is not approved yet. Only verified marketplace providers can publish services.");
            return "redirect:/marketplace/provider/dashboard";
        }

        String normalizedMode = mode != null ? mode.trim() : "";
        boolean isOnline = normalizedMode.equalsIgnoreCase("Online") || normalizedMode.equalsIgnoreCase("Live") || normalizedMode.contains("Online");
        boolean isOffline = normalizedMode.equalsIgnoreCase("Offline") || normalizedMode.contains("Offline");
        boolean isHybrid = normalizedMode.contains("Hybrid");

        if ((isOnline || isHybrid) && (meetingLink == null || meetingLink.isBlank())) {
            redirectAttributes.addFlashAttribute("error", "Meeting link is required for Online / Hybrid sessions.");
            return "redirect:/marketplace/provider/dashboard";
        }

        if ((isOffline || isHybrid) && (serviceLocation == null || serviceLocation.isBlank())) {
            redirectAttributes.addFlashAttribute("error", "Service location is required for Offline / Hybrid sessions.");
            return "redirect:/marketplace/provider/dashboard";
        }

        ProviderClass pc = new ProviderClass();
        pc.setProvider(p);
        pc.setClassName(className);
        pc.setDescription(description);
        pc.setDuration(duration);
        pc.setDateTime(LocalDateTime.parse(dateTime));
        pc.setMode(mode);
        pc.setPrice(price);
        pc.setAvailableSeats(seats != null ? seats : 100);
        pc.setMeetingLink(meetingLink != null ? meetingLink.trim() : "");
        pc.setServiceLocation(serviceLocation != null ? serviceLocation.trim() : "");
        pc.setCategory(ProviderCategory.valueOf(category.trim().toUpperCase()));
        if (serviceProvided != null && !serviceProvided.isBlank()) {
            pc.setServiceProvided(serviceProvided.trim());
        }

        classRepo.save(pc);
        return "redirect:/marketplace/provider/dashboard";
    }

    @PostMapping("/book")
    public String book(@RequestParam("providerId") Long providerId,
                       @RequestParam("requestedTime") String requestedTime,
                       @RequestParam(value = "note", required = false) String note,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(providerId).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "Provider not available.");
            return "redirect:/marketplace";
        }

        LocalDateTime reqTime;
        try {
            reqTime = LocalDateTime.parse(requestedTime, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reqTime.isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Booking date/time cannot be in the past.");
            return "redirect:/marketplace/view/" + providerId;
        }

        boolean slotTaken = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream()
                .filter(b -> b.getStatus() != ProviderBookingStatus.CANCELLED)
                .anyMatch(b -> b.getRequestedTime() != null
                        && java.time.Duration.between(b.getRequestedTime(), reqTime).abs().toMinutes() < 60);
        if (slotTaken) {
            redirectAttributes.addFlashAttribute("error", "This time slot is already booked. Please choose another time.");
            return "redirect:/marketplace/view/" + providerId;
        }

        ProviderBooking b = new ProviderBooking();
        b.setUser(u);
        b.setProvider(p);
        b.setRequestedTime(reqTime);
        b.setNote(note);
        b.setStatus(ProviderBookingStatus.PENDING);
        bookingRepo.save(b);

        redirectAttributes.addFlashAttribute("message", "Booking request sent.");
        return "redirect:/marketplace/myBookings";
    }

    @GetMapping("/myBookings")
    public String myBookings(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("bookings", bookingRepo.findByUserOrderByRequestedTimeDesc(u));
        model.addAttribute("workerBookings", workerBookingRepo.findByClient_Id(u.getId()));
        return "marketplace/my-bookings";
    }

    /**
     * Fake worker payment without Razorpay — disabled. Use /payment/create-order + /payment/verify with type WORKER_BOOKING.
     */
    @PostMapping("/worker-booking/{id}/pay")
    public String payWorkerBooking(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        redirectAttributes.addFlashAttribute("error", "Direct worker payment is disabled. Complete payment via Razorpay.");
        return "redirect:/marketplace/myBookings";
    }

    @PostMapping("/review")
    public String review(@RequestParam("providerId") Long providerId,
                         @RequestParam("rating") Integer rating,
                         @RequestParam(value = "comment", required = false) String comment,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(providerId).orElse(null);
        if (p == null) return "redirect:/marketplace";

        if (rating == null || rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("error", "Rating must be 1-5.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reviewRepo.existsByUserIdAndProviderId(u.getId(), providerId)) {
            redirectAttributes.addFlashAttribute("error", "You already reviewed this provider.");
            return "redirect:/marketplace/view/" + providerId;
        }

        ProviderReview r = new ProviderReview();
        r.setUser(u);
        r.setProvider(p);
        r.setRating(rating);
        r.setComment(comment);
        reviewRepo.save(r);

        List<ProviderReview> reviews = reviewRepo.findByProviderIdOrderByCreatedAtDesc(providerId);
        double avg = reviews.stream().mapToInt(x -> x.getRating() == null ? 0 : x.getRating()).average().orElse(0.0);
        p.setRating(avg);
        providerRepo.save(p);

        redirectAttributes.addFlashAttribute("message", "Review submitted.");
        return "redirect:/marketplace/view/" + providerId;
    }
}

