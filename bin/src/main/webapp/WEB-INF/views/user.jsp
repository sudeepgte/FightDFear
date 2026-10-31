<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Leaflet Map CSS for Map Picker (whitelisted by CSP) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
            --rose-light: #FFF1F2;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
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
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
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
        .header-brand i { color: var(--primary); font-size: 1.3rem; }
        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 8px;
            transition: color 0.2s, background-color 0.2s;
        }
        .header-links a:hover, .header-links a:focus-visible {
            color: var(--primary);
            background: var(--rose-light);
            outline: none;
        }
        .main-container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 28px auto 40px;
            padding: 0 16px;
        }
        .info-banner {
            background: var(--rose-soft);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
            border: 1px solid #FECDD3;
        }
        .info-banner h1 {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .info-banner p {
            font-size: 0.9rem;
            color: var(--navy);
            line-height: 1.45;
            margin: 0;
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 16px; position: relative; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .req-star { color: var(--primary); font-weight: 800; margin-left: 2px; }
        .form-input, .form-select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            background: #fff;
            color: var(--navy);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background-color 0.2s;
        }
        .form-input:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.15);
        }
        .form-input.is-invalid, .form-select.is-invalid {
            border-color: var(--error) !important;
            background-color: #FFF5F5 !important;
        }
        .form-input.is-invalid:focus, .form-select.is-invalid:focus {
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.15) !important;
        }
        .field-error {
            display: none;
            font-size: 0.8rem;
            color: var(--error);
            margin-top: 5px;
            font-weight: 600;
            line-height: 1.35;
        }
        .field-error.show {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .password-field {
            position: relative;
        }
        .password-field .form-input {
            padding-right: 48px;
        }
        .password-toggle-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            padding: 0;
            transition: background 0.15s, color 0.15s;
        }
        .password-toggle-btn:hover,
        .password-toggle-btn:focus-visible {
            color: var(--primary);
            outline: none;
            background: var(--rose-soft);
        }
        .password-toggle-btn i { font-size: 1.1rem; pointer-events: none; }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 5px; line-height: 1.4; }
        .row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .btn-select-map {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: var(--rose-light);
            color: var(--primary-hover);
            border: 1px solid #FECDD3;
            border-radius: 8px;
            padding: 8px 14px;
            font-weight: 700;
            font-size: 0.84rem;
            cursor: pointer;
            font-family: inherit;
            margin-top: 7px;
            transition: all 0.2s ease;
        }
        .btn-select-map:hover, .btn-select-map:focus-visible {
            background: var(--rose-soft);
            border-color: var(--primary);
            color: var(--primary-hover);
            transform: translateY(-1px);
            outline: none;
        }
        .form-section-divider {
            margin: 24px 0 16px;
            padding-top: 18px;
            border-top: 1px solid var(--border-color);
        }
        .form-section-title {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }
        .form-section-subtitle {
            font-size: 0.8rem;
            color: var(--text-gray);
            margin-bottom: 14px;
        }
        .otp-row {
            display: flex;
            gap: 8px;
            margin-top: 8px;
            flex-wrap: wrap;
            align-items: center;
        }
        .otp-input {
            flex: 1 1 11ch;
            min-width: 10ch;
            max-width: 100%;
            letter-spacing: 2px;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }
        .btn-secondary {
            background: var(--rose-soft);
            color: var(--primary-hover);
            border: 1px solid #FECDD3;
            border-radius: 10px;
            padding: 10px 14px;
            font-weight: 700;
            font-size: 0.85rem;
            cursor: pointer;
            font-family: inherit;
            transition: background 0.15s, transform 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-secondary:hover:not(:disabled) {
            background: #FECDD3;
            transform: translateY(-1px);
        }
        .btn-secondary:disabled { opacity: 0.55; cursor: not-allowed; }
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            margin-top: 12px;
            transition: background 0.2s, transform 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-primary:hover:not(:disabled) { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-primary:disabled { background: #cbd5e1; cursor: not-allowed; transform: none; }
        .alert {
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.9rem;
            margin-bottom: 16px;
            line-height: 1.4;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #FECACA; }
        .alert-ok { background: var(--success-bg); color: var(--success); border: 1px solid #BBF7D0; }
        .terms-box {
            background: #FDF2F8;
            border: 1px solid #FBCFE8;
            border-radius: 12px;
            padding: 12px 14px;
            margin: 16px 0 10px;
        }
        .footer-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
        .footer-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .footer-link a:hover { text-decoration: underline; }
        .otp-badge {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--success);
            display: none;
            align-items: center;
            gap: 4px;
        }
        .otp-badge.show { display: inline-flex; }
        .otp-status {
            font-size: 0.78rem;
            margin-top: 6px;
            font-weight: 600;
        }
        .otp-status.ok { color: var(--success); }
        .otp-status.err { color: var(--error); }
        .otp-status.info { color: var(--text-gray); }
        .submit-hint {
            font-size: 0.8rem;
            color: var(--text-gray);
            text-align: center;
            margin-top: 10px;
        }

        /* Modal Overlays */
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center; z-index: 1000; padding: 16px;
        }
        .modal-card {
            background: #FFFFFF; border-radius: 20px; max-width: 480px; width: 100%; padding: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15); max-height: 90vh; overflow-y: auto;
        }
        .modal-header { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; }
        .modal-header .icon-wrap {
            width: 42px; height: 42px; border-radius: 12px; background: var(--rose-soft); color: var(--primary);
            display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0;
        }
        .modal-header h3 { font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0; }
        .modal-body {
            background: var(--bg-page); border: 1px solid var(--border-color); border-radius: 12px;
            padding: 14px 16px; margin-bottom: 20px;
        }
        .review-row {
            display: flex; justify-content: space-between; gap: 12px; padding: 8px 0;
            border-bottom: 1px dashed var(--border-color); font-size: 0.88rem;
        }
        .review-row:last-child { border-bottom: none; }
        .review-row .label { color: var(--text-gray); font-weight: 500; }
        .review-row .value { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }
        .modal-actions { display: flex; gap: 10px; }
        .btn-modal-cancel {
            flex: 1; padding: 12px; background: #FFFFFF; border: 1px solid var(--border-color);
            color: var(--navy); border-radius: 10px; font-size: 0.92rem; font-weight: 700; cursor: pointer; font-family: inherit;
            transition: background 0.2s;
        }
        .btn-modal-cancel:hover { background: #F1F5F9; }
        .btn-modal-confirm {
            flex: 1.5; padding: 12px; background: var(--primary); border: none; color: #FFFFFF;
            border-radius: 10px; font-size: 0.92rem; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px; font-family: inherit;
            transition: background 0.2s;
        }
        .btn-modal-confirm:hover:not(:disabled) { background: var(--primary-hover); }
        .btn-modal-confirm:disabled { opacity: 0.55; cursor: not-allowed; }
        .btn-close-modal {
            background: none; border: none; font-size: 1.5rem; color: var(--text-gray); cursor: pointer; line-height: 1; padding: 4px 8px; border-radius: 6px;
        }
        .btn-close-modal:hover { color: var(--navy); background: #F1F5F9; }

        /* Map Picker Specific Styles */
        .map-modal-card {
            background: #FFFFFF;
            border-radius: 20px;
            max-width: 640px;
            width: 100%;
            max-height: 94vh;
            display: flex;
            flex-direction: column;
            padding: 22px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
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
            height: 320px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            background: #E2E8F0;
        }
        .map-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
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
            color: var(--navy);
            transition: background 0.15s;
        }
        .map-suggestion-item:last-child { border-bottom: none; }
        .map-suggestion-item:hover, .map-suggestion-item:focus {
            background: #FFF1F2;
            color: var(--primary);
            outline: none;
        }
        .map-selected-bar {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 14px;
            margin-top: 12px;
            font-size: 0.86rem;
            line-height: 1.4;
        }
        .map-selected-label {
            font-weight: 700;
            color: var(--navy);
            display: block;
            margin-bottom: 2px;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .map-selected-value {
            color: #334155;
            font-weight: 600;
            word-break: break-word;
        }
        .map-provider-tag {
            font-size: 0.72rem;
            padding: 2px 7px;
            border-radius: 6px;
            background: #E2E8F0;
            color: #475569;
            font-weight: 600;
        }

        /* Responsive Breakpoints */
        @media (max-width: 640px) {
            .row-2 { grid-template-columns: 1fr; }
            .form-card { padding: 22px 16px; }
            .map-modal-card { padding: 18px 14px; }
            .map-canvas-wrap { height: 260px; }
        }
        @media (max-width: 420px) {
            .map-search-row { flex-wrap: wrap; }
            .map-search-row .btn-secondary { flex: 1 1 calc(50% - 4px); justify-content: center; }
            .otp-input { width: 100%; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"
                 style="height:32px;width:32px;border-radius:8px;object-fit:cover;"
                 onerror="this.style.display='none';">
            Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </header>

    <main class="main-container">
        <div class="info-banner">
            <h1>Create your Fight D Fear account</h1>
            <p>Registration collects only what you need to sign in safely. Email OTP verification is required to verify identity and enable emergency safety alerts.</p>
        </div>

        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="alert alert-error" id="serverError" role="alert"><i class="bi bi-exclamation-circle me-1"></i> ${error}</div>
            </c:if>
            <div class="alert alert-error" id="formError" role="alert" style="display:none;"></div>

            <form action="${pageContext.request.contextPath}/users/register" method="post" id="userRegisterForm" novalidate>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                <!-- Full Name -->
                <div class="form-group">
                    <label for="fullName">Full name <span class="req-star">*</span></label>
                    <input type="text" name="fullName" id="fullName" class="form-input" required
                           autocomplete="name" minlength="2" maxlength="70" placeholder="e.g. Priya Sharma"
                           spellcheck="false">
                    <div class="field-error" id="fullNameError" role="alert"></div>
                </div>

                <!-- Email Address with OTP -->
                <div class="form-group">
                    <label for="email">Email Address <span class="req-star">*</span></label>
                    <input type="email" name="email" id="email" class="form-input" required
                           autocomplete="email" maxlength="100" placeholder="name@example.com" spellcheck="false">
                    <div class="field-error" id="emailError" role="alert"></div>
                    <div class="otp-row">
                        <button type="button" class="btn-secondary" id="btnSendEmailOtp">Send email OTP</button>
                    </div>
                    <div class="otp-row">
                        <input type="text" id="emailOtp" name="emailOtp" class="form-input otp-input"
                               placeholder="6-digit OTP" maxlength="6" minlength="6" pattern="[0-9]{6}"
                               inputmode="numeric" autocomplete="one-time-code" aria-label="6-digit email OTP">
                        <button type="button" class="btn-secondary" id="btnVerifyEmailOtp">Verify</button>
                        <span class="otp-badge" id="emailOtpOk"><i class="bi bi-check-circle-fill"></i> Verified</span>
                    </div>
                    <div class="otp-status info" id="emailOtpStatus"></div>
                    <div class="hint"><i class="bi bi-info-circle me-1"></i> Private login key used to authenticate account, verify identity, and send critical emergency alerts.</div>
                </div>

                <!-- Phone Number -->
                <div class="form-group">
                    <label for="phoneNumber">Phone Number (10 digits) <span class="req-star">*</span></label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input" required
                           maxlength="10" pattern="\d{10}" inputmode="numeric" placeholder="e.g. 9876543210"
                           autocomplete="tel-national">
                    <div class="field-error" id="phoneNumberError" role="alert"></div>
                    <div id="phoneOtpSection" style="display:none;">
                        <div class="otp-row">
                            <button type="button" class="btn-secondary" id="btnSendPhoneOtp">Send phone OTP</button>
                        </div>
                        <div class="otp-row">
                            <input type="text" id="phoneOtp" class="form-input otp-input"
                                   placeholder="6-digit OTP" maxlength="6" minlength="6" pattern="[0-9]{6}"
                                   inputmode="numeric" autocomplete="one-time-code" aria-label="6-digit phone OTP">
                            <button type="button" class="btn-secondary" id="btnVerifyPhoneOtp">Verify</button>
                            <span class="otp-badge" id="phoneOtpOk"><i class="bi bi-check-circle-fill"></i> Verified</span>
                        </div>
                        <div class="otp-status info" id="phoneOtpStatus"></div>
                    </div>
                    <div class="hint" id="phoneOtpHint"><i class="bi bi-info-circle me-1"></i> Enter your 10-digit mobile number — SMS OTP will be requested when enabled on the server.</div>
                </div>

                <!-- City / Location & Gender -->
                <div class="row-2">
                    <div class="form-group">
                        <label for="city">City / Location <span class="req-star">*</span></label>
                        <input type="text" name="city" id="city" class="form-input" required minlength="2" maxlength="150"
                               placeholder="e.g. Mumbai, New Delhi">
                        <button type="button" class="btn-select-map" id="btnOpenMapPicker" aria-haspopup="dialog" aria-controls="mapPickerModal">
                            <i class="bi bi-geo-alt-fill" aria-hidden="true"></i> Select from Map
                        </button>
                        <div class="field-error" id="cityError" role="alert"></div>
                        <div class="hint"><i class="bi bi-info-circle me-1"></i> Helps identify proximity self-defense centers &amp; safe route overlays.</div>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender <span class="req-star">*</span></label>
                        <select name="gender" id="gender" class="form-select" required>
                            <option value="" disabled selected>Select gender</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                        <div class="field-error" id="genderError" role="alert"></div>
                        <div class="hint"><i class="bi bi-info-circle me-1"></i> Fight D Fear is a women-only platform. Gender is required for safety features.</div>
                    </div>
                </div>

                <!-- Date of Birth -->
                <div class="form-group">
                    <label for="dob">Date of birth (optional)</label>
                    <input type="date" name="dob" id="dob" class="form-input"
                           max="<%= java.time.LocalDate.now() %>">
                    <div class="field-error" id="dobError" role="alert"></div>
                    <div class="hint"><i class="bi bi-info-circle me-1"></i> Used optionally to verify safety cohorts.</div>
                </div>

                <!-- Emergency Contact Details -->
                <div class="form-section-divider">
                    <h2 class="form-section-title"><i class="bi bi-shield-fill-plus" style="color:var(--primary);" aria-hidden="true"></i> Emergency Contact Details</h2>
                    <p class="form-section-subtitle">Designated contacts to receive your live location and emergency alerts if you tap SOS or are in danger.</p>
                </div>

                <!-- Emergency Contact Name -->
                <div class="form-group">
                    <label for="emergencyContactName">Emergency Contact Name <span class="req-star">*</span></label>
                    <input type="text" name="emergencyContactName" id="emergencyContactName" class="form-input" required
                           minlength="2" maxlength="70" placeholder="e.g. Ananya Sen" autocomplete="off" spellcheck="false"
                           value="${param.emergencyContactName}">
                    <div class="field-error" id="emergencyContactNameError" role="alert"></div>
                </div>

                <!-- Emergency Contact Phone Number -->
                <div class="form-group">
                    <label for="emergencyContactPhone">Emergency Contact Phone Number <span class="req-star">*</span></label>
                    <input type="tel" name="emergencyContactPhone" id="emergencyContactPhone" class="form-input" required
                           maxlength="10" pattern="\d{10}" inputmode="numeric" placeholder="e.g. 9876543210"
                           autocomplete="off" value="${param.emergencyContactPhone}">
                    <div class="field-error" id="emergencyContactPhoneError" role="alert"></div>
                </div>

                <!-- Emergency Contact Email -->
                <div class="form-group">
                    <label for="emergencyContactEmail">Emergency Contact Email <span class="req-star">*</span></label>
                    <input type="email" name="emergencyContactEmail" id="emergencyContactEmail" class="form-input" required
                           maxlength="100" placeholder="e.g. contact@example.com" autocomplete="off" spellcheck="false"
                           value="${param.emergencyContactEmail}">
                    <div class="field-error" id="emergencyContactEmailError" role="alert"></div>
                </div>

                <!-- Emergency WhatsApp Number -->
                <div class="form-group">
                    <label for="whatsappNumber">Emergency WhatsApp Number <span class="req-star">*</span></label>
                    <input type="tel" name="whatsappNumber" id="whatsappNumber" class="form-input" required
                           maxlength="20" placeholder="e.g. +91 9876543210" autocomplete="tel"
                           value="${param.whatsappNumber}">
                    <div class="field-error" id="whatsappNumberError" role="alert"></div>
                    <div class="hint"><i class="bi bi-whatsapp text-success me-1"></i> Required with country code (e.g. +91) to share your live location when you are in danger or trigger SOS.</div>
                </div>

                <!-- Password and Confirm Password -->
                <div class="row-2">
                    <div class="form-group">
                        <label for="password">Password <span class="req-star">*</span></label>
                        <div class="password-field">
                            <input type="password" name="password" id="password" class="form-input" required
                                   minlength="6" maxlength="64" autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="password"
                                    aria-label="Show password" title="Show password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div class="field-error" id="passwordError" role="alert"></div>
                        <div class="hint">Min 6 characters with a number and special character (!@#$%^&amp;*)</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm password <span class="req-star">*</span></label>
                        <div class="password-field">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" required
                                   minlength="6" maxlength="64" autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="confirmPassword"
                                    aria-label="Show confirm password" title="Show confirm password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div class="field-error" id="confirmPasswordError" role="alert"></div>
                    </div>
                </div>

                <!-- Terms & Conditions Box -->
                <div class="terms-box">
                    <div style="display:flex; align-items:flex-start; gap:10px;">
                        <input type="checkbox" name="acceptedTerms" id="acceptedTerms" value="true" required
                               style="width:18px; height:18px; accent-color:var(--primary); cursor:pointer; margin-top:2px;">
                        <label for="acceptedTerms" style="font-size:0.88rem; color:var(--navy); font-weight:500; cursor:pointer; line-height:1.45; margin:0;">
                            I have read and agree to the 
                            <a href="javascript:void(0)" id="btnOpenTermsModal" style="color:var(--primary); font-weight:700; text-decoration:underline;">
                                Terms &amp; Conditions
                            </a>
                            and <a href="javascript:void(0)" id="btnOpenPrivacyModal" style="color:var(--primary); font-weight:700; text-decoration:underline;">Privacy Policy</a> <span class="req-star">*</span>
                        </label>
                    </div>
                    <div class="field-error" id="acceptedTermsError" role="alert" style="margin-top:6px; padding-left:28px;"></div>
                    <div id="termsCheckBadge" style="display:none; font-size:0.8rem; color:var(--success); font-weight:700; margin-top:6px; padding-left:28px;">
                        <i class="bi bi-check-circle-fill"></i> Terms accepted &amp; verified
                    </div>
                </div>

                <button type="submit" class="btn-primary" id="btnSubmit" disabled>Create account</button>
                <p class="submit-hint" id="submitHint">Verify your email OTP to enable account creation.</p>
            </form>

            <p class="footer-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        </div>
    </main>

    <!-- Map Picker Modal -->
    <div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle" style="display:none;">
        <div class="map-modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-geo-alt-fill"></i></div>
                <div style="flex: 1;">
                    <h3 id="mapModalTitle">Select Location</h3>
                    <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Search address or click on map to set your location</p>
                </div>
                <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close location picker">&times;</button>
            </div>
            <div class="map-search-row">
                <div style="position: relative; flex: 1;">
                    <input type="text" id="mapSearchInput" class="form-input" placeholder="Search city, area, or landmark..." autocomplete="off">
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
                    <span class="map-selected-label">Chosen Location</span>
                    <span class="map-provider-tag" id="mapProviderBadge">Interactive Map</span>
                </div>
                <div class="map-selected-value" id="mapSelectedAddress">Click on the map or search to choose your city/location</div>
            </div>
            <div class="modal-actions" style="margin-top: 14px;">
                <button type="button" class="btn-modal-cancel" id="btnCancelMap">Cancel</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check2-circle"></i> Use This Location
                </button>
            </div>
        </div>
    </div>

    <!-- Confirmation / Preview Modal -->
    <div id="confirmModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="confirmModalTitle" style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-shield-check"></i></div>
                <div>
                    <h3 id="confirmModalTitle">Confirm Details</h3>
                    <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Please cross-check your credentials before creating account</p>
                </div>
            </div>
            <div class="modal-body">
                <div class="review-row"><span class="label">Full Name:</span><span class="value" id="revFullName">—</span></div>
                <div class="review-row"><span class="label">Email Address:</span><span class="value" id="revEmail">—</span></div>
                <div class="review-row"><span class="label">Mobile Number:</span><span class="value" id="revPhone">—</span></div>
                <div class="review-row"><span class="label">City / Location:</span><span class="value" id="revCity">—</span></div>
                <div class="review-row"><span class="label">Date of Birth:</span><span class="value" id="revDob">—</span></div>
                <div class="review-row"><span class="label">Gender:</span><span class="value" id="revGender">—</span></div>
                <div class="review-row"><span class="label">Emergency Contact:</span><span class="value" id="revEmergencyName">—</span></div>
                <div class="review-row"><span class="label">Emergency Phone:</span><span class="value" id="revEmergencyPhone">—</span></div>
                <div class="review-row"><span class="label">Emergency Email:</span><span class="value" id="revEmergencyEmail">—</span></div>
                <div class="review-row"><span class="label">Emergency WhatsApp:</span><span class="value" id="revWhatsappNumber">—</span></div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="btnConfirmBack">Back / Edit</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmRegister">
                    Confirm &amp; Register <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Terms & Conditions Modal -->
    <div id="termsModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="termsModalTitle" style="display:none;">
        <div class="modal-card" style="max-width: 580px; max-height: 85vh; display: flex; flex-direction: column;">
            <div class="modal-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 14px; margin-bottom: 14px;">
                <div class="icon-wrap"><i class="bi bi-journal-check"></i></div>
                <div style="flex: 1;">
                    <h3 id="termsModalTitle">Terms &amp; Conditions</h3>
                    <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Fight D Fear — Women Community &amp; Safety Platform</p>
                </div>
                <button type="button" id="btnCloseTermsModal" class="btn-close-modal" aria-label="Close modal">&times;</button>
            </div>
            <div class="modal-body" id="termsModalContent" style="overflow-y: auto; max-height: 48vh; font-size: 0.88rem; line-height: 1.6; color: var(--navy); background: #FFF; padding: 14px 18px; border: 1px solid var(--border-color); border-radius: 12px;">
                <div id="termsTextSection">
                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">1. Purpose &amp; Women-Centric Community</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Fight D Fear is an empowerment, health, and personal safety ecosystem built for women. By registering, you commit to upholding the values of mutual respect, trust, empathy, and integrity within our community.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">2. Emergency SOS &amp; Location Sharing</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">The emergency SOS features and real-time tracking are designed for crisis intervention and personal defense. Your coordinates are securely transmitted solely to designated emergency contacts, verified buddies, or responding emergency agencies during active SOS events.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">3. Identity Verification &amp; Account Protection</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Users must provide accurate information during registration. Authentication keys and one-time passwords (OTP) must not be transferred or shared. Any impersonation or fraudulent behavior results in immediate account suspension.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">4. Privacy &amp; Data Security</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">We implement end-to-end industry-standard encryption to protect your personal details, wellness records, and contacts. Your data is never sold to third-party advertisers.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">5. Zero-Tolerance Safety Policy</h4>
                    <p style="margin-bottom:0; color:var(--text-gray);">Any harassment, stalking, hate speech, or abuse targeted at any member or partner will result in permanent account termination and potential reporting to law enforcement authorities.</p>
                </div>
            </div>
            <div class="modal-actions" style="margin-top: 16px; padding-top: 12px; border-top: 1px solid var(--border-color);">
                <button type="button" class="btn-modal-cancel" id="btnDismissTerms">Close</button>
                <button type="button" class="btn-modal-confirm" id="btnAcceptTermsModal" style="background:var(--success);">
                    <i class="bi bi-check-lg"></i> I Read &amp; Agree (Accept)
                </button>
            </div>
        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

    <!-- Optional Google Maps JS API (loaded if key is configured) -->
    <c:if test="${not empty googleMapsApiKey}">
        <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=places" async defer></script>
    </c:if>

<script>
(function () {
    'use strict';
    var ctx = '${pageContext.request.contextPath}';
    var emailVerified = false;
    var phoneVerified = true;
    var phoneOtpRequired = false;
    var phoneOtpSending = false;
    var phoneAutoSendTimer = null;
    var lastAutoSentPhone = '';
    var isSubmitting = false;
    var fetchOpts = { credentials: 'same-origin' };

    // Map Picker State
    var mapInitialized = false;
    var currentMap = null;
    var currentMarker = null;
    var selectedLocationText = '';
    var googleMapsAvailable = false;

    // Listen for Google Maps Authentication failure
    window.gm_authFailure = function() {
        console.warn('[MapPicker] Google Maps authentication failed. Using OpenStreetMap fallback.');
        googleMapsAvailable = false;
        var badge = document.getElementById('mapProviderBadge');
        if (badge) {
            badge.textContent = 'OpenStreetMap';
        }
    };

    // -------------------------------------------------------------
    // Inline Validation Helpers
    // -------------------------------------------------------------
    function setFieldError(fieldId, errorMsg) {
        var input = document.getElementById(fieldId);
        var errEl = document.getElementById(fieldId + 'Error');
        if (!errEl) return;
        if (errorMsg) {
            errEl.textContent = errorMsg;
            errEl.classList.add('show');
            if (input) {
                input.classList.add('is-invalid');
                input.setAttribute('aria-invalid', 'true');
            }
        } else {
            errEl.textContent = '';
            errEl.classList.remove('show');
            if (input) {
                input.classList.remove('is-invalid');
                input.removeAttribute('aria-invalid');
            }
        }
    }

    function clearFieldError(fieldId) {
        setFieldError(fieldId, '');
    }

    // Validation rules
    function validateFullName() {
        var val = document.getElementById('fullName').value.trim();
        if (!val) {
            setFieldError('fullName', 'Full name is required.');
            return false;
        }
        if (val.length < 2 || val.length > 70) {
            setFieldError('fullName', 'Full name must be between 2 and 70 characters.');
            return false;
        }
        if (!/^[a-zA-Z\s.'\-]+$/.test(val)) {
            setFieldError('fullName', 'Full name can only contain letters, spaces, hyphens, and dots.');
            return false;
        }
        clearFieldError('fullName');
        return true;
    }

    function validateEmail() {
        var val = document.getElementById('email').value.trim();
        if (!val) {
            setFieldError('email', 'Email address is required.');
            return false;
        }
        if (val.length > 100) {
            setFieldError('email', 'Email address must not exceed 100 characters.');
            return false;
        }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(val)) {
            setFieldError('email', 'Please enter a valid email address (e.g. name@example.com).');
            return false;
        }
        clearFieldError('email');
        return true;
    }

    function validatePhoneNumber() {
        var val = document.getElementById('phoneNumber').value.trim();
        if (!val) {
            setFieldError('phoneNumber', 'Phone number is required.');
            return false;
        }
        if (!/^\d{10}$/.test(val)) {
            setFieldError('phoneNumber', 'Phone number must be exactly 10 digits.');
            return false;
        }
        if (/^(\d)\1{9}$/.test(val)) {
            setFieldError('phoneNumber', 'Please enter a valid 10-digit mobile number.');
            return false;
        }
        clearFieldError('phoneNumber');
        return true;
    }

    function validateCity() {
        var val = document.getElementById('city').value.trim();
        if (!val) {
            setFieldError('city', 'City / Location is required.');
            return false;
        }
        if (val.length < 2 || val.length > 150) {
            setFieldError('city', 'City / Location must be between 2 and 150 characters.');
            return false;
        }
        clearFieldError('city');
        return true;
    }

    function validateGender() {
        var val = document.getElementById('gender').value.trim();
        if (!val) {
            setFieldError('gender', 'Please select your gender. Fight D Fear is a women-only platform.');
            return false;
        }
        clearFieldError('gender');
        return true;
    }

    function validateDob() {
        var val = document.getElementById('dob').value.trim();
        if (!val) {
            clearFieldError('dob');
            return true; // Optional field
        }
        var birthDate = new Date(val);
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        if (isNaN(birthDate.getTime())) {
            setFieldError('dob', 'Date of birth must be a valid date.');
            return false;
        }
        if (birthDate > today) {
            setFieldError('dob', 'Date of birth cannot be in the future.');
            return false;
        }
        if (birthDate.getFullYear() < 1900) {
            setFieldError('dob', 'Please enter a valid year of birth (after 1900).');
            return false;
        }
        clearFieldError('dob');
        return true;
    }

    function validatePassword() {
        var val = document.getElementById('password').value;
        if (!val) {
            setFieldError('password', 'Password is required.');
            return false;
        }
        if (val.length < 6) {
            setFieldError('password', 'Password must be at least 6 characters long.');
            return false;
        }
        if (val.length > 64) {
            setFieldError('password', 'Password must not exceed 64 characters.');
            return false;
        }
        if (!/^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/.test(val)) {
            setFieldError('password', 'Password must include at least one number and one special character (!@#$%^&*).');
            return false;
        }
        clearFieldError('password');
        // Also revalidate confirmPassword if already typed
        var confirmVal = document.getElementById('confirmPassword').value;
        if (confirmVal) {
            validateConfirmPassword();
        }
        return true;
    }

    function validateConfirmPassword() {
        var pass = document.getElementById('password').value;
        var confirm = document.getElementById('confirmPassword').value;
        if (!confirm) {
            setFieldError('confirmPassword', 'Please confirm your password.');
            return false;
        }
        if (pass !== confirm) {
            setFieldError('confirmPassword', 'Passwords do not match.');
            return false;
        }
        clearFieldError('confirmPassword');
        return true;
    }

    function validateTerms() {
        var chk = document.getElementById('acceptedTerms');
        if (!chk.checked) {
            setFieldError('acceptedTerms', 'You must accept the Terms & Conditions and Privacy Policy to register.');
            return false;
        }
        clearFieldError('acceptedTerms');
        return true;
    }

    function validateWhatsappNumber() {
        var input = document.getElementById('whatsappNumber');
        var val = input ? input.value.trim() : '';
        if (!val) {
            setFieldError('whatsappNumber', 'WhatsApp number is required.');
            return false;
        }
        if (!/^\+?[0-9\s\-().]{8,25}$/.test(val)) {
            setFieldError('whatsappNumber', 'WhatsApp number can only contain digits, spaces, and an optional leading "+".');
            return false;
        }
        var digitsOnly = val.replace(/\D/g, '');
        if (digitsOnly.length < 8 || digitsOnly.length > 15) {
            setFieldError('whatsappNumber', 'WhatsApp number must contain between 8 and 15 digits with country code.');
            return false;
        }
        if (/^(\d)\1{7,}$/.test(digitsOnly)) {
            setFieldError('whatsappNumber', 'Please enter a valid WhatsApp number with country code.');
            return false;
        }
        clearFieldError('whatsappNumber');
        return true;
    }

    function validateEmergencyContactName() {
        var input = document.getElementById('emergencyContactName');
        var val = input ? input.value.trim() : '';
        if (!val) {
            setFieldError('emergencyContactName', 'Emergency contact name is required.');
            return false;
        }
        if (val.length < 2 || val.length > 70) {
            setFieldError('emergencyContactName', 'Emergency contact name must be between 2 and 70 characters.');
            return false;
        }
        if (!/^[a-zA-Z\s.'\-]+$/.test(val)) {
            setFieldError('emergencyContactName', 'Emergency contact name can only contain letters and spaces.');
            return false;
        }
        clearFieldError('emergencyContactName');
        return true;
    }

    function validateEmergencyContactPhone() {
        var input = document.getElementById('emergencyContactPhone');
        var val = input ? input.value.trim() : '';
        if (!val) {
            setFieldError('emergencyContactPhone', 'Emergency contact phone number is required.');
            return false;
        }
        if (!/^\d{10}$/.test(val)) {
            setFieldError('emergencyContactPhone', 'Emergency contact phone number must be exactly 10 digits.');
            return false;
        }
        if (/^(\d)\1{9}$/.test(val)) {
            setFieldError('emergencyContactPhone', 'Please enter a valid 10-digit emergency contact phone number.');
            return false;
        }
        clearFieldError('emergencyContactPhone');
        return true;
    }

    function validateEmergencyContactEmail() {
        var input = document.getElementById('emergencyContactEmail');
        var val = input ? input.value.trim() : '';
        if (!val) {
            setFieldError('emergencyContactEmail', 'Emergency contact email is required.');
            return false;
        }
        if (val.length > 100) {
            setFieldError('emergencyContactEmail', 'Emergency contact email must not exceed 100 characters.');
            return false;
        }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(val)) {
            setFieldError('emergencyContactEmail', 'Please enter a valid emergency contact email (e.g. name@example.com).');
            return false;
        }
        clearFieldError('emergencyContactEmail');
        return true;
    }

    // Attach immediate validation & error removal on user input
    document.getElementById('fullName').addEventListener('input', function() {
        if (this.value.trim().length >= 2) validateFullName();
    });
    document.getElementById('fullName').addEventListener('blur', validateFullName);

    document.getElementById('email').addEventListener('input', function() {
        emailVerified = false;
        document.getElementById('emailOtpOk').classList.remove('show');
        setStatus('emailOtpStatus', '', '');
        try { sessionStorage.removeItem('regEmailVerified'); } catch (e) {}
        refreshSubmit();
        if (this.value.includes('@') && this.value.includes('.')) validateEmail();
    });
    document.getElementById('email').addEventListener('blur', validateEmail);

    document.getElementById('phoneNumber').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
        phoneVerified = false;
        document.getElementById('phoneOtpOk').classList.remove('show');
        setStatus('phoneOtpStatus', '', '');
        lastAutoSentPhone = '';
        refreshSubmit();
        if (this.value.length === 10) {
            validatePhoneNumber();
            if (phoneOtpRequired) {
                clearTimeout(phoneAutoSendTimer);
                phoneAutoSendTimer = setTimeout(function () {
                    sendPhoneOtp(true);
                }, 400);
            }
        }
    });
    document.getElementById('phoneNumber').addEventListener('blur', validatePhoneNumber);

    document.getElementById('whatsappNumber').addEventListener('input', function() {
        if (this.value.trim().length >= 8 || this.classList.contains('is-invalid')) {
            validateWhatsappNumber();
        }
    });
    document.getElementById('whatsappNumber').addEventListener('blur', validateWhatsappNumber);

    document.getElementById('city').addEventListener('input', function() {
        if (this.value.trim().length >= 2) validateCity();
    });
    document.getElementById('city').addEventListener('blur', validateCity);

    document.getElementById('gender').addEventListener('change', validateGender);
    document.getElementById('dob').addEventListener('input', validateDob);
    document.getElementById('dob').addEventListener('blur', validateDob);

    document.getElementById('password').addEventListener('input', function() {
        if (this.value.length >= 6) validatePassword();
    });
    document.getElementById('password').addEventListener('blur', validatePassword);

    document.getElementById('confirmPassword').addEventListener('input', function() {
        if (this.value.length >= 1) validateConfirmPassword();
    });
    document.getElementById('confirmPassword').addEventListener('blur', validateConfirmPassword);

    document.getElementById('emergencyContactName').addEventListener('input', function() {
        if (this.value.trim().length >= 2 || this.classList.contains('is-invalid')) {
            validateEmergencyContactName();
        }
    });
    document.getElementById('emergencyContactName').addEventListener('blur', validateEmergencyContactName);

    document.getElementById('emergencyContactPhone').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
        if (this.value.length === 10 || this.classList.contains('is-invalid')) {
            validateEmergencyContactPhone();
        }
    });
    document.getElementById('emergencyContactPhone').addEventListener('blur', validateEmergencyContactPhone);

    document.getElementById('emergencyContactEmail').addEventListener('input', function() {
        if ((this.value.includes('@') && this.value.includes('.')) || this.classList.contains('is-invalid')) {
            validateEmergencyContactEmail();
        }
    });
    document.getElementById('emergencyContactEmail').addEventListener('blur', validateEmergencyContactEmail);

    // -------------------------------------------------------------
    // OTP & Verification Logic
    // -------------------------------------------------------------
    function markEmailVerified(email) {
        emailVerified = true;
        document.getElementById('emailOtpOk').classList.add('show');
        setStatus('emailOtpStatus', 'Email verified successfully', 'ok');
        clearFieldError('email');
        try {
            sessionStorage.setItem('regEmailVerified', email.toLowerCase());
        } catch (e) {}
        refreshSubmit();
    }

    function restoreEmailVerified() {
        try {
            var saved = sessionStorage.getItem('regEmailVerified');
            var current = document.getElementById('email').value.trim().toLowerCase();
            if (saved && current && saved === current) {
                markEmailVerified(current);
            }
        } catch (e) {}
    }

    function setStatus(id, text, kind) {
        var el = document.getElementById(id);
        if (!el) return;
        el.textContent = text || '';
        el.className = 'otp-status' + (kind ? ' ' + kind : '');
    }

    function refreshSubmit() {
        var ready = emailVerified && document.getElementById('acceptedTerms').checked;
        if (phoneOtpRequired) {
            ready = ready && phoneVerified;
        }
        document.getElementById('btnSubmit').disabled = !ready;

        var hint = document.getElementById('submitHint');
        if (ready) {
            hint.textContent = 'All set — click Create account to finish registration.';
        } else if (!emailVerified) {
            hint.textContent = 'Verify your email OTP to enable account creation.';
        } else if (phoneOtpRequired && !phoneVerified) {
            hint.textContent = 'Verify your phone OTP to enable account creation.';
        } else if (!document.getElementById('acceptedTerms').checked) {
            hint.textContent = 'Accept the Terms & Conditions to continue.';
        } else {
            hint.textContent = 'Complete verification steps above.';
        }
    }

    function bindOtpInput(id) {
        var el = document.getElementById(id);
        if (!el) return;
        el.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, '').slice(0, 6);
        });
    }

    function isValidOtp(value) {
        return /^\d{6}$/.test(value);
    }

    async function loadPhoneOtpStatus() {
        try {
            var res = await fetch(ctx + '/api/auth/otp/phone-status', Object.assign({}, fetchOpts, {
                headers: { 'Accept': 'application/json' }
            }));
            var data = await res.json();
            phoneOtpRequired = data.available === true;
            var phoneSection = document.getElementById('phoneOtpSection');
            var hint = document.getElementById('phoneOtpHint');
            if (phoneOtpRequired) {
                phoneSection.style.display = '';
                hint.innerHTML = '<i class="bi bi-info-circle me-1"></i> A 6-digit OTP is sent automatically by SMS when you enter a valid 10-digit number.';
                phoneVerified = false;
            } else {
                phoneSection.style.display = 'none';
                hint.innerHTML = '<i class="bi bi-info-circle me-1"></i> Phone number is saved for emergency alerts. SMS verification is optional on this server.';
                phoneVerified = true;
                setStatus('phoneOtpStatus', '', '');
            }
            refreshSubmit();
        } catch (e) {
            phoneOtpRequired = false;
            phoneVerified = true;
            refreshSubmit();
        }
    }

    async function sendPhoneOtp(autoTriggered) {
        var phone = document.getElementById('phoneNumber').value.trim();
        if (!/^\d{10}$/.test(phone)) {
            if (!autoTriggered) setFieldError('phoneNumber', 'Enter a valid 10-digit phone first');
            return;
        }
        if (phoneOtpSending) return;
        if (autoTriggered && phone === lastAutoSentPhone) return;

        phoneOtpSending = true;
        var btn = document.getElementById('btnSendPhoneOtp');
        if (btn) btn.disabled = true;
        setStatus('phoneOtpStatus', autoTriggered ? 'Sending OTP to your phone…' : 'Sending OTP…', 'info');

        try {
            var res = await fetch(ctx + '/api/auth/otp/send-phone', Object.assign({}, fetchOpts, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ phoneNumber: phone })
            }));
            var data = await res.json();
            if (data.success) {
                lastAutoSentPhone = phone;
                setStatus('phoneOtpStatus', data.message || 'OTP sent to +' + phone, 'ok');
                var phoneOtpInput = document.getElementById('phoneOtp');
                if (phoneOtpInput) phoneOtpInput.focus();
            } else {
                setStatus('phoneOtpStatus', data.error || 'Failed to send OTP', 'err');
            }
        } catch (e) {
            setStatus('phoneOtpStatus', 'Network error sending OTP', 'err');
        } finally {
            phoneOtpSending = false;
            if (btn) btn.disabled = false;
        }
    }

    bindOtpInput('emailOtp');
    bindOtpInput('phoneOtp');
    loadPhoneOtpStatus();
    restoreEmailVerified();

    // -------------------------------------------------------------
    // Terms & Conditions Modal
    // -------------------------------------------------------------
    var termsModal = document.getElementById('termsModal');
    var btnOpenTerms = document.getElementById('btnOpenTermsModal');
    var btnOpenPrivacy = document.getElementById('btnOpenPrivacyModal');
    var btnCloseTerms = document.getElementById('btnCloseTermsModal');
    var btnDismissTerms = document.getElementById('btnDismissTerms');
    var btnAcceptTerms = document.getElementById('btnAcceptTermsModal');
    var chkTerms = document.getElementById('acceptedTerms');
    var badgeTerms = document.getElementById('termsCheckBadge');

    function syncTermsBadge() {
        if (chkTerms.checked) {
            badgeTerms.style.display = 'block';
            clearFieldError('acceptedTerms');
        } else {
            badgeTerms.style.display = 'none';
        }
        refreshSubmit();
    }

    if (btnOpenTerms) {
        btnOpenTerms.addEventListener('click', function (e) {
            e.preventDefault();
            document.getElementById('termsModalTitle').textContent = 'Terms & Conditions';
            termsModal.style.display = 'flex';
        });
    }
    if (btnOpenPrivacy) {
        btnOpenPrivacy.addEventListener('click', function (e) {
            e.preventDefault();
            document.getElementById('termsModalTitle').textContent = 'Privacy Policy & Data Security';
            termsModal.style.display = 'flex';
        });
    }
    function closeTermsModal() {
        termsModal.style.display = 'none';
    }
    if (btnCloseTerms) btnCloseTerms.addEventListener('click', closeTermsModal);
    if (btnDismissTerms) btnDismissTerms.addEventListener('click', closeTermsModal);

    if (btnAcceptTerms) {
        btnAcceptTerms.addEventListener('click', function () {
            chkTerms.checked = true;
            syncTermsBadge();
            closeTermsModal();
        });
    }

    chkTerms.addEventListener('change', syncTermsBadge);

    // -------------------------------------------------------------
    // Send & Verify Email OTP
    // -------------------------------------------------------------
    document.getElementById('btnSendEmailOtp').addEventListener('click', async function () {
        if (!validateEmail()) {
            document.getElementById('email').focus();
            return;
        }
        var email = document.getElementById('email').value.trim().toLowerCase();
        this.disabled = true;
        setStatus('emailOtpStatus', 'Sending OTP to ' + email + '…', 'info');
        try {
            var res = await fetch(ctx + '/api/auth/otp/send-email', Object.assign({}, fetchOpts, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ email: email })
            }));
            var data = await res.json();
            if (data.success) {
                setStatus('emailOtpStatus', data.message || 'OTP sent to your email. Check inbox & spam.', 'ok');
                document.getElementById('emailOtp').focus();
            } else {
                setStatus('emailOtpStatus', data.error || 'Failed to send OTP', 'err');
                setFieldError('email', data.error || 'Failed to send OTP');
            }
        } catch (e) {
            setStatus('emailOtpStatus', 'Network error sending OTP', 'err');
        } finally {
            this.disabled = false;
        }
    });

    document.getElementById('btnVerifyEmailOtp').addEventListener('click', async function () {
        var email = document.getElementById('email').value.trim().toLowerCase();
        var otp = document.getElementById('emailOtp').value.trim();
        if (!validateEmail()) {
            document.getElementById('email').focus();
            return;
        }
        if (!isValidOtp(otp)) {
            setStatus('emailOtpStatus', 'Please enter the 6-digit OTP code', 'err');
            document.getElementById('emailOtp').focus();
            return;
        }
        this.disabled = true;
        setStatus('emailOtpStatus', 'Verifying code…', 'info');
        try {
            var res = await fetch(ctx + '/api/auth/otp/verify-email', Object.assign({}, fetchOpts, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ email: email, otp: otp })
            }));
            var data = await res.json();
            if (data.success) {
                markEmailVerified(email);
            } else {
                setStatus('emailOtpStatus', data.error || 'Invalid or expired OTP code', 'err');
            }
        } catch (e) {
            setStatus('emailOtpStatus', 'Network error verifying OTP', 'err');
        } finally {
            this.disabled = false;
        }
    });

    // Send & Verify Phone OTP
    var btnSendPhone = document.getElementById('btnSendPhoneOtp');
    if (btnSendPhone) {
        btnSendPhone.addEventListener('click', function () {
            sendPhoneOtp(false);
        });
    }

    var btnVerifyPhone = document.getElementById('btnVerifyPhoneOtp');
    if (btnVerifyPhone) {
        btnVerifyPhone.addEventListener('click', async function () {
            var phone = document.getElementById('phoneNumber').value.trim();
            var otp = document.getElementById('phoneOtp').value.trim();
            if (!validatePhoneNumber()) {
                document.getElementById('phoneNumber').focus();
                return;
            }
            if (!isValidOtp(otp)) {
                setStatus('phoneOtpStatus', 'Please enter the 6-digit OTP code', 'err');
                document.getElementById('phoneOtp').focus();
                return;
            }
            this.disabled = true;
            try {
                var res = await fetch(ctx + '/api/auth/otp/verify-phone', Object.assign({}, fetchOpts, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ phoneNumber: phone, otp: otp })
                }));
                var data = await res.json();
                if (data.success) {
                    phoneVerified = true;
                    document.getElementById('phoneOtpOk').classList.add('show');
                    setStatus('phoneOtpStatus', 'Phone verified successfully', 'ok');
                    refreshSubmit();
                } else {
                    setStatus('phoneOtpStatus', data.error || 'Invalid or expired OTP', 'err');
                }
            } catch (e) {
                setStatus('phoneOtpStatus', 'Network error verifying OTP', 'err');
            } finally {
                this.disabled = false;
            }
        });
    }

    function showFormError(msg) {
        var el = document.getElementById('formError');
        if (!el) return;
        el.style.display = msg ? 'block' : 'none';
        el.innerHTML = msg ? '<i class="bi bi-exclamation-circle me-1"></i> ' + msg : '';
        if (msg) el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // -------------------------------------------------------------
    // Map Picker Implementation (Leaflet + Google Maps fallback)
    // -------------------------------------------------------------
    var mapPickerModal = document.getElementById('mapPickerModal');
    var btnOpenMapPicker = document.getElementById('btnOpenMapPicker');
    var btnCloseMapModal = document.getElementById('btnCloseMapModal');
    var btnCancelMap = document.getElementById('btnCancelMap');
    var btnConfirmLocation = document.getElementById('btnConfirmLocation');
    var btnSearchMap = document.getElementById('btnSearchMap');
    var btnLocateMe = document.getElementById('btnLocateMe');
    var mapSearchInput = document.getElementById('mapSearchInput');
    var mapSuggestions = document.getElementById('mapSuggestions');
    var mapSelectedAddressEl = document.getElementById('mapSelectedAddress');
    var mapPickerAlert = document.getElementById('mapPickerAlert');
    var mapProviderBadge = document.getElementById('mapProviderBadge');

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
        selectedLocationText = formattedAddress || '';
        mapSelectedAddressEl.textContent = selectedLocationText || 'Location selected (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')';
        btnConfirmLocation.disabled = !selectedLocationText;
    }

    async function reverseGeocodeCoords(lat, lng) {
        setSelectedLocation('Resolving address…', lat, lng);
        showMapAlert('');
        try {
            var res = await fetch(ctx + '/api/auth/geo/reverse?lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng), Object.assign({}, fetchOpts, {
                headers: { 'Accept': 'application/json' }
            }));
            if (res.ok) {
                var data = await res.json();
                if (data.success && data.address) {
                    setSelectedLocation(data.address, lat, lng);
                    return;
                }
            }
        } catch (e) {
            console.warn('[MapPicker] Reverse geocoding fetch error:', e);
        }
        // Fallback representation if network or reverse geocode fails
        setSelectedLocation('Location (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')', lat, lng);
    }

    function initMapPicker() {
        if (mapInitialized && currentMap) {
            setTimeout(function() {
                if (currentMap.invalidateSize) {
                    currentMap.invalidateSize();
                }
            }, 100);
            return;
        }

        var defaultLat = 19.0760;
        var defaultLng = 72.8777; // Mumbai default

        // Check if existing city field can be searched or geocoded
        var existingCity = document.getElementById('city').value.trim();
        if (existingCity) {
            mapSearchInput.value = existingCity;
        }

        // Initialize Leaflet Map (guaranteed by CSP, robust & lightweight)
        try {
            currentMap = L.map('mapContainer', {
                center: [defaultLat, defaultLng],
                zoom: 12,
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

            mapProviderBadge.textContent = 'Interactive Map';

            currentMarker.on('dragend', function (e) {
                var pos = e.target.getLatLng();
                reverseGeocodeCoords(pos.lat, pos.lng);
            });

            currentMap.on('click', function (e) {
                var lat = e.latlng.lat;
                var lng = e.latlng.lng;
                currentMarker.setLatLng([lat, lng]);
                reverseGeocodeCoords(lat, lng);
            });

            mapInitialized = true;

            setTimeout(function() {
                currentMap.invalidateSize();
                if (existingCity) {
                    executeSearch(existingCity);
                } else {
                    reverseGeocodeCoords(defaultLat, defaultLng);
                }
            }, 150);

        } catch (err) {
            console.error('[MapPicker] Failed to initialize Leaflet map:', err);
            showMapAlert('Map renderer failed to initialize. You can still type your city manually.');
        }
    }

    async function executeSearch(query) {
        if (!query || !query.trim()) return;
        showMapAlert('');
        mapSuggestions.style.display = 'none';

        try {
            var res = await fetch(ctx + '/api/auth/geo/search?q=' + encodeURIComponent(query.trim()), Object.assign({}, fetchOpts, {
                headers: { 'Accept': 'application/json' }
            }));
            if (res.ok) {
                var data = await res.json();
                if (data.success && data.results && data.results.length > 0) {
                    if (data.results.length === 1) {
                        applySearchResult(data.results[0]);
                    } else {
                        renderSuggestions(data.results);
                    }
                    return;
                }
            }
            showMapAlert('No location results found for "' + query + '". Try a different city or area name.');
        } catch (e) {
            showMapAlert('Network error searching location. You can select directly on the map.');
        }
    }

    function renderSuggestions(results) {
        mapSuggestions.innerHTML = '';
        results.forEach(function (item) {
            var div = document.createElement('div');
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
        var lat = item.lat;
        var lng = item.lng;
        currentMap.setView([lat, lng], 14);
        currentMarker.setLatLng([lat, lng]);
        setSelectedLocation(item.address, lat, lng);
    }

    if (btnOpenMapPicker) {
        btnOpenMapPicker.addEventListener('click', function () {
            mapPickerModal.style.display = 'flex';
            initMapPicker();
        });
    }

    function closeMapPicker() {
        mapPickerModal.style.display = 'none';
        mapSuggestions.style.display = 'none';
        showMapAlert('');
    }

    if (btnCloseMapModal) btnCloseMapModal.addEventListener('click', closeMapPicker);
    if (btnCancelMap) btnCancelMap.addEventListener('click', closeMapPicker);

    if (btnSearchMap) {
        btnSearchMap.addEventListener('click', function () {
            executeSearch(mapSearchInput.value);
        });
    }

    mapSearchInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            executeSearch(this.value);
        }
    });

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
                var lat = pos.coords.latitude;
                var lng = pos.coords.longitude;
                if (currentMap && currentMarker) {
                    currentMap.setView([lat, lng], 15);
                    currentMarker.setLatLng([lat, lng]);
                }
                reverseGeocodeCoords(lat, lng);
            }, function (err) {
                btnLocateMe.disabled = false;
                var msg = 'Location access was denied or unavailable. You can search or click on the map to choose your city.';
                if (err.code === err.PERMISSION_DENIED) {
                    msg = 'Location permission was denied. Please select your location on the map or type your city.';
                }
                showMapAlert(msg);
            }, { timeout: 10000, enableHighAccuracy: true });
        });
    }

    if (btnConfirmLocation) {
        btnConfirmLocation.addEventListener('click', function () {
            if (!selectedLocationText) return;
            // Clean up address to a neat city/area representation or formatted string
            var cityInput = document.getElementById('city');
            cityInput.value = selectedLocationText;
            clearFieldError('city');
            closeMapPicker();
        });
    }

    // Close modals on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (mapPickerModal.style.display === 'flex') closeMapPicker();
            if (confirmModal.style.display === 'flex') confirmModal.style.display = 'none';
            if (termsModal.style.display === 'flex') closeTermsModal();
        }
    });

    // -------------------------------------------------------------
    // Form Submission & Confirmation Modal
    // -------------------------------------------------------------
    var confirmModal = document.getElementById('confirmModal');
    var btnConfirmBack = document.getElementById('btnConfirmBack');
    var btnConfirmRegister = document.getElementById('btnConfirmRegister');

    if (btnConfirmBack) {
        btnConfirmBack.addEventListener('click', function () {
            confirmModal.style.display = 'none';
        });
    }

    document.getElementById('userRegisterForm').addEventListener('submit', function (e) {
        e.preventDefault();
        showFormError('');

        // Run validation across every field
        var vName = validateFullName();
        var vEmail = validateEmail();
        var vPhone = validatePhoneNumber();
        var vWhatsapp = validateWhatsappNumber();
        var vCity = validateCity();
        var vGender = validateGender();
        var vDob = validateDob();
        var vEcName = validateEmergencyContactName();
        var vEcPhone = validateEmergencyContactPhone();
        var vEcEmail = validateEmergencyContactEmail();
        var vPass = validatePassword();
        var vConfirm = validateConfirmPassword();
        var vTerms = validateTerms();

        if (!vName || !vEmail || !vPhone || !vWhatsapp || !vCity || !vGender || !vDob || !vEcName || !vEcPhone || !vEcEmail || !vPass || !vConfirm || !vTerms) {
            // Find first invalid input and focus it
            var firstInvalid = document.querySelector('.is-invalid, input:invalid');
            if (firstInvalid) {
                firstInvalid.focus();
                firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            return;
        }

        if (!emailVerified) {
            setFieldError('email', 'Please verify the 6-digit OTP sent to your email first.');
            document.getElementById('emailOtp').focus();
            return;
        }

        if (phoneOtpRequired && !phoneVerified) {
            setFieldError('phoneNumber', 'Please verify your phone number via OTP first.');
            var phoneOtpInput = document.getElementById('phoneOtp');
            if (phoneOtpInput) phoneOtpInput.focus();
            return;
        }

        // Populate Preview Card
        document.getElementById('revFullName').textContent = document.getElementById('fullName').value.trim() || '—';
        document.getElementById('revEmail').textContent = document.getElementById('email').value.trim().toLowerCase() || '—';
        document.getElementById('revPhone').textContent = document.getElementById('phoneNumber').value.trim() || '—';
        document.getElementById('revWhatsappNumber').textContent = document.getElementById('whatsappNumber').value.trim() || '—';
        document.getElementById('revCity').textContent = document.getElementById('city').value.trim() || '—';
        document.getElementById('revDob').textContent = document.getElementById('dob').value.trim() || 'Not specified';
        var genderSelect = document.getElementById('gender');
        var genderText = genderSelect.options[genderSelect.selectedIndex] ? genderSelect.options[genderSelect.selectedIndex].text : '—';
        document.getElementById('revGender').textContent = genderText;
        document.getElementById('revEmergencyName').textContent = document.getElementById('emergencyContactName').value.trim() || '—';
        document.getElementById('revEmergencyPhone').textContent = document.getElementById('emergencyContactPhone').value.trim() || '—';
        document.getElementById('revEmergencyEmail').textContent = document.getElementById('emergencyContactEmail').value.trim().toLowerCase() || '—';

        // Show Confirmation Modal
        confirmModal.style.display = 'flex';
    });

    if (btnConfirmRegister) {
        btnConfirmRegister.addEventListener('click', async function () {
            if (isSubmitting) return;
            isSubmitting = true;

            var pass = document.getElementById('password').value;
            var confirm = document.getElementById('confirmPassword').value;

            btnConfirmRegister.disabled = true;
            btnConfirmRegister.innerHTML = 'Registering… <span class="spinner-border spinner-border-sm ms-1" role="status" aria-hidden="true"></span>';

            var payload = {
                fullName: document.getElementById('fullName').value.trim(),
                email: document.getElementById('email').value.trim().toLowerCase(),
                phoneNumber: document.getElementById('phoneNumber').value.trim(),
                whatsappNumber: document.getElementById('whatsappNumber').value.trim(),
                city: document.getElementById('city').value.trim(),
                dob: document.getElementById('dob').value.trim(),
                gender: document.getElementById('gender').value.trim(),
                emergencyContactName: document.getElementById('emergencyContactName').value.trim(),
                emergencyContactPhone: document.getElementById('emergencyContactPhone').value.trim(),
                emergencyContactEmail: document.getElementById('emergencyContactEmail').value.trim().toLowerCase(),
                password: pass,
                confirmPassword: confirm,
                acceptedTerms: 'true',
                emailOtp: document.getElementById('emailOtp').value.trim()
            };

            try {
                var res = await fetch(ctx + '/api/auth/register-web', Object.assign({}, fetchOpts, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify(payload)
                }));
                var data = await res.json();
                if (data.success && data.redirectUrl) {
                    try { sessionStorage.removeItem('regEmailVerified'); } catch (err) {}
                    window.location.href = data.redirectUrl;
                    return;
                }
                confirmModal.style.display = 'none';
                showFormError(data.error || 'Registration failed. Please try again.');
            } catch (err) {
                confirmModal.style.display = 'none';
                showFormError('Network error. Could not complete registration.');
            } finally {
                isSubmitting = false;
                btnConfirmRegister.disabled = false;
                btnConfirmRegister.innerHTML = 'Confirm &amp; Register <i class="bi bi-check2-circle"></i>';
                refreshSubmit();
            }
        });
    }

    // Password visibility toggle accessibility
    document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var id = btn.getAttribute('data-toggle-password');
            var input = document.getElementById(id);
            if (!input) return;
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            btn.setAttribute('aria-pressed', show ? 'true' : 'false');
            btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            btn.setAttribute('title', show ? 'Hide password' : 'Show password');
            var icon = btn.querySelector('i');
            if (icon) icon.className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
        });
    });
})();
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
