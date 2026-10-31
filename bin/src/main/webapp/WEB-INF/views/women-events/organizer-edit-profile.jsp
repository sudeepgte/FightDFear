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
    <title>Complete Organizer Profile — Fight D Fear</title>

    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
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
            --border-focus: #F43F5E;
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

        /* Top Sticky Header */
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
            gap: 12px;
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
            max-width: 1280px;
            margin: 20px auto 50px;
            padding: 0 clamp(16px, 2.5vw, 32px);
            box-sizing: border-box;
        }

        /* Profile Progress Card */
        .profile-progress-card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 20px 24px;
            margin-bottom: 20px;
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
            padding: 3px 10px;
            border-radius: 999px;
        }

        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-changes { background: var(--warning-bg); color: var(--warning); border: 1px solid #FED7AA; }
        .badge-approved { background: var(--success-bg); color: var(--success); }
        .badge-rejected { background: var(--error-bg); color: var(--error); }

        .progress-bar-container {
            height: 9px;
            background: #E2E8F0;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 5px;
            width: ${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%;
            transition: width 0.3s ease;
        }

        .progress-guidance {
            font-size: 0.88rem;
            color: var(--text-gray);
            line-height: 1.45;
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
            gap: 4px;
            font-size: 0.76rem;
            font-weight: 600;
            background: #FFF7ED;
            color: #C2410C;
            border: 1px solid #FED7AA;
            border-radius: 6px;
            padding: 4px 10px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .missing-chip:hover {
            background: #FFEDD5;
            border-color: #FB923C;
        }

        /* Live Preview Card */
        .org-preview-card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.03);
        }

        .org-preview-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }

        .org-preview-card h3 {
            font-size: 0.95rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .preview-hint {
            font-size: 0.8rem;
            color: var(--text-gray);
        }

        .org-preview-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px 18px;
        }

        .org-preview-item label {
            display: block;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-gray);
            margin-bottom: 2px;
        }

        .org-preview-item span {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--navy);
            word-break: break-word;
        }

        .org-preview-bio {
            margin-top: 12px;
            padding-top: 10px;
            border-top: 1px solid #F1F5F9;
        }

        @media (max-width: 900px) {
            .org-preview-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 540px) {
            .org-preview-grid { grid-template-columns: 1fr; }
        }

        /* Banner alerts */
        .feedback-banner {
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 18px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .banner-warning { background: #FFFBEB; border: 1px solid #FCD34D; color: #92400E; }
        .banner-warning i { font-size: 1.3rem; color: #D97706; }
        .banner-success { background: var(--success-bg); border: 1px solid #BBF7D0; color: #166534; }
        .banner-success i { font-size: 1.3rem; color: var(--success); }
        .banner-error { background: var(--error-bg); border: 1px solid #FECACA; color: #991B1B; }
        .banner-error i { font-size: 1.3rem; color: var(--error); }

        .banner-content h4 {
            font-size: 0.92rem;
            font-weight: 800;
            margin-bottom: 3px;
        }

        .banner-content p {
            font-size: 0.85rem;
            line-height: 1.4;
        }

        .submit-bar { margin-bottom: 20px; }

        .btn-submit-verification {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--primary-hover);
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
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
            box-sizing: border-box;
        }

        .section-header {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-header i {
            color: var(--primary);
            font-size: 1.25rem;
        }

        .section-desc {
            font-size: 0.84rem;
            color: var(--text-gray);
            margin-bottom: 20px;
        }

        /* 2-column Grid for Form Fields */
        .form-grid-2 {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 24px;
            width: 100%;
            box-sizing: border-box;
        }

        .form-group {
            min-width: 0;
            max-width: 100%;
            box-sizing: border-box;
            margin-bottom: 4px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            font-size: 0.84rem;
            font-weight: 700;
            margin-bottom: 6px;
            color: var(--navy);
        }

        .form-group label .req {
            color: var(--primary);
            margin-left: 2px;
            font-weight: 800;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            height: 44px;
            padding: 0 14px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.92rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }

        .form-textarea {
            height: auto;
            min-height: 100px;
            padding: 12px 14px;
            resize: vertical;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid, .form-select.is-valid, .form-textarea.is-valid {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.12) !important;
        }

        .error-msg {
            display: none;
            color: var(--error);
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 5px;
            align-items: center;
            gap: 5px;
        }

        .error-msg.visible {
            display: flex;
        }

        .helper-text, .hint {
            font-size: 0.78rem;
            color: var(--text-gray);
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Chips Container */
        .chip-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 6px;
        }

        .chip-item {
            position: relative;
            cursor: pointer;
            user-select: none;
            border: 1.5px solid var(--border-color);
            border-radius: 8px;
            padding: 8px 14px;
            font-size: 0.84rem;
            font-weight: 600;
            color: #475569;
            background: #F8FAFC;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .chip-item:hover {
            border-color: #CBD5E1;
            background: #F1F5F9;
        }

        .chip-item input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .chip-item.active {
            background: var(--rose-soft);
            border-color: var(--primary);
            color: var(--primary);
            font-weight: 700;
        }

        .chip-item.active i {
            color: var(--primary);
        }

        /* Toggle switch */
        .toggle-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            margin-top: 10px;
        }

        .toggle-label {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--navy);
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
            transition: .25s;
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
            transition: .25s;
            border-radius: 50%;
        }

        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(22px); }

        /* Location Action Bar & Map Picker */
        .location-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #FFF1F2;
            border: 1px solid #FECDD3;
            border-radius: 12px;
            padding: 12px 18px;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .btn-map-picker {
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.84rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-map-picker:hover {
            background: var(--primary-hover);
        }

        /* Bank Subfields Card */
        .bank-subfields-card {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 16px 20px;
            margin-top: 12px;
        }

        /* Leaflet Map Picker Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .map-modal-card {
            background: #FFFFFF;
            border-radius: 18px;
            width: 100%;
            max-width: 780px;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: var(--shadow-float);
            animation: modalPop 0.2s ease-out;
        }

        @keyframes modalPop {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 22px;
            border-bottom: 1px solid var(--border-color);
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
            font-size: 1.5rem;
            color: var(--text-gray);
            cursor: pointer;
            line-height: 1;
            padding: 0;
        }

        .btn-close-modal:hover { color: var(--navy); }

        .map-search-bar {
            padding: 12px 20px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            gap: 8px;
            position: relative;
        }

        .map-search-input {
            flex: 1;
            height: 38px;
            padding: 0 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.88rem;
        }

        .map-search-input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .map-suggestions-box {
            position: absolute;
            top: 56px;
            left: 20px;
            right: 20px;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: var(--shadow-float);
            max-height: 180px;
            overflow-y: auto;
            z-index: 1050;
            display: none;
        }

        .map-suggestion-item {
            padding: 8px 12px;
            font-size: 0.82rem;
            cursor: pointer;
            border-bottom: 1px solid #F1F5F9;
        }

        .map-suggestion-item:hover {
            background: #F8FAFC;
            color: var(--primary);
        }

        #mapContainer {
            width: 100%;
            height: 380px;
            background: #E2E8F0;
        }

        .map-modal-footer {
            padding: 14px 20px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            background: #FFFFFF;
        }

        .map-selected-address-box {
            font-size: 0.82rem;
            color: var(--text-gray);
            flex: 1;
            min-width: 220px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .map-modal-actions {
            display: flex;
            gap: 8px;
        }

        /* Review Modal */
        .review-modal-card {
            background: #FFFFFF;
            border-radius: 18px;
            width: 100%;
            max-width: 650px;
            max-height: 85vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: var(--shadow-float);
            animation: modalPop 0.2s ease-out;
        }

        .review-modal-body {
            padding: 20px 24px;
            overflow-y: auto;
        }

        .review-summary-banner {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 16px;
        }

        .rev-avatar {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            object-fit: cover;
            background: var(--rose-soft);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary);
            flex-shrink: 0;
            overflow: hidden;
        }

        .rev-details h4 {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 2px;
        }

        .rev-details p {
            font-size: 0.82rem;
            color: var(--text-gray);
        }

        /* Bottom Action Buttons */
        .bottom-actions {
            margin-top: 28px;
            display: flex;
            gap: 14px;
        }

        .btn-bottom-save {
            flex: 1;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
        }

        /* Media & Document Upload Styling */
        .upload-picker-box {
            display: flex;
            align-items: center;
            gap: 16px;
            background: #F8FAFC;
            border: 1.5px dashed var(--border-color);
            border-radius: 14px;
            padding: 16px 18px;
            margin-top: 6px;
            transition: border-color 0.2s, background 0.2s;
        }
        .upload-picker-box:hover {
            border-color: var(--primary);
            background: #FFF5F7;
        }
        .photo-preview-circle {
            width: 76px;
            height: 76px;
            border-radius: 50%;
            overflow: hidden;
            background: var(--rose-light);
            border: 3px solid #fff;
            box-shadow: 0 4px 12px rgba(225, 29, 72, 0.15);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .photo-preview-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .logo-preview-box {
            width: 76px;
            height: 76px;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            border: 2px solid var(--border-color);
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4px;
        }
        .logo-preview-box img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        .photo-fallback {
            font-size: 32px;
            color: var(--primary);
        }
        .upload-meta {
            flex: 1;
            min-width: 0;
        }
        .upload-btn-row {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 4px;
        }
        .btn-choose-file {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: var(--primary);
            color: #fff;
            border-radius: 8px;
            font-size: 0.84rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-choose-file:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }
        .upload-file-status {
            font-size: 0.82rem;
            color: var(--navy);
            font-weight: 600;
        }
        .doc-status-wrap {
            margin-top: 8px;
            padding: 10px 14px;
            border-radius: 10px;
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
        }
        .doc-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
        }
        .doc-badge.uploaded {
            background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0;
        }
        .doc-badge.selected {
            background: #EFF6FF; color: #1D4ED8; border: 1px solid #BFDBFE;
        }
        .doc-badge.not-uploaded {
            background: #F1F5F9; color: #64748B; border: 1px solid #CBD5E1;
        }
        .doc-link {
            color: var(--primary);
            font-weight: 700;
            font-size: 0.84rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .doc-link:hover {
            text-decoration: underline;
        }
        .gallery-grid-preview {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(105px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }
        .gallery-thumb-wrap {
            position: relative;
            width: 100%;
            aspect-ratio: 4/3;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            background: #F8FAFC;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .gallery-thumb-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .gallery-del-btn {
            position: absolute;
            top: 4px;
            right: 4px;
            background: rgba(220, 38, 38, 0.9);
            color: #fff;
            border: none;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.72rem;
        }
        .gallery-del-btn:hover {
            background: #b91c1c;
        }

        /* Responsive Breakpoints */
        @media (max-width: 768px) {
            .form-grid-2 { grid-template-columns: 1fr; }
            .bottom-actions { flex-direction: column; }
            #mapContainer { height: 280px; }
            .location-action-bar { flex-direction: column; align-items: flex-start; }
            .btn-map-picker { width: 100%; justify-content: center; }
            .upload-picker-box { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="app-header">
        <div style="display: flex; align-items: center; gap: 12px;">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" style="color: var(--navy); font-size: 1.25rem; text-decoration: none;" title="Back to Dashboard">
                <i class="bi bi-arrow-left"></i>
            </a>
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="header-brand">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
                <span>Event Host Studio</span>
                <span class="portal-badge">Profile Setup</span>
            </a>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="btn-skip">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <button type="button" class="btn-header-draft" onclick="saveProfileDraft()">
                <i class="bi bi-floppy"></i> Save Draft
            </button>
            <button type="button" class="btn-primary" onclick="openReviewModal()">
                <i class="bi bi-send-check"></i> Submit for Verification
            </button>
        </div>
    </header>

    <main class="main-container">

        <c:set var="statusStr" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus : 'PROFILE_INCOMPLETE'}"/>

        <!-- Top Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <div class="progress-title-wrap">
                    <span class="progress-title">Organizer Profile Completion</span>
                    <span class="progress-pct" id="pctText">${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%</span>
                </div>
                <c:choose>
                    <c:when test="${statusStr eq 'APPROVED'}">
                        <span class="status-badge badge-approved"><i class="bi bi-check-circle-fill me-1"></i> Approved</span>
                    </c:when>
                    <c:when test="${statusStr eq 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes"><i class="bi bi-exclamation-triangle-fill me-1"></i> Changes Requested</span>
                    </c:when>
                    <c:when test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending"><i class="bi bi-clock-history me-1"></i> Under Review</span>
                    </c:when>
                    <c:when test="${statusStr eq 'REJECTED'}">
                        <span class="status-badge badge-rejected"><i class="bi bi-x-circle-fill me-1"></i> Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered"><i class="bi bi-pencil-square me-1"></i> Incomplete Profile</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="progress-bar-container">
                <div class="progress-bar-fill" id="progressBarFill" style="width: ${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%;"></div>
            </div>

            <p class="progress-guidance" id="progressGuidance">
                <c:choose>
                    <c:when test="${not empty nextStepGuidance}">${nextStepGuidance}</c:when>
                    <c:otherwise>Complete all mandatory profile fields across the sections to submit your application for Admin Verification.</c:otherwise>
                </c:choose>
            </p>

            <div class="missing-list" id="missingListContainer">
                <c:forEach var="miss" items="${missingItems}">
                    <span class="missing-chip" onclick="focusMissingItem('${miss}')"><i class="bi bi-exclamation-circle"></i> <c:out value="${miss}"/></span>
                </c:forEach>
            </div>
        </div>

        <!-- Live Application Preview Card -->
        <div class="org-preview-card" id="orgPreviewCard">
            <div class="org-preview-card-header">
                <h3><i class="bi bi-person-badge" style="color:var(--primary);"></i> Live Application Summary</h3>
                <span class="preview-hint">Real-time attendee &amp; admin verification view</span>
            </div>
            <div class="org-preview-grid">
                <div class="org-preview-item">
                    <label>Full Name</label>
                    <span id="pv-fullName">${not empty host.fullName ? host.fullName : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Official Phone</label>
                    <span id="pv-phone">${not empty host.phone ? host.phone : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Organization Name</label>
                    <span id="pv-organizerName">${not empty host.organizerName ? host.organizerName : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Entity Type</label>
                    <span id="pv-organizerType">${not empty host.organizerType ? host.organizerType : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Location Base</label>
                    <span id="pv-location">${not empty host.city ? host.city : ''}${not empty host.state ? (not empty host.city ? ', ' : '') += host.state : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Experience</label>
                    <span id="pv-years">${host.yearsExperience != null ? host.yearsExperience += ' Years' : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Categories</label>
                    <span id="pv-categories">${not empty host.eventCategories ? host.eventCategories : '—'}</span>
                </div>
                <div class="org-preview-item">
                    <label>Typical Offering</label>
                    <span id="pv-sessionOffering">${not empty host.sessionMode ? host.sessionMode : 'In-Person'} (${host.typicalPrice != null ? '₹' += host.typicalPrice : '₹0'})</span>
                </div>
            </div>
            <div class="org-preview-bio">
                <div class="org-preview-item">
                    <label>Mission &amp; Event Background Bio</label>
                    <span id="pv-bio">${not empty host.hostBio ? host.hostBio : 'No bio added yet.'}</span>
                </div>
            </div>
        </div>

        <!-- Success Message from Redirect -->
        <c:if test="${not empty success}">
            <div class="feedback-banner banner-success">
                <i class="bi bi-check-circle-fill"></i>
                <div class="banner-content">
                    <h4>Success</h4>
                    <p><c:out value="${success}"/></p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="feedback-banner banner-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="banner-content">
                    <h4>Attention</h4>
                    <p><c:out value="${error}"/></p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty host.rejectionReason}">
            <div class="feedback-banner banner-error">
                <i class="bi bi-exclamation-circle-fill"></i>
                <div class="banner-content">
                    <h4>Admin Rejection Feedback</h4>
                    <p><c:out value="${host.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty host.changesRequestedNote}">
            <div class="feedback-banner banner-warning">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="banner-content">
                    <h4>Changes Requested by Admin</h4>
                    <p><c:out value="${host.changesRequestedNote}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Top Live Inline Notice Banner -->
        <div id="liveAlertBanner" class="feedback-banner" style="display:none;"></div>

        <!-- Quick Top Action Bar -->
        <div class="submit-bar">
            <button type="button" id="btnSubmitVerificationTop" class="btn-submit-verification" onclick="openReviewModal()">
                <c:choose>
                    <c:when test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">
                        <i class="bi bi-clock-history"></i> Profile Under Admin Review — Open Organizer Dashboard <i class="bi bi-arrow-right-short"></i>
                    </c:when>
                    <c:when test="${statusStr eq 'APPROVED'}">
                        <i class="bi bi-speedometer2"></i> Host Account Approved — Go to Dashboard <i class="bi bi-arrow-right-short"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-send-check-fill"></i> Submit Host Profile for Verification &amp; Open Dashboard
                    </c:otherwise>
                </c:choose>
            </button>
        </div>

        <!-- Main Form -->
        <form id="hostProfileForm" method="POST" action="${pageContext.request.contextPath}/women-events/organizer/profile-completion" enctype="multipart/form-data" onsubmit="handleFormSubmit(event)">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="action" id="formAction" value="saveDraft"/>
            <input type="hidden" name="latitude" id="inputLatitude" value="<c:out value='${host.latitude}'/>"/>
            <input type="hidden" name="longitude" id="inputLongitude" value="<c:out value='${host.longitude}'/>"/>
            <input type="hidden" name="city" id="inputCity" value="<c:out value='${host.city}'/>"/>
            <input type="hidden" name="bankDetails" id="bankDetails" value="<c:out value='${host.bankDetails}'/>"/>

            <!-- SECTION 1: Host Identity & Organization -->
            <div class="section-card" id="sec-identity">
                <div class="section-header">
                    <i class="bi bi-building-check"></i>
                    <span>1. Host Identity &amp; Organization Details</span>
                </div>
                <p class="section-desc">Provide your primary organizer credentials and official contact details.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="fullName">1.1 Full Name <span class="req">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-input" value="<c:out value='${host.fullName}'/>" placeholder="Your full name" required maxlength="100">
                        <div class="error-msg" id="err-fullName"><i class="bi bi-exclamation-circle-fill"></i> Full name is required (at least 2 characters).</div>
                    </div>

                    <div class="form-group">
                        <label for="organizerType">1.2 Organization Type <span class="req">*</span></label>
                        <select id="organizerType" name="organizerType" class="form-select" required>
                            <option value="">-- Select Organization Type --</option>
                            <option value="NGO" ${host.organizerType eq 'NGO' ? 'selected' : ''}>NGO / Non-Profit</option>
                            <option value="Company" ${host.organizerType eq 'Company' ? 'selected' : ''}>Company / Private Limited</option>
                            <option value="Educational Institution" ${host.organizerType eq 'Educational Institution' ? 'selected' : ''}>Educational Institution</option>
                            <option value="Government Department" ${host.organizerType eq 'Government Department' ? 'selected' : ''}>Government Department</option>
                            <option value="Community Organization" ${host.organizerType eq 'Community Organization' ? 'selected' : ''}>Community Organization</option>
                            <option value="Women Self Help Group" ${host.organizerType eq 'Women Self Help Group' ? 'selected' : ''}>Women Self Help Group (SHG)</option>
                            <option value="Startup" ${host.organizerType eq 'Startup' ? 'selected' : ''}>Startup / Social Enterprise</option>
                            <option value="Fitness Organization" ${host.organizerType eq 'Fitness Organization' ? 'selected' : ''}>Fitness / Wellness Organization</option>
                            <option value="Individual Organizer" ${host.organizerType eq 'Individual Organizer' ? 'selected' : ''}>Individual Organizer</option>
                        </select>
                        <div class="error-msg" id="err-organizerType"><i class="bi bi-exclamation-circle-fill"></i> Please select a valid organization type.</div>
                    </div>

                    <div class="form-group">
                        <label for="phone">1.3 Official Phone Number <span class="req">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-input" value="<c:out value='${host.phone}'/>" placeholder="10-digit official mobile number" maxlength="10" inputmode="numeric" required>
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit mobile number.</div>
                    </div>

                    <div class="form-group">
                        <label for="organizerName">1.4 Organization / Entity Name <span class="req">*</span></label>
                        <input type="text" id="organizerName" name="organizerName" class="form-input" value="<c:out value='${host.organizerName}'/>" placeholder="e.g. SheLeads Foundation" required maxlength="120">
                        <div class="error-msg" id="err-organizerName"><i class="bi bi-exclamation-circle-fill"></i> Organization name is required (minimum 2 characters).</div>
                    </div>

                    <div class="form-group">
                        <label for="whatsappNumber">1.5 WhatsApp Contact Number</label>
                        <input type="tel" id="whatsappNumber" name="whatsappNumber" class="form-input" value="<c:out value='${host.whatsappNumber}'/>" placeholder="10-digit WhatsApp number (Optional)" maxlength="10" inputmode="numeric">
                        <div class="error-msg" id="err-whatsappNumber"><i class="bi bi-exclamation-circle-fill"></i> WhatsApp number must be 10 digits if provided.</div>
                    </div>

                    <div class="form-group">
                        <label for="credentialNumber">1.6 Reg / GST / NGO Credential Number <span class="req">*</span></label>
                        <input type="text" id="credentialNumber" name="credentialNumber" class="form-input" value="<c:out value='${host.credentialNumber}'/>" placeholder="CIN, GSTIN, NGO Darpan ID or Reg. No." required maxlength="80">
                        <div class="error-msg" id="err-credentialNumber"><i class="bi bi-exclamation-circle-fill"></i> Registration / Credential identification number is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="yearsExperience">1.7 Years of Experience <span class="req">*</span></label>
                        <input type="number" id="yearsExperience" name="yearsExperience" class="form-input" value="${host.yearsExperience != null ? host.yearsExperience : 1}" min="0" max="50" required>
                        <div class="error-msg" id="err-yearsExperience"><i class="bi bi-exclamation-circle-fill"></i> Experience must be between 0 and 50 years.</div>
                    </div>

                    <div class="form-group">
                        <label for="eventsConducted">1.8 Previous Events Conducted</label>
                        <input type="number" id="eventsConducted" name="eventsConducted" class="form-input" value="${host.eventsConducted != null ? host.eventsConducted : 0}" min="0" placeholder="Number of events conducted">
                        <div class="helper-text"><i class="bi bi-info-circle"></i> Approximate count of workshops, events, or retreats held.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Location & Map Integration -->
            <div class="section-card" id="sec-location">
                <div class="section-header">
                    <i class="bi bi-geo-alt"></i>
                    <span>2. Venue Base &amp; Operational Location</span>
                </div>
                <p class="section-desc">Specify your primary headquarters, venue base, or operational city for event listings.</p>

                <div class="location-action-bar">
                    <div>
                        <span style="font-size: 0.9rem; font-weight: 700; color: var(--navy); display: block;">Pinpoint Venue via Interactive Map</span>
                        <span style="font-size: 0.8rem; color: var(--text-gray);">Search or drop a pin to auto-fill address, city, state, pincode, and coordinates</span>
                    </div>
                    <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                        <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                    </button>
                </div>

                <div class="form-group full">
                    <label for="officeAddress">2.1 Street Address / Venue Base <span class="req">*</span></label>
                    <input type="text" id="officeAddress" name="officeAddress" class="form-input" value="<c:out value='${host.officeAddress}'/>" placeholder="Building, venue name, street or landmark" required maxlength="255">
                    <div class="error-msg" id="err-officeAddress"><i class="bi bi-exclamation-circle-fill"></i> Street address is required (minimum 5 characters).</div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="countrySelect">2.2 Country <span class="req">*</span></label>
                        <select id="countrySelect" name="country" class="form-select">
                            <option value="India" selected>India</option>
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
                            2.3 State / UT <span class="req">*</span>
                            <span id="stateSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading...</span>
                        </label>
                        <select id="stateSelect" name="state" class="form-select" required>
                            <option value="">-- Select State / UT --</option>
                        </select>
                        <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> State is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="districtSelect">
                            2.4 City / District <span class="req">*</span>
                            <span id="districtSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading...</span>
                        </label>
                        <select id="districtSelect" class="form-select" required>
                            <option value="">-- Select State First --</option>
                        </select>
                        <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> City / District is required.</div>
                    </div>

                    <div class="form-group" id="customCityGroup" style="display:none;">
                        <label for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                        <input type="text" id="customCityInput" class="form-input" placeholder="Enter your city or town name" maxlength="60">
                        <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                    </div>

                    <div class="form-group">
                        <label for="pincode">2.5 Postal Pincode <span class="req">*</span></label>
                        <input type="text" id="pincode" name="pincode" class="form-input" value="<c:out value='${host.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" inputmode="numeric" required>
                        <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 6-digit postal pincode.</div>
                    </div>

                    <div class="form-group full">
                        <label for="mapsLocation">2.6 Google Maps Link (Auto-filled via Map Picker)</label>
                        <input type="url" id="mapsLocation" name="mapsLocation" class="form-input" value="<c:out value='${not empty host.website && host.website.contains(\"maps\") ? host.website : \"\"}'/>" placeholder="https://maps.google.com/?q=... or select via map above">
                        <div class="error-msg" id="err-mapsLocation"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid URL starting with http:// or https://</div>
                        <div class="helper-text"><i class="bi bi-check-circle"></i> Coordinates: <span id="coordsDisplay">${host.latitude != null ? host.latitude : '—'}, ${host.longitude != null ? host.longitude : '—'}</span></div>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Event Categories Offered -->
            <div class="section-card" id="sec-categories">
                <div class="section-header">
                    <i class="bi bi-tags"></i>
                    <span>3. Event Categories Offered <span class="req">*</span></span>
                </div>
                <p class="section-desc">Select the themes and categories of women-focused events you organize (at least 1 required).</p>

                <div class="chip-grid">
                    <c:forEach var="cat" items="Health & Wellness,Entrepreneurship & Career,Fitness & Sports,Education & Skills,Social & Community,Safety & Awareness,Arts & Culture,Financial Literacy,Motherhood & Parenting">
                        <label class="chip-item ${host.eventCategories != null && host.eventCategories.contains(cat) ? 'active' : ''}">
                            <input type="checkbox" name="eventCategories" class="cb-category" value="${cat}" ${host.eventCategories != null && host.eventCategories.contains(cat) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                            <i class="bi ${host.eventCategories != null && host.eventCategories.contains(cat) ? 'bi-check-circle-fill' : 'bi-circle'}"></i>
                            <span>${cat}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-eventCategories" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one event category.</div>
            </div>

            <!-- SECTION 4: Who I Serve & Private Sessions -->
            <div class="section-card" id="sec-audience">
                <div class="section-header">
                    <i class="bi bi-people"></i>
                    <span>4. Target Audience &amp; Session Modality</span>
                </div>
                <p class="section-desc">Select the attendee groups you primarily cater to (at least 1 required).</p>

                <div class="chip-grid">
                    <c:forEach var="aud" items="Women Only,College Girls,Working Professionals,Mothers & Homemakers,Senior Citizens,Entrepreneurs & Founders,Young Girls (Teens)">
                        <label class="chip-item ${host.audience != null && host.audience.contains(aud) ? 'active' : ''}">
                            <input type="checkbox" name="audience" class="cb-audience" value="${aud}" ${host.audience != null && host.audience.contains(aud) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                            <i class="bi ${host.audience != null && host.audience.contains(aud) ? 'bi-check-circle-fill' : 'bi-circle'}"></i>
                            <span>${aud}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-audience" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one target audience.</div>

                <div class="toggle-row">
                    <div>
                        <span class="toggle-label">Doorstep / On-Site Private Corporate &amp; Group Sessions</span>
                        <div style="font-size:0.78rem;color:var(--text-gray);margin-top:2px;">Offer on-premise workshops at colleges, corporate offices, or residential communities.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="doorService" name="doorService" value="true" ${host.doorService ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>
            </div>

            <!-- SECTION 5: Venue Amenities & Facilities -->
            <div class="section-card" id="sec-facilities">
                <div class="section-header">
                    <i class="bi bi-stars"></i>
                    <span>5. Venue Amenities &amp; Facilities</span>
                </div>
                <p class="section-desc">Select the facilities available at your venue for attendees.</p>

                <div class="chip-grid">
                    <c:forEach var="fac" items="Parking,Wi-Fi,Projector / Screen,Air Conditioned,Clean Restroom,Refreshments,First Aid Kit,Sound System,Wheelchair Accessible,CCTV & Security,Childcare Corner">
                        <label class="chip-item ${host.facilities != null && host.facilities.contains(fac) ? 'active' : ''}">
                            <input type="checkbox" name="facilities" class="cb-facility" value="${fac}" ${host.facilities != null && host.facilities.contains(fac) ? 'checked' : ''} onchange="toggleChipActive(this);">
                            <i class="bi ${host.facilities != null && host.facilities.contains(fac) ? 'bi-check-circle-fill' : 'bi-circle'}"></i>
                            <span>${fac}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- SECTION 6: Operating Hours & Schedule -->
            <div class="section-card" id="sec-schedule">
                <div class="section-header">
                    <i class="bi bi-calendar3"></i>
                    <span>6. Operating Days &amp; Schedule</span>
                </div>
                <p class="section-desc">Define your working schedule or preferred workshop days.</p>

                <div class="form-group full">
                    <label>6.1 Open Days <span class="req">*</span></label>
                    <div class="chip-grid">
                        <c:forEach var="day" items="Mon,Tue,Wed,Thu,Fri,Sat,Sun">
                            <label class="chip-item ${host.openDays != null && host.openDays.contains(day) ? 'active' : ''}">
                                <input type="checkbox" name="openDays" class="cb-day" value="${day}" ${host.openDays != null && host.openDays.contains(day) ? 'checked' : ''} onchange="toggleChipActive(this); recalculateProgress();">
                                <i class="bi ${host.openDays != null && host.openDays.contains(day) ? 'bi-check-circle-fill' : 'bi-circle'}"></i>
                                <span>${day}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="error-msg" id="err-openDays" style="margin-top: 10px;"><i class="bi bi-exclamation-circle-fill"></i> Please select at least one operating day.</div>
                </div>

                <div class="form-grid-2" style="margin-top: 16px;">
                    <div class="form-group">
                        <label for="openTime">6.2 Opening Time <span class="req">*</span></label>
                        <input type="time" id="openTime" name="openTime" class="form-input" value="${host.openTime != null ? host.openTime : '09:00'}" required>
                        <div class="error-msg" id="err-openTime"><i class="bi bi-exclamation-circle-fill"></i> Opening time is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="closeTime">6.3 Closing Time <span class="req">*</span></label>
                        <input type="time" id="closeTime" name="closeTime" class="form-input" value="${host.closeTime != null ? host.closeTime : '18:00'}" required>
                        <div class="error-msg" id="err-closeTime"><i class="bi bi-exclamation-circle-fill"></i> Closing time must be after opening time.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 7: About Organization / Mission Bio -->
            <div class="section-card" id="sec-bio">
                <div class="section-header">
                    <i class="bi bi-chat-square-quote"></i>
                    <span>7. About Organization &amp; Mission Bio</span>
                </div>
                <p class="section-desc">Share your organization's mission, background, and previous event experience with attendees.</p>

                <div class="form-group full">
                    <label for="hostBio">7.1 Mission &amp; Event Background Bio <span class="req">*</span></label>
                    <textarea id="hostBio" name="hostBio" class="form-textarea" rows="4" placeholder="Tell attendees about your organization, safety mission, previous events, and community impact..." required><c:out value="${host.hostBio}"/></textarea>
                    <div class="error-msg" id="err-hostBio"><i class="bi bi-exclamation-circle-fill"></i> Mission bio is required (minimum 10 characters).</div>
                    <div class="helper-text"><i class="bi bi-info-circle"></i> A thorough bio instills trust with women attendees and speeds up admin approval.</div>
                </div>
            </div>

            <!-- SECTION 8: Typical Event Offering & Pricing -->
            <div class="section-card" id="sec-offering">
                <div class="section-header">
                    <i class="bi bi-ticket-perforated"></i>
                    <span>8. Typical Event Offering &amp; Pricing</span>
                </div>
                <p class="section-desc">Establish your standard workshop/event parameters.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="sessionMode">8.1 Standard Session Mode <span class="req">*</span></label>
                        <select id="sessionMode" name="sessionMode" class="form-select" required>
                            <option value="In-Person" ${host.sessionMode eq 'In-Person' ? 'selected' : ''}>In-Person</option>
                            <option value="Virtual" ${host.sessionMode eq 'Virtual' ? 'selected' : ''}>Virtual / Online</option>
                            <option value="Hybrid" ${host.sessionMode eq 'Hybrid' ? 'selected' : ''}>Hybrid (In-Person + Online)</option>
                        </select>
                        <div class="error-msg" id="err-sessionMode"><i class="bi bi-exclamation-circle-fill"></i> Please select a valid session mode.</div>
                    </div>

                    <div class="form-group">
                        <label for="durationMinutes">8.2 Typical Duration (Minutes) <span class="req">*</span></label>
                        <input type="number" id="durationMinutes" name="durationMinutes" class="form-input" value="${host.durationMinutes != null ? host.durationMinutes : 60}" min="15" max="480" required>
                        <div class="error-msg" id="err-durationMinutes"><i class="bi bi-exclamation-circle-fill"></i> Typical duration must be at least 15 minutes.</div>
                    </div>

                    <div class="form-group full">
                        <label for="typicalPrice">8.3 Typical Ticket Price (₹, enter 0 for Free) <span class="req">*</span></label>
                        <input type="number" id="typicalPrice" name="typicalPrice" class="form-input" value="${host.typicalPrice != null ? host.typicalPrice : 0}" min="0" step="1" required>
                        <div class="error-msg" id="err-typicalPrice"><i class="bi bi-exclamation-circle-fill"></i> Ticket price cannot be negative.</div>
                        <div class="helper-text"><i class="bi bi-info-circle"></i> You can customize individual ticket tiers when publishing each event.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 9: Payout Details -->
            <div class="section-card" id="sec-payout">
                <div class="section-header">
                    <i class="bi bi-wallet2"></i>
                    <span>9. Payout &amp; Financial Settlement Details</span>
                </div>
                <p class="section-desc">Provide your banking or UPI details for ticket sales disbursement.</p>

                <div class="form-group full">
                    <label for="upiId">9.1 UPI ID (for instant settlement)</label>
                    <input type="text" id="upiId" name="upiId" class="form-input" value="<c:out value='${host.upiId}'/>" placeholder="organizer@upi or mobilenumber@paytm" maxlength="80">
                    <div class="error-msg" id="err-upiId"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid UPI handle (e.g. name@bank).</div>
                </div>

                <div class="form-group full">
                    <label style="display:flex;align-items:center;gap:6px;font-size:0.86rem;font-weight:700;">
                        <i class="bi bi-bank" style="color:var(--primary);"></i> 9.2 Bank Account Details
                    </label>

                    <div class="bank-subfields-card">
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label for="bankAccountHolder">Account Holder Name</label>
                                <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="e.g. SheLeads Trust or Signatory Name" maxlength="100">
                                <div class="error-msg" id="err-bankAccountHolder"><i class="bi bi-exclamation-circle-fill"></i> Enter account holder name.</div>
                            </div>

                            <div class="form-group">
                                <label for="bankName">Bank Name</label>
                                <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. State Bank of India, HDFC" maxlength="100">
                                <div class="error-msg" id="err-bankName"><i class="bi bi-exclamation-circle-fill"></i> Enter bank name.</div>
                            </div>

                            <div class="form-group">
                                <label for="bankAccountNumber">Account Number</label>
                                <input type="password" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Enter bank account number" maxlength="30" autocomplete="new-password" inputmode="numeric">
                                <div class="error-msg" id="err-bankAccountNumber"><i class="bi bi-exclamation-circle-fill"></i> Account number must be 9 to 18 digits.</div>
                            </div>

                            <div class="form-group">
                                <label for="bankConfirmAccountNumber">Confirm Account Number</label>
                                <input type="text" id="bankConfirmAccountNumber" class="form-input" placeholder="Re-enter bank account number" maxlength="30" inputmode="numeric">
                                <div class="error-msg" id="err-bankConfirmAccountNumber"><i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match.</div>
                            </div>

                            <div class="form-group">
                                <label for="bankIfsc">IFSC Code</label>
                                <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. SBIN0001234" maxlength="11" style="text-transform:uppercase;">
                                <div class="error-msg" id="err-bankIfsc"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 11-character IFSC code.</div>
                            </div>

                            <div class="form-group">
                                <label for="bankBranch">Branch Name</label>
                                <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Koramangala, Bengaluru" maxlength="100">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 10: Visuals, Brand & Verification Documents -->
            <div class="section-card" id="sec-media">
                <div class="section-header">
                    <i class="bi bi-images"></i>
                    <span>10. Visuals, Brand &amp; Verification Documents</span>
                </div>
                <p class="section-desc">Select and upload your organizer profile photo, organization brand logo, ID proof or registration document, and past event photo gallery.</p>

                <div class="form-grid-2">
                    <!-- 10.1 Organizer Profile Photo -->
                    <div class="form-group" id="group-profilePhoto">
                        <label for="profilePhoto">10.1 Organizer Profile Photo <span class="req">*</span></label>
                        <input type="hidden" id="existingProfilePhoto" value="<c:out value='${host.profilePhotoPath}'/>">
                        <div class="upload-picker-box">
                            <div class="photo-preview-circle">
                                <c:choose>
                                    <c:when test="${not empty host.profilePhotoPath}">
                                        <img id="profilePhotoPreview" src="${fn:startsWith(host.profilePhotoPath, 'http') ? host.profilePhotoPath : pageContext.request.contextPath.concat(host.profilePhotoPath)}" alt="Profile Photo">
                                        <div id="profilePhotoFallback" class="photo-fallback" style="display:none;"><i class="bi bi-person-fill"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div id="profilePhotoFallback" class="photo-fallback"><i class="bi bi-person-fill"></i></div>
                                        <img id="profilePhotoPreview" src="" alt="Profile Photo" style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="upload-meta">
                                <div class="upload-btn-row">
                                    <label for="profilePhoto" class="btn-choose-file">
                                        <i class="bi bi-camera-fill"></i> Select Photo
                                    </label>
                                    <input type="file" id="profilePhoto" name="profilePhoto" accept="image/jpeg,image/png,image/webp" style="display:none;" onchange="handleProfilePhotoSelected(this)">
                                    <span id="profilePhotoName" class="upload-file-status">
                                        <c:choose>
                                            <c:when test="${not empty host.profilePhotoPath}"><span class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Photo on file</span></c:when>
                                            <c:otherwise><span class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> No photo selected</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="hint">JPG, PNG or WEBP up to 5 MB. Appears as your organizer avatar across the portal.</div>
                                <div class="error-msg" id="err-profilePhoto"><i class="bi bi-exclamation-circle-fill"></i> Please select a valid profile photo (JPG, PNG, max 5 MB).</div>
                            </div>
                        </div>
                    </div>

                    <!-- 10.2 Brand / Organization Logo -->
                    <div class="form-group" id="group-logoFile">
                        <label for="logoFile">10.2 Brand / Organization Logo <span class="req">*</span></label>
                        <input type="hidden" id="existingLogo" value="<c:out value='${host.logoPath}'/>">
                        <div class="upload-picker-box">
                            <div class="logo-preview-box">
                                <c:choose>
                                    <c:when test="${not empty host.logoPath}">
                                        <img id="logoPreview" src="${fn:startsWith(host.logoPath, 'http') ? host.logoPath : pageContext.request.contextPath.concat(host.logoPath)}" alt="Brand Logo">
                                        <div id="logoFallback" class="photo-fallback" style="display:none;"><i class="bi bi-image"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div id="logoFallback" class="photo-fallback"><i class="bi bi-building"></i></div>
                                        <img id="logoPreview" src="" alt="Brand Logo" style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="upload-meta">
                                <div class="upload-btn-row">
                                    <label for="logoFile" class="btn-choose-file">
                                        <i class="bi bi-upload"></i> Select Logo
                                    </label>
                                    <input type="file" id="logoFile" name="logoFile" accept="image/jpeg,image/png,image/webp,image/svg+xml" style="display:none;" onchange="handleLogoSelected(this)">
                                    <span id="logoFileName" class="upload-file-status">
                                        <c:choose>
                                            <c:when test="${not empty host.logoPath}"><span class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Logo on file</span></c:when>
                                            <c:otherwise><span class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> No logo selected</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="hint">Upload your official NGO, Foundation, or Enterprise logo (PNG/JPG/WEBP).</div>
                                <div class="error-msg" id="err-logoFile"><i class="bi bi-exclamation-circle-fill"></i> Please select a brand logo.</div>
                            </div>
                        </div>
                    </div>

                    <!-- 10.3 Important Document / ID Proof -->
                    <div class="form-group span-2" id="group-documentFile">
                        <label for="documentFile">10.3 Important Document / ID Proof <span class="req">*</span> (Govt ID / NGO Certificate / GST / CIN Proof)</label>
                        <input type="hidden" id="existingDocument" value="<c:out value='${host.documentPath}'/>">
                        <div class="upload-picker-box" style="align-items: flex-start;">
                            <div style="font-size:2.2rem;color:var(--primary);flex-shrink:0;margin-top:2px;">
                                <i class="bi bi-file-earmark-check-fill"></i>
                            </div>
                            <div class="upload-meta">
                                <div class="upload-btn-row">
                                    <label for="documentFile" class="btn-choose-file">
                                        <i class="bi bi-file-earmark-arrow-up-fill"></i> Select Verification Document
                                    </label>
                                    <input type="file" id="documentFile" name="documentFile" accept="image/jpeg,image/png,application/pdf" style="display:none;" onchange="handleDocSelected(this)">
                                    <span id="docFileName" class="upload-file-status">
                                        <c:choose>
                                            <c:when test="${not empty host.documentPath}">
                                                <span class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Document currently on file</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded yet</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${not empty host.documentPath}">
                                    <div class="doc-status-wrap mt-2">
                                        <c:choose>
                                            <c:when test="${fn:endsWith(fn:toLowerCase(host.documentPath), '.pdf')}">
                                                <a href="${fn:startsWith(host.documentPath, 'http') ? host.documentPath : pageContext.request.contextPath.concat(host.documentPath)}" target="_blank" class="doc-link">
                                                    <i class="bi bi-file-earmark-pdf-fill text-danger fs-5"></i> View Existing Document (PDF)
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="d-flex align-items-center gap-2">
                                                    <img src="${fn:startsWith(host.documentPath, 'http') ? host.documentPath : pageContext.request.contextPath.concat(host.documentPath)}" alt="Document" style="width:40px;height:40px;object-fit:cover;border-radius:6px;border:1px solid var(--border-color);">
                                                    <a href="${fn:startsWith(host.documentPath, 'http') ? host.documentPath : pageContext.request.contextPath.concat(host.documentPath)}" target="_blank" class="doc-link">
                                                        <i class="bi bi-box-arrow-up-right"></i> View Full Document
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                                <div class="hint">Upload PDF, JPG, or PNG (up to 10 MB). Official certificate or identity document for admin verification.</div>
                                <div class="error-msg" id="err-documentFile"><i class="bi bi-exclamation-circle-fill"></i> Please upload an official verification document (PDF, JPG, PNG).</div>
                            </div>
                        </div>
                    </div>

                    <!-- 10.4 Event Photo Gallery -->
                    <div class="form-group span-2" id="group-galleryFiles">
                        <label for="galleryFiles">10.4 Event Photo Gallery (Select multiple photos)</label>
                        <input type="hidden" name="removeGalleryPhoto" id="removeGalleryPhotoInput" value="">
                        <div class="upload-picker-box" style="flex-direction: column; align-items: stretch;">
                            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                <div>
                                    <label for="galleryFiles" class="btn-choose-file">
                                        <i class="bi bi-images"></i> Select Gallery Photos
                                    </label>
                                    <input type="file" id="galleryFiles" name="galleryFiles" accept="image/*" multiple style="display:none;" onchange="handleGallerySelected(this)">
                                    <span id="galleryFilesStatus" class="upload-file-status ms-2 text-muted">Select multiple past event photos</span>
                                </div>
                                <span class="hint"><i class="bi bi-info-circle"></i> High-resolution photos from your previous workshops, seminars, or events.</span>
                            </div>

                            <!-- Existing & Selected Previews Grid -->
                            <div class="gallery-grid-preview" id="galleryGridPreview">
                                <c:if test="${not empty host.galleryPhotos}">
                                    <c:forEach var="photo" items="${fn:split(host.galleryPhotos, ',')}">
                                        <c:if test="${not empty fn:trim(photo)}">
                                            <div class="gallery-thumb-wrap" id="galThumb-${fn:replace(fn:replace(photo, '/', '_'), '.', '_')}">
                                                <img src="${fn:startsWith(photo, 'http') ? photo : pageContext.request.contextPath.concat(photo)}" alt="Event Photo">
                                                <button type="button" class="gallery-del-btn" title="Remove Photo" onclick="removeExistingGalleryPhoto('${photo}')">
                                                    <i class="bi bi-x"></i>
                                                </button>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 11: Web & Social Links -->
            <div class="section-card" id="sec-social">
                <div class="section-header">
                    <i class="bi bi-globe"></i>
                    <span>11. Social Media &amp; Web Presence</span>
                </div>
                <p class="section-desc">Connect your social accounts to build credibility.</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="website">Official Website</label>
                        <input type="url" id="website" name="website" class="form-input" value="<c:out value='${host.website}'/>" placeholder="https://sheleads.org">
                        <div class="error-msg" id="err-website"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid URL starting with http:// or https://</div>
                    </div>

                    <div class="form-group">
                        <label for="instagram">Instagram Profile</label>
                        <input type="text" id="instagram" name="instagram" class="form-input" value="<c:out value='${host.instagram}'/>" placeholder="@sheleads_org or full URL">
                    </div>

                    <div class="form-group">
                        <label for="facebook">Facebook Page</label>
                        <input type="text" id="facebook" name="facebook" class="form-input" value="<c:out value='${host.facebook}'/>" placeholder="facebook.com/sheleads">
                    </div>

                    <div class="form-group">
                        <label for="linkedin">LinkedIn Page</label>
                        <input type="text" id="linkedin" name="linkedin" class="form-input" value="<c:out value='${host.linkedin}'/>" placeholder="linkedin.com/company/sheleads">
                    </div>
                </div>
            </div>

            <!-- Bottom Actions -->
            <div class="bottom-actions">
                <button type="button" class="btn-skip btn-bottom-save" onclick="saveProfileDraft()">
                    <i class="bi bi-floppy me-2"></i> Save Profile Draft
                </button>
                <button type="button" class="btn-primary btn-bottom-save" onclick="openReviewModal()">
                    <i class="bi bi-send-check-fill me-2"></i> Review &amp; Submit for Verification
                </button>
            </div>
        </form>

    </main>

    <!-- LEAFLET MAP MODAL (OpenStreetMap + Leaflet, CSP Compliant) -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle">
        <div class="map-modal-card">
            <div class="modal-header-row">
                <div class="modal-title">
                    <i class="bi bi-geo-alt-fill" style="color:var(--primary);"></i>
                    <span id="mapModalTitle">Select Venue &amp; Operational Location</span>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close">&times;</button>
            </div>

            <div class="map-search-bar">
                <input type="text" id="mapSearchInput" class="map-search-input" placeholder="Search landmark, street, city or area in India...">
                <button type="button" class="btn-primary" id="btnSearchMap" style="padding: 0 14px; font-size: 0.85rem;">
                    <i class="bi bi-search"></i>
                </button>
                <button type="button" class="btn-secondary" id="btnLocateMe" style="padding: 0 14px; font-size: 0.85rem; border: 1px solid var(--border-color); background: #FFF;" title="Use my current location">
                    <i class="bi bi-crosshair"></i> Current Location
                </button>
                <div id="mapSuggestions" class="map-suggestions-box"></div>
            </div>

            <div id="mapPickerAlert" style="display:none;background:#FEF2F2;border:1px solid #FECACA;color:#DC2626;padding:8px 16px;font-size:0.8rem;"></div>

            <div id="mapContainer"></div>

            <div class="map-modal-footer">
                <div class="map-selected-address-box">
                    <i class="bi bi-pin-map-fill" style="color:var(--primary);"></i>
                    <span id="mapSelectedAddress">Drop or drag pin to select location</span>
                </div>
                <div class="map-modal-actions">
                    <button type="button" class="btn-skip" id="btnCancelMap">Cancel</button>
                    <button type="button" class="btn-primary" id="btnConfirmLocation" disabled>
                        <i class="bi bi-check-lg"></i> Confirm Location
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- PROFILE REVIEW MODAL -->
    <div id="profileReviewModalBackdrop" class="modal-overlay" onclick="handleReviewBackdropClick(event)">
        <div class="review-modal-card">
            <div class="modal-header-row" style="padding: 16px 22px;">
                <div class="modal-title">
                    <i class="bi bi-clipboard2-check" style="color:var(--primary);"></i>
                    <span>Review Application for Admin Verification</span>
                </div>
                <button type="button" class="btn-close-modal" onclick="closeReviewModal()" aria-label="Close">&times;</button>
            </div>

            <div class="review-modal-body">
                <div class="review-summary-banner">
                    <div class="rev-avatar">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="rev-details">
                        <h4 id="revModalOrgName">SheLeads Foundation</h4>
                        <p><span id="revModalHostName">Organizer Name</span> &bull; <span id="revModalCityState">City, State</span></p>
                    </div>
                </div>

                <div style="margin-bottom:16px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">
                        <span style="font-size:0.85rem;font-weight:700;color:var(--navy);">Verification Readiness</span>
                        <span style="font-size:0.85rem;font-weight:800;color:var(--primary);" id="revModalPct">0%</span>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" id="revModalBar" style="width:0%;"></div>
                    </div>
                </div>

                <div id="revModalMissingSection" style="display:none;background:#FFF7ED;border:1px solid #FED7AA;border-radius:12px;padding:14px;margin-bottom:16px;">
                    <div style="font-weight:700;font-size:0.88rem;color:#C2410C;margin-bottom:6px;">
                        <i class="bi bi-exclamation-triangle-fill"></i> Please complete these required fields first:
                    </div>
                    <ul id="revModalMissingList" style="margin:0;padding-left:20px;font-size:0.82rem;color:#9A3412;line-height:1.6;"></ul>
                </div>

                <div id="revModalSuccessSection" style="display:none;background:#F0FDF4;border:1px solid #BBF7D0;border-radius:12px;padding:14px;margin-bottom:16px;">
                    <div style="font-weight:700;font-size:0.88rem;color:#166534;">
                        <i class="bi bi-check-circle-fill"></i> All 16 mandatory fields are complete and verified!
                    </div>
                    <div style="font-size:0.82rem;color:#15803D;margin-top:4px;">
                        Your host profile is ready for submission. Our team will review your credentials within 24–48 hours.
                    </div>
                </div>
            </div>

            <div class="map-modal-footer">
                <button type="button" class="btn-skip" onclick="closeReviewModal()">Keep Editing</button>
                <button type="button" class="btn-primary" id="btnFinalSubmit" onclick="executeFinalSubmit()">
                    <i class="bi bi-send-check-fill me-1"></i> Submit Profile for Review
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
        const ctx = '${pageContext.request.contextPath}';

        // -------------------------------------------------------------
        // Comprehensive Dependent Location Dataset (Matching Doctor/Trainer)
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
                "California": ["Los Angeles", "San Francisco", "San Diego", "San Jose", "Other"],
                "New York": ["New York City", "Buffalo", "Rochester", "Albany", "Other"],
                "Texas": ["Houston", "Austin", "Dallas", "San Antonio", "Other"]
            },
            "United Kingdom": {
                "England": ["London", "Manchester", "Birmingham", "Leeds", "Other"],
                "Scotland": ["Edinburgh", "Glasgow", "Aberdeen", "Other"]
            },
            "Canada": {
                "Ontario": ["Toronto", "Ottawa", "Mississauga", "Other"],
                "British Columbia": ["Vancouver", "Victoria", "Surrey", "Other"]
            },
            "Australia": {
                "New South Wales": ["Sydney", "Newcastle", "Other"],
                "Victoria": ["Melbourne", "Geelong", "Other"]
            },
            "United Arab Emirates": {
                "Emirates": ["Dubai", "Abu Dhabi", "Sharjah", "Ajman", "Other"]
            },
            "Singapore": {
                "Singapore": ["Central", "East", "North", "North-East", "West"]
            },
            "Other": {
                "International Region": ["General Region", "Other"]
            }
        };

        const savedState = "<c:out value='${host.state}'/>";
        const savedCity = "<c:out value='${host.city}'/>";

        // -------------------------------------------------------------
        // Helper: Toggle chip visual selection
        // -------------------------------------------------------------
        function toggleChipActive(checkbox) {
            const label = checkbox.closest('.chip-item');
            if (label) {
                const icon = label.querySelector('i');
                if (checkbox.checked) {
                    label.classList.add('active');
                    if (icon) { icon.className = 'bi bi-check-circle-fill'; }
                } else {
                    label.classList.remove('active');
                    if (icon) { icon.className = 'bi bi-circle'; }
                }
            }
        }

        function getCheckedValues(className) {
            return Array.from(document.querySelectorAll('.' + className + ':checked')).map(cb => cb.value).join(',');
        }

        // -------------------------------------------------------------
        // Inline Validation Helpers
        // -------------------------------------------------------------
        function setFieldState(id, errId, isValid, msg) {
            const el = document.getElementById(id);
            const errEl = document.getElementById(errId);
            if (el) {
                el.classList.remove('is-valid', 'is-invalid');
                el.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
            if (errEl) {
                if (!isValid) {
                    if (msg) errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + msg;
                    errEl.classList.add('visible');
                } else {
                    errEl.classList.remove('visible');
                }
            }
            return isValid;
        }

        function validateFullName() {
            const val = (document.getElementById('fullName')?.value || '').trim();
            return setFieldState('fullName', 'err-fullName', val.length >= 2, 'Full name must be at least 2 characters.');
        }

        function validateOrganizerType() {
            const val = (document.getElementById('organizerType')?.value || '').trim();
            return setFieldState('organizerType', 'err-organizerType', !!val, 'Please select an organization type.');
        }

        function validatePhone() {
            const val = (document.getElementById('phone')?.value || '').trim();
            const valid = /^\d{10}$/.test(val);
            return setFieldState('phone', 'err-phone', valid, 'Official phone must be exactly 10 digits.');
        }

        function validateOrganizerName() {
            const val = (document.getElementById('organizerName')?.value || '').trim();
            return setFieldState('organizerName', 'err-organizerName', val.length >= 2, 'Organization name must be at least 2 characters.');
        }

        function validateWhatsappNumber() {
            const val = (document.getElementById('whatsappNumber')?.value || '').trim();
            if (!val) {
                setFieldState('whatsappNumber', 'err-whatsappNumber', true);
                const el = document.getElementById('whatsappNumber');
                if (el) el.classList.remove('is-valid');
                return true;
            }
            const valid = /^\d{10}$/.test(val);
            return setFieldState('whatsappNumber', 'err-whatsappNumber', valid, 'WhatsApp number must be 10 digits.');
        }

        function validateCredentialNumber() {
            const val = (document.getElementById('credentialNumber')?.value || '').trim();
            return setFieldState('credentialNumber', 'err-credentialNumber', val.length >= 2, 'Credential registration number is required.');
        }

        function validateYearsExperience() {
            const val = document.getElementById('yearsExperience')?.value;
            const num = parseInt(val, 10);
            const valid = !isNaN(num) && num >= 0 && num <= 50;
            return setFieldState('yearsExperience', 'err-yearsExperience', valid, 'Years of experience must be between 0 and 50.');
        }

        function validateOfficeAddress() {
            const val = (document.getElementById('officeAddress')?.value || '').trim();
            return setFieldState('officeAddress', 'err-officeAddress', val.length >= 5, 'Street address is required (minimum 5 characters).');
        }

        function validateState() {
            const val = (document.getElementById('stateSelect')?.value || '').trim();
            return setFieldState('stateSelect', 'err-state', !!val, 'State is required.');
        }

        function validateCity() {
            const distVal = (document.getElementById('districtSelect')?.value || '').trim();
            const customVal = (document.getElementById('customCityInput')?.value || '').trim();
            const cityInput = document.getElementById('inputCity');
            let valid = false;
            if (distVal === 'Other') {
                valid = customVal.length >= 2;
                setFieldState('customCityInput', 'err-customCity', valid, 'Please enter your city / town name.');
                if (cityInput) cityInput.value = customVal;
            } else {
                valid = distVal.length > 0;
                setFieldState('districtSelect', 'err-city', valid, 'City / District is required.');
                if (cityInput) cityInput.value = distVal;
            }
            return valid;
        }

        function validatePincode() {
            const val = (document.getElementById('pincode')?.value || '').trim();
            const valid = /^\d{6}$/.test(val);
            return setFieldState('pincode', 'err-pincode', valid, 'Pincode must be exactly 6 digits.');
        }

        function validateMapsLocation() {
            const val = (document.getElementById('mapsLocation')?.value || '').trim();
            if (!val) {
                setFieldState('mapsLocation', 'err-mapsLocation', true);
                const el = document.getElementById('mapsLocation');
                if (el) el.classList.remove('is-valid');
                return true;
            }
            try {
                const u = new URL(val);
                const ok = u.protocol === 'http:' || u.protocol === 'https:';
                return setFieldState('mapsLocation', 'err-mapsLocation', ok, 'URL protocol must be http or https.');
            } catch (_) {
                return setFieldState('mapsLocation', 'err-mapsLocation', false, 'Enter a valid URL (e.g. https://maps.google.com/...)');
            }
        }

        function validateEventCategories() {
            const checked = document.querySelectorAll('.cb-category:checked');
            const errEl = document.getElementById('err-eventCategories');
            const valid = checked.length > 0;
            if (errEl) {
                if (valid) errEl.classList.remove('visible');
                else errEl.classList.add('visible');
            }
            return valid;
        }

        function validateAudience() {
            const checked = document.querySelectorAll('.cb-audience:checked');
            const errEl = document.getElementById('err-audience');
            const valid = checked.length > 0;
            if (errEl) {
                if (valid) errEl.classList.remove('visible');
                else errEl.classList.add('visible');
            }
            return valid;
        }

        function validateOpenDays() {
            const checked = document.querySelectorAll('.cb-day:checked');
            const errEl = document.getElementById('err-openDays');
            const valid = checked.length > 0;
            if (errEl) {
                if (valid) errEl.classList.remove('visible');
                else errEl.classList.add('visible');
            }
            return valid;
        }

        function validateOperatingHours() {
            const openVal = (document.getElementById('openTime')?.value || '').trim();
            const closeVal = (document.getElementById('closeTime')?.value || '').trim();
            const openOk = setFieldState('openTime', 'err-openTime', !!openVal, 'Opening time is required.');
            let closeOk = setFieldState('closeTime', 'err-closeTime', !!closeVal, 'Closing time is required.');
            if (openVal && closeVal) {
                if (closeVal <= openVal) {
                    closeOk = setFieldState('closeTime', 'err-closeTime', false, 'Closing time must be strictly after opening time.');
                }
            }
            return openOk && closeOk;
        }

        function validateHostBio() {
            const val = (document.getElementById('hostBio')?.value || '').trim();
            return setFieldState('hostBio', 'err-hostBio', val.length >= 10, 'Mission & background bio must be at least 10 characters.');
        }

        function validateSessionMode() {
            const val = (document.getElementById('sessionMode')?.value || '').trim();
            return setFieldState('sessionMode', 'err-sessionMode', !!val, 'Please select a session mode.');
        }

        function validateDurationMinutes() {
            const val = document.getElementById('durationMinutes')?.value;
            const num = parseInt(val, 10);
            const valid = !isNaN(num) && num >= 15;
            return setFieldState('durationMinutes', 'err-durationMinutes', valid, 'Duration must be at least 15 minutes.');
        }

        function validateTypicalPrice() {
            const val = document.getElementById('typicalPrice')?.value;
            const num = parseFloat(val);
            const valid = !isNaN(num) && num >= 0;
            return setFieldState('typicalPrice', 'err-typicalPrice', valid, 'Ticket price cannot be negative.');
        }

        function validateUpiId() {
            const val = (document.getElementById('upiId')?.value || '').trim();
            if (!val) {
                setFieldState('upiId', 'err-upiId', true);
                const el = document.getElementById('upiId');
                if (el) el.classList.remove('is-valid');
                return true;
            }
            const valid = /^[\w.\-]{2,}@[a-zA-Z]{2,}$/.test(val);
            return setFieldState('upiId', 'err-upiId', valid, 'Enter a valid UPI handle (e.g. name@upi).');
        }

        function validateBankAccountNumber() {
            const acctEl = document.getElementById('bankAccountNumber');
            const confEl = document.getElementById('bankConfirmAccountNumber');
            if (!acctEl) return true;
            const acct = acctEl.value.trim();
            const conf = confEl ? confEl.value.trim() : '';

            if (acct) {
                const valid = /^\d{9,18}$/.test(acct);
                setFieldState('bankAccountNumber', 'err-bankAccountNumber', valid, 'Account number must be 9 to 18 digits.');
                if (conf) {
                    setFieldState('bankConfirmAccountNumber', 'err-bankConfirmAccountNumber', acct === conf, 'Account numbers do not match.');
                }
                return valid;
            } else {
                setFieldState('bankAccountNumber', 'err-bankAccountNumber', true);
                acctEl.classList.remove('is-valid');
                return true;
            }
        }

        function validateBankConfirmAccountNumber() {
            const acctEl = document.getElementById('bankAccountNumber');
            const confEl = document.getElementById('bankConfirmAccountNumber');
            if (!confEl) return true;
            const acct = acctEl ? acctEl.value.trim() : '';
            const conf = confEl.value.trim();
            if (conf || acct) {
                return setFieldState('bankConfirmAccountNumber', 'err-bankConfirmAccountNumber', acct === conf, 'Account numbers do not match.');
            }
            return true;
        }

        function validateBankIfsc() {
            const el = document.getElementById('bankIfsc');
            if (!el) return true;
            const val = el.value.trim().toUpperCase();
            el.value = val;
            if (!val) {
                setFieldState('bankIfsc', 'err-bankIfsc', true);
                el.classList.remove('is-valid');
                return true;
            }
            const valid = /^[A-Z]{4}0[A-Z0-9]{6}$/.test(val);
            return setFieldState('bankIfsc', 'err-bankIfsc', valid, 'IFSC must be 11 characters (e.g. SBIN0001234).');
        }

        function validateProfilePhoto() {
            const pInput = document.getElementById('profilePhoto');
            const hasExisting = !!(document.getElementById('existingProfilePhoto')?.value || '').trim();
            const selected = pInput && pInput.files && pInput.files.length > 0;
            const valid = selected || hasExisting;
            const errEl = document.getElementById('err-profilePhoto');
            if (errEl) {
                if (!valid) {
                    errEl.textContent = 'Organizer profile photo is required.';
                    errEl.classList.add('visible');
                } else {
                    errEl.classList.remove('visible');
                }
            }
            return valid;
        }

        function validateLogoPath() {
            const lInput = document.getElementById('logoFile');
            const hasExisting = !!(document.getElementById('existingLogo')?.value || '').trim();
            const selected = lInput && lInput.files && lInput.files.length > 0;
            const valid = selected || hasExisting;
            const errEl = document.getElementById('err-logoFile');
            if (errEl) {
                if (!valid) {
                    errEl.textContent = 'Brand / organization logo is required.';
                    errEl.classList.add('visible');
                } else {
                    errEl.classList.remove('visible');
                }
            }
            return valid;
        }

        function validateDocumentFile() {
            const dInput = document.getElementById('documentFile');
            const hasExisting = !!(document.getElementById('existingDocument')?.value || '').trim();
            const selected = dInput && dInput.files && dInput.files.length > 0;
            const valid = selected || hasExisting;
            const errEl = document.getElementById('err-documentFile');
            if (errEl) {
                if (!valid) {
                    errEl.textContent = 'Verification document or ID proof is required.';
                    errEl.classList.add('visible');
                } else {
                    errEl.classList.remove('visible');
                }
            }
            return valid;
        }

        // -------------------------------------------------------------
        // Cascading Location Dropdowns (Country -> State -> District)
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

            populateStates(countrySelect ? countrySelect.value : 'India', savedState);
        }

        // -------------------------------------------------------------
        // Leaflet Interactive Map Picker
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
            setMapSelectedLocation('Resolving venue address…', lat, lng);
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
            setMapSelectedLocation('Venue Location (' + lat.toFixed(5) + ', ' + lng.toFixed(5) + ')', lat, lng);
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

            const savedLat = parseFloat(document.getElementById('inputLatitude')?.value);
            const savedLng = parseFloat(document.getElementById('inputLongitude')?.value);
            if (!isNaN(savedLat) && !isNaN(savedLng) && savedLat !== 0) {
                defaultLat = savedLat;
                defaultLng = savedLng;
            } else {
                const mapLinkVal = document.getElementById('mapsLocation')?.value || '';
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

                const latInput = document.getElementById('inputLatitude');
                const lngInput = document.getElementById('inputLongitude');
                if (latInput) latInput.value = selectedCoords.lat.toFixed(6);
                if (lngInput) lngInput.value = selectedCoords.lng.toFixed(6);

                const coordsDisplay = document.getElementById('coordsDisplay');
                if (coordsDisplay) coordsDisplay.textContent = selectedCoords.lat.toFixed(5) + ', ' + selectedCoords.lng.toFixed(5);

                const mapLinkInput = document.getElementById('mapsLocation');
                if (mapLinkInput) {
                    mapLinkInput.value = 'https://www.google.com/maps?q=' + selectedCoords.lat.toFixed(6) + ',' + selectedCoords.lng.toFixed(6);
                    validateMapsLocation();
                }

                const addrInput = document.getElementById('officeAddress');
                if (addrInput && (!addrInput.value || addrInput.value.trim().length < 5) && selectedAddressText) {
                    addrInput.value = selectedAddressText;
                    validateOfficeAddress();
                }

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
        // Bank Details Serialization
        // -------------------------------------------------------------
        function serializeBankDetails() {
            const holder = (document.getElementById('bankAccountHolder')?.value || '').trim();
            const bank = (document.getElementById('bankName')?.value || '').trim();
            const acct = (document.getElementById('bankAccountNumber')?.value || '').trim();
            const ifsc = (document.getElementById('bankIfsc')?.value || '').trim().toUpperCase();
            const branch = (document.getElementById('bankBranch')?.value || '').trim();
            const hidden = document.getElementById('bankDetails');
            if (!hidden) return;

            if (!holder && !bank && !acct && !ifsc && !branch) {
                hidden.value = '';
                return;
            }
            const parts = [];
            if (holder) parts.push('Account Holder: ' + holder);
            if (bank) parts.push('Bank: ' + bank);
            if (acct) parts.push('A/C: ' + acct);
            if (ifsc) parts.push('IFSC: ' + ifsc);
            if (branch) parts.push('Branch: ' + branch);
            hidden.value = parts.join(' | ');
        }

        function parseExistingBankDetails() {
            const raw = (document.getElementById('bankDetails')?.value || '').trim();
            if (!raw) return;
            const holderMatch = raw.match(/Account Holder:\s*([^|]+)/i);
            const bankMatch = raw.match(/Bank:\s*([^|]+)/i);
            const acctMatch = raw.match(/A\/C:\s*([^|]+)/i) || raw.match(/Account Number:\s*([^|]+)/i);
            const ifscMatch = raw.match(/IFSC:\s*([^|]+)/i);
            const branchMatch = raw.match(/Branch:\s*([^|]+)/i);

            if (holderMatch && document.getElementById('bankAccountHolder')) document.getElementById('bankAccountHolder').value = holderMatch[1].trim();
            if (bankMatch && document.getElementById('bankName')) document.getElementById('bankName').value = bankMatch[1].trim();
            if (acctMatch && document.getElementById('bankAccountNumber')) {
                const num = acctMatch[1].trim();
                document.getElementById('bankAccountNumber').value = num;
                if (document.getElementById('bankConfirmAccountNumber')) document.getElementById('bankConfirmAccountNumber').value = num;
            }
            if (ifscMatch && document.getElementById('bankIfsc')) document.getElementById('bankIfsc').value = ifscMatch[1].trim().toUpperCase();
            if (branchMatch && document.getElementById('bankBranch')) document.getElementById('bankBranch').value = branchMatch[1].trim();
        }

        // -------------------------------------------------------------
        // File Selection Handlers & Previews
        // -------------------------------------------------------------
        function handleProfilePhotoSelected(input) {
            const file = input?.files?.[0];
            const nameEl = document.getElementById('profilePhotoName');
            const errEl = document.getElementById('err-profilePhoto');
            if (!file) return;

            if (file.size > 5 * 1024 * 1024) {
                if (errEl) { errEl.textContent = 'Profile photo exceeds 5 MB limit.'; errEl.classList.add('visible'); }
                input.value = '';
                return;
            }
            if (errEl) errEl.classList.remove('visible');

            const reader = new FileReader();
            reader.onload = function(e) {
                const prev = document.getElementById('profilePhotoPreview');
                const fallback = document.getElementById('profilePhotoFallback');
                if (prev) { prev.src = e.target.result; prev.style.display = 'block'; }
                if (fallback) fallback.style.display = 'none';
            };
            reader.readAsDataURL(file);

            if (nameEl) nameEl.innerHTML = '<span class="doc-badge selected"><i class="bi bi-check-circle-fill"></i> Selected: ' + escapeHtml(file.name) + '</span>';
            recalculateProgress();
        }

        function handleLogoSelected(input) {
            const file = input?.files?.[0];
            const nameEl = document.getElementById('logoFileName');
            const errEl = document.getElementById('err-logoFile');
            if (!file) return;

            if (file.size > 5 * 1024 * 1024) {
                if (errEl) { errEl.textContent = 'Brand logo exceeds 5 MB limit.'; errEl.classList.add('visible'); }
                input.value = '';
                return;
            }
            if (errEl) errEl.classList.remove('visible');

            const reader = new FileReader();
            reader.onload = function(e) {
                const prev = document.getElementById('logoPreview');
                const fallback = document.getElementById('logoFallback');
                if (prev) { prev.src = e.target.result; prev.style.display = 'block'; }
                if (fallback) fallback.style.display = 'none';
            };
            reader.readAsDataURL(file);

            if (nameEl) nameEl.innerHTML = '<span class="doc-badge selected"><i class="bi bi-check-circle-fill"></i> Selected: ' + escapeHtml(file.name) + '</span>';
            recalculateProgress();
        }

        function handleDocSelected(input) {
            const file = input?.files?.[0];
            const nameEl = document.getElementById('docFileName');
            const errEl = document.getElementById('err-documentFile');
            if (!file) return;

            if (file.size > 10 * 1024 * 1024) {
                if (errEl) { errEl.textContent = 'Document exceeds 10 MB limit.'; errEl.classList.add('visible'); }
                input.value = '';
                return;
            }
            if (errEl) errEl.classList.remove('visible');

            if (nameEl) nameEl.innerHTML = '<span class="doc-badge selected"><i class="bi bi-file-earmark-check-fill"></i> Selected: ' + escapeHtml(file.name) + '</span>';
            recalculateProgress();
        }

        function handleGallerySelected(input) {
            const files = input?.files;
            if (!files || files.length === 0) return;
            const statusEl = document.getElementById('galleryFilesStatus');
            if (statusEl) statusEl.textContent = files.length + ' new photo(s) selected';

            const grid = document.getElementById('galleryGridPreview');
            grid?.querySelectorAll('.new-preview').forEach(el => el.remove());

            Array.from(files).forEach((file) => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const wrap = document.createElement('div');
                    wrap.className = 'gallery-thumb-wrap new-preview';
                    wrap.style.border = '2px solid var(--primary)';
                    wrap.innerHTML = '<img src="' + e.target.result + '" alt="Preview"><div style="position:absolute;bottom:2px;right:2px;background:var(--primary);color:#fff;font-size:0.65rem;padding:2px 4px;border-radius:4px;font-weight:700;">NEW</div>';
                    grid.appendChild(wrap);
                };
                reader.readAsDataURL(file);
            });
        }

        function removeExistingGalleryPhoto(photoPath) {
            if (!confirm('Are you sure you want to remove this photo from your gallery?')) return;
            const inp = document.getElementById('removeGalleryPhotoInput');
            if (inp) inp.value = photoPath;
            document.getElementById('hostProfileForm')?.submit();
        }

        function escapeHtml(str) {
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        // -------------------------------------------------------------
        // Profile Completion Progress Recalculation (19 Backend Items)
        // -------------------------------------------------------------
        function calculateProfileStatus() {
            const checks = [];

            // 1. Full name
            const fn = (document.getElementById('fullName')?.value || '').trim();
            checks.push({ key: '1.1 Full name', valid: fn.length >= 2, target: 'fullName' });

            // 2. Organizer type
            const ot = (document.getElementById('organizerType')?.value || '').trim();
            checks.push({ key: '1.2 Organizer type', valid: !!ot, target: 'organizerType' });

            // 3. Organizer name
            const on = (document.getElementById('organizerName')?.value || '').trim();
            checks.push({ key: '1.3 Organizer name', valid: on.length >= 2, target: 'organizerName' });

            // 4. Official phone (10 digits)
            const ph = (document.getElementById('phone')?.value || '').trim();
            checks.push({ key: '1.5 Official phone', valid: /^\d{10}$/.test(ph), target: 'phone' });

            // 5. Credential number
            const cred = (document.getElementById('credentialNumber')?.value || '').trim();
            checks.push({ key: '1.8 GST / NGO / CIN number', valid: cred.length >= 2, target: 'credentialNumber' });

            // 6. Address
            const addr = (document.getElementById('officeAddress')?.value || '').trim();
            checks.push({ key: '2.1 Address', valid: addr.length >= 5, target: 'officeAddress' });

            // 7. City
            const city = (document.getElementById('inputCity')?.value || '').trim();
            checks.push({ key: '2.3 City', valid: city.length >= 2, target: 'districtSelect' });

            // 8. State
            const st = (document.getElementById('stateSelect')?.value || '').trim();
            checks.push({ key: '2.4 State', valid: !!st, target: 'stateSelect' });

            // 9. Pincode (6 digits)
            const pin = (document.getElementById('pincode')?.value || '').trim();
            checks.push({ key: '2.5 Pincode', valid: /^\d{6}$/.test(pin), target: 'pincode' });

            // 10. Event categories
            const cats = document.querySelectorAll('.cb-category:checked');
            checks.push({ key: '3.1 Categories', valid: cats.length > 0, target: 'sec-categories' });

            // 11. Who I serve (Audience)
            const aud = document.querySelectorAll('.cb-audience:checked');
            checks.push({ key: '4.1 Who I serve', valid: aud.length > 0, target: 'sec-audience' });

            // 12. Open days
            const days = document.querySelectorAll('.cb-day:checked');
            checks.push({ key: '6.1 Open days', valid: days.length > 0, target: 'sec-schedule' });

            // 13. Open time
            const otm = (document.getElementById('openTime')?.value || '').trim();
            checks.push({ key: '6.2 Open time', valid: !!otm, target: 'openTime' });

            // 14. Close time
            const ctm = (document.getElementById('closeTime')?.value || '').trim();
            const timeOrderOk = otm && ctm ? ctm > otm : !!ctm;
            checks.push({ key: '6.3 Close time', valid: !!ctm && timeOrderOk, target: 'closeTime' });

            // 15. Bio
            const bio = (document.getElementById('hostBio')?.value || '').trim();
            checks.push({ key: '7.1 About', valid: bio.length >= 10, target: 'hostBio' });

            // 16. Typical ticket & session mode
            const sm = (document.getElementById('sessionMode')?.value || '').trim();
            const tp = document.getElementById('typicalPrice')?.value;
            const tpNum = parseFloat(tp);
            const ticketOk = !!sm && !isNaN(tpNum) && tpNum >= 0;
            checks.push({ key: '8. Typical ticket', valid: ticketOk, target: 'typicalPrice' });

            // 17. Profile photo
            const pInput = document.getElementById('profilePhoto');
            const hasExistingPhoto = !!(document.getElementById('existingProfilePhoto')?.value || '').trim();
            const photoSelected = pInput && pInput.files && pInput.files.length > 0;
            checks.push({ key: '10.1 Profile photo', valid: (photoSelected || hasExistingPhoto), target: 'group-profilePhoto' });

            // 18. Brand logo
            const lInput = document.getElementById('logoFile');
            const hasExistingLogo = !!(document.getElementById('existingLogo')?.value || '').trim();
            const logoSelected = lInput && lInput.files && lInput.files.length > 0;
            checks.push({ key: '10.2 Brand logo', valid: (logoSelected || hasExistingLogo), target: 'group-logoFile' });

            // 19. ID / Registration proof
            const dInput = document.getElementById('documentFile');
            const hasExistingDoc = !!(document.getElementById('existingDocument')?.value || '').trim();
            const docSelected = dInput && dInput.files && dInput.files.length > 0;
            checks.push({ key: '10.3 ID / Registration proof', valid: (docSelected || hasExistingDoc), target: 'group-documentFile' });

            const completed = checks.filter(c => c.valid).length;
            const total = checks.length; // exactly 19
            const pct = Math.round((completed / total) * 100);
            const missing = checks.filter(c => !c.valid);

            return { pct, completed, total, missing, checks };
        }

        function recalculateProgress() {
            const status = calculateProfileStatus();

            const pctText = document.getElementById('pctText');
            if (pctText) pctText.textContent = status.pct + '%';

            const bar = document.getElementById('progressBarFill');
            if (bar) bar.style.width = status.pct + '%';

            const missingContainer = document.getElementById('missingListContainer');
            if (missingContainer) {
                missingContainer.innerHTML = '';
                status.missing.forEach(m => {
                    const span = document.createElement('span');
                    span.className = 'missing-chip';
                    span.innerHTML = '<i class="bi bi-exclamation-circle"></i> ' + m.key;
                    span.onclick = () => focusMissingItem(m.key);
                    missingContainer.appendChild(span);
                });
            }

            const guidance = document.getElementById('progressGuidance');
            if (guidance) {
                if (status.missing.length === 0) {
                    guidance.innerHTML = '<strong>All 19 mandatory fields are complete!</strong> Your host profile is ready for Admin Verification.';
                } else {
                    guidance.innerHTML = 'Complete <strong>' + status.missing[0].key + '</strong> and ' + (status.missing.length - 1) + ' other field(s) to reach 100% and submit for verification.';
                }
            }

            updateLivePreview();
        }

        function updateLivePreview() {
            const set = (id, text) => { const n = document.getElementById(id); if (n) n.textContent = text || '—'; };

            const fn = (document.getElementById('fullName')?.value || '').trim();
            const ph = (document.getElementById('phone')?.value || '').trim();
            const on = (document.getElementById('organizerName')?.value || '').trim();
            const ot = (document.getElementById('organizerType')?.value || '').trim();
            const city = (document.getElementById('inputCity')?.value || '').trim();
            const state = (document.getElementById('stateSelect')?.value || '').trim();
            const exp = document.getElementById('yearsExperience')?.value;
            const bio = (document.getElementById('hostBio')?.value || '').trim();
            const sm = (document.getElementById('sessionMode')?.value || '').trim();
            const tp = (document.getElementById('typicalPrice')?.value || '0').trim();

            const cats = Array.from(document.querySelectorAll('.cb-category:checked')).map(c => c.value).join(', ');

            set('pv-fullName', fn);
            set('pv-phone', ph);
            set('pv-organizerName', on);
            set('pv-organizerType', ot);
            set('pv-location', [city, state].filter(Boolean).join(', '));
            set('pv-years', exp ? exp + ' Years' : '—');
            set('pv-categories', cats);
            set('pv-sessionOffering', (sm || 'In-Person') + ' (₹' + (tp || '0') + ')');
            set('pv-bio', bio || 'No mission bio entered yet.');
        }

        function focusMissingItem(key) {
            const status = calculateProfileStatus();
            const match = status.checks.find(c => c.key === key || key.includes(c.key));
            if (match && match.target) {
                const el = document.getElementById(match.target);
                if (el) {
                    el.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    if (el.focus && el.tagName !== 'DIV') el.focus();
                }
            }
        }

        // -------------------------------------------------------------
        // Profile Review & Submission Modal
        // -------------------------------------------------------------
        function openReviewModal() {
            const status = calculateProfileStatus();
            const reviewModal = document.getElementById('profileReviewModalBackdrop');
            if (!reviewModal) return;

            document.getElementById('revModalOrgName').textContent = (document.getElementById('organizerName')?.value || 'Organization Name').trim();
            document.getElementById('revModalHostName').textContent = (document.getElementById('fullName')?.value || 'Host Name').trim();
            const city = (document.getElementById('inputCity')?.value || '').trim();
            const state = (document.getElementById('stateSelect')?.value || '').trim();
            document.getElementById('revModalCityState').textContent = [city, state].filter(Boolean).join(', ') || 'Location';

            document.getElementById('revModalPct').textContent = status.pct + '%';
            document.getElementById('revModalBar').style.width = status.pct + '%';

            const missSec = document.getElementById('revModalMissingSection');
            const missList = document.getElementById('revModalMissingList');
            const succSec = document.getElementById('revModalSuccessSection');
            const btnSubmit = document.getElementById('btnFinalSubmit');

            if (status.missing.length > 0) {
                missSec.style.display = 'block';
                succSec.style.display = 'none';
                missList.innerHTML = '';
                status.missing.forEach(m => {
                    const li = document.createElement('li');
                    li.textContent = m.key;
                    li.style.cursor = 'pointer';
                    li.style.textDecoration = 'underline';
                    li.onclick = () => { closeReviewModal(); focusMissingItem(m.key); };
                    missList.appendChild(li);
                });
                if (btnSubmit) {
                    btnSubmit.disabled = true;
                    btnSubmit.innerHTML = '<i class="bi bi-lock-fill me-1"></i> Incomplete (Resolve ' + status.missing.length + ' Fields)';
                }
            } else {
                missSec.style.display = 'none';
                succSec.style.display = 'block';
                if (btnSubmit) {
                    btnSubmit.disabled = false;
                    btnSubmit.innerHTML = '<i class="bi bi-send-check-fill me-1"></i> Submit Profile for Review';
                }
            }

            reviewModal.style.display = 'flex';
        }

        function closeReviewModal() {
            const reviewModal = document.getElementById('profileReviewModalBackdrop');
            if (reviewModal) reviewModal.style.display = 'none';
        }

        function handleReviewBackdropClick(e) {
            if (e.target && e.target.id === 'profileReviewModalBackdrop') closeReviewModal();
        }

        // -------------------------------------------------------------
        // Save Draft & Submit Handlers
        // -------------------------------------------------------------
        function displayLiveBanner(msg, type) {
            const b = document.getElementById('liveAlertBanner');
            if (!b) return;
            b.className = 'feedback-banner ' + (type === 'success' ? 'banner-success' : 'banner-error');
            b.innerHTML = '<i class="bi ' + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill') + '"></i><div class="banner-content"><h4>' + (type === 'success' ? 'Success' : 'Notice') + '</h4><p>' + msg + '</p></div>';
            b.style.display = 'flex';
            b.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        function saveProfileDraft() {
            serializeBankDetails();
            const formAction = document.getElementById('formAction');
            if (formAction) formAction.value = 'saveDraft';
            const btn = document.getElementById('btnSubmitVerificationTop');
            if (btn) btn.disabled = true;
            document.getElementById('hostProfileForm')?.submit();
        }

        function executeFinalSubmit() {
            serializeBankDetails();
            const status = calculateProfileStatus();
            if (status.missing.length > 0) {
                closeReviewModal();
                displayLiveBanner('Please complete all 19 required fields before submitting for verification.', 'error');
                focusMissingItem(status.missing[0].key);
                return;
            }

            const btn = document.getElementById('btnFinalSubmit');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Submitting Application...';
            }

            const formAction = document.getElementById('formAction');
            if (formAction) formAction.value = 'submitVerification';
            document.getElementById('hostProfileForm')?.submit();
        }

        function handleFormSubmit(e) {
            serializeBankDetails();
        }

        // -------------------------------------------------------------
        // DOM Ready: Attach Listeners
        // -------------------------------------------------------------
        document.addEventListener('DOMContentLoaded', function() {
            initLocationSelectors();
            parseExistingBankDetails();

            // Field input & blur bindings for immediate validation
            const validationMap = [
                { id: 'fullName', fn: validateFullName },
                { id: 'organizerType', fn: validateOrganizerType, evt: 'change' },
                { id: 'phone', fn: validatePhone },
                { id: 'organizerName', fn: validateOrganizerName },
                { id: 'whatsappNumber', fn: validateWhatsappNumber },
                { id: 'credentialNumber', fn: validateCredentialNumber },
                { id: 'yearsExperience', fn: validateYearsExperience },
                { id: 'officeAddress', fn: validateOfficeAddress },
                { id: 'pincode', fn: validatePincode },
                { id: 'mapsLocation', fn: validateMapsLocation },
                { id: 'openTime', fn: validateOperatingHours },
                { id: 'closeTime', fn: validateOperatingHours },
                { id: 'hostBio', fn: validateHostBio },
                { id: 'sessionMode', fn: validateSessionMode, evt: 'change' },
                { id: 'durationMinutes', fn: validateDurationMinutes },
                { id: 'typicalPrice', fn: validateTypicalPrice },
                { id: 'upiId', fn: validateUpiId },
                { id: 'bankAccountNumber', fn: validateBankAccountNumber },
                { id: 'bankConfirmAccountNumber', fn: validateBankConfirmAccountNumber },
                { id: 'bankIfsc', fn: validateBankIfsc },
                { id: 'profilePhoto', fn: validateProfilePhoto, evt: 'change' },
                { id: 'logoFile', fn: validateLogoPath, evt: 'change' },
                { id: 'documentFile', fn: validateDocumentFile, evt: 'change' }
            ];

            validationMap.forEach(item => {
                const el = document.getElementById(item.id);
                if (el) {
                    el.addEventListener('input', () => { item.fn(); recalculateProgress(); });
                    el.addEventListener('blur', () => { item.fn(); recalculateProgress(); });
                    if (item.evt) el.addEventListener(item.evt, () => { item.fn(); recalculateProgress(); });
                }
            });

            // Bank subfields
            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'bankConfirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', serializeBankDetails);
                    el.addEventListener('blur', serializeBankDetails);
                }
            });

            // Initial calculation
            recalculateProgress();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
