<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${trainer.fullName} — Coach Profile Review | Fight D Fear Admin</title>

    <!-- Bootstrap & Icons & Typography -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_parameter" content="${_csrf.parameterName}"/>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">

    <style>        :root {
            --navy-dark: #E11D48;
            --navy-primary: #FFF5F5;
            --navy-light: #FFF5F5;
            --coral-primary: #F43F5E;
            --coral-light: #FFE4E6;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --card-bg: #ffffff;
            --page-bg: #ffffff;
            --border-color: #e2e8f0;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            background-color: var(--page-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
            margin: 0;
            padding-bottom: 80px;
        }

        /* Topbar */
        .admin-topbar {
            background: var(--navy-primary);
            color: var(--text-dark);
            padding: 14px 24px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-color);
        }

        .admin-topbar .brand {
            color: var(--text-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 700;
        }

        .admin-topbar .brand img {
            height: 32px;
            width: 32px;
            border-radius: 8px;
            object-fit: cover;
        }

        .review-container {
            max-width: 1200px;
            margin: 28px auto 0;
            padding: 0 16px;
        }

        .back-nav {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.92rem;
            text-decoration: none;
            margin-bottom: 20px;
            transition: color 0.2s;
        }

        .back-nav:hover {
            color: var(--coral-primary);
        }

        /* Provider Header Card */
        .header-card {
            background: var(--navy-primary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 32px;
            color: var(--text-dark);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }

        .header-card::after {
            content: '';
            position: absolute;
            right: -60px;
            top: -60px;
            width: 220px;
            height: 220px;
            background: rgba(244, 63, 94, 0.05);
            border-radius: 50%;
            pointer-events: none;
        }

        .avatar-box {
            width: 120px;
            height: 120px;
            border-radius: 20px;
            border: 4px solid #fff;
            overflow: hidden;
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            flex-shrink: 0;
        }

        .avatar-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .badge-status-lg {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.82rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-APPROVED, .status-VERIFIED { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .status-PENDING_ADMIN_APPROVAL, .status-READY_FOR_VERIFICATION { background: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }
        .status-CHANGES_REQUESTED { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .status-REJECTED, .status-SUSPENDED { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

        .header-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 12px;
            font-size: 0.95rem;
            color: var(--text-dark);
        }

        .header-meta i {
            color: var(--coral-primary);
            opacity: 0.9;
        }

        .pct-bar-bg {
            background: rgba(0,0,0,0.1);
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 10px;
        }

        .pct-bar-fill {
            background: var(--success-color);
            height: 100%;
            border-radius: 4px;
        }

        /* Content Grid */
        .grid-2 {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }

        @media (max-width: 992px) {
            .grid-2 { grid-template-columns: 1fr; }
            .header-card { padding: 24px; }
            .header-card .d-flex { flex-direction: column; text-align: center; }
            .header-meta { justify-content: center; }
        }

        .review-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--page-bg);
        }

        .section-header h3 {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
            font-family: 'Outfit', sans-serif;
        }

        .section-header i {
            color: var(--coral-primary);
            font-size: 1.2rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .info-field {
            background: var(--page-bg);
            padding: 14px 16px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .info-field-label {
            display: block;
            font-size: 0.78rem;
            text-transform: uppercase;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .info-field-value {
            font-size: 1rem;
            font-weight: 500;
            color: var(--text-dark);
            word-break: break-word;
        }

        .empty-text {
            color: #94a3b8;
            font-style: italic;
        }

        .program-badge {
            background: var(--coral-light);
            color: var(--navy-dark);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
            margin: 0 6px 6px 0;
            border: 1px solid rgba(244, 63, 94, 0.2);
        }

        /* Action Dock */
        .action-dock {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: var(--navy-primary);
            border-top: 1px solid var(--border-color);
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 1000;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.1);
        }.tag-pill {
            display: inline-block;
            background: #f1f5f9;
            color: var(--text-dark);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.82rem;
            font-weight: 600;
            margin-right: 6px;
            margin-bottom: 6px;
            border: 1px solid var(--border-color);
        }

        .tag-pill.highlight {
            background: var(--coral-light);
            color: #9f1239;
            border-color: #fecdd3;
        }

        /* Gallery Grid */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 14px;
        }

        .gallery-item {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            aspect-ratio: 4/3;
            border: 1px solid var(--border-color);
            background: #f8fafc;
            cursor: pointer;
        }

        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }

        .gallery-item:hover img {
            transform: scale(1.06);
        }

        /* Sticky Action Bar */
        .action-dock {
            position: sticky;
            bottom: 20px;
            background: var(--navy-primary);
            backdrop-filter: blur(10px);
            padding: 16px 24px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            color: var(--text-dark);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            z-index: 900;
            border: 1px solid var(--border-color);
        }

        .btn-action-approve {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-approve:hover {
            background: #059669;
            transform: translateY(-1px);
            color: white;
        }

        .btn-action-changes {
            background: #f59e0b;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-changes:hover {
            background: #d97706;
            transform: translateY(-1px);
            color: white;
        }

        .btn-action-reject {
            background: #ef4444;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-reject:hover {
            background: #dc2626;
            transform: translateY(-1px);
            color: white;
        }

        .empty-text {
            color: var(--text-muted);
            font-style: italic;
            font-size: 0.9rem;
        }
    </style>
</head>
  <body class="ap-page">
  <div class="layout">
    <%@ include file="globalAdminMenu.jsp" %>
    <main class="main">
      <div class="ap-topbar">
        <div class="ap-topbar-left">
          <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
          <div class="ap-search" style="max-width:360px;">
            <i class="fas fa-search"></i>
            <input type="search" id="apHeaderSearch" placeholder="Search anything..." aria-label="Search">
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
            <div class="name"><c:out value="${admin.name}"/></div>
            <i class="fas fa-chevron-down ms-1" style="font-size:0.7rem;color:var(--ap-muted);"></i>
          </a>
        </div>
      </div>
<div class="review-container">

        <!-- Flash messages -->
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

        <a href="${pageContext.request.contextPath}/admin/pending-trainers" class="back-nav">
            <i class="bi bi-arrow-left"></i> Back to Fitness Trainers Oversight
        </a>

        <!-- PROVIDER HEADER CARD -->
        <div class="header-card">
            <div class="d-flex align-items-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="${not empty trainer.profilePhotoPath}">
                            <img src="${trainer.profilePhotoPath.startsWith('http') ? trainer.profilePhotoPath : pageContext.request.contextPath.concat(trainer.profilePhotoPath)}" alt="Profile Photo">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" alt="Default Avatar">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
                        <h1 class="h3 fw-bold mb-0 text-dark">${trainer.fullName}</h1>
                        <c:if test="${empty statusKey}">
                            <c:set var="statusKey" value="${not empty trainer.partnerProfileStatus ? trainer.partnerProfileStatus.name() : (not empty trainer.verificationStatus ? (trainer.verificationStatus.name() == 'VERIFIED' ? 'APPROVED' : trainer.verificationStatus.name()) : 'PENDING')}"/>
                        </c:if>
                        <span class="badge-status-lg status-${statusKey}">
                            <i class="bi ${statusKey == 'APPROVED' || statusKey == 'VERIFIED' ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            ${statusKey}
                        </span>

                        <c:if test="${trainer.suspended}">
                            <span class="badge bg-danger text-dark px-3 py-1">SUSPENDED</span>
                        </c:if>
                    </div>

                    <div class="d-flex flex-wrap gap-4 text-muted small mb-3">
                        <div><i class="bi bi-award-fill text-dark"></i> <strong>Designation:</strong> ${not empty trainer.designation ? trainer.designation : 'Fitness Coach'}</div>
                        <div><i class="bi bi-envelope-fill text-dark"></i> <a href="mailto:${trainer.email}" class="text-dark text-decoration-none">${trainer.email}</a></div>
                        <div><i class="bi bi-telephone-fill text-dark"></i> <a href="tel:${trainer.phone}" class="text-dark text-decoration-none">${trainer.phone}</a></div>
                        <div><i class="bi bi-geo-alt-fill text-dark"></i> ${not empty trainer.city ? trainer.city : 'Location not set'}</div>
                    </div>

                    <!-- Profile Completion -->
                    <div class="mt-2" style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold text-dark mb-1">
                            <span>Profile Completion</span>
                            <span>${trainer.profileCompletionPct != null ? trainer.profileCompletionPct : 0}%</span>
                        </div>
                        <div class="progress-wrap">
                            <div class="progress-bar-fill" style="width: ${trainer.profileCompletionPct != null ? trainer.profileCompletionPct : 0}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. COACH IDENTITY & CREDENTIALS -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-person-badge-fill"></i>
                <h3>1. Coach Identity & Professional Credentials</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Full Name</span>
                    <span class="info-field-value">${trainer.fullName}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Coach Designation</span>
                    <span class="info-field-value">${not empty trainer.designation ? trainer.designation : '<span class=\"empty-text\">Personal Trainer</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Experience</span>
                    <span class="info-field-value">${trainer.experience != null ? trainer.experience : 0} Years in Industry</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Certificate / License Registration #</span>
                    <span class="info-field-value">${not empty trainer.credentialNumber ? trainer.credentialNumber : '<span class=\"empty-text\">Not specified</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Primary Phone</span>
                    <span class="info-field-value">${not empty trainer.phone ? trainer.phone : '<span class=\"empty-text\">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">WhatsApp Number</span>
                    <span class="info-field-value">${not empty trainer.whatsappNumber ? trainer.whatsappNumber : '<span class=\"empty-text\">Same as primary</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Official Email</span>
                    <span class="info-field-value">${trainer.email}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Service Type / Model</span>
                    <span class="info-field-value">${not empty trainer.serviceType ? trainer.serviceType : '<span class=\"empty-text\">General Fitness</span>'}</span>
                </div>
            </div>
        </div>

        <!-- 2. LOCATION & STUDIO PREMISES -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-geo-alt-fill"></i>
                <h3>2. Physical Location & Service Radius</h3>
            </div>
            <div class="info-grid">
                <div class="info-field" style="grid-column: 1 / -1;">
                    <span class="info-field-label">Studio / Street Address</span>
                    <span class="info-field-value">${not empty trainer.address ? trainer.address : '<span class=\"empty-text\">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">City</span>
                    <span class="info-field-value">${not empty trainer.city ? trainer.city : '<span class=\"empty-text\">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">State</span>
                    <span class="info-field-value">${not empty trainer.state ? trainer.state : '<span class=\"empty-text\">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Postal Pincode</span>
                    <span class="info-field-value">${not empty trainer.pincode ? trainer.pincode : '<span class=\"empty-text\">Not provided</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Doorstep / Home Visits</span>
                    <span class="info-field-value mt-1">
                        <c:choose>
                            <c:when test="${trainer.doorService}">
                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Offered</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Studio / Online Only</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <!-- 3. BIO & COACHING PHILOSOPHY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-file-text-fill"></i>
                <h3>3. Coach Bio & Training Philosophy</h3>
            </div>
            <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.95rem; line-height: 1.7;">
                ${not empty trainer.bio ? trainer.bio : '<span class=\"empty-text\">No bio description provided yet.</span>'}
            </div>
        </div>

        <!-- 4. FITNESS SPECIALIZATIONS & CLIENTELE -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-activity"></i>
                <h3>4. Specializations, Session Modes & Clientele</h3>
            </div>
            <div class="row g-4">
                <div class="col-md-6">
                    <span class="info-field-label d-block mb-2">Training Specializations</span>
                    <div>
                        <c:choose>
                            <c:when test="${not empty trainer.specializations}">
                                <c:forEach var="s" items="${fn:split(trainer.specializations, ',')}">
                                    <span class="tag-pill highlight"><i class="bi bi-lightning-charge-fill me-1"></i>${fn:trim(s)}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-text">No specializations tagged</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-6">
                    <span class="info-field-label d-block mb-2">Target Clientele</span>
                    <div>
                        <c:choose>
                            <c:when test="${not empty trainer.audience}">
                                <c:forEach var="a" items="${fn:split(trainer.audience, ',')}">
                                    <span class="tag-pill">${fn:trim(a)}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-text">All clients</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Preferred Session Mode</span>
                    <span class="info-field-value mt-1 d-block">
                        <span class="badge bg-primary">${not empty trainer.sessionMode ? trainer.sessionMode : 'In-Person & Online'}</span>
                    </span>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Session Duration</span>
                    <span class="info-field-value mt-1 d-block">
                        ${trainer.durationMinutes != null ? trainer.durationMinutes : 60} Minutes
                    </span>
                </div>

                <div class="col-md-4">
                    <span class="info-field-label">Buffer Between Sessions</span>
                    <span class="info-field-value mt-1 d-block">
                        ${trainer.bufferMinutes != null ? trainer.bufferMinutes : 10} Minutes
                    </span>
                </div>
            </div>
        </div>

        <!-- 5. OPERATIONS & SCHEDULE -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-clock-fill"></i>
                <h3>5. Operations, Available Days & Timings</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Available Days</span>
                    <span class="info-field-value">${not empty trainer.openDays ? trainer.openDays : '<span class=\"empty-text\">Not specified</span>'}</span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Daily Working Hours</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${trainer.openTime != null && trainer.closeTime != null}">
                                ${trainer.openTime} - ${trainer.closeTime}
                            </c:when>
                            <c:when test="${not empty trainer.availableTimings}">
                                ${trainer.availableTimings}
                            </c:when>
                            <c:otherwise><span class="empty-text">Not specified</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Break Interval</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${trainer.breakStart != null && trainer.breakEnd != null}">
                                ${trainer.breakStart} - ${trainer.breakEnd}
                            </c:when>
                            <c:otherwise><span class="empty-text">No break interval</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Blocked / Holiday Dates</span>
                    <span class="info-field-value">${not empty trainer.blockedDates ? trainer.blockedDates : '<span class=\"empty-text\">None configured</span>'}</span>
                </div>
            </div>
        </div>

        <!-- 6. FACILITIES & STUDIO EQUIPMENT -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-shield-fill-plus"></i>
                <h3>6. Studio Facilities & Training Equipment</h3>
            </div>
            <div>
                <c:choose>
                    <c:when test="${not empty trainer.facilities}">
                        <c:forEach var="f" items="${fn:split(trainer.facilities, ',')}">
                            <span class="tag-pill"><i class="bi bi-check2-circle text-success me-1"></i>${fn:trim(f)}</span>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No studio facility tags listed</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 7. PRICING & BANKING SETUP -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-wallet2"></i>
                <h3>7. Session Pricing & Bank Payout Setup</h3>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Session Fee</span>
                        <div class="h4 fw-bold text-success mb-0 mt-1">₹${trainer.sessionFees != null ? trainer.sessionFees : (trainer.typicalPrice != null ? trainer.typicalPrice : 0)} <small class="text-muted fw-normal fs-6">/ session</small></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">UPI ID</span>
                        <div class="fw-bold text-dark mt-1">${not empty trainer.upiId ? trainer.upiId : '<span class=\"empty-text\">Not linked</span>'}</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Bank Account Info</span>
                        <div class="fw-bold text-dark mt-1">${not empty trainer.bankDetails ? trainer.bankDetails : '<span class=\"empty-text\">Not provided</span>'}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 8. MEDIA GALLERY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-images"></i>
                <h3>8. Training Media & Gallery</h3>
            </div>
            <c:choose>
                <c:when test="${not empty trainer.galleryPhotos}">
                    <div class="gallery-grid">
                        <c:forEach var="photo" items="${fn:split(trainer.galleryPhotos, ',')}">
                            <div class="gallery-item" onclick="window.open('${fn:trim(photo).startsWith('http') ? fn:trim(photo) : pageContext.request.contextPath.concat(fn:trim(photo))}', '_blank')">
                                <img src="${fn:trim(photo).startsWith('http') ? fn:trim(photo) : pageContext.request.contextPath.concat(fn:trim(photo))}" alt="Trainer Media" loading="lazy">
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-4 text-center text-muted bg-light rounded-3">
                        <i class="bi bi-camera fs-3 d-block mb-1"></i>
                        No gallery photos uploaded yet.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 9. CERTIFICATES & DOCUMENTS -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-file-earmark-medical-fill"></i>
                <h3>9. Professional Certifications & Documents</h3>
            </div>
            <c:choose>
                <c:when test="${not empty trainer.certificationsPath}">
                    <div class="d-flex align-items-center justify-content-between p-3 border rounded-3 bg-light">
                        <div class="d-flex align-items-center gap-3">
                            <i class="bi bi-file-earmark-pdf-fill text-danger fs-1"></i>
                            <div>
                                <h6 class="fw-bold mb-0">Coach Certification / License Document</h6>
                                <small class="text-muted">Official accreditation file uploaded during profile setup</small>
                            </div>
                        </div>
                        <a href="${trainer.certificationsPath.startsWith('http') ? trainer.certificationsPath : pageContext.request.contextPath.concat(trainer.certificationsPath)}" target="_blank" class="btn btn-primary fw-bold">
                            <i class="bi bi-box-arrow-up-right me-1"></i> View / Open Document
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-4 text-center text-muted bg-light rounded-3">
                        <i class="bi bi-file-earmark-x fs-3 d-block mb-1"></i>
                        No certification document uploaded yet.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 10. VERIFICATION AUDIT TRAIL -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-clipboard-check-fill"></i>
                <h3>10. Verification Audit Trail & Admin Feedback</h3>
            </div>
            <div class="info-grid mb-3">
                <div class="info-field">
                    <span class="info-field-label">Verification Status</span>
                    <span class="info-field-value">
                        <span class="badge-status-lg status-${statusKey}">${statusKey}</span>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Submitted for Verification</span>
                    <span class="info-field-value">
                        <c:choose>
                            <c:when test="${trainer.submittedForVerificationAt != null}">
                                ${trainer.submittedForVerificationAt}
                            </c:when>
                            <c:otherwise><span class="empty-text">Not recorded</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <c:if test="${not empty trainer.rejectionReason}">
                <div class="alert alert-danger rounded-3 mt-3">
                    <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection Reason on Record:</strong>
                    <div class="mt-1">${trainer.rejectionReason}</div>
                </div>
            </c:if>

            <c:if test="${not empty trainer.changesRequestedNote}">
                <div class="alert alert-warning rounded-3 mt-3">
                    <strong><i class="bi bi-pencil-square me-1"></i> Changes Requested Note on Record:</strong>
                    <div class="mt-1">${trainer.changesRequestedNote}</div>
                </div>
            </c:if>
        </div>

        <!-- STICKY ACTION DOCK -->
        <div class="action-dock">
            <div>
                <span class="small text-muted d-block">Admin Decision Workflow</span>
                <strong class="text-dark">${trainer.fullName}</strong>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">

                <c:if test="${statusKey != 'APPROVED'}">
                    <!-- Approve -->
                    <form action="${pageContext.request.contextPath}/admin/trainers/${trainer.id}/approve" method="post" class="m-0">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this fitness coach?');">
                            <i class="bi bi-check-lg me-1"></i> Approve Coach
                        </button>
                    </form>
                </c:if>

                <!-- Request Changes Trigger -->
                <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#trainerChangesModal">
                    <i class="bi bi-pencil me-1"></i> Request Changes
                </button>

                <c:if test="${statusKey != 'APPROVED'}">
                    <!-- Reject Trigger -->
                    <button type="button" class="btn-action-reject" data-bs-toggle="modal" data-bs-target="#trainerRejectModal">
                        <i class="bi bi-x-lg me-1"></i> Reject
                    </button>
                </c:if>
            </div>
        </div>

    </div>

    <!-- REQUEST CHANGES MODAL -->
    <div class="modal fade" id="trainerChangesModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/trainers/${trainer.id}/request-changes" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i> Request Profile Changes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide specific feedback explaining what needs to be updated before approval.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Feedback Note</label>
                            <textarea name="note" class="form-control" rows="4" placeholder="e.g., Please attach a valid certification and provide session timings..." required></textarea>
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
    <div class="modal fade" id="trainerRejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/trainers/${trainer.id}/reject" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-x-octagon me-2"></i> Reject Coach</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide the reason for rejecting this trainer application.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rejection Reason</label>
                            <textarea name="reason" class="form-control" rows="4" placeholder="e.g., Incomplete credentials or unverified certification..." required></textarea>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main></div><script>document.getElementById('sidebarToggle').addEventListener('click', function() { document.querySelector('.sidebar').classList.toggle('active'); });</script></body>
</html>

