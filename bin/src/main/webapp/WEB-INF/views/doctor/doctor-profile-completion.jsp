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
    <title>Complete Doctor Profile — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Leaflet Map CSS for Map Picker (whitelisted by CSP) -->
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
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { overflow-x: hidden; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }
        .app-header {
            background: #fff;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
            gap: 12px;
            flex-wrap: wrap;
        }
        .header-brand {
            display: flex; align-items: center; gap: 10px;
            font-size: 1.1rem; font-weight: 800; color: var(--navy); text-decoration: none;
        }
        .header-brand img {
            height: 32px; width: 32px; border-radius: 8px; object-fit: cover;
        }
        .header-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .btn-skip, .btn-header-save, .btn-primary, .btn-ghost {
            border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            padding: 8px 16px; cursor: pointer; font-family: inherit; text-decoration: none;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
            transition: background 0.2s, opacity 0.2s;
        }
        .btn-skip {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-skip:hover { background: var(--bg-page); }
        .btn-header-save, .btn-primary {
            border: none; background: var(--primary); color: #fff;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }
        .btn-header-save:hover, .btn-primary:hover { background: var(--primary-hover); }
        .btn-header-save:disabled, .btn-primary:disabled, .btn-ghost:disabled {
            opacity: 0.65; cursor: not-allowed; box-shadow: none;
        }
        .btn-ghost {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-ghost:hover { background: var(--bg-page); }
        .main-container {
            flex: 1;
            width: 100%;
            max-width: 1380px;
            margin: 18px auto 48px;
            padding: 0 clamp(16px, 3vw, 40px);
            box-sizing: border-box;
        }
        .profile-layout-grid {
            display: block;
            width: 100%;
        }
        .form-column {
            width: 100%;
            max-width: 100%;
        }
        .profile-progress-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: var(--shadow-card);
        }
        .progress-header {
            display: flex; justify-content: space-between; align-items: center;
            gap: 12px; flex-wrap: wrap; margin-bottom: 10px;
        }
        .progress-title { font-size: 1rem; font-weight: 800; color: var(--navy); }
        .progress-pct {
            font-size: 0.85rem; font-weight: 800; color: var(--primary);
            background: var(--rose-soft); border: 1px solid var(--rose-border);
            padding: 4px 12px; border-radius: 999px;
        }
        .progress-bar-container {
            height: 8px; background: #E2E8F0; border-radius: 4px; overflow: hidden; margin-bottom: 12px;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 4px;
            width: ${profileCompletionPct}%;
            transition: width 0.3s ease;
        }
        .progress-guidance {
            font-size: 0.88rem; color: var(--text-gray); line-height: 1.45;
        }
        .progress-guidance strong { color: var(--navy); }
        .missing-list {
            margin-top: 10px; display: flex; flex-wrap: wrap; gap: 6px;
        }
        .missing-list span {
            display: inline-block; font-size: 0.75rem; font-weight: 600;
            background: #FFF7ED; color: #C2410C; border: 1px solid #FED7AA;
            border-radius: 6px; padding: 4px 8px;
        }
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
            width: 100%;
            box-sizing: border-box;
        }
        .section-title {
            font-size: 1.1rem; font-weight: 800; color: var(--navy);
            margin-bottom: 18px; display: flex; align-items: center; gap: 10px;
        }
        .section-title .num {
            display: inline-flex; align-items: center; justify-content: center;
            width: 28px; height: 28px; border-radius: 8px;
            background: var(--rose-light); color: var(--primary);
            font-size: 0.8rem; font-weight: 800; flex-shrink: 0;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 24px;
            margin-bottom: 8px;
            width: 100%;
            box-sizing: border-box;
        }
        .field {
            min-width: 0;
            max-width: 100%;
            box-sizing: border-box;
        }
        .field.full { grid-column: 1 / -1; }
        .field label {
            display: block; font-size: 0.84rem; font-weight: 700; margin-bottom: 6px; color: var(--navy);
        }
        .field label .req { color: var(--primary); }
        .field input, .field select, .field textarea {
            width: 100%; padding: 11px 13px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.92rem; font-family: inherit; background: #fff; color: var(--navy);
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .field input.is-invalid,
        .field select.is-invalid,
        .field textarea.is-invalid {
            border-color: var(--error) !important;
            background: var(--error-bg) !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }
        .field input.is-valid,
        .field select.is-valid,
        .field textarea.is-valid {
            border-color: var(--success);
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.08);
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
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 4px; }
        .day-toggles, .mode-toggles {
            display: flex; flex-wrap: wrap; gap: 8px;
        }
        .chip {
            display: inline-flex; align-items: center; gap: 6px;
            border: 1px solid var(--border-color); border-radius: 8px;
            padding: 7px 12px; font-size: 0.82rem; font-weight: 600; cursor: pointer;
            background: #F1F5F9; color: #475569; user-select: none;
            transition: all 0.2s;
        }
        .chip input { accent-color: var(--primary); }
        .chip:has(input:checked) {
            background: var(--rose-light); border-color: var(--primary); color: var(--primary);
        }
        .mode-toggles.is-invalid,
        .day-toggles.is-invalid {
            outline: 2px solid rgba(220, 38, 38, 0.35);
            outline-offset: 4px;
            border-radius: 10px;
        }
        .switch-row {
            display: flex; align-items: center; gap: 10px; font-size: 0.9rem; font-weight: 600;
        }
        .alert {
            padding: 12px 14px; border-radius: 12px; font-size: 0.88rem; font-weight: 600; margin-bottom: 16px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #fecaca; }
        .alert-ok { background: var(--success-bg); color: var(--success); border: 1px solid #bbf7d0; }
        .actions {
            display: flex; gap: 12px; flex-wrap: wrap; margin-top: 20px;
            border-top: 1px solid var(--border-color); padding-top: 18px;
        }
        .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip {
            flex: 1; min-width: 140px; padding: 12px 18px; font-size: 0.95rem;
        }
        .preview-sticky-wrap {
            position: sticky; top: 80px; z-index: 20;
        }
        .live-preview-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--rose-border);
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            overflow: hidden;
        }
        .preview-banner-header {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            color: #fff; padding: 16px 20px;
            display: flex; justify-content: space-between; align-items: center; gap: 10px;
        }
        .preview-banner-header h3 { font-size: 0.95rem; font-weight: 800; }
        .preview-badge-live {
            background: var(--primary); color: #fff;
            font-size: 0.68rem; font-weight: 800; text-transform: uppercase;
            letter-spacing: 0.8px; padding: 4px 10px; border-radius: 20px;
        }
        .preview-body { padding: 20px; }
        .preview-row {
            display: flex; justify-content: space-between; gap: 12px;
            padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 0.88rem;
        }
        .preview-row:last-child { border-bottom: none; }
        .preview-row .k { color: var(--text-gray); flex-shrink: 0; }
        .preview-row .v { font-weight: 700; text-align: right; word-break: break-word; }
        .preview-meta-row {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 12px; background: var(--bg-page);
            border-radius: 10px; border: 1px solid var(--border-color);
            margin-bottom: 8px; font-size: 0.82rem;
        }
        .preview-meta-row i { color: var(--primary); }
        .form-card, .preview-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }
        @media (max-width: 991px) {
            .submitted-details-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; gap: 14px; }
            .main-container { padding: 0 14px; margin: 14px auto 36px; }
            .section-card { padding: 18px 16px; }
            .submitted-details-grid { grid-template-columns: 1fr; padding: 16px; }
            .submitted-card-header { padding: 16px; }
        }
        @media (max-width: 600px) {
            .app-header { padding: 12px 14px; }
            .section-card, .form-card, .preview-card { padding: 16px 14px; }
            .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip { min-width: 100%; flex: 1 1 100%; }
            .profile-photo-card { flex-direction: column; align-items: center; text-align: center; }
            .photo-btn-row { justify-content: center; }
            .day-toggles, .mode-toggles { gap: 6px; }
            .chip { font-size: 0.78rem; padding: 6px 10px; }
        }

        /* Profile Photo section styling */
        .profile-photo-card {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            border-radius: 14px;
            padding: 18px 20px;
            margin-bottom: 16px;
        }
        .photo-preview-circle {
            width: 86px;
            height: 86px;
            border-radius: 50%;
            overflow: hidden;
            background: var(--rose-light);
            border: 3px solid #fff;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.15);
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
        .photo-fallback {
            font-size: 34px;
            color: var(--primary);
        }
        .photo-upload-meta {
            flex: 1;
            min-width: 0;
        }
        .photo-btn-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 6px;
        }
        .btn-choose-photo {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: var(--primary);
            color: #fff;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-choose-photo:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }
        .photo-file-name {
            font-size: 0.82rem;
            color: var(--navy);
            font-weight: 600;
        }

        /* Structured Bank Subfields */
        .bank-subfields-card {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 16px 18px;
            margin-top: 6px;
        }
        .bank-subfields-card .grid {
            margin-bottom: 0;
        }

        /* Document upload status & preview styling (Clamped inside box, zero overflow) */
        .doc-file-input {
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
            font-size: 0.85rem;
            cursor: pointer;
        }
        .doc-status-wrap {
            margin-top: 10px;
            padding: 12px 14px;
            border-radius: 12px;
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
            box-sizing: border-box;
        }
        .doc-badge {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 7px 12px;
            border-radius: 8px;
            margin-bottom: 8px;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
            word-break: break-word;
            overflow-wrap: anywhere;
            line-height: 1.45;
        }
        .doc-badge i {
            flex-shrink: 0;
            margin-top: 2px;
            font-size: 1rem;
        }
        .doc-badge strong {
            font-weight: 700;
            word-break: break-all;
            overflow-wrap: anywhere;
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
        .doc-preview-box {
            margin-top: 6px;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
        }
        .doc-thumb-row {
            display: flex;
            align-items: center;
            gap: 12px;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
        }
        .doc-thumb-img {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            flex-shrink: 0;
        }
        .doc-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }
        .doc-link:hover { text-decoration: underline; color: var(--navy); }
        .doc-pdf-row, .doc-generic-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            color: #334155;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
        }
        .doc-file-info {
            font-size: 0.82rem;
            color: #0F172A;
            font-weight: 600;
            word-break: break-all;
            overflow-wrap: anywhere;
            min-width: 0;
            max-width: 100%;
        }

        /* Submitted Profile Snapshot Card (Kept after submitting) */
        .submitted-profile-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--rose-border);
            box-shadow: 0 4px 20px rgba(244, 63, 94, 0.08);
            margin-bottom: 22px;
            overflow: hidden;
            width: 100%;
            box-sizing: border-box;
        }
        .submitted-card-header {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            color: #fff;
            padding: 18px 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: space-between;
        }
        .submitted-avatar-wrap {
            width: 54px;
            height: 54px;
            border-radius: 50%;
            overflow: hidden;
            background: var(--rose-light);
            border: 2px solid var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .submitted-avatar-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .submitted-avatar-wrap .avatar-letter {
            font-size: 22px;
            font-weight: 800;
            color: var(--primary);
        }
        .submitted-doctor-meta {
            flex: 1;
            min-width: 200px;
        }
        .submitted-name {
            font-size: 1.15rem;
            font-weight: 800;
            color: #fff;
        }
        .submitted-spec {
            font-size: 0.85rem;
            color: #94A3B8;
            margin-top: 3px;
        }
        .submitted-status-badge {
            background: rgba(244, 63, 94, 0.2);
            color: #FDA4AF;
            border: 1px solid rgba(244, 63, 94, 0.4);
            font-size: 0.8rem;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .submitted-details-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 24px;
            padding: 18px 24px;
            background: #fff;
        }
        .summary-cell {
            display: flex;
            flex-direction: column;
            gap: 4px;
            font-size: 0.88rem;
            min-width: 0;
        }
        .summary-cell .k {
            font-size: 0.74rem;
            color: var(--text-gray);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .summary-cell .v {
            font-weight: 700;
            color: var(--navy);
            word-break: break-word;
        }

        /* Cascading Helper Info & Spinners */
        .cascade-info {
            font-size: 0.74rem; color: var(--text-gray); margin-top: 4px;
            display: flex; align-items: center; gap: 4px;
        }
        @keyframes spin { 100% { transform: rotate(360deg); } }
        .spin { display: inline-block; animation: spin 1s linear infinite; }

        /* Map Picker Button */
        .btn-map-picker {
            background: #FFE4E6; border: 1.5px solid #FECDD3; color: var(--primary);
            padding: 5px 12px; border-radius: 8px; font-size: 0.8rem; font-weight: 700;
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
            transition: all 0.2s; font-family: inherit;
        }
        .btn-map-picker:hover {
            background: var(--primary); color: #fff; border-color: var(--primary);
            box-shadow: 0 3px 8px rgba(244, 63, 94, 0.25);
        }

        
        /* Map Picker Styles (Aligned with /users/register) */
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center;
            z-index: 9999; padding: 16px;
        }
        .map-modal-card {
            background: #FFFFFF; border-radius: 20px; max-width: 680px; width: 100%;
            max-height: 94vh; display: flex; flex-direction: column; padding: 22px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        .modal-header {
            display: flex; align-items: center; gap: 12px; margin-bottom: 16px;
        }
        .modal-header .icon-wrap {
            width: 40px; height: 40px; border-radius: 10px;
            background: var(--rose-light); color: var(--primary);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; flex-shrink: 0;
        }
        .modal-header h3 {
            font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0 0 2px 0;
        }
        .btn-close-modal {
            background: transparent; border: none; font-size: 1.5rem; line-height: 1;
            color: var(--text-gray); cursor: pointer; padding: 4px; border-radius: 8px;
            transition: color 0.15s, background 0.15s; margin-left: auto;
        }
        .btn-close-modal:hover { color: var(--navy); background: #F1F5F9; }
        .map-search-row {
            display: flex; gap: 8px; margin-bottom: 12px; position: relative;
        }
        .map-canvas-wrap {
            position: relative; width: 100%; height: 320px; border-radius: 12px;
            overflow: hidden; border: 1.5px solid var(--border-color); background: #E2E8F0;
        }
        .map-suggestions {
            position: absolute; top: 100%; left: 0; right: 0; background: #FFFFFF;
            border: 1px solid var(--border-color); border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12); max-height: 180px;
            overflow-y: auto; z-index: 1050; display: none; margin-top: 4px;
        }
        .map-suggestion-item {
            padding: 9px 12px; cursor: pointer; font-size: 0.85rem;
            border-bottom: 1px solid #F1F5F9; color: var(--navy); transition: background 0.15s;
        }
        .map-suggestion-item:last-child { border-bottom: none; }
        .map-suggestion-item:hover { background: var(--rose-soft); color: var(--primary); }
        .map-selected-bar {
            background: #F8FAFC; border: 1px solid var(--border-color); border-radius: 10px;
            padding: 10px 14px; margin-top: 12px; font-size: 0.86rem; line-height: 1.4;
        }
        .map-selected-label {
            font-weight: 700; color: var(--navy); display: block; margin-bottom: 2px;
            font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .map-selected-value { color: #334155; font-weight: 600; word-break: break-word; }
        .map-provider-tag {
            font-size: 0.72rem; padding: 2px 7px; border-radius: 6px;
            background: #E2E8F0; color: #475569; font-weight: 600;
        }
        .btn-modal-cancel {
            padding: 10px 18px; border-radius: 10px; border: 1px solid var(--border-color);
            background: #F1F5F9; color: var(--navy); font-weight: 700; font-size: 0.88rem; cursor: pointer;
        }
        .btn-modal-confirm {
            padding: 10px 20px; border-radius: 10px; border: none;
            background: var(--primary); color: #FFFFFF; font-weight: 700; font-size: 0.88rem;
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-modal-confirm:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn-secondary {
            padding: 9px 14px; border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            border: 1px solid var(--border-color); background: #F1F5F9; color: var(--navy);
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-secondary:hover { background: #E2E8F0; }

    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/doctors/dashboard">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            Fight D Fear
        </a>
        <div class="header-actions">
            <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
            <button type="button" class="btn-header-save" id="headerReviewBtn">Review profile</button>
        </div>
    </header>

    <main class="main-container">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-ok"><i class="bi bi-check-circle-fill"></i> ${message}</div>

            <!-- Saved Profile Snapshot (Shown after submitting) -->
            <div class="submitted-profile-card">
                <div class="submitted-card-header">
                    <div style="display:flex;align-items:center;gap:14px;flex-wrap:wrap;">
                        <div class="submitted-avatar-wrap">
                            <c:set var="docPhotoPreview" value="${not empty doctor.profilePhotoPath ? doctor.profilePhotoPath : profile.profilePhotoPath}" />
                            <c:choose>
                                <c:when test="${not empty docPhotoPreview}">
                                    <img src="${pageContext.request.contextPath}${docPhotoPreview}" alt="Doctor Photo">
                                </c:when>
                                <c:otherwise>
                                    <span class="avatar-letter">${not empty doctor.fullName ? doctor.fullName.substring(0, 1) : 'D'}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="submitted-doctor-meta">
                            <div class="submitted-name">${not empty doctor.fullName ? doctor.fullName : 'Doctor'}</div>
                            <div class="submitted-spec">
                                <i class="bi bi-stethoscope"></i> ${not empty doctor.specialization ? doctor.specialization : 'Specialist'}
                                <c:if test="${not empty doctor.qualification}"> &bull; ${doctor.qualification}</c:if>
                            </div>
                        </div>
                    </div>
                    <div class="submitted-status-badge">
                        <i class="bi bi-shield-check"></i> ${statusLabel} (${profileCompletionPct}%)
                    </div>
                </div>
                <div class="submitted-details-grid">
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-geo-alt"></i> Location</span>
                        <span class="v">${not empty doctor.city ? doctor.city : '—'}, ${not empty doctor.state ? doctor.state : ''}</span>
                    </div>
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-briefcase"></i> Experience</span>
                        <span class="v">${doctor.experienceYears != null ? doctor.experienceYears : 0} Years</span>
                    </div>
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-cash-stack"></i> Fee</span>
                        <span class="v">${doctor.consultationFee != null ? '₹'.concat(doctor.consultationFee.toString()) : '—'}</span>
                    </div>
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-award"></i> Medical Reg</span>
                        <span class="v">${not empty doctor.medicalRegNumber ? doctor.medicalRegNumber : '—'}</span>
                    </div>
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-hospital"></i> Hospital / Clinic</span>
                        <span class="v">${not empty doctor.hospitalName ? doctor.hospitalName : '—'}</span>
                    </div>
                    <div class="summary-cell">
                        <span class="k"><i class="bi bi-telephone"></i> Phone</span>
                        <span class="v">${not empty doctor.phone ? doctor.phone : '—'}</span>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="profile-layout-grid">
            <div class="form-column">
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <span class="progress-title">Profile Completion</span>
                        <span class="progress-pct">${profileCompletionPct}%</span>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill"></div>
                    </div>
                    <p class="progress-guidance"><strong>${statusLabel}</strong> — ${nextStepGuidance}</p>
                    <c:if test="${not empty missingItems}">
                        <div class="missing-list">
                            <c:forEach var="m" items="${missingItems}">
                                <span><i class="bi bi-exclamation-circle"></i> ${m}</span>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- EDIT -->
                <div id="editPanel">
                    <form id="profileForm" action="${pageContext.request.contextPath}/doctors/profile-completion${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" novalidate>
                        <c:if test="${not empty _csrf}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </c:if>
                        <!-- 1. Professional Information -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">1</span> Professional Information &amp; Photo</div>
                            
                            <!-- Profile Photo Card -->
                            <div class="profile-photo-card">
                                <div class="photo-preview-circle">
                                    <c:set var="docPhoto" value="${not empty doctor.profilePhotoPath ? doctor.profilePhotoPath : profile.profilePhotoPath}" />
                                    <c:choose>
                                        <c:when test="${not empty docPhoto}">
                                            <img id="mainPhotoPreview" src="${pageContext.request.contextPath}${docPhoto}" alt="Profile Photo">
                                            <div id="mainPhotoFallback" class="photo-fallback" style="display:none;"><i class="bi bi-person-fill"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="mainPhotoFallback" class="photo-fallback"><i class="bi bi-person-bounding-box"></i></div>
                                            <img id="mainPhotoPreview" src="" alt="Profile Photo" style="display:none;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="photo-upload-meta">
                                    <div class="photo-btn-row">
                                        <label for="profilePhoto" class="btn-choose-photo">
                                            <i class="bi bi-camera-fill"></i> Upload Profile Photo
                                        </label>
                                        <input type="file" name="profilePhoto" id="profilePhoto" accept="image/jpeg,image/png,application/pdf" class="doc-file-input" data-doc-id="profilePhoto" style="display:none;">
                                        <span id="photoFileName" class="photo-file-name">
                                            ${not empty docPhoto ? 'Photo currently on file' : 'No photo uploaded yet'}
                                        </span>
                                    </div>
                                    <p class="hint">Upload a professional photo (JPG or PNG up to 5 MB). This photo appears on your doctor card and patient appointment booking.</p>
                                    <div class="error-msg" id="err-profilePhoto">Use JPG, PNG or PDF up to 5 MB.</div>
                                </div>
                            </div>

                            <div class="grid">
                                <div class="field">
                                    <label>Doctor name <span class="req">*</span></label>
                                    <input type="text" name="fullName" id="fullName" value="${doctor.fullName}" required>
                                    <div class="error-msg" id="err-fullName">Doctor name is required.</div>
                                </div>
                                <div class="field">
                                    <label>Email (read-only)</label>
                                    <input type="email" value="${doctor.email}" disabled>
                                </div>
                                <div class="field">
                                    <label>Phone</label>
                                    <input type="tel" name="phone" id="phone" value="${doctor.phone}" pattern="[0-9]{10}" maxlength="10">
                                    <div class="error-msg" id="err-phone">Phone must be exactly 10 digits.</div>
                                </div>
                                <div class="field">
                                    <label>Gender</label>
                                    <select name="gender" id="gender">
                                        <option value="FEMALE" selected>Female</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Specialization <span class="req">*</span></label>
                                    <input type="text" name="specialization" id="specialization" value="${doctor.specialization != null ? doctor.specialization : ''}" placeholder="e.g. Gynecologist" maxlength="80">
                                    <div class="error-msg" id="err-specialization">Specialization is required.</div>
                                </div>
                                <div class="field">
                                    <label>Qualification <span class="req">*</span></label>
                                    <input type="text" name="qualification" id="qualification" value="${doctor.qualification != null ? doctor.qualification : ''}" placeholder="e.g. MBBS, MD" maxlength="120">
                                    <div class="error-msg" id="err-qualification">Qualification is required.</div>
                                </div>
                                <div class="field">
                                    <label>Medical registration number <span class="req">*</span></label>
                                    <input type="text" name="medicalRegNumber" id="medicalRegNumber" value="${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : ''}" maxlength="60" placeholder="e.g. MCI-12345 or DMC/R/1234">
                                    <div class="hint">Official Medical Council registration (3 to 60 characters, e.g. MCI-12345/2018).</div>
                                    <div class="error-msg" id="err-medicalRegNumber">Enter a valid medical registration number (3-60 alphanumeric characters).</div>
                                </div>
                                <div class="field">
                                    <label>Years of experience <span class="req">*</span></label>
                                    <input type="text" name="experienceYears" id="experienceYears" inputmode="numeric" maxlength="2" value="${doctor.experienceYears != null ? doctor.experienceYears : ''}" placeholder="0 - 50">
                                    <div class="hint">Whole number between 0 and 50 years of clinical practice.</div>
                                    <div class="error-msg" id="err-experienceYears">Enter experience between 0 and 50 years.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 2. Clinic / Hospital -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">2</span> Clinic / Hospital</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Hospital / clinic name <span class="req">*</span></label>
                                    <input type="text" name="hospitalName" id="hospitalName" value="${doctor.hospitalName != null ? doctor.hospitalName : ''}" maxlength="120" placeholder="e.g. Apollo Hospital / City Health Clinic">
                                    <div class="error-msg" id="err-hospitalName">Hospital / clinic name is required.</div>
                                </div>
                                <div class="field full">
                                    <label>Clinic address <span class="req">*</span></label>
                                    <textarea name="clinicAddress" id="clinicAddress" rows="2" maxlength="300" placeholder="Building name, street, chamber number, or landmark...">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea>
                                    <div class="error-msg" id="err-clinicAddress">Clinic address is required (at least 5 characters).</div>
                                </div>
                                <div class="field">
                                    <label>
                                        Country <span class="req">*</span>
                                        <span id="countrySpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading countries...</span>
                                    </label>
                                    <select name="country" id="countrySelect">
                                        <option value="India">India</option>
                                        <option value="United States">United States</option>
                                        <option value="United Kingdom">United Kingdom</option>
                                        <option value="Canada">Canada</option>
                                        <option value="Australia">Australia</option>
                                        <option value="United Arab Emirates">United Arab Emirates</option>
                                        <option value="Singapore">Singapore</option>
                                        <option value="Other">Other</option>
                                    </select>
                                    <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting country updates state list from API</div>
                                    <div class="error-msg" id="err-country">Country is required.</div>
                                </div>
                                <div class="field">
                                    <label>
                                        State / UT <span class="req">*</span>
                                        <span id="stateSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading states...</span>
                                    </label>
                                    <select name="state" id="stateSelect">
                                        <option value="">-- Select State / UT --</option>
                                    </select>
                                    <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting state updates district list from API</div>
                                    <div class="error-msg" id="err-state">State is required.</div>
                                </div>
                                <div class="field">
                                    <label>
                                        District / City <span class="req">*</span>
                                        <span id="districtSpinner" style="display:none;font-size:0.75rem;color:var(--primary);font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading districts...</span>
                                    </label>
                                    <select id="districtSelect">
                                        <option value="">-- Select State First --</option>
                                    </select>
                                    <div class="cascade-info"><i class="bi bi-check-circle"></i> Filters to chosen state's districts / cities</div>
                                    <div class="error-msg" id="err-city">District / City is required.</div>
                                </div>
                                <div class="field" id="customCityGroup" style="display:none;">
                                    <label>Custom City / Town Name <span class="req">*</span></label>
                                    <input type="text" id="customCityInput" placeholder="Type your city or town name" maxlength="60">
                                    <div class="error-msg" id="err-customCity">Please enter your city or town name.</div>
                                </div>
                                <input type="hidden" name="city" id="city" value="${doctor.city != null ? doctor.city : ''}">
                                <div class="field">
                                    <label>Pincode <span class="req">*</span></label>
                                    <input type="text" name="pincode" id="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6" pattern="\d{6}" inputmode="numeric" placeholder="6-digit pincode">
                                    <div class="error-msg" id="err-pincode">Enter a valid 6-digit pincode.</div>
                                </div>
                                <div class="field full">
                                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;flex-wrap:wrap;gap:8px;">
                                        <label style="margin-bottom:0;font-weight:700;">Google Maps Clinic Location</label>
                                        <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                                            <i class="bi bi-geo-alt-fill"></i> Select from Map
                                        </button>
                                    </div>
                                    <input type="url" name="googleMapLocation" id="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}" placeholder="https://maps.google.com/?q=... or click Select from Map">
                                    <div class="error-msg" id="err-googleMapLocation">Enter a valid URL starting with http:// or https://.</div>
                                    <div class="hint">Click <strong>Select from Map</strong> to search or drop a pin on your clinic, or paste your Google Maps link.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 3. Consultation Modes -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">3</span> Consultation Modes</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Select the ways patients can consult you <span class="req">*</span></label>
                                    <div class="mode-toggles" id="modeToggles">
                                        <c:set var="modes" value="${doctor.consultationModes != null ? doctor.consultationModes : (doctor.consultationType != null ? doctor.consultationType.name() : '')}" />
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="CLINIC" ${fn:contains(modes, 'CLINIC') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Clinic</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="VIDEO" ${fn:contains(modes, 'VIDEO') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Video</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="ONLINE" ${fn:contains(modes, 'ONLINE') ? 'checked' : ''}> Online / Chat</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="OFFLINE" ${fn:contains(modes, 'OFFLINE') ? 'checked' : ''}> Offline</label>
                                    </div>
                                    <div class="error-msg" id="err-consultationModes">Select at least one consultation mode to submit for verification.</div>
                                    <div class="hint">Optional when saving a draft; required when submitting for verification.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 4. Availability -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">4</span> Availability</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Available days <span class="req">*</span></label>
                                    <div class="day-toggles" id="dayToggles">
                                        <c:set var="days" value="${doctor.availableDays != null ? doctor.availableDays : ''}" />
                                        <label class="chip"><input type="checkbox" name="availableDays" value="MONDAY" ${fn:contains(days, 'MONDAY') ? 'checked' : ''}> Mon</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="TUESDAY" ${fn:contains(days, 'TUESDAY') ? 'checked' : ''}> Tue</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="WEDNESDAY" ${fn:contains(days, 'WEDNESDAY') ? 'checked' : ''}> Wed</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="THURSDAY" ${fn:contains(days, 'THURSDAY') ? 'checked' : ''}> Thu</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="FRIDAY" ${fn:contains(days, 'FRIDAY') ? 'checked' : ''}> Fri</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="SATURDAY" ${fn:contains(days, 'SATURDAY') ? 'checked' : ''}> Sat</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="SUNDAY" ${fn:contains(days, 'SUNDAY') ? 'checked' : ''}> Sun</label>
                                    </div>
                                    <div class="error-msg" id="err-availableDays">Select at least one available day to submit for verification.</div>
                                    <div class="hint">Optional when saving a draft; required when submitting for verification.</div>
                                </div>
                                <div class="field">
                                    <label>Start time <span class="req">*</span></label>
                                    <input type="time" name="startTime" id="startTime" value="${doctor.startTime != null ? doctor.startTime : '09:00'}">
                                    <div class="error-msg" id="err-startTime">Start time is required.</div>
                                </div>
                                <div class="field">
                                    <label>End time <span class="req">*</span></label>
                                    <input type="time" name="endTime" id="endTime" value="${doctor.endTime != null ? doctor.endTime : '18:00'}">
                                    <div class="error-msg" id="err-endTime">End time must be after start time.</div>
                                </div>
                                <div class="field">
                                    <label>Slot duration (minutes)</label>
                                    <select name="slotDurationMinutes" id="slotDurationMinutes">
                                        <c:set var="slotDur" value="${doctor.slotDurationMinutes != null ? doctor.slotDurationMinutes : 30}" />
                                        <option value="15" ${slotDur == 15 ? 'selected' : ''}>15</option>
                                        <option value="20" ${slotDur == 20 ? 'selected' : ''}>20</option>
                                        <option value="30" ${slotDur == 30 ? 'selected' : ''}>30</option>
                                        <option value="45" ${slotDur == 45 ? 'selected' : ''}>45</option>
                                        <option value="60" ${slotDur == 60 ? 'selected' : ''}>60</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Buffer between patients (minutes)</label>
                                    <select name="bufferMinutes" id="bufferMinutes">
                                        <c:set var="bufMin" value="${doctor.bufferMinutes != null ? doctor.bufferMinutes : 0}" />
                                        <option value="0" ${bufMin == 0 ? 'selected' : ''}>0</option>
                                        <option value="5" ${bufMin == 5 ? 'selected' : ''}>5</option>
                                        <option value="10" ${bufMin == 10 ? 'selected' : ''}>10</option>
                                        <option value="15" ${bufMin == 15 ? 'selected' : ''}>15</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Break start</label>
                                    <input type="time" name="breakStart" id="breakStart" value="${doctor.breakStart != null ? doctor.breakStart : ''}">
                                </div>
                                <div class="field">
                                    <label>Break end</label>
                                    <input type="time" name="breakEnd" id="breakEnd" value="${doctor.breakEnd != null ? doctor.breakEnd : ''}">
                                    <div class="error-msg" id="err-breakEnd">Provide a valid break window.</div>
                                </div>
                                <div class="field full">
                                    <label>Blocked dates</label>
                                    <input type="text" name="blockedDates" id="blockedDates" value="${doctor.blockedDates != null ? doctor.blockedDates : ''}" placeholder="e.g. 2026-09-01, 2026-09-15">
                                    <div class="hint">Comma-separated YYYY-MM-DD dates you are unavailable.</div>
                                </div>
                                <div class="field full">
                                    <label class="switch-row">
                                        <input type="checkbox" name="autoConfirm" value="yes" ${doctor.autoConfirm != null && doctor.autoConfirm ? 'checked' : ''}>
                                        Auto-confirm bookings (off = you accept each request)
                                    </label>
                                </div>
                                <div class="field full">
                                    <label class="switch-row">
                                        <input type="checkbox" name="emergencyAvailable" value="yes" ${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'checked' : ''}>
                                        Emergency / instant consult available
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- 5. Languages -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">5</span> Languages</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Languages you consult in <span class="req">*</span></label>
                                    <input type="text" name="languages" id="languages" value="${doctor.languages != null ? doctor.languages : ''}" placeholder="e.g. English, Hindi" maxlength="120">
                                    <div class="error-msg" id="err-languages">Enter at least one language.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 6. Services offered -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">6</span> Services offered</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Services patients can book</label>
                                    <input type="text" name="services" id="services" value="${doctor.services != null ? doctor.services : ''}" placeholder="Optional, comma-separated">
                                </div>
                            </div>
                        </div>

                        <!-- 7. Fees -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">7</span> Fees</div>
                            <div class="grid">
                                <div class="field">
                                    <label>Consultation fee (₹) <span class="req">*</span></label>
                                    <input type="text" name="consultationFee" id="consultationFee" inputmode="numeric" maxlength="6" value="${doctor.consultationFee != null ? doctor.consultationFee : ''}" placeholder="Enter consultation fee">
                                    <div class="error-msg" id="err-consultationFee">Enter a consultation fee of 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Chat fee (₹)</label>
                                    <input type="text" name="chatFee" id="chatFee" inputmode="numeric" maxlength="6" value="${doctor.chatFee != null ? doctor.chatFee : ''}" placeholder="0">
                                    <div class="error-msg" id="err-chatFee">Chat fee must be 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Call fee (₹)</label>
                                    <input type="text" name="callFee" id="callFee" inputmode="numeric" maxlength="6" value="${doctor.callFee != null ? doctor.callFee : ''}" placeholder="0">
                                    <div class="error-msg" id="err-callFee">Call fee must be 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Video fee (₹)</label>
                                    <input type="text" name="videoFee" id="videoFee" inputmode="numeric" maxlength="6" value="${doctor.videoFee != null ? doctor.videoFee : ''}" placeholder="0">
                                    <div class="error-msg" id="err-videoFee">Video fee must be 0 or greater.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 8. About you / Bio -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">8</span> About you / Bio</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Bio</label>
                                    <textarea name="bio" id="bio" rows="4" maxlength="2000" placeholder="Short professional bio for patients">${doctor.bio != null ? doctor.bio : ''}</textarea>
                                    <div class="error-msg" id="err-bio">Bio must be 2000 characters or fewer.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 9. Payout & Bank Details -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">9</span> Payout &amp; Bank Details</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>UPI ID</label>
                                    <input type="text" name="upiId" id="upiId" value="${doctor.upiId != null ? doctor.upiId : ''}" placeholder="name@upi" maxlength="80">
                                    <div class="error-msg" id="err-upiId">Enter a valid UPI ID (e.g. name@upi).</div>
                                    <div class="hint">Instant UPI handle for fast consultation payouts.</div>
                                </div>
                                <div class="field full">
                                    <label style="font-weight:700;margin-bottom:8px;display:flex;align-items:center;gap:6px;">
                                        <i class="bi bi-bank" style="color:var(--primary);"></i> Bank Account Details
                                    </label>
                                    <div class="bank-subfields-card">
                                        <div class="grid">
                                            <div class="field">
                                                <label>Account Holder Name</label>
                                                <input type="text" name="bankAccountHolder" id="bankAccountHolder" placeholder="e.g. Dr. Jane Doe" maxlength="100">
                                            </div>
                                            <div class="field">
                                                <label>Bank Name</label>
                                                <input type="text" name="bankName" id="bankName" placeholder="e.g. State Bank of India, HDFC Bank" maxlength="100">
                                            </div>
                                            <div class="field">
                                                <label>Account Number</label>
                                                <input type="password" name="bankAccountNumber" id="bankAccountNumber" placeholder="Enter bank account number" maxlength="30" autocomplete="new-password">
                                                <div class="error-msg" id="err-bankAccountNumber">Account number is required if bank details are provided.</div>
                                            </div>
                                            <div class="field">
                                                <label>Confirm Account Number</label>
                                                <input type="text" id="bankConfirmAccountNumber" placeholder="Re-enter bank account number" maxlength="30">
                                                <div class="error-msg" id="err-bankConfirmAccountNumber">Account numbers do not match.</div>
                                            </div>
                                            <div class="field">
                                                <label>IFSC Code</label>
                                                <input type="text" name="bankIfsc" id="bankIfsc" placeholder="e.g. SBIN0001234" maxlength="20" style="text-transform:uppercase;">
                                                <div class="error-msg" id="err-bankIfsc">Enter a valid 11-character IFSC code.</div>
                                            </div>
                                            <div class="field">
                                                <label>Branch Name</label>
                                                <input type="text" name="bankBranch" id="bankBranch" placeholder="e.g. Indiranagar, Bengaluru" maxlength="100">
                                            </div>
                                        </div>
                                        <!-- Synchronized hidden bank details field -->
                                        <input type="hidden" name="bankDetails" id="bankDetails" value="${doctor.bankDetails != null ? doctor.bankDetails : ''}">
                                    </div>
                                    <div class="hint" style="margin-top:8px;">Earnings stay securely in your wallet until you request a payout from the dashboard.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 10. Documents -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">10</span> Verification Documents (optional)</div>
                            <p class="hint" style="margin-bottom:14px;">JPG, PNG or PDF up to 5 MB. Existing uploads are kept if you do not replace them.</p>
                            <div class="grid">

                                <!-- Government ID -->
                                <div class="field">
                                    <label>Government ID</label>
                                    <input type="file" name="idProof" id="idProof" accept="image/jpeg,image/png,application/pdf" class="doc-file-input" data-doc-id="idProof">
                                    <div class="error-msg" id="err-idProof">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <c:set var="docId" value="${not empty doctor.idProofPath ? doctor.idProofPath : (not empty doctor.identityDocumentPath ? doctor.identityDocumentPath : profile.idProofPath)}" />
                                    <div class="doc-status-wrap" id="docWrap-idProof">
                                        <c:choose>
                                            <c:when test="${not empty docId}">
                                                <div class="doc-badge uploaded" id="badge-idProof"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                                <div class="doc-preview-box" id="preview-idProof">
                                                    <c:choose>
                                                        <c:when test="${fn:endsWith(fn:toLowerCase(docId), '.pdf')}">
                                                            <a href="${pageContext.request.contextPath}${docId}" target="_blank" class="doc-link">
                                                                <i class="bi bi-file-earmark-pdf-fill text-danger"></i> View Document (PDF)
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="doc-thumb-row">
                                                                <img src="${pageContext.request.contextPath}${docId}" alt="Government ID" class="doc-thumb-img">
                                                                <a href="${pageContext.request.contextPath}${docId}" target="_blank" class="doc-link">
                                                                    <i class="bi bi-box-arrow-up-right"></i> View Full Image
                                                                </a>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="doc-badge not-uploaded" id="badge-idProof"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                                <div class="doc-preview-box" id="preview-idProof" style="display:none;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Medical Registration Certificate -->
                                <div class="field">
                                    <label>Medical registration certificate</label>
                                    <input type="file" name="degreeCertificate" id="degreeCertificate" accept="image/jpeg,image/png,application/pdf" class="doc-file-input" data-doc-id="degreeCertificate">
                                    <div class="error-msg" id="err-degreeCertificate">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <c:set var="docDegree" value="${not empty doctor.degreeCertificatePath ? doctor.degreeCertificatePath : profile.degreeCertificatePath}" />
                                    <div class="doc-status-wrap" id="docWrap-degreeCertificate">
                                        <c:choose>
                                            <c:when test="${not empty docDegree}">
                                                <div class="doc-badge uploaded" id="badge-degreeCertificate"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                                <div class="doc-preview-box" id="preview-degreeCertificate">
                                                    <c:choose>
                                                        <c:when test="${fn:endsWith(fn:toLowerCase(docDegree), '.pdf')}">
                                                            <a href="${pageContext.request.contextPath}${docDegree}" target="_blank" class="doc-link">
                                                                <i class="bi bi-file-earmark-pdf-fill text-danger"></i> View Document (PDF)
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="doc-thumb-row">
                                                                <img src="${pageContext.request.contextPath}${docDegree}" alt="Medical Registration" class="doc-thumb-img">
                                                                <a href="${pageContext.request.contextPath}${docDegree}" target="_blank" class="doc-link">
                                                                    <i class="bi bi-box-arrow-up-right"></i> View Full Image
                                                                </a>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="doc-badge not-uploaded" id="badge-degreeCertificate"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                                <div class="doc-preview-box" id="preview-degreeCertificate" style="display:none;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Medical License -->
                                <div class="field">
                                    <label>Medical license</label>
                                    <input type="file" name="medicalLicense" id="medicalLicense" accept="image/jpeg,image/png,application/pdf" class="doc-file-input" data-doc-id="medicalLicense">
                                    <div class="error-msg" id="err-medicalLicense">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <c:set var="docLicense" value="${not empty doctor.medicalLicensePath ? doctor.medicalLicensePath : profile.medicalLicensePath}" />
                                    <div class="doc-status-wrap" id="docWrap-medicalLicense">
                                        <c:choose>
                                            <c:when test="${not empty docLicense}">
                                                <div class="doc-badge uploaded" id="badge-medicalLicense"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                                <div class="doc-preview-box" id="preview-medicalLicense">
                                                    <c:choose>
                                                        <c:when test="${fn:endsWith(fn:toLowerCase(docLicense), '.pdf')}">
                                                            <a href="${pageContext.request.contextPath}${docLicense}" target="_blank" class="doc-link">
                                                                <i class="bi bi-file-earmark-pdf-fill text-danger"></i> View Document (PDF)
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="doc-thumb-row">
                                                                <img src="${pageContext.request.contextPath}${docLicense}" alt="Medical License" class="doc-thumb-img">
                                                                <a href="${pageContext.request.contextPath}${docLicense}" target="_blank" class="doc-link">
                                                                    <i class="bi bi-box-arrow-up-right"></i> View Full Image
                                                                </a>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="doc-badge not-uploaded" id="badge-medicalLicense"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                                <div class="doc-preview-box" id="preview-medicalLicense" style="display:none;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 11. Review & Submit -->
                        <div class="section-card" id="reviewSubmitSection">
                            <div class="section-title"><span class="num">11</span> Review &amp; Submit</div>
                            <p style="color:var(--text-gray);font-size:0.9rem;margin:0 0 12px;line-height:1.45;">
                                Use <strong>Review profile</strong> to confirm what you entered. Save first, then submit for verification when ready.
                            </p>
                            <div class="preview-row"><span class="k">Completion</span><span class="v">${profileCompletionPct}%</span></div>
                            <div class="preview-row"><span class="k">Status</span><span class="v">${statusLabel}</span></div>
                            <div class="preview-row"><span class="k">Next step</span><span class="v" style="font-weight:600;text-align:right;">${nextStepGuidance}</span></div>
                            <c:if test="${not empty missingItems}">
                                <div class="missing-list" style="margin:12px 0 4px;">
                                    <c:forEach var="m" items="${missingItems}">
                                        <span>${m}</span>
                                    </c:forEach>
                                </div>
                                <p style="font-size:0.82rem;color:#B45309;margin:8px 0 0;font-weight:600;">Fill the missing items above, save, then return here to submit.</p>
                            </c:if>
                            <input type="hidden" name="intent" id="profileIntent" value="">
                            <div class="actions" style="border-top:none;padding-top:12px;margin-top:8px;">
                                <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
                                <button type="button" class="btn-ghost" id="reviewBtn">Review profile</button>
                                <button type="submit" class="btn-primary" id="submitVerifyBtn">
                                    Save &amp; Submit for verification
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- PREVIEW -->
                <div id="previewPanel" style="display:none;">
                    <div class="preview-card">
                        <h2 style="font-size:1.2rem;font-weight:800;margin-bottom:6px;">11. Review &amp; Submit</h2>
                        <p style="color:var(--text-gray);font-size:0.9rem;margin-bottom:12px;">Confirm your details before saving. ${statusLabel} — ${nextStepGuidance}</p>

                        <div class="section-title"><span class="num">1</span> Professional Information</div>
                        <div class="preview-row"><span class="k">Name</span><span class="v" id="pvFullName">—</span></div>
                        <div class="preview-row"><span class="k">Email</span><span class="v">${doctor.email}</span></div>
                        <div class="preview-row"><span class="k">Phone</span><span class="v" id="pvPhone">—</span></div>
                        <div class="preview-row"><span class="k">Gender</span><span class="v" id="pvGender">—</span></div>
                        <div class="preview-row"><span class="k">Specialization</span><span class="v" id="pvSpec">—</span></div>
                        <div class="preview-row"><span class="k">Qualification</span><span class="v" id="pvQual">—</span></div>
                        <div class="preview-row"><span class="k">Experience</span><span class="v" id="pvExp">—</span></div>
                        <div class="preview-row"><span class="k">Medical Reg No.</span><span class="v" id="pvReg">—</span></div>

                        <div class="section-title"><span class="num">2</span> Clinic / Hospital</div>
                        <div class="preview-row"><span class="k">Hospital / Clinic</span><span class="v" id="pvHospital">—</span></div>
                        <div class="preview-row"><span class="k">Address</span><span class="v" id="pvAddress">—</span></div>
                        <div class="preview-row"><span class="k">City / State / Pin</span><span class="v" id="pvLocation">—</span></div>
                        <div class="preview-row"><span class="k">Maps</span><span class="v" id="pvMap">—</span></div>

                        <div class="section-title"><span class="num">3</span> Consultation Modes</div>
                        <div class="preview-row"><span class="k">Modes</span><span class="v" id="pvModes">—</span></div>

                        <div class="section-title"><span class="num">4</span> Availability</div>
                        <div class="preview-row"><span class="k">Days / Hours</span><span class="v" id="pvAvail">—</span></div>
                        <div class="preview-row"><span class="k">Slot / Buffer</span><span class="v" id="pvSlot">—</span></div>
                        <div class="preview-row"><span class="k">Break</span><span class="v" id="pvBreak">—</span></div>
                        <div class="preview-row"><span class="k">Blocked dates</span><span class="v" id="pvBlocked">—</span></div>
                        <div class="preview-row"><span class="k">Auto-confirm</span><span class="v" id="pvAuto">—</span></div>
                        <div class="preview-row"><span class="k">Emergency</span><span class="v" id="pvEmerg">—</span></div>

                        <div class="section-title"><span class="num">5</span> Languages</div>
                        <div class="preview-row"><span class="k">Languages</span><span class="v" id="pvLang">—</span></div>

                        <div class="section-title"><span class="num">6</span> Services offered</div>
                        <div class="preview-row"><span class="k">Services</span><span class="v" id="pvServices">—</span></div>

                        <div class="section-title"><span class="num">7</span> Fees</div>
                        <div class="preview-row"><span class="k">Consultation</span><span class="v" id="pvFee">—</span></div>
                        <div class="preview-row"><span class="k">Chat / Call / Video</span><span class="v" id="pvOtherFees">—</span></div>

                        <div class="section-title"><span class="num">8</span> About you</div>
                        <div class="preview-row"><span class="k">Bio</span><span class="v" id="pvBio">—</span></div>

                        <div class="section-title"><span class="num">9</span> Payout</div>
                        <div class="preview-row"><span class="k">UPI</span><span class="v" id="pvUpi">—</span></div>
                        <div class="preview-row"><span class="k">Bank</span><span class="v" id="pvBank">—</span></div>

                        <div class="section-title"><span class="num">10</span> Documents</div>
                        <div class="preview-row"><span class="k">Profile photo</span><span class="v" id="pvPhotoDoc">—</span></div>
                        <div class="preview-row"><span class="k">Government ID</span><span class="v" id="pvIdDoc">—</span></div>
                        <div class="preview-row"><span class="k">Medical license</span><span class="v" id="pvLicDoc">—</span></div>
                        <div class="preview-row"><span class="k">Registration certificate</span><span class="v" id="pvCertDoc">—</span></div>

                        <div class="actions">
                            <button type="button" class="btn-ghost" id="backEditBtn">Back &amp; Edit</button>
                            <button type="button" class="btn-primary" id="confirmSaveBtn">Confirm &amp; Save</button>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </main>

    <!-- Google Map Clinic Location Picker Modal (Identical architecture to /users/register) -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle" style="display:none;">
        <div class="map-modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-geo-alt-fill"></i></div>
                <div style="flex: 1;">
                    <h3 id="mapModalTitle">Select Clinic Location</h3>
                    <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Search clinic, landmark or click on the map to pin your location</p>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close location picker">&times;</button>
            </div>
            <div class="map-search-row">
                <div style="position: relative; flex: 1;">
                    <input type="text" id="mapSearchInput" class="form-input" placeholder="Search clinic, hospital, landmark, or street..." autocomplete="off">
                    <div class="map-suggestions" id="mapSuggestions"></div>
                </div>
                <button type="button" class="btn-secondary" id="btnSearchMap" title="Search location"><i class="bi bi-search"></i> Search</button>
                <button type="button" class="btn-secondary" id="btnLocateMe" title="Use current GPS location"><i class="bi bi-crosshair"></i> GPS</button>
            </div>
            <div id="mapPickerAlert" class="alert alert-error" style="display:none; margin-bottom:10px; padding:8px 12px; font-size:0.82rem;"></div>
            <div class="map-canvas-wrap">
                <div id="mapContainer" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="map-selected-bar">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:3px;">
                    <span class="map-selected-label">Chosen Clinic Location</span>
                    <span class="map-provider-tag" id="mapProviderBadge">Interactive Map</span>
                </div>
                <div class="map-selected-value" id="mapSelectedAddress">Click on the map or search to choose your clinic location</div>
            </div>
            <div class="modal-actions" style="margin-top: 14px; display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn-modal-cancel" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Use This Location
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS (CSP Whitelisted via cdn.jsdelivr.net) -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <!-- Optional Google Maps JS API (loaded if key is configured) -->
    <c:if test="${not empty googleMapsApiKey}">
        <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=places" async defer></script>
    </c:if>

    <script>
        (function () {
            'use strict';
            const ctx = '${pageContext.request.contextPath}';
            const form = document.getElementById('profileForm');
            const editPanel = document.getElementById('editPanel');
            const previewPanel = document.getElementById('previewPanel');
            const reviewBtn = document.getElementById('reviewBtn');
            const headerReviewBtn = document.getElementById('headerReviewBtn');
            const backEditBtn = document.getElementById('backEditBtn');
            const confirmSaveBtn = document.getElementById('confirmSaveBtn');
            const submitVerifyBtn = document.getElementById('submitVerifyBtn');
            let saving = false;

            function val(id) {
                const el = document.getElementById(id);
                return el ? (el.value || '').trim() : '';
            }
            function checkedValues(name) {
                return Array.from(document.querySelectorAll('input[name="' + name + '"]:checked')).map(e => e.value);
            }
            function escapeHtml(str) {
                if (!str) return '';
                return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
            }
            function fileLabel(inputName, existingLabel) {
                const input = form.querySelector('input[name="' + inputName + '"]');
                if (input && input.files && input.files.length > 0) return 'Selected: ' + input.files[0].name;
                return existingLabel;
            }

            // -----------------------------------------------------------------
            // Error Display Helpers
            // -----------------------------------------------------------------
            function setInvalid(id, invalid, msg) {
                const el = document.getElementById(id);
                const err = document.getElementById('err-' + id);
                if (el) {
                    el.classList.toggle('is-invalid', !!invalid);
                    if (!invalid && el.value && el.value.trim()) {
                        el.classList.add('is-valid');
                    } else {
                        el.classList.remove('is-valid');
                    }
                }
                if (err) {
                    if (msg) {
                        err.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + escapeHtml(msg);
                    }
                    err.classList.toggle('show', !!invalid);
                }
            }

            function setModeError(show, msg) {
                const wrap = document.getElementById('modeToggles');
                const err = document.getElementById('err-consultationModes');
                if (wrap) wrap.classList.toggle('is-invalid', !!show);
                if (err) {
                    if (msg) err.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + escapeHtml(msg);
                    err.classList.toggle('show', !!show);
                }
            }
            function clearModeError() { setModeError(false); }

            function setDaysError(show, msg) {
                const wrap = document.getElementById('dayToggles');
                const err = document.getElementById('err-availableDays');
                if (wrap) wrap.classList.toggle('is-invalid', !!show);
                if (err) {
                    if (msg) err.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + escapeHtml(msg);
                    err.classList.toggle('show', !!show);
                }
            }

            function isNonNegFee(v) {
                return v === '' || (!Number.isNaN(Number(v)) && Number(v) >= 0);
            }

            // -----------------------------------------------------------------
            // Granular Field Validators with Live Requirements & Length Counters
            // -----------------------------------------------------------------
            function validateFullName(strict) {
                const v = val('fullName');
                if (!v) {
                    setInvalid('fullName', true, 'Doctor full name is required.');
                    return false;
                }
                if (v.length < 2) {
                    setInvalid('fullName', true, 'Doctor name is too short (currently ' + v.length + '/2 characters minimum).');
                    return false;
                }
                setInvalid('fullName', false);
                return true;
            }

            function validatePhone(strict) {
                const v = val('phone');
                if (!v) {
                    if (strict) {
                        setInvalid('phone', true, 'Mobile phone number is required for verification.');
                        return false;
                    }
                    setInvalid('phone', false);
                    return true;
                }
                if (v.length < 10) {
                    setInvalid('phone', true, 'Phone number must be exactly 10 digits (currently ' + v.length + '/10 digits).');
                    return false;
                }
                setInvalid('phone', false);
                return true;
            }

            function validateSpecialization(strict) {
                const v = val('specialization');
                if (!v) {
                    if (strict) {
                        setInvalid('specialization', true, 'Specialization is required for verification.');
                        return false;
                    }
                    setInvalid('specialization', false);
                    return true;
                }
                if (v.length < 2) {
                    setInvalid('specialization', true, 'Specialization is too short (currently ' + v.length + '/2 characters, e.g. Gynecologist).');
                    return false;
                }
                setInvalid('specialization', false);
                return true;
            }

            function validateQualification(strict) {
                const v = val('qualification');
                if (!v) {
                    if (strict) {
                        setInvalid('qualification', true, 'Qualification is required for verification.');
                        return false;
                    }
                    setInvalid('qualification', false);
                    return true;
                }
                if (v.length < 2) {
                    setInvalid('qualification', true, 'Qualification is too short (currently ' + v.length + '/2 characters, e.g. MBBS, MD).');
                    return false;
                }
                setInvalid('qualification', false);
                return true;
            }

            function validateMedicalRegNumber(strict) {
                const v = val('medicalRegNumber');
                if (!v) {
                    if (strict) {
                        setInvalid('medicalRegNumber', true, 'Medical registration number is required to verify your profile.');
                        return false;
                    }
                    setInvalid('medicalRegNumber', false);
                    return true;
                }
                if (v.length < 3) {
                    setInvalid('medicalRegNumber', true, 'Too short: Registration number must be at least 3 characters (currently ' + v.length + '/3 characters, e.g. MCI-12345).');
                    return false;
                }
                setInvalid('medicalRegNumber', false);
                return true;
            }

            function validateExperienceYears(strict) {
                const v = val('experienceYears');
                if (v === '') {
                    if (strict) {
                        setInvalid('experienceYears', true, 'Years of experience is required for verification.');
                        return false;
                    }
                    setInvalid('experienceYears', false);
                    return true;
                }
                const n = Number(v);
                if (n < 0 || n > 50) {
                    setInvalid('experienceYears', true, 'Years of experience must be between 0 and 50 years.');
                    return false;
                }
                setInvalid('experienceYears', false);
                return true;
            }

            function validateHospitalName(strict) {
                const v = val('hospitalName');
                if (!v) {
                    if (strict) {
                        setInvalid('hospitalName', true, 'Hospital / clinic name is required for verification.');
                        return false;
                    }
                    setInvalid('hospitalName', false);
                    return true;
                }
                if (v.length < 2) {
                    setInvalid('hospitalName', true, 'Hospital / clinic name is too short (currently ' + v.length + '/2 characters).');
                    return false;
                }
                setInvalid('hospitalName', false);
                return true;
            }

            function validateClinicAddress(strict) {
                const v = val('clinicAddress');
                if (!v) {
                    if (strict) {
                        setInvalid('clinicAddress', true, 'Clinic address is required for verification.');
                        return false;
                    }
                    setInvalid('clinicAddress', false);
                    return true;
                }
                if (v.length < 5) {
                    setInvalid('clinicAddress', true, 'Clinic address is too short (currently ' + v.length + '/5 characters minimum).');
                    return false;
                }
                setInvalid('clinicAddress', false);
                return true;
            }

            function validateCountry(strict) {
                const v = val('countrySelect');
                if (!v && strict) {
                    setInvalid('countrySelect', true, 'Please select your country.');
                    return false;
                }
                setInvalid('countrySelect', false);
                return true;
            }

            function validateState(strict) {
                const v = val('stateSelect');
                if (!v && strict) {
                    setInvalid('stateSelect', true, 'Please select your state / UT.');
                    return false;
                }
                setInvalid('stateSelect', false);
                return true;
            }

            function validateDistrict(strict) {
                const d = val('districtSelect');
                if (d === 'Other') {
                    const c = val('customCityInput');
                    if (!c) {
                        setInvalid('customCity', true, 'Please type your custom city or town name.');
                        return false;
                    }
                    if (c.length < 2) {
                        setInvalid('customCity', true, 'City name is too short (currently ' + c.length + '/2 characters).');
                        return false;
                    }
                    setInvalid('customCity', false);
                    setInvalid('districtSelect', false);
                    const cityInp = document.getElementById('city');
                    if (cityInp) cityInp.value = c;
                    return true;
                }
                if (!d && strict) {
                    setInvalid('districtSelect', true, 'Please select your district / city.');
                    return false;
                }
                setInvalid('districtSelect', false);
                setInvalid('customCity', false);
                const cityInp = document.getElementById('city');
                if (cityInp) cityInp.value = d;
                return true;
            }

            function validatePincode(strict) {
                const v = val('pincode');
                if (!v) {
                    if (strict) {
                        setInvalid('pincode', true, 'Postal pincode is required for verification.');
                        return false;
                    }
                    setInvalid('pincode', false);
                    return true;
                }
                if (v.length < 6) {
                    setInvalid('pincode', true, 'Pincode must be exactly 6 digits (currently ' + v.length + '/6 digits).');
                    return false;
                }
                setInvalid('pincode', false);
                return true;
            }

            function validateGoogleMapLocation() {
                const v = val('googleMapLocation');
                if (!v) {
                    setInvalid('googleMapLocation', false);
                    return true;
                }
                if (!/^https?:\/\/.+/i.test(v)) {
                    setInvalid('googleMapLocation', true, 'Please enter a valid URL starting with http:// or https://, or click Select from Map.');
                    return false;
                }
                setInvalid('googleMapLocation', false);
                return true;
            }

            function validateConsultationModes(strict) {
                if (!strict) {
                    clearModeError();
                    return true;
                }
                const ok = checkedValues('consultationModes').length > 0;
                setModeError(!ok, ok ? '' : 'Select at least one consultation mode (Clinic, Video, etc.).');
                return ok;
            }

            function validateAvailableDays(strict) {
                if (!strict) {
                    setDaysError(false);
                    return true;
                }
                const ok = checkedValues('availableDays').length > 0;
                setDaysError(!ok, ok ? '' : 'Select at least one available day of the week.');
                return ok;
            }

            function validateOperatingHours(strict) {
                const start = val('startTime');
                const end = val('endTime');
                let ok = true;
                if (strict && !start) {
                    setInvalid('startTime', true, 'Start time is required.');
                    ok = false;
                } else {
                    setInvalid('startTime', false);
                }

                if (start && end && end <= start) {
                    setInvalid('endTime', true, 'End time must be after start time.');
                    ok = false;
                } else if (strict && !end) {
                    setInvalid('endTime', true, 'End time is required.');
                    ok = false;
                } else {
                    setInvalid('endTime', false);
                }
                return ok;
            }

            function validateBreakWindow() {
                const bStart = val('breakStart');
                const bEnd = val('breakEnd');
                if ((bStart && !bEnd) || (!bStart && bEnd)) {
                    setInvalid('breakEnd', true, 'Provide both break start and break end, or leave both empty.');
                    return false;
                }
                if (bStart && bEnd && bEnd <= bStart) {
                    setInvalid('breakEnd', true, 'Break end time must be after break start time.');
                    return false;
                }
                setInvalid('breakEnd', false);
                return true;
            }

            function validateLanguages(strict) {
                const v = val('languages');
                if (!v) {
                    if (strict) {
                        setInvalid('languages', true, 'Enter at least one consultation language.');
                        return false;
                    }
                    setInvalid('languages', false);
                    return true;
                }
                if (v.length < 2) {
                    setInvalid('languages', true, 'Enter at least 2 characters for languages.');
                    return false;
                }
                setInvalid('languages', false);
                return true;
            }

            function validateFees(strict) {
                const fee = val('consultationFee');
                let ok = true;
                if (fee === '') {
                    if (strict) {
                        setInvalid('consultationFee', true, 'Consultation fee is required for verification.');
                        ok = false;
                    } else {
                        setInvalid('consultationFee', false);
                    }
                } else {
                    setInvalid('consultationFee', false);
                }

                ['chatFee', 'callFee', 'videoFee'].forEach(function (id) {
                    setInvalid(id, false);
                });
                return ok;
            }

            function validateBio() {
                const b = val('bio');
                if (b.length > 2000) {
                    setInvalid('bio', true, 'Bio must be 2000 characters or fewer (currently ' + b.length + '/2000).');
                    return false;
                }
                setInvalid('bio', false);
                return true;
            }

            function validatePayout() {
                let ok = true;
                const upi = val('upiId');
                if (upi !== '' && !/^[\w.\-]{2,}@[a-zA-Z]{2,}$/.test(upi)) {
                    setInvalid('upiId', true, 'Enter a valid UPI ID (e.g. doctorname@okaxis).');
                    ok = false;
                } else {
                    setInvalid('upiId', false);
                }

                const bAcct = val('bankAccountNumber');
                const bConf = val('bankConfirmAccountNumber');
                if (bAcct && bConf && bAcct !== bConf) {
                    setInvalid('bankConfirmAccountNumber', true, 'Bank account numbers do not match.');
                    ok = false;
                } else {
                    setInvalid('bankConfirmAccountNumber', false);
                }

                const bIfsc = val('bankIfsc');
                if (bIfsc !== '') {
                    if (bIfsc.length < 11) {
                        setInvalid('bankIfsc', true, 'IFSC must be exactly 11 characters (currently ' + bIfsc.length + '/11, e.g. SBIN0001234).');
                        ok = false;
                    } else if (!/^[A-Z]{4}0[A-Z0-9]{6}$/.test(bIfsc)) {
                        setInvalid('bankIfsc', true, 'Invalid format: 4 letters, 0, then 6 characters (e.g. SBIN0001234).');
                        ok = false;
                    } else {
                        setInvalid('bankIfsc', false);
                    }
                } else {
                    setInvalid('bankIfsc', false);
                }
                return ok;
            }

            function validateDocuments() {
                let ok = true;
                const maxBytes = 5 * 1024 * 1024;
                const allowed = /^(image\/jpeg|image\/png|application\/pdf)$/i;
                ['profilePhoto', 'idProof', 'degreeCertificate', 'medicalLicense'].forEach(function (id) {
                    const input = document.getElementById(id);
                    if (!input || !input.files || !input.files.length) {
                        setInvalid(id, false);
                        return;
                    }
                    const f = input.files[0];
                    const badType = f.type && !allowed.test(f.type);
                    const badSize = f.size > maxBytes;
                    if (badType || badSize) {
                        setInvalid(id, true, badSize ? 'File exceeds 5 MB limit.' : 'Use JPG, PNG or PDF format.');
                        ok = false;
                    } else {
                        setInvalid(id, false);
                    }
                });
                return ok;
            }

            // Master validator combining all field rules
            function validateKeyFields(mode) {
                const strict = mode === 'verify';
                let valid = true;
                let firstInvalid = null;

                function check(fn, id) {
                    const res = fn(strict);
                    if (!res) {
                        valid = false;
                        if (!firstInvalid) firstInvalid = document.getElementById(id);
                    }
                }

                check(validateFullName, 'fullName');
                check(validatePhone, 'phone');
                check(validateSpecialization, 'specialization');
                check(validateQualification, 'qualification');
                check(validateMedicalRegNumber, 'medicalRegNumber');
                check(validateExperienceYears, 'experienceYears');
                check(validateHospitalName, 'hospitalName');
                check(validateClinicAddress, 'clinicAddress');
                check(validateCountry, 'countrySelect');
                check(validateState, 'stateSelect');
                check(validateDistrict, 'districtSelect');
                check(validatePincode, 'pincode');
                check(validateGoogleMapLocation, 'googleMapLocation');
                check(validateConsultationModes, 'modeToggles');
                check(validateAvailableDays, 'dayToggles');
                check(validateOperatingHours, 'endTime');
                check(validateBreakWindow, 'breakEnd');
                check(validateLanguages, 'languages');
                check(validateFees, 'consultationFee');
                check(validateBio, 'bio');
                check(validatePayout, 'bankConfirmAccountNumber');
                check(validateDocuments, 'profilePhoto');

                if (!valid && firstInvalid) {
                    if (firstInvalid.scrollIntoView) {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                    if (firstInvalid.focus) {
                        firstInvalid.focus();
                    }
                }
                return valid;
            }

            // -----------------------------------------------------------------
            // Wire Live Listeners on BOTH 'input' AND 'blur' for ALL fields
            // -----------------------------------------------------------------
            function bindLive(id, validatorFn) {
                const el = document.getElementById(id);
                if (!el) return;
                el.addEventListener('input', function () {
                    validatorFn(false);
                    updateLivePreview();
                });
                el.addEventListener('blur', function () {
                    validatorFn(false);
                });
            }

            bindLive('fullName', validateFullName);
            bindLive('phone', validatePhone);
            bindLive('specialization', validateSpecialization);
            bindLive('qualification', validateQualification);
            bindLive('medicalRegNumber', validateMedicalRegNumber);
            bindLive('experienceYears', validateExperienceYears);
            bindLive('hospitalName', validateHospitalName);
            bindLive('clinicAddress', validateClinicAddress);
            bindLive('customCityInput', validateDistrict);
            bindLive('pincode', validatePincode);
            bindLive('googleMapLocation', validateGoogleMapLocation);
            bindLive('languages', validateLanguages);
            bindLive('consultationFee', validateFees);
            bindLive('chatFee', validateFees);
            bindLive('callFee', validateFees);
            bindLive('videoFee', validateFees);
            bindLive('bio', validateBio);
            bindLive('upiId', validatePayout);
            bindLive('bankAccountNumber', validatePayout);
            bindLive('bankConfirmAccountNumber', validatePayout);
            bindLive('bankIfsc', validatePayout);

            const cSelect = document.getElementById('countrySelect');
            if (cSelect) cSelect.addEventListener('change', () => { validateCountry(false); updateLivePreview(); });
            const sSelect = document.getElementById('stateSelect');
            if (sSelect) sSelect.addEventListener('change', () => { validateState(false); updateLivePreview(); });
            const dSelect = document.getElementById('districtSelect');
            if (dSelect) dSelect.addEventListener('change', () => { validateDistrict(false); updateLivePreview(); });

            ['startTime', 'endTime'].forEach(id => {
                const el = document.getElementById(id);
                if (el) el.addEventListener('change', () => validateOperatingHours(false));
            });
            ['breakStart', 'breakEnd'].forEach(id => {
                const el = document.getElementById(id);
                if (el) el.addEventListener('change', () => validateBreakWindow());
            });

            // -----------------------------------------------------------------
            // Progress Calculation (20 milestones, 5% each = 100%)
            // -----------------------------------------------------------------
            const hasExistingPhoto = ${not empty doctor.profilePhotoPath ? 'true' : 'false'};
            const hasExistingDocs = ${(not empty doctor.medicalLicensePath or not empty doctor.degreeCertificatePath or not empty doctor.idProofPath or not empty doctor.identityDocumentPath) ? 'true' : 'false'};

            function recalculateProgress() {
                let filled = 0;
                const total = 20;

                const photoInput = document.getElementById('profilePhoto');
                const hasPhoto = (photoInput && photoInput.files && photoInput.files.length > 0) || hasExistingPhoto;
                if (hasPhoto) filled++;

                if (val('fullName').length >= 2) filled++;
                if (/^\d{10}$/.test(val('phone'))) filled++;
                if (val('gender')) filled++;
                if (val('specialization').length >= 2) filled++;
                if (val('qualification').length >= 2) filled++;

                const reg = val('medicalRegNumber');
                if (reg && reg.length >= 3 && reg.length <= 60 && /^[a-zA-Z0-9\/\-.\s]+$/.test(reg)) filled++;

                const exp = val('experienceYears');
                if (exp !== '' && /^\d+$/.test(exp) && Number(exp) >= 0 && Number(exp) <= 50) filled++;

                if (val('hospitalName').length >= 2) filled++;
                if (val('clinicAddress').length >= 5) filled++;

                const distVal = val('districtSelect');
                const customCity = val('customCityInput');
                const cityVal = (distVal && distVal !== 'Other') ? distVal : (customCity || val('city'));
                if (cityVal) filled++;

                if (val('stateSelect') || val('state')) filled++;
                if (/^\d{6}$/.test(val('pincode'))) filled++;
                if (checkedValues('consultationModes').length > 0) filled++;
                if (checkedValues('availableDays').length > 0) filled++;
                if (val('startTime')) filled++;
                if (val('languages').length >= 2) filled++;

                const fee = val('consultationFee');
                if (fee !== '' && !Number.isNaN(Number(fee)) && Number(fee) >= 0) filled++;

                const hasUploadedDoc = ['idProof', 'degreeCertificate', 'medicalLicense'].some(id => {
                    const inp = document.getElementById(id);
                    return inp && inp.files && inp.files.length > 0;
                });
                if (hasExistingDocs || hasUploadedDoc) filled++;

                serializeBankDetails();
                if (val('upiId') || val('bankDetails') || val('bankAccountNumber')) filled++;

                const pct = Math.min(100, Math.round((100 * filled) / total));
                document.querySelectorAll('.progress-pct').forEach(el => el.textContent = pct + '%');
                document.querySelectorAll('.progress-bar-fill').forEach(el => el.style.width = pct + '%');

                const lpCompletion = document.getElementById('lpCompletion');
                if (lpCompletion) lpCompletion.textContent = pct + '%';
            }

            function serializeBankDetails() {
                const holder = val('bankAccountHolder');
                const bank = val('bankName');
                const acct = val('bankAccountNumber');
                const ifsc = val('bankIfsc');
                const branch = val('bankBranch');
                const hidden = document.getElementById('bankDetails');
                if (!hidden) return;

                if (!holder && !bank && !acct && !ifsc && !branch) return;
                const parts = [];
                if (holder) parts.push('Account Holder: ' + holder);
                if (bank) parts.push('Bank: ' + bank);
                if (acct) parts.push('A/C: ' + acct);
                if (ifsc) parts.push('IFSC: ' + ifsc.toUpperCase());
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
                if (ifscMatch && document.getElementById('bankIfsc')) document.getElementById('bankIfsc').value = ifscMatch[1].trim();
                if (branchMatch && document.getElementById('bankBranch')) document.getElementById('bankBranch').value = branchMatch[1].trim();

                if (!holderMatch && !bankMatch && !acctMatch && !ifscMatch && !branchMatch) {
                    if (document.getElementById('bankAccountHolder')) document.getElementById('bankAccountHolder').value = raw;
                }
            }

            // Photo upload live preview
            const photoInput = document.getElementById('profilePhoto');
            if (photoInput) {
                photoInput.addEventListener('change', function () {
                    if (this.files && this.files[0]) {
                        const f = this.files[0];
                        const nameEl = document.getElementById('photoFileName');
                        if (nameEl) nameEl.textContent = f.name;

                        if (f.type && f.type.startsWith('image/')) {
                            const url = URL.createObjectURL(f);
                            const mainImg = document.getElementById('mainPhotoPreview');
                            const mainFallback = document.getElementById('mainPhotoFallback');
                            if (mainImg) { mainImg.src = url; mainImg.style.display = 'block'; }
                            if (mainFallback) mainFallback.style.display = 'none';

                            const lpImg = document.getElementById('lpAvatarImg');
                            const lpFallback = document.getElementById('lpAvatarFallback');
                            if (lpImg) { lpImg.src = url; lpImg.style.display = 'block'; }
                            if (lpFallback) lpFallback.style.display = 'none';
                        }
                    }
                    recalculateProgress();
                });
            }

            function updateLivePreview() {
                const setText = (id, text) => {
                    const el = document.getElementById(id);
                    if (el) el.textContent = text || '—';
                };
                const name = val('fullName') || 'Doctor name';
                const spec = val('specialization') || 'Specialization';
                setText('lpName', name);
                setText('lpNameTop', name);
                setText('lpSpec', spec);
                setText('lpSpecTop', spec);
                const currentCity = val('city') || (val('districtSelect') !== 'Other' ? val('districtSelect') : '') || val('customCityInput');
                setText('lpCity', [currentCity, val('stateSelect') || val('state')].filter(Boolean).join(', ') || 'City');
                const fee = val('consultationFee');
                setText('lpFee', fee !== '' ? '₹' + fee : 'Fee');
                setText('lpModes', checkedValues('consultationModes').join(', ') || '—');
                recalculateProgress();
            }

            // -----------------------------------------------------------------
            // Cascading Location Selectors (Instant Local Dataset, Zero CSP Violations)
            // -----------------------------------------------------------------
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

            const savedCountry = "${not empty doctor.country ? doctor.country : 'India'}";
            const savedState = "${not empty doctor.state ? doctor.state : ''}";
            const savedCity = "${not empty doctor.city ? doctor.city : ''}";

            // -----------------------------------------------------------------
            // Strict Input Restriction & Clamping (Chars do not appear if invalid)
            // -----------------------------------------------------------------
            function setupInputRestrictions() {
                // Pincode: Digits only, strictly max 6 digits. 7th digit will not appear.
                const pin = document.getElementById('pincode');
                if (pin) {
                    pin.addEventListener('input', function () {
                        this.value = this.value.replace(/\D/g, '').slice(0, 6);
                        validatePincode(false);
                        recalculateProgress();
                    });
                }

                // Phone: Digits only, strictly max 10 digits. 11th digit will not appear.
                const phone = document.getElementById('phone');
                if (phone) {
                    phone.addEventListener('input', function () {
                        this.value = this.value.replace(/\D/g, '').slice(0, 10);
                        validatePhone(false);
                        recalculateProgress();
                    });
                }

                // Medical Registration Number: Alphanumeric, /, -, ., space only. Max 60 chars.
                const reg = document.getElementById('medicalRegNumber');
                if (reg) {
                    reg.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z0-9\/\-.\s]/g, '').slice(0, 60);
                        validateMedicalRegNumber(false);
                        recalculateProgress();
                    });
                }

                // Years of Experience: Digits only, max 2 chars, capped at 50.
                const exp = document.getElementById('experienceYears');
                if (exp) {
                    exp.addEventListener('input', function () {
                        this.value = this.value.replace(/\D/g, '').slice(0, 2);
                        if (this.value !== '' && Number(this.value) > 50) {
                            this.value = '50';
                        }
                        validateExperienceYears(false);
                        recalculateProgress();
                    });
                }

                // Doctor Name: Letters, spaces, hyphens, dots only. Max 80 chars.
                const name = document.getElementById('fullName');
                if (name) {
                    name.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z\s.'\-]/g, '').slice(0, 80);
                        validateFullName(false);
                        updateLivePreview();
                    });
                }

                // Specialization: Letters, spaces, commas, dots, hyphens, (), / only. Max 80 chars.
                const spec = document.getElementById('specialization');
                if (spec) {
                    spec.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z\s,.'\-()\/]/g, '').slice(0, 80);
                        validateSpecialization(false);
                        updateLivePreview();
                    });
                }

                // Qualification: Letters, spaces, commas, dots, hyphens, (), / only. Max 120 chars.
                const qual = document.getElementById('qualification');
                if (qual) {
                    qual.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z0-9\s,.'\-()\/]/g, '').slice(0, 120);
                        validateQualification(false);
                        updateLivePreview();
                    });
                }

                // Hospital Name: Max 120 chars.
                const hosp = document.getElementById('hospitalName');
                if (hosp) {
                    hosp.addEventListener('input', function () {
                        this.value = this.value.slice(0, 120);
                        validateHospitalName(false);
                        recalculateProgress();
                    });
                }

                // Clinic Address: Max 300 chars.
                const addr = document.getElementById('clinicAddress');
                if (addr) {
                    addr.addEventListener('input', function () {
                        this.value = this.value.slice(0, 300);
                        validateClinicAddress(false);
                        recalculateProgress();
                    });
                }

                // Custom City: Letters, spaces, hyphens only. Max 60 chars.
                const cityCustom = document.getElementById('customCityInput');
                if (cityCustom) {
                    cityCustom.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z\s\-]/g, '').slice(0, 60);
                        const cityInp = document.getElementById('city');
                        if (cityInp) cityInp.value = this.value.trim();
                        validateDistrict(false);
                        updateLivePreview();
                    });
                }

                // Fees: Digits only, max 6 digits (up to ₹999,999). Negative numbers and decimals do not appear.
                ['consultationFee', 'chatFee', 'callFee', 'videoFee'].forEach(function (id) {
                    const el = document.getElementById(id);
                    if (el) {
                        el.addEventListener('input', function () {
                            this.value = this.value.replace(/\D/g, '').slice(0, 6);
                            validateFees(false);
                            updateLivePreview();
                        });
                    }
                });

                // Bank Account Numbers: Digits only, max 20 digits.
                ['bankAccountNumber', 'bankConfirmAccountNumber'].forEach(function (id) {
                    const el = document.getElementById(id);
                    if (el) {
                        el.addEventListener('input', function () {
                            this.value = this.value.replace(/\D/g, '').slice(0, 20);
                            validatePayout();
                            serializeBankDetails();
                            recalculateProgress();
                        });
                    }
                });

                // Bank IFSC: Uppercase automatically, alphanumeric only, max 11 chars.
                const ifsc = document.getElementById('bankIfsc');
                if (ifsc) {
                    ifsc.addEventListener('input', function () {
                        this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 11);
                        validatePayout();
                        serializeBankDetails();
                    });
                }

                // UPI ID: Lowercase, no spaces, valid symbols only. Max 80 chars.
                const upi = document.getElementById('upiId');
                if (upi) {
                    upi.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z0-9.\-_@]/g, '').toLowerCase().slice(0, 80);
                        validatePayout();
                        recalculateProgress();
                    });
                }

                // Languages: Letters, spaces, commas, hyphens only. Max 120 chars.
                const lang = document.getElementById('languages');
                if (lang) {
                    lang.addEventListener('input', function () {
                        this.value = this.value.replace(/[^a-zA-Z\s,.'\-]/g, '').slice(0, 120);
                        validateLanguages(false);
                        recalculateProgress();
                    });
                }

                // Bio: Max 2000 chars.
                const bio = document.getElementById('bio');
                if (bio) {
                    bio.addEventListener('input', function () {
                        this.value = this.value.slice(0, 2000);
                        validateBio();
                    });
                }
            }

            function initLocationSelectors() {
                const countrySelect = document.getElementById('countrySelect');
                const stateSelect = document.getElementById('stateSelect');
                const districtSelect = document.getElementById('districtSelect');
                const customCityGroup = document.getElementById('customCityGroup');
                const customCityInput = document.getElementById('customCityInput');
                const cityInput = document.getElementById('city');

                if (savedCountry && countrySelect) countrySelect.value = savedCountry;

                function populateStates(country, selectedState) {
                    if (!stateSelect) return;
                    stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';

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
                    updateLivePreview();
                }

                if (countrySelect) {
                    countrySelect.addEventListener('change', () => {
                        populateStates(countrySelect.value, '');
                        if (cityInput) cityInput.value = '';
                        updateLivePreview();
                    });
                }

                if (stateSelect) {
                    stateSelect.addEventListener('change', () => {
                        populateDistricts(countrySelect.value, stateSelect.value, '');
                        setInvalid('stateSelect', false);
                        updateLivePreview();
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
                        setInvalid('districtSelect', false);
                        setInvalid('city', false);
                        updateLivePreview();
                    });
                }

                if (customCityInput) {
                    customCityInput.addEventListener('input', () => {
                        if (cityInput) cityInput.value = customCityInput.value.trim();
                        setInvalid('customCity', false);
                        setInvalid('city', false);
                        updateLivePreview();
                    });
                }

                populateStates(countrySelect.value, savedState);
            }

            // -----------------------------------------------------------------
            // Map Picker Implementation (Leaflet + OSM, CSP Compliant)
            // -----------------------------------------------------------------
            let mapInitialized = false;
            let currentMap = null;
            let currentMarker = null;
            let selectedClinicCoords = null;
            let selectedLocationText = '';

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
            const mapProviderBadge = document.getElementById('mapProviderBadge');

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
                selectedClinicCoords = { lat: lat, lng: lng };
                selectedLocationText = formattedAddress || '';
                if (mapSelectedAddressEl) {
                    mapSelectedAddressEl.textContent = selectedLocationText || ('Location (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')');
                }
                if (btnConfirmLocation) {
                    btnConfirmLocation.disabled = !selectedLocationText;
                }
            }

            async function reverseGeocodeCoords(lat, lng) {
                setSelectedLocation('Resolving clinic address…', lat, lng);
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
                    console.warn('[MapPicker] Reverse geocoding fetch error:', e);
                }
                setSelectedLocation('Clinic Location (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')', lat, lng);
            }

            function initMapPicker() {
                if (typeof L === 'undefined') {
                    console.error('[MapPicker] Leaflet JS not loaded.');
                    showMapAlert('Map renderer failed to load. You can paste your Google Maps link directly.');
                    return;
                }

                if (mapInitialized && currentMap) {
                    setTimeout(function() {
                        if (currentMap.invalidateSize) currentMap.invalidateSize();
                        if (selectedClinicCoords && currentMarker) {
                            currentMap.setView([selectedClinicCoords.lat, selectedClinicCoords.lng], 14);
                            currentMarker.setLatLng([selectedClinicCoords.lat, selectedClinicCoords.lng]);
                        }
                    }, 100);
                    return;
                }

                let defaultLat = 19.0760;
                let defaultLng = 72.8777; // Mumbai default

                // Check existing map URL for coordinates
                const existingMapUrl = val('googleMapLocation');
                if (existingMapUrl) {
                    const match = existingMapUrl.match(/q=([0-9.-]+),([0-9.-]+)/) || existingMapUrl.match(/@([0-9.-]+),([0-9.-]+)/);
                    if (match) {
                        defaultLat = parseFloat(match[1]);
                        defaultLng = parseFloat(match[2]);
                    }
                }

                const existingSearch = val('city') || val('clinicAddress') || val('hospitalName');
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
                        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
                    }).addTo(currentMap);

                    currentMarker = L.marker([defaultLat, defaultLng], {
                        draggable: true,
                        autoPan: true
                    }).addTo(currentMap);

                    if (mapProviderBadge) mapProviderBadge.textContent = 'Interactive Map';

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
                        if (existingMapUrl && existingMapUrl.includes('=')) {
                            reverseGeocodeCoords(defaultLat, defaultLng);
                        } else if (existingSearch) {
                            executeSearch(existingSearch);
                        } else {
                            reverseGeocodeCoords(defaultLat, defaultLng);
                        }
                    }, 150);

                } catch (err) {
                    console.error('[MapPicker] Failed to init Leaflet:', err);
                    showMapAlert('Map renderer error. You can still paste your Google Maps link or type your address.');
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
                    showMapAlert('No location results found for "' + query + '". Try a landmark, area or hospital name.');
                } catch (e) {
                    showMapAlert('Network error searching location. You can select directly on the map.');
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
                    showMapAlert('Requesting your current GPS coordinates…');
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
                        showMapAlert('Location access was denied or unavailable. You can click on the map to set your location.');
                    }, { timeout: 10000, enableHighAccuracy: true });
                });
            }

            if (btnConfirmLocation) {
                btnConfirmLocation.addEventListener('click', function () {
                    if (!selectedClinicCoords) return;

                    // 1. Google Maps URL
                    const mapUrlInput = document.getElementById('googleMapLocation');
                    if (mapUrlInput) {
                        mapUrlInput.value = 'https://www.google.com/maps?q=' + selectedClinicCoords.lat.toFixed(6) + ',' + selectedClinicCoords.lng.toFixed(6);
                        setInvalid('googleMapLocation', false);
                    }

                    // 2. Clinic Address
                    const addrInput = document.getElementById('clinicAddress');
                    if (addrInput && (!addrInput.value || addrInput.value.trim().length < 5) && selectedLocationText) {
                        addrInput.value = selectedLocationText;
                        setInvalid('clinicAddress', false);
                    }

                    // 3. Pincode
                    if (selectedLocationText) {
                        const pinMatch = selectedLocationText.match(/\b([1-9][0-9]{5})\b/);
                        const pinInput = document.getElementById('pincode');
                        if (pinMatch && pinInput && !pinInput.value) {
                            pinInput.value = pinMatch[1];
                            setInvalid('pincode', false);
                        }
                    }

                    closeMapPicker();
                    updateLivePreview();
                    recalculateProgress();
                });
            }

            // Close modals on Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    if (mapPickerModal && mapPickerModal.style.display === 'flex') closeMapPicker();
                }
            });

            // -----------------------------------------------------------------
            // Preview & Submission Handlers
            // -----------------------------------------------------------------
            function showPreview() {
                if (!validateKeyFields('draft')) return;

                function checked(name) {
                    const el = form.querySelector('input[name="' + name + '"]');
                    return el && el.checked ? 'Yes' : 'No';
                }
                const phone = val('phone');
                const exp = val('experienceYears');

                document.getElementById('pvFullName').textContent = val('fullName') || '—';
                document.getElementById('pvPhone').textContent = phone || '—';
                document.getElementById('pvGender').textContent = val('gender') || '—';
                document.getElementById('pvSpec').textContent = val('specialization') || '—';
                document.getElementById('pvQual').textContent = val('qualification') || '—';
                document.getElementById('pvExp').textContent = exp !== '' ? exp + ' years' : '—';
                document.getElementById('pvReg').textContent = val('medicalRegNumber') || '—';
                document.getElementById('pvHospital').textContent = val('hospitalName') || '—';
                document.getElementById('pvAddress').textContent = val('clinicAddress') || '—';
                const distVal = val('districtSelect');
                const customCity = val('customCityInput');
                const finalCity = (distVal && distVal !== 'Other') ? distVal : (customCity || val('city'));
                document.getElementById('pvLocation').textContent =
                    [finalCity, val('stateSelect') || val('state'), val('countrySelect'), val('pincode')].filter(Boolean).join(', ') || '—';
                document.getElementById('pvMap').textContent = val('googleMapLocation') || '—';
                document.getElementById('pvModes').textContent = checkedValues('consultationModes').join(', ') || '—';
                document.getElementById('pvAvail').textContent =
                    (checkedValues('availableDays').join(', ') || '—') +
                    ' · ' + (val('startTime') || '—') + '–' + (val('endTime') || '—');
                document.getElementById('pvSlot').textContent =
                    (val('slotDurationMinutes') || '—') + ' min slot · ' + (val('bufferMinutes') || '0') + ' min buffer';
                document.getElementById('pvBreak').textContent =
                    (val('breakStart') || '—') + '–' + (val('breakEnd') || '—');
                document.getElementById('pvBlocked').textContent = val('blockedDates') || '—';
                document.getElementById('pvAuto').textContent = checked('autoConfirm');
                document.getElementById('pvEmerg').textContent = checked('emergencyAvailable');
                document.getElementById('pvLang').textContent = val('languages') || '—';
                document.getElementById('pvServices').textContent = val('services') || '—';
                document.getElementById('pvFee').textContent =
                    val('consultationFee') !== '' ? '₹' + val('consultationFee') : '—';
                document.getElementById('pvOtherFees').textContent = [
                    val('chatFee') !== '' ? 'Chat ₹' + val('chatFee') : null,
                    val('callFee') !== '' ? 'Call ₹' + val('callFee') : null,
                    val('videoFee') !== '' ? 'Video ₹' + val('videoFee') : null
                ].filter(Boolean).join(' · ') || '—';
                document.getElementById('pvBio').textContent = val('bio') || '—';
                document.getElementById('pvUpi').textContent = val('upiId') || '—';
                document.getElementById('pvBank').textContent = val('bankDetails') || '—';

                document.getElementById('pvPhotoDoc').textContent =
                    fileLabel('profilePhoto', '${not empty doctor.profilePhotoPath ? "On file" : "Not uploaded"}');
                document.getElementById('pvIdDoc').textContent =
                    fileLabel('idProof', '${(not empty doctor.idProofPath or not empty doctor.identityDocumentPath) ? "On file" : "Not uploaded"}');
                document.getElementById('pvLicDoc').textContent =
                    fileLabel('medicalLicense', '${not empty doctor.medicalLicensePath ? "On file" : "Not uploaded"}');
                document.getElementById('pvCertDoc').textContent =
                    fileLabel('degreeCertificate', '${not empty doctor.degreeCertificatePath ? "On file" : "Not uploaded"}');

                editPanel.style.display = 'none';
                previewPanel.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }

            reviewBtn.addEventListener('click', showPreview);
            headerReviewBtn.addEventListener('click', showPreview);
            backEditBtn.addEventListener('click', () => {
                previewPanel.style.display = 'none';
                editPanel.style.display = 'block';
                saving = false;
                confirmSaveBtn.disabled = false;
                confirmSaveBtn.textContent = 'Confirm & Save';
            });

            function ensureCsrfOnForm() {
                if (!form) return;
                var token = '';
                var csrfInput = form.querySelector('input[name="_csrf"]');
                if (csrfInput && csrfInput.value) token = csrfInput.value;
                if (!token) {
                    var match = document.cookie.match(/(^|;)\s*XSRF-TOKEN\s*=\s*([^;]+)/);
                    if (match) token = decodeURIComponent(match[2]);
                }
                if (token) {
                    if (!form.querySelector('input[name="_csrf"]')) {
                        var hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = '_csrf';
                        hidden.value = token;
                        form.appendChild(hidden);
                    }
                    if (form.action && !form.action.includes('_csrf=')) {
                        var sep = form.action.includes('?') ? '&' : '?';
                        form.action += sep + '_csrf=' + encodeURIComponent(token);
                    }
                }
            }

            confirmSaveBtn.addEventListener('click', () => {
                if (saving) return;
                if (!validateKeyFields('draft')) {
                    previewPanel.style.display = 'none';
                    editPanel.style.display = 'block';
                    return;
                }
                var intentField = document.getElementById('profileIntent');
                if (intentField) intentField.value = '';
                saving = true;
                confirmSaveBtn.disabled = true;
                confirmSaveBtn.textContent = 'Saving...';
                ensureCsrfOnForm();
                form.submit();
            });

            if (submitVerifyBtn) {
                submitVerifyBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    if (saving) return;
                    if (!validateKeyFields('verify')) {
                        previewPanel.style.display = 'none';
                        editPanel.style.display = 'block';
                        return;
                    }
                    var intentField = document.getElementById('profileIntent');
                    if (intentField) intentField.value = 'submitVerification';
                    saving = true;
                    submitVerifyBtn.textContent = 'Submitting...';
                    ensureCsrfOnForm();
                    form.submit();
                });
            }

            form.addEventListener('submit', function (e) {
                if (!validateKeyFields('draft')) {
                    e.preventDefault();
                    saving = false;
                    return;
                }
                ensureCsrfOnForm();
            });

            function initDocUploadListeners() {
                ['profilePhoto', 'idProof', 'degreeCertificate', 'medicalLicense'].forEach(function(docId) {
                    const input = document.getElementById(docId);
                    if (!input) return;
                    input.addEventListener('change', function() {
                        const badge = document.getElementById('badge-' + docId);
                        const preview = document.getElementById('preview-' + docId);
                        if (!badge || !preview) return;

                        if (input.files && input.files[0]) {
                            const file = input.files[0];
                            const isImg = file.type && file.type.startsWith('image/');
                            const isPdf = file.type === 'application/pdf' || file.name.toLowerCase().endsWith('.pdf');
                            const sizeKb = (file.size / 1024).toFixed(1);

                            badge.className = 'doc-badge selected';
                            badge.innerHTML = '<i class="bi bi-file-earmark-check-fill"></i>' +
                                '<div style="min-width:0;flex:1;word-break:break-all;overflow-wrap:anywhere;">' +
                                    '<span>Selected: <strong>' + escapeHtml(file.name) + '</strong></span>' +
                                    '<span style="display:block;font-size:0.75rem;color:#475569;margin-top:2px;">(' + sizeKb + ' KB) &bull; Ready to save</span>' +
                                '</div>';

                            preview.style.display = 'block';
                            if (isImg) {
                                const reader = new FileReader();
                                reader.onload = function(e) {
                                    preview.innerHTML =
                                        '<div class="doc-thumb-row">' +
                                          '<img src="' + e.target.result + '" alt="Preview" class="doc-thumb-img">' +
                                          '<div class="doc-file-info" style="min-width:0;flex:1;word-break:break-all;overflow-wrap:anywhere;">' +
                                              '<div style="color:#059669;font-weight:700;"><i class="bi bi-image text-success me-1"></i> Image preview</div>' +
                                              '<div style="font-size:0.75rem;color:#64748B;">' + escapeHtml(file.name) + '</div>' +
                                          '</div>' +
                                        '</div>';
                                };
                                reader.readAsDataURL(file);
                            } else if (isPdf) {
                                preview.innerHTML =
                                    '<div class="doc-pdf-row">' +
                                      '<i class="bi bi-file-earmark-pdf-fill text-danger fs-4" style="flex-shrink:0;"></i>' +
                                      '<div class="doc-file-info" style="min-width:0;flex:1;word-break:break-all;overflow-wrap:anywhere;">' +
                                          '<div style="font-weight:700;">PDF document selected</div>' +
                                          '<div style="font-size:0.75rem;color:#64748B;">' + escapeHtml(file.name) + '</div>' +
                                      '</div>' +
                                    '</div>';
                            } else {
                                preview.innerHTML =
                                    '<div class="doc-generic-row">' +
                                      '<i class="bi bi-file-earmark text-primary fs-4" style="flex-shrink:0;"></i>' +
                                      '<div class="doc-file-info" style="min-width:0;flex:1;word-break:break-all;overflow-wrap:anywhere;">' +
                                          '<span>' + escapeHtml(file.name) + '</span>' +
                                      '</div>' +
                                    '</div>';
                            }
                        }
                    });
                });
            }

            setupInputRestrictions();
            initLocationSelectors();
            parseExistingBankDetails();
            initDocUploadListeners();
            updateLivePreview();
        })();
    </script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
