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
            border-radius: 10px;
            border: 1.5px solid #cbd5e1;
            padding: 10px 15px;
            font-size: 0.95rem;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #f43f5e;
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }

        .btn-register {
            background: linear-gradient(135deg, #1e1b4b, #f43f5e);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 12px;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(244, 63, 94, 0.3);
            margin-top: 20px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(244, 63, 94, 0.4);
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
    </style>
</head>
<body>

    <div class="register-container">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/entrepreneur/login" class="text-secondary text-decoration-none">
                <i class="bi bi-arrow-left"></i> Back to Login
            </a>
        </div>

        <h2 class="header-title">Register as <span>Entrepreneur</span></h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/entrepreneur/register" method="post" enctype="multipart/form-data">
            
            <!-- SECTION 1: Personal Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-person-fill"></i> 1. Personal Details</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Email Address *</label>
                        <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Phone Number *</label>
                        <input type="tel" name="phone" class="form-control" placeholder="10-digit number" pattern="[0-9]{10}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Password *</label>
                        <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Date of Birth *</label>
                        <input type="date" name="dob" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Gender *</label>
                        <select name="gender" class="form-select" required>
                            <option value="">Select Gender</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Profile Photo *</label>
                        <input type="file" name="profilePhoto" class="form-control" accept="image/*" required>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Aadhaar Verification -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-shield-check"></i> 2. Aadhaar Verification</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Aadhaar Number *</label>
                        <input type="text" name="aadhaarNumber" class="form-control" placeholder="12-digit Aadhaar" pattern="[0-9]{12}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Aadhaar Document Upload *</label>
                        <input type="file" name="aadhaarDoc" class="form-control" accept="image/*,.pdf" required>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Business Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-briefcase-fill"></i> 3. Business Details</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Name *</label>
                        <input type="text" name="businessName" class="form-control" placeholder="Enter business name" required>
                    </div>
                    <div class="col-md-6">
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
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Location *</label>
                        <input type="text" name="businessLocation" class="form-control" placeholder="City or Area" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Experience (Years) *</label>
                        <input type="number" name="businessExperience" class="form-control" min="0" placeholder="Years of experience" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Investment Needed ($) *</label>
                        <input type="number" name="investmentNeeded" class="form-control" min="1" placeholder="Amount needed in USD" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Expected Monthly Income ($) *</label>
                        <input type="number" name="expectedMonthlyIncome" class="form-control" min="1" placeholder="Expected income in USD" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Business Description *</label>
                        <textarea name="businessDescription" class="form-control" rows="4" placeholder="Describe your business model and target customers..." required></textarea>
                    </div>
                </div>
            </div>

            <!-- SECTION 4: Media & Documents -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-images"></i> 4. Media & Documents</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Photos (Multi-select) *</label>
                        <input type="file" name="photos" class="form-control" accept="image/*" multiple required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Verification Documents (Multi-select) *</label>
                        <input type="file" name="documents" class="form-control" accept=".pdf,.doc,.docx" multiple required>
                    </div>
                    <div class="col-12">
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
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Bank Name *</label>
                        <input type="text" name="bankName" class="form-control" placeholder="e.g. JPMorgan Chase" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Account Number *</label>
                        <input type="text" name="accountNumber" class="form-control" placeholder="Enter bank account number" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">IFSC Code / Bank Code *</label>
                        <input type="text" name="ifscCode" class="form-control" placeholder="e.g. IFSC/Routing Code" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">UPI ID *</label>
                        <input type="text" name="upiId" class="form-control" placeholder="e.g. mobile@upi or email@payout" required>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-register">Submit Registration</button>
        </form>

        <p class="back-link">
            Already have an account? <a href="${pageContext.request.contextPath}/entrepreneur/login">Sign in here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
