<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Professional Registration | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        :root {
            --brand-purple: #1e1b4b;
            --brand-pink: #f43f5e;
            --fdf-border: #f1f3f5;
            --fdf-text: #1e293b;
            --error-red: #ef4444;
            --success-green: #22c55e;
        }

        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Poppins', sans-serif; min-height:100vh; display:flex; background:#fff; color:var(--fdf-text); }
        .auth-container { flex:1; display:flex; width:100%; }

        /* === Left Panel — Visual Side === */
        .left-panel {
            flex: 1;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 40px;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: -100px; right: -100px;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }

        .left-panel::after {
            content: '';
            position: absolute;
            bottom: -150px; left: -80px;
            width: 500px; height: 500px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }

        .left-panel .brand {
            position: relative; z-index: 2;
            text-align: center;
            color: white;
        }

        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 16px;
        }

        .brand-logo i {
            font-size: 2.22rem;
            margin-right: 8px;
            opacity: 0.9;
        }

        .brand-tagline {
            font-size: 1.15rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 360px;
            line-height: 1.7;
            margin-bottom: 40px;
        }

        .feature-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
            text-align: left;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 14px;
            color: rgba(255,255,255,0.9);
            font-size: 0.95rem;
            font-weight: 400;
        }

        .feature-list li .feat-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: rgba(255,255,255,0.15);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .form-panel { flex: 1.2; display: flex; justify-content: center; align-items: center; padding: 40px; background: #fff; overflow-y: auto; }
        .reg-card { width: 100%; max-width: 500px; }
        
        .fdf-group { margin-bottom: 20px; position: relative; }
        .fdf-group label { display:block; font-size:0.75rem; font-weight:800; color:var(--brand-purple); margin-bottom:8px; text-transform:uppercase; }
        .fdf-input { 
            width:100%; padding:14px 18px; border:2px solid var(--fdf-border); 
            border-radius:16px; background:#f8fafc; outline:none; 
            transition:0.3s; font-family:inherit; font-weight: 500;
        }
        .fdf-input:focus { border-color:var(--brand-pink); background:#fff; box-shadow:0 0 0 4px rgba(219,39,119,0.05); }
        .fdf-input.is-invalid { border-color: var(--error-red); background: #fef2f2; }

        .btn-dr { 
            padding:16px 32px; border-radius:14px; font-weight:800; cursor:pointer; 
            transition:0.3s; border:none; font-size: 1rem; width: 100%;
            background: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%); color:#fff;
            box-shadow: 0 8px 20px rgba(219,39,119,0.2);
        }
        .btn-dr:disabled { opacity: 0.65; cursor: not-allowed; transform: none !important; }
        .btn-dr:hover:not(:disabled) { transform: translateY(-2px); filter: brightness(1.1); }
        
        .error-msg { display: none; color: var(--error-red); font-size: 0.75rem; margin-top: 6px; font-weight: 600; }
        
        .password-input-wrap { position: relative; }
        .password-input-wrap .fdf-input { padding-right: 48px; }
        .password-toggle-btn {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: #64748b; cursor: pointer; padding: 4px; font-size: 1.1rem;
        }
        .password-toggle-btn:hover { color: var(--brand-pink); }
        
        .back-home { display: inline-flex; align-items: center; gap: 6px; color: #64748b; text-decoration: none; font-size: 0.85rem; font-weight: 600; margin-bottom: 30px; }
        .back-home:hover { color: var(--brand-purple); }

        .checkbox-group { display: flex; align-items: flex-start; gap: 10px; margin-bottom: 25px; margin-top: 10px; }
        .checkbox-group input { margin-top: 4px; width: 18px; height: 18px; accent-color: var(--brand-pink); cursor: pointer; }
        .checkbox-group label { font-size: 0.85rem; color: #64748b; font-weight: 500; cursor: pointer; line-height: 1.5; text-transform: none; }
        .checkbox-group a { color: var(--brand-pink); text-decoration: none; font-weight: 600; }
        .checkbox-group a:hover { text-decoration: underline; }

        .login-link { text-align: center; margin-top: 25px; font-size: 0.9rem; color: #64748b; font-weight: 500; }
        .login-link a { color: var(--brand-purple); text-decoration: none; font-weight: 700; }
        .login-link a:hover { text-decoration: underline; }

        .alert { padding: 14px 20px; border-radius: 12px; font-size: 0.9rem; font-weight: 600; margin-bottom: 20px; }
        .alert-danger { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }

        @media (max-width: 992px) {
            body, .auth-container { flex-direction: column; }
            .left-panel {
                min-height: 25vh;
                padding: 40px 20px;
                text-align: center;
            }
            .feature-list { display: none; }
            .brand-tagline { margin: 0 auto; font-size: 1rem; }
            .form-panel {
                padding: 40px 20px;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
            }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .fdf-input { padding: 12px 15px; border-radius: 12px; }
            .btn-dr { padding: 14px 20px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo"><i class="bi bi-heart-pulse"></i> Fight D Fear</div>
                <p class="brand-tagline">Join our network of trusted women doctors. Provide quality healthcare and support to the community.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-person-heart"></i></span> Consult Trusted Women Doctors</li>
                    <li><span class="feat-icon"><i class="bi bi-hospital-fill"></i></span> 24/7 Health & Emergency Support</li>
                    <li><span class="feat-icon"><i class="bi bi-clipboard-check-fill"></i></span> Safe & Confidential Guidance</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="reg-card">
                <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Back to Home</a>
                
                <h2 style="font-family:'Montserrat'; font-weight:800; color:var(--brand-purple); font-size:1.8rem; margin-bottom:8px;">Doctor Registration</h2>
                <p style="color:#64748b; font-size:0.95rem; margin-bottom:30px; font-weight:500;">Create your account to start offering consultations.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/doctors/register" method="post" id="registerForm">
                    
                    <div class="fdf-group">
                        <label>Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="fdf-input" placeholder="e.g. Dr. Priya Sharma" required minlength="3">
                        <div class="error-msg" id="nameError">Name must be at least 3 characters and contain valid letters.</div>
                    </div>

                    <div class="fdf-group">
                        <label>Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="fdf-input" placeholder="e.g. 9876543210" required pattern="[0-9]{10}">
                        <div class="error-msg" id="phoneError">Please enter a valid 10-digit phone number.</div>
                    </div>

                    <div class="fdf-group">
                        <label>Email Address</label>
                        <div style="display: flex; gap: 10px;">
                            <input type="email" id="email" name="email" class="fdf-input" placeholder="doctor@example.com" required>
                            <button type="button" id="sendOtpBtn" class="btn-dr" style="padding: 14px 20px; width: auto; white-space: nowrap;">Send OTP</button>
                        </div>
                        <div class="error-msg" id="emailError">Please enter a valid email address.</div>
                    </div>

                    <!-- OTP Section (Hidden initially) -->
                    <div class="fdf-group" id="otpGroup" style="display: none;">
                        <label>Email OTP Verification</label>
                        <div style="display: flex; gap: 10px;">
                            <input type="text" id="otpInput" class="fdf-input" placeholder="Enter OTP" maxlength="6">
                            <button type="button" id="verifyOtpBtn" class="btn-dr" style="padding: 14px 20px; width: auto; white-space: nowrap; background: #22c55e;">Verify</button>
                        </div>
                        <div class="error-msg" id="otpError" style="color: var(--error-red);">Invalid OTP. Please try again.</div>
                        <div id="otpSuccess" style="display: none; color: var(--success-green); font-size: 0.8rem; font-weight: 600; margin-top: 6px;">Email Verified Successfully! <i class="bi bi-check-circle-fill"></i></div>
                    </div>

                    <div class="fdf-group">
                        <label>Password</label>
                        <div class="password-input-wrap">
                            <input type="password" id="password" name="password" class="fdf-input" placeholder="••••••••" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('password', this)" aria-label="Toggle password visibility">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="error-msg" id="pwdError">Password must be at least 8 characters, include 1 capital letter, 1 number, and 1 special character.</div>
                    </div>

                    <div class="fdf-group">
                        <label>Confirm Password</label>
                        <div class="password-input-wrap">
                            <input type="password" id="confirmPassword" class="fdf-input" placeholder="••••••••" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('confirmPassword', this)" aria-label="Toggle password visibility">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="error-msg" id="matchError">Passwords do not match.</div>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">I agree to the <a href="#">Terms & Conditions</a> and <a href="#">Privacy Policy</a> of Fight D Fear.</label>
                    </div>

                    <button type="submit" id="submitBtn" class="btn-dr" disabled>Create Account</button>
                    
                    <div class="login-link">
                        Already have an account? <a href="${pageContext.request.contextPath}/doctors/login">Login here</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(inputId, btn) {
            const input = document.getElementById(inputId);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById('registerForm');
            const fullName = document.getElementById('fullName');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const email = document.getElementById('email');
            
            const submitBtn = document.getElementById('submitBtn');
            const sendOtpBtn = document.getElementById('sendOtpBtn');
            const verifyOtpBtn = document.getElementById('verifyOtpBtn');
            const otpGroup = document.getElementById('otpGroup');
            const otpInput = document.getElementById('otpInput');
            const otpSuccess = document.getElementById('otpSuccess');
            const otpError = document.getElementById('otpError');

            let isEmailVerified = false;

            // Real-time validation for Full Name
            fullName.addEventListener('input', () => {
                const isValid = /^[a-zA-Z\s\.\-]{3,}$/.test(fullName.value.trim());
                if(!isValid && fullName.value.length > 0) {
                    fullName.classList.add('is-invalid');
                    document.getElementById('nameError').style.display = 'block';
                } else {
                    fullName.classList.remove('is-invalid');
                    document.getElementById('nameError').style.display = 'none';
                }
                checkFormValidity();
            });

            // Real-time validation for Password
            password.addEventListener('input', () => {
                const pwdPattern = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$/;
                const isValid = pwdPattern.test(password.value);
                if(!isValid && password.value.length > 0) {
                    password.classList.add('is-invalid');
                    document.getElementById('pwdError').style.display = 'block';
                } else {
                    password.classList.remove('is-invalid');
                    document.getElementById('pwdError').style.display = 'none';
                }
                checkFormValidity();
            });

            // Real-time validation for Confirm Password
            confirmPassword.addEventListener('input', () => {
                if(confirmPassword.value !== password.value && confirmPassword.value.length > 0) {
                    confirmPassword.classList.add('is-invalid');
                    document.getElementById('matchError').style.display = 'block';
                } else {
                    confirmPassword.classList.remove('is-invalid');
                    document.getElementById('matchError').style.display = 'none';
                }
                checkFormValidity();
            });

            // Form Submit Intercept
            form.addEventListener('submit', (e) => {
                const pwdPattern = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$/;
                let hasError = false;

                if (!/^[a-zA-Z\s\.\-]{3,}$/.test(fullName.value.trim())) {
                    fullName.classList.add('is-invalid');
                    document.getElementById('nameError').style.display = 'block';
                    hasError = true;
                }
                
                if (!pwdPattern.test(password.value)) {
                    password.classList.add('is-invalid');
                    document.getElementById('pwdError').style.display = 'block';
                    hasError = true;
                }

                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('is-invalid');
                    document.getElementById('matchError').style.display = 'block';
                    hasError = true;
                }

                if (!isEmailVerified) {
                    document.getElementById('emailError').textContent = "Please verify your email via OTP first.";
                    document.getElementById('emailError').style.display = 'block';
                    hasError = true;
                }

                if (hasError) {
                    e.preventDefault();
                }
            });

            // Check if we can enable submit btn
            function checkFormValidity() {
                if (isEmailVerified) {
                    submitBtn.disabled = false;
                } else {
                    submitBtn.disabled = true;
                }
            }

            // --- OTP Logic ---
            sendOtpBtn.addEventListener('click', async () => {
                const emailVal = email.value.trim();
                if (!emailVal || !email.checkValidity()) {
                    email.classList.add('is-invalid');
                    document.getElementById('emailError').textContent = "Please enter a valid email address.";
                    document.getElementById('emailError').style.display = 'block';
                    return;
                }
                email.classList.remove('is-invalid');
                document.getElementById('emailError').style.display = 'none';

                sendOtpBtn.disabled = true;
                sendOtpBtn.textContent = 'Sending...';

                try {
                    const res = await fetch('${pageContext.request.contextPath}/api/doctors/provider/otp/send-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: emailVal })
                    });
                    const data = await res.json();
                    
                    if (data.success) {
                        otpGroup.style.display = 'block';
                        sendOtpBtn.textContent = 'OTP Sent';
                        email.readOnly = true; 
                    } else {
                        document.getElementById('emailError').textContent = data.error || data.message || "Failed to send OTP.";
                        document.getElementById('emailError').style.display = 'block';
                        sendOtpBtn.disabled = false;
                        sendOtpBtn.textContent = 'Send OTP';
                    }
                } catch (err) {
                    document.getElementById('emailError').textContent = "Network error. Try again.";
                    document.getElementById('emailError').style.display = 'block';
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
                    const res = await fetch('${pageContext.request.contextPath}/api/doctors/provider/otp/verify-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ email: emailVal, otp: otpVal })
                    });
                    const data = await res.json();
                    
                    if (data.success) {
                        isEmailVerified = true;
                        otpInput.style.display = 'none';
                        verifyOtpBtn.style.display = 'none';
                        otpError.style.display = 'none';
                        otpSuccess.style.display = 'block';
                        checkFormValidity();
                    } else {
                        otpError.textContent = data.error || data.message || "Invalid OTP.";
                        otpError.style.display = 'block';
                        verifyOtpBtn.disabled = false;
                        verifyOtpBtn.textContent = 'Verify';
                    }
                } catch (err) {
                    otpError.textContent = "Network error. Try again.";
                    otpError.style.display = 'block';
                    verifyOtpBtn.disabled = false;
                    verifyOtpBtn.textContent = 'Verify';
                }
            });

        });
    </script>
</body>
</html>
