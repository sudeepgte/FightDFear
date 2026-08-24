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
        .otp-row input { flex: 1; min-width: 120px; }
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
                <div class="alert alert-error"><i class="bi bi-exclamation-circle me-1"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/users/register" method="post" enctype="multipart/form-data" id="userRegisterForm">
                <div class="form-group">
                    <label>Profile photo <span style="color:var(--text-gray);font-weight:500;">(optional)</span></label>
                    <input type="file" name="image" class="form-input" accept="image/*">
                </div>

                <div class="form-group">
                    <label>Full name *</label>
                    <input type="text" name="fullName" id="fullName" class="form-input" required autocomplete="name">
                </div>

                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" id="email" class="form-input" required autocomplete="email">
                    <div class="otp-row">
                        <button type="button" class="btn-secondary" id="btnSendEmailOtp">Send email OTP</button>
                        <input type="text" id="emailOtp" class="form-input" placeholder="6-digit OTP" maxlength="6" inputmode="numeric">
                        <button type="button" class="btn-secondary" id="btnVerifyEmailOtp">Verify</button>
                        <span class="otp-badge" id="emailOtpOk"><i class="bi bi-check-circle-fill"></i> Verified</span>
                    </div>
                    <div class="hint">We send a code to your inbox. Resend after cooldown if needed.</div>
                </div>

                <div class="row-2">
                    <div class="form-group">
                        <label>Phone (10 digits) *</label>
                        <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input" required maxlength="10" pattern="\d{10}" inputmode="numeric">
                        <div class="otp-row">
                            <button type="button" class="btn-secondary" id="btnSendPhoneOtp">Send phone OTP</button>
                            <input type="text" id="phoneOtp" class="form-input" placeholder="OTP" maxlength="6" inputmode="numeric">
                            <button type="button" class="btn-secondary" id="btnVerifyPhoneOtp">Verify</button>
                            <span class="otp-badge" id="phoneOtpOk"><i class="bi bi-check-circle-fill"></i> OK</span>
                        </div>
                        <div class="hint">Demo phone OTP: 123456 (same as mobile)</div>
                    </div>
                    <div class="form-group">
                        <label>Emergency contact *</label>
                        <input type="tel" name="emergencyContact" id="emergencyContact" class="form-input" required maxlength="10" pattern="\d{10}" inputmode="numeric">
                        <div class="hint">Must differ from your phone</div>
                    </div>
                </div>

                <div class="row-2">
                    <div class="form-group">
                        <label>Date of birth *</label>
                        <input type="date" name="dob" id="dob" class="form-input" required
                               max="<%= java.time.LocalDate.now() %>">
                    </div>
                    <div class="form-group">
                        <label>Gender (optional)</label>
                        <select name="gender" id="gender" class="form-select">
                            <option value="">Prefer not to say</option>
                            <option value="FEMALE">Female</option>
                            <option value="MALE">Male</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Preferred language *</label>
                    <select name="preferredLanguage" id="preferredLanguage" class="form-select" required>
                        <option>English</option>
                        <option>Hindi</option>
                        <option>Marathi</option>
                        <option>Tamil</option>
                        <option>Telugu</option>
                        <option>Kannada</option>
                        <option>Bengali</option>
                        <option>Gujarati</option>
                        <option>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Current location / address *</label>
                    <textarea name="homeAddress" id="homeAddress" class="form-input" rows="2" required placeholder="Address or Google Maps link"></textarea>
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
            </form>

            <p class="footer-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        </div>
    </div>

<script>
(function () {
    var ctx = '${pageContext.request.contextPath}';
    var emailVerified = false;
    var phoneVerified = false;

    function refreshSubmit() {
        document.getElementById('btnSubmit').disabled = !(emailVerified && phoneVerified && document.getElementById('acceptedTerms').checked);
    }

    document.getElementById('acceptedTerms').addEventListener('change', refreshSubmit);
    document.getElementById('email').addEventListener('input', function () {
        emailVerified = false;
        document.getElementById('emailOtpOk').classList.remove('show');
        refreshSubmit();
    });
    document.getElementById('phoneNumber').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
        phoneVerified = false;
        document.getElementById('phoneOtpOk').classList.remove('show');
        refreshSubmit();
    });
    document.getElementById('emergencyContact').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

    document.getElementById('btnSendEmailOtp').addEventListener('click', async function () {
        var email = document.getElementById('email').value.trim().toLowerCase();
        if (!email || email.indexOf('@') < 0) {
            alert('Enter a valid email first');
            return;
        }
        this.disabled = true;
        try {
            var res = await fetch(ctx + '/api/auth/otp/send-email', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ email: email })
            });
            var data = await res.json();
            if (data.success) {
                alert(data.message || 'OTP sent to your email');
            } else {
                alert(data.error || 'Failed to send OTP');
            }
        } catch (e) {
            alert('Network error sending OTP');
        } finally {
            this.disabled = false;
        }
    });

    document.getElementById('btnVerifyEmailOtp').addEventListener('click', async function () {
        var email = document.getElementById('email').value.trim().toLowerCase();
        var otp = document.getElementById('emailOtp').value.trim();
        if (!otp) { alert('Enter the OTP code'); return; }
        try {
            var res = await fetch(ctx + '/api/auth/otp/verify-email', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify({ email: email, otp: otp })
            });
            var data = await res.json();
            if (data.success) {
                emailVerified = true;
                document.getElementById('emailOtpOk').classList.add('show');
                refreshSubmit();
            } else {
                alert(data.error || 'Invalid or expired OTP');
            }
        } catch (e) {
            alert('Network error verifying OTP');
        }
    });

    document.getElementById('btnSendPhoneOtp').addEventListener('click', function () {
        var phone = document.getElementById('phoneNumber').value.trim();
        if (!/^\d{10}$/.test(phone)) {
            alert('Enter a valid 10-digit phone first');
            return;
        }
        alert('Demo OTP sent for Phone. Use 123456.');
    });

    document.getElementById('btnVerifyPhoneOtp').addEventListener('click', function () {
        var otp = document.getElementById('phoneOtp').value.trim();
        if (otp === '123456') {
            phoneVerified = true;
            document.getElementById('phoneOtpOk').classList.add('show');
            refreshSubmit();
        } else {
            alert('Invalid OTP. Demo code is 123456.');
        }
    });

    document.getElementById('userRegisterForm').addEventListener('submit', function (e) {
        var pass = document.getElementById('password').value;
        var confirm = document.getElementById('confirmPassword').value;
        var phone = document.getElementById('phoneNumber').value.trim();
        var emergency = document.getElementById('emergencyContact').value.trim();
        var re = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
        if (!emailVerified) {
            e.preventDefault();
            alert('Please verify your email OTP first.');
            return;
        }
        if (!phoneVerified) {
            e.preventDefault();
            alert('Please verify your phone OTP first.');
            return;
        }
        if (!re.test(pass)) {
            e.preventDefault();
            alert('Password must be at least 6 characters and include a number and special character (!@#$%^&*).');
            return;
        }
        if (pass !== confirm) {
            e.preventDefault();
            alert('Passwords do not match.');
            return;
        }
        if (phone === emergency) {
            e.preventDefault();
            alert('Emergency contact should differ from your phone.');
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
