<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join as Entrepreneur — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #FFF8FA;
            --card-bg: #FFFFFF;
            --border-color: #FCE8EB;
            --success: var(--brand-pink);
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

        /* Info Banner */
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

        /* Confirmation Modal Overlay */
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
    
        .bg-brand-pink { background-color: var(--brand-pink) !important; color: white !important; }
        .text-brand-pink { color: var(--brand-pink) !important; }
        .bg-soft-pink { background-color: var(--pink-soft-bg) !important; }
        .badge-brand { background-color: var(--pink-soft-bg) !important; color: var(--brand-pink) !important; border: 1px solid var(--border-light); }
        .btn-brand-pink { background-color: var(--brand-pink) !important; color: white !important; border: none; }
        .btn-brand-pink:hover { background-color: var(--brand-pink-hover) !important; color: white !important; }
</style>
</head>
<body>

    <!-- App Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/entrepreneur/login">Sign in</a>
        </div>
    </header>

    <!-- Main Container -->
    <main class="main-container">

        <!-- Info Card Matching Martial Arts Centre -->
        <div class="info-banner">
            <h2>Quick registration</h2>
            <p>For female entrepreneurs, founders & small business owners. After login, complete your profile details and pitch for funding.</p>
            <p class="subtext">For self-defense centers or fitness trainers, register under respective partner modules.</p>
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

            <form id="regForm" action="${pageContext.request.contextPath}/entrepreneur/register" method="post">
                <input type="hidden" name="acceptedTerms" value="true">

                <!-- Full Name -->
                <div class="form-group">
                    <label for="fullName">Full name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" placeholder="e.g. Priya Sharma" required>
                </div>

                <!-- Mobile Number -->
                <div class="form-group">
                    <label for="phone">Mobile number *</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="10-digit mobile number" maxlength="10" required pattern="[0-9]{10}">
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email">Email *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" class="form-input" placeholder="entrepreneur@example.com" required>
                    </div>
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
                        <input type="text" id="emailOtp" name="emailOtp" class="form-input" placeholder="6-digit OTP" maxlength="6" style="letter-spacing: 2px; font-weight: 700;">
                        <button type="button" id="btnVerifyOtp" class="btn-otp" style="background: var(--navy);" onclick="handleVerifyOtp()">
                            Verify
                        </button>
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="password">Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="Min 6 chars with number & special char" required oninput="evaluatePasswordStrength(this.value)">
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
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">Confirm password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter password" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('confirmPassword', this)" aria-label="Toggle confirm password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <!-- Terms -->
                <label class="terms-row">
                    <input type="checkbox" id="termsCheck" required>
                    <span>I accept the <strong>Terms & Privacy Policy</strong></span>
                </label>

                <!-- Submit Button -->
                <button type="button" class="btn-submit" onclick="openConfirmationModal()">
                    Create account <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="login-footer">
                Already registered? <a href="${pageContext.request.contextPath}/entrepreneur/login">Sign in</a>
            </div>
        </div>
    </main>

    <!-- Confirmation Modal Card Matching Mobile & Martial Arts -->
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
                    <span class="label">Full Name:</span>
                    <span class="value" id="revName">—</span>
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

        function showAlert(msg, isError = true) {
            const el = document.getElementById('jsAlert');
            el.className = 'alert-box ' + (isError ? 'alert-error' : 'alert-success');
            el.innerHTML = '<i class="bi ' + (isError ? 'bi-exclamation-circle-fill' : 'bi-check-circle-fill') + '"></i> ' + msg;
            el.style.display = 'flex';
            window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' });
        }

        function hideAlert() {
            document.getElementById('jsAlert').style.display = 'none';
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
                bar.style.backgroundColor = (i <= score) ? colors[score] : '#E2E8F0';
            }
            document.getElementById('strLabel').textContent = labels[score];
        }

        async function handleSendOtp() {
            hideAlert();
            const email = document.getElementById('email').value.trim();
            if (!email || !email.includes('@') || !email.includes('.')) {
                showAlert('Please enter a valid email address first.');
                return;
            }

            const btn = document.getElementById('btnSendOtp');
            btn.disabled = true;
            document.getElementById('sendOtpText').textContent = 'Sending...';

            try {
                const res = await fetch('${pageContext.request.contextPath}/api/entrepreneur/otp/send-email', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email })
                });
                const data = await res.json();

                if (data.success) {
                    isOtpSent = true;
                    document.getElementById('otpGroup').style.display = 'block';
                    showAlert('OTP sent to ' + email, false);
                    alert('OTP sent to your email (' + email + ')! Please check your inbox or spam folder.');
                    startResendTimer(60);
                } else {
                    btn.disabled = false;
                    document.getElementById('sendOtpText').textContent = 'Send email OTP';
                    showAlert(data.error || data.message || 'Failed to send OTP. Please check the email.');
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

            if (otp.length !== 6) {
                showAlert('Please enter the 6-digit OTP.');
                return;
            }

            const btn = document.getElementById('btnVerifyOtp');
            btn.disabled = true;
            btn.textContent = 'Verifying...';

            try {
                const res = await fetch('${pageContext.request.contextPath}/api/entrepreneur/otp/verify-email', {
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
                    showAlert('Email verified successfully!', false);
                    alert('Email verified successfully! You can now complete registration.');
                } else {
                    showAlert(data.error || data.message || 'Invalid or expired OTP. Please try again.');
                }
            } catch (err) {
                btn.disabled = false;
                btn.textContent = 'Verify';
                showAlert('Network error while verifying OTP.');
            }
        }

        function openConfirmationModal() {
            hideAlert();
            const name = document.getElementById('fullName').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const email = document.getElementById('email').value.trim();
            const pass = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('termsCheck').checked;

            if (!name) { showAlert('Full name is required.'); return; }
            if (!phone || phone.length !== 10) { showAlert('Valid 10-digit mobile number is required.'); return; }
            if (!email || !email.includes('@')) { showAlert('Valid email address is required.'); return; }
            if (!isOtpVerified) { showAlert('Please verify your email OTP before registering.'); return; }
            if (!pass || pass.length < 6) { showAlert('Password must be at least 6 characters.'); return; }
            if (pass !== confirm) { showAlert('Passwords do not match.'); return; }
            if (!terms) { showAlert('Please accept the Terms & Privacy Policy.'); return; }

            document.getElementById('revName').textContent = name;
            document.getElementById('revPhone').textContent = phone;
            document.getElementById('revEmail').textContent = email;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function closeConfirmationModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function submitRegistration() {
            document.getElementById('regForm').submit();
        }
    </script>
</body>
</html>
