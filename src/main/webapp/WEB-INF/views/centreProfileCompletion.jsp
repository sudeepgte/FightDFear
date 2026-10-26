<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Centre Profile — Fight D Fear</title>
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
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-skip:hover {
            background: var(--bg-page);
            border-color: #CBD5E1;
        }

        .btn-header-preview {
            padding: 8px 16px;
            background: #FFFFFF;
            color: var(--primary);
            border: 1.5px solid var(--primary);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-header-preview:hover {
            background: var(--primary-soft);
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
            color: #94A3B8;
            cursor: not-allowed;
            box-shadow: none;
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        @media (max-width: 650px) {
            .form-row { grid-template-columns: 1fr; }
        }

        /* Custom Checkbox Chips */
        .chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }

        .chip-checkbox {
            position: relative;
            cursor: pointer;
            user-select: none;
            margin: 0;
        }

        .chip-checkbox input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .chip-label {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: #F8FAFC;
            border: 1px solid #CBD5E1;
            border-radius: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            color: #334155;
            transition: all 0.2s;
        }

        .chip-checkbox input:checked + .chip-label {
            background: var(--primary-soft);
            border-color: var(--primary);
            color: var(--primary-hover);
            font-weight: 700;
        }

        /* Switches / Toggles */
        .toggle-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #F1F5F9;
        }

        .toggle-row:last-child { border-bottom: none; }

        .toggle-info {
            display: flex;
            flex-direction: column;
        }

        .toggle-label {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--navy);
        }

        .toggle-subtext {
            font-size: 0.78rem;
            color: var(--text-gray);
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 26px;
        }

        .toggle-switch input { opacity: 0; width: 0; height: 0; }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #CBD5E1;
            transition: .3s;
            border-radius: 26px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }

        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(22px); }

        /* Bottom Action Buttons */
        .bottom-actions {
            margin-top: 32px;
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn-bottom-save {
            flex: 1;
            padding: 14px 20px;
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

        .btn-bottom-preview {
            flex: 1;
            padding: 14px 24px;
            background: var(--navy);
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
            box-shadow: 0 4px 14px rgba(30, 27, 75, 0.15);
        }

        .btn-bottom-preview:hover {
            background: var(--navy-light);
            transform: translateY(-1px);
        }

        /* ====================================================
           PREVIEW PROFILE MODAL & DECENT CARD LAYOUT
           ==================================================== */
        .preview-modal-backdrop {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(6px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-y: auto;
        }

        .preview-modal-dialog {
            background: #FFFFFF;
            border-radius: 20px;
            max-width: 820px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
            animation: modalFadeIn 0.25s ease-out;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .preview-modal-header {
            background: var(--navy);
            color: #FFFFFF;
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .preview-modal-header h3 {
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }

        .btn-close-modal {
            background: rgba(255, 255, 255, 0.15);
            border: none;
            color: #FFFFFF;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            transition: all 0.2s;
        }

        .btn-close-modal:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .preview-modal-body {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
            background: #F8FAFC;
        }

        /* Decent Preview Card Inside Modal */
        .preview-profile-card {
            background: #FFFFFF;
            border-radius: 16px;
            border: 1px solid #E2E8F0;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }

        .card-hero-banner {
            background: linear-gradient(135deg, #1E1B4B 0%, #312E81 100%);
            padding: 24px;
            color: #FFFFFF;
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .card-avatar-box {
            width: 90px;
            height: 90px;
            border-radius: 18px;
            overflow: hidden;
            background: #FFE4E6;
            border: 3px solid #FFFFFF;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-avatar-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .card-avatar-fallback {
            font-size: 2.4rem;
            font-weight: 900;
            color: var(--primary);
        }

        .card-hero-info {
            flex: 1;
            min-width: 220px;
        }

        .card-hero-title {
            font-size: 1.4rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }

        .card-hero-sub {
            font-size: 0.9rem;
            color: #CBD5E1;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card-badge-pill {
            background: rgba(244, 63, 94, 0.25);
            color: #FECDD3;
            border: 1px solid rgba(244, 63, 94, 0.4);
            font-size: 0.75rem;
            font-weight: 800;
            padding: 3px 10px;
            border-radius: 20px;
            display: inline-block;
        }

        .card-content-grid {
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card-info-box {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 16px;
        }

        .card-info-label {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-gray);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card-info-label i {
            color: var(--primary);
            font-size: 0.95rem;
        }

        .card-tag-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .card-tag {
            background: #FFE4E6;
            color: #BE123C;
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .card-feature-pill {
            background: #ECFDF5;
            color: #065F46;
            border: 1px solid #A7F3D0;
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 0.8rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .card-gallery-strip {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .card-gallery-img {
            width: 72px;
            height: 72px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid #E2E8F0;
        }

        /* Modal Footer */
        .preview-modal-footer {
            background: #FFFFFF;
            border-top: 1px solid #E2E8F0;
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-modal-edit {
            padding: 10px 18px;
            background: #FFFFFF;
            color: var(--navy);
            border: 1px solid #CBD5E1;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-modal-edit:hover {
            background: #F1F5F9;
        }

        .btn-modal-save {
            padding: 10px 20px;
            background: #FFFFFF;
            color: var(--primary);
            border: 1.5px solid var(--primary);
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-modal-save:hover {
            background: var(--primary-soft);
        }

        .btn-modal-submit {
            padding: 10px 24px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 800;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.3);
        }

        .btn-modal-submit:hover {
            background: var(--primary-hover);
        }
    </style>
</head>
<body>

    <!-- Sticky Top Header Bar -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/centres/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear</span>
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/centres/dashboard" class="btn-skip">Skip for now</a>
            <button type="button" class="btn-header-preview" onclick="openPreviewModal()">
                <i class="bi bi-eye-fill"></i> Preview Profile
            </button>
            <button type="button" class="btn-header-save" onclick="saveProfileDirectly()">
                <i class="bi bi-save2"></i> Save Profile
            </button>
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

        <!-- Dynamic Profile Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <span class="progress-title">
                    <i class="bi bi-speedometer2" style="color: var(--primary);"></i>
                    Profile Completion: <span id="pctText">${center.profileCompletionPct != null ? center.profileCompletionPct : 0}%</span>
                </span>
                <c:choose>
                    <c:when test="${center.centreProfileStatus == 'APPROVED' || center.approved}">
                        <span class="status-badge badge-approved"><i class="bi bi-patch-check-fill me-1"></i> Approved</span>
                    </c:when>
                    <c:when test="${center.centreProfileStatus == 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes"><i class="bi bi-pencil-square me-1"></i> Changes Requested</span>
                    </c:when>
                    <c:when test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending"><i class="bi bi-clock-history me-1"></i> Under Review</span>
                    </c:when>
                    <c:when test="${center.centreProfileStatus == 'REJECTED'}">
                        <span class="status-badge badge-rejected"><i class="bi bi-x-circle me-1"></i> Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered"><i class="bi bi-person-badge me-1"></i> In Progress</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="progress-bar-container">
                <div id="progressBarFill" class="progress-bar-fill" style="width: ${center.profileCompletionPct != null ? center.profileCompletionPct : 0}%;"></div>
            </div>
            <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 6px;">
                Complete all required sections below to submit your martial arts centre for Admin verification and marketplace listing.
            </p>

            <!-- Dynamic Missing Items Chips -->
            <div id="missingChipsContainer" class="missing-chips">
                <c:if test="${empty center.name}"><span class="chip-missing" id="chip-name"><i class="bi bi-exclamation-circle me-1"></i> Centre Name</span></c:if>
                <c:if test="${empty center.location and empty center.area}"><span class="chip-missing" id="chip-location"><i class="bi bi-exclamation-circle me-1"></i> Street Address</span></c:if>
                <c:if test="${empty center.city}"><span class="chip-missing" id="chip-city"><i class="bi bi-exclamation-circle me-1"></i> City</span></c:if>
                <c:if test="${empty center.openTime or empty center.closeTime}"><span class="chip-missing" id="chip-hours"><i class="bi bi-exclamation-circle me-1"></i> Operating Hours</span></c:if>
                <c:if test="${empty center.stylesTaught}"><span class="chip-missing" id="chip-styles"><i class="bi bi-exclamation-circle me-1"></i> Styles Taught</span></c:if>
                <c:if test="${empty center.about}"><span class="chip-missing" id="chip-about"><i class="bi bi-exclamation-circle me-1"></i> About Centre</span></c:if>
            </div>
        </div>

        <!-- Admin Feedback Banner -->
        <c:if test="${not empty center.rejectionReason or not empty center.changesRequestedNote}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Review Feedback</h4>
                    <p><c:out value="${not empty center.changesRequestedNote ? center.changesRequestedNote : center.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Top Verification Action Card -->
        <div class="submit-action-card">
            <div class="submit-info">
                <h3>Ready to get verified?</h3>
                <p>Submit your profile once required details are filled. Our team reviews within 24 hours.</p>
            </div>
            <div>
                <button type="button" class="btn-submit-verification" onclick="openPreviewModal()"
                        <c:if test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                    <c:choose>
                        <c:when test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                            <i class="bi bi-clock-history"></i> Under Review
                        </c:when>
                        <c:when test="${center.centreProfileStatus == 'APPROVED'}">
                            <i class="bi bi-patch-check-fill"></i> Verified Centre
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-send-check-fill"></i> Preview &amp; Submit for Verification
                        </c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>

        <!-- Main Form Container -->
        <form id="profileForm" action="${pageContext.request.contextPath}/centres/updateProfile${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <input type="hidden" name="id" value="${center.id}">

            <!-- SECTION 0: Centre Logo & Profile Photo (Prominent Card) -->
            <div class="section-card" style="border: 2px solid #FBCFE8; background: linear-gradient(180deg, #FFFFFF 0%, #FFF5F7 100%);">
                <div class="section-header" style="color: var(--primary); border-bottom-color: #FECDD3;">
                    <i class="bi bi-camera-fill"></i> Official Centre Logo / Profile Image
                </div>
                <div style="display: flex; align-items: center; gap: 24px; flex-wrap: wrap;">
                    <div style="position: relative; width: 110px; height: 110px; flex-shrink: 0;">
                        <c:choose>
                            <c:when test="${not empty center.profilePhoto}">
                                <img id="profilePhotoPreview" src="${pageContext.request.contextPath}${center.profilePhoto}" 
                                     alt="Centre Logo" 
                                     style="width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid #F43F5E; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                            </c:when>
                            <c:otherwise>
                                <img id="profilePhotoPreview" src="" alt="Centre Logo" 
                                     style="display: none; width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid #F43F5E; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                                <div id="profilePhotoFallback" 
                                     style="width: 110px; height: 110px; border-radius: 50%; background: #FFE4E6; color: #F43F5E; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; border: 4px solid #FECDD3;">
                                    ${not empty center.name ? center.name.substring(0, 1).toUpperCase() : 'M'}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="flex: 1; min-width: 240px;">
                        <h4 style="font-size: 1rem; font-weight: 800; color: var(--navy); margin: 0 0 4px;">Upload Dojo Logo / Facade Photo</h4>
                        <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0 0 12px; line-height: 1.4;">
                            A clear, professional logo or centre front photo increases student trust and self-defense inquiry rates by over 60%. Accepts JPG, PNG, or WebP (max 5MB).
                        </p>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                            <label for="profilePhotoInput" style="background: var(--primary); color: white; padding: 9px 18px; border-radius: 10px; font-size: 0.85rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; margin: 0; transition: background 0.2s;">
                                <i class="bi bi-upload"></i> Choose Centre Logo
                            </label>
                            <input type="file" id="profilePhotoInput" name="profilePhotoFile" accept="image/*" style="display: none;" onchange="previewSelectedPhoto(this)">
                            <button type="button" id="btnClearPhoto" onclick="clearSelectedPhoto()" style="display: none; background: white; border: 1px solid #E2E8F0; color: var(--text-gray); padding: 8px 14px; border-radius: 10px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                <i class="bi bi-x-circle"></i> Remove Selection
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 1: Centre Identity -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-building"></i> 1. Centre Identity &amp; Contact
                </div>
                
                <div class="form-group">
                    <label>1.1 Centre Name *</label>
                    <input type="text" name="name" id="inputName" class="form-input" value="<c:out value='${center.name}'/>" placeholder="e.g. Apex Martial Arts Academy" required oninput="triggerRecalculateProgress()">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.2 Centre Type *</label>
                        <select name="centreType" id="inputCentreType" class="form-select">
                            <option value="Academy" ${center.centreType == 'Academy' ? 'selected' : ''}>Academy</option>
                            <option value="Dojo" ${center.centreType == 'Dojo' ? 'selected' : ''}>Dojo</option>
                            <option value="Training hall" ${center.centreType == 'Training hall' ? 'selected' : ''}>Training hall</option>
                            <option value="Home studio" ${center.centreType == 'Home studio' ? 'selected' : ''}>Home studio</option>
                            <option value="Community hall" ${center.centreType == 'Community hall' ? 'selected' : ''}>Community hall</option>
                            <option value="Outdoor" ${center.centreType == 'Outdoor' ? 'selected' : ''}>Outdoor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.3 Owner / Head Coach *</label>
                        <input type="text" name="contactPerson" id="inputContactPerson" class="form-input" value="<c:out value='${center.contactPerson}'/>" placeholder="e.g. Sensei Rajesh Kumar" required oninput="triggerRecalculateProgress()">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.4 Designation</label>
                        <select name="designation" id="inputDesignation" class="form-select">
                            <option value="Head coach" ${center.designation == 'Head coach' ? 'selected' : ''}>Head coach</option>
                            <option value="Owner" ${center.designation == 'Owner' ? 'selected' : ''}>Owner</option>
                            <option value="Manager" ${center.designation == 'Manager' ? 'selected' : ''}>Manager</option>
                            <option value="Instructor" ${center.designation == 'Instructor' ? 'selected' : ''}>Instructor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.5 Official Phone Number *</label>
                        <input type="tel" name="phone" id="inputPhone" class="form-input" value="<c:out value='${center.phoneNumber}'/>" maxlength="10" placeholder="10-digit mobile number" required oninput="triggerRecalculateProgress()">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.6 WhatsApp Number</label>
                        <input type="tel" name="whatsappNumber" id="inputWhatsapp" class="form-input" value="<c:out value='${center.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                    </div>
                    <div class="form-group">
                        <label>1.7 Year Started</label>
                        <input type="number" name="yearStarted" id="inputYearStarted" class="form-input" value="${center.yearStarted}" placeholder="e.g. 2018" maxlength="4">
                    </div>
                </div>

                <div class="form-group">
                    <label>1.8 Federation / Style Affiliation</label>
                    <input type="text" name="affiliation" id="inputAffiliation" class="form-input" value="<c:out value='${center.affiliation}'/>" placeholder="e.g. World Karate Federation, KAI, Indian Boxing Association">
                </div>
            </div>

            <!-- SECTION 2: Location & Address -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-geo-alt-fill"></i> 2. Location &amp; Premises Address
                </div>
                
                <div class="form-group">
                    <label>2.1 Street Address / Hall / Landmark *</label>
                    <input type="text" name="location" id="inputLocation" class="form-input" value="<c:out value='${not empty center.location ? center.location : center.area}'/>" placeholder="Door/Plot No, Hall name, Landmark, Road" required oninput="triggerRecalculateProgress()">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>2.2 City *</label>
                        <input type="text" name="city" id="inputCity" class="form-input" value="<c:out value='${center.city}'/>" placeholder="e.g. Mumbai" required oninput="triggerRecalculateProgress()">
                    </div>
                    <div class="form-group">
                        <label>2.3 State *</label>
                        <input type="text" name="state" id="inputState" class="form-input" value="<c:out value='${center.state}'/>" placeholder="e.g. Maharashtra" required oninput="triggerRecalculateProgress()">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>2.4 Pincode *</label>
                        <input type="text" name="pincode" id="inputPincode" class="form-input" value="<c:out value='${center.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required oninput="triggerRecalculateProgress()">
                    </div>
                    <div class="form-group">
                        <label>2.5 Google Map Location Link</label>
                        <input type="url" name="mapLink" id="inputMapLink" class="form-input" value="<c:out value='${center.googleMapLocation}'/>" placeholder="https://maps.google.com/...">
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Martial Arts Styles -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-award-fill"></i> 3. Martial Arts Styles Taught *
                </div>
                <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 12px;">Select all combat disciplines and martial arts systems offered at your centre:</p>
                <div class="chips-container">
                    <c:forEach var="style" items="${['Karate', 'Taekwondo', 'Self-Defence', 'Kickboxing', 'Boxing', 'MMA', 'Judo', 'Krav Maga', 'Jiu-Jitsu', 'Kung Fu', 'Muay Thai', 'Kalari']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="styles" value="${style}" class="style-checkbox" ${center.stylesTaught != null && center.stylesTaught.contains(style) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                            <span class="chip-label"><i class="bi bi-check2"></i> ${style}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- SECTION 4: Target Audience -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-people-fill"></i> 4. Who Can Join (Target Audience) *
                </div>
                <div class="chips-container">
                    <c:forEach var="aud" items="${['Women & Girls', 'Kids (5-12 yrs)', 'Teens & College Students', 'Beginners & Working Women', 'Professional Athletes', 'Senior Citizens']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="audience" value="${aud}" class="aud-checkbox" ${center.audience != null && center.audience.contains(aud) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                            <span class="chip-label"><i class="bi bi-check2"></i> ${aud}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- SECTION 5: Training Features & Environment -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-shield-check"></i> 5. Training Environment &amp; Amenities
                </div>
                
                <div class="toggle-row">
                    <div class="toggle-info">
                        <span class="toggle-label"><i class="bi bi-gender-female text-danger me-1"></i> Exclusive Women-Only Batches</span>
                        <span class="toggle-subtext">Dedicated slots reserved exclusively for female students and girls</span>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" name="womenOnly" id="inputWomenOnly" value="true" ${center.womenOnlyBatches == true ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>

                <div class="toggle-row">
                    <div class="toggle-info">
                        <span class="toggle-label"><i class="bi bi-person-check-fill text-success me-1"></i> Female Black-Belt Instructor Present</span>
                        <span class="toggle-subtext">Certified female trainers and coaches actively conducting training</span>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" name="femaleInstructor" id="inputFemaleInstructor" value="true" ${center.femaleInstructor == true ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>

                <div style="margin-top: 18px;">
                    <label style="font-size: 0.84rem; font-weight: 700; color: var(--navy); display: block; margin-bottom: 8px;">Dojo Amenities &amp; Facilities:</label>
                    <div class="chips-container">
                        <c:forEach var="fac" items="${['Tatami Mats', 'Changing Rooms', 'Drinking Water', 'Punching Bags', 'First Aid Box', 'CCTV Security', 'Shower Area', 'Air Conditioning / Ventilation']}">
                            <label class="chip-checkbox">
                                <input type="checkbox" name="facilities" value="${fac}" class="fac-checkbox" ${center.facilities != null && center.facilities.contains(fac) ? 'checked' : ''}>
                                <span class="chip-label"><i class="bi bi-check2"></i> ${fac}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- SECTION 6: Working Hours & Schedule -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-clock-history"></i> 6. Available Days &amp; Timings *
                </div>
                
                <div class="form-group">
                    <label>6.1 Open Days *</label>
                    <div class="chips-container">
                        <c:forEach var="day" items="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']}">
                            <label class="chip-checkbox">
                                <input type="checkbox" name="availableDays" value="${day}" class="day-checkbox" ${center.availableDays != null && center.availableDays.contains(day) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                                <span class="chip-label"><i class="bi bi-calendar-event"></i> ${day}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>6.2 Opening Time *</label>
                        <input type="time" name="openTime" id="inputOpenTime" class="form-input" value="<c:out value='${not empty center.openTime ? center.openTime : \"06:00\"}'/>" required onchange="triggerRecalculateProgress()">
                    </div>
                    <div class="form-group">
                        <label>6.3 Closing Time *</label>
                        <input type="time" name="closeTime" id="inputCloseTime" class="form-input" value="<c:out value='${not empty center.closeTime ? center.closeTime : \"21:00\"}'/>" required onchange="triggerRecalculateProgress()">
                    </div>
                </div>
            </div>

            <!-- SECTION 7: About the Centre -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-card-text"></i> 7. About the Centre &amp; Methodology *
                </div>

                <div class="form-group">
                    <label>7.1 About the Centre &amp; Philosophy *</label>
                    <textarea name="about" id="inputAbout" class="form-textarea" rows="4" placeholder="Describe your training ethos, instructors, safety standards, and dojo culture..." required oninput="triggerRecalculateProgress()"><c:out value="${center.about}"/></textarea>
                </div>

                <div class="form-group">
                    <label>7.2 How We Teach &amp; Step-by-Step Methodology *</label>
                    <textarea name="howWeTeach" id="inputHowWeTeach" class="form-textarea" rows="3" placeholder="Explain your teaching progression (warmups, belt grading, sparring, self-defense drills)..." required oninput="triggerRecalculateProgress()"><c:out value="${center.howWeTeach}"/></textarea>
                </div>

                <div class="form-group">
                    <label>7.3 What We Offer *</label>
                    <div class="chips-container">
                        <c:forEach var="offer" items="${['Regular class', 'Trial class', 'Belt grading', 'Workshops', 'Self-defence crash course']}">
                            <label class="chip-checkbox">
                                <input type="checkbox" name="offers" value="${offer}" class="offer-checkbox" ${center.whatWeOffer != null && center.whatWeOffer.contains(offer) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                                <span class="chip-label"><i class="bi bi-check2"></i> ${offer}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- SECTION 8: Payout & Settlement Details -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-bank"></i> 8. Payout &amp; Bank Account Details
                </div>
                
                <div class="form-group">
                    <label>8.1 Direct UPI ID</label>
                    <input type="text" name="upiId" id="inputUpiId" class="form-input" value="<c:out value='${center.upiId}'/>" placeholder="centre@upi">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>8.2 Account Holder Name *</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank records">
                    </div>
                    <div class="form-group">
                        <label>8.3 Bank Name *</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. HDFC Bank, ICICI Bank, SBI">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>8.4 Account Number *</label>
                        <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Bank Account Number" maxlength="20">
                    </div>
                    <div class="form-group">
                        <label>8.5 Confirm Account Number *</label>
                        <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Re-enter Account Number" maxlength="20">
                        <small id="accMismatchMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match
                        </small>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>8.6 IFSC Code *</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. HDFC0001234" maxlength="11" style="text-transform: uppercase;">
                        <small id="ifscFormatMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Invalid IFSC format (e.g. SBIN0001234)
                        </small>
                    </div>
                    <div class="form-group">
                        <label>8.7 Branch Name</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Andheri West Branch">
                    </div>
                </div>

                <!-- Hidden serialized field for DB compatibility -->
                <input type="hidden" id="bankDetails" name="bankDetails" value="<c:out value='${center.bankDetails}'/>">
            </div>

            <!-- SECTION 9: Trainer Certificate / Documents -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-file-earmark-check"></i> 9. Trainer Certification &amp; Proof (Optional)
                </div>
                <div class="form-group">
                    <label>9.1 Black Belt / Coach Certificate / Registration Proof</label>
                    <input type="file" name="certificateFile" class="form-input" accept=".pdf,image/*">
                    <c:if test="${not empty center.trainerCertificatePath}">
                        <div style="margin-top: 8px; font-size: 0.82rem; color: #16A34A; font-weight: 600;">
                            <i class="bi bi-check-circle-fill"></i> Certificate on file: <c:out value="${center.trainerCertificatePath}"/>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- SECTION 10: Centre Photos (Gallery) -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-images"></i> 10. Centre &amp; Dojo Gallery Photos
                </div>
                
                <p style="font-size: 0.85rem; color: var(--text-gray); margin-bottom: 14px;">
                    Upload photos of your training mats, equipment, class sessions, and student belt grading ceremonies.
                </p>

                <!-- Modern File Upload Control -->
                <div style="background: #F8FAFC; border: 2px dashed #CBD5E1; border-radius: 12px; padding: 24px; text-align: center;">
                    <i class="bi bi-cloud-arrow-up-fill" style="font-size: 2.2rem; color: var(--primary); display: block; margin-bottom: 8px;"></i>
                    <label for="inputGalleryFiles" style="background: var(--navy); color: white; padding: 10px 22px; border-radius: 10px; font-size: 0.88rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 8px; transition: background 0.2s;">
                        <i class="bi bi-plus-circle"></i> Choose Gallery Photos (Multiple)
                    </label>
                    <input type="file" name="galleryFiles" id="inputGalleryFiles" accept="image/*" multiple style="display: none;" onchange="previewSelectedGallery(this)">
                    <p style="font-size: 0.78rem; color: var(--text-gray); margin: 0;">JPG, PNG, WebP up to 5MB each. You can select multiple images.</p>
                    
                    <!-- Live Status of Selected Photos -->
                    <div id="gallerySelectedStatus" style="display: none; margin-top: 14px; background: #ECFDF5; border: 1px solid #A7F3D0; color: #065F46; padding: 8px 14px; border-radius: 8px; font-size: 0.85rem; font-weight: 700;">
                        <i class="bi bi-check-circle-fill me-1"></i> <span id="galleryCountText">0</span> new photos selected for upload
                    </div>

                    <!-- Thumbnails for newly selected photos -->
                    <div id="newGalleryPreviews" style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; margin-top: 14px;"></div>
                </div>

                <!-- Existing Uploaded Gallery Photos -->
                <c:if test="${not empty center.galleryPhotos and center.galleryPhotos.size() > 0}">
                    <div style="margin-top: 20px;">
                        <label style="font-size: 0.84rem; font-weight: 700; color: var(--navy); display: block; margin-bottom: 10px;">
                            Currently Saved Gallery Photos (${center.galleryPhotos.size()}):
                        </label>
                        <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                            <c:forEach var="photo" items="${center.galleryPhotos}">
                                <div style="position: relative; width: 84px; height: 84px; border-radius: 12px; overflow: hidden; border: 2px solid #E2E8F0; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                                    <img src="${pageContext.request.contextPath}${photo}" style="width: 100%; height: 100%; object-fit: cover;" alt="Dojo Gallery Photo">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Bottom Action Buttons -->
            <div class="bottom-actions">
                <button type="button" class="btn-bottom-save" onclick="saveProfileDirectly()">
                    <i class="bi bi-save2"></i> Save Profile Details
                </button>
                <button type="button" class="btn-bottom-preview" onclick="openPreviewModal()">
                    <i class="bi bi-eye-fill"></i> Preview Profile &amp; Submit
                </button>
            </div>
        </form>

        <!-- Hidden Verification Form for direct submission -->
        <form id="verificationForm" action="${pageContext.request.contextPath}/centres/submit-verification${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" style="display: none;">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
        </form>
    </main>

    <!-- ====================================================
         PREVIEW PROFILE MODAL & DECENT CARD LAYOUT
         ==================================================== -->
    <div id="previewModalBackdrop" class="preview-modal-backdrop" onclick="handleBackdropClick(event)">
        <div class="preview-modal-dialog">
            <div class="preview-modal-header">
                <h3><i class="bi bi-award-fill" style="color: var(--primary);"></i> Centre Profile Preview</h3>
                <button type="button" class="btn-close-modal" onclick="closePreviewModal()">&times;</button>
            </div>
            
            <div class="preview-modal-body">
                <!-- Preview Profile Card with Decent Layout -->
                <div class="preview-profile-card">
                    
                    <!-- Hero Banner -->
                    <div class="card-hero-banner">
                        <div class="card-avatar-box">
                            <img id="modalAvatarImg" src="" class="card-avatar-img" alt="Centre Logo" style="display: none;">
                            <div id="modalAvatarFallback" class="card-avatar-fallback">M</div>
                        </div>
                        <div class="card-hero-info">
                            <div class="card-hero-title">
                                <span id="modalName">Apex Martial Arts Academy</span>
                                <i class="bi bi-patch-check-fill" style="color: #10B981; font-size: 1.15rem;" title="Verified Centre"></i>
                            </div>
                            <div class="card-hero-sub">
                                <span id="modalCoach">Sensei Rajesh</span> &bull; 
                                <span id="modalDesignation">Head Coach</span> &bull; 
                                <span id="modalLocation"><i class="bi bi-geo-alt-fill text-danger me-1"></i> Mumbai, Maharashtra</span>
                            </div>
                            <span id="modalCentreType" class="card-badge-pill">Dojo</span>
                        </div>
                    </div>

                    <!-- Card Body Content -->
                    <div class="card-content-grid">
                        
                        <!-- Timings & Availability -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-clock-history"></i> Operating Timings &amp; Days</div>
                            <div style="font-size: 0.92rem; font-weight: 700; color: var(--navy); margin-bottom: 6px;" id="modalHours">06:00 - 21:00</div>
                            <div id="modalDaysTags" class="card-tag-row"></div>
                        </div>

                        <!-- Training Features -->
                        <div class="card-info-box" id="modalFeaturesBox">
                            <div class="card-info-label"><i class="bi bi-shield-check"></i> Training Environment</div>
                            <div class="card-tag-row">
                                <span id="modalWomenOnlyBadge" class="card-feature-pill" style="display: none;">
                                    <i class="bi bi-gender-female text-danger"></i> Women-Only Batches Available
                                </span>
                                <span id="modalFemaleInstBadge" class="card-feature-pill" style="display: none;">
                                    <i class="bi bi-person-check-fill text-success"></i> Female Instructor Present
                                </span>
                            </div>
                        </div>

                        <!-- Styles Taught -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-award"></i> Martial Arts Styles Taught</div>
                            <div id="modalStylesTags" class="card-tag-row"></div>
                        </div>

                        <!-- Target Audience -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-people"></i> Who Can Join</div>
                            <div id="modalAudienceTags" class="card-tag-row"></div>
                        </div>

                        <!-- Dojo Amenities -->
                        <div class="card-info-box" id="modalFacilitiesBox">
                            <div class="card-info-label"><i class="bi bi-building-check"></i> Dojo Facilities &amp; Amenities</div>
                            <div id="modalFacilitiesTags" class="card-tag-row"></div>
                        </div>

                        <!-- About & Ethos -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-card-text"></i> About Centre &amp; Philosophy</div>
                            <p id="modalAboutText" style="font-size: 0.88rem; color: #334155; margin-bottom: 10px; line-height: 1.5; white-space: pre-wrap;"></p>
                            
                            <div class="card-info-label" style="margin-top: 12px;"><i class="bi bi-journal-text"></i> Teaching Progression</div>
                            <p id="modalHowWeTeachText" style="font-size: 0.88rem; color: #334155; margin: 0; line-height: 1.5; white-space: pre-wrap;"></p>
                        </div>

                        <!-- Photos Strip -->
                        <div class="card-info-box" id="modalGalleryBox">
                            <div class="card-info-label"><i class="bi bi-images"></i> Dojo Photos Strip</div>
                            <div id="modalGalleryStrip" class="card-gallery-strip"></div>
                        </div>

                        <!-- Payout / Settlement Preview -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-bank"></i> Verified Settlement Account</div>
                            <div style="font-size: 0.85rem; color: var(--navy); font-weight: 600;" id="modalBankSummary">
                                Bank Account on file
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Modal Footer Actions -->
            <div class="preview-modal-footer">
                <button type="button" class="btn-modal-edit" onclick="closePreviewModal()">
                    <i class="bi bi-pencil-square me-1"></i> Edit Details
                </button>
                <button type="button" class="btn-modal-save" onclick="saveProfileDirectly()">
                    <i class="bi bi-save2 me-1"></i> Save as Draft
                </button>
                <button type="button" class="btn-modal-submit" onclick="submitForVerification()">
                    <i class="bi bi-send-check-fill me-1"></i> Confirm &amp; Submit for Verification
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript Engine -->
    <script>
        // Profile Photo Preview & Clear
        function previewSelectedPhoto(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.getElementById('profilePhotoPreview');
                    const fallback = document.getElementById('profilePhotoFallback');
                    const clearBtn = document.getElementById('btnClearPhoto');
                    if (img) {
                        img.src = e.target.result;
                        img.style.display = 'block';
                    }
                    if (fallback) fallback.style.display = 'none';
                    if (clearBtn) clearBtn.style.display = 'inline-flex';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function clearSelectedPhoto() {
            const input = document.getElementById('profilePhotoInput');
            const img = document.getElementById('profilePhotoPreview');
            const fallback = document.getElementById('profilePhotoFallback');
            const clearBtn = document.getElementById('btnClearPhoto');
            if (input) input.value = '';
            if (img) {
                img.src = '';
                img.style.display = 'none';
            }
            if (fallback) fallback.style.display = 'flex';
            if (clearBtn) clearBtn.style.display = 'none';
        }

        // Gallery Photos Multi-Select Preview & Status
        let newlySelectedGalleryFiles = [];

        function previewSelectedGallery(input) {
            const statusBox = document.getElementById('gallerySelectedStatus');
            const countText = document.getElementById('galleryCountText');
            const previewContainer = document.getElementById('newGalleryPreviews');
            
            if (input.files && input.files.length > 0) {
                newlySelectedGalleryFiles = Array.from(input.files);
                if (statusBox) statusBox.style.display = 'block';
                if (countText) countText.textContent = newlySelectedGalleryFiles.length;
                if (previewContainer) {
                    previewContainer.innerHTML = '';
                    newlySelectedGalleryFiles.slice(0, 8).forEach(file => {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const thumb = document.createElement('div');
                            thumb.style.cssText = 'width: 72px; height: 72px; border-radius: 10px; overflow: hidden; border: 2px solid #10B981; box-shadow: 0 2px 6px rgba(0,0,0,0.08); position: relative;';
                            thumb.innerHTML = '<img src="' + e.target.result + '" style="width: 100%; height: 100%; object-fit: cover;" alt="Preview">';
                            previewContainer.appendChild(thumb);
                        };
                        reader.readAsDataURL(file);
                    });
                }
            } else {
                newlySelectedGalleryFiles = [];
                if (statusBox) statusBox.style.display = 'none';
                if (previewContainer) previewContainer.innerHTML = '';
            }
        }

        // Real-Time Progress Calculation to 100%
        function triggerRecalculateProgress() {
            let filled = 0;
            const total = 16;

            const name = document.getElementById('inputName')?.value.trim();
            if (name) filled++;

            const centreType = document.getElementById('inputCentreType')?.value.trim();
            if (centreType) filled++;

            const contact = document.getElementById('inputContactPerson')?.value.trim();
            if (contact) filled++;

            const phone = document.getElementById('inputPhone')?.value.trim();
            if (phone && phone.length === 10) filled++;

            const loc = document.getElementById('inputLocation')?.value.trim();
            if (loc) filled++;

            const city = document.getElementById('inputCity')?.value.trim();
            if (city) filled++;

            const state = document.getElementById('inputState')?.value.trim();
            if (state) filled++;

            const pincode = document.getElementById('inputPincode')?.value.trim();
            if (pincode && pincode.length === 6) filled++;

            const stylesCount = document.querySelectorAll('.style-checkbox:checked').length;
            if (stylesCount > 0) filled++;

            const audCount = document.querySelectorAll('.aud-checkbox:checked').length;
            if (audCount > 0) filled++;

            const daysCount = document.querySelectorAll('.day-checkbox:checked').length;
            if (daysCount > 0) filled++;

            const openTime = document.getElementById('inputOpenTime')?.value.trim();
            if (openTime) filled++;

            const closeTime = document.getElementById('inputCloseTime')?.value.trim();
            if (closeTime) filled++;

            const about = document.getElementById('inputAbout')?.value.trim();
            if (about) filled++;

            const howWeTeach = document.getElementById('inputHowWeTeach')?.value.trim();
            if (howWeTeach) filled++;

            const offersCount = document.querySelectorAll('.offer-checkbox:checked').length;
            if (offersCount > 0) filled++;

            const pct = Math.min(100, Math.round((filled / total) * 100));

            const pctText = document.getElementById('pctText');
            if (pctText) pctText.textContent = pct + '%';

            const barFill = document.getElementById('progressBarFill');
            if (barFill) barFill.style.width = pct + '%';

            // Hide missing chips if filled
            if (name && document.getElementById('chip-name')) document.getElementById('chip-name').style.display = 'none';
            if (loc && document.getElementById('chip-location')) document.getElementById('chip-location').style.display = 'none';
            if (city && document.getElementById('chip-city')) document.getElementById('chip-city').style.display = 'none';
            if (openTime && closeTime && document.getElementById('chip-hours')) document.getElementById('chip-hours').style.display = 'none';
            if (stylesCount > 0 && document.getElementById('chip-styles')) document.getElementById('chip-styles').style.display = 'none';
            if (about && document.getElementById('chip-about')) document.getElementById('chip-about').style.display = 'none';
        }

        // Bank Details Pre-parsing & Synchronization
        function parseExistingBankDetails() {
            const raw = (document.getElementById('bankDetails')?.value || '').trim();
            if (!raw) return;

            if (raw.includes('|')) {
                const parts = raw.split('|').map(s => s.trim());
                parts.forEach(part => {
                    const lower = part.toLowerCase();
                    if (lower.startsWith('account holder:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankAccountHolder');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('bank:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankName');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('a/c:') || lower.startsWith('account:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankAccountNumber');
                        const cel = document.getElementById('confirmAccountNumber');
                        if (el && !el.value) el.value = val;
                        if (cel && !cel.value) cel.value = val;
                    } else if (lower.startsWith('ifsc:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankIfsc');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('branch:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankBranch');
                        if (el && !el.value) el.value = val;
                    }
                });
            } else {
                const holder = document.getElementById('bankAccountHolder');
                if (holder && !holder.value) holder.value = raw;
            }
        }

        function syncBankDetails() {
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '';
            const bName = document.getElementById('bankName')?.value.trim() || '';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '';

            const ifscInput = document.getElementById('bankIfsc');
            if (ifscInput && ifscInput.value !== ifsc) ifscInput.value = ifsc;

            const mismatchEl = document.getElementById('accMismatchMsg');
            if (mismatchEl) {
                if (acc && confirmAcc && acc !== confirmAcc) {
                    mismatchEl.style.display = 'block';
                } else {
                    mismatchEl.style.display = 'none';
                }
            }

            const ifscMsg = document.getElementById('ifscFormatMsg');
            if (ifscMsg) {
                if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                    ifscMsg.style.display = 'block';
                } else {
                    ifscMsg.style.display = 'none';
                }
            }

            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                }
            }
        }

        // Open & Populate Preview Modal Card
        function openPreviewModal() {
            syncBankDetails();

            // Populate Name & Identity
            const name = document.getElementById('inputName')?.value.trim() || 'Centre Name';
            document.getElementById('modalName').textContent = name;
            
            const coach = document.getElementById('inputContactPerson')?.value.trim() || 'Owner / Coach';
            document.getElementById('modalCoach').textContent = coach;

            const desig = document.getElementById('inputDesignation')?.value || 'Head Coach';
            document.getElementById('modalDesignation').textContent = desig;

            const city = document.getElementById('inputCity')?.value.trim() || 'City';
            const state = document.getElementById('inputState')?.value.trim() || 'State';
            document.getElementById('modalLocation').innerHTML = '<i class="bi bi-geo-alt-fill text-danger me-1"></i> ' + city + ', ' + state;

            const cType = document.getElementById('inputCentreType')?.value || 'Academy';
            document.getElementById('modalCentreType').textContent = cType;

            // Avatar Preview in Modal
            const photoImg = document.getElementById('profilePhotoPreview');
            const modalImg = document.getElementById('modalAvatarImg');
            const modalFallback = document.getElementById('modalAvatarFallback');
            if (photoImg && photoImg.src && photoImg.style.display !== 'none' && !photoImg.src.endsWith('/')) {
                modalImg.src = photoImg.src;
                modalImg.style.display = 'block';
                modalFallback.style.display = 'none';
            } else {
                modalImg.style.display = 'none';
                modalFallback.style.display = 'block';
                modalFallback.textContent = name.charAt(0).toUpperCase() || 'M';
            }

            // Timings & Days
            const openTime = document.getElementById('inputOpenTime')?.value || '06:00';
            const closeTime = document.getElementById('inputCloseTime')?.value || '21:00';
            document.getElementById('modalHours').textContent = openTime + ' - ' + closeTime;

            const daysContainer = document.getElementById('modalDaysTags');
            daysContainer.innerHTML = '';
            const checkedDays = Array.from(document.querySelectorAll('.day-checkbox:checked')).map(c => c.value);
            if (checkedDays.length === 0) {
                daysContainer.innerHTML = '<span class="card-tag">Mon - Sat</span>';
            } else {
                checkedDays.forEach(d => {
                    const t = document.createElement('span');
                    t.className = 'card-tag';
                    t.textContent = d.substring(0, 3);
                    daysContainer.appendChild(t);
                });
            }

            // Features (Women-Only & Female Instructor)
            const womenOnly = document.getElementById('inputWomenOnly')?.checked;
            const femaleInst = document.getElementById('inputFemaleInstructor')?.checked;
            document.getElementById('modalWomenOnlyBadge').style.display = womenOnly ? 'inline-flex' : 'none';
            document.getElementById('modalFemaleInstBadge').style.display = femaleInst ? 'inline-flex' : 'none';

            // Styles Taught
            const stylesContainer = document.getElementById('modalStylesTags');
            stylesContainer.innerHTML = '';
            const checkedStyles = Array.from(document.querySelectorAll('.style-checkbox:checked')).map(c => c.value);
            if (checkedStyles.length === 0) {
                stylesContainer.innerHTML = '<span class="card-tag">Karate</span><span class="card-tag">Self-Defence</span>';
            } else {
                checkedStyles.forEach(s => {
                    const t = document.createElement('span');
                    t.className = 'card-tag';
                    t.textContent = s;
                    stylesContainer.appendChild(t);
                });
            }

            // Audience
            const audContainer = document.getElementById('modalAudienceTags');
            audContainer.innerHTML = '';
            const checkedAud = Array.from(document.querySelectorAll('.aud-checkbox:checked')).map(c => c.value);
            if (checkedAud.length === 0) {
                audContainer.innerHTML = '<span class="card-tag">Women &amp; Girls</span><span class="card-tag">Beginners</span>';
            } else {
                checkedAud.forEach(a => {
                    const t = document.createElement('span');
                    t.className = 'card-tag';
                    t.textContent = a;
                    audContainer.appendChild(t);
                });
            }

            // Facilities
            const facContainer = document.getElementById('modalFacilitiesTags');
            facContainer.innerHTML = '';
            const checkedFac = Array.from(document.querySelectorAll('.fac-checkbox:checked')).map(c => c.value);
            if (checkedFac.length === 0) {
                document.getElementById('modalFacilitiesBox').style.display = 'none';
            } else {
                document.getElementById('modalFacilitiesBox').style.display = 'block';
                checkedFac.forEach(f => {
                    const t = document.createElement('span');
                    t.className = 'card-feature-pill';
                    t.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i> ' + f;
                    facContainer.appendChild(t);
                });
            }

            // About & How We Teach
            const about = document.getElementById('inputAbout')?.value.trim() || 'Dedicated martial arts and personal defense academy.';
            document.getElementById('modalAboutText').textContent = about;

            const howWeTeach = document.getElementById('inputHowWeTeach')?.value.trim() || 'Structured belt grading syllabus, daily fitness warmups, technique drills, and practical self-defense application.';
            document.getElementById('modalHowWeTeachText').textContent = howWeTeach;

            // Gallery Strip
            const galleryStrip = document.getElementById('modalGalleryStrip');
            galleryStrip.innerHTML = '';
            
            // Check existing gallery photos
            <c:if test="${not empty center.galleryPhotos}">
                <c:forEach var="p" items="${center.galleryPhotos}">
                    galleryStrip.innerHTML += '<img src="${pageContext.request.contextPath}${p}" class="card-gallery-img" alt="Gallery Photo">';
                </c:forEach>
            </c:if>

            // Append newly selected files
            if (newlySelectedGalleryFiles.length > 0) {
                newlySelectedGalleryFiles.slice(0, 5).forEach(f => {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'card-gallery-img';
                        img.style.borderColor = '#10B981';
                        galleryStrip.appendChild(img);
                    };
                    reader.readAsDataURL(f);
                });
            }

            if (galleryStrip.children.length === 0 && newlySelectedGalleryFiles.length === 0) {
                document.getElementById('modalGalleryBox').style.display = 'none';
            } else {
                document.getElementById('modalGalleryBox').style.display = 'block';
            }

            // Bank Summary
            const bHolder = document.getElementById('bankAccountHolder')?.value.trim();
            const bName = document.getElementById('bankName')?.value.trim();
            const bAcc = document.getElementById('bankAccountNumber')?.value.trim();
            const bIfsc = document.getElementById('bankIfsc')?.value.trim();
            const upi = document.getElementById('inputUpiId')?.value.trim();

            if (bAcc || bHolder) {
                const masked = bAcc ? '•••• ' + bAcc.slice(-4) : 'Provided';
                document.getElementById('modalBankSummary').innerHTML = 
                    '<i class="bi bi-shield-lock-fill text-success me-1"></i> A/C: ' + masked + ' (' + (bName || 'Bank') + ') &bull; IFSC: ' + (bIfsc || 'N/A') + (upi ? ' &bull; UPI: ' + upi : '');
            } else {
                document.getElementById('modalBankSummary').textContent = 'Direct Bank details not provided yet';
            }

            // Show Backdrop & Dialog
            document.getElementById('previewModalBackdrop').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closePreviewModal() {
            document.getElementById('previewModalBackdrop').style.display = 'none';
            document.body.style.overflow = '';
        }

        function handleBackdropClick(e) {
            if (e.target.id === 'previewModalBackdrop') {
                closePreviewModal();
            }
        }

        // Save Profile Directly
        function saveProfileDirectly() {
            syncBankDetails();
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();

            if (acc && confirmAcc && acc !== confirmAcc) {
                alert('Bank account numbers do not match. Please verify and correct.');
                document.getElementById('confirmAccountNumber')?.focus();
                return;
            }

            if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                alert('Please enter a valid 11-character IFSC code (e.g. SBIN0001234).');
                document.getElementById('bankIfsc')?.focus();
                return;
            }

            document.getElementById('profileForm').submit();
        }

        // Confirm & Submit for Verification
        function submitForVerification() {
            syncBankDetails();
            const form = document.getElementById('profileForm');
            if (!form.checkValidity()) {
                closePreviewModal();
                form.reportValidity();
                return;
            }

            // Save details and trigger verification in one seamless request
            let input = document.getElementById('submitVerificationAfterSaveInput');
            if (!input) {
                input = document.createElement('input');
                input.type = 'hidden';
                input.id = 'submitVerificationAfterSaveInput';
                input.name = 'submitVerificationAfterSave';
                input.value = 'true';
                form.appendChild(input);
            }
            form.submit();
        }

        // On DOM Load
        document.addEventListener('DOMContentLoaded', function() {
            parseExistingBankDetails();
            triggerRecalculateProgress();

            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', syncBankDetails);
                    el.addEventListener('blur', syncBankDetails);
                }
            });

            // Sync bank details before form submission
            const pForm = document.getElementById('profileForm');
            if (pForm) {
                pForm.addEventListener('submit', function() {
                    syncBankDetails();
                });
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
