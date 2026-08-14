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
import in.sp.main.Repository.Booking1Repository;
import jakarta.servlet.http.HttpSession;

import java.time.format.DateTimeFormatter;
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

    @Autowired
    private in.sp.main.Repository.BookingRepository bookingRepository;

    @Autowired
    private in.sp.main.Repository.Booking1Repository booking1Repository;

    @Autowired
    private in.sp.main.Repository.OfferRepository offerRepository;

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
        
        Long salonId = loggedSalon.getId();
        
        // Today's date
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDateTime startOfDay = today.atStartOfDay();
        java.time.LocalDateTime endOfDay = today.atTime(java.time.LocalTime.MAX);
        
        // --- Old Booking entity counts (instant bookings) ---
        long oldTodayAppts = bookingRepository.countBySalonIdAndBookingTimeBetween(salonId, startOfDay, endOfDay);
        long oldCompletedAppts = bookingRepository.countBySalonIdAndStatusAndBookingTimeBetween(salonId, in.sp.main.Entities.BookingStatus.COMPLETED, startOfDay, endOfDay);
        Double oldTodayRevenue = bookingRepository.sumRevenueBySalonIdAndDate(salonId, startOfDay, endOfDay);
        long oldTotalBookings = bookingRepository.countBySalonId(salonId);
        
        // --- Booking1 entity counts (customer bookings via online form) ---
        long newTodayAppts = booking1Repository.countBySalonAndBookingDate(loggedSalon, today);
        long newCompletedAppts = booking1Repository.countBySalonAndStatusAndBookingDate(loggedSalon, "COMPLETED", today);
        Double newTodayRevenue = booking1Repository.sumRevenueBySalonAndDate(loggedSalon, today);
        long newTotalBookings = booking1Repository.countBySalon(loggedSalon);
        
        // Merge counts from both booking systems
        long todayAppts = oldTodayAppts + newTodayAppts;
        long completedAppts = oldCompletedAppts + newCompletedAppts;
        double todayRevenue = (oldTodayRevenue != null ? oldTodayRevenue : 0.0) + (newTodayRevenue != null ? newTodayRevenue : 0.0);
        long totalBookings = oldTotalBookings + newTotalBookings;
        
        // Average rating from old booking system
        List<Object[]> avgResultList = bookingRepository.getAverageRatingAndCount(salonId);
        Double avgRating = 0.0;
        long totalReviews = 0;
        if (avgResultList != null && !avgResultList.isEmpty()) {
            Object[] avgResult = avgResultList.get(0);
            if (avgResult[0] != null) avgRating = ((Number) avgResult[0]).doubleValue();
            if (avgResult[1] != null) totalReviews = ((Number) avgResult[1]).longValue();
        }
        avgRating = Math.round(avgRating * 10.0) / 10.0;
        
        model.addAttribute("todayApptsCount", todayAppts);
        model.addAttribute("completedApptsCount", completedAppts);
        model.addAttribute("todayRevenue", todayRevenue);
        model.addAttribute("totalBookingsCount", totalBookings);
        model.addAttribute("averageRating", avgRating);
        model.addAttribute("totalReviews", totalReviews);
        
        // --- Calculate Today's Real Hours ---
        String todayHours = "09:00 AM - 09:00 PM"; // Default fallback
        try {
            if (loggedSalon.getOperatingHoursJson() != null && !loggedSalon.getOperatingHoursJson().isEmpty()) {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                java.util.Map<String, String> hoursMap = mapper.readValue(loggedSalon.getOperatingHoursJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){});
                String dayName = today.getDayOfWeek().name().toLowerCase();
                if (hoursMap.containsKey(dayName)) {
                    String val = hoursMap.get(dayName);
                    if (val != null && val.contains(" - ")) {
                        String[] parts = val.split(" - ");
                        java.time.format.DateTimeFormatter format12 = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");
                        todayHours = java.time.LocalTime.parse(parts[0]).format(format12) + " - " + java.time.LocalTime.parse(parts[1]).format(format12);
                    } else if (val != null) {
                        todayHours = val; // e.g. "Closed"
                    }
                }
            }
        } catch (Exception e) {
            // Ignore parse errors, fallback to default
        }
        model.addAttribute("todayHours", todayHours);
        
        // Top services from old booking system
        List<Object[]> topServices = bookingRepository.findTopServicesBySalonId(salonId);
        model.addAttribute("topServices", topServices);
        
        // Fetch salon offers to display in the dashboard
        List<in.sp.main.Entities.Offer> salonOffers = offerRepository.findBySalonId(salonId);
        model.addAttribute("salonOffers", salonOffers);
        
        // --- Business Overview (This Week) ---
        java.time.LocalDate monday = today.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
        java.time.LocalDate sunday = monday.plusDays(6);
        java.time.LocalDateTime startOfWeek = monday.atStartOfDay();
        java.time.LocalDateTime endOfWeek = sunday.atTime(java.time.LocalTime.MAX);
        
        // Old booking system week stats
        long oldWeekTotal = bookingRepository.countBySalonIdAndBookingTimeBetween(salonId, startOfWeek, endOfWeek);
        long oldWeekCompleted = bookingRepository.countBySalonIdAndStatusAndBookingTimeBetween(salonId, in.sp.main.Entities.BookingStatus.COMPLETED, startOfWeek, endOfWeek);
        long oldWeekPending = bookingRepository.countBySalonIdAndStatusAndBookingTimeBetween(salonId, in.sp.main.Entities.BookingStatus.PENDING, startOfWeek, endOfWeek);
        Double oldWeekRevenue = bookingRepository.sumRevenueBySalonIdAndDate(salonId, startOfWeek, endOfWeek);
        if (oldWeekRevenue == null) oldWeekRevenue = 0.0;
        
        // New booking system week stats
        long newWeekTotal = booking1Repository.countBySalonAndBookingDateBetween(loggedSalon, monday, sunday);
        long newWeekCompleted = booking1Repository.countBySalonAndStatusAndBookingDateBetween(loggedSalon, "COMPLETED", monday, sunday);
        long newWeekPending = booking1Repository.countBySalonAndStatusAndBookingDateBetween(loggedSalon, "PENDING", monday, sunday);
        Double newWeekRevenue = booking1Repository.sumRevenueBySalonAndDateBetween(loggedSalon, monday, sunday);
        if (newWeekRevenue == null) newWeekRevenue = 0.0;
        
        long weekTotalAppts = oldWeekTotal + newWeekTotal;
        long weekCompletedAppts = oldWeekCompleted + newWeekCompleted;
        long weekPendingAppts = oldWeekPending + newWeekPending;
        long weekOtherAppts = weekTotalAppts - weekCompletedAppts - weekPendingAppts;
        if (weekOtherAppts < 0) weekOtherAppts = 0;
        double weekRevenue = oldWeekRevenue + newWeekRevenue;
        
        // Daily revenue bars (merged)
        List<Double> dailyRevenue = new java.util.ArrayList<>();
        double maxDaily = 1.0;
        for (int i = 0; i < 7; i++) {
            java.time.LocalDate dayDate = monday.plusDays(i);
            java.time.LocalDateTime sdl = dayDate.atStartOfDay();
            java.time.LocalDateTime edl = dayDate.atTime(java.time.LocalTime.MAX);
            Double oldDayRev = bookingRepository.sumRevenueBySalonIdAndDate(salonId, sdl, edl);
            Double newDayRev = booking1Repository.sumRevenueBySalonAndDate(loggedSalon, dayDate);
            double merged = (oldDayRev != null ? oldDayRev : 0.0) + (newDayRev != null ? newDayRev : 0.0);
            dailyRevenue.add(merged);
            if (merged > maxDaily) maxDaily = merged;
        }
        List<Integer> dailyRevenueHeights = new java.util.ArrayList<>();
        for (Double rev : dailyRevenue) {
            int height = (int) Math.max(10, (rev / maxDaily) * 100);
            dailyRevenueHeights.add(height);
        }
        
        // Donut chart percentages
        double cPct = weekTotalAppts == 0 ? 0 : ((double) weekCompletedAppts / weekTotalAppts) * 100;
        double pPct = weekTotalAppts == 0 ? 0 : ((double) weekPendingAppts / weekTotalAppts) * 100;
        double oPct = weekTotalAppts == 0 ? 0 : ((double) weekOtherAppts / weekTotalAppts) * 100;
        int offsetCompleted = 25;
        int offsetPending = (100 - (int) cPct + 25) % 100;
        int offsetOther = (100 - (int) cPct - (int) pPct + 25) % 100;
        
        model.addAttribute("weekTotalAppts", weekTotalAppts);
        model.addAttribute("weekCompletedAppts", weekCompletedAppts);
        model.addAttribute("weekPendingAppts", weekPendingAppts);
        model.addAttribute("weekOtherAppts", weekOtherAppts);
        model.addAttribute("weekRevenue", weekRevenue);
        model.addAttribute("dailyRevenue", dailyRevenue);
        model.addAttribute("dailyRevenueHeights", dailyRevenueHeights);
        model.addAttribute("cPct", String.format("%.0f", cPct));
        model.addAttribute("pPct", String.format("%.0f", pPct));
        model.addAttribute("oPct", String.format("%.0f", oPct));
        model.addAttribute("offsetCompleted", offsetCompleted);
        model.addAttribute("offsetPending", offsetPending);
        model.addAttribute("offsetOther", offsetOther);
        // --- End Business Overview ---
        
        // Calendar events - merge both booking systems
        List<in.sp.main.Entities.Booking> allBookingsList = bookingRepository.findBySalonId(salonId);
        java.util.List<java.util.Map<String, Object>> calendarEvents = new java.util.ArrayList<>();
        for (in.sp.main.Entities.Booking b : allBookingsList) {
            java.util.Map<String, Object> event = new java.util.HashMap<>();
            String serviceName = "Service";
            if (b.getSalonService() != null) serviceName = b.getSalonService().getName();
            else if (b.getService() != null) serviceName = b.getService().getName();
            String userName = b.getUser() != null && b.getUser().getFullName() != null ? b.getUser().getFullName() : "Client";
            event.put("title", userName + " - " + serviceName);
            if (b.getBookingTime() != null) {
                event.put("start", b.getBookingTime().toString());
                event.put("end", b.getBookingTime().plusMinutes(60).toString());
            }
            if (in.sp.main.Entities.BookingStatus.COMPLETED.equals(b.getStatus())) event.put("color", "#10b981");
            else if (in.sp.main.Entities.BookingStatus.PENDING.equals(b.getStatus())) event.put("color", "#f59e0b");
            else if (in.sp.main.Entities.BookingStatus.CANCELLED.equals(b.getStatus())) event.put("color", "#ef4444");
            else event.put("color", "#3b82f6");
            calendarEvents.add(event);
        }
        // Add Booking1 to calendar
        List<in.sp.main.Entities.Booking1> allBooking1List = booking1Repository.findBySalon(loggedSalon);
        for (in.sp.main.Entities.Booking1 b1 : allBooking1List) {
            if (b1.getBookingDate() != null && b1.getPreferredTime() != null) {
                java.util.Map<String, Object> event = new java.util.HashMap<>();
                String sn = "Service";
                if (b1.getService() != null) sn = b1.getService().getName();
                else if (b1.getTreatment() != null) sn = b1.getTreatment().getServiceName();
                String un = b1.getUser() != null && b1.getUser().getFullName() != null ? b1.getUser().getFullName() : "Client";
                event.put("title", un + " - " + sn);
                java.time.LocalDateTime startDT = java.time.LocalDateTime.of(b1.getBookingDate(), b1.getPreferredTime());
                event.put("start", startDT.toString());
                event.put("end", startDT.plusMinutes(60).toString());
                String st = b1.getStatus() != null ? b1.getStatus() : "PENDING";
                if ("COMPLETED".equals(st)) event.put("color", "#10b981");
                else if ("PENDING".equals(st)) event.put("color", "#f59e0b");
                else if ("CANCELLED".equals(st) || "REJECTED".equals(st)) event.put("color", "#ef4444");
                else event.put("color", "#3b82f6");
                calendarEvents.add(event);
            }
        }
        try {
            model.addAttribute("calendarEventsJson", new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(calendarEvents));
        } catch (Exception e) {}
        
        // Today's schedule from Booking1 (real customer appointments for today)
        List<in.sp.main.Entities.Booking1> todayBookingsList = booking1Repository.findBySalonAndBookingDate(loggedSalon, today);
        model.addAttribute("todayBookings", todayBookingsList);
        
        // Recent appointments (last 5 from Booking1, ordered by date desc)
        List<in.sp.main.Entities.Booking1> recentAll = booking1Repository.findBySalonOrderByBookingDateDesc(loggedSalon);
        model.addAttribute("recentBookings1", recentAll.size() > 5 ? recentAll.subList(0, 5) : recentAll);
        
        // Today's date display
        String todayDisplay = today.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, EEEE"));
        model.addAttribute("todayDate", todayDisplay);
        
        model.addAttribute("salon", loggedSalon);
        return "salon/salon-dashboard";
    }
    @GetMapping("/salons/profile")
    public String viewProfile(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";
        Optional<Salon> salonOpt = salonRepository.findById(loggedSalon.getId());
        if (salonOpt.isEmpty()) { session.invalidate(); return "redirect:/salons/login"; }
        Salon salon = salonOpt.get();
        model.addAttribute("salon", salon);
        
        int completionPercentage = 10; // Base 10% just for registering
        
        boolean basicDone = salon.getName() != null && !salon.getName().isEmpty() && salon.getPhone() != null && !salon.getPhone().isEmpty();
        if(basicDone) completionPercentage += 5;
        model.addAttribute("stepBasicInfo", basicDone);
        
        boolean detailsDone = salon.getSalonCategory() != null && !salon.getSalonCategory().isEmpty();
        if(detailsDone) completionPercentage += 15;
        model.addAttribute("stepSalonDetails", detailsDone);
        
        boolean servicesDone = true; // mock for now, assuming they have default service or wait until services module
        if(servicesDone) completionPercentage += 10;
        model.addAttribute("stepServices", servicesDone);
        
        boolean photosDone = salon.getProfileImageUrl() != null && !salon.getProfileImageUrl().isEmpty();
        if(photosDone) completionPercentage += 15;
        model.addAttribute("stepPhotos", photosDone);
        
        boolean facilitiesDone = salon.getHasAc() != null && (salon.getHasAc() || salon.getHasWifi() || salon.getHasParking());
        if(facilitiesDone) completionPercentage += 15;
        model.addAttribute("stepFacilities", facilitiesDone);
        
        boolean docsDone = salon.getBusinessRegistrationUrl() != null && !salon.getBusinessRegistrationUrl().isEmpty();
        if(docsDone) completionPercentage += 10;
        model.addAttribute("stepDocs", docsDone);
        model.addAttribute("docsCount", docsDone ? 5 : 0);
        model.addAttribute("docsTotal", 5);
        
        boolean socialDone = salon.getSocialMediaJson() != null && !salon.getSocialMediaJson().isEmpty() && !salon.getSocialMediaJson().contains("\"instagram\":\"\"");
        if(socialDone) completionPercentage += 10;
        model.addAttribute("stepSocial", socialDone);
        model.addAttribute("socialCount", socialDone ? 4 : 0);
        model.addAttribute("socialTotal", 4);
        
        boolean prefDone = salon.getPreferencesJson() != null && !salon.getPreferencesJson().isEmpty();
        if(prefDone) completionPercentage += 10;
        model.addAttribute("stepPref", prefDone);
        
        if (completionPercentage > 100) completionPercentage = 100;
        model.addAttribute("completionPercentage", completionPercentage);
        
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            if (salon.getPreferencesJson() != null && !salon.getPreferencesJson().isEmpty()) {
                model.addAttribute("salonPrefs", mapper.readValue(salon.getPreferencesJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){}));
            }
            java.util.Map<String, String> hoursMap = null;
            if (salon.getOperatingHoursJson() != null && !salon.getOperatingHoursJson().isEmpty()) {
                hoursMap = mapper.readValue(salon.getOperatingHoursJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){});
            }
            if (hoursMap == null || hoursMap.isEmpty()) {
                hoursMap = new java.util.HashMap<>();
                hoursMap.put("monday", "10:00 - 19:00");
                hoursMap.put("tuesday", "10:00 - 19:00");
                hoursMap.put("wednesday", "10:00 - 19:00");
                hoursMap.put("thursday", "10:00 - 19:00");
                hoursMap.put("friday", "10:00 - 19:00");
                hoursMap.put("saturday", "10:00 - 22:00");
                hoursMap.put("sunday", "10:00 - 22:00");
            }
            model.addAttribute("salonHours", hoursMap);
            
            java.util.Map<String, String> hoursDisplay = new java.util.HashMap<>();
            java.time.format.DateTimeFormatter format12 = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");
            for (java.util.Map.Entry<String, String> entry : hoursMap.entrySet()) {
                String val = entry.getValue();
                if (val != null && val.contains(" - ")) {
                    try {
                        String[] parts = val.split(" - ");
                        hoursDisplay.put(entry.getKey(), java.time.LocalTime.parse(parts[0]).format(format12) + " - " + java.time.LocalTime.parse(parts[1]).format(format12));
                    } catch(Exception e) { hoursDisplay.put(entry.getKey(), val); }
                } else { hoursDisplay.put(entry.getKey(), val); }
            }
            model.addAttribute("salonHoursDisplay", hoursDisplay);
            
        } catch(Exception e) {}
        
        return "salon/salon-profile";
    }

    @GetMapping("/salons/preview")
    public String previewProfile(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";
        model.addAttribute("salon", loggedSalon);
        
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            
            // Interior Images
            if (loggedSalon.getInteriorImagesJson() != null && !loggedSalon.getInteriorImagesJson().isEmpty()) {
                java.util.List<String> images = mapper.readValue(loggedSalon.getInteriorImagesJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.List<String>>(){});
                model.addAttribute("interiorImagesList", images);
            }
            
            // Preferences
            if (loggedSalon.getPreferencesJson() != null && !loggedSalon.getPreferencesJson().isEmpty()) {
                java.util.Map<String, String> prefsMap = mapper.readValue(loggedSalon.getPreferencesJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){});
                model.addAttribute("salonPrefs", prefsMap);
            }
            
            // Social Media
            if (loggedSalon.getSocialMediaJson() != null && !loggedSalon.getSocialMediaJson().isEmpty()) {
                java.util.Map<String, String> socialMap = mapper.readValue(loggedSalon.getSocialMediaJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){});
                model.addAttribute("salonSocial", socialMap);
            }
            
            // Hours Display
            java.util.Map<String, String> hoursMap = null;
            if (loggedSalon.getOperatingHoursJson() != null && !loggedSalon.getOperatingHoursJson().isEmpty()) {
                hoursMap = mapper.readValue(loggedSalon.getOperatingHoursJson(), new com.fasterxml.jackson.core.type.TypeReference<java.util.Map<String, String>>(){});
            }
            if (hoursMap != null) {
                java.util.Map<String, String> hoursDisplay = new java.util.HashMap<>();
                java.time.format.DateTimeFormatter format12 = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");
                for (java.util.Map.Entry<String, String> entry : hoursMap.entrySet()) {
                    String val = entry.getValue();
                    if (val != null && val.contains(" - ")) {
                        try {
                            String[] parts = val.split(" - ");
                            hoursDisplay.put(entry.getKey(), java.time.LocalTime.parse(parts[0]).format(format12) + " - " + java.time.LocalTime.parse(parts[1]).format(format12));
                        } catch(Exception e) { hoursDisplay.put(entry.getKey(), val); }
                    } else { hoursDisplay.put(entry.getKey(), val); }
                }
                model.addAttribute("salonHoursDisplay", hoursDisplay);
            }
        } catch(Exception e) {}
        
        return "salon/salon-preview";
    }

    @PostMapping("/salons/updateProfile")
    public String updateProfile(
            @ModelAttribute Salon updatedSalon,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "coverImage", required = false) MultipartFile coverImage,
            @RequestParam(value = "interiorImages", required = false) MultipartFile[] interiorImages,
            @RequestParam(value = "businessRegistration", required = false) MultipartFile businessRegistration,
            @RequestParam(value = "salonLicense", required = false) MultipartFile salonLicense,
            @RequestParam(value = "fireSafety", required = false) MultipartFile fireSafety,
            @RequestParam(value = "gstCertificate", required = false) MultipartFile gstCertificate,
            @RequestParam(value = "hygieneCertificate", required = false) MultipartFile hygieneCertificate,
            @RequestParam(value = "socialInstagram", required = false) String socialInstagram,
            @RequestParam(value = "socialFacebook", required = false) String socialFacebook,
            @RequestParam(value = "socialWebsite", required = false) String socialWebsite,
            jakarta.servlet.http.HttpServletRequest request,
            HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {

        Salon sessionSalon = (Salon) session.getAttribute("loggedSalon");
        if (sessionSalon == null) return "redirect:/salons/login";
        
        Optional<Salon> salonOpt = salonRepository.findById(updatedSalon.getId() != null ? updatedSalon.getId() : sessionSalon.getId());
        if (salonOpt.isPresent()) {
            Salon salon = salonOpt.get();
            
            salon.setName(updatedSalon.getName());
            salon.setEmail(updatedSalon.getEmail());
            salon.setPhone(updatedSalon.getPhone());
            salon.setAddress(updatedSalon.getAddress());
            salon.setCity(updatedSalon.getCity());
            salon.setState(updatedSalon.getState());
            salon.setPincode(updatedSalon.getPincode());
            salon.setWebsite(updatedSalon.getWebsite());
            salon.setBio(updatedSalon.getBio());
            salon.setSalonTagline(updatedSalon.getSalonTagline());
            salon.setSalonCategory(updatedSalon.getSalonCategory());
            salon.setEstablishedYear(updatedSalon.getEstablishedYear());
            salon.setAvailabilityHours(updatedSalon.getAvailabilityHours());
            salon.setIsWomenOnly(updatedSalon.getIsWomenOnly() != null ? updatedSalon.getIsWomenOnly() : false);
            salon.setCurrentStatus(updatedSalon.getCurrentStatus());
            
            salon.setBusinessRegistrationNo(updatedSalon.getBusinessRegistrationNo());
            salon.setGstNumber(updatedSalon.getGstNumber());
            salon.setSalonLicenseNo(updatedSalon.getSalonLicenseNo());
            salon.setAlternateNumber(updatedSalon.getAlternateNumber());
            salon.setHygieneStandard(updatedSalon.getHygieneStandard());
            salon.setLanguagesSpoken(updatedSalon.getLanguagesSpoken());
            salon.setLandmark(updatedSalon.getLandmark());
            salon.setHasReceptionArea(updatedSalon.getHasReceptionArea() != null ? updatedSalon.getHasReceptionArea() : false);
            salon.setHasWaitingArea(updatedSalon.getHasWaitingArea() != null ? updatedSalon.getHasWaitingArea() : false);
            
            salon.setSalonSizeSqFt(updatedSalon.getSalonSizeSqFt());
            salon.setTotalFloors(updatedSalon.getTotalFloors());
            salon.setTotalChairs(updatedSalon.getTotalChairs());
            salon.setTreatmentRooms(updatedSalon.getTreatmentRooms());
            salon.setWashrooms(updatedSalon.getWashrooms());
            
            salon.setHasParking(updatedSalon.getHasParking() != null ? updatedSalon.getHasParking() : false);
            salon.setHasAc(updatedSalon.getHasAc() != null ? updatedSalon.getHasAc() : false);
            salon.setHasWifi(updatedSalon.getHasWifi() != null ? updatedSalon.getHasWifi() : false);
            salon.setHasPowerBackup(updatedSalon.getHasPowerBackup() != null ? updatedSalon.getHasPowerBackup() : false);
            salon.setIsWheelchairAccessible(updatedSalon.getIsWheelchairAccessible() != null ? updatedSalon.getIsWheelchairAccessible() : false);
            
            String jsonSocial = String.format("{\"instagram\":\"%s\", \"facebook\":\"%s\", \"website\":\"%s\"}", 
                socialInstagram != null ? socialInstagram : "", 
                socialFacebook != null ? socialFacebook : "",
                socialWebsite != null ? socialWebsite : "");
            salon.setSocialMediaJson(jsonSocial);
            
            try {
                java.util.Map<String, String> prefsMap = new java.util.HashMap<>();
                for (java.util.Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
                    if (entry.getKey().startsWith("pref_")) prefsMap.put(entry.getKey(), entry.getValue()[0]);
                }
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                salon.setPreferencesJson(mapper.writeValueAsString(prefsMap));
                
                java.util.Map<String, String> hoursMap = new java.util.HashMap<>();
                String[] days = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"};
                for(String day : days) {
                    String open = request.getParameter("hours_" + day + "_open");
                    String close = request.getParameter("hours_" + day + "_close");
                    String isClosed = request.getParameter("hours_" + day + "_closed");
                    if (isClosed != null && isClosed.equals("true")) hoursMap.put(day, "Closed");
                    else if (open != null && !open.isEmpty() && close != null && !close.isEmpty()) hoursMap.put(day, open + " - " + close);
                    else hoursMap.put(day, "Not set");
                }
                if (request.getParameter("hours_monday_open") != null) salon.setOperatingHoursJson(mapper.writeValueAsString(hoursMap));
            } catch(Exception e) {}
            
            try {
                if (profileImage != null && !profileImage.isEmpty()) salon.setProfileImageUrl(fileUploadService.saveFile(profileImage));
                if (coverImage != null && !coverImage.isEmpty()) salon.setCoverImageUrl(fileUploadService.saveFile(coverImage));
                if (businessRegistration != null && !businessRegistration.isEmpty()) salon.setBusinessRegistrationUrl(fileUploadService.saveFile(businessRegistration));
                if (salonLicense != null && !salonLicense.isEmpty()) salon.setSalonLicenseUrl(fileUploadService.saveFile(salonLicense));
                if (fireSafety != null && !fireSafety.isEmpty()) salon.setFireSafetyUrl(fileUploadService.saveFile(fireSafety));
                if (gstCertificate != null && !gstCertificate.isEmpty()) salon.setGstCertificateUrl(fileUploadService.saveFile(gstCertificate));
                if (hygieneCertificate != null && !hygieneCertificate.isEmpty()) salon.setHygieneCertificateUrl(fileUploadService.saveFile(hygieneCertificate));
            } catch (Exception e) {}

            salonRepository.save(salon);
            session.setAttribute("loggedSalon", salon);
        }
        return "redirect:/salons/profile";
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
    @GetMapping({"/myStylists", "/salon/stylists"})
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
                return "redirect:/salon/stylists";
            }
        }
        model.addAttribute("error", "Stylist not found.");
        return "redirect:/salon/stylists";
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

        return "redirect:/salon/stylists";
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
            Optional<Service1> serviceOpt = serviceRepository.findById(id);
            if (serviceOpt.isPresent() && serviceOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
                serviceRepository.removeFromAllPackages(id);
                serviceRepository.removeFromAllOffers(id);
                serviceRepository.deleteBookingsForService(id);
                serviceRepository.deleteOldBookingsForService(id);
                serviceRepository.deleteOldBookingsForStylistService(id);
                
                serviceRepository.forceDeleteService(id);
                redirectAttributes.addFlashAttribute("successMessage", "Service deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Service not found or unauthorized.");
            }
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : e.getClass().getName();
            Throwable cause = e.getCause();
            if (cause != null) {
                errorMsg += " -> " + (cause.getMessage() != null ? cause.getMessage() : cause.getClass().getName());
            }
            redirectAttributes.addFlashAttribute("errorMessage",
                "Cannot delete this service. Error: " + errorMsg.replace("\"", "'").replace("\n", " "));
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

