<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join the Movement | User Registration</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS (Assuming it defines the variables) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    
    <style>
        :root {
            --brand-purple: #1e1b4b;
            --brand-purple-dark: #1e1b4b;
            --brand-purple-darker: #3F1430;
            --brand-pink: #f43f5e;
            --brand-pink-light: #FB7185;
            --fdf-border: #f1f3f5;
            --fdf-text: #1e293b;
            --fdf-muted: #64748b;
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --error-red: #ef4444;
            --success-green: #22c55e;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Poppins', sans-serif; 
            min-height: 100vh; 
            display: flex; 
            background: #fff; 
            color: var(--fdf-text); 
        }
        
        .auth-container { flex: 1; display: flex; width: 100%; }
        
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
            font-size: 2rem;
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
        .reg-card { width: 100%; max-width: 650px; }
        .reg-card h2 { font-family: 'Montserrat', sans-serif; font-size: 2.2rem; font-weight: 900; color: var(--brand-purple-darker); margin-bottom: 35px; border-left: 6px solid var(--brand-pink); padding-left: 20px; }

        .fdf-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 20px; }
        .fdf-group { margin-bottom: 20px; position: relative; }
        .fdf-group label { display: block; font-size: 0.75rem; font-weight: 800; color: var(--brand-purple-dark); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px; }
        .fdf-input { width: 100%; padding: 14px 18px; border: 2px solid var(--fdf-border); border-radius: 16px; background: #f8fafc; outline: none; transition: all 0.3s ease; font-family: inherit; font-weight: 500; }
        .fdf-input:focus { border-color: var(--brand-pink); background: #fff; box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05); }
        .password-input-wrap { position: relative; }
        .password-input-wrap .fdf-input { padding-right: 48px; }
        .password-toggle-btn { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); border: none; background: transparent; color: #64748b; cursor: pointer; padding: 4px; font-size: 1.1rem; }

        .btn-dr { padding: 14px 28px; border-radius: 12px; font-weight: 800; cursor: pointer; transition: 0.3s; border: none; font-size: 1rem; width: 100%; }
        .btn-dr-next { background: var(--gradient-primary); color: #fff; box-shadow: 0 8px 20px rgba(124, 45, 94, 0.2); }
        .btn-dr-prev { background: #f1f5f9; color: var(--fdf-muted); }

        .dr-progress { display: flex; justify-content: flex-start; gap: 15px; margin-bottom: 30px; }
        .dr-step-dot { width: 35px; height: 35px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem; cursor: pointer; transition: 0.3s; color: var(--fdf-muted); border: 2px solid #fff; box-shadow: 0 0 0 2px #f1f5f9; }
        .dr-step-dot.active { background: var(--brand-pink); color: #fff; transform: scale(1.1); box-shadow: 0 0 15px rgba(219, 39, 119, 0.3); }
        .dr-step-dot.completed { background: var(--brand-purple); color: #fff; }
        
        .dr-step-panel { display: none; animation: fadeIn 0.4s ease; }
        .dr-step-panel.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .is-invalid { border-color: var(--error-red) !important; background-color: #fef2f2; }
        .error-feedback { color: var(--error-red); font-size: 0.7rem; font-weight: 700; margin-top: 6px; display: none; }

        .back-home { display: inline-flex; align-items: center; gap: 10px; color: var(--fdf-muted); text-decoration: none; font-size: 0.95rem; font-weight: 600; margin-bottom: 30px; transition: 0.3s; }
        .back-home:hover { color: var(--brand-purple); }

        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel {
                min-height: 30vh;
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
            .reg-card h2 { font-size: 1.8rem; margin-bottom: 25px; }
        }

        @media (max-width: 650px) {
            .fdf-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress { justify-content: center; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .reg-card h2 { font-size: 1.5rem; padding-left: 15px; }
            .fdf-input { padding: 12px 15px; }
            .btn-dr { padding: 12px 20px; }
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
                    <li><span class="feat-icon"><i class="bi bi-bell-fill"></i></span> One-tap SOS Emergency Alerts</li>
                    <li><span class="feat-icon"><i class="bi bi-geo-alt-fill"></i></span> Real-time Location Sharing</li>
                    <li><span class="feat-icon"><i class="bi bi-people-fill"></i></span> Verified Volunteer Network</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-lock-fill"></i></span> Self-Defense Training & Resources</li>
                    <li><span class="feat-icon"><i class="bi bi-camera-reels-fill"></i></span> Community Reels & Video Sharing</li>
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
                <h2>User Registration</h2>

                <c:if test="${not empty error}"><div class="alert alert-danger" style="border-radius:12px; padding:12px 16px; font-size:0.9rem; margin-bottom:20px; background:#fef2f2; color:#b91c1c; border:1px solid #fee2e2;">${error}</div></c:if>
                <c:if test="${not empty success}"><div class="alert alert-success" style="border-radius:12px; padding:12px 16px; font-size:0.9rem; margin-bottom:20px; background:#f0fdf4; color:#15803d; border:1px solid #dcfce7;">${success}</div></c:if>

                <form action="${pageContext.request.contextPath}/users/register" method="post" enctype="multipart/form-data" id="userForm">
                    <!-- Step 1: Basic Information -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat';">Basic Information</h3>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Full Name</label>
                                <input type="text" name="fullName" id="fullName" class="fdf-input" placeholder="e.g. Priya Sharma" required>
                                <div class="error-feedback">Name must be at least 3 characters.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Phone Number</label>
                                <input type="tel" name="phoneNumber" id="phoneNumber" class="fdf-input" placeholder="10-digit number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                                <div class="error-feedback">Enter a valid 10-digit number.</div>
                            </div>
                        </div>
                        <div class="fdf-group">
                            <label>Email Address</label>
                            <input type="email" name="email" id="email" class="fdf-input" placeholder="name@example.com" required>
                            <div class="error-feedback">Valid email required.</div>
                        </div>
                        <div class="fdf-group">
                            <label>Password</label>
                            <div class="password-input-wrap">
                                <input type="password" name="password" id="password" class="fdf-input" placeholder="••••••••" required autocomplete="new-password">
                                <button type="button" class="password-toggle-btn" data-toggle-password="password" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-feedback">Min 6 chars with number & uppercase.</div>
                        </div>
                        <div class="fdf-group">
                            <label>Home Address</label>
                            <input type="text" name="homeAddress" id="homeAddress" class="fdf-input" placeholder="Current residential address" required>
                            <div class="error-feedback">Address is required.</div>
                        </div>
                        
                        <button type="button" class="btn-dr btn-dr-next" onclick="nextStep(1)">Continue to Identity Verification</button>
                    </div>

                    <!-- Step 2: Personal & Identity -->
                    <div class="dr-step-panel" id="step2">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat';">Personal & Identity</h3>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Date of Birth</label>
                                <input type="date" id="dob" name="dob" class="fdf-input" required max="<%= java.time.LocalDate.now() %>">
                                <div class="error-feedback">DOB is required and cannot be a future date.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Age</label>
                                <input type="number" id="age" name="age" class="fdf-input" placeholder="Age" required readonly>
                                <div class="error-feedback">Invalid age.</div>
                            </div>
                        </div>

                        <div class="fdf-group">
                            <label>Gender Identification</label>
                            <select name="gender" id="gender" class="fdf-input" required>
                                <option value="">Select Gender</option>
                                <option value="FEMALE">FEMALE</option>
                                <option value="MALE">MALE</option>
                                <option value="OTHER">OTHER</option>
                            </select>
                            <div class="error-feedback">Please select gender.</div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Identity Proof (PDF/IMG)</label>
                                <input type="file" name="identityDoc" id="identityDoc" class="fdf-input" style="padding:10px;" accept="image/*,.pdf" required>
                                <div class="error-feedback">Identity proof required (Image or PDF).</div>
                            </div>
                            <div class="fdf-group">
                                <label>Profile Photo</label>
                                <input type="file" name="image" id="profilePhoto" class="fdf-input" style="padding:10px;" accept="image/*" required>
                                <div class="error-feedback">Photo is required.</div>
                            </div>
                        </div>

                        <div style="display:flex; justify-content:space-between; gap:15px; margin-top:20px;">
                            <button type="button" class="btn-dr btn-dr-prev w-50" onclick="showStep(1)">Back</button>
                            <button type="submit" class="btn-dr btn-dr-next w-50" style="margin-top:0;">Complete Sign Up</button>
                        </div>
                    </div>
                </form>
                
                <p style="text-align:center; margin-top:30px; font-size:0.95rem; color:var(--fdf-muted);">Already protected? <a href="${pageContext.request.contextPath}/login" style="color:var(--brand-pink); font-weight:800; text-decoration:none;">Sign In Now</a></p>
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
        }

        const validateField = (el) => {
            let isValid = true;
            const val = el.value.trim();
            const err = el.parentElement.querySelector('.error-feedback');

            if (el.hasAttribute('required') && !val) isValid = false;
            
            if (isValid && el.id === 'fullName') isValid = val.length >= 3;
            if (isValid && el.id === 'phoneNumber') isValid = /^[6-9]\d{9}$/.test(val);
            if (isValid && el.id === 'email') isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
            if (isValid && el.id === 'password') isValid = val.length >= 6 && /[A-Z]/.test(val) && /\d/.test(val);
            if (isValid && el.id === 'dob') {
                const selectedDate = new Date(val);
                const today = new Date();
                today.setHours(0,0,0,0);
                isValid = selectedDate <= today;
            }
            if (isValid && el.id === 'age') isValid = parseInt(val) >= 10;

            if (isValid) {
                el.classList.remove('is-invalid');
                if (err) err.style.display = 'none';
            } else {
                el.classList.add('is-invalid');
                if (err) err.style.display = 'block';
            }
            return isValid;
        };

        function nextStep(s) {
            const panel = document.getElementById('step' + s);
            const fields = panel.querySelectorAll('.fdf-input');
            let allValid = true;
            fields.forEach(f => { if (!validateField(f)) allValid = false; });
            if (allValid) showStep(s + 1);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const dob = document.getElementById('dob');
            const age = document.getElementById('age');

            // Prevent future dates
            const todayStr = new Date().toISOString().split('T')[0];
            dob.setAttribute('max', todayStr);
            
            dob.addEventListener('change', function() {
                if (this.value) {
                    const birthDate = new Date(this.value);
                    if (!isNaN(birthDate.getTime())) {
                        const today = new Date();
                        let computedAge = today.getFullYear() - birthDate.getFullYear();
                        const m = today.getMonth() - birthDate.getMonth();
                        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                            computedAge--;
                        }
                        age.value = computedAge;
                        validateField(age);
                    }
                }
            });

            document.getElementById('userForm').addEventListener('submit', function(e) {
                const currentPanel = document.querySelector('.dr-step-panel.active');
                const fields = currentPanel.querySelectorAll('.fdf-input');
                let allValid = true;
                fields.forEach(f => { if (!validateField(f)) allValid = false; });
                if (!allValid) e.preventDefault();
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>

