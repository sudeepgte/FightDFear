package in.sp.main.Entities;

/**
 * Lifecycle for Self-Defense Centre (MartialArtsCenter) registration —
 * mirrors {@link DoctorProfileStatus}.
 */
public enum CentreProfileStatus {
    REGISTERED,
    PROFILE_INCOMPLETE,
    READY_FOR_VERIFICATION,
    PENDING_ADMIN_APPROVAL,
    APPROVED,
    CHANGES_REQUESTED,
    REJECTED,
    SUSPENDED
}
