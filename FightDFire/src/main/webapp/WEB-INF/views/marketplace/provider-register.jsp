<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Provider Registration</title>
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; min-height: 100vh; display: flex; background: #fff; color: var(--fdf-text); }
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
        .reg-card { width: 100%; max-width: 600px; }
        .reg-card h2 { font-family: 'Montserrat', sans-serif; font-size: 2rem; font-weight: 900; color: var(--brand-purple-darker); margin-bottom: 30px; border-left: 5px solid var(--brand-pink); padding-left: 15px; }
        .fdf-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px; }
        .fdf-group { margin-bottom: 15px; }
        .fdf-group label { display: block; font-size: 0.8rem; font-weight: 800; color: var(--brand-purple-dark); margin-bottom: 8px; text-transform: uppercase; }
        .fdf-input { width: 100%; padding: 12px 16px; border: 1px solid var(--fdf-border); border-radius: 12px; background: #fdf2f8; outline: none; transition: 0.3s; font-family: inherit; }
        .fdf-input:focus { border-color: var(--brand-pink); background: #fff; box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05); }

        .btn-dr { padding: 14px 28px; border-radius: 12px; font-weight: 800; cursor: pointer; transition: 0.3s; border: none; font-size: 1rem; }
        .btn-dr-next { background: var(--gradient-primary); color: #fff; box-shadow: 0 8px 20px rgba(124, 45, 94, 0.2); width: 100%; margin-top: 10px; }
        .btn-dr-prev { background: #f1f5f9; color: var(--fdf-muted); width: 100%; }

        .dr-progress { display: flex; justify-content: flex-start; gap: 15px; margin-bottom: 30px; }
        .dr-step-dot { width: 32px; height: 32px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; cursor: pointer; transition: 0.3s; color: var(--fdf-muted); }
        .dr-step-dot.active { background: var(--brand-pink); color: #fff; transform: scale(1.15); box-shadow: 0 0 15px rgba(219, 39, 119, 0.3); }
        .dr-step-dot.completed { background: var(--brand-purple); color: #fff; }
        
        .dr-step-panel { display: none; animation: fadeIn 0.4s ease; }
        .dr-step-panel.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 992px) {
            body { flex-direction: column; }
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

        @media (max-width: 600px) {
            .fdf-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress { justify-content: center; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .reg-card h2 { font-size: 1.5rem; }
            .fdf-input { padding: 10px 14px; }
            .btn-dr { padding: 12px 20px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo"><i class="bi bi-shop"></i> Fight D Fear</div>
                <p class="brand-tagline">Join our marketplace of trusted safety services and products. Expand your reach today.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-patch-check-fill"></i></span> Verified Local Vendors for Quick Assistance</li>
                    <li><span class="feat-icon"><i class="bi bi-clock-fill"></i></span> Emergency Services Available 24/7</li>
                    <li><span class="feat-icon"><i class="bi bi-star-fill"></i></span> Trusted & Reviewed Service Providers</li>
                    <li><span class="feat-icon"><i class="bi bi-lightning-fill"></i></span> Fast Response When You Need Help Most</li>
                </ul>
            </div>
        </div>
        <div class="form-panel">
            <div class="reg-card">
                <div class="dr-progress">
                    <div class="dr-step-dot active" data-step="1" onclick="showStep(1)" style="cursor:pointer;">1</div>
                    <div class="dr-step-dot" data-step="2" onclick="showStep(2)" style="cursor:pointer;">2</div>
                </div>

                <h2>Provider Partner</h2>
                <p style="color:var(--fdf-muted); margin-bottom:25px;">Register your services to Join the platform</p>
                <c:if test="${not empty error}"><div class="alert alert-danger" style="border-radius:12px; padding:12px; font-size:0.9rem; margin-bottom:20px;">${error}</div></c:if>
                
                <form action="${pageContext.request.contextPath}/marketplace/provider/register" method="post" enctype="multipart/form-data" id="providerForm">
                    <!-- Step 1: Account Information -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker);">Account Details</h3>
                        <div class="fdf-row">
                            <div class="fdf-group"><label>Full Name</label><input class="fdf-input" name="fullName" placeholder="Priya Sharma" required></div>
                            <div class="fdf-group"><label>Email</label><input class="fdf-input" type="email" name="email" placeholder="priya@example.com" required></div>
                        </div>
                        <div class="fdf-row">
                            <div class="fdf-group"><label>Phone</label><input class="fdf-input" type="tel" name="phone" placeholder="10-digit number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required></div>
                            <div class="fdf-group"><label>Password</label><input class="fdf-input" type="password" name="password" placeholder="••••••••" required></div>
                        </div>
                        <button type="button" class="btn-dr btn-dr-next" onclick="nextStep(1)">Continue to Professional Details</button>
                    </div>

                    <!-- Step 2: Professional Details -->
                    <div class="dr-step-panel" id="step2">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker);">Professional Details</h3>
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Category</label>
                                <select class="fdf-input" name="category" id="categorySelect" required>
                                    <option value="" disabled ${empty param.category ? 'selected' : ''}>Choose a category</option>
                                    <option value="TUTOR" ${param.category == 'TUTOR' ? 'selected' : ''}>Tutor</option>
                                    <option value="HOME_BAKER" ${param.category == 'HOME_BAKER' ? 'selected' : ''}>Home Baker</option>
                                    <option value="LANGUAGE_TRAINER" ${param.category == 'LANGUAGE_TRAINER' ? 'selected' : ''}>Language Trainer</option>
                                    <option value="WOMEN_PRODUCTS" ${param.category == 'WOMEN_PRODUCTS' ? 'selected' : ''}>Women Products</option>
                                    <option value="WOMEN_LAWYER" ${param.category == 'WOMEN_LAWYER' ? 'selected' : ''}>Women Lawyer</option>
                                    <option value="FITNESS_ZUMBA" ${param.category == 'FITNESS_ZUMBA' ? 'selected' : ''}>Fitness Zumba</option>
                                </select>
                            </div>
                            <div class="fdf-group"><label>Location</label><input class="fdf-input" name="locationText" placeholder="City / Area" required></div>
                        </div>
                        <div class="fdf-group"><label>Profile Bio / Description</label><textarea class="fdf-input" name="description" rows="3" maxlength="300" placeholder="Tell us about your services..." required></textarea></div>
                        <div class="fdf-group"><label>Gov ID Identification (PDF/IMG)</label><input class="fdf-input" type="file" name="identityDoc" style="padding:10px;" required></div>
                        
                        <div style="display:flex; justify-content:space-between; gap:15px; margin-top:20px;">
                            <button type="button" class="btn-dr btn-dr-prev w-50" onclick="showStep(1)">Back</button>
                            <button type="submit" class="btn-dr btn-dr-next w-50" style="margin-top:0;">Initialize Partnership</button>
                        </div>
                    </div>
                </form>
                <p style="text-align:center; margin-top:20px; font-size:0.9rem;">Already registered? <a href="${pageContext.request.contextPath}/marketplace/provider/login" style="color:var(--brand-pink); font-weight:800; text-decoration:none;">Sign In</a></p>
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
        function nextStep(s) {
            const panel = document.getElementById('step' + s);
            const req = panel.querySelectorAll('[required]');
            let valid = true;
            req.forEach(el => { if (!el.value) { el.style.borderColor = 'red'; valid = false; } else { el.style.borderColor = ''; } });
            if (valid) showStep(s + 1);
        }
    </script>
</body>
</html>

