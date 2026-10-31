<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Service Partner Profile — Admin Verification</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.wp-admin-wp { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; background: var(--ap-bg, #F8FAFC); }
  body.wp-admin-wp .layout { display: flex; min-height: 100vh; }
  body.wp-admin-wp .main { flex: 1; min-width: 0; background: var(--ap-bg, #F8FAFC); }
  body.wp-admin-wp .mainInner { max-width: 960px; margin: 0 auto; padding: 22px 24px 60px; }
  body.wp-admin-wp .profile-card {
      background: #FFFFFF; border-radius: 16px; padding: 32px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.03); border: 1px solid var(--ap-border, #E2E8F0);
  }
  body.wp-admin-wp .profile-header {
      display: flex; flex-direction: column; align-items: center; text-align: center;
      margin-bottom: 28px; padding-bottom: 24px; border-bottom: 1px solid var(--ap-border, #E2E8F0);
  }
  body.wp-admin-wp .profile-avatar {
      width: 104px; height: 104px; background: #FFF1F2; color: #F43F5E;
      border-radius: 50%; display: flex; align-items: center; justify-content: center;
      font-size: 2.6rem; font-weight: 800; margin-bottom: 14px; border: 3px solid #FDA4AF; overflow: hidden;
  }
  body.wp-admin-wp .profile-name { font-size: 1.65rem; font-weight: 800; color: #0F172A; margin-bottom: 4px; }
  body.wp-admin-wp .profile-business { color: #F43F5E; font-size: 1.05rem; font-weight: 700; margin-bottom: 12px; }
  body.wp-admin-wp .badge-status {
    padding: 6px 16px; border-radius: 999px; font-size: 0.8rem; font-weight: 700; display: inline-flex; align-items: center; gap: 6px;
  }
  body.wp-admin-wp .status-VERIFIED, body.wp-admin-wp .status-APPROVED { background: #DCFCE7; color: #166534; }
  body.wp-admin-wp .status-PENDING { background: #FEF3C7; color: #92400E; }
  body.wp-admin-wp .status-RE_VERIFICATION { background: #DBEAFE; color: #1E40AF; }
  body.wp-admin-wp .status-CHANGES_REQUESTED { background: #F3E8FF; color: #6B21A8; }
  body.wp-admin-wp .status-REJECTED { background: #FEE2E2; color: #991B1B; }

  body.wp-admin-wp .section-title {
      font-size: 1.05rem; font-weight: 800; color: #0F172A; margin-bottom: 14px;
      display: flex; align-items: center; gap: 8px;
  }
  body.wp-admin-wp .info-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
      gap: 14px; margin-bottom: 26px;
  }
  body.wp-admin-wp .info-item {
      background: #F8FAFC; padding: 14px 16px; border-radius: 12px; border: 1px solid var(--ap-border, #E2E8F0);
  }
  body.wp-admin-wp .info-label {
      font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.05em;
      color: #64748B; font-weight: 700; margin-bottom: 5px;
      display: flex; align-items: center; gap: 6px;
  }
  body.wp-admin-wp .info-value { font-size: 0.95rem; font-weight: 600; color: #0F172A; word-break: break-word; }
  body.wp-admin-wp .doc-box {
      background: #F8FAFC; border-radius: 12px; padding: 18px; display: flex; align-items: center;
      gap: 16px; border: 1px solid var(--ap-border, #E2E8F0); margin-bottom: 26px;
  }
  body.wp-admin-wp .doc-box-icon {
      width: 48px; height: 48px; background: #fff; color: #F43F5E; border-radius: 10px;
      display: flex; align-items: center; justify-content: center; font-size: 1.4rem;
      border: 1px solid var(--ap-border, #E2E8F0); flex-shrink: 0;
  }
  body.wp-admin-wp .doc-box-content .label { font-size: 0.82rem; color: #64748B; margin-bottom: 4px; font-weight: 600; }
  body.wp-admin-wp .doc-link { color: #F43F5E; font-weight: 700; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
  body.wp-admin-wp .action-bar {
      display: flex; gap: 12px; flex-wrap: wrap; padding-top: 18px;
  }
  body.wp-admin-wp .btn-verify {
      background: #16A34A; color: #fff; border: none; border-radius: 9px;
      padding: 10px 22px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
  }
  body.wp-admin-wp .btn-verify:hover { background: #15803D; }
  body.wp-admin-wp .btn-changes {
      background: #8B5CF6; color: #fff; border: none; border-radius: 9px;
      padding: 10px 22px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
  }
  body.wp-admin-wp .btn-changes:hover { background: #7C3AED; }
  body.wp-admin-wp .btn-reject {
      background: #DC2626; color: #fff; border: none; border-radius: 9px;
      padding: 10px 22px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
  }
  body.wp-admin-wp .btn-reject:hover { background: #B91C1C; }
  body.wp-admin-wp .ap-btn-back {
      display: inline-flex; align-items: center; gap: 6px; height: 38px; padding: 7px 16px;
      border-radius: 9px; border: 1px solid var(--ap-border, #E2E8F0); background: #fff; color: #0F172A;
      font-weight: 700; font-size: 0.85rem; text-decoration: none; margin-left: auto; transition: all 0.2s;
  }
  body.wp-admin-wp .ap-btn-back:hover { background: #F1F5F9; color: #F43F5E; }
  body.wp-admin-wp .ap-page-head { align-items: center; }
  @media (max-width: 700px) { body.wp-admin-wp .mainInner { padding: 16px 14px 40px; } }
</style>
</head>
<body class="ap-page wp-admin-wp">
<c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>

<div class="layout">
  <%@ include file="src/main/webapp/WEB-INF/views/globalAdminMenu.jsp" %>
  <main class="main">
    <div class="ap-topbar topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${apAdmin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty apAdmin.profilePhoto}"><img src="${pageContext.request.contextPath}${apAdmin.profilePhoto}" alt=""></c:when>
              <c:otherwise>${fn:substring(apAdmin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span><div class="name"><c:out value="${apAdmin.name}"/></div><div class="role">Super Admin</div></span>
        </a>
      </div>
    </div>
    <div class="mainInner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=${categoryParam}&filter=${filterParam}&q=${qParam}">Service Partners</a>
        <span class="sep">&gt;</span>
        <span>Provider Profile</span>
      </nav>
      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-user-tie"></i></div>
        <div>
          <h1>Provider Profile Details</h1>
          <p>Review submitted credentials, documentation, and administer approval</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=${categoryParam}&filter=${filterParam}&q=${qParam}" class="ap-btn-back">
            <i class="fas fa-arrow-left"></i> Back to Queue
        </a>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show mb-3" style="border-radius:12px;">
          <i class="fas fa-info-circle me-1"></i> <c:out value="${message}"/>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-3" style="border-radius:12px;">
          <i class="fas fa-exclamation-triangle me-1"></i> <c:out value="${error}"/>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>

      <div class="profile-card">
          <!-- Profile Header -->
          <div class="profile-header">
              <div class="profile-avatar">
                  <c:choose>
                      <c:when test="${not empty provider.profilePhoto}">
                          <img src="${pageContext.request.contextPath}${provider.profilePhoto}" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                      </c:when>
                      <c:otherwise>
                          ${not empty provider.fullName ? fn:substring(provider.fullName,0,1) : 'P'}
                      </c:otherwise>
                  </c:choose>
              </div>

              <div class="profile-name"><c:out value="${provider.fullName}"/></div>
              <div class="profile-business">
                  <c:out value="${not empty provider.businessName ? provider.businessName : (not empty provider.category ? provider.category.displayName : 'Service Partner')}"/>
              </div>
              
              <c:set var="vStat" value="${provider.verificationStatus}"/>
              <c:set var="pStat" value="${provider.partnerProfileStatus}"/>
              <c:choose>
                  <c:when test="${vStat == 'VERIFIED' || vStat == 'APPROVED' || pStat == 'APPROVED'}">
                      <span class="badge-status status-VERIFIED"><i class="fas fa-check-circle"></i> APPROVED</span>
                  </c:when>
                  <c:when test="${vStat == 'RE_VERIFICATION' || pStat == 'READY_FOR_VERIFICATION'}">
                      <span class="badge-status status-RE_VERIFICATION"><i class="fas fa-sync"></i> RE-VERIFICATION</span>
                  </c:when>
                  <c:when test="${vStat == 'CHANGES_REQUESTED' || pStat == 'CHANGES_REQUESTED'}">
                      <span class="badge-status status-CHANGES_REQUESTED"><i class="fas fa-edit"></i> CHANGES REQUESTED</span>
                  </c:when>
                  <c:when test="${vStat == 'REJECTED' || pStat == 'REJECTED'}">
                      <span class="badge-status status-REJECTED"><i class="fas fa-times-circle"></i> REJECTED</span>
                  </c:when>
                  <c:otherwise>
                      <span class="badge-status status-PENDING"><i class="fas fa-clock"></i> PENDING VERIFICATION</span>
                  </c:otherwise>
              </c:choose>
          </div>

          <!-- 1. Personal & Contact Information -->
          <div class="section-title"><i class="fas fa-user-circle text-danger"></i> 1. Contact Information</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                  <div class="info-value"><c:out value="${not empty provider.fullName ? provider.fullName : '-'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-envelope"></i> Email Address</div>
                  <div class="info-value"><c:out value="${not empty provider.email ? provider.email : '-'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-phone"></i> Contact Phone</div>
                  <div class="info-value"><c:out value="${not empty provider.phone ? provider.phone : '-'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fab fa-whatsapp"></i> WhatsApp Number</div>
                  <div class="info-value"><c:out value="${not empty provider.whatsappNumber ? provider.whatsappNumber : '-'}"/></div>
              </div>
          </div>

          <!-- 2. Professional & Business Details -->
          <div class="section-title"><i class="fas fa-briefcase text-primary"></i> 2. Professional &amp; Business Details</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-layer-group"></i> Service Category</div>
                  <div class="info-value">
                      <span class="badge bg-light text-dark border"><c:out value="${not empty provider.category ? provider.category.displayName : '-'}"/></span>
                  </div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-store"></i> Business / Brand Name</div>
                  <div class="info-value"><c:out value="${not empty provider.businessName ? provider.businessName : '-'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-history"></i> Experience</div>
                  <div class="info-value"><c:out value="${not empty provider.experience ? provider.experience : (not empty provider.experienceYears ? provider.experienceYears.toString().concat(' Years') : '-')}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-rupee-sign"></i> Consultation / Service Fee</div>
                  <div class="info-value"><c:out value="${not empty provider.consultationFee ? '₹'.concat(provider.consultationFee.toString()) : '-'}"/></div>
              </div>
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-graduation-cap"></i> Qualifications / Certifications</div>
                  <div class="info-value"><c:out value="${not empty provider.qualification ? provider.qualification : '-'}"/></div>
              </div>
              <c:if test="${not empty provider.practiceAreas || not empty provider.barCouncilId}">
                  <div class="info-item">
                      <div class="info-label"><i class="fas fa-gavel"></i> Bar Council / License ID</div>
                      <div class="info-value"><c:out value="${not empty provider.barCouncilId ? provider.barCouncilId : '-'}"/></div>
                  </div>
                  <div class="info-item" style="grid-column: 2 / -1;">
                      <div class="info-label"><i class="fas fa-tags"></i> Practice Areas</div>
                      <div class="info-value"><c:out value="${not empty provider.practiceAreas ? provider.practiceAreas : '-'}"/></div>
                  </div>
              </c:if>
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-align-left"></i> Profile Bio / Description</div>
                  <div class="info-value" style="white-space: pre-line;"><c:out value="${not empty provider.description ? provider.description : (not empty provider.bio ? provider.bio : '-')}"/></div>
              </div>
          </div>

          <!-- 3. Location & Availability -->
          <div class="section-title"><i class="fas fa-map-marker-alt text-success"></i> 3. Location &amp; Availability</div>
          <div class="info-grid">
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-map"></i> Location / City / Area</div>
                  <div class="info-value"><c:out value="${not empty provider.locationText ? provider.locationText : (not empty provider.address ? provider.address : '-')}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-calendar-alt"></i> Available Days</div>
                  <div class="info-value"><c:out value="${not empty provider.availableDays ? provider.availableDays : (not empty provider.openDays ? provider.openDays : '-')}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-clock"></i> Working Hours</div>
                  <div class="info-value">
                      <c:choose>
                          <c:when test="${not empty provider.workingHoursFrom || not empty provider.workingHoursTo}">
                              <c:out value="${provider.workingHoursFrom}"/> - <c:out value="${provider.workingHoursTo}"/>
                          </c:when>
                          <c:when test="${not empty provider.openTime || not empty provider.closeTime}">
                              <c:out value="${provider.openTime}"/> - <c:out value="${provider.closeTime}"/>
                          </c:when>
                          <c:otherwise>-</c:otherwise>
                      </c:choose>
                  </div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-language"></i> Languages Spoken</div>
                  <div class="info-value"><c:out value="${not empty provider.languagesSpoken ? provider.languagesSpoken : (not empty provider.languages ? provider.languages : '-')}"/></div>
              </div>
          </div>

          <!-- 4. Verification Document -->
          <div class="section-title"><i class="fas fa-id-card text-info"></i> 4. Verification Document</div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-file-contract"></i></div>
              <div class="doc-box-content">
                  <c:choose>
                      <c:when test="${not empty provider.identityDocumentPath && provider.identityDocumentPath != 'web-pending'}">
                          <div class="label">Identification / Professional Certificate Document</div>
                          <a href="${pageContext.request.contextPath}${provider.identityDocumentPath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View Document in New Tab
                          </a>
                      </c:when>
                      <c:otherwise>
                          <div class="text-muted">No identification document uploaded.</div>
                      </c:otherwise>
                  </c:choose>
              </div>
          </div>

          <!-- 5. Submission & Review History -->
          <div class="section-title"><i class="fas fa-history text-secondary"></i> 5. Submission &amp; Review History</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-calendar-check"></i> Submitted At</div>
                  <div class="info-value"><c:out value="${not empty provider.submittedForVerificationAt ? provider.submittedForVerificationAt : 'Pending submission'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-percent"></i> Profile Completion</div>
                  <div class="info-value">${not empty provider.profileCompletionPct ? provider.profileCompletionPct : 0}%</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-user-shield"></i> Reviewed By Admin</div>
                  <div class="info-value"><c:out value="${not empty provider.reviewedByAdminName ? provider.reviewedByAdminName : 'Not yet reviewed'}"/></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-clock"></i> Reviewed At</div>
                  <div class="info-value"><c:out value="${not empty provider.reviewedAt ? provider.reviewedAt : '-'}"/></div>
              </div>
          </div>

          <!-- Decision Panel -->
          <div class="section-title mt-4"><i class="fas fa-gavel text-danger"></i> Administrator Decision &amp; Actions</div>
          <div class="doc-box" style="display:block;">
              <c:if test="${not empty provider.changesRequestedNote}">
                  <div class="alert alert-warning py-2 px-3 small mb-3" style="border-radius:10px;">
                      <strong><i class="fas fa-edit me-1"></i> Changes Requested Feedback:</strong>
                      <div class="mt-1"><c:out value="${provider.changesRequestedNote}"/></div>
                  </div>
              </c:if>
              <c:if test="${not empty provider.rejectionReason}">
                  <div class="alert alert-danger py-2 px-3 small mb-3" style="border-radius:10px;">
                      <strong><i class="fas fa-times-circle me-1"></i> Rejection Reason:</strong>
                      <div class="mt-1"><c:out value="${provider.rejectionReason}"/></div>
                  </div>
              </c:if>
              
              <div class="mb-3">
                  <label class="form-label fw-bold" style="font-size:0.88rem; color:#0F172A;">Feedback / Explanation (Required for Request Changes and Reject)</label>
                  <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Enter instructions for the provider or reason for rejection..."></textarea>
              </div>

              <div class="action-bar" style="border-top:none; padding-top:4px;">
                  <c:if test="${vStat != 'VERIFIED' && vStat != 'APPROVED' && pStat != 'APPROVED'}">
                      <form id="approveForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/verify" method="post" class="m-0 p-0"
                            onsubmit="return confirm('Are you sure you want to approve provider ${fn:escapeXml(provider.fullName)}?');">
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                          <input type="hidden" name="category" value="${categoryParam}"/>
                          <input type="hidden" name="filter" value="${filterParam}"/>
                          <input type="hidden" name="q" value="${qParam}"/>
                          <button type="submit" class="btn-verify">
                              <i class="fas fa-check-circle"></i> Approve Provider
                          </button>
                      </form>
                  </c:if>

                  <form id="changesForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/request-changes" method="post" class="m-0 p-0"
                        onsubmit="var n = document.getElementById('decisionNotes').value.trim(); if(!n){alert('Please enter instructions for the provider when requesting changes.'); return false;} document.getElementById('changesNote').value=n;">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                      <input type="hidden" name="category" value="${categoryParam}"/>
                      <input type="hidden" name="filter" value="${filterParam}"/>
                      <input type="hidden" name="q" value="${qParam}"/>
                      <input type="hidden" name="note" id="changesNote">
                      <button type="submit" class="btn-changes">
                          <i class="fas fa-edit"></i> Request Changes
                      </button>
                  </form>

                  <c:if test="${vStat != 'REJECTED' && pStat != 'REJECTED'}">
                      <form id="rejectForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/reject" method="post" class="m-0 p-0" 
                            onsubmit="var r = document.getElementById('decisionNotes').value.trim(); if(!r){alert('Please provide a reason to reject this provider.'); return false;} document.getElementById('rejectReason').value=r; return confirm('Are you sure you want to reject this provider application?');">
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                          <input type="hidden" name="category" value="${categoryParam}"/>
                          <input type="hidden" name="filter" value="${filterParam}"/>
                          <input type="hidden" name="q" value="${qParam}"/>
                          <input type="hidden" name="reason" id="rejectReason">
                          <button type="submit" class="btn-reject">
                              <i class="fas fa-times-circle"></i> Reject Application
                          </button>
                      </form>
                  </c:if>
              </div>
          </div>

      </div>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
