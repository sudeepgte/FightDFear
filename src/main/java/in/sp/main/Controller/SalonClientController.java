package in.sp.main.Controller;

import java.util.ArrayList;
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

import in.sp.main.Entities.Booking;
import in.sp.main.Entities.Booking1;
import in.sp.main.Entities.OfferBooking;
import in.sp.main.Entities.BookingStatus;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonClient;
import in.sp.main.Entities.User;
import in.sp.main.Repository.BookingRepository;
import in.sp.main.Repository.Booking1Repository;
import in.sp.main.Repository.OfferBookingRepository;
import in.sp.main.Repository.SalonClientRepository;
import in.sp.main.Repository.UserRepository;
import java.util.HashSet;
import java.util.Set;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/salon/clients")
public class SalonClientController {

    @Autowired
    private SalonClientRepository salonClientRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private Booking1Repository booking1Repository;

    @Autowired
    private OfferBookingRepository offerBookingRepository;

    @GetMapping
    public String viewClientsDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        // Auto-create clients from new bookings
        List<Booking1> b1List = booking1Repository.findBySalon(loggedSalon);
        List<OfferBooking> obList = offerBookingRepository.findBySalonId(loggedSalon.getId());

        Set<User> allUsers = new HashSet<>();
        for (Booking1 b : b1List) if(b.getUser() != null) allUsers.add(b.getUser());
        for (OfferBooking ob : obList) if(ob.getUser() != null) allUsers.add(ob.getUser());

        for (User u : allUsers) {
            Optional<SalonClient> scOpt = salonClientRepository.findBySalonIdAndUserId(loggedSalon.getId(), u.getId());
            if (scOpt.isEmpty()) {
                SalonClient sc = new SalonClient();
                sc.setSalon(loggedSalon);
                sc.setUser(u);
                salonClientRepository.save(sc);
            }
        }

        List<SalonClient> clients = salonClientRepository.findBySalonId(loggedSalon.getId());
        
        List<Map<String, Object>> clientDataList = new ArrayList<>();
        
        int totalClients = clients.size();
        int activeClients = 0;
        int newClients = 0;
        int returningClients = 0;

        for (SalonClient client : clients) {
            int visits = 0;
            double totalSpent = 0;
            String lastVisit = "Never";
            java.time.LocalDate latestDate = null;
            
            // Legacy bookings
            List<Booking> legacyBookings = bookingRepository.findBySalonIdAndUserId(loggedSalon.getId(), client.getUser().getId());
            for (Booking b : legacyBookings) {
                visits++;
                if (b.getStatus() == BookingStatus.COMPLETED && b.getPricePaid() != null) {
                    totalSpent += b.getPricePaid();
                }
                if (b.getBookingTime() != null) {
                    java.time.LocalDate d = b.getBookingTime().toLocalDate();
                    if (latestDate == null || d.isAfter(latestDate)) latestDate = d;
                }
            }

            // Booking1 (services & treatments)
            for (Booking1 b1 : b1List) {
                if (b1.getUser() != null && b1.getUser().getId().equals(client.getUser().getId())) {
                    visits++;
                    if ("COMPLETED".equalsIgnoreCase(b1.getStatus())) {
                        totalSpent += b1.getPrice();
                    }
                    if (b1.getBookingDate() != null) {
                        if (latestDate == null || b1.getBookingDate().isAfter(latestDate)) latestDate = b1.getBookingDate();
                    }
                }
            }

            // OfferBookings
            for (OfferBooking ob : obList) {
                if (ob.getUser() != null && ob.getUser().getId().equals(client.getUser().getId())) {
                    visits++;
                    if ("COMPLETED".equalsIgnoreCase(ob.getStatus())) {
                        double price = ob.getOriginalPrice();
                        if (ob.getOffer() != null) {
                            price = price - (price * ob.getOffer().getDiscountPercent() / 100.0);
                        }
                        totalSpent += price;
                    }
                    if (ob.getDate() != null) {
                        if (latestDate == null || ob.getDate().isAfter(latestDate)) latestDate = ob.getDate();
                    }
                }
            }

            if (latestDate != null) {
                lastVisit = latestDate.toString();
            }
            
            String status = "New";
            if(visits == 0) {
                status = "New";
                newClients++;
            } else if (visits == 1) {
                status = "Active";
                activeClients++;
            } else {
                status = "Returning";
                returningClients++;
                activeClients++;
            }

            Map<String, Object> data = new HashMap<>();
            data.put("client", client);
            data.put("visits", visits);
            data.put("totalSpent", totalSpent);
            data.put("lastVisit", lastVisit);
            data.put("status", status);
            clientDataList.add(data);
        }

        model.addAttribute("clientsData", clientDataList);
        model.addAttribute("totalClients", totalClients);
        model.addAttribute("newClients", newClients);
        model.addAttribute("returningClients", returningClients);
        model.addAttribute("activeClients", activeClients);
        
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-clients";
    }

    @PostMapping("/add")
    public String addClient(@RequestParam("fullName") String fullName,
                            @RequestParam("phoneNumber") String phoneNumber,
                            @RequestParam(value="email", required=false) String email,
                            @RequestParam(value="dob", required=false) String dob,
                            @RequestParam(value="gender", required=false) String genderStr,
                            @RequestParam(value="homeAddress", required=false) String address,
                            @RequestParam(value="clientNotes", required=false) String clientNotes,
                            @RequestParam(value="preferences", required=false) String preferences,
                            HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<User> existingUserOpt = userRepository.findByPhoneNumber(phoneNumber);
        User user;
        if (existingUserOpt.isPresent()) {
            user = existingUserOpt.get();
            Optional<SalonClient> existingClient = salonClientRepository.findBySalonIdAndUserId(loggedSalon.getId(), user.getId());
            if (existingClient.isPresent()) {
                session.setAttribute("errorMsg", "This client already exists.");
                return "redirect:/salon/clients/view/" + existingClient.get().getId();
            }
        } else {
            user = new User();
            user.setFullName(fullName);
            user.setPhoneNumber(phoneNumber);
            user.setEmail(email);
            user.setDob(dob);
            user.setHomeAddress(address);
            if (genderStr != null && !genderStr.isEmpty()) {
                try {
                    user.setGender(Gender.valueOf(genderStr.toUpperCase()));
                } catch(Exception e) {}
            }
            userRepository.save(user);
        }

        SalonClient client = new SalonClient();
        client.setSalon(loggedSalon);
        client.setUser(user);
        client.setClientNotes(clientNotes);
        client.setPreferences(preferences);
        salonClientRepository.save(client);
        
        session.setAttribute("successMsg", "Client added successfully.");
        return "redirect:/salon/clients";
    }

    @GetMapping("/view/{id}")
    public String viewClient(@PathVariable("id") Long id, HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonClient> clientOpt = salonClientRepository.findById(id);
        if (clientOpt.isEmpty() || !clientOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            return "redirect:/salon/clients";
        }

        SalonClient client = clientOpt.get();
        List<Map<String, Object>> unifiedBookings = new ArrayList<>();
        int visits = 0;
        double totalSpent = 0;
        
        // Legacy
        List<Booking> legacyBookings = bookingRepository.findBySalonIdAndUserIdOrderByBookingTimeDesc(loggedSalon.getId(), client.getUser().getId());
        for (Booking b : legacyBookings) {
            visits++;
            if (b.getStatus() == BookingStatus.COMPLETED && b.getPricePaid() != null) {
                totalSpent += b.getPricePaid();
            }
            Map<String, Object> map = new HashMap<>();
            map.put("status", b.getStatus().toString());
            map.put("dateTime", b.getBookingTime().toString());
            map.put("displayDate", b.getBookingTime().format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")));
            map.put("serviceName", b.getSalonService() != null ? b.getSalonService().getName() : "Custom Service");
            map.put("stylistName", b.getStylist() != null ? b.getStylist().getFirstName() : "Any");
            map.put("pricePaid", b.getPricePaid());
            map.put("sortDate", b.getBookingTime());
            unifiedBookings.add(map);
        }

        // Booking1
        List<Booking1> b1List = booking1Repository.findByUser(client.getUser());
        for (Booking1 b1 : b1List) {
            if (b1.getSalon() != null && b1.getSalon().getId().equals(loggedSalon.getId())) {
                visits++;
                if ("COMPLETED".equalsIgnoreCase(b1.getStatus())) {
                    totalSpent += b1.getPrice();
                }
                Map<String, Object> map = new HashMap<>();
                map.put("status", b1.getStatus());
                map.put("dateTime", b1.getBookingDate() + "T" + b1.getPreferredTime());
                java.time.LocalDateTime ldt = java.time.LocalDateTime.of(b1.getBookingDate(), b1.getPreferredTime());
                map.put("displayDate", ldt.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")));
                map.put("serviceName", b1.getService() != null ? b1.getService().getName() : (b1.getTreatment() != null ? b1.getTreatment().getServiceName() : "Service"));
                map.put("stylistName", "Any");
                map.put("pricePaid", b1.getPrice());
                map.put("sortDate", java.time.LocalDateTime.of(b1.getBookingDate(), b1.getPreferredTime()));
                unifiedBookings.add(map);
            }
        }

        // OfferBooking
        List<OfferBooking> obList = offerBookingRepository.findByUser(client.getUser());
        for (OfferBooking ob : obList) {
            if (ob.getSalon() != null && ob.getSalon().getId().equals(loggedSalon.getId())) {
                visits++;
                double price = ob.getOriginalPrice();
                if (ob.getOffer() != null) {
                    price = price - (price * ob.getOffer().getDiscountPercent() / 100.0);
                }
                if ("COMPLETED".equalsIgnoreCase(ob.getStatus())) {
                    totalSpent += price;
                }
                Map<String, Object> map = new HashMap<>();
                map.put("status", ob.getStatus());
                map.put("dateTime", ob.getDate() + "T" + ob.getTime());
                java.time.LocalDateTime ldt = java.time.LocalDateTime.of(ob.getDate(), ob.getTime());
                map.put("displayDate", ldt.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")));
                map.put("serviceName", ob.getOffer() != null ? ob.getOffer().getTitle() : "Offer");
                map.put("stylistName", "Any");
                map.put("pricePaid", price);
                map.put("sortDate", java.time.LocalDateTime.of(ob.getDate(), ob.getTime()));
                unifiedBookings.add(map);
            }
        }

        // sort unifiedBookings by sortDate descending
        unifiedBookings.sort((m1, m2) -> {
            java.time.LocalDateTime d1 = (java.time.LocalDateTime) m1.get("sortDate");
            java.time.LocalDateTime d2 = (java.time.LocalDateTime) m2.get("sortDate");
            return d2.compareTo(d1);
        });
        
        double avgSpent = visits > 0 ? totalSpent / visits : 0;
        
        model.addAttribute("client", client);
        model.addAttribute("bookings", unifiedBookings);
        model.addAttribute("totalVisits", visits);
        model.addAttribute("totalSpent", totalSpent);
        model.addAttribute("avgSpent", avgSpent);
        
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            model.addAttribute("error", errorMsg);
            session.removeAttribute("errorMsg");
        }
        
        return "salon/salon-client-view";
    }
}
