<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Complete Seller Profile — Fight D Fear Shop</title>

    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Leaflet Map CSS for Map Picker (CSP Compliant) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">

    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --rose-soft: #FFF1F2;
            --rose-light: #FFE4E6;
            --rose-border: #FECDD3;
            --navy: #0F172A;
            --navy-light: #1E293B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --warning: #C2410C;
            --warning-bg: #FFF7ED;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.03);
            --shadow-float: 0 10px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.04);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { overflow-x: hidden; scroll-behavior: smooth; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Top App Header */
        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px clamp(16px, 3vw, 40px);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            gap: 12px;
            flex-wrap: wrap;
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

        .header-brand .portal-badge {
            font-size: 0.72rem;
            font-weight: 700;
            background: var(--rose-soft);
            color: var(--primary);
            border: 1px solid var(--rose-border);
            padding: 3px 8px;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-skip, .btn-primary, .btn-secondary {
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            padding: 9px 18px;
            cursor: pointer;
            font-family: inherit;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .btn-skip {
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
        }

        .btn-skip:hover {
            background: var(--bg-page);
            border-color: #CBD5E1;
        }

        .btn-primary {
            border: none;
            background: var(--primary);
            color: #FFFFFF;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
        }

        .btn-secondary:hover {
            background: #F1F5F9;
        }

        /* Main Container */
        .main-container {
            flex: 1;
            width: 100%;
            max-width: 1380px;
            margin: 24px auto 48px;
            padding: 0 clamp(16px, 2.5vw, 36px);
        }

        /* 2-Column Responsive Layout */
        .profile-layout-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 390px;
            gap: 28px;
            align-items: start;
        }

        @media (max-width: 1024px) {
            .profile-layout-grid {
                grid-template-columns: 1fr;
            }
            .preview-column {
                order: 2;
            }
        }

        /* Section Cards */
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: clamp(18px, 2.5vw, 26px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
            transition: border-color 0.2s ease;
        }

        .section-card:hover {
            border-color: #CBD5E1;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .section-header i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .section-desc {
            font-size: 0.84rem;
            color: var(--text-gray);
            margin-bottom: 18px;
            line-height: 1.45;
        }

        /* Progress Card */
        .profile-progress-card {
            background: #FFFFFF;
            border-radius: 18px;
            border: 1px solid var(--border-color);
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            gap: 12px;
            flex-wrap: wrap;
        }

        .progress-title-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-title {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
        }

        .pct-badge {
            font-size: 0.88rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--rose-soft);
            border: 1px solid var(--rose-border);
            padding: 2px 10px;
            border-radius: 20px;
        }

        .status-badge {
            font-size: 0.74rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-registered { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; }
        .badge-pending { background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A; }
        .badge-approved { background: var(--success-bg); color: var(--success); border: 1px solid #BBF7D0; }
        .badge-rejected { background: var(--error-bg); color: var(--error); border: 1px solid #FECACA; }
        .badge-incomplete { background: #F8FAFC; color: #64748B; border: 1px solid var(--border-color); }

        .progress-bar-container {
            height: 10px;
            background: #E2E8F0;
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E 0%, #FB7185 100%);
            border-radius: 6px;
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .progress-guidance {
            font-size: 0.82rem;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .progress-guidance i {
            color: var(--primary);
        }

        /* Form Controls & Grid */
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        @media (max-width: 640px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 0.84rem;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .req { color: var(--primary); }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s ease;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            background-color: #FEF2F2 !important;
        }

        .form-input.is-valid, .form-select.is-valid {
            border-color: var(--success);
        }

        .ro-box {
            background: #F8FAFC;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.9rem;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .tag-ro {
            font-size: 0.68rem;
            font-weight: 800;
            text-transform: uppercase;
            background: var(--rose-light);
            color: #9F1239;
            padding: 2px 8px;
            border-radius: 6px;
            letter-spacing: 0.5px;
        }

        .error-msg {
            display: none;
            color: var(--error);
            font-size: 0.78rem;
            font-weight: 600;
            margin-top: 6px;
            align-items: center;
            gap: 5px;
            line-height: 1.35;
        }

        .error-msg.visible {
            display: flex;
        }

        .helper-text {
            font-size: 0.78rem;
            color: var(--text-gray);
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Location Action Bar & Map Button */
        .location-action-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(135deg, #FFF1F2 0%, #FFFFFF 100%);
            border: 1.5px dashed var(--rose-border);
            border-radius: 14px;
            padding: 14px 18px;
            margin-bottom: 18px;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-map-picker {
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            padding: 9px 18px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
            transition: all 0.2s ease;
            font-family: inherit;
        }

        .btn-map-picker:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        /* Alerts */
        .alert-banner {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background: var(--error-bg);
            color: var(--error);
            border: 1px solid #FECACA;
        }

        .alert-success {
            background: var(--success-bg);
            color: var(--success);
            border: 1px solid #BBF7D0;
        }

        /* Avatar / Photo Uploader */
        .photo-uploader-box {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #F8FAFC;
            border: 1.5px solid var(--border-color);
            border-radius: 16px;
            padding: 18px 22px;
            flex-wrap: wrap;
        }

        .photo-avatar-ring {
            position: relative;
            width: 84px;
            height: 84px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--rose-border);
            background: var(--rose-light);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .btn-photo-choose {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--rose-soft);
            border: 1px solid var(--rose-border);
            color: var(--primary);
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 0.84rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-photo-choose:hover {
            background: #FFE4E6;
        }

        .btn-photo-reset {
            background: #F1F5F9;
            border: 1px solid #CBD5E1;
            color: var(--text-gray);
            padding: 8px 14px;
            border-radius: 10px;
            font-size: 0.84rem;
            font-weight: 600;
            cursor: pointer;
            display: none;
        }

        .btn-photo-reset:hover {
            background: #E2E8F0;
        }

        /* Bottom Sticky Action */
        .btn-bottom-save {
            width: 100%;
            padding: 15px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 14px;
            font-size: 1.05rem;
            font-weight: 800;
            cursor: pointer;
            font-family: inherit;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.3);
            transition: all 0.2s ease;
        }

        .btn-bottom-save:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        /* Live Preview Card (Right Column) */
        .preview-sticky-wrap {
            position: sticky;
            top: 86px;
        }

        .live-preview-card {
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid var(--rose-border);
            box-shadow: var(--shadow-float);
            overflow: hidden;
        }

        .preview-banner-header {
            background: linear-gradient(135deg, #FFE4E6 0%, #FFF1F2 100%);
            padding: 14px 20px;
            border-bottom: 1px solid var(--rose-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .preview-badge-label {
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .preview-body {
            padding: 24px 20px;
        }

        .preview-top-profile {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 16px;
        }

        .preview-avatar {
            width: 62px;
            height: 62px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid var(--primary);
            background: var(--rose-light);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .preview-name {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 3px;
            line-height: 1.25;
            word-break: break-word;
        }

        .preview-shop {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--primary);
            word-break: break-word;
        }

        .preview-meta-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding-top: 14px;
            border-top: 1px solid var(--border-color);
        }

        .preview-meta-item {
            font-size: 0.84rem;
            color: var(--navy-light);
            display: flex;
            align-items: center;
            gap: 10px;
            word-break: break-word;
        }

        .preview-meta-item i {
            color: var(--primary);
            font-size: 1rem;
            width: 18px;
            text-align: center;
            flex-shrink: 0;
        }

        .preview-chips-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed var(--border-color);
        }

        .preview-chip {
            font-size: 0.72rem;
            font-weight: 700;
            background: var(--bg-page);
            border: 1px solid var(--border-color);
            padding: 3px 8px;
            border-radius: 6px;
            color: var(--text-gray);
        }

        /* Map Picker Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(4px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .map-modal-card {
            background: #FFFFFF;
            border-radius: 20px;
            width: 100%;
            max-width: 820px;
            max-height: 92vh;
            display: flex;
            flex-direction: column;
            box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.25);
            overflow: hidden;
            animation: modalFadeIn 0.25s ease-out;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-header-row {
            padding: 16px 22px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-close-modal {
            background: none;
            border: none;
            font-size: 1.6rem;
            color: var(--text-gray);
            cursor: pointer;
            line-height: 1;
            padding: 4px;
            border-radius: 6px;
        }

        .btn-close-modal:hover { color: var(--navy); }

        .map-search-row {
            padding: 12px 22px;
            display: flex;
            gap: 8px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--border-color);
            position: relative;
        }

        .map-suggestions {
            display: none;
            position: absolute;
            top: 100%;
            left: 22px;
            right: 22px;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            max-height: 180px;
            overflow-y: auto;
            z-index: 1050;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .map-suggestion-item {
            padding: 10px 14px;
            font-size: 0.85rem;
            cursor: pointer;
            border-bottom: 1px solid #F1F5F9;
        }

        .map-suggestion-item:hover {
            background: var(--rose-soft);
            color: var(--primary);
        }

        .map-canvas-wrap {
            height: clamp(320px, 46vh, 460px);
            width: 100%;
            position: relative;
        }

        .map-selected-bar {
            padding: 12px 22px;
            background: #F8FAFC;
            border-top: 1px solid var(--border-color);
            font-size: 0.85rem;
        }

        .modal-footer-row {
            padding: 14px 22px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    </style>
</head>
<body>
    <!-- Top Sticky Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/women-products/seller/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear Shop</span>
            <span class="portal-badge">Seller Profile</span>
        </a>
        <div class="header-actions">
            <a class="btn-skip" href="${pageContext.request.contextPath}/women-products/seller/dashboard">
                <i class="bi bi-arrow-left"></i> Skip to Dashboard
            </a>
            <button type="button" class="btn-primary" onclick="triggerProfileSave()">
                <i class="bi bi-cloud-check-fill"></i> Save Profile
            </button>
        </div>
    </header>

    <main class="main-container">
        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert-banner alert-error">
                <i class="bi bi-exclamation-triangle-fill" style="font-size:1.1rem;"></i>
                <div><c:out value="${error}"/></div>
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert-banner alert-success">
                <i class="bi bi-check-circle-fill" style="font-size:1.1rem;"></i>
                <div><c:out value="${message}"/></div>
            </div>
        </c:if>

        <div class="profile-layout-grid">
            <!-- Form Column -->
            <div class="form-column">
                <!-- Progress Card -->
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <div class="progress-title-wrap">
                            <span class="progress-title">Shop Profile Completion</span>
                            <span class="pct-badge" id="completionPctBadge">${seller.profileCompletionPct != null ? seller.profileCompletionPct : 0}%</span>
                        </div>
                        <c:choose>
                            <c:when test="${seller.partnerProfileStatus == 'APPROVED'}">
                                <span class="status-badge badge-approved"><i class="bi bi-patch-check-fill"></i> Approved</span>
                            </c:when>
                            <c:when test="${seller.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                <span class="status-badge badge-pending"><i class="bi bi-hourglass-split"></i> Under Review</span>
                            </c:when>
                            <c:when test="${seller.partnerProfileStatus == 'REJECTED'}">
                                <span class="status-badge badge-rejected"><i class="bi bi-x-circle-fill"></i> Changes Requested</span>
                            </c:when>
                            <c:when test="${seller.partnerProfileStatus == 'PROFILE_INCOMPLETE'}">
                                <span class="status-badge badge-incomplete"><i class="bi bi-pencil-square"></i> Incomplete</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-registered"><i class="bi bi-person-check"></i> Registered</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" id="progressBarFill" style="width: ${seller.profileCompletionPct != null ? seller.profileCompletionPct : 0}%;"></div>
                    </div>

                    <div class="progress-guidance" id="progressGuidance">
                        <i class="bi bi-info-circle-fill"></i>
                        <span id="progressGuidanceText">Fill the required fields below to achieve 100% completion and qualify for marketplace verification.</span>
                    </div>
                </div>

                <!-- Main Form -->
                <form id="sellerProfileForm" action="${pageContext.request.contextPath}/women-products/seller/profile/update${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" novalidate>
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>

                    <!-- SECTION 1: Seller Identity -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-person-badge"></i>
                            <span>1. Seller Identity &amp; Contact</span>
                        </div>
                        <p class="section-desc">Personal and business identification details that build customer trust.</p>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="fullName">Full Name <span class="req">*</span></label>
                                <input type="text" class="form-input" name="fullName" id="fullName" required maxlength="80" value="<c:out value='${seller.fullName}'/>" placeholder="Your full legal name">
                                <div class="error-msg" id="err-fullName"><i class="bi bi-exclamation-circle-fill"></i> Full Name must be 2–80 letters only (no digits).</div>
                            </div>

                            <div class="form-group">
                                <label for="businessName">Shop / Business Name <span class="req">*</span></label>
                                <input type="text" class="form-input" name="businessName" id="businessName" required maxlength="100" value="<c:out value='${seller.businessName}'/>" placeholder="e.g. Namratha Handlooms &amp; Crafts">
                                <div class="error-msg" id="err-businessName"><i class="bi bi-exclamation-circle-fill"></i> Shop Name is required (2–100 characters).</div>
                            </div>

                            <div class="form-group">
                                <label>Official Email <span class="tag-ro">Not Editable</span></label>
                                <div class="ro-box">
                                    <span><c:out value="${seller.email}"/></span>
                                    <i class="bi bi-lock-fill" style="color:var(--text-gray);"></i>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="phone">Official Phone <span class="req">*</span></label>
                                <input type="tel" class="form-input" name="phone" id="phone" required maxlength="10" inputmode="numeric" value="<c:out value='${seller.phone}'/>" placeholder="10-digit mobile number">
                                <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit Indian mobile number starting with 6-9.</div>
                            </div>

                            <div class="form-group">
                                <label for="designation">Role / Designation <span class="req">*</span></label>
                                <input type="text" class="form-input" name="designation" id="designation" maxlength="120" value="<c:out value='${seller.designation}'/>" placeholder="e.g. Founder, Store Manager, Master Artisan">
                                <div class="error-msg" id="err-designation"><i class="bi bi-exclamation-circle-fill"></i> Role or designation is required.</div>
                            </div>

                            <div class="form-group">
                                <label for="whatsappNumber">WhatsApp Number</label>
                                <input type="tel" class="form-input" name="whatsappNumber" id="whatsappNumber" maxlength="10" inputmode="numeric" value="<c:out value='${seller.whatsappNumber}'/>" placeholder="10-digit WhatsApp number">
                                <div class="error-msg" id="err-whatsapp"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit WhatsApp number starting with 6-9.</div>
                            </div>

                            <div class="form-group full">
                                <label for="experience">Experience / Years in Business</label>
                                <input type="text" class="form-input" name="experience" id="experience" maxlength="100" value="<c:out value='${seller.experience}'/>" placeholder="e.g. 5+ years crafting handmade organic soaps">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 2: Shop Location & Coordinates -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-geo-alt"></i>
                            <span>2. Physical Store &amp; Operational Location</span>
                        </div>
                        <p class="section-desc">Define where your shop or dispatch warehouse is physically based.</p>

                        <!-- Map Selection Bar -->
                        <div class="location-action-bar">
                            <div>
                                <div style="font-weight:700; color:var(--navy); font-size:0.92rem;">Pin Exact Physical Location</div>
                                <div style="font-size:0.78rem; color:var(--text-gray);">Use our interactive map picker to set GPS coordinates and auto-fill address details.</div>
                            </div>
                            <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                                <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                            </button>
                        </div>

                        <!-- Address -->
                        <div class="form-group">
                            <label for="address">Landmark / Business Address <span class="req">*</span></label>
                            <input type="text" class="form-input" name="address" id="address" required maxlength="1000" value="<c:out value='${seller.address}'/>" placeholder="Shop/Building #, Street name, Area, Landmark">
                            <div class="error-msg" id="err-address"><i class="bi bi-exclamation-circle-fill"></i> Address must be at least 10 characters long.</div>
                        </div>

                        <!-- Dependent Dropdowns: Country -> State -> District/City -->
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="countrySelect">Country <span class="req">*</span></label>
                                <select id="countrySelect" class="form-select">
                                    <option value="India">India</option>
                                    <option value="United States">United States</option>
                                    <option value="United Kingdom">United Kingdom</option>
                                    <option value="Canada">Canada</option>
                                    <option value="Australia">Australia</option>
                                    <option value="United Arab Emirates">United Arab Emirates</option>
                                    <option value="Singapore">Singapore</option>
                                    <option value="Other">Other</option>
                                </select>
                                <div class="helper-text"><i class="bi bi-info-circle"></i> Selecting country updates state &amp; district options</div>
                            </div>

                            <div class="form-group">
                                <label for="stateSelect">State / UT <span class="req">*</span></label>
                                <select name="state" id="stateSelect" class="form-select">
                                    <option value="">-- Select State / UT --</option>
                                </select>
                                <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> Please select your State / UT.</div>
                            </div>

                            <div class="form-group">
                                <label for="districtSelect">City / District <span class="req">*</span></label>
                                <select id="districtSelect" class="form-select">
                                    <option value="">-- Select State First --</option>
                                </select>
                                <input type="hidden" name="city" id="inputCity" value="<c:out value='${seller.city}'/>">
                                <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> Please select your City / District.</div>
                            </div>

                            <div class="form-group" id="customCityGroup" style="display:none;">
                                <label for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                                <input type="text" id="customCityInput" class="form-input" placeholder="Enter your city / town name" maxlength="80">
                                <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                            </div>

                            <div class="form-group">
                                <label for="pincode">Postal Pincode <span class="req">*</span></label>
                                <input type="text" class="form-input" name="pincode" id="pincode" maxlength="6" inputmode="numeric" value="<c:out value='${seller.pincode}'/>" placeholder="6-digit Pincode">
                                <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 6-digit postal pincode.</div>
                            </div>

                            <div class="form-group">
                                <label for="inputMapLink">Google Maps Location Link</label>
                                <input type="text" class="form-input" id="inputMapLink" placeholder="Auto-filled via map picker or paste link" value="${seller.latitude != null ? 'https://www.google.com/maps?q='.concat(seller.latitude).concat(',').concat(seller.longitude) : ''}">
                            </div>
                        </div>

                        <!-- Hidden GPS Coordinates -->
                        <input type="hidden" name="latitude" id="inputLatitude" value="${seller.latitude}">
                        <input type="hidden" name="longitude" id="inputLongitude" value="${seller.longitude}">
                    </div>

                    <!-- SECTION 3: Categories & Brand Type -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-tags"></i>
                            <span>3. Categories &amp; Brand Specialty</span>
                        </div>
                        <p class="section-desc">Specify the primary product categories you sell and your brand classification.</p>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="category">Primary Product Category <span class="req">*</span></label>
                                <input type="text" class="form-input" name="category" id="category" maxlength="100" value="<c:out value='${seller.category}'/>" placeholder="e.g. Handloom Sarees, Organic Skincare, Terracotta Jewellery">
                                <div class="error-msg" id="err-category"><i class="bi bi-exclamation-circle-fill"></i> Primary product category is required.</div>
                            </div>

                            <div class="form-group">
                                <label for="brandType">Brand / Listing Type <span class="req">*</span></label>
                                <input type="text" class="form-input" name="brandType" id="brandType" maxlength="120" value="<c:out value='${seller.brandType}'/>" placeholder="e.g. Handmade Artisan, Organic Boutique, Certified Retail">
                                <div class="error-msg" id="err-brandType"><i class="bi bi-exclamation-circle-fill"></i> Brand / listing type is required.</div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 4: Service Area & Languages -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-globe2"></i>
                            <span>4. Service Area &amp; Communication</span>
                        </div>
                        <p class="section-desc">Regions you deliver to and languages your customer support speaks.</p>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="serviceArea">Delivery / Service Area</label>
                                <input type="text" class="form-input" name="serviceArea" id="serviceArea" maxlength="255" value="<c:out value='${seller.serviceArea}'/>" placeholder="e.g. Pan India, South India, Local Citywide Same-Day">
                            </div>

                            <div class="form-group">
                                <label for="languagesSpoken">Languages Spoken</label>
                                <input type="text" class="form-input" name="languagesSpoken" id="languagesSpoken" maxlength="255" value="<c:out value='${seller.languagesSpoken}'/>" placeholder="e.g. English, Hindi, Kannada, Tamil">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 5: Shop Facilities & Qualifications -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-building-check"></i>
                            <span>5. Shop Facilities &amp; Credentials</span>
                        </div>
                        <p class="section-desc">Artisan certifications, store amenities, and quality assurance.</p>

                        <div class="form-group">
                            <label for="qualification">Qualifications / Certifications</label>
                            <textarea class="form-textarea" name="qualification" id="qualification" rows="2" maxlength="2000" placeholder="e.g. Certified Organic Producer, Handloom Mark Holder, MSME Registered"><c:out value="${seller.qualification}"/></textarea>
                        </div>

                        <div class="form-group">
                            <label for="facilities">Store Amenities &amp; Services</label>
                            <input type="text" class="form-input" name="facilities" id="facilities" maxlength="500" value="<c:out value='${seller.facilities}'/>" placeholder="e.g. Trial room, Custom tailoring, Eco-friendly packaging, Gift wrapping">
                        </div>
                    </div>

                    <!-- SECTION 6: Working Hours & Schedule -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-clock-history"></i>
                            <span>6. Operating Hours &amp; Schedule</span>
                        </div>
                        <p class="section-desc">Inform customers when your physical shop is open or dispatch team is active.</p>

                        <div class="form-group">
                            <label for="availableDays">Available Days <span class="req">*</span></label>
                            <input type="text" class="form-input" name="availableDays" id="availableDays" value="<c:out value='${not empty seller.availableDays ? seller.availableDays : "Mon,Tue,Wed,Thu,Fri,Sat"}'/>" placeholder="e.g. Mon,Tue,Wed,Thu,Fri,Sat">
                            <div class="error-msg" id="err-availableDays"><i class="bi bi-exclamation-circle-fill"></i> Available days are required.</div>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="workingHoursFrom">Opening Time <span class="req">*</span></label>
                                <input type="text" class="form-input" name="workingHoursFrom" id="workingHoursFrom" maxlength="50" value="<c:out value='${not empty seller.workingHoursFrom ? seller.workingHoursFrom : "09:30"}'/>" placeholder="09:30">
                                <div class="error-msg" id="err-hoursFrom"><i class="bi bi-exclamation-circle-fill"></i> Opening time is required (e.g. 09:30).</div>
                            </div>

                            <div class="form-group">
                                <label for="workingHoursTo">Closing Time <span class="req">*</span></label>
                                <input type="text" class="form-input" name="workingHoursTo" id="workingHoursTo" maxlength="50" value="<c:out value='${not empty seller.workingHoursTo ? seller.workingHoursTo : "20:00"}'/>" placeholder="20:00">
                                <div class="error-msg" id="err-hoursTo"><i class="bi bi-exclamation-circle-fill"></i> Closing time is required (e.g. 20:00).</div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 7: About the Shop / Brand Story -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-journal-text"></i>
                            <span>7. About the Shop &amp; Brand Story</span>
                        </div>
                        <p class="section-desc">Share your journey, values, product uniqueness, and artisanal philosophy.</p>

                        <div class="form-group">
                            <label for="description">Shop Description <span class="req">*</span></label>
                            <textarea class="form-textarea" name="description" id="description" rows="4" maxlength="2000" placeholder="Tell customers about your brand heritage, quality standards, and craftsmanship..."><c:out value="${seller.description}"/></textarea>
                            <div class="helper-text" id="descCharCount" style="justify-content:flex-end;">0 / 2000 characters</div>
                            <div class="error-msg" id="err-description"><i class="bi bi-exclamation-circle-fill"></i> Shop description is required (minimum 10 characters).</div>
                        </div>
                    </div>

                    <!-- SECTION 8: Payout & Bank Details -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-credit-card-2-front"></i>
                            <span>8. Payout &amp; Bank Account Details</span>
                        </div>
                        <p class="section-desc">
                            <i class="bi bi-shield-lock-fill" style="color:var(--primary);"></i> Payout details are encrypted and securely used to disburse customer order payments.
                        </p>

                        <!-- Hidden serialized bankDetails -->
                        <input type="hidden" id="bankDetails" name="bankDetails" value="<c:out value='${seller.bankDetails}'/>">

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="bankAccountHolder">Account Holder Name</label>
                                <input type="text" class="form-input" id="bankAccountHolder" placeholder="Name as per bank passbook">
                            </div>

                            <div class="form-group">
                                <label for="bankName">Bank Name</label>
                                <input type="text" class="form-input" id="bankName" placeholder="e.g. State Bank of India, HDFC Bank">
                            </div>

                            <div class="form-group">
                                <label for="bankAccountNumber">Account Number</label>
                                <input type="password" class="form-input" id="bankAccountNumber" placeholder="Enter bank account number" autocomplete="new-password">
                            </div>

                            <div class="form-group">
                                <label for="confirmAccountNumber">Confirm Account Number</label>
                                <input type="text" class="form-input" id="confirmAccountNumber" placeholder="Re-enter account number">
                                <div class="error-msg" id="err-accMismatch"><i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match.</div>
                                <div id="accMatchSuccess" style="display:none; color:var(--success); font-size:0.78rem; font-weight:700; margin-top:4px;">
                                    <i class="bi bi-check-circle-fill"></i> Account numbers match
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="bankIfsc">IFSC Code</label>
                                <input type="text" class="form-input" id="bankIfsc" placeholder="e.g. SBIN0001234" maxlength="11" style="text-transform:uppercase;">
                                <div class="error-msg" id="err-ifsc"><i class="bi bi-exclamation-circle-fill"></i> Format: 4 letters, 0, 6 alphanumeric characters (e.g. SBIN0001234).</div>
                            </div>

                            <div class="form-group">
                                <label for="bankBranch">Branch Name</label>
                                <input type="text" class="form-input" id="bankBranch" placeholder="e.g. Indiranagar, Bengaluru">
                            </div>

                            <div class="form-group">
                                <label for="upiId">UPI ID (Instant Payouts)</label>
                                <input type="text" class="form-input" name="upiId" id="upiId" value="<c:out value='${seller.upiId}'/>" placeholder="username@bank">
                                <div class="error-msg" id="err-upi"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid UPI ID (e.g. name@bank).</div>
                            </div>

                            <div class="form-group">
                                <label for="gstin">GSTIN (Optional)</label>
                                <input type="text" class="form-input" name="gstin" id="gstin" maxlength="15" value="<c:out value='${seller.gstin}'/>" placeholder="22AAAAA0000A1Z5" style="text-transform:uppercase;">
                                <div class="error-msg" id="err-gstin"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 15-character GSTIN.</div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 9: Profile Photo & Verification Documents -->
                    <div class="section-card">
                        <div class="section-header">
                            <i class="bi bi-images"></i>
                            <span>9. Profile Photo &amp; Verification Documents</span>
                        </div>
                        <p class="section-desc">Visual assets for your store and business identity documents for account verification.</p>

                        <!-- Profile Photo -->
                        <div class="form-group" style="margin-bottom:24px;">
                            <label style="margin-bottom:10px;">Store Avatar / Portrait Photo</label>
                            <div class="photo-uploader-box">
                                <div class="photo-avatar-ring">
                                    <c:choose>
                                        <c:when test="${not empty seller.profilePhotoPath}">
                                            <img id="sellerPhotoPreview" src="${pageContext.request.contextPath}${seller.profilePhotoPath}" style="width:100%; height:100%; object-fit:cover;">
                                            <span id="sellerPhotoFallback" style="display:none; font-size:1.8rem; font-weight:800; color:var(--primary);">${fn:substring(not empty seller.fullName ? seller.fullName : 'S', 0, 1)}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <img id="sellerPhotoPreview" style="display:none; width:100%; height:100%; object-fit:cover;">
                                            <span id="sellerPhotoFallback" style="font-size:1.8rem; font-weight:800; color:var(--primary);">${fn:substring(not empty seller.fullName ? seller.fullName : 'S', 0, 1)}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="flex:1;">
                                    <div style="font-size:0.9rem; font-weight:700; color:var(--navy); margin-bottom:4px;">Upload Shop Logo or Founder Portrait</div>
                                    <div style="font-size:0.78rem; color:var(--text-gray); margin-bottom:12px;">Supported: JPG, JPEG, PNG, WEBP (Max 5MB). High-resolution image recommended.</div>
                                    <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                                        <label for="profilePhotoInput" class="btn-photo-choose">
                                            <i class="bi bi-camera-fill"></i> Choose Photo
                                        </label>
                                        <button type="button" id="clearPhotoBtn" class="btn-photo-reset">
                                            <i class="bi bi-x-circle"></i> Reset
                                        </button>
                                        <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/png,image/jpeg,image/jpg,image/webp" style="display:none;">
                                    </div>
                                    <div class="error-msg" id="err-photo"><i class="bi bi-exclamation-circle-fill"></i> File must be JPG, PNG, or WEBP under 5MB.</div>
                                </div>
                            </div>
                        </div>

                        <!-- Identity Document -->
                        <div class="form-group" style="margin-bottom:20px;">
                            <label for="identityDocInput">Identity Document (Aadhaar / Voter ID / MSME / GST Certificate)</label>
                            <input type="file" class="form-input" id="identityDocInput" name="identityDoc" accept="image/*,.pdf">
                            <div class="helper-text"><i class="bi bi-shield-check"></i> Encrypted and used solely for admin identity and partner verification.</div>
                            <c:if test="${not empty seller.identityDocPath}">
                                <div style="margin-top:8px;">
                                    <a href="${pageContext.request.contextPath}${seller.identityDocPath}" target="_blank" style="font-size:0.84rem; color:var(--primary); font-weight:700; text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                                        <i class="bi bi-file-earmark-check-fill"></i> View Currently Uploaded Identity Document
                                    </a>
                                </div>
                            </c:if>
                            <div class="error-msg" id="err-doc"><i class="bi bi-exclamation-circle-fill"></i> Document must be PDF or image under 10MB.</div>
                        </div>

                        <!-- Gallery Photos -->
                        <div class="form-group">
                            <label for="galleryPhotosInput">Workshop / Store Showcase Photos (Optional)</label>
                            <input type="file" class="form-input" id="galleryPhotosInput" name="galleryPhotos" accept="image/*" multiple>
                            <div class="helper-text"><i class="bi bi-collection-play"></i> You can select multiple images showcasing your store, workshop, or handcrafted products.</div>
                            <c:if test="${not empty seller.galleryPhotos}">
                                <div class="ro-box" style="margin-top:10px; font-size:0.82rem;">
                                    <span>Uploaded showcase photos: <c:out value="${seller.galleryPhotos}"/></span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Bottom Submit -->
                    <button type="submit" class="btn-bottom-save">
                        <i class="bi bi-check2-circle" style="font-size:1.3rem;"></i> Save &amp; Complete Seller Profile
                    </button>
                </form>
            </div>

            <!-- Sticky Live Preview Column -->
            <aside class="preview-column">
                <div class="preview-sticky-wrap">
                    <div class="live-preview-card">
                        <div class="preview-banner-header">
                            <span class="preview-badge-label">
                                <i class="bi bi-shop"></i> Storefront Preview
                            </span>
                            <span class="pct-badge" id="previewPctChip">${seller.profileCompletionPct != null ? seller.profileCompletionPct : 0}%</span>
                        </div>

                        <div class="preview-body">
                            <div class="preview-top-profile">
                                <div class="preview-avatar">
                                    <c:choose>
                                        <c:when test="${not empty seller.profilePhotoPath}">
                                            <img id="liveCardPhoto" src="${pageContext.request.contextPath}${seller.profilePhotoPath}" style="width:100%; height:100%; object-fit:cover;">
                                            <span id="liveCardInitial" style="display:none; font-size:1.5rem; font-weight:800; color:var(--primary);">${fn:substring(not empty seller.fullName ? seller.fullName : 'S', 0, 1)}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <img id="liveCardPhoto" style="display:none; width:100%; height:100%; object-fit:cover;">
                                            <span id="liveCardInitial" style="font-size:1.5rem; font-weight:800; color:var(--primary);">${fn:substring(not empty seller.fullName ? seller.fullName : 'S', 0, 1)}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="flex:1; min-width:0;">
                                    <div class="preview-name" id="previewCardName"><c:out value="${not empty seller.fullName ? seller.fullName : 'Seller Name'}"/></div>
                                    <div class="preview-shop" id="previewCardShop"><c:out value="${not empty seller.businessName ? seller.businessName : 'Store Name'}"/></div>
                                </div>
                            </div>

                            <div class="preview-meta-list">
                                <div class="preview-meta-item">
                                    <i class="bi bi-envelope"></i>
                                    <span><c:out value="${seller.email}"/></span>
                                </div>
                                <div class="preview-meta-item">
                                    <i class="bi bi-telephone"></i>
                                    <span id="previewCardPhone"><c:out value="${not empty seller.phone ? seller.phone : '+91 98765 43210'}"/></span>
                                </div>
                                <div class="preview-meta-item">
                                    <i class="bi bi-geo-alt"></i>
                                    <span id="previewCardLocation">
                                        <c:choose>
                                            <c:when test="${not empty seller.city}">${seller.city}<c:if test="${not empty seller.state}">, ${seller.state}</c:if></c:when>
                                            <c:otherwise>Physical Store Location</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="preview-meta-item">
                                    <i class="bi bi-clock"></i>
                                    <span id="previewCardHours">
                                        <c:choose>
                                            <c:when test="${not empty seller.workingHoursFrom && not empty seller.workingHoursTo}">${seller.workingHoursFrom} - ${seller.workingHoursTo}</c:when>
                                            <c:otherwise>09:30 - 20:00</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="preview-chips-wrap" id="previewCardChips">
                                <span class="preview-chip" id="chipCategory"><c:out value="${not empty seller.category ? seller.category : 'General Products'}"/></span>
                                <span class="preview-chip" id="chipBrand"><c:out value="${not empty seller.brandType ? seller.brandType : 'Handmade &amp; Retail'}"/></span>
                                <span class="preview-chip" id="chipStatus"><c:out value="${not empty seller.verificationStatus ? seller.verificationStatus : 'PENDING'}"/></span>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </main>

    <!-- ====================================================
         LEAFLET MAP PICKER MODAL (CSP Compliant)
         ==================================================== -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle">
        <div class="map-modal-card">
            <div class="modal-header-row">
                <div class="modal-title">
                    <i class="bi bi-geo-alt-fill" style="color:var(--primary);"></i>
                    <span id="mapModalTitle">Pin Shop / Dispatch Location</span>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close">&times;</button>
            </div>

            <div class="map-search-row">
                <div style="flex:1; position:relative;">
                    <input type="text" id="mapSearchInput" class="form-input" placeholder="Search area, landmark, street, city..." autocomplete="off">
                    <div class="map-suggestions" id="mapSuggestions"></div>
                </div>
                <button type="button" class="btn-secondary" id="btnSearchMap">
                    <i class="bi bi-search"></i> Search
                </button>
                <button type="button" class="btn-secondary" id="btnLocateMe" title="Use Current GPS Location">
                    <i class="bi bi-crosshair"></i> GPS
                </button>
            </div>

            <div id="mapPickerAlert" class="alert-banner alert-error" style="display:none; padding:8px 14px; margin:0; border-radius:0;"></div>

            <div class="map-canvas-wrap">
                <div id="mapContainer" style="width:100%; height:100%;"></div>
            </div>

            <div class="map-selected-bar">
                <div style="font-size:0.75rem; font-weight:700; color:var(--text-gray); text-transform:uppercase; margin-bottom:2px;">Selected Pin Address</div>
                <div id="mapSelectedAddress" style="font-weight:600; color:var(--navy);">Click on the map or search above to pin your store location</div>
            </div>

            <div class="modal-footer-row">
                <button type="button" class="btn-skip" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-primary" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Confirm Location
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS (CSP Safe) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
    (function () {
        'use strict';

        const ctx = '${pageContext.request.contextPath}';
        const form = document.getElementById('sellerProfileForm');

        // Location Dataset (Country -> State -> District / City)
        const locationData = {
            "India": {
                "Andhra Pradesh": ["Ananthapuramu", "Chittoor", "East Godavari", "Eluru", "Guntur", "Kakinada", "Krishna", "Kurnool", "NTR", "Palnadu", "Prakasam", "Srikakulam", "Nellore", "Tirupati", "Visakhapatnam", "Vizianagaram", "West Godavari", "YSR Kadapa", "Other"],
                "Arunachal Pradesh": ["Itanagar", "Tawang", "West Kameng", "East Kameng", "Papum Pare", "Lohit", "Namsai", "Changlang", "Other"],
                "Assam": ["Guwahati", "Dibrugarh", "Silchar", "Jorhat", "Nagaon", "Tinsukia", "Tezpur", "Barpeta", "Bongaigaon", "Other"],
                "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif", "Arrah", "Begusarai", "Other"],
                "Chhattisgarh": ["Raipur", "Bhilai", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur", "Raigarh", "Other"],
                "Goa": ["North Goa", "South Goa", "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Other"],
                "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar", "Junagadh", "Anand", "Navsari", "Other"],
                "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", "Karnal", "Sonipat", "Panchkula", "Other"],
                "Himachal Pradesh": ["Shimla", "Dharamshala", "Mandi", "Solan", "Kullu", "Hamirpur", "Una", "Other"],
                "Jharkhand": ["Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Giridih", "Other"],
                "Karnataka": ["Bengaluru Urban", "Bengaluru Rural", "Mysuru", "Hubballi-Dharwad", "Mangaluru", "Belagavi", "Kalaburagi", "Davanagere", "Ballari", "Vijayapura", "Shivamogga", "Tumakuru", "Udupi", "Hassan", "Other"],
                "Kerala": ["Thiruvananthapuram", "Kochi (Ernakulam)", "Kozhikode", "Thrissur", "Kollam", "Palakkad", "Malappuram", "Kannur", "Kottayam", "Alappuzha", "Other"],
                "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna", "Ratlam", "Rewa", "Other"],
                "Maharashtra": ["Mumbai", "Navi Mumbai", "Pune", "Nagpur", "Thane", "Nashik", "Chhatrapati Sambhajinagar", "Solapur", "Kolhapur", "Amravati", "Other"],
                "Manipur": ["Imphal West", "Imphal East", "Thoubal", "Bishnupur", "Churachandpur", "Other"],
                "Meghalaya": ["Shillong", "Tura", "Jowai", "Ri-Bhoi", "Other"],
                "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Kolasib", "Other"],
                "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Tuensang", "Other"],
                "Odisha": ["Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur", "Puri", "Balasore", "Other"],
                "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "Mohali (SAS Nagar)", "Hoshiarpur", "Other"],
                "Rajasthan": ["Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Sikar", "Other"],
                "Sikkim": ["Gangtok", "Namchi", "Gyalshing", "Mangan", "Other"],
                "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Vellore", "Erode", "Thoothukudi", "Other"],
                "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam", "Mahbubnagar", "Other"],
                "Tripura": ["Agartala", "Dharmanagar", "Udaipur", "Other"],
                "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj", "Noida", "Greater Noida", "Ghaziabad", "Meerut", "Bareilly", "Aligarh", "Gorakhpur", "Other"],
                "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rishikesh", "Other"],
                "West Bengal": ["Kolkata", "Howrah", "North 24 Parganas", "South 24 Parganas", "Durgapur", "Asansol", "Siliguri", "Other"],
                "Delhi": ["Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North West Delhi", "South Delhi", "West Delhi", "Other"],
                "Chandigarh": ["Chandigarh", "Other"],
                "Puducherry": ["Puducherry", "Karaikal", "Other"]
            },
            "United States": {
                "California": ["Los Angeles", "San Francisco", "San Diego", "San Jose", "Sacramento", "Other"],
                "New York": ["New York City", "Buffalo", "Rochester", "Albany", "Other"],
                "Texas": ["Houston", "Austin", "Dallas", "San Antonio", "Other"]
            },
            "United Kingdom": {
                "England": ["London", "Manchester", "Birmingham", "Leeds", "Other"],
                "Scotland": ["Edinburgh", "Glasgow", "Other"]
            },
            "Canada": {
                "Ontario": ["Toronto", "Ottawa", "Mississauga", "Other"],
                "British Columbia": ["Vancouver", "Victoria", "Other"]
            },
            "Australia": {
                "New South Wales": ["Sydney", "Newcastle", "Other"],
                "Victoria": ["Melbourne", "Geelong", "Other"]
            },
            "United Arab Emirates": {
                "Emirates": ["Dubai", "Abu Dhabi", "Sharjah", "Ajman", "Other"]
            },
            "Singapore": {
                "Singapore": ["Central", "East", "West", "North", "Other"]
            },
            "Other": {
                "International Region": ["General Region", "Other"]
            }
        };

        const savedState = "${seller.state != null ? seller.state : ''}";
        const savedCity = "${seller.city != null ? seller.city : ''}";

        // --- Location Dropdowns Initialization ---
        const countrySelect = document.getElementById('countrySelect');
        const stateSelect = document.getElementById('stateSelect');
        const districtSelect = document.getElementById('districtSelect');
        const customCityGroup = document.getElementById('customCityGroup');
        const customCityInput = document.getElementById('customCityInput');
        const inputCity = document.getElementById('inputCity');

        function populateStates(country, selState) {
            if (!stateSelect) return;
            stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';
            const statesObj = locationData[country] || locationData['India'] || {};
            const stateNames = Object.keys(statesObj).sort();

            stateNames.forEach(st => {
                const opt = document.createElement('option');
                opt.value = st;
                opt.textContent = st;
                if (st.toLowerCase() === (selState || '').toLowerCase()) opt.selected = true;
                stateSelect.appendChild(opt);
            });

            if (stateSelect.value) {
                populateDistricts(country, stateSelect.value, savedCity);
            } else {
                districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                districtSelect.disabled = true;
                if (customCityGroup) customCityGroup.style.display = 'none';
            }
        }

        function populateDistricts(country, state, selCity) {
            if (!districtSelect) return;
            districtSelect.innerHTML = '<option value="">-- Select City / District --</option>';
            districtSelect.disabled = false;

            const statesObj = locationData[country] || locationData['India'] || {};
            const districts = statesObj[state] || ['Other'];

            let matched = false;
            districts.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d;
                opt.textContent = d;
                if (selCity && (d.toLowerCase() === selCity.toLowerCase() || selCity.toLowerCase().includes(d.toLowerCase()))) {
                    opt.selected = true;
                    matched = true;
                }
                districtSelect.appendChild(opt);
            });

            if (selCity && !matched) {
                districtSelect.value = 'Other';
                if (customCityGroup) {
                    customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.value = selCity;
                }
                if (inputCity) inputCity.value = selCity;
            } else if (districtSelect.value === 'Other') {
                if (customCityGroup) customCityGroup.style.display = 'block';
            } else {
                if (customCityGroup) customCityGroup.style.display = 'none';
                if (inputCity) inputCity.value = districtSelect.value;
            }
        }

        countrySelect.addEventListener('change', () => {
            populateStates(countrySelect.value, '');
            validateState();
            recalculateProgress();
        });

        stateSelect.addEventListener('change', () => {
            populateDistricts(countrySelect.value, stateSelect.value, '');
            validateState();
            recalculateProgress();
            updateLivePreview();
        });

        districtSelect.addEventListener('change', () => {
            if (districtSelect.value === 'Other') {
                if (customCityGroup) customCityGroup.style.display = 'block';
                if (inputCity) inputCity.value = customCityInput ? customCityInput.value.trim() : '';
            } else {
                if (customCityGroup) customCityGroup.style.display = 'none';
                if (inputCity) inputCity.value = districtSelect.value;
            }
            validateCity();
            recalculateProgress();
            updateLivePreview();
        });

        if (customCityInput) {
            customCityInput.addEventListener('input', () => {
                if (inputCity) inputCity.value = customCityInput.value.trim();
                validateCity();
                recalculateProgress();
                updateLivePreview();
            });
        }

        // Initialize with India & saved values
        populateStates('India', savedState);

        // --- Field Validations & Inline Error Helpers ---
        function setFieldError(fieldId, errId, isValid, msg) {
            const input = document.getElementById(fieldId);
            const err = document.getElementById(errId);
            if (input) {
                input.classList.toggle('is-invalid', !isValid);
                input.classList.toggle('is-valid', isValid);
            }
            if (err) {
                err.classList.toggle('visible', !isValid);
                if (msg) {
                    err.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + msg;
                }
            }
            return isValid;
        }

        function validateFullName() {
            const val = document.getElementById('fullName').value.trim();
            const valid = val.length >= 2 && val.length <= 80 && /^[A-Za-z][A-Za-z .'-]{1,79}$/.test(val);
            return setFieldError('fullName', 'err-fullName', valid);
        }

        function validateBusinessName() {
            const val = document.getElementById('businessName').value.trim();
            const valid = val.length >= 2 && val.length <= 100;
            return setFieldError('businessName', 'err-businessName', valid);
        }

        function validatePhone() {
            const val = document.getElementById('phone').value.trim();
            const valid = /^[6-9]\d{9}$/.test(val);
            return setFieldError('phone', 'err-phone', valid);
        }

        function validateDesignation() {
            const val = document.getElementById('designation').value.trim();
            const valid = val.length >= 2;
            return setFieldError('designation', 'err-designation', valid);
        }

        function validateWhatsapp() {
            const val = document.getElementById('whatsappNumber').value.trim();
            if (!val) {
                setFieldError('whatsappNumber', 'err-whatsapp', true);
                return true;
            }
            const valid = /^[6-9]\d{9}$/.test(val);
            return setFieldError('whatsappNumber', 'err-whatsapp', valid);
        }

        function validateAddress() {
            const val = document.getElementById('address').value.trim();
            const valid = val.length >= 10;
            return setFieldError('address', 'err-address', valid);
        }

        function validateState() {
            const val = stateSelect ? stateSelect.value : '';
            return setFieldError('stateSelect', 'err-state', !!val);
        }

        function validateCity() {
            const val = inputCity ? inputCity.value.trim() : '';
            const valid = val.length >= 2;
            setFieldError('districtSelect', 'err-city', valid);
            if (districtSelect.value === 'Other') {
                setFieldError('customCityInput', 'err-customCity', valid);
            }
            return valid;
        }

        function validatePincode() {
            const val = document.getElementById('pincode').value.trim();
            const valid = /^\d{6}$/.test(val);
            return setFieldError('pincode', 'err-pincode', valid);
        }

        function validateCategory() {
            const val = document.getElementById('category').value.trim();
            const valid = val.length >= 2;
            return setFieldError('category', 'err-category', valid);
        }

        function validateBrandType() {
            const val = document.getElementById('brandType').value.trim();
            const valid = val.length >= 2;
            return setFieldError('brandType', 'err-brandType', valid);
        }

        function validateAvailableDays() {
            const val = document.getElementById('availableDays').value.trim();
            const valid = val.length >= 2;
            return setFieldError('availableDays', 'err-availableDays', valid);
        }

        function validateHoursFrom() {
            const val = document.getElementById('workingHoursFrom').value.trim();
            const valid = val.length >= 2;
            return setFieldError('workingHoursFrom', 'err-hoursFrom', valid);
        }

        function validateHoursTo() {
            const val = document.getElementById('workingHoursTo').value.trim();
            const valid = val.length >= 2;
            return setFieldError('workingHoursTo', 'err-hoursTo', valid);
        }

        function validateDescription() {
            const val = document.getElementById('description').value.trim();
            const valid = val.length >= 10;
            return setFieldError('description', 'err-description', valid);
        }

        // Bank Details Pre-parsing & Serialization
        const hiddenBank = document.getElementById('bankDetails');
        const acHolderInput = document.getElementById('bankAccountHolder');
        const bankNameInput = document.getElementById('bankName');
        const acNumInput = document.getElementById('bankAccountNumber');
        const confirmAcInput = document.getElementById('confirmAccountNumber');
        const ifscInput = document.getElementById('bankIfsc');
        const branchInput = document.getElementById('bankBranch');
        const mismatchErr = document.getElementById('err-accMismatch');
        const matchOk = document.getElementById('accMatchSuccess');
        const ifscErr = document.getElementById('err-ifsc');
        const upiInput = document.getElementById('upiId');
        const gstinInput = document.getElementById('gstin');

        // Pre-parse existing bank details
        if (hiddenBank && hiddenBank.value) {
            const raw = hiddenBank.value.trim();
            if (raw.includes('|')) {
                raw.split('|').forEach(part => {
                    const p = part.trim();
                    const lower = p.toLowerCase();
                    if (lower.startsWith('account holder:')) acHolderInput.value = p.substring(15).trim();
                    else if (lower.startsWith('bank:')) bankNameInput.value = p.substring(5).trim();
                    else if (lower.startsWith('a/c:')) {
                        const ac = p.substring(4).trim();
                        acNumInput.value = ac;
                        confirmAcInput.value = ac;
                    }
                    else if (lower.startsWith('ifsc:')) ifscInput.value = p.substring(5).trim();
                    else if (lower.startsWith('branch:')) branchInput.value = p.substring(7).trim();
                });
            } else {
                bankNameInput.value = raw;
            }
        }

        function syncBankDetails() {
            const holder = acHolderInput ? acHolderInput.value.trim() : '';
            const bName = bankNameInput ? bankNameInput.value.trim() : '';
            const acNum = acNumInput ? acNumInput.value.trim() : '';
            const ifsc = ifscInput ? ifscInput.value.trim().toUpperCase() : '';
            const branch = branchInput ? branchInput.value.trim() : '';

            if (ifscInput) ifscInput.value = ifsc;

            if (holder || bName || acNum || ifsc || branch) {
                const parts = [];
                if (holder) parts.push('Account Holder: ' + holder);
                if (bName) parts.push('Bank: ' + bName);
                if (acNum) parts.push('A/C: ' + acNum);
                if (ifsc) parts.push('IFSC: ' + ifsc);
                if (branch) parts.push('Branch: ' + branch);
                if (hiddenBank) hiddenBank.value = parts.join(' | ');
            }
        }

        function validateAccountMatch() {
            if (!acNumInput || !confirmAcInput) return true;
            const a = acNumInput.value.trim();
            const c = confirmAcInput.value.trim();
            if (c.length > 0) {
                if (a !== c) {
                    if (mismatchErr) mismatchErr.classList.add('visible');
                    if (matchOk) matchOk.style.display = 'none';
                    confirmAcInput.classList.add('is-invalid');
                    return false;
                } else {
                    if (mismatchErr) mismatchErr.classList.remove('visible');
                    if (matchOk) matchOk.style.display = 'block';
                    confirmAcInput.classList.remove('is-invalid');
                    confirmAcInput.classList.add('is-valid');
                    return true;
                }
            } else {
                if (mismatchErr) mismatchErr.classList.remove('visible');
                if (matchOk) matchOk.style.display = 'none';
                confirmAcInput.classList.remove('is-invalid');
                return true;
            }
        }

        function validateIfsc() {
            if (!ifscInput) return true;
            const code = ifscInput.value.trim().toUpperCase();
            if (!code) {
                if (ifscErr) ifscErr.classList.remove('visible');
                ifscInput.classList.remove('is-invalid');
                return true;
            }
            const ok = /^[A-Z]{4}0[A-Z0-9]{6}$/.test(code);
            if (ifscErr) ifscErr.classList.toggle('visible', !ok);
            ifscInput.classList.toggle('is-invalid', !ok);
            return ok;
        }

        function validateUpi() {
            if (!upiInput) return true;
            const val = upiInput.value.trim();
            if (!val) {
                setFieldError('upiId', 'err-upi', true);
                return true;
            }
            const ok = /^[a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+$/.test(val);
            return setFieldError('upiId', 'err-upi', ok);
        }

        function validateGstin() {
            if (!gstinInput) return true;
            const val = gstinInput.value.trim().toUpperCase();
            gstinInput.value = val;
            if (!val) {
                setFieldError('gstin', 'err-gstin', true);
                return true;
            }
            const ok = /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/.test(val);
            return setFieldError('gstin', 'err-gstin', ok);
        }

        // Attach listeners for live validation and preview update
        const liveFields = [
            { id: 'fullName', validator: validateFullName },
            { id: 'businessName', validator: validateBusinessName },
            { id: 'phone', validator: validatePhone },
            { id: 'designation', validator: validateDesignation },
            { id: 'whatsappNumber', validator: validateWhatsapp },
            { id: 'address', validator: validateAddress },
            { id: 'pincode', validator: validatePincode },
            { id: 'category', validator: validateCategory },
            { id: 'brandType', validator: validateBrandType },
            { id: 'availableDays', validator: validateAvailableDays },
            { id: 'workingHoursFrom', validator: validateHoursFrom },
            { id: 'workingHoursTo', validator: validateHoursTo },
            { id: 'description', validator: validateDescription },
            { id: 'upiId', validator: validateUpi },
            { id: 'gstin', validator: validateGstin }
        ];

        liveFields.forEach(f => {
            const el = document.getElementById(f.id);
            if (el) {
                el.addEventListener('input', () => {
                    f.validator();
                    recalculateProgress();
                    updateLivePreview();
                });
                el.addEventListener('blur', () => {
                    f.validator();
                    recalculateProgress();
                });
            }
        });

        // Bank listeners
        [acHolderInput, bankNameInput, acNumInput, confirmAcInput, ifscInput, branchInput].forEach(el => {
            if (el) {
                el.addEventListener('input', () => {
                    syncBankDetails();
                    if (el === acNumInput || el === confirmAcInput) validateAccountMatch();
                    if (el === ifscInput) validateIfsc();
                    recalculateProgress();
                });
            }
        });

        // Description char counter
        const descEl = document.getElementById('description');
        const descCountEl = document.getElementById('descCharCount');
        if (descEl && descCountEl) {
            descCountEl.textContent = descEl.value.length + ' / 2000 characters';
            descEl.addEventListener('input', () => {
                descCountEl.textContent = descEl.value.length + ' / 2000 characters';
            });
        }

        // --- Profile Photo & Live Preview ---
        const photoInput = document.getElementById('profilePhotoInput');
        const photoPreview = document.getElementById('sellerPhotoPreview');
        const photoFallback = document.getElementById('sellerPhotoFallback');
        const liveCardPhoto = document.getElementById('liveCardPhoto');
        const liveCardInitial = document.getElementById('liveCardInitial');
        const clearPhotoBtn = document.getElementById('clearPhotoBtn');
        const errPhoto = document.getElementById('err-photo');
        const origPhotoSrc = photoPreview ? photoPreview.getAttribute('src') : '';

        if (photoInput) {
            photoInput.addEventListener('change', function () {
                const file = this.files && this.files[0];
                if (!file) return;

                // Validate size & type
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                if (!validTypes.includes(file.type) || file.size > 5 * 1024 * 1024) {
                    if (errPhoto) errPhoto.classList.add('visible');
                    this.value = '';
                    return;
                }
                if (errPhoto) errPhoto.classList.remove('visible');

                const reader = new FileReader();
                reader.onload = function (e) {
                    if (photoPreview) {
                        photoPreview.src = e.target.result;
                        photoPreview.style.display = 'block';
                    }
                    if (photoFallback) photoFallback.style.display = 'none';
                    if (liveCardPhoto) {
                        liveCardPhoto.src = e.target.result;
                        liveCardPhoto.style.display = 'block';
                    }
                    if (liveCardInitial) liveCardInitial.style.display = 'none';
                    if (clearPhotoBtn) clearPhotoBtn.style.display = 'inline-block';
                    recalculateProgress();
                };
                reader.readAsDataURL(file);
            });
        }

        if (clearPhotoBtn) {
            clearPhotoBtn.addEventListener('click', function () {
                if (photoInput) photoInput.value = '';
                if (origPhotoSrc) {
                    if (photoPreview) photoPreview.src = origPhotoSrc;
                    if (liveCardPhoto) liveCardPhoto.src = origPhotoSrc;
                } else {
                    if (photoPreview) photoPreview.style.display = 'none';
                    if (photoFallback) photoFallback.style.display = 'block';
                    if (liveCardPhoto) liveCardPhoto.style.display = 'none';
                    if (liveCardInitial) liveCardInitial.style.display = 'block';
                }
                clearPhotoBtn.style.display = 'none';
                recalculateProgress();
            });
        }

        // Live Preview synchronizer
        function updateLivePreview() {
            const nameVal = document.getElementById('fullName')?.value.trim() || 'Seller Name';
            const shopVal = document.getElementById('businessName')?.value.trim() || 'Store Name';
            const phoneVal = document.getElementById('phone')?.value.trim() || '+91 98765 43210';
            const stateVal = stateSelect?.value || '';
            const cityVal = inputCity?.value || '';
            const hoursFrom = document.getElementById('workingHoursFrom')?.value.trim() || '09:30';
            const hoursTo = document.getElementById('workingHoursTo')?.value.trim() || '20:00';
            const catVal = document.getElementById('category')?.value.trim() || 'General Products';
            const brandVal = document.getElementById('brandType')?.value.trim() || 'Handmade & Retail';

            const cardName = document.getElementById('previewCardName');
            const cardShop = document.getElementById('previewCardShop');
            const cardPhone = document.getElementById('previewCardPhone');
            const cardLocation = document.getElementById('previewCardLocation');
            const cardHours = document.getElementById('previewCardHours');
            const cardInitial = document.getElementById('liveCardInitial');
            const chipCategory = document.getElementById('chipCategory');
            const chipBrand = document.getElementById('chipBrand');

            if (cardName) cardName.textContent = nameVal;
            if (cardShop) cardShop.textContent = shopVal;
            if (cardPhone) cardPhone.textContent = phoneVal;
            if (cardHours) cardHours.textContent = hoursFrom + ' - ' + hoursTo;
            if (chipCategory) chipCategory.textContent = catVal;
            if (chipBrand) chipBrand.textContent = brandVal;

            if (cardInitial && nameVal) {
                cardInitial.textContent = nameVal.charAt(0).toUpperCase();
            }

            if (cardLocation) {
                const locParts = [cityVal, stateVal].filter(Boolean);
                cardLocation.textContent = locParts.length > 0 ? locParts.join(', ') : 'Physical Store Location';
            }
        }

        // --- Accurate Profile Completion Percentage ---
        function recalculateProgress() {
            const checks = [
                validateFullName(),
                validateBusinessName(),
                validatePhone(),
                validateAddress(),
                stateSelect && stateSelect.value,
                inputCity && inputCity.value.trim().length >= 2,
                validatePincode(),
                validateCategory(),
                validateBrandType(),
                validateAvailableDays(),
                validateHoursFrom(),
                validateHoursTo(),
                validateDescription(),
                validateDesignation(),
                (hiddenBank && hiddenBank.value.trim().length > 10) || (upiInput && upiInput.value.trim().length > 4),
                (photoPreview && photoPreview.style.display !== 'none' && photoPreview.getAttribute('src')) || "${not empty seller.profilePhotoPath || not empty seller.identityDocPath}" === "true"
            ];

            const total = checks.length;
            const completed = checks.filter(Boolean).length;
            const pct = Math.round((completed / total) * 100);

            const badge = document.getElementById('completionPctBadge');
            const fill = document.getElementById('progressBarFill');
            const chip = document.getElementById('previewPctChip');
            const guidance = document.getElementById('progressGuidanceText');

            if (badge) badge.textContent = pct + '%';
            if (fill) fill.style.width = pct + '%';
            if (chip) chip.textContent = pct + '%';

            if (guidance) {
                if (pct === 100) {
                    guidance.textContent = '🎉 Profile is 100% complete! Your store is fully ready for admin verification.';
                } else if (!checks[0]) guidance.textContent = 'Enter your Full Legal Name to increase completion.';
                else if (!checks[1]) guidance.textContent = 'Enter your Shop / Business Name to increase completion.';
                else if (!checks[2]) guidance.textContent = 'Enter a valid 10-digit Phone number to increase completion.';
                else if (!checks[3]) guidance.textContent = 'Provide your Store / Landmark Address (min 10 chars).';
                else if (!checks[4] || !checks[5]) guidance.textContent = 'Select your State and City / District.';
                else if (!checks[6]) guidance.textContent = 'Enter a valid 6-digit postal Pincode.';
                else if (!checks[7]) guidance.textContent = 'Specify your Primary Product Category.';
                else if (!checks[8]) guidance.textContent = 'Specify your Brand / Listing Type.';
                else if (!checks[12]) guidance.textContent = 'Add a descriptive About / Brand Story for your store.';
                else guidance.textContent = 'Complete remaining contact & bank details to reach 100% completion.';
            }

            return pct;
        }

        // Run initial calculation
        setTimeout(recalculateProgress, 200);

        // --- LEAFLET MAP MODAL LOGIC ---
        const mapModal = document.getElementById('mapPickerModal');
        const btnOpenMap = document.getElementById('btnOpenMapPicker');
        const btnCloseMap = document.getElementById('btnCloseMapModal');
        const btnCancelMap = document.getElementById('btnCancelMap');
        const btnConfirmMap = document.getElementById('btnConfirmLocation');
        const btnSearchMap = document.getElementById('btnSearchMap');
        const btnLocateMe = document.getElementById('btnLocateMe');
        const mapSearchInput = document.getElementById('mapSearchInput');
        const mapSuggestions = document.getElementById('mapSuggestions');
        const mapSelectedAddress = document.getElementById('mapSelectedAddress');
        const mapPickerAlert = document.getElementById('mapPickerAlert');

        let leafletMap = null;
        let leafletMarker = null;
        let selectedCoords = null;
        let selectedAddressText = '';

        function showMapAlert(msg) {
            if (!mapPickerAlert) return;
            if (msg) {
                mapPickerAlert.textContent = msg;
                mapPickerAlert.style.display = 'block';
            } else {
                mapPickerAlert.style.display = 'none';
            }
        }

        function setMapSelected(addr, lat, lng) {
            selectedCoords = { lat, lng };
            selectedAddressText = addr;
            if (mapSelectedAddress) {
                mapSelectedAddress.textContent = addr || ('Location (' + lat.toFixed(5) + ', ' + lng.toFixed(5) + ')');
            }
            if (btnConfirmMap) btnConfirmMap.disabled = false;
        }

        async function reverseGeocodeCoords(lat, lng) {
            showMapAlert('');
            try {
                const res = await fetch(ctx + '/api/auth/geo/reverse?lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng), {
                    headers: { 'Accept': 'application/json' },
                    credentials: 'same-origin'
                });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.success && data.address) {
                        setMapSelected(data.address, lat, lng);
                        return;
                    }
                }
            } catch (e) {
                console.warn('[MapPicker] Reverse geocode error:', e);
            }
            // Fallback direct Nominatim
            try {
                const osmRes = await fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng + '&zoom=18&addressdetails=1');
                if (osmRes.ok) {
                    const osmData = await osmRes.json();
                    if (osmData && osmData.display_name) {
                        setMapSelected(osmData.display_name, lat, lng);
                        return;
                    }
                }
            } catch (e2) {}
            setMapSelected('Shop Location (' + lat.toFixed(5) + ', ' + lng.toFixed(5) + ')', lat, lng);
        }

        function initLeafletMap() {
            if (typeof L === 'undefined') {
                showMapAlert('Map library failed to load. Please check your internet connection.');
                return;
            }

            let defaultLat = 12.9716; // Bengaluru default
            let defaultLng = 77.5946;

            const savedLat = parseFloat(document.getElementById('inputLatitude')?.value);
            const savedLng = parseFloat(document.getElementById('inputLongitude')?.value);
            if (!isNaN(savedLat) && !isNaN(savedLng) && savedLat !== 0) {
                defaultLat = savedLat;
                defaultLng = savedLng;
            }

            if (leafletMap) {
                setTimeout(() => {
                    leafletMap.invalidateSize();
                    if (selectedCoords) {
                        leafletMap.setView([selectedCoords.lat, selectedCoords.lng], 15);
                        leafletMarker.setLatLng([selectedCoords.lat, selectedCoords.lng]);
                    }
                }, 150);
                return;
            }

            try {
                leafletMap = L.map('mapContainer', {
                    center: [defaultLat, defaultLng],
                    zoom: 13,
                    zoomControl: true
                });

                L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(leafletMap);

                leafletMarker = L.marker([defaultLat, defaultLng], {
                    draggable: true,
                    autoPan: true
                }).addTo(leafletMap);

                leafletMarker.on('dragend', function (e) {
                    const pos = e.target.getLatLng();
                    reverseGeocodeCoords(pos.lat, pos.lng);
                });

                leafletMap.on('click', function (e) {
                    const lat = e.latlng.lat;
                    const lng = e.latlng.lng;
                    leafletMarker.setLatLng([lat, lng]);
                    reverseGeocodeCoords(lat, lng);
                });

                setTimeout(() => {
                    leafletMap.invalidateSize();
                    reverseGeocodeCoords(defaultLat, defaultLng);
                }, 200);

            } catch (err) {
                console.error('[MapPicker] Leaflet init error:', err);
                showMapAlert('Could not render map. You can enter your address and map link manually.');
            }
        }

        async function executeMapSearch(query) {
            if (!query || !query.trim()) return;
            showMapAlert('');
            if (mapSuggestions) mapSuggestions.style.display = 'none';

            try {
                const res = await fetch(ctx + '/api/auth/geo/search?q=' + encodeURIComponent(query.trim()), {
                    headers: { 'Accept': 'application/json' },
                    credentials: 'same-origin'
                });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.success && data.results && data.results.length > 0) {
                        if (data.results.length === 1) {
                            applySearchResult(data.results[0]);
                        } else {
                            renderSuggestions(data.results);
                        }
                        return;
                    }
                }
            } catch (e) {}

            // Fallback to OpenStreetMap search
            try {
                const osmRes = await fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query.trim()) + '&limit=5');
                if (osmRes.ok) {
                    const osmData = await osmRes.json();
                    if (osmData && osmData.length > 0) {
                        const formatted = osmData.map(item => ({
                            address: item.display_name,
                            latitude: item.lat,
                            longitude: item.lon
                        }));
                        renderSuggestions(formatted);
                        return;
                    }
                }
            } catch (e2) {}

            showMapAlert('No location results found for "' + query + '". Try a landmark, area, or street name.');
        }

        function renderSuggestions(results) {
            if (!mapSuggestions) return;
            mapSuggestions.innerHTML = '';
            results.forEach(item => {
                const div = document.createElement('div');
                div.className = 'map-suggestion-item';
                div.textContent = item.address;
                div.addEventListener('click', () => {
                    applySearchResult(item);
                    mapSuggestions.style.display = 'none';
                });
                mapSuggestions.appendChild(div);
            });
            mapSuggestions.style.display = 'block';
        }

        function applySearchResult(item) {
            const lat = parseFloat(item.latitude || item.lat);
            const lng = parseFloat(item.longitude || item.lon || item.lng);
            if (!isNaN(lat) && !isNaN(lng)) {
                if (leafletMap && leafletMarker) {
                    leafletMap.setView([lat, lng], 16);
                    leafletMarker.setLatLng([lat, lng]);
                }
                setMapSelected(item.address, lat, lng);
            }
        }

        function closeMapModal() {
            if (mapModal) mapModal.style.display = 'none';
            if (mapSuggestions) mapSuggestions.style.display = 'none';
            showMapAlert('');
        }

        if (btnOpenMap) {
            btnOpenMap.addEventListener('click', () => {
                if (mapModal) mapModal.style.display = 'flex';
                initLeafletMap();
            });
        }

        if (btnCloseMap) btnCloseMap.addEventListener('click', closeMapModal);
        if (btnCancelMap) btnCancelMap.addEventListener('click', closeMapModal);

        if (btnSearchMap && mapSearchInput) {
            btnSearchMap.addEventListener('click', () => executeMapSearch(mapSearchInput.value));
            mapSearchInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    executeMapSearch(mapSearchInput.value);
                }
            });
        }

        if (btnLocateMe) {
            btnLocateMe.addEventListener('click', () => {
                if (!navigator.geolocation) {
                    showMapAlert('Geolocation is not supported by your browser.');
                    return;
                }
                btnLocateMe.disabled = true;
                showMapAlert('Requesting your GPS coordinates…');
                navigator.geolocation.getCurrentPosition(pos => {
                    btnLocateMe.disabled = false;
                    showMapAlert('');
                    const lat = pos.coords.latitude;
                    const lng = pos.coords.longitude;
                    if (leafletMap && leafletMarker) {
                        leafletMap.setView([lat, lng], 16);
                        leafletMarker.setLatLng([lat, lng]);
                    }
                    reverseGeocodeCoords(lat, lng);
                }, () => {
                    btnLocateMe.disabled = false;
                    showMapAlert('GPS location access was denied. You can click on the map to place your pin.');
                }, { timeout: 10000, enableHighAccuracy: true });
            });
        }

        if (btnConfirmMap) {
            btnConfirmMap.addEventListener('click', () => {
                if (!selectedCoords) return;

                // 1. Lat / Lng inputs
                const latInput = document.getElementById('inputLatitude');
                const lngInput = document.getElementById('inputLongitude');
                if (latInput) latInput.value = selectedCoords.lat.toFixed(6);
                if (lngInput) lngInput.value = selectedCoords.lng.toFixed(6);

                // 2. Map link
                const mapLink = document.getElementById('inputMapLink');
                if (mapLink) {
                    mapLink.value = 'https://www.google.com/maps?q=' + selectedCoords.lat.toFixed(6) + ',' + selectedCoords.lng.toFixed(6);
                }

                // 3. Address
                const addrInput = document.getElementById('address');
                if (addrInput && (!addrInput.value || addrInput.value.trim().length < 5) && selectedAddressText) {
                    addrInput.value = selectedAddressText;
                    validateAddress();
                }

                // 4. Try matching pincode
                if (selectedAddressText) {
                    const pinMatch = selectedAddressText.match(/\b([1-9][0-9]{5})\b/);
                    const pinInput = document.getElementById('pincode');
                    if (pinMatch && pinInput && !pinInput.value) {
                        pinInput.value = pinMatch[1];
                        validatePincode();
                    }
                }

                closeMapModal();
                recalculateProgress();
                updateLivePreview();
            });
        }

        // Close on ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && mapModal && mapModal.style.display === 'flex') {
                closeMapModal();
            }
        });

        // --- Form Submission Validation ---
        window.triggerProfileSave = function () {
            form.requestSubmit();
        };

        form.addEventListener('submit', function (e) {
            syncBankDetails();

            const isValidName = validateFullName();
            const isValidBusiness = validateBusinessName();
            const isValidPhone = validatePhone();
            const isValidDesignation = validateDesignation();
            const isValidAddress = validateAddress();
            const isValidState = validateState();
            const isValidCity = validateCity();
            const isValidPincode = validatePincode();
            const isValidCategory = validateCategory();
            const isValidBrand = validateBrandType();
            const isValidDays = validateAvailableDays();
            const isValidFrom = validateHoursFrom();
            const isValidTo = validateHoursTo();
            const isValidDesc = validateDescription();
            const isValidAccountMatch = validateAccountMatch();
            const isValidIfsc = validateIfsc();
            const isValidUpi = validateUpi();
            const isValidGstin = validateGstin();
            const isValidWhatsapp = validateWhatsapp();

            const allValid = isValidName && isValidBusiness && isValidPhone && isValidDesignation
                && isValidAddress && isValidState && isValidCity && isValidPincode && isValidCategory
                && isValidBrand && isValidDays && isValidFrom && isValidTo && isValidDesc
                && isValidAccountMatch && isValidIfsc && isValidUpi && isValidGstin && isValidWhatsapp;

            if (!allValid) {
                e.preventDefault();
                // Scroll to first invalid field
                const firstInvalid = form.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
                return false;
            }
        });
    })();
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
