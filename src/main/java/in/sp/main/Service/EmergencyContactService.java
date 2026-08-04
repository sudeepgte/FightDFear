package in.sp.main.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class EmergencyContactService {

    private static final int MAX_PERSONAL_CONTACTS = 5;
    private static final Set<String> DEFAULT_CONTACT_NAMES = Set.of("Police", "Ambulance");

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    @Autowired
    private UserRepository userRepository;

    private static final String POLICE_NAME = "Police";
    private static final String AMBULANCE_NAME = "Ambulance";
    private static final String POLICE_PHONE = "100";
    private static final String AMBULANCE_PHONE = "102";
    private static final String POLICE_EMAIL = "police@example.com";
    private static final String AMBULANCE_EMAIL = "ambulance@example.com";
    private static final String RELATION = "None";

    public List<EmergencyContact> getEmergencyContactsByUserId(Long userId) {
        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);
        ensureDefaultContacts(userId, contacts);
        return contacts;
    }

    public int countPersonalContacts(Long userId) {
        return (int) emergencyContactRepository.findByUserId(userId).stream()
                .filter(c -> c.getName() != null && !DEFAULT_CONTACT_NAMES.contains(c.getName()))
                .count();
    }

    public boolean canAddPersonalContact(Long userId) {
        return countPersonalContacts(userId) < MAX_PERSONAL_CONTACTS;
    }

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
        if (!canAddPersonalContact(userId)) {
            throw new IllegalArgumentException("You can add up to " + MAX_PERSONAL_CONTACTS + " personal emergency contacts.");
        }

        String phone = contact.getPhone() == null ? "" : contact.getPhone().replaceAll("\\D", "");
        if (!phone.matches("^\\d{10}$")) {
            throw new IllegalArgumentException("Phone number must be exactly 10 digits.");
        }
        contact.setPhone(phone);

        if (contact.getName() != null && DEFAULT_CONTACT_NAMES.contains(contact.getName().trim())) {
            throw new IllegalArgumentException("That contact name is reserved for emergency services.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));

        contact.setUser(user);
        return emergencyContactRepository.save(contact);
    }

    public EmergencyContact updateEmergencyContact(Long contactId, EmergencyContact updatedContact) {
        EmergencyContact existingContact = emergencyContactRepository.findById(contactId)
                .orElseThrow(() -> new RuntimeException("Emergency contact not found"));

        String phone = updatedContact.getPhone() == null ? "" : updatedContact.getPhone().replaceAll("\\D", "");
        if (!phone.matches("^\\d{10}$")) {
            throw new IllegalArgumentException("Phone number must be exactly 10 digits.");
        }

        existingContact.setName(updatedContact.getName());
        existingContact.setPhone(phone);
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

    public String getFirstContactPhone(Long userId) {
        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);
        for (EmergencyContact contact : contacts) {
            if (contact.getPhone() != null && !contact.getPhone().isEmpty()
                    && !contact.getPhone().equals("100") && !contact.getPhone().equals("102")
                    && !contact.getPhone().equals("108")) {
                return contact.getPhone();
            }
        }
        return "100";
    }
}
