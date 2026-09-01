<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investor Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            /* Mobile Flutter Theme Colors - Rose, Plum & neutral Slate */
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --primary-plum: #4c0519;
            --bg-scaffold: #f8fafc;
            --bg-surface: #ffffff;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
            --border-focus: #f43f5e;
            --rose-bg-light: #ffe4e6;
            --rose-text-dark: #be123c;
            --font-heading: 'Poppins', sans-serif;
            --font-body: 'Inter', sans-serif;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--font-body);
            background: var(--bg-scaffold);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            margin: 0;
        }

        .register-container {
            width: 100%;
            max-width: 480px;
            background: var(--bg-surface);
            border-radius: 16px;
            padding: 40px; 
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-light);
            position: relative;
        }

        .back-link-top {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--primary-rose);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 25px;
            transition: color 0.2s;
        }

        .back-link-top:hover {
            color: var(--primary-rose-hover);
        }

        .header-title {
            font-family: var(--font-heading);
            font-weight: 800;
            color: var(--primary-plum);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.6rem;
        }

        .header-title span {
            color: var(--primary-rose);
        }

        .header-subtitle {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        .form-label {
            font-size: 0.85rem;
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 6px;
        }

        .form-control {
            border-radius: 12px;
            border: 1.5px solid var(--border-light);
            background-color: var(--bg-surface);
            color: var(--text-primary);
            padding: 12px 16px;
            font-size: 0.95rem;
            transition: all 0.3s;
            height: 50px;
        }

        .form-control:focus {
            outline: none;
            background-color: var(--bg-surface);
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }
        
        .input-group-custom {
            position: relative;
        }

        .input-group-custom .field-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        
        .toggle-password {
            cursor: pointer;
            z-index: 10;
        }

        .btn-register {
            background: var(--primary-rose);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 12px;
            width: 100%;
            transition: all 0.3s;
            margin-top: 15px;
            font-size: 1rem;
        }

        .btn-register:hover {
            background: var(--primary-rose-hover);
            transform: translateY(-1px);
            box-shadow: 0 8px 15px rgba(244, 63, 94, 0.2);
            color: white;
        }

        .btn-register:disabled {
            background-color: #cbd5e1;
            color: #94a3b8;
            transform: none;
            box-shadow: none;
            cursor: not-allowed;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .login-link a {
            color: var(--primary-rose);
            font-weight: 700;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .btn-otp {
            height: 50px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            border: 1.5px solid var(--border-light);
            background-color: transparent;
            color: var(--text-primary);
        }

        .btn-otp:hover {
            border-color: var(--primary-rose);
            color: var(--primary-rose);
        }

        .btn-verify-submit {
            height: 50px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            background-color: var(--primary-rose);
            color: white;
            border: none;
        }
        
        .btn-verify-submit:hover {
            opacity: 0.9;
        }

        .otp-verified-badge {
            color: var(--rose-text-dark);
            background: var(--rose-bg-light);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            height: 50px;
        }

        /* Password Strength Bar */
        .strength-meter {
            height: 6px;
            background-color: var(--border-light);
            border-radius: 3px;
            margin-top: 8px;
            overflow: hidden;
            display: none;
        }

        .strength-bar {
            height: 100%;
            width: 0;
            transition: width 0.3s, background-color 0.3s;
        }

        .strength-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            margin-top: 4px;
            display: none;
        }

        .form-check-input:checked {
            background-color: var(--primary-rose);
            border-color: var(--primary-rose);
        }

        .form-check-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.4;
        }

        .form-check-label a {
            color: var(--primary-rose);
            text-decoration: none;
            font-weight: 600;
        }

        .rose-alert {
            background: var(--rose-bg-light);
            border: 1px solid #fecaca;
            color: var(--rose-text-dark);
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    
        .bg-rose { background-color: #f43f5e !important; color: white !important; }
        .text-rose { color: #f43f5e !important; }
        .badge-rose { background-color: #ffe4e6 !important; color: #f43f5e !important; border: 1px solid #F8C8D4; }
</style>
</head>
<body>

    <div class="register-container">
        
        <a href="${pageContext.request.contextPath}/investor/login" class="back-link-top">
            <i class="bi bi-arrow-left"></i> Back to Login
        </a>

        <h2 class="header-title">
            Register as <span>Investor</span>
        </h2>
        <p class="header-subtitle">Join us and access our venture matching marketplace</p>

        <!-- JS Alert Box -->
        <div class="rose-alert" id="jsAlert" style="display: none;">
            <i class="bi bi-exclamation-circle"></i> <span id="jsAlertText"></span>
        </div>

        <c:if test="${not empty error}">
            <div class="rose-alert" role="alert">
                <i class="bi bi-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/investor/register" method="post" id="investorRegForm">
            
            <!-- Contact Details -->
            <div class="mb-3">
                <label class="form-label" for="fullName">Full Name *</label>
                <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Enter your full name" required>
            </div>

            <div class="mb-3">
                <label class="form-label" for="email">Email Address *</label>
                <div class="row g-2">
                    <div class="col-8">
                        <div class="input-group-custom">
                            <input type="email" id="email" name="email" class="form-control" placeholder="Enter email address" required>
                            <i class="field-icon bi bi-envelope"></i>
                        </div>
                    </div>
                    <div class="col-4">
                        <button type="button" id="sendOtpBtn" class="btn w-100 btn-otp">Send OTP</button>
                    </div>
                </div>
            </div>

            <!-- OTP Verification Row (Hidden by default, triggered on email send) -->
            <div class="mb-3" id="otpRow" style="display: none;">
                <label class="form-label" for="emailOtp">Enter Email OTP *</label>
                <div class="row g-2">
                    <div class="col-8">
                        <input type="text" id="emailOtp" name="emailOtp" class="form-control" placeholder="6-digit code">
                    </div>
                    <div class="col-4">
                        <button type="button" id="verifyOtpBtn" class="btn w-100 btn-verify-submit">Verify</button>
                    </div>
                </div>
                <small class="form-text text-muted" id="otpStatusHint" style="font-size: 0.8rem; margin-top: 4px; display: block;"></small>
            </div>

            <!-- Verified Badge indicator -->
            <div class="mb-3" id="otpVerifiedBadge" style="display: none;">
                <label class="form-label">Email Status</label>
                <div class="otp-verified-badge">
                    <i class="bi bi-patch-check-fill"></i> Email verified successfully
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="phone">Phone Number *</label>
                <input type="tel" id="phone" name="phone" class="form-control" placeholder="Enter 10-digit number" pattern="[0-9]{10}" required>
            </div>

            <div class="mb-3">
                <label class="form-label" for="password">Password *</label>
                <div class="input-group-custom">
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password (min 6 characters)" required>
                    <i class="field-icon bi bi-eye-slash toggle-password" id="togglePassword"></i>
                </div>
                <!-- PW Strength Meter -->
                <div class="strength-meter" id="pwStrengthMeter">
                    <div class="strength-bar" id="pwStrengthBar"></div>
                </div>
                <div class="strength-label" id="pwStrengthLabel">Password strength</div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="confirmPassword">Confirm Password *</label>
                <div class="input-group-custom">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
                    <i class="field-icon bi bi-eye-slash toggle-password" id="toggleConfirmPassword"></i>
                </div>
                <small class="form-text text-danger" id="passwordMatchError" style="display: none;">Passwords do not match</small>
            </div>

            <!-- Terms and Privacy Checkbox -->
            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="acceptedTerms" name="acceptedTerms" required>
                <label class="form-check-label" for="acceptedTerms">
                    I agree to the <a href="#">Terms of Use</a> and <a href="#">Privacy Policy</a>.
                </label>
            </div>

            <button type="submit" id="submitBtn" class="btn btn-register">
                <i class="bi bi-person-plus"></i> Register as Investor
            </button>
        </form>

        <p class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/investor/login">Sign in here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const CONTEXT_PATH = "${pageContext.request.contextPath}";

        let isEmailVerified = false;
        let isPasswordMatching = false;
        let isPasswordStrongVal = false;

        const form = document.querySelector('form');
        const emailInput = document.getElementById('email');
        const sendOtpBtn = document.getElementById('sendOtpBtn');
        const otpRow = document.getElementById('otpRow');
        const emailOtpInput = document.getElementById('emailOtp');
        const verifyOtpBtn = document.getElementById('verifyOtpBtn');
        const otpVerifiedBadge = document.getElementById('otpVerifiedBadge');
        const otpStatusHint = document.getElementById('otpStatusHint');

        const phoneInput = document.getElementById('phone');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatchError = document.getElementById('passwordMatchError');
        const acceptedTermsCheckbox = document.getElementById('acceptedTerms');
        const submitBtn = document.getElementById('submitBtn');

        const setupTogglePassword = (triggerId, fieldId) => {
            const trigger = document.getElementById(triggerId);
            const field = document.getElementById(fieldId);
            if (trigger && field) {
                trigger.addEventListener('click', function() {
                    const type = field.type === 'password' ? 'text' : 'password';
                    field.type = type;
                    this.classList.toggle('bi-eye');
                    this.classList.toggle('bi-eye-slash');
                });
            }
        };

        setupTogglePassword('togglePassword', 'password');
        setupTogglePassword('toggleConfirmPassword', 'confirmPassword');

        const checkFormState = () => {
            // Managed inside form submit validation instead of disabling button
        };

        sendOtpBtn.addEventListener('click', async () => {
            const email = emailInput.value.trim();
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Please enter a valid email address first.');
                emailInput.focus();
                return;
            }

            sendOtpBtn.disabled = true;
            sendOtpBtn.innerText = 'Sending...';

            try {
                const response = await fetch(`${CONTEXT_PATH}/api/investor/otp/send-email`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email })
                });

                const data = await response.json();
                if (response.ok && data.success) {
                    otpStatusHint.innerText = 'OTP sent! Please check your inbox.';
                    otpStatusHint.style.color = '#be123c';
                    otpRow.style.display = 'block';
                    emailOtpInput.required = true;
                    emailInput.readOnly = true;
                } else {
                    alert('Failed to send OTP: ' + (data.error || 'Unknown error'));
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.innerText = 'Send OTP';
                }
            } catch (err) {
                console.error(err);
                alert('Network error. Failed to send OTP.');
                sendOtpBtn.disabled = false;
                sendOtpBtn.innerText = 'Send OTP';
            }
        });

        verifyOtpBtn.addEventListener('click', async () => {
            const email = emailInput.value.trim();
            const otp = emailOtpInput.value.trim();
            if (!otp) {
                alert('Please enter the OTP code.');
                emailOtpInput.focus();
                return;
            }

            verifyOtpBtn.disabled = true;
            verifyOtpBtn.innerText = 'Verifying...';

            try {
                const response = await fetch(`${CONTEXT_PATH}/api/investor/otp/verify-email`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, otp: otp })
                });

                const data = await response.json();
                if (response.ok && data.success) {
                    isEmailVerified = true;
                    otpRow.style.display = 'none';
                    otpVerifiedBadge.style.display = 'flex';
                    emailOtpInput.readOnly = true;
                    sendOtpBtn.style.display = 'none';
                    checkFormState();
                } else {
                    alert('Invalid OTP. Please enter the correct OTP code.');
                    verifyOtpBtn.disabled = false;
                    verifyOtpBtn.innerText = 'Verify';
                }
            } catch (err) {
                console.error(err);
                alert('Verification request failed. Please try again.');
                verifyOtpBtn.disabled = false;
                verifyOtpBtn.innerText = 'Verify';
            }
        });

        const validatePasswordStrength = (pwd) => {
            const meter = document.getElementById('pwStrengthMeter');
            const bar = document.getElementById('pwStrengthBar');
            const label = document.getElementById('pwStrengthLabel');

            if (!pwd) {
                meter.style.display = 'none';
                label.style.display = 'none';
                isPasswordStrongVal = false;
                return;
            }

            meter.style.display = 'block';
            label.style.display = 'block';

            let score = 0;
            if (pwd.length >= 6) score++;
            if (pwd.length >= 10) score++;
            if (/[A-Z]/.test(pwd)) score++;
            if (/[0-9]/.test(pwd)) score++;
            if (/[!@#$%^&*]/.test(pwd)) score++;

            const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
            const isCompliant = passwordRegex.test(pwd);

            let pct = (score / 5) * 100;
            bar.style.width = pct + '%';

            if (!isCompliant) {
                bar.style.backgroundColor = '#be123c';
                label.innerText = 'Format: Min 6 characters with 1 number and 1 special symbol (!@#$%)';
                label.style.color = '#be123c';
                isPasswordStrongVal = false;
            } else if (score < 4) {
                bar.style.backgroundColor = '#be123c';
                label.innerText = 'Medium strength';
                label.style.color = '#be123c';
                isPasswordStrongVal = true;
            } else {
                bar.style.backgroundColor = '#be123c';
                label.innerText = 'Strong password';
                label.style.color = '#be123c';
                isPasswordStrongVal = true;
            }
        };

        passwordInput.addEventListener('input', () => {
            validatePasswordStrength(passwordInput.value);
            checkPasswordsMatch();
            checkFormState();
        });

        const checkPasswordsMatch = () => {
            const pwd = passwordInput.value;
            const confirm = confirmPasswordInput.value;

            if (!confirm) {
                passwordMatchError.style.display = 'none';
                isPasswordMatching = false;
                return;
            }

            if (pwd === confirm) {
                passwordMatchError.style.display = 'none';
                isPasswordMatching = true;
                confirmPasswordInput.style.borderColor = '#cbd5e1';
            } else {
                passwordMatchError.style.display = 'block';
                isPasswordMatching = false;
                confirmPasswordInput.style.borderColor = '#be123c';
            }
        };

        confirmPasswordInput.addEventListener('input', () => {
            checkPasswordsMatch();
            checkFormState();
        });

        phoneInput.addEventListener('input', () => {
            if (phoneInput.value.length === 10) {
                phoneInput.style.borderColor = '#cbd5e1';
            } else {
                phoneInput.style.borderColor = '#be123c';
            }
            checkFormState();
        });

        document.getElementById('fullName').addEventListener('input', checkFormState);
        acceptedTermsCheckbox.addEventListener('change', checkFormState);

        const showAlert = (msg) => {
            const el = document.getElementById('jsAlert');
            const txt = document.getElementById('jsAlertText');
            if (el && txt) {
                txt.innerText = msg;
                el.style.display = 'flex';
                window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' });
            } else {
                alert(msg);
            }
        };

        const hideAlert = () => {
            const el = document.getElementById('jsAlert');
            if (el) el.style.display = 'none';
        };

        const regForm = document.getElementById('investorRegForm');
        regForm.addEventListener('submit', function(e) {
            hideAlert();

            const name = document.getElementById('fullName').value.trim();
            const email = emailInput.value.trim();
            const phone = phoneInput.value.trim();
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const termsChecked = acceptedTermsCheckbox.checked;

            if (!name) {
                showAlert('Full Name is required.');
                e.preventDefault();
                return;
            }
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                showAlert('Please enter a valid email address.');
                e.preventDefault();
                return;
            }
            if (!isEmailVerified) {
                showAlert('Please verify your email address via OTP first.');
                e.preventDefault();
                return;
            }
            if (!phone || phone.length !== 10) {
                showAlert('Please enter a valid 10-digit phone number.');
                e.preventDefault();
                return;
            }
            
            const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/;
            if (!password || !passwordRegex.test(password)) {
                showAlert('Password must contain at least 6 characters, including 1 number and 1 special symbol (!@#$%).');
                e.preventDefault();
                return;
            }
            if (password !== confirmPassword) {
                showAlert('Passwords do not match.');
                e.preventDefault();
                return;
            }
            if (!termsChecked) {
                showAlert('You must accept the Terms of Use and Privacy Policy.');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>
