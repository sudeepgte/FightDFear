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
    <title>Complete Entrepreneur Profile — Fight D Fear</title>
    
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Leaflet CSS for Interactive Location Map (Whitelisted by CSP) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">

    <style>
        :root {
            --bg-page: #F8FAFC;
            --bg-card: #FFFFFF;
            --text-plum: #0F172A;
            --brand-pink: #F43F5E;
            --brand-pink-hover: #E11D48;
            --pink-soft-bg: #FFF1F2;
            --pink-border: #FECDD3;
            --gold-accent: #F59E0B;
            --border-light: #E2E8F0;
            --font-main: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            --font-heading: 'Outfit', sans-serif;
            --text-gray: #64748B;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --shadow-card: 0 4px 18px rgba(15, 23, 42, 0.04);
            --shadow-hover: 0 8px 24px rgba(15, 23, 42, 0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { overflow-x: hidden; }

        body {
            font-family: var(--font-main);
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--text-plum);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Sticky Header */
        .app-header {
            background: var(--bg-card);
            border-bottom: 1px solid var(--border-light);
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
            gap: 12px;
            flex-wrap: wrap;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-plum);
            text-decoration: none;
        }

        .header-brand i { color: var(--brand-pink); font-size: 1.3rem; }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-light);
            background: var(--bg-card);
            color: var(--text-plum);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
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
        }

        .btn-header-save {
            padding: 8px 18px;
            background: var(--brand-pink);
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
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }

        .btn-header-save:hover {
            background: var(--brand-pink-hover);
            transform: translateY(-1px);
        }

        .btn-header-save:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        /* Main Container: Responsive Width for Windows laptops & desktops */
        .main-container {
            flex: 1;
            max-width: 1080px;
            width: 100%;
            margin: 22px auto 48px;
            padding: 0 clamp(16px, 2.5vw, 32px);
            box-sizing: border-box;
        }

        /* Alerts & Banners */
        .alert-box {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            animation: fadeIn 0.3s ease;
        }

        .alert-success {
            background: var(--success-bg);
            border: 1px solid #BBF7D0;
            color: var(--success);
        }

        .alert-error {
            background: var(--error-bg);
            border: 1px solid #FECACA;
            color: var(--error);
        }

        /* Profile Completion Card */
        .profile-progress-card {
            background: var(--bg-card);
            border-radius: 18px;
            border: 1px solid var(--border-light);
            padding: 22px 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .progress-title {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--text-plum);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-pct {
            font-size: 0.88rem;
            font-weight: 800;
            color: var(--brand-pink);
            background: var(--pink-soft-bg);
            border: 1px solid var(--pink-border);
            padding: 4px 12px;
            border-radius: 999px;
        }

        .status-badge {
            font-size: 0.78rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 999px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-changes { background: #FFF7ED; color: #C2410C; border: 1px solid #FFEDD5; }
        .badge-approved { background: #DCFCE7; color: #15803D; }
        .badge-rejected { background: #FEE2E2; color: #B91C1C; }

        .progress-bar-container {
            height: 10px;
            background: #E2E8F0;
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 14px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E 0%, #FB7185 100%);
            border-radius: 6px;
            transition: width 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .progress-guidance {
            font-size: 0.88rem;
            color: var(--text-gray);
            line-height: 1.5;
        }

        .missing-list {
            margin-top: 12px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .missing-tag {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 0.76rem;
            font-weight: 600;
            background: #FFF7ED;
            color: #C2410C;
            border: 1px solid #FED7AA;
            border-radius: 6px;
            padding: 4px 9px;
            transition: all 0.2s ease;
        }

        /* Admin Feedback Banner */
        .feedback-banner {
            background: #FFFBEB;
            border: 1px solid #FCD34D;
            border-radius: 14px;
            padding: 16px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .feedback-banner i {
            color: #D97706;
            font-size: 1.3rem;
            margin-top: 1px;
            flex-shrink: 0;
        }

        .feedback-content h4 {
            font-size: 0.92rem;
            font-weight: 800;
            color: #92400E;
            margin-bottom: 4px;
        }

        .feedback-content p {
            font-size: 0.86rem;
            color: #78350F;
            line-height: 1.45;
        }

        /* Verification Submit Bar */
        .submit-bar {
            margin-bottom: 22px;
        }

        .btn-submit-verification {
            width: 100%;
            padding: 14px 20px;
            background: var(--brand-pink);
            color: #FFFFFF;
            border: none;
            border-radius: 14px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--brand-pink-hover);
            transform: translateY(-1px);
        }

        .btn-submit-verification:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748B;
            transform: none;
        }

        /* Section Cards */
        .section-card {
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: 18px;
            padding: clamp(18px, 2.5vw, 26px);
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
            transition: box-shadow 0.2s;
        }

        .section-card:hover {
            box-shadow: var(--shadow-hover);
        }

        .section-header {
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-plum);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-header .num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 9px;
            background: var(--pink-soft-bg);
            color: var(--brand-pink);
            font-weight: 800;
            font-size: 0.95rem;
            flex-shrink: 0;
        }

        /* Form Layouts: Windows 2-Column Responsive */
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-row.form-row-3 {
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .form-group {
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        label {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--text-plum);
            margin-bottom: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        label .req {
            color: var(--brand-pink);
            font-size: 0.95rem;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border-light);
            border-radius: 11px;
            font-size: 0.92rem;
            font-family: inherit;
            color: var(--text-plum);
            background: #FFFFFF;
            transition: all 0.2s ease;
            outline: none;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input::placeholder, .form-textarea::placeholder {
            color: #94A3B8;
        }

        .form-textarea {
            resize: vertical;
            min-height: 90px;
            line-height: 1.5;
        }

        .hint {
            font-size: 0.78rem;
            color: var(--text-gray);
            margin-top: 5px;
            line-height: 1.4;
        }

        /* Inline Validation Error Messages */
        .error-msg {
            color: var(--error);
            font-size: 0.78rem;
            font-weight: 600;
            margin-top: 5px;
            display: none;
            align-items: center;
            gap: 5px;
            line-height: 1.35;
        }

        .error-msg.visible {
            display: flex;
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            background-color: #FFF8F8 !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid, .form-select.is-valid, .form-textarea.is-valid {
            border-color: var(--success);
        }

        /* Map Picker Button & Preview */
        .btn-map-picker {
            background: #F1F5F9;
            color: var(--text-plum);
            border: 1px solid #CBD5E1;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .btn-map-picker:hover {
            background: var(--pink-soft-bg);
            border-color: var(--pink-border);
            color: var(--brand-pink);
        }

        .btn-map-picker i {
            color: var(--brand-pink);
        }

        .map-location-preview {
            display: none;
            align-items: center;
            gap: 8px;
            margin-top: 7px;
            padding: 7px 12px;
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            border-radius: 8px;
            font-size: 0.82rem;
            color: var(--text-gray);
        }

        /* Leaflet Map Modal Dialog */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            padding: 16px;
        }

        .map-modal-card {
            background: #FFFFFF;
            border-radius: 20px;
            max-width: 720px;
            width: 100%;
            max-height: 94vh;
            display: flex;
            flex-direction: column;
            padding: 22px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }

        .modal-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .modal-header .icon-wrap {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--pink-soft-bg);
            color: var(--brand-pink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .modal-header h3 {
            font-family: var(--font-heading);
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-plum);
            margin: 0 0 2px 0;
        }

        .btn-close-modal {
            background: transparent;
            border: none;
            font-size: 1.5rem;
            line-height: 1;
            color: var(--text-gray);
            cursor: pointer;
            padding: 4px;
            border-radius: 8px;
            transition: color 0.15s, background 0.15s;
            margin-left: auto;
        }

        .btn-close-modal:hover {
            color: var(--text-plum);
            background: #F1F5F9;
        }

        .map-search-row {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            position: relative;
        }

        .map-canvas-wrap {
            position: relative;
            width: 100%;
            height: 330px;
            border-radius: 12px;
            overflow: hidden;
            border: 1.5px solid var(--border-light);
            background: #E2E8F0;
        }

        .map-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #FFFFFF;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            max-height: 180px;
            overflow-y: auto;
            z-index: 1050;
            display: none;
            margin-top: 4px;
        }

        .map-suggestion-item {
            padding: 9px 12px;
            cursor: pointer;
            font-size: 0.85rem;
            border-bottom: 1px solid #F1F5F9;
            color: var(--text-plum);
            transition: background 0.15s;
        }

        .map-suggestion-item:last-child { border-bottom: none; }
        .map-suggestion-item:hover { background: var(--pink-soft-bg); color: var(--brand-pink); }

        .map-selected-bar {
            background: #F8FAFC;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 10px 14px;
            margin-top: 12px;
            font-size: 0.86rem;
            line-height: 1.4;
        }

        .map-selected-label {
            font-weight: 700;
            color: var(--text-plum);
            display: block;
            margin-bottom: 2px;
            font-size: 0.74rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .map-selected-value {
            color: #334155;
            font-weight: 600;
            word-break: break-word;
        }

        .btn-modal-cancel {
            padding: 10px 18px;
            border-radius: 10px;
            border: 1px solid var(--border-light);
            background: #F1F5F9;
            color: var(--text-plum);
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
        }

        .btn-modal-confirm {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            background: var(--brand-pink);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-modal-confirm:disabled { opacity: 0.5; cursor: not-allowed; }

        .btn-secondary {
            padding: 9px 14px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            border: 1px solid var(--border-light);
            background: #F1F5F9;
            color: var(--text-plum);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-secondary:hover { background: #E2E8F0; }

        /* Bottom Sticky/Floating Save Action Bar */
        .bottom-actions {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-bottom-save {
            padding: 14px 28px;
            background: var(--brand-pink);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 0.98rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-bottom-save:hover {
            background: var(--brand-pink-hover);
            transform: translateY(-1px);
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Breakpoints */
        @media (max-width: 768px) {
            .app-header { padding: 12px 16px; }
            .main-container { margin: 16px auto 36px; padding: 0 14px; }
            .form-row, .form-row.form-row-3 { grid-template-columns: 1fr; gap: 12px; }
            .section-card { padding: 16px; }
            .map-modal-card { max-height: 96vh; padding: 16px; }
            .map-canvas-wrap { height: 260px; }
            .bottom-actions { justify-content: stretch; }
            .btn-bottom-save { width: 100%; justify-content: center; }
        }

        @media (max-width: 480px) {
            .header-brand span { display: none; }
            .btn-skip { padding: 6px 10px; font-size: 0.8rem; }
            .btn-header-save { padding: 6px 12px; font-size: 0.8rem; }
        }
    </style>
</head>
<body>

    <!-- Sticky Top Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="header-brand">
            <i class="bi bi-rocket-takeoff-fill"></i>
            <span>Fight D Fear</span>
            <span style="font-size:0.8rem; font-weight:600; color:var(--text-gray); font-family:var(--font-main);">/ Entrepreneur Profile</span>
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="btn-skip">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
            <button type="button" id="btnHeaderSave" class="btn-header-save">
                <i class="bi bi-floppy2-fill"></i> Save Details
            </button>
        </div>
    </header>

    <main class="main-container">

        <!-- Server Success / Error Feedback -->
        <c:if test="${not empty message}">
            <div class="alert-box alert-success">
                <i class="bi bi-check-circle-fill"></i>
                <div><c:out value="${message}"/></div>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-box alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div><c:out value="${error}"/></div>
            </div>
        </c:if>

        <!-- Unlocked & Approved Status Banner -->
        <c:if test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
            <div style="background: linear-gradient(135deg, #059669 0%, #10B981 100%); border-radius: 16px; padding: 20px 24px; color: white; margin-bottom: 22px; box-shadow: 0 6px 18px rgba(16, 185, 129, 0.25);">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <span style="background: rgba(255,255,255,0.22); color: white; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 50px; text-transform: uppercase; letter-spacing: 0.5px;">Account Verified &amp; Approved</span>
                        <h3 style="font-family:var(--font-heading); font-size: 1.3rem; font-weight: 800; margin: 8px 0 4px; color: white;">
                            <i class="bi bi-patch-check-fill me-1"></i> Your Entrepreneur Hub is Fully Active!
                        </h3>
                        <p style="margin: 0; font-size: 0.88rem; color: rgba(255,255,255,0.92);">Admin has verified your venture and business identity. You have complete access to investor pitches, booking orders, and live funding requests.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" style="background: #FFFFFF; color: #047857; font-weight: 800; font-size: 0.92rem; padding: 11px 22px; border-radius: 50px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.12); transition: transform 0.2s;">
                        <i class="bi bi-speedometer2"></i> Open Dashboard
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Dynamic Profile Completion Progress Card -->
        <div class="profile-progress-card">
            <div style="display:flex; align-items:center; gap:18px; margin-bottom:14px; flex-wrap:wrap;">
                <div style="width:58px; height:58px; border-radius:50%; overflow:hidden; background:var(--pink-soft-bg); border:2.5px solid var(--pink-border); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                    <c:choose>
                        <c:when test="${not empty entrepreneur.profilePhoto}">
                            <img id="topBarAvatar" src="${fn:startsWith(entrepreneur.profilePhoto, 'http') ? entrepreneur.profilePhoto : pageContext.request.contextPath.concat(entrepreneur.profilePhoto)}" alt="Avatar" style="width:100%; height:100%; object-fit:cover;">
                            <span id="topBarAvatarFallback" style="font-family:var(--font-heading); font-size:1.5rem; color:var(--brand-pink); font-weight:800; display:none;">
                                ${not empty entrepreneur.fullName ? fn:substring(entrepreneur.fullName, 0, 1).toUpperCase() : 'E'}
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span id="topBarAvatarFallback" style="font-family:var(--font-heading); font-size:1.5rem; color:var(--brand-pink); font-weight:800;">
                                ${not empty entrepreneur.fullName ? fn:substring(entrepreneur.fullName, 0, 1).toUpperCase() : 'E'}
                            </span>
                            <img id="topBarAvatar" src="" alt="Avatar" style="width:100%; height:100%; object-fit:cover; display:none;">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="flex:1; min-width:240px;">
                    <div class="progress-header">
                        <div class="progress-title">
                            Profile Completion: <span id="pctText" class="progress-pct">${not empty profileCompletionPct ? profileCompletionPct : (not empty entrepreneur.profileCompletionPct ? entrepreneur.profileCompletionPct : 0)}%</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
                                <span class="status-badge badge-approved"><i class="bi bi-check-circle-fill"></i> Approved</span>
                            </c:when>
                            <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                                <span class="status-badge badge-changes"><i class="bi bi-exclamation-circle-fill"></i> Changes Requested</span>
                            </c:when>
                            <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                <span class="status-badge badge-pending"><i class="bi bi-clock-history"></i> Under Review</span>
                            </c:when>
                            <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'REJECTED'}">
                                <span class="status-badge badge-rejected"><i class="bi bi-x-circle-fill"></i> Rejected</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-registered"><i class="bi bi-person-badge"></i> Registered</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" style="width: ${not empty profileCompletionPct ? profileCompletionPct : (not empty entrepreneur.profileCompletionPct ? entrepreneur.profileCompletionPct : 0)}%;"></div>
                    </div>
                </div>
            </div>
            <p class="progress-guidance" id="guidanceText">
                Complete all 16 required milestones below to reach <strong>100% profile completion</strong>. Once all required information is in place, you can submit your profile for admin verification.
            </p>
            <div id="missingList" class="missing-list"></div>
        </div>

        <!-- Admin Feedback Banner -->
        <c:if test="${not empty entrepreneur and not empty entrepreneur.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Verification Note</h4>
                    <p><c:out value="${entrepreneur.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Submit for Verification Bar -->
        <div class="submit-bar">
            <c:choose>
                <c:when test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="btn-submit-verification" style="background:#059669;">
                        <i class="bi bi-patch-check-fill"></i> Profile Verified &amp; Approved — Open Entrepreneur Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <form id="verificationSubmitForm" action="${pageContext.request.contextPath}/entrepreneur/submit-verification${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post">
                        <c:if test="${not empty _csrf}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </c:if>
                        <button type="submit" id="btnSubmitVerification" class="btn-submit-verification"
                                <c:if test="${(empty profileCompletionPct or profileCompletionPct lt 100) and (empty entrepreneur.profileCompletionPct or entrepreneur.profileCompletionPct lt 100) or (entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL')}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Submitted — Pending Admin Review
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-send-check-fill"></i> Submit for Admin Verification
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Section Forms Container -->
        <form id="profileForm" action="${pageContext.request.contextPath}/entrepreneur/profile-completion${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" novalidate>
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>

            <!-- Section 1: Business Identity & Founder Details -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">1</span>
                    <span>Business Identity &amp; Founder Details</span>
                </div>

                <!-- Founder Profile Photo Card -->
                <div style="display:flex; align-items:center; gap:20px; background:#F8FAFC; border:1px solid var(--border-light); border-radius:16px; padding:18px 20px; margin-bottom:22px; flex-wrap:wrap;">
                    <div style="width:84px; height:84px; border-radius:50%; overflow:hidden; background:var(--pink-soft-bg); border:3px solid var(--pink-border); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <c:choose>
                            <c:when test="${not empty entrepreneur.profilePhoto}">
                                <img id="entPhotoPreview" src="${fn:startsWith(entrepreneur.profilePhoto, 'http') ? entrepreneur.profilePhoto : pageContext.request.contextPath.concat(entrepreneur.profilePhoto)}" alt="Profile Photo" style="width:100%; height:100%; object-fit:cover;">
                                <div id="entPhotoFallback" style="display:none; font-family:var(--font-heading); font-size:2rem; color:var(--brand-pink); font-weight:800;">
                                    ${not empty entrepreneur.fullName ? fn:substring(entrepreneur.fullName, 0, 1).toUpperCase() : 'E'}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div id="entPhotoFallback" style="font-family:var(--font-heading); font-size:2rem; color:var(--brand-pink); font-weight:800;">
                                    ${not empty entrepreneur.fullName ? fn:substring(entrepreneur.fullName, 0, 1).toUpperCase() : 'E'}
                                </div>
                                <img id="entPhotoPreview" src="" alt="Profile Photo" style="width:100%; height:100%; object-fit:cover; display:none;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="flex:1; min-width:240px;">
                        <label style="font-size:0.95rem;">1.0 Founder Headshot / Brand Logo <span class="req">*</span></label>
                        <p class="hint" style="margin:2px 0 10px;">Upload a clear founder portrait or venture logo (JPG, PNG, WEBP up to 5 MB). Builds trust with investors and clients.</p>
                        <div style="display:flex; align-items:center; gap:12px; flex-wrap:wrap;">
                            <label for="profilePhotoFileInput" class="btn-skip" style="background:var(--brand-pink); color:#FFFFFF; border:none; padding:8px 16px; cursor:pointer;">
                                <i class="bi bi-camera-fill"></i> Choose Photo
                            </label>
                            <input type="file" id="profilePhotoFileInput" name="profilePhotoFile" accept="image/jpeg,image/png,image/webp" style="display:none;" data-has-file="${not empty entrepreneur.profilePhoto ? 'true' : 'false'}">
                            <span id="entPhotoName" style="font-size:0.84rem; color:var(--text-gray); word-break:break-all;">
                                ${not empty entrepreneur.profilePhoto ? '<i class=\"bi bi-check-circle-fill text-success\"></i> Photo on file' : 'No photo uploaded yet'}
                            </span>
                        </div>
                        <div class="error-msg" id="err-profilePhoto">Please upload a valid profile photo or logo (JPG/PNG under 5MB).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">1.1 Entrepreneur Full Name <span class="req">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-input" value="<c:out value='${entrepreneur.fullName}'/>" placeholder="e.g. Ananya Sharma" required>
                        <div class="error-msg" id="err-fullName">Please enter your full name (at least 2 letters).</div>
                    </div>
                    <div class="form-group">
                        <label for="businessName">1.2 Business / Venture Name <span class="req">*</span></label>
                        <input type="text" id="businessName" name="businessName" class="form-input" value="${entrepreneur.businessName eq 'Pending Profile Completion' ? '' : entrepreneur.businessName}" placeholder="e.g. Lotus Crafts &amp; Handloom" required>
                        <div class="error-msg" id="err-businessName">Please enter a valid business or venture name (at least 2 characters).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="businessCategory">1.3 Business Category <span class="req">*</span></label>
                        <select id="businessCategory" name="businessCategory" class="form-select" required>
                            <option value="">-- Select Primary Category --</option>
                            <option value="Tea Shop" <c:if test="${entrepreneur.businessCategory == 'Tea Shop'}">selected</c:if>>Tea / Coffee Shop &amp; Bakery</option>
                            <option value="Food & Catering" <c:if test="${entrepreneur.businessCategory == 'Food & Catering'}">selected</c:if>>Food &amp; Catering Services</option>
                            <option value="Apparel & Fashion" <c:if test="${entrepreneur.businessCategory == 'Apparel & Fashion'}">selected</c:if>>Apparel, Textiles &amp; Fashion</option>
                            <option value="Beauty & Wellness" <c:if test="${entrepreneur.businessCategory == 'Beauty & Wellness'}">selected</c:if>>Beauty, Salon &amp; Wellness</option>
                            <option value="Handicrafts & Arts" <c:if test="${entrepreneur.businessCategory == 'Handicrafts & Arts'}">selected</c:if>>Handicrafts, Pottery &amp; Arts</option>
                            <option value="Education & Tutoring" <c:if test="${entrepreneur.businessCategory == 'Education & Tutoring'}">selected</c:if>>Education, Daycare &amp; Tutoring</option>
                            <option value="Tech & Digital Services" <c:if test="${entrepreneur.businessCategory == 'Tech & Digital Services'}">selected</c:if>>Tech, Digital &amp; IT Services</option>
                            <option value="Retail & E-commerce" <c:if test="${entrepreneur.businessCategory == 'Retail & E-commerce'}">selected</c:if>>Retail &amp; E-commerce</option>
                            <option value="Agriculture & Dairy" <c:if test="${entrepreneur.businessCategory == 'Agriculture & Dairy'}">selected</c:if>>Agriculture, Farming &amp; Dairy</option>
                            <option value="Other" <c:if test="${entrepreneur.businessCategory == 'Other'}">selected</c:if>>Other Special Venture</option>
                        </select>
                        <div class="error-msg" id="err-businessCategory">Please select a business category.</div>
                    </div>
                    <div class="form-group">
                        <label for="designation">1.4 Designation / Role in Venture</label>
                        <input type="text" id="designation" name="designation" class="form-input" value="<c:out value='${entrepreneur.designation}'/>" placeholder="e.g. Founder, Managing Partner, CEO">
                        <span class="hint">Optional title shown on investor proposals.</span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">1.5 Account Email <span class="req">*</span></label>
                        <input type="email" id="email" name="email" class="form-input" value="<c:out value='${entrepreneur.email}'/>" placeholder="founder@example.com" required>
                        <div class="error-msg" id="err-email">Please enter a valid email address (e.g. name@domain.com).</div>
                        <span class="hint">Primary contact email used for investor queries.</span>
                    </div>
                    <div class="form-group">
                        <label for="phone">1.6 Mobile Phone Number <span class="req">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-input" value="<c:out value='${entrepreneur.phone}'/>" maxlength="10" placeholder="10-digit mobile number" required pattern="[6-9][0-9]{9}">
                        <div class="error-msg" id="err-phone">Please enter a valid 10-digit Indian mobile number (e.g. 9876543210).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="whatsappNumber">1.7 WhatsApp Business Number</label>
                        <input type="tel" id="whatsappNumber" name="whatsappNumber" class="form-input" value="<c:out value='${entrepreneur.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                        <div class="error-msg" id="err-whatsappNumber">WhatsApp number must be a valid 10-digit number.</div>
                        <span class="hint">Optional number for direct investor WhatsApp communication.</span>
                    </div>
                    <div class="form-group">
                        <label for="dob">1.8 Date of Birth</label>
                        <input type="date" id="dob" name="dob" class="form-input" value="<c:out value='${entrepreneur.dob}'/>">
                        <span class="hint">Used for identity and demographic validation.</span>
                    </div>
                </div>
            </div>

            <!-- Section 2: Location & Operations (with Dependent Dropdowns & Map Selection) -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">2</span>
                    <span>Location &amp; Operations</span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="countrySelect">2.1 Country <span class="req">*</span></label>
                        <select id="countrySelect" class="form-select">
                            <option value="India" selected>India</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="stateSelect">2.2 State / Union Territory <span class="req">*</span></label>
                        <select id="stateSelect" name="state" class="form-select" required>
                            <option value="">-- Select State / UT --</option>
                        </select>
                        <div class="error-msg" id="err-state">Please select your state or union territory.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="citySelect">2.3 City / District <span class="req">*</span></label>
                        <select id="citySelect" class="form-select" required>
                            <option value="">-- Select State First --</option>
                        </select>
                        <div id="customCityGroup" style="display:none; margin-top:8px;">
                            <input type="text" id="customCityInput" class="form-input" placeholder="Enter City/District name">
                        </div>
                        <input type="hidden" id="cityHidden" name="city" value="<c:out value='${entrepreneur.city}'/>">
                        <div class="error-msg" id="err-city">Please select or type your city / district.</div>
                    </div>
                    <div class="form-group">
                        <label for="pincode">2.4 Postal Pincode <span class="req">*</span></label>
                        <input type="text" id="pincode" name="pincode" class="form-input" value="<c:out value='${entrepreneur.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required pattern="[1-9][0-9]{5}">
                        <div class="error-msg" id="err-pincode">Enter a valid 6-digit postal pincode.</div>
                    </div>
                </div>

                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; flex-wrap:wrap; gap:8px;">
                        <label for="businessLocation" style="margin-bottom:0;">2.5 Street Address / Shop / Office / Landmark <span class="req">*</span></label>
                        <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                            <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                        </button>
                    </div>
                    <input type="text" id="businessLocation" name="businessLocation" class="form-input" value="${entrepreneur.businessLocation eq 'Pending' ? '' : entrepreneur.businessLocation}" placeholder="Shop/Office No, Building name, Street, Landmark" required>
                    <div class="error-msg" id="err-businessLocation">Please enter your business street address or landmark (min 3 characters).</div>
                    
                    <!-- Map Pin Coordinates Status Bar -->
                    <div id="mapLocationPreview" class="map-location-preview" style="display:${(not empty entrepreneur.latitude and not empty entrepreneur.longitude) ? 'flex' : 'none'};">
                        <i class="bi bi-pin-map-fill" style="color:var(--brand-pink); font-size:1.1rem;"></i>
                        <span>Location Coordinates: <strong id="pinnedCoordsText">${entrepreneur.latitude}, ${entrepreneur.longitude}</strong></span>
                        <button type="button" id="btnClearMapPin" style="border:none; background:transparent; color:var(--error); font-size:0.75rem; font-weight:700; cursor:pointer; margin-left:auto;">
                            <i class="bi bi-x-circle"></i> Clear Pin
                        </button>
                    </div>
                    <input type="hidden" id="latitude" name="latitude" value="<c:out value='${entrepreneur.latitude}'/>">
                    <input type="hidden" id="longitude" name="longitude" value="<c:out value='${entrepreneur.longitude}'/>">
                </div>
            </div>

            <!-- Section 3: Financial & Investment Details -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">3</span>
                    <span>Financial &amp; Investment Details</span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="investmentNeeded">3.1 Funding / Investment Required (₹) <span class="req">*</span></label>
                        <input type="number" step="1000" id="investmentNeeded" name="investmentNeeded" class="form-input" value="${entrepreneur.investmentNeeded == 0.0 ? '' : entrepreneur.investmentNeeded}" placeholder="e.g. 250000" min="1000" required>
                        <div class="error-msg" id="err-investmentNeeded">Please specify the funding amount required (minimum ₹1,000).</div>
                        <span class="hint">Total capital you are seeking from micro-investors or loan partners.</span>
                    </div>
                    <div class="form-group">
                        <label for="expectedMonthlyIncome">3.2 Expected Monthly Revenue (₹) <span class="req">*</span></label>
                        <input type="number" step="1000" id="expectedMonthlyIncome" name="expectedMonthlyIncome" class="form-input" value="${entrepreneur.expectedMonthlyIncome == 0.0 ? '' : entrepreneur.expectedMonthlyIncome}" placeholder="e.g. 50000" min="100" required>
                        <div class="error-msg" id="err-expectedMonthlyIncome">Please enter expected monthly revenue (minimum ₹100).</div>
                        <span class="hint">Projected average monthly gross or net revenue.</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="businessExperience">3.3 Business Experience (Years) <span class="req">*</span></label>
                    <input type="number" id="businessExperience" name="businessExperience" class="form-input" value="${entrepreneur.businessExperience == 0 ? '' : entrepreneur.businessExperience}" placeholder="e.g. 2 (enter 0 if new venture)" min="0" max="60" required>
                    <div class="error-msg" id="err-businessExperience">Enter valid experience in years (0 to 60).</div>
                    <span class="hint">Enter 0 if this is your first startup or new venture.</span>
                </div>
            </div>

            <!-- Section 4: Identity & Legal Verification -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">4</span>
                    <span>Identity &amp; Legal Verification</span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="aadhaarNumber">4.1 Aadhaar Number <span class="req">*</span></label>
                        <input type="text" id="aadhaarNumber" name="aadhaarNumber" class="form-input" value="<c:out value='${entrepreneur.aadhaarNumber}'/>" placeholder="12-digit Aadhaar number" maxlength="12" required pattern="[0-9]{12}">
                        <div class="error-msg" id="err-aadhaarNumber">Aadhaar must be exactly 12 numeric digits.</div>
                        <span class="hint">Used strictly for government identity verification and safety audit.</span>
                    </div>
                    <div class="form-group">
                        <label for="panNumber">4.2 PAN Number</label>
                        <input type="text" id="panNumber" name="panNumber" class="form-input" placeholder="e.g. ABCDE1234F" maxlength="10" style="text-transform:uppercase;">
                        <div class="error-msg" id="err-panNumber">Enter a valid 10-character PAN (e.g. ABCDE1234F).</div>
                        <span class="hint">Optional PAN card number for financial compliance.</span>
                    </div>
                </div>
            </div>

            <!-- Section 5: Business Overview & Pitch Deck -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">5</span>
                    <span>Business Overview &amp; Pitch Deck</span>
                </div>

                <div class="form-group">
                    <label for="businessDescription">5.1 Business Description &amp; Vision <span class="req">*</span></label>
                    <textarea id="businessDescription" name="businessDescription" class="form-textarea" rows="4" placeholder="Describe your product/service, your target customers, competitive edge, and how funds will be utilized..." required>${entrepreneur.businessDescription eq 'Profile pending completion by entrepreneur.' ? '' : entrepreneur.businessDescription}</textarea>
                    <div class="error-msg" id="err-businessDescription">Please provide a descriptive business overview (at least 10 characters).</div>
                    <span class="hint">Highlight what makes your business unique and how an investor will benefit.</span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="pitchDeckFile">5.2 Pitch Deck Document (PDF / Presentation)</label>
                        <input type="file" id="pitchDeckFile" name="pitchDeckFile" class="form-input" accept=".pdf,image/*" data-has-file="${not empty entrepreneur.documentsPath ? 'true' : 'false'}">
                        <div class="error-msg" id="err-pitchDeckFile">Please upload a valid document (PDF, PNG, JPG under 15MB).</div>
                        <c:if test="${not empty entrepreneur.documentsPath}">
                            <div style="color:var(--success); font-size:0.8rem; font-weight:600; margin-top:4px;">
                                <i class="bi bi-check-circle-fill"></i> Pitch deck document already on file
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="businessPhotosFiles">5.3 Product / Store Gallery Photos</label>
                        <input type="file" id="businessPhotosFiles" name="businessPhotosFiles" class="form-input" accept="image/*" multiple data-has-file="${not empty entrepreneur.photosPath ? 'true' : 'false'}">
                        <div class="error-msg" id="err-businessPhotosFiles">Allowed formats: JPG, PNG, WEBP (Max 5MB each).</div>
                        <c:if test="${not empty entrepreneur.photosPath}">
                            <div style="color:var(--success); font-size:0.8rem; font-weight:600; margin-top:4px;">
                                <i class="bi bi-check-circle-fill"></i> Gallery photos already uploaded
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Section 6: Payout & Bank Details -->
            <div class="section-card">
                <div class="section-header">
                    <span class="num">6</span>
                    <span>Payout &amp; Disbursement Details</span>
                </div>
                <p class="hint" style="margin-bottom:16px;">
                    Provide either an instant <strong>UPI ID</strong> or complete <strong>Bank Account details</strong> to receive investor disbursements and earnings.
                </p>

                <div class="form-group">
                    <label for="upiId">6.1 UPI ID (For Direct Instant Payouts)</label>
                    <input type="text" id="upiId" name="upiId" class="form-input" value="<c:out value='${entrepreneur.upiId}'/>" placeholder="e.g. foundername@okaxis, business@upi">
                    <div class="error-msg" id="err-upiId">Enter a valid UPI ID (e.g. name@bank).</div>
                    <span class="hint">Instant settlement UPI handle (optional if bank account is filled).</span>
                </div>

                <div style="text-align:center; margin:16px 0; color:var(--text-gray); font-size:0.82rem; font-weight:700; position:relative;">
                    <span style="background:var(--bg-card); padding:0 12px; position:relative; z-index:1;">— OR BANK ACCOUNT TRANSFER —</span>
                    <div style="position:absolute; top:50%; left:0; right:0; height:1px; background:var(--border-light); z-index:0;"></div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankAccountHolder">6.2 Account Holder Name</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank records">
                    </div>
                    <div class="form-group">
                        <label for="bankName">6.3 Bank Name</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" value="<c:out value='${entrepreneur.bankName}'/>" placeholder="e.g. State Bank of India, HDFC Bank">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankAccountNumber">6.4 Account Number</label>
                        <input type="password" id="bankAccountNumber" name="bankAccountNumber" class="form-input" value="<c:out value='${entrepreneur.accountNumber}'/>" placeholder="9 to 18 digits" maxlength="18" autocomplete="new-password">
                        <div class="error-msg" id="err-bankAccountNumber">Account number must be 9 to 18 digits.</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmAccountNumber">6.5 Confirm Account Number</label>
                        <input type="text" id="confirmAccountNumber" name="confirmAccountNumber" class="form-input" placeholder="Re-enter bank account number" maxlength="18" autocomplete="off">
                        <div class="error-msg" id="err-confirmAccountNumber">Account numbers do not match.</div>
                        <div id="accMatchOk" style="display:none; color:var(--success); font-size:0.75rem; font-weight:700; margin-top:4px;">
                            <i class="bi bi-check-circle-fill"></i> Account numbers match
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankIfsc">6.6 IFSC Code</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" value="<c:out value='${entrepreneur.ifscCode}'/>" placeholder="e.g. SBIN0001234" maxlength="11" style="text-transform:uppercase;">
                        <div class="error-msg" id="err-bankIfsc">IFSC code must be 11 characters (e.g. ABCD0123456).</div>
                    </div>
                    <div class="form-group">
                        <label for="bankBranch">6.7 Branch Name</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Connaught Place Branch">
                    </div>
                </div>

                <div class="error-msg" id="err-payout">Please provide either a valid UPI ID or complete bank details (Account Number &amp; IFSC).</div>
                <input type="hidden" id="bankDetails" name="bankDetails" value="<c:out value='${entrepreneur.bankDetails}'/>">
            </div>

            <!-- Bottom Action Button -->
            <div class="bottom-actions">
                <button type="submit" id="btnBottomSave" class="btn-bottom-save">
                    <i class="bi bi-floppy2-fill"></i> Save Profile Details
                </button>
            </div>
        </form>

    </main>

    <!-- Leaflet Location Picker Modal -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle">
        <div class="map-modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-geo-alt-fill"></i></div>
                <div style="flex:1;">
                    <h3 id="mapModalTitle">Select Venture Location</h3>
                    <p style="font-size:0.82rem; color:var(--text-gray); margin:0;">Search locality, market, or click on the map to pin your business address</p>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close location picker">&times;</button>
            </div>

            <div class="map-search-row">
                <div style="position:relative; flex:1;">
                    <input type="text" id="mapSearchInput" class="form-input" placeholder="Search locality, street, market, city, or landmark..." autocomplete="off">
                    <div class="map-suggestions" id="mapSuggestions"></div>
                </div>
                <button type="button" class="btn-secondary" id="btnSearchMap" title="Search place"><i class="bi bi-search"></i> Search</button>
                <button type="button" class="btn-secondary" id="btnLocateMe" title="Use current GPS location"><i class="bi bi-crosshair"></i> GPS</button>
            </div>

            <div id="mapPickerAlert" class="alert-box alert-error" style="display:none; padding:8px 12px; margin-bottom:10px; font-size:0.82rem;"></div>

            <div class="map-canvas-wrap">
                <div id="mapContainer" style="width:100%; height:100%;"></div>
            </div>

            <div class="map-selected-bar">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:3px;">
                    <span class="map-selected-label">Selected Venture Location</span>
                    <span style="font-size:0.72rem; padding:2px 7px; border-radius:6px; background:#E2E8F0; color:#475569; font-weight:700;">OpenStreetMap</span>
                </div>
                <div class="map-selected-value" id="mapSelectedAddress">Click on the map or search to choose your location</div>
            </div>

            <div style="margin-top:14px; display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn-modal-cancel" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Use This Location
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS Library (Whitelisted by CSP) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <!-- Comprehensive Validation, Cascading Location, Leaflet Map & Accurate Profile Completion Engine -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const ctx = "${pageContext.request.contextPath}";
            const form = document.getElementById("profileForm");
            if (!form) return;

            // Saved location values from database
            const savedState = "${not empty entrepreneur.state ? entrepreneur.state : ''}";
            const savedCity = "${not empty entrepreneur.city ? entrepreneur.city : ''}";
            const savedLat = "${not empty entrepreneur.latitude ? entrepreneur.latitude : ''}";
            const savedLng = "${not empty entrepreneur.longitude ? entrepreneur.longitude : ''}";

            // Helper to get trimmed value
            function val(id) {
                const el = document.getElementById(id);
                return el ? el.value.trim() : "";
            }

            // Set validation state on field
            function setFieldState(id, isValid, errorMsg) {
                const input = document.getElementById(id);
                const errDiv = document.getElementById("err-" + id);
                if (input) {
                    if (isValid) {
                        input.classList.remove("is-invalid");
                        input.classList.add("is-valid");
                    } else {
                        input.classList.remove("is-valid");
                        input.classList.add("is-invalid");
                    }
                }
                if (errDiv) {
                    if (isValid) {
                        errDiv.classList.remove("visible");
                        errDiv.style.display = "none";
                    } else {
                        if (errorMsg) errDiv.textContent = errorMsg;
                        errDiv.classList.add("visible");
                        errDiv.style.display = "flex";
                    }
                }
            }

            // -------------------------------------------------------------
            // 1. Cascading State, District, and City Dropdowns
            // -------------------------------------------------------------
            const stateSelect = document.getElementById("stateSelect");
            const citySelect = document.getElementById("citySelect");
            const customCityGroup = document.getElementById("customCityGroup");
            const customCityInput = document.getElementById("customCityInput");
            const cityHidden = document.getElementById("cityHidden");

            // Curated offline-safe fallback state & city mapping
            const ALL_INDIAN_STATES = [
                "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
                "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
                "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
                "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab",
                "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
                "Uttar Pradesh", "Uttarakhand", "West Bengal",
                "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu",
                "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
            ];

            async function initStates() {
                let states = ALL_INDIAN_STATES;
                try {
                    const res = await fetch(ctx + "/api/locations/states");
                    if (res.ok) {
                        const data = await res.json();
                        if (data && data.success && Array.isArray(data.states) && data.states.length > 0) {
                            states = data.states;
                        }
                    }
                } catch (e) {
                    // Fallback to ALL_INDIAN_STATES
                }

                stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';
                states.forEach(st => {
                    const opt = document.createElement("option");
                    opt.value = st;
                    opt.textContent = st;
                    if (savedState && savedState.toLowerCase() === st.toLowerCase()) {
                        opt.selected = true;
                    }
                    stateSelect.appendChild(opt);
                });

                if (stateSelect.value) {
                    loadCitiesForState(stateSelect.value, savedCity);
                }
            }

            async function loadCitiesForState(st, preselectCity) {
                citySelect.innerHTML = '<option value="">-- Loading Cities... --</option>';
                citySelect.disabled = true;

                let cities = [];
                try {
                    const res = await fetch(ctx + "/api/locations/cities?state=" + encodeURIComponent(st));
                    if (res.ok) {
                        const data = await res.json();
                        if (data && data.success && Array.isArray(data.cities)) {
                            cities = data.cities;
                        }
                    }
                } catch (e) {
                    console.warn("Cities fetch failed, will provide custom city input", e);
                }

                citySelect.innerHTML = '<option value="">-- Select City / District --</option>';
                let matched = false;

                cities.forEach(c => {
                    const opt = document.createElement("option");
                    opt.value = c;
                    opt.textContent = c;
                    if (preselectCity && c.toLowerCase() === preselectCity.toLowerCase()) {
                        opt.selected = true;
                        matched = true;
                    }
                    citySelect.appendChild(opt);
                });

                // Add "Other" option for custom input
                const otherOpt = document.createElement("option");
                otherOpt.value = "Other";
                otherOpt.textContent = "+ Other (Type City)";
                if (preselectCity && !matched) {
                    otherOpt.selected = true;
                }
                citySelect.appendChild(otherOpt);
                citySelect.disabled = false;

                if (citySelect.value === "Other") {
                    customCityGroup.style.display = "block";
                    if (customCityInput && preselectCity) {
                        customCityInput.value = preselectCity;
                        cityHidden.value = preselectCity;
                    }
                } else {
                    customCityGroup.style.display = "none";
                    if (matched) cityHidden.value = preselectCity;
                }
                recalculateCompletion();
            }

            if (stateSelect) {
                stateSelect.addEventListener("change", function() {
                    const chosen = this.value;
                    if (!chosen) {
                        citySelect.innerHTML = '<option value="">-- Select State First --</option>';
                        citySelect.disabled = true;
                        customCityGroup.style.display = "none";
                        cityHidden.value = "";
                        setFieldState("state", false, "Please select your state.");
                    } else {
                        setFieldState("state", true);
                        loadCitiesForState(chosen, "");
                    }
                    recalculateCompletion();
                });
            }

            if (citySelect) {
                citySelect.addEventListener("change", function() {
                    if (this.value === "Other") {
                        customCityGroup.style.display = "block";
                        if (customCityInput) {
                            customCityInput.focus();
                            cityHidden.value = customCityInput.value.trim();
                        }
                    } else {
                        customCityGroup.style.display = "none";
                        cityHidden.value = this.value;
                    }
                    validateCityField();
                    recalculateCompletion();
                });
            }

            if (customCityInput) {
                customCityInput.addEventListener("input", function() {
                    cityHidden.value = this.value.trim();
                    validateCityField();
                    recalculateCompletion();
                });
            }

            function validateCityField() {
                const cityVal = cityHidden.value.trim();
                if (!cityVal || cityVal === "Other") {
                    setFieldState("city", false, "Please select or type your city / district.");
                    return false;
                }
                setFieldState("city", true);
                return true;
            }

            initStates();

            // -------------------------------------------------------------
            // 2. Leaflet Map Interactive Location Selection Modal
            // -------------------------------------------------------------
            let map = null;
            let marker = null;
            let currentPinCoords = null;
            let currentPinAddress = "";

            const mapModal = document.getElementById("mapPickerModal");
            const btnOpenMap = document.getElementById("btnOpenMapPicker");
            const btnCloseMap = document.getElementById("btnCloseMapModal");
            const btnCancelMap = document.getElementById("btnCancelMap");
            const btnConfirmLocation = document.getElementById("btnConfirmLocation");
            const btnSearchMap = document.getElementById("btnSearchMap");
            const btnLocateMe = document.getElementById("btnLocateMe");
            const mapSearchInput = document.getElementById("mapSearchInput");
            const mapSuggestions = document.getElementById("mapSuggestions");
            const mapSelectedAddress = document.getElementById("mapSelectedAddress");
            const mapPickerAlert = document.getElementById("mapPickerAlert");
            const btnClearMapPin = document.getElementById("btnClearMapPin");
            const mapLocationPreview = document.getElementById("mapLocationPreview");
            const pinnedCoordsText = document.getElementById("pinnedCoordsText");
            const latInput = document.getElementById("latitude");
            const lngInput = document.getElementById("longitude");

            function showMapAlert(msg) {
                if (!mapPickerAlert) return;
                if (msg) {
                    mapPickerAlert.textContent = msg;
                    mapPickerAlert.style.display = "flex";
                } else {
                    mapPickerAlert.style.display = "none";
                    mapPickerAlert.textContent = "";
                }
            }

            function initMapInstance() {
                if (map) {
                    setTimeout(() => map.invalidateSize(), 150);
                    return;
                }

                let initLat = 20.5937; // Center of India default
                let initLng = 78.9629;
                let zoom = 5;

                if (latInput.value && lngInput.value) {
                    initLat = parseFloat(latInput.value);
                    initLng = parseFloat(lngInput.value);
                    zoom = 14;
                }

                map = L.map("mapContainer", {
                    center: [initLat, initLng],
                    zoom: zoom,
                    zoomControl: true
                });

                L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
                    maxZoom: 19,
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
                }).addTo(map);

                marker = L.marker([initLat, initLng], { draggable: true }).addTo(map);

                if (latInput.value && lngInput.value) {
                    reverseGeocode(initLat, initLng);
                }

                map.on("click", function(e) {
                    const lat = e.latlng.lat;
                    const lng = e.latlng.lng;
                    marker.setLatLng([lat, lng]);
                    reverseGeocode(lat, lng);
                });

                marker.on("dragend", function(e) {
                    const pos = marker.getLatLng();
                    reverseGeocode(pos.lat, pos.lng);
                });
            }

            async function reverseGeocode(lat, lng) {
                currentPinCoords = { lat: lat, lng: lng };
                mapSelectedAddress.textContent = "Resolving location address... (" + lat.toFixed(4) + ", " + lng.toFixed(4) + ")";
                showMapAlert("");

                try {
                    const url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + encodeURIComponent(lat) + "&lon=" + encodeURIComponent(lng) + "&addressdetails=1";
                    const res = await fetch(url, { headers: { "Accept-Language": "en" } });
                    if (res.ok) {
                        const data = await res.json();
                        if (data && data.display_name) {
                            currentPinAddress = data.display_name;
                            currentPinCoords.address = data.display_name;
                            currentPinCoords.details = data.address || {};
                            mapSelectedAddress.textContent = data.display_name;
                            btnConfirmLocation.disabled = false;
                            return;
                        }
                    }
                } catch (e) {
                    console.warn("Reverse geocode network error", e);
                }

                currentPinAddress = "Location (" + lat.toFixed(4) + ", " + lng.toFixed(4) + ")";
                mapSelectedAddress.textContent = currentPinAddress;
                btnConfirmLocation.disabled = false;
            }

            async function searchLocation(query) {
                if (!query || query.trim().length < 3) return;
                showMapAlert("");
                try {
                    const url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(query.trim() + ", India") + "&limit=5&addressdetails=1";
                    const res = await fetch(url, { headers: { "Accept-Language": "en" } });
                    if (res.ok) {
                        const results = await res.json();
                        mapSuggestions.innerHTML = "";
                        if (results && results.length > 0) {
                            results.forEach(item => {
                                const div = document.createElement("div");
                                div.className = "map-suggestion-item";
                                div.textContent = item.display_name;
                                div.addEventListener("click", () => {
                                    const lat = parseFloat(item.lat);
                                    const lon = parseFloat(item.lon);
                                    map.setView([lat, lon], 15);
                                    marker.setLatLng([lat, lon]);
                                    mapSuggestions.style.display = "none";
                                    reverseGeocode(lat, lon);
                                });
                                mapSuggestions.appendChild(div);
                            });
                            mapSuggestions.style.display = "block";
                        } else {
                            showMapAlert("No matching location found. Please try another landmark or street name.");
                        }
                    }
                } catch (e) {
                    showMapAlert("Could not search location. Please check your internet connection.");
                }
            }

            if (btnOpenMap) {
                btnOpenMap.addEventListener("click", () => {
                    mapModal.style.display = "flex";
                    initMapInstance();
                    setTimeout(() => {
                        if (map) map.invalidateSize();
                    }, 200);
                });
            }

            function closeMapModal() {
                mapModal.style.display = "none";
                showMapAlert("");
                mapSuggestions.style.display = "none";
            }

            if (btnCloseMap) btnCloseMap.addEventListener("click", closeMapModal);
            if (btnCancelMap) btnCancelMap.addEventListener("click", closeMapModal);

            if (btnSearchMap) {
                btnSearchMap.addEventListener("click", () => {
                    searchLocation(mapSearchInput.value);
                });
            }

            if (mapSearchInput) {
                mapSearchInput.addEventListener("keydown", (e) => {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        searchLocation(mapSearchInput.value);
                    }
                });
            }

            if (btnLocateMe) {
                btnLocateMe.addEventListener("click", () => {
                    if (!navigator.geolocation) {
                        showMapAlert("Geolocation is not supported by your browser.");
                        return;
                    }
                    btnLocateMe.disabled = true;
                    btnLocateMe.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Locating...';
                    navigator.geolocation.getCurrentPosition(
                        (pos) => {
                            btnLocateMe.disabled = false;
                            btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> GPS';
                            const lat = pos.coords.latitude;
                            const lng = pos.coords.longitude;
                            map.setView([lat, lng], 16);
                            marker.setLatLng([lat, lng]);
                            reverseGeocode(lat, lng);
                        },
                        (err) => {
                            btnLocateMe.disabled = false;
                            btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> GPS';
                            showMapAlert("Location permission was denied or unavailable. Please click on the map to pin your location.");
                        },
                        { timeout: 10000, enableHighAccuracy: true }
                    );
                });
            }

            if (btnConfirmLocation) {
                btnConfirmLocation.addEventListener("click", () => {
                    if (!currentPinCoords) return;

                    latInput.value = currentPinCoords.lat.toFixed(6);
                    lngInput.value = currentPinCoords.lng.toFixed(6);
                    pinnedCoordsText.textContent = latInput.value + ", " + lngInput.value;
                    mapLocationPreview.style.display = "flex";

                    // Populate street address if empty or pending
                    const addrInput = document.getElementById("businessLocation");
                    if (addrInput && currentPinAddress) {
                        addrInput.value = currentPinAddress;
                        setFieldState("businessLocation", true);
                    }

                    // Auto-sync State, City, Pincode if returned in addressdetails
                    if (currentPinCoords.details) {
                        const d = currentPinCoords.details;
                        const detectedState = d.state || "";
                        const detectedCity = d.city || d.town || d.district || d.county || "";
                        const detectedPostcode = d.postcode || "";

                        if (detectedPostcode && /^\d{6}$/.test(detectedPostcode)) {
                            const pinEl = document.getElementById("pincode");
                            if (pinEl) {
                                pinEl.value = detectedPostcode;
                                setFieldState("pincode", true);
                            }
                        }

                        if (detectedState) {
                            for (let i = 0; i < stateSelect.options.length; i++) {
                                if (stateSelect.options[i].text.toLowerCase().includes(detectedState.toLowerCase())) {
                                    stateSelect.selectedIndex = i;
                                    setFieldState("state", true);
                                    loadCitiesForState(stateSelect.value, detectedCity);
                                    break;
                                }
                            }
                        }
                    }

                    closeMapModal();
                    recalculateCompletion();
                });
            }

            if (btnClearMapPin) {
                btnClearMapPin.addEventListener("click", () => {
                    latInput.value = "";
                    lngInput.value = "";
                    mapLocationPreview.style.display = "none";
                    currentPinCoords = null;
                });
            }

            // -------------------------------------------------------------
            // 3. Bank & Payout Field Sync & Real-Time Formatting
            // -------------------------------------------------------------
            const rawBankDetails = document.getElementById("bankDetails")?.value || "";
            const holderInput = document.getElementById("bankAccountHolder");
            const bankInput = document.getElementById("bankName");
            const accInput = document.getElementById("bankAccountNumber");
            const confirmInput = document.getElementById("confirmAccountNumber");
            const ifscInput = document.getElementById("bankIfsc");
            const branchInput = document.getElementById("bankBranch");
            const upiInput = document.getElementById("upiId");

            if (rawBankDetails && rawBankDetails.includes("|")) {
                const parts = rawBankDetails.split("|").map(s => s.trim());
                parts.forEach(p => {
                    const colon = p.indexOf(":");
                    if (colon > -1) {
                        const key = p.substring(0, colon).trim().toLowerCase();
                        const val = p.substring(colon + 1).trim();
                        if (key.includes("holder") && holderInput && !holderInput.value) holderInput.value = val;
                        if (key.includes("bank") && bankInput && !bankInput.value) bankInput.value = val;
                        if ((key.includes("a/c") || key.includes("account")) && accInput && !accInput.value) {
                            accInput.value = val;
                            if (confirmInput) confirmInput.value = val;
                        }
                        if (key.includes("ifsc") && ifscInput && !ifscInput.value) ifscInput.value = val;
                        if (key.includes("branch") && branchInput && !branchInput.value) branchInput.value = val;
                    }
                });
            } else if (accInput && accInput.value && confirmInput && !confirmInput.value) {
                confirmInput.value = accInput.value;
            }

            function syncBankDetails() {
                const holder = holderInput ? holderInput.value.trim() : "";
                const bank = bankInput ? bankInput.value.trim() : "";
                const acc = accInput ? accInput.value.trim() : "";
                const ifsc = ifscInput ? ifscInput.value.trim().toUpperCase() : "";
                const branch = branchInput ? branchInput.value.trim() : "";

                if (ifscInput) ifscInput.value = ifsc;

                if (acc || holder || bank || ifsc) {
                    const serialized = "Account Holder: " + holder + " | Bank: " + bank + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                    const hField = document.getElementById("bankDetails");
                    if (hField) hField.value = serialized;
                }
            }

            function validateBankAndPayout() {
                let isBankOk = true;
                const upi = upiInput ? upiInput.value.trim() : "";
                const acc = accInput ? accInput.value.trim() : "";
                const confirm = confirmInput ? confirmInput.value.trim() : "";
                const ifsc = ifscInput ? ifscInput.value.trim().toUpperCase() : "";

                // UPI check if filled
                let isUpiValid = false;
                if (upi) {
                    if (/^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$/.test(upi)) {
                        setFieldState("upiId", true);
                        isUpiValid = true;
                    } else {
                        setFieldState("upiId", false, "Please enter a valid UPI ID (e.g. name@okaxis).");
                    }
                } else {
                    setFieldState("upiId", true);
                }

                // Bank details validation
                let hasCompleteBank = false;
                if (acc || confirm || ifsc || (bankInput && bankInput.value.trim())) {
                    if (acc && !/^\d{9,18}$/.test(acc)) {
                        setFieldState("bankAccountNumber", false, "Account number must be 9 to 18 digits.");
                        isBankOk = false;
                    } else if (acc) {
                        setFieldState("bankAccountNumber", true);
                    }

                    const accMatchOk = document.getElementById("accMatchOk");
                    if (acc && confirm) {
                        if (acc !== confirm) {
                            setFieldState("confirmAccountNumber", false, "Account numbers do not match.");
                            if (accMatchOk) accMatchOk.style.display = "none";
                            isBankOk = false;
                        } else {
                            setFieldState("confirmAccountNumber", true);
                            if (accMatchOk) accMatchOk.style.display = "block";
                        }
                    } else if (confirm) {
                        setFieldState("confirmAccountNumber", false, "Please enter both account numbers.");
                        if (accMatchOk) accMatchOk.style.display = "none";
                        isBankOk = false;
                    }

                    if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                        setFieldState("bankIfsc", false, "Enter valid 11-char IFSC code (e.g. SBIN0001234).");
                        isBankOk = false;
                    } else if (ifsc) {
                        setFieldState("bankIfsc", true);
                    }

                    if (acc && /^\d{9,18}$/.test(acc) && acc === confirm && ifsc && /^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                        hasCompleteBank = true;
                    }
                }

                const payoutValid = isUpiValid || hasCompleteBank;
                const errPayout = document.getElementById("err-payout");
                if (errPayout) {
                    if (payoutValid || (!upi && !acc && !confirm && !ifsc)) {
                        errPayout.style.display = "none";
                    } else {
                        errPayout.style.display = "flex";
                    }
                }

                syncBankDetails();
                return { payoutValid: payoutValid, isBankOk: isBankOk };
            }

            [holderInput, bankInput, accInput, confirmInput, ifscInput, branchInput, upiInput].forEach(inp => {
                if (inp) {
                    inp.addEventListener("input", () => {
                        validateBankAndPayout();
                        recalculateCompletion();
                    });
                    inp.addEventListener("blur", () => {
                        validateBankAndPayout();
                        recalculateCompletion();
                    });
                }
            });

            // -------------------------------------------------------------
            // 4. File Upload Previews & Size Validations
            // -------------------------------------------------------------
            const photoInput = document.getElementById("profilePhotoFileInput");
            if (photoInput) {
                photoInput.addEventListener("change", function() {
                    const file = this.files && this.files[0];
                    if (file) {
                        if (file.size > 5 * 1024 * 1024) {
                            setFieldState("profilePhoto", false, "Profile photo exceeds 5MB limit. Please choose a smaller image.");
                            this.value = "";
                            return;
                        }
                        const allowed = ["image/jpeg", "image/png", "image/webp"];
                        if (!allowed.includes(file.type)) {
                            setFieldState("profilePhoto", false, "Only JPG, PNG, and WEBP images are allowed.");
                            this.value = "";
                            return;
                        }

                        setFieldState("profilePhoto", true);
                        const nameEl = document.getElementById("entPhotoName");
                        if (nameEl) nameEl.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i> ' + file.name;

                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const previewImg = document.getElementById("entPhotoPreview");
                            const fallback = document.getElementById("entPhotoFallback");
                            const topAvatar = document.getElementById("topBarAvatar");
                            const topFallback = document.getElementById("topBarAvatarFallback");

                            if (previewImg) {
                                previewImg.src = e.target.result;
                                previewImg.style.display = "block";
                            }
                            if (fallback) fallback.style.display = "none";

                            if (topAvatar) {
                                topAvatar.src = e.target.result;
                                topAvatar.style.display = "block";
                            }
                            if (topFallback) topFallback.style.display = "none";
                        };
                        reader.readAsDataURL(file);
                    }
                    recalculateCompletion();
                });
            }

            const pitchDeckInput = document.getElementById("pitchDeckFile");
            if (pitchDeckInput) {
                pitchDeckInput.addEventListener("change", function() {
                    const file = this.files && this.files[0];
                    if (file && file.size > 15 * 1024 * 1024) {
                        setFieldState("pitchDeckFile", false, "Pitch deck file exceeds 15MB limit.");
                        this.value = "";
                    } else {
                        setFieldState("pitchDeckFile", true);
                    }
                });
            }

            // -------------------------------------------------------------
            // 5. Live Field Validators (Input & Blur)
            // -------------------------------------------------------------
            function validateFullName() {
                const v = val("fullName");
                if (!v || v.length < 2) {
                    setFieldState("fullName", false, "Please enter your full name (at least 2 letters).");
                    return false;
                }
                setFieldState("fullName", true);
                return true;
            }

            function validateBusinessName() {
                const v = val("businessName");
                if (!v || v.length < 2 || v.toLowerCase() === "pending profile completion") {
                    setFieldState("businessName", false, "Please enter a valid venture name (min 2 characters).");
                    return false;
                }
                setFieldState("businessName", true);
                return true;
            }

            function validateBusinessCategory() {
                const v = val("businessCategory");
                if (!v) {
                    setFieldState("businessCategory", false, "Please select your business category.");
                    return false;
                }
                setFieldState("businessCategory", true);
                return true;
            }

            function validateEmail() {
                const v = val("email");
                if (!v || !/^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})$/.test(v)) {
                    setFieldState("email", false, "Please enter a valid email address (e.g. name@domain.com).");
                    return false;
                }
                setFieldState("email", true);
                return true;
            }

            function validatePhone() {
                const v = val("phone");
                if (!v || !/^[6-9]\d{9}$/.test(v)) {
                    setFieldState("phone", false, "Please enter a valid 10-digit Indian mobile number (e.g. 9876543210).");
                    return false;
                }
                setFieldState("phone", true);
                return true;
            }

            function validateWhatsApp() {
                const v = val("whatsappNumber");
                if (v && !/^[6-9]\d{9}$/.test(v)) {
                    setFieldState("whatsappNumber", false, "WhatsApp number must be a valid 10-digit mobile number.");
                    return false;
                }
                setFieldState("whatsappNumber", true);
                return true;
            }

            function validateBusinessLocation() {
                const v = val("businessLocation");
                if (!v || v.length < 3 || v.toLowerCase() === "pending") {
                    setFieldState("businessLocation", false, "Please enter your business street address or landmark (min 3 characters).");
                    return false;
                }
                setFieldState("businessLocation", true);
                return true;
            }

            function validateStateField() {
                const v = val("stateSelect");
                if (!v) {
                    setFieldState("state", false, "Please select your state or union territory.");
                    return false;
                }
                setFieldState("state", true);
                return true;
            }

            function validatePincode() {
                const v = val("pincode");
                if (!v || !/^[1-9][0-9]{5}$/.test(v)) {
                    setFieldState("pincode", false, "Enter a valid 6-digit postal pincode.");
                    return false;
                }
                setFieldState("pincode", true);
                return true;
            }

            function validateInvestmentNeeded() {
                const v = parseFloat(val("investmentNeeded"));
                if (isNaN(v) || v <= 0) {
                    setFieldState("investmentNeeded", false, "Please enter a valid funding amount required (minimum ₹1,000).");
                    return false;
                }
                setFieldState("investmentNeeded", true);
                return true;
            }

            function validateExpectedIncome() {
                const v = parseFloat(val("expectedMonthlyIncome"));
                if (isNaN(v) || v <= 0) {
                    setFieldState("expectedMonthlyIncome", false, "Please enter expected monthly revenue (minimum ₹100).");
                    return false;
                }
                setFieldState("expectedMonthlyIncome", true);
                return true;
            }

            function validateBusinessExperience() {
                const raw = val("businessExperience");
                if (raw === "") {
                    setFieldState("businessExperience", false, "Enter business experience in years (enter 0 for new startups).");
                    return false;
                }
                const n = parseInt(raw, 10);
                if (isNaN(n) || n < 0 || n > 60) {
                    setFieldState("businessExperience", false, "Experience must be between 0 and 60 years.");
                    return false;
                }
                setFieldState("businessExperience", true);
                return true;
            }

            function validateAadhaar() {
                const v = val("aadhaarNumber");
                if (!v || !/^\d{12}$/.test(v)) {
                    setFieldState("aadhaarNumber", false, "Aadhaar must be exactly 12 numeric digits.");
                    return false;
                }
                setFieldState("aadhaarNumber", true);
                return true;
            }

            function validatePAN() {
                const v = val("panNumber");
                if (v && !/^[A-Z]{5}[0-9]{4}[A-Z]$/.test(v.toUpperCase())) {
                    setFieldState("panNumber", false, "Enter a valid 10-character PAN (e.g. ABCDE1234F).");
                    return false;
                }
                setFieldState("panNumber", true);
                return true;
            }

            function validateBusinessDescription() {
                const v = val("businessDescription");
                if (!v || v.length < 10 || v.toLowerCase() === "profile pending completion by entrepreneur.") {
                    setFieldState("businessDescription", false, "Please provide a descriptive business overview (at least 10 characters).");
                    return false;
                }
                setFieldState("businessDescription", true);
                return true;
            }

            // Bind live validation listeners
            const liveBindings = [
                ["fullName", validateFullName],
                ["businessName", validateBusinessName],
                ["businessCategory", validateBusinessCategory],
                ["email", validateEmail],
                ["phone", validatePhone],
                ["whatsappNumber", validateWhatsApp],
                ["businessLocation", validateBusinessLocation],
                ["pincode", validatePincode],
                ["investmentNeeded", validateInvestmentNeeded],
                ["expectedMonthlyIncome", validateExpectedIncome],
                ["businessExperience", validateBusinessExperience],
                ["aadhaarNumber", validateAadhaar],
                ["panNumber", validatePAN],
                ["businessDescription", validateBusinessDescription]
            ];

            liveBindings.forEach(([id, fn]) => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener("input", () => {
                        fn();
                        recalculateCompletion();
                    });
                    el.addEventListener("blur", () => {
                        fn();
                        recalculateCompletion();
                    });
                }
            });

            // -------------------------------------------------------------
            // 6. Accurate Profile Completion Percentage Formula
            // Formula: Profile Completion % = (Valid Completed Required / Total Required: 16) * 100
            // -------------------------------------------------------------
            const TOTAL_REQUIRED_MILESTONES = 16;

            function recalculateCompletion() {
                let completedCount = 0;
                const missing = [];

                // 1. Profile photo
                const hasPhotoFile = photoInput && photoInput.files && photoInput.files.length > 0;
                const hasExistingPhoto = photoInput && photoInput.getAttribute("data-has-file") === "true";
                if (hasPhotoFile || hasExistingPhoto) {
                    completedCount++;
                } else {
                    missing.push("Founder Headshot");
                }

                // 2. Full Name
                if (val("fullName").length >= 2) {
                    completedCount++;
                } else {
                    missing.push("Full Name");
                }

                // 3. Business Name
                const bName = val("businessName");
                if (bName.length >= 2 && bName.toLowerCase() !== "pending profile completion") {
                    completedCount++;
                } else {
                    missing.push("Business Name");
                }

                // 4. Business Category
                if (val("businessCategory")) {
                    completedCount++;
                } else {
                    missing.push("Category");
                }

                // 5. Account Email
                if (/^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})$/.test(val("email"))) {
                    completedCount++;
                } else {
                    missing.push("Valid Email");
                }

                // 6. Mobile Phone
                if (/^[6-9]\d{9}$/.test(val("phone"))) {
                    completedCount++;
                } else {
                    missing.push("10-Digit Mobile");
                }

                // 7. Street Address
                const bLoc = val("businessLocation");
                if (bLoc.length >= 3 && bLoc.toLowerCase() !== "pending") {
                    completedCount++;
                } else {
                    missing.push("Street Address");
                }

                // 8. State
                if (val("stateSelect")) {
                    completedCount++;
                } else {
                    missing.push("State");
                }

                // 9. City
                const cityVal = cityHidden.value.trim();
                if (cityVal && cityVal !== "Other") {
                    completedCount++;
                } else {
                    missing.push("City");
                }

                // 10. Pincode
                if (/^[1-9][0-9]{5}$/.test(val("pincode"))) {
                    completedCount++;
                } else {
                    missing.push("Pincode");
                }

                // 11. Investment Needed
                const inv = parseFloat(val("investmentNeeded"));
                if (!isNaN(inv) && inv > 0) {
                    completedCount++;
                } else {
                    missing.push("Funding Required");
                }

                // 12. Expected Monthly Income
                const inc = parseFloat(val("expectedMonthlyIncome"));
                if (!isNaN(inc) && inc > 0) {
                    completedCount++;
                } else {
                    missing.push("Monthly Revenue");
                }

                // 13. Business Experience
                const expRaw = val("businessExperience");
                if (expRaw !== "" && !isNaN(parseInt(expRaw, 10)) && parseInt(expRaw, 10) >= 0) {
                    completedCount++;
                } else {
                    missing.push("Experience");
                }

                // 14. Aadhaar Number
                if (/^\d{12}$/.test(val("aadhaarNumber"))) {
                    completedCount++;
                } else {
                    missing.push("12-Digit Aadhaar");
                }

                // 15. Business Description
                const desc = val("businessDescription");
                if (desc.length >= 10 && desc.toLowerCase() !== "profile pending completion by entrepreneur.") {
                    completedCount++;
                } else {
                    missing.push("Business Description");
                }

                // 16. Payout Info (Valid UPI or complete Bank Details)
                const payoutRes = validateBankAndPayout();
                if (payoutRes.payoutValid) {
                    completedCount++;
                } else {
                    missing.push("Payout Info (UPI or Bank)");
                }

                const pct = Math.min(100, Math.round((completedCount * 100) / TOTAL_REQUIRED_MILESTONES));

                // Update UI Progress Display
                const pctText = document.getElementById("pctText");
                const progressFill = document.querySelector(".progress-bar-fill");
                const guidance = document.getElementById("guidanceText");
                const missingList = document.getElementById("missingList");
                const btnSubmitVerif = document.getElementById("btnSubmitVerification");

                if (pctText) pctText.textContent = pct + "%";
                if (progressFill) progressFill.style.width = pct + "%";

                if (missingList) {
                    missingList.innerHTML = "";
                    if (missing.length > 0 && pct < 100) {
                        missing.forEach(item => {
                            const span = document.createElement("span");
                            span.className = "missing-tag";
                            span.innerHTML = '<i class="bi bi-dash-circle"></i> ' + item;
                            missingList.appendChild(span);
                        });
                    }
                }

                if (guidance) {
                    if (pct >= 100) {
                        guidance.innerHTML = '<span style="color:var(--success); font-weight:700;"><i class="bi bi-check-circle-fill"></i> Congratulations! All 16 required milestones are complete. You can now submit your profile for admin verification.</span>';
                    } else {
                        const remaining = TOTAL_REQUIRED_MILESTONES - completedCount;
                        guidance.innerHTML = 'Complete remaining <strong>' + remaining + ' milestone' + (remaining === 1 ? '' : 's') + '</strong> below to reach 100% and unlock verification.';
                    }
                }

                if (btnSubmitVerif && "${entrepreneur.partnerProfileStatus}" !== "PENDING_ADMIN_APPROVAL" && "${entrepreneur.partnerProfileStatus}" !== "APPROVED") {
                    btnSubmitVerif.disabled = (pct < 100);
                }
            }

            // -------------------------------------------------------------
            // 7. Form Submission Validation & Smooth Scroll
            // -------------------------------------------------------------
            form.addEventListener("submit", function(e) {
                const validations = [
                    validateFullName(),
                    validateBusinessName(),
                    validateBusinessCategory(),
                    validateEmail(),
                    validatePhone(),
                    validateWhatsApp(),
                    validateStateField(),
                    validateCityField(),
                    validateBusinessLocation(),
                    validatePincode(),
                    validateInvestmentNeeded(),
                    validateExpectedIncome(),
                    validateBusinessExperience(),
                    validateAadhaar(),
                    validatePAN(),
                    validateBusinessDescription()
                ];

                const bankRes = validateBankAndPayout();
                if (!bankRes.isBankOk) {
                    validations.push(false);
                }

                const hasPhotoFile = photoInput && photoInput.files && photoInput.files.length > 0;
                const hasExistingPhoto = photoInput && photoInput.getAttribute("data-has-file") === "true";
                if (!hasPhotoFile && !hasExistingPhoto) {
                    setFieldState("profilePhoto", false, "Please upload a founder portrait or venture logo.");
                    validations.push(false);
                }

                const allValid = validations.every(v => v === true);

                if (!allValid) {
                    e.preventDefault();
                    // Smooth scroll to the first invalid input
                    const firstInvalid = form.querySelector(".is-invalid, .error-msg.visible");
                    if (firstInvalid) {
                        const target = firstInvalid.closest(".form-group") || firstInvalid;
                        target.scrollIntoView({ behavior: "smooth", block: "center" });
                        const input = target.querySelector("input, select, textarea");
                        if (input) input.focus();
                    }
                    return false;
                }

                syncBankDetails();
                const btnSave = document.getElementById("btnBottomSave");
                if (btnSave) {
                    btnSave.disabled = true;
                    btnSave.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Saving Details...';
                }
            });

            // Header save button delegates to form submission
            const btnHeaderSave = document.getElementById("btnHeaderSave");
            if (btnHeaderSave) {
                btnHeaderSave.addEventListener("click", () => {
                    form.requestSubmit ? form.requestSubmit() : form.submit();
                });
            }

            // Initial calculation on page load
            validateBankAndPayout();
            recalculateCompletion();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
