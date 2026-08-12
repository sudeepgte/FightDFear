package in.sp.main.Controller;

import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.*;
import in.sp.main.Service.MartialArtsCenterService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalSidebarAdvice {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private MartialArtsCenterService centreService;
    
    @Autowired
    private DoctorRepository doctorRepository;
    
    @Autowired
    private ServiceProviderRepository serviceProviderRepository;
    
    @Autowired
    private SalonRepository salonRepository;
    
    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private WomenProductSellerRepository womenProductSellerRepository;

    @Autowired
    private FitnessTrainerRepository fitnessTrainerRepository;

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private BusinessProposalRepository businessProposalRepository;

    @Autowired
    private EventHostRepository eventHostRepository;

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Autowired
    private FinancialEducatorRepository financialEducatorRepository;

    @Autowired
    private WomenEventRepository womenEventRepository;

    @ModelAttribute
    public void addSidebarCounts(Model model, HttpSession session) {
        if (session.getAttribute("admin") != null) {
            try {
                long pendingUsers = userRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
                long pendingCentres = centreService.getCentresByApprovalStatus(false).size();
                long pendingDoctors = doctorRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
                long pendingSellers = womenProductSellerRepository.findByVerificationStatus(VerificationStatus.PENDING).size()
                        + serviceProviderRepository.findByCategoryAndVerificationStatus(
                                in.sp.main.Entities.ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.PENDING).size();
                long pendingTrainers = 0;
                try {
                    pendingTrainers = fitnessTrainerRepository
                            .findByPartnerProfileStatusIn(in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses())
                            .size();
                } catch (Exception ignored) {
                    pendingTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
                }
                long pendingSalons = 0;
                try {
                    pendingSalons = salonRepository
                            .findByPartnerProfileStatusIn(in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses())
                            .size();
                } catch (Exception ignored) {
                    pendingSalons = salonRepository.findByApproved(false).size();
                }
                long pendingStylists = 0;
                try {
                    pendingStylists = stylistRepository
                            .findByPartnerProfileStatusIn(in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses())
                            .size();
                } catch (Exception ignored) {
                    pendingStylists = stylistRepository.findByApproved(false).size();
                }
                long pendingLawyers = serviceProviderRepository.findByCategoryAndVerificationStatus(
                        in.sp.main.Entities.ProviderCategory.WOMEN_LAWYER, VerificationStatus.PENDING).size();
                long pendingFitness = serviceProviderRepository.findByCategoryAndVerificationStatus(
                        in.sp.main.Entities.ProviderCategory.FITNESS_ZUMBA, VerificationStatus.PENDING).size();
                long unreadContactMessages = contactMessageRepository.countByReadByAdminFalse();
                
                long pendingProposals = businessProposalRepository.findByStatus(VerificationStatus.PENDING).size();
                long pendingEnt = entrepreneurRepository.findAll().stream()
                        .filter(e -> e.getVerificationStatus() == VerificationStatus.PENDING).count();
                long pendingInv = investorRepository.findAll().stream()
                        .filter(i -> i.getVerificationStatus() == VerificationStatus.PENDING).count();
                long sidePendingProposals = pendingProposals + pendingEnt + pendingInv;

                long pendingEventHosts = eventHostRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
                long pendingWomenEvents = womenEventRepository.findByStatusOrderByCreatedAtDesc("PENDING").size();
                long sidePendingEventHosts = pendingEventHosts + pendingWomenEvents;
                long pendingJobApplications = jobApplicationRepository.countByStatus(VerificationStatus.PENDING);
                long pendingDeliveryPartners = 0;
                try {
                    pendingDeliveryPartners = deliveryPartnerRepository
                            .findByPartnerProfileStatusIn(in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses())
                            .size();
                } catch (Exception ignored) {
                    pendingDeliveryPartners = deliveryPartnerRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
                }
                long pendingCreators = 0;
                try {
                    pendingCreators = userRepository.countByCreatorProfileStatusIn(
                            in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingCreators = 0;
                }
                long pendingEducators = 0;
                try {
                    pendingEducators = financialEducatorRepository.countByPartnerProfileStatusIn(
                            in.sp.main.Service.PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingEducators = 0;
                }

                model.addAttribute("side_pendingUsers", pendingUsers);
                model.addAttribute("side_pendingCentres", pendingCentres);
                model.addAttribute("side_pendingDoctors", pendingDoctors);
                model.addAttribute("side_pendingSellers", pendingSellers);
                model.addAttribute("side_pendingSalons", pendingSalons);
                model.addAttribute("side_pendingStylists", pendingStylists);
                model.addAttribute("side_pendingLawyers", pendingLawyers);
                model.addAttribute("side_pendingFitness", pendingFitness);
                model.addAttribute("side_pendingTrainers", pendingTrainers);
                model.addAttribute("side_unreadContactMessages", unreadContactMessages);
                model.addAttribute("side_pendingProposals", sidePendingProposals);
                model.addAttribute("side_pendingEventHosts", sidePendingEventHosts);
                model.addAttribute("side_pendingJobApplications", pendingJobApplications);
                model.addAttribute("side_pendingDeliveryPartners", pendingDeliveryPartners);
                model.addAttribute("side_pendingCreators", pendingCreators);
                model.addAttribute("side_pendingEducators", pendingEducators);
            } catch (Exception e) {
                // Fail gracefully
            }
        }
    }
}
