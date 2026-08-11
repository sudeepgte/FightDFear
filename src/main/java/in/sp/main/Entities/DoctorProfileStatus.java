package in.sp.main.Entities;

/**
 * Doctor onboarding and verification lifecycle.
 * {@link VerificationStatus} remains for backward-compatible patient listing filters.
 */
public enum DoctorProfileStatus {
    REGISTERED,
    PROFILE_INCOMPLETE,
    READY_FOR_VERIFICATION,
    PENDING_ADMIN_APPROVAL,
    APPROVED,
    CHANGES_REQUESTED,
    REJECTED,
    SUSPENDED;

    public boolean canLogin() {
        return this != SUSPENDED;
    }

    public boolean isVisibleToPatients() {
        return this == APPROVED;
    }
}
