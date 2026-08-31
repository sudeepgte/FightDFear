<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty doctor.fullName ? doctor.fullName : 'Doctor'} - Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.ap-page { margin: 0; }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  .mainInner { max-width: 1100px; margin: 0 auto; padding: 22px 24px 48px; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    text-decoration: none; font-weight: 600; font-size: 0.88rem; margin-bottom: 14px;
  }
  .back-nav:hover { color: var(--ap-accent); }

  .header-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 18px; box-shadow: var(--ap-shadow);
  }
  .header-card h1 { margin: 0; font-size: 1.45rem; font-weight: 800; color: var(--ap-text); font-family: Outfit, Poppins, sans-serif; }
  .header-card .contact-line { color: var(--ap-muted); font-size: 0.88rem; }
  .header-card .contact-line a { color: var(--ap-text); text-decoration: none; font-weight: 600; }
  .avatar-box {
    width: 96px; height: 96px; border-radius: 50%; overflow: hidden; flex-shrink: 0;
    border: 3px solid #FFE4E6; background: var(--ap-accent-soft);
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .progress-wrap { height: 8px; background: #F1F5F9; border-radius: 999px; overflow: hidden; }
  .progress-bar-fill { height: 100%; background: var(--ap-accent); border-radius: 999px; }

  .review-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 16px; box-shadow: var(--ap-shadow);
  }
  .section-header {
    display: flex; align-items: center; gap: 10px; margin-bottom: 16px;
    padding-bottom: 12px; border-bottom: 1px solid var(--ap-border);
  }
  .section-header i {
    width: 34px; height: 34px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: inline-flex; align-items: center; justify-content: center;
  }
  .section-header h3 { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--ap-text); }

  .info-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: 14px 18px; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    display: block; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
    text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px;
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-text); word-break: break-word; }
  .empty-text { color: #94A3B8; font-size: 0.88rem; font-style: italic; }

  .badge-status-lg {
    display: inline-flex; align-items: center; padding: 6px 12px; border-radius: 999px;
    font-size: 0.75rem; font-weight: 800; letter-spacing: 0.02em;
  }
  .status-APPROVED, .status-VERIFIED { background: var(--ap-success-bg); color: var(--ap-success); }
  .status-REJECTED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  .status-CHANGES_REQUESTED { background: #FFEDD5; color: #C2410C; }
  .status-PROFILE_INCOMPLETE, .status-PENDING, .status-PENDING_ADMIN_APPROVAL,
  .status-READY_FOR_VERIFICATION, .status-REGISTERED { background: #FEF3C7; color: #B45309; }

  .tag-pill {
    display: inline-flex; padding: 4px 10px; border-radius: 999px; background: #F8FAFC;
    border: 1px solid var(--ap-border); font-size: 0.78rem; font-weight: 600; margin: 0 6px 6px 0; color: #334155;
  }
  .fee-tile {
    border: 1px solid var(--ap-border); border-radius: 12px; padding: 12px; background: #FCFCFD; height: 100%;
  }
  .fee-tile .amt { font-size: 1.1rem; font-weight: 800; color: var(--ap-text); }

  .doc-row {
    display: flex; align-items: center; gap: 12px; padding: 12px; border: 1px solid var(--ap-border);
    border-radius: 12px; margin-bottom: 10px; background: #fff;
  }
  .doc-icon {
    width: 40px; height: 40px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .doc-link { color: var(--ap-accent); font-weight: 700; text-decoration: none; font-size: 0.86rem; }
  .doc-link:hover { text-decoration: underline; }
  .warn-mobile { color: #B45309; font-size: 0.82rem; font-weight: 600; }

  .history-table th { font-size: 0.72rem; color: var(--ap-muted); text-transform: uppercase; }
  .history-table td { font-size: 0.84rem; vertical-align: top; }

  .action-bar { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }
  .btn-verify, .btn-reject, .btn-changes {
    border: 0; border-radius: 10px; padding: 12px 22px; font-weight: 700; font-size: 0.9rem;
    display: inline-flex; align-items: center; gap: 8px; cursor: pointer;
  }
  .btn-verify { background: var(--ap-success); color: #fff; }
  .btn-changes { background: var(--ap-warn); color: #fff; }
  .btn-reject { background: var(--ap-danger); color: #fff; }
  .reason-checks label {
    display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--ap-border);
    border-radius: 999px; padding: 6px 12px; font-size: 0.82rem; background: #fff; cursor: pointer;
  }

  @media (max-width: 768px) {
    .mainInner { padding: 16px 14px 40px; }
    .info-grid { grid-template-columns: 1fr; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .btn-changes { width: 100%; justify-content: center; }
  }
</style>
</head>
<body class="ap-page">

<c:set var="pp" value="${profilePayload}"/>
<c:set var="displayName" value="${not empty doctor.fullName ? doctor.fullName : pp.fullName}"/>
<c:set var="displayEmail" value="${not empty doctor.email ? doctor.email : pp.email}"/>
<c:set var="displayPhone" value="${not empty doctor.phone ? doctor.phone : pp.phone}"/>
<c:set var="photoPath" value="${not empty doctor.profilePhotoPath ? doctor.profilePhotoPath : pp.profilePhotoPath}"/>
<c:set var="photoOk" value="${not empty photoPath and photoPath != 'mobile-pending' and not fn:startsWith(photoPath, 'mobile:')}"/>
<c:set var="pct" value="${doctor.profileCompletionPct != null ? doctor.profileCompletionPct : pp.profileCompletionPct}"/>
<c:if test="${empty pct}"><c:set var="pct" value="0"/></c:if>
<c:set var="statusKey" value="${not empty pp.doctorProfileStatus ? pp.doctorProfileStatus : doctor.doctorProfileStatus}"/>
<c:if test="${empty statusKey}"><c:set var="statusKey" value="PENDING"/></c:if>
<c:set var="displayStatus" value="${not empty statusLabel ? statusLabel : pp.doctorProfileStatusLabel}"/>
<c:if test="${empty displayStatus}"><c:set var="displayStatus" value="${statusKey}"/></c:if>


<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:320px;">
          <i class="fas fa-search"></i>
          <input type="search" placeholder="Search anything..." aria-label="Search" readonly
                 onclick="window.location.href='${pageContext.request.contextPath}/admin/pending-doctors'">
          <span class="ap-kbd">Ctrl + K</span>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
          <i class="fas fa-bell"></i>
          <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
        </a>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
          <span class="ap-avatar">${fn:substring(admin.name,0,1)}</span>
          <span>
            <div class="name"><c:out value="${admin.name}"/></div>
            <div class="role">Super Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="mainInner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-doctors">Doctor Verification</a>
        <span class="sep">&gt;</span>
        <span>Review</span>
      </nav>

<c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show mb-3 rounded-4" role="alert">
          <i class="bi bi-check-circle-fill me-2"></i>${message}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-3 rounded-4" role="alert">
          <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>

      <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Doctors
      </a>

      <!-- 1. Applicant header -->
      <div class="header-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
            <c:choose>
              <c:when test="${photoOk}">
                <img src="${fn:startsWith(photoPath, 'http') ? photoPath : pageContext.request.contextPath.concat(photoPath)}" alt="${displayName}">
              </c:when>
              <c:otherwise>
                <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light">
                  <i class="bi bi-stethoscope" style="font-size:2.6rem;color:#94a3b8;"></i>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="flex-grow-1" style="position:relative;z-index:1;">
            <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
              <h1>${not empty displayName ? displayName : 'Unnamed doctor'}</h1>
              <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
            </div>
            <div class="d-flex flex-wrap gap-3 gap-md-4 contact-line small mb-3">
              <div>
                <i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty displayEmail}"><a href="mailto:${displayEmail}" class="text-decoration-none">${displayEmail}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty displayPhone}"><a href="tel:${displayPhone}" class="text-decoration-none">${displayPhone}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
            </div>
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold mb-1">
                <span>Profile Completion</span>
                <span>${pct}%</span>
              </div>
              <div class="progress-wrap">
                <div class="progress-bar-fill" style="width:${pct}%;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <c:if test="${not empty pendingDraft}">
        <div class="alert alert-warning rounded-4 mb-4" style="border:1px solid #fde68a;">
          <div class="fw-bold mb-1"><i class="bi bi-arrow-repeat me-1"></i> Pending re-verification changes</div>
          <strong>Status:</strong> ${pendingDraft.status}<br/>
          <c:if test="${not empty pendingDraft.adminNotes}"><strong>Admin notes:</strong> ${pendingDraft.adminNotes}<br/></c:if>
          <c:if test="${not empty pendingDraft.submittedAt}"><strong>Submitted:</strong> ${pendingDraft.submittedAt}<br/></c:if>
          <div class="mt-2 small text-muted">Live approved profile is preserved until these changes are approved.</div>
        </div>
      </c:if>

      <!-- 2. Personal Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-person-badge-fill"></i>
          <h3>1. Personal Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Full name</span>
            <span class="info-field-value">${not empty displayName ? displayName : ''}</span>
            <c:if test="${empty displayName}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Email</span>
            <span class="info-field-value">${not empty displayEmail ? displayEmail : ''}</span>
            <c:if test="${empty displayEmail}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Phone</span>
            <span class="info-field-value">${not empty displayPhone ? displayPhone : ''}</span>
            <c:if test="${empty displayPhone}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Gender</span>
            <c:choose>
              <c:when test="${not empty doctor.gender}"><span class="info-field-value">${doctor.gender}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 3. Professional Information -->
      <c:set var="specialization" value="${not empty doctor.specialization ? doctor.specialization : pp.specialization}"/>
      <c:set var="qualification" value="${not empty doctor.qualification ? doctor.qualification : pp.qualification}"/>
      <c:set var="medicalRegNumber" value="${not empty doctor.medicalRegNumber ? doctor.medicalRegNumber : pp.medicalRegNumber}"/>
      <c:set var="experienceYears" value="${doctor.experienceYears != null ? doctor.experienceYears : pp.experienceYears}"/>
      <c:set var="bioVal" value="${not empty doctor.bio ? doctor.bio : pp.bio}"/>
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-briefcase-fill"></i>
          <h3>2. Professional Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Specialization</span>
            <c:choose>
              <c:when test="${not empty specialization}"><span class="info-field-value">${specialization}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Qualification</span>
            <c:choose>
              <c:when test="${not empty qualification}"><span class="info-field-value">${qualification}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Medical registration number</span>
            <c:choose>
              <c:when test="${not empty medicalRegNumber}"><span class="info-field-value">${medicalRegNumber}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Experience</span>
            <c:choose>
              <c:when test="${experienceYears != null}"><span class="info-field-value">${experienceYears} years</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Languages</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty pp.languages}">
                  <c:forEach var="lang" items="${pp.languages}">
                    <span class="tag-pill">${lang}</span>
                  </c:forEach>
                </c:when>
                <c:when test="${not empty doctor.languages}">
                  <c:forEach var="lang" items="${fn:split(doctor.languages, ',')}">
                    <span class="tag-pill">${fn:trim(lang)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Services</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty pp.services}">
                  <c:forEach var="svc" items="${pp.services}">
                    <span class="tag-pill">${svc}</span>
                  </c:forEach>
                </c:when>
                <c:when test="${not empty doctor.services}">
                  <c:forEach var="svc" items="${fn:split(doctor.services, ',')}">
                    <span class="tag-pill">${fn:trim(svc)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Bio</span>
            <div class="bio-box mt-1">
              <c:choose>
                <c:when test="${not empty bioVal}">${bioVal}</c:when>
                <c:otherwise><span class="empty-text">No bio provided.</span></c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- 4. Practice / Address -->
      <c:set var="hospitalName" value="${not empty doctor.hospitalName ? doctor.hospitalName : pp.hospitalName}"/>
      <c:set var="clinicAddress" value="${not empty doctor.clinicAddress ? doctor.clinicAddress : pp.clinicAddress}"/>
      <c:set var="cityVal" value="${not empty doctor.city ? doctor.city : pp.city}"/>
      <c:set var="stateVal" value="${not empty doctor.state ? doctor.state : pp.state}"/>
      <c:set var="pincodeVal" value="${not empty doctor.pincode ? doctor.pincode : pp.pincode}"/>
      <c:set var="mapVal" value="${not empty doctor.googleMapLocation ? doctor.googleMapLocation : pp.googleMapLocation}"/>
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-geo-alt-fill"></i>
          <h3>3. Practice / Address</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Hospital / clinic</span>
            <c:choose>
              <c:when test="${not empty hospitalName}"><span class="info-field-value">${hospitalName}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Clinic address</span>
            <c:choose>
              <c:when test="${not empty clinicAddress}"><span class="info-field-value">${clinicAddress}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">City</span>
            <c:choose>
              <c:when test="${not empty cityVal}"><span class="info-field-value">${cityVal}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">State</span>
            <c:choose>
              <c:when test="${not empty stateVal}"><span class="info-field-value">${stateVal}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Pincode</span>
            <c:choose>
              <c:when test="${not empty pincodeVal}"><span class="info-field-value">${pincodeVal}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Map</span>
            <c:choose>
              <c:when test="${not empty mapVal}">
                <c:choose>
                  <c:when test="${fn:startsWith(mapVal, 'http')}">
                    <a class="doc-link" href="${mapVal}" target="_blank" rel="noopener">
                      <i class="bi bi-box-arrow-up-right me-1"></i> Open map
                    </a>
                  </c:when>
                  <c:otherwise><span class="info-field-value">${mapVal}</span></c:otherwise>
                </c:choose>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 5. Consultation & Availability -->
      <c:set var="daysRaw" value="${not empty doctor.availableDays ? doctor.availableDays : pp.availableDays}"/>
      <c:set var="startTime" value="${not empty doctor.startTime ? doctor.startTime : pp.startTime}"/>
      <c:set var="endTime" value="${not empty doctor.endTime ? doctor.endTime : pp.endTime}"/>
      <c:set var="consultFee" value="${doctor.consultationFee != null ? doctor.consultationFee : pp.consultationFee}"/>
      <c:set var="chatFee" value="${doctor.chatFee != null ? doctor.chatFee : pp.chatFee}"/>
      <c:set var="callFee" value="${doctor.callFee != null ? doctor.callFee : pp.callFee}"/>
      <c:set var="videoFee" value="${doctor.videoFee != null ? doctor.videoFee : pp.videoFee}"/>
      <c:set var="emerg" value="${doctor.emergencyAvailable != null ? doctor.emergencyAvailable : pp.emergencyAvailable}"/>
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clock-fill"></i>
          <h3>4. Consultation &amp; Availability</h3>
        </div>
        <div class="info-grid mb-3">
          <div class="info-field span-all">
            <span class="info-field-label">Consultation modes</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty pp.consultationModes}">
                  <c:forEach var="mode" items="${pp.consultationModes}">
                    <span class="tag-pill">${mode}</span>
                  </c:forEach>
                </c:when>
                <c:when test="${not empty doctor.consultationModes}">
                  <c:forEach var="mode" items="${fn:split(doctor.consultationModes, ',')}">
                    <span class="tag-pill">${fn:trim(mode)}</span>
                  </c:forEach>
                </c:when>
                <c:when test="${not empty doctor.consultationType}">
                  <span class="tag-pill">${doctor.consultationType}</span>
                </c:when>
                <c:when test="${not empty pp.consultationType}">
                  <span class="tag-pill">${pp.consultationType}</span>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Available days</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty daysRaw}">
                  <c:forEach var="day" items="${fn:split(daysRaw, ',')}">
                    <span class="tag-pill">${fn:trim(day)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field">
            <span class="info-field-label">Times</span>
            <c:choose>
              <c:when test="${not empty startTime or not empty endTime}">
                <span class="info-field-value">${startTime} – ${endTime}</span>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Emergency available</span>
            <c:choose>
              <c:when test="${emerg == true}"><span class="badge bg-success">Yes</span></c:when>
              <c:when test="${emerg == false}"><span class="badge bg-secondary">No</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>

        <c:if test="${not empty pp.availabilitySlots}">
          <div class="mb-3">
            <span class="info-field-label d-block mb-2">Availability slots</span>
            <c:forEach var="slot" items="${pp.availabilitySlots}">
              <span class="tag-pill">${slot.day} ${slot.start}–${slot.end}</span>
            </c:forEach>
          </div>
        </c:if>

        <div class="row g-3">
          <div class="col-6 col-md-3">
            <div class="fee-tile">
              <span class="info-field-label">Consultation fee</span>
              <div class="amt mt-1">
                <c:choose>
                  <c:when test="${consultFee != null}">₹<fmt:formatNumber value="${consultFee}" maxFractionDigits="0"/></c:when>
                  <c:otherwise><span class="empty-text">—</span></c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="fee-tile">
              <span class="info-field-label">Chat fee</span>
              <div class="amt mt-1">
                <c:choose>
                  <c:when test="${chatFee != null}">₹<fmt:formatNumber value="${chatFee}" maxFractionDigits="0"/></c:when>
                  <c:otherwise><span class="empty-text">—</span></c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="fee-tile">
              <span class="info-field-label">Call fee</span>
              <div class="amt mt-1">
                <c:choose>
                  <c:when test="${callFee != null}">₹<fmt:formatNumber value="${callFee}" maxFractionDigits="0"/></c:when>
                  <c:otherwise><span class="empty-text">—</span></c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="fee-tile">
              <span class="info-field-label">Video fee</span>
              <div class="amt mt-1">
                <c:choose>
                  <c:when test="${videoFee != null}">₹<fmt:formatNumber value="${videoFee}" maxFractionDigits="0"/></c:when>
                  <c:otherwise><span class="empty-text">—</span></c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 6. Documents -->
      <c:set var="govIdPath" value="${not empty doctor.idProofPath ? doctor.idProofPath : (not empty pp.idProofPath ? pp.idProofPath : (not empty doctor.identityDocumentPath ? doctor.identityDocumentPath : pp.identityDocumentPath))}"/>
      <c:set var="degreePath" value="${not empty pp.degreeCertificatePath ? pp.degreeCertificatePath : doctor.degreeCertificatePath}"/>
      <c:set var="licensePath" value="${not empty doctor.medicalLicensePath ? doctor.medicalLicensePath : pp.medicalLicensePath}"/>
      <c:set var="extraCertPath" value="${not empty doctor.additionalCertificatePath ? doctor.additionalCertificatePath : pp.additionalCertificatePath}"/>
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-earmark-medical-fill"></i>
          <h3>5. Documents</h3>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-person-circle"></i></div>
          <div>
            <div class="info-field-label">Profile photo</div>
            <c:choose>
              <c:when test="${empty photoPath}"><div class="empty-text">Not uploaded</div></c:when>
              <c:when test="${photoPath == 'mobile-pending' or fn:startsWith(photoPath, 'mobile:')}">
                <div class="warn-mobile">Placeholder only — doctor must re-upload from mobile app.</div>
              </c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(photoPath, 'http') ? photoPath : pageContext.request.contextPath.concat(photoPath)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View profile photo
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-person-vcard"></i></div>
          <div>
            <div class="info-field-label">Government ID</div>
            <c:choose>
              <c:when test="${empty govIdPath}"><div class="empty-text">Not uploaded</div></c:when>
              <c:when test="${govIdPath == 'mobile-pending' or fn:startsWith(govIdPath, 'mobile:')}">
                <div class="warn-mobile">Placeholder only — doctor must re-upload from mobile app.</div>
              </c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(govIdPath, 'http') ? govIdPath : pageContext.request.contextPath.concat(govIdPath)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View government ID
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-award"></i></div>
          <div>
            <div class="info-field-label">Medical registration certificate</div>
            <c:choose>
              <c:when test="${empty degreePath}"><div class="empty-text">Not uploaded</div></c:when>
              <c:when test="${degreePath == 'mobile-pending' or fn:startsWith(degreePath, 'mobile:')}">
                <div class="warn-mobile">Placeholder only — doctor must re-upload from mobile app.</div>
              </c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(degreePath, 'http') ? degreePath : pageContext.request.contextPath.concat(degreePath)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View registration certificate
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div>
            <div class="info-field-label">Medical license</div>
            <c:choose>
              <c:when test="${empty licensePath}"><div class="empty-text">Not uploaded</div></c:when>
              <c:when test="${licensePath == 'mobile-pending' or fn:startsWith(licensePath, 'mobile:')}">
                <div class="warn-mobile">Placeholder only — doctor must re-upload from mobile app.</div>
              </c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(licensePath, 'http') ? licensePath : pageContext.request.contextPath.concat(licensePath)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View medical license
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-paperclip"></i></div>
          <div>
            <div class="info-field-label">Additional certificates</div>
            <c:choose>
              <c:when test="${empty extraCertPath}"><div class="empty-text">Not uploaded</div></c:when>
              <c:when test="${extraCertPath == 'mobile-pending' or fn:startsWith(extraCertPath, 'mobile:')}">
                <div class="warn-mobile">Placeholder only — doctor must re-upload from mobile app.</div>
              </c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(extraCertPath, 'http') ? extraCertPath : pageContext.request.contextPath.concat(extraCertPath)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View additional certificate
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 7. Application / Audit -->
      <c:set var="rejectNote" value="${not empty doctor.rejectionReason ? doctor.rejectionReason : pp.rejectionReason}"/>
      <c:set var="changesNote" value="${not empty doctor.changesRequestedNote ? doctor.changesRequestedNote : pp.changesRequestedNote}"/>
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clipboard-check-fill"></i>
          <h3>6. Application / Audit</h3>
        </div>
        <div class="info-grid mb-3">
          <div class="info-field">
            <span class="info-field-label">Status</span>
            <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Submitted for verification</span>
            <c:choose>
              <c:when test="${doctor.submittedForVerificationAt != null}">
                <span class="info-field-value">${doctor.submittedForVerificationAt}</span>
              </c:when>
              <c:otherwise><span class="empty-text">Not recorded</span></c:otherwise>
            </c:choose>
          </div>
        </div>

        <c:if test="${not empty rejectNote}">
          <div class="alert alert-danger rounded-3">
            <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection reason:</strong>
            <div class="mt-1">${rejectNote}</div>
          </div>
        </c:if>
        <c:if test="${not empty changesNote}">
          <div class="alert alert-warning rounded-3">
            <strong><i class="bi bi-pencil-square me-1"></i> Changes requested:</strong>
            <div class="mt-1">${changesNote}</div>
          </div>
        </c:if>

        <div class="section-header mt-2 mb-2" style="border-bottom:none;padding-bottom:0;">
          <i class="bi bi-clock-history"></i>
          <h3>Verification history</h3>
        </div>
        <c:choose>
          <c:when test="${not empty history}">
            <div class="table-responsive">
              <table class="table table-sm align-middle history-table mb-0">
                <thead>
                  <tr>
                    <th>When</th>
                    <th>Action</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Notes</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="h" items="${history}">
                    <tr>
                      <td>${h.createdAt}</td>
                      <td>${h.action}</td>
                      <td>${h.fromStatusLabel}</td>
                      <td>${h.toStatusLabel}</td>
                      <td>
                        <c:if test="${not empty h.reasons}"><div><strong>Reasons:</strong> ${h.reasons}</div></c:if>
                        <c:if test="${not empty h.notes}">${h.notes}</c:if>
                        <c:if test="${empty h.notes && empty h.reasons}">—</c:if>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-text">No verification history yet.</div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 8. Admin Decision -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-gavel"></i>
          <h3>7. Admin Decision</h3>
        </div>
        <div class="mb-3">
          <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
          <c:if test="${not empty doctor.changesRequestedNote}">
            <div class="mt-2 text-warning small"><strong>Changes requested:</strong> ${doctor.changesRequestedNote}</div>
          </c:if>
          <c:if test="${not empty doctor.rejectionReason}">
            <div class="mt-2 text-danger small"><strong>Rejection reason:</strong> ${doctor.rejectionReason}</div>
          </c:if>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Decision notes / comments</label>
          <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the doctor (required for reject / request changes)"></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Request-change reasons (optional checkboxes)</label>
          <div class="d-flex flex-wrap gap-2 reason-checks">
            <label><input type="checkbox" class="reason-box" value="Professional information"> Professional information</label>
            <label><input type="checkbox" class="reason-box" value="Clinic details"> Clinic details</label>
            <label><input type="checkbox" class="reason-box" value="Documents"> Documents</label>
            <label><input type="checkbox" class="reason-box" value="Availability"> Availability</label>
            <label><input type="checkbox" class="reason-box" value="Fees"> Fees</label>
          </div>
        </div>

        <div class="action-bar">
          <form id="approveForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/verify" method="post" class="m-0 p-0">
            <input type="hidden" name="notes" id="approveNotes">
            <button type="submit" class="btn-verify" onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-check-circle"></i> Approve
            </button>
          </form>

          <form id="changesForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/request-changes" method="post" class="m-0 p-0">
            <input type="hidden" name="notes" id="changesNotes">
            <input type="hidden" name="reasons" id="changesReasons">
            <button type="submit" class="btn-changes"
                    onclick="
                      document.getElementById('changesNotes').value=document.getElementById('decisionNotes').value;
                      document.getElementById('changesReasons').value=Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                    ">
              <i class="fas fa-edit"></i> Request Changes
            </button>
          </form>

          <form id="rejectForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/reject" method="post" class="m-0 p-0"
                onsubmit="return confirm('Reject this doctor?')">
            <input type="hidden" name="notes" id="rejectNotes">
            <button type="submit" class="btn-reject"
                    onclick="document.getElementById('rejectNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-times-circle"></i> Reject
            </button>
          </form>
        </div>
      </div>

    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
