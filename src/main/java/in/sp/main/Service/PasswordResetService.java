package in.sp.main.Service;

import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.PasswordResetToken;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.Stylist;
import in.sp.main.Entities.User;
import in.sp.main.Entities.UserType;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Entities.Investor;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.EventHost;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.PasswordResetTokenRepository;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WomenProductSellerRepository;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Repository.InvestorRepository;
import in.sp.main.Repository.FitnessTrainerRepository;
import in.sp.main.Repository.EventHostRepository;

@Service
public class PasswordResetService {

    @Autowired private UserRepository userRepository;
    @Autowired private AdminRepository adminRepository;
    @Autowired private MartialArtsCenterRepository centreRepository;
    @Autowired private DoctorRepository doctorRepository;
    @Autowired private StylistRepository stylistRepository;
    @Autowired private SalonRepository salonRepository;
    @Autowired private ServiceProviderRepository providerRepository;
    @Autowired private WomenProductSellerRepository sellerRepository;
    @Autowired private EntrepreneurRepository entrepreneurRepository;
    @Autowired private InvestorRepository investorRepository;
    @Autowired private FitnessTrainerRepository fitnessTrainerRepository;
    @Autowired private EventHostRepository eventHostRepository;
    @Autowired private PasswordResetTokenRepository tokenRepository;
    @Autowired private JavaMailSender mailSender;
    @Autowired private PasswordService passwordService;

    @Value("${app.base-url}")
    private String baseUrl;

    private static final int EXPIRATION_TIME = 15;

    public String createPasswordResetToken(String email) {
        String normEmail = email.trim().toLowerCase();
        Optional<User> user = userRepository.findByEmail(normEmail);
        Optional<Admin> admin = adminRepository.findByEmail(normEmail);
        Optional<MartialArtsCenter> centre = centreRepository.findByEmail(normEmail);
        Optional<Doctor> doctor = doctorRepository.findByEmail(normEmail);
        Optional<Stylist> stylist = stylistRepository.findByEmail(normEmail);
        Optional<Salon> salon = salonRepository.findByUsername(normEmail); // Salon uses username
        Optional<ServiceProvider> provider = providerRepository.findByEmail(normEmail);
        Optional<WomenProductSeller> seller = sellerRepository.findByEmail(normEmail);
        Optional<Entrepreneur> entrepreneur = entrepreneurRepository.findByEmail(normEmail);
        Optional<Investor> investor = investorRepository.findByEmail(normEmail);
        Optional<FitnessTrainer> fitnessTrainer = fitnessTrainerRepository.findByEmail(normEmail);
        Optional<EventHost> eventHost = eventHostRepository.findByEmail(normEmail);

        UserType userType = null;
        if (user.isPresent()) userType = UserType.USER;
        else if (admin.isPresent()) userType = UserType.ADMIN;
        else if (centre.isPresent()) userType = UserType.CENTRE;
        else if (doctor.isPresent()) userType = UserType.DOCTOR;
        else if (stylist.isPresent()) userType = UserType.STYLIST;
        else if (salon.isPresent()) userType = UserType.SALON;
        else if (provider.isPresent()) userType = UserType.PROVIDER;
        else if (seller.isPresent()) userType = UserType.SELLER;
        else if (entrepreneur.isPresent()) userType = UserType.ENTREPRENEUR;
        else if (investor.isPresent()) userType = UserType.INVESTOR;
        else if (fitnessTrainer.isPresent()) userType = UserType.FITNESS_TRAINER;
        else if (eventHost.isPresent()) userType = UserType.EVENT_HOST;
        else return "Email not found";

        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = new PasswordResetToken(normEmail, token, userType, EXPIRATION_TIME);
        tokenRepository.save(resetToken);

        sendResetEmail(normEmail, token, userType);
        return "Reset email sent successfully";
    }

    private void sendResetEmail(String email, String token, UserType userType) {
        String resetUrl = UriComponentsBuilder.fromHttpUrl(trimTrailingSlash(baseUrl))
                .path("/auth/reset-password")
                .queryParam("token", token)
                .queryParam("type", userType.name())
                .build()
                .toUriString();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Password Reset Request");
        message.setText("You requested a password reset for your Fight D Fear account.\n\n"
                + "Reset your password using this link:\n"
                + resetUrl + "\n\n"
                + "This link expires in " + EXPIRATION_TIME + " minutes.\n"
                + "If you did not request this, you can ignore this email.");
        mailSender.send(message);
    }

    private static String trimTrailingSlash(String url) {
        if (url == null || url.isEmpty()) {
            return url;
        }
        return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    public String resetPassword(String token, String newPassword) {
        Optional<PasswordResetToken> tokenOpt = tokenRepository.findByToken(token);
        if (tokenOpt.isEmpty() || tokenOpt.get().isExpired()) {
            return "Invalid or expired token";
        }

        PasswordResetToken resetToken = tokenOpt.get();
        String email = resetToken.getEmail();
        UserType userType = resetToken.getUserType();
        String encodedPassword = passwordService.encode(newPassword);

        switch (userType) {
            case USER:
                userRepository.findByEmail(email).ifPresent(user -> {
                    user.setPassword(encodedPassword);
                    userRepository.save(user);
                });
                break;
            case ADMIN:
                adminRepository.findByEmail(email).ifPresent(admin -> {
                    admin.setPassword(encodedPassword);
                    adminRepository.save(admin);
                });
                break;
            case CENTRE:
                centreRepository.findByEmail(email).ifPresent(centre -> {
                    centre.setPassword(encodedPassword);
                    centreRepository.save(centre);
                });
                break;
            case DOCTOR:
                doctorRepository.findByEmail(email).ifPresent(doctor -> {
                    doctor.setPassword(encodedPassword);
                    doctorRepository.save(doctor);
                });
                break;
            case STYLIST:
                stylistRepository.findByEmail(email).ifPresent(stylist -> {
                    stylist.setPassword(encodedPassword);
                    stylistRepository.save(stylist);
                });
                break;
            case SALON:

                salonRepository.findByUsername(email).ifPresent(salon -> {

                    salon.setPassword(encodedPassword);

                    salonRepository.save(salon);

                });

                break;
            case PROVIDER:
                providerRepository.findByEmail(email).ifPresent(provider -> {
                    provider.setPassword(encodedPassword);
                    providerRepository.save(provider);
                });
                break;
            case SELLER:
                sellerRepository.findByEmail(email).ifPresent(seller -> {
                    seller.setPassword(encodedPassword);
                    sellerRepository.save(seller);
                });
                break;
            case ENTREPRENEUR:
                entrepreneurRepository.findByEmail(email).ifPresent(ent -> {
                    ent.setPassword(encodedPassword);
                    entrepreneurRepository.save(ent);
                });
                break;
            case INVESTOR:
                investorRepository.findByEmail(email).ifPresent(inv -> {
                    inv.setPassword(encodedPassword);
                    investorRepository.save(inv);
                });
                break;
            case FITNESS_TRAINER:
                fitnessTrainerRepository.findByEmail(email).ifPresent(ft -> {
                    ft.setPassword(encodedPassword);
                    fitnessTrainerRepository.save(ft);
                });
                break;
            case EVENT_HOST:
                eventHostRepository.findByEmail(email).ifPresent(eh -> {
                    eh.setPassword(encodedPassword);
                    eventHostRepository.save(eh);
                });
                break;
        }

        tokenRepository.delete(resetToken);
        return "Password reset successful";
    }
}