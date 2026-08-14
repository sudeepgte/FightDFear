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
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

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
        .reg-card { width: 100%; max-width: 650px; }
        
        .dr-progress { display:flex; justify-content:space-between; margin-bottom:40px; position: relative; }
        .dr-progress::after {
            content: ''; position: absolute; top: 20px; left: 0; right: 0; height: 2px; 
            background: #f1f5f9; z-index: 1;
        }
        
        .dr-step-item { z-index: 2; text-align: center; width: 40px; cursor: pointer; }
        .dr-step-dot { 
            width:40px; height:40px; border-radius:50%; background:#f1f5f9; 
            display:flex; align-items:center; justify-content:center; 
            font-weight:800; font-size:0.9rem; border:2px solid #fff; 
            transition:0.3s; color:#94a3b8; box-shadow: 0 0 0 2px #f1f5f9;
        }
        .dr-step-item.active .dr-step-dot { background:var(--brand-pink); color:#fff; box-shadow: 0 0 0 2px var(--brand-pink); }
        .dr-step-item.completed .dr-step-dot { background:var(--brand-purple); color:#fff; box-shadow: 0 0 0 2px var(--brand-purple); }
        
        .dr-step-label { font-size: 0.65rem; font-weight: 800; margin-top: 8px; text-transform: uppercase; color: #94a3b8; }
        .dr-step-item.active .dr-step-label { color: var(--brand-pink); }

        .dr-step-panel { display:none; animation:fadeIn 0.4s ease; }
        .dr-step-panel.active { display:block; }
        @keyframes fadeIn { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }

        .fdf-row { display:grid; grid-template-columns: 1fr 1fr; gap:25px; margin-bottom:20px; }
        .fdf-group { margin-bottom:20px; position: relative; }
        .fdf-group label { display:block; font-size:0.75rem; font-weight:800; color:var(--brand-purple-dark); margin-bottom:8px; text-transform:uppercase; }
        .fdf-input { 
            width:100%; padding:14px 18px; border:2px solid var(--fdf-border); 
            border-radius:16px; background:#f8fafc; outline:none; 
            transition:0.3s; font-family:inherit; font-weight: 500;
        }
        .fdf-input:focus { border-color:var(--brand-pink); background:#fff; box-shadow:0 0 0 4px rgba(219,39,119,0.05); }

        .btn-dr { 
            padding:16px 32px; border-radius:14px; font-weight:800; cursor:pointer; 
            transition:0.3s; border:none; font-size: 1rem; width: 100%;
        }
        .btn-dr-next { background:var(--gradient-primary); color:#fff; box-shadow: 0 8px 20px rgba(219,39,119,0.2); }
        .btn-dr-next.is-disabled { opacity: 0.65; cursor: pointer; transform: none !important; pointer-events: auto; }
        .btn-dr-prev { background:#f1f5f9; color:#64748b; }
        .error-msg { display: none; color: var(--error-red); font-size: 0.75rem; margin-top: 6px; font-weight: 600; }
        .password-input-wrap { position: relative; }
        .password-input-wrap .fdf-input { padding-right: 48px; }
        .password-toggle-btn {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: #64748b; cursor: pointer; padding: 4px; font-size: 1.1rem;
        }
        .password-toggle-btn:hover { color: var(--brand-pink); }
        .back-home { display: inline-flex; align-items: center; gap: 6px; color: #64748b; text-decoration: none; font-size: 0.85rem; font-weight: 600; margin-bottom: 20px; }
        .step-hint { display: none; color: var(--error-red); font-size: 0.85rem; margin-bottom: 12px; font-weight: 600; }
        .step-hint.visible { display: block; }
        
        .btn-dr:hover:not(:disabled) { transform: translateY(-2px); filter: brightness(1.1); }

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
            .dr-progress { margin-bottom: 30px; overflow-x: auto; padding-bottom: 10px; justify-content: flex-start; gap: 10px; }
            .dr-step-item { flex-shrink: 0; }
        }

        @media (max-width: 600px) {
            .fdf-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress::-webkit-scrollbar { display: none; }
            .dr-progress { -ms-overflow-style: none; scrollbar-width: none; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .fw-900 { font-size: 1.5rem !important; }
            .fdf-input { padding: 12px 15px; border-radius: 12px; }
            .btn-dr { padding: 14px 20px; }
            .dr-step-dot { width: 35px; height: 35px; font-size: 0.8rem; }
        }

    </style>
</head>
<body>
    <div class="auth-container">

        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo"><i class="bi bi-heart-pulse"></i> Fight D Fear</div>
                <p class="brand-tagline">Providing quality healthcare and support to the community. Dedicated to safety and wellness.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-person-heart"></i></span> Consult Trusted Women Doctors</li>
                    <li><span class="feat-icon"><i class="bi bi-hospital-fill"></i></span> 24/7 Health & Emergency Support</li>
                    <li><span class="feat-icon"><i class="bi bi-clipboard-check-fill"></i></span> Safe & Confidential Guidance</li>
                    <li><span class="feat-icon"><i class="bi bi-calendar-event-fill"></i></span> Book Appointments Easily</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="reg-card">
                <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Back to Home</a>
                <div class="dr-progress">
                    <div class="dr-step-item active" data-step="1">
                        <div class="dr-step-dot">1</div>
                        <div class="dr-step-label">Basic</div>
                    </div>
                    <div class="dr-step-item" data-step="2">
                        <div class="dr-step-dot">2</div>
                        <div class="dr-step-label">Professional</div>
                    </div>
                    <div class="dr-step-item" data-step="3">
                        <div class="dr-step-dot">3</div>
                        <div class="dr-step-label">Location</div>
                    </div>
                    <div class="dr-step-item" data-step="4">
                        <div class="dr-step-dot">4</div>
                        <div class="dr-step-label">Availability</div>
                    </div>
                    <div class="dr-step-item" data-step="5">
                        <div class="dr-step-dot">5</div>
                        <div class="dr-step-label">Verification</div>
                    </div>
                    <div class="dr-step-item" data-step="6">
                        <div class="dr-step-dot">6</div>
                        <div class="dr-step-label">Payment</div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/doctors/register" method="post" enctype="multipart/form-data" id="doctorRegForm" novalidate>
                    <c:if test="${not empty error}"><div class="alert alert-danger mb-4 rounded-4">${error}</div></c:if>

                    <!-- STEP 1: BASIC DETAILS -->
                    <div class="dr-step-panel active" id="step1">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Basic Credentials</h2>
                        
                        <div class="fdf-group">
                            <label>Profile Photo</label>
                            <input type="file" id="profilePhoto" name="profilePhoto" class="fdf-input" accept="image/png, image/jpeg">
                            <div class="error-msg">JPG/PNG only, Max 2MB.</div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="fdf-input" placeholder="e.g. Dr. Priya Sharma">
                                <div class="error-msg">Minimum 3 characters (alphabets only).</div>
                            </div>
                            <div class="fdf-group">
                                <label>Email Address</label>
                                <input type="email" id="email" name="email" class="fdf-input" placeholder="priya@doc.com">
                                <div class="error-msg">Valid email required.</div>
                            </div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Phone Number *</label>
                                <input type="tel" id="phone" name="phone" class="fdf-input" placeholder="e.g. 9876543210" required>
                                <div class="error-msg">Valid 10-digit Indian phone number is required.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Gender</label>
                                <select id="gender" name="gender" class="fdf-input">
                                    <option value="">Select Gender</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="MALE">Male</option>
                                    <option value="OTHER">Other</option>
                                </select>
                                <div class="error-msg">Please select gender.</div>
                            </div>
                        </div>

                        <div class="fdf-group">
                            <label>Account Password</label>
                            <div class="password-input-wrap">
                                <input type="password" id="password" name="password" class="fdf-input" placeholder="••••••••" autocomplete="new-password">
                                <button type="button" class="password-toggle-btn" data-toggle-password="password" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="error-msg">Min 6 characters with 1 uppercase letter and 1 number.</div>
                        </div>

                        <p id="stepValidationHint" class="step-hint">Please complete all required fields above to continue.</p>
                        <button type="button" class="btn-dr btn-dr-next w-100 mt-3 is-disabled" data-next="2">Professional Info <i class="bi bi-arrow-right ms-2"></i></button>
                    </div>

                    <!-- STEP 2: PROFESSIONAL INFO -->
                    <div class="dr-step-panel" id="step2">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Professional Expertise</h2>
                        
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Medical Registration Number</label>
                                <input type="text" id="medicalRegNumber" name="medicalRegNumber" class="fdf-input" placeholder="ABC-12345">
                                <div class="error-msg">Registration number is required.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Years of Experience</label>
                                <input type="number" id="experienceYears" name="experienceYears" class="fdf-input" placeholder="0 - 50">
                                <div class="error-msg">Experience must be 0-50 years.</div>
                            </div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Primary Specialization</label>
                                <select id="specialization" name="specialization" class="fdf-input">
                                    <option value="">Select Specialty</option>
                                    <option value="Gynecologist">Gynecologist</option>
                                    <option value="Psychologist">Psychologist</option>
                                    <option value="General Physician">General Physician</option>
                                    <option value="Pediatrician">Pediatrician</option>
                                    <option value="Dermatologist">Dermatologist</option>
                                </select>
                                <div class="error-msg">Select your specialization.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Qualification</label>
                                <select id="qualification" name="qualification" class="fdf-input">
                                    <option value="">Select Degree</option>
                                    <option value="MBBS">MBBS</option>
                                    <option value="MD">MD</option>
                                    <option value="MS">MS</option>
                                    <option value="DNB">DNB</option>
                                    <option value="PhD">PhD</option>
                                </select>
                                <div class="error-msg">Select your highest qualification.</div>
                            </div>
                        </div>

                        <div class="fdf-group">
                            <label>Hospital / Clinic Name</label>
                            <input type="text" id="hospitalName" name="hospitalName" class="fdf-input" placeholder="Full name of practice">
                            <div class="error-msg">Minimum 3 characters required.</div>
                        </div>

                        <!-- Consultation Type Hidden/Default -->
                        <input type="hidden" name="consultationType" value="CLINIC">

                        <div class="d-flex gap-3 mt-4">
                            <button type="button" class="btn-dr btn-dr-prev flex-fill" data-prev="1">Back</button>
                            <button type="button" class="btn-dr btn-dr-next flex-fill is-disabled" data-next="3">Clinic Location</button>
                        </div>
                    </div>

                    <!-- STEP 3: CLINIC LOCATION -->
                    <div class="dr-step-panel" id="step3">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Clinic Location</h2>
                        
                        <div class="fdf-group">
                            <label>Detailed Practice Address</label>
                            <textarea id="clinicAddress" name="clinicAddress" class="fdf-input" rows="3" placeholder="Street, landmark..."></textarea>
                            <div class="error-msg">Detailed address is required.</div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>City</label>
                                <input type="text" id="city" name="city" class="fdf-input" placeholder="City name">
                                <div class="error-msg">City name (alphabets only).</div>
                            </div>
                            <div class="fdf-group">
                                <label>State</label>
                                <input type="text" id="state" name="state" class="fdf-input" placeholder="State name">
                                <div class="error-msg">State name (alphabets only).</div>
                            </div>
                        </div>

                        <div class="fdf-group">
                            <label>Pincode</label>
                            <input type="text" id="pincode" name="pincode" class="fdf-input" placeholder="6-digit PIN">
                            <div class="error-msg">Valid 6-digit Indian pincode.</div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="button" class="btn-dr btn-dr-prev flex-fill" data-prev="2">Back</button>
                            <button type="button" class="btn-dr btn-dr-next flex-fill is-disabled" data-next="4">Availability</button>
                        </div>
                    </div>

                    <!-- STEP 4: AVAILABILITY -->
                    <div class="dr-step-panel" id="step4">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Practice Hours</h2>
                        
                        <div class="fdf-group">
                            <label>Working Days</label>
                            <div class="d-flex flex-wrap gap-2">
                                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="days"
       value="MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY"/>

<c:forTokens var="day" items="${days}" delims=",">
    <label class="btn btn-outline-purple flex-fill py-2 px-1"
           style="font-size:0.7rem; font-weight:700;">

        <input type="checkbox"
               name="availableDays"
               value="${day}"
               class="d-none">

        ${fn:substring(day,0,3)}
    </label>
</c:forTokens>
                            </div>
                            <div class="error-msg">Select at least one day.</div>
                        </div>

                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Shift Start Time</label>
                                <input type="time" id="startTime" name="startTime" class="fdf-input">
                                <div class="error-msg">Start time required.</div>
                            </div>
                            <div class="fdf-group">
                                <label>Shift End Time</label>
                                <input type="time" id="endTime" name="endTime" class="fdf-input">
                                <div class="error-msg">End time must be after start time.</div>
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="button" class="btn-dr btn-dr-prev flex-fill" data-prev="3">Back</button>
                            <button type="button" class="btn-dr btn-dr-next flex-fill is-disabled" data-next="5">Documentation</button>
                        </div>
                    </div>

                    <!-- STEP 5: VERIFICATION -->
                    <div class="dr-step-panel" id="step5">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Identity Verification</h2>
                        
                        <div class="fdf-group">
                            <label>Medical License / Registration Proof (PDF/IMG)</label>
                            <input type="file" id="medicalLicense" name="medicalLicense" class="fdf-input" style="padding:10px;" accept="image/*,.pdf">
                            <div class="error-msg">Required: JPG, PNG or PDF (Max 2MB).</div>
                        </div>

                        <div class="fdf-group">
                            <label>Government ID Proof (PDF/IMG)</label>
                            <input type="file" id="idProof" name="idProof" class="fdf-input" style="padding:10px;" accept="image/*,.pdf">
                            <div class="error-msg">Required: JPG, PNG or PDF (Max 2MB).</div>
                        </div>

                        <div class="fdf-group">
                            <label>Highest Degree Certificate (PDF/IMG)</label>
                            <input type="file" id="degreeCertificate" name="degreeCertificate" class="fdf-input" style="padding:10px;" accept="image/*,.pdf">
                            <div class="error-msg">Required: JPG, PNG or PDF (Max 2MB).</div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="button" class="btn-dr btn-dr-prev flex-fill" data-prev="4">Back</button>
                            <button type="button" class="btn-dr btn-dr-next flex-fill is-disabled" data-next="6">Payment Setup</button>
                        </div>
                    </div>

                    <!-- STEP 6: PAYMENT SETUP -->
                    <div class="dr-step-panel" id="step6">
                        <h2 class="fw-900 mb-4" style="color:var(--brand-purple-darker); font-family:'Montserrat';">Final Setup</h2>
                        
                        <div class="fdf-row">
                            <div class="fdf-group">
                                <label>Consultation Fee (₹)</label>
                                <input type="number" id="consultationFee" name="consultationFee" class="fdf-input" placeholder="e.g. 500">
                                <div class="error-msg">Must be a positive amount.</div>
                            </div>
                            <div class="fdf-group">
                                <label>UPI ID for Payouts</label>
                                <input type="text" id="upiId" name="upiId" class="fdf-input" placeholder="doctor@upi">
                                <div class="error-msg">Invalid format (e.g., name@bank).</div>
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="button" class="btn-dr btn-dr-prev flex-fill" data-prev="5">Back</button>
                            <button type="submit" id="submitBtn" class="btn-dr btn-dr-next flex-fill is-disabled">Submit Registration</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let currentStep = 1;
            const form = document.getElementById('doctorRegForm');
            const stepPanels = document.querySelectorAll('.dr-step-panel');
            const stepDots = document.querySelectorAll('.dr-step-item');

            const validateStep = (step) => {
                const panel = document.getElementById('step' + step);
                const nextBtn = panel.querySelector('.btn-dr-next');
                let isValid = true;

                if (step === 1) {
                    isValid &= checkFile('profilePhoto', ['jpg','jpeg','png'], 2) &&
                               checkText('fullName', 3, /^[a-zA-Z\s]+$/) &&
                               checkEmail('email') &&
                               checkRegex('phone', /^[6-9]\d{9}$/) &&
                               checkNotEmpty('gender') &&
                               checkPassword('password');
                } else if (step === 2) {
                    isValid &= checkNotEmpty('medicalRegNumber') &&
                               checkRange('experienceYears', 0, 50) &&
                               checkNotEmpty('specialization') &&
                               checkNotEmpty('qualification') &&
                               checkText('hospitalName', 3);
                } else if (step === 3) {
                    isValid &= checkNotEmpty('clinicAddress') &&
                               checkText('city', 1, /^[a-zA-Z\s]+$/) &&
                               checkText('state', 1, /^[a-zA-Z\s]+$/) &&
                               checkRegex('pincode', /^\d{6}$/);
                } else if (step === 4) {
                    const daysSelected = panel.querySelectorAll('input[name="availableDays"]:checked').length > 0;
                    toggleError('availableDays', daysSelected);
                    
                    const start = document.getElementById('startTime').value;
                    const end = document.getElementById('endTime').value;
                    const timeValid = start && end && (end > start);
                    toggleError('endTime', timeValid);
                    toggleError('startTime', start !== "");
                    
                    isValid &= daysSelected && timeValid;
                } else if (step === 5) {
                    isValid &= checkFile('medicalLicense', ['jpg','jpeg','png','pdf'], 2) &&
                               checkFile('idProof', ['jpg','jpeg','png','pdf'], 2) &&
                               checkFile('degreeCertificate', ['jpg','jpeg','png','pdf'], 2);
                } else if (step === 6) {
                    isValid &= checkRange('consultationFee', 1, 100000) &&
                               checkRegex('upiId', /^[\w.-]+@[\w.-]+$/);
                }

                if (nextBtn) {
                    nextBtn.classList.toggle("is-disabled", !isValid);
                    nextBtn.setAttribute("aria-disabled", String(!isValid));
                }
                return isValid;
            };

            const toggleError = (id, valid) => {
                const el = (id === 'availableDays') ? document.querySelector('input[name="availableDays"]').parentElement.parentElement : document.getElementById(id);
                const err = el.parentElement.querySelector('.error-msg');
                if (valid) {
                    el.classList.remove('is-invalid');
                    el.classList.add('is-valid');
                    if(err) err.style.display = 'none';
                } else {
                    el.classList.remove('is-valid');
                    el.classList.add('is-invalid');
                    if(err) err.style.display = 'block';
                }
            };

            const checkNotEmpty = (id) => {
                const val = document.getElementById(id).value.trim();
                const valid = val.length > 0;
                toggleError(id, valid);
                return valid;
            };

            const checkText = (id, min, regex) => {
                const val = document.getElementById(id).value.trim();
                let valid = val.length >= min;
                if (regex) valid &= regex.test(val);
                toggleError(id, valid);
                return valid;
            };

            const checkRegex = (id, regex) => {
                const val = document.getElementById(id).value.trim();
                const valid = regex.test(val);
                toggleError(id, valid);
                return valid;
            };

            const checkRange = (id, min, max) => {
                const val = parseFloat(document.getElementById(id).value);
                const valid = !isNaN(val) && val >= min && val <= max;
                toggleError(id, valid);
                return valid;
            };

            const checkEmail = (id) => {
                const val = document.getElementById(id).value.trim();
                const valid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
                toggleError(id, valid);
                return valid;
            };

            const checkPassword = (id) => {
                const val = document.getElementById(id).value;
                const valid = val.length >= 6 && /[A-Z]/.test(val) && /\d/.test(val);
                toggleError(id, valid);
                return valid;
            };

            const stepHint = document.getElementById('stepValidationHint');

            const focusFirstInvalid = (panel) => {
                const invalid = panel.querySelector('.fdf-input.is-invalid, select.fdf-input.is-invalid');
                if (invalid) {
                    invalid.focus();
                    invalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            };

            const checkFile = (id, allowedExts, maxSizeMB) => {
                const el = document.getElementById(id);
                if (el.files.length === 0) {
                    toggleError(id, false);
                    return false;
                }
                const file = el.files[0];
                const ext = file.name.split('.').pop().toLowerCase();
                const valid = allowedExts.includes(ext) && (file.size <= maxSizeMB * 1024 * 1024);
                toggleError(id, valid);
                return valid;
            };

            // Attach listeners for live validation
            form.addEventListener('input', (e) => {
                if(e.target.id) validateStep(currentStep);
            });
            form.addEventListener('change', (e) => {
                if (e.target.id || e.target.name === 'availableDays') {
                    validateStep(currentStep);
                    if (stepHint) stepHint.classList.remove('visible');
                }
            });

            // Navigation
            document.querySelectorAll('.btn-dr-next').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    if (btn.type === 'submit') return;
                    const next = parseInt(btn.dataset.next, 10);
                    if (!next) return;
                    const panel = document.getElementById('step' + currentStep);
                    if (!validateStep(currentStep)) {
                        e.preventDefault();
                        if (stepHint) stepHint.classList.add('visible');
                        if (panel) focusFirstInvalid(panel);
                        return;
                    }
                    if (stepHint) stepHint.classList.remove('visible');
                    showStep(next);
                });
            });

            document.getElementById('doctorRegForm')?.addEventListener('submit', (e) => {
                if (!validateStep(currentStep)) {
                    e.preventDefault();
                }
            });

            document.querySelectorAll('.btn-dr-prev').forEach(btn => {
                btn.addEventListener('click', () => {
                    showStep(parseInt(btn.dataset.prev));
                });
            });

            const showStep = (s) => {
                stepPanels.forEach(p => p.classList.remove('active'));
                document.getElementById('step' + s).classList.add('active');
                
                stepDots.forEach(dot => {
                    const step = parseInt(dot.dataset.step);
                    dot.classList.remove('active', 'completed');
                    if (step === s) dot.classList.add('active');
                    else if (step < s) dot.classList.add('completed');
                });
                
                currentStep = s;
                validateStep(s);
                window.scrollTo({ top: 0, behavior: 'smooth' });
            };

            // Custom Checkbox UI toggle
            document.querySelectorAll('input[name="availableDays"]').forEach(cb => {
                cb.addEventListener('change', function() {
                    this.parentElement.classList.toggle('btn-purple', this.checked);
                    this.parentElement.classList.toggle('btn-outline-purple', !this.checked);
                });
            });

            // Initial validation
            validateStep(1);
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>

