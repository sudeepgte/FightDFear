<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrepreneur Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #ffe4e6 50%, #e0e7ff 100%);
            min-height: 100vh;
            padding: 40px 15px;
        }

        .register-container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .header-title {
            text-align: center;
            font-weight: 800;
            color: #1e1b4b;
            margin-bottom: 30px;
        }

        .header-title span {
            background: linear-gradient(90deg, #f43f5e, #be123c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .section-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #1e1b4b;
            margin-bottom: 20px;
            border-bottom: 2px solid rgba(244, 63, 94, 0.1);
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #f43f5e;
        }

        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            padding: 14px 16px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #fff;
            color: #0f172a;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #f43f5e;
            box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1);
        }

        .btn-register {
            background: linear-gradient(135deg, #1e1b4b, #f43f5e);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 12px;
            font-size: 1rem;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3);
            margin-top: 20px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(244, 63, 94, 0.4);
            color: white;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #f43f5e;
            text-decoration: none;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            body { padding: 20px 10px; }
            .register-container { padding: 30px 20px; border-radius: 16px; }
            .header-title { font-size: 1.5rem; margin-bottom: 20px; }
            .section-title { font-size: 1.05rem; }
        }
    </style>
</head>
<body>

    <div class="register-container">
        <div class="mb-4 d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none fw-bold small">
                <i class="bi bi-house-door-fill"></i> Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/login" class="text-secondary text-decoration-none fw-bold small">
                <i class="bi bi-arrow-left"></i> Back to Login
            </a>
        </div>

        <h2 class="header-title">Register as <span>Entrepreneur</span></h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/entrepreneur/register" method="post" enctype="multipart/form-data" id="registerForm" class="needs-validation" novalidate>
            
            <!-- SECTION 1: Personal Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-person-fill"></i> 1. Personal Details</h4>
                <div class="row g-3">
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" minlength="2" required>
                        <div class="invalid-feedback">Please enter your full name.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Email Address *</label>
                        <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Phone Number *</label>
                        <input type="tel" name="phone" class="form-control" placeholder="10-digit number" pattern="[0-9]{10}" required>
                        <div class="invalid-feedback">Please enter a valid 10-digit phone number.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Password *</label>
                        <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" minlength="6" required>
                        <div class="invalid-feedback">Password must be at least 6 characters long.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Date of Birth *</label>
                        <input type="date" name="dob" class="form-control" required>
                        <div class="invalid-feedback">Please select your date of birth.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Gender *</label>
                        <select name="gender" class="form-select" required>
                            <option value="">Select Gender</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                        <div class="invalid-feedback">Please select your gender.</div>
                    </div>
                    <div class="col-12 position-relative">
                        <label class="form-label fw-semibold">Profile Photo *</label>
                        <input type="file" name="profilePhoto" class="form-control" accept="image/*" required>
                        <div class="invalid-feedback">Please upload a profile photo.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Aadhaar Verification -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-shield-check"></i> 2. Aadhaar Verification</h4>
                <div class="row g-3">
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Aadhaar Number *</label>
                        <input type="text" name="aadhaarNumber" class="form-control" placeholder="12-digit Aadhaar" pattern="[0-9]{12}" required>
                        <div class="invalid-feedback">Please enter a valid 12-digit Aadhaar number.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Aadhaar Document Upload *</label>
                        <input type="file" name="aadhaarDoc" class="form-control" accept="image/*,.pdf" required>
                        <div class="invalid-feedback">Please upload your Aadhaar document.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Business Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-briefcase-fill"></i> 3. Business Details</h4>
                <div class="row g-3">
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Business Name *</label>
                        <input type="text" name="businessName" class="form-control" placeholder="Enter business name" required>
                        <div class="invalid-feedback">Please enter your business name.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Business Category *</label>
                        <select name="businessCategory" class="form-select" required>
                            <option value="">Select Business Category</option>
                            <option value="Tea Shop">Tea Shop</option>
                            <option value="Fruits Shop">Fruits Shop</option>
                            <option value="Tailoring Shop">Tailoring Shop</option>
                            <option value="Beauty Salon">Beauty Salon</option>
                            <option value="Homemade Food Business">Homemade Food Business</option>
                            <option value="Pickle Business">Pickle Business</option>
                            <option value="Boutique">Boutique</option>
                            <option value="Candle Making">Candle Making</option>
                            <option value="Soap Making">Soap Making</option>
                            <option value="Dairy Business">Dairy Business</option>
                        </select>
                        <div class="invalid-feedback">Please select a business category.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Business Location *</label>
                        <input type="text" name="businessLocation" class="form-control" placeholder="City or Area" required>
                        <div class="invalid-feedback">Please enter your business location.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Business Experience (Years) *</label>
                        <input type="number" name="businessExperience" class="form-control" min="0" placeholder="Years of experience" required>
                        <div class="invalid-feedback">Please enter your business experience.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Investment Needed (₹) *</label>
                        <input type="number" name="investmentNeeded" class="form-control" min="1" placeholder="Amount needed in INR" required>
                        <div class="invalid-feedback">Please enter a valid investment amount.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Expected Monthly Income (₹) *</label>
                        <input type="number" name="expectedMonthlyIncome" class="form-control" min="1" placeholder="Expected income in INR" required>
                        <div class="invalid-feedback">Please enter a valid expected income.</div>
                    </div>
                    <div class="col-12 position-relative">
                        <label class="form-label fw-semibold">Business Description *</label>
                        <textarea name="businessDescription" class="form-control" rows="4" minlength="20" placeholder="Describe your business model and target customers..." required></textarea>
                        <div class="invalid-feedback">Please provide a business description (at least 20 characters).</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 4: Media & Documents -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-images"></i> 4. Media & Documents</h4>
                <div class="row g-3">
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Business Photos (Multi-select) *</label>
                        <input type="file" name="photos" class="form-control" accept="image/*" multiple required>
                        <div class="invalid-feedback">Please upload at least one business photo.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Verification Documents (Multi-select) *</label>
                        <input type="file" name="documents" class="form-control" accept=".pdf,.doc,.docx" multiple required>
                        <div class="invalid-feedback">Please upload verification documents.</div>
                    </div>
                    <div class="col-12 position-relative">
                        <label class="form-label fw-semibold">Video Pitch (Optional)</label>
                        <input type="file" name="videoPitch" class="form-control" accept="video/*">
                        <div class="form-text text-muted">A short 1-2 minute video explaining your business concept.</div>
                    </div>
                </div>
            </div>

            <!-- SECTION 5: Bank Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-bank2"></i> 5. Bank & Payout Details</h4>
                <div class="row g-3">
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Bank Name *</label>
                        <input type="text" name="bankName" class="form-control" placeholder="e.g. JPMorgan Chase" required>
                        <div class="invalid-feedback">Please enter your bank name.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">Account Number *</label>
                        <input type="text" name="accountNumber" class="form-control" placeholder="Enter bank account number" required>
                        <div class="invalid-feedback">Please enter your account number.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">IFSC Code / Bank Code *</label>
                        <input type="text" name="ifscCode" class="form-control" placeholder="e.g. IFSC/Routing Code" required>
                        <div class="invalid-feedback">Please enter your bank code.</div>
                    </div>
                    <div class="col-md-6 position-relative">
                        <label class="form-label fw-semibold">UPI ID *</label>
                        <input type="text" name="upiId" class="form-control" placeholder="e.g. mobile@upi or email@payout" required>
                        <div class="invalid-feedback">Please enter your UPI ID.</div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-register" id="submitBtn">Submit Registration</button>
        </form>

        <p class="back-link">
            Already have an account? <a href="${pageContext.request.contextPath}/entrepreneur/login">Sign in here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('registerForm');
            const submitBtn = document.getElementById('submitBtn');
            const inputs = form.querySelectorAll('input, select, textarea');

            const validationRules = {
                fullName: {
                    pattern: /^[a-zA-Z\s]{2,50}$/,
                    message: "Please enter a valid name (letters only, 2-50 characters)."
                },
                email: {
                    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                    message: "Please enter a valid email address."
                },
                phone: {
                    pattern: /^[6-9]\d{9}$/,
                    message: "Please enter a valid 10-digit Indian phone number."
                },
                password: {
                    pattern: /^.{6,}$/,
                    message: "Password must be at least 6 characters long."
                },
                aadhaarNumber: {
                    pattern: /^\d{12}$/,
                    message: "Please enter exactly 12 digits for Aadhaar."
                },
                businessName: {
                    pattern: /^.{2,100}$/,
                    message: "Business name must be at least 2 characters."
                },
                accountNumber: {
                    pattern: /^\d{9,18}$/,
                    message: "Please enter a valid bank account number (9-18 digits)."
                },
                ifscCode: {
                    pattern: /^[A-Z]{4}0[A-Z0-9]{6}$/,
                    message: "Please enter a valid IFSC code (e.g. SBIN0001234)."
                },
                upiId: {
                    pattern: /^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$/,
                    message: "Please enter a valid UPI ID (e.g. name@bank)."
                }
            };

            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    validateField(this);
                    checkFormValidity();
                });
                
                input.addEventListener('change', function() {
                    validateField(this);
                    checkFormValidity();
                });
                
                input.addEventListener('blur', function() {
                    validateField(this);
                });
            });

            function validateField(field) {
                if (!field.hasAttribute('required') && field.value.trim() === '') {
                    field.classList.remove('is-invalid', 'is-valid');
                    return true;
                }

                let isValid = field.checkValidity();
                let customMessage = "";

                if (isValid && validationRules[field.name]) {
                    const rule = validationRules[field.name];
                    if (!rule.pattern.test(field.value.trim())) {
                        isValid = false;
                        customMessage = rule.message;
                    }
                }

                const feedbackElement = field.nextElementSibling;
                if (feedbackElement && feedbackElement.classList.contains('invalid-feedback')) {
                    if (customMessage) {
                        feedbackElement.textContent = customMessage;
                    } else if (field.validationMessage) {
                        // fallback to default HTML5 message if no custom rule failed
                        feedbackElement.textContent = "Please provide valid input.";
                    }
                }

                if (isValid) {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                } else {
                    field.classList.remove('is-valid');
                    field.classList.add('is-invalid');
                }
                
                return isValid;
            }

            function checkFormValidity() {
                let allValid = true;
                inputs.forEach(input => {
                    if (input.hasAttribute('required') || input.value.trim() !== '') {
                        if (validationRules[input.name]) {
                             if (!validationRules[input.name].pattern.test(input.value.trim())) {
                                 allValid = false;
                             }
                        } else if (!input.checkValidity()) {
                            allValid = false;
                        }
                    }
                });

                if (allValid && form.checkValidity()) {
                    submitBtn.classList.remove('disabled');
                    submitBtn.removeAttribute('disabled');
                } else {
                    submitBtn.classList.add('disabled');
                    submitBtn.setAttribute('disabled', 'true');
                }
            }

            form.addEventListener('submit', function (event) {
                let isFormValid = true;
                inputs.forEach(input => {
                    if (!validateField(input)) {
                        isFormValid = false;
                    }
                });

                if (!isFormValid || !form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    const firstInvalid = form.querySelector('.is-invalid, :invalid');
                    if (firstInvalid) {
                        firstInvalid.focus();
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                } else {
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Processing...';
                    submitBtn.style.pointerEvents = 'none';
                    submitBtn.style.opacity = '0.8';
                }
                form.classList.add('was-validated');
            }, false);
            
            checkFormValidity();
        });
    </script>
</body>
</html>
