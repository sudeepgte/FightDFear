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

    <style>
        :root {
            --navy-dark: #0f0d26;
            --navy-primary: #1e1b4b;
            --navy-light: #312e81;
            --coral-primary: #f43f5e;
            --coral-light: #ffe4e6;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --card-bg: #ffffff;
            --page-bg: #f8fafc;
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
            color: white;
            padding: 14px 24px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .admin-topbar .brand {
            color: white;
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
            color: var(--navy-primary);
        }

        /* Provider Header Card */
        .header-card {
            background: linear-gradient(135deg, var(--navy-primary) 0%, var(--navy-light) 100%);
            border-radius: 20px;
            padding: 32px;
            color: white;
            box-shadow: 0 12px 30px rgba(30, 27, 75, 0.15);
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
            background: rgba(244, 63, 94, 0.12);
            border-radius: 50%;
            pointer-events: none;
        }

        .avatar-box {
            width: 120px;
            height: 120px;
            border-radius: 20px;
            border: 4px solid rgba(255,255,255,0.25);
            overflow: hidden;
            background: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
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
        .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .status-READY_FOR_VERIFICATION { background: #e0f2fe; color: #075985; border: 1px solid #bae6fd; }
        .status-CHANGES_REQUESTED { background: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; }
        .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
        .status-REJECTED, .status-SUSPENDED { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        /* Progress Bar */
        .progress-wrap {
            background: rgba(255,255,255,0.15);
            border-radius: 50px;
            height: 10px;
            overflow: hidden;
            margin-top: 8px;
        }

        .progress-bar-fill {
            background: linear-gradient(90deg, #f43f5e, #10b981);
            height: 100%;
            border-radius: 50px;
            transition: width 0.6s ease;
        }

        /* Review Section Cards */
        .review-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 16px rgba(0,0,0,0.04);
            padding: 24px 28px;
            margin-bottom: 24px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
        }

        .section-header i {
            color: var(--coral-primary);
            font-size: 1.25rem;
        }

        .section-header h3 {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--navy-primary);
            margin: 0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 18px;
        }

        .info-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-field-label {
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
        }

        .info-field-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-dark);
            word-break: break-word;
        }

        .tag-pill {
            display: inline-block;
            background: #f1f5f9;
            color: var(--navy-primary);
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
            background: rgba(30, 27, 75, 0.94);
            backdrop-filter: blur(10px);
            padding: 16px 24px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            z-index: 900;
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
<body>

    <!-- Topbar -->
    <header class="admin-topbar">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear Admin Portal</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <span class="badge bg-light text-dark fw-bold px-3 py-2">Coach Profile Review</span>
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-outline-light">
                <i class="bi bi-box-arrow-right"></i> Sign Out
            </a>
        </div>
    </header>

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
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="${not empty trainer.profilePhotoPath}">
                            <img src="${trainer.profilePhotoPath.startsWith('http') ? trainer.profilePhotoPath : pageContext.request.contextPath.concat(trainer.profilePhotoPath)}" alt="${trainer.fullName}">
                        </c:when>
                        <c:otherwise>
                            <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light text-muted">
                                <i class="bi bi-person-fill" style="font-size: 3.5rem; color: #94a3b8;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
                        <h1 class="h3 fw-bold mb-0 text-white">${trainer.fullName}</h1>
                        <c:set var="statusKey" value="${trainer.partnerProfileStatus != null ? trainer.partnerProfileStatus : (trainer.verificationStatus == 'VERIFIED' ? 'APPROVED' : 'PENDING')}"/>
                        <span class="badge-status-lg status-${statusKey}">
                            <i class="bi ${statusKey == 'APPROVED' || statusKey == 'VERIFIED' ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            ${statusKey}
                        </span>
                        <c:if test="${trainer.suspended}">
                            <span class="badge bg-danger text-white px-3 py-1">SUSPENDED</span>
                        </c:if>
                    </div>

                    <div class="d-flex flex-wrap gap-4 text-white-50 small mb-3">
                        <div><i class="bi bi-award-fill text-white"></i> <strong>Designation:</strong> ${not empty trainer.designation ? trainer.designation : 'Fitness Coach'}</div>
                        <div><i class="bi bi-envelope-fill text-white"></i> <a href="mailto:${trainer.email}" class="text-white text-decoration-none">${trainer.email}</a></div>
                        <div><i class="bi bi-telephone-fill text-white"></i> <a href="tel:${trainer.phone}" class="text-white text-decoration-none">${trainer.phone}</a></div>
                        <div><i class="bi bi-geo-alt-fill text-white"></i> ${not empty trainer.city ? trainer.city : 'Location not set'}</div>
                    </div>

                    <!-- Profile Completion -->
                    <div class="mt-2" style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold text-white mb-1">
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
                <span class="small text-white-50 d-block">Admin Decision Workflow</span>
                <strong class="text-white">${trainer.fullName}</strong>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <!-- Approve -->
                <form action="${pageContext.request.contextPath}/admin/trainers/${trainer.id}/approve" method="post" class="m-0">
                    <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this fitness coach?');">
                        <i class="bi bi-check-lg me-1"></i> Approve Coach
                    </button>
                </form>

                <!-- Request Changes Trigger -->
                <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#trainerChangesModal">
                    <i class="bi bi-pencil me-1"></i> Request Changes
                </button>

                <!-- Reject Trigger -->
                <button type="button" class="btn-action-reject" data-bs-toggle="modal" data-bs-target="#trainerRejectModal">
                    <i class="bi bi-x-lg me-1"></i> Reject
                </button>
            </div>
        </div>

    </div>

    <!-- REQUEST CHANGES MODAL -->
    <div class="modal fade" id="trainerChangesModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/trainers/${trainer.id}/request-changes" method="post">
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
</body>
</html>
