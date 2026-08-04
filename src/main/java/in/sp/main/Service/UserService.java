package in.sp.main.Service;



import java.util.List;

import java.util.Optional;



import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;



import in.sp.main.Entities.User;

import in.sp.main.Repository.*;



@Service

public class UserService {



    @Autowired

    private UserRepository userRepository;

    

    @Autowired

    private EnrollmentRepository enrollmentRepository;



    @Autowired

    private VideoUploadRepository videoUploadRepository;



    @Autowired

    private VideoCommentRepository videoCommentRepository;



    @Autowired

    private VideoLikeRepository videoLikeRepository;



    @Autowired

    private VideoViewRepository videoViewRepository;



    @Autowired

    private VideoReportRepository videoReportRepository;



    @Autowired

    private AttendanceRepository attendanceRepository;



    @Autowired

    private FitnessBookingRepository fitnessBookingRepository;



    @Autowired

    private WomenEventRegistrationRepository womenEventRegistrationRepository;



    @Autowired

    private EmergencyContactRepository emergencyContactRepository;



    @Autowired

    private TrustedContactRepository trustedContactRepository;



    @Autowired

    private UserFollowRepository userFollowRepository;



    @Autowired

    private JobApplicationRepository jobApplicationRepository;



    @Autowired

    private BuddyRequestRepository buddyRequestRepository;



    @Autowired

    private DangerPointRepository dangerPointRepository;



    @Autowired

    private SOSRequestRepository sosRequestRepository;



    @Autowired

    private WalletTransactionRepository walletTransactionRepository;



    @Autowired

    private ExpressPostRepository expressPostRepository;



    @Autowired

    private ExpressCommentRepository expressCommentRepository;



    @Autowired

    private ExpressLikeRepository expressLikeRepository;



    @Autowired

    private BookingRepository bookingRepository;



    @Autowired

    private Booking1Repository booking1Repository;



    @Autowired

    private ProviderBookingRepository providerBookingRepository;



    @Autowired

    private OfferBookingRepository offerBookingRepository;



    @Autowired

    private DoctorAppointmentRepository doctorAppointmentRepository;



    @Autowired

    private ReviewRepository reviewRepository;



    @Autowired

    private BadgeRepository badgeRepository;



    @Autowired

    private PanicLogRepository panicLogRepository;



    @Autowired

    private MedicalDetailsRepository medicalDetailsRepository;



    @Autowired

    private RoutineReminderRepository routineReminderRepository;



    @Autowired

    private CreatorNotificationRepository creatorNotificationRepository;



    @Autowired

    private CreatorStoryRepository creatorStoryRepository;



    @Autowired

    private VideoBookmarkRepository videoBookmarkRepository;



    @Autowired

    private WomenCartItemRepository womenCartItemRepository;



    @Autowired

    private WomenWishlistItemRepository womenWishlistItemRepository;



    @Autowired

    private WomenProductOrderRepository womenProductOrderRepository;



    @Autowired

    private MarketplaceEnrollmentRepository marketplaceEnrollmentRepository;



    @Autowired

    private PaymentRepository paymentRepository;



    @Autowired

    private LoanApplicationRepository loanApplicationRepository;



    @Autowired

    private UserBlockRepository userBlockRepository;



    @Autowired

    private PasswordResetTokenRepository passwordResetTokenRepository;



    @Autowired

    private OfferRepository offerRepository;



    // Create a new user with password encoding

    public User createUser(User user) {

        return userRepository.save(user);

    }

    

    // Method to get all users

    public List<User> getAllUsers() {

        return userRepository.findAll();

    }



    // Get a user by ID

    public User getUserById(Long id) {

        return userRepository.findById(id).orElse(null);

    }



@Transactional

public void deleteUser(Long id) {

    User user = userRepository.findById(id).orElse(null);

    if (user == null) {

        return;

    }



    enrollmentRepository.deleteByUserId(id);

    attendanceRepository.deleteByUser_Id(id);



    videoCommentRepository.deleteByUser_Id(id);

    videoLikeRepository.deleteByUserId(id);

    videoViewRepository.deleteByUserId(id);

    videoReportRepository.deleteByReportedBy_Id(id);



    videoCommentRepository.deleteByVideo_User_Id(id);

    videoLikeRepository.deleteByVideo_User_Id(id);

    videoViewRepository.deleteByVideo_User_Id(id);

    videoReportRepository.deleteByVideo_User_Id(id);



    videoUploadRepository.deleteByUserId(id);

    videoBookmarkRepository.findByUser_Id(id).forEach(videoBookmarkRepository::delete);



    fitnessBookingRepository.findByUser_Id(id).forEach(fitnessBookingRepository::delete);

    womenEventRegistrationRepository.findByUserOrderByRegisteredAtDesc(user).forEach(womenEventRegistrationRepository::delete);

    emergencyContactRepository.findByUserId(id).forEach(emergencyContactRepository::delete);

    trustedContactRepository.findByUserId(id).forEach(trustedContactRepository::delete);

    jobApplicationRepository.findByUser_Id(id).forEach(jobApplicationRepository::delete);

    userFollowRepository.findByFollower(user).forEach(userFollowRepository::delete);

    userFollowRepository.findByFollowed(user).forEach(userFollowRepository::delete);



    buddyRequestRepository.findByFromUser(user).forEach(buddyRequestRepository::delete);

    buddyRequestRepository.findByToUser(user).forEach(buddyRequestRepository::delete);



    dangerPointRepository.deleteByUser(user);

    sosRequestRepository.findByUser(user).forEach(sosRequestRepository::delete);



    walletTransactionRepository.findByUser_IdOrderByTransactionDateDesc(id).forEach(walletTransactionRepository::delete);



    expressCommentRepository.findByUserId(id).forEach(expressCommentRepository::delete);

    expressLikeRepository.findByUserId(id).forEach(expressLikeRepository::delete);

    expressPostRepository.findByUserId(id).forEach(expressPostRepository::delete);



    bookingRepository.findByUserId(id).forEach(bookingRepository::delete);

    booking1Repository.findByUser(user).forEach(booking1Repository::delete);

    providerBookingRepository.findByUserOrderByRequestedTimeDesc(user).forEach(providerBookingRepository::delete);

    offerBookingRepository.findByUser(user).forEach(offerBookingRepository::delete);

    doctorAppointmentRepository.findByUserOrderByAppointmentTimeDesc(user).forEach(doctorAppointmentRepository::delete);



    reviewRepository.findByUserId(id).forEach(reviewRepository::delete);

    badgeRepository.findByUserId(id).forEach(badgeRepository::delete);

    panicLogRepository.findByUserId(id).forEach(panicLogRepository::delete);

    medicalDetailsRepository.findByUser(user).forEach(medicalDetailsRepository::delete);

    routineReminderRepository.findByUserOrderByIdDesc(user).forEach(routineReminderRepository::delete);



    creatorNotificationRepository.findByUser_IdOrderByCreatedAtDesc(id).forEach(creatorNotificationRepository::delete);

    creatorStoryRepository.findByUser_Id(id).forEach(creatorStoryRepository::delete);



    womenCartItemRepository.deleteByUser(user);

    womenWishlistItemRepository.findByUser(user).forEach(womenWishlistItemRepository::delete);

    womenProductOrderRepository.findByUserOrderByOrderTimeDesc(user).forEach(womenProductOrderRepository::delete);



    marketplaceEnrollmentRepository.findByUser_Id(id).forEach(marketplaceEnrollmentRepository::delete);

    paymentRepository.findByUserId(id).forEach(paymentRepository::delete);

    loanApplicationRepository.findByUserOrderBySubmittedAtDesc(user).forEach(loanApplicationRepository::delete);



    userBlockRepository.findByUser_Id(id).forEach(userBlockRepository::delete);

    userBlockRepository.findByBlockedUser_Id(id).forEach(userBlockRepository::delete);



    offerRepository.findByUser_FullName(user.getFullName()).forEach(offerRepository::delete);



    if (user.getEmail() != null) {

        passwordResetTokenRepository.deleteByEmail(user.getEmail().trim().toLowerCase());

    }



    userRepository.deleteById(id);

}



 

    public User updateUser(Long id, User updatedUser) {

        Optional<User> optionalUser = userRepository.findById(id);

        if (optionalUser.isEmpty()) {

            throw new RuntimeException("User not found with ID: " + id);

        }



        User existingUser = optionalUser.get();



        // Only update fields if they are not null or empty

        if (updatedUser.getFullName() != null && !updatedUser.getFullName().isEmpty()) {

            existingUser.setFullName(updatedUser.getFullName());

        }

        if (updatedUser.getEmail() != null && !updatedUser.getEmail().isEmpty()) {

            existingUser.setEmail(updatedUser.getEmail());

        }

        if (updatedUser.getPhoneNumber() != null && !updatedUser.getPhoneNumber().isEmpty()) {

            existingUser.setPhoneNumber(updatedUser.getPhoneNumber());

        }

        if (updatedUser.getHomeAddress() != null && !updatedUser.getHomeAddress().isEmpty()) {

            existingUser.setHomeAddress(updatedUser.getHomeAddress());

        }

        if (updatedUser.getProfilePhoto() != null && !updatedUser.getProfilePhoto().isEmpty()) {

            existingUser.setProfilePhoto(updatedUser.getProfilePhoto());

        }

        if (updatedUser.getIdentityDocument() != null && !updatedUser.getIdentityDocument().isEmpty()) {

            existingUser.setIdentityDocument(updatedUser.getIdentityDocument());  

        }

        if (updatedUser.getAge() != null ) {

            existingUser.setAge(updatedUser.getAge());

        }

        if (updatedUser.getGender() != null ) {

            existingUser.setGender(updatedUser.getGender());

        }

        



        return userRepository.save(existingUser);

    }

    public User findByUsername(String username) {

        return userRepository.findByEmail(username).orElse(null);

    }

}


