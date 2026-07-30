package in.sp.main.Controller;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Service.PasswordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Public mobile APIs for Glow Space provider onboarding.
 */
@RestController
@RequestMapping("/api/glow/provider")
public class MobileGlowProviderAuthController {

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private PasswordService passwordService;

    @PostMapping("/register/salon")
    public ResponseEntity<Map<String, Object>> registerSalon(@RequestBody Map<String, String> body) {
        Map<String, Object> res = new LinkedHashMap<>();
        if (body == null) return badRequest("Request body is required");

        String name = trim(body.get("name"));
        String username = trim(body.get("username")).toLowerCase();
        String phone = trim(body.get("phone"));
        String city = trim(body.get("city"));
        String password = body.getOrDefault("password", "");
        String confirmPassword = body.getOrDefault("confirmPassword", "");
        String bio = trim(body.get("bio"));
        String availabilityHours = trim(body.get("availabilityHours"));
        String address = trim(body.get("address"));

        if (name.isBlank() || username.isBlank() || password.isBlank()) {
            return badRequest("name, username and password are required");
        }
        if (!password.equals(confirmPassword)) {
            return badRequest("Passwords do not match");
        }
        if (password.length() < 6) {
            return badRequest("Password must be at least 6 characters");
        }
        Optional<Salon> existing = salonRepository.findByUsername(username);
        if (existing.isPresent()) {
            res.put("success", false);
            res.put("error", "Username already registered");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(res);
        }

        Salon salon = new Salon();
        salon.setName(name);
        salon.setUsername(username);
        salon.setPassword(passwordService.encode(password));
        salon.setPhone(phone.isBlank() ? null : phone);
        salon.setCity(city.isBlank() ? null : city);
        salon.setAddress(address.isBlank() ? null : address);
        salon.setBio(bio.isBlank() ? null : bio);
        salon.setAvailabilityHours(availabilityHours.isBlank() ? null : availabilityHours);
        // Mobile flow does not upload files in this phase.
        salon.setHygieneCertificateUrl("mobile-pending");
        salon.setApproved(false);

        salonRepository.save(salon);

        res.put("success", true);
        res.put("message", "Salon registration submitted. Await admin verification.");
        res.put("providerType", "SALON");
        res.put("salonId", salon.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/register/stylist")
    public ResponseEntity<Map<String, Object>> registerStylist(@RequestBody Map<String, String> body) {
        Map<String, Object> res = new LinkedHashMap<>();
        if (body == null) return badRequest("Request body is required");

        String firstName = trim(body.get("firstName"));
        String lastName = trim(body.get("lastName"));
        String email = trim(body.get("email")).toLowerCase();
        String contactNumber = trim(body.get("contactNumber"));
        String password = body.getOrDefault("password", "");
        String confirmPassword = body.getOrDefault("confirmPassword", "");
        String specialization = trim(body.get("specialization"));
        String bio = trim(body.get("bio"));
        String availabilityHours = trim(body.get("availabilityHours"));

        if (firstName.isBlank() || email.isBlank() || password.isBlank()) {
            return badRequest("firstName, email and password are required");
        }
        if (!password.equals(confirmPassword)) {
            return badRequest("Passwords do not match");
        }
        if (password.length() < 6) {
            return badRequest("Password must be at least 6 characters");
        }
        if (stylistRepository.findByEmail(email).isPresent()) {
            res.put("success", false);
            res.put("error", "Email already registered");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(res);
        }

        Stylist stylist = new Stylist();
        stylist.setFirstName(firstName);
        stylist.setLastName(lastName.isBlank() ? null : lastName);
        stylist.setEmail(email);
        stylist.setContactNumber(contactNumber.isBlank() ? null : contactNumber);
        stylist.setPassword(passwordService.encode(password));
        stylist.setSpecialization(specialization.isBlank() ? null : specialization);
        stylist.setBio(bio.isBlank() ? null : bio);
        stylist.setAvailabilityHours(availabilityHours.isBlank() ? null : availabilityHours);
        stylist.setAvailable(true);
        stylist.setRating(0.0);
        stylist.setIsIndependent(true);
        stylist.setApproved(false);

        stylistRepository.save(stylist);

        res.put("success", true);
        res.put("message", "Stylist registration submitted. Await admin verification.");
        res.put("providerType", "STYLIST");
        res.put("stylistId", stylist.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", error
        ));
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
