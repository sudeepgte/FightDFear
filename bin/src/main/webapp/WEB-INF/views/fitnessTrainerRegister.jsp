<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fitness Trainer Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            color: #1e293b;
            background-color: #f1f5f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .main-wrapper {
            width: 100%;
            height: 100vh;
            background: #ffffff;
            display: flex;
            overflow: hidden;
        }

        /* ─── Left Column ─── */
        .left-col {
            width: 38%;
            background: linear-gradient(180deg, #fff0f2 0%, #f3ebfc 100%);
            padding: 40px;
            display: flex;
            flex-direction: column;
            position: relative;
            justify-content: space-between;
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #6366f1;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 25px;
            transition: color 0.2s;
        }
        .btn-back i { font-size: 1.1rem; }
        .btn-back:hover { color: #4338ca; }

        .left-col h1 {
            font-size: 2.2rem;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.2;
            margin-bottom: 5px;
        }
        .left-col h1 span {
            color: #f43f5e;
            display: block;
        }
        .left-col > p {
            color: #475569;
            font-size: 0.95rem;
            margin-bottom: 40px;
            font-weight: 500;
            line-height: 1.5;
        }

        .features-list {
            display: flex;
            flex-direction: column;
            gap: 25px;
            flex: 1;
        }
        .feature-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }
        .feature-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            color: #f43f5e;
            box-shadow: 0 4px 10px rgba(244,63,94,0.1);
            flex-shrink: 0;
        }
        .feature-text h4 {
            font-size: 0.95rem;
            font-weight: 700;
            margin: 0 0 3px 0;
            color: #1e293b;
        }
        .feature-text p {
            font-size: 0.8rem;
            color: #64748b;
            margin: 0;
            line-height: 1.4;
        }

        .trainers-image {
            width: 100%;
            margin-top: auto;
            text-align: center;
        }
        .trainers-image img {
            max-width: 100%;
            max-height: 280px;
            object-fit: contain;
            mix-blend-mode: multiply;
        }

        /* ─── Right Column ─── */
        .right-col {
            width: 62%;
            padding: 40px 50px;
            background: #ffffff;
            overflow-y: auto;
            height: 100vh;
        }
        
        /* Custom scrollbar for right col */
        .right-col::-webkit-scrollbar { width: 6px; }
        .right-col::-webkit-scrollbar-track { background: #f1f5f9; }
        .right-col::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        .right-col::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header h2 {
            font-size: 1.6rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0 0 5px 0;
        }
        .form-header p {
            color: #64748b;
            font-size: 0.9rem;
            margin: 0;
        }

        /* Section Cards */
        .section-card {
            background: #fafaf9;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 25px;
        }
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
        }
        .section-title i {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            background: #ffe4e6;
            color: #f43f5e;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        /* Form Controls */
        .form-label {
            font-size: 0.82rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
        }
        .form-label span.text-danger { color: #f43f5e; }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            padding: 10px 14px;
            font-size: 0.9rem;
            transition: all 0.2s;
            background-color: #ffffff;
        }
        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        .input-group-custom {
            position: relative;
        }
        .input-group-custom i.icon-left {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }
        .input-group-custom .form-control {
            padding-left: 40px;
        }

        /* Validation */
        .form-control.is-valid { border-color: #10b981 !important; }
        .form-control.is-invalid { border-color: #ef4444 !important; }
        .field-feedback {
            font-size: 0.75rem;
            margin-top: 5px;
            display: none;
            align-items: center;
            gap: 4px;
        }
        .field-feedback.error  { color: #ef4444; display: flex; }
        .field-feedback.success { color: #10b981; display: flex; }

        /* Password Strength */
        .strength-bar-wrap { height: 4px; background: #e2e8f0; border-radius: 4px; margin-top: 8px; display: none; }
        .strength-bar { height: 100%; border-radius: 4px; transition: 0.3s; }
        .strength-label { font-size: 0.7rem; font-weight: 600; margin-top: 4px; display: none; }

        /* Specializations Grid */
        .spec-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            gap: 10px;
        }
        .spec-box { display: flex; height: 100%; }
        .spec-box input { display: none; }
        .spec-label {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            background: white;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 10px 8px;
            font-size: 0.8rem;
            font-weight: 500;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            color: #475569;
            line-height: 1.3;
        }
        .spec-label i { color: #94a3b8; }
        .spec-box input:checked + .spec-label {
            background: #fff1f2;
            border-color: #f43f5e;
            color: #f43f5e;
            font-weight: 600;
        }
        .spec-box input:checked + .spec-label i { color: #f43f5e; }

        /* File Upload */
        .file-upload-box {
            border: 1.5px dashed #cbd5e1;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            background: #ffffff;
            transition: all 0.2s;
            cursor: pointer;
            position: relative;
        }
        .file-upload-box:hover { border-color: #94a3b8; background: #f8fafc; }
        .file-upload-box input[type="file"] {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
        }
        .file-upload-box i { font-size: 1.8rem; color: #475569; margin-bottom: 5px; }
        .file-upload-box .title { font-size: 0.85rem; font-weight: 600; color: #1e293b; display: block; }
        .file-upload-box .desc { font-size: 0.75rem; color: #94a3b8; }

        /* Buttons & Footer */
        .btn-register {
            background: linear-gradient(90deg, #6b21a8, #e11d48);
            color: white;
            border: none;
            padding: 16px;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 12px;
            width: 100%;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 15px rgba(225,29,72,0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(225,29,72,0.35);
            color: white;
        }
        .footer-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.85rem;
            color: #64748b;
        }
        .footer-link a {
            color: #e11d48;
            font-weight: 700;
            text-decoration: none;
        }
        .footer-link a:hover { text-decoration: underline; }

        @media (max-width: 992px) {
            body { height: auto; }
            .main-wrapper { flex-direction: column; height: auto; overflow: visible; }
            .left-col, .right-col { width: 100%; padding: 30px; }
            .right-col { height: auto; overflow: visible; }
            .trainers-image { display: none; }
        }
    </style>
</head>
<body>

<div class="main-wrapper">
    <!-- Left Column: Branding & Info -->
    <div class="left-col">
        <a href="${pageContext.request.contextPath}/" class="btn-back">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
        
        <h1>Fitness Trainer <span>Registration</span></h1>
        <p>Join our platform and connect with clients looking for professional fitness guidance.</p>
        
        <div class="features-list">
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-people"></i></div>
                <div class="feature-text">
                    <h4>Manage your fitness profile</h4>
                    <p>Create and manage your professional trainer profile.</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-person-plus-fill"></i></div>
                <div class="feature-text">
                    <h4>Connect with clients</h4>
                    <p>Get discovered by clients looking for your expertise.</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-currency-rupee"></i></div>
                <div class="feature-text">
                    <h4>Set your session fees</h4>
                    <p>Set your own fees and grow your fitness business.</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-file-earmark-check"></i></div>
                <div class="feature-text">
                    <h4>Showcase certifications</h4>
                    <p>Highlight your skills and certified qualifications.</p>
                </div>
            </div>
        </div>


    </div>

    <!-- Right Column: Registration Form -->
    <div class="right-col">
        <div class="form-header">
            <h2>Create your trainer account</h2>
            <p>Register to offer wellness & fitness services to women on our platform.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 small py-2 px-3 mb-4 rounded-3">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <form id="registerForm" action="${pageContext.request.contextPath}/fitness/trainer/register" method="POST" enctype="multipart/form-data" novalidate>
            
            <!-- Section 1: Personal Details -->
            <div class="section-card">
                <div class="section-title"><i class="bi bi-person-fill"></i> Personal Details</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Full Name <span class="text-danger">*</span></label>
                        <div class="input-group-custom">
                            <i class="bi bi-person icon-left"></i>
                            <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. Jessica Smith" required oninput="validateName(this)">
                        </div>
                        <div class="field-feedback" id="fullName-fb"></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email Address <span class="text-danger">*</span></label>
                        <div class="input-group-custom">
                            <i class="bi bi-envelope icon-left"></i>
                            <input type="email" id="email" name="email" class="form-control" placeholder="jessica.smith@example.com" required oninput="validateEmail(this)">
                        </div>
                        <div class="field-feedback" id="email-fb"></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                        <div class="input-group-custom">
                            <i class="bi bi-telephone icon-left"></i>
                            <input type="tel" id="phone" name="phone" class="form-control" placeholder="10-digit number starting with 6-9" maxlength="10" required oninput="validatePhone(this)">
                        </div>
                        <div class="field-feedback" id="phone-fb"></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Password <span class="text-danger">*</span></label>
                        <div class="input-group-custom">
                            <i class="bi bi-lock icon-left"></i>
                            <input type="password" id="passwordInput" name="password" class="form-control" style="padding-right: 40px;" placeholder="••••••••" required oninput="validatePassword(this)">
                            <i class="bi bi-eye" id="togglePassword" style="position:absolute; right:12px; top:50%; transform:translateY(-50%); cursor:pointer; color:#94a3b8; font-size:1.1rem; z-index:10;"></i>
                        </div>
                        <div class="strength-bar-wrap" id="strengthBarWrap"><div class="strength-bar" id="strengthBar"></div></div>
                        <div class="strength-label" id="strengthLabel"></div>
                        <div class="field-feedback" id="password-fb"></div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">Professional Bio / About Me <span class="text-danger">*</span></label>
                        <div class="input-group-custom">
                            <textarea id="bio" name="bio" class="form-control" rows="3" placeholder="Tell clients about your coaching style, philosophy, and background..." required oninput="validateBio(this)"></textarea>
                        </div>
                        <div class="field-feedback" id="bio-fb" style="margin-top: 5px;"></div>
                    </div>
                </div>
            </div>

            <!-- Section 2: Professional Details -->
            <div class="section-card">
                <div class="section-title"><i class="bi bi-briefcase-fill"></i> Professional Details</div>
                
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Experience (Years) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" id="experience" name="experience" class="form-control" placeholder="e.g. 5" min="0" required oninput="validateExperience(this)">
                            <span class="input-group-text bg-white text-muted" style="font-size:0.8rem;">Years</span>
                        </div>
                        <div class="field-feedback" id="experience-fb"></div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fee per Session (₹) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" id="sessionFees" name="sessionFees" class="form-control" placeholder="e.g. 300" min="1" required oninput="validateFees(this)">
                            <span class="input-group-text bg-white text-muted" style="font-size:0.8rem;">/ Session</span>
                        </div>
                        <div class="field-feedback" id="sessionFees-fb"></div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Available Hours <span class="text-danger">*</span></label>
                        <input type="hidden" id="availableTimings" name="availableTimings" required>
                        <div class="d-flex align-items-center gap-2">
                            <input type="time" class="form-control px-2" id="timeStart" onchange="updateTimings()">
                            <span class="text-muted fw-bold">-</span>
                            <input type="time" class="form-control px-2" id="timeEnd" onchange="updateTimings()">
                        </div>
                        <div class="field-feedback" id="availableTimings-fb"></div>
                    </div>
                </div>

                <label class="form-label">Select Specialization Categories <span class="text-danger">*</span></label>
                <div class="spec-grid mb-2" id="specGrid">
                    <c:forEach var="cat" items="${categories}">
                        <div class="spec-box">
                            <input type="checkbox" name="specializations" value="${cat}" id="spec_${cat}" onchange="validateSpecializations()">
                            <label class="spec-label" for="spec_${cat}"><i class="bi bi-check2-circle"></i> ${cat}</label>
                        </div>
                    </c:forEach>
                </div>
                <div class="field-feedback mb-4" id="spec-fb"></div>

                <div class="row g-3 mt-1">
                    <div class="col-md-6">
                        <label class="form-label">Profile Photo <span class="text-danger">*</span></label>
                        <div class="file-upload-box">
                            <input type="file" id="profilePhoto" name="profilePhoto" accept="image/jpeg,image/png,image/jpg,image/webp" required onchange="validatePhoto(this); updateFileName(this, 'photoName')">
                            <i class="bi bi-cloud-arrow-up"></i>
                            <span class="title" id="photoName">Upload Photo</span>
                            <span class="desc">JPG, PNG, WEBP &ndash; max 5 MB</span>
                        </div>
                        <div class="field-feedback" id="profilePhoto-fb"></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Certification Document <span class="text-danger">*</span></label>
                        <div class="file-upload-box">
                            <input type="file" id="certificationDoc" name="certificationDoc" accept="application/pdf,image/jpeg,image/png,image/jpg" required onchange="validateCertDoc(this); updateFileName(this, 'certName')">
                            <i class="bi bi-cloud-arrow-up"></i>
                            <span class="title" id="certName">Upload Document</span>
                            <span class="desc">PDF, JPG, PNG &ndash; max 10 MB</span>
                        </div>
                        <div class="field-feedback" id="certificationDoc-fb"></div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-register" id="submitBtn">
                <i class="bi bi-person-plus-fill"></i> Register as Trainer
            </button>
        </form>

        <div class="footer-link">
            Already registered? <a href="${pageContext.request.contextPath}/fitness/trainer/login">Trainer Login Here</a>
        </div>
    </div>
</div>

<script>
    /* Support Start/End Time UI to hidden availableTimings mapping */
    function updateTimings() {
        const start = document.getElementById('timeStart').value;
        const end = document.getElementById('timeEnd').value;
        const hidden = document.getElementById('availableTimings');
        
        if (start && end) {
            hidden.value = start + '-' + end;
            validateTimings(hidden);
        } else {
            hidden.value = '';
            setInvalid(hidden, 'availableTimings-fb', 'Please select both start and end times.');
        }
    }

    function updateFileName(input, labelId) {
        if(input.files && input.files[0]) {
            document.getElementById(labelId).innerText = input.files[0].name;
            document.getElementById(labelId).style.color = '#f43f5e';
        }
    }


    /* ─── Helpers ─── */
    function setValid(el, fbId, msg) {
        el.classList.remove('is-invalid'); el.classList.add('is-valid');
        const fb = document.getElementById(fbId);
        fb.className = 'field-feedback success';
        fb.innerHTML = '<i class="bi bi-check-circle-fill"></i> ' + msg;
    }
    function setInvalid(el, fbId, msg) {
        el.classList.remove('is-valid'); el.classList.add('is-invalid');
        const fb = document.getElementById(fbId);
        fb.className = 'field-feedback error';
        fb.innerHTML = '<i class="bi bi-x-circle-fill"></i> ' + msg;
    }
    function clearState(el, fbId) {
        el.classList.remove('is-valid', 'is-invalid');
        const fb = document.getElementById(fbId);
        fb.className = 'field-feedback';
        fb.innerHTML = '';
    }

    /* ─── Full Name ─── */
    function validateName(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'fullName-fb', 'Full name is required.'); return false; }
        if (!/^[A-Za-z\s]{3,50}$/.test(v)) { setInvalid(el, 'fullName-fb', 'Only letters & spaces, 3–50 characters.'); return false; }
        setValid(el, 'fullName-fb', 'Looks good!'); return true;
    }

    /* ─── Email ─── */
    function validateEmail(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'email-fb', 'Email address is required.'); return false; }
        const emailRegex = /^[a-zA-Z][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(v)) { setInvalid(el, 'email-fb', 'Enter a valid email (e.g. coach@fitness.com). Must start with a letter.'); return false; }
        setValid(el, 'email-fb', 'Valid email address.'); return true;
    }

    /* ─── Phone ─── */
    function validatePhone(el) {
        // Strip non-digits as user types
        el.value = el.value.replace(/[^0-9]/g, '').slice(0, 10);
        const v = el.value;
        if (!v) { setInvalid(el, 'phone-fb', 'Phone number is required.'); return false; }
        if (!/^[6-9][0-9]{9}$/.test(v)) { setInvalid(el, 'phone-fb', 'Must be 10 digits starting with 6, 7, 8, or 9.'); return false; }
        setValid(el, 'phone-fb', 'Valid Indian mobile number.'); return true;
    }

    /* ─── Password + Strength ─── */
    function validatePassword(el) {
        const v = el.value;
        const wrap = document.getElementById('strengthBarWrap');
        const bar  = document.getElementById('strengthBar');
        const lbl  = document.getElementById('strengthLabel');

        if (!v) {
            wrap.style.display = 'none'; lbl.style.display = 'none';
            setInvalid(el, 'password-fb', 'Password is required.'); return false;
        }

        // Strength calculation
        let score = 0;
        if (v.length >= 8)  score++;
        if (/[A-Z]/.test(v)) score++;
        if (/[a-z]/.test(v)) score++;
        if (/[0-9]/.test(v)) score++;
        if (/[^A-Za-z0-9]/.test(v)) score++;

        const levels = [
            { w: '20%',  bg: '#ef4444', t: 'Very Weak',  c: '#ef4444' },
            { w: '40%',  bg: '#f97316', t: 'Weak',       c: '#f97316' },
            { w: '60%',  bg: '#eab308', t: 'Fair',       c: '#eab308' },
            { w: '80%',  bg: '#22c55e', t: 'Strong',     c: '#22c55e' },
            { w: '100%', bg: '#10b981', t: 'Very Strong', c: '#10b981' }
        ];
        const lvl = levels[score - 1] || levels[0];
        wrap.style.display = 'block'; lbl.style.display = 'block';
        bar.style.width = lvl.w; bar.style.background = lvl.bg;
        lbl.style.color = lvl.c; lbl.textContent = lvl.t;

        if (v.length < 8) { setInvalid(el, 'password-fb', 'Password must be at least 8 characters.'); return false; }
        if (!/[A-Za-z]/.test(v)) { setInvalid(el, 'password-fb', 'Password must contain at least one letter.'); return false; }
        if (!/[0-9]/.test(v)) { setInvalid(el, 'password-fb', 'Password must contain at least one number.'); return false; }
        setValid(el, 'password-fb', 'Password meets requirements.'); return true;
    }

    /* ─── Bio ─── */
    function validateBio(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'bio-fb', 'Bio is required.'); return false; }
        if (v.length < 10) { setInvalid(el, 'bio-fb', 'Please write at least 10 characters.'); return false; }
        setValid(el, 'bio-fb', 'Looks good.'); return true;
    }

    /* ─── Experience ─── */
    function validateExperience(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'experience-fb', 'Experience is required.'); return false; }
        const n = parseFloat(v);
        if (isNaN(n) || n < 0) { setInvalid(el, 'experience-fb', 'Enter a valid number (0 or more).'); return false; }
        if (n > 50) { setInvalid(el, 'experience-fb', 'Seems too high — max 50 years.'); return false; }
        setValid(el, 'experience-fb', 'Valid.'); return true;
    }

    /* ─── Session Fees ─── */
    function validateFees(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'sessionFees-fb', 'Fee per session is required.'); return false; }
        const n = parseFloat(v);
        if (isNaN(n) || n < 1) { setInvalid(el, 'sessionFees-fb', 'Fee must be at least ₹1.'); return false; }
        if (n > 100000) { setInvalid(el, 'sessionFees-fb', 'Fee seems unreasonably high.'); return false; }
        setValid(el, 'sessionFees-fb', '₹' + n + ' per session.'); return true;
    }

    /* ─── Available Timings ─── */
    function validateTimings(el) {
        const v = el.value.trim();
        if (!v) { setInvalid(el, 'availableTimings-fb', 'Available hours are required.'); return false; }
        const timePattern = /^([01]?\d|2[0-3]):[0-5]\d[-–]([01]?\d|2[0-3]):[0-5]\d$/;
        if (!timePattern.test(v)) { setInvalid(el, 'availableTimings-fb', 'Use format HH:MM-HH:MM (e.g. 08:00-12:00).'); return false; }
        setValid(el, 'availableTimings-fb', 'Valid time range.'); return true;
    }

    /* ─── Specializations ─── */
    function validateSpecializations() {
        const checked = document.querySelectorAll('input[name="specializations"]:checked').length;
        const grid = document.getElementById('specGrid');
        const fb   = document.getElementById('spec-fb');
        if (checked === 0) {
            grid.classList.add('is-invalid');
            fb.className = 'field-feedback error';
            fb.innerHTML = '<i class="bi bi-x-circle-fill"></i> Please select at least one specialization.';
            return false;
        }
        grid.classList.remove('is-invalid');
        fb.className = 'field-feedback success';
        fb.innerHTML = '<i class="bi bi-check-circle-fill"></i> ' + checked + ' specialization(s) selected.';
        return true;
    }

    /* ─── Profile Photo ─── */
    function validatePhoto(el) {
        if (!el.files.length) { setInvalid(el, 'profilePhoto-fb', 'Profile photo is required.'); return false; }
        const file = el.files[0];
        const allowed = ['image/jpeg','image/png','image/jpg','image/webp'];
        if (!allowed.includes(file.type)) { setInvalid(el, 'profilePhoto-fb', 'Only JPG, PNG, or WEBP images allowed.'); return false; }
        if (file.size > 5 * 1024 * 1024) { setInvalid(el, 'profilePhoto-fb', 'File size must be under 5 MB.'); return false; }
        setValid(el, 'profilePhoto-fb', file.name + ' selected.'); return true;
    }

    /* ─── Certification Doc ─── */
    function validateCertDoc(el) {
        if (!el.files.length) { setInvalid(el, 'certificationDoc-fb', 'Certification document is required.'); return false; }
        const file = el.files[0];
        const allowed = ['application/pdf','image/jpeg','image/png','image/jpg'];
        if (!allowed.includes(file.type)) { setInvalid(el, 'certificationDoc-fb', 'Only PDF, JPG, or PNG files allowed.'); return false; }
        if (file.size > 10 * 1024 * 1024) { setInvalid(el, 'certificationDoc-fb', 'File size must be under 10 MB.'); return false; }
        setValid(el, 'certificationDoc-fb', file.name + ' selected.'); return true;
    }

    /* ─── Form Submit Validation ─── */
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const checks = [
            validateName(document.getElementById('fullName')),
            validateEmail(document.getElementById('email')),
            validatePhone(document.getElementById('phone')),
            validatePassword(document.getElementById('passwordInput')),
            validateBio(document.getElementById('bio')),
            validateExperience(document.getElementById('experience')),
            validateFees(document.getElementById('sessionFees')),
            validateTimings(document.getElementById('availableTimings')),
            validateSpecializations(),
            validatePhoto(document.getElementById('profilePhoto')),
            validateCertDoc(document.getElementById('certificationDoc'))
        ];
        if (checks.includes(false)) {
            e.preventDefault();
            // Scroll to first invalid field
            const firstInvalid = document.querySelector('.is-invalid');
            if (firstInvalid) firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    });

    /* ─── Password Toggle ─── */
    document.getElementById('togglePassword').addEventListener('click', function() {
        const input = document.getElementById('passwordInput');
        const isPassword = input.getAttribute('type') === 'password';
        input.setAttribute('type', isPassword ? 'text' : 'password');
        this.classList.toggle('bi-eye');
        this.classList.toggle('bi-eye-slash');
    });
</script>
</body>
</html>
