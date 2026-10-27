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
    <title>Complete Centre Profile — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Leaflet CSS for Map Picker (CSP Whitelisted via cdn.jsdelivr.net) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">
    <c:if test="${not empty googleMapsApiKey}">
        <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=places" async defer></script>
    </c:if>
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

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
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

        /* Expanded Responsive Main Container */
        .main-container {
            flex: 1;
            width: 100%;
            max-width: 1380px;
            margin: 18px auto 48px;
            padding: 0 clamp(16px, 3vw, 40px);
            box-sizing: border-box;
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
            width: 100%;
            box-sizing: border-box;
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

        .progress-pct-badge {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--rose-soft);
            border: 1px solid #FECDD3;
            padding: 4px 12px;
            border-radius: 999px;
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
            width: 100%;
            box-sizing: border-box;
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

        /* Section Cards & Form Grid */
        .section-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 22px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            transition: border-color 0.2s;
            width: 100%;
            box-sizing: border-box;
        }

        .section-card:hover {
            border-color: #CBD5E1;
        }

        .section-header {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-header i {
            color: var(--primary);
            font-size: 1.25rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 24px;
            width: 100%;
            box-sizing: border-box;
        }

        .form-group {
            margin-bottom: 0;
            min-width: 0;
            box-sizing: border-box;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            font-size: 0.84rem;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .form-group label .req {
            color: var(--primary);
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.92rem;
            font-family: inherit;
            color: var(--text-dark);
            background: #FFFFFF;
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border-color: var(--error) !important;
            background: #FFF5F5 !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid, .form-select.is-valid, .form-textarea.is-valid {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.08) !important;
        }

        .error-msg {
            display: none;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--error);
            margin-top: 5px;
            line-height: 1.4;
        }

        .error-msg.show {
            display: flex;
            align-items: center;
            gap: 5px;
            animation: fadeInErr 0.2s ease-in-out;
        }

        @keyframes fadeInErr {
            from { opacity: 0; transform: translateY(-2px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hint {
            font-size: 0.75rem;
            color: var(--text-gray);
            margin-top: 4px;
        }

        .cascade-info {
            font-size: 0.74rem;
            color: #475569;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .btn-map-picker {
            padding: 6px 14px;
            border-radius: 8px;
            background: var(--rose-soft);
            color: var(--primary);
            border: 1px solid #FECDD3;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-map-picker:hover {
            background: #FFE4E6;
            color: var(--primary-hover);
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
            color: var(--navy);
            transition: all 0.2s;
        }

        .chip-checkbox input:checked ~ .chip-label {
            background: var(--primary-soft);
            border-color: var(--primary);
            color: var(--primary);
            font-weight: 700;
        }

        /* Toggle Switches */
        .toggle-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            background: #F8FAFC;
            border-radius: 12px;
            margin-bottom: 12px;
            border: 1px solid #E2E8F0;
        }

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
            font-size: 0.75rem;
            color: var(--text-gray);
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 26px;
            flex-shrink: 0;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #CBD5E1;
            transition: .3s;
            border-radius: 34px;
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
        }

        input:checked + .slider {
            background-color: var(--primary);
        }

        input:checked + .slider:before {
            transform: translateX(22px);
        }

        /* Bottom Fixed Action Bar */
        .bottom-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            flex-wrap: wrap;
        }

        .btn-bottom-save {
            padding: 12px 24px;
            background: #FFFFFF;
            color: var(--navy);
            border: 1.5px solid var(--border-color);
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-bottom-save:hover {
            background: #F1F5F9;
            border-color: #94A3B8;
        }

        .btn-bottom-preview {
            padding: 12px 28px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 800;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.3);
        }

        .btn-bottom-preview:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.4);
        }

        /* Modal Overlay & Dialog */
        .preview-modal-backdrop, .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 16px;
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
            letter-spacing: 0.5px;
            color: var(--text-gray);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card-info-val {
            font-size: 0.92rem;
            color: var(--text-dark);
            line-height: 1.5;
        }

        .card-tags-flex {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 6px;
        }

        .card-tag {
            background: #EEF2F6;
            color: var(--navy);
            font-size: 0.8rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            border: 1px solid #E2E8F0;
        }

        .card-feature-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #ECFDF5;
            color: #065F46;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            border: 1px solid #A7F3D0;
        }

        .card-gallery-strip {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .card-gallery-img {
            width: 72px;
            height: 72px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid #E2E8F0;
        }

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

        /* Map Picker Modal */
        .map-modal-card {
            background: #fff;
            border-radius: 16px;
            max-width: 720px;
            width: 100%;
            padding: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }

        .map-modal-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        .map-modal-header .icon-wrap {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--rose-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .map-search-row {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            position: relative;
        }

        .map-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 170px;
            background: #fff;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }

        .map-suggestion-item {
            padding: 9px 12px;
            font-size: 0.84rem;
            cursor: pointer;
            border-bottom: 1px solid #F1F5F9;
        }

        .map-suggestion-item:hover {
            background: #F8FAFC;
            color: var(--primary);
        }

        .map-canvas-wrap {
            height: 330px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #CBD5E1;
            position: relative;
        }

        .map-selected-bar {
            margin-top: 10px;
            padding: 10px 14px;
            background: #F8FAFC;
            border-radius: 10px;
            border: 1px solid #E2E8F0;
        }

        .map-selected-label {
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--text-gray);
        }

        .map-provider-tag {
            font-size: 0.72rem;
            font-weight: 700;
            color: #059669;
            background: #ECFDF5;
            padding: 2px 8px;
            border-radius: 6px;
        }

        .map-selected-value {
            font-size: 0.86rem;
            font-weight: 600;
            color: var(--navy);
            margin-top: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .btn-modal-cancel {
            padding: 10px 18px;
            background: #fff;
            color: var(--navy);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-modal-confirm {
            padding: 10px 22px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-modal-confirm:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* Responsive Breakpoints */
        @media (max-width: 900px) {
            .form-grid {
                grid-template-columns: 1fr;
                gap: 14px;
            }
            .form-group.full {
                grid-column: auto;
            }
            .map-canvas-wrap {
                height: 270px;
            }
            .map-suggestions {
                right: 0;
            }
        }

        @media (max-width: 600px) {
            .app-header {
                padding: 12px 16px;
            }
            .main-container {
                padding: 0 12px;
                margin: 12px auto 36px;
            }
            .section-card {
                padding: 16px;
                border-radius: 12px;
            }
            .map-search-row {
                flex-direction: column;
            }
            .map-suggestions {
                right: 0;
            }
            .bottom-actions {
                flex-direction: column-reverse;
            }
            .btn-bottom-save, .btn-bottom-preview {
                width: 100%;
                justify-content: center;
            }
            .submit-action-card {
                padding: 16px;
            }
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
                    Profile Completion: <span id="pctText" class="progress-pct-badge">${center.profileCompletionPct != null ? center.profileCompletionPct : 0}%</span>
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
                Complete all 16 required milestones below to submit your centre for Admin verification and listing.
            </p>

            <!-- Dynamic Missing Items Chips -->
            <div id="missingChipsContainer" class="missing-chips">
                <span class="chip-missing" id="chip-name" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Centre Name</span>
                <span class="chip-missing" id="chip-type" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Centre Type</span>
                <span class="chip-missing" id="chip-contact" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Head Coach</span>
                <span class="chip-missing" id="chip-phone" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Official Phone</span>
                <span class="chip-missing" id="chip-location" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Street Address</span>
                <span class="chip-missing" id="chip-city" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> City</span>
                <span class="chip-missing" id="chip-state" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> State</span>
                <span class="chip-missing" id="chip-pincode" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Pincode</span>
                <span class="chip-missing" id="chip-styles" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Styles Taught</span>
                <span class="chip-missing" id="chip-audience" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Target Audience</span>
                <span class="chip-missing" id="chip-days" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Open Days</span>
                <span class="chip-missing" id="chip-hours" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Operating Hours</span>
                <span class="chip-missing" id="chip-about" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> About Centre</span>
                <span class="chip-missing" id="chip-teach" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Teaching Method</span>
                <span class="chip-missing" id="chip-offers" style="display:none;"><i class="bi bi-exclamation-circle me-1"></i> Offerings</span>
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

            <!-- SECTION 1: Centre Identity & Contact -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-building"></i> 1. Centre Identity &amp; Contact
                </div>
                
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="inputName">1.1 Centre Name <span class="req">*</span></label>
                        <input type="text" name="name" id="inputName" class="form-input" value="${center.name}" placeholder="e.g. Apex Martial Arts Academy" maxlength="80" required>
                        <div class="hint">Official academy, dojo or training studio name (minimum 2 characters).</div>
                        <div class="error-msg" id="err-name"><i class="bi bi-exclamation-circle-fill"></i> Centre name is required (minimum 2 characters).</div>
                    </div>

                    <div class="form-group">
                        <label for="inputCentreType">1.2 Centre Type <span class="req">*</span></label>
                        <select name="centreType" id="inputCentreType" class="form-select">
                            <option value="Academy" ${center.centreType == 'Academy' ? 'selected' : ''}>Academy</option>
                            <option value="Dojo" ${center.centreType == 'Dojo' ? 'selected' : ''}>Dojo</option>
                            <option value="Training hall" ${center.centreType == 'Training hall' ? 'selected' : ''}>Training hall</option>
                            <option value="Home studio" ${center.centreType == 'Home studio' ? 'selected' : ''}>Home studio</option>
                            <option value="Community hall" ${center.centreType == 'Community hall' ? 'selected' : ''}>Community hall</option>
                            <option value="Outdoor" ${center.centreType == 'Outdoor' ? 'selected' : ''}>Outdoor</option>
                        </select>
                        <div class="error-msg" id="err-centreType"><i class="bi bi-exclamation-circle-fill"></i> Centre type is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputContactPerson">1.3 Owner / Head Coach <span class="req">*</span></label>
                        <input type="text" name="contactPerson" id="inputContactPerson" class="form-input" value="${center.contactPerson}" placeholder="e.g. Sensei Rajesh Kumar" maxlength="60" required>
                        <div class="hint">Name of chief instructor or manager (letters and spaces only).</div>
                        <div class="error-msg" id="err-contactPerson"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid owner or coach name.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputDesignation">1.4 Designation</label>
                        <select name="designation" id="inputDesignation" class="form-select">
                            <option value="Head coach" ${center.designation == 'Head coach' ? 'selected' : ''}>Head coach</option>
                            <option value="Owner" ${center.designation == 'Owner' ? 'selected' : ''}>Owner</option>
                            <option value="Manager" ${center.designation == 'Manager' ? 'selected' : ''}>Manager</option>
                            <option value="Instructor" ${center.designation == 'Instructor' ? 'selected' : ''}>Instructor</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="inputPhone">1.5 Official Phone Number <span class="req">*</span></label>
                        <input type="tel" name="phone" id="inputPhone" class="form-input" value="${center.phoneNumber}" maxlength="10" inputmode="numeric" placeholder="10-digit mobile number" required>
                        <div class="hint">10-digit mobile number starting with 6, 7, 8, or 9.</div>
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Valid 10-digit phone number is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputWhatsapp">1.6 WhatsApp Number</label>
                        <input type="tel" name="whatsappNumber" id="inputWhatsapp" class="form-input" value="${center.whatsappNumber}" placeholder="10-digit WhatsApp number" maxlength="10" inputmode="numeric">
                        <div class="hint">Optional direct student inquiry number (10 digits).</div>
                        <div class="error-msg" id="err-whatsapp"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 10-digit WhatsApp number.</div>
                    </div>

                    <div class="form-group">
                        <label for="inputYearStarted">1.7 Year Started</label>
                        <input type="text" name="yearStarted" id="inputYearStarted" class="form-input" value="${center.yearStarted}" placeholder="e.g. 2018" maxlength="4" inputmode="numeric">
                        <div class="hint">Year established between 1950 and current year.</div>
                        <div class="error-msg" id="err-yearStarted"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid year between 1950 and current year.</div>
                    </div>

                    <div class="form-group full">
                        <label for="inputAffiliation">1.8 Federation / Style Affiliation</label>
                        <input type="text" name="affiliation" id="inputAffiliation" class="form-input" value="${center.affiliation}" placeholder="e.g. World Karate Federation, KAI, Indian Boxing Association" maxlength="120">
                        <div class="hint">Official sports council, federation, or black-belt certifying body.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Location & Address (Cascading Dropdowns & Map Picker) -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-geo-alt-fill"></i> 2. Location &amp; Premises Address
                </div>
                
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="inputLocation">2.1 Street Address / Hall / Landmark <span class="req">*</span></label>
                        <input type="text" name="location" id="inputLocation" class="form-input" value="${not empty center.location ? center.location : center.area}" placeholder="Door/Plot No, Hall name, Landmark, Road" maxlength="250" required>
                        <div class="hint">Full premises address, training floor, or landmark for student navigation.</div>
                        <div class="error-msg" id="err-location"><i class="bi bi-exclamation-circle-fill"></i> Street address or hall name is required (at least 3 characters).</div>
                    </div>

                    <div class="form-group">
                        <label for="countrySelect">
                            2.2 Country <span class="req">*</span>
                        </label>
                        <select name="country" id="countrySelect" class="form-select">
                            <option value="India" selected>India</option>
                            <option value="United States">United States</option>
                            <option value="United Kingdom">United Kingdom</option>
                            <option value="Canada">Canada</option>
                            <option value="Australia">Australia</option>
                            <option value="United Arab Emirates">United Arab Emirates</option>
                            <option value="Singapore">Singapore</option>
                            <option value="Other">Other</option>
                        </select>
                        <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting a country updates the available states / regions</div>
                        <div class="error-msg" id="err-country"><i class="bi bi-exclamation-circle-fill"></i> Country is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="stateSelect">
                            2.3 State / Region <span class="req">*</span>
                        </label>
                        <select name="state" id="stateSelect" class="form-select">
                            <option value="">-- Select State / Region --</option>
                        </select>
                        <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting a state updates the available districts / cities</div>
                        <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> State is required.</div>
                    </div>

                    <div class="form-group">
                        <label for="districtSelect">
                            2.4 District / City <span class="req">*</span>
                        </label>
                        <select id="districtSelect" class="form-select">
                            <option value="">-- Select State First --</option>
                        </select>
                        <div class="cascade-info"><i class="bi bi-check-circle"></i> Filters to chosen state's districts / cities</div>
                        <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> District / City is required.</div>
                    </div>

                    <div class="form-group" id="customCityGroup" style="display:none;">
                        <label for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                        <input type="text" id="customCityInput" class="form-input" placeholder="Type city or town name" maxlength="60">
                        <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                    </div>
                    <input type="hidden" name="city" id="inputCity" value="${center.city}">

                    <div class="form-group">
                        <label for="inputPincode">2.5 Pincode <span class="req">*</span></label>
                        <input type="text" name="pincode" id="inputPincode" class="form-input" value="${center.pincode}" placeholder="6-digit Pincode" maxlength="6" inputmode="numeric" required>
                        <div class="hint">6-digit postal code (e.g. 400001).</div>
                        <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 6-digit pincode.</div>
                    </div>

                    <div class="form-group full">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; flex-wrap: wrap; gap: 8px;">
                            <label for="inputMapLink" style="margin-bottom: 0;">2.6 Google Map Location Link</label>
                            <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                                <i class="bi bi-geo-alt-fill"></i> Select from Map
                            </button>
                        </div>
                        <input type="url" name="mapLink" id="inputMapLink" class="form-input" value="${center.googleMapLocation}" placeholder="https://maps.google.com/?q=... or click Select from Map">
                        <input type="hidden" name="centreLat" id="inputCentreLat" value="${center.centreLat}">
                        <input type="hidden" name="centreLng" id="inputCentreLng" value="${center.centreLng}">
                        <div class="hint">Click <strong>Select from Map</strong> to search or pin your centre, or paste your Google Maps link.</div>
                        <div class="error-msg" id="err-mapLink"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid URL starting with http:// or https://.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Martial Arts Styles -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-award-fill"></i> 3. Martial Arts Styles Taught <span class="req">*</span>
                </div>
                <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 12px;">Select all combat disciplines and martial arts systems offered at your centre:</p>
                <div class="chips-container" id="stylesContainer">
                    <c:forEach var="style" items="${['Karate', 'Taekwondo', 'Self-Defence', 'Kickboxing', 'Boxing', 'MMA', 'Judo', 'Krav Maga', 'Jiu-Jitsu', 'Kung Fu', 'Muay Thai', 'Kalari']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="styles" value="${style}" class="style-checkbox" ${center.stylesTaught != null && center.stylesTaught.contains(style) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                            <span class="chip-label"><i class="bi bi-check2"></i> ${style}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-styles"><i class="bi bi-exclamation-circle-fill"></i> Select at least one martial arts style taught.</div>
            </div>

            <!-- SECTION 4: Target Audience -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-people-fill"></i> 4. Who Can Join (Target Audience) <span class="req">*</span>
                </div>
                <div class="chips-container" id="audienceContainer">
                    <c:forEach var="aud" items="${['Women & Girls', 'Kids (5-12 yrs)', 'Teens & College Students', 'Beginners & Working Women', 'Professional Athletes', 'Senior Citizens']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="audience" value="${aud}" class="aud-checkbox" ${center.audience != null && center.audience.contains(aud) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                            <span class="chip-label"><i class="bi bi-check2"></i> ${aud}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="error-msg" id="err-audience"><i class="bi bi-exclamation-circle-fill"></i> Select at least one target audience category.</div>
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
                    <i class="bi bi-clock-history"></i> 6. Available Days &amp; Timings <span class="req">*</span>
                </div>
                
                <div class="form-group full" style="margin-bottom: 16px;">
                    <label>6.1 Open Days <span class="req">*</span></label>
                    <div class="chips-container" id="daysContainer">
                        <c:forEach var="day" items="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']}">
                            <label class="chip-checkbox">
                                <input type="checkbox" name="availableDays" value="${day}" class="day-checkbox" ${center.availableDays != null && center.availableDays.toString().contains(day) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                                <span class="chip-label"><i class="bi bi-calendar-event"></i> ${day}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="error-msg" id="err-availableDays"><i class="bi bi-exclamation-circle-fill"></i> Select at least one open training day.</div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="inputOpenTime">6.2 Opening Time <span class="req">*</span></label>
                        <input type="time" name="openTime" id="inputOpenTime" class="form-input" value="${not empty center.openTime ? center.openTime : '06:00'}" required onchange="triggerRecalculateProgress()">
                        <div class="error-msg" id="err-openTime"><i class="bi bi-exclamation-circle-fill"></i> Opening time is required.</div>
                    </div>
                    <div class="form-group">
                        <label for="inputCloseTime">6.3 Closing Time <span class="req">*</span></label>
                        <input type="time" name="closeTime" id="inputCloseTime" class="form-input" value="${not empty center.closeTime ? center.closeTime : '21:00'}" required onchange="triggerRecalculateProgress()">
                        <div class="error-msg" id="err-closeTime"><i class="bi bi-exclamation-circle-fill"></i> Closing time is required.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 7: About the Centre -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-card-text"></i> 7. About the Centre &amp; Methodology <span class="req">*</span>
                </div>

                <div class="form-grid">
                    <div class="form-group full">
                        <label for="inputAbout">7.1 About the Centre &amp; Philosophy <span class="req">*</span></label>
                        <textarea name="about" id="inputAbout" class="form-textarea" rows="4" placeholder="Describe your training ethos, instructors, safety standards, and dojo culture..." required maxlength="2000" oninput="triggerRecalculateProgress()"><c:out value="${center.about}"/></textarea>
                        <div class="hint">Minimum 10 characters detailing your centre history and values.</div>
                        <div class="error-msg" id="err-about"><i class="bi bi-exclamation-circle-fill"></i> About section is required (minimum 10 characters).</div>
                    </div>

                    <div class="form-group full">
                        <label for="inputHowWeTeach">7.2 How We Teach &amp; Step-by-Step Methodology <span class="req">*</span></label>
                        <textarea name="howWeTeach" id="inputHowWeTeach" class="form-textarea" rows="3" placeholder="Explain your teaching progression (warmups, belt grading, sparring, self-defense drills)..." required maxlength="1500" oninput="triggerRecalculateProgress()"><c:out value="${center.howWeTeach}"/></textarea>
                        <div class="hint">Minimum 10 characters describing coaching style and belt progression.</div>
                        <div class="error-msg" id="err-howWeTeach"><i class="bi bi-exclamation-circle-fill"></i> Teaching methodology is required (minimum 10 characters).</div>
                    </div>

                    <div class="form-group full">
                        <label>7.3 What We Offer <span class="req">*</span></label>
                        <div class="chips-container" id="offersContainer">
                            <c:forEach var="offer" items="${['Regular class', 'Trial class', 'Belt grading', 'Workshops', 'Self-defence crash course']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="offers" value="${offer}" class="offer-checkbox" ${center.whatWeOffer != null && center.whatWeOffer.contains(offer) ? 'checked' : ''} onchange="triggerRecalculateProgress()">
                                    <span class="chip-label"><i class="bi bi-check2"></i> ${offer}</span>
                                </label>
                            </c:forEach>
                        </div>
                        <div class="error-msg" id="err-offers"><i class="bi bi-exclamation-circle-fill"></i> Select at least one training offer.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 8: Payout & Settlement Details -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-bank"></i> 8. Payout &amp; Bank Account Details
                </div>
                
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="inputUpiId">8.1 Direct UPI ID (Optional)</label>
                        <input type="text" name="upiId" id="inputUpiId" class="form-input" value="${center.upiId}" placeholder="centre@upi" maxlength="80">
                        <div class="hint">Virtual Payment Address for automated fee settlements.</div>
                        <div class="error-msg" id="err-upiId"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid UPI ID (e.g. name@bank).</div>
                    </div>

                    <div class="form-group">
                        <label for="bankAccountHolder">8.2 Account Holder Name</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank records" maxlength="80">
                    </div>
                    <div class="form-group">
                        <label for="bankName">8.3 Bank Name</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. HDFC Bank, ICICI Bank, SBI" maxlength="80">
                    </div>

                    <div class="form-group">
                        <label for="bankAccountNumber">8.4 Account Number</label>
                        <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Bank Account Number" maxlength="20" inputmode="numeric">
                    </div>
                    <div class="form-group">
                        <label for="confirmAccountNumber">8.5 Confirm Account Number</label>
                        <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Re-enter Account Number" maxlength="20" inputmode="numeric">
                        <small id="accMismatchMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="bankIfsc">8.6 IFSC Code</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. HDFC0001234" maxlength="11" style="text-transform: uppercase;">
                        <small id="ifscFormatMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Invalid IFSC format (e.g. SBIN0001234)
                        </small>
                    </div>
                    <div class="form-group">
                        <label for="bankBranch">8.7 Branch Name</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Andheri West Branch" maxlength="80">
                    </div>
                </div>

                <!-- Hidden serialized field for DB compatibility -->
                <input type="hidden" id="bankDetails" name="bankDetails" value="${center.bankDetails}">
            </div>

            <!-- SECTION 9: Trainer Certificate / Documents -->
            <div class="section-card">
                <div class="section-header">
                    <i class="bi bi-file-earmark-check"></i> 9. Trainer Certification &amp; Proof (Optional)
                </div>
                <div class="form-group full">
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
                <c:if test="${not empty center.galleryPhotos}">
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

    <!-- Map Location Picker Modal (Leaflet + OSM, CSP Compliant) -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" style="display:none;">
        <div class="map-modal-card">
            <div class="map-modal-header">
                <div class="icon-wrap"><i class="bi bi-geo-alt-fill"></i></div>
                <div style="flex: 1;">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0;">Select Centre Location</h3>
                    <p style="font-size: 0.8rem; color: var(--text-gray); margin: 0;">Search address or click on the map to pin your centre</p>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close location picker">&times;</button>
            </div>
            <div class="map-search-row">
                <div style="position: relative; flex: 1;">
                    <input type="text" id="mapSearchInput" class="form-input" placeholder="Search landmark, area, or street..." autocomplete="off">
                    <div class="map-suggestions" id="mapSuggestions"></div>
                </div>
                <button type="button" class="btn-modal-cancel" id="btnSearchMap" title="Search location"><i class="bi bi-search"></i> Search</button>
                <button type="button" class="btn-modal-cancel" id="btnLocateMe" title="Use current GPS location"><i class="bi bi-crosshair"></i> GPS</button>
            </div>
            <div id="mapPickerAlert" style="display:none; margin-bottom:10px; padding:8px 12px; font-size:0.82rem; background:#FEF2F2; color:#991B1B; border-radius:8px;"></div>
            <div class="map-canvas-wrap">
                <div id="mapContainer" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="map-selected-bar">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:3px;">
                    <span class="map-selected-label">Chosen Centre Location</span>
                    <span class="map-provider-tag" id="mapProviderBadge">Interactive Map</span>
                </div>
                <div class="map-selected-value" id="mapSelectedAddress">Click on the map or search to choose your centre location</div>
            </div>
            <div style="margin-top: 14px; display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn-modal-cancel" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Use This Location
                </button>
            </div>
        </div>
    </div>

    <!-- PREVIEW PROFILE MODAL -->
    <div id="previewModalBackdrop" class="preview-modal-backdrop" onclick="handleBackdropClick(event)">
        <div class="preview-modal-dialog">
            <div class="preview-modal-header">
                <h3><i class="bi bi-award-fill" style="color: var(--primary);"></i> Centre Profile Preview</h3>
                <button type="button" class="btn-close-modal" onclick="closePreviewModal()">&times;</button>
            </div>
            <div class="preview-modal-body">
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
                                <i class="bi bi-patch-check-fill text-primary" title="Verified"></i>
                            </div>
                            <div class="card-hero-sub">
                                <span><i class="bi bi-person-fill me-1"></i> <span id="modalCoach">Sensei Rajesh Kumar</span> (<span id="modalDesignation">Head Coach</span>)</span>
                            </div>
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <span class="card-badge-pill" id="modalCentreType">Academy</span>
                                <span class="card-badge-pill" id="modalLocation"><i class="bi bi-geo-alt-fill text-danger me-1"></i> Mumbai, Maharashtra</span>
                            </div>
                        </div>
                    </div>

                    <!-- Content Grid -->
                    <div class="card-content-grid">
                        <!-- Key Highlights -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 14px;">
                            <div class="card-info-box">
                                <div class="card-info-label"><i class="bi bi-clock-fill text-primary"></i> Operating Hours</div>
                                <div class="card-info-val" id="modalHours">06:00 - 21:00</div>
                                <div class="card-tags-flex" id="modalDaysTags"></div>
                            </div>
                            <div class="card-info-box">
                                <div class="card-info-label"><i class="bi bi-shield-check text-success"></i> Women Safety Highlights</div>
                                <div style="display: flex; flex-direction: column; gap: 6px; margin-top: 4px;">
                                    <span class="card-feature-pill" id="modalWomenOnlyBadge" style="display: none;">
                                        <i class="bi bi-gender-female text-danger"></i> Exclusive Women-Only Batches
                                    </span>
                                    <span class="card-feature-pill" id="modalFemaleInstBadge" style="display: none;">
                                        <i class="bi bi-check-circle-fill text-success"></i> Female Instructor Present
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Styles & Audience -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-award-fill text-danger"></i> Martial Arts Disciplines Offered</div>
                            <div class="card-tags-flex" id="modalStylesTags"></div>
                        </div>

                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-people-fill text-primary"></i> Who Can Join</div>
                            <div class="card-tags-flex" id="modalAudienceTags"></div>
                        </div>

                        <!-- Amenities -->
                        <div class="card-info-box" id="modalFacilitiesBox">
                            <div class="card-info-label"><i class="bi bi-check-circle-fill text-success"></i> Dojo Facilities</div>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 6px;" id="modalFacilitiesTags"></div>
                        </div>

                        <!-- About & Methodology -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-card-text text-primary"></i> About the Centre</div>
                            <div class="card-info-val" id="modalAboutText"></div>
                        </div>

                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-journal-text text-primary"></i> Teaching Methodology</div>
                            <div class="card-info-val" id="modalHowWeTeachText"></div>
                        </div>

                        <!-- Gallery Preview Strip -->
                        <div class="card-info-box" id="modalGalleryBox">
                            <div class="card-info-label"><i class="bi bi-images text-primary"></i> Dojo Gallery</div>
                            <div class="card-gallery-strip" id="modalGalleryStrip"></div>
                        </div>

                        <!-- Bank & Settlement Info -->
                        <div class="card-info-box">
                            <div class="card-info-label"><i class="bi bi-bank text-primary"></i> Settlement &amp; Payout Account</div>
                            <div class="card-info-val" id="modalBankSummary">Direct Bank details not provided yet</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="preview-modal-footer">
                <button type="button" class="btn-modal-edit" onclick="closePreviewModal()">
                    <i class="bi bi-pencil"></i> Back to Editing
                </button>
                <button type="button" class="btn-modal-save" onclick="saveProfileDirectly()">
                    <i class="bi bi-save2"></i> Save Changes
                </button>
                <button type="button" class="btn-modal-submit" onclick="submitForVerification()">
                    <i class="bi bi-send-check"></i> Submit for Verification
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS (CSP Whitelisted via cdn.jsdelivr.net) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <!-- Script Logic -->
    <script>
        const ctx = '${pageContext.request.contextPath}';
        const savedCountry = '${not empty center.state ? "India" : "India"}';
        const savedState = '${not empty center.state ? center.state : ""}';
        const savedCity = '${not empty center.city ? center.city : ""}';
        let newlySelectedGalleryFiles = [];

        // -------------------------------------------------------------
        // Cascading Location Selectors Dataset (India States & Districts)
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
                "Illinois": ["Chicago", "Aurora", "Naperville", "Rockford", "Other"]
            },
            "Other": {
                "Region / Province": ["Metropolitan Area", "Central District", "Other"]
            }
        };

        function setFieldStatus(id, isError, customMsg) {
            const input = document.getElementById(id);
            const errEl = document.getElementById('err-' + id.replace('input', '').toLowerCase()) || document.getElementById('err-' + id);
            if (input) {
                if (isError) {
                    input.classList.add('is-invalid');
                    input.classList.remove('is-valid');
                } else {
                    input.classList.remove('is-invalid');
                    if (input.value && input.value.trim().length > 0) {
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                    }
                }
            }
            if (errEl) {
                if (customMsg) errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + customMsg;
                if (isError) errEl.classList.add('show');
                else errEl.classList.remove('show');
            }
        }

        function val(id) {
            const el = document.getElementById(id);
            return el ? el.value.trim() : '';
        }

        function initLocationSelectors() {
            const countrySelect = document.getElementById('countrySelect');
            const stateSelect = document.getElementById('stateSelect');
            const districtSelect = document.getElementById('districtSelect');
            const customCityGroup = document.getElementById('customCityGroup');
            const customCityInput = document.getElementById('customCityInput');
            const cityInput = document.getElementById('inputCity');

            function populateStates(country, selectedState) {
                if (!stateSelect) return;
                stateSelect.innerHTML = '<option value="">-- Select State / Region --</option>';

                const statesObj = locationData[country] || locationData["Other"] || {};
                const stateNames = Object.keys(statesObj).sort();

                stateNames.forEach(st => {
                    const opt = document.createElement('option');
                    opt.value = st;
                    opt.textContent = st;
                    if (st === selectedState) opt.selected = true;
                    stateSelect.appendChild(opt);
                });

                if (selectedState && stateSelect.value === selectedState) {
                    populateDistricts(country, selectedState, savedCity);
                } else {
                    if (districtSelect) districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    if (customCityGroup) customCityGroup.style.display = 'none';
                }
            }

            function populateDistricts(country, state, selectedDistrict) {
                if (!districtSelect) return;
                districtSelect.innerHTML = '<option value="">-- Select District / City --</option>';
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
                triggerRecalculateProgress();
            }

            if (countrySelect) {
                countrySelect.addEventListener('change', () => {
                    populateStates(countrySelect.value, '');
                    if (cityInput) cityInput.value = '';
                    setFieldStatus('countrySelect', false);
                    triggerRecalculateProgress();
                });
            }

            if (stateSelect) {
                stateSelect.addEventListener('change', () => {
                    populateDistricts(countrySelect.value, stateSelect.value, '');
                    setFieldStatus('stateSelect', false);
                    triggerRecalculateProgress();
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
                    setFieldStatus('districtSelect', false);
                    triggerRecalculateProgress();
                });
            }

            if (customCityInput) {
                customCityInput.addEventListener('input', () => {
                    if (cityInput) cityInput.value = customCityInput.value.trim();
                    setFieldStatus('customCityInput', false);
                    setFieldStatus('districtSelect', false);
                    triggerRecalculateProgress();
                });
            }

            populateStates(countrySelect ? countrySelect.value : 'India', savedState);
        }

        // -------------------------------------------------------------
        // Leaflet Map Picker Implementation (Interactive, Search, GPS, CSP Compliant)
        // -------------------------------------------------------------
        let currentMap = null;
        let currentMarker = null;
        let mapInitialized = false;
        let selectedCentreCoords = null;
        let selectedLocationAddress = '';

        const mapPickerModal = document.getElementById('mapPickerModal');
        const btnOpenMapPicker = document.getElementById('btnOpenMapPicker');
        const btnCloseMapModal = document.getElementById('btnCloseMapModal');
        const btnCancelMap = document.getElementById('btnCancelMap');
        const btnConfirmLocation = document.getElementById('btnConfirmLocation');
        const btnSearchMap = document.getElementById('btnSearchMap');
        const btnLocateMe = document.getElementById('btnLocateMe');
        const mapSearchInput = document.getElementById('mapSearchInput');
        const mapSuggestions = document.getElementById('mapSuggestions');
        const mapSelectedAddressEl = document.getElementById('mapSelectedAddress');
        const mapPickerAlert = document.getElementById('mapPickerAlert');

        function showMapAlert(msg) {
            if (!mapPickerAlert) return;
            if (msg) {
                mapPickerAlert.textContent = msg;
                mapPickerAlert.style.display = 'block';
            } else {
                mapPickerAlert.style.display = 'none';
                mapPickerAlert.textContent = '';
            }
        }

        function setSelectedLocation(formattedAddress, lat, lng) {
            selectedCentreCoords = { lat: lat, lng: lng };
            selectedLocationAddress = formattedAddress || '';
            if (mapSelectedAddressEl) {
                mapSelectedAddressEl.textContent = selectedLocationAddress || ('Location (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')');
            }
            if (btnConfirmLocation) {
                btnConfirmLocation.disabled = !selectedLocationAddress && !selectedCentreCoords;
            }
        }

        async function reverseGeocodeCoords(lat, lng) {
            setSelectedLocation('Resolving centre address...', lat, lng);
            showMapAlert('');
            try {
                const res = await fetch(ctx + '/api/auth/geo/reverse?lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng), {
                    headers: { 'Accept': 'application/json' },
                    credentials: 'same-origin'
                });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.success && data.address) {
                        setSelectedLocation(data.address, lat, lng);
                        return;
                    }
                }
            } catch (e) {
                console.warn('[MapPicker] Reverse geocode fetch failed:', e);
            }
            setSelectedLocation('Centre Location (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')', lat, lng);
        }

        function initMapPicker() {
            if (typeof L === 'undefined') {
                showMapAlert('Map library is currently loading or restricted. You can paste your Google Maps link directly.');
                return;
            }

            if (mapInitialized && currentMap) {
                setTimeout(function() {
                    if (currentMap.invalidateSize) currentMap.invalidateSize();
                    if (selectedCentreCoords && currentMarker) {
                        currentMap.setView([selectedCentreCoords.lat, selectedCentreCoords.lng], 14);
                        currentMarker.setLatLng([selectedCentreCoords.lat, selectedCentreCoords.lng]);
                    }
                }, 100);
                return;
            }

            let defaultLat = 19.0760;
            let defaultLng = 72.8777; // Mumbai default

            // Check existing lat/lng
            const latVal = val('inputCentreLat');
            const lngVal = val('inputCentreLng');
            if (latVal && lngVal && !isNaN(parseFloat(latVal)) && !isNaN(parseFloat(lngVal))) {
                defaultLat = parseFloat(latVal);
                defaultLng = parseFloat(lngVal);
            } else {
                // Check map link
                const existingMapUrl = val('inputMapLink');
                if (existingMapUrl) {
                    const match = existingMapUrl.match(/q=([0-9.-]+),([0-9.-]+)/) || existingMapUrl.match(/@([0-9.-]+),([0-9.-]+)/);
                    if (match) {
                        defaultLat = parseFloat(match[1]);
                        defaultLng = parseFloat(match[2]);
                    }
                }
            }

            const existingSearch = val('inputLocation') || val('inputCity') || val('inputName');
            if (existingSearch && mapSearchInput && !mapSearchInput.value) {
                mapSearchInput.value = existingSearch;
            }

            try {
                currentMap = L.map('mapContainer', {
                    center: [defaultLat, defaultLng],
                    zoom: 13,
                    zoomControl: true
                });

                L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '&copy; OpenStreetMap'
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

                setTimeout(function() {
                    if (currentMap.invalidateSize) currentMap.invalidateSize();
                    reverseGeocodeCoords(defaultLat, defaultLng);
                }, 150);

            } catch (err) {
                console.error('[MapPicker] Failed to init Leaflet:', err);
                showMapAlert('Map renderer error. You can paste your Google Maps link directly.');
            }
        }

        async function executeSearch(query) {
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
                showMapAlert('No location results found for "' + query + '". Try a prominent landmark, area, or city name.');
            } catch (e) {
                showMapAlert('Network error searching location. You can click on the map to set location.');
            }
        }

        function renderSuggestions(results) {
            if (!mapSuggestions) return;
            mapSuggestions.innerHTML = '';
            results.forEach(function (item) {
                const div = document.createElement('div');
                div.className = 'map-suggestion-item';
                div.textContent = item.address;
                div.addEventListener('click', function () {
                    applySearchResult(item);
                    mapSuggestions.style.display = 'none';
                });
                mapSuggestions.appendChild(div);
            });
            mapSuggestions.style.display = 'block';
        }

        function applySearchResult(item) {
            if (!item || !currentMap || !currentMarker) return;
            const lat = item.lat;
            const lng = item.lng;
            currentMap.setView([lat, lng], 15);
            currentMarker.setLatLng([lat, lng]);
            setSelectedLocation(item.address, lat, lng);
        }

        function closeMapPicker() {
            if (mapPickerModal) mapPickerModal.style.display = 'none';
            if (mapSuggestions) mapSuggestions.style.display = 'none';
            showMapAlert('');
        }

        if (btnOpenMapPicker) {
            btnOpenMapPicker.addEventListener('click', function () {
                if (mapPickerModal) mapPickerModal.style.display = 'flex';
                initMapPicker();
            });
        }
        if (btnCloseMapModal) btnCloseMapModal.addEventListener('click', closeMapPicker);
        if (btnCancelMap) btnCancelMap.addEventListener('click', closeMapPicker);

        if (btnSearchMap && mapSearchInput) {
            btnSearchMap.addEventListener('click', function () {
                executeSearch(mapSearchInput.value);
            });
            mapSearchInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    executeSearch(this.value);
                }
            });
        }

        if (btnLocateMe) {
            btnLocateMe.addEventListener('click', function () {
                if (!navigator.geolocation) {
                    showMapAlert('Geolocation is not supported by your browser.');
                    return;
                }
                btnLocateMe.disabled = true;
                showMapAlert('Requesting your GPS location...');
                navigator.geolocation.getCurrentPosition(function (pos) {
                    btnLocateMe.disabled = false;
                    showMapAlert('');
                    const lat = pos.coords.latitude;
                    const lng = pos.coords.longitude;
                    if (currentMap && currentMarker) {
                        currentMap.setView([lat, lng], 16);
                        currentMarker.setLatLng([lat, lng]);
                    }
                    reverseGeocodeCoords(lat, lng);
                }, function (err) {
                    btnLocateMe.disabled = false;
                    showMapAlert('Location access was denied or timed out. You can click on the map to set your location.');
                }, { timeout: 10000, enableHighAccuracy: true });
            });
        }

        if (btnConfirmLocation) {
            btnConfirmLocation.addEventListener('click', function () {
                if (!selectedCentreCoords) return;

                // 1. Google Maps URL
                const mapUrlInput = document.getElementById('inputMapLink');
                if (mapUrlInput) {
                    mapUrlInput.value = 'https://www.google.com/maps?q=' + selectedCentreCoords.lat.toFixed(6) + ',' + selectedCentreCoords.lng.toFixed(6);
                    setFieldStatus('inputMapLink', false);
                }

                // 2. Latitude & Longitude
                const latInput = document.getElementById('inputCentreLat');
                const lngInput = document.getElementById('inputCentreLng');
                if (latInput) latInput.value = selectedCentreCoords.lat.toFixed(6);
                if (lngInput) lngInput.value = selectedCentreCoords.lng.toFixed(6);

                // 3. Address
                const addrInput = document.getElementById('inputLocation');
                if (addrInput && (!addrInput.value || addrInput.value.trim().length < 5) && selectedLocationAddress) {
                    addrInput.value = selectedLocationAddress;
                    setFieldStatus('inputLocation', false);
                }

                // 4. Pincode extraction
                if (selectedLocationAddress) {
                    const pinMatch = selectedLocationAddress.match(/([1-9][0-9]{5})/);
                    const pinInput = document.getElementById('inputPincode');
                    if (pinMatch && pinInput && !pinInput.value) {
                        pinInput.value = pinMatch[1];
                        setFieldStatus('inputPincode', false);
                    }
                }

                closeMapPicker();
                triggerRecalculateProgress();
            });
        }

        // -------------------------------------------------------------
        // Accurate Real-Time Profile Progress Calculation (16 Milestones, matching backend)
        // -------------------------------------------------------------
        function triggerRecalculateProgress() {
            let filled = 0;
            const total = 16;

            // 1. Centre Name
            const name = val('inputName');
            const nameOk = name.length >= 2;
            if (nameOk) filled++;
            const chipName = document.getElementById('chip-name');
            if (chipName) chipName.style.display = nameOk ? 'none' : 'inline-flex';

            // 2. Centre Type
            const centreType = val('inputCentreType');
            const typeOk = centreType.length > 0;
            if (typeOk) filled++;
            const chipType = document.getElementById('chip-type');
            if (chipType) chipType.style.display = typeOk ? 'none' : 'inline-flex';

            // 3. Contact Person (Owner/Coach)
            const contact = val('inputContactPerson');
            const contactOk = contact.length >= 2;
            if (contactOk) filled++;
            const chipContact = document.getElementById('chip-contact');
            if (chipContact) chipContact.style.display = contactOk ? 'none' : 'inline-flex';

            // 4. Official Phone (10 digits)
            const phone = val('inputPhone');
            const phoneOk = /^\d{10}$/.test(phone);
            if (phoneOk) filled++;
            const chipPhone = document.getElementById('chip-phone');
            if (chipPhone) chipPhone.style.display = phoneOk ? 'none' : 'inline-flex';

            // 5. Street Address / Location
            const loc = val('inputLocation');
            const locOk = loc.length >= 3;
            if (locOk) filled++;
            const chipLoc = document.getElementById('chip-location');
            if (chipLoc) chipLoc.style.display = locOk ? 'none' : 'inline-flex';

            // 6. City
            const city = val('inputCity');
            const cityOk = city.length > 0;
            if (cityOk) filled++;
            const chipCity = document.getElementById('chip-city');
            if (chipCity) chipCity.style.display = cityOk ? 'none' : 'inline-flex';

            // 7. State
            const state = val('stateSelect');
            const stateOk = state.length > 0;
            if (stateOk) filled++;
            const chipState = document.getElementById('chip-state');
            if (chipState) chipState.style.display = stateOk ? 'none' : 'inline-flex';

            // 8. Pincode (6 digits)
            const pincode = val('inputPincode');
            const pinOk = /^\d{6}$/.test(pincode);
            if (pinOk) filled++;
            const chipPin = document.getElementById('chip-pincode');
            if (chipPin) chipPin.style.display = pinOk ? 'none' : 'inline-flex';

            // 9. Styles Taught
            const stylesCount = document.querySelectorAll('.style-checkbox:checked').length;
            const stylesOk = stylesCount > 0;
            if (stylesOk) filled++;
            const chipStyles = document.getElementById('chip-styles');
            if (chipStyles) chipStyles.style.display = stylesOk ? 'none' : 'inline-flex';

            // 10. Target Audience
            const audCount = document.querySelectorAll('.aud-checkbox:checked').length;
            const audOk = audCount > 0;
            if (audOk) filled++;
            const chipAud = document.getElementById('chip-audience');
            if (chipAud) chipAud.style.display = audOk ? 'none' : 'inline-flex';

            // 11. Open Days
            const daysCount = document.querySelectorAll('.day-checkbox:checked').length;
            const daysOk = daysCount > 0;
            if (daysOk) filled++;
            const chipDays = document.getElementById('chip-days');
            if (chipDays) chipDays.style.display = daysOk ? 'none' : 'inline-flex';

            // 12. Open Time
            const openTime = val('inputOpenTime');
            const openOk = openTime.length > 0;
            if (openOk) filled++;

            // 13. Close Time
            const closeTime = val('inputCloseTime');
            const closeOk = closeTime.length > 0;
            if (closeOk) filled++;
            const chipHours = document.getElementById('chip-hours');
            if (chipHours) chipHours.style.display = (openOk && closeOk) ? 'none' : 'inline-flex';

            // 14. About
            const about = val('inputAbout');
            const aboutOk = about.length >= 10;
            if (aboutOk) filled++;
            const chipAbout = document.getElementById('chip-about');
            if (chipAbout) chipAbout.style.display = aboutOk ? 'none' : 'inline-flex';

            // 15. How We Teach
            const howWeTeach = val('inputHowWeTeach');
            const teachOk = howWeTeach.length >= 10;
            if (teachOk) filled++;
            const chipTeach = document.getElementById('chip-teach');
            if (chipTeach) chipTeach.style.display = teachOk ? 'none' : 'inline-flex';

            // 16. What We Offer
            const offersCount = document.querySelectorAll('.offer-checkbox:checked').length;
            const offersOk = offersCount > 0;
            if (offersOk) filled++;
            const chipOffers = document.getElementById('chip-offers');
            if (chipOffers) chipOffers.style.display = offersOk ? 'none' : 'inline-flex';

            // Calculate exact integer percentage: (filled / 16) * 100
            const pct = Math.min(100, Math.round((filled / total) * 100));

            const pctText = document.getElementById('pctText');
            if (pctText) pctText.textContent = pct + '%';

            const barFill = document.getElementById('progressBarFill');
            if (barFill) barFill.style.width = pct + '%';
        }

        // -------------------------------------------------------------
        // Photo & Gallery Previews
        // -------------------------------------------------------------
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
                    if (clearBtn) clearBtn.style.display = 'inline-block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function clearSelectedPhoto() {
            const input = document.getElementById('profilePhotoInput');
            if (input) input.value = '';
            const img = document.getElementById('profilePhotoPreview');
            const fallback = document.getElementById('profilePhotoFallback');
            const clearBtn = document.getElementById('btnClearPhoto');
            if (img) {
                img.src = '';
                img.style.display = 'none';
            }
            if (fallback) fallback.style.display = 'flex';
            if (clearBtn) clearBtn.style.display = 'none';
        }

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

        // -------------------------------------------------------------
        // Bank Details Pre-parsing & Synchronization
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

        // -------------------------------------------------------------
        // Preview Modal Functions
        // -------------------------------------------------------------
        function openPreviewModal() {
            syncBankDetails();

            const name = val('inputName') || 'Centre Name';
            document.getElementById('modalName').textContent = name;
            
            const coach = val('inputContactPerson') || 'Owner / Coach';
            document.getElementById('modalCoach').textContent = coach;

            const desig = val('inputDesignation') || 'Head Coach';
            document.getElementById('modalDesignation').textContent = desig;

            const city = val('inputCity') || 'City';
            const state = val('stateSelect') || 'State';
            document.getElementById('modalLocation').innerHTML = '<i class="bi bi-geo-alt-fill text-danger me-1"></i> ' + city + ', ' + state;

            const cType = val('inputCentreType') || 'Academy';
            document.getElementById('modalCentreType').textContent = cType;

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

            const openTime = val('inputOpenTime') || '06:00';
            const closeTime = val('inputCloseTime') || '21:00';
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

            const womenOnly = document.getElementById('inputWomenOnly')?.checked;
            const femaleInst = document.getElementById('inputFemaleInstructor')?.checked;
            document.getElementById('modalWomenOnlyBadge').style.display = womenOnly ? 'inline-flex' : 'none';
            document.getElementById('modalFemaleInstBadge').style.display = femaleInst ? 'inline-flex' : 'none';

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

            const about = val('inputAbout') || 'Dedicated martial arts and personal defense academy.';
            document.getElementById('modalAboutText').textContent = about;

            const howWeTeach = val('inputHowWeTeach') || 'Structured belt grading syllabus, daily fitness warmups, technique drills, and practical self-defense application.';
            document.getElementById('modalHowWeTeachText').textContent = howWeTeach;

            const galleryStrip = document.getElementById('modalGalleryStrip');
            galleryStrip.innerHTML = '';
            <c:if test="${not empty center.galleryPhotos}">
                <c:forEach var="p" items="${center.galleryPhotos}">
                    galleryStrip.innerHTML += '<img src="${pageContext.request.contextPath}${p}" class="card-gallery-img" alt="Gallery Photo">';
                </c:forEach>
            </c:if>

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

            const bHolder = val('bankAccountHolder');
            const bName = val('bankName');
            const bAcc = val('bankAccountNumber');
            const bIfsc = val('bankIfsc');
            const upi = val('inputUpiId');

            if (bAcc || bHolder) {
                const masked = bAcc ? '•••• ' + bAcc.slice(-4) : 'Provided';
                document.getElementById('modalBankSummary').innerHTML = 
                    '<i class="bi bi-shield-lock-fill text-success me-1"></i> A/C: ' + masked + ' (' + (bName || 'Bank') + ') &bull; IFSC: ' + (bIfsc || 'N/A') + (upi ? ' &bull; UPI: ' + upi : '');
            } else {
                document.getElementById('modalBankSummary').textContent = 'Direct Bank details not provided yet';
            }

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

        // -------------------------------------------------------------
        // Validation & Submission
        // -------------------------------------------------------------
        function validateAllFields(strict) {
            let valid = true;
            let firstInvalid = null;

            function check(condition, id, msg) {
                if (!condition) {
                    setFieldStatus(id, true, msg);
                    valid = false;
                    if (!firstInvalid) firstInvalid = document.getElementById(id);
                } else {
                    setFieldStatus(id, false);
                }
            }

            const name = val('inputName');
            check(name.length >= 2, 'inputName', 'Centre name is required (minimum 2 characters).');

            const contact = val('inputContactPerson');
            check(contact.length >= 2, 'inputContactPerson', 'Owner or coach name is required (minimum 2 characters).');

            const phone = val('inputPhone');
            check(/^[6-9]\d{9}$/.test(phone), 'inputPhone', 'Enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.');

            const whatsapp = val('inputWhatsapp');
            if (whatsapp) {
                check(/^[6-9]\d{9}$/.test(whatsapp), 'inputWhatsapp', 'Enter a valid 10-digit WhatsApp number.');
            } else {
                setFieldStatus('inputWhatsapp', false);
            }

            const year = val('inputYearStarted');
            if (year) {
                const y = parseInt(year, 10);
                const curY = new Date().getFullYear();
                check(y >= 1950 && y <= curY, 'inputYearStarted', 'Enter a valid year between 1950 and ' + curY + '.');
            } else {
                setFieldStatus('inputYearStarted', false);
            }

            const loc = val('inputLocation');
            check(loc.length >= 3, 'inputLocation', 'Street address or hall name is required (at least 3 characters).');

            const state = val('stateSelect');
            check(state.length > 0, 'stateSelect', 'State is required.');

            const dist = val('districtSelect');
            const city = val('inputCity');
            check(city.length > 0, 'districtSelect', 'District or City is required.');

            const pin = val('inputPincode');
            check(/^\d{6}$/.test(pin), 'inputPincode', 'Enter a valid 6-digit pincode.');

            const mapLink = val('inputMapLink');
            if (mapLink) {
                check(/^https?:\/\/.+/i.test(mapLink), 'inputMapLink', 'Enter a valid URL starting with http:// or https://');
            } else {
                setFieldStatus('inputMapLink', false);
            }

            if (strict) {
                const styles = document.querySelectorAll('.style-checkbox:checked').length;
                check(styles > 0, 'stylesContainer', 'Select at least one martial arts style taught.');

                const audience = document.querySelectorAll('.aud-checkbox:checked').length;
                check(audience > 0, 'audienceContainer', 'Select at least one target audience category.');

                const days = document.querySelectorAll('.day-checkbox:checked').length;
                check(days > 0, 'daysContainer', 'Select at least one operating day.');

                const openT = val('inputOpenTime');
                check(openT.length > 0, 'inputOpenTime', 'Opening time is required.');

                const closeT = val('inputCloseTime');
                check(closeT.length > 0, 'inputCloseTime', 'Closing time is required.');

                const about = val('inputAbout');
                check(about.length >= 10, 'inputAbout', 'About section is required (minimum 10 characters).');

                const teach = val('inputHowWeTeach');
                check(teach.length >= 10, 'inputHowWeTeach', 'Teaching methodology is required (minimum 10 characters).');

                const offers = document.querySelectorAll('.offer-checkbox:checked').length;
                check(offers > 0, 'offersContainer', 'Select at least one training offer.');
            }

            const acc = val('bankAccountNumber');
            const confirmAcc = val('confirmAccountNumber');
            const ifsc = val('bankIfsc').toUpperCase();

            if (acc && confirmAcc && acc !== confirmAcc) {
                check(false, 'confirmAccountNumber', 'Bank account numbers do not match.');
            }

            if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                check(false, 'bankIfsc', 'Invalid IFSC format (e.g. SBIN0001234).');
            }

            if (!valid && firstInvalid) {
                if (firstInvalid.scrollIntoView) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                if (firstInvalid.focus) firstInvalid.focus();
            }

            return valid;
        }

        function saveProfileDirectly() {
            syncBankDetails();
            if (!validateAllFields(false)) return;
            document.getElementById('profileForm').submit();
        }

        function submitForVerification() {
            syncBankDetails();
            if (!validateAllFields(true)) {
                closePreviewModal();
                return;
            }

            const form = document.getElementById('profileForm');
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

        // -------------------------------------------------------------
        // On DOM Load
        // -------------------------------------------------------------
        document.addEventListener('DOMContentLoaded', function() {
            initLocationSelectors();
            parseExistingBankDetails();

            // Clamping on numeric fields
            const phoneInput = document.getElementById('inputPhone');
            if (phoneInput) {
                phoneInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                    setFieldStatus('inputPhone', false);
                    triggerRecalculateProgress();
                });
                phoneInput.addEventListener('blur', function() {
                    if (this.value && !/^[6-9]\d{9}$/.test(this.value)) {
                        setFieldStatus('inputPhone', true, 'Enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.');
                    }
                });
            }

            const whatsappInput = document.getElementById('inputWhatsapp');
            if (whatsappInput) {
                whatsappInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                    setFieldStatus('inputWhatsapp', false);
                });
            }

            const yearInput = document.getElementById('inputYearStarted');
            if (yearInput) {
                yearInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 4);
                    setFieldStatus('inputYearStarted', false);
                });
            }

            const pinInput = document.getElementById('inputPincode');
            if (pinInput) {
                pinInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 6);
                    setFieldStatus('inputPincode', false);
                    triggerRecalculateProgress();
                });
                pinInput.addEventListener('blur', function() {
                    if (this.value && !/^\d{6}$/.test(this.value)) {
                        setFieldStatus('inputPincode', true, 'Enter a valid 6-digit pincode.');
                    }
                });
            }

            const nameInput = document.getElementById('inputName');
            if (nameInput) {
                nameInput.addEventListener('input', function() {
                    this.value = this.value.replace(/[^a-zA-Z0-9\s.\-&',]/g, '').slice(0, 80);
                    if (this.value.trim().length >= 2) setFieldStatus('inputName', false);
                    triggerRecalculateProgress();
                });
                nameInput.addEventListener('blur', function() {
                    if (this.value.trim().length < 2) setFieldStatus('inputName', true, 'Centre name must be at least 2 characters.');
                });
            }

            const contactInput = document.getElementById('inputContactPerson');
            if (contactInput) {
                contactInput.addEventListener('input', function() {
                    this.value = this.value.replace(/[^a-zA-Z\s.]/g, '').slice(0, 60);
                    if (this.value.trim().length >= 2) setFieldStatus('inputContactPerson', false);
                    triggerRecalculateProgress();
                });
                contactInput.addEventListener('blur', function() {
                    if (this.value.trim().length < 2) setFieldStatus('inputContactPerson', true, 'Contact person name must be at least 2 characters.');
                });
            }

            const locInput = document.getElementById('inputLocation');
            if (locInput) {
                locInput.addEventListener('input', function() {
                    if (this.value.trim().length >= 3) setFieldStatus('inputLocation', false);
                    triggerRecalculateProgress();
                });
                locInput.addEventListener('blur', function() {
                    if (this.value.trim().length < 3) setFieldStatus('inputLocation', true, 'Street address must be at least 3 characters.');
                });
            }

            const aboutInput = document.getElementById('inputAbout');
            if (aboutInput) {
                aboutInput.addEventListener('input', function() {
                    if (this.value.trim().length >= 10) setFieldStatus('inputAbout', false);
                    triggerRecalculateProgress();
                });
                aboutInput.addEventListener('blur', function() {
                    if (this.value.trim().length < 10) setFieldStatus('inputAbout', true, 'About section must be at least 10 characters.');
                });
            }

            const teachInput = document.getElementById('inputHowWeTeach');
            if (teachInput) {
                teachInput.addEventListener('input', function() {
                    if (this.value.trim().length >= 10) setFieldStatus('inputHowWeTeach', false);
                    triggerRecalculateProgress();
                });
                teachInput.addEventListener('blur', function() {
                    if (this.value.trim().length < 10) setFieldStatus('inputHowWeTeach', true, 'Teaching methodology must be at least 10 characters.');
                });
            }

            // Bank details sync
            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', syncBankDetails);
                    el.addEventListener('blur', syncBankDetails);
                }
            });

            // Initial calculation
            triggerRecalculateProgress();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
