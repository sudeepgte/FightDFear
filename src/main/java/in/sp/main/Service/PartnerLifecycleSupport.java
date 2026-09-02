package in.sp.main.Service;

import java.util.List;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;

/**
 * Shared helpers to keep PartnerProfileStatus in sync with legacy VerificationStatus / approved flags.
 */
public final class PartnerLifecycleSupport {

    private PartnerLifecycleSupport() {}

    public static String statusLabel(PartnerProfileStatus status) {
        if (status == null) return "Profile Incomplete";
        return switch (status) {
            case REGISTERED -> "Registered";
            case PROFILE_INCOMPLETE -> "Profile Incomplete";
            case READY_FOR_VERIFICATION -> "Ready to Submit";
            case PENDING_ADMIN_APPROVAL -> "Pending Approval";
            case APPROVED -> "Approved";
            case CHANGES_REQUESTED -> "Changes Requested";
            case REJECTED -> "Rejected";
            case SUSPENDED -> "Suspended";
        };
    }

    public static VerificationStatus toVerificationStatus(PartnerProfileStatus status) {
        if (status == null) return VerificationStatus.PENDING;
        return switch (status) {
            case APPROVED -> VerificationStatus.VERIFIED;
            case REJECTED -> VerificationStatus.REJECTED;
            default -> VerificationStatus.PENDING;
        };
    }

    public static PartnerProfileStatus fromVerificationStatus(VerificationStatus status) {
        if (status == null) return PartnerProfileStatus.PROFILE_INCOMPLETE;
        return switch (status) {
            case VERIFIED -> PartnerProfileStatus.APPROVED;
            case REJECTED, CANCELLED -> PartnerProfileStatus.REJECTED;
            case PENDING, CHANGES_REQUESTED, RE_VERIFICATION -> PartnerProfileStatus.PENDING_ADMIN_APPROVAL;
        };
    }

    public static PartnerProfileStatus fromApprovedFlag(boolean approved) {
        return approved ? PartnerProfileStatus.APPROVED : PartnerProfileStatus.PENDING_ADMIN_APPROVAL;
    }

    public static boolean needsProfileCompletion(PartnerProfileStatus status) {
        return status != PartnerProfileStatus.APPROVED
                && status != PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                && status != PartnerProfileStatus.SUSPENDED;
    }

    public static boolean isPendingAdminQueue(PartnerProfileStatus status) {
        return status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                || status == PartnerProfileStatus.READY_FOR_VERIFICATION
                || status == PartnerProfileStatus.CHANGES_REQUESTED
                || status == PartnerProfileStatus.PROFILE_INCOMPLETE
                || status == PartnerProfileStatus.REGISTERED
                || status == null;
    }

    public static List<PartnerProfileStatus> pendingQueueStatuses() {
        return List.of(
                PartnerProfileStatus.PENDING_ADMIN_APPROVAL,
                PartnerProfileStatus.READY_FOR_VERIFICATION,
                PartnerProfileStatus.CHANGES_REQUESTED,
                PartnerProfileStatus.PROFILE_INCOMPLETE,
                PartnerProfileStatus.REGISTERED
        );
    }

    public static int pendingPriority(PartnerProfileStatus s) {
        if (s == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) return 0;
        if (s == PartnerProfileStatus.CHANGES_REQUESTED) return 1;
        if (s == PartnerProfileStatus.READY_FOR_VERIFICATION) return 2;
        if (s == null) return 3;
        return 4;
    }

    public static boolean blank(String v) {
        return v == null || v.isBlank();
    }
}
