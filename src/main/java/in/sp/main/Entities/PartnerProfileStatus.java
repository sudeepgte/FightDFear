package in.sp.main.Entities;

/**
 * Shared partner registration lifecycle — same shape as DoctorProfileStatus / CentreProfileStatus.
 * Used by Fitness, Glow, Marketplace, Seller, Event Host, Entrepreneur, Investor.
 */
public enum PartnerProfileStatus {
    REGISTERED,
    PROFILE_INCOMPLETE,
    READY_FOR_VERIFICATION,
    PENDING_ADMIN_APPROVAL,
    APPROVED,
    CHANGES_REQUESTED,
    REJECTED,
    SUSPENDED
}
