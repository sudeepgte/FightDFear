<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stylist Registration — Fight D Fear</title>
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

        .password-strength-container { margin-top: 10px; }
        .strength-bar { height: 6px; border-radius: 10px; background: #e2e8f0; width: 100%; overflow: hidden; }
        .strength-fill { height: 100%; width: 0; transition: 0.3s ease; }
        .strength-text { font-size: 0.7rem; font-weight: 800; text-transform: uppercase; margin-top: 5px; display: block; }

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
            .fdf-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress { justify-content: center; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .reg-card h2 { font-size: 1.5rem; padding-left: 15px; }
            .fdf-input { padding: 12px 15px; border-radius: 12px; }
            .btn-dr { padding: 14px 20px; }
            .dr-step-dot { width: 32px; height: 32px; font-size: 0.8rem; }
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
                    <li><span class="feat-icon"><i class="bi bi-gem"></i></span> Elite Beauty & Safety Network</li>
                    <li><span class="feat-icon"><i class="bi bi-patch-check-fill"></i></span> Verified Professional Badge</li>
                    <li><span class="feat-icon"><i class="bi bi-calendar-heart-fill"></i></span> Personalized Safety Bookings</li>
                    <li><span class="feat-icon"><i class="bi bi-magic"></i></span> Empowering Glow Community</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="reg-card">
                <div class="dr-progress">
                    <div class="dr-step-dot active" data-step="1" onclick="showStep(1)">1</div>
                    <div class="dr-step-dot" data-step="2" onclick="showStep(2)">2</div>
                </div>

                <a href="${pageContext.request.contextPath}/index" class="back-home"><i class="bi bi-arrow-left"></i> Return Home</a>
                <h2>Join the Elite</h2>

                <c:if test="${not empty error}">
                    <div style="background:#fef2f2; color:#b91c1c; padding:15px 20px; border-radius:14px; font-size:0.9rem; margin-bottom:25px; font-weight:600; border:1px solid #fee2e2;">
                        <i class="bi bi-shield-exclamation me-2"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/stylists/register" method="post" id="stylistRegForm">
                    <!-- Step 1: Personal Profile -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Step 1: Personal Profile</h3>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>First Name</label>
                                <input type="text" name="firstName" id="firstName" class="fdf-input" placeholder="e.g. Priya" required>
                                <div class="error-msg" id="err-firstName">Required (Min 2 chars, alphabets only).</div>
                            </div>
                            <div class="fdf-group">
                                <label>Last Name</label>
                                <input type="text" name="lastName" id="lastName" class="fdf-input" placeholder="e.g. Sharma" required>
                                <div class="error-msg" id="err-lastName">Required (Min 2 chars, alphabets only).</div>
                            </div>
                        </div>
                        <div class="fdf-group">
                            <label>Email Address</label>
                            <input type="email" name="email" id="email" class="fdf-input" placeholder="priya@example.com" required>
                            <div class="error-msg" id="err-email">Valid email is required (e.g., name@domain.com).</div>
                        </div>
                        <div class="fdf-group">
                            <label>Password</label>
                            <input type="password" name="password" id="password" class="fdf-input" placeholder="Create a strong password" required>
                            <div class="error-msg" id="err-password">6-8 chars (1 Uppercase & 1 Number required).</div>
                            <div class="password-strength-container" id="strengthContainer" style="display:none;">
                                <div class="strength-bar"><div id="strengthFill" class="strength-fill"></div></div>
                                <span id="strengthText" class="strength-text"></span>
                            </div>
                        </div>
                        
                        <button type="button" class="btn-dr btn-dr-next" id="btn-next-1" onclick="nextStep(1)">Continue to Expertise</button>
                    </div>

                    <!-- Step 2: Professional Expertise -->
                    <div class="dr-step-panel" id="step2">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker); font-family:'Montserrat'; font-weight: 800;">Step 2: Professional Expertise</h3>
                        
                        <div class="fdf-group">
                            <label>Specialization</label>
                            <input type="text" name="specialization" id="specialization" class="fdf-input" placeholder="e.g. Hair Styling, Bridal Makeup" required>
                            <div class="error-msg" id="err-specialization">Required (Min 3-5 characters).</div>
                        </div>

                        <div class="fdf-group">
                            <label>Experience (Years)</label>
                            <input type="number" name="experienceInYears" id="experience" class="fdf-input" placeholder="0" min="0" max="50" required>
                            <div class="error-msg" id="err-experience">Required (Range: 0-50 years).</div>
                        </div>

                        <div style="display:flex; justify-content:space-between; gap:20px; margin-top:30px;">
                            <button type="button" class="btn-dr btn-dr-prev" onclick="showStep(1)">Back</button>
                            <button type="submit" class="btn-dr btn-dr-next" id="btn-submit" style="margin-top:0;">Create Professional Profile</button>
                        </div>
                    </div>
                </form>

                <div class="login-link">
                    Already have an account? <a href="${pageContext.request.contextPath}/stylists/login">Login Here</a>
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
            checkFormValidity();
        }

        function updatePasswordStrength(password) {
            const container = document.getElementById('strengthContainer');
            const fill = document.getElementById('strengthFill');
            const text = document.getElementById('strengthText');
            
            if (!password) {
                container.style.display = 'none';
                return;
            }
            container.style.display = 'block';

            let strength = 0;
            if (password.length >= 6) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[!@#$%^&*]/.test(password)) strength++;

            const colors = ['#ef4444', '#f59e0b', '#10b981', '#059669'];
            const labels = ['Weak', 'Fair', 'Strong', 'Excellent'];
            
            fill.style.width = (strength * 25) + '%';
            fill.style.background = colors[strength - 1] || '#ef4444';
            text.innerText = labels[strength - 1] || 'Too Weak';
            text.style.color = colors[strength - 1] || '#ef4444';
        }

        const validateField = (el) => {
            let isValid = true;
            const val = el.value.trim();
            const fieldId = el.id;
            const errorEl = document.getElementById('err-' + fieldId);

            if (el.hasAttribute('required') && !val) {
                isValid = false;
            } else {
                if (fieldId === 'firstName' || fieldId === 'lastName') {
                    isValid = val.length >= 2 && /^[a-zA-Z\s]+$/.test(val);
                } else if (fieldId === 'email') {
                    isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
                } else if (fieldId === 'password') {
                    isValid = val.length >= 6 && val.length <= 8 && /[A-Z]/.test(val) && /\d/.test(val);
                    updatePasswordStrength(val);
                } else if (fieldId === 'specialization') {
                    isValid = val.length >= 3;
                } else if (fieldId === 'experience') {
                    const num = parseInt(val);
                    isValid = !isNaN(num) && num >= 0 && num <= 50;
                }
            }

            if (isValid) {
                el.classList.remove('is-invalid');
                el.classList.add('is-valid');
                if (errorEl) errorEl.style.display = 'none';
            } else {
                el.classList.remove('is-valid');
                el.classList.add('is-invalid');
                if (errorEl) errorEl.style.display = 'block';
            }
            
            checkFormValidity();
            return isValid;
        };

        function checkFormValidity() {
            const step1Fields = ['firstName', 'lastName', 'email', 'password'];
            const step2Fields = ['specialization', 'experience'];
            
            const isStep1Valid = step1Fields.every(id => {
                const el = document.getElementById(id);
                return el && el.classList.contains('is-valid');
            });

            const isStep2Valid = step2Fields.every(id => {
                const el = document.getElementById(id);
                return el && el.classList.contains('is-valid');
            });

            const nextBtn = document.getElementById('btn-next-1');
            if (nextBtn) nextBtn.disabled = !isStep1Valid;
            const submitBtn = document.getElementById('btn-submit');
            if (submitBtn) submitBtn.disabled = !isStep2Valid;
        }

        function nextStep(s) {
            const panel = document.getElementById('step' + s);
            const fields = panel.querySelectorAll('.fdf-input');
            let allValid = true;
            fields.forEach(f => { if (!validateField(f)) allValid = false; });
            if (allValid) showStep(s + 1);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll('.fdf-input');
            inputs.forEach(input => {
                input.addEventListener('input', () => validateField(input));
                input.addEventListener('change', () => validateField(input));
            });

            document.getElementById('stylistRegForm').addEventListener('submit', function(e) {
                const fields = document.querySelectorAll('.fdf-input');
                let allValid = true;
                fields.forEach(f => { if (!validateField(f)) allValid = false; });
                if (!allValid) {
                    e.preventDefault();
                    if (!document.getElementById('step2').classList.contains('active')) showStep(1);
                }
            });

            checkFormValidity();
        });
    </script>
</body>
</html>

