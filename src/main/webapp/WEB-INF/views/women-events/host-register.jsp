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
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748B;
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

        <div class="form-card">
            <div id="statusAlert" class="alert-box alert-error" style="display: none;">
                <i class="bi bi-exclamation-circle-fill"></i> <span id="alertText"></span>
            </div>

            <form id="quickRegisterForm" onsubmit="handleRegistration(event)">
                
                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" placeholder="e.g. Anjali Sharma" required minlength="2">
                </div>

                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" class="form-input" placeholder="organizer@example.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <div class="otp-row">
                        <button type="button" id="btnSendOtp" class="btn-otp" onclick="sendOtp()">
                            <i class="bi bi-envelope-arrow-up"></i> <span id="sendOtpText">Send Email OTP</span>
                        </button>
                    </div>
                </div>

                <div id="otpSection" class="form-group" style="display: none;">
                    <label for="emailOtp">6-Digit Email OTP *</label>
                    <div class="otp-row">
                        <input type="text" id="emailOtp" class="form-input" placeholder="Enter 6-digit OTP" maxlength="6" pattern="^\d{6}$">
                        <button type="button" id="btnVerifyOtp" class="btn-otp" style="background: var(--primary);" onclick="verifyOtp()">
                            Verify OTP
                        </button>
                    </div>
                </div>

                <div id="verifiedBadge" class="verified-badge" style="display: none;">
                    <i class="bi bi-patch-check-fill"></i> Email Verified Successfully
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="phone">Phone Number (10 Digits) *</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="10-digit mobile number" required pattern="^\d{10}$" maxlength="10">
                </div>

                <div class="form-group">
                    <label for="password">Password (Min 6 Characters) *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required minlength="6">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="••••••••" required minlength="6">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('confirmPassword', this)" aria-label="Toggle confirm password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <label class="terms-row">
                    <input type="checkbox" id="acceptedTerms" required>
                    <span>I accept the <strong>Terms & Safety Policies</strong> *</span>
                </label>

                <button type="submit" id="btnSubmitAccount" class="btn-submit" disabled>
                    <i class="bi bi-person-plus-fill"></i> Create Host Account
                </button>
            </form>

            <div class="login-footer">
                Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login">Sign in here</a>
            </div>
        </div>
    </main>

    <script>
        let isEmailVerified = false;
        const contextPath = '${pageContext.request.contextPath}';

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
            const email = document.getElementById('email').value.trim();
            if (!email || !email.includes('@')) {
                showAlert('Please enter a valid email address first.');
                return;
            }

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
            const otp = document.getElementById('emailOtp').value.trim();

            if (!otp || otp.length !== 6) {
                showAlert('Please enter the 6-digit OTP code.');
                return;
            }

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
                    showAlert('Email verified successfully! You can now complete registration.', true);
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

        async function handleRegistration(e) {
            e.preventDefault();
            hideAlert();

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

            if (!/^\d{10}$/.test(phone)) {
                showAlert('Phone number must be exactly 10 digits.');
                return;
            }

            if (password !== confirmPassword) {
                showAlert('Passwords do not match.');
                return;
            }

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
