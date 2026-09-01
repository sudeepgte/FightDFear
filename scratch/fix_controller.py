import codecs

path = "src/main/java/in/sp/main/Controller/LawyerController.java"
with codecs.open(path, "r", "utf-8") as f:
    content = f.read()

# Replace the specific login return
target_login = '''            session.setAttribute("loggedLawyer", p);
            return "redirect:/lawyer/dashboard";'''
new_login = '''            session.setAttribute("loggedLawyer", p);
            if (p.getPartnerProfileStatus() == in.sp.main.Entities.PartnerProfileStatus.REGISTERED || p.getProfileCompletionPct() == null || p.getProfileCompletionPct() < 100) {
                return "redirect:/lawyer/profile-completion";
            }
            return "redirect:/lawyer/dashboard";'''
content = content.replace(target_login, new_login)

# Add methods before the last }
new_methods = '''

    @GetMapping("/profile-completion")
    public String lawyerProfileCompletion(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";
        p = providerRepo.findById(p.getId()).orElse(p);
        model.addAttribute("lawyer", p);
        return "lawyer/profileCompletion";
    }

    @PostMapping("/profile-completion/save")
    public String saveProfileCompletion(@RequestParam String fullName,
                                      @RequestParam String phone,
                                      @RequestParam(required = false) String designation,
                                      @RequestParam(required = false) String barCouncilId,
                                      @RequestParam(required = false) String city,
                                      @RequestParam(required = false) String state,
                                      @RequestParam(required = false) String practiceAreas,
                                      @RequestParam(required = false) String openDays,
                                      @RequestParam(required = false) String openTime,
                                      @RequestParam(required = false) String closeTime,
                                      @RequestParam(required = false) String bio,
                                      @RequestParam(required = false) String serviceMode,
                                      @RequestParam(required = false) Integer experienceYears,
                                      @RequestParam(required = false) String languages,
                                      HttpSession session, RedirectAttributes ra) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedLawyer");
        if (p == null) return "redirect:/lawyer/login";
        
        ServiceProvider existing = providerRepo.findById(p.getId()).orElse(null);
        if (existing != null) {
            existing.setFullName(fullName != null ? fullName.trim() : "");
            existing.setPhone(phone != null ? phone.trim() : "");
            existing.setDesignation(designation != null ? designation.trim() : "");
            existing.setBarCouncilId(barCouncilId != null ? barCouncilId.trim() : "");
            existing.setCity(city != null ? city.trim() : "");
            existing.setState(state != null ? state.trim() : "");
            existing.setPracticeAreas(practiceAreas != null ? practiceAreas.trim() : "");
            existing.setOpenDays(openDays != null ? openDays.trim() : "");
            
            java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
            if (openTime != null && !openTime.isEmpty()) {
                existing.setOpenTime(java.time.LocalTime.parse(openTime, fmt));
            }
            if (closeTime != null && !closeTime.isEmpty()) {
                existing.setCloseTime(java.time.LocalTime.parse(closeTime, fmt));
            }
            
            existing.setBio(bio != null ? bio.trim() : "");
            existing.setServiceMode(serviceMode != null ? serviceMode.trim() : "");
            if (experienceYears != null) existing.setExperienceYears(experienceYears);
            existing.setLanguages(languages != null ? languages.trim() : "");
            
            existing.setLocationText(city != null ? city.trim() : "");
            existing.setProfileCompletionPct(100);
            existing.setPartnerProfileStatus(in.sp.main.Entities.PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
            
            providerRepo.save(existing);
            session.setAttribute("loggedLawyer", existing);
            ra.addFlashAttribute("message", "Profile saved successfully!");
        }
        return "redirect:/lawyer/dashboard";
    }
}'''

# Remove trailing spaces and newlines, then replace the last brace
content = content.rstrip()
if content.endswith('}'):
    content = content[:-1] + new_methods

with codecs.open(path, "w", "utf-8") as f:
    f.write(content)
