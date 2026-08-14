<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        :root {
            --brand-purple: #1e1b4b;
            --brand-purple-dark: #1e1b4b;
            --brand-purple-darker: #3F1430;
            --brand-pink: #f43f5e;
            --fdf-border: #f1f3f5;
            --fdf-text: #1e293b;
            --fdf-muted: #64748b;
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --error-red: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; min-height: 100vh; display: flex; background: #fffcfd; color: var(--fdf-text); }
        .auth-container { flex: 1; display: flex; width: 100%; }
        
        .left-panel { flex: 1; background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%); display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 60px 40px; position: relative; overflow: hidden; color: white; }
        .brand-logo { font-size: 2.5rem; font-weight: 800; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; }
        .brand-logo i { font-size: 2.22rem; opacity: 0.9; }
        .brand-tagline { font-size: 1.15rem; font-weight: 300; opacity: 0.9; max-width: 380px; line-height: 1.7; margin-bottom: 40px; text-align: center; }
        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 15px; font-size: 0.95rem; }
        .feat-icon { width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; justify-content: center; align-items: center; font-size: 1.1rem; flex-shrink: 0; }

        .form-panel { flex: 1.2; display: flex; justify-content: center; align-items: center; padding: 40px; background: #fff; overflow-y: auto; }
        .reg-card { width: 100%; max-width: 650px; }
        .reg-card h2 { 
            font-family: 'Montserrat', sans-serif; 
            font-size: 2.2rem; 
            font-weight: 900; 
            color: var(--brand-purple-darker); 
            margin-bottom: 35px; 
            border-left: 6px solid var(--brand-pink); 
            padding-left: 20px; 
            line-height: 1.1;
        }

        .fdf-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 20px; }
        .fdf-group { margin-bottom: 20px; position: relative; }
        .fdf-group label { display: block; font-size: 0.75rem; font-weight: 800; color: var(--brand-purple-dark); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px; }
        .fdf-input { width: 100%; padding: 14px 18px; border: 2px solid var(--fdf-border); border-radius: 16px; background: #f8fafc; outline: none; transition: 0.3s; font-family: inherit; font-weight: 500; }
        .fdf-input:focus { border-color: var(--brand-pink); background: #fff; box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05); }

        .password-input-wrap { position: relative; }
        .password-input-wrap .fdf-input { padding-right: 48px; }
        .password-toggle-btn {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: #64748b; cursor: pointer;
            width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center;
            z-index: 2;
        }

        .upload-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-top: 5px; }
        .upload-btn { position: relative; background: #f8fafc; border: 2px dashed #e2e8f0; border-radius: 16px; padding: 20px; text-align: center; cursor: pointer; transition: 0.3s; }
        .upload-btn:hover { border-color: var(--brand-pink); background: #fff; }
        .upload-btn i { font-size: 1.8rem; color: var(--brand-purple); display: block; margin-bottom: 5px; }
        .upload-btn span { font-size: 0.75rem; font-weight: 700; color: var(--fdf-muted); }
        .upload-btn input { position: absolute; inset: 0; opacity: 0; cursor: pointer; }

        .btn-dr { padding: 18px 28px; border-radius: 18px; font-weight: 800; cursor: pointer; transition: 0.3s; border: none; font-size: 1.1rem; width: 100%; margin-top: 20px; }
        .btn-dr-next { background: var(--gradient-primary); color: #fff; box-shadow: 0 8px 25px rgba(124, 45, 94, 0.25); }
        .btn-dr-prev { background: #f1f5f9; color: var(--fdf-muted); margin-top: 0; }

        .dr-progress { display: flex; justify-content: flex-start; gap: 20px; margin-bottom: 40px; }
        .dr-step-dot { 
            width: 35px; height: 35px; border-radius: 50%; background: #f1f5f9; 
            display: flex; align-items: center; justify-content: center; 
            font-weight: 800; font-size: 0.9rem; cursor: pointer; 
            transition: 0.3s; color: var(--fdf-muted); 
            border: 2px solid #fff; box-shadow: 0 0 0 2px #f1f5f9; 
        }
        .dr-step-dot.active { background: var(--brand-pink); color: #fff; transform: scale(1.1); box-shadow: 0 0 15px rgba(219, 39, 119, 0.3); }
        .dr-step-dot.completed { background: var(--brand-purple); color: #fff; }
        
        .dr-step-panel { display: none; animation: fadeIn 0.4s ease; }
        .dr-step-panel.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .is-invalid { border-color: var(--error-red) !important; background-color: #fef2f2 !important; }
        .is-valid { border-color: #10b981 !important; background-color: #ecfdf5 !important; }
        .error-msg { color: var(--error-red); font-size: 0.75rem; font-weight: 700; margin-top: 6px; display: none; }
        .field-hint { color: #6b7280; font-size: 0.72rem; font-weight: 500; margin-top: 6px; line-height: 1.4; }
        .fdf-input.is-invalid ~ .field-hint { display: none; }
        .valid-msg { color: #10b981; font-size: 0.75rem; font-weight: 700; margin-top: 6px; display: none; }

        .back-home { display: inline-flex; align-items: center; gap: 10px; color: var(--fdf-muted); text-decoration: none; font-size: 0.95rem; font-weight: 600; margin-bottom: 25px; transition: 0.3s; }
        .back-home:hover { color: var(--brand-purple); }

        .login-link { text-align: center; margin-top: 35px; font-size: 0.95rem; color: var(--fdf-muted); border-top: 1px solid #f3f4f6; padding-top: 25px; }
        .login-link a { color: var(--brand-pink); text-decoration: none; font-weight: 800; }

        .upload-success { color: #10b981; font-weight: 700; font-size: 0.75rem; display: none; margin-top: 5px; }

        @media (max-width: 992px) {
            body, .auth-container { display: block; height: auto; min-height: 100vh; overflow-y: auto; }
            .left-panel {
                min-height: auto;
                padding: 40px 20px 50px 20px;
                text-align: center;
                display: block;
            }
            .feature-list { display: none; }
            .brand { display: flex; flex-direction: column; align-items: center; }
            .brand-logo { justify-content: center; margin-bottom: 15px; }
            .brand-tagline { margin: 0 auto; font-size: 0.95rem; }
            .form-panel {
                padding: 40px 20px;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -20px;
                position: relative;
                z-index: 5;
                display: block;
                height: auto;
                min-height: 60vh;
                overflow: visible;
            }
            .reg-card { margin: 0 auto; max-width: 100%; }
            .reg-card h2 { font-size: 1.8rem; }
        }

        @media (max-width: 650px) {
            .fdf-row, .upload-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress { justify-content: center; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 1.8rem; }
            .reg-card h2 { font-size: 1.5rem; padding-left: 15px; }
            .fdf-input { padding: 12px 15px; border-radius: 12px; }
            .btn-dr { padding: 16px; border-radius: 14px; font-size: 1rem; }
            .dr-step-dot { width: 32px; height: 32px; font-size: 0.8rem; }
            .form-panel { padding: 30px 15px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo"><i class="bi bi-shield-check"></i> Fight D Fear</div>
                <p class="brand-tagline">Empowering Women's Safety Through Technology. Your safety is our mission — anytime, anywhere.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-star-fill"></i></span> Premium Beauty Safety Standards</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-shaded"></i></span> Verified Salon Professional Network</li>
                    <li><span class="feat-icon"><i class="bi bi-calendar-check-fill"></i></span> Secure Booking Management</li>
                    <li><span class="feat-icon"><i class="bi bi-heart-pulse-fill"></i></span> Women-Centric Wellness Space</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="reg-card">

                <div class="dr-progress">
                    <div class="dr-step-dot active" data-step="1" onclick="showStep(1)">1</div>
                    <div class="dr-step-dot" data-step="2" onclick="showStep(2)">2</div>
                </div>

                <a href="${pageContext.request.contextPath}/" class="back-home"><i class="bi bi-arrow-left"></i> Return Home</a>

                <a href="${pageContext.request.contextPath}/index" class="back-home"><i class="bi bi-arrow-left"></i> Return Home</a>

                <h2>Join our Ecosystem</h2>

                <c:if test="${not empty error}">
                    <div style="background:#fef2f2; color:#b91c1c; padding:15px 20px; border-radius:14px; font-size:0.9rem; margin-bottom:25px; font-weight:600; border:1px solid #fee2e2;">
                        <i class="bi bi-shield-exclamation me-2"></i> ${error}
                    </div>
                </c:if>


                <form action="${pageContext.request.contextPath}/salons/register" method="post" enctype="multipart/form-data" id="salonRegForm">
                    <!-- Step 1: Salon Account Setup -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Step 1: Salon Account Setup</h3>
                        
                        <div class="fdf-group">
                            <label>Salon Name</label>
                            <input type="text" name="name" id="salonName" class="fdf-input"
                                   placeholder="e.g. Radiance Wellness Hub"
                                   required minlength="3" maxlength="255"
                                   autocomplete="organization">
                            <div class="field-hint" id="hint-salonName">3–255 characters.</div>
                            <div class="error-msg" id="err-salonName">Salon name must be 3–255 characters.</div>
                        </div>

                <form action="${pageContext.request.contextPath}/salons/register" method="post" id="salonRegForm">
                    <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Salon Account Setup</h3>
                    
                    <div class="fdf-group">
                        <label>Salon Name</label>
                        <input type="text" name="name" id="salonName" class="fdf-input" placeholder="e.g. Radiance Wellness Hub" required>
                        <div class="error-msg" id="err-salonName">Salon name must be at least 3 characters.</div>
                    </div>


                    <div class="fdf-row">
                        <div class="fdf-group">
                            <label>Username</label>
                            <input type="text" name="username" id="username" class="fdf-input"
                                   placeholder="e.g. radiance_hub"
                                   required minlength="3" maxlength="20"
                                   pattern="[A-Za-z0-9_]{3,20}"
                                   title="3–20 characters: letters, numbers, and underscores only"
                                   autocomplete="username">
                            <div class="field-hint" id="hint-username">Allowed: letters (A–Z, a–z), numbers (0–9), and underscore (_). Length: 3–20. No spaces or special characters.</div>
                            <div class="error-msg" id="err-username">Username must be 3–20 characters and may only contain letters, numbers, and underscores (no spaces or special characters).</div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Email ID</label>
                                <input type="email" name="email" id="email" class="fdf-input"
                                       placeholder="e.g. salon@example.com"
                                       required maxlength="255"
                                       autocomplete="email">
                                <div class="field-hint" id="hint-email">Enter a valid email address (e.g. name@domain.com).</div>
                                <div class="error-msg" id="err-email">Please enter a valid email address.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Phone Number</label>
                                <input type="tel" name="phone" id="phone" class="fdf-input"
                                       placeholder="e.g. 9876543210"
                                       required minlength="10" maxlength="10"
                                       pattern="[0-9]{10}"
                                       inputmode="numeric"
                                       title="Exactly 10 digits"
                                       autocomplete="tel">
                                <div class="field-hint" id="hint-phone">Exactly 10 digits (numbers only).</div>
                                <div class="error-msg" id="err-phone">Phone number must be exactly 10 digits.</div>
                            </div>
                        </div>
                        <div class="fdf-group">
                            <label>Phone Number</label>
                            <input type="tel" name="phone" id="phone" class="fdf-input" placeholder="e.g. 9876543210" required>
                            <div class="error-msg" id="err-phone">Enter a valid 10-digit phone number.</div>
                        </div>
                    </div>

                    <div class="fdf-group">
                        <label>Email Address</label>
                        <input type="email" name="email" id="email" class="fdf-input" placeholder="e.g. contact@radiance.com" required>
                        <div class="error-msg" id="err-email">Enter a valid email address.</div>
                    </div>

                    <div class="fdf-row">
                        <div class="fdf-group">
                            <label>Password</label>
                            <div class="password-input-wrap">
                                <input type="password" name="password" id="password" class="fdf-input" placeholder="••••••••" required>
                                <button type="button" class="password-toggle-btn" data-toggle-password="password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-msg" id="err-password">At least 6 characters (1 uppercase, 1 number required).</div>
                        </div>
                        <div class="fdf-group">
                            <label>Confirm Password</label>
                            <div class="password-input-wrap">
                                <input type="password" name="confirmPassword" id="confirmPassword" class="fdf-input" placeholder="••••••••" required>
                                <button type="button" class="password-toggle-btn" data-toggle-password="confirmPassword">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-msg" id="err-confirmPassword">❌ Passwords do not match</div>
                            <div class="valid-msg" id="val-confirmPassword" style="color: #10b981;">✅ Passwords match</div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-dr btn-dr-next" id="btn-submit">Register Salon Partner</button>
                </form>

                <div class="login-link">
                    Already a partner? <a href="${pageContext.request.contextPath}/salons/login">Log In Now</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        const validateField = (el) => {
            let isValid = true;
            const val = el.value.trim();
            const fieldId = el.id;
            const errorEl = document.getElementById('err-' + fieldId);
            const validEl = document.getElementById('val-' + fieldId);

            if (el.hasAttribute('required') && !val) isValid = false;
            
            if (isValid) {
                if (fieldId === 'salonName') isValid = val.length >= 3 && val.length <= 255;
                if (fieldId === 'username') isValid = /^[a-zA-Z0-9_]{3,20}$/.test(val);

                if (fieldId === 'email') isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val) && val.length <= 255;
                if (fieldId === 'phone') isValid = /^\d{10}$/.test(val);
                if (fieldId === 'password') isValid = val.length >= 6 && val.length <= 8 && /[A-Z]/.test(val) && /\d/.test(val);

                if (fieldId === 'phone') isValid = /^\d{10}$/.test(val);
                if (fieldId === 'email') isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
                if (fieldId === 'password') isValid = val.length >= 6 && /[A-Z]/.test(val) && /\d/.test(val);

                if (fieldId === 'confirmPassword') isValid = val === document.getElementById('password').value;
            }

            if (isValid) {
                el.classList.remove('is-invalid');
                el.classList.add('is-valid');
                if (errorEl) errorEl.style.display = 'none';
                if (validEl) validEl.style.display = 'block';
            } else {
                el.classList.remove('is-valid');
                el.classList.add('is-invalid');
                if (errorEl) errorEl.style.display = 'block';
                if (validEl) validEl.style.display = 'none';
            }
            checkFormValidity();
            return isValid;
        };

        function checkFormValidity() {

            const step1Fields = ['salonName', 'username', 'email', 'phone', 'password', 'confirmPassword'];
            const step2Fields = ['bio', 'hygieneCertificate'];
            
            const isStep1Valid = step1Fields.every(id => {

            const fields = ['salonName', 'username', 'email', 'phone', 'password', 'confirmPassword'];
            const isValid = fields.every(id => {

                const el = document.getElementById(id);
                return el && el.classList.contains('is-valid');
            });
            const submitBtn = document.getElementById('btn-submit');
            if (submitBtn) submitBtn.disabled = !isValid;
        }

        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('[data-toggle-password]').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    const id = btn.getAttribute('data-toggle-password');
                    const input = document.getElementById(id);
                    if (!input) return;
                    const show = input.type === 'password';
                    input.type = show ? 'text' : 'password';
                    const icon = btn.querySelector('i');
                    if (icon) {
                        icon.classList.toggle('bi-eye', !show);
                        icon.classList.toggle('bi-eye-slash', show);
                    }
                });
            });

            const inputs = document.querySelectorAll('.fdf-input');
            inputs.forEach(input => {
                input.addEventListener('input', () => validateField(input));
                input.addEventListener('change', () => validateField(input));
            });

            document.getElementById('salonRegForm').addEventListener('submit', function(e) {
                const fields = document.querySelectorAll('.fdf-input');
                let allValid = true;
                fields.forEach(f => { if (!validateField(f)) allValid = false; });
                if (!allValid) {
                    e.preventDefault();
                }
            });

            const phoneInput = document.getElementById('phone');
            if (phoneInput) {
                phoneInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                });
            }

            checkFormValidity();
        });
    </script>
</body>
</html>


