<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Women Jobs Register — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }
        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
        }
        .header-brand i { color: var(--primary); font-size: 1.3rem; }
        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
        }
        .header-links a:hover { color: var(--primary); }
        .main-container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 28px auto 40px;
            padding: 0 16px;
        }
        .info-banner {
            background: var(--rose-soft);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
            border: 1px solid #FECDD3;
        }
        .info-banner h2 { font-size: 1.15rem; font-weight: 800; color: var(--navy); margin-bottom: 6px; }
        .info-banner p { font-size: 0.9rem; color: var(--navy); line-height: 1.45; margin: 0; }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .card-header { margin-bottom: 22px; }
        .card-header h2 { font-size: 1.35rem; font-weight: 800; margin-bottom: 6px; }
        .card-header .subtitle { font-size: 0.9rem; color: var(--text-gray); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 8px; }
        .form-group { margin-bottom: 4px; }
        .form-group.full-width { grid-column: span 2; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 6px; }
        .input-wrapper { position: relative; }
        .input-wrapper i.prefix-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1rem; }
        .form-input, .form-select {
            width: 100%;
            padding: 12px 14px 12px 42px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            background-color: white;
            font-family: inherit;
            color: var(--navy);
        }
        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2394a3b8'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 18px;
            padding-right: 40px;
        }
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-toggle-btn {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: var(--text-gray); cursor: pointer; padding: 4px; font-size: 1.1rem; z-index: 2;
        }
        .input-wrapper.password-field .form-input { padding-right: 46px; }
        .btn-otp {
            padding: 12px 16px; border-radius: 10px; background: var(--navy); color: white; border: none;
            font-size: 0.85rem; font-weight: 700; cursor: pointer; white-space: nowrap; font-family: inherit;
        }
        .btn-otp-ok { background: var(--success); }
        .btn-register {
            width: 100%; padding: 14px; background: var(--primary); color: white; border: none;
            border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25); margin-top: 16px; font-family: inherit;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-register:hover { background: var(--primary-hover); }
        .login-link { text-align: center; margin-top: 20px; font-size: 0.9rem; color: var(--text-gray); }
        .login-link a { color: var(--primary); text-decoration: none; font-weight: 700; }
        .error-alert {
            background: var(--error-bg); border: 1px solid #FECACA; color: var(--error);
            padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 16px;
            display: flex; align-items: center; gap: 10px;
        }
        .section-label {
            grid-column: span 2;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-gray);
            margin-top: 8px;
        }
        @media (max-width: 640px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width, .section-label { grid-column: span 1; }
        }
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 100; padding: 16px;
        }
        .modal-card {
            background: #FFFFFF; border-radius: 20px; max-width: 460px; width: 100%; padding: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .modal-header { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
        .modal-header .icon-wrap {
            width: 40px; height: 40px; border-radius: 10px; background: var(--rose-soft); color: var(--primary);
            display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0;
        }
        .modal-header h3 { font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0; }
        .modal-body {
            background: var(--bg-page); border: 1px solid var(--border-color); border-radius: 12px;
            padding: 14px; margin-bottom: 20px;
        }
        .review-row {
            display: flex; justify-content: space-between; gap: 12px; padding: 8px 0;
            border-bottom: 1px dashed var(--border-color); font-size: 0.85rem;
        }
        .review-row:last-child { border-bottom: none; }
        .review-row .label { color: var(--text-gray); font-weight: 500; }
        .review-row .value { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }
        .modal-actions { display: flex; gap: 10px; }
        .btn-modal-cancel {
            flex: 1; padding: 12px; background: #FFFFFF; border: 1px solid var(--border-color);
            color: var(--navy); border-radius: 10px; font-size: 0.9rem; font-weight: 700; cursor: pointer; font-family: inherit;
        }
        .btn-modal-confirm {
            flex: 1.5; padding: 12px; background: var(--primary); border: none; color: #FFFFFF;
            border-radius: 10px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px; font-family: inherit;
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <i class="bi bi-briefcase-fill"></i> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/women-jobs/login">Sign In</a>
        </div>
    </header>

    <div class="main-container">
        <div class="info-banner">
            <h2>Join Women Jobs</h2>
            <p>Create your worker account, verify your email, and submit your application. After admin verification you can receive bookings from clients.</p>
        </div>

        <div class="register-card form-card">
            <div class="card-header">
                <h2>Register as Job Partner</h2>
                <p class="subtitle">Complete the form below. All fields are required.</p>
            </div>

            <div id="js-error-alert" class="error-alert" style="display: none;">
                <i class="bi bi-exclamation-circle"></i>
                <span id="js-error-msg"></span>
            </div>

            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle"></i> ${error}</div>
            </c:if>

            <form id="registerForm" action="${pageContext.request.contextPath}/women-jobs/register" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="section-label">Account details</div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <div class="input-wrapper">
                            <i class="bi bi-person prefix-icon"></i>
                            <input type="text" name="fullName" class="form-input" placeholder="Your Name" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email Address</label>
                        <div class="input-wrapper" style="display: flex; gap: 10px; align-items: center;">
                            <div style="position: relative; flex-grow: 1;">
                                <i class="bi bi-envelope prefix-icon"></i>
                                <input type="email" id="email" name="email" class="form-input" placeholder="name@example.com" required>
                            </div>
                            <button type="button" id="btn-send-otp" class="btn-otp">Send OTP</button>
                        </div>
                    </div>

                    <div class="form-group" id="otp-section" style="display: none;">
                        <label>Enter OTP</label>
                        <div class="input-wrapper" style="display: flex; gap: 10px; align-items: center;">
                            <div style="position: relative; flex-grow: 1;">
                                <i class="bi bi-shield-lock prefix-icon"></i>
                                <input type="text" id="otp" class="form-input" placeholder="6-digit verification code">
                            </div>
                            <button type="button" id="btn-verify-otp" class="btn-otp btn-otp-ok">Verify OTP</button>
                        </div>
                        <div id="otp-msg" style="margin-top: 5px; font-size: 0.8rem; font-weight: 600;"></div>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <div class="input-wrapper">
                            <i class="bi bi-telephone prefix-icon"></i>
                            <input type="tel" name="phone" class="form-input" placeholder="10-digit number" pattern="^\d{10}$" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Hourly Rate (₹)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-currency-rupee prefix-icon"></i>
                            <input type="number" name="hourlyRate" class="form-input" placeholder="e.g. 350" min="1" required>
                        </div>
                    </div>

                    <div class="section-label">Work category</div>
                    <div class="form-group">
                        <label>Job Category</label>
                        <div class="input-wrapper">
                            <i class="bi bi-tag prefix-icon"></i>
                            <select id="jobCategory" name="jobCategory" class="form-select" required onchange="updateSubCategories()">
                                <option value="" disabled selected>Select Category</option>
                                <option value="Caregiver">Caregiver</option>
                                <option value="Babysitting">Babysitting</option>
                                <option value="Housekeeping">Housekeeping</option>
                                <option value="Cooking">Cooking</option>
                                <option value="Beauty & Salon">Beauty & Salon</option>
                                <option value="Healthcare">Healthcare</option>
                                <option value="Teaching">Teaching</option>
                                <option value="Office Jobs">Office Jobs</option>
                                <option value="Retail">Retail</option>
                                <option value="Hospitality">Hospitality</option>
                                <option value="Customer Support">Customer Support</option>
                                <option value="Delivery & Logistics">Delivery & Logistics</option>
                                <option value="Domestic Help">Domestic Help</option>
                                <option value="Tailoring & Fashion">Tailoring & Fashion</option>
                                <option value="Digital Jobs">Digital Jobs</option>
                                <option value="Freelancing">Freelancing</option>
                                <option value="Entrepreneurship">Entrepreneurship</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Specific Job</label>
                        <div class="input-wrapper">
                            <i class="bi bi-briefcase prefix-icon"></i>
                            <select id="jobSubCategory" name="jobSubCategory" class="form-select" required>
                                <option value="" disabled selected>Select Specific Job</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label>Upload Proof Document (ID/Certificate)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-file-earmark-arrow-up prefix-icon"></i>
                            <input type="file" name="proofDocument" class="form-input" accept="image/*,.pdf" style="padding-top: 10px;" required>
                        </div>
                    </div>

                    <div class="section-label">Password</div>
                    <div class="form-group">
                        <label>Password</label>
                        <div class="input-wrapper password-field">
                            <i class="bi bi-shield-lock prefix-icon"></i>
                            <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('password')"><i class="bi bi-eye"></i></button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password</label>
                        <div class="input-wrapper password-field">
                            <i class="bi bi-shield-lock prefix-icon"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="••••••••" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('confirmPassword')"><i class="bi bi-eye"></i></button>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-register">Apply &amp; Register <i class="bi bi-arrow-right"></i></button>
            </form>
            <p class="login-link">Already registered? <a href="${pageContext.request.contextPath}/women-jobs/login">Sign In</a></p>
        </div>
    </div>

    <div id="confirmModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-shield-lock-fill"></i></div>
                <div>
                    <h3>Confirm Details</h3>
                    <p style="font-size: 0.8rem; color: var(--text-gray); margin: 0;">Review your information before account creation</p>
                </div>
            </div>
            <div class="modal-body">
                <div class="review-row"><span class="label">Full Name:</span><span class="value" id="revName">—</span></div>
                <div class="review-row"><span class="label">Mobile Number:</span><span class="value" id="revPhone">—</span></div>
                <div class="review-row"><span class="label">Email:</span><span class="value" id="revEmail">—</span></div>
                <div class="review-row"><span class="label">Job Category:</span><span class="value" id="revCategory">—</span></div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="btnConfirmBack">Back / Edit</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmRegister">
                    Confirm &amp; Register <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>

    <script>
        const categories = {
            "Caregiver": ["Elderly Caregiver", "Patient Care Assistant", "Child Caregiver", "Home Care Assistant"],
            "Babysitting": ["Babysitter", "Nanny", "Daycare Assistant"],
            "Housekeeping": ["House Maid", "Housekeeper", "Cleaner"],
            "Cooking": ["Home Cook", "Personal Cook", "Kitchen Assistant"],
            "Beauty & Salon": ["Beautician", "Hair Stylist", "Makeup Artist", "Nail Technician"],
            "Healthcare": ["Nurse", "Care Assistant", "Receptionist", "Lab Assistant"],
            "Teaching": ["Tutor", "School Teacher", "Preschool Teacher"],
            "Office Jobs": ["Receptionist", "Office Assistant", "Data Entry Operator"],
            "Retail": ["Cashier", "Sales Executive", "Store Assistant"],
            "Hospitality": ["Hotel Receptionist", "Housekeeping Staff", "Waitress"],
            "Customer Support": ["Call Center Executive", "Customer Care Representative"],
            "Delivery & Logistics": ["Parcel Coordinator", "Delivery Executive (where applicable)"],
            "Domestic Help": ["Laundry Assistant", "Home Helper"],
            "Tailoring & Fashion": ["Tailor", "Boutique Assistant", "Fashion Designer"],
            "Digital Jobs": ["Content Writer", "Graphic Designer", "Social Media Executive"],
            "Freelancing": ["Virtual Assistant", "Translator", "Online Tutor"],
            "Entrepreneurship": ["Sell Handmade Products", "Home Bakery", "Boutique Owner"]
        };

        function updateSubCategories() {
            const categorySelect = document.getElementById("jobCategory");
            const subCategorySelect = document.getElementById("jobSubCategory");
            const selectedCategory = categorySelect.value;

            subCategorySelect.innerHTML = '<option value="" disabled selected>Select Specific Job</option>';

            if (selectedCategory && categories[selectedCategory]) {
                categories[selectedCategory].forEach(subCat => {
                    const option = document.createElement("option");
                    option.value = subCat;
                    option.text = subCat;
                    subCategorySelect.appendChild(option);
                });
            }
        }

        function togglePassword(fieldId) {
            var passwordInput = document.getElementById(fieldId);
            var toggleBtn = passwordInput.nextElementSibling.querySelector("i");
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleBtn.classList.remove("bi-eye");
                toggleBtn.classList.add("bi-eye-slash");
            } else {
                passwordInput.type = "password";
                toggleBtn.classList.remove("bi-eye-slash");
                toggleBtn.classList.add("bi-eye");
            }
        }

        let isEmailVerified = false;
        let wjConfirmReady = false;

        document.getElementById('btn-send-otp').addEventListener('click', function() {
            const emailInput = document.getElementById('email');
            const email = emailInput.value.trim();
            const otpMsg = document.getElementById('otp-msg');
            const otpSection = document.getElementById('otp-section');
            const sendBtn = this;

            if (email === '' || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Please enter a valid email address first.');
                return;
            }

            sendBtn.disabled = true;
            sendBtn.textContent = 'Sending...';
            otpMsg.textContent = '';

            fetch('${pageContext.request.contextPath}/women-jobs/send-otp?email=' + encodeURIComponent(email), {
                method: 'POST'
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    otpSection.style.display = 'block';
                    otpMsg.textContent = 'OTP sent successfully! Please check your email inbox.';
                    otpMsg.style.color = '#10b981';
                    sendBtn.textContent = 'Resend OTP';
                    alert('OTP sent to your email (' + email + ')! Please check your inbox or spam folder.');
                } else {
                    otpMsg.textContent = 'Error: ' + data.message;
                    otpMsg.style.color = '#f43f5e';
                    sendBtn.textContent = 'Send OTP';
                }
                sendBtn.disabled = false;
            })
            .catch(err => {
                otpMsg.textContent = 'Could not send OTP. Please try again.';
                otpMsg.style.color = '#f43f5e';
                sendBtn.textContent = 'Send OTP';
                sendBtn.disabled = false;
            });
        });

        document.getElementById('btn-verify-otp').addEventListener('click', function() {
            const email = document.getElementById('email').value.trim();
            const otp = document.getElementById('otp').value.trim();
            const otpMsg = document.getElementById('otp-msg');
            const verifyBtn = this;

            if (otp === '') {
                alert('Please enter the 6-digit OTP code.');
                return;
            }

            verifyBtn.disabled = true;
            verifyBtn.textContent = 'Verifying...';

            fetch('${pageContext.request.contextPath}/women-jobs/verify-otp?email=' + encodeURIComponent(email) + '&otp=' + encodeURIComponent(otp), {
                method: 'POST'
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    isEmailVerified = true;
                    otpMsg.textContent = 'Email verified successfully!';
                    otpMsg.style.color = '#10b981';
                    document.getElementById('email').readOnly = true;
                    document.getElementById('btn-send-otp').style.display = 'none';
                    verifyBtn.style.display = 'none';
                    document.getElementById('otp').disabled = true;
                    alert('Email verified successfully! You can now complete registration.');
                } else {
                    otpMsg.textContent = data.message || 'Invalid or expired OTP.';
                    otpMsg.style.color = '#f43f5e';
                    verifyBtn.textContent = 'Verify OTP';
                    verifyBtn.disabled = false;
                }
            })
            .catch(err => {
                otpMsg.textContent = 'Verification failed. Please try again.';
                otpMsg.style.color = '#f43f5e';
                verifyBtn.textContent = 'Verify OTP';
                verifyBtn.disabled = false;
            });
        });

        document.getElementById('registerForm').addEventListener('submit', function(event) {
            const errorAlert = document.getElementById('js-error-alert');
            const errorMsg = document.getElementById('js-error-msg');
            errorAlert.style.display = 'none';
            errorMsg.textContent = '';

            const fullName = this.fullName.value.trim();
            const email = this.email.value.trim();
            const phone = this.phone.value.trim();
            const hourlyRate = this.hourlyRate.value.trim();
            const password = this.password.value;
            const confirmPassword = this.confirmPassword.value;

            if (!isEmailVerified) {
                showError('Please verify your email address using OTP first.');
                event.preventDefault();
                return;
            }

            if (fullName === '') {
                showError('Full Name is required.');
                event.preventDefault();
                return;
            }
            if (!/^[a-zA-Z\s]+$/.test(fullName)) {
                showError('Full Name must contain only alphabets and spaces.');
                event.preventDefault();
                return;
            }
            if (fullName.length < 2) {
                showError('Full Name must be at least 2 characters long.');
                event.preventDefault();
                return;
            }

            if (email === '') {
                showError('Email Address is required.');
                event.preventDefault();
                return;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                showError('Please enter a valid email address.');
                event.preventDefault();
                return;
            }

            if (phone === '') {
                showError('Phone Number is required.');
                event.preventDefault();
                return;
            }
            if (!/^\d{10}$/.test(phone)) {
                showError('Phone number must be exactly 10 digits.');
                event.preventDefault();
                return;
            }

            if (!this.jobCategory.value) {
                showError('Job Category is required.');
                event.preventDefault();
                return;
            }
            if (!this.jobSubCategory.value) {
                showError('Specific Job is required.');
                event.preventDefault();
                return;
            }
            if (!this.proofDocument.files || this.proofDocument.files.length === 0) {
                showError('Please upload a proof document.');
                event.preventDefault();
                return;
            }

            if (hourlyRate === '') {
                showError('Hourly Rate is required.');
                event.preventDefault();
                return;
            }
            const rateNum = parseFloat(hourlyRate);
            if (isNaN(rateNum) || rateNum <= 0) {
                showError('Hourly rate must be greater than zero.');
                event.preventDefault();
                return;
            }

            if (password === '') {
                showError('Password is required.');
                event.preventDefault();
                return;
            }
            if (password.length < 8) {
                showError('Password must be at least 8 characters long.');
                event.preventDefault();
                return;
            }

            if (confirmPassword === '') {
                showError('Confirm Password is required.');
                event.preventDefault();
                return;
            }
            if (password !== confirmPassword) {
                showError('Password and Confirm Password do not match.');
                event.preventDefault();
                return;
            }

            if (!wjConfirmReady) {
                event.preventDefault();
                document.getElementById('revName').textContent = fullName;
                document.getElementById('revPhone').textContent = phone;
                document.getElementById('revEmail').textContent = email;
                document.getElementById('revCategory').textContent = this.jobCategory.value + ' / ' + this.jobSubCategory.value;
                document.getElementById('confirmModal').style.display = 'flex';
            }

            function showError(message) {
                errorMsg.textContent = message;
                errorAlert.style.display = 'flex';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        });

        document.getElementById('btnConfirmBack').addEventListener('click', function () {
            document.getElementById('confirmModal').style.display = 'none';
            wjConfirmReady = false;
        });
        document.getElementById('btnConfirmRegister').addEventListener('click', function () {
            wjConfirmReady = true;
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('registerForm').requestSubmit();
        });
    </script>
</body>
</html>
