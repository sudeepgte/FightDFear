<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty doctor.fullName ? doctor.fullName : 'Doctor'} — Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary: #F43F5E;
    --rose-soft: #FFF1F2;
    --bg: #F8FAFC;
    --navy: #0F172A;
    --navy-mid: #1E293B;
    --border: #E2E8F0;
    --text-muted: #64748B;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    background: var(--bg);
    color: var(--navy-mid);
  }

  .topbar {
    background: var(--navy);
    color: #fff;
    padding: 0 20px;
    height: 58px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 1000;
    border-bottom: 1px solid rgba(255,255,255,0.08);
  }
  .topbar .brand {
    color: #fff;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 1.05rem;
    font-weight: 700;
    font-family: 'Outfit', sans-serif;
  }
  .topbar .brand img {
    height: 32px;
    width: 32px;
    border-radius: 8px;
    object-fit: cover;
  }
  .topbar .btn-logout {
    background: rgba(255,255,255,0.12);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.28);
    border-radius: 8px;
    padding: 6px 14px;
    font-size: 0.85rem;
    font-weight: 600;
    text-decoration: none;
  }
  .mobile-toggle {
    display: none;
    background: none;
    border: none;
    color: #fff;
    font-size: 1.2rem;
    cursor: pointer;
    padding: 6px;
    margin-right: 8px;
  }

  .layout { display: flex; min-height: calc(100vh - 58px); }
  .sidebar {
    width: var(--sidebar-w);
    background: #fff;
    border-right: 1px solid var(--border);
    position: sticky;
    top: 58px;
    height: calc(100vh - 58px);
    padding: 14px 12px;
    overflow-y: auto;
    flex-shrink: 0;
  }
  .sidebar .brand {
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--navy);
    padding: 10px 15px;
    text-transform: uppercase;
    letter-spacing: 1px;
  }
  .sidebar .sectionTitle {
    font-size: 0.7rem;
    font-weight: 700;
    color: #94a3b8;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin: 20px 15px 8px;
  }
  .sidebar .navlink {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 15px;
    border-radius: 12px;
    color: #4b5563;
    text-decoration: none;
    font-weight: 500;
    font-size: 0.9rem;
    margin-bottom: 2px;
  }
  .sidebar .navlink i { width: 20px; text-align: center; color: var(--primary); }
  .sidebar .navlink:hover { background: var(--rose-soft); color: var(--navy); }
  .sidebar .navlink.active {
    background: var(--primary);
    color: #fff;
    font-weight: 600;
  }
  .sidebar .navlink.active i { color: #fff; }

  .main { flex: 1; min-width: 0; padding: 24px 20px 56px; }
  .mainInner { max-width: 1100px; margin: 0 auto; }

  .back-nav {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: var(--text-muted);
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    margin-bottom: 16px;
  }
  .back-nav:hover { color: var(--primary); }

  .header-card {
    background: linear-gradient(135deg, var(--navy) 0%, var(--navy-mid) 100%);
    border-radius: 20px;
    padding: 28px;
    color: #fff;
    margin-bottom: 22px;
    position: relative;
    overflow: hidden;
  }
  .header-card::after {
    content: '';
    position: absolute;
    right: -50px;
    top: -50px;
    width: 200px;
    height: 200px;
    background: rgba(244, 63, 94, 0.16);
    border-radius: 50%;
    pointer-events: none;
  }
  .avatar-box {
    width: 112px;
    height: 112px;
    border-radius: 20px;
    border: 4px solid rgba(255,255,255,0.22);
    overflow: hidden;
    background: #fff;
    flex-shrink: 0;
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .header-card h1 {
    font-family: 'Outfit', sans-serif;
    font-size: 1.55rem;
    font-weight: 800;
    margin: 0;
    color: #fff;
  }
  .progress-wrap {
    background: rgba(255,255,255,0.16);
    border-radius: 50px;
    height: 10px;
    overflow: hidden;
    margin-top: 8px;
  }
  .progress-bar-fill {
    background: linear-gradient(90deg, var(--primary), #fb7185);
    height: 100%;
    border-radius: 50px;
  }

  .badge-status-lg {
    padding: 6px 14px;
    border-radius: 50px;
    font-size: 0.78rem;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    letter-spacing: 0.3px;
  }
  .status-APPROVED, .status-VERIFIED { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
  .status-READY_FOR_VERIFICATION { background: #e0f2fe; color: #075985; border: 1px solid #bae6fd; }
  .status-CHANGES_REQUESTED { background: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
  .status-REJECTED, .status-SUSPENDED { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

  .review-card {
    background: #fff;
    border-radius: 16px;
    border: 1px solid var(--border);
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
    padding: 22px 26px;
    margin-bottom: 20px;
  }
  .section-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 18px;
    padding-bottom: 12px;
    border-bottom: 1px solid var(--border);
  }
  .section-header i { color: var(--primary); font-size: 1.2rem; }
  .section-header h3 {
    font-family: 'Outfit', sans-serif;
    font-size: 1.08rem;
    font-weight: 700;
    color: var(--navy);
    margin: 0;
  }

  .info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 16px;
  }
  .info-field { display: flex; flex-direction: column; gap: 4px; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    font-size: 0.74rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.55px;
    color: var(--text-muted);
  }
  .info-field-value {
    font-size: 0.95rem;
    font-weight: 600;
    color: var(--navy-mid);
    word-break: break-word;
  }
  .empty-text { color: var(--text-muted); font-style: italic; font-weight: 500; font-size: 0.9rem; }
  .bio-box {
    background: var(--rose-soft);
    border: 1px solid #fecdd3;
    border-radius: 12px;
    padding: 14px 16px;
    font-size: 0.94rem;
    line-height: 1.65;
    color: var(--navy-mid);
  }
  .tag-pill {
    display: inline-block;
    background: var(--rose-soft);
    color: #9f1239;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
    margin: 0 6px 6px 0;
    border: 1px solid #fecdd3;
  }
  .fee-tile {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 14px 16px;
  }
  .fee-tile .amt { font-size: 1.2rem; font-weight: 800; color: var(--navy); font-family: 'Outfit', sans-serif; }

  .doc-row {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 16px;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: #fff;
    margin-bottom: 10px;
  }
  .doc-icon {
    width: 46px;
    height: 46px;
    border-radius: 10px;
    background: var(--rose-soft);
    color: var(--primary);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    flex-shrink: 0;
  }
  .doc-link { color: var(--primary); font-weight: 700; text-decoration: none; }
  .doc-link:hover { text-decoration: underline; }
  .warn-mobile {
    color: #b45309;
    font-size: 0.8rem;
    font-weight: 600;
    margin-top: 4px;
  }

  .history-table { font-size: 0.88rem; }
  .history-table th {
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: var(--text-muted);
    font-weight: 700;
  }

  .reason-checks label {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 999px;
    padding: 6px 12px;
    font-size: 0.82rem;
    font-weight: 600;
  }
  .reason-checks input { accent-color: var(--primary); }

  .action-bar {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    flex-wrap: wrap;
    padding-top: 18px;
    border-top: 1px solid var(--border);
  }
  .btn-verify {
    background: #059669;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 12px 24px;
    font-size: 0.95rem;
    font-weight: 700;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }
  .btn-verify:hover { background: #047857; color: #fff; }
  .btn-reject {
    background: #dc2626;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 12px 24px;
    font-size: 0.95rem;
    font-weight: 700;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }
  .btn-reject:hover { background: #b91c1c; color: #fff; }

  .sidebar-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    z-index: 1500;
  }
  .sidebar-overlay.active { display: block; }

  @media (max-width: 992px) {
    .mobile-toggle { display: block; }
    .layout { flex-direction: column; }
    .sidebar {
      position: fixed;
      left: -100%;
      top: 0;
      z-index: 2000;
      width: 280px;
      height: 100vh;
      transition: left 0.3s ease;
      box-shadow: 10px 0 30px rgba(0,0,0,0.18);
    }
    .sidebar.active { left: 0; }
  }
  @media (max-width: 768px) {
    .main { padding: 16px 12px 40px; }
    .header-card { padding: 20px 16px; }
    .review-card { padding: 18px 14px; }
    .info-grid { grid-template-columns: 1fr; }
    .doc-row { align-items: flex-start; }
    .action-bar { justify-content: stretch; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .action-bar .btn { width: 100%; justify-content: center; }
    .avatar-box { width: 88px; height: 88px; }
  }
</style>
</head>
<body>

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

<div class="topbar">
  <div class="d-flex align-items-center">
    <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu">
      <i class="fas fa-bars"></i>
    </button>
    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
      <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
      <span>Fight D Fear Admin</span>
    </a>
  </div>
  <div class="d-flex align-items-center gap-2">
    <span class="badge bg-light text-dark fw-bold px-3 py-2 d-none d-sm-inline">Doctor Review</span>
    <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">

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
            <div class="d-flex flex-wrap gap-3 gap-md-4 text-white-50 small mb-3">
              <div>
                <i class="bi bi-envelope-fill text-white"></i>
                <c:choose>
                  <c:when test="${not empty displayEmail}"><a href="mailto:${displayEmail}" class="text-white text-decoration-none">${displayEmail}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill text-white"></i>
                <c:choose>
                  <c:when test="${not empty displayPhone}"><a href="tel:${displayPhone}" class="text-white text-decoration-none">${displayPhone}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
            </div>
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold text-white mb-1">
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
            <button type="submit" class="btn btn-warning text-dark fw-semibold"
                    style="border-radius:10px;padding:12px 28px;"
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
