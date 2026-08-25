<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lawyer Registration | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; background: #fffcfd; color: #1e293b; }
        .left-panel { flex: 1; background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%); display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 60px 40px; position: relative; overflow: hidden; }
        .left-panel::before { content: ''; position: absolute; top: -100px; right: -100px; width: 400px; height: 400px; border-radius: 50%; background: rgba(255,255,255,0.06); }
        .left-panel::after { content: ''; position: absolute; bottom: -150px; left: -80px; width: 500px; height: 500px; border-radius: 50%; background: rgba(255,255,255,0.04); }
        .left-panel .brand { position: relative; z-index: 2; text-align: center; color: white; }
        .brand-logo { font-size: 2.5rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 16px; }
        .brand-logo i { font-size: 2.2rem; margin-right: 8px; }
        .brand-tagline { font-size: 1.1rem; font-weight: 300; opacity: 0.9; max-width: 360px; line-height: 1.7; margin-bottom: 40px; }
        
        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 16px; text-align: left; margin-top: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 14px; color: rgba(255,255,255,0.9); font-size: 0.95rem; font-weight: 400; }
        .feature-list li .feat-icon { width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; justify-content: center; align-items: center; font-size: 1.1rem; flex-shrink: 0; }
        
        .right-panel { flex: 1.2; display: flex; justify-content: center; align-items: center; padding: 40px; background: #fff; overflow-y: auto;}
        .reg-card { width: 100%; max-width: 550px; }
        .back-home { display: inline-flex; align-items: center; gap: 6px; color: #64748b; text-decoration: none; font-size: 0.85rem; font-weight: 600; margin-bottom: 30px; }
        
        .reg-card h2 { font-size: 1.85rem; font-weight: 800; color: #1e1b4b; margin-bottom: 6px; }
        .reg-card .subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 35px; }
        
        .form-group { margin-bottom: 22px; position: relative; }
        .form-group label { display: block; font-size: 0.75rem; font-weight: 800; color: #1e1b4b; margin-bottom: 8px; text-transform: uppercase; }
        
        .input-wrapper { position: relative; display: flex; align-items: center; }
        .form-input { width: 100%; padding: 14px 18px; border: 2px solid #f1f5f9; border-radius: 12px; font-size: 0.95rem; background: #f8fafc; transition: all 0.3s ease; font-weight: 500; font-family: 'Inter', sans-serif;}
        .form-input:focus { outline: none; border-color: #f43f5e; background: #fff; box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1); }
        .form-input::placeholder { color: #94a3b8; font-weight: 400;}

        .password-toggle-btn { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); border: none; background: transparent; color: #94a3b8; cursor: pointer; padding: 4px; font-size: 1.1rem; z-index: 2; }
        
        .btn-send-otp { background: linear-gradient(135deg, #1e1b4b, #f43f5e); color: white; border: none; border-radius: 12px; padding: 0 20px; font-weight: 700; cursor: pointer; height: 100%; margin-left: 15px; white-space: nowrap; transition: 0.3s;}
        .btn-send-otp:hover { filter: brightness(1.1); transform: translateY(-1px); }
        .btn-verify-otp { background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; border-radius: 12px; padding: 0 20px; font-weight: 700; cursor: pointer; height: 100%; margin-left: 15px; white-space: nowrap; transition: 0.3s;}
        .btn-verify-otp:hover { filter: brightness(1.1); transform: translateY(-1px); }
        
        .terms-wrap { display: flex; align-items: flex-start; gap: 10px; margin-bottom: 25px; margin-top: 10px; }
        .terms-wrap input { width: 18px; height: 18px; margin-top: 2px; accent-color: #f43f5e; cursor: pointer; }
        .terms-wrap label { font-size: 0.85rem; color: #64748b; line-height: 1.5; cursor: pointer; }
        .terms-wrap label span { color: #f43f5e; font-weight: 600; }

        .btn-register { width: 100%; padding: 16px; background: #f43f5e; color: white; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s ease; opacity: 0.8;}
        .btn-register:hover { filter: brightness(1.1); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(244, 63, 94, 0.3); opacity: 1;}

        .error-alert { background: #fff1f2; border: 1px solid #fecdd3; color: #e11d48; padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600; }
        .success-alert { background: #f0fdf4; border: 1px solid #bbf7d0; color: #15803d; padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: none; align-items: center; gap: 10px; font-weight: 600; }
        
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel { padding: 40px 20px; min-height: 30vh; text-align: center; }
            .feature-list { display: none; }
            .brand-tagline { margin: 0 auto; font-size: 1rem; }
            .right-panel { padding: 40px 20px; border-top-left-radius: 30px; border-top-right-radius: 30px; margin-top: -30px; position: relative; z-index: 5; }
        }
    </style>
</head>
<body>
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo"><i class="bi bi-briefcase"></i> Fight D Fear</div>
            <p class="brand-tagline">Join our network of trusted women lawyers. Provide expert legal guidance and support to the community.</p>
            <ul class="feature-list">
                <li><span class="feat-icon"><i class="bi bi-briefcase"></i></span> Consult Trusted Women Lawyers</li>
                <li><span class="feat-icon"><i class="bi bi-shield-check"></i></span> 24/7 Legal & Emergency Support</li>
                <li><span class="feat-icon"><i class="bi bi-clipboard-check-fill"></i></span> Safe & Confidential Guidance</li>
            </ul>
        </div>
    </div>
    
    <div class="right-panel">
        <div class="reg-card">
            <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Back to Home</a>
            
            <h2>Lawyer Registration</h2>
            <p class="subtitle">Create your account to start offering consultations.</p>
            
            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>
            <div class="error-alert" id="js-error" style="display:none;"><i class="bi bi-exclamation-circle-fill"></i> <span></span></div>
            <div class="success-alert" id="js-success"><i class="bi bi-check-circle-fill"></i> <span></span></div>

            <form action="${pageContext.request.contextPath}/lawyer/register" method="post" id="regForm">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" class="form-input" placeholder="e.g. Adv. Priya Sharma" required>
                </div>
                
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" class="form-input" placeholder="e.g. 9876543210" pattern="[0-9]{10}" required>
                </div>
                
                <div class="form-group">
                    <label>Email Address</label>
                    <div style="display:flex; height:52px;">
                        <input type="email" id="email" name="email" class="form-input" placeholder="lawyer@gmail.com" required style="border-radius: 12px 0 0 12px;">
                        <button type="button" class="btn-send-otp" id="btnSendOtp" onclick="sendOtp()" style="border-radius: 0 12px 12px 0; margin-left:0;">Send OTP</button>
                    </div>
                </div>
                
                <div class="form-group" id="otpGroup" style="display:none;">
                    <label>Enter Email OTP</label>
                    <div style="display:flex; height:52px;">
                        <input type="text" name="otp" id="otp" class="form-input" placeholder="6-digit code" style="border-radius: 12px 0 0 12px;">
                        <button type="button" class="btn-verify-otp" id="btnVerifyOtp" onclick="verifyOtp()" style="border-radius: 0 12px 12px 0; margin-left:0;">Verify</button>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required minlength="8">
                        <button type="button" class="password-toggle-btn" onclick="togglePw('password')"><i class="bi bi-eye"></i></button>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="••••••••" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePw('confirmPassword')"><i class="bi bi-eye"></i></button>
                    </div>
                </div>
                
                <div class="terms-wrap">
                    <input type="checkbox" id="terms" required>
                    <label for="terms">I agree to the <span>Terms & Conditions</span> and <span>Privacy Policy</span> of Fight D Fear.</label>
                </div>
                
                <button type="button" class="btn-register" onclick="submitForm()">Create Account</button>
            </form>
        </div>
    </div>

    <script>
        let isOtpVerified = false;

        function togglePw(id) {
            const el = document.getElementById(id);
            const btnIcon = el.nextElementSibling.querySelector('i');
            if (el.type === 'password') {
                el.type = 'text';
                btnIcon.classList.remove('bi-eye');
                btnIcon.classList.add('bi-eye-slash');
            } else {
                el.type = 'password';
                btnIcon.classList.remove('bi-eye-slash');
                btnIcon.classList.add('bi-eye');
            }
        }
        
        function showError(msg) {
            document.getElementById('js-error').style.display = 'flex';
            document.getElementById('js-error').querySelector('span').innerText = msg;
            document.getElementById('js-success').style.display = 'none';
        }
        
        function showSuccess(msg) {
            document.getElementById('js-success').style.display = 'flex';
            document.getElementById('js-success').querySelector('span').innerText = msg;
            document.getElementById('js-error').style.display = 'none';
        }

        function sendOtp() {
            const email = document.getElementById('email').value;
            if (!email) {
                showError("Please enter your email address first");
                return;
            }
            
            const btn = document.getElementById('btnSendOtp');
            const originalText = btn.innerText;
            btn.innerText = 'Sending...';
            btn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/lawyer/otp/send-email', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: email })
            }).then(r => r.json()).then(data => {
                if(data.success) {
                    showSuccess("OTP sent successfully to your email!");
                    document.getElementById('otpGroup').style.display = 'block';
                    document.getElementById('otp').setAttribute('required', 'true');
                    btn.innerText = 'Sent';
                } else {
                    showError(data.message || "Failed to send OTP");
                    btn.innerText = originalText;
                    btn.disabled = false;
                }
            }).catch(e => {
                showError("Failed to communicate with server");
                btn.innerText = originalText;
                btn.disabled = false;
            });
        }
        
        function verifyOtp() {
            const email = document.getElementById('email').value;
            const otp = document.getElementById('otp').value;
            if (!otp) {
                showError("Please enter the OTP first");
                return;
            }
            
            const btn = document.getElementById('btnVerifyOtp');
            const originalText = btn.innerText;
            btn.innerText = 'Verifying...';
            btn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/lawyer/otp/verify-email', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: email, otp: otp })
            }).then(r => r.json()).then(data => {
                if(data.success) {
                    showSuccess("Email verified successfully!");
                    btn.innerText = 'Verified';
                    btn.style.background = '#059669';
                    document.getElementById('otp').readOnly = true;
                    document.getElementById('email').readOnly = true;
                    isOtpVerified = true;
                } else {
                    showError(data.message || "Invalid or expired OTP");
                    btn.innerText = originalText;
                    btn.disabled = false;
                }
            }).catch(e => {
                showError("Failed to communicate with server");
                btn.innerText = originalText;
                btn.disabled = false;
            });
        }
        
        function submitForm() {
            const form = document.getElementById('regForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            if (document.getElementById('password').value !== document.getElementById('confirmPassword').value) {
                showError("Passwords do not match!");
                return;
            }
            
            if (!isOtpVerified) {
                showError("Please verify your email with OTP first!");
                return;
            }
            
            form.submit();
        }
    </script>
</body>
</html>
