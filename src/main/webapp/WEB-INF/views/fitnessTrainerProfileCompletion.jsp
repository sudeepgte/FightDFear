<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Coach Profile — Fight D Fear</title>

    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Leaflet Map CSS for Map Picker (CSP whitelisted) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">

    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --rose-soft: #FFF1F2;
            --rose-light: #FFE4E6;
            --rose-border: #FECDD3;
            --navy: #0F172A;
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

        .header-brand i { color: var(--primary); font-size: 1.35rem; }

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

        .btn-skip, .btn-header-draft, .btn-primary, .btn-secondary {
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

        .btn-skip, .btn-header-draft {
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
        }

        .btn-skip:hover, .btn-header-draft:hover {
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

        .btn-primary:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Main Container */
        .main-container {
            flex: 1;
            width: 100%;
            max-width: 1380px;
            margin: 20px auto 60px;
            padding: 0 clamp(16px, 3vw, 40px);
            box-sizing: border-box;
        }

        /* Banner Notifications */
        .alert-banner {
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 0.9rem;
            line-height: 1.45;
        }

        .alert-banner i { font-size: 1.15rem; flex-shrink: 0; margin-top: 1px; }
        .alert-banner.alert-success { background: var(--success-bg); color: #166534; border: 1px solid #BBF7D0; }
        .alert-banner.alert-error { background: var(--error-bg); color: #991B1B; border: 1px solid #FECACA; }
        .alert-banner.alert-warning { background: var(--warning-bg); color: #9A3412; border: 1px solid #FED7AA; }
        .alert-banner.alert-info { background: #EFF6FF; color: #1E40AF; border: 1px solid #BFDBFE; }

        /* Progress Card */
        .profile-progress-card {
            background: #FFFFFF;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 20px 24px;
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 12px;
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

        .progress-pct {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--rose-soft);
            border: 1px solid var(--rose-border);
            padding: 4px 12px;
            border-radius: 999px;
            transition: all 0.3s;
        }

        .progress-pct.complete {
            background: var(--success-bg);
            color: var(--success);
            border-color: #BBF7D0;
        }

        .progress-bar-container {
            height: 10px;
            background: #E2E8F0;
            border-radius: 999px;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E 0%, #FB7185 100%);
            border-radius: 999px;
            width: 0%;
            transition: width 0.35s ease;
        }

        .progress-bar-fill.complete {
            background: linear-gradient(90deg, #16A34A 0%, #22C55E 100%);
        }

        .progress-guidance {
            font-size: 0.88rem;
            color: var(--text-gray);
            line-height: 1.5;
        }

        .progress-guidance strong { color: var(--navy); }

        .missing-list {
            margin-top: 12px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .missing-chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.78rem;
            font-weight: 600;
            background: #FFF7ED;
            color: #C2410C;
            border: 1px solid #FED7AA;
            border-radius: 6px;
            padding: 4px 9px;
            transition: all 0.2s;
        }

        /* Section Cards */
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 30px);
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 4px;
        }

        .section-header i { color: var(--primary); font-size: 1.25rem; }

        .section-desc {
            font-size: 0.85rem;
            color: var(--text-gray);
            margin-bottom: 20px;
        }

        /* Form Controls & Grid */
        .form-grid-2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: 1 / -1;
            margin-bottom: 16px;
        }

        label {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
        }

        .req { color: var(--primary); font-weight: 800; }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            height: 44px;
            padding: 10px 14px;
            border-radius: 10px;
            border: 1.5px solid var(--border-color);
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: border-color 0.2s, box-shadow 0.2s, background-color 0.2s;
            outline: none;
        }

        .form-textarea {
            height: auto;
            min-height: 110px;
            resize: vertical;
            line-height: 1.5;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            background-color: var(--error-bg);
        }

        .form-input.is-valid, .form-select.is-valid, .form-textarea.is-valid {
            border-color: var(--success);
            background-color: var(--success-bg);
        }

        .error-msg {
            color: var(--error);
            font-size: 0.78rem;
            font-weight: 600;
            margin-top: 5px;
            display: none;
            align-items: center;
            gap: 5px;
        }

        .error-msg.show { display: flex; }

        .helper-text {
            font-size: 0.78rem;
            color: var(--text-gray);
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Checkbox & Radio Badges / Pills */
        .chip-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 10px;
            margin-top: 6px;
        }

        .chip-item {
            position: relative;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            background: #FFFFFF;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            transition: all 0.2s ease;
            user-select: none;
        }

        .chip-item:hover {
            border-color: #CBD5E1;
            background: #F8FAFC;
        }

        .chip-item input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
            cursor: pointer;
        }

        .chip-item.active {
            border-color: var(--primary);
            background: var(--rose-soft);
            color: var(--primary);
            font-weight: 700;
        }

        /* Location Bar with Map Picker */
        .location-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 8px;
        }

        .btn-map-picker {
            background: #FFFFFF;
            border: 1.5px solid var(--primary);
            color: var(--primary);
            font-size: 0.82rem;
            font-weight: 700;
            border-radius: 8px;
            padding: 6px 12px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-map-picker:hover {
            background: var(--rose-soft);
            transform: translateY(-1px);
        }

        /* File Upload Cards */
        .file-upload-box {
            border: 2px dashed #CBD5E1;
            border-radius: 12px;
            padding: 18px 20px;
            background: #F8FAFC;
            transition: border-color 0.2s, background-color 0.2s;
        }

        .file-upload-box:hover {
            border-color: var(--primary);
            background: var(--rose-soft);
        }

        .file-upload-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .avatar-preview {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--rose-border);
            background: #FFE4E6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--primary);
            overflow: hidden;
            flex-shrink: 0;
        }

        .gallery-preview-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 12px;
        }

        .gallery-thumb {
            width: 76px;
            height: 76px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid var(--border-color);
        }

        .existing-file-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            background: #F1F5F9;
            color: #334155;
            padding: 4px 10px;
            border-radius: 6px;
            margin-top: 8px;
            border: 1px solid #E2E8F0;
        }

        /* Action Buttons Area */
        .bottom-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 14px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            flex-wrap: wrap;
        }

        .btn-bottom-save {
            padding: 13px 28px;
            font-size: 0.95rem;
            border-radius: 12px;
        }

        /* Leaflet Map Picker Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.72);
            backdrop-filter: blur(5px);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
            overflow-y: auto;
        }

        .map-modal-card {
            background: #FFFFFF;
            width: 100%;
            max-width: 820px;
            border-radius: 20px;
            padding: 22px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            display: flex;
            flex-direction: column;
            gap: 12px;
            animation: modalPop 0.2s ease-out;
            max-height: 92vh;
            overflow-y: auto;
        }

        @keyframes modalPop {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        .modal-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-close-modal {
            background: transparent;
            border: none;
            font-size: 1.6rem;
            line-height: 1;
            color: var(--text-gray);
            cursor: pointer;
            padding: 4px;
            border-radius: 6px;
        }

        .btn-close-modal:hover { color: var(--navy); }

        .map-search-row {
            display: flex;
            gap: 8px;
            position: relative;
        }

        .map-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            margin-top: 4px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: var(--shadow-float);
            display: none;
        }

        .map-suggestion-item {
            padding: 10px 14px;
            font-size: 0.85rem;
            cursor: pointer;
            border-bottom: 1px solid #F1F5F9;
        }

        .map-suggestion-item:hover { background: #F8FAFC; color: var(--primary); }

        .map-canvas-wrap {
            width: 100%;
            height: 360px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            background: #E2E8F0;
        }

        .map-selected-bar {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.85rem;
            color: var(--navy);
        }

        /* Review Modal */
        .review-modal-card {
            background: #FFFFFF;
            width: 100%;
            max-width: 860px;
            border-radius: 20px;
            max-height: 90vh;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border: 1px solid var(--rose-border);
            animation: modalPop 0.2s ease-out;
        }

        .review-modal-body {
            padding: 22px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .review-section-box {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 14px 18px;
        }

        .review-section-title {
            font-size: 0.85rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-gray);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .review-item {
            margin-bottom: 6px;
        }

        .review-item-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-gray);
            text-transform: uppercase;
        }

        .review-item-val {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--navy);
        }

        .review-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px 16px;
        }

        /* Responsive Breakpoints */
        @media (max-width: 768px) {
            .form-grid-2 { grid-template-columns: 1fr; }
            .review-grid-2 { grid-template-columns: 1fr; }
            .chip-grid { grid-template-columns: repeat(2, 1fr); }
            .app-header { padding: 12px 16px; }
            .section-card { padding: 16px; }
            .map-canvas-wrap { height: 260px; }
        }

        @media (max-width: 480px) {
            .chip-grid { grid-template-columns: 1fr; }
            .header-actions { width: 100%; justify-content: flex-end; }
            .bottom-actions { justify-content: stretch; }
            .bottom-actions button { width: 100%; }
        }
    </style>
</head>
<body>

    <!-- App Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="header-brand">
            <i class="bi bi-heart-pulse-fill"></i>
            <span>Fight D Fear</span>
            <span class="portal-badge">Fitness Coach</span>
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="btn-skip">
                <i class="bi bi-arrow-left"></i> Studio Dashboard
            </a>
            <button type="button" class="btn-header-draft" onclick="submitProfile('saveDraft')">
                <i class="bi bi-save"></i> Save Draft
            </button>
            <button type="button" class="btn-primary" onclick="openReviewModal()">
                <i class="bi bi-check2-circle"></i> Review &amp; Submit
            </button>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-container">

        <!-- Flash Messages -->
        <c:if test="${not empty error}">
            <div class="alert-banner alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div><c:out value="${error}"/></div>
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert-banner alert-success">
                <i class="bi bi-check-circle-fill"></i>
                <div><c:out value="${success}"/></div>
            </div>
        </c:if>
        <c:if test="${not empty info}">
            <div class="alert-banner alert-info">
                <i class="bi bi-info-circle-fill"></i>
                <div><c:out value="${info}"/></div>
            </div>
        </c:if>
        <c:if test="${not empty trainer.rejectionReason}">
            <div class="alert-banner alert-warning">
                <i class="bi bi-shield-exclamation"></i>
                <div>
                    <strong>Verification Feedback:</strong>
                    <p style="margin-top: 4px;"><c:out value="${trainer.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Profile Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <div class="progress-title-wrap">
                    <span class="progress-title">Profile Completion Progress</span>
                    <span class="progress-pct" id="progressPctBadge">${profileCompletionPct}% Complete</span>
                </div>
                <div style="font-size: 0.85rem; font-weight: 700; color: var(--text-gray);" id="completionStatusText">
                    <c:choose>
                        <c:when test="${profileCompletionPct >= 100}">
                            <span style="color: var(--success);"><i class="bi bi-check-circle-fill"></i> All required items ready</span>
                        </c:when>
                        <c:otherwise>
                            <span>18 Required Items</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="progress-bar-container">
                <div class="progress-bar-fill" id="progressBarFill" style="width: ${profileCompletionPct}%;"></div>
            </div>

            <div class="progress-guidance" id="progressGuidanceText">
                Complete all required details so client members can find and book your training sessions with confidence.
            </div>

            <!-- Missing Items Chips -->
            <div class="missing-list" id="missingListChips">
                <c:forEach var="item" items="${missingItems}">
                    <span class="missing-chip" data-item="${item}">
                        <i class="bi bi-dash-circle"></i> ${item}
                    </span>
                </c:forEach>
            </div>
        </div>

        <!-- Main Form -->
        <form id="trainerProfileForm" action="${pageContext.request.contextPath}/fitness/trainer/updateProfile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="id" value="${trainer.id}">
            <input type="hidden" name="intent" id="formIntent" value="submitVerification">
            <input type="hidden" name="latitude" id="inputLatitude" value="${trainer.latitude}">
            <input type="hidden" name="longitude" id="inputLongitude" value="${trainer.longitude}">
            <input type="hidden" name="bankDetails" id="bankDetails" value="<c:out value='${trainer.bankDetails}'/>">

            <!-- Section 1: Professional Identity -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-person-badge"></i>
                    <span>1. Identity &amp; Professional Credentials</span>
                </div>
                <p class="section-desc">Your verified coaching name, credentials, and official contact details.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="inputFullName">Full Name <span class="req">*</span></label>
                        <input type="text" name="fullName" id="inputFullName" class="form-input" value="<c:out value='${trainer.fullName}'/>" placeholder="e.g. Coach Sarah Sharma" maxlength="80">
                        <div class="error-msg" id="err-fullName"><i class="bi bi-exclamation-circle-fill"></i> Full Name is required (minimum 3 letters, alphabets only).</div>
                    </div>

                    <div class="form-group">
                        <label for="inputDesignation">Primary Designation <span class="req">*</span></label>
                        <select name="designation" id="inputDesignation" class="form-select">
                            <option value="">-- Select Coaching Designation --</option>
                            <c:forEach var="desig" items="Certified Fitness Coach,Yoga & Meditation Instructor,Strength & Conditioning Coach,Functional Training Specialist,Pilates Instructor,Weight Loss & Nutrition Coach,Martial Arts & Self-Defense Coach,Senior Fitness Specialist,Post-Rehab & Corrective Exercise Coach,Personal Trainer">
                                <option value="${desig}" ${trainer.designation == desig ? 'selected' : ''}>${desig}</option>
                            </c:forEach>
                        </select>
                        <div class="error-msg" id="err-designation"><i class="bi bi-exclamation-circle-fill"></i> Please select your primary coaching designation.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputPhone">Official Phone Number <span class="req">*</span></label>
                        <input type="tel" name="phone" id="inputPhone" class="form-input" value="<c:out value='${trainer.phone}'/>" placeholder="10-digit mobile number" maxlength="10">
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputWhatsapp">WhatsApp Number (Optional)</label>
                        <input type="tel" name="whatsappNumber" id="inputWhatsapp" class="form-input" value="<c:out value='${trainer.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                        <div class="error-msg" id="err-whatsapp"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit WhatsApp number starting with 6, 7, 8, or 9.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputExperience">Years of Experience <span class="req">*</span></label>
                        <input type="number" name="experience" id="inputExperience" class="form-input" value="${trainer.experience != null ? trainer.experience : 1}" min="0" max="50">
                        <div class="error-msg" id="err-experience"><i class="bi bi-exclamation-circle-fill"></i> Experience must be a number between 0 and 50 years.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputCredential">Credential / Certification Reg. ID <span class="req">*</span></label>
                        <input type="text" name="credentialNumber" id="inputCredential" class="form-input" value="<c:out value='${trainer.credentialNumber}'/>" placeholder="e.g. ACE-192842 or RYT-200" maxlength="60">
                        <div class="error-msg" id="err-credentialNumber"><i class="bi bi-exclamation-circle-fill"></i> Credential Registration / Certification ID is required.</div>
                    </div>
                </div>
            </div>

            <!-- Section 2: Studio / Training Location -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-geo-alt"></i>
                    <span>2. Studio &amp; Operational Location</span>
                </div>
                <p class="section-desc">Define where your studio is based or where you offer client coaching.</p>

                <div class="location-action-bar">
                    <span style="font-size: 0.88rem; font-weight: 700; color: var(--navy);">Select Exact Physical Location</span>
                    <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                        <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                    </button>
                </div>

                <div class="form-group full">
                    <label for="inputAddress">Studio Address or Home Base <span class="req">*</span></label>
                    <input type="text" name="address" id="inputAddress" class="form-input" value="<c:out value='${trainer.address}'/>" placeholder="Building, street, studio name or landmark" maxlength="255">
                    <div class="error-msg" id="err-address"><i class="bi bi-exclamation-circle-fill"></i> Studio address is required (minimum 5 characters).</div>
                </div>

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
                        <label for="stateSelect">
                            State / UT <span class="req">*</span>
                            <span id="stateSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading...</span>
                        </label>
                        <select name="state" id="stateSelect" class="form-select">
                            <option value="">-- Select State / UT --</option>
                        </select>
                        <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> State is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="districtSelect">
                            City / District <span class="req">*</span>
                            <span id="districtSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading...</span>
                        </label>
                        <select id="districtSelect" class="form-select">
                            <option value="">-- Select State First --</option>
                        </select>
                        <input type="hidden" name="city" id="inputCity" value="<c:out value='${trainer.city}'/>">
                        <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> City / District is required.</div>
                    </div>

                    <div class="form-group" id="customCityGroup" style="display:none;">
                        <label for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                        <input type="text" id="customCityInput" class="form-input" placeholder="Enter your city / town name" maxlength="60">
                        <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputPincode">Postal Pincode <span class="req">*</span></label>
                        <input type="text" name="pincode" id="inputPincode" class="form-input" value="<c:out value='${trainer.pincode}'/>" placeholder="6-digit Pincode" maxlength="6">
                        <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 6-digit postal pincode.</div>
                    </div>

                    <div class="form-group full">
                        <label for="inputMapLink">Google Maps Location Link (Auto-filled via Map Picker)</label>
                        <input type="url" name="mapLink" id="inputMapLink" class="form-input" placeholder="https://maps.google.com/?q=... or select on map above">
                        <div class="error-msg" id="err-mapLink"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid URL starting with http:// or https://</div>
                    </div>
                </div>
            </div>

            <!-- Section 3: Specializations & Categories -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-lightning-charge"></i>
                    <span>3. Coaching Categories &amp; Specializations</span>
                </div>
                <p class="section-desc">Select the fitness categories and workout styles you offer (minimum 1 required).</p>

                <div class="chip-grid">
                    <c:forEach var="cat" items="Yoga,Pilates,HIIT,Strength Training,Zumba / Dance Fitness,Cardio / Aerobics,CrossFit,Weight Loss,Post-Natal Fitness,Self-Defense & Kickboxing,Nutrition & Diet Coaching,Flexibility & Mobility">
                        <label class="chip-item ${trainer.specializations != null && trainer.specializations.contains(cat) ? 'active' : ''}">
                            <input type="checkbox" name="specializations" class="spec-checkbox" value="${cat}" ${trainer.specializations != null && trainer.specializations.contains(cat) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                            <span>${cat}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-specializations" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one coaching specialization.</div>
            </div>

            <!-- Section 4: Target Audience & Doorstep Service -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-people"></i>
                    <span>4. Target Audience &amp; Training Modality</span>
                </div>
                <p class="section-desc">Specify who you coach and whether you visit client locations.</p>

                <label style="margin-bottom: 8px;">Target Client Audience <span class="req">*</span></label>
                <div class="chip-grid">
                    <c:forEach var="aud" items="Women Only,Beginners,Intermediate & Advanced,Teens (13-19),Seniors (50+),Post-Natal Mothers,Corporate Employees">
                        <label class="chip-item ${trainer.audience != null && trainer.audience.contains(aud) ? 'active' : ''}">
                            <input type="checkbox" name="audience" class="aud-checkbox" value="${aud}" ${trainer.audience != null && trainer.audience.contains(aud) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                            <span>${aud}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-audience" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one target client audience.</div>

                <div style="margin-top: 20px; padding: 14px 16px; background: #F8FAFC; border: 1px solid var(--border-color); border-radius: 12px; display: flex; align-items: center; gap: 12px;">
                    <input type="checkbox" name="doorstepService" id="inputDoorstep" value="true" ${trainer.doorService == true ? 'checked' : ''} style="width: 18px; height: 18px; accent-color: var(--primary); cursor: pointer;">
                    <label for="inputDoorstep" style="margin: 0; font-weight: 600; cursor: pointer;">
                        I offer doorstep / home visits (training at client's home or residential society)
                    </label>
                </div>
            </div>

            <!-- Section 5: Studio Amenities & Facilities -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-building-check"></i>
                    <span>5. Studio Amenities &amp; Facilities</span>
                </div>
                <p class="section-desc">Select available facilities at your studio location (optional).</p>

                <div class="chip-grid">
                    <c:forEach var="fac" items="Private Studio,Changing Room,Shower,Locker,AC,Free Weights,Cardio Equipment,Mirrors,Parking">
                        <label class="chip-item ${trainer.facilities != null && trainer.facilities.contains(fac) ? 'active' : ''}">
                            <input type="checkbox" name="facilities" class="fac-checkbox" value="${fac}" ${trainer.facilities != null && trainer.facilities.contains(fac) ? 'checked' : ''} onchange="toggleChipActive(this);">
                            <span>${fac}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- Section 6: Working Hours & Availability -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-clock-history"></i>
                    <span>6. Working Days &amp; Schedule</span>
                </div>
                <p class="section-desc">Set your operating days and everyday coaching availability hours.</p>

                <label style="margin-bottom: 8px;">Available Operating Days <span class="req">*</span></label>
                <div class="chip-grid" style="grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));">
                    <c:forEach var="day" items="Mon,Tue,Wed,Thu,Fri,Sat,Sun">
                        <label class="chip-item ${trainer.openDays != null && trainer.openDays.contains(day) ? 'active' : ''}">
                            <input type="checkbox" name="availableDays" class="day-checkbox" value="${day}" ${trainer.openDays != null && trainer.openDays.contains(day) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                            <span>${day}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-availableDays" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one working day.</div>

                <div class="form-grid-2" style="margin-top: 18px;">
                    <div class="form-group">
                        <label for="inputOpenTime">Opening / First Session Time <span class="req">*</span></label>
                        <input type="time" name="openTime" id="inputOpenTime" class="form-input" value="${trainer.openTime != null ? trainer.openTime : '06:00'}">
                        <div class="error-msg" id="err-openTime"><i class="bi bi-exclamation-circle-fill"></i> Opening time is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputCloseTime">Closing / Last Session Time <span class="req">*</span></label>
                        <input type="time" name="closeTime" id="inputCloseTime" class="form-input" value="${trainer.closeTime != null ? trainer.closeTime : '20:00'}">
                        <div class="error-msg" id="err-closeTime"><i class="bi bi-exclamation-circle-fill"></i> Closing time must be after opening time.</div>
                    </div>
                </div>
            </div>

            <!-- Section 7: About You & Bio -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-chat-quote"></i>
                    <span>7. About You &amp; Coaching Philosophy</span>
                </div>
                <p class="section-desc">Share your background, client transformations, and coaching philosophy.</p>

                <div class="form-group full">
                    <label for="inputBio">Bio &amp; Coaching Approach <span class="req">*</span></label>
                    <textarea name="bio" id="inputBio" class="form-textarea" rows="4" placeholder="Describe your coaching philosophy, certifications, who you help, and your transformation stories (min 20 characters)..."><c:out value="${trainer.bio}"/></textarea>
                    <div class="error-msg" id="err-bio"><i class="bi bi-exclamation-circle-fill"></i> Bio is required (minimum 20 characters describing your coaching approach).</div>
                    <div class="helper-text"><i class="bi bi-text-paragraph"></i> <span id="bioCharCount">0</span> characters entered (min 20)</div>
                </div>
            </div>

            <!-- Section 8: Typical Session & Pricing -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-cash-stack"></i>
                    <span>8. Session Format &amp; Pricing</span>
                </div>
                <p class="section-desc">Standard session format and typical single-session pricing for client booking.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="inputSessionMode">Primary Session Mode <span class="req">*</span></label>
                        <select name="sessionMode" id="inputSessionMode" class="form-select">
                            <option value="In-Person Studio" ${trainer.sessionMode == 'In-Person Studio' ? 'selected' : ''}>In-Person Studio</option>
                            <option value="Home / Client Location" ${trainer.sessionMode == 'Home / Client Location' ? 'selected' : ''}>Home / Client Location</option>
                            <option value="Online 1-on-1" ${trainer.sessionMode == 'Online 1-on-1' ? 'selected' : ''}>Online 1-on-1</option>
                            <option value="Hybrid" ${trainer.sessionMode == 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                        </select>
                        <div class="error-msg" id="err-sessionMode"><i class="bi bi-exclamation-circle-fill"></i> Session mode is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputSessionDuration">Session Duration <span class="req">*</span></label>
                        <select name="sessionDuration" id="inputSessionDuration" class="form-select">
                            <option value="30" ${trainer.durationMinutes == 30 ? 'selected' : ''}>30 minutes</option>
                            <option value="45" ${trainer.durationMinutes == 45 ? 'selected' : ''}>45 minutes</option>
                            <option value="60" ${trainer.durationMinutes == 60 || trainer.durationMinutes == null ? 'selected' : ''}>60 minutes</option>
                            <option value="90" ${trainer.durationMinutes == 90 ? 'selected' : ''}>90 minutes</option>
                        </select>
                        <div class="error-msg" id="err-sessionDuration"><i class="bi bi-exclamation-circle-fill"></i> Session duration is required.</div>
                    </div>

                    <div class="form-group full">
                        <label for="inputSessionFees">Typical Single-Session Fee (₹, 0 = free initial assessment) <span class="req">*</span></label>
                        <input type="number" name="sessionFees" id="inputSessionFees" class="form-input" value="${trainer.typicalPrice != null ? trainer.typicalPrice : (trainer.sessionFees != null ? trainer.sessionFees : 300)}" min="0" step="10">
                        <div class="error-msg" id="err-sessionFees"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid session fee (minimum 0).</div>
                    </div>
                </div>
            </div>

            <!-- Section 9: Payout & Bank Details -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-bank"></i>
                    <span>9. Payout &amp; Direct Bank Account</span>
                </div>
                <p class="section-desc">Bank account and UPI for receiving direct client session payouts.</p>

                <div class="form-group full">
                    <label for="inputUpiId">UPI ID (VPA for Instant Payouts)</label>
                    <input type="text" name="upiId" id="inputUpiId" class="form-input" value="<c:out value='${trainer.upiId}'/>" placeholder="e.g. coachname@okhdfcbank">
                    <div class="error-msg" id="err-upiId"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid UPI ID (e.g. name@bank).</div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="bankAccountHolder">Account Holder Name</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank passbook">
                        <div class="error-msg" id="err-bankAccountHolder"><i class="bi bi-exclamation-circle-fill"></i> Account holder name is required when bank account is provided.</div>
                    </div>

                    <div class="form-group">
                        <label for="bankName">Bank Name</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. HDFC Bank, SBI, ICICI">
                        <div class="error-msg" id="err-bankName"><i class="bi bi-exclamation-circle-fill"></i> Bank name is required when bank account is provided.</div>
                    </div>

                    <div class="form-group">
                        <label for="bankAccountNumber">Bank Account Number</label>
                        <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="9 to 18 numeric digits" maxlength="18" inputmode="numeric">
                        <div class="error-msg" id="err-bankAccountNumber"><i class="bi bi-exclamation-circle-fill"></i> Account number must be between 9 and 18 digits.</div>
                    </div>

                    <div class="form-group">
                        <label for="confirmAccountNumber">Re-enter Bank Account Number</label>
                        <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Re-enter bank account number" maxlength="18" inputmode="numeric">
                        <div class="error-msg" id="err-confirmAccountNumber"><i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match.</div>
                    </div>

                    <div class="form-group">
                        <label for="bankIfsc">IFSC Code</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. HDFC0001234" maxlength="11" style="text-transform: uppercase;">
                        <div class="error-msg" id="err-bankIfsc"><i class="bi bi-exclamation-circle-fill"></i> Invalid IFSC format (e.g. SBIN0001234).</div>
                    </div>

                    <div class="form-group">
                        <label for="bankBranch">Branch Name (Optional)</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Indiranagar Branch">
                    </div>
                </div>
            </div>

            <!-- Section 10: Documents & Certifications -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-file-earmark-medical"></i>
                    <span>10. Profile Photo &amp; Coach Certification</span>
                </div>
                <p class="section-desc">Upload your profile headshot and certification scan for admin verification.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>10.1 Profile Photo (Headshot)</label>
                        <div class="file-upload-box">
                            <div class="file-upload-row">
                                <div class="avatar-preview" id="avatarPreviewContainer">
                                    <c:choose>
                                        <c:when test="${not empty trainer.profilePhotoPath}">
                                            <img id="avatarPreviewImg" src="${trainer.profilePhotoPath}" style="width:100%;height:100%;object-fit:cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-person-fill" id="avatarFallbackIcon"></i>
                                            <img id="avatarPreviewImg" src="" style="width:100%;height:100%;object-fit:cover;display:none;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="flex:1;">
                                    <input type="file" name="profilePhotoFile" id="inputProfilePhoto" class="form-input" accept="image/jpeg,image/png,image/webp">
                                    <div class="helper-text"><i class="bi bi-info-circle"></i> JPEG, PNG, WEBP up to 5MB</div>
                                </div>
                            </div>
                            <c:if test="${not empty trainer.profilePhotoPath}">
                                <div class="existing-file-tag"><i class="bi bi-check-circle-fill" style="color:var(--success);"></i> Profile photo currently on file</div>
                            </c:if>
                        </div>
                        <div class="error-msg" id="err-profilePhoto"><i class="bi bi-exclamation-circle-fill"></i> Please select an image file under 5MB.</div>
                    </div>

                    <div class="form-group">
                        <label>10.2 Certification Scan <span class="req">*</span></label>
                        <div class="file-upload-box">
                            <input type="file" name="certificateFile" id="inputCertificateFile" class="form-input" accept=".pdf,image/jpeg,image/png,image/webp">
                            <div class="helper-text"><i class="bi bi-info-circle"></i> PDF or image scan up to 10MB</div>
                            <c:if test="${not empty trainer.certificationsPath}">
                                <div class="existing-file-tag"><i class="bi bi-check-circle-fill" style="color:var(--success);"></i> Certification document on file</div>
                            </c:if>
                        </div>
                        <div class="error-msg" id="err-certificateFile"><i class="bi bi-exclamation-circle-fill"></i> Certification document is required (PDF or image under 10MB).</div>
                    </div>
                </div>
            </div>

            <!-- Section 11: Studio & Training Gallery -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-images"></i>
                    <span>11. Studio Photos &amp; Workout Gallery <span class="req">*</span></span>
                </div>
                <p class="section-desc">Showcase your training environment, workout space, or coaching sessions.</p>

                <div class="form-group full">
                    <div class="file-upload-box">
                        <input type="file" name="galleryFiles" id="inputGalleryFiles" class="form-input" accept="image/jpeg,image/png,image/webp" multiple>
                        <div class="helper-text"><i class="bi bi-info-circle"></i> Select one or more images (JPEG, PNG, WEBP, up to 5MB each)</div>

                        <!-- Gallery Thumbnails Preview -->
                        <div class="gallery-preview-grid" id="galleryPreviewContainer">
                            <c:if test="${not empty trainer.galleryPhotos}">
                                <c:forEach var="photo" items="${fn:split(trainer.galleryPhotos, ',')}">
                                    <c:if test="${not empty fn:trim(photo)}">
                                        <img src="${fn:trim(photo)}" class="gallery-thumb" title="Existing photo">
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                    <div class="error-msg" id="err-galleryFiles"><i class="bi bi-exclamation-circle-fill"></i> Studio photos are required (upload at least 1 image under 5MB).</div>
                </div>
            </div>

            <!-- Bottom Action Area -->
            <div class="bottom-actions">
                <button type="button" class="btn-skip" onclick="submitProfile('saveDraft')">
                    <i class="bi bi-save"></i> Save Draft
                </button>
                <button type="button" class="btn-primary btn-bottom-save" onclick="openReviewModal()">
                    <i class="bi bi-clipboard-check-fill"></i> Review Profile &amp; Submit
                </button>
            </div>
        </form>
    </main>

    <!-- ====================================================
         LEAFLET MAP MODAL (OpenStreetMap + CSP Compliant)
         ==================================================== -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle">
        <div class="map-modal-card">
            <div class="modal-header-row">
                <div class="modal-title">
                    <i class="bi bi-geo-alt-fill" style="color:var(--primary);"></i>
                    <span id="mapModalTitle">Select Studio / Coaching Location</span>
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

            <div id="mapPickerAlert" class="alert-banner alert-warning" style="display:none; padding:8px 12px; margin-bottom:0;"></div>

            <div class="map-canvas-wrap">
                <div id="mapContainer" style="width:100%; height:100%;"></div>
            </div>

            <div class="map-selected-bar">
                <div style="font-size:0.75rem; font-weight:700; color:var(--text-gray); text-transform:uppercase; margin-bottom:2px;">Selected Location</div>
                <div id="mapSelectedAddress" style="font-weight:600; color:var(--navy);">Click on the map or search above to pin your studio location</div>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:4px;">
                <button type="button" class="btn-skip" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-primary" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Confirm Location
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================================
         PROFILE REVIEW MODAL
         ==================================================== -->
    <div id="profileReviewModalBackdrop" class="modal-overlay" onclick="handleReviewBackdropClick(event)">
        <div class="review-modal-card">
            <div class="modal-header-row" style="padding: 18px 22px;">
                <div class="modal-title">
                    <i class="bi bi-clipboard-check-fill" style="color: var(--primary);"></i>
                    <span>Review Coach Profile Summary</span>
                </div>
                <button type="button" class="btn-close-modal" onclick="closeReviewModal()" aria-label="Close">&times;</button>
            </div>

            <div class="review-modal-body">
                <!-- Summary Card -->
                <div style="background: linear-gradient(135deg, #FFF1F2 0%, #FFFFFF 100%); border: 1px solid var(--rose-border); border-radius: 14px; padding: 16px 20px; display: flex; align-items: center; gap: 16px;">
                    <div style="width: 64px; height: 64px; border-radius: 50%; overflow: hidden; border: 2px solid var(--rose-border); background: #FFE4E6; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <img id="modalRevAvatarImg" src="${not empty trainer.profilePhotoPath ? trainer.profilePhotoPath : ''}" style="width: 100%; height: 100%; object-fit: cover; ${empty trainer.profilePhotoPath ? 'display:none;' : ''}">
                        <div id="modalRevAvatarFallback" style="font-size: 1.8rem; color: var(--primary); ${not empty trainer.profilePhotoPath ? 'display:none;' : ''}">
                            <i class="bi bi-person-fill"></i>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 6px;">
                            <span id="modalRevFullName">${not empty trainer.fullName ? trainer.fullName : 'Coach Name'}</span>
                            <i class="bi bi-patch-check-fill" style="color:var(--success);"></i>
                        </div>
                        <div id="modalRevDesignation" style="font-size: 0.88rem; font-weight: 700; color: var(--primary); margin-bottom: 2px;">
                            ${not empty trainer.designation ? trainer.designation : 'Certified Fitness Coach'}
                        </div>
                        <div style="font-size: 0.8rem; color: var(--text-gray);">
                            <span id="modalRevExp">${trainer.experience != null ? trainer.experience : 0} Years Exp</span> &bull; 
                            <span id="modalRevCityState">${not empty trainer.city ? trainer.city : 'City'}, ${not empty trainer.state ? trainer.state : 'State'}</span>
                        </div>
                    </div>
                </div>

                <!-- 1. Identity -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-person-badge"></i> 1. Identity &amp; Contact Details</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Full Name</div><div class="review-item-val" id="revValName">—</div></div>
                        <div class="review-item"><div class="review-item-label">Designation</div><div class="review-item-val" id="revValDesig">—</div></div>
                        <div class="review-item"><div class="review-item-label">Official Phone</div><div class="review-item-val" id="revValPhone">—</div></div>
                        <div class="review-item"><div class="review-item-label">WhatsApp</div><div class="review-item-val" id="revValWhatsapp">—</div></div>
                        <div class="review-item"><div class="review-item-label">Experience</div><div class="review-item-val" id="revValExperience">—</div></div>
                        <div class="review-item"><div class="review-item-label">Credential ID</div><div class="review-item-val" id="revValCredential">—</div></div>
                    </div>
                </div>

                <!-- 2. Studio / Location -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-geo-alt"></i> 2. Studio &amp; Location</div>
                    <div class="review-grid-2">
                        <div class="review-item" style="grid-column: 1 / -1;"><div class="review-item-label">Studio Address</div><div class="review-item-val" id="revValAddress">—</div></div>
                        <div class="review-item"><div class="review-item-label">City, State &amp; Country</div><div class="review-item-val" id="revValCityState">—</div></div>
                        <div class="review-item"><div class="review-item-label">Pincode</div><div class="review-item-val" id="revValPincode">—</div></div>
                    </div>
                </div>

                <!-- 3. Specializations & Audience -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-lightning-charge"></i> 3. Specializations &amp; Audience</div>
                    <div class="review-item" style="margin-bottom: 8px;">
                        <div class="review-item-label">Categories Offered</div>
                        <div class="review-item-val" id="revValSpecs">—</div>
                    </div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Target Audience</div><div class="review-item-val" id="revValAudience">—</div></div>
                        <div class="review-item"><div class="review-item-label">Doorstep Sessions</div><div class="review-item-val" id="revValDoorstep">—</div></div>
                    </div>
                </div>

                <!-- 4. Schedule & Pricing -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-clock-history"></i> 4. Schedule, Mode &amp; Pricing</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Available Days</div><div class="review-item-val" id="revValDays">—</div></div>
                        <div class="review-item"><div class="review-item-label">Hours of Operation</div><div class="review-item-val" id="revValHours">—</div></div>
                        <div class="review-item"><div class="review-item-label">Session Format</div><div class="review-item-val" id="revValSessionMode">—</div></div>
                        <div class="review-item"><div class="review-item-label">Typical Session Fee</div><div class="review-item-val" id="revValPrice" style="color:var(--primary); font-weight:800;">—</div></div>
                    </div>
                </div>

                <!-- 5. Bank / Payout -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-bank"></i> 5. Payout Details</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">UPI ID</div><div class="review-item-val" id="revValUpi">—</div></div>
                        <div class="review-item"><div class="review-item-label">Account Holder</div><div class="review-item-val" id="revValBankHolder">—</div></div>
                        <div class="review-item"><div class="review-item-label">Bank Name</div><div class="review-item-val" id="revValBankName">—</div></div>
                        <div class="review-item"><div class="review-item-label">Account Number</div><div class="review-item-val" id="revValBankAcc">—</div></div>
                        <div class="review-item"><div class="review-item-label">IFSC Code</div><div class="review-item-val" id="revValBankIfsc">—</div></div>
                        <div class="review-item"><div class="review-item-label">Branch</div><div class="review-item-val" id="revValBankBranch">—</div></div>
                    </div>
                </div>

                <!-- 6. Documents -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-file-earmark-check"></i> 6. Documents Status</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Profile Photo</div><div class="review-item-val" id="revValPhotoStatus">—</div></div>
                        <div class="review-item"><div class="review-item-label">Certification Document</div><div class="review-item-val" id="revValCertStatus">—</div></div>
                        <div class="review-item" style="grid-column: 1 / -1;"><div class="review-item-label">Studio Photos</div><div class="review-item-val" id="revValGalleryStatus">—</div></div>
                    </div>
                </div>
            </div>

            <div style="padding: 16px 22px; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; background: #F8FAFC;">
                <button type="button" class="btn-skip" onclick="closeReviewModal()">
                    <i class="bi bi-pencil"></i> Back to Edit
                </button>
                <div style="display:flex; gap:10px;">
                    <button type="button" class="btn-skip" onclick="submitProfile('saveDraft')">
                        <i class="bi bi-save"></i> Save Draft
                    </button>
                    <button type="button" class="btn-primary" onclick="submitProfile('submitVerification')">
                        <i class="bi bi-send-check"></i> Submit for Admin Verification
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Leaflet JS (CSP Whitelisted via cdn.jsdelivr.net) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
        const ctx = '${pageContext.request.contextPath}';
        const hasSavedPhoto = ${not empty trainer.profilePhotoPath};
        const hasSavedCert = ${not empty trainer.certificationsPath};
        const hasSavedGallery = ${not empty trainer.galleryPhotos};

        // -------------------------------------------------------------
        // Comprehensive Dependent Location Dataset (Zero CSP Violations)
        // -------------------------------------------------------------
        const locationData = {
            "India": {
                "Andhra Pradesh": ["Ananthapuramu", "Chittoor", "East Godavari", "Eluru", "Guntur", "Kakinada", "Krishna", "Kurnool", "NTR", "Palnadu", "Prakasam", "Srikakulam", "Sri Potti Sriramulu Nellore", "Tirupati", "Visakhapatnam", "Vizianagaram", "West Godavari", "YSR Kadapa", "Other"],
                "Arunachal Pradesh": ["Itanagar", "Tawang", "West Kameng", "East Kameng", "Papum Pare", "Kurung Kumey", "Kra Daadi", "Lower Subansiri", "Upper Subansiri", "West Siang", "East Siang", "Siang", "Upper Siang", "Lower Siang", "Lower Dibang Valley", "Dibang Valley", "Anjaw", "Lohit", "Namsai", "Changlang", "Tirap", "Longding", "Other"],
                "Assam": ["Guwahati (Kamrup Metro)", "Kamrup", "Dibrugarh", "Silchar (Cachar)", "Jorhat", "Nagaon", "Tinsukia", "Tezpur (Sonitpur)", "Barpeta", "Dhubri", "Goalpara", "Golaghat", "Hailakandi", "Karimganj", "Kokrajhar", "Lakhimpur", "Morigaon", "Nalbari", "Sivasagar", "Bongaigaon", "Other"],
                "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif (Nalanda)", "Arrah (Bhojpur)", "Begusarai", "Katihar", "Munger", "Chhapra (Saran)", "Danapur", "Saharsa", "Sasaram (Rohtas)", "Hajipur (Vaishali)", "Dehri", "Siwan", "Motihari (East Champaran)", "Bettiah (West Champaran)", "Other"],
                "Chhattisgarh": ["Raipur", "Bhilai (Durg)", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur (Bastar)", "Ambikapur (Surguja)", "Raigarh", "Dhamtari", "Mahasamund", "Kanker", "Kawardha (Kabirdham)", "Janjgir-Champa", "Other"],
                "Goa": ["North Goa", "South Goa", "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Other"],
                "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar", "Junagadh", "Anand", "Navsari", "Morbi", "Nadiad (Kheda)", "Surendranagar", "Bharuch", "Mehsana", "Bhuj (Kutch)", "Porbandar", "Palanpur (Banaskantha)", "Valsad", "Vapi", "Other"],
                "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", "Karnal", "Sonipat", "Panchkula", "Bhiwani", "Sirsa", "Bahadurgarh (Jhajjar)", "Jind", "Thanesar (Kurukshetra)", "Kaithal", "Rewari", "Palwal", "Other"],
                "Himachal Pradesh": ["Shimla", "Dharamshala (Kangra)", "Mandi", "Solan", "Kullu", "Hamirpur", "Una", "Bilaspur", "Chamba", "Sirmaur (Nahan)", "Kinnaur", "Lahaul and Spiti", "Other"],
                "Jharkhand": ["Ranchi", "Jamshedpur (East Singhbhum)", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Giridih", "Ramgarh", "Medininagar (Palamu)", "Dumka", "Chaibasa (West Singhbhum)", "Other"],
                "Karnataka": ["Bengaluru Urban", "Bengaluru Rural", "Mysuru", "Hubballi-Dharwad", "Mangaluru (Dakshina Kannada)", "Belagavi", "Kalaburagi (Gulbarga)", "Davanagere", "Ballari", "Vijayapura (Bijapur)", "Shivamogga (Shimoga)", "Tumakuru", "Bidar", "Raichur", "Udupi", "Hassan", "Mandya", "Chikkamagaluru", "Bagalkote", "Gadag", "Kolar", "Chitradurga", "Other"],
                "Kerala": ["Thiruvananthapuram", "Ernakulam (Kochi)", "Kozhikode", "Thrissur", "Kollam", "Palakkad", "Malappuram", "Kannur", "Kottayam", "Alappuzha", "Kasaragod", "Pathanamthitta", "Idukki", "Wayanad", "Other"],
                "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna", "Ratlam", "Rewa", "Katni", "Singrauli", "Burhanpur", "Khandwa", "Bhind", "Chhindwara", "Guna", "Shivpuri", "Vidisha", "Damoh", "Other"],
                "Maharashtra": ["Mumbai City", "Mumbai Suburban", "Pune", "Nagpur", "Thane", "Nashik", "Chhatrapati Sambhajinagar (Aurangabad)", "Solapur", "Kolhapur", "Amravati", "Navi Mumbai", "Nanded", "Jalgaon", "Akola", "Latur", "Dhule", "Ahmednagar", "Chandrapur", "Parbhani", "Jalna", "Raigad", "Satara", "Sangli", "Wardha", "Other"],
                "Manipur": ["Imphal West", "Imphal East", "Thoubal", "Bishnupur", "Churachandpur", "Ukhrul", "Senapati", "Tamenglong", "Chandel", "Kangpokpi", "Other"],
                "Meghalaya": ["Shillong (East Khasi Hills)", "West Khasi Hills", "South West Khasi Hills", "Ri-Bhoi", "Tura (West Garo Hills)", "East Garo Hills", "South Garo Hills", "North Garo Hills", "Jowai (West Jaintia Hills)", "East Jaintia Hills", "Other"],
                "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Kolasib", "Serchhip", "Lawngtlai", "Mamit", "Saiha", "Other"],
                "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Zunheboto", "Mon", "Phek", "Chumoukedima", "Niuland", "Other"],
                "Odisha": ["Bhubaneswar (Khurda)", "Cuttack", "Rourkela (Sundargarh)", "Berhampur (Ganjam)", "Sambalpur", "Puri", "Balasore", "Bhadrak", "Baripada (Mayurbhanj)", "Jharsuguda", "Jeypore (Koraput)", "Angul", "Bargarh", "Balangir", "Kendujhar", "Other"],
                "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "SAS Nagar (Mohali)", "Hoshiarpur", "Pathankot", "Moga", "Abohar (Fazilka)", "Batala (Gurdaspur)", "Khanna", "Firozpur", "Kapurthala", "Sangrur", "Barnala", "Faridkot", "Rupnagar", "Other"],
                "Rajasthan": ["Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Bharatpur", "Sikar", "Pali", "Sri Ganganagar", "Hanumangarh", "Tonk", "Kishangarh", "Beawar", "Jhunjhunu", "Chittorgarh", "Barmer", "Nagaur", "Other"],
                "Sikkim": ["Gangtok (East Sikkim)", "Namchi (South Sikkim)", "Gyalshing (West Sikkim)", "Mangan (North Sikkim)", "Pakyong", "Soreng", "Other"],
                "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Ranipet", "Vellore", "Erode", "Thoothukudi", "Dindigul", "Thanjavur", "Hosur (Krishnagiri)", "Nagercoil (Kanyakumari)", "Kanchipuram", "Kumarapalayam", "Karaikkudi", "Neyveli", "Cuddalore", "Other"],
                "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam (Peddapalli)", "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet", "Miryalaguda", "Siddipet", "Mancherial", "Rangareddy", "Medchal-Malkajgiri", "Sangareddy", "Other"],
                "Tripura": ["Agartala (West Tripura)", "Dharmanagar (North Tripura)", "Udaipur (Gomati)", "Kailashahar (Unakoti)", "Belonia (South Tripura)", "Khowai", "Ambassa (Dhalai)", "Sepahijala", "Other"],
                "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj (Allahabad)", "Gautam Buddha Nagar (Noida / Greater Noida)", "Ghaziabad", "Meerut", "Bareilly", "Aligarh", "Moradabad", "Saharanpur", "Gorakhpur", "Firozabad", "Jhansi", "Muzaffarnagar", "Mathura", "Ayodhya", "Budaun", "Rampur", "Shahjahanpur", "Farrukhabad", "Other"],
                "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani (Nainital)", "Rudraprayag", "Kashipur (Udham Singh Nagar)", "Rishikesh", "Pithoragarh", "Almora", "Tehri Garhwal", "Pauri Garhwal", "Chamoli", "Uttarkashi", "Other"],
                "West Bengal": ["Kolkata", "Howrah", "North 24 Parganas", "South 24 Parganas", "Hooghly", "Durgapur (Paschim Bardhaman)", "Asansol", "Siliguri (Darjeeling)", "Bardhaman", "Malda", "Baharampur (Murshidabad)", "Habra", "Kharagpur (Paschim Medinipur)", "Shantipur (Nadia)", "Dankuni", "Jalpaiguri", "Cooch Behar", "Purulia", "Bankura", "Other"],
                "Andaman and Nicobar Islands": ["Port Blair (South Andaman)", "North and Middle Andaman", "Nicobar", "Other"],
                "Chandigarh": ["Chandigarh", "Other"],
                "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa", "Other"],
                "Delhi": ["Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North East Delhi", "North West Delhi", "Shahdara", "South Delhi", "South East Delhi", "South West Delhi", "West Delhi", "Other"],
                "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua", "Udhampur", "Budgam", "Pulwama", "Kupwara", "Poonch", "Rajouri", "Other"],
                "Ladakh": ["Leh", "Kargil", "Other"],
                "Lakshadweep": ["Kavaratti", "Agatti", "Andrott", "Minicoy", "Other"],
                "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam", "Other"]
            },
            "United States": {
                "California": ["Los Angeles", "San Francisco", "San Diego", "San Jose", "Sacramento", "Oakland", "Other"],
                "New York": ["New York City", "Buffalo", "Rochester", "Albany", "Syracuse", "Other"],
                "Texas": ["Houston", "Austin", "Dallas", "San Antonio", "Fort Worth", "El Paso", "Other"],
                "Florida": ["Miami", "Orlando", "Tampa", "Jacksonville", "Tallahassee", "Other"],
                "Illinois": ["Chicago", "Aurora", "Naperville", "Rockford", "Other"],
                "Washington": ["Seattle", "Spokane", "Tacoma", "Vancouver", "Other"],
                "Other State": ["City / District", "Other"]
            },
            "United Kingdom": {
                "England": ["London", "Manchester", "Birmingham", "Leeds", "Liverpool", "Bristol", "Sheffield", "Other"],
                "Scotland": ["Edinburgh", "Glasgow", "Aberdeen", "Dundee", "Inverness", "Other"],
                "Wales": ["Cardiff", "Swansea", "Newport", "Other"],
                "Northern Ireland": ["Belfast", "Derry", "Lisburn", "Other"]
            },
            "Canada": {
                "Ontario": ["Toronto", "Ottawa", "Mississauga", "Brampton", "Hamilton", "Other"],
                "British Columbia": ["Vancouver", "Victoria", "Surrey", "Burnaby", "Richmond", "Other"],
                "Quebec": ["Montreal", "Quebec City", "Laval", "Gatineau", "Other"],
                "Alberta": ["Calgary", "Edmonton", "Red Deer", "Other"]
            },
            "Australia": {
                "New South Wales": ["Sydney", "Newcastle", "Central Coast", "Wollongong", "Other"],
                "Victoria": ["Melbourne", "Geelong", "Ballarat", "Bendigo", "Other"],
                "Queensland": ["Brisbane", "Gold Coast", "Sunshine Coast", "Townsville", "Cairns", "Other"],
                "Western Australia": ["Perth", "Fremantle", "Mandurah", "Other"]
            },
            "United Arab Emirates": {
                "Emirates": ["Dubai", "Abu Dhabi", "Sharjah", "Ajman", "Ras Al Khaimah", "Fujairah", "Umm Al Quwain"]
            },
            "Singapore": {
                "Singapore": ["Central Region", "East Region", "North Region", "North-East Region", "West Region"]
            },
            "Other": {
                "International Region": ["General Region / City", "Other"]
            }
        };

        const savedState = "<c:out value='${trainer.state}'/>";
        const savedCity = "<c:out value='${trainer.city}'/>";

        // -------------------------------------------------------------
        // Helper: Toggle chip visual selection
        // -------------------------------------------------------------
        function toggleChipActive(checkbox) {
            const label = checkbox.closest('.chip-item');
            if (label) {
                if (checkbox.checked) label.classList.add('active');
                else label.classList.remove('active');
            }
        }

        // -------------------------------------------------------------
        // Cascading Location Selectors
        // -------------------------------------------------------------
        function initLocationSelectors() {
            const countrySelect = document.getElementById('countrySelect');
            const stateSelect = document.getElementById('stateSelect');
            const districtSelect = document.getElementById('districtSelect');
            const customCityGroup = document.getElementById('customCityGroup');
            const customCityInput = document.getElementById('customCityInput');
            const cityInput = document.getElementById('inputCity');

            function populateStates(country, selectedState) {
                if (!stateSelect) return;
                stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';

                const statesObj = locationData[country] || locationData["Other"] || {};
                const stateNames = Object.keys(statesObj).sort();

                stateNames.forEach(st => {
                    const opt = document.createElement('option');
                    opt.value = st;
                    opt.textContent = st;
                    if (st.toLowerCase() === (selectedState || '').toLowerCase()) opt.selected = true;
                    stateSelect.appendChild(opt);
                });

                if (selectedState && stateSelect.value) {
                    populateDistricts(country, stateSelect.value, savedCity);
                } else {
                    if (districtSelect) districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    if (customCityGroup) customCityGroup.style.display = 'none';
                }
            }

            function populateDistricts(country, state, selectedDistrict) {
                if (!districtSelect) return;
                districtSelect.innerHTML = '<option value="">-- Select City / District --</option>';
                if (!state) {
                    districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    return;
                }

                const statesObj = locationData[country] || locationData["Other"] || {};
                const districts = statesObj[state] || ["Other"];
                const cur = selectedDistrict || districtSelect.value || savedCity;
                let matched = false;

                districts.forEach(dist => {
                    const opt = document.createElement('option');
                    opt.value = dist;
                    opt.textContent = dist;
                    if (cur && dist.toLowerCase() === cur.toLowerCase()) {
                        opt.selected = true;
                        matched = true;
                    }
                    districtSelect.appendChild(opt);
                });

                if (cur && !matched && cur !== "Other") {
                    districtSelect.value = "Other";
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.value = cur;
                    if (cityInput) cityInput.value = cur;
                } else if (districtSelect.value === "Other") {
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (cityInput && customCityInput) cityInput.value = customCityInput.value.trim();
                } else {
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    if (cityInput) cityInput.value = districtSelect.value;
                }
                recalculateProgress();
            }

            if (countrySelect) {
                countrySelect.addEventListener('change', () => {
                    populateStates(countrySelect.value, '');
                    if (cityInput) cityInput.value = '';
                    recalculateProgress();
                });
            }

            if (stateSelect) {
                stateSelect.addEventListener('change', () => {
                    populateDistricts(countrySelect.value, stateSelect.value, '');
                    validateState();
                    recalculateProgress();
                });
            }

            if (districtSelect) {
                districtSelect.addEventListener('change', () => {
                    if (districtSelect.value === 'Other') {
                        if (customCityGroup) customCityGroup.style.display = 'block';
                        if (customCityInput) {
                            customCityInput.focus();
                            if (cityInput) cityInput.value = customCityInput.value.trim();
                        }
                    } else {
                        if (customCityGroup) customCityGroup.style.display = 'none';
                        if (cityInput) cityInput.value = districtSelect.value;
                    }
                    validateCity();
                    recalculateProgress();
                });
            }

            if (customCityInput) {
                customCityInput.addEventListener('input', () => {
                    if (cityInput) cityInput.value = customCityInput.value.trim();
                    validateCity();
                    recalculateProgress();
                });
            }

            // Initialize on load
            populateStates(countrySelect.value, savedState);
        }

        // -------------------------------------------------------------
        // Leaflet Interactive Map Picker Modal
        // -------------------------------------------------------------
        let mapInitialized = false;
        let currentMap = null;
        let currentMarker = null;
        let selectedCoords = null;
        let selectedAddressText = '';

        const mapModal = document.getElementById('mapPickerModal');
        const btnOpenMap = document.getElementById('btnOpenMapPicker');
        const btnCloseMap = document.getElementById('btnCloseMapModal');
        const btnCancelMap = document.getElementById('btnCancelMap');
        const btnConfirmMap = document.getElementById('btnConfirmLocation');
        const btnSearchMap = document.getElementById('btnSearchMap');
        const btnLocateMe = document.getElementById('btnLocateMe');
        const mapSearchInput = document.getElementById('mapSearchInput');
        const mapSuggestions = document.getElementById('mapSuggestions');
        const mapSelectedAddressEl = document.getElementById('mapSelectedAddress');
        const mapAlertEl = document.getElementById('mapPickerAlert');

        function showMapAlert(msg) {
            if (!mapAlertEl) return;
            if (msg) {
                mapAlertEl.textContent = msg;
                mapAlertEl.style.display = 'block';
            } else {
                mapAlertEl.style.display = 'none';
                mapAlertEl.textContent = '';
            }
        }

        function setMapSelectedLocation(address, lat, lng) {
            selectedCoords = { lat: lat, lng: lng };
            selectedAddressText = address || '';
            if (mapSelectedAddressEl) {
                mapSelectedAddressEl.textContent = address || ('Location: ' + lat.toFixed(5) + ', ' + lng.toFixed(5));
            }
            if (btnConfirmMap) {
                btnConfirmMap.disabled = false;
            }
        }

        async function reverseGeocodeCoords(lat, lng) {
            setMapSelectedLocation('Resolving address…', lat, lng);
            showMapAlert('');
            try {
                const res = await fetch(ctx + '/api/auth/geo/reverse?lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng), {
                    headers: { 'Accept': 'application/json' },
                    credentials: 'same-origin'
                });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.success && data.address) {
                        setMapSelectedLocation(data.address, lat, lng);
                        return;
                    }
                }
            } catch (e) {
                console.warn('[MapPicker] Reverse geocode error:', e);
            }
            setMapSelectedLocation('Studio Location (' + lat.toFixed(5) + ', ' + lng.toFixed(5) + ')', lat, lng);
        }

        function initMap() {
            if (typeof L === 'undefined') {
                showMapAlert('Map library failed to load. You can paste your Google Maps link directly.');
                return;
            }

            if (mapInitialized && currentMap) {
                setTimeout(() => {
                    if (currentMap.invalidateSize) currentMap.invalidateSize();
                    if (selectedCoords && currentMarker) {
                        currentMap.setView([selectedCoords.lat, selectedCoords.lng], 15);
                        currentMarker.setLatLng([selectedCoords.lat, selectedCoords.lng]);
                    }
                }, 100);
                return;
            }

            let defaultLat = 19.0760;
            let defaultLng = 72.8777; // Mumbai default

            // Check if saved lat/lng exists
            const savedLat = parseFloat(document.getElementById('inputLatitude')?.value);
            const savedLng = parseFloat(document.getElementById('inputLongitude')?.value);
            if (!isNaN(savedLat) && !isNaN(savedLng) && savedLat !== 0) {
                defaultLat = savedLat;
                defaultLng = savedLng;
            } else {
                const mapLinkVal = document.getElementById('inputMapLink')?.value || '';
                const match = mapLinkVal.match(/[?&@](?:q=)?([0-9.-]+),([0-9.-]+)/);
                if (match) {
                    defaultLat = parseFloat(match[1]);
                    defaultLng = parseFloat(match[2]);
                }
            }

            try {
                currentMap = L.map('mapContainer', {
                    center: [defaultLat, defaultLng],
                    zoom: 13,
                    zoomControl: true
                });

                L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(currentMap);

                currentMarker = L.marker([defaultLat, defaultLng], {
                    draggable: true,
                    autoPan: true
                }).addTo(currentMap);

                currentMarker.on('dragend', function (e) {
                    const pos = e.target.getLatLng();
                    reverseGeocodeCoords(pos.lat, pos.lng);
                });

                currentMap.on('click', function (e) {
                    const lat = e.latlng.lat;
                    const lng = e.latlng.lng;
                    currentMarker.setLatLng([lat, lng]);
                    reverseGeocodeCoords(lat, lng);
                });

                mapInitialized = true;

                setTimeout(() => {
                    if (currentMap.invalidateSize) currentMap.invalidateSize();
                    reverseGeocodeCoords(defaultLat, defaultLng);
                }, 150);

            } catch (err) {
                console.error('[MapPicker] Leaflet init error:', err);
                showMapAlert('Unable to initialize map. You can enter your address and map link manually.');
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
                showMapAlert('No location results found for "' + query + '". Try a landmark, area, or street name.');
            } catch (e) {
                showMapAlert('Network error searching location. You can pin directly on the map.');
            }
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
            const lng = parseFloat(item.longitude || item.lng);
            if (!isNaN(lat) && !isNaN(lng)) {
                if (currentMap && currentMarker) {
                    currentMap.setView([lat, lng], 16);
                    currentMarker.setLatLng([lat, lng]);
                }
                setMapSelectedLocation(item.address, lat, lng);
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
                initMap();
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
                    if (currentMap && currentMarker) {
                        currentMap.setView([lat, lng], 16);
                        currentMarker.setLatLng([lat, lng]);
                    }
                    reverseGeocodeCoords(lat, lng);
                }, err => {
                    btnLocateMe.disabled = false;
                    showMapAlert('GPS location access was denied. You can click on the map to place your pin.');
                }, { timeout: 10000, enableHighAccuracy: true });
            });
        }

        if (btnConfirmMap) {
            btnConfirmMap.addEventListener('click', () => {
                if (!selectedCoords) return;

                // 1. Coordinates
                const latInput = document.getElementById('inputLatitude');
                const lngInput = document.getElementById('inputLongitude');
                if (latInput) latInput.value = selectedCoords.lat.toFixed(6);
                if (lngInput) lngInput.value = selectedCoords.lng.toFixed(6);

                // 2. Google Maps URL
                const mapLinkInput = document.getElementById('inputMapLink');
                if (mapLinkInput) {
                    mapLinkInput.value = 'https://www.google.com/maps?q=' + selectedCoords.lat.toFixed(6) + ',' + selectedCoords.lng.toFixed(6);
                    validateMapLink();
                }

                // 3. Address
                const addrInput = document.getElementById('inputAddress');
                if (addrInput && (!addrInput.value || addrInput.value.trim().length < 5) && selectedAddressText) {
                    addrInput.value = selectedAddressText;
                    validateAddress();
                }

                // 4. Pincode
                if (selectedAddressText) {
                    const pinMatch = selectedAddressText.match(/\b([1-9][0-9]{5})\b/);
                    const pinInput = document.getElementById('inputPincode');
                    if (pinMatch && pinInput && !pinInput.value) {
                        pinInput.value = pinMatch[1];
                        validatePincode();
                    }
                }

                closeMapModal();
                recalculateProgress();
            });
        }

        // Close on ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                if (mapModal && mapModal.style.display === 'flex') closeMapModal();
                const reviewBackdrop = document.getElementById('profileReviewModalBackdrop');
                if (reviewBackdrop && reviewBackdrop.style.display === 'flex') closeReviewModal();
            }
        });

        // -------------------------------------------------------------
        // Field Validation Engine & Inline Messages
        // -------------------------------------------------------------
        function setFieldState(inputEl, errorEl, isValid) {
            if (!inputEl) return;
            if (isValid) {
                inputEl.classList.remove('is-invalid');
                inputEl.classList.add('is-valid');
                if (errorEl) errorEl.classList.remove('show');
            } else {
                inputEl.classList.remove('is-valid');
                inputEl.classList.add('is-invalid');
                if (errorEl) errorEl.classList.add('show');
            }
        }

        function validateFullName() {
            const el = document.getElementById('inputFullName');
            const err = document.getElementById('err-fullName');
            const val = el ? el.value.trim() : '';
            const ok = val.length >= 3 && /^[a-zA-Z\s.\-]{3,80}$/.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateDesignation() {
            const el = document.getElementById('inputDesignation');
            const err = document.getElementById('err-designation');
            const ok = el && el.value.trim() !== '';
            setFieldState(el, err, ok);
            return ok;
        }

        function validatePhone() {
            const el = document.getElementById('inputPhone');
            const err = document.getElementById('err-phone');
            const val = el ? el.value.trim() : '';
            const ok = /^[6-9]\d{9}$/.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateWhatsapp() {
            const el = document.getElementById('inputWhatsapp');
            const err = document.getElementById('err-whatsapp');
            const val = el ? el.value.trim() : '';
            if (!val) {
                if (el) el.classList.remove('is-invalid', 'is-valid');
                if (err) err.classList.remove('show');
                return true;
            }
            const ok = /^[6-9]\d{9}$/.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateExperience() {
            const el = document.getElementById('inputExperience');
            const err = document.getElementById('err-experience');
            const val = el ? parseInt(el.value, 10) : NaN;
            const ok = !isNaN(val) && val >= 0 && val <= 50;
            setFieldState(el, err, ok);
            return ok;
        }

        function validateCredentialNumber() {
            const el = document.getElementById('inputCredential');
            const err = document.getElementById('err-credentialNumber');
            const val = el ? el.value.trim() : '';
            const ok = val.length >= 3;
            setFieldState(el, err, ok);
            return ok;
        }

        function validateAddress() {
            const el = document.getElementById('inputAddress');
            const err = document.getElementById('err-address');
            const val = el ? el.value.trim() : '';
            const ok = val.length >= 5;
            setFieldState(el, err, ok);
            return ok;
        }

        function validateState() {
            const el = document.getElementById('stateSelect');
            const err = document.getElementById('err-state');
            const ok = el && el.value.trim() !== '';
            setFieldState(el, err, ok);
            return ok;
        }

        function validateCity() {
            const el = document.getElementById('inputCity');
            const err = document.getElementById('err-city');
            const ok = el && el.value.trim() !== '';
            setFieldState(el, err, ok);
            return ok;
        }

        function validatePincode() {
            const el = document.getElementById('inputPincode');
            const err = document.getElementById('err-pincode');
            const val = el ? el.value.trim() : '';
            const ok = /^\d{6}$/.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateMapLink() {
            const el = document.getElementById('inputMapLink');
            const err = document.getElementById('err-mapLink');
            const val = el ? el.value.trim() : '';
            if (!val) {
                if (el) el.classList.remove('is-invalid', 'is-valid');
                if (err) err.classList.remove('show');
                return true;
            }
            const ok = /^https?:\/\/.+/i.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateSpecializations() {
            const checked = document.querySelectorAll('input.spec-checkbox:checked').length;
            const err = document.getElementById('err-specializations');
            const ok = checked >= 1;
            if (err) {
                if (ok) err.classList.remove('show');
                else err.classList.add('show');
            }
            return ok;
        }

        function validateAudience() {
            const checked = document.querySelectorAll('input.aud-checkbox:checked').length;
            const err = document.getElementById('err-audience');
            const ok = checked >= 1;
            if (err) {
                if (ok) err.classList.remove('show');
                else err.classList.add('show');
            }
            return ok;
        }

        function validateAvailableDays() {
            const checked = document.querySelectorAll('input.day-checkbox:checked').length;
            const err = document.getElementById('err-availableDays');
            const ok = checked >= 1;
            if (err) {
                if (ok) err.classList.remove('show');
                else err.classList.add('show');
            }
            return ok;
        }

        function validateOpenTime() {
            const el = document.getElementById('inputOpenTime');
            const err = document.getElementById('err-openTime');
            const ok = el && el.value.trim() !== '';
            setFieldState(el, err, ok);
            return ok;
        }

        function validateCloseTime() {
            const openEl = document.getElementById('inputOpenTime');
            const closeEl = document.getElementById('inputCloseTime');
            const err = document.getElementById('err-closeTime');
            const ok = closeEl && closeEl.value.trim() !== '' && (!openEl || closeEl.value > openEl.value);
            setFieldState(closeEl, err, ok);
            return ok;
        }

        function validateBio() {
            const el = document.getElementById('inputBio');
            const err = document.getElementById('err-bio');
            const counter = document.getElementById('bioCharCount');
            const val = el ? el.value.trim() : '';
            if (counter) counter.textContent = val.length;
            const ok = val.length >= 20;
            setFieldState(el, err, ok);
            return ok;
        }

        function validateSessionMode() {
            const el = document.getElementById('inputSessionMode');
            const err = document.getElementById('err-sessionMode');
            const ok = el && el.value.trim() !== '';
            setFieldState(el, err, ok);
            return ok;
        }

        function validateSessionFees() {
            const el = document.getElementById('inputSessionFees');
            const err = document.getElementById('err-sessionFees');
            const val = el ? parseFloat(el.value) : NaN;
            const ok = !isNaN(val) && val >= 0;
            setFieldState(el, err, ok);
            return ok;
        }

        function validateUpiId() {
            const el = document.getElementById('inputUpiId');
            const err = document.getElementById('err-upiId');
            const val = el ? el.value.trim() : '';
            if (!val) {
                if (el) el.classList.remove('is-invalid', 'is-valid');
                if (err) err.classList.remove('show');
                return true;
            }
            const ok = /^[\w.\-_]{2,256}@[a-zA-Z]{2,64}$/.test(val);
            setFieldState(el, err, ok);
            return ok;
        }

        function validateBankDetails() {
            const accEl = document.getElementById('bankAccountNumber');
            const confEl = document.getElementById('confirmAccountNumber');
            const ifscEl = document.getElementById('bankIfsc');
            const holderEl = document.getElementById('bankAccountHolder');
            const nameEl = document.getElementById('bankName');

            const acc = accEl ? accEl.value.trim() : '';
            const conf = confEl ? confEl.value.trim() : '';
            const ifsc = ifscEl ? ifscEl.value.trim().toUpperCase() : '';
            const holder = holderEl ? holderEl.value.trim() : '';
            const bName = nameEl ? nameEl.value.trim() : '';

            // If any bank field provided, validate the required set
            if (acc || holder || bName || ifsc) {
                const accOk = /^\d{9,18}$/.test(acc);
                const confOk = acc === conf && acc.length > 0;
                const ifscOk = /^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc);
                const holderOk = holder.length >= 2;
                const nameOk = bName.length >= 2;

                setFieldState(accEl, document.getElementById('err-bankAccountNumber'), accOk);
                setFieldState(confEl, document.getElementById('err-confirmAccountNumber'), confOk);
                setFieldState(ifscEl, document.getElementById('err-bankIfsc'), ifscOk);
                setFieldState(holderEl, document.getElementById('err-bankAccountHolder'), holderOk);
                setFieldState(nameEl, document.getElementById('err-bankName'), nameOk);

                return accOk && confOk && ifscOk && holderOk && nameOk;
            }
            return true;
        }

        function validateCertificate() {
            const fileInput = document.getElementById('inputCertificateFile');
            const err = document.getElementById('err-certificateFile');
            const hasNewFile = fileInput && fileInput.files && fileInput.files.length > 0;
            const ok = hasSavedCert || hasNewFile;
            if (err) {
                if (ok) err.classList.remove('show');
                else err.classList.add('show');
            }
            return ok;
        }

        function validateGallery() {
            const fileInput = document.getElementById('inputGalleryFiles');
            const err = document.getElementById('err-galleryFiles');
            const hasNewFiles = fileInput && fileInput.files && fileInput.files.length > 0;
            const ok = hasSavedGallery || hasNewFiles;
            if (err) {
                if (ok) err.classList.remove('show');
                else err.classList.add('show');
            }
            return ok;
        }

        // -------------------------------------------------------------
        // Accurate Completion Percentage Calculation (18 Required Items)
        // -------------------------------------------------------------
        const requiredItemsMap = [
            { key: "1.1 Full name", check: validateFullName },
            { key: "1.2 Designation", check: validateDesignation },
            { key: "1.5 Official phone", check: validatePhone },
            { key: "1.7 Years of experience", check: validateExperience },
            { key: "1.8 ACE / NASM / Yoga Alliance / cert number", check: validateCredentialNumber },
            { key: "2.1 Address", check: validateAddress },
            { key: "2.3 City", check: validateCity },
            { key: "2.4 State", check: validateState },
            { key: "2.5 Pincode", check: validatePincode },
            { key: "3.1 Specializations", check: validateSpecializations },
            { key: "4.1 Who I serve", check: validateAudience },
            { key: "6.1 Open days", check: validateAvailableDays },
            { key: "6.2 Open time", check: validateOpenTime },
            { key: "6.3 Close time", check: validateCloseTime },
            { key: "7.1 About", check: validateBio },
            { key: "8. Typical session", check: () => validateSessionMode() && validateSessionFees() },
            { key: "10. Documents & Certification", check: validateCertificate },
            { key: "11. Studio photos", check: validateGallery }
        ];

        function recalculateProgress() {
            const total = requiredItemsMap.length; // 18 items
            let filled = 0;
            const missing = [];

            requiredItemsMap.forEach(item => {
                if (item.check()) {
                    filled++;
                } else {
                    missing.push(item.key);
                }
            });

            const pct = Math.round((filled / total) * 100);

            // Update badge & bar
            const badge = document.getElementById('progressPctBadge');
            const bar = document.getElementById('progressBarFill');
            const statusText = document.getElementById('completionStatusText');

            if (badge) {
                badge.textContent = pct + '% Complete';
                if (pct >= 100) badge.classList.add('complete');
                else badge.classList.remove('complete');
            }

            if (bar) {
                bar.style.width = pct + '%';
                if (pct >= 100) bar.classList.add('complete');
                else bar.classList.remove('complete');
            }

            if (statusText) {
                if (pct >= 100) {
                    statusText.innerHTML = '<span style="color:var(--success);"><i class="bi bi-check-circle-fill"></i> All 18 items completed! Ready for Verification</span>';
                } else {
                    statusText.textContent = filled + ' of ' + total + ' Required Items';
                }
            }

            // Update missing chips
            const chipContainer = document.getElementById('missingListChips');
            if (chipContainer) {
                chipContainer.innerHTML = '';
                missing.forEach(m => {
                    const span = document.createElement('span');
                    span.className = 'missing-chip';
                    span.innerHTML = '<i class="bi bi-dash-circle"></i> ' + m;
                    chipContainer.appendChild(span);
                });
            }

            return { pct, missing, isReady: missing.length === 0 };
        }

        // -------------------------------------------------------------
        // Bank Details Serialization
        // -------------------------------------------------------------
        function parseExistingBankDetails() {
            const raw = (document.getElementById('bankDetails')?.value || '').trim();
            if (!raw) return;

            if (raw.includes('|')) {
                const parts = raw.split('|').map(s => s.trim());
                parts.forEach(part => {
                    const low = part.toLowerCase();
                    if (low.startsWith('account holder:')) {
                        const h = document.getElementById('bankAccountHolder');
                        if (h) h.value = part.substring(part.indexOf(':') + 1).trim();
                    } else if (low.startsWith('bank:')) {
                        const b = document.getElementById('bankName');
                        if (b) b.value = part.substring(part.indexOf(':') + 1).trim();
                    } else if (low.startsWith('a/c:')) {
                        const acc = part.substring(part.indexOf(':') + 1).trim();
                        const a = document.getElementById('bankAccountNumber');
                        const c = document.getElementById('confirmAccountNumber');
                        if (a) a.value = acc;
                        if (c) c.value = acc;
                    } else if (low.startsWith('ifsc:')) {
                        const i = document.getElementById('bankIfsc');
                        if (i) i.value = part.substring(part.indexOf(':') + 1).trim().toUpperCase();
                    } else if (low.startsWith('branch:')) {
                        const br = document.getElementById('bankBranch');
                        if (br) br.value = part.substring(part.indexOf(':') + 1).trim();
                    }
                });
            }
        }

        function syncBankDetails() {
            const holder = (document.getElementById('bankAccountHolder')?.value || '').trim();
            const bName = (document.getElementById('bankName')?.value || '').trim();
            const acc = (document.getElementById('bankAccountNumber')?.value || '').trim();
            const ifsc = (document.getElementById('bankIfsc')?.value || '').trim().toUpperCase();
            const branch = (document.getElementById('bankBranch')?.value || '').trim();

            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                } else {
                    hidden.value = "";
                }
            }
        }

        // -------------------------------------------------------------
        // File Previews
        // -------------------------------------------------------------
        function previewSelectedPhoto(input) {
            const file = input.files && input.files[0];
            const err = document.getElementById('err-profilePhoto');
            if (file) {
                if (!file.type.startsWith('image/')) {
                    if (err) { err.textContent = 'Please choose an image file (JPEG, PNG, WEBP).'; err.classList.add('show'); }
                    input.value = '';
                    return;
                }
                if (file.size > 5 * 1024 * 1024) {
                    if (err) { err.textContent = 'Image exceeds 5MB size limit.'; err.classList.add('show'); }
                    input.value = '';
                    return;
                }
                if (err) err.classList.remove('show');

                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.getElementById('avatarPreviewImg');
                    const fallback = document.getElementById('avatarFallbackIcon');
                    if (img) {
                        img.src = e.target.result;
                        img.style.display = 'block';
                    }
                    if (fallback) fallback.style.display = 'none';

                    const modalImg = document.getElementById('modalRevAvatarImg');
                    const modalFallback = document.getElementById('modalRevAvatarFallback');
                    if (modalImg) {
                        modalImg.src = e.target.result;
                        modalImg.style.display = 'block';
                    }
                    if (modalFallback) modalFallback.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
            recalculateProgress();
        }

        function previewSelectedGallery(input) {
            const files = input.files;
            const container = document.getElementById('galleryPreviewContainer');
            const err = document.getElementById('err-galleryFiles');

            if (files && files.length > 0) {
                let valid = true;
                Array.from(files).forEach(f => {
                    if (!f.type.startsWith('image/')) valid = false;
                    if (f.size > 5 * 1024 * 1024) valid = false;
                });
                if (!valid) {
                    if (err) { err.textContent = 'Each gallery photo must be an image under 5MB.'; err.classList.add('show'); }
                    input.value = '';
                    return;
                }
                if (err) err.classList.remove('show');

                if (container) {
                    container.innerHTML = '';
                    Array.from(files).forEach(file => {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'gallery-thumb';
                            container.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    });
                }
            }
            recalculateProgress();
        }

        // -------------------------------------------------------------
        // Review Modal Handlers
        // -------------------------------------------------------------
        function populateReviewModal() {
            const form = document.getElementById('trainerProfileForm');
            if (!form) return;

            const name = document.getElementById('inputFullName')?.value.trim() || '—';
            const desig = document.getElementById('inputDesignation')?.value || '—';
            const phone = document.getElementById('inputPhone')?.value.trim() || '—';
            const whatsapp = document.getElementById('inputWhatsapp')?.value.trim() || '—';
            const exp = document.getElementById('inputExperience')?.value || '0';
            const cred = document.getElementById('inputCredential')?.value.trim() || '—';

            document.getElementById('modalRevFullName').textContent = name;
            document.getElementById('modalRevDesignation').textContent = desig;
            document.getElementById('modalRevExp').textContent = exp + ' Years Exp';

            document.getElementById('revValName').textContent = name;
            document.getElementById('revValDesig').textContent = desig;
            document.getElementById('revValPhone').textContent = phone;
            document.getElementById('revValWhatsapp').textContent = whatsapp;
            document.getElementById('revValExperience').textContent = exp + ' Years';
            document.getElementById('revValCredential').textContent = cred;

            // Location
            const addr = document.getElementById('inputAddress')?.value.trim() || '—';
            const city = document.getElementById('inputCity')?.value.trim() || '—';
            const state = document.getElementById('stateSelect')?.value || '—';
            const country = document.getElementById('countrySelect')?.value || 'India';
            const pin = document.getElementById('inputPincode')?.value.trim() || '—';

            document.getElementById('modalRevCityState').textContent = city + ', ' + state;
            document.getElementById('revValAddress').textContent = addr;
            document.getElementById('revValCityState').textContent = city + ', ' + state + ' (' + country + ')';
            document.getElementById('revValPincode').textContent = pin;

            // Specs & Audience
            const specs = Array.from(document.querySelectorAll('input.spec-checkbox:checked')).map(cb => cb.value);
            document.getElementById('revValSpecs').textContent = specs.length > 0 ? specs.join(', ') : 'None selected';

            const auds = Array.from(document.querySelectorAll('input.aud-checkbox:checked')).map(cb => cb.value);
            document.getElementById('revValAudience').textContent = auds.length > 0 ? auds.join(', ') : 'None selected';

            const doorstep = document.getElementById('inputDoorstep')?.checked ? 'Yes (Home visits offered)' : 'No (Studio only)';
            document.getElementById('revValDoorstep').textContent = doorstep;

            // Schedule & Pricing
            const days = Array.from(document.querySelectorAll('input.day-checkbox:checked')).map(cb => cb.value);
            document.getElementById('revValDays').textContent = days.length > 0 ? days.join(', ') : 'None';

            const openT = document.getElementById('inputOpenTime')?.value || '06:00';
            const closeT = document.getElementById('inputCloseTime')?.value || '20:00';
            document.getElementById('revValHours').textContent = openT + ' to ' + closeT;

            const mode = document.getElementById('inputSessionMode')?.value || 'In-Person Studio';
            const dur = document.getElementById('inputSessionDuration')?.value || '60';
            document.getElementById('revValSessionMode').textContent = mode + ' (' + dur + ' mins)';

            const price = document.getElementById('inputSessionFees')?.value || '0';
            document.getElementById('revValPrice').textContent = '₹' + price + ' / session';

            // Bank
            const upi = document.getElementById('inputUpiId')?.value.trim() || '—';
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '—';
            const bName = document.getElementById('bankName')?.value.trim() || '—';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '—';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '—').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '—';

            document.getElementById('revValUpi').textContent = upi;
            document.getElementById('revValBankHolder').textContent = holder;
            document.getElementById('revValBankName').textContent = bankName;
            document.getElementById('revValBankAcc').textContent = acc !== '—' ? acc : 'Not provided';
            document.getElementById('revValBankIfsc').textContent = ifsc;
            document.getElementById('revValBankBranch').textContent = branch;

            // Documents
            const photoFile = form.querySelector('input[name="profilePhotoFile"]')?.files[0];
            document.getElementById('revValPhotoStatus').textContent = photoFile ? ('New file: ' + photoFile.name) : (hasSavedPhoto ? 'Profile photo on file' : 'None');

            const certFile = form.querySelector('input[name="certificateFile"]')?.files[0];
            document.getElementById('revValCertStatus').textContent = certFile ? ('New file: ' + certFile.name) : (hasSavedCert ? 'Certification on file' : 'Pending');

            const galleryFiles = form.querySelector('input[name="galleryFiles"]')?.files;
            document.getElementById('revValGalleryStatus').textContent = (galleryFiles && galleryFiles.length > 0) ? (galleryFiles.length + ' photos selected') : (hasSavedGallery ? 'Gallery photos on file' : 'None');
        }

        function openReviewModal() {
            syncBankDetails();
            const result = recalculateProgress();
            populateReviewModal();
            const backdrop = document.getElementById('profileReviewModalBackdrop');
            if (backdrop) backdrop.style.display = 'flex';
        }

        function closeReviewModal() {
            const backdrop = document.getElementById('profileReviewModalBackdrop');
            if (backdrop) backdrop.style.display = 'none';
        }

        function handleReviewBackdropClick(e) {
            if (e.target && e.target.id === 'profileReviewModalBackdrop') {
                closeReviewModal();
            }
        }

        // -------------------------------------------------------------
        // Form Submission
        // -------------------------------------------------------------
        function submitProfile(intent) {
            const form = document.getElementById('trainerProfileForm');
            if (!form) return;

            syncBankDetails();
            document.getElementById('formIntent').value = intent || 'submitVerification';

            if (intent === 'submitVerification') {
                // Validate all fields
                let allValid = true;
                requiredItemsMap.forEach(item => {
                    if (!item.check()) allValid = false;
                });

                if (!validateBankDetails()) allValid = false;

                if (!allValid) {
                    recalculateProgress();
                    closeReviewModal();
                    alert('Please complete all required fields highlighted in red before submitting for verification.');
                    // Scroll to first invalid element
                    const firstInvalid = document.querySelector('.is-invalid, .error-msg.show');
                    if (firstInvalid) {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                    return;
                }
            }

            // Disable buttons during submission to prevent double clicks
            document.querySelectorAll('.btn-primary, .btn-header-draft').forEach(b => b.disabled = true);
            form.submit();
        }

        // -------------------------------------------------------------
        // Real-time Event Listeners
        // -------------------------------------------------------------
        document.addEventListener('DOMContentLoaded', function() {
            initLocationSelectors();
            parseExistingBankDetails();

            // Input restrictions & Live Validations
            const fullNameEl = document.getElementById('inputFullName');
            if (fullNameEl) {
                fullNameEl.addEventListener('input', () => {
                    fullNameEl.value = fullNameEl.value.replace(/[^a-zA-Z\s.\-]/g, '').slice(0, 80);
                    validateFullName();
                    recalculateProgress();
                });
                fullNameEl.addEventListener('blur', validateFullName);
            }

            const desigEl = document.getElementById('inputDesignation');
            if (desigEl) {
                desigEl.addEventListener('change', () => { validateDesignation(); recalculateProgress(); });
            }

            const phoneEl = document.getElementById('inputPhone');
            if (phoneEl) {
                phoneEl.addEventListener('input', () => {
                    phoneEl.value = phoneEl.value.replace(/\D/g, '').slice(0, 10);
                    validatePhone();
                    recalculateProgress();
                });
                phoneEl.addEventListener('blur', validatePhone);
            }

            const whatsappEl = document.getElementById('inputWhatsapp');
            if (whatsappEl) {
                whatsappEl.addEventListener('input', () => {
                    whatsappEl.value = whatsappEl.value.replace(/\D/g, '').slice(0, 10);
                    validateWhatsapp();
                });
                whatsappEl.addEventListener('blur', validateWhatsapp);
            }

            const expEl = document.getElementById('inputExperience');
            if (expEl) {
                expEl.addEventListener('input', () => { validateExperience(); recalculateProgress(); });
                expEl.addEventListener('blur', validateExperience);
            }

            const credEl = document.getElementById('inputCredential');
            if (credEl) {
                credEl.addEventListener('input', () => { validateCredentialNumber(); recalculateProgress(); });
                credEl.addEventListener('blur', validateCredentialNumber);
            }

            const addrEl = document.getElementById('inputAddress');
            if (addrEl) {
                addrEl.addEventListener('input', () => { validateAddress(); recalculateProgress(); });
                addrEl.addEventListener('blur', validateAddress);
            }

            const pinEl = document.getElementById('inputPincode');
            if (pinEl) {
                pinEl.addEventListener('input', () => {
                    pinEl.value = pinEl.value.replace(/\D/g, '').slice(0, 6);
                    validatePincode();
                    recalculateProgress();
                });
                pinEl.addEventListener('blur', validatePincode);
            }

            const mapLinkEl = document.getElementById('inputMapLink');
            if (mapLinkEl) {
                mapLinkEl.addEventListener('input', validateMapLink);
                mapLinkEl.addEventListener('blur', validateMapLink);
            }

            const bioEl = document.getElementById('inputBio');
            if (bioEl) {
                bioEl.addEventListener('input', () => { validateBio(); recalculateProgress(); });
                bioEl.addEventListener('blur', validateBio);
            }

            const sModeEl = document.getElementById('inputSessionMode');
            if (sModeEl) {
                sModeEl.addEventListener('change', () => { validateSessionMode(); recalculateProgress(); });
            }

            const sDurEl = document.getElementById('inputSessionDuration');
            if (sDurEl) {
                sDurEl.addEventListener('change', recalculateProgress);
            }

            const sFeesEl = document.getElementById('inputSessionFees');
            if (sFeesEl) {
                sFeesEl.addEventListener('input', () => { validateSessionFees(); recalculateProgress(); });
                sFeesEl.addEventListener('blur', validateSessionFees);
            }

            const upiEl = document.getElementById('inputUpiId');
            if (upiEl) {
                upiEl.addEventListener('input', validateUpiId);
                upiEl.addEventListener('blur', validateUpiId);
            }

            // Bank details inputs
            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', () => {
                        if (id === 'bankAccountNumber' || id === 'confirmAccountNumber') {
                            el.value = el.value.replace(/\D/g, '').slice(0, 18);
                        } else if (id === 'bankIfsc') {
                            el.value = el.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 11);
                        }
                        validateBankDetails();
                        syncBankDetails();
                    });
                    el.addEventListener('blur', () => {
                        validateBankDetails();
                        syncBankDetails();
                    });
                }
            });

            // File inputs
            const photoInput = document.getElementById('inputProfilePhoto');
            if (photoInput) {
                photoInput.addEventListener('change', function() { previewSelectedPhoto(this); });
            }

            const certInput = document.getElementById('inputCertificateFile');
            if (certInput) {
                certInput.addEventListener('change', function() {
                    validateCertificate();
                    recalculateProgress();
                });
            }

            const galleryInput = document.getElementById('inputGalleryFiles');
            if (galleryInput) {
                galleryInput.addEventListener('change', function() { previewSelectedGallery(this); });
            }

            // Initial calculation
            recalculateProgress();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
