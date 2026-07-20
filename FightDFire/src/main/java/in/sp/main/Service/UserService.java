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

    // Delete a user by ID
   

@Transactional
public void deleteUser(Long id) {
    // 1. Delete enrollments
    enrollmentRepository.deleteByUserId(id);
    
    // 2. Delete data related to the user's interactions on OTHER people's videos
    videoCommentRepository.deleteByUser_Id(id);
    videoLikeRepository.deleteByUserId(id);
    videoViewRepository.deleteByUserId(id);
    videoReportRepository.deleteByReportedBy_Id(id);
    
    // 3. Delete data related to the user's OWN videos (likes, comments, views, reports on their videos)
    videoCommentRepository.deleteByVideo_User_Id(id);
    videoLikeRepository.deleteByVideo_User_Id(id);
    videoViewRepository.deleteByVideo_User_Id(id);
    videoReportRepository.deleteByVideo_User_Id(id);
    
    // 4. Delete the user's videos
    videoUploadRepository.deleteByUserId(id);
    
    // 5. Finally delete the user
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
