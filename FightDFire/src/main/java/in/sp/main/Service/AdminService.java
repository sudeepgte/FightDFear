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

  
    public boolean registerAdmin(Admin admin) {
		/*
		 * if (adminRepository.findByEmail(admin.getEmail()).isPresent()) { throw new
		 * RuntimeException("Email already exists"); }
		 */
    	 Optional<Admin> existing = adminRepository.findByEmail(admin.getEmail());
    	    if (existing.isEmpty()) {
    	        adminRepository.save(admin);
    	        return true;
    	    }
        return false;
    }

  
    public Admin loginAdmin(String email, String password) {
        Optional<Admin> opt = adminRepository.findByEmail(email);
        if (opt.isEmpty()) return null;
        Admin admin = opt.get();
        return (admin.getPassword() != null && admin.getPassword().equals(password))
                ? admin
                : null;
    }
 // Update Admin
    public Admin updateAdmin(int id, Admin updatedAdmin) {
        return adminRepository.findById(id).map(admin -> {
            admin.setName(updatedAdmin.getName());
            admin.setEmail(updatedAdmin.getEmail());
            admin.setPassword(updatedAdmin.getPassword());
            if (updatedAdmin.getProfilePhoto() != null) {
                admin.setProfilePhoto(updatedAdmin.getProfilePhoto());
            }
            return adminRepository.save(admin);
        }).orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
    }

    // Delete Admin
    public void deleteAdmin(int id) {
        if (adminRepository.existsById(id)) {
            adminRepository.deleteById(id);
        } else {
            throw new RuntimeException("Admin not found with id: " + id);
        }
    }


	public List<Admin> findAllAdmins() {
		// TODO Auto-generated method stub
		return adminRepository.findAll();
	}


	public Optional<Admin> findById(int id) {
	
		return adminRepository.findById(id);
	}
}
