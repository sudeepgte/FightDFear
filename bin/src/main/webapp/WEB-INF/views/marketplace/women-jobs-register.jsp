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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; background: #fffcfd; }
        
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
        .left-panel::before { content: ''; position: absolute; top: -100px; right: -100px; width: 400px; height: 400px; border-radius: 50%; background: rgba(255,255,255,0.06); }
        .left-panel::after { content: ''; position: absolute; bottom: -150px; left: -80px; width: 500px; height: 500px; border-radius: 50%; background: rgba(255,255,255,0.04); }
        .left-panel .brand { position: relative; z-index: 2; text-align: center; color: white; }
        .brand-logo { font-size: 2.5rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 16px; }
        .brand-logo i { font-size: 2.2rem; margin-right: 8px; }
        .brand-tagline { font-size: 1.1rem; font-weight: 300; opacity: 0.9; max-width: 360px; line-height: 1.7; margin-bottom: 40px; }
        
        .right-panel { 
            flex: 1.2; 
            display: flex; 
            justify-content: center; 
            align-items: flex-start; 
            padding: 50px 40px; 
            overflow-y: auto; 
            max-height: 100vh; 
        }
        .register-card { width: 100%; max-width: 480px; }
        .register-card h2 { font-size: 1.85rem; font-weight: 800; color: #3F1430; margin-bottom: 6px; }
        .register-card .subtitle { color: #6b7280; font-size: 0.95rem; margin-bottom: 32px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group.full-width { grid-column: span 2; margin-bottom: 10px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: #3F1430; margin-bottom: 8px; }
        .input-wrapper { position: relative; }
        .input-wrapper i.prefix-icon { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 1rem; }
        
        .form-input, .form-select { 
            width: 100%; 
            padding: 14px 16px 14px 46px; 
            border: 2px solid #f3e8ef; 
            border-radius: 12px; 
            font-size: 0.95rem; 
            transition: all 0.3s ease; 
            background-color: white;
            font-family: inherit;
        }
        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%239ca3af'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 18px;
            padding-right: 40px;
        }
        .form-input:focus, .form-select:focus { outline: none; border-color: #1e1b4b; box-shadow: 0 0 0 4px rgba(30, 27, 75, 0.1); }
        
        .password-toggle-btn { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); border: none; background: transparent; color: #9ca3af; cursor: pointer; padding: 4px; font-size: 1.1rem; z-index: 2; }
        .input-wrapper.password-field .form-input { padding-right: 46px; }
        
        .btn-register { width: 100%; padding: 14px; background: linear-gradient(135deg, #1e1b4b, #1e1b4b); color: white; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3); margin-top: 10px; }
        .btn-register:hover { transform: translateY(-2px); box-shadow: 0 6px 25px rgba(124, 45, 94, 0.4); }
        
        .login-link { text-align: center; margin-top: 24px; font-size: 0.9rem; color: #6b7280; }
        .login-link a { color: #1e1b4b; text-decoration: none; font-weight: 700; }
        
        .error-alert { background: #fff1f8; border: 1px solid #ffc2df; color: #1e1b4b; padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .back-home { display: inline-flex; align-items: center; gap: 6px; color: #6b7280; text-decoration: none; font-size: 0.85rem; font-weight: 500; margin-bottom: 28px; }
        
        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 16px; text-align: left; margin-top: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 14px; color: rgba(255,255,255,0.9); font-size: 0.95rem; font-weight: 400; }
        .feature-list li .feat-icon { width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; justify-content: center; align-items: center; font-size: 1.1rem; flex-shrink: 0; }
        
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel {
                padding: 50px 30px;
                min-height: 25vh;
                text-align: center;
            }
            .brand-tagline { 
                margin: 0 auto;
                font-size: 1rem;
            }
            .feature-list { display: none; }
            .right-panel { 
                padding: 40px 20px;
                background: #fff;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
                max-height: none;
                overflow-y: visible;
            }
            .register-card {
                max-width: 100%;
            }
            .form-grid {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo"><i class="bi bi-briefcase"></i> Fight D Fear</div>
            <p class="brand-tagline">Empowering women with flexible job opportunities and financial independence. Dedicated to professional growth and safety.</p>
            <ul class="feature-list">
                <li><span class="feat-icon"><i class="bi bi-briefcase-fill"></i></span> Access Flexible Job Opportunities</li>
                <li><span class="feat-icon"><i class="bi bi-shield-fill-check"></i></span> Safe & Verified Clients</li>
                <li><span class="feat-icon"><i class="bi bi-calendar-check-fill"></i></span> Manage Your Bookings Effortlessly</li>
                <li><span class="feat-icon"><i class="bi bi-wallet2"></i></span> Request Secure UPI Payouts</li>
            </ul>
        </div>
    </div>
    <div class="right-panel">
        <div class="register-card">
            <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Back to Home</a>
            <h2>Register as Job Partner</h2>
            <p class="subtitle">Complete your profile to start receiving bookings</p>
            
            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/women-jobs/register" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name</label>
                        <div class="input-wrapper">
                            <i class="bi bi-person prefix-icon"></i>
                            <input type="text" name="fullName" class="form-input" placeholder="Your Name" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Email Address</label>
                        <div class="input-wrapper">
                            <i class="bi bi-envelope prefix-icon"></i>
                            <input type="email" name="email" class="form-input" placeholder="name@example.com" required>
                        </div>
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

                <button type="submit" class="btn-register">Apply & Register <i class="bi bi-arrow-right"></i></button>
            </form>
            <p class="login-link">Already registered? <a href="${pageContext.request.contextPath}/women-jobs/login">Sign In</a></p>
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
    </script>
</body>
</html>
