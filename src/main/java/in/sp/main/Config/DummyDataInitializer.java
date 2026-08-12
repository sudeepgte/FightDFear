package in.sp.main.Config;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Entities.ServiceCategory;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.ServiceRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DummyDataInitializer implements CommandLineRunner {

    private final SalonRepository salonRepository;
    private final ServiceRepository serviceRepository;

    public DummyDataInitializer(SalonRepository salonRepository, ServiceRepository serviceRepository) {
        this.salonRepository = salonRepository;
        this.serviceRepository = serviceRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Checking if services need to be initialized...");
        List<Salon> salons = salonRepository.findAll();
        for (Salon salon : salons) {
            List<Service1> services = serviceRepository.findBySalonId(salon.getId());
            if (services.size() < 18) {
                System.out.println("Initializing services for salon: " + salon.getName());
                
                String[][] defaultServices = {
                        // Hair Stylist (HAIR)
                        {"Hair Spa", "1500.0", "HAIR"},
                        {"Keratin Treatment", "4500.0", "HAIR"},
                        {"Hair Cut & Styling", "800.0", "HAIRCUT"},
                        {"Hair Color (Global)", "3500.0", "HAIR_COLOR"},
                        {"Root Touch Up", "1200.0", "HAIR_COLOR"},
                        {"Hair Botox", "5000.0", "HAIRCUT"},
                        
                        // Beauty Services
                        {"Skin Brightening Facial", "2500.0", "SKIN_CARE"},
                        {"Gold Facial", "3500.0", "FACIAL"},
                        {"Bridal Makeup", "15000.0", "BRIDAL"},
                        {"Party Makeup", "4500.0", "MAKEUP"},
                        {"Threading (Eyebrows)", "100.0", "THREADING"},
                        {"Gel Nail Extension", "1200.0", "NAIL_CARE"},
                        {"Full Body Waxing", "2000.0", "WAXING"},
                        {"Mehendi Art", "500.0", "MEHENDI"},
                        
                        // Wellness Services
                        {"Body Spa", "3000.0", "SPA_MASSAGE"},
                        {"Deep Tissue Massage", "3500.0", "MASSAGE"},
                        {"Aromatherapy Massage", "2800.0", "SPA"},
                        {"Reflexology", "1500.0", "WELLNESS"},
                        {"Wellness Package (Basic)", "4500.0", "PACKAGES"},
                        {"Wellness Package (Premium)", "7500.0", "PACKAGES"}
                };

                for (String[] svcData : defaultServices) {
                    Service1 svc = new Service1();
                    svc.setName(svcData[0]);
                    svc.setPrice(Double.parseDouble(svcData[1]));
                    try {
                        svc.setCategory(ServiceCategory.valueOf(svcData[2]));
                    } catch (Exception e) {
                        // ignore if category is invalid
                    }
                    svc.setDurationMinutes(60);
                    svc.setSalon(salon);
                    serviceRepository.save(svc);
                }
            }
        }
    }
}
