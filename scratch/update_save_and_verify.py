p = 'src/main/java/in/sp/main/Controller/MartialArtsCenterController.java'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

target1 = """            @RequestParam(required = false) MultipartFile certificateFile,
            @RequestParam(required = false) MultipartFile[] galleryFiles,
            HttpSession session, RedirectAttributes redirectAttributes) {"""

repl1 = """            @RequestParam(required = false) MultipartFile certificateFile,
            @RequestParam(required = false) MultipartFile[] galleryFiles,
            @RequestParam(value = "submitVerificationAfterSave", required = false) Boolean submitVerificationAfterSave,
            HttpSession session, RedirectAttributes redirectAttributes) {"""

target2 = """        centreProfileService.applyFields(center, body);
        center = centreProfileService.refreshCompletion(center);
        session.setAttribute("loggedCentre", center);

        redirectAttributes.addFlashAttribute("message", "Profile details saved successfully! Current completion: " + (center.getProfileCompletionPct() != null ? center.getProfileCompletionPct() : 0) + "%");
        return "redirect:/centres/profile-completion";
    }"""

repl2 = """        centreProfileService.applyFields(center, body);
        center = centreProfileService.refreshCompletion(center);

        if (Boolean.TRUE.equals(submitVerificationAfterSave)) {
            center.setCentreProfileStatus(CentreProfileStatus.PENDING_ADMIN_APPROVAL);
            center.setSubmittedForVerificationAt(LocalDateTime.now());
            centreRepository.save(center);
            session.setAttribute("loggedCentre", center);
            redirectAttributes.addFlashAttribute("message", "Your centre profile has been submitted for Admin Verification! Our team will review your application shortly.");
            return "redirect:/centres/dashboard";
        }

        session.setAttribute("loggedCentre", center);
        redirectAttributes.addFlashAttribute("message", "Profile details saved successfully! Current completion: " + (center.getProfileCompletionPct() != null ? center.getProfileCompletionPct() : 0) + "%");
        return "redirect:/centres/profile-completion";
    }"""

assert target1 in content, 'target1 not found in controller'
assert target2 in content, 'target2 not found in controller'

content = content.replace(target1, repl1, 1).replace(target2, repl2, 1)

with open(p, 'w', encoding='utf-8', newline='') as f:
    f.write(content)

print('Updated submitVerificationAfterSave in updateProfile')
