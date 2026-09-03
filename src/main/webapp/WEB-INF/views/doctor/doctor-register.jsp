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
            --rose-border: #FECDD3;
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
            margin-bottom: 20px;
        }
        .info-banner h1 { font-size: 1.25rem; font-weight: 800; margin-bottom: 6px; }
        .info-banner p { font-size: 0.9rem; color: var(--text-gray); line-height: 1.5; }
        .form-card, .success-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block; font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 6px;
        }
        .form-input {
            width: 100%; padding: 12px 14px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.95rem; font-family: inherit; color: var(--navy); background: #fff;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-input.is-invalid { border-color: var(--error); background: #fff5f5; }
        .form-input:read-only { background: #F8FAFC; color: #475569; }
        .password-wrap { position: relative; }
        .password-wrap .form-input { padding-right: 46px; }
        .password-toggle {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: var(--text-gray); cursor: pointer;
            padding: 4px; font-size: 1.1rem;
        }
        .password-toggle:hover { color: var(--primary); }
        .strength-row { display: flex; align-items: center; gap: 8px; margin-top: 8px; }
        .strength-bars { display: flex; gap: 4px; flex: 1; }
        .strength-bar { height: 4px; flex: 1; border-radius: 2px; background: #E2E8F0; }
        .strength-text { font-size: 0.75rem; font-weight: 600; color: var(--text-gray); min-width: 52px; }
        .otp-row { display: flex; gap: 10px; align-items: stretch; }
        .otp-row .form-input { flex: 1; min-width: 0; }
        .btn-otp, .btn-submit, .btn-modal-cancel, .btn-modal-confirm {
            border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer;
            padding: 12px 16px; border: none; font-family: inherit; transition: 0.2s;
        }
        .btn-otp {
            background: var(--rose-soft); color: var(--primary);
            border: 1px solid var(--rose-border); white-space: nowrap;
        }
        .btn-otp.btn-otp-solid {
            background: var(--primary); color: #fff; border-color: var(--primary);
        }
        .btn-otp:hover:not(:disabled) { background: #ffe4e6; }
        .btn-otp.btn-otp-solid:hover:not(:disabled) { background: var(--primary-hover); border-color: var(--primary-hover); color: #fff; }
        .btn-otp:disabled, .btn-submit:disabled, .btn-modal-confirm:disabled {
            opacity: 0.55; cursor: not-allowed; box-shadow: none; transform: none;
        }
        .btn-submit {
            width: 100%; background: var(--primary); color: #fff;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex; align-items: center; justify-content: center; gap: 8px;
            margin-top: 8px;
        }
        .btn-submit:hover:not(:disabled) {
            background: var(--primary-hover); transform: translateY(-1px);
        }
        .error-msg { display: none; color: var(--error); font-size: 0.78rem; margin-top: 6px; font-weight: 600; }
        .hint { font-size: 0.78rem; color: var(--text-gray); margin-top: 6px; }
        .otp-ok { display: none; color: var(--success); font-size: 0.82rem; font-weight: 600; margin-top: 8px; }
        .checkbox-group {
            display: flex; align-items: flex-start; gap: 10px; margin: 8px 0 18px;
        }
        .checkbox-group input { margin-top: 3px; width: 18px; height: 18px; accent-color: var(--primary); }
        .checkbox-group label { font-size: 0.85rem; color: var(--text-gray); font-weight: 500; line-height: 1.45; }
        .checkbox-group a { color: var(--primary); font-weight: 600; text-decoration: none; }
        .alert-box {
            padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 16px;
            display: none; align-items: center; gap: 8px;
        }
        .alert-error { background: var(--error-bg); border: 1px solid #FECACA; color: var(--error); }
        .alert-success { background: var(--success-bg); border: 1px solid #BBF7D0; color: var(--success); }
        .server-error {
            display: flex; padding: 12px 14px; border-radius: 10px; font-size: 0.88rem; font-weight: 600;
            margin-bottom: 18px; background: var(--error-bg); color: var(--error); border: 1px solid #fecaca; gap: 8px;
        }
        .login-link { text-align: center; margin-top: 20px; font-size: 0.9rem; color: var(--text-gray); }
        .login-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
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
        .btn-success-cta {
            display: inline-flex; align-items: center; justify-content: center; gap: 8px;
            max-width: 280px; width: 100%; text-decoration: none;
            background: var(--primary); color: #fff; padding: 13px 18px; border-radius: 12px;
            font-weight: 700; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        }
        .btn-success-cta:hover { background: var(--primary-hover); }

        /* Martial Arts–style confirmation modal */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center;
            z-index: 100; padding: 16px;
        }
        .modal-overlay.open { display: flex; }
        .modal-card {
            background: #fff; border-radius: 20px; max-width: 460px; width: 100%;
            padding: 24px; box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            animation: popIn 0.2s ease-out;
            max-height: calc(100vh - 32px); overflow-y: auto;
        }
        @keyframes popIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .modal-header { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; }
        .modal-header .icon-wrap {
            width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
            background: var(--rose-soft); color: var(--primary);
            display: flex; align-items: center; justify-content: center; font-size: 1.25rem;
        }
        .modal-header h3 { font-size: 1.15rem; font-weight: 800; color: var(--navy); }
        .modal-header p { font-size: 0.8rem; color: var(--text-gray); margin-top: 2px; }
        .modal-body {
            background: var(--bg-page); border: 1px solid var(--border-color);
            border-radius: 12px; padding: 14px; margin-bottom: 20px;
        }
        .review-row {
            display: flex; justify-content: space-between; gap: 12px;
            padding: 10px 0; border-bottom: 1px dashed var(--border-color); font-size: 0.88rem;
        }
        .review-row:last-child { border-bottom: none; }
        .review-row .label { color: var(--text-gray); font-weight: 500; }
        .review-row .value { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }
        .modal-actions { display: flex; gap: 10px; }
        .btn-modal-cancel {
            flex: 1; background: #fff; color: var(--navy); border: 1px solid var(--border-color);
        }
        .btn-modal-cancel:hover { background: var(--bg-page); }
        .btn-modal-confirm {
            flex: 1.5; background: var(--primary); color: #fff;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
        }
        .btn-modal-confirm:hover:not(:disabled) { background: var(--primary-hover); }

        @media (max-width: 600px) {
            .app-header { padding: 12px 16px; }
            .form-card, .success-card { padding: 22px 16px; }
            .otp-row { flex-direction: column; }
            .btn-otp { width: 100%; }
            .modal-actions { flex-direction: column-reverse; }
            .btn-modal-cancel, .btn-modal-confirm { flex: none; width: 100%; }
        }
        @media (max-width: 390px) {
            .info-banner h1 { font-size: 1.1rem; }
            .modal-card { padding: 18px; border-radius: 16px; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
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
                    <p>Sign in to complete your clinic profile and submit for admin verification.</p>
                    <div class="success-note">
                        <strong>Next step:</strong> Registration is not admin approval. After login, complete all profile sections so an admin can review your application.
                    </div>
                    <a class="btn-success-cta" href="${pageContext.request.contextPath}/doctors/login">
                        Continue to Login <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="info-banner">
                    <h1>Join as a Women Doctor</h1>
                    <p>Create your account with email OTP verification. Complete clinic details after login.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="server-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
                </c:if>
                <div id="jsAlert" class="alert-box" role="alert"></div>

                <div class="form-card" id="formPanel">
                    <form id="registerForm" action="${pageContext.request.contextPath}/doctors/register" method="post" novalidate>
                        <div class="form-group">
                            <label for="fullName">Full name *</label>
                            <input type="text" id="fullName" name="fullName" class="form-input"
                                   value="${fullName != null ? fullName : ''}"
                                   placeholder="e.g. Dr. Priya Sharma" required maxlength="100" autocomplete="name">
                            <div class="error-msg" id="nameError">Enter your full name (at least 2 characters).</div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Mobile number *</label>
                            <input type="tel" id="phone" name="phone" class="form-input"
                                   value="${phone != null ? phone : ''}"
                                   placeholder="10-digit mobile" required maxlength="10" inputmode="numeric" autocomplete="tel">
                            <div class="error-msg" id="phoneError">Enter a valid 10-digit mobile number.</div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email *</label>
                            <div class="otp-row">
                                <input type="email" id="email" name="email" class="form-input"
                                       value="${email != null ? email : ''}"
                                       placeholder="doctor@example.com" required maxlength="120" autocomplete="email">
                                <button type="button" id="sendOtpBtn" class="btn-otp">Send OTP</button>
                            </div>
                            <div class="error-msg" id="emailError">Enter a valid email address.</div>
                        </div>

                        <div class="form-group" id="otpGroup" style="display:none;">
                            <label for="otpInput">Email OTP *</label>
                            <div class="otp-row">
                                <input type="text" id="otpInput" class="form-input" placeholder="6-digit code" maxlength="6" inputmode="numeric" autocomplete="one-time-code">
                                <button type="button" id="verifyOtpBtn" class="btn-otp btn-otp-solid">Verify</button>
                            </div>
                            <div class="error-msg" id="otpError">Enter the 6-digit OTP sent to your email.</div>
                            <div class="otp-ok" id="otpSuccess"><i class="bi bi-check-circle-fill"></i> Email verified</div>
                        </div>

                        <div class="form-group">
                            <label for="password">Password *</label>
                            <div class="password-wrap">
                                <input type="password" id="password" name="password" class="form-input"
                                       placeholder="Min 6 chars, number + special" required maxlength="64" autocomplete="new-password">
                                <button type="button" class="password-toggle" data-target="password" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="strength-row">
                                <div class="strength-bars">
                                    <div class="strength-bar" id="str1"></div>
                                    <div class="strength-bar" id="str2"></div>
                                    <div class="strength-bar" id="str3"></div>
                                    <div class="strength-bar" id="str4"></div>
                                </div>
                                <span class="strength-text" id="strLabel">Weak</span>
                            </div>
                            <div class="hint">At least 6 characters, including a number and a special character (!@#$%^&amp;*)</div>
                            <div class="error-msg" id="pwdError">Password must be at least 6 characters and include a number and special character.</div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm password *</label>
                            <div class="password-wrap">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                                       placeholder="Re-enter password" required maxlength="64" autocomplete="new-password">
                                <button type="button" class="password-toggle" data-target="confirmPassword" aria-label="Show confirm password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-msg" id="matchError">Passwords do not match.</div>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="terms" name="acceptedTerms" value="true" required>
                            <label for="terms">I agree to the <a href="#">Terms &amp; Conditions</a> and <a href="#">Privacy Policy</a></label>
                        </div>
                        <div class="error-msg" id="termsError" style="margin-top:-10px;margin-bottom:14px;">You must accept the Terms and Privacy Policy.</div>

                        <button type="button" id="reviewBtn" class="btn-submit">
                            Create account <i class="bi bi-arrow-right"></i>
                        </button>
                    </form>
                    <div class="login-link">Already registered? <a href="${pageContext.request.contextPath}/doctors/login">Sign in</a></div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <c:if test="${empty registrationSuccess}">
    <div id="confirmModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="confirmTitle">
        <div class="modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-person-badge-fill"></i></div>
                <div>
                    <h3 id="confirmTitle">Confirm Details</h3>
                    <p>Review your information before account creation</p>
                </div>
            </div>
            <div class="modal-body">
                <div class="review-row"><span class="label">Full name</span><span class="value" id="revName">—</span></div>
                <div class="review-row"><span class="label">Mobile</span><span class="value" id="revPhone">—</span></div>
                <div class="review-row"><span class="label">Email</span><span class="value" id="revEmail">—</span></div>
                <div class="review-row"><span class="label">Email OTP</span><span class="value" style="color:var(--success);">Verified</span></div>
                <div class="review-row"><span class="label">Password</span><span class="value">••••••••</span></div>
                <div class="review-row"><span class="label">Terms</span><span class="value" style="color:var(--success);">Accepted</span></div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="modalEditBtn">Back / Edit</button>
                <button type="button" class="btn-modal-confirm" id="confirmSubmitBtn">
                    Confirm &amp; Register <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>

    <script>
        (function () {
            const ctx = '${pageContext.request.contextPath}';
            const form = document.getElementById('registerForm');
            const modal = document.getElementById('confirmModal');
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
            const confirmSubmitBtn = document.getElementById('confirmSubmitBtn');

            let emailVerified = false;
            let submitting = false;
            let otpBusy = false;

            const pwdRule = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
            const emailRule = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
            const phoneRule = /^\d{10}$/;

            function showAlert(msg, isError) {
                const el = document.getElementById('jsAlert');
                el.className = 'alert-box ' + (isError ? 'alert-error' : 'alert-success');
                el.style.display = 'flex';
                el.innerHTML = '<i class="bi ' + (isError ? 'bi-exclamation-circle-fill' : 'bi-check-circle-fill') + '"></i> ' + msg;
                el.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            function hideAlert() {
                const el = document.getElementById('jsAlert');
                el.style.display = 'none';
            }
            function showErr(id, show, msg) {
                const el = document.getElementById(id);
                if (!el) return;
                if (msg) el.textContent = msg;
                el.style.display = show ? 'block' : 'none';
            }
            function setInvalid(input, invalid) {
                input.classList.toggle('is-invalid', !!invalid);
            }

            function nameMsg() {
                const v = fullName.value.trim();
                if (!v) return 'Full name is required.';
                if (v.length < 2) return 'Enter your full name (at least 2 characters).';
                if (v.length > 100) return 'Full name must be 100 characters or fewer.';
                return null;
            }
            function phoneMsg() {
                const v = phone.value.trim();
                if (!v) return 'Mobile number is required.';
                if (!/^\d+$/.test(v)) return 'Mobile number must contain digits only.';
                if (!phoneRule.test(v)) return 'Enter a valid 10-digit mobile number.';
                return null;
            }
            function emailMsg() {
                const v = email.value.trim();
                if (!v) return 'Email is required.';
                if (!emailRule.test(v)) return 'Enter a valid email address.';
                return null;
            }
            function pwdMsg() {
                const v = password.value;
                if (!v) return 'Password is required.';
                if (v.length < 6) return 'Password must be at least 6 characters.';
                if (!/[0-9]/.test(v)) return 'Password must include at least one number.';
                if (!/[!@#$%^&*]/.test(v)) return 'Password must include a special character (!@#$%^&*).';
                if (!pwdRule.test(v)) return 'Password must be at least 6 characters and include a number and special character.';
                return null;
            }
            function matchMsg() {
                if (!confirmPassword.value) return 'Confirm password is required.';
                if (confirmPassword.value !== password.value) return 'Passwords do not match.';
                return null;
            }

            function evaluatePasswordStrength(p) {
                let score = 0;
                if (p.length >= 6) score++;
                if (p.length >= 10) score++;
                if (/[0-9]/.test(p)) score++;
                if (/[!@#$%^&*]/.test(p)) score++;
                const colors = ['#E2E8F0', '#EF4444', '#F97316', '#84CC16', '#22C55E'];
                const labels = ['Weak', 'Weak', 'Fair', 'Good', 'Strong'];
                for (let i = 1; i <= 4; i++) {
                    document.getElementById('str' + i).style.backgroundColor = (i <= score) ? colors[score] : '#E2E8F0';
                }
                document.getElementById('strLabel').textContent = labels[score];
            }

            function validateField(field) {
                if (field === 'fullName') {
                    const m = nameMsg(); setInvalid(fullName, !!m); showErr('nameError', !!m, m); return !m;
                }
                if (field === 'phone') {
                    const m = phoneMsg(); setInvalid(phone, !!m); showErr('phoneError', !!m, m); return !m;
                }
                if (field === 'email') {
                    const m = emailMsg(); setInvalid(email, !!m); showErr('emailError', !!m, m); return !m;
                }
                if (field === 'password') {
                    const m = pwdMsg(); setInvalid(password, !!m); showErr('pwdError', !!m, m); return !m;
                }
                if (field === 'confirmPassword') {
                    const m = matchMsg(); setInvalid(confirmPassword, !!m); showErr('matchError', !!m, m); return !m;
                }
                if (field === 'terms') {
                    const ok = terms.checked; showErr('termsError', !ok); return ok;
                }
                return true;
            }

            function validateAll(showErrors) {
                const checks = [
                    ['fullName', !nameMsg()],
                    ['phone', !phoneMsg()],
                    ['email', !emailMsg()],
                    ['password', !pwdMsg()],
                    ['confirmPassword', !matchMsg()],
                    ['terms', terms.checked]
                ];
                let ok = true;
                checks.forEach(([field, fieldOk]) => {
                    if (showErrors) validateField(field);
                    if (!fieldOk) ok = false;
                });
                if (!emailVerified) {
                    ok = false;
                    if (showErrors) {
                        showErr('emailError', true, 'Please verify your email via OTP first.');
                        setInvalid(email, true);
                    }
                }
                return ok;
            }

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

            phone.addEventListener('input', () => {
                phone.value = phone.value.replace(/\D/g, '').slice(0, 10);
            });
            otpInput.addEventListener('input', () => {
                otpInput.value = otpInput.value.replace(/\D/g, '').slice(0, 6);
            });
            password.addEventListener('input', () => evaluatePasswordStrength(password.value));

            fullName.addEventListener('blur', () => validateField('fullName'));
            phone.addEventListener('blur', () => validateField('phone'));
            email.addEventListener('blur', () => validateField('email'));
            password.addEventListener('blur', () => validateField('password'));
            confirmPassword.addEventListener('blur', () => validateField('confirmPassword'));
            terms.addEventListener('change', () => validateField('terms'));

            email.addEventListener('input', () => {
                if (emailVerified) {
                    emailVerified = false;
                    email.readOnly = false;
                    otpSuccess.style.display = 'none';
                    otpGroup.style.display = 'none';
                    otpInput.value = '';
                    otpInput.style.display = '';
                    verifyOtpBtn.style.display = '';
                }
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
                hideAlert();
                if (!validateField('email')) return;
                if (otpBusy) return;
                otpBusy = true;
                sendOtpBtn.disabled = true;
                sendOtpBtn.textContent = 'Sending...';
                try {
                    const res = await fetch(ctx + '/api/doctors/provider/otp/send-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: email.value.trim() })
                    });
                    let data = {};
                    try { data = await res.json(); } catch (_) {}
                    if (res.ok && data.success) {
                        otpGroup.style.display = 'block';
                        emailVerified = false;
                        otpSuccess.style.display = 'none';
                        otpInput.style.display = '';
                        otpInput.value = '';
                        verifyOtpBtn.style.display = '';
                        verifyOtpBtn.disabled = false;
                        verifyOtpBtn.textContent = 'Verify';
                        showAlert('OTP sent to your email. Check inbox and spam.', false);
                        armOtpResend(60);
                    } else {
                        showErr('emailError', true, data.error || data.message || 'Failed to send OTP.');
                        sendOtpBtn.disabled = false;
                        sendOtpBtn.textContent = 'Send OTP';
                    }
                } catch (e) {
                    showErr('emailError', true, 'Network error. Try again.');
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.textContent = 'Send OTP';
                } finally {
                    otpBusy = false;
                }
            });

            verifyOtpBtn.addEventListener('click', async () => {
                hideAlert();
                const otpVal = otpInput.value.trim();
                if (!/^\d{6}$/.test(otpVal)) {
                    showErr('otpError', true, 'Enter the 6-digit OTP sent to your email.');
                    setInvalid(otpInput, true);
                    return;
                }
                setInvalid(otpInput, false);
                showErr('otpError', false);
                if (otpBusy) return;
                otpBusy = true;
                verifyOtpBtn.disabled = true;
                verifyOtpBtn.textContent = 'Verifying...';
                try {
                    const res = await fetch(ctx + '/api/doctors/provider/otp/verify-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: email.value.trim(), otp: otpVal })
                    });
                    const data = await res.json();
                    if (data.success) {
                        emailVerified = true;
                        email.readOnly = true;
                        otpInput.style.display = 'none';
                        verifyOtpBtn.style.display = 'none';
                        otpSuccess.style.display = 'block';
                        showErr('emailError', false);
                        setInvalid(email, false);
                        showAlert('Email verified successfully.', false);
                    } else {
                        showErr('otpError', true, data.error || data.message || 'Invalid or expired OTP.');
                        verifyOtpBtn.disabled = false;
                        verifyOtpBtn.textContent = 'Verify';
                    }
                } catch (e) {
                    showErr('otpError', true, 'Network error. Try again.');
                    verifyOtpBtn.disabled = false;
                    verifyOtpBtn.textContent = 'Verify';
                } finally {
                    otpBusy = false;
                }
            });

            function openModal() {
                hideAlert();
                if (!validateAll(true)) {
                    showAlert('Please fix the highlighted fields before continuing.', true);
                    return;
                }
                document.getElementById('revName').textContent = fullName.value.trim();
                document.getElementById('revPhone').textContent = phone.value.trim();
                document.getElementById('revEmail').textContent = email.value.trim();
                modal.classList.add('open');
                document.body.style.overflow = 'hidden';
            }
            function closeModal() {
                modal.classList.remove('open');
                document.body.style.overflow = '';
                submitting = false;
                confirmSubmitBtn.disabled = false;
                confirmSubmitBtn.innerHTML = 'Confirm &amp; Register <i class="bi bi-check2-circle"></i>';
            }

            reviewBtn.addEventListener('click', openModal);
            document.getElementById('modalEditBtn').addEventListener('click', closeModal);
            modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && modal.classList.contains('open')) closeModal();
            });

            confirmSubmitBtn.addEventListener('click', () => {
                if (submitting) return;
                if (!validateAll(true)) {
                    closeModal();
                    showAlert('Please fix the highlighted fields before continuing.', true);
                    return;
                }
                submitting = true;
                confirmSubmitBtn.disabled = true;
                confirmSubmitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Creating account...';
                reviewBtn.disabled = true;
                form.submit();
            });

            form.addEventListener('submit', (e) => {
                if (!validateAll(true) || !emailVerified) {
                    e.preventDefault();
                    submitting = false;
                    reviewBtn.disabled = false;
                    confirmSubmitBtn.disabled = false;
                    confirmSubmitBtn.innerHTML = 'Confirm &amp; Register <i class="bi bi-check2-circle"></i>';
                }
            });

            evaluatePasswordStrength(password.value || '');
        })();
    </script>
    </c:if>
</body>
</html>
