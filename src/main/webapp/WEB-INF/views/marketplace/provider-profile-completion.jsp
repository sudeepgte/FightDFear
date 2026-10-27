<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Marketplace Provider Profile — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --primary-soft: #FFF1F2;
            --navy: #1E1B4B;
            --navy-light: #2E2A66;
            --text-dark: #0F172A;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --border-focus: #F43F5E;
            --success: #10B981;
            --success-bg: #ECFDF5;
            --warning: #F59E0B;
            --warning-bg: #FFFBEB;
            --error: #EF4444;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            line-height: 1.5;
        }

        /* Top Header Bar */
        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
        }

        .header-brand img {
            height: 34px;
            width: 34px;
            border-radius: 8px;
            object-fit: cover;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-skip:hover {
            background: #F1F5F9;
            border-color: #CBD5E1;
            color: var(--primary);
        }

        .btn-header-save {
            padding: 8px 18px;
            background: var(--navy);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-header-save:hover {
            background: var(--navy-light);
            transform: translateY(-1px);
        }

        .btn-header-logout {
            padding: 8px 14px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--text-gray);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-header-logout:hover {
            color: var(--error);
            border-color: #FCA5A5;
            background: var(--error-bg);
        }

        /* Centered Main Container */
        .main-container {
            flex: 1;
            max-width: 900px;
            width: 100%;
            margin: 28px auto 60px;
            padding: 0 20px;
        }

        /* Alerts & Notices */
        .alert-banner {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,0,0,0.03);
        }

        .alert-banner.success {
            background: #F0FDF4;
            color: #166534;
            border: 1px solid #BBF7D0;
        }

        .alert-banner.error {
            background: #FEF2F2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        /* Feedback Banner */
        .feedback-banner {
            background: #FFF7ED;
            border: 1px solid #FED7AA;
            border-left: 5px solid #EA580C;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }

        .feedback-banner i {
            color: #EA580C;
            font-size: 1.4rem;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .feedback-content h4 {
            color: #9A3412;
            font-size: 0.95rem;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .feedback-content p {
            color: #7C2D12;
            font-size: 0.88rem;
            margin: 0;
            line-height: 1.4;
        }

        /* Profile Progress Card */
        .profile-progress-card {
            background: #FFFFFF;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 22px 24px;
            margin-bottom: 20px;
            box-shadow: 0 4px 14px rgba(30, 27, 75, 0.03);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .progress-title {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-badge {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-approved { background: #DCFCE7; color: #166534; }
        .badge-changes { background: #FFEDD5; color: #9A3412; }
        .badge-rejected { background: #FEE2E2; color: #991B1B; }

        .progress-bar-container {
            width: 100%;
            height: 10px;
            background: #E2E8F0;
            border-radius: 20px;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E 0%, #10B981 100%);
            border-radius: 20px;
            transition: width 0.4s ease;
        }

        .missing-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .chip-missing {
            background: #FFF1F2;
            color: #E11D48;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            border: 1px solid #FECDD3;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
        }

        /* Top Action / Submit Verification Card */
        .submit-action-card {
            background: linear-gradient(135deg, #1E1B4B 0%, #312E81 100%);
            border-radius: 16px;
            padding: 20px 24px;
            color: #FFFFFF;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            box-shadow: 0 4px 20px rgba(30, 27, 75, 0.15);
        }

        .submit-info h3 {
            font-size: 1.1rem;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .submit-info p {
            font-size: 0.85rem;
            color: #C7D2FE;
            margin: 0;
        }

        .btn-submit-verification {
            padding: 12px 24px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.35);
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.45);
        }

        .btn-submit-verification:disabled {
            background: #475569;
            color: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            opacity: 0.85;
        }

        /* Section Cards */
        .section-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            transition: border-color 0.2s;
        }

        .section-card:hover {
            border-color: #CBD5E1;
        }

        .section-header {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-header i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 16px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 0.84rem;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--text-dark);
            background: #FFFFFF;
            transition: all 0.2s;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid, .file-upload-box.is-invalid {
            border-color: var(--error) !important;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.15) !important;
        }

        .form-input:read-only {
            background-color: #F8FAFC;
            color: #475569;
            cursor: not-allowed;
            border-color: #E2E8F0;
        }

        .form-hint {
            font-size: 0.78rem;
            color: var(--text-gray);
            margin-top: 4px;
        }

        .form-error {
            font-size: 0.78rem;
            color: var(--error);
            font-weight: 600;
            margin-top: 4px;
            display: none;
        }

        .form-error.show {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        @media (max-width: 650px) {
            .form-row { grid-template-columns: 1fr; }
            .submit-action-card { flex-direction: column; align-items: stretch; }
            .btn-submit-verification { justify-content: center; }
            .bottom-actions { flex-direction: column; }
        }

        /* Upload styling */
        .file-upload-box {
            border: 2px dashed #CBD5E1;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            background: #F8FAFC;
            cursor: pointer;
            transition: all 0.2s;
        }

        .file-upload-box:hover {
            border-color: var(--primary);
            background: #FFF1F2;
        }

        .file-upload-box.has-file {
            border-color: #10B981;
            background: #ECFDF5;
        }

        .file-upload-box i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 6px;
            display: inline-block;
        }

        .file-upload-box.has-file i {
            color: #10B981;
        }

        .file-upload-box p {
            font-size: 0.88rem;
            color: var(--navy);
            font-weight: 700;
            margin: 0 0 2px;
        }

        .file-upload-box span {
            font-size: 0.78rem;
            color: var(--text-gray);
        }

        /* Loading Spinner */
        .loader-inline {
            display: inline-block;
            font-size: 0.85rem;
            color: var(--primary);
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Bottom Action Buttons */
        .bottom-actions {
            margin-top: 32px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn-bottom-skip {
            padding: 14px 20px;
            background: #FFFFFF;
            color: var(--navy);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-bottom-skip:hover {
            background: #F1F5F9;
            color: var(--primary);
            border-color: #CBD5E1;
        }

        .btn-bottom-save {
            padding: 14px 22px;
            background: #FFFFFF;
            color: var(--navy);
            border: 2px solid var(--navy);
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-bottom-save:hover {
            background: #F1F5F9;
        }

        .btn-bottom-submit {
            flex: 1;
            padding: 14px 26px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.3);
        }

        .btn-bottom-submit:hover:not(:disabled) {
            background: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.4);
        }

        .btn-bottom-submit:disabled {
            background: #475569;
            color: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            opacity: 0.85;
        }
    </style>
</head>
<body>

    <!-- Sticky Top Header Bar -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear Marketplace</span>
        </a>
        <div class="header-actions">
            <!-- SKIP NOW BUTTON -->
            <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" class="btn-skip" id="btnSkipNow">
                <i class="bi bi-arrow-right-short" style="font-size: 1.1rem;"></i> Skip Now
            </a>
            <button type="button" class="btn-header-save" onclick="saveDraftDirectly()">
                <i class="bi bi-floppy"></i> Save Draft
            </button>
            <a href="${pageContext.request.contextPath}/logout" class="btn-header-logout" title="Sign Out">
                <i class="bi bi-box-arrow-right"></i> Sign out
            </a>
        </div>
    </header>

    <main class="main-container">

        <!-- Flash Status Alerts -->
        <c:if test="${not empty message}">
            <div class="alert-banner success">
                <i class="bi bi-check-circle-fill" style="font-size: 1.2rem;"></i>
                <span><c:out value="${message}"/></span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-banner error">
                <i class="bi bi-exclamation-triangle-fill" style="font-size: 1.2rem;"></i>
                <span><c:out value="${error}"/></span>
            </div>
        </c:if>

        <!-- Information Notice Banner -->
        <c:choose>
            <c:when test="${provider.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                <div class="alert-banner" style="background: #EFF6FF; color: #1E40AF; border: 1px solid #BFDBFE;">
                    <i class="bi bi-clock-history" style="font-size: 1.3rem; color: #2563EB;"></i>
                    <div style="flex: 1;">
                        <strong>Details Submitted — Pending Admin Verification:</strong> Your profile details have been submitted. Our admin team will verify your application and activate your dashboard features. You can make updates and re-submit details below if needed.
                    </div>
                    <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" style="color: #2563EB; font-weight: 700; text-decoration: underline; white-space: nowrap;">Go to Dashboard &rarr;</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert-banner" style="background: #FFF1F2; color: #9F1239; border: 1px solid #FECDD3;">
                    <i class="bi bi-info-circle-fill" style="font-size: 1.3rem; color: #E11D48;"></i>
                    <div style="flex: 1;">
                        <strong>First Submit Details:</strong> Please fill in your profile details below and click <strong>Submit Details</strong>. Once submitted, your profile will be sent to the administrator for verification. You can also click <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" style="color: #E11D48; font-weight: 800; text-decoration: underline;">Skip Now</a> to open your dashboard (features remain locked until verified).
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Admin Feedback Banner if Changes Requested -->
        <c:if test="${provider.partnerProfileStatus == 'CHANGES_REQUESTED' || provider.verificationStatus == 'CHANGES_REQUESTED' || not empty provider.changesRequestedNote || not empty provider.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Administrator Review Feedback</h4>
                    <p>
                        <c:choose>
                            <c:when test="${not empty provider.changesRequestedNote}">
                                <c:out value="${provider.changesRequestedNote}"/>
                            </c:when>
                            <c:when test="${not empty provider.rejectionReason}">
                                <c:out value="${provider.rejectionReason}"/>
                            </c:when>
                            <c:otherwise>
                                Please review your profile information, update the highlighted details below, and resubmit for verification.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </c:if>

        <!-- Dynamic Profile Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <span class="progress-title">
                    <i class="bi bi-speedometer2" style="color: var(--primary);"></i>
                    Profile Completion: <span id="pctText">${provider.profileCompletionPct != null ? provider.profileCompletionPct : 0}%</span>
                </span>
                <c:choose>
                    <c:when test="${provider.partnerProfileStatus == 'APPROVED' || provider.verificationStatus == 'VERIFIED'}">
                        <span class="status-badge badge-approved"><i class="bi bi-patch-check-fill me-1"></i> Verified Provider</span>
                    </c:when>
                    <c:when test="${provider.partnerProfileStatus == 'CHANGES_REQUESTED' || provider.verificationStatus == 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes"><i class="bi bi-pencil-square me-1"></i> Changes Requested</span>
                    </c:when>
                    <c:when test="${provider.partnerProfileStatus == 'READY_FOR_VERIFICATION' || provider.verificationStatus == 'RE_VERIFICATION'}">
                        <span class="status-badge badge-pending" style="background: #EEF2FF; color: #4338CA;"><i class="bi bi-arrow-repeat me-1"></i> Re-verification Queue</span>
                    </c:when>
                    <c:when test="${provider.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending"><i class="bi bi-clock-history me-1"></i> Submitted — Pending Verification</span>
                    </c:when>
                    <c:when test="${provider.partnerProfileStatus == 'REJECTED' || provider.verificationStatus == 'REJECTED'}">
                        <span class="status-badge badge-rejected"><i class="bi bi-x-circle me-1"></i> Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered"><i class="bi bi-pencil-square me-1"></i> Submit Details Required</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="progress-bar-container">
                <div id="progressBarFill" class="progress-bar-fill" style="width: ${provider.profileCompletionPct != null ? provider.profileCompletionPct : 0}%;"></div>
            </div>
            <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 6px;">
                Complete each required field below and click <strong>Submit Details</strong> for admin verification. You can click <strong>Skip Now</strong> to open your dashboard anytime (features remain locked until verified).
            </p>

            <!-- Dynamic Missing Items Chips -->
            <div id="missingChipsContainer" class="missing-chips">
                <c:if test="${empty provider.phone}"><span class="chip-missing" id="chip-phone"><i class="bi bi-exclamation-circle me-1"></i> Contact Phone</span></c:if>
                <c:if test="${empty provider.state}"><span class="chip-missing" id="chip-state"><i class="bi bi-exclamation-circle me-1"></i> State</span></c:if>
                <c:if test="${empty provider.city}"><span class="chip-missing" id="chip-city"><i class="bi bi-exclamation-circle me-1"></i> City / District</span></c:if>
                <c:if test="${empty provider.serviceArea and empty provider.address and empty provider.locationText}"><span class="chip-missing" id="chip-area"><i class="bi bi-exclamation-circle me-1"></i> Area / Locality</span></c:if>
                <c:if test="${empty provider.description or provider.description.length() < 15}"><span class="chip-missing" id="chip-bio"><i class="bi bi-exclamation-circle me-1"></i> Profile Bio (15+ chars)</span></c:if>
                <c:if test="${empty provider.identityDocumentPath}"><span class="chip-missing" id="chip-doc"><i class="bi bi-exclamation-circle me-1"></i> Verification Document</span></c:if>
                <c:if test="${empty provider.profilePhoto}"><span class="chip-missing" id="chip-photo"><i class="bi bi-exclamation-circle me-1"></i> Profile Photo</span></c:if>
            </div>
        </div>

        <!-- Top Verification Action Card -->
        <div class="submit-action-card">
            <div class="submit-info">
                <h3>Submit Details for Admin Verification</h3>
                <p>Fill out the required information below and click <strong>Submit Details</strong>. First submit your details, then our admin team will review and verify your account.</p>
            </div>
            <div>
                <button type="button" class="btn-submit-verification" id="topBtnSubmit" onclick="submitForVerification()">
                    <i class="bi bi-send-check-fill me-1"></i> Submit Details
                </button>
            </div>
        </div>

        <!-- Main Profile Form -->
        <form id="providerProfileForm" action="${pageContext.request.contextPath}/marketplace/provider/profile-completion" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="action" id="formActionInput" value="submit">
            <input type="hidden" name="locationText" id="inputLocationText" value="<c:out value='${provider.locationText}'/>">

            <!-- SECTION 0: Profile Photo & Visual Identity -->
            <div class="section-card" style="border: 2px solid #FBCFE8; background: linear-gradient(180deg, #FFFFFF 0%, #FFF5F7 100%);">
                <div class="section-header" style="color: var(--primary); border-bottom-color: #FECDD3;">
                    <i class="bi bi-camera-fill"></i> Professional Profile Photo &amp; Avatar
                </div>
                <div style="display: flex; align-items: center; gap: 24px; flex-wrap: wrap;">
                    <div style="position: relative; width: 110px; height: 110px; flex-shrink: 0;">
                        <c:choose>
                            <c:when test="${not empty provider.profilePhoto}">
                                <img id="profilePhotoPreview" src="${pageContext.request.contextPath}${provider.profilePhoto}" 
                                     alt="Provider Profile Photo" 
                                     style="width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid #F43F5E; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                            </c:when>
                            <c:otherwise>
                                <img id="profilePhotoPreview" src="" alt="Provider Profile Photo" 
                                     style="display: none; width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid #F43F5E; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                                <div id="profilePhotoFallback" 
                                     style="width: 110px; height: 110px; border-radius: 50%; background: #FFE4E6; color: #F43F5E; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; border: 4px solid #FECDD3;">
                                    ${not empty provider.fullName ? provider.fullName.substring(0, 1).toUpperCase() : 'P'}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="flex: 1; min-width: 240px;">
                        <h4 style="font-size: 1rem; font-weight: 800; color: var(--navy); margin: 0 0 4px;">Upload Profile Photo</h4>
                        <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0 0 12px; line-height: 1.4;">
                            A professional, friendly photo significantly boosts client trust and booking inquiries. Accepts JPG, PNG, or WebP (max 5MB).
                        </p>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                            <label for="profilePhotoFile" style="background: var(--primary); color: white; padding: 9px 18px; border-radius: 10px; font-size: 0.85rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; margin: 0; transition: background 0.2s;">
                                <i class="bi bi-upload"></i> Choose Photo
                            </label>
                            <input type="file" id="profilePhotoFile" name="profilePhotoFile" accept="image/*" style="display: none;" onchange="previewSelectedPhoto(this)">
                            <button type="button" id="btnClearPhoto" onclick="clearSelectedPhoto()" style="display: none; background: white; border: 1px solid #E2E8F0; color: var(--text-gray); padding: 8px 14px; border-radius: 10px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                <i class="bi bi-x-circle"></i> Remove Selection
                            </button>
                        </div>
                        <div class="form-error" id="err-photo"></div>
                    </div>
                </div>
            </div>

            <!-- SECTION 1: Account Identity & Contact -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-person-badge-fill"></i> 1. Account Details &amp; Primary Identity
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.1 Full Name (Registered Account) *</label>
                        <input type="text" id="inputFullName" class="form-input" value="<c:out value='${provider.fullName}'/>" readonly>
                        <div class="form-hint"><i class="bi bi-lock-fill text-muted"></i> Populated automatically from your registered account.</div>
                    </div>

                    <div class="form-group">
                        <label>1.2 Email Address (Registered Account) *</label>
                        <div style="position: relative;">
                            <input type="email" id="inputEmail" class="form-input" value="<c:out value='${provider.email}'/>" readonly style="padding-right: 120px;">
                            <span style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: #ECFDF5; color: #10B981; border: 1px solid #BBF7D0; font-size: 0.72rem; font-weight: 700; padding: 3px 8px; border-radius: 6px; display: inline-flex; align-items: center; gap: 4px;">
                                <i class="bi bi-patch-check-fill"></i> Verified
                            </span>
                        </div>
                        <div class="form-hint"><i class="bi bi-shield-check text-success"></i> Primary communication and login ID.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="inputCategory">1.3 Service Category *</label>
                        <select name="category" id="inputCategory" class="form-select" onchange="validateCategoryField()">
                            <option value="">-- Select Service Category --</option>
                            <c:forEach items="${providerCategories}" var="cat">
                                <option value="${cat.name()}" ${provider.category eq cat ? 'selected' : ''}>
                                    ${cat.displayName}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="form-hint">Pre-selected from registration. You can update if your specialization changed.</div>
                        <div class="form-error" id="err-category"><i class="bi bi-exclamation-circle-fill"></i> Please select a valid service category.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputPhone">1.4 Official Contact Phone (10 digits) *</label>
                        <input type="tel" name="phone" id="inputPhone" class="form-input" value="<c:out value='${provider.phone}'/>" 
                               maxlength="10" placeholder="e.g. 9876543210" required 
                               oninput="cleanPhoneInput(this); validatePhoneField();"
                               onblur="validatePhoneField();">
                        <div class="form-hint">Must be 10 numeric digits. Used for booking alerts and verification.</div>
                        <div class="form-error" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Phone number is required and must be exactly 10 digits.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="inputBusinessName">1.5 Business / Brand / Studio Name (Optional)</label>
                        <input type="text" name="businessName" id="inputBusinessName" class="form-input" 
                               value="<c:out value='${provider.businessName}'/>" placeholder="e.g. Ananya Health & Fitness Studio" oninput="triggerRecalculateProgress()">
                    </div>

                    <div class="form-group">
                        <label for="inputFee">1.6 Starting Consultation / Service Fee (₹)</label>
                        <input type="number" name="consultationFee" id="inputFee" class="form-input" 
                               value="${provider.consultationFee}" min="0" step="1" placeholder="e.g. 500">
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Location & Service Coverage (Dependent Cascading Dropdowns) -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-geo-alt-fill"></i> 2. Location &amp; Service Coverage
                </div>
                <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 14px;">
                    Select your state, district/city, and area so nearby clients can find and book your services.
                </p>

                <div class="form-row">
                    <div class="form-group">
                        <label for="selectState">2.1 State / Union Territory *</label>
                        <select name="state" id="selectState" class="form-select" required onchange="handleStateChange()" onblur="validateStateField()">
                            <option value="">-- Select State / UT --</option>
                            <c:forEach items="${indianStates}" var="st">
                                <option value="${st}" ${provider.state eq st ? 'selected' : ''}>${st}</option>
                            </c:forEach>
                        </select>
                        <div class="form-error" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> Please select your State / Union Territory.</div>
                    </div>

                    <div class="form-group">
                        <label for="selectCity">
                            2.2 City / District *
                            <span id="citySpinner" class="loader-inline" style="display: none; margin-left: 6px;"><i class="bi bi-arrow-repeat"></i></span>
                        </label>
                        <select name="city" id="selectCity" class="form-select" required onchange="handleCityChange()" onblur="validateCityField()" disabled>
                            <option value="">-- Select State First --</option>
                        </select>
                        <div class="form-error" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> Please select your City / District.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="selectArea">
                            2.3 Area / Locality *
                            <span id="areaSpinner" class="loader-inline" style="display: none; margin-left: 6px;"><i class="bi bi-arrow-repeat"></i></span>
                        </label>
                        <select id="selectArea" class="form-select" onchange="handleAreaSelectChange()" onblur="validateAreaField()" disabled>
                            <option value="">-- Select City First --</option>
                        </select>

                        <!-- Fallback / Custom Area Input (Shown if 'OTHER' selected or manual input needed) -->
                        <div id="customAreaContainer" style="display: none; margin-top: 8px;">
                            <input type="text" id="inputCustomArea" class="form-input" placeholder="Type your specific area / locality name" oninput="handleCustomAreaInput()" onblur="validateAreaField()">
                        </div>

                        <!-- Real submitted serviceArea value -->
                        <input type="hidden" name="serviceArea" id="inputServiceArea" value="<c:out value='${provider.serviceArea}'/>">
                        <div class="form-error" id="err-area"><i class="bi bi-exclamation-circle-fill"></i> Area / Locality is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputPincode">2.4 Pincode (6 digits)</label>
                        <input type="text" name="pincode" id="inputPincode" class="form-input" 
                               value="<c:out value='${provider.pincode}'/>" maxlength="6" placeholder="e.g. 400050" 
                               oninput="cleanPincodeInput(this); validatePincodeField();"
                               onblur="validatePincodeField();">
                        <div class="form-error" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Pincode must be 6 numeric digits.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="inputAddress">2.5 Street Address / Landmark / Studio Address</label>
                    <input type="text" name="address" id="inputAddress" class="form-input" 
                           value="<c:out value='${provider.address}'/>" placeholder="Flat / Shop No., Building Name, Street / Road, Landmark" oninput="triggerRecalculateProgress()">
                    <div class="form-hint">Used for client appointments and service delivery.</div>
                </div>
            </div>

            <!-- SECTION 3: Professional Experience & Profile Bio -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-file-earmark-person-fill"></i> 3. Professional Bio &amp; Offerings
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <label for="inputDescription" style="margin-bottom: 0;">3.1 Profile Bio &amp; Service Description *</label>
                        <span style="font-size: 0.76rem; color: var(--text-gray);" id="bioCounter">0 / 15 min chars</span>
                    </div>
                    <textarea name="description" id="inputDescription" class="form-textarea" rows="4" 
                              placeholder="Describe your expertise, teaching/service methodology, qualifications, years of experience, and how you assist women..." 
                              required 
                              oninput="validateDescriptionField()"
                              onblur="validateDescriptionField()"><c:out value="${provider.description}"/></textarea>
                    <div class="form-error" id="err-description"><i class="bi bi-exclamation-circle-fill"></i> Profile bio is required and must be at least 15 characters.</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="inputQualification">3.2 Qualifications / Certifications</label>
                        <input type="text" name="qualification" id="inputQualification" class="form-input" 
                               value="<c:out value='${provider.qualification}'/>" placeholder="e.g. Certified Nutritionist, RYT-500, Diploma" oninput="triggerRecalculateProgress()">
                    </div>

                    <div class="form-group">
                        <label for="inputExperience">3.3 Years of Experience</label>
                        <input type="text" name="experience" id="inputExperience" class="form-input" 
                               value="<c:out value='${provider.experience}'/>" placeholder="e.g. 5+ Years" oninput="triggerRecalculateProgress()">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="inputAvailableDays">3.4 Available Working Days</label>
                        <input type="text" name="availableDays" id="inputAvailableDays" class="form-input" 
                               value="<c:out value='${not empty provider.availableDays ? provider.availableDays : "Mon - Sat"}'/>" placeholder="e.g. Mon - Sat, Weekdays">
                    </div>

                    <div class="form-group">
                        <label for="inputLanguages">3.5 Languages Spoken</label>
                        <input type="text" name="languagesSpoken" id="inputLanguages" class="form-input" 
                               value="<c:out value='${not empty provider.languagesSpoken ? provider.languagesSpoken : "English, Hindi"}'/>" placeholder="e.g. English, Hindi, Marathi">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="inputHoursFrom">3.6 Working Hours From</label>
                        <input type="text" name="workingHoursFrom" id="inputHoursFrom" class="form-input" 
                               value="<c:out value='${not empty provider.workingHoursFrom ? provider.workingHoursFrom : "09:00 AM"}'/>" placeholder="e.g. 09:00 AM">
                    </div>

                    <div class="form-group">
                        <label for="inputHoursTo">3.7 Working Hours To</label>
                        <input type="text" name="workingHoursTo" id="inputHoursTo" class="form-input" 
                               value="<c:out value='${not empty provider.workingHoursTo ? provider.workingHoursTo : "07:00 PM"}'/>" placeholder="e.g. 07:00 PM">
                    </div>
                </div>
            </div>

            <!-- SECTION 4: Document Verification -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-shield-check"></i> 4. Identity &amp; Professional Verification Documents
                </div>
                <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 14px;">
                    Upload government ID or professional certificate to speed up administrator verification. Accepts PDF, JPG, or PNG (maximum 5MB).
                </p>

                <div class="form-group">
                    <input type="file" id="identityDoc" name="identityDoc" accept=".pdf,image/jpeg,image/png" style="display: none;" onchange="handleIdentityDocChange(this)">
                    <div class="file-upload-box ${not empty provider.identityDocumentPath ? 'has-file' : ''}" id="idDocBox" onclick="document.getElementById('identityDoc').click()">
                        <i class="bi ${not empty provider.identityDocumentPath ? 'bi-check-circle-fill' : 'bi-file-earmark-arrow-up'}"></i>
                        <p id="idDocFileName">
                            ${not empty provider.identityDocumentPath ? 'Verification Document on File (Click to replace)' : 'Click to upload Government ID / Certificate'}
                        </p>
                        <span id="idDocSubtitle">PDF, JPG, or PNG up to 5MB</span>
                    </div>
                    <div class="form-error" id="err-doc"><i class="bi bi-exclamation-circle-fill"></i> Please upload a valid verification document (PDF, JPG, or PNG, max 5MB).</div>
                </div>
            </div>

            <!-- Bottom Actions -->
            <div class="bottom-actions">
                <!-- SKIP NOW BUTTON -->
                <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" class="btn-bottom-skip" id="btnBottomSkipNow">
                    <i class="bi bi-arrow-right-circle me-1"></i> Skip Now
                </a>
                <button type="button" class="btn-bottom-save" onclick="saveDraftDirectly()">
                    <i class="bi bi-floppy me-1"></i> Save Draft
                </button>
                <button type="button" class="btn-bottom-submit" id="bottomBtnSubmit" onclick="submitForVerification()">
                    <i class="bi bi-send-check-fill me-1"></i> Submit Details
                </button>
            </div>
        </form>

    </main>

    <script>
        // Saved state from backend
        const initialSavedState = "<c:out value='${provider.state}'/>";
        const initialSavedCity = "<c:out value='${provider.city}'/>";
        const initialSavedArea = "<c:out value='${provider.serviceArea}'/>";
        const hasExistingDocument = "${not empty provider.identityDocumentPath}" === "true";
        const contextPath = "${pageContext.request.contextPath}";

        // --- REAL-TIME FIELD VALIDATORS ---

        function cleanPhoneInput(el) {
            el.value = el.value.replace(/\D/g, '').substring(0, 10);
        }

        function cleanPincodeInput(el) {
            el.value = el.value.replace(/\D/g, '').substring(0, 6);
        }

        function validatePhoneField() {
            const phone = document.getElementById('inputPhone').value.trim();
            if (!phone) {
                showFieldError('err-phone', 'inputPhone', 'Official contact phone is required.');
                return false;
            }
            if (!/^\d{10}$/.test(phone)) {
                showFieldError('err-phone', 'inputPhone', 'Phone number must be exactly 10 digits.');
                return false;
            }
            clearFieldError('err-phone', 'inputPhone');
            triggerRecalculateProgress();
            return true;
        }

        function validateCategoryField() {
            const cat = document.getElementById('inputCategory').value;
            if (!cat) {
                showFieldError('err-category', 'inputCategory', 'Please select a service category.');
                return false;
            }
            clearFieldError('err-category', 'inputCategory');
            triggerRecalculateProgress();
            return true;
        }

        function validateStateField() {
            const state = document.getElementById('selectState').value;
            if (!state) {
                showFieldError('err-state', 'selectState', 'Please select your State / Union Territory.');
                return false;
            }
            clearFieldError('err-state', 'selectState');
            triggerRecalculateProgress();
            return true;
        }

        function validateCityField() {
            const city = document.getElementById('selectCity').value;
            if (!city) {
                showFieldError('err-city', 'selectCity', 'Please select your City / District.');
                return false;
            }
            clearFieldError('err-city', 'selectCity');
            triggerRecalculateProgress();
            return true;
        }

        function validateAreaField() {
            const area = document.getElementById('inputServiceArea').value.trim();
            if (!area) {
                const areaSelect = document.getElementById('selectArea');
                const targetInput = (areaSelect.value === 'OTHER') ? 'inputCustomArea' : 'selectArea';
                showFieldError('err-area', targetInput, 'Area / Locality is required.');
                return false;
            }
            clearFieldError('err-area', 'selectArea');
            clearFieldError('err-area', 'inputCustomArea');
            triggerRecalculateProgress();
            return true;
        }

        function validatePincodeField() {
            const pincode = document.getElementById('inputPincode').value.trim();
            if (pincode && !/^\d{6}$/.test(pincode)) {
                showFieldError('err-pincode', 'inputPincode', 'Pincode must be 6 numeric digits.');
                return false;
            }
            clearFieldError('err-pincode', 'inputPincode');
            triggerRecalculateProgress();
            return true;
        }

        function validateDescriptionField() {
            const desc = document.getElementById('inputDescription').value.trim();
            document.getElementById('bioCounter').textContent = desc.length + ' / 15 min chars';
            if (desc.length < 15) {
                showFieldError('err-description', 'inputDescription', 'Profile Bio must be at least 15 characters (currently ' + desc.length + ').');
                return false;
            }
            clearFieldError('err-description', 'inputDescription');
            triggerRecalculateProgress();
            return true;
        }

        function validateDocumentField() {
            const fileInput = document.getElementById('identityDoc');
            const hasNewFile = fileInput.files && fileInput.files.length > 0;
            if (!hasExistingDocument && !hasNewFile) {
                showFieldError('err-doc', 'idDocBox', 'Verification document is required for administrator review.');
                return false;
            }
            clearFieldError('err-doc', 'idDocBox');
            return true;
        }

        // --- CASCADING LOCATION LOGIC ---

        async function fetchCities(stateName) {
            const citySelect = document.getElementById('selectCity');
            const citySpinner = document.getElementById('citySpinner');
            citySpinner.style.display = 'inline-block';
            citySelect.disabled = true;
            citySelect.innerHTML = '<option value="">Loading cities...</option>';

            try {
                const res = await fetch(contextPath + '/api/locations/cities?state=' + encodeURIComponent(stateName));
                const data = await res.json();
                citySelect.innerHTML = '<option value="">-- Select City / District --</option>';
                if (data.success && data.cities && data.cities.length > 0) {
                    data.cities.forEach(c => {
                        const opt = document.createElement('option');
                        opt.value = c;
                        opt.textContent = c;
                        citySelect.appendChild(opt);
                    });
                    citySelect.disabled = false;
                } else {
                    citySelect.innerHTML = '<option value="">No predefined cities found (Select Other)</option>';
                    citySelect.disabled = false;
                }
            } catch (err) {
                console.error('Failed to load cities:', err);
                citySelect.innerHTML = '<option value="">Error loading cities</option>';
            } finally {
                citySpinner.style.display = 'none';
            }
        }

        async function fetchAreas(stateName, cityName) {
            const areaSelect = document.getElementById('selectArea');
            const areaSpinner = document.getElementById('areaSpinner');
            areaSpinner.style.display = 'inline-block';
            areaSelect.disabled = true;
            areaSelect.innerHTML = '<option value="">Loading localities...</option>';

            try {
                const res = await fetch(contextPath + '/api/locations/areas?state=' + encodeURIComponent(stateName) + '&city=' + encodeURIComponent(cityName));
                const data = await res.json();
                areaSelect.innerHTML = '<option value="">-- Select Area / Locality --</option>';

                let hasAreas = false;
                if (data.success && data.areas && data.areas.length > 0) {
                    hasAreas = true;
                    data.areas.forEach(a => {
                        const opt = document.createElement('option');
                        opt.value = a;
                        opt.textContent = a;
                        areaSelect.appendChild(opt);
                    });
                }

                // Add "Other / Enter custom locality"
                const otherOpt = document.createElement('option');
                otherOpt.value = 'OTHER';
                otherOpt.textContent = 'Other / Enter Custom Locality...';
                areaSelect.appendChild(otherOpt);

                areaSelect.disabled = false;

                // If no predefined areas exist, automatically show custom input
                if (!hasAreas) {
                    areaSelect.value = 'OTHER';
                    handleAreaSelectChange();
                }
            } catch (err) {
                console.error('Failed to load areas:', err);
                areaSelect.innerHTML = '<option value="OTHER">Other / Enter Custom Locality</option>';
                areaSelect.disabled = false;
                handleAreaSelectChange();
            } finally {
                areaSpinner.style.display = 'none';
            }
        }

        async function handleStateChange() {
            const state = document.getElementById('selectState').value;
            const citySelect = document.getElementById('selectCity');
            const areaSelect = document.getElementById('selectArea');
            const customAreaContainer = document.getElementById('customAreaContainer');
            const inputServiceArea = document.getElementById('inputServiceArea');

            // Reset dependent dropdowns
            citySelect.innerHTML = '<option value="">-- Select City / District --</option>';
            citySelect.disabled = true;
            areaSelect.innerHTML = '<option value="">-- Select City First --</option>';
            areaSelect.disabled = true;
            customAreaContainer.style.display = 'none';
            inputServiceArea.value = '';

            clearFieldError('err-state', 'selectState');

            if (state) {
                await fetchCities(state);
            } else {
                showFieldError('err-state', 'selectState', 'Please select your State / Union Territory.');
            }
            updateLocationTextSummary();
            triggerRecalculateProgress();
        }

        async function handleCityChange() {
            const state = document.getElementById('selectState').value;
            const city = document.getElementById('selectCity').value;
            const areaSelect = document.getElementById('selectArea');
            const customAreaContainer = document.getElementById('customAreaContainer');
            const inputServiceArea = document.getElementById('inputServiceArea');

            areaSelect.innerHTML = '<option value="">-- Select Area / Locality --</option>';
            areaSelect.disabled = true;
            customAreaContainer.style.display = 'none';
            inputServiceArea.value = '';

            clearFieldError('err-city', 'selectCity');

            if (state && city) {
                await fetchAreas(state, city);
            } else {
                showFieldError('err-city', 'selectCity', 'Please select your City / District.');
            }
            updateLocationTextSummary();
            triggerRecalculateProgress();
        }

        function handleAreaSelectChange() {
            const areaSelect = document.getElementById('selectArea');
            const customAreaContainer = document.getElementById('customAreaContainer');
            const inputCustomArea = document.getElementById('inputCustomArea');
            const inputServiceArea = document.getElementById('inputServiceArea');

            clearFieldError('err-area', 'selectArea');

            if (areaSelect.value === 'OTHER') {
                customAreaContainer.style.display = 'block';
                inputServiceArea.value = inputCustomArea.value.trim();
                inputCustomArea.focus();
            } else if (areaSelect.value) {
                customAreaContainer.style.display = 'none';
                inputServiceArea.value = areaSelect.value;
            } else {
                customAreaContainer.style.display = 'none';
                inputServiceArea.value = '';
            }
            validateAreaField();
            updateLocationTextSummary();
            triggerRecalculateProgress();
        }

        function handleCustomAreaInput() {
            const inputCustomArea = document.getElementById('inputCustomArea');
            const inputServiceArea = document.getElementById('inputServiceArea');
            inputServiceArea.value = inputCustomArea.value.trim();
            validateAreaField();
            updateLocationTextSummary();
            triggerRecalculateProgress();
        }

        function updateLocationTextSummary() {
            const state = document.getElementById('selectState').value;
            const city = document.getElementById('selectCity').value;
            const area = document.getElementById('inputServiceArea').value;
            const address = document.getElementById('inputAddress').value;

            const parts = [];
            if (address && address.trim()) parts.push(address.trim());
            if (area && area.trim()) parts.push(area.trim());
            if (city && city.trim()) parts.push(city.trim());
            if (state && state.trim()) parts.push(state.trim());

            document.getElementById('inputLocationText').value = parts.join(', ');
        }

        // Initialize location cascade if saved values exist
        async function initLocationCascade() {
            if (initialSavedState) {
                document.getElementById('selectState').value = initialSavedState;
                await fetchCities(initialSavedState);

                if (initialSavedCity) {
                    const citySelect = document.getElementById('selectCity');
                    citySelect.value = initialSavedCity;
                    await fetchAreas(initialSavedState, initialSavedCity);

                    if (initialSavedArea) {
                        const areaSelect = document.getElementById('selectArea');
                        let matched = false;
                        for (let i = 0; i < areaSelect.options.length; i++) {
                            if (areaSelect.options[i].value.toLowerCase() === initialSavedArea.toLowerCase()) {
                                areaSelect.selectedIndex = i;
                                matched = true;
                                break;
                            }
                        }
                        if (!matched) {
                            areaSelect.value = 'OTHER';
                            document.getElementById('customAreaContainer').style.display = 'block';
                            document.getElementById('inputCustomArea').value = initialSavedArea;
                        }
                        document.getElementById('inputServiceArea').value = initialSavedArea;
                    }
                }
            }
            updateLocationTextSummary();
            triggerRecalculateProgress();
        }

        // --- PHOTO & DOCUMENT PREVIEWS & VALIDATION ---

        function previewSelectedPhoto(input) {
            clearFieldError('err-photo', 'profilePhotoFile');
            if (input.files && input.files[0]) {
                const file = input.files[0];
                if (!file.type.startsWith('image/')) {
                    showFieldError('err-photo', 'profilePhotoFile', 'Please choose a valid image file (JPG, PNG, or WEBP).');
                    input.value = '';
                    return;
                }
                if (file.size > 5 * 1024 * 1024) {
                    showFieldError('err-photo', 'profilePhotoFile', 'Image file is too large (maximum 5MB).');
                    input.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('profilePhotoPreview');
                    const fallback = document.getElementById('profilePhotoFallback');
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    if (fallback) fallback.style.display = 'none';
                    document.getElementById('btnClearPhoto').style.display = 'inline-flex';
                };
                reader.readAsDataURL(file);
                triggerRecalculateProgress();
            }
        }

        function clearSelectedPhoto() {
            const input = document.getElementById('profilePhotoFile');
            input.value = '';
            const preview = document.getElementById('profilePhotoPreview');
            const fallback = document.getElementById('profilePhotoFallback');
            const existingPhoto = "${provider.profilePhoto}";
            if (existingPhoto) {
                preview.src = contextPath + existingPhoto;
                preview.style.display = 'block';
                if (fallback) fallback.style.display = 'none';
            } else {
                preview.style.display = 'none';
                if (fallback) fallback.style.display = 'flex';
            }
            document.getElementById('btnClearPhoto').style.display = 'none';
            triggerRecalculateProgress();
        }

        function handleIdentityDocChange(input) {
            clearFieldError('err-doc', 'idDocBox');
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const validTypes = ['application/pdf', 'image/jpeg', 'image/png', 'image/jpg'];
                const ext = file.name.split('.').pop().toLowerCase();
                const isValidExt = ['pdf', 'jpg', 'jpeg', 'png'].includes(ext);

                if (!validTypes.includes(file.type) && !isValidExt) {
                    showFieldError('err-doc', 'idDocBox', 'Invalid file type. Only PDF, JPG, and PNG are accepted.');
                    input.value = '';
                    return;
                }

                if (file.size > 5 * 1024 * 1024) {
                    showFieldError('err-doc', 'idDocBox', 'File size exceeds 5MB limit (' + (file.size / (1024 * 1024)).toFixed(1) + 'MB).');
                    input.value = '';
                    return;
                }

                document.getElementById('idDocFileName').textContent = file.name;
                document.getElementById('idDocSubtitle').textContent = (file.size / 1024).toFixed(0) + ' KB — Ready for upload';
                document.getElementById('idDocBox').classList.add('has-file');
                const icon = document.querySelector('#idDocBox i');
                icon.className = 'bi bi-check-circle-fill';
                triggerRecalculateProgress();
            }
        }

        // --- DYNAMIC PROGRESS RECALCULATION ---

        function triggerRecalculateProgress() {
            let score = 0;

            // 1. Full name
            score += 10;
            // 2. Email
            score += 10;
            // 3. Category
            const cat = document.getElementById('inputCategory').value;
            if (cat) score += 10;

            // 4. Phone
            const phone = document.getElementById('inputPhone').value.trim();
            const phoneValid = /^\d{10}$/.test(phone);
            if (phoneValid) {
                score += 10;
                hideChip('chip-phone');
            } else {
                showChip('chip-phone');
            }

            // 5. State
            const state = document.getElementById('selectState').value.trim();
            if (state) {
                score += 10;
                hideChip('chip-state');
            } else {
                showChip('chip-state');
            }

            // 6. City
            const city = document.getElementById('selectCity').value.trim();
            if (city) {
                score += 10;
                hideChip('chip-city');
            } else {
                showChip('chip-city');
            }

            // 7. Area / Address
            const area = document.getElementById('inputServiceArea').value.trim();
            const address = document.getElementById('inputAddress').value.trim();
            if (area || address) {
                score += 10;
                hideChip('chip-area');
            } else {
                showChip('chip-area');
            }

            // 8. Description Bio
            const desc = document.getElementById('inputDescription').value.trim();
            document.getElementById('bioCounter').textContent = desc.length + ' / 15 min chars';
            if (desc.length >= 15) {
                score += 10;
                hideChip('chip-bio');
            } else {
                showChip('chip-bio');
            }

            // 9. Qualifications / Experience / Business Name
            const qual = document.getElementById('inputQualification').value.trim();
            const exp = document.getElementById('inputExperience').value.trim();
            const bName = document.getElementById('inputBusinessName').value.trim();
            if (qual || exp || bName) {
                score += 10;
            }

            // 10. Document / Photo
            const newDoc = document.getElementById('identityDoc').files.length > 0;
            const hasExistingPhoto = "${not empty provider.profilePhoto}" === "true";
            const newPhoto = document.getElementById('profilePhotoFile').files.length > 0;

            if (hasExistingDocument || newDoc) {
                hideChip('chip-doc');
            } else {
                showChip('chip-doc');
            }

            if (hasExistingPhoto || newPhoto) {
                hideChip('chip-photo');
            } else {
                showChip('chip-photo');
            }

            if (hasExistingDocument || newDoc || hasExistingPhoto || newPhoto) {
                score += 10;
            }

            const pct = Math.min(100, score);
            document.getElementById('pctText').textContent = pct + '%';
            document.getElementById('progressBarFill').style.width = pct + '%';
        }

        function showChip(id) {
            const el = document.getElementById(id);
            if (el) el.style.display = 'inline-flex';
        }

        function hideChip(id) {
            const el = document.getElementById(id);
            if (el) el.style.display = 'none';
        }

        function showFieldError(errorId, inputId, msg) {
            const errEl = document.getElementById(errorId);
            if (errEl) {
                if (msg) errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + msg;
                errEl.classList.add('show');
            }
            const inputEl = document.getElementById(inputId);
            if (inputEl) inputEl.classList.add('is-invalid');
        }

        function clearFieldError(errorId, inputId) {
            const errEl = document.getElementById(errorId);
            if (errEl) errEl.classList.remove('show');
            const inputEl = document.getElementById(inputId);
            if (inputEl) inputEl.classList.remove('is-invalid');
        }

        // --- SUBMISSION ACTIONS ---

        function saveDraftDirectly() {
            updateLocationTextSummary();
            document.getElementById('formActionInput').value = 'draft';
            document.getElementById('providerProfileForm').submit();
        }

        function submitForVerification() {
            updateLocationTextSummary();
            let isValid = true;
            let firstInvalidEl = null;

            // 1. Validate Category
            if (!validateCategoryField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('inputCategory');
            }

            // 2. Validate Phone
            if (!validatePhoneField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('inputPhone');
            }

            // 3. Validate State
            if (!validateStateField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('selectState');
            }

            // 4. Validate City
            if (!validateCityField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('selectCity');
            }

            // 5. Validate Area
            if (!validateAreaField()) {
                isValid = false;
                const areaSelect = document.getElementById('selectArea');
                if (!firstInvalidEl) firstInvalidEl = (areaSelect.value === 'OTHER') ? document.getElementById('inputCustomArea') : areaSelect;
            }

            // 6. Validate Pincode
            if (!validatePincodeField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('inputPincode');
            }

            // 7. Validate Bio Description
            if (!validateDescriptionField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('inputDescription');
            }

            // 8. Validate Document
            if (!validateDocumentField()) {
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById('idDocBox');
            }

            if (!isValid) {
                if (firstInvalidEl) {
                    firstInvalidEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    if (typeof firstInvalidEl.focus === 'function') {
                        firstInvalidEl.focus();
                    }
                }
                return;
            }

            // Disable buttons to prevent duplicate submission
            const topBtn = document.getElementById('topBtnSubmit');
            const bottomBtn = document.getElementById('bottomBtnSubmit');
            if (topBtn) {
                topBtn.disabled = true;
                topBtn.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Submitting Details...';
            }
            if (bottomBtn) {
                bottomBtn.disabled = true;
                bottomBtn.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Submitting Details...';
            }

            document.getElementById('formActionInput').value = 'submit';
            document.getElementById('providerProfileForm').submit();
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            initLocationCascade();
            triggerRecalculateProgress();
        });
    </script>
</body>
</html>
