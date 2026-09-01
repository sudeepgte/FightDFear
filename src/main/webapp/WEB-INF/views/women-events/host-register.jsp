<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join as Event Host — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
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
            font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
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
            margin-bottom: 4px;
        }

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

        .form-input, .form-select {
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

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

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
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-otp:hover:not(:disabled) {
            background: var(--primary-hover);
        }

        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--success);
            font-weight: 700;
            font-size: 0.85rem;
            background: var(--success-bg);
            padding: 6px 12px;
            border-radius: 8px;
            border: 1px solid #BBF7D0;
            margin-top: 6px;
        }

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
            background: var(--rose-soft);
            color: var(--primary);
            opacity: 0.65;
            cursor: not-allowed;
            box-shadow: none;
        }

        .form-input.is-invalid, .form-select.is-invalid {
            border-color: var(--error) !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid, .form-select.is-valid {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.12) !important;
        }

        .error-feedback {
            color: var(--error);
            font-size: 0.8rem;
            margin-top: 5px;
            font-weight: 500;
            display: none;
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

        .otp-hint {
            font-size: 0.8rem;
            color: var(--text-gray);
            margin-top: 8px;
            line-height: 1.45;
        }

        .preview-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }

        .section-title {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--primary);
            margin: 18px 0 10px;
            padding-bottom: 6px;
            border-bottom: 1px solid #FECDD3;
        }

        .preview-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.92rem;
        }

        .preview-row:last-child { border-bottom: none; }
        .preview-row .k { color: var(--text-gray); font-weight: 500; }
        .preview-row .v { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }

        .btn-row {
            display: flex;
            gap: 10px;
            margin-top: 24px;
        }

        .btn-ghost {
            flex: 1;
            padding: 14px;
            background: #FFFFFF;
            color: var(--navy);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
        }

        .btn-ghost:hover { border-color: var(--primary); color: var(--primary); }

        .btn-row .btn-submit { flex: 1; width: auto; }
    </style>
</head>
<body>

    <header class="app-header">
        <a href="${pageContext.request.contextPath}/women-events" class="header-brand">
            <i class="bi bi-shield-heart-fill"></i> Fight D Fear Event Studio
        </a>
        <div class="header-links">
            Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login" style="color: var(--primary); font-weight: 700; text-decoration: none; margin-left: 4px;">Sign in</a>
        </div>
    </header>

    <main class="main-container">

        <div class="info-banner">
            <h2>Join as an Event Host</h2>
            <p>For NGOs, Corporate Partners, Self-Defense Academies & Event Organizers. Create your host account to publish safety events & community workshops.</p>
        </div>

        <div class="form-card" id="formPanel">
            <div id="statusAlert" class="alert-box alert-error" style="display: none;">
                <i class="bi bi-exclamation-circle-fill"></i> <span id="alertText"></span>
            </div>

            <form id="quickRegisterForm" novalidate>

                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" placeholder="e.g. Anjali Sharma" required minlength="2" oninput="onFormChange()" onblur="validateFullName()">
                    <div class="error-feedback" id="error-fullName"></div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" class="form-input" placeholder="organizer@example.com" required oninput="onEmailChange()" onblur="validateEmail()">
                    </div>
                    <div class="error-feedback" id="error-email"></div>
                </div>

                <div class="form-group">
                    <div class="otp-row">
                        <button type="button" id="btnSendOtp" class="btn-otp" onclick="sendOtp()">
                            <i class="bi bi-envelope-arrow-up"></i> <span id="sendOtpText">Send Email OTP</span>
                        </button>
                    </div>
                    <div class="otp-hint" id="otpSendHint">OTP is valid for 10 minutes. You can resend after 60 seconds.</div>
                </div>

                <div id="otpSection" class="form-group" style="display: none;">
                    <label for="emailOtp">6-Digit Email OTP *</label>
                    <div class="otp-row">
                        <input type="text" id="emailOtp" class="form-input" placeholder="Enter 6-digit OTP" maxlength="6" pattern="^\d{6}$" inputmode="numeric" oninput="validateOtp()" onblur="validateOtp()">
                        <button type="button" id="btnVerifyOtp" class="btn-otp" style="background: var(--primary);" onclick="verifyOtp()">
                            Verify OTP
                        </button>
                    </div>
                    <div class="error-feedback" id="error-emailOtp"></div>
                    <div class="otp-hint" id="otpTimeHint">Enter the code within 10 minutes. Use Resend after the countdown if you did not receive it.</div>
                </div>

                <div id="verifiedBadge" class="verified-badge" style="display: none;">
                    <i class="bi bi-patch-check-fill"></i> Email Verified Successfully
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="phone">Phone Number (10 Digits) *</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="10-digit mobile number" required pattern="^\d{10}$" maxlength="10" oninput="onFormChange()" onblur="validatePhone()">
                    <div class="error-feedback" id="error-phone"></div>
                </div>

                <div class="form-group">
                    <label for="password">Password (Min 6 Characters) *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required minlength="6" oninput="onFormChange()" onblur="validatePassword()">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="error-feedback" id="error-password"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="••••••••" required minlength="6" oninput="onFormChange()" onblur="validateConfirmPassword()">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('confirmPassword', this)" aria-label="Toggle confirm password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="error-feedback" id="error-confirmPassword"></div>
                </div>

                <label class="terms-row">
                    <input type="checkbox" id="acceptedTerms" required onchange="onFormChange()">
                    <span>I accept the <strong>Terms & Safety Policies</strong> *</span>
                </label>
                <div class="error-feedback" id="error-acceptedTerms" style="margin-top: -12px; margin-bottom: 12px;"></div>

                <button type="button" id="btnReview" class="btn-submit" disabled onclick="showPreview()">
                    <i class="bi bi-eye-fill"></i> Review &amp; Continue
                </button>
            </form>

            <div class="login-footer">
                Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login">Sign in here</a>
            </div>
        </div>

        <div class="preview-card" id="previewPanel" style="display:none;">
            <h2 style="font-size:1.2rem;font-weight:800;margin-bottom:6px;">Event Host Registration Review</h2>
            <p style="color:var(--text-gray);font-size:0.9rem;margin-bottom:8px;">Confirm your details before creating your account.</p>

            <div class="section-title">Personal Information</div>
            <div class="preview-row"><span class="k">Full Name</span><span class="v" id="pvName">—</span></div>
            <div class="preview-row"><span class="k">Email</span><span class="v" id="pvEmail">—</span></div>
            <div class="preview-row"><span class="k">Phone</span><span class="v" id="pvPhone">—</span></div>

            <div class="section-title">Account</div>
            <div class="preview-row"><span class="k">Email</span><span class="v" style="color:var(--success);">Verified</span></div>
            <div class="preview-row"><span class="k">Password</span><span class="v">••••••••</span></div>

            <div class="section-title">Terms</div>
            <div class="preview-row"><span class="k">Terms &amp; Safety Policies</span><span class="v" style="color:var(--success);">Accepted</span></div>

            <div id="previewAlert" class="alert-box alert-error" style="display:none;margin-top:16px;">
                <i class="bi bi-exclamation-circle-fill"></i> <span id="previewAlertText"></span>
            </div>

            <div class="btn-row">
                <button type="button" class="btn-ghost" id="editBtn" onclick="editPreview()">Edit</button>
                <button type="button" class="btn-submit" id="btnConfirmSubmit" onclick="submitRegistration()">Confirm &amp; Submit</button>
            </div>
        </div>
    </main>

    <script>
        let isEmailVerified = false;
        let submitting = false;
        let otpResendTimer = null;
        const contextPath = '${pageContext.request.contextPath}';
        const LOGIN_PREFILL_KEY = 'fdf_host_login_prefill';
        let otpExpirationMinutes = 10;
        let otpResendCooldownSeconds = 60;

        function onFormChange() {
            refreshReviewButton();
        }

        function onEmailChange() {
            isEmailVerified = false;
            document.getElementById('verifiedBadge').style.display = 'none';
            document.getElementById('email').readOnly = false;
            document.getElementById('btnSendOtp').style.display = '';
            refreshReviewButton();
        }

        function refreshReviewButton() {
            const name = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('acceptedTerms').checked;
            const emailOk = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email);
            const ready = isEmailVerified
                && name.length >= 2 && /^[a-zA-Z\s]+$/.test(name)
                && emailOk
                && /^\d{10}$/.test(phone)
                && password.length >= 6
                && confirm === password
                && terms;
            document.getElementById('btnReview').disabled = !ready;
        }

        function validateFullName() {
            const el = document.getElementById('fullName');
            const err = document.getElementById('error-fullName');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Full Name is required.');
                return false;
            }
            if (val.length < 2) {
                showFieldInvalid(el, err, 'Full Name must be at least 2 characters.');
                return false;
            }
            if (!/^[a-zA-Z\s]+$/.test(val)) {
                showFieldInvalid(el, err, 'Full Name must contain only letters and spaces.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateEmail() {
            const el = document.getElementById('email');
            const err = document.getElementById('error-email');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Email Address is required.');
                return false;
            }
            const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!regex.test(val)) {
                showFieldInvalid(el, err, 'Please enter a valid email address.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateOtp() {
            const el = document.getElementById('emailOtp');
            const err = document.getElementById('error-emailOtp');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'OTP code is required.');
                return false;
            }
            if (!/^\d{6}$/.test(val)) {
                showFieldInvalid(el, err, 'OTP must be a 6-digit number.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validatePhone() {
            const el = document.getElementById('phone');
            const err = document.getElementById('error-phone');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Phone Number is required.');
                return false;
            }
            if (!/^\d{10}$/.test(val)) {
                showFieldInvalid(el, err, 'Phone Number must be exactly 10 digits.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validatePassword() {
            const el = document.getElementById('password');
            const err = document.getElementById('error-password');
            const val = el.value;
            if (!val) {
                showFieldInvalid(el, err, 'Password is required.');
                return false;
            }
            if (val.length < 6) {
                showFieldInvalid(el, err, 'Password must be at least 6 characters.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateConfirmPassword() {
            const el = document.getElementById('confirmPassword');
            const err = document.getElementById('error-confirmPassword');
            const val = el.value;
            const pass = document.getElementById('password').value;
            if (!val) {
                showFieldInvalid(el, err, 'Please confirm your password.');
                return false;
            }
            if (val !== pass) {
                showFieldInvalid(el, err, 'Passwords do not match.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateTerms() {
            const el = document.getElementById('acceptedTerms');
            const err = document.getElementById('error-acceptedTerms');
            if (!el.checked) {
                showFieldInvalid(el, err, 'You must accept the Terms & Safety Policies.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function showFieldInvalid(el, err, msg) {
            el.classList.add('is-invalid');
            el.classList.remove('is-valid');
            err.innerText = msg;
            err.style.display = 'block';
        }

        function showFieldValid(el, err) {
            el.classList.remove('is-invalid');
            el.classList.add('is-valid');
            err.innerText = '';
            err.style.display = 'none';
        }

        function showAlert(msg, isSuccess = false) {
            const box = document.getElementById('statusAlert');
            const text = document.getElementById('alertText');
            box.className = 'alert-box ' + (isSuccess ? 'alert-success' : 'alert-error');
            box.querySelector('i').className = 'bi ' + (isSuccess ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill');
            text.innerText = msg;
            box.style.display = 'flex';
        }

        function hideAlert() {
            document.getElementById('statusAlert').style.display = 'none';
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

        function armOtpResend(seconds) {
            if (otpResendTimer) clearInterval(otpResendTimer);
            const btn = document.getElementById('btnSendOtp');
            const label = document.getElementById('sendOtpText');
            let left = seconds;
            btn.disabled = true;
            label.innerText = 'Resend in ' + left + 's';
            otpResendTimer = setInterval(() => {
                left -= 1;
                if (left <= 0) {
                    clearInterval(otpResendTimer);
                    otpResendTimer = null;
                    if (!isEmailVerified) {
                        btn.disabled = false;
                        label.innerText = 'Resend OTP';
                    }
                } else {
                    label.innerText = 'Resend in ' + left + 's';
                }
            }, 1000);
        }

        async function sendOtp() {
            hideAlert();
            if (!validateEmail()) {
                showAlert('Please enter a valid email address first.');
                return;
            }
            const email = document.getElementById('email').value.trim();
            const btn = document.getElementById('btnSendOtp');
            btn.disabled = true;
            document.getElementById('sendOtpText').innerText = 'Sending...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/otp/send-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email })
                });
                const data = await res.json();
                if (data.success) {
                    otpExpirationMinutes = data.expirationMinutes || otpExpirationMinutes;
                    otpResendCooldownSeconds = data.resendCooldownSeconds || otpResendCooldownSeconds;
                    const msg = data.message || ('OTP sent to ' + email + '. Valid for ' + otpExpirationMinutes
                        + ' minutes. You can resend after ' + otpResendCooldownSeconds + ' seconds.');
                    showAlert(msg, true);
                    alert('OTP sent to ' + email + '.\n\nValid for ' + otpExpirationMinutes
                        + ' minutes.\nYou can resend after ' + otpResendCooldownSeconds
                        + ' seconds.\nPlease check your inbox or spam folder.');
                    document.getElementById('otpSection').style.display = 'block';
                    document.getElementById('otpTimeHint').innerText = 'Enter the code within '
                        + otpExpirationMinutes + ' minutes. Use Resend after the '
                        + otpResendCooldownSeconds + '-second countdown if you did not receive it.';
                    document.getElementById('otpSendHint').innerText = 'OTP is valid for '
                        + otpExpirationMinutes + ' minutes. You can resend after '
                        + otpResendCooldownSeconds + ' seconds.';
                    isEmailVerified = false;
                    document.getElementById('verifiedBadge').style.display = 'none';
                    document.getElementById('emailOtp').readOnly = false;
                    document.getElementById('emailOtp').value = '';
                    document.getElementById('btnVerifyOtp').style.display = '';
                    document.getElementById('btnVerifyOtp').disabled = false;
                    document.getElementById('btnVerifyOtp').innerText = 'Verify OTP';
                    armOtpResend(otpResendCooldownSeconds);
                    refreshReviewButton();
                } else {
                    const err = data.error || 'Failed to send OTP.';
                    showAlert(err);
                    alert(err);
                    btn.disabled = false;
                    document.getElementById('sendOtpText').innerText = 'Send Email OTP';
                }
            } catch (e) {
                showAlert('Network error while sending OTP.');
                btn.disabled = false;
                document.getElementById('sendOtpText').innerText = 'Send Email OTP';
            }
        }

        async function verifyOtp() {
            hideAlert();
            const email = document.getElementById('email').value.trim();
            if (!validateOtp()) {
                showAlert('Please enter the 6-digit OTP code. Codes expire in ' + otpExpirationMinutes + ' minutes.');
                return;
            }
            const otp = document.getElementById('emailOtp').value.trim();
            const btn = document.getElementById('btnVerifyOtp');
            btn.disabled = true;
            btn.innerText = 'Verifying...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/otp/verify-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, otp: otp })
                });
                const data = await res.json();
                if (data.success) {
                    isEmailVerified = true;
                    document.getElementById('verifiedBadge').style.display = 'inline-flex';
                    document.getElementById('email').readOnly = true;
                    document.getElementById('emailOtp').readOnly = true;
                    document.getElementById('otpSection').style.display = 'none';
                    document.getElementById('btnSendOtp').style.display = 'none';
                    if (otpResendTimer) {
                        clearInterval(otpResendTimer);
                        otpResendTimer = null;
                    }
                    showAlert('Email verified successfully. Complete the form, then Review & Continue.', true);
                    refreshReviewButton();
                } else {
                    const err = data.error || ('Invalid or expired OTP. Codes expire in ' + otpExpirationMinutes + ' minutes.');
                    showAlert(err);
                    alert(err);
                    btn.disabled = false;
                    btn.innerText = 'Verify OTP';
                }
            } catch (e) {
                showAlert('Network error verifying OTP.');
                btn.disabled = false;
                btn.innerText = 'Verify OTP';
            }
        }

        function showPreview() {
            hideAlert();
            if (!isEmailVerified) {
                showAlert('Please verify your email via OTP before continuing.');
                return;
            }
            if (!validateFullName() || !validateEmail() || !validatePhone()
                    || !validatePassword() || !validateConfirmPassword() || !validateTerms()) {
                showAlert('Please resolve the errors below before reviewing.');
                return;
            }
            document.getElementById('pvName').innerText = document.getElementById('fullName').value.trim();
            document.getElementById('pvEmail').innerText = document.getElementById('email').value.trim();
            document.getElementById('pvPhone').innerText = document.getElementById('phone').value.trim();
            document.getElementById('formPanel').style.display = 'none';
            document.getElementById('previewPanel').style.display = 'block';
            document.getElementById('previewAlert').style.display = 'none';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function editPreview() {
            document.getElementById('previewPanel').style.display = 'none';
            document.getElementById('formPanel').style.display = 'block';
            submitting = false;
            const btn = document.getElementById('btnConfirmSubmit');
            btn.disabled = false;
            btn.innerHTML = 'Confirm &amp; Submit';
            document.getElementById('fullName').focus();
        }

        async function submitRegistration() {
            if (submitting) return;
            hideAlert();
            document.getElementById('previewAlert').style.display = 'none';

            if (!isEmailVerified || !validateFullName() || !validateEmail() || !validatePhone()
                    || !validatePassword() || !validateConfirmPassword() || !validateTerms()) {
                editPreview();
                showAlert('Please resolve the errors below before submitting.');
                return;
            }

            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const otp = document.getElementById('emailOtp').value.trim();
            const acceptedTerms = document.getElementById('acceptedTerms').checked;

            submitting = true;
            const btnSubmit = document.getElementById('btnConfirmSubmit');
            btnSubmit.disabled = true;
            btnSubmit.innerHTML = '<i class="bi bi-arrow-repeat"></i> Registering...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/register-quick', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        fullName: fullName,
                        email: email,
                        phone: phone,
                        password: password,
                        confirmPassword: confirmPassword,
                        emailOtp: otp,
                        acceptedTerms: acceptedTerms
                    })
                });
                const data = await res.json();
                if (data.success) {
                    try {
                        sessionStorage.setItem(LOGIN_PREFILL_KEY, JSON.stringify({ email: email, password: password }));
                    } catch (e) { /* ignore */ }
                    window.location.href = contextPath + '/women-events/host/login?registered=true&email=' + encodeURIComponent(email);
                } else {
                    const err = data.error || 'Registration failed.';
                    document.getElementById('previewAlertText').innerText = err;
                    document.getElementById('previewAlert').style.display = 'flex';
                    submitting = false;
                    btnSubmit.disabled = false;
                    btnSubmit.innerHTML = 'Confirm &amp; Submit';
                }
            } catch (e) {
                document.getElementById('previewAlertText').innerText = 'Server connection error during registration.';
                document.getElementById('previewAlert').style.display = 'flex';
                submitting = false;
                btnSubmit.disabled = false;
                btnSubmit.innerHTML = 'Confirm & Submit';
            }
        }
    </script>
</body>
</html>
<!--
</body>
</html>
<!--
            const el = document.getElementById('fullName');
            const err = document.getElementById('error-fullName');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Full Name is required.');
                return false;
            }
            if (val.length < 2) {
                showFieldInvalid(el, err, 'Full Name must be at least 2 characters.');
                return false;
            }
            if (!/^[a-zA-Z\s]+$/.test(val)) {
                showFieldInvalid(el, err, 'Full Name must contain only letters and spaces.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateEmail() {
            const el = document.getElementById('email');
            const err = document.getElementById('error-email');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Email Address is required.');
                return false;
            }
            const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!regex.test(val)) {
                showFieldInvalid(el, err, 'Please enter a valid email address.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateOtp() {
            const el = document.getElementById('emailOtp');
            const err = document.getElementById('error-emailOtp');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'OTP code is required.');
                return false;
            }
            if (!/^\d{6}$/.test(val)) {
                showFieldInvalid(el, err, 'OTP must be a 6-digit number.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validatePhone() {
            const el = document.getElementById('phone');
            const err = document.getElementById('error-phone');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Phone Number is required.');
                return false;
            }
            if (!/^\d{10}$/.test(val)) {
                showFieldInvalid(el, err, 'Phone Number must be exactly 10 digits.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validatePassword() {
            const el = document.getElementById('password');
            const err = document.getElementById('error-password');
            const val = el.value;
            if (!val) {
                showFieldInvalid(el, err, 'Password is required.');
                return false;
            }
            if (val.length < 6) {
                showFieldInvalid(el, err, 'Password must be at least 6 characters.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateConfirmPassword() {
            const el = document.getElementById('confirmPassword');
            const err = document.getElementById('error-confirmPassword');
            const val = el.value;
            const pass = document.getElementById('password').value;
            if (!val) {
                showFieldInvalid(el, err, 'Please confirm your password.');
                return false;
            }
            if (val !== pass) {
                showFieldInvalid(el, err, 'Passwords do not match.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validateTerms() {
            const el = document.getElementById('acceptedTerms');
            const err = document.getElementById('error-acceptedTerms');
            if (!el.checked) {
                showFieldInvalid(el, err, 'You must accept the Terms & Safety Policies.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function showFieldInvalid(el, err, msg) {
            el.classList.add('is-invalid');
            el.classList.remove('is-valid');
            err.innerText = msg;
            err.style.display = 'block';
        }

        function showFieldValid(el, err) {
            el.classList.remove('is-invalid');
            el.classList.add('is-valid');
            err.innerText = '';
            err.style.display = 'none';
        }

        function showAlert(msg, isSuccess = false) {
            const box = document.getElementById('statusAlert');
            const text = document.getElementById('alertText');
            box.className = 'alert-box ' + (isSuccess ? 'alert-success' : 'alert-error');
            box.querySelector('i').className = 'bi ' + (isSuccess ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill');
            text.innerText = msg;
            box.style.display = 'flex';
        }

        function hideAlert() {
            document.getElementById('statusAlert').style.display = 'none';
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

        async function sendOtp() {
            hideAlert();
            if (!validateEmail()) {
                showAlert('Please enter a valid email address first.');
                return;
            }
            const email = document.getElementById('email').value.trim();

            const btn = document.getElementById('btnSendOtp');
            btn.disabled = true;
            document.getElementById('sendOtpText').innerText = 'Sending...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/otp/send-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email })
                });
                const data = await res.json();
                if (data.success) {
                    showAlert('OTP sent to ' + email + '. Check your inbox!', true);
                    document.getElementById('otpSection').style.display = 'block';
                    document.getElementById('sendOtpText').innerText = 'Resend OTP';
                } else {
                    showAlert(data.error || 'Failed to send OTP.');
                    document.getElementById('sendOtpText').innerText = 'Send Email OTP';
                }
            } catch (e) {
                showAlert('Network error while sending OTP.');
                document.getElementById('sendOtpText').innerText = 'Send Email OTP';
            } finally {
                btn.disabled = false;
            }
        }

        async function verifyOtp() {
            hideAlert();
            const email = document.getElementById('email').value.trim();
            if (!validateOtp()) {
                showAlert('Please enter the 6-digit OTP code.');
                return;
            }
            const otp = document.getElementById('emailOtp').value.trim();

            const btn = document.getElementById('btnVerifyOtp');
            btn.disabled = true;
            btn.innerText = 'Verifying...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/otp/verify-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, otp: otp })
                });
                const data = await res.json();
                if (data.success) {
                    isEmailVerified = true;
                    document.getElementById('verifiedBadge').style.display = 'inline-flex';
                    document.getElementById('btnSubmitAccount').disabled = false;
                    document.getElementById('email').readOnly = true;
                    document.getElementById('emailOtp').readOnly = true;
                    document.getElementById('otpSection').style.display = 'none';
                    document.getElementById('btnSendOtp').style.display = 'none';
                    showAlert('Email verified successfully! Review your details, then create the account.', true);
                    document.getElementById('previewName').innerText = document.getElementById('fullName').value.trim();
                    document.getElementById('previewEmail').innerText = email;
                    document.getElementById('previewCard').style.display = 'block';
                    document.getElementById('btnSubmitAccount').disabled = false;
                } else {
                    showAlert(data.error || 'Invalid OTP code.');
                }
            } catch (e) {
                showAlert('Network error verifying OTP.');
            } finally {
                btn.disabled = false;
                if (!isEmailVerified) btn.innerText = 'Verify OTP';
            }
        }

        function editPreview() {
            document.getElementById('previewCard').style.display = 'none';
            document.getElementById('fullName').focus();
        }

        async function handleRegistration(e) {
            e.preventDefault();
            hideAlert();

            const isNameElValid = validateFullName();
            const isEmailElValid = validateEmail();
            const isPhoneElValid = validatePhone();
            const isPassElValid = validatePassword();
            const isConfirmElValid = validateConfirmPassword();
            const isTermsElValid = validateTerms();

            if (!isNameElValid || !isEmailElValid || !isPhoneElValid || !isPassElValid || !isConfirmElValid || !isTermsElValid) {
                const firstInvalid = document.querySelector('.form-input.is-invalid, input[type="checkbox"].is-invalid');
                if (firstInvalid) firstInvalid.focus();
                showAlert('Please resolve the errors below before submitting.');
                return;
            }

            if (!isEmailVerified) {
                showAlert('Please verify your email via OTP before submitting.');
                return;
            }

            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const otp = document.getElementById('emailOtp').value.trim();
            const acceptedTerms = document.getElementById('acceptedTerms').checked;

            const btnSubmit = document.getElementById('btnSubmitAccount');
            btnSubmit.disabled = true;
            btnSubmit.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Registering...';

            try {
                const res = await fetch(contextPath + '/api/women-events/host/register-quick', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        fullName: fullName,
                        email: email,
                        phone: phone,
                        password: password,
                        confirmPassword: confirmPassword,
                        emailOtp: otp,
                        acceptedTerms: acceptedTerms
                    })
                });
                const data = await res.json();
                if (data.success) {
                    window.location.href = contextPath + '/women-events/host/login?registered=true';
                } else {
                    showAlert(data.error || 'Registration failed.');
                    btnSubmit.disabled = false;
                    btnSubmit.innerHTML = '<i class="bi bi-person-plus-fill"></i> Create Host Account';
                }
            } catch (e) {
                showAlert('Server connection error during registration.');
                btnSubmit.disabled = false;
                btnSubmit.innerHTML = '<i class="bi bi-person-plus-fill"></i> Create Host Account';
            }
        }
    </script>
</body>
</html>
-->
