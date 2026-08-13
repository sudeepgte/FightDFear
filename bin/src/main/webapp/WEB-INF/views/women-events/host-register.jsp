<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Become an Event Host — Women Safety App</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; color: #1a1a2e; }
        .page-header { background: linear-gradient(135deg, #1a1a2e 0%, #1e1b4b 100%);
            padding: 40px 20px; color: white; text-align: center; }
        .container-main { max-width: 680px; margin: 0 auto; padding: 40px 20px 80px; }
        .card-form { background: white; border-radius: 20px; padding: 40px;
            box-shadow: 0 10px 30px rgba(124,45,94,0.06); border: 1.5px solid #f0e8f5; }
        .form-label { font-weight: 600; font-size: 0.9rem; color: #555; margin-bottom: 8px; }
        .form-control, .form-select { border-radius: 12px; border: 1.5px solid #e2e8f0; padding: 12px;
            font-family: 'Outfit', sans-serif; font-size: 0.92rem; }
        .form-control:focus, .form-select:focus { border-color: #a855f7; box-shadow: 0 0 0 3px rgba(168,85,247,0.15); }
        .btn-submit { background: linear-gradient(135deg, #1e1b4b, #a855f7); color: white;
            border: none; border-radius: 12px; padding: 14px; width: 100%; font-weight: 700;
            font-size: 1rem; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(124,45,94,0.3); }
        .reg-link { color: #1e1b4b; font-weight: 600; text-decoration: none; }
        .reg-link:hover { color: #a855f7; text-decoration: underline; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div class="page-header">
    <h1 style="font-size:2rem; font-weight:800; margin:0;"><i class="bi bi-calendar-check me-2"></i>Event Host Registration</h1>
    <p style="opacity:0.85; margin:8px 0 0; font-size:0.95rem;">Join our gated network of verified safety event organizers</p>
</div>

<div class="container-main">
    <div class="card-form">
        <h4 class="fw-bold mb-4" style="color: #1e1b4b;"><i class="bi bi-file-earmark-person me-2"></i>Create Host Profile</h4>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 small py-2 px-3 mb-4" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/women-events/host/register" method="post">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="fullName" class="form-control" placeholder="e.g. Anjali Sharma" required/>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="anjali@example.com" required/>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Phone Number (10 digits)</label>
                    <input type="text" name="phone" class="form-control" placeholder="e.g. 9876543210" required pattern="^\d{10}$"/>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required/>
                </div>
            </div>

            <hr class="my-4" style="border-top: 1px dashed #cbd5e1;"/>

            <div class="mb-3">
                <label class="form-label">Host / Organization Name</label>
                <input type="text" name="organizerName" class="form-control" placeholder="e.g. She Leads Foundation" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Organizer Type</label>
                <select name="organizerType" class="form-select" required>
                    <option value="">-- Select Type --</option>
                    <option value="NGO">NGO</option>
                    <option value="Government">Government</option>
                    <option value="College">College / University</option>
                    <option value="Company">Corporate Company</option>
                    <option value="Community">Community Group</option>
                    <option value="Gym">Gym / Self-Defense Studio</option>
                    <option value="Hospital">Hospital / Medical Center</option>
                    <option value="Fitness Trainer">Fitness Trainer</option>
                    <option value="Women Entrepreneur">Women Entrepreneur</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Contact Information</label>
                <input type="text" name="hostContact" class="form-control" placeholder="e.g. info@organization.com or +91 XXXXX XXXXX" required/>
            </div>

            <div class="mb-4">
                <label class="form-label">Organizer Bio / Purpose</label>
                <textarea name="hostBio" class="form-control" rows="4" placeholder="Briefly describe your purpose or safety training background..." required></textarea>
            </div>

            <button type="submit" class="btn-submit mb-3">Submit Registration</button>

            <p class="text-center small text-muted mb-0">
                Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login" class="reg-link">Sign In here</a>
            </p>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
