package in.sp.main.Service;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.Admin;
import in.sp.main.Repository.AdminRepository;

@Service
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordService passwordService;

    public boolean registerAdmin(Admin admin) {
    	 Optional<Admin> existing = adminRepository.findByEmail(admin.getEmail());
    	    if (existing.isEmpty()) {
    	        String raw = admin.getPassword();
    	        if (raw == null || !raw.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$")) {
    	            throw new IllegalArgumentException(
    	                    "Password must be at least 8 characters long and include uppercase, lowercase, a number, and a special character");
    	        }
    	        admin.setPassword(passwordService.encode(raw));
    	        adminRepository.save(admin);
    	        return true;
    	    }
        return false;
    }

    public Admin loginAdmin(String email, String password) {
        if (email == null || password == null) return null;
        Optional<Admin> opt = adminRepository.findByEmailIgnoreCase(email.trim())
                .or(() -> adminRepository.findByEmail(email.trim()));
        if (opt.isEmpty()) return null;
        Admin admin = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, admin.getPassword(), hashed -> {
            admin.setPassword(hashed);
            adminRepository.save(admin);
        });
        return ok ? admin : null;
    }

    public Admin updateAdmin(int id, Admin updatedAdmin) {
        return adminRepository.findById(id).map(admin -> {
            admin.setName(updatedAdmin.getName());
            admin.setEmail(updatedAdmin.getEmail());
            String newPassword = updatedAdmin.getPassword();
            if (newPassword != null && !newPassword.isBlank()) {
                if (!passwordService.isBcryptEncoded(newPassword)) {
                    admin.setPassword(passwordService.encode(newPassword));
                } else {
                    admin.setPassword(newPassword);
                }
            }
            if (updatedAdmin.getProfilePhoto() != null) {
                admin.setProfilePhoto(updatedAdmin.getProfilePhoto());
            }
            return adminRepository.save(admin);
        }).orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
    }

    public void deleteAdmin(int id) {
        if (adminRepository.existsById(id)) {
            adminRepository.deleteById(id);
        } else {
            throw new RuntimeException("Admin not found with id: " + id);
        }
    }

	public List<Admin> findAllAdmins() {
		return adminRepository.findAll();
	}

	public Optional<Admin> findById(int id) {
		return adminRepository.findById(id);
	}
}
