package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorDraftStatus;
import in.sp.main.Entities.DoctorProfileDraft;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.DoctorVerificationAction;
import in.sp.main.Entities.DoctorVerificationActionType;
import in.sp.main.Repository.DoctorProfileDraftRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.DoctorVerificationActionRepository;

@Service
public class DoctorVerificationService {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorProfileService doctorProfileService;

    @Autowired
    private DoctorDraftService doctorDraftService;

    @Autowired
    private DoctorProfileDraftRepository draftRepository;

    @Autowired
    private DoctorVerificationActionRepository actionRepository;

    @Autowired
    private DoctorNotificationService notificationService;

    public static String friendlyStatusLabel(DoctorProfileStatus status) {
        if (status == null) {
            return "Profile Incomplete";
        }
        return switch (status) {
            case REGISTERED, PROFILE_INCOMPLETE -> "Profile Incomplete";
            case READY_FOR_VERIFICATION -> "Ready for Verification";
            case PENDING_ADMIN_APPROVAL -> "Pending Admin Approval";
            case CHANGES_REQUESTED -> "Changes Requested";
            case APPROVED -> "Approved";
            case REJECTED -> "Rejected";
            case SUSPENDED -> "Suspended";
        };
    }

    @Transactional
    public void approve(Doctor doctor, Long adminId, String notes) {
        requireDoctor(doctor);
        if (Boolean.TRUE.equals(doctor.getHasPendingReverification())
                && doctorDraftService.findDraft(doctor.getId())
                        .map(d -> d.getStatus() == DoctorDraftStatus.PENDING_REVIEW)
                        .orElse(false)) {
            approveReverification(doctor, adminId, notes);
            return;
        }

        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorProfileService.markApproved(doctor);
        doctorDraftService.clearDraft(doctor);
        recordAction(doctor, DoctorVerificationActionType.APPROVED, from, DoctorProfileStatus.APPROVED, notes, null, adminId);
        notificationService.notifyDoctor(
                doctor,
                "VERIFICATION_APPROVED",
                "Profile approved",
                "Your doctor profile has been approved. Patients can now discover and book you."
                        + (isBlank(notes) ? "" : "\n\nAdmin note: " + notes.trim()),
                true);
        doctorRepository.save(doctor);
    }

    @Transactional
    public void reject(Doctor doctor, Long adminId, String notes) {
        requireDoctor(doctor);
        if (isBlank(notes)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Rejection notes are required");
        }
        if (Boolean.TRUE.equals(doctor.getHasPendingReverification())
                && doctorDraftService.findDraft(doctor.getId())
                        .map(d -> d.getStatus() == DoctorDraftStatus.PENDING_REVIEW)
                        .orElse(false)) {
            rejectReverification(doctor, adminId, notes);
            return;
        }

        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorProfileService.markRejected(doctor, notes);
        recordAction(doctor, DoctorVerificationActionType.REJECTED, from, DoctorProfileStatus.REJECTED, notes, null, adminId);
        notificationService.notifyDoctor(
                doctor,
                "VERIFICATION_REJECTED",
                "Profile rejected",
                "Your doctor profile was rejected.\n\nReason: " + notes.trim()
                        + "\n\nPlease update your profile and resubmit for verification.",
                true);
        doctorRepository.save(doctor);
    }

    @Transactional
    public void requestChanges(Doctor doctor, Long adminId, String reasons, String notes) {
        requireDoctor(doctor);
        String combined = combineReasonsAndNotes(reasons, notes);
        if (isBlank(combined)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Please select a reason or enter comments");
        }

        if (Boolean.TRUE.equals(doctor.getHasPendingReverification())
                && doctorDraftService.findDraft(doctor.getId())
                        .map(d -> d.getStatus() == DoctorDraftStatus.PENDING_REVIEW)
                        .orElse(false)) {
            requestChangesOnReverification(doctor, adminId, reasons, notes);
            return;
        }

        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorProfileService.markChangesRequested(doctor, combined);
        recordAction(doctor, DoctorVerificationActionType.CHANGES_REQUESTED, from,
                DoctorProfileStatus.CHANGES_REQUESTED, notes, reasons, adminId);
        notificationService.notifyDoctor(
                doctor,
                "CHANGES_REQUESTED",
                "Changes requested",
                "An admin requested changes to your doctor profile.\n\n" + combined
                        + "\n\nPlease update the requested information and resubmit for verification.",
                true);
        doctorRepository.save(doctor);
    }

    @Transactional
    public void recordSubmission(Doctor doctor, boolean resubmit) {
        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        DoctorVerificationActionType action = resubmit
                ? DoctorVerificationActionType.RESUBMITTED
                : DoctorVerificationActionType.SUBMITTED;
        recordAction(doctor, action, from, DoctorProfileStatus.PENDING_ADMIN_APPROVAL, null, null, null);
        notificationService.notifyDoctor(
                doctor,
                "VERIFICATION_SUBMITTED",
                resubmit ? "Profile resubmitted" : "Profile submitted for verification",
                resubmit
                        ? "Your updated profile has been resubmitted for admin review."
                        : "Your profile has been submitted for admin verification. We will notify you once it is reviewed.",
                true);
    }

    @Transactional
    public void recordReverificationSubmission(Doctor doctor) {
        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        recordAction(doctor, DoctorVerificationActionType.REVERIFICATION_SUBMITTED, from, from,
                "Approved profile changes submitted for review", null, null);
        notificationService.notifyDoctor(
                doctor,
                "REVERIFICATION_SUBMITTED",
                "Changes pending admin approval",
                "Your profile changes were saved as pending review. Your currently approved profile remains visible to patients until the new changes are approved.",
                true);
    }

    public List<Map<String, Object>> history(Long doctorId) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (DoctorVerificationAction a : actionRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId)) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", a.getId());
            row.put("action", a.getAction() == null ? null : a.getAction().name());
            row.put("fromStatus", a.getFromStatus());
            row.put("toStatus", a.getToStatus());
            row.put("fromStatusLabel", labelFromRaw(a.getFromStatus()));
            row.put("toStatusLabel", labelFromRaw(a.getToStatus()));
            row.put("notes", a.getNotes());
            row.put("reasons", a.getReasons());
            row.put("adminId", a.getAdminId());
            row.put("createdAt", a.getCreatedAt() == null ? null : a.getCreatedAt().toString());
            out.add(row);
        }
        return out;
    }

    public List<Doctor> queueByFilter(String filter) {
        String f = filter == null ? "pending" : filter.trim().toLowerCase(Locale.ROOT);
        return switch (f) {
            case "approved" -> doctorRepository.findByDoctorProfileStatus(DoctorProfileStatus.APPROVED);
            case "rejected" -> doctorRepository.findByDoctorProfileStatus(DoctorProfileStatus.REJECTED);
            case "changes_requested", "changes-requested" ->
                    doctorRepository.findByDoctorProfileStatus(DoctorProfileStatus.CHANGES_REQUESTED);
            case "reverification" -> doctorRepository.findByHasPendingReverificationTrue().stream()
                    .filter(d -> doctorDraftService.findDraft(d.getId())
                            .map(dr -> dr.getStatus() == DoctorDraftStatus.PENDING_REVIEW)
                            .orElse(false))
                    .collect(Collectors.toList());
            case "ready" -> doctorRepository.findByDoctorProfileStatus(DoctorProfileStatus.READY_FOR_VERIFICATION);
            case "all" -> doctorRepository.findAll();
            default -> doctorRepository.findByDoctorProfileStatusIn(List.of(
                    DoctorProfileStatus.PENDING_ADMIN_APPROVAL,
                    DoctorProfileStatus.READY_FOR_VERIFICATION,
                    DoctorProfileStatus.PROFILE_INCOMPLETE,
                    DoctorProfileStatus.REGISTERED));
        };
    }

    private void approveReverification(Doctor doctor, Long adminId, String notes) {
        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorDraftService.applyDraftToLive(doctor);
        doctorProfileService.refreshCompletion(doctor);
        doctorProfileService.syncVerificationStatus(doctor);
        recordAction(doctor, DoctorVerificationActionType.REVERIFICATION_APPROVED, from, from,
                notes, null, adminId);
        notificationService.notifyDoctor(
                doctor,
                "REVERIFICATION_APPROVED",
                "Profile changes approved",
                "Your pending profile changes have been approved and are now live."
                        + (isBlank(notes) ? "" : "\n\nAdmin note: " + notes.trim()),
                true);
        doctorRepository.save(doctor);
    }

    private void rejectReverification(Doctor doctor, Long adminId, String notes) {
        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorDraftService.rejectDraft(doctor, notes);
        recordAction(doctor, DoctorVerificationActionType.REVERIFICATION_REJECTED, from, from,
                notes, null, adminId);
        notificationService.notifyDoctor(
                doctor,
                "REVERIFICATION_REJECTED",
                "Profile changes rejected",
                "Your pending profile changes were rejected. Your currently approved profile is unchanged.\n\nReason: "
                        + notes.trim(),
                true);
        doctorRepository.save(doctor);
    }

    private void requestChangesOnReverification(Doctor doctor, Long adminId, String reasons, String notes) {
        String combined = combineReasonsAndNotes(reasons, notes);
        DoctorProfileStatus from = doctor.getDoctorProfileStatus();
        doctorDraftService.rejectDraft(doctor, combined);
        recordAction(doctor, DoctorVerificationActionType.REVERIFICATION_CHANGES_REQUESTED, from, from,
                notes, reasons, adminId);
        notificationService.notifyDoctor(
                doctor,
                "REVERIFICATION_CHANGES_REQUESTED",
                "Changes requested on pending updates",
                "An admin requested changes to your pending profile updates. Your currently approved profile remains live.\n\n"
                        + combined,
                true);
        doctorRepository.save(doctor);
    }

    private void recordAction(
            Doctor doctor,
            DoctorVerificationActionType action,
            DoctorProfileStatus from,
            DoctorProfileStatus to,
            String notes,
            String reasons,
            Long adminId) {
        DoctorVerificationAction row = new DoctorVerificationAction();
        row.setDoctorId(doctor.getId());
        row.setAction(action);
        row.setFromStatus(from == null ? null : from.name());
        row.setToStatus(to == null ? null : to.name());
        row.setNotes(isBlank(notes) ? null : notes.trim());
        row.setReasons(isBlank(reasons) ? null : reasons.trim());
        row.setAdminId(adminId);
        actionRepository.save(row);
    }

    private static String combineReasonsAndNotes(String reasons, String notes) {
        StringBuilder sb = new StringBuilder();
        if (!isBlank(reasons)) {
            sb.append("Reasons: ").append(reasons.trim());
        }
        if (!isBlank(notes)) {
            if (sb.length() > 0) {
                sb.append("\n");
            }
            sb.append(notes.trim());
        }
        return sb.toString();
    }

    private static String labelFromRaw(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        try {
            return friendlyStatusLabel(DoctorProfileStatus.valueOf(raw));
        } catch (Exception ex) {
            return raw;
        }
    }

    private static void requireDoctor(Doctor doctor) {
        if (doctor == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Doctor not found");
        }
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public Map<String, Object> draftSummary(Doctor doctor) {
        return doctorDraftService.findDraft(doctor.getId()).map(d -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("status", d.getStatus() == null ? null : d.getStatus().name());
            m.put("adminNotes", d.getAdminNotes());
            m.put("submittedAt", d.getSubmittedAt() == null ? null : d.getSubmittedAt().toString());
            m.put("fields", doctorDraftService.readDraftMap(d));
            return m;
        }).orElse(null);
    }

    public List<DoctorProfileDraft> pendingReverificationDrafts() {
        return draftRepository.findByStatus(DoctorDraftStatus.PENDING_REVIEW);
    }
}
