package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.StylistRepository;

@Service
public class StylistProfileService {

    @Autowired
    private StylistRepository stylistRepository;

    public void setLifecycleStatus(Stylist stylist, PartnerProfileStatus status) {
        if (stylist == null || status == null) {
            return;
        }
        stylist.setPartnerProfileStatus(status);
        if (status == PartnerProfileStatus.APPROVED) {
            stylist.setApproved(true);
        } else if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || status == PartnerProfileStatus.PROFILE_INCOMPLETE
                || status == PartnerProfileStatus.REGISTERED
                || status == PartnerProfileStatus.READY_FOR_VERIFICATION
                || status == PartnerProfileStatus.REJECTED
                || status == PartnerProfileStatus.SUSPENDED) {
            stylist.setApproved(false);
        }
    }

    public List<String> missingItems(Stylist stylist) {
        List<String> missing = new ArrayList<>();
        if (PartnerLifecycleSupport.blank(stylist.getFirstName())) missing.add("firstName");
        if (PartnerLifecycleSupport.blank(stylist.getBio())) missing.add("bio");
        if (PartnerLifecycleSupport.blank(stylist.getSpecialization())) missing.add("specialization");
        return missing;
    }

    public int calculateCompletionPct(Stylist stylist) {
        int filled = 0;
        int total = 3;
        if (!PartnerLifecycleSupport.blank(stylist.getFirstName())) filled++;
        if (!PartnerLifecycleSupport.blank(stylist.getBio())) filled++;
        if (!PartnerLifecycleSupport.blank(stylist.getSpecialization())) filled++;
        return (int) Math.round(100.0 * filled / total);
    }

    @Transactional
    public Stylist refreshCompletion(Stylist stylist) {
        List<String> missing = missingItems(stylist);
        int pct = calculateCompletionPct(stylist);
        stylist.setProfileCompletionPct(pct);

        PartnerProfileStatus current = stylist.getPartnerProfileStatus();
        if (current == PartnerProfileStatus.SUSPENDED
                || current == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || current == PartnerProfileStatus.APPROVED
                || current == PartnerProfileStatus.CHANGES_REQUESTED) {
            return stylistRepository.save(stylist);
        }

        if (missing.isEmpty()) {
            setLifecycleStatus(stylist, PartnerProfileStatus.READY_FOR_VERIFICATION);
        } else if (current == null
                || current == PartnerProfileStatus.REGISTERED
                || current == PartnerProfileStatus.READY_FOR_VERIFICATION
                || current == PartnerProfileStatus.REJECTED) {
            setLifecycleStatus(stylist, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        return stylistRepository.save(stylist);
    }

    public boolean isReadyForVerification(Stylist stylist) {
        return missingItems(stylist).isEmpty();
    }

    public Map<String, Object> profilePayload(Stylist stylist) {
        refreshCompletion(stylist);
        List<String> missing = missingItems(stylist);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", stylist.getId());
        m.put("firstName", stylist.getFirstName());
        m.put("lastName", stylist.getLastName());
        m.put("email", stylist.getEmail());
        m.put("contactNumber", stylist.getContactNumber());
        m.put("specialization", stylist.getSpecialization());
        m.put("bio", stylist.getBio());
        m.put("availabilityHours", stylist.getAvailabilityHours());
        m.put("experienceInYears", stylist.getExperienceInYears());
        m.put("profileImage", stylist.getProfileImage());
        m.put("approved", stylist.isApproved());
        m.put("salonId", stylist.getSalon() == null ? null : stylist.getSalon().getId());
        m.put("partnerProfileStatus", stylist.getPartnerProfileStatus() == null
                ? null : stylist.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(stylist.getPartnerProfileStatus()));
        m.put("profileCompletionPct", stylist.getProfileCompletionPct() == null
                ? 0 : stylist.getProfileCompletionPct());
        m.put("missingItems", missing);
        m.put("canSubmitForVerification", canSubmit(stylist, missing));
        m.put("rejectionReason", stylist.getRejectionReason());
        m.put("changesRequestedNote", stylist.getChangesRequestedNote());
        m.put("nextStepGuidance", guidance(stylist, missing));
        return m;
    }

    private boolean canSubmit(Stylist stylist, List<String> missing) {
        PartnerProfileStatus s = stylist.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL || s == PartnerProfileStatus.SUSPENDED) {
            return false;
        }
        return missing.isEmpty();
    }

    private String guidance(Stylist stylist, List<String> missing) {
        PartnerProfileStatus s = stylist.getPartnerProfileStatus();
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            return "Your stylist profile is under admin review. You'll be notified once approved.";
        }
        if (s == PartnerProfileStatus.APPROVED) {
            return "Your stylist profile is approved and visible to clients.";
        }
        if (s == PartnerProfileStatus.REJECTED) {
            return "Registration was rejected. Update your profile and resubmit.";
        }
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) {
            return "Admin requested changes. Update the highlighted items and resubmit.";
        }
        if (!missing.isEmpty()) {
            return "Complete " + missing.get(0) + " to submit verification.";
        }
        return "All required items are ready. Submit for admin verification.";
    }
}
