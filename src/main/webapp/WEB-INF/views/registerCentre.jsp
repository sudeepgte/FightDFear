<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join as Self-Defense Trainer — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
            --warning: #C2410C;
            --warning-bg: #FFF7ED;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }

        /* Top Bar */
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

        .header-brand i {
            color: var(--primary);
            font-size: 1.3rem;
        }

        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: color 0.2s;
        }

        .header-links a:hover {
            color: var(--primary);
        }

        /* Main Container */
        .main-container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 28px auto 40px;
            padding: 0 16px;
        }

        /* Info Card */
        .info-banner {
            background: var(--rose-soft);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
            border: 1px solid #FECDD3;
        }

        .info-banner h2 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .info-banner p {
            font-size: 0.9rem;
            color: var(--navy);
            line-height: 1.45;
            margin-bottom: 8px;
        }

        .info-banner .subtext {
            font-size: 0.8rem;
            color: rgba(30, 27, 75, 0.75);
            margin-bottom: 0;
        }

        /* Form Card */
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-input.is-invalid {
            border-color: var(--error) !important;
            background: #FFF5F5 !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.08) !important;
        }

        .error-msg {
            display: none;
            color: var(--error);
            font-size: 0.78rem;
            margin-top: 5px;
            font-weight: 600;
            line-height: 1.35;
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

        /* Password Wrapper */
        .password-field .form-input {
            padding-right: 42px;
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            padding: 4px;
            font-size: 1.1rem;
        }

        .password-toggle-btn:hover {
            color: var(--navy);
        }

        /* OTP Row */
        .otp-row {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .btn-otp {
            padding: 12px 16px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            white-space: nowrap;
            transition: background 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-otp:hover:not(:disabled) {
            background: var(--primary-hover);
        }

        .btn-otp:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            color: #64748B;
        }

        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            color: var(--success);
            font-weight: 700;
            font-size: 0.85rem;
            background: var(--success-bg);
            padding: 6px 10px;
            border-radius: 8px;
            border: 1px solid #BBF7D0;
        }

        /* Password Strength */
        .pass-strength {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 6px;
        }

        .strength-bars {
            display: flex;
            gap: 4px;
            flex: 1;
            height: 4px;
        }

        .strength-bar {
            flex: 1;
            background: #E2E8F0;
            border-radius: 2px;
        }

        .strength-text {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-gray);
        }

        /* Terms Checkbox */
        .terms-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 16px 0 20px;
            font-size: 0.85rem;
            color: var(--navy);
            cursor: pointer;
        }

        .terms-row input[type="checkbox"] {
            margin-top: 2px;
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
        }

        /* Submit Button */
        .btn-submit {
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
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover:not(:disabled) {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-submit:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
        }

        .login-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .login-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
        }

        .login-footer a:hover {
            text-decoration: underline;
        }

        /* Alerts */
        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-error {
            background: var(--error-bg);
            border: 1px solid #FECACA;
            color: var(--error);
        }

        .alert-success {
            background: var(--success-bg);
            border: 1px solid #BBF7D0;
            color: var(--success);
        }

        /* Confirmation Modal Card */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 100;
            padding: 16px;
        }

        .modal-card {
            background: #FFFFFF;
            border-radius: 20px;
            max-width: 460px;
            width: 100%;
            padding: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            animation: popIn 0.2s ease-out;
        }

        @keyframes popIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .modal-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
        }

        .modal-header .icon-wrap {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--rose-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .modal-header h3 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
        }

        .modal-body {
            background: var(--bg-page);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 14px;
            margin-bottom: 20px;
        }

        .review-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed var(--border-color);
            font-size: 0.85rem;
        }

        .review-row:last-child {
            border-bottom: none;
        }

        .review-row .label {
            color: var(--text-gray);
            font-weight: 500;
        }

        .review-row .value {
            color: var(--navy);
            font-weight: 700;
            text-align: right;
        }

        .modal-actions {
            display: flex;
            gap: 10px;
        }

        .btn-modal-cancel {
            flex: 1;
            padding: 12px;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-modal-confirm {
            flex: 1.5;
            padding: 12px;
            background: var(--primary);
            border: none;
            color: #FFFFFF;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
    </style>
</head>
<body>

    <!-- App Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/centres/login">Sign in</a>
        </div>
    </header>

    <!-- Main Container -->
    <main class="main-container">

        <!-- Info Card Matching Mobile -->
        <div class="info-banner">
            <h2>Quick registration</h2>
            <p>For Karate, Taekwondo & self-defence centres. After login, add your martial arts programs and batches.</p>
            <p class="subtext">For Gym, Zumba or wellness coaching, register as Fitness Trainer instead.</p>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <div id="jsAlert" style="display: none;"></div>

            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-circle-fill"></i> ${error}
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                </div>
            </c:if>

            <form id="regForm" action="${pageContext.request.contextPath}/centres/register" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input type="hidden" name="acceptedTerms" value="true">

                <!-- Centre / Trainer Name -->
                <div class="form-group">
                    <label for="name">Centre / Trainer name *</label>
                    <input type="text" id="name" name="name" class="form-input" placeholder="e.g. Tiger Martial Arts Academy" maxlength="80" required>
                    <div class="hint">Official academy, dojo, or trainer name (minimum 2 characters).</div>
                    <div class="error-msg" id="err-name"><i class="bi bi-exclamation-circle-fill"></i> Centre / Trainer name is required (minimum 2 characters).</div>
                </div>

                <!-- Contact Person -->
                <div class="form-group">
                    <label for="contactPerson">Contact person (optional)</label>
                    <input type="text" id="contactPerson" name="contactPerson" class="form-input" placeholder="e.g. Master Rajesh Sharma" maxlength="60">
                    <div class="hint">Name of the head sensei, coach or manager.</div>
                    <div class="error-msg" id="err-contactPerson"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid name (letters and spaces only).</div>
                </div>

                <!-- Mobile Number -->
                <div class="form-group">
                    <label for="phone">Mobile number *</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="10-digit mobile number" maxlength="10" inputmode="numeric" required pattern="[0-9]{10}">
                    <div class="hint">10-digit mobile number (digits only, e.g. 9876543210).</div>
                    <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Valid 10-digit mobile number is required.</div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email">Email *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" class="form-input" placeholder="centre@example.com" maxlength="80" required>
                    </div>
                    <div class="hint">Official email used for student inquiries, logins, and OTP verification.</div>
                    <div class="error-msg" id="err-email"><i class="bi bi-exclamation-circle-fill"></i> Valid email address is required.</div>
                </div>

                <!-- OTP Dispatch & Verification -->
                <div class="form-group">
                    <div class="otp-row">
                        <button type="button" id="btnSendOtp" class="btn-otp" onclick="handleSendOtp()">
                            <i class="bi bi-envelope-arrow-up"></i> <span id="sendOtpText">Send email OTP</span>
                        </button>
                        <div id="verifiedBadge" class="verified-badge" style="display: none;">
                            <i class="bi bi-patch-check-fill"></i> Verified
                        </div>
                    </div>
                </div>

                <!-- OTP Input Field -->
                <div class="form-group" id="otpGroup" style="display: none;">
                    <label for="emailOtp">Email OTP *</label>
                    <div class="otp-row">
                        <input type="text" id="emailOtp" name="emailOtp" class="form-input" placeholder="6-digit OTP" maxlength="6" inputmode="numeric" style="letter-spacing: 2px; font-weight: 700;">
                        <button type="button" id="btnVerifyOtp" class="btn-otp" style="background: var(--navy);" onclick="handleVerifyOtp()">
                            Verify
                        </button>
                    </div>
                    <div class="error-msg" id="err-emailOtp"><i class="bi bi-exclamation-circle-fill"></i> Enter the 6-digit OTP sent to your email.</div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="password">Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="Min 6 chars with number & special char" required maxlength="50" oninput="evaluatePasswordStrength(this.value)">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="pass-strength">
                        <div class="strength-bars">
                            <div class="strength-bar" id="str1"></div>
                            <div class="strength-bar" id="str2"></div>
                            <div class="strength-bar" id="str3"></div>
                            <div class="strength-bar" id="str4"></div>
                        </div>
                        <span class="strength-text" id="strLabel">Weak</span>
                    </div>
                    <div class="hint">Minimum 6 characters. Use letters, numbers, and symbols for better security.</div>
                    <div class="error-msg" id="err-password"><i class="bi bi-exclamation-circle-fill"></i> Password must be at least 6 characters.</div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">Confirm password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter password" required maxlength="50">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('confirmPassword', this)" aria-label="Toggle confirm password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="error-msg" id="err-confirmPassword"><i class="bi bi-exclamation-circle-fill"></i> Passwords do not match.</div>
                </div>

                <!-- Terms & Conditions Box with Modal Link -->
                <div class="terms-box" style="background:#FDF2F8; border:1px solid #FBCFE8; border-radius:12px; padding:12px 14px; margin:16px 0 10px;">
                    <div style="display:flex; align-items:flex-start; gap:10px;">
                        <input type="checkbox" name="acceptedTerms" id="termsCheck" value="true" required style="width:18px; height:18px; accent-color:var(--primary); cursor:pointer; margin-top:2px;">
                        <label for="termsCheck" style="font-size:0.88rem; color:var(--navy); font-weight:500; cursor:pointer; line-height:1.45; margin:0;">
                            I have read and agree to the 
                            <a href="javascript:void(0)" onclick="openTermsModal('Terms &amp; Conditions', false)" style="color:var(--primary); font-weight:700; text-decoration:underline;">
                                Terms &amp; Conditions
                            </a>
                            and <a href="javascript:void(0)" onclick="openTermsModal('Privacy Policy &amp; Data Security', true)" style="color:var(--primary); font-weight:700; text-decoration:underline;">Privacy Policy</a> *
                        </label>
                    </div>
                    <div id="termsCheckBadge" style="display:none; font-size:0.8rem; color:var(--success); font-weight:700; margin-top:6px; padding-left:28px;">
                        <i class="bi bi-check-circle-fill"></i> Terms accepted &amp; verified
                    </div>
                    <div class="error-msg" id="err-terms"><i class="bi bi-exclamation-circle-fill"></i> You must accept the Terms &amp; Conditions and Privacy Policy.</div>
                </div>

                <!-- Submit Button -->
                <button type="button" class="btn-submit" onclick="openConfirmationModal()">
                    Create account <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="login-footer">
                Already registered? <a href="${pageContext.request.contextPath}/centres/login">Sign in</a>
            </div>
        </div>
    </main>

    <!-- Confirmation Modal Card Matching Mobile -->
    <div id="confirmModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <div class="icon-wrap">
                    <i class="bi bi-shield-lock-fill"></i>
                </div>
                <div>
                    <h3>Confirm Details</h3>
                    <p style="font-size: 0.8rem; color: var(--text-gray);">Review your information before account creation</p>
                </div>
            </div>
            <div class="modal-body">
                <div class="review-row">
                    <span class="label">Centre Name:</span>
                    <span class="value" id="revName">—</span>
                </div>
                <div class="review-row">
                    <span class="label">Contact Person:</span>
                    <span class="value" id="revContact">—</span>
                </div>
                <div class="review-row">
                    <span class="label">Mobile Number:</span>
                    <span class="value" id="revPhone">—</span>
                </div>
                <div class="review-row">
                    <span class="label">Email:</span>
                    <span class="value" id="revEmail">—</span>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="closeConfirmationModal()">Back / Edit</button>
                <button type="button" class="btn-modal-confirm" onclick="submitRegistration()">
                    Confirm & Register <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Script Logic -->
    <script>
        let isOtpSent = false;
        let isOtpVerified = false;
        let resendSeconds = 0;
        let resendTimer = null;
        let isSubmitting = false;

        function showAlert(msg, isError = true) {
            const el = document.getElementById('jsAlert');
            if (!el) return;
            el.className = 'alert-box ' + (isError ? 'alert-error' : 'alert-success');
            el.innerHTML = '<i class="bi ' + (isError ? 'bi-exclamation-circle-fill' : 'bi-check-circle-fill') + '"></i> ' + msg;
            el.style.display = 'flex';
            window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' });
        }

        function hideAlert() {
            const el = document.getElementById('jsAlert');
            if (el) el.style.display = 'none';
        }

        function setFieldError(fieldId, isError, customMsg) {
            const input = document.getElementById(fieldId);
            const errEl = document.getElementById('err-' + fieldId);
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
                if (customMsg) {
                    errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + customMsg;
                }
                if (isError) {
                    errEl.classList.add('show');
                } else {
                    errEl.classList.remove('show');
                }
            }
        }

        function validateName(showErr = true) {
            const el = document.getElementById('name');
            const val = el ? el.value.trim() : '';
            if (!val) {
                if (showErr) setFieldError('name', true, 'Centre / Trainer name is required.');
                return false;
            }
            if (val.length < 2) {
                if (showErr) setFieldError('name', true, 'Centre name must be at least 2 characters.');
                return false;
            }
            setFieldError('name', false);
            return true;
        }

        function validateContactPerson(showErr = true) {
            const el = document.getElementById('contactPerson');
            const val = el ? el.value.trim() : '';
            if (val && !/^[a-zA-Z\s.]+$/.test(val)) {
                if (showErr) setFieldError('contactPerson', true, 'Contact person can only contain letters and spaces.');
                return false;
            }
            setFieldError('contactPerson', false);
            return true;
        }

        function validatePhone(showErr = true) {
            const el = document.getElementById('phone');
            const val = el ? el.value.trim() : '';
            if (!val) {
                if (showErr) setFieldError('phone', true, 'Mobile number is required.');
                return false;
            }
            if (!/^[6-9]\d{9}$/.test(val)) {
                if (showErr) setFieldError('phone', true, 'Enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.');
                return false;
            }
            setFieldError('phone', false);
            return true;
        }

        function validateEmail(showErr = true) {
            const el = document.getElementById('email');
            const val = el ? el.value.trim().toLowerCase() : '';
            if (!val) {
                if (showErr) setFieldError('email', true, 'Email address is required.');
                return false;
            }
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!emailRegex.test(val)) {
                if (showErr) setFieldError('email', true, 'Please enter a valid email format (e.g. centre@example.com).');
                return false;
            }
            setFieldError('email', false);
            return true;
        }

        function validatePassword(showErr = true) {
            const el = document.getElementById('password');
            const val = el ? el.value : '';
            if (!val) {
                if (showErr) setFieldError('password', true, 'Password is required.');
                return false;
            }
            if (val.length < 6) {
                if (showErr) setFieldError('password', true, 'Password must be at least 6 characters.');
                return false;
            }
            setFieldError('password', false);
            // Re-validate confirm password if it already has value
            const confEl = document.getElementById('confirmPassword');
            if (confEl && confEl.value) {
                validateConfirmPassword(showErr);
            }
            return true;
        }

        function validateConfirmPassword(showErr = true) {
            const passEl = document.getElementById('password');
            const confEl = document.getElementById('confirmPassword');
            const pass = passEl ? passEl.value : '';
            const conf = confEl ? confEl.value : '';
            if (!conf) {
                if (showErr) setFieldError('confirmPassword', true, 'Please confirm your password.');
                return false;
            }
            if (pass !== conf) {
                if (showErr) setFieldError('confirmPassword', true, 'Passwords do not match.');
                return false;
            }
            setFieldError('confirmPassword', false);
            return true;
        }

        function validateTerms(showErr = true) {
            const el = document.getElementById('termsCheck');
            const checked = el ? el.checked : false;
            if (!checked) {
                if (showErr) setFieldError('terms', true, 'You must accept the Terms & Conditions and Privacy Policy.');
                return false;
            }
            setFieldError('terms', false);
            return true;
        }

        function togglePassVisibility(id, btn) {
            const input = document.getElementById(id);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        function evaluatePasswordStrength(p) {
            let score = 0;
            if (p.length >= 6) score++;
            if (p.length >= 10) score++;
            if (/[0-9]/.test(p)) score++;
            if (/[!@#$%^&*(),.?":{}|<>]/.test(p)) score++;

            const colors = ['#E2E8F0', '#EF4444', '#F97316', '#84CC16', '#22C55E'];
            const labels = ['Weak', 'Weak', 'Fair', 'Good', 'Strong'];

            for (let i = 1; i <= 4; i++) {
                const bar = document.getElementById('str' + i);
                if (bar) bar.style.backgroundColor = (i <= score) ? colors[score] : '#E2E8F0';
            }
            const lbl = document.getElementById('strLabel');
            if (lbl) lbl.textContent = labels[score];
        }

        async function handleSendOtp() {
            hideAlert();
            if (!validateEmail(true)) {
                showAlert('Please provide a valid email address before requesting an OTP.');
                return;
            }
            const email = document.getElementById('email').value.trim();

            const btn = document.getElementById('btnSendOtp');
            btn.disabled = true;
            document.getElementById('sendOtpText').textContent = 'Sending...';

            try {
                const res = await fetch('${pageContext.request.contextPath}/api/martial-arts/centre/otp/send-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email })
                });
                const data = await res.json();

                if (data.success) {
                    isOtpSent = true;
                    document.getElementById('otpGroup').style.display = 'block';
                    showAlert('OTP sent to ' + email, false);
                    startResendTimer(60);
                } else {
                    btn.disabled = false;
                    document.getElementById('sendOtpText').textContent = 'Send email OTP';
                    showAlert(data.error || 'Failed to send OTP. Please check the email.');
                }
            } catch (err) {
                btn.disabled = false;
                document.getElementById('sendOtpText').textContent = 'Send email OTP';
                showAlert('Network error while sending OTP.');
            }
        }

        function startResendTimer(sec) {
            resendSeconds = sec;
            const btn = document.getElementById('btnSendOtp');
            const txt = document.getElementById('sendOtpText');
            btn.disabled = true;

            clearInterval(resendTimer);
            resendTimer = setInterval(() => {
                resendSeconds--;
                if (resendSeconds <= 0) {
                    clearInterval(resendTimer);
                    btn.disabled = false;
                    txt.textContent = 'Resend OTP';
                } else {
                    txt.textContent = 'Resend in ' + resendSeconds + 's';
                }
            }, 1000);
        }

        async function handleVerifyOtp() {
            hideAlert();
            const email = document.getElementById('email').value.trim();
            const otp = document.getElementById('emailOtp').value.trim();

            if (!otp || otp.length !== 6) {
                setFieldError('emailOtp', true, 'Please enter the complete 6-digit OTP.');
                return;
            }
            setFieldError('emailOtp', false);

            const btn = document.getElementById('btnVerifyOtp');
            btn.disabled = true;
            btn.textContent = 'Verifying...';

            try {
                const res = await fetch('${pageContext.request.contextPath}/api/martial-arts/centre/otp/verify-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, otp: otp })
                });
                const data = await res.json();
                btn.disabled = false;
                btn.textContent = 'Verify';

                if (data.success) {
                    isOtpVerified = true;
                    document.getElementById('verifiedBadge').style.display = 'inline-flex';
                    document.getElementById('otpGroup').style.display = 'none';
                    document.getElementById('btnSendOtp').style.display = 'none';
                    document.getElementById('email').readOnly = true;
                    setFieldError('email', false);
                    showAlert('Email verified successfully! You can now complete registration.', false);
                } else {
                    setFieldError('emailOtp', true, data.error || 'Invalid or expired OTP. Please try again.');
                    showAlert(data.error || 'Invalid or expired OTP. Please try again.');
                }
            } catch (err) {
                btn.disabled = false;
                btn.textContent = 'Verify';
                setFieldError('emailOtp', true, 'Network error while verifying OTP.');
                showAlert('Network error while verifying OTP.');
            }
        }

        function openConfirmationModal() {
            hideAlert();
            const isNameValid = validateName(true);
            const isContactValid = validateContactPerson(true);
            const isPhoneValid = validatePhone(true);
            const isEmailValid = validateEmail(true);
            const isPassValid = validatePassword(true);
            const isConfirmValid = validateConfirmPassword(true);
            const isTermsValid = validateTerms(true);

            if (!isNameValid) {
                document.getElementById('name').focus();
                return;
            }
            if (!isContactValid) {
                document.getElementById('contactPerson').focus();
                return;
            }
            if (!isPhoneValid) {
                document.getElementById('phone').focus();
                return;
            }
            if (!isEmailValid) {
                document.getElementById('email').focus();
                return;
            }
            if (!isOtpVerified) {
                showAlert('Please verify your email with the OTP before completing registration.');
                if (!isOtpSent) {
                    document.getElementById('btnSendOtp').focus();
                } else {
                    document.getElementById('emailOtp').focus();
                }
                return;
            }
            if (!isPassValid) {
                document.getElementById('password').focus();
                return;
            }
            if (!isConfirmValid) {
                document.getElementById('confirmPassword').focus();
                return;
            }
            if (!isTermsValid) {
                showAlert('Please read and accept the Terms & Conditions and Privacy Policy.');
                document.getElementById('termsCheck').focus();
                return;
            }

            const name = document.getElementById('name').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const email = document.getElementById('email').value.trim();
            const contact = document.getElementById('contactPerson').value.trim();

            document.getElementById('revName').textContent = name;
            document.getElementById('revContact').textContent = contact || name;
            document.getElementById('revPhone').textContent = phone;
            document.getElementById('revEmail').textContent = email;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function closeConfirmationModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function submitRegistration() {
            if (isSubmitting) return;
            isSubmitting = true;

            const btn = document.querySelector('.btn-modal-confirm');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true" style="display:inline-block;width:1rem;height:1rem;border:2px solid currentColor;border-right-color:transparent;border-radius:50%;animation:spin 0.75s linear infinite;margin-right:6px;"></span> Registering...';
            }
            document.getElementById('regForm').submit();
        }

        function openTermsModal(title, isPrivacy) {
            document.getElementById('termsModalTitle').textContent = title;
            document.getElementById('termsTextSection').style.display = isPrivacy ? 'none' : 'block';
            document.getElementById('privacyTextSection').style.display = isPrivacy ? 'block' : 'none';
            document.getElementById('termsModal').style.display = 'flex';
        }

        function closeTermsModal() {
            document.getElementById('termsModal').style.display = 'none';
        }

        function acceptTermsAndClose() {
            const chk = document.getElementById('termsCheck');
            if (chk) {
                chk.checked = true;
                setFieldError('terms', false);
                syncTermsCheckBadge();
            }
            closeTermsModal();
        }

        function syncTermsCheckBadge() {
            const chk = document.getElementById('termsCheck');
            const badge = document.getElementById('termsCheckBadge');
            if (badge && chk) {
                badge.style.display = chk.checked ? 'block' : 'none';
                if (chk.checked) setFieldError('terms', false);
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const chk = document.getElementById('termsCheck');
            if (chk) {
                chk.addEventListener('change', function() {
                    syncTermsCheckBadge();
                    validateTerms(false);
                });
                syncTermsCheckBadge();
            }

            // Input clamping and live real-time validation handlers
            const phoneEl = document.getElementById('phone');
            if (phoneEl) {
                phoneEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                    validatePhone(false);
                });
                phoneEl.addEventListener('blur', function() { validatePhone(true); });
            }

            const otpEl = document.getElementById('emailOtp');
            if (otpEl) {
                otpEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 6);
                    if (this.value.length === 6) setFieldError('emailOtp', false);
                });
            }

            const nameEl = document.getElementById('name');
            if (nameEl) {
                nameEl.addEventListener('input', function() {
                    this.value = this.value.replace(/[^a-zA-Z0-9\s.\-&',]/g, '').slice(0, 80);
                    validateName(false);
                });
                nameEl.addEventListener('blur', function() { validateName(true); });
            }

            const contactEl = document.getElementById('contactPerson');
            if (contactEl) {
                contactEl.addEventListener('input', function() {
                    this.value = this.value.replace(/[^a-zA-Z\s.]/g, '').slice(0, 60);
                    validateContactPerson(false);
                });
                contactEl.addEventListener('blur', function() { validateContactPerson(true); });
            }

            const emailEl = document.getElementById('email');
            if (emailEl) {
                emailEl.addEventListener('input', function() {
                    if (this.value.includes('@') && this.value.includes('.')) validateEmail(false);
                });
                emailEl.addEventListener('blur', function() { validateEmail(true); });
            }

            const passEl = document.getElementById('password');
            if (passEl) {
                passEl.addEventListener('input', function() { validatePassword(false); });
                passEl.addEventListener('blur', function() { validatePassword(true); });
            }

            const confirmEl = document.getElementById('confirmPassword');
            if (confirmEl) {
                confirmEl.addEventListener('input', function() { validateConfirmPassword(false); });
                confirmEl.addEventListener('blur', function() { validateConfirmPassword(true); });
            }
        });
    </script>

    <!-- Terms & Conditions Modal -->
    <div id="termsModal" class="modal-overlay" style="display:none; align-items:center; justify-content:center; z-index:100; padding:16px;">
        <div class="modal-card" style="max-width:580px; max-height:85vh; display:flex; flex-direction:column; background:#fff; border-radius:20px; padding:24px;">
            <div class="modal-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 14px; margin-bottom: 14px;">
                <div class="icon-wrap"><i class="bi bi-journal-check"></i></div>
                <div style="flex: 1;">
                    <h3 id="termsModalTitle" style="font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0;">Terms &amp; Conditions</h3>
                    <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Fight D Fear — Women Martial Arts &amp; Self Defense</p>
                </div>
                <button type="button" onclick="closeTermsModal()" style="background:none; border:none; font-size:1.5rem; color:var(--text-gray); cursor:pointer; line-height:1;">&times;</button>
            </div>
            <div class="modal-body" id="termsModalContent" style="overflow-y: auto; max-height: 48vh; font-size: 0.88rem; line-height: 1.6; color: var(--navy); background: #FFF; padding: 14px 18px; border: 1px solid var(--border-color); border-radius: 12px;">
                <div id="termsTextSection">
                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">1. Purpose &amp; Women's Safety Mission</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Martial arts academies, dojos, and self-defense centres registered on Fight D Fear are committed to equipping women and girls with authentic defense skills, confidence, and physical empowerment in a safe, respectful environment.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">2. Instructor Credentials &amp; Verification</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Centres must deploy certified instructors with recognized martial arts black belts / coach licenses. Misleading belt rankings or unverified facilities will be removed promptly.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">3. Trainee Safety &amp; Non-Violence</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Techniques taught must prioritize de-escalation, self-defense, and escape. Bullying, inappropriate physical touch, or unauthorized sparring will result in immediate permanent expulsion.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">4. Zero-Tolerance Policy</h4>
                    <p style="margin-bottom:0; color:var(--text-gray);">Any abusive behavior or harassment will be reported directly to law enforcement authorities.</p>
                </div>
                <div id="privacyTextSection" style="display:none;">
                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">1. Information We Collect</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">We collect contact credentials, centre affiliation details, and settlement bank info strictly necessary for student batch registrations and fee payouts.</p>

                    <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">2. Data Protection</h4>
                    <p style="margin-bottom:12px; color:var(--text-gray);">Your financial and institutional records are encrypted in transit and securely preserved.</p>
                </div>
            </div>
            <div class="modal-actions" style="margin-top: 14px; display:flex; gap:10px;">
                <button type="button" class="btn-modal-cancel" onclick="closeTermsModal()" style="flex:1;">Close</button>
                <button type="button" class="btn-modal-confirm" onclick="acceptTermsAndClose()" style="flex:1.2; background:var(--primary); color:#fff; border:none; padding:12px; border-radius:10px; font-weight:700; cursor:pointer;">
                    I Agree &amp; Accept <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
