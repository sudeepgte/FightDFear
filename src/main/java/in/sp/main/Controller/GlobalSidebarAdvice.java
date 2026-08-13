package in.sp.main.Controller;

import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.*;
import in.sp.main.Service.PartnerLifecycleSupport;
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
    private MartialArtsCenterRepository centreRepository;

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
                long pendingUsers = userRepository.countByVerificationStatus(VerificationStatus.PENDING);
                long pendingCentres = centreRepository.countByApproved(false);
                long pendingDoctors = doctorRepository.countByVerificationStatus(VerificationStatus.PENDING);
                long pendingSellers = womenProductSellerRepository.countByVerificationStatus(VerificationStatus.PENDING)
                        + serviceProviderRepository.countByCategoryAndVerificationStatus(
                                in.sp.main.Entities.ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.PENDING);
                long pendingTrainers = 0;
                try {
                    pendingTrainers = fitnessTrainerRepository
                            .countByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingTrainers = fitnessTrainerRepository.countByVerificationStatus(VerificationStatus.PENDING);
                }
                long pendingSalons = 0;
                try {
                    pendingSalons = salonRepository
                            .countByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingSalons = salonRepository.countByApproved(false);
                }
                long pendingStylists = 0;
                try {
                    pendingStylists = stylistRepository
                            .countByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingStylists = stylistRepository.countByApproved(false);
                }
                long pendingLawyers = serviceProviderRepository.countByCategoryAndVerificationStatus(
                        in.sp.main.Entities.ProviderCategory.WOMEN_LAWYER, VerificationStatus.PENDING);
                long pendingFitness = serviceProviderRepository.countByCategoryAndVerificationStatus(
                        in.sp.main.Entities.ProviderCategory.FITNESS_ZUMBA, VerificationStatus.PENDING);
                long unreadContactMessages = contactMessageRepository.countByReadByAdminFalse();

                long pendingProposals = businessProposalRepository.countByStatus(VerificationStatus.PENDING);
                long pendingEnt = entrepreneurRepository.countByVerificationStatus(VerificationStatus.PENDING);
                long pendingInv = investorRepository.countByVerificationStatus(VerificationStatus.PENDING);
                long sidePendingProposals = pendingProposals + pendingEnt + pendingInv;

                long pendingEventHosts = eventHostRepository.countByVerificationStatus(VerificationStatus.PENDING);
                long pendingWomenEvents = womenEventRepository.countByStatus("PENDING");
                long sidePendingEventHosts = pendingEventHosts + pendingWomenEvents;
                long pendingJobApplications = jobApplicationRepository.countByStatus(VerificationStatus.PENDING);
                long pendingDeliveryPartners = 0;
                try {
                    pendingDeliveryPartners = deliveryPartnerRepository
                            .countByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingDeliveryPartners = deliveryPartnerRepository.countByVerificationStatus(VerificationStatus.PENDING);
                }
                long pendingCreators = 0;
                try {
                    pendingCreators = userRepository.countByCreatorProfileStatusIn(
                            PartnerLifecycleSupport.pendingQueueStatuses());
                } catch (Exception ignored) {
                    pendingCreators = 0;
                }
                long pendingEducators = 0;
                try {
                    pendingEducators = financialEducatorRepository.countByPartnerProfileStatusIn(
                            PartnerLifecycleSupport.pendingQueueStatuses());
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
