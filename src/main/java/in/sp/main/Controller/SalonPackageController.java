package in.sp.main.Controller;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonPackage;
import in.sp.main.Entities.SalonMembership;
import in.sp.main.Entities.Service1;
import in.sp.main.Repository.SalonPackageRepository;
import in.sp.main.Repository.SalonMembershipRepository;
import in.sp.main.Repository.ServiceRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/salon/packages")
public class SalonPackageController {

    @Autowired
    private SalonPackageRepository salonPackageRepository;

    @Autowired
    private SalonMembershipRepository salonMembershipRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @GetMapping
    public String viewPackages(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<SalonPackage> packages = salonPackageRepository.findBySalonId(loggedSalon.getId());
        List<SalonMembership> memberships = salonMembershipRepository.findBySalonId(loggedSalon.getId());
        List<Service1> salonServices = serviceRepository.findBySalonId(loggedSalon.getId());

        model.addAttribute("packages", packages);
        model.addAttribute("memberships", memberships);
        model.addAttribute("salonServices", salonServices);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            model.addAttribute("error", errorMsg);
            session.removeAttribute("errorMsg");
        }

        return "salon/salon-packages";
    }

    @PostMapping("/addPackage")
    public String addPackage(@RequestParam("packageName") String packageName,
                             @RequestParam("description") String description,
                             @RequestParam("price") Double price,
                             @RequestParam(value = "serviceIds", required = false) List<Long> serviceIds,
                             HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        SalonPackage newPackage = new SalonPackage();
        newPackage.setSalon(loggedSalon);
        newPackage.setPackageName(packageName);
        newPackage.setDescription(description);
        newPackage.setPrice(price);
        newPackage.setDurationInDays(0);
        newPackage.setIsActive(true);

        List<Service1> includedServices = new ArrayList<>();
        if (serviceIds != null) {
            for (Long id : serviceIds) {
                serviceRepository.findById(id).ifPresent(includedServices::add);
            }
        }
        newPackage.setIncludedServices(includedServices);

        salonPackageRepository.save(newPackage);
        session.setAttribute("successMsg", "Package created successfully!");
        
        return "redirect:/salon/packages";
    }

    @PostMapping("/addMembership")
    public String addMembership(@RequestParam("membershipName") String membershipName,
                                @RequestParam("benefits") String benefits,
                                @RequestParam("price") Double price,
                                @RequestParam("durationInMonths") Integer durationInMonths,
                                HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        SalonMembership newMembership = new SalonMembership();
        newMembership.setSalon(loggedSalon);
        newMembership.setMembershipName(membershipName);
        newMembership.setBenefits(benefits);
        newMembership.setPrice(price);
        newMembership.setDurationInMonths(durationInMonths);
        newMembership.setIsActive(true);

        salonMembershipRepository.save(newMembership);
        session.setAttribute("successMsg", "Membership created successfully!");
        
        return "redirect:/salon/packages";
    }

    @PostMapping("/togglePackage")
    public String togglePackage(@RequestParam("packageId") Long packageId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonPackage> pkgOpt = salonPackageRepository.findById(packageId);
        if (pkgOpt.isPresent() && pkgOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            SalonPackage pkg = pkgOpt.get();
            pkg.setIsActive(!pkg.getIsActive());
            salonPackageRepository.save(pkg);
            session.setAttribute("successMsg", "Package status updated.");
        } else {
            session.setAttribute("errorMsg", "Package not found.");
        }

        return "redirect:/salon/packages";
    }

    @PostMapping("/toggleMembership")
    public String toggleMembership(@RequestParam("membershipId") Long membershipId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonMembership> memOpt = salonMembershipRepository.findById(membershipId);
        if (memOpt.isPresent() && memOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            SalonMembership mem = memOpt.get();
            mem.setIsActive(!mem.getIsActive());
            salonMembershipRepository.save(mem);
            session.setAttribute("successMsg", "Membership status updated.");
        } else {
            session.setAttribute("errorMsg", "Membership not found.");
        }

        return "redirect:/salon/packages";
    }

    @PostMapping("/deletePackage")
    public String deletePackage(@RequestParam("packageId") Long packageId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonPackage> pkgOpt = salonPackageRepository.findById(packageId);
        if (pkgOpt.isPresent() && pkgOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            salonPackageRepository.delete(pkgOpt.get());
            session.setAttribute("successMsg", "Package deleted successfully.");
        } else {
            session.setAttribute("errorMsg", "Package not found.");
        }

        return "redirect:/salon/packages";
    }

    @PostMapping("/deleteMembership")
    public String deleteMembership(@RequestParam("membershipId") Long membershipId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<SalonMembership> memOpt = salonMembershipRepository.findById(membershipId);
        if (memOpt.isPresent() && memOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            salonMembershipRepository.delete(memOpt.get());
            session.setAttribute("successMsg", "Membership deleted successfully.");
        } else {
            session.setAttribute("errorMsg", "Membership not found.");
        }

        return "redirect:/salon/packages";
    }
}
