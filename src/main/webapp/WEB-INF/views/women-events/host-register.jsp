<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Become an Event Host — Women Safety App</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <style>
        :root {
            --primary-navy: #1e1b4b;
            --primary-pink: #f43f5e;
            --soft-pink: #fff1f2;
            --bg-soft: #faf7f8;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-clr: #e2e8f0;
            --gradient-main: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --success-bg: #ecfdf5;
            --success-text: #047857;
            --danger-bg: #fee2e2;
            --danger-text: #b91c1c;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; min-height: 100vh; display: block; color: var(--text-dark); background: var(--bg-soft); }
        
        .split-layout { display: flex; width: 100%; min-height: 100vh; }
        
        /* Left Panel */
        .left-panel {
            flex: 0.85;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 45%, #f43f5e 100%);
            padding: 60px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-right: 1px solid var(--border-clr);
            position: relative;
        }
        .icon-circle {
            width: 70px; height: 70px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin-bottom: 35px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .welcome-title { font-size: 2.6rem; font-weight: 800; line-height: 1.15; margin-bottom: 18px; color: white; }
        .welcome-title span { color: var(--primary-pink); }
        .welcome-desc { color: rgba(255,255,255,0.9); font-size: 1.05rem; line-height: 1.6; margin-bottom: 45px; max-width: 90%; font-weight: 300; }
        
        .feature-item { display: flex; align-items: flex-start; gap: 18px; margin-bottom: 25px; }
        .feature-icon { 
            width: 48px; height: 48px; min-width: 48px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
        }
        .feature-text h5 { font-size: 1.05rem; font-weight: 700; margin-bottom: 4px; color: white; }
        .feature-text p { font-size: 0.9rem; color: rgba(255,255,255,0.8); margin: 0; line-height: 1.45; }
        
        /* Right Panel */
        .right-panel {
            flex: 1.15;
            padding: 50px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: white;
            overflow-y: auto;
        }
        
        .form-container { width: 100%; max-width: 540px; }
        
        .form-header { display: flex; align-items: center; gap: 14px; margin-bottom: 30px; }
        .form-header .icon {
            width: 46px; height: 46px; border-radius: 12px; border: 1.5px solid var(--border-clr); background: var(--soft-pink);
            color: var(--primary-pink); display: flex; align-items: center; justify-content: center; font-size: 1.35rem;
        }
        .form-header h2 { font-size: 1.75rem; font-weight: 800; color: var(--primary-navy); margin: 0; border-left: 4px solid var(--primary-pink); padding-left: 14px; }
        
        .input-group-custom { margin-bottom: 20px; position: relative; }
        .input-group-custom label { display: block; font-size: 0.88rem; font-weight: 600; margin-bottom: 8px; color: var(--text-dark); }
        .input-wrap { position: relative; display: flex; align-items: center; }
        .input-wrap i.prefix { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1.1rem; }
        .input-wrap i.suffix { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1.1rem; cursor: pointer; }
        
        .input-wrap input {
            width: 100%; padding: 13px 14px 13px 44px; border: 1.5px solid var(--border-clr);
            border-radius: 10px; font-family: inherit; font-size: 0.95rem; color: var(--text-dark); outline: none; transition: 0.2s;
        }
        .input-wrap input::placeholder { color: #94a3b8; font-weight: 400; }
        .input-wrap input:focus { border-color: var(--primary-pink); box-shadow: 0 0 0 3.5px rgba(244,63,94,0.1); background: white; }
        
        .btn-action-inline {
            padding: 12px 18px; background: var(--primary-navy); color: white; border: none; border-radius: 10px;
            font-family: inherit; font-size: 0.88rem; font-weight: 600; cursor: pointer; transition: 0.2s; white-space: nowrap; margin-left: 8px;
        }
        .btn-action-inline:hover { background: #2e2a72; }
        .btn-action-inline:disabled { background: #cbd5e1; cursor: not-allowed; }
        
        .verified-badge {
            display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: var(--success-bg);
            color: var(--success-text); border-radius: 20px; font-size: 0.82rem; font-weight: 700; margin-top: 6px; border: 1px solid #a7f3d0;
        }

        .terms-wrap { display: flex; align-items: center; gap: 10px; font-size: 0.88rem; color: var(--text-muted); margin: 15px 0 25px; }
        .terms-wrap input { width: 18px; height: 18px; accent-color: var(--primary-pink); cursor: pointer; }

        .btn-submit {
            width: 100%; padding: 16px; background: var(--gradient-main); color: white;
            border: none; border-radius: 12px; font-family: inherit; font-size: 1.05rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer;
            transition: 0.3s; box-shadow: 0 6px 18px rgba(244, 63, 94, 0.25);
        }
        .btn-submit:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 10px 22px rgba(244, 63, 94, 0.35); }
        .btn-submit:disabled { opacity: 0.6; cursor: not-allowed; transform: none; box-shadow: none; }
        
        .signin-link { text-align: center; margin-top: 22px; font-size: 0.92rem; color: var(--text-muted); }
        .signin-link a { color: var(--primary-pink); font-weight: 700; text-decoration: none; }
        .signin-link a:hover { text-decoration: underline; }

        .alert-custom { padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; font-weight: 500; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .alert-custom.danger { background: var(--danger-bg); color: var(--danger-text); border: 1px solid #fca5a5; }
        .alert-custom.success { background: var(--success-bg); color: var(--success-text); border: 1px solid #a7f3d0; }
        
        @media (max-width: 992px) {
            .split-layout { flex-direction: column; display: block; }
            .left-panel { padding: 35px 20px; min-height: auto; text-align: center; align-items: center; }
            .welcome-desc { text-align: center; margin: 0 auto 20px; }
            .feature-item { display: none; }
            .right-panel { padding: 35px 20px; display: block; height: auto; border-top: 1px solid var(--border-clr); }
        }
    </style>
</head>
<body>

<div class="split-layout">
    <!-- Left Visual Panel -->
    <div class="left-panel">
        <div class="icon-circle">
            <i class="bi bi-people-fill"></i>
        </div>
        <h2 class="welcome-title">Become a Women<br><span>Event Organizer!</span></h2>
        <p class="welcome-desc">Create your host account in seconds. Complete email OTP verification to get started.</p>
        
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
            <div class="feature-text">
                <h5>Verified Community</h5>
                <p>Ensure safety & trust for women attendees.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-calendar2-heart"></i></div>
            <div class="feature-text">
                <h5>Host Workshops & Events</h5>
                <p>Organize wellness, safety, and career sessions.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-qr-code-scan"></i></div>
            <div class="feature-text">
                <h5>Easy Ticket Check-in</h5>
                <p>Manage registrations with digital ticket verification.</p>
            </div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="right-panel">
        <div class="form-container">
            <div class="form-header">
                <div class="icon"><i class="bi bi-person-plus"></i></div>
                <h2>Host Quick Register</h2>
            </div>

            <div id="statusAlert" class="alert-custom danger" style="display: none;">
                <i class="bi bi-exclamation-triangle-fill"></i> <span id="alertText"></span>
            </div>

            <form id="quickRegisterForm" onsubmit="handleRegistration(event)">
                <!-- Full Name -->
                <div class="input-group-custom">
                    <label>Full Name *</label>
                    <div class="input-wrap">
                        <i class="bi bi-person prefix"></i>
                        <input type="text" id="fullName" name="fullName" placeholder="e.g. Anjali Sharma" required minlength="2"/>
                    </div>
                </div>

                <!-- Email & OTP Step -->
                <div class="input-group-custom">
                    <label>Email Address *</label>
                    <div class="input-wrap">
                        <i class="bi bi-envelope prefix"></i>
                        <input type="email" id="email" name="email" placeholder="organizer@example.com" required/>
                        <button type="button" id="btnSendOtp" class="btn-action-inline" onclick="sendOtp()">Send OTP</button>
                    </div>
                </div>

                <!-- OTP Input Section (Hidden initially) -->
                <div id="otpSection" class="input-group-custom" style="display: none;">
                    <label>Enter 6-Digit Email OTP *</label>
                    <div class="input-wrap">
                        <i class="bi bi-shield-lock prefix"></i>
                        <input type="text" id="emailOtp" placeholder="6-digit OTP" maxlength="6" pattern="^\d{6}$"/>
                        <button type="button" id="btnVerifyOtp" class="btn-action-inline" onclick="verifyOtp()">Verify OTP</button>
                    </div>
                    <div id="verifiedBadge" class="verified-badge" style="display: none;">
                        <i class="bi bi-check-circle-fill"></i> Email Verified Successfully
                    </div>
                </div>

                <!-- Phone Number -->
                <div class="input-group-custom">
                    <label>Phone Number (10 Digits) *</label>
                    <div class="input-wrap">
                        <i class="bi bi-telephone prefix"></i>
                        <input type="text" id="phone" name="phone" placeholder="9876543210" required pattern="^\d{10}$" maxlength="10"/>
                    </div>
                </div>

                <!-- Password & Confirm Password -->
                <div class="input-group-custom">
                    <label>Password (Min 6 Characters) *</label>
                    <div class="input-wrap">
                        <i class="bi bi-lock prefix"></i>
                        <input type="password" id="password" name="password" placeholder="•••••••••" required minlength="6"/>
                        <i class="bi bi-eye suffix" onclick="togglePass('password')"></i>
                    </div>
                </div>

                <div class="input-group-custom">
                    <label>Confirm Password *</label>
                    <div class="input-wrap">
                        <i class="bi bi-lock-fill prefix"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="•••••••••" required minlength="6"/>
                        <i class="bi bi-eye suffix" onclick="togglePass('confirmPassword')"></i>
                    </div>
                </div>

                <!-- Terms Checkbox -->
                <div class="terms-wrap">
                    <input type="checkbox" id="acceptedTerms" required/>
                    <label for="acceptedTerms">I accept the Terms & Conditions and Safety Policies *</label>
                </div>

                <!-- Submit Button -->
                <button type="submit" id="btnSubmitAccount" class="btn-submit" disabled>
                    <i class="bi bi-person-plus-fill"></i> Create Host Account
                </button>

                <p class="signin-link">
                    Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login">Sign in here</a>
                </p>
            </form>
        </div>
    </div>
</div>

<script>
    let isEmailVerified = false;
    const contextPath = '${pageContext.request.contextPath}';

    function showAlert(msg, isSuccess = false) {
        const box = document.getElementById('statusAlert');
        const text = document.getElementById('alertText');
        box.className = 'alert-custom ' + (isSuccess ? 'success' : 'danger');
        box.querySelector('i').className = 'bi ' + (isSuccess ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill');
        text.innerText = msg;
        box.style.display = 'flex';
    }

    function hideAlert() {
        document.getElementById('statusAlert').style.display = 'none';
    }

    function togglePass(id) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
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
        btn.innerText = 'Sending...';

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
                btn.innerText = 'Resend OTP';
            } else {
                showAlert(data.error || 'Failed to send OTP.');
            }
        } catch (e) {
            showAlert('Network error while sending OTP.');
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
                btn.style.display = 'none';
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
