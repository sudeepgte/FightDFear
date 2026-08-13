<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Partner Registration — Fight D Fear</title>
  
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
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
    .brand-logo { font-size: 2.5rem; font-weight: 800; margin-bottom: 16px; }
    .brand-tagline { font-size: 1.15rem; font-weight: 300; opacity: 0.9; max-width: 360px; line-height: 1.7; margin-bottom: 40px; }
    .feature-list { list-style: none; display: flex; flex-direction: column; gap: 16px; }
    .feature-list li { display: flex; align-items: center; gap: 14px; font-size: 0.95rem; }
    .feat-icon { width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; justify-content: center; align-items: center; }

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

    .is-invalid { border-color: var(--error-red) !important; background-color: #fef2f2; }
    .error-msg { color: var(--error-red); font-size: 0.7rem; font-weight: 700; margin-top: 6px; display: none; }

    .back-home { display: inline-flex; align-items: center; gap: 10px; color: var(--fdf-muted); text-decoration: none; font-size: 0.95rem; font-weight: 600; margin-bottom: 25px; transition: 0.3s; }
    .back-home:hover { color: var(--brand-purple); }

    .login-link { text-align: center; margin-top: 35px; font-size: 0.95rem; color: var(--fdf-muted); border-top: 1px solid #f3f4f6; padding-top: 25px; }
    .login-link a { color: var(--brand-pink); text-decoration: none; font-weight: 800; }

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
        .reg-card h2 { font-size: 1.8rem; }
    }

    @media (max-width: 650px) {
        .fdf-row, .upload-row { grid-template-columns: 1fr; gap: 0; }
        .dr-progress { justify-content: center; }
    }

    @media (max-width: 480px) {
        .brand-logo { font-size: 2rem; }
        .reg-card h2 { font-size: 1.5rem; padding-left: 15px; }
        .fdf-input { padding: 12px 15px; border-radius: 12px; }
        .btn-dr { padding: 14px 20px; }
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
                    <li><span class="feat-icon"><i class="bi bi-smartwatch"></i></span> Safety Gadgets & Essentials</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-fill-check"></i></span> Personal Protection Tools</li>
                    <li><span class="feat-icon"><i class="bi bi-safe-fill"></i></span> Daily Use Safety Accessories</li>
                    <li><span class="feat-icon"><i class="bi bi-gender-female"></i></span> Designed Specifically for Women</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="reg-card">
                <div class="dr-progress">
                    <div class="dr-step-dot active" data-step="1" onclick="showStep(1)">1</div>
                    <div class="dr-step-dot" data-step="2" onclick="showStep(2)">2</div>
                </div>

                <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Return Home</a>
                <h2>Join our Ecosystem</h2>

                <c:if test="${not empty error}"><div style="background:#fef2f2; color:#b91c1c; padding:15px 20px; border-radius:14px; font-size:0.9rem; margin-bottom:25px; font-weight:600; border:1px solid #fee2e2;"><i class="bi bi-shield-exclamation me-2"></i> ${error}</div></c:if>

                <form method="post" action="${pageContext.request.contextPath}/women-products/seller/register" enctype="multipart/form-data" id="sellerForm">
                    <!-- Step 1: Brand & Account -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Brand & Account</h3>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Full Name</label>
                                <input type="text" name="fullName" id="fullName" class="fdf-input" placeholder="Your Name" required>
                                <div class="error-msg">Name must be at least 3 characters.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Business Name</label>
                                <input type="text" name="businessName" id="businessName" class="fdf-input" placeholder="Brand Name" required>
                                <div class="error-msg">Business name is required.</div>
                            </div>
                        </div>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Email Address</label>
                                <input type="email" name="email" id="email" class="fdf-input" placeholder="business@email.com" required>
                                <div class="error-msg">Valid business email required.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Phone Number</label>
                                <input type="tel" name="phone" id="phone" class="fdf-input" placeholder="10-digit number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                                <div class="error-msg">Valid 10-digit number required.</div>
                            </div>
                        </div>
                        <div class="fdf-group">
                            <label>Password</label>
                            <div style="position: relative;">
                                <input type="password" name="password" id="password" class="fdf-input" placeholder="••••••••" required style="padding-right: 45px;">
                                <i class="bi bi-eye-slash" id="togglePassword" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--fdf-muted); font-size: 1.2rem; z-index: 10;"></i>
                            </div>
                            <div class="error-msg">Min 6 chars with number, uppercase & special char.</div>
                        </div>
                        
                        <button type="button" class="btn-dr btn-dr-next" onclick="nextStep(1)">Continue to Verification</button>
                    </div>

                    <!-- Step 2: Verification -->
                    <div class="dr-step-panel" id="step2">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Business Verification</h3>
                        <div class="fdf-group">
                            <label>Business Address</label>
                            <input type="text" name="address" id="address" class="fdf-input" placeholder="Office/Warehouse location" required>
                            <div class="error-msg">Address is required (min 10 chars).</div>
                        </div>
                        
                        <div class="upload-row">
                            <div class="fdf-group">
                                <label>Profile Picture</label>
                                <div class="upload-btn" id="profileBox">
                                    <i class="bi bi-person-circle"></i>
                                    <span id="profileText">Choose JPG/PNG</span>
                                    <input type="file" name="profilePhoto" id="profilePhoto" accept="image/*" required>
                                </div>
                                <div class="error-msg">Profile photo is required.</div>
                            </div>
                            <div class="fdf-group">
                                <label>ID Proof (PDF/IMG)</label>
                                <div class="upload-btn" id="identityBox">
                                    <i class="bi bi-file-earmark-lock"></i>
                                    <span id="identityText">Choose File</span>
                                    <input type="file" name="identityDoc" id="identityDoc" accept="image/*,.pdf" required>
                                </div>
                                <div class="error-msg">Identity proof is required.</div>
                            </div>
                        </div>

                        <div style="display:flex; justify-content:space-between; gap:20px; margin-top:30px;">
                            <button type="button" class="btn-dr btn-dr-prev" onclick="showStep(1)">Back</button>
                            <button type="submit" class="btn-dr btn-dr-next" style="margin-top:0;">Initialize Partnership</button>
                        </div>
                    </div>
                </form>

                <div class="login-link">
                    Already a registered partner? <a href="${pageContext.request.contextPath}/women-products/seller/login">Sign in here</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showStep(s) {
            document.querySelectorAll('.dr-step-panel').forEach(p => p.classList.remove('active'));
            document.getElementById('step' + s).classList.add('active');
            document.querySelectorAll('.dr-step-dot').forEach(d => {
                const step = parseInt(d.dataset.step);
                d.classList.remove('active', 'completed');
                if (step === s) d.classList.add('active');
                else if (step < s) d.classList.add('completed');
            });
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        const validateField = (el) => {
            let isValid = true;
            const val = el.value.trim();
            const err = el.parentElement.querySelector('.error-msg') || el.parentElement.parentElement.querySelector('.error-msg');

            if (el.hasAttribute('required') && !val && el.type !== 'file') isValid = false;
            if (el.type === 'file' && el.hasAttribute('required') && el.files.length === 0) isValid = false;
            
            if (isValid && el.id === 'fullName') isValid = val.length >= 3;
            if (isValid && el.id === 'phone') isValid = /^[6-9]\d{9}$/.test(val);
            if (isValid && el.id === 'email') isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
            if (isValid && el.id === 'password') isValid = val.length >= 6 && /[A-Z]/.test(val) && /\d/.test(val) && /[!@#$%^&*(),.?":{}|<>]/.test(val);
            if (isValid && el.id === 'address') isValid = val.length >= 10;

            if (isValid) {
                el.classList.remove('is-invalid');
                if (el.type === 'file') el.parentElement.classList.remove('is-invalid');
                if (err) err.style.display = 'none';
            } else {
                el.classList.add('is-invalid');
                if (el.type === 'file') el.parentElement.classList.add('is-invalid');
                if (err) err.style.display = 'block';
            }
            return isValid;
        };

        function nextStep(s) {
            const panel = document.getElementById('step' + s);
            const fields = panel.querySelectorAll('.fdf-input, input[type="file"]');
            let allValid = true;
            fields.forEach(f => { if (!validateField(f)) allValid = false; });
            if (allValid) showStep(s + 1);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const togglePassword = document.getElementById('togglePassword');
            if (togglePassword) {
                togglePassword.addEventListener('click', function() {
                    const password = document.getElementById('password');
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);
                    this.classList.toggle('bi-eye');
                    this.classList.toggle('bi-eye-slash');
                });
            }
            document.getElementById('profilePhoto').addEventListener('change', function() {
                if (this.files[0]) document.getElementById('profileText').innerText = this.files[0].name;
            });
            document.getElementById('identityDoc').addEventListener('change', function() {
                if (this.files[0]) document.getElementById('identityText').innerText = this.files[0].name;
            });

            document.getElementById('sellerForm').addEventListener('submit', function(e) {
                const currentPanel = document.querySelector('.dr-step-panel.active');
                const fields = currentPanel.querySelectorAll('.fdf-input, input[type="file"]');
                let allValid = true;
                fields.forEach(f => { if (!validateField(f)) allValid = false; });
                if (!allValid) e.preventDefault();
            });
        });
    </script>
</body>
</html>

