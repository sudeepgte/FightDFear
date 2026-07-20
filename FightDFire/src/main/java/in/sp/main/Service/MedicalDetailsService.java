package in.sp.main.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.MedicalDetails;
import in.sp.main.Entities.User;
import in.sp.main.Repository.MedicalDetailsRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class MedicalDetailsService {

    @Autowired
    private MedicalDetailsRepository medicalDetailsRepository;
    
    @Autowired
    private UserRepository userRepository;

    // Create a new Medical Details for a user
    public void createMedicalDetails(Long userId, MedicalDetails medicalDetails) {
        // Set the userId if necessary (optional, depending on how you want to manage it)
        // medicalDetails.setUserId(userId); // Uncomment if userId is part of the entity
        
        medicalDetailsRepository.save(medicalDetails);  // Save the new medical details in the database
    }

    // Get medical details for a specific user
    public List<MedicalDetails> getMedicalDetailsByUserId(Long userId) {
        Optional<User> user = userRepository.findById(userId);  // Fetch the User entity by userId
        if (user.isPresent()) {
            return medicalDetailsRepository.findByUser(user.get());  // Use the User object to find associated medical details
        }
        return List.of();  // Return an empty list if user is not found
    }

    // Get a specific Medical Detail by ID
    public MedicalDetails getMedicalDetailsById(Long id) {
        // Find the medical details by its ID
        Optional<MedicalDetails> medicalDetails = medicalDetailsRepository.findById(id);
        return medicalDetails.orElse(null);  // Return null if not found
    }

    // Update an existing Medical Detail
    public void updateMedicalDetails(Long id, MedicalDetails updatedMedicalDetails) {
        // Fetch the existing medical details and update
        Optional<MedicalDetails> existingMedicalDetails = medicalDetailsRepository.findById(id);
        
        if (existingMedicalDetails.isPresent()) {
            MedicalDetails medicalDetails = existingMedicalDetails.get();
            medicalDetails.setBloodGroup(updatedMedicalDetails.getBloodGroup());
            medicalDetails.setAllergies(updatedMedicalDetails.getAllergies());
            medicalDetails.setMedicalHistory(updatedMedicalDetails.getMedicalHistory());
            medicalDetails.setMedications(updatedMedicalDetails.getMedications());
            medicalDetailsRepository.save(medicalDetails);  // Save updated details
        }
    }

    // Delete a specific Medical Detail by ID
    public void deleteMedicalDetails(Long id) {
        // Delete the medical detail by its ID
        medicalDetailsRepository.deleteById(id);
    }

    // Optional: Get a list of all medical details (for admin or overall listing)
    public List<MedicalDetails> getAllMedicalDetails() {
        return medicalDetailsRepository.findAll();  // Fetch all medical details from the database
    }
}
