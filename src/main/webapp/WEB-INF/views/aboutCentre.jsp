<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty center.name ? center.name : 'Martial Arts Centre'} — Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  :root {
    /* 10% ACCENT */
    --ap-accent: #F43F5E;
    --ap-accent-hover: #E11D48;
    --ap-accent-soft: #FFF1F2;
    --ap-accent-surface: #FFF5F6;
    --ap-accent-border: #FECDD3;
    --ap-accent-text: #BE123C;

    /* 60% PRIMARY SURFACE */
    --ap-bg: #F8FAFC;
    --ap-card: #FFFFFF;

    /* 30% SECONDARY STRUCTURE */
    --ap-border: #E2E8F0;
    --ap-border-subtle: #F1F5F9;

    /* TEXT */
    --ap-text: #0F172A;
    --ap-navy: #0F172A;
    --ap-navy-mid: #1E293B;
    --ap-muted: #64748B;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body.ap-page {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    background: var(--ap-bg);
    color: var(--ap-text);
  }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  .review-container { max-width: 1100px; margin: 0 auto; padding: 22px 24px 60px; }

  /* NAVIGATION & CRUMB */
  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    font-weight: 600; font-size: 0.88rem; text-decoration: none; margin-bottom: 16px;
    transition: color 0.2s;
  }
  .back-nav:hover { color: var(--ap-accent); }

  /* 60/30/10 HERO PROFILE HEADER CARD */
  .hero-profile-card {
    background: #FFFFFF;
    border: 1px solid var(--ap-accent-border);
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 22px;
    box-shadow: 0 4px 20px rgba(244, 63, 94, 0.06);
    position: relative;
    overflow: hidden;
  }
  .hero-profile-card::after {
    content: ''; position: absolute; right: -40px; top: -40px;
    width: 180px; height: 180px; background: rgba(244, 63, 94, 0.05);
    border-radius: 50%; pointer-events: none;
  }

  .avatar-box {
    width: 112px; height: 112px; border-radius: 20px;
    border: 3px solid var(--ap-accent-border); overflow: hidden;
    background: var(--ap-accent-soft); flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .hero-profile-card h1 {
    font-family: 'Outfit', sans-serif; font-size: 1.6rem; font-weight: 800;
    margin: 0; color: var(--ap-navy);
  }

  .progress-wrap {
    background: var(--ap-accent-soft);
    border-radius: 50px; height: 10px; overflow: hidden; margin-top: 6px;
    border: 1px solid var(--ap-accent-border);
  }
  .progress-bar-fill {
    background: linear-gradient(90deg, #F43F5E, #FB7185);
    height: 100%; border-radius: 50px;
    transition: width 0.4s ease;
  }

  /* BADGES & STATUS PILLS */
  .badge-status-lg {
    padding: 6px 14px; border-radius: 50px; font-size: 0.78rem; font-weight: 700;
    display: inline-flex; align-items: center; gap: 6px;
  }
  .status-APPROVED, .status-VERIFIED { background: #DCFCE7; color: #166534; border: 1px solid #BBF7D0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A; }
  .status-READY_FOR_VERIFICATION { background: var(--ap-accent-soft); color: var(--ap-accent-text); border: 1px solid var(--ap-accent-border); }
  .status-CHANGES_REQUESTED { background: #FFEDD5; color: #9A3412; border: 1px solid #FED7AA; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; }
  .status-REJECTED, .status-SUSPENDED { background: #FEE2E2; color: #991B1B; border: 1px solid #FECACA; }

  /* STRUCTURED REVIEW CARDS (60% Card Surface, 30% Structure) */
  .review-card {
    background: #FFFFFF; border-radius: 16px; border: 1px solid var(--ap-border);
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04); padding: 22px 26px; margin-bottom: 20px;
  }
  .section-header {
    display: flex; align-items: center; gap: 12px; margin-bottom: 18px;
    padding-bottom: 12px; border-bottom: 1px solid var(--ap-border);
  }
  .section-header i {
    width: 36px; height: 36px; border-radius: 10px; background: var(--ap-accent-soft);
    color: var(--ap-accent); font-size: 1.15rem; display: inline-flex;
    align-items: center; justify-content: center; flex-shrink: 0;
  }
  .section-header h3 {
    font-family: 'Outfit', sans-serif; font-size: 1.08rem; font-weight: 700;
    color: var(--ap-navy); margin: 0;
  }

  /* INFO GRID */
  .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
  .info-field { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    font-size: 0.74rem; font-weight: 700; text-transform: uppercase;
    letter-spacing: 0.55px; color: var(--ap-muted);
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-navy-mid); word-break: break-word; }
  .empty-text { color: var(--ap-muted); font-style: italic; font-weight: 500; font-size: 0.88rem; }

  /* 30% SECONDARY STRUCTURE ELEMENTS */
  .bio-box {
    background: var(--ap-accent-surface); border: 1px solid var(--ap-accent-border); border-radius: 12px;
    padding: 14px 16px; font-size: 0.94rem; line-height: 1.65; color: var(--ap-navy-mid);
  }
  .tag-pill {
    display: inline-flex; align-items: center; background: var(--ap-accent-soft); color: var(--ap-accent-text);
    padding: 5px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;
    margin: 0 6px 6px 0; border: 1px solid var(--ap-accent-border);
  }
  .tag-pill.neutral {
    background: #F8FAFC; color: #475569; border-color: var(--ap-border);
  }
  .tag-pill.success {
    background: #DCFCE7; color: #166534; border-color: #BBF7D0;
  }

  .doc-row {
    display: flex; align-items: center; gap: 14px; padding: 14px 16px;
    border: 1px solid var(--ap-accent-border); border-radius: 12px; background: var(--ap-accent-surface); margin-bottom: 10px;
  }
  .doc-icon {
    width: 46px; height: 46px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0;
  }
  .doc-link { color: var(--ap-accent); font-weight: 700; text-decoration: none; }
  .doc-link:hover { text-decoration: underline; color: var(--ap-accent-hover); }

  .batch-row {
    display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap;
    padding: 14px 16px; border: 1px solid var(--ap-border); border-radius: 12px; margin-bottom: 10px; background: #FAFAFC;
  }
  .batch-row:last-child { margin-bottom: 0; }

  .gallery-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px;
  }
  .gallery-item {
    aspect-ratio: 1; border-radius: 12px; overflow: hidden; border: 1px solid var(--ap-border); cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  .gallery-item:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.08); border-color: var(--ap-accent-border); }
  .gallery-item img { width: 100%; height: 100%; object-fit: cover; }

  /* REASON CHECKS */
  .reason-checks label {
    display: inline-flex; align-items: center; gap: 6px; background: #F8FAFC;
    border: 1px solid var(--ap-border); border-radius: 999px; padding: 6px 14px; font-size: 0.82rem; font-weight: 600;
    cursor: pointer; transition: all 0.2s; color: var(--ap-navy-mid);
  }
  .reason-checks label:hover { background: var(--ap-accent-soft); border-color: var(--ap-accent-border); color: var(--ap-accent-text); }
  .reason-checks input { accent-color: var(--ap-accent); }

  /* ACTION BUTTONS */
  .action-bar {
    display: flex; justify-content: flex-end; gap: 10px; flex-wrap: wrap;
    padding-top: 18px; border-top: 1px solid var(--ap-border);
  }
  .btn-verify {
    background: #059669; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-verify:hover { background: #047857; color: #fff; }
  .btn-changes {
    background: #F59E0B; color: #1F2937; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-changes:hover { background: #D97706; color: #1F2937; }
  .btn-reject {
    background: #DC2626; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-reject:hover { background: #B91C1C; color: #fff; }
  .btn-delete-acc {
    background: #FFFFFF; color: #DC2626; border: 1.5px solid #DC2626; border-radius: 10px;
    padding: 10px 18px; font-size: 0.88rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s;
  }
  .btn-delete-acc:hover { background: #FEE2E2; color: #991B1B; }

  .missing-list { margin: 0; padding-left: 1.15rem; color: var(--ap-muted); font-size: 0.9rem; }
  .missing-list li { margin-bottom: 4px; }

  @media (max-width: 992px) {
    .mobile-toggle { display: block; }
    .layout { flex-direction: column; }
    .sidebar {
      position: fixed; left: -100%; top: 0; z-index: 2000; width: 280px; height: 100vh;
      transition: left 0.3s ease; box-shadow: 10px 0 30px rgba(0,0,0,0.18);
    }
    .sidebar.active { left: 0; }
  }
  @media (max-width: 768px) {
    .review-container { padding: 16px 14px 40px; }
    .hero-profile-card { padding: 20px 16px; }
    .review-card { padding: 18px 14px; }
    .info-grid { grid-template-columns: 1fr; }
    .action-bar { justify-content: stretch; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .btn-changes { width: 100%; justify-content: center; }
    .avatar-box { width: 88px; height: 88px; }
  }
</style>
</head>
<body class="ap-page">

<c:set var="isAdmin" value="${not empty sessionScope.admin}"/>
<c:set var="statusKey" value="${center.centreProfileStatus != null ? center.centreProfileStatus : (center.approved ? 'APPROVED' : 'PENDING_ADMIN_APPROVAL')}"/>
<c:set var="displayStatus" value="${not empty statusLabel ? statusLabel : statusKey}"/>
<c:set var="pct" value="${pct != null ? pct : (center.profileCompletionPct != null ? center.profileCompletionPct : 0)}"/>
<c:set var="logoPath" value="${center.profilePhoto}"/>
<c:set var="logoOk" value="${not empty logoPath and logoPath != 'mobile-pending' and not fn:startsWith(logoPath, 'mobile:')}"/>

<c:choose>
  <c:when test="${isAdmin}">
    <div class="layout">
      <%@ include file="globalAdminMenu.jsp" %>
      <main class="main">
        <div class="ap-topbar">
          <div class="ap-topbar-left">
            <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
            <div class="ap-search" style="max-width:360px;">
              <i class="fas fa-search"></i>
              <input type="search" placeholder="Search anything..." aria-label="Search" readonly
                     onclick="window.location.href='${pageContext.request.contextPath}/admin/martialManagement'">
              <span class="ap-kbd">Ctrl + K</span>
            </div>
          </div>
          <div style="display:flex;align-items:center;gap:10px;">
            <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
              <i class="fas fa-bell"></i>
              <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
            </a>
            <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
              <span class="ap-avatar">
                <c:choose>
                  <c:when test="${not empty admin.profilePhoto}">
                    <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
                  </c:when>
                  <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
                </c:choose>
              </span>
              <span>
                <div class="name"><c:out value="${admin.name}"/></div>
                <div class="role">Super Admin</div>
              </span>
            </a>
          </div>
        </div>

        <div class="review-container">
          <nav class="ap-crumb">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
            <span class="sep">&gt;</span>
            <a href="${pageContext.request.contextPath}/admin/martialManagement">Martial Arts Centres</a>
            <span class="sep">&gt;</span>
            <span>Review Profile</span>
          </nav>
          <a href="${pageContext.request.contextPath}/admin/martialManagement" class="back-nav">
            <i class="bi bi-arrow-left"></i> Back to Martial Arts Centres Management
          </a>
  </c:when>
  <c:otherwise>
    <div class="review-container" style="padding-top: 32px;">
      <a href="${pageContext.request.contextPath}/centres/dashboard" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Centre Dashboard
      </a>
  </c:otherwise>
</c:choose>

      <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show mb-3 rounded-4 shadow-sm" role="alert">
          <i class="bi bi-check-circle-fill me-2"></i> ${message}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-3 rounded-4 shadow-sm" role="alert">
          <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>

      <!-- 60/30/10 HERO PROFILE HEADER CARD -->
      <div class="hero-profile-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
            <c:choose>
              <c:when test="${logoOk}">
                <img src="${fn:startsWith(logoPath, 'http') ? logoPath : pageContext.request.contextPath.concat(logoPath)}"
                     alt="${center.name}"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <div style="display:none; width:100%; height:100%; align-items:center; justify-content:center;">
                  <i class="bi bi-shield-shaded" style="font-size:2.6rem; color:var(--ap-accent);"></i>
                </div>
              </c:when>
              <c:otherwise>
                <i class="bi bi-shield-shaded" style="font-size:2.6rem; color:var(--ap-accent);"></i>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="flex-grow-1" style="position:relative; z-index:1;">
            <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
              <h1>${not empty center.name ? center.name : 'Unnamed Martial Arts Centre'}</h1>
              <span class="badge-status-lg status-${statusKey}">
                <i class="bi ${center.approved ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                ${displayStatus}
              </span>
            </div>

            <div class="d-flex flex-wrap gap-3 gap-md-4 small mb-3" style="color:var(--ap-muted);">
              <div>
                <i class="bi bi-person-badge-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty center.contactPerson}"><span class="fw-semibold" style="color:var(--ap-navy-mid);">${center.contactPerson}</span></c:when>
                  <c:otherwise>Owner not specified</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty center.email}"><a href="mailto:${center.email}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);">${center.email}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty center.phoneNumber}"><a href="tel:${center.phoneNumber}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);">${center.phoneNumber}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-geo-alt-fill me-1" style="color:var(--ap-accent);"></i>
                <span class="fw-semibold" style="color:var(--ap-navy-mid);">${not empty center.city ? center.city : center.location}</span>
              </div>
            </div>

            <!-- Profile Completion Meter -->
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold mb-1" style="color:var(--ap-navy-mid);">
                <span>Profile Completion</span>
                <span style="color:var(--ap-accent); font-weight:800;">${pct}%</span>
              </div>
              <div class="progress-wrap">
                <div class="progress-bar-fill" style="width:${pct}%;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 1. CENTRE IDENTITY & CONTACT INFORMATION -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-building-fill-check"></i>
          <h3>1. Centre Identity & Contact Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Official Centre Name</span>
            <c:choose><c:when test="${not empty center.name}"><span class="info-field-value">${center.name}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Centre Classification</span>
            <c:choose><c:when test="${not empty center.centreType}"><span class="info-field-value">${center.centreType}</span></c:when><c:otherwise><span class="empty-text">Not specified</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Owner / Head Instructor</span>
            <c:choose><c:when test="${not empty center.contactPerson}"><span class="info-field-value">${center.contactPerson}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Instructor Designation</span>
            <c:choose><c:when test="${not empty center.designation}"><span class="info-field-value">${center.designation}</span></c:when><c:otherwise><span class="empty-text">Head Coach</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Primary Contact Phone</span>
            <c:choose><c:when test="${not empty center.phoneNumber}"><span class="info-field-value">${center.phoneNumber}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">WhatsApp Helpline</span>
            <c:choose><c:when test="${not empty center.whatsappNumber}"><span class="info-field-value">${center.whatsappNumber}</span></c:when><c:otherwise><span class="empty-text">Same as primary</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Official Email</span>
            <c:choose><c:when test="${not empty center.email}"><span class="info-field-value">${center.email}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Established Year</span>
            <c:choose><c:when test="${center.yearStarted != null}"><span class="info-field-value">${center.yearStarted}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Federation Affiliation</span>
            <c:choose><c:when test="${not empty center.affiliation}"><span class="info-field-value">${center.affiliation}</span></c:when><c:otherwise><span class="empty-text">Independent / Unaffiliated</span></c:otherwise></c:choose>
          </div>
        </div>
      </div>

      <!-- 2. PHYSICAL LOCATION & PREMISES -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-geo-alt-fill"></i>
          <h3>2. Physical Location & Dojo Address</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Hall / Landmark / Street Address</span>
            <span class="info-field-value">${not empty center.area ? center.area : (not empty center.location ? center.location : '<span class="empty-text">Not provided</span>')}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">City</span>
            <c:choose><c:when test="${not empty center.city}"><span class="info-field-value">${center.city}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">State</span>
            <c:choose><c:when test="${not empty center.state}"><span class="info-field-value">${center.state}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Postal Pincode</span>
            <c:choose><c:when test="${not empty center.pincode}"><span class="info-field-value">${center.pincode}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Google Maps Link / Coordinates</span>
            <c:choose>
              <c:when test="${not empty center.googleMapLocation}">
                <div><a href="${center.googleMapLocation}" target="_blank" class="doc-link"><i class="bi bi-map-fill me-1"></i> Open in Google Maps</a></div>
              </c:when>
              <c:when test="${center.centreLat != null && center.centreLng != null}">
                <span class="info-field-value">${center.centreLat}, ${center.centreLng}</span>
              </c:when>
              <c:otherwise><span class="empty-text">No GPS coordinates pinned</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 3. ABOUT CENTRE & TEACHING METHODOLOGY -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-text-fill"></i>
          <h3>3. About Centre & Training Methodology</h3>
        </div>
        <div class="d-flex flex-column gap-3">
          <div>
            <span class="info-field-label d-block mb-1">About the Centre</span>
            <div class="bio-box">
              <c:choose>
                <c:when test="${not empty center.about}"><c:out value="${center.about}"/></c:when>
                <c:otherwise><span class="empty-text">No description provided yet.</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div>
            <span class="info-field-label d-block mb-1">How We Teach (Training Methodology)</span>
            <div class="bio-box">
              <c:choose>
                <c:when test="${not empty center.howWeTeach}"><c:out value="${center.howWeTeach}"/></c:when>
                <c:otherwise><span class="empty-text">No teaching methodology specified.</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div>
            <span class="info-field-label d-block mb-1">What We Offer & Syllabus Scope</span>
            <div class="bio-box">
              <c:choose>
                <c:when test="${not empty center.whatWeOffer}"><c:out value="${center.whatWeOffer}"/></c:when>
                <c:otherwise><span class="empty-text">No details specified.</span></c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- 4. MARTIAL ARTS DISCIPLINES & AUDIENCE -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-trophy-fill"></i>
          <h3>4. Martial Arts Styles, Audience & Women Safety</h3>
        </div>
        <div class="info-grid mb-3">
          <div class="info-field span-all">
            <span class="info-field-label mb-1">Martial Arts Styles Taught</span>
            <div>
              <c:choose>
                <c:when test="${not empty center.stylesTaught}">
                  <c:forEach var="s" items="${fn:split(center.stylesTaught, ',')}">
                    <span class="tag-pill"><i class="bi bi-lightning-charge-fill me-1"></i>${fn:trim(s)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">No styles tagged</span></c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="info-field span-all">
            <span class="info-field-label mb-1">Target Audience</span>
            <div>
              <c:choose>
                <c:when test="${not empty center.audience}">
                  <c:forEach var="a" items="${fn:split(center.audience, ',')}">
                    <span class="tag-pill neutral">${fn:trim(a)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">All age groups</span></c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="info-field">
            <span class="info-field-label">Women-Only Batches</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${center.womenOnlyBatches}">
                  <span class="tag-pill success"><i class="bi bi-check-circle-fill me-1"></i> Available</span>
                </c:when>
                <c:otherwise>
                  <span class="tag-pill neutral">Not exclusively offered</span>
                </c:otherwise>
              </c:choose>
            </span>
          </div>

          <div class="info-field">
            <span class="info-field-label">Female Instructor On-Site</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${center.femaleInstructor}">
                  <span class="tag-pill success"><i class="bi bi-check-circle-fill me-1"></i> Yes, Available</span>
                </c:when>
                <c:otherwise>
                  <span class="tag-pill neutral">No</span>
                </c:otherwise>
              </c:choose>
            </span>
          </div>

          <div class="info-field">
            <span class="info-field-label">Age Groups Accepted</span>
            <span class="info-field-value">${not empty center.ageGroups ? center.ageGroups : '<span class="empty-text">Kids, Teens & Adults</span>'}</span>
          </div>
        </div>
      </div>

      <!-- 5. OPERATIONS & SCHEDULE -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clock-fill"></i>
          <h3>5. Operations, Operating Hours & Weekly Schedule</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label mb-1">Working Days</span>
            <div>
              <c:choose>
                <c:when test="${not empty sortedAvailableDays}">
                  <c:forEach var="day" items="${sortedAvailableDays}">
                    <span class="tag-pill neutral">${day}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">No operating days specified</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field">
            <span class="info-field-label">Operating Hours</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${not empty center.openTime && not empty center.closeTime}">${center.openTime} - ${center.closeTime}</c:when>
                <c:otherwise><span class="empty-text">Not specified</span></c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Daily Break Interval</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${not empty center.breakStart && not empty center.breakEnd}">${center.breakStart} - ${center.breakEnd}</c:when>
                <c:otherwise><span class="empty-text">No midday break</span></c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Blocked / Holiday Dates</span>
            <span class="info-field-value">${not empty center.blockedDates ? center.blockedDates : '<span class="empty-text">None configured</span>'}</span>
          </div>
        </div>
      </div>

      <!-- 6. FACILITIES & SAFETY INFRASTRUCTURE -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-shield-fill-plus"></i>
          <h3>6. Centre Facilities & Safety Infrastructure</h3>
        </div>
        <div>
          <c:choose>
            <c:when test="${not empty center.facilities}">
              <c:forEach var="f" items="${fn:split(center.facilities, ',')}">
                <span class="tag-pill success"><i class="bi bi-check2-circle me-1"></i>${fn:trim(f)}</span>
              </c:forEach>
            </c:when>
            <c:otherwise><span class="empty-text">No specific facility tags listed</span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 7. TRAINING PROGRAMS & BATCHES -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-calendar3-event-fill"></i>
          <h3>7. Training Programs, Active Batches & Pricing</h3>
        </div>
        
        <div class="info-grid mb-3">
          <div class="info-field">
            <span class="info-field-label">Starting Price</span>
            <span class="info-field-value fw-bold fs-5" style="color: #16A34A;">₹${center.startingFee != null ? center.startingFee : 0} <small class="text-muted fw-normal fs-6">/ month</small></span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Free Trial Available</span>
            <span class="info-field-value ${center.trialAvailable ? 'text-success' : 'text-muted'}">
              <i class="bi ${center.trialAvailable ? 'bi-check-circle-fill' : 'bi-x-circle'}"></i>
              ${center.trialAvailable ? '1 Free Demo Session Offered' : 'No Free Trial'}
            </span>
          </div>
        </div>

        <div class="info-field-label mb-2">Registered Batches & Programs:</div>
        <c:choose>
          <c:when test="${not empty batches}">
            <c:forEach var="b" items="${batches}">
              <div class="batch-row">
                <div>
                  <strong style="color:var(--ap-navy); font-size:0.95rem;">${b.name}</strong>
                  <span class="tag-pill ms-2" style="font-size:0.75rem; padding:3px 10px; margin:0;">${b.style}</span>
                  <div class="small mt-1" style="color:var(--ap-muted);">
                    <i class="bi bi-person"></i> Coach: ${not empty b.instructor ? b.instructor : center.contactPerson} &nbsp;|&nbsp;
                    <i class="bi bi-clock"></i> ${b.timeSlot} (${b.availableDays})
                  </div>
                </div>
                <div class="text-md-end">
                  <div class="fw-bold fs-5" style="color: #16A34A;">₹${b.fee != null ? b.fee : 0}</div>
                  <div class="small" style="color:var(--ap-muted);">Capacity: ${b.capacity != null ? b.capacity : 20} seats</div>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:when test="${not empty types}">
            <c:forEach var="type" items="${types}">
              <div class="batch-row">
                <div>
                  <strong style="color:var(--ap-navy); font-size:0.95rem;">${type.name}</strong>
                  <div class="small" style="color:var(--ap-muted);">Curriculum Program</div>
                </div>
                <div class="fw-bold fs-5" style="color: #16A34A;">₹${type.cost}</div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="p-3 text-center bg-light rounded-3" style="color:var(--ap-muted);">
              <i class="bi bi-info-circle me-1"></i> No training programs added yet.
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 8. MEDIA & GALLERY -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-images"></i>
          <h3>8. Centre Media & Training Gallery</h3>
        </div>
        <c:choose>
          <c:when test="${not empty center.galleryPhotos}">
            <div class="gallery-grid">
              <c:forEach var="photo" items="${center.galleryPhotos}">
                <div class="gallery-item" onclick="window.open('${pageContext.request.contextPath}${photo}', '_blank')">
                  <img src="${pageContext.request.contextPath}${photo}" alt="Centre Photo" loading="lazy">
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="p-3 text-center bg-light rounded-3" style="color:var(--ap-muted);">
              <i class="bi bi-camera me-1"></i> No gallery images uploaded yet.
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 9. CERTIFICATES & DOCUMENTS -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-earmark-medical-fill"></i>
          <h3>9. Certifications & Verification Documents</h3>
        </div>
        <c:choose>
          <c:when test="${not empty center.trainerCertificatePath}">
            <div class="doc-row mb-0">
              <div class="doc-icon"><i class="bi bi-file-earmark-pdf-fill"></i></div>
              <div class="flex-grow-1">
                <div class="info-field-label">Trainer / Centre Master Certificate</div>
                <div class="small" style="color:var(--ap-muted);">Official accreditation document submitted by provider</div>
              </div>
              <div>
                <a href="${pageContext.request.contextPath}${center.trainerCertificatePath}" target="_blank" class="doc-link">
                  <i class="fas fa-external-link-alt me-1"></i> View Document
                </a>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="p-3 text-center bg-light rounded-3" style="color:var(--ap-muted);">
              <i class="bi bi-file-earmark-x me-1"></i> No certificate uploaded.
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 10. ADMIN DECISION & AUDIT TRAIL -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-gavel"></i>
          <h3>10. Admin Decision & Audit Trail</h3>
        </div>

        <div class="mb-3">
          <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
          <c:if test="${not empty center.changesRequestedNote}">
            <div class="mt-2 text-warning small"><strong><i class="bi bi-pencil-square me-1"></i> Changes requested on record:</strong> ${center.changesRequestedNote}</div>
          </c:if>
          <c:if test="${not empty center.rejectionReason}">
            <div class="mt-2 text-danger small"><strong><i class="bi bi-x-octagon me-1"></i> Rejection reason on record:</strong> ${center.rejectionReason}</div>
          </c:if>
        </div>

        <c:if test="${not empty missingItems}">
          <div class="alert alert-warning rounded-3 mb-3 p-3">
            <strong class="d-block mb-1"><i class="bi bi-exclamation-triangle-fill me-1"></i> Incomplete Profile Items:</strong>
            <ul class="missing-list">
              <c:forEach var="item" items="${missingItems}">
                <li>${item}</li>
              </c:forEach>
            </ul>
          </div>
        </c:if>

        <c:if test="${isAdmin}">
          <div class="mb-3">
            <label class="form-label fw-semibold" style="color:var(--ap-navy);">Decision notes / comments</label>
            <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the centre management (passed to approve / reject / request changes)" style="border-color:var(--ap-border);"></textarea>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold" style="color:var(--ap-navy);">Request-change reasons (optional)</label>
            <div class="d-flex flex-wrap gap-2 reason-checks">
              <label><input type="checkbox" class="reason-box" value="Centre Identity & Name"> Centre Identity & Name</label>
              <label><input type="checkbox" class="reason-box" value="Dojo Location & Maps"> Dojo Location & Maps</label>
              <label><input type="checkbox" class="reason-box" value="Certificates & Verification Documents"> Certificates & Docs</label>
              <label><input type="checkbox" class="reason-box" value="Batch Timings & Pricing"> Batch Timings & Pricing</label>
              <label><input type="checkbox" class="reason-box" value="Facilities & Safety Infrastructure"> Facilities & Safety</label>
              <label><input type="checkbox" class="reason-box" value="Gallery Photos"> Gallery Photos</label>
            </div>
          </div>

          <div class="action-bar">
            <!-- APPROVE FORM (Only show if not already approved) -->
            <c:if test="${!center.approved and statusKey ne 'APPROVED'}">
              <form id="approveForm" action="${pageContext.request.contextPath}/admin/centres/${center.id}/approve" method="post" class="m-0">
                <input type="hidden" name="notes" id="approveNotes">
                <button type="submit" class="btn-verify" onclick="document.getElementById('approveNotes').value = document.getElementById('decisionNotes').value; return confirm('Approve this centre for public listing?');">
                  <i class="fas fa-check-circle"></i> Approve Centre
                </button>
              </form>
            </c:if>

            <c:if test="${center.approved or statusKey eq 'APPROVED'}">
              <span class="tag-pill success" style="padding: 10px 18px; font-size: 0.9rem; font-weight: 700; margin: 0;">
                <i class="bi bi-check-circle-fill me-2"></i> Centre Approved & Active
              </span>
            </c:if>

            <!-- REQUEST CHANGES FORM -->
            <form id="requestChangesForm" action="${pageContext.request.contextPath}/admin/centres/${center.id}/request-changes" method="post" class="m-0">
              <input type="hidden" name="notes" id="changesNotes">
              <input type="hidden" name="reasons" id="changesReasons">
              <button type="submit" class="btn-changes" onclick="
                document.getElementById('changesNotes').value = document.getElementById('decisionNotes').value;
                document.getElementById('changesReasons').value = Array.from(document.querySelectorAll('.reason-box:checked')).map(e => e.value).join(', ');
              ">
                <i class="fas fa-edit"></i> Request Changes
              </button>
            </form>

            <!-- REJECT FORM -->
            <form id="rejectForm" action="${pageContext.request.contextPath}/admin/centres/${center.id}/reject" method="post" class="m-0" onsubmit="return confirm('Reject this centre application?');">
              <input type="hidden" name="notes" id="rejectNotes">
              <button type="submit" class="btn-reject" onclick="document.getElementById('rejectNotes').value = document.getElementById('decisionNotes').value;">
                <i class="fas fa-times-circle"></i> Reject Application
              </button>
            </form>
          </div>
        </c:if>
      </div>

      <!-- DANGER ZONE: DELETE ACCOUNT -->
      <c:if test="${isAdmin}">
        <div class="review-card border border-danger bg-white">
          <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
              <h5 class="fw-bold text-danger mb-1"><i class="bi bi-trash3-fill me-2"></i> Delete Centre Record</h5>
              <p class="small text-muted mb-0">Permanently delete this martial arts centre and all associated records from the platform.</p>
            </div>
            <form action="${pageContext.request.contextPath}/centres/delete/${center.id}" method="post" class="m-0"
                  onsubmit="return confirm('Are you sure you want to permanently delete this centre? This action cannot be undone.');">
              <button type="submit" class="btn-delete-acc">
                <i class="bi bi-trash me-1"></i> Delete Record
              </button>
            </form>
          </div>
        </div>
      </c:if>

<c:choose>
  <c:when test="${isAdmin}">
        </div>
      </main>
    </div>
  </c:when>
  <c:otherwise>
    </div>
  </c:otherwise>
</c:choose>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const toggle = document.getElementById('sidebarToggle');
  const sidebar = document.querySelector('.sidebar');
  if (toggle && sidebar) {
    toggle.addEventListener('click', () => sidebar.classList.toggle('active'));
  }
</script>
</body>
</html>
