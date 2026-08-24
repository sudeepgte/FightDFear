<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investor Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f4f6fa;
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
            margin: 0;
            padding: 0;
        }

        .left-panel {
            width: 35%;
            min-width: 400px;
            flex-shrink: 0;
            background: linear-gradient(180deg, #1a164b 0%, #3e1b6a 50%, #902166 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 40px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: -100px; left: -100px;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,0.02);
            z-index: 1;
        }

        .left-panel-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 450px;
            margin: 0 auto;
        }

        .brand-logo {
            font-size: 1.8rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
        }

        .brand-logo i {
            background: #f43f5e;
            color: white;
            height: 40px;
            width: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-size: 1.2rem;
        }

        .hero-pretitle {
            color: #f43f5e;
            font-weight: 700;
            font-size: 0.9rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .hero-title {
            font-size: 2.8rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
        }

        .hero-desc {
            font-size: 1.05rem;
            opacity: 0.85;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .feature-box {
            display: flex;
            gap: 16px;
            margin-bottom: 25px;
        }

        .feature-icon {
            height: 45px;
            width: 45px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
            color: #e2e8f0;
        }

        .feature-text h4 {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 3px;
        }

        .feature-text p {
            font-size: 0.85rem;
            opacity: 0.7;
            margin: 0;
            line-height: 1.4;
        }

        .right-panel {
            flex: 1;
            padding: 20px;
            height: 100vh;
            overflow-y: auto;
            background: #f4f6fa;
        }

        .register-container {
            width: 100%;
            max-width: 900px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 12px;
            padding: 40px 50px; 
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
            position: relative;
        }

        .back-link-top {
            position: absolute;
            top: 40px;
            right: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #312e81;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .header-title {
            text-align: center;
            font-weight: 800;
            color: #1e1b4b;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header-title i {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            width: 40px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #312e81;
            font-size: 1.1rem;
        }

        .header-title span {
            color: #312e81;
        }

        .header-subtitle {
            text-align: center;
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 35px;
        }
        
        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title span {
            background: #312e81;
            color: white;
            font-size: 0.75rem;
            height: 22px;
            width: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
        }

        .form-label {
            font-size: 0.85rem;
            color: #0f172a;
            font-weight: 700;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1.5px solid #cbd5e1;
            background-color: #ffffff;
            color: #1e293b;
            padding: 10px 15px;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            background-color: #ffffff;
            border-color: #312e81;
            box-shadow: 0 0 0 3px rgba(49, 46, 129, 0.1);
        }
        
        .input-group-custom {
            position: relative;
        }

        .input-group-custom i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }
        
        .toggle-password {
            cursor: pointer;
            z-index: 10;
        }

        .btn-register {
            background: linear-gradient(135deg, #312e81, #f43f5e);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 8px;
            width: 100%;
            transition: all 0.3s;
            margin-top: 10px;
            font-size: 1rem;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(244, 63, 94, 0.3);
            color: white;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: #64748b;
        }

        .login-link a {
            color: #312e81;
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 992px) {
            body { flex-direction: column; overflow-y: auto; }
            .left-panel { flex: none; padding: 50px 30px; min-height: auto; }
            .right-panel { height: auto; padding: 20px; }
            .register-container { padding: 30px 20px; }
            .hero-title { font-size: 2.2rem; }
            .back-link-top { position: relative; top: 0; right: 0; justify-content: center; margin-bottom: 20px; }
        }
    </style>
</head>
<body>

    <!-- LEFT PANEL: Branding & Features -->
    <div class="left-panel">
        <div class="left-panel-content">
            <div class="brand-logo">
                <i class="bi bi-graph-up-arrow"></i> InvestHub
            </div>

            <div class="hero-pretitle">JOIN OUR NETWORK</div>
            <h1 class="hero-title">Invest in Ideas.<br>Build the Future.</h1>
            <p class="hero-desc">
                Create your investor account and access high-potential opportunities, innovative startups, and impactful ventures.
            </p>

            <div class="feature-box">
                <div class="feature-icon"><i class="bi bi-bullseye"></i></div>
                <div class="feature-text">
                    <h4>Discover Opportunities</h4>
                    <p>Find and invest in high-potential startups and growing businesses.</p>
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-icon"><i class="bi bi-graph-up"></i></div>
                <div class="feature-text">
                    <h4>Smart Investment Matching</h4>
                    <p>Get matched with opportunities that align with your interests.</p>
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                <div class="feature-text">
                    <h4>Secure & Verified</h4>
                    <p>We ensure a secure platform with verified documents and data protection.</p>
                </div>
            </div>
            
            <div class="feature-box">
                <div class="feature-icon"><i class="bi bi-people"></i></div>
                <div class="feature-text">
                    <h4>Grow Your Portfolio</h4>
                    <p>Diversify your investments and maximize long-term returns.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT PANEL: Registration Form Container -->
    <div class="right-panel">
        <div class="register-container">
            
            <a href="${pageContext.request.contextPath}/investor/login" class="back-link-top">
                <i class="bi bi-arrow-left"></i> Back to Login
            </a>

            <h2 class="header-title">
                <i class="bi bi-person"></i> Register as <span>Investor</span>
            </h2>
            <p class="header-subtitle">Fill in the details below to create your investor account</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <!-- EXACT HTML PRESERVED: Registration Form -->
            <form action="${pageContext.request.contextPath}/investor/register" method="post" enctype="multipart/form-data">
                
                <!-- SECTION 1: Personal Details -->
                <div class="mb-4">
                    <h4 class="section-title"><span>1</span> Contact Details</h4>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Full Name *</label>
                            <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address *</label>
                            <div class="input-group-custom">
                                <input type="email" name="email" class="form-control" placeholder="Enter your email address" required>
                                <i class="bi bi-envelope"></i>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number *</label>
                            <input type="tel" name="phone" class="form-control" placeholder="Enter 10-digit number" pattern="[0-9]{10}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Password *</label>
                            <div class="input-group-custom">
                                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required minlength="6">
                                <i class="bi bi-eye-slash toggle-password" id="togglePassword"></i>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Profile Photo (Optional)</label>
                            <div class="input-group-custom">
                                <input type="file" name="profilePhoto" class="form-control" accept="image/*">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: Profile & Investment Interests -->
                <div class="mb-4">
                    <h4 class="section-title"><span>2</span> Entity Profile</h4>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Company / Institution Name *</label>
                            <input type="text" name="companyName" class="form-control" placeholder="e.g. Angel Network, NGO, Bank, Self" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Budget Range (Investment Capacity) *</label>
                            <select name="budgetRange" class="form-select" required>
                                <option value="">Select Budget Range</option>
                                <option value="Under Rs. 50,000">Under ₹50,000</option>
                                <option value="Rs. 50,000 - Rs. 2,00,000">₹50,000 - ₹2,00,000</option>
                                <option value="Rs. 2,00,000 - Rs. 10,00,000">₹2,00,000 - ₹10,00,000</option>
                                <option value="Rs. 10,00,000+">₹10,00,000+</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Investment Interests / Bio *</label>
                            <textarea name="investmentInterests" class="form-control" rows="2" placeholder="Explain what type of businesses you are interested in funding (e.g. boutiques, local food startups, tech etc.)" required></textarea>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: Preferences -->
                <div class="mb-4">
                    <h4 class="section-title"><span>3</span> Match Preferences</h4>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Preferred Locations *</label>
                            <input type="text" name="preferredLocations" class="form-control" placeholder="e.g. TN, Tho, Choeng, All (comma sep)" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Preferred Categories *</label>
                            <input type="text" name="preferredCategories" class="form-control" placeholder="e.g. Tea Shop, Boutique, All (comma sep)" required>
                        </div>
                    </div>
                </div>

                <!-- SECTION 4: Verification Documents -->
                <div class="mb-4">
                    <h4 class="section-title"><span>4</span> Verification Documents</h4>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Verification Document Upload *</label>
                            <div class="input-group-custom">
                                <input type="file" name="verificationDocs" class="form-control" accept=".pdf,.doc,.docx,.jpg,.png" required>
                            </div>
                            <div class="form-text text-muted" style="font-size: 0.75rem;">Please upload business registration, ID proof, or incorporation documents to build trust.</div>
                        </div>
                    </div>
                </div>

                <button type="submit" id="submitBtn" class="btn btn-register">
                    <i class="bi bi-person-plus"></i> Register as Investor
                </button>
            </form>
            <!-- END OF FORM -->

            <p class="login-link">
                Already have an account? <a href="${pageContext.request.contextPath}/investor/login">Sign in here</a>
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Eye icon toggle logic
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');

        if (togglePassword && password) {
            togglePassword.addEventListener('click', function () {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }

        // Basic front-end form validation
        const form = document.querySelector('form');
        form.addEventListener('submit', function (e) {
            let isValid = true;
            const phoneInput = document.querySelector('input[name="phone"]');
            const emailInput = document.querySelector('input[name="email"]');
            
            // Phone validation
            const phoneRegex = /^[0-9]{10}$/;
            if (phoneInput && !phoneRegex.test(phoneInput.value)) {
                alert('Please enter a valid 10-digit phone number.');
                phoneInput.style.borderColor = 'red';
                isValid = false;
            } else if (phoneInput) {
                phoneInput.style.borderColor = '#cbd5e1';
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailInput && !emailRegex.test(emailInput.value)) {
                alert('Please enter a valid email address.');
                emailInput.style.borderColor = 'red';
                isValid = false;
            } else if (emailInput) {
                emailInput.style.borderColor = '#cbd5e1';
            }

            if (!isValid) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
