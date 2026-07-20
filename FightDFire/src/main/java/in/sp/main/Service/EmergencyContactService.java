package in.sp.main.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class EmergencyContactService {

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    @Autowired
    private UserRepository userRepository; // Assuming you have a UserRepository for fetching User

    // Default contacts
    private static final String POLICE_NAME = "Police";
    private static final String AMBULANCE_NAME = "Ambulance";
    private static final String POLICE_PHONE = "100";
    private static final String AMBULANCE_PHONE = "102";
    private static final String POLICE_EMAIL = "police@example.com";
    private static final String AMBULANCE_EMAIL = "ambulance@example.com";
    private static final String RELATION = "None";

    public List<EmergencyContact> getEmergencyContactsByUserId(Long userId) {
        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);

        // Ensure Police and Ambulance contacts exist by default if not already added
        ensureDefaultContacts(userId, contacts);

        return contacts;
    }

    // This method ensures default Police and Ambulance contacts exist for the user
    private void ensureDefaultContacts(Long userId, List<EmergencyContact> contacts) {
        boolean policeExists = false;
        boolean ambulanceExists = false;

        for (EmergencyContact contact : contacts) {
            if (contact.getName().equals(POLICE_NAME)) {
                policeExists = true;
            }
            if (contact.getName().equals(AMBULANCE_NAME)) {
                ambulanceExists = true;
            }
        }

        // If Police contact doesn't exist, create it
        if (!policeExists) {
            EmergencyContact policeContact = new EmergencyContact();
            policeContact.setName(POLICE_NAME);
            policeContact.setPhone(POLICE_PHONE);
            policeContact.setRelation(RELATION);
            policeContact.setEmail(POLICE_EMAIL);
            policeContact.setUser(userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId)));
            emergencyContactRepository.save(policeContact);
        }

        // If Ambulance contact doesn't exist, create it
        if (!ambulanceExists) {
            EmergencyContact ambulanceContact = new EmergencyContact();
            ambulanceContact.setName(AMBULANCE_NAME);
            ambulanceContact.setPhone(AMBULANCE_PHONE);
            ambulanceContact.setRelation(RELATION);
            ambulanceContact.setEmail(AMBULANCE_EMAIL);
            ambulanceContact.setUser(userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId)));
            emergencyContactRepository.save(ambulanceContact);
        }
    }

    public EmergencyContact createEmergencyContact(Long userId, EmergencyContact contact) {
        // Fetch the existing user from the database
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));

        // Associate the user with the contact
        contact.setUser(user);

        // Save the emergency contact
        return emergencyContactRepository.save(contact);
    }

    public EmergencyContact updateEmergencyContact(Long contactId, EmergencyContact updatedContact) {
        EmergencyContact existingContact = emergencyContactRepository.findById(contactId)
                .orElseThrow(() -> new RuntimeException("Emergency contact not found"));
        existingContact.setName(updatedContact.getName());
        existingContact.setPhone(updatedContact.getPhone());
        existingContact.setRelation(updatedContact.getRelation());
        existingContact.setEmail(updatedContact.getEmail());
        return emergencyContactRepository.save(existingContact);
    }

    public void deleteEmergencyContact(Long contactId) {
        emergencyContactRepository.deleteById(contactId);
    }

    public Optional<EmergencyContact> getEmergencyContactById(Long contactId) {
        return emergencyContactRepository.findById(contactId);
    }

    /**
     * Get the first valid emergency contact phone for auto-call (skips police/ambulance defaults)
     */
    public String getFirstContactPhone(Long userId) {
        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);
        for (EmergencyContact contact : contacts) {
            if (contact.getPhone() != null && !contact.getPhone().isEmpty()
                    && !contact.getPhone().equals("100") && !contact.getPhone().equals("102")
                    && !contact.getPhone().equals("108")) {
                return contact.getPhone();
            }
        }
        return "100"; // Fallback to police if no personal contacts
    }
}
