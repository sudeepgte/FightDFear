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
    <title>Investor Profile Completion — Fight D Fear</title>
    
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Leaflet CSS for Interactive Location Map (Whitelisted by CSP) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">

    <style>
        :root {
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --primary-plum: #4c0519;
            --rose-bg-light: #fff1f2;
            --rose-border: #fecdd3;
            --bg-page: #f8fafc;
            --bg-card: #ffffff;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
            --border-focus: #f43f5e;
            --success: #16a34a;
            --success-bg: #f0fdf4;
            --error: #dc2626;
            --error-bg: #fef2f2;
            --font-heading: 'Outfit', 'Poppins', sans-serif;
            --font-body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            --shadow-card: 0 4px 18px rgba(15, 23, 42, 0.04);
            --shadow-hover: 0 8px 24px rgba(15, 23, 42, 0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { overflow-x: hidden; }

        body {
            font-family: var(--font-body);
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--text-primary);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Header */
        .app-header {
            background: var(--bg-card);
            border-bottom: 2px solid var(--primary-rose);
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            gap: 12px;
            flex-wrap: wrap;
            box-shadow: 0 1px 4px rgba(0,0,0,0.03);
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--primary-plum);
            text-decoration: none;
        }

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
            color: var(--text-primary);
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
            background: #f1f5f9;
            border-color: #cbd5e1;
        }

        .btn-header-save {
            padding: 8px 18px;
            background: var(--primary-rose);
            color: #ffffff;
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
            background: var(--primary-rose-hover);
            transform: translateY(-1px);
        }

        /* Main Container */
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
            border: 1px solid #bbf7d0;
            color: var(--success);
        }

        .alert-danger {
            background: var(--error-bg);
            border: 1px solid #fecaca;
            color: var(--error);
        }

        /* Approved Banner */
        .approved-banner {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            border-radius: 16px;
            padding: 22px 24px;
            color: white;
            margin-bottom: 22px;
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }

        .approved-banner h3 {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 800;
            margin: 6px 0 4px;
        }

        .approved-banner p {
            margin: 0;
            font-size: 0.88rem;
            color: rgba(255, 255, 255, 0.92);
        }

        .btn-approved-dash {
            background: #ffffff;
            color: #059669;
            font-weight: 700;
            font-size: 0.92rem;
            padding: 10px 22px;
            border-radius: 50px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transition: transform 0.2s;
            white-space: nowrap;
        }

        .btn-approved-dash:hover {
            transform: scale(1.02);
            color: #047857;
        }

        /* Dynamic Profile Progress Card */
        .profile-progress-card {
            background: var(--bg-card);
            border-radius: 18px;
            border: 1px solid var(--rose-border);
            padding: 22px 24px;
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
            position: relative;
            overflow: hidden;
        }

        .profile-progress-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-rose), #fb7185);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .progress-user-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .progress-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: var(--rose-bg-light);
            color: var(--primary-rose);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            font-weight: 800;
            border: 2px solid var(--rose-border);
            overflow: hidden;
            flex-shrink: 0;
        }

        .progress-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .progress-title-block h2 {
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--primary-plum);
            margin: 0;
        }

        .progress-title-block span {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .status-badge {
            font-size: 0.78rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-registered { background: #e2e8f0; color: #475569; }
        .badge-pending { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .badge-changes { background: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; }
        .badge-approved { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-rejected { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

        .progress-bar-container {
            height: 10px;
            background: #e2e8f0;
            border-radius: 50px;
            overflow: hidden;
            margin: 14px 0 10px;
            position: relative;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-rose) 0%, #fb7185 100%);
            border-radius: 50px;
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .progress-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
            font-size: 0.82rem;
            color: var(--text-secondary);
            margin-top: 6px;
        }

        .progress-pct-badge {
            font-weight: 800;
            color: var(--primary-rose);
            font-size: 0.95rem;
        }

        /* Missing Requirements Tag Cloud */
        .missing-tags-container {
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed var(--border-light);
        }

        .missing-tags-label {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .missing-tags-list {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .missing-tag-pill {
            font-size: 0.75rem;
            padding: 4px 10px;
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
            border-radius: 6px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .missing-tag-pill:hover {
            background: #ffe4e6;
            transform: translateY(-1px);
        }

        /* Admin Feedback Banners */
        .feedback-banner {
            background: #fffbeb;
            border: 1px solid #fcd34d;
            border-radius: 14px;
            padding: 16px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }

        .feedback-banner i {
            color: #d97706;
            font-size: 1.35rem;
            margin-top: 2px;
        }

        .feedback-content h4 {
            font-family: var(--font-heading);
            font-size: 0.95rem;
            font-weight: 800;
            color: #92400e;
            margin: 0 0 4px;
        }

        .feedback-content p {
            font-size: 0.88rem;
            color: #78350f;
            line-height: 1.45;
            margin: 0;
        }

        /* Submit for Verification Bar */
        .submit-bar {
            margin-bottom: 22px;
        }

        .btn-submit-verification {
            width: 100%;
            padding: 16px;
            background: var(--primary-rose);
            color: #ffffff;
            border: none;
            border-radius: 14px;
            font-family: var(--font-heading);
            font-size: 1.02rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 4px 16px rgba(244, 63, 94, 0.28);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--primary-rose-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.35);
        }

        .btn-submit-verification:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748b;
            transform: none;
        }

        /* Section Cards */
        .section-card {
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: 18px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .section-card:hover {
            box-shadow: var(--shadow-hover);
        }

        .section-header {
            font-family: var(--font-heading);
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--primary-plum);
            background: var(--rose-bg-light);
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid var(--primary-rose);
        }

        .section-header .num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background: var(--primary-rose);
            color: white;
            border-radius: 50%;
            font-size: 0.78rem;
            font-weight: 800;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .form-group label .req {
            color: var(--primary-rose);
            margin-left: 2px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid var(--border-light);
            border-radius: 12px;
            font-size: 0.92rem;
            font-family: inherit;
            color: var(--text-primary);
            background: #ffffff;
            transition: all 0.2s;
            height: 48px;
            box-sizing: border-box;
        }

        .form-textarea {
            height: auto;
            min-height: 110px;
            resize: vertical;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            background-color: #fffaf0 !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid, .form-select.is-valid, .form-textarea.is-valid {
            border-color: var(--success) !important;
            background-color: var(--success-bg) !important;
        }

        .error-msg {
            display: none;
            font-size: 0.78rem;
            color: var(--error);
            font-weight: 600;
            margin-top: 5px;
            align-items: center;
            gap: 5px;
            line-height: 1.35;
        }

        .error-msg.visible {
            display: flex;
        }

        .helper-text {
            font-size: 0.78rem;
            color: var(--text-secondary);
            margin-top: 4px;
            line-height: 1.35;
        }

        /* Map Picker Button & Location Box */
        .btn-map-picker {
            padding: 8px 14px;
            background: #ffffff;
            color: var(--primary-rose);
            border: 1.5px solid var(--primary-rose);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-map-picker:hover {
            background: var(--rose-bg-light);
            transform: translateY(-1px);
        }

        .map-location-preview {
            background: var(--rose-bg-light);
            border: 1px dashed var(--primary-rose);
            border-radius: 10px;
            padding: 10px 14px;
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.85rem;
            color: var(--text-primary);
        }

        .map-location-preview strong {
            color: var(--primary-plum);
        }

        /* Bottom Save Actions */
        .bottom-actions {
            margin-top: 28px;
            display: flex;
            gap: 14px;
        }

        .btn-bottom-save {
            flex: 1;
            padding: 16px;
            background: var(--primary-rose);
            color: #ffffff;
            border: none;
            border-radius: 14px;
            font-family: var(--font-heading);
            font-size: 1.02rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 4px 16px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-bottom-save:hover {
            background: var(--primary-rose-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.35);
        }

        /* Leaflet Map Modal */
        .map-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(6px);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .map-modal-overlay.open {
            display: flex;
        }

        .map-modal-card {
            background: #ffffff;
            border-radius: 20px;
            width: 100%;
            max-width: 680px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid var(--border-light);
            animation: modalFadeIn 0.3s ease;
            max-height: 92vh;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .map-modal-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--rose-bg-light);
        }

        .map-modal-title {
            font-family: var(--font-heading);
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--primary-plum);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .map-modal-close {
            background: transparent;
            border: none;
            font-size: 1.4rem;
            color: var(--text-secondary);
            cursor: pointer;
            line-height: 1;
            padding: 4px;
            border-radius: 6px;
            transition: color 0.2s;
        }

        .map-modal-close:hover {
            color: var(--error);
        }

        .map-modal-body {
            padding: 16px 22px;
            overflow-y: auto;
            flex: 1;
        }

        .map-search-row {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            position: relative;
        }

        .map-search-input {
            flex: 1;
            padding: 10px 14px;
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
        }

        .map-search-input:focus {
            outline: none;
            border-color: var(--primary-rose);
        }

        .btn-search-map {
            padding: 10px 16px;
            background: var(--primary-rose);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-search-map:hover {
            background: var(--primary-rose-hover);
        }

        .btn-locate-me {
            padding: 10px 14px;
            background: #ffffff;
            color: var(--text-primary);
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.88rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }

        .btn-locate-me:hover {
            background: #f1f5f9;
        }

        .map-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #ffffff;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            max-height: 200px;
            overflow-y: auto;
            display: none;
            margin-top: 4px;
        }

        .map-suggestion-item {
            padding: 10px 14px;
            font-size: 0.85rem;
            border-bottom: 1px solid #f1f5f9;
            cursor: pointer;
            transition: background 0.15s;
        }

        .map-suggestion-item:hover {
            background: #f8fafc;
            color: var(--primary-rose);
        }

        .map-suggestion-item:last-child {
            border-bottom: none;
        }

        #mapContainer {
            width: 100%;
            height: 350px;
            border-radius: 14px;
            border: 1.5px solid var(--border-light);
            margin-bottom: 12px;
            background: #f1f5f9;
        }

        .map-selected-address-box {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.85rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .map-modal-footer {
            padding: 14px 22px;
            border-top: 1px solid var(--border-light);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: #ffffff;
        }

        .btn-modal-cancel {
            padding: 10px 20px;
            background: #ffffff;
            border: 1.5px solid var(--border-light);
            color: var(--text-primary);
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
        }

        .btn-modal-cancel:hover {
            background: #f1f5f9;
        }

        .btn-modal-confirm {
            padding: 10px 22px;
            background: var(--primary-rose);
            border: none;
            color: #ffffff;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-modal-confirm:hover:not(:disabled) {
            background: var(--primary-rose-hover);
        }

        .btn-modal-confirm:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
        }

        @media (max-width: 600px) {
            .map-search-row {
                flex-direction: column;
            }
            #mapContainer {
                height: 280px;
            }
        }
    </style>
</head>
<body>

    <!-- Header with Skip & Save Actions -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/investor/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-skip">
                <i class="bi bi-speedometer2"></i> Skip to Dashboard
            </a>
            <button type="button" class="btn-header-save" onclick="triggerProfileSubmit()">
                <i class="bi bi-floppy-fill"></i> Save Profile
            </button>
        </div>
    </header>

    <main class="main-container">

        <!-- Flash Success Notification -->
        <c:if test="${not empty success}">
            <div class="alert-box alert-success" role="alert">
                <i class="bi bi-check-circle-fill" style="font-size:1.2rem;"></i>
                <span>${success}</span>
            </div>
        </c:if>
        
        <!-- Flash Error Notification -->
        <c:if test="${not empty error}">
            <div class="alert-box alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill" style="font-size:1.2rem;"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Approved / Verified Banner -->
        <c:if test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
            <div class="approved-banner">
                <div>
                    <span style="background: rgba(255,255,255,0.22); color: white; font-size: 0.75rem; font-weight: 700; padding: 4px 12px; border-radius: 50px; text-transform: uppercase; letter-spacing: 0.5px;">Account Verified &amp; Approved</span>
                    <h3><i class="bi bi-patch-check-fill me-1"></i> Your Investor Profile is Fully Active!</h3>
                    <p>Admin has approved your credentials. You can now access and invest directly in startups across the platform.</p>
                </div>
                <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-approved-dash">
                    <i class="bi bi-speedometer2"></i> Open Investor Dashboard
                </a>
            </div>
        </c:if>

        <!-- Dynamic Profile Completion Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <div class="progress-user-info">
                    <div class="progress-avatar">
                        <c:choose>
                            <c:when test="${not empty investor.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${investor.profilePhoto}" alt="${investor.fullName}">
                            </c:when>
                            <c:otherwise>
                                ${not empty investor.fullName ? investor.fullName.substring(0, 1).toUpperCase() : 'I'}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="progress-title-block">
                        <h2>Investor Profile Completion</h2>
                        <span>Complete all 17 required milestones for verification</span>
                    </div>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
                            <span class="status-badge badge-approved"><i class="bi bi-check-circle-fill"></i> Approved</span>
                        </c:when>
                        <c:when test="${not empty investor and investor.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                            <span class="status-badge badge-changes"><i class="bi bi-pencil-square"></i> Changes Requested</span>
                        </c:when>
                        <c:when test="${not empty investor and investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                            <span class="status-badge badge-pending"><i class="bi bi-clock-history"></i> Under Review</span>
                        </c:when>
                        <c:when test="${not empty investor and investor.partnerProfileStatus == 'REJECTED'}">
                            <span class="status-badge badge-rejected"><i class="bi bi-x-circle-fill"></i> Rejected</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge badge-registered"><i class="bi bi-person-check"></i> Registered</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Progress Bar -->
            <div class="progress-bar-container">
                <div class="progress-bar-fill" id="progressBarFill" style="width: ${not empty investor.profileCompletionPct ? investor.profileCompletionPct : 0}%;"></div>
            </div>

            <div class="progress-footer">
                <div>
                    Status: <span id="milestoneCounterText">Calculating...</span>
                </div>
                <div class="progress-pct-badge" id="pctText">
                    ${not empty investor.profileCompletionPct ? investor.profileCompletionPct : 0}%
                </div>
            </div>

            <!-- Live Missing Requirements Tag Cloud -->
            <div class="missing-tags-container" id="missingTagsContainer">
                <div class="missing-tags-label">
                    <i class="bi bi-list-check"></i> Missing Requirements (<span id="missingCountText">0</span> remaining)
                </div>
                <div class="missing-tags-list" id="missingTagsList">
                    <!-- Populated dynamically by JS -->
                </div>
            </div>
        </div>

        <!-- Admin Feedback Banner -->
        <c:if test="${not empty investor and not empty investor.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Feedback / Rejection Reason</h4>
                    <p><c:out value="${investor.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty investor and not empty investor.changesRequestedNote}">
            <div class="feedback-banner">
                <i class="bi bi-info-circle-fill"></i>
                <div class="feedback-content">
                    <h4>Required Revisions from Admin</h4>
                    <p><c:out value="${investor.changesRequestedNote}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Submit for Verification Bar -->
        <div class="submit-bar">
            <c:choose>
                <c:when test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
                    <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-submit-verification" style="background:#059669; color:white; text-decoration:none;">
                        <i class="bi bi-patch-check-fill"></i> Profile Approved — Open Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/investor/submit-verification" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button type="submit" id="btnSubmitVerification" class="btn-submit-verification" 
                                <c:if test="${(empty investor.profileCompletionPct or investor.profileCompletionPct < 100) or investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${not empty investor and investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Under Review — Pending Admin Approval
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

        <!-- Complete Profile Form -->
        <form id="profileForm" action="${pageContext.request.contextPath}/investor/complete-profile" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            
            <!-- Section 0: Professional Profile Photo Card -->
            <div class="section-card" id="card-photo">
                <div class="section-header">
                    <span class="num">0</span>
                    <span>Professional Profile Headshot</span>
                </div>
                
                <div style="display: flex; align-items: center; gap: 24px; flex-wrap: wrap;">
                    <div style="position: relative; width: 110px; height: 110px; flex-shrink: 0;">
                        <c:choose>
                            <c:when test="${not empty investor.profilePhoto}">
                                <img id="profilePhotoPreview" src="${pageContext.request.contextPath}${investor.profilePhoto}" 
                                     alt="Profile Photo" 
                                     style="width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid var(--primary-rose); box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                            </c:when>
                            <c:otherwise>
                                <img id="profilePhotoPreview" src="" alt="Profile Photo" 
                                     style="display: none; width: 110px; height: 110px; border-radius: 50%; object-fit: cover; border: 4px solid var(--primary-rose); box-shadow: 0 4px 14px rgba(244, 63, 94, 0.2);">
                                <div id="profilePhotoFallback" 
                                     style="width: 110px; height: 110px; border-radius: 50%; background: #ffe4e6; color: var(--primary-rose); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; border: 4px solid var(--rose-border);">
                                    ${not empty investor.fullName ? investor.fullName.substring(0, 1).toUpperCase() : 'I'}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="flex: 1; min-width: 240px;">
                        <h4 style="font-family: var(--font-heading); font-size: 1rem; font-weight: 800; color: var(--text-primary); margin: 0 0 4px;">Upload Profile Headshot <span class="req" style="color:var(--primary-rose);">*</span></h4>
                        <p class="helper-text" style="margin-bottom: 12px;">
                            A clear, professional photo increases investor trust and startup pitch acceptance by 70%. Accepts JPG, PNG, or WebP (max 5MB).
                        </p>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                            <label for="profilePhotoInput" style="background: var(--primary-rose); color: white; padding: 9px 18px; border-radius: 10px; font-size: 0.88rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; margin: 0; transition: background 0.2s;">
                                <i class="bi bi-camera-fill"></i> Choose Headshot Photo
                            </label>
                            <input type="file" id="profilePhotoInput" name="profilePhotoFile" accept="image/*" style="display: none;" onchange="previewSelectedPhoto(this)">
                            <button type="button" id="btnClearPhoto" onclick="clearSelectedPhoto()" style="display: none; background: white; border: 1.5px solid var(--border-light); color: var(--text-secondary); padding: 8px 14px; border-radius: 10px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                <i class="bi bi-x-circle"></i> Remove Photo
                            </button>
                        </div>
                        <div class="error-msg" id="err-photo"><i class="bi bi-exclamation-circle-fill"></i> <span>Please upload a professional profile headshot photo.</span></div>
                    </div>
                </div>
            </div>

            <!-- Section 1: Business Profile & Credentials -->
            <div class="section-card" id="card-identity">
                <div class="section-header">
                    <span class="num">1</span>
                    <span>Business Profile &amp; Credentials</span>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">1.1 Full Name <span class="req">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-input" value="<c:out value='${investor.fullName}'/>" placeholder="Your full legal name" required>
                        <div class="error-msg" id="err-fullName"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter your full legal name (minimum 2 characters).</span></div>
                    </div>
                    <div class="form-group">
                        <label for="designation">1.2 Role / Designation <span class="req">*</span></label>
                        <input type="text" id="designation" name="designation" class="form-input" value="<c:out value='${investor.designation}'/>" placeholder="e.g. Managing Partner / Angel Investor" required>
                        <div class="error-msg" id="err-designation"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter your role or designation.</span></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="companyName">1.3 Business / Fund Name <span class="req">*</span></label>
                        <input type="text" id="companyName" name="companyName" class="form-input" value="<c:out value='${investor.companyName}'/>" placeholder="e.g. Apex Capital Ventures" required>
                        <div class="error-msg" id="err-companyName"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter your firm or investment entity name.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="credentialNumber">1.4 SEBI / AIF / PAN ID <span class="req">*</span></label>
                        <input type="text" id="credentialNumber" name="credentialNumber" class="form-input" value="<c:out value='${investor.credentialNumber}'/>" placeholder="10-digit PAN or SEBI Registration Number" required style="text-transform: uppercase;">
                        <div class="error-msg" id="err-credentialNumber"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter a valid SEBI Registration or 10-character PAN ID.</span></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">1.5 Mobile Phone Number <span class="req">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-input" value="<c:out value='${investor.phone}'/>" placeholder="10-digit mobile number" maxlength="10" required>
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="whatsappNumber">1.6 WhatsApp Number</label>
                        <input type="tel" id="whatsappNumber" name="whatsappNumber" class="form-input" value="<c:out value='${investor.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                        <div class="error-msg" id="err-whatsappNumber"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter a valid 10-digit WhatsApp number.</span></div>
                    </div>
                </div>
            </div>

            <!-- Section 2: Address & Operations with Map Integration -->
            <div class="section-card" id="card-location">
                <div class="section-header">
                    <span class="num">2</span>
                    <span>Address &amp; Operations</span>
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
                        <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> <span>Please select your state or union territory.</span></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="citySelect">2.3 City / District <span class="req">*</span></label>
                        <select id="citySelect" class="form-select" required>
                            <option value="">-- Select State First --</option>
                        </select>
                        <div id="customCityGroup" style="display:none; margin-top:8px;">
                            <input type="text" id="customCityInput" class="form-input" placeholder="Type City / District name">
                        </div>
                        <input type="hidden" id="cityHidden" name="city" value="<c:out value='${investor.city}'/>">
                        <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> <span>Please select or enter your city/district.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="pincode">2.4 Postal Pincode <span class="req">*</span></label>
                        <input type="text" id="pincode" name="pincode" class="form-input" value="<c:out value='${investor.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required pattern="[1-9][0-9]{5}">
                        <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> <span>Enter a valid 6-digit postal pincode.</span></div>
                    </div>
                </div>

                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; flex-wrap:wrap; gap:8px;">
                        <label for="address" style="margin-bottom:0;">2.5 Street Address / Office Location <span class="req">*</span></label>
                        <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                            <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                        </button>
                    </div>
                    <input type="text" id="address" name="address" class="form-input" value="<c:out value='${investor.address}'/>" placeholder="Office/Suite No, Building Name, Street, Landmark" required>
                    <div class="error-msg" id="err-address"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter your office street address or landmark (min 3 characters).</span></div>
                    
                    <!-- Map Coordinates Preview Bar -->
                    <div id="mapLocationPreview" class="map-location-preview" style="display:${(not empty investor.latitude and not empty investor.longitude) ? 'flex' : 'none'};">
                        <i class="bi bi-pin-map-fill" style="color:var(--primary-rose); font-size:1.1rem;"></i>
                        <span>Location Coordinates: <strong id="pinnedCoordsText">${investor.latitude}, ${investor.longitude}</strong></span>
                        <button type="button" id="btnClearMapPin" style="border:none; background:transparent; color:var(--error); font-size:0.75rem; font-weight:700; cursor:pointer; margin-left:auto;">
                            <i class="bi bi-x-circle"></i> Clear Pin
                        </button>
                    </div>
                    <input type="hidden" id="latitude" name="latitude" value="<c:out value='${investor.latitude}'/>">
                    <input type="hidden" id="longitude" name="longitude" value="<c:out value='${investor.longitude}'/>">
                </div>
            </div>

            <!-- Section 3: Sector & Cheque Details -->
            <div class="section-card" id="card-thesis">
                <div class="section-header">
                    <span class="num">3</span>
                    <span>Investment Thesis &amp; Ticket Size</span>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="categoriesOffered">3.1 Target Sectors / Categories <span class="req">*</span></label>
                        <input type="text" id="categoriesOffered" name="categoriesOffered" class="form-input" value="<c:out value='${investor.categoriesOffered}'/>" placeholder="e.g. Tech, Retail, Apparel, Handicrafts, Healthcare" required>
                        <div class="error-msg" id="err-categoriesOffered"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter your target investment sectors.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="audience">3.2 Who I Fund (Target Audience) <span class="req">*</span></label>
                        <input type="text" id="audience" name="audience" class="form-input" value="<c:out value='${investor.audience}'/>" placeholder="e.g. Women Founders, Early-stage D2C, Tech Startups" required>
                        <div class="error-msg" id="err-audience"><i class="bi bi-exclamation-circle-fill"></i> <span>Please specify the startup profiles you fund.</span></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="ticketMode">3.3 Investment Stage <span class="req">*</span></label>
                        <select id="ticketMode" name="ticketMode" class="form-select" required>
                            <option value="Angel" <c:if test="${investor.ticketMode == 'Angel'}">selected</c:if>>Angel (₹10K - ₹2L)</option>
                            <option value="Seed" <c:if test="${investor.ticketMode == 'Seed'}">selected</c:if>>Seed (₹2L - ₹10L)</option>
                            <option value="Series" <c:if test="${investor.ticketMode == 'Series'}">selected</c:if>>Series (₹10L - ₹50L)</option>
                            <option value="Grant" <c:if test="${investor.ticketMode == 'Grant'}">selected</c:if>>Grant (Non-equity / Social Impact)</option>
                        </select>
                        <div class="error-msg" id="err-ticketMode"><i class="bi bi-exclamation-circle-fill"></i> <span>Please select an investment stage.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="typicalPrice">3.4 Typical Cheque / Budget Size (₹) <span class="req">*</span></label>
                        <input type="number" step="1000" id="typicalPrice" name="typicalPrice" class="form-input" value="<c:out value='${investor.typicalCheque}'/>" placeholder="e.g. 50000" min="1000" required>
                        <div class="error-msg" id="err-typicalPrice"><i class="bi bi-exclamation-circle-fill"></i> <span>Please enter a valid typical cheque size (min ₹1,000).</span></div>
                    </div>
                </div>
            </div>

            <!-- Section 4: Call & Meeting Slot Settings -->
            <div class="section-card" id="card-schedule">
                <div class="section-header">
                    <span class="num">4</span>
                    <span>Pitch Meeting &amp; Call Slots</span>
                </div>
                
                <div class="form-group">
                    <label for="openDays">4.1 Available Days <span class="req">*</span></label>
                    <input type="text" id="openDays" name="openDays" class="form-input" value="<c:out value='${investor.openDays}'/>" placeholder="e.g. Mon-Fri or Monday, Wednesday, Friday" required>
                    <div class="error-msg" id="err-openDays"><i class="bi bi-exclamation-circle-fill"></i> <span>Please specify your available days for founder pitch calls.</span></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="openTime">4.2 Availability Start Time <span class="req">*</span></label>
                        <input type="time" id="openTime" name="openTime" class="form-input" value="<c:out value='${investor.openTime}'/>" required>
                        <div class="error-msg" id="err-openTime"><i class="bi bi-exclamation-circle-fill"></i> <span>Please select availability start time.</span></div>
                    </div>
                    <div class="form-group">
                        <label for="closeTime">4.3 Availability End Time <span class="req">*</span></label>
                        <input type="time" id="closeTime" name="closeTime" class="form-input" value="<c:out value='${investor.closeTime}'/>" required>
                        <div class="error-msg" id="err-closeTime"><i class="bi bi-exclamation-circle-fill"></i> <span>Please select availability end time (must be after start time).</span></div>
                    </div>
                </div>
            </div>

            <!-- Section 5: Profile Bio & Investment Focus -->
            <div class="section-card" id="card-bio">
                <div class="section-header">
                    <span class="num">5</span>
                    <span>Profile Bio &amp; Mentorship Focus</span>
                </div>
                <div class="form-group">
                    <label for="bio">5.1 About Me / Investment Criteria &amp; Support <span class="req">*</span></label>
                    <textarea id="bio" name="bio" class="form-textarea" rows="4" placeholder="Briefly introduce your investment criteria, background, support, and mentorship expertise..." required><c:out value="${investor.bio}"/></textarea>
                    <div class="error-msg" id="err-bio"><i class="bi bi-exclamation-circle-fill"></i> <span>Please provide an introductory bio and investment focus (minimum 15 characters).</span></div>
                </div>
            </div>

            <!-- Section 6: Settlement & Bank Info -->
            <div class="section-card" id="card-bank">
                <div class="section-header">
                    <span class="num">6</span>
                    <span>Payout &amp; Settlement Account</span>
                </div>
                
                <div class="form-group">
                    <label for="inputUpiId">6.1 UPI ID (for instant settlement / optional)</label>
                    <input type="text" name="upiId" id="inputUpiId" class="form-input" value="<c:out value='${investor.upiId}'/>" placeholder="e.g. username@okhdfcbank">
                    <div class="error-msg" id="err-upiId"><i class="bi bi-exclamation-circle-fill"></i> <span>Invalid UPI ID format.</span></div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankAccountHolder">6.2 Account Holder Name</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank records">
                    </div>
                    <div class="form-group">
                        <label for="bankName">6.3 Bank Name</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. HDFC Bank, ICICI Bank, SBI">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankAccountNumber">6.4 Account Number</label>
                        <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Enter bank account number" maxlength="20">
                    </div>
                    <div class="form-group">
                        <label for="confirmAccountNumber">6.5 Re-enter Account Number</label>
                        <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Confirm bank account number" maxlength="20">
                        <div class="error-msg" id="err-confirmAccountNumber"><i class="bi bi-exclamation-circle-fill"></i> <span>Account numbers do not match.</span></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankIfsc">6.6 IFSC Code</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. HDFC0001234" maxlength="11" style="text-transform: uppercase;">
                        <div class="error-msg" id="err-bankIfsc"><i class="bi bi-exclamation-circle-fill"></i> <span>Invalid IFSC format (e.g. SBIN0001234, 11 alphanumeric characters).</span></div>
                    </div>
                    <div class="form-group">
                        <label for="bankBranch">6.7 Branch Name</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Nariman Point Branch">
                    </div>
                </div>

                <!-- Hidden serialized field for DB compatibility -->
                <input type="hidden" id="bankDetails" name="bankDetails" value="<c:out value='${investor.bankDetails}'/>">
            </div>

            <!-- Bottom Save Action -->
            <div class="bottom-actions">
                <button type="button" class="btn-bottom-save" onclick="triggerProfileSubmit()">
                    <i class="bi bi-floppy-fill"></i> Save Investor Profile
                </button>
            </div>
        </form>

    </main>

    <!-- Leaflet Interactive Location Map Modal -->
    <div id="mapPickerModal" class="map-modal-overlay">
        <div class="map-modal-card">
            <div class="map-modal-header">
                <h3 class="map-modal-title">
                    <i class="bi bi-geo-alt-fill text-danger"></i> Select Office Location on Map
                </h3>
                <button type="button" class="map-modal-close" id="btnCloseMapModal">&times;</button>
            </div>
            <div class="map-modal-body">
                <div class="map-search-row">
                    <input type="text" id="mapSearchInput" class="map-search-input" placeholder="Search locality, city, landmark or area...">
                    <button type="button" id="btnSearchMap" class="btn-search-map">
                        <i class="bi bi-search"></i> Search
                    </button>
                    <button type="button" id="btnLocateMe" class="btn-locate-me">
                        <i class="bi bi-crosshair"></i> Locate Me
                    </button>
                    <div id="mapSuggestions" class="map-suggestions"></div>
                </div>

                <div id="mapContainer"></div>

                <div class="map-selected-address-box">
                    <i class="bi bi-pin-map-fill text-danger" style="font-size:1.1rem; flex-shrink:0;"></i>
                    <span id="mapSelectedAddress" style="font-weight:600;">Click on map or drag the pin to select office location</span>
                </div>

                <div id="mapPickerAlert" style="display:none; color:var(--error); font-size:0.8rem; font-weight:600; margin-top:8px;"></div>
            </div>
            <div class="map-modal-footer">
                <button type="button" id="btnCancelMap" class="btn-modal-cancel">Cancel</button>
                <button type="button" id="btnConfirmLocation" class="btn-modal-confirm" disabled>
                    <i class="bi bi-check-lg"></i> Confirm &amp; Use Location
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS (Whitelisted by CSP) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const ctx = "${pageContext.request.contextPath}";

        // -------------------------------------------------------------
        // Photo Preview and Clear
        // -------------------------------------------------------------
        function previewSelectedPhoto(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                if (file.size > 5 * 1024 * 1024) {
                    setFieldState("photo", false, "Photo size exceeds 5MB limit. Please choose a smaller image.");
                    input.value = "";
                    return;
                }
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('profilePhotoPreview');
                    const fallback = document.getElementById('profilePhotoFallback');
                    const btnClear = document.getElementById('btnClearPhoto');
                    if (preview) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    if (fallback) fallback.style.display = 'none';
                    if (btnClear) btnClear.style.display = 'inline-block';
                    setFieldState("photo", true);
                    recalculateCompletion();
                };
                reader.readAsDataURL(file);
            }
        }

        function clearSelectedPhoto() {
            const input = document.getElementById('profilePhotoInput');
            const preview = document.getElementById('profilePhotoPreview');
            const fallback = document.getElementById('profilePhotoFallback');
            const btnClear = document.getElementById('btnClearPhoto');
            if (input) input.value = '';
            if (btnClear) btnClear.style.display = 'none';

            if ("${investor.profilePhoto}" !== "") {
                if (preview) {
                    preview.src = ctx + "${investor.profilePhoto}";
                    preview.style.display = 'block';
                }
                setFieldState("photo", true);
            } else {
                if (preview) preview.style.display = 'none';
                if (fallback) fallback.style.display = 'flex';
                setFieldState("photo", false, "Please upload a professional profile headshot photo.");
            }
            recalculateCompletion();
        }

        // -------------------------------------------------------------
        // Validation Utilities & Field States
        // -------------------------------------------------------------
        function setFieldState(fieldKey, isValid, errorMsg) {
            const errEl = document.getElementById("err-" + fieldKey);
            const inputEl = document.getElementById(fieldKey);

            if (errEl) {
                const span = errEl.querySelector("span");
                if (!isValid) {
                    if (errorMsg && span) span.textContent = errorMsg;
                    errEl.classList.add("visible");
                } else {
                    errEl.classList.remove("visible");
                }
            }

            if (inputEl) {
                if (!isValid) {
                    inputEl.classList.add("is-invalid");
                    inputEl.classList.remove("is-valid");
                } else {
                    inputEl.classList.remove("is-invalid");
                    if (inputEl.value && inputEl.value.trim().length > 0) {
                        inputEl.classList.add("is-valid");
                    } else {
                        inputEl.classList.remove("is-valid");
                    }
                }
            }
        }

        // -------------------------------------------------------------
        // Dependent Location Dropdowns (State -> City)
        // -------------------------------------------------------------
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

        const stateSelect = document.getElementById("stateSelect");
        const citySelect = document.getElementById("citySelect");
        const customCityGroup = document.getElementById("customCityGroup");
        const customCityInput = document.getElementById("customCityInput");
        const cityHidden = document.getElementById("cityHidden");

        const savedState = "${investor.state}";
        const savedCity = "${investor.city}";

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
                // fallback to static list
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
                console.warn("Cities fetch failed, fallback to custom entry", e);
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

            // Add "+ Other (Type City)" option
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
                    setFieldState("state", false, "Please select your state or union territory.");
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
                setFieldState("city", false, "Please select or enter your city/district.");
                return false;
            }
            setFieldState("city", true);
            return true;
        }

        // -------------------------------------------------------------
        // Leaflet Map Interactive Location Picker
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
                mapPickerAlert.style.display = "block";
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

            let initLat = 20.5937; // Center of India
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
                console.warn("Reverse geocode fetch error", e);
            }

            currentPinAddress = "Office Location (" + lat.toFixed(4) + ", " + lng.toFixed(4) + ")";
            mapSelectedAddress.textContent = currentPinAddress;
            btnConfirmLocation.disabled = false;
        }

        async function searchLocation(query) {
            if (!query || query.trim().length < 3) return;
            showMapAlert("");
            mapSuggestions.style.display = "none";

            try {
                const url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(query.trim()) + "&countrycodes=in&limit=5&addressdetails=1";
                const res = await fetch(url, { headers: { "Accept-Language": "en" } });
                if (res.ok) {
                    const data = await res.json();
                    if (Array.isArray(data) && data.length > 0) {
                        mapSuggestions.innerHTML = "";
                        data.forEach(item => {
                            const div = document.createElement("div");
                            div.className = "map-suggestion-item";
                            div.textContent = item.display_name;
                            div.addEventListener("click", () => {
                                const lat = parseFloat(item.lat);
                                const lng = parseFloat(item.lon);
                                map.setView([lat, lng], 15);
                                marker.setLatLng([lat, lng]);
                                currentPinCoords = { lat: lat, lng: lng, address: item.display_name, details: item.address || {} };
                                currentPinAddress = item.display_name;
                                mapSelectedAddress.textContent = item.display_name;
                                btnConfirmLocation.disabled = false;
                                mapSuggestions.style.display = "none";
                            });
                            mapSuggestions.appendChild(div);
                        });
                        mapSuggestions.style.display = "block";
                        return;
                    }
                }
                showMapAlert("No location matches found for '" + query + "'. Try another area or landmark.");
            } catch (e) {
                showMapAlert("Search network error. You can directly tap the map to place your pin.");
            }
        }

        if (btnOpenMap) {
            btnOpenMap.addEventListener("click", function() {
                mapModal.classList.add("open");
                initMapInstance();
                setTimeout(() => {
                    if (map) map.invalidateSize();
                }, 200);
            });
        }

        if (btnCloseMap) {
            btnCloseMap.addEventListener("click", function() {
                mapModal.classList.remove("open");
            });
        }

        if (btnCancelMap) {
            btnCancelMap.addEventListener("click", function() {
                mapModal.classList.remove("open");
            });
        }

        if (btnSearchMap) {
            btnSearchMap.addEventListener("click", () => searchLocation(mapSearchInput.value));
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
            btnLocateMe.addEventListener("click", function() {
                if (!navigator.geolocation) {
                    showMapAlert("Geolocation is not supported by your browser.");
                    return;
                }
                btnLocateMe.disabled = true;
                btnLocateMe.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Locating...';
                navigator.geolocation.getCurrentPosition(
                    (pos) => {
                        btnLocateMe.disabled = false;
                        btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> Locate Me';
                        const lat = pos.coords.latitude;
                        const lng = pos.coords.longitude;
                        if (map && marker) {
                            map.setView([lat, lng], 15);
                            marker.setLatLng([lat, lng]);
                            reverseGeocode(lat, lng);
                        }
                    },
                    (err) => {
                        btnLocateMe.disabled = false;
                        btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> Locate Me';
                        showMapAlert("Location permission denied or unavailable. Please pick location manually.");
                    },
                    { enableHighAccuracy: true, timeout: 8000 }
                );
            });
        }

        if (btnConfirmLocation) {
            btnConfirmLocation.addEventListener("click", function() {
                if (!currentPinCoords) return;

                latInput.value = currentPinCoords.lat.toFixed(6);
                lngInput.value = currentPinCoords.lng.toFixed(6);

                if (pinnedCoordsText) {
                    pinnedCoordsText.textContent = currentPinCoords.lat.toFixed(6) + ", " + currentPinCoords.lng.toFixed(6);
                }
                if (mapLocationPreview) {
                    mapLocationPreview.style.display = "flex";
                }

                // Auto-fill address if empty or shorter
                const addrInput = document.getElementById("address");
                if (addrInput && (!addrInput.value.trim() || addrInput.value.length < 10) && currentPinAddress) {
                    addrInput.value = currentPinAddress;
                    setFieldState("address", true);
                }

                // If details contain state/city/pincode, synchronize
                const d = currentPinCoords.details || {};
                const pinSt = d.state || "";
                const pinCity = d.city || d.town || d.district || d.county || "";
                const pinPostcode = d.postcode || "";

                if (pinPostcode && /^\d{6}$/.test(pinPostcode)) {
                    const pinInput = document.getElementById("pincode");
                    if (pinInput && !pinInput.value) {
                        pinInput.value = pinPostcode;
                        setFieldState("pincode", true);
                    }
                }

                if (pinSt && stateSelect) {
                    for (let i = 0; i < stateSelect.options.length; i++) {
                        if (stateSelect.options[i].value.toLowerCase() === pinSt.toLowerCase()) {
                            stateSelect.selectedIndex = i;
                            loadCitiesForState(stateSelect.value, pinCity);
                            setFieldState("state", true);
                            break;
                        }
                    }
                }

                mapModal.classList.remove("open");
                recalculateCompletion();
            });
        }

        if (btnClearMapPin) {
            btnClearMapPin.addEventListener("click", function() {
                latInput.value = "";
                lngInput.value = "";
                if (mapLocationPreview) mapLocationPreview.style.display = "none";
                currentPinCoords = null;
                recalculateCompletion();
            });
        }

        // -------------------------------------------------------------
        // Bank Details Synchronization
        // -------------------------------------------------------------
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
            }
        }

        function syncBankDetails() {
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '';
            const bName = document.getElementById('bankName')?.value.trim() || '';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '';

            // Uppercase IFSC
            const ifscInput = document.getElementById('bankIfsc');
            if (ifscInput && ifscInput.value !== ifsc) ifscInput.value = ifsc;

            // Bank Account match check
            if (acc && confirmAcc && acc !== confirmAcc) {
                setFieldState("confirmAccountNumber", false, "Bank account numbers do not match.");
            } else {
                setFieldState("confirmAccountNumber", true);
            }

            // IFSC format check
            if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                setFieldState("bankIfsc", false, "Invalid IFSC format (e.g. HDFC0001234, 11 alphanumeric characters).");
            } else if (ifsc) {
                setFieldState("bankIfsc", true);
            }

            // Serialize into hidden field
            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                }
            }
        }

        // -------------------------------------------------------------
        // Accurate 17-Milestone Profile Completion Calculation
        // Formula: (Number of valid, completed required fields / 17) * 100
        // -------------------------------------------------------------
        const REQUIRED_MILESTONES = [
            { id: "photo", label: "0. Profile Photo", check: () => "${investor.profilePhoto}" !== "" || (document.getElementById('profilePhotoInput')?.files?.length > 0) },
            { id: "fullName", label: "1.1 Full Name", check: () => document.getElementById("fullName")?.value.trim().length >= 2 },
            { id: "designation", label: "1.2 Role / Designation", check: () => document.getElementById("designation")?.value.trim().length >= 2 },
            { id: "companyName", label: "1.3 Business / Fund Name", check: () => document.getElementById("companyName")?.value.trim().length >= 2 },
            { id: "credentialNumber", label: "1.4 SEBI / PAN ID", check: () => document.getElementById("credentialNumber")?.value.trim().length >= 5 },
            { id: "phone", label: "1.5 Mobile Phone", check: () => /^[6-9]\d{9}$/.test(document.getElementById("phone")?.value.trim() || "") },
            { id: "state", label: "2.2 State / UT", check: () => (document.getElementById("stateSelect")?.value || "").trim().length > 0 },
            { id: "city", label: "2.3 City / District", check: () => (document.getElementById("cityHidden")?.value || "").trim().length > 0 && document.getElementById("cityHidden")?.value !== "Other" },
            { id: "pincode", label: "2.4 Pincode", check: () => /^[1-9][0-9]{5}$/.test(document.getElementById("pincode")?.value.trim() || "") },
            { id: "address", label: "2.5 Street Address", check: () => document.getElementById("address")?.value.trim().length >= 3 },
            { id: "categoriesOffered", label: "3.1 Target Sectors", check: () => document.getElementById("categoriesOffered")?.value.trim().length >= 2 },
            { id: "audience", label: "3.2 Who I Fund", check: () => document.getElementById("audience")?.value.trim().length >= 2 },
            { id: "ticketMode", label: "3.3 Investment Stage", check: () => (document.getElementById("ticketMode")?.value || "").trim().length > 0 },
            { id: "typicalPrice", label: "3.4 Typical Cheque Size", check: () => {
                const val = parseFloat(document.getElementById("typicalPrice")?.value);
                return !isNaN(val) && val >= 1000;
            }},
            { id: "openDays", label: "4.1 Available Days", check: () => document.getElementById("openDays")?.value.trim().length >= 2 },
            { id: "openTime", label: "4.2 Meeting Hours", check: () => {
                const o = document.getElementById("openTime")?.value;
                const c = document.getElementById("closeTime")?.value;
                return o && c && o < c;
            }},
            { id: "bio", label: "5.1 Profile Bio", check: () => document.getElementById("bio")?.value.trim().length >= 15 }
        ];

        function recalculateCompletion() {
            let validCount = 0;
            const missing = [];

            REQUIRED_MILESTONES.forEach(m => {
                if (m.check()) {
                    validCount++;
                } else {
                    missing.push(m);
                }
            });

            const total = REQUIRED_MILESTONES.length; // 17
            const pct = Math.min(100, Math.round((validCount / total) * 100));

            // Update Progress Bar & Text
            const pctText = document.getElementById("pctText");
            const progressBarFill = document.getElementById("progressBarFill");
            const counterText = document.getElementById("milestoneCounterText");
            const verificationBtn = document.getElementById("btnSubmitVerification");

            if (pctText) pctText.textContent = pct + "%";
            if (progressBarFill) progressBarFill.style.width = pct + "%";
            if (counterText) counterText.textContent = validCount + " of " + total + " milestones completed (" + pct + "%)";

            // Update Missing Tags
            const missingContainer = document.getElementById("missingTagsContainer");
            const missingList = document.getElementById("missingTagsList");
            const missingCount = document.getElementById("missingCountText");

            if (missingCount) missingCount.textContent = missing.length;

            if (missingList) {
                missingList.innerHTML = "";
                if (missing.length === 0) {
                    missingList.innerHTML = '<span style="color:var(--success); font-weight:700; font-size:0.85rem;"><i class="bi bi-check-circle-fill"></i> All 17 required milestones complete! Ready for verification.</span>';
                } else {
                    missing.forEach(m => {
                        const pill = document.createElement("span");
                        pill.className = "missing-tag-pill";
                        pill.innerHTML = '<i class="bi bi-circle"></i> ' + m.label;
                        pill.addEventListener("click", () => {
                            const target = document.getElementById(m.id) || document.getElementById("card-" + m.id);
                            if (target) {
                                target.scrollIntoView({ behavior: "smooth", block: "center" });
                                if (target.focus) target.focus();
                            }
                        });
                        missingList.appendChild(pill);
                    });
                }
            }

            // Verification Button Enable/Disable
            if (verificationBtn && "${investor.partnerProfileStatus}" !== "PENDING_ADMIN_APPROVAL") {
                verificationBtn.disabled = (pct < 100);
            }
        }

        // -------------------------------------------------------------
        // Comprehensive Form Submission & Inline Validation
        // -------------------------------------------------------------
        function validateAllFields(showErrors) {
            let isValid = true;
            let firstInvalidEl = null;

            // 0. Photo Check
            const hasPhoto = "${investor.profilePhoto}" !== "" || (document.getElementById('profilePhotoInput')?.files?.length > 0);
            if (!hasPhoto) {
                if (showErrors) setFieldState("photo", false, "Please upload a professional profile headshot photo.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("card-photo");
            } else {
                setFieldState("photo", true);
            }

            // 1. Full Name
            const nameVal = document.getElementById("fullName").value.trim();
            if (nameVal.length < 2) {
                if (showErrors) setFieldState("fullName", false, "Please enter your full legal name (minimum 2 characters).");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("fullName");
            } else {
                setFieldState("fullName", true);
            }

            // 2. Designation
            const desigVal = document.getElementById("designation").value.trim();
            if (desigVal.length < 2) {
                if (showErrors) setFieldState("designation", false, "Please enter your role or designation.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("designation");
            } else {
                setFieldState("designation", true);
            }

            // 3. Company Name
            const compVal = document.getElementById("companyName").value.trim();
            if (compVal.length < 2) {
                if (showErrors) setFieldState("companyName", false, "Please enter your firm or investment entity name.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("companyName");
            } else {
                setFieldState("companyName", true);
            }

            // 4. Credential (PAN / SEBI)
            const credVal = document.getElementById("credentialNumber").value.trim();
            if (credVal.length < 5) {
                if (showErrors) setFieldState("credentialNumber", false, "Please enter a valid SEBI Registration or 10-character PAN ID.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("credentialNumber");
            } else {
                setFieldState("credentialNumber", true);
            }

            // 5. Phone
            const phoneVal = document.getElementById("phone").value.trim();
            if (!/^[6-9]\d{9}$/.test(phoneVal)) {
                if (showErrors) setFieldState("phone", false, "Please enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("phone");
            } else {
                setFieldState("phone", true);
            }

            // 6. WhatsApp (Optional, but if filled must be 10 digits)
            const waVal = document.getElementById("whatsappNumber").value.trim();
            if (waVal && !/^[6-9]\d{9}$/.test(waVal)) {
                if (showErrors) setFieldState("whatsappNumber", false, "WhatsApp number must be 10 digits starting with 6, 7, 8, or 9.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("whatsappNumber");
            } else {
                setFieldState("whatsappNumber", true);
            }

            // 7. State
            const stateVal = document.getElementById("stateSelect").value.trim();
            if (!stateVal) {
                if (showErrors) setFieldState("state", false, "Please select your state or union territory.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("stateSelect");
            } else {
                setFieldState("state", true);
            }

            // 8. City
            const cityVal = (document.getElementById("cityHidden").value || "").trim();
            if (!cityVal || cityVal === "Other") {
                if (showErrors) setFieldState("city", false, "Please select or enter your city/district.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("citySelect");
            } else {
                setFieldState("city", true);
            }

            // 9. Pincode
            const pinVal = document.getElementById("pincode").value.trim();
            if (!/^[1-9][0-9]{5}$/.test(pinVal)) {
                if (showErrors) setFieldState("pincode", false, "Enter a valid 6-digit postal pincode.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("pincode");
            } else {
                setFieldState("pincode", true);
            }

            // 10. Street Address
            const addrVal = document.getElementById("address").value.trim();
            if (addrVal.length < 3) {
                if (showErrors) setFieldState("address", false, "Please enter your office street address or landmark (min 3 characters).");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("address");
            } else {
                setFieldState("address", true);
            }

            // 11. Sectors
            const secVal = document.getElementById("categoriesOffered").value.trim();
            if (secVal.length < 2) {
                if (showErrors) setFieldState("categoriesOffered", false, "Please enter your target investment sectors.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("categoriesOffered");
            } else {
                setFieldState("categoriesOffered", true);
            }

            // 12. Audience
            const audVal = document.getElementById("audience").value.trim();
            if (audVal.length < 2) {
                if (showErrors) setFieldState("audience", false, "Please specify the startup profiles you fund.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("audience");
            } else {
                setFieldState("audience", true);
            }

            // 13. Investment Stage
            const stageVal = document.getElementById("ticketMode").value.trim();
            if (!stageVal) {
                if (showErrors) setFieldState("ticketMode", false, "Please select an investment stage.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("ticketMode");
            } else {
                setFieldState("ticketMode", true);
            }

            // 14. Typical Cheque Size
            const chequeVal = parseFloat(document.getElementById("typicalPrice").value);
            if (isNaN(chequeVal) || chequeVal < 1000) {
                if (showErrors) setFieldState("typicalPrice", false, "Please enter a valid typical cheque size (min ₹1,000).");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("typicalPrice");
            } else {
                setFieldState("typicalPrice", true);
            }

            // 15. Open Days
            const daysVal = document.getElementById("openDays").value.trim();
            if (daysVal.length < 2) {
                if (showErrors) setFieldState("openDays", false, "Please specify your available days for founder pitch calls.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("openDays");
            } else {
                setFieldState("openDays", true);
            }

            // 16. Hours
            const openT = document.getElementById("openTime").value;
            const closeT = document.getElementById("closeTime").value;
            if (!openT) {
                if (showErrors) setFieldState("openTime", false, "Please select availability start time.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("openTime");
            } else {
                setFieldState("openTime", true);
            }

            if (!closeT || closeT <= openT) {
                if (showErrors) setFieldState("closeTime", false, "Availability end time must be after start time.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("closeTime");
            } else {
                setFieldState("closeTime", true);
            }

            // 17. Bio
            const bioVal = document.getElementById("bio").value.trim();
            if (bioVal.length < 15) {
                if (showErrors) setFieldState("bio", false, "Please provide an introductory bio and investment focus (minimum 15 characters).");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("bio");
            } else {
                setFieldState("bio", true);
            }

            // Optional Bank validation
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();

            if (acc && confirmAcc && acc !== confirmAcc) {
                if (showErrors) setFieldState("confirmAccountNumber", false, "Bank account numbers do not match.");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("confirmAccountNumber");
            }

            if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                if (showErrors) setFieldState("bankIfsc", false, "Invalid IFSC format (e.g. SBIN0001234, 11 alphanumeric characters).");
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = document.getElementById("bankIfsc");
            }

            return { isValid, firstInvalidEl };
        }

        function triggerProfileSubmit() {
            const form = document.getElementById("profileForm");
            if (!form) return;

            syncBankDetails();
            const res = validateAllFields(true);

            if (!res.isValid) {
                if (res.firstInvalidEl) {
                    res.firstInvalidEl.scrollIntoView({ behavior: "smooth", block: "center" });
                    if (res.firstInvalidEl.focus) res.firstInvalidEl.focus();
                }
                return;
            }

            form.submit();
        }

        // -------------------------------------------------------------
        // Document Initialization
        // -------------------------------------------------------------
        document.addEventListener("DOMContentLoaded", function() {
            initStates();
            parseExistingBankDetails();

            // Wire real-time change listeners to recalculate completion
            const form = document.getElementById("profileForm");
            if (form) {
                form.querySelectorAll("input, select, textarea").forEach(el => {
                    el.addEventListener("input", function() {
                        recalculateCompletion();
                    });
                    el.addEventListener("change", function() {
                        recalculateCompletion();
                    });
                    el.addEventListener("blur", function() {
                        validateAllFields(false);
                    });
                });

                // Bank details listeners
                ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                    const el = document.getElementById(id);
                    if (el) {
                        el.addEventListener('input', syncBankDetails);
                        el.addEventListener('blur', syncBankDetails);
                    }
                });

                // Form submit event handler
                form.addEventListener("submit", function(e) {
                    syncBankDetails();
                    const res = validateAllFields(true);
                    if (!res.isValid) {
                        e.preventDefault();
                        if (res.firstInvalidEl) {
                            res.firstInvalidEl.scrollIntoView({ behavior: "smooth", block: "center" });
                            if (res.firstInvalidEl.focus) res.firstInvalidEl.focus();
                        }
                    }
                });
            }

            // Initial calculation
            recalculateCompletion();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
