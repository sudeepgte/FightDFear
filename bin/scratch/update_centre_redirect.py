p = 'src/main/java/in/sp/main/Controller/MartialArtsCenterController.java'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

target1 = """        // Smart routing: Check if profile needs completion (Mobile parity)
        boolean needsCompletion = center.getCentreProfileStatus() == CentreProfileStatus.REGISTERED
                || center.getCentreProfileStatus() == CentreProfileStatus.PROFILE_INCOMPLETE
                || center.getCentreProfileStatus() == CentreProfileStatus.CHANGES_REQUESTED
                || (center.getProfileCompletionPct() != null && center.getProfileCompletionPct() < 100 && !center.isApproved());

        if (needsCompletion) {
            return "redirect:/centres/profile-completion";
        }
        return "redirect:/centres/dashboard";"""

repl1 = """        // Smart routing: Check if profile needs completion (Mobile parity)
        boolean needsCompletion = (center.getCentreProfileStatus() == CentreProfileStatus.REGISTERED
                || center.getCentreProfileStatus() == CentreProfileStatus.PROFILE_INCOMPLETE
                || center.getCentreProfileStatus() == CentreProfileStatus.CHANGES_REQUESTED)
                && center.getCentreProfileStatus() != CentreProfileStatus.PENDING_ADMIN_APPROVAL;

        if (needsCompletion) {
            return "redirect:/centres/profile-completion";
        }
        return "redirect:/centres/dashboard";"""

target2 = """        redirectAttributes.addFlashAttribute("message", "Your centre profile has been submitted for Admin Verification! Our team will review your application shortly.");
        return "redirect:/centres/profile-completion";
    }"""

repl2 = """        redirectAttributes.addFlashAttribute("message", "Your centre profile has been submitted for Admin Verification! Our team will review your application shortly.");
        return "redirect:/centres/dashboard";
    }"""

assert target1 in content, 'target1 not found'
assert target2 in content, 'target2 not found'

content = content.replace(target1, repl1, 1).replace(target2, repl2, 1)

with open(p, 'w', encoding='utf-8', newline='') as f:
    f.write(content)

print('Updated MartialArtsCenterController routing and verification redirect to /centres/dashboard')
