<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fitness Trainer Registration — Fight D Fear</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #ffe4e6 50%, #e0e7ff 100%);
            min-height: 100vh;
            padding: 60px 15px;
            color: #0f172a;
        }

        .register-container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
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
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.15);
        }

        /* Specializations checkboxes Styled Grid */
        .spec-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 10px;
            max-height: 180px;
            overflow-y: auto;
            padding: 12px;
            background: #f8fafc;
            border: 1.5px solid #cbd5e1;
            border-radius: 12px;
        }
        .spec-box {
            position: relative;
        }
        .spec-box input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        .spec-label {
            display: block;
            background: white;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            padding: 8px;
            font-size: 0.76rem;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            user-select: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .spec-box input:checked + .spec-label {
            background: #ffe4e6;
            border-color: #f43f5e;
            color: #be123c;
            box-shadow: 0 4px 10px rgba(244, 63, 94, 0.1);
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

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="register-container">
        
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Logo" style="height: 60px; border-radius: 12px;" class="mb-3"></a>
            <h2 class="header-title">Fitness Trainer <span>Registration</span></h2>
            <p class="text-muted">Register to offer wellness & fitness services to women on our platform.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 small py-2 px-3 mb-4" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/fitness/trainer/register" method="POST" enctype="multipart/form-data">
            
            <div class="section-title">
                <i class="bi bi-person-fill"></i> Personal Details
            </div>
            
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Full Name</label>
                    <input type="text" name="fullName" class="form-control" placeholder="e.g. Jessica Smith" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="e.g. coach@fitness.com" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Phone Number</label>
                    <input type="text" name="phone" class="form-control" placeholder="e.g. +91 9876543210" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Password</label>
                    <div style="position: relative;">
                        <input type="password" name="password" id="passwordInput" class="form-control" placeholder="••••••••" style="padding-right: 46px;" required>
                        <i class="bi bi-eye-slash" id="togglePassword" style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #94a3b8; font-size: 1.1rem; z-index: 10;"></i>
                    </div>
                </div>
            </div>

            <div class="section-title">
                <i class="bi bi-briefcase-fill"></i> Professional Details
            </div>
            
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Experience (Years)</label>
                    <input type="number" name="experience" class="form-control" placeholder="e.g. 5" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Fee per Session (₹)</label>
                    <input type="number" name="sessionFees" class="form-control" placeholder="e.g. 300" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Available Hours</label>
                    <input type="text" name="availableTimings" class="form-control" placeholder="e.g. 08:00-12:00" required>
                </div>

                <div class="col-12">
                    <label class="form-label text-muted small fw-bold">Select Specialization Categories</label>
                    <div class="spec-grid">
                        <c:forEach var="cat" items="${categories}">
                            <div class="spec-box">
                                <input type="checkbox" name="specializations" value="${cat}" id="spec_${cat}">
                                <label class="spec-label" for="spec_${cat}">${cat}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="section-title">
                <i class="bi bi-file-earmark-arrow-up-fill"></i> Verification Documents
            </div>
            
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Profile Photo</label>
                    <input type="file" name="profilePhoto" class="form-control" accept="image/*" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Certification Document (PDF/Image)</label>
                    <input type="file" name="certificationDoc" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn btn-register">Register as Coach</button>
        </form>

        <div class="back-link">
            <p class="text-muted small">Already registered? <a href="${pageContext.request.contextPath}/fitness/trainer/login">Coach Login Here</a></p>
        </div>
    </div>
</div>

    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#passwordInput');
        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function () {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
    </script>
</body>
</html>
