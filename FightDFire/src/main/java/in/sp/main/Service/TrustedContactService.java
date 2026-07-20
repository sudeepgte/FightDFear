package in.sp.main.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.TrustedContactRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class TrustedContactService {

    @Autowired
    private TrustedContactRepository trustedContactRepository;
    
    @Autowired
    private UserRepository userRepository;

    public List<TrustedContact> getTrustedContactsByUserId(Long userId) {
        return trustedContactRepository.findByUserId(userId);
    }

    public TrustedContact createTrustedContact(Long userId, TrustedContact contact) {
        // Fetch the user from the database
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));

        // Set the existing user on the trusted contact
        contact.setUser(user);
        
        // Save the trusted contact
        return trustedContactRepository.save(contact);
    }

    // Update an existing trusted contact
    public TrustedContact updateTrustedContact(Long contactId, TrustedContact contact) {
        Optional<TrustedContact> existingContactOpt = trustedContactRepository.findById(contactId);
        if (existingContactOpt.isPresent()) {
            TrustedContact existingContact = existingContactOpt.get();
            existingContact.setName(contact.getName());
            existingContact.setPhone(contact.getPhone());
            return trustedContactRepository.save(existingContact);
        }
        return null; // Return null or throw exception if contact not found
    }

    // Get a specific trusted contact by its ID
    public TrustedContact getTrustedContactById(Long contactId) {
        return trustedContactRepository.findById(contactId).orElse(null);
    }

    // Delete a trusted contact
    public void deleteTrustedContact(Long contactId) {
        trustedContactRepository.deleteById(contactId);
    }
}
