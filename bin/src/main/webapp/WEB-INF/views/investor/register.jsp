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
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #f43f5e 100%);
            min-height: 100vh;
            padding: 40px 15px;
        }

        .register-container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-title {
            text-align: center;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 30px;
        }

        .header-title span {
            background: linear-gradient(90deg, #1e1b4b, #312e81);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .section-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            border-bottom: 2px solid rgba(49, 46, 129, 0.1);
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #312e81;
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
            border-color: #312e81;
            box-shadow: 0 0 0 3px rgba(49, 46, 129, 0.1);
        }

        .btn-register {
            background: linear-gradient(135deg, #0f172a, #312e81);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 12px;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(49, 46, 129, 0.3);
            margin-top: 20px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(49, 46, 129, 0.4);
            color: white;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #312e81;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <div class="register-container">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/investor/login" class="text-secondary text-decoration-none">
                <i class="bi bi-arrow-left"></i> Back to Login
            </a>
        </div>

        <h2 class="header-title">Register as <span>Investor</span></h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/investor/register" method="post" enctype="multipart/form-data">
            
            <!-- SECTION 1: Personal Details -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-person-badge-fill"></i> 1. Contact Details</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Email Address *</label>
                        <input type="email" name="email" class="form-control" placeholder="Enter corporate or personal email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Phone Number *</label>
                        <input type="tel" name="phone" class="form-control" placeholder="10-digit number" pattern="[0-9]{10}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Password *</label>
                        <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Profile Photo (Optional)</label>
                        <input type="file" name="profilePhoto" class="form-control" accept="image/*">
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Profile & Investment Interests -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-building"></i> 2. Entity Profile</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Company / Institution Name *</label>
                        <input type="text" name="companyName" class="form-control" placeholder="e.g. Angel Network, NGO, Bank, Self" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Budget Range (Investment Capacity) *</label>
                        <select name="budgetRange" class="form-select" required>
                            <option value="">Select Budget Range</option>
                            <option value="Under Rs. 50,000">Under ₹50,000</option>
                            <option value="Rs. 50,000 - Rs. 2,00,000">₹50,000 - ₹2,00,000</option>
                            <option value="Rs. 2,00,000 - Rs. 10,00,000">₹2,00,000 - ₹10,00,000</option>
                            <option value="Rs. 10,00,000+">₹10,00,000+</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Investment Interests / Bio *</label>
                        <textarea name="investmentInterests" class="form-control" rows="3" placeholder="Explain what type of businesses you are interested in funding (e.g. boutiques, local food startups, tailoring)..." required></textarea>
                    </div>
                </div>
            </div>

            <!-- SECTION 3: Preferences -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-sliders"></i> 3. Match Preferences</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Preferred Locations *</label>
                        <input type="text" name="preferredLocations" class="form-control" placeholder="e.g. New York, Chicago, All (comma-separated)" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Preferred Categories *</label>
                        <input type="text" name="preferredCategories" class="form-control" placeholder="e.g. Tea Shop, Boutique, All (comma-separated)" required>
                    </div>
                </div>
            </div>

            <!-- SECTION 4: Verification Documents -->
            <div class="mb-5">
                <h4 class="section-title"><i class="bi bi-file-earmark-check-fill"></i> 4. Verification Documents</h4>
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">Verification Document Upload *</label>
                        <input type="file" name="verificationDocs" class="form-control" accept=".pdf,.doc,.docx,.jpg,.png" required>
                        <div class="form-text text-muted">Please upload business registration, ID proof, or incorporation documents to build trust.</div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-register">Register as Investor</button>
        </form>

        <p class="back-link">
            Already have an account? <a href="${pageContext.request.contextPath}/investor/login">Sign in here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
