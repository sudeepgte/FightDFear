<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${center.name} - Provider Profile Review | Fight D Fear</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.ap-page { margin: 0; padding-bottom: 96px; }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  .review-container { max-width: 1100px; margin: 0 auto; padding: 22px 24px 40px; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    text-decoration: none; font-weight: 600; font-size: 0.88rem; margin-bottom: 14px;
  }
  .back-nav:hover { color: var(--ap-accent); }

  .header-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 18px; box-shadow: var(--ap-shadow); color: var(--ap-text);
  }
  .header-card h1, .header-card .h3 { color: var(--ap-text) !important; }
  .avatar-box {
    width: 96px; height: 96px; border-radius: 50%; overflow: hidden; flex-shrink: 0;
    border: 3px solid #FFE4E6; background: var(--ap-accent-soft);
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .contact-line { color: var(--ap-muted); }
  .contact-line a { color: var(--ap-text); font-weight: 600; text-decoration: none; }
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
  .info-field-label {
    display: block; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
    text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px;
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-text); word-break: break-word; }
  .empty-text { color: #94A3B8; font-size: 0.88rem; font-style: italic; }

  .badge-status-lg {
    display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; border-radius: 999px;
    font-size: 0.75rem; font-weight: 800;
  }
  .status-APPROVED { background: var(--ap-success-bg); color: var(--ap-success); }
  .status-REJECTED, .status-SUSPENDED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  .status-CHANGES_REQUESTED { background: #FFEDD5; color: #C2410C; }
  .status-PENDING_ADMIN_APPROVAL, .status-PROFILE_INCOMPLETE, .status-REGISTERED,
  .status-READY_FOR_VERIFICATION { background: #FEF3C7; color: #B45309; }

  .tag-pill {
    display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 999px;
    background: #F8FAFC; border: 1px solid var(--ap-border); font-size: 0.78rem; font-weight: 600;
    margin: 0 6px 6px 0; color: #334155;
  }
  .batch-card {
    display: flex; justify-content: space-between; gap: 12px; flex-wrap: wrap;
    border: 1px solid var(--ap-border); border-radius: 12px; padding: 14px; margin-bottom: 10px; background: #FCFCFD;
  }
  .gallery-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 10px;
  }
  .gallery-item {
    aspect-ratio: 1; border-radius: 12px; overflow: hidden; border: 1px solid var(--ap-border); cursor: pointer;
  }
  .gallery-item img { width: 100%; height: 100%; object-fit: cover; }

  .action-dock {
    position: fixed; left: var(--sidebar-w, 272px); right: 0; bottom: 0; z-index: 1050;
    background: #0F172A; color: #fff; padding: 14px 20px;
    display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap;
    border-top: 1px solid rgba(255,255,255,.08);
  }
  .btn-action-approve, .btn-action-changes, .btn-action-reject, .btn-action-delete {
    border: 0; border-radius: 10px; padding: 10px 16px; font-weight: 700; font-size: 0.88rem;
    display: inline-flex; align-items: center; gap: 6px; cursor: pointer;
  }
  .btn-action-approve { background: var(--ap-success); color: #fff; }
  .btn-action-changes { background: var(--ap-warn); color: #fff; }
  .btn-action-reject, .btn-action-delete { background: var(--ap-danger); color: #fff; }

  .owner-shell { max-width: 1100px; margin: 0 auto; padding: 22px 24px 40px; }

  @media (max-width: 992px) {
    .action-dock { left: 0; }
    .info-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body class="ap-page">

<c:set var="isAdmin" value="${not empty sessionScope.admin}"/>

<c:choose>
  <c:when test="${isAdmin}">
<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>
  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:320px;">
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
          <span class="ap-avatar">${fn:substring(admin.name,0,1)}</span>
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
        <span>Review</span>
      </nav>
      <a href="${pageContext.request.contextPath}/admin/martialManagement" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Martial Arts Centres Management
      </a>
  </c:when>
  <c:otherwise>
    <div class="owner-shell">
      <a href="${pageContext.request.contextPath}/centres/dashboard" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Centre Dashboard
      </a>
  </c:otherwise>
</c:choose>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- PROVIDER HEADER CARD -->
        <div class="header-card">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="${not empty center.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${center.profilePhoto}" alt="${center.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light text-muted">
                                <i class="bi bi-shield-shaded" style="font-size: 3rem; color: #94a3b8;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
                        <h1 class="h3 fw-bold mb-0">${center.name}</h1>
                        <c:set var="statusKey" value="${center.centreProfileStatus != null ? center.centreProfileStatus : (center.approved ? 'APPROVED' : 'PENDING_ADMIN_APPROVAL')}"/>
                        <span class="badge-status-lg status-${statusKey}">
                            <i class="bi ${center.approved ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            ${statusKey}
                        </span>
                    </div>

                    <div class="d-flex flex-wrap gap-4 contact-line small mb-3">
                        <div><i class="bi bi-person-fill me-1" style="color:var(--ap-accent);"></i> <strong>Manager:</strong> ${not empty center.contactPerson ? center.contactPerson : 'Not provided'}</div>
                        <div><i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i> <a href="mailto:${center.email}" class="text-decoration-none">${center.email}</a></div>
                        <div><i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i> <a href="tel:${center.phoneNumber}" class="text-decoration-none">${center.phoneNumber}</a></div>
                        <div><i class="bi bi-geo-alt-fill me-1" style="color:var(--ap-accent);"></i> ${not empty center.city ? center.city : center.location}</div>
                    </div>

                    <!-- Profile Completion -->
                    <div class="mt-2" style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold mb-1">
                            <span>Profile Completion</span>
                            <span>${center.profileCompletionPct != null ? center.profileCompletionPct : (center.approved ? 100 : 0)}%</span>
                        </div>
                        <div class="progress-wrap">
                            <div class="progress-bar-fill" style="width: ${center.profileCompletionPct != null ? center.profileCompletionPct : (center.approved ? 100 : 0)}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. BASIC / CENTRE IDENTITY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-building-fill-check"></i>
                <h3>1. Centre Identity & Contact Information</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Official Centre Name</span>
                    <span class="info-field-value">${not empty center.name ? center.name : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Centre Classification</span>
                    <span class="info-field-value">${not empty center.centreType ? center.centreType : '<span class="empty-text">Not specified</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Owner / Head Instructor</span>
                    <span class="info-field-value">${not empty center.contactPerson ? center.contactPerson : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Instructor Designation</span>
                    <span class="info-field-value">${not empty center.designation ? center.designation : '<span class="empty-text">Head Coach</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Primary Contact Phone</span>
                    <span class="info-field-value">${not empty center.phoneNumber ? center.phoneNumber : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">WhatsApp Helpline</span>
                    <span class="info-field-value">${not empty center.whatsappNumber ? center.whatsappNumber : '<span class="empty-text">Same as primary</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Official Email</span>
                    <span class="info-field-value">${not empty center.email ? center.email : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Established Year</span>
                    <span class="info-field-value">${center.yearStarted != null ? center.yearStarted : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Federation Affiliation</span>
                    <span class="info-field-value">${not empty center.affiliation ? center.affiliation : '<span class="empty-text">Independent / Unaffiliated</span>'}</span>
                </div>
            </div>
        </div>

        <!-- 2. LOCATION & PREMISES -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-geo-alt-fill"></i>
                <h3>2. Physical Location & Map Coordinates</h3>
            </div>
            <div class="info-grid">
                <div class="info-field" style="grid-column: 1 / -1;">
                    <span class="info-field-label">Hall / Landmark / Street Address</span>
                    <span class="info-field-value">${not empty center.area ? center.area : (not empty center.location ? center.location : '<span class="empty-text">Not provided</span>')}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">City</span>
                    <span class="info-field-value">${not empty center.city ? center.city : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">State</span>
                    <span class="info-field-value">${not empty center.state ? center.state : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Postal Pincode</span>
                    <span class="info-field-value">${not empty center.pincode ? center.pincode : '<span class="empty-text">Not provided</span>'}</span>
                </div>
                <div class="info-field" style="grid-column: 1 / -1;">
                    <span class="info-field-label">Google Maps Link / Coordinates</span>
                    <c:choose>
                        <c:when test="${not empty center.googleMapLocation}">
                            <a href="${center.googleMapLocation}" target="_blank" class="ap-btn-view d-inline-flex align-items-center gap-2 mt-1" style="max-width: 250px;">
                                <i class="bi bi-map-fill"></i> Open in Google Maps
                            </a>
                        </c:when>
                        <c:when test="${center.centreLat != null && center.centreLng != null}">
                            <span class="info-field-value">${center.centreLat}, ${center.centreLng}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="empty-text">No GPS coordinates pinned</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- 3. ABOUT & TEACHING PHILOSOPHY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-file-text-fill"></i>
                <h3>3. About Centre & Training Methodology</h3>
            </div>
            <div class="d-flex flex-column gap-3">
                <div>
                    <span class="info-field-label d-block mb-1">About the Centre</span>
                    <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.92rem; line-height: 1.6;">
                        ${not empty center.about ? center.about : '<span class="empty-text">No bio description provided yet.</span>'}
                    </div>
                </div>
                <div>
                    <span class="info-field-label d-block mb-1">How We Teach (Training Methodology)</span>
                    <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.92rem; line-height: 1.6;">
                        ${not empty center.howWeTeach ? center.howWeTeach : '<span class="empty-text">No teaching methodology specified.</span>'}
                    </div>
                </div>
                <div>
                    <span class="info-field-label d-block mb-1">What We Offer</span>
                    <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.92rem; line-height: 1.6;">
                        ${not empty center.whatWeOffer ? center.whatWeOffer : '<span class="empty-text">No offers specified.</span>'}
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. MARTIAL ARTS CURRICULUM & AUDIENCE -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-trophy-fill"></i>
                <h3>4. Martial Arts Styles, Audience & Women Safety</h3>
            </div>
            <div class="row g-4">
                <div class="col-md-6">
                    <span class="info-field-label d-block mb-2">Martial Arts Styles Taught</span>
                    <div>
                        <c:choose>
                            <c:when test="${not empty center.stylesTaught}">
                                <c:forEach var="s" items="${fn:split(center.stylesTaught, ',')}">
                                    <span class="tag-pill highlight"><i class="bi bi-lightning-charge-fill me-1"></i>${fn:trim(s)}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-text">No styles tagged</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-6">
                    <span class="info-field-label d-block mb-2">Target Audience</span>
                    <div>
                        <c:choose>
                            <c:when test="${not empty center.audience}">
                                <c:forEach var="a" items="${fn:split(center.audience, ',')}">
                                    <span class="tag-pill">${fn:trim(a)}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-text">All age groups</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Women-Only Batches</span>
                    <span class="info-field-value mt-1 d-block">
                        <c:choose>
                            <c:when test="${center.womenOnlyBatches}">
                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Not exclusively offered</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Female Instructor On-Site</span>
                    <span class="info-field-value mt-1 d-block">
                        <c:choose>
                            <c:when test="${center.femaleInstructor}">
                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Yes, Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">No</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Age Groups Accepted</span>
                    <span class="info-field-value mt-1 d-block">
                        ${not empty center.ageGroups ? center.ageGroups : '<span class="empty-text">Kids, Teens & Adults</span>'}
                    </span>
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
                <div class="info-field">
                    <span class="info-field-label">Working Days</span>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${not empty sortedAvailableDays}">
                                <c:forEach var="day" items="${sortedAvailableDays}">
                                    <span class="tag-pill">${day}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-text">No operating days specified</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Operating Hours</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${not empty center.openTime && not empty center.closeTime}">
                                ${center.openTime} - ${center.closeTime}
                            </c:when>
                            <c:otherwise><span class="empty-text">Not specified</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Daily Break Interval</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${not empty center.breakStart && not empty center.breakEnd}">
                                ${center.breakStart} - ${center.breakEnd}
                            </c:when>
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

        <!-- 6. FACILITIES & EQUIPMENT -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-shield-fill-plus"></i>
                <h3>6. Centre Facilities & Safety Infrastructure</h3>
            </div>
            <div>
                <c:choose>
                    <c:when test="${not empty center.facilities}">
                        <c:forEach var="f" items="${fn:split(center.facilities, ',')}">
                            <span class="tag-pill"><i class="bi bi-check2-circle text-success me-1"></i>${fn:trim(f)}</span>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No specific facility tags listed</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 7. TRAINING PROGRAMS & BATCHES -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-calendar3-event-fill"></i>
                <h3>7. Training Programs, Active Batches & Pricing</h3>
            </div>
            
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Starting Price</span>
                        <div class="h4 fw-bold text-success mb-0 mt-1">₹${center.startingFee != null ? center.startingFee : 0} <small class="text-muted fw-normal fs-6">/ month</small></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Free Trial Available</span>
                        <div class="h5 fw-bold mb-0 mt-1 ${center.trialAvailable ? 'text-success' : 'text-muted'}">
                            <i class="bi ${center.trialAvailable ? 'bi-check-circle-fill' : 'bi-x-circle'}"></i>
                            ${center.trialAvailable ? '1 Free Demo Session Offered' : 'No Free Trial'}
                        </div>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold fs-6 text-secondary mb-3">Registered Batches & Programs:</h5>
            <c:choose>
                <c:when test="${not empty center.batches}">
                    <c:forEach var="b" items="${center.batches}">
                        <div class="batch-card">
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">${b.name} <span class="ap-badge ap-badge-reverify ms-2">${b.style}</span></h6>
                                <div class="small text-muted">
                                    <i class="bi bi-person"></i> Coach: ${not empty b.instructor ? b.instructor : center.contactPerson} &nbsp;|&nbsp;
                                    <i class="bi bi-clock"></i> ${b.startTime} - ${b.endTime} (${b.days})
                                </div>
                            </div>
                            <div class="text-md-end">
                                <div class="fw-bold text-success fs-5">₹${b.fee != null ? b.fee : 0}</div>
                                <div class="small text-muted">Capacity: ${b.maxCapacity != null ? b.maxCapacity : 20} seats</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:when test="${not empty types}">
                    <c:forEach var="type" items="${types}">
                        <div class="batch-card">
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">${type.name}</h6>
                                <div class="small text-muted">Curriculum Program</div>
                            </div>
                            <div class="fw-bold text-success fs-5">₹${type.cost}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="p-4 text-center text-muted bg-light rounded-3">
                        <i class="bi bi-info-circle fs-3 d-block mb-1"></i>
                        No training programs added yet.
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
                    <div class="p-4 text-center text-muted bg-light rounded-3">
                        <i class="bi bi-camera fs-3 d-block mb-1"></i>
                        No gallery images uploaded yet.
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
                    <div class="d-flex align-items-center justify-content-between p-3 border rounded-3 bg-light">
                        <div class="d-flex align-items-center gap-3">
                            <i class="bi bi-file-earmark-pdf-fill text-danger fs-1"></i>
                            <div>
                                <h6 class="fw-bold mb-0">Trainer / Centre Master Certificate</h6>
                                <small class="text-muted">Official accreditation document submitted by provider</small>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}${center.trainerCertificatePath}" target="_blank" class="ap-btn ap-btn-primary">
                            <i class="bi bi-box-arrow-up-right me-1"></i> View / Open Document
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-4 text-center text-muted bg-light rounded-3">
                        <i class="bi bi-file-earmark-x fs-3 d-block mb-1"></i>
                        No certificate uploaded (Optional for unregistered centres).
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 10. VERIFICATION STATUS & ADMIN AUDIT TRAIL -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-clipboard-check-fill"></i>
                <h3>10. Verification Audit Trail & Admin Feedback</h3>
            </div>
            <div class="info-grid mb-3">
                <div class="info-field">
                    <span class="info-field-label">Current Status</span>
                    <span class="info-field-value">
                        <span class="badge-status-lg status-${statusKey}">
                            ${statusKey}
                        </span>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Submitted for Verification</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${center.submittedForVerificationAt != null}">
                                ${center.submittedForVerificationAt}
                            </c:when>
                            <c:otherwise><span class="empty-text">Not recorded</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <c:if test="${not empty center.rejectionReason}">
                <div class="alert alert-danger rounded-3 mt-3">
                    <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection Reason on Record:</strong>
                    <div class="mt-1">${center.rejectionReason}</div>
                </div>
            </c:if>

            <c:if test="${not empty center.changesRequestedNote}">
                <div class="alert alert-warning rounded-3 mt-3">
                    <strong><i class="bi bi-pencil-square me-1"></i> Changes Requested Note on Record:</strong>
                    <div class="mt-1">${center.changesRequestedNote}</div>
                </div>
            </c:if>
        </div>

        <!-- 11. DANGER ZONE -->
        <div class="review-card border-danger-subtle bg-danger-subtle bg-opacity-10">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h5 class="fw-bold text-danger mb-1"><i class="bi bi-trash3-fill me-2"></i> Delete Centre Account</h5>
                    <p class="small text-muted mb-0">Permanently delete this martial arts centre and all associated records from the platform.</p>
                </div>
                <form action="${pageContext.request.contextPath}/centres/delete/${center.id}" method="post" class="m-0"
                      onsubmit="return confirm('Are you sure you want to permanently delete this centre? This action cannot be undone.');">
                    <button type="submit" class="btn-action-delete">
                        <i class="bi bi-trash me-1"></i> Delete Account
                    </button>
                </form>
            </div>
        </div>

<c:if test="${isAdmin}">
        <!-- STICKY ACTION DOCK -->
        <div class="action-dock">
            <div>
                <span class="small text-white-50 d-block">Admin Decision Workflow</span>
                <strong class="text-white">${center.name}</strong>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <!-- Approve -->
                <form action="${pageContext.request.contextPath}/admin/approve/${center.id}" method="post" class="m-0">
                    <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this centre for public listing?');">
                        <i class="bi bi-check-lg me-1"></i> Approve Centre
                    </button>
                </form>

                <!-- Request Changes Modal Trigger -->
                <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#requestChangesModal">
                    <i class="bi bi-pencil me-1"></i> Request Changes
                </button>

                <!-- Reject Modal Trigger -->
                <button type="button" class="btn-action-reject" data-bs-toggle="modal" data-bs-target="#rejectModal">
                    <i class="bi bi-x-lg me-1"></i> Reject
                </button>
            </div>
        </div>

    </div>

    <!-- REQUEST CHANGES MODAL -->
    <div class="modal fade" id="requestChangesModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/centres/${center.id}/request-changes" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i> Request Profile Changes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide specific feedback to the provider explaining what needs to be updated before approval.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Feedback Note</label>
                            <textarea name="note" class="form-control" rows="4" placeholder="e.g., Please upload your government certificate and specify batch timings..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark">Send Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- REJECT MODAL -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/centres/${center.id}/reject" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-x-octagon me-2"></i> Reject Application</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide the reason for rejecting this centre application.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rejection Reason</label>
                            <textarea name="reason" class="form-control" rows="4" placeholder="e.g., Ineligible location or unverified qualifications..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger fw-bold">Confirm Rejection</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    
</c:if>

<c:choose>
  <c:when test="${isAdmin}">
  </main>
</div>
  </c:when>
  <c:otherwise>
    </div>
  </c:otherwise>
</c:choose>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
