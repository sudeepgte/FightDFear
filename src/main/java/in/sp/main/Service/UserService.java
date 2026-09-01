package in.sp.main.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.MedicalDetails;
import in.sp.main.Entities.User;
import in.sp.main.Repository.AttendanceRepository;
import in.sp.main.Repository.BuddyRequestRepository;
import in.sp.main.Repository.DangerPointRepository;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.FitnessBookingRepository;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Repository.TrustedContactRepository;
import in.sp.main.Repository.UserFollowRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoCommentRepository;
import in.sp.main.Repository.VideoLikeRepository;
import in.sp.main.Repository.VideoReportRepository;
import in.sp.main.Repository.VideoUploadRepository;
import in.sp.main.Repository.VideoViewRepository;
import in.sp.main.Repository.WomenCartItemRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;

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
    private TrustedContactRepository trustedContactRepository;

    @Autowired
    private UserFollowRepository userFollowRepository;

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    @Autowired
    private BuddyRequestRepository buddyRequestRepository;

    @Autowired
    private WomenCartItemRepository womenCartItemRepository;

    @Autowired
    private DangerPointRepository dangerPointRepository;

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @Transactional
    public User getUserByIdForProfileForm(Long id) {
        return userRepository.findByIdWithProfileDetails(id).orElse(null);
    }

    public User findByUsername(String username) {
        return userRepository.findByEmail(username).orElse(null);
    }

    @Transactional
    public User updateUser(Long id, User updatedUser) {
        User existingUser = userRepository.findByIdWithProfileDetails(id)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + id));

        if (updatedUser.getFullName() != null && !updatedUser.getFullName().isEmpty()) {
            existingUser.setFullName(updatedUser.getFullName());
        }
        if (updatedUser.getEmail() != null && !updatedUser.getEmail().isEmpty()) {
            existingUser.setEmail(updatedUser.getEmail());
        }
        if (updatedUser.getPhoneNumber() != null && !updatedUser.getPhoneNumber().isEmpty()) {
            existingUser.setPhoneNumber(updatedUser.getPhoneNumber());
        }
        if (updatedUser.getHomeAddress() != null) {
            existingUser.setHomeAddress(updatedUser.getHomeAddress());
        }
        if (updatedUser.getCity() != null) {
            existingUser.setCity(updatedUser.getCity());
        }
        if (updatedUser.getWorkCollegeAddress() != null) {
            existingUser.setWorkCollegeAddress(updatedUser.getWorkCollegeAddress());
        }
        if (updatedUser.getSafetyPreferences() != null) {
            existingUser.setSafetyPreferences(updatedUser.getSafetyPreferences());
        }
        existingUser.setPrivate(updatedUser.isPrivate());
        existingUser.setDob(updatedUser.getDob());
        existingUser.setAge(updatedUser.getAge());
        existingUser.setGender(updatedUser.getGender());

        if (updatedUser.getProfilePhoto() != null && !updatedUser.getProfilePhoto().isEmpty()) {
            existingUser.setProfilePhoto(updatedUser.getProfilePhoto());
        }
        if (updatedUser.getIdentityDocument() != null && !updatedUser.getIdentityDocument().isEmpty()) {
            existingUser.setIdentityDocument(updatedUser.getIdentityDocument());
        }
        if (updatedUser.getLastReadBroadcastTime() != null) {
            existingUser.setLastReadBroadcastTime(updatedUser.getLastReadBroadcastTime());
        }

        if (updatedUser.getEmergencyContacts() != null && !updatedUser.getEmergencyContacts().isEmpty()) {
            EmergencyContact incoming = updatedUser.getEmergencyContacts().get(0);
            EmergencyContact primary = (existingUser.getEmergencyContacts() != null
                    && !existingUser.getEmergencyContacts().isEmpty())
                    ? existingUser.getEmergencyContacts().get(0) : null;
            if (primary == null) {
                primary = new EmergencyContact();
                primary.setUser(existingUser);
                if (existingUser.getEmergencyContacts() == null) {
                    existingUser.setEmergencyContacts(new java.util.ArrayList<>());
                }
                existingUser.getEmergencyContacts().add(primary);
            }
            primary.setName(incoming.getName());
            primary.setPhone(incoming.getPhone());
            primary.setRelation(incoming.getRelation());
        }

        if (updatedUser.getMedicalDetails() != null) {
            MedicalDetails incomingMedical = updatedUser.getMedicalDetails();
            MedicalDetails medical = existingUser.getMedicalDetails();
            if (medical == null) {
                medical = new MedicalDetails();
                medical.setUser(existingUser);
                existingUser.setMedicalDetails(medical);
            }
            medical.setBloodGroup(incomingMedical.getBloodGroup());
            medical.setAllergies(incomingMedical.getAllergies());
            medical.setMedicalHistory(incomingMedical.getMedicalHistory());
            medical.setMedications(incomingMedical.getMedications());
        }

        return userRepository.save(existingUser);
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

        fitnessBookingRepository.deleteAll(fitnessBookingRepository.findByUser_Id(id));
        womenEventRegistrationRepository.deleteAll(
                womenEventRegistrationRepository.findByUserOrderByRegisteredAtDesc(user));
        jobApplicationRepository.deleteAll(jobApplicationRepository.findByUser_Id(id));
        buddyRequestRepository.deleteAll(buddyRequestRepository.findByFromUser(user));
        buddyRequestRepository.deleteAll(buddyRequestRepository.findByToUser(user));
        trustedContactRepository.deleteAll(trustedContactRepository.findByUserId(id));
        womenCartItemRepository.deleteByUser(user);
        dangerPointRepository.deleteByUser(user);

        List<User> allUsers = userRepository.findAll();
        for (User other : allUsers) {
            userFollowRepository.deleteByFollower_IdAndFollowed_Id(id, other.getId());
            userFollowRepository.deleteByFollower_IdAndFollowed_Id(other.getId(), id);
        }

        userRepository.delete(user);
    }
}
