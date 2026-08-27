<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Doctor Registration | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --rose-soft: #FFF1F2;
            --rose-border: #FECDD3;
            --navy: #1E293B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
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
            background: #fff;
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
            display: flex; align-items: center; gap: 10px;
            font-size: 1.15rem; font-weight: 800; color: var(--navy); text-decoration: none;
        }
        .header-brand i { color: var(--primary); font-size: 1.3rem; }
        .header-links a {
            color: var(--text-gray); text-decoration: none; font-size: 0.9rem; font-weight: 600;
        }
        .header-links a:hover { color: var(--primary); }
        .main-container {
            flex: 1; max-width: 560px; width: 100%; margin: 28px auto 40px; padding: 0 16px;
        }
        .info-banner {
            background: var(--rose-soft);
            border: 1px solid var(--rose-border);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
        }
        .info-banner h1 { font-size: 1.25rem; font-weight: 800; margin-bottom: 6px; }
        .info-banner p { font-size: 0.9rem; color: var(--text-gray); line-height: 1.5; }
        .form-card, .preview-card, .success-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block; font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 6px;
        }
        .form-input {
            width: 100%; padding: 12px 14px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.95rem; font-family: inherit; color: var(--navy); background: #fff;
        }
        .form-input:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-input.is-invalid { border-color: var(--error); background: #fff5f5; }
        .password-wrap { position: relative; }
        .password-wrap .form-input { padding-right: 46px; }
        .password-toggle {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: var(--text-gray); cursor: pointer;
            padding: 4px; font-size: 1.1rem;
        }
        .password-toggle:hover { color: var(--primary); }
        .otp-row { display: flex; gap: 10px; align-items: stretch; }
        .otp-row .form-input { flex: 1; min-width: 0; }
        .btn-secondary, .btn-primary, .btn-ghost {
            border-radius: 10px; font-weight: 700; font-size: 0.95rem; cursor: pointer;
            padding: 12px 18px; border: none; font-family: inherit; transition: 0.2s;
        }
        .btn-primary { background: var(--primary); color: #fff; width: 100%; }
        .btn-primary:hover:not(:disabled) { background: var(--primary-hover); }
        .btn-primary:disabled { opacity: 0.55; cursor: not-allowed; }
        .btn-secondary {
            background: var(--rose-soft); color: var(--primary);
            border: 1px solid var(--rose-border); white-space: nowrap;
        }
        .btn-secondary:hover:not(:disabled) { background: #ffe4e6; }
        .btn-secondary:disabled { opacity: 0.6; cursor: not-allowed; }
        .btn-ghost {
            background: #fff; color: var(--navy); border: 1px solid var(--border-color); width: 100%;
        }
        .btn-ghost:hover { background: var(--bg-page); }
        .btn-row { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 8px; }
        .btn-row .btn-primary, .btn-row .btn-ghost { flex: 1; min-width: 140px; width: auto; }
        .error-msg { display: none; color: var(--error); font-size: 0.78rem; margin-top: 6px; font-weight: 600; }
        .hint { font-size: 0.78rem; color: var(--text-gray); margin-top: 6px; }
        .otp-ok { display: none; color: var(--success); font-size: 0.82rem; font-weight: 600; margin-top: 8px; }
        .checkbox-group {
            display: flex; align-items: flex-start; gap: 10px; margin: 8px 0 22px;
        }
        .checkbox-group input { margin-top: 3px; width: 18px; height: 18px; accent-color: var(--primary); }
        .checkbox-group label { font-size: 0.85rem; color: var(--text-gray); font-weight: 500; line-height: 1.45; }
        .checkbox-group a { color: var(--primary); font-weight: 600; text-decoration: none; }
        .alert {
            padding: 12px 14px; border-radius: 10px; font-size: 0.88rem; font-weight: 600; margin-bottom: 18px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #fecaca; }
        .login-link { text-align: center; margin-top: 22px; font-size: 0.9rem; color: var(--text-gray); }
        .login-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .section-title {
            font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.04em;
            color: var(--primary); margin: 18px 0 10px; padding-bottom: 6px; border-bottom: 1px solid var(--rose-border);
        }
        .preview-row {
            display: flex; justify-content: space-between; gap: 12px;
            padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 0.92rem;
        }
        .preview-row:last-child { border-bottom: none; }
        .preview-row .k { color: var(--text-gray); font-weight: 500; }
        .preview-row .v { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }
        .success-card { text-align: center; padding: 40px 28px; }
        .success-icon {
            width: 72px; height: 72px; border-radius: 50%;
            background: var(--success-bg); color: var(--success);
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 2rem; margin-bottom: 18px;
        }
        .success-card h2 { font-size: 1.4rem; font-weight: 800; margin-bottom: 10px; }
        .success-card p { color: var(--text-gray); font-size: 0.95rem; line-height: 1.6; margin-bottom: 10px; }
        .success-note {
            background: var(--rose-soft); border: 1px solid var(--rose-border);
            border-radius: 12px; padding: 12px 14px; font-size: 0.85rem; color: var(--navy);
            margin: 18px 0 24px; text-align: left;
        }
        @media (max-width: 480px) {
            .app-header { padding: 12px 16px; }
            .form-card, .preview-card, .success-card { padding: 22px 16px; }
            .otp-row { flex-direction: column; }
            .btn-secondary { width: 100%; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/index.html">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"
                 style="height:32px;width:32px;border-radius:8px;object-fit:cover;">
            Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/doctors/login">Doctor Login</a>
        </div>
    </header>

    <main class="main-container">
        <c:choose>
            <c:when test="${registrationSuccess}">
                <div class="success-card" id="successPanel">
                    <div class="success-icon"><i class="bi bi-check-lg"></i></div>
                    <h2>Registration Successful</h2>
                    <p>Your Doctor account has been created<c:if test="${not empty registeredName}"> for <strong>${registeredName}</strong></c:if>.</p>
                    <p>Your profile can now be completed and submitted for verification.</p>
                    <div class="success-note">
                        Registration does not mean admin approval. After login, complete your professional profile so an admin can review your application.
                    </div>
                    <a class="btn-primary" style="display:inline-block;text-decoration:none;max-width:280px;"
                       href="${pageContext.request.contextPath}/doctors/login">Continue to Login</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="info-banner">
                    <h1>Join as a Women Doctor</h1>
                    <p>Create your account with email OTP verification. Complete clinic details after login.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>

                <!-- FORM -->
                <div class="form-card" id="formPanel">
                    <form id="registerForm" action="${pageContext.request.contextPath}/doctors/register" method="post" novalidate>
                        <div class="form-group">
                            <label for="fullName">Full name *</label>
                            <input type="text" id="fullName" name="fullName" class="form-input"
                                   value="${fullName != null ? fullName : ''}"
                                   placeholder="e.g. Dr. Priya Sharma" required autocomplete="name">
                            <div class="error-msg" id="nameError">Full name is required</div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone *</label>
                            <input type="tel" id="phone" name="phone" class="form-input"
                                   value="${phone != null ? phone : ''}"
                                   placeholder="10-digit mobile" required maxlength="10" inputmode="numeric" autocomplete="tel">
                            <div class="error-msg" id="phoneError">Phone number must be exactly 10 digits</div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email *</label>
                            <div class="otp-row">
                                <input type="email" id="email" name="email" class="form-input"
                                       value="${email != null ? email : ''}"
                                       placeholder="doctor@example.com" required autocomplete="email">
                                <button type="button" id="sendOtpBtn" class="btn-secondary">Send OTP</button>
                            </div>
                            <div class="error-msg" id="emailError">Enter a valid email address</div>
                        </div>

                        <div class="form-group" id="otpGroup" style="display:none;">
                            <label for="otpInput">Email OTP *</label>
                            <div class="otp-row">
                                <input type="text" id="otpInput" class="form-input" placeholder="Enter OTP" maxlength="6" inputmode="numeric" autocomplete="one-time-code">
                                <button type="button" id="verifyOtpBtn" class="btn-secondary">Verify</button>
                            </div>
                            <div class="error-msg" id="otpError">Invalid or expired email OTP</div>
                            <div class="otp-ok" id="otpSuccess"><i class="bi bi-check-circle-fill"></i> Email verified</div>
                        </div>

                        <div class="form-group">
                            <label for="password">Password *</label>
                            <div class="password-wrap">
                                <input type="password" id="password" name="password" class="form-input"
                                       placeholder="Min 6 chars, number + special" required autocomplete="new-password">
                                <button type="button" class="password-toggle" data-target="password" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="hint">At least 6 characters, including a number and a special character (!@#$%^&amp;*)</div>
                            <div class="error-msg" id="pwdError">Password must be at least 6 characters and include a number and special character</div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm password *</label>
                            <div class="password-wrap">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                                       placeholder="Re-enter password" required autocomplete="new-password">
                                <button type="button" class="password-toggle" data-target="confirmPassword" aria-label="Show confirm password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-msg" id="matchError">Passwords do not match</div>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="terms" name="acceptedTerms" value="true" required>
                            <label for="terms">I agree to the <a href="#">Terms &amp; Conditions</a> and <a href="#">Privacy Policy</a></label>
                        </div>
                        <div class="error-msg" id="termsError" style="margin-top:-14px;margin-bottom:14px;">You must accept the Terms and Privacy Policy</div>

                        <button type="button" id="reviewBtn" class="btn-primary" disabled>Review &amp; Continue</button>
                    </form>
                    <div class="login-link">Already registered? <a href="${pageContext.request.contextPath}/doctors/login">Login</a></div>
                </div>

                <!-- PREVIEW -->
                <div class="preview-card" id="previewPanel" style="display:none;">
                    <h2 style="font-size:1.2rem;font-weight:800;margin-bottom:6px;">Doctor Registration Review</h2>
                    <p style="color:var(--text-gray);font-size:0.9rem;margin-bottom:8px;">Confirm your details before creating your account.</p>

                    <div class="section-title">Personal Information</div>
                    <div class="preview-row"><span class="k">Full Name</span><span class="v" id="pvName">—</span></div>
                    <div class="preview-row"><span class="k">Email</span><span class="v" id="pvEmail">—</span></div>
                    <div class="preview-row"><span class="k">Phone</span><span class="v" id="pvPhone">—</span></div>

                    <div class="section-title">Account</div>
                    <div class="preview-row"><span class="k">Email</span><span class="v" style="color:var(--success);">Verified</span></div>
                    <div class="preview-row"><span class="k">Password</span><span class="v">••••••••</span></div>

                    <div class="section-title">Terms</div>
                    <div class="preview-row"><span class="k">Terms &amp; Privacy</span><span class="v" style="color:var(--success);">Accepted</span></div>

                    <div class="btn-row" style="margin-top:24px;">
                        <button type="button" id="editBtn" class="btn-ghost">Edit</button>
                        <button type="button" id="confirmSubmitBtn" class="btn-primary">Confirm &amp; Submit</button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <c:if test="${empty registrationSuccess}">
    <script>
        (function () {
            const ctx = '${pageContext.request.contextPath}';
            const form = document.getElementById('registerForm');
            const formPanel = document.getElementById('formPanel');
            const previewPanel = document.getElementById('previewPanel');
            const fullName = document.getElementById('fullName');
            const phone = document.getElementById('phone');
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const terms = document.getElementById('terms');
            const reviewBtn = document.getElementById('reviewBtn');
            const sendOtpBtn = document.getElementById('sendOtpBtn');
            const verifyOtpBtn = document.getElementById('verifyOtpBtn');
            const otpGroup = document.getElementById('otpGroup');
            const otpInput = document.getElementById('otpInput');
            const otpSuccess = document.getElementById('otpSuccess');
            const otpError = document.getElementById('otpError');
            const confirmSubmitBtn = document.getElementById('confirmSubmitBtn');
            const editBtn = document.getElementById('editBtn');

            let emailVerified = false;
            let submitting = false;

            const pwdRule = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
            const emailRule = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
            const phoneRule = /^\d{10}$/;

            document.querySelectorAll('.password-toggle').forEach(btn => {
                btn.addEventListener('click', () => {
                    const input = document.getElementById(btn.getAttribute('data-target'));
                    const icon = btn.querySelector('i');
                    if (input.type === 'password') {
                        input.type = 'text';
                        icon.classList.replace('bi-eye', 'bi-eye-slash');
                    } else {
                        input.type = 'password';
                        icon.classList.replace('bi-eye-slash', 'bi-eye');
                    }
                });
            });

            function showErr(id, show, msg) {
                const el = document.getElementById(id);
                if (!el) return;
                if (msg) el.textContent = msg;
                el.style.display = show ? 'block' : 'none';
            }

            function validateAll(showErrors) {
                let ok = true;
                const nameOk = fullName.value.trim().length > 0;
                const phoneOk = phoneRule.test(phone.value.trim());
                const emailOk = emailRule.test(email.value.trim());
                const pwdOk = pwdRule.test(password.value);
                const matchOk = confirmPassword.value.length > 0 && confirmPassword.value === password.value;
                const termsOk = terms.checked;

                if (showErrors) {
                    fullName.classList.toggle('is-invalid', !nameOk);
                    phone.classList.toggle('is-invalid', !phoneOk && phone.value.length > 0);
                    email.classList.toggle('is-invalid', !emailOk && email.value.length > 0);
                    password.classList.toggle('is-invalid', !pwdOk && password.value.length > 0);
                    confirmPassword.classList.toggle('is-invalid', !matchOk && confirmPassword.value.length > 0);
                    showErr('nameError', !nameOk);
                    showErr('phoneError', !phoneOk && (phone.value.length > 0 || showErrors));
                    showErr('emailError', !emailOk);
                    showErr('pwdError', !pwdOk && password.value.length > 0);
                    showErr('matchError', !matchOk && confirmPassword.value.length > 0);
                    showErr('termsError', !termsOk);
                    if (!emailVerified) {
                        showErr('emailError', true, 'Please verify your email via OTP first.');
                        ok = false;
                    }
                }

                ok = ok && nameOk && phoneOk && emailOk && pwdOk && matchOk && termsOk && emailVerified;
                reviewBtn.disabled = !(nameOk && phoneOk && emailOk && pwdOk && matchOk && termsOk && emailVerified);
                return ok;
            }

            [fullName, phone, email, password, confirmPassword, terms].forEach(el => {
                el.addEventListener('input', () => validateAll(false));
                el.addEventListener('change', () => validateAll(false));
            });

            let otpResendTimer = null;
            function armOtpResend(seconds) {
                if (otpResendTimer) clearInterval(otpResendTimer);
                let left = seconds;
                sendOtpBtn.disabled = true;
                sendOtpBtn.textContent = 'Resend in ' + left + 's';
                otpResendTimer = setInterval(() => {
                    left -= 1;
                    if (left <= 0) {
                        clearInterval(otpResendTimer);
                        otpResendTimer = null;
                        sendOtpBtn.disabled = false;
                        sendOtpBtn.textContent = 'Resend OTP';
                    } else {
                        sendOtpBtn.textContent = 'Resend in ' + left + 's';
                    }
                }, 1000);
            }

            sendOtpBtn.addEventListener('click', async () => {
                const emailVal = email.value.trim();
                if (!emailRule.test(emailVal)) {
                    email.classList.add('is-invalid');
                    showErr('emailError', true, 'Enter a valid email address');
                    return;
                }
                sendOtpBtn.disabled = true;
                sendOtpBtn.textContent = 'Sending...';
                showErr('emailError', false);
                try {
                    const res = await fetch(ctx + '/api/doctors/provider/otp/send-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: emailVal })
                    });
                    let data = {};
                    try { data = await res.json(); } catch (_) { data = {}; }
                    if (res.ok && data.success) {
                        otpGroup.style.display = 'block';
                        email.readOnly = true;
                        emailVerified = false;
                        otpSuccess.style.display = 'none';
                        otpInput.style.display = '';
                        verifyOtpBtn.style.display = '';
                        verifyOtpBtn.disabled = false;
                        verifyOtpBtn.textContent = 'Verify';
                        armOtpResend(60);
                        validateAll(false);
                    } else {
                        showErr('emailError', true, data.error || data.message || 'Failed to send OTP.');
                        sendOtpBtn.disabled = false;
                        sendOtpBtn.textContent = 'Send OTP';
                    }
                } catch (e) {
                    showErr('emailError', true, 'Network error. Try again.');
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.textContent = 'Send OTP';
                }
            });

            verifyOtpBtn.addEventListener('click', async () => {
                const emailVal = email.value.trim();
                const otpVal = otpInput.value.trim();
                if (!otpVal) return;
                verifyOtpBtn.disabled = true;
                verifyOtpBtn.textContent = 'Verifying...';
                try {
                    const res = await fetch(ctx + '/api/doctors/provider/otp/verify-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: emailVal, otp: otpVal })
                    });
                    const data = await res.json();
                    if (data.success) {
                        emailVerified = true;
                        otpInput.style.display = 'none';
                        verifyOtpBtn.style.display = 'none';
                        otpError.style.display = 'none';
                        otpSuccess.style.display = 'block';
                        showErr('emailError', false);
                        validateAll(false);
                    } else {
                        showErr('otpError', true, data.error || data.message || 'Invalid or expired email OTP');
                        verifyOtpBtn.disabled = false;
                        verifyOtpBtn.textContent = 'Verify';
                    }
                } catch (e) {
                    showErr('otpError', true, 'Network error. Try again.');
                    verifyOtpBtn.disabled = false;
                    verifyOtpBtn.textContent = 'Verify';
                }
            });

            reviewBtn.addEventListener('click', () => {
                if (!validateAll(true)) return;
                document.getElementById('pvName').textContent = fullName.value.trim();
                document.getElementById('pvEmail').textContent = email.value.trim();
                document.getElementById('pvPhone').textContent = phone.value.trim();
                formPanel.style.display = 'none';
                previewPanel.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });

            editBtn.addEventListener('click', () => {
                previewPanel.style.display = 'none';
                formPanel.style.display = 'block';
                submitting = false;
                confirmSubmitBtn.disabled = false;
                confirmSubmitBtn.textContent = 'Confirm & Submit';
            });

            confirmSubmitBtn.addEventListener('click', () => {
                if (submitting) return;
                if (!validateAll(true)) {
                    previewPanel.style.display = 'none';
                    formPanel.style.display = 'block';
                    return;
                }
                submitting = true;
                confirmSubmitBtn.disabled = true;
                confirmSubmitBtn.textContent = 'Submitting...';
                form.submit();
            });

            form.addEventListener('submit', (e) => {
                if (!validateAll(true)) {
                    e.preventDefault();
                    submitting = false;
                    confirmSubmitBtn.disabled = false;
                    confirmSubmitBtn.textContent = 'Confirm & Submit';
                }
            });

            validateAll(false);
        })();
    </script>
    </c:if>
</body>
</html>
