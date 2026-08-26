<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — Fight D Fear</title>
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
        }
        .header-links a:hover { color: var(--primary); }
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
            margin: 0;
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
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
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-field {
            position: relative;
        }
        .password-field .form-input {
            padding-right: 48px;
        }
        .password-toggle-btn {
            position: absolute;
            right: 10px;
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
        }
        .password-toggle-btn:hover,
        .password-toggle-btn:focus {
            color: var(--primary);
            outline: none;
            background: var(--rose-soft);
        }
        .password-toggle-btn i { font-size: 1.1rem; pointer-events: none; }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 5px; }
        .row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
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
            min-width: 11ch;
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
            margin-top: 8px;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-primary:disabled { background: #cbd5e1; cursor: not-allowed; transform: none; }
        .alert {
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.9rem;
            margin-bottom: 16px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #FECACA; }
        .alert-ok { background: var(--success-bg); color: var(--success); border: 1px solid #BBF7D0; }
        .terms {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            font-size: 0.85rem;
            color: var(--text-gray);
            margin: 12px 0 8px;
        }
        .footer-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
        .footer-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .otp-badge {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--success);
            display: none;
        }
        .otp-badge.show { display: inline; }
        .otp-status {
            font-size: 0.75rem;
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
        @media (max-width: 600px) {
            .row-2 { grid-template-columns: 1fr; }
            .form-card { padding: 22px 16px; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-heart-fill"></i> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </header>

    <div class="main-container">
        <div class="info-banner">
            <h2>Create your Fight D Fear account</h2>
            <p>Registration collects only what you need to sign in. Complete your profile later from the dashboard. Email OTP verification is required.</p>
        </div>

        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="alert alert-error" id="serverError"><i class="bi bi-exclamation-circle me-1"></i> ${error}</div>
            </c:if>
            <div class="alert alert-error" id="formError" style="display:none;"></div>

            <form action="${pageContext.request.contextPath}/users/register" method="post" id="userRegisterForm">
                <div class="form-group">
                    <label>Full name *</label>
                    <input type="text" name="fullName" id="fullName" class="form-input" required autocomplete="name">
                </div>

                <div class="form-group">
                    <label>Email Address *</label>
                    <input type="email" name="email" id="email" class="form-input" required autocomplete="email">
                    <div class="otp-row">
                        <button type="button" class="btn-secondary" id="btnSendEmailOtp">Send email OTP</button>
                    </div>
                    <div class="otp-row">
                        <input type="text" id="emailOtp" class="form-input otp-input" placeholder="6-digit OTP" maxlength="6" minlength="6" pattern="[0-9]{6}" inputmode="numeric" autocomplete="one-time-code" aria-label="6-digit email OTP">
                        <button type="button" class="btn-secondary" id="btnVerifyEmailOtp">Verify</button>
                        <span class="otp-badge" id="emailOtpOk"><i class="bi bi-check-circle-fill"></i> Verified</span>
                    </div>
                    <div class="otp-status info" id="emailOtpStatus"></div>
                    <div class="hint"><i class="bi bi-info-circle me-1"></i> Private login key used to authenticate account, verify identity, and send critical emergency alerts.</div>
                </div>

                <div class="form-group">
                    <label>Phone Number (10 digits) *</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input" required maxlength="10" pattern="\d{10}" inputmode="numeric">
                    <div id="phoneOtpSection">
                    <div class="otp-row">
                        <button type="button" class="btn-secondary" id="btnSendPhoneOtp">Send phone OTP</button>
                    </div>
                    <div class="otp-row">
                        <input type="text" id="phoneOtp" class="form-input otp-input" placeholder="6-digit OTP" maxlength="6" minlength="6" pattern="[0-9]{6}" inputmode="numeric" autocomplete="one-time-code" aria-label="6-digit phone OTP">
                        <button type="button" class="btn-secondary" id="btnVerifyPhoneOtp">Verify</button>
                        <span class="otp-badge" id="phoneOtpOk"><i class="bi bi-check-circle-fill"></i> Verified</span>
                    </div>
                    <div class="otp-status info" id="phoneOtpStatus"></div>
                    </div>
                    <div class="hint" id="phoneOtpHint"><i class="bi bi-info-circle me-1"></i> Enter your 10-digit mobile number — a real OTP will be sent by SMS when SMS is enabled on the server.</div>
                </div>

                <div class="row-2">
                    <div class="form-group">
                        <label>City / Location *</label>
                        <input type="text" name="city" id="city" class="form-input" required placeholder="e.g. Mumbai, New Delhi">
                        <div class="hint"><i class="bi bi-info-circle me-1"></i> Helps identify proximity self-defense centers & zone map overlays.</div>
                    </div>
                    <div class="form-group">
                        <label>Gender (optional)</label>
                        <select name="gender" id="gender" class="form-select">
                            <option value="">Prefer not to say</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                        <div class="hint"><i class="bi bi-info-circle me-1"></i> Helps customize buddy matching companion preferences.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Date of birth (optional)</label>
                    <input type="date" name="dob" id="dob" class="form-input"
                           max="<%= java.time.LocalDate.now() %>">
                    <div class="hint"><i class="bi bi-info-circle me-1"></i> Used optionally to verify safety cohorts.</div>
                </div>

                <div class="row-2">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <div class="password-field">
                            <input type="password" name="password" id="password" class="form-input" required autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="password"
                                    aria-label="Show password" title="Show password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div class="hint">Min 6 characters with a number and special character (!@#$%^&amp;*)</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm password *</label>
                        <div class="password-field">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" required autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="confirmPassword"
                                    aria-label="Show confirm password" title="Show confirm password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <label class="terms">
                    <input type="checkbox" name="acceptedTerms" id="acceptedTerms" value="true" required>
                    <span>I agree to the Terms &amp; Conditions and Privacy Policy *</span>
                </label>

                <button type="submit" class="btn-primary" id="btnSubmit" disabled>Create account</button>
                <p class="submit-hint" id="submitHint">Verify your email OTP to enable account creation.</p>
            </form>

            <p class="footer-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        </div>
    </div>

<script>
(function () {
    var ctx = '${pageContext.request.contextPath}';
    var emailVerified = false;
    var phoneVerified = true;
    var phoneOtpRequired = false;
    var phoneOtpSending = false;
    var phoneAutoSendTimer = null;
    var lastAutoSentPhone = '';
    var fetchOpts = { credentials: 'same-origin' };

    function markEmailVerified(email) {
        emailVerified = true;
        document.getElementById('emailOtpOk').classList.add('show');
        setStatus('emailOtpStatus', 'Email verified', 'ok');
        try {
            sessionStorage.setItem('regEmailVerified', email.toLowerCase());
        } catch (e) { /* ignore */ }
        refreshSubmit();
    }

    function restoreEmailVerified() {
        try {
            var saved = sessionStorage.getItem('regEmailVerified');
            var current = document.getElementById('email').value.trim().toLowerCase();
            if (saved && current && saved === current) {
                markEmailVerified(current);
            }
        } catch (e) { /* ignore */ }
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
                hint.innerHTML = '<i class="bi bi-info-circle me-1"></i> Phone number is saved for alerts. SMS verification is optional when SMS is not configured on the server.';
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
            if (!autoTriggered) alert('Enter a valid 10-digit phone first');
            return;
        }
        if (phoneOtpSending) return;
        if (autoTriggered && phone === lastAutoSentPhone) return;

        phoneOtpSending = true;
        var btn = document.getElementById('btnSendPhoneOtp');
        btn.disabled = true;
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
                document.getElementById('phoneOtp').focus();
            } else {
                setStatus('phoneOtpStatus', data.error || 'Failed to send OTP', 'err');
                if (!autoTriggered) alert(data.error || 'Failed to send OTP');
            }
        } catch (e) {
            setStatus('phoneOtpStatus', 'Network error sending OTP', 'err');
            if (!autoTriggered) alert('Network error sending OTP');
        } finally {
            phoneOtpSending = false;
            btn.disabled = false;
        }
    }

    bindOtpInput('emailOtp');
    bindOtpInput('phoneOtp');
    loadPhoneOtpStatus();
    restoreEmailVerified();

    document.getElementById('acceptedTerms').addEventListener('change', refreshSubmit);
    document.getElementById('email').addEventListener('input', function () {
        emailVerified = false;
        document.getElementById('emailOtpOk').classList.remove('show');
        setStatus('emailOtpStatus', '', '');
        try { sessionStorage.removeItem('regEmailVerified'); } catch (e) { /* ignore */ }
        refreshSubmit();
    });
    document.getElementById('phoneNumber').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
        phoneVerified = false;
        document.getElementById('phoneOtpOk').classList.remove('show');
        setStatus('phoneOtpStatus', '', '');
        lastAutoSentPhone = '';
        refreshSubmit();

        if (phoneOtpRequired && /^\d{10}$/.test(this.value.trim())) {
            clearTimeout(phoneAutoSendTimer);
            phoneAutoSendTimer = setTimeout(function () {
                sendPhoneOtp(true);
            }, 400);
        }
    });

    document.getElementById('btnSendEmailOtp').addEventListener('click', async function () {
        var email = document.getElementById('email').value.trim().toLowerCase();
        if (!email || email.indexOf('@') < 0) {
            alert('Enter a valid email first');
            return;
        }
        this.disabled = true;
        setStatus('emailOtpStatus', 'Sending OTP…', 'info');
        try {
            var res = await fetch(ctx + '/api/auth/otp/send-email', Object.assign({}, fetchOpts, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ email: email })
            }));
            var data = await res.json();
            if (data.success) {
                setStatus('emailOtpStatus', data.message || 'OTP sent to your email', 'ok');
                document.getElementById('emailOtp').focus();
            } else {
                setStatus('emailOtpStatus', data.error || 'Failed to send OTP', 'err');
                alert(data.error || 'Failed to send OTP');
            }
        } catch (e) {
            setStatus('emailOtpStatus', 'Network error sending OTP', 'err');
            alert('Network error sending OTP');
        } finally {
            this.disabled = false;
        }
    });

    document.getElementById('btnVerifyEmailOtp').addEventListener('click', async function () {
        var email = document.getElementById('email').value.trim().toLowerCase();
        var otp = document.getElementById('emailOtp').value.trim();
        if (!isValidOtp(otp)) {
            alert('Please enter the 6-digit OTP code.');
            return;
        }
        this.disabled = true;
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
                setStatus('emailOtpStatus', data.error || 'Invalid or expired OTP', 'err');
                alert(data.error || 'Invalid or expired OTP');
            }
        } catch (e) {
            setStatus('emailOtpStatus', 'Network error verifying OTP', 'err');
            alert('Network error verifying OTP');
        } finally {
            this.disabled = false;
        }
    });

    document.getElementById('btnSendPhoneOtp').addEventListener('click', function () {
        sendPhoneOtp(false);
    });

    document.getElementById('btnVerifyPhoneOtp').addEventListener('click', async function () {
        var phone = document.getElementById('phoneNumber').value.trim();
        var otp = document.getElementById('phoneOtp').value.trim();
        if (!/^\d{10}$/.test(phone)) {
            alert('Enter a valid 10-digit phone first');
            return;
        }
        if (!isValidOtp(otp)) {
            alert('Please enter the 6-digit OTP code.');
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
                setStatus('phoneOtpStatus', 'Phone verified', 'ok');
                refreshSubmit();
            } else {
                setStatus('phoneOtpStatus', data.error || 'Invalid or expired OTP', 'err');
                alert(data.error || 'Invalid or expired OTP');
            }
        } catch (e) {
            setStatus('phoneOtpStatus', 'Network error verifying OTP', 'err');
            alert('Network error verifying OTP');
        } finally {
            this.disabled = false;
        }
    });

    function showFormError(msg) {
        var el = document.getElementById('formError');
        if (!el) return;
        el.style.display = msg ? 'block' : 'none';
        el.innerHTML = msg ? '<i class="bi bi-exclamation-circle me-1"></i> ' + msg : '';
        if (msg) el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    document.getElementById('userRegisterForm').addEventListener('submit', async function (e) {
        e.preventDefault();
        showFormError('');

        var pass = document.getElementById('password').value;
        var confirm = document.getElementById('confirmPassword').value;
        var re = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
        if (!emailVerified) {
            alert('Please verify your email OTP first.');
            return;
        }
        if (!phoneVerified && phoneOtpRequired) {
            alert('Please verify your phone OTP first.');
            return;
        }
        if (!re.test(pass)) {
            alert('Password must be at least 6 characters and include a number and special character (!@#$%^&*).');
            return;
        }
        if (pass !== confirm) {
            alert('Passwords do not match.');
            return;
        }
        if (!document.getElementById('acceptedTerms').checked) {
            alert('Please accept the Terms & Conditions.');
            return;
        }

        var btn = document.getElementById('btnSubmit');
        btn.disabled = true;
        btn.textContent = 'Creating account…';

        var payload = {
            fullName: document.getElementById('fullName').value.trim(),
            email: document.getElementById('email').value.trim().toLowerCase(),
            phoneNumber: document.getElementById('phoneNumber').value.trim(),
            city: document.getElementById('city').value.trim(),
            dob: document.getElementById('dob').value.trim(),
            gender: document.getElementById('gender').value.trim(),
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
                try { sessionStorage.removeItem('regEmailVerified'); } catch (err) { /* ignore */ }
                window.location.href = data.redirectUrl;
                return;
            }
            showFormError(data.error || 'Registration failed. Please try again.');
        } catch (err) {
            showFormError('Network error. Could not complete registration.');
        } finally {
            btn.textContent = 'Create account';
            refreshSubmit();
        }
    });

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
</body>
</html>
