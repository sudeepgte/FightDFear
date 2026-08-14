<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Workshop Details</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;90&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --fl-purple: #1e1b4b;
            --fl-pink: #f43f5e;
            --fl-gold: #ffd700;
            --fl-bg: #f8fafc;
            --fl-shadow: 0 15px 35px rgba(30, 27, 75, 0.1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--fl-bg);
            color: #333;
            min-height: 100vh;
        }

        /* Hero Header */
        .details-hero {
            background: linear-gradient(135deg, var(--fl-purple) 0%, var(--fl-pink) 100%);
            padding: 60px 0 80px;
            color: white;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
            position: relative;
            overflow: hidden;
        }

        .details-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png');
            opacity: 0.1;
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--fl-shadow);
            border: 1px solid rgba(30, 27, 75, 0.05);
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--fl-purple);
            margin-bottom: 20px;
        }

        /* Badge List */
        .badge-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .badge-item {
            background: rgba(30, 27, 75, 0.1);
            color: var(--fl-purple);
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
        }

        /* Register Button */
        .register-btn {
            background: linear-gradient(135deg, var(--fl-purple), var(--fl-pink));
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 700;
            transition: all 0.3s;
        }

        .register-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(30, 27, 75, 0.3);
            color: white;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            top: 30px;
            left: 30px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0.8;
            transition: 0.3s;
            z-index: 100;
        }

        .back-btn:hover {
            opacity: 1;
            transform: translateX(-5px);
        }

        @media (max-width: 768px) {
            .details-hero h1 { font-size: 1.8rem; }
            .details-hero { 
                padding: 60px 15px 80px; 
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
            }
        }

        /* 📱 Global Mobile Fixes */
        html, body {
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }
        .container {
            padding-left: 20px !important;
            padding-right: 20px !important;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <header class="details-hero">
        <a href="${pageContext.request.contextPath}/financial-literacy" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Hub
        </a>
        <div class="container text-center">
            <div class="badge-list justify-content-center" id="workshopBadges">
                <c:if test="${workshop != null}">
                    <span class="badge-item"><i class="fas fa-map-marker-alt me-1"></i>${workshop.city}</span>
                    <span class="badge-item"><i class="fas fa-users me-1"></i>${workshop.seats} Seats</span>
                </c:if>
            </div>
            <h1 id="workshopTitle">${workshop != null ? workshop.title : 'Workshop Not Found'}</h1>
        </div>
    </header>

    <main class="container mt-5 mb-5">
        <!-- Workshop Details -->
        <div class="section-card">
            <p id="workshopDescription" class="mb-4">${workshop != null ? workshop.description : ''}</p>
            
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="p-3 rounded" style="background: rgba(30, 27, 75, 0.05);">
                        <i class="fas fa-map-marker-alt text-primary mb-2"></i>
                        <h6 class="fw-bold mb-1">Venue</h6>
                        <p class="mb-0" id="workshopVenue">${workshop != null ? workshop.venue : ''}</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 rounded" style="background: rgba(30, 27, 75, 0.05);">
                        <i class="fas fa-calendar text-primary mb-2"></i>
                        <h6 class="fw-bold mb-1">Date</h6>
                        <p class="mb-0" id="workshopDate">${workshop != null ? workshop.date : ''}</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 rounded" style="background: rgba(30, 27, 75, 0.05);">
                        <i class="fas fa-clock text-primary mb-2"></i>
                        <h6 class="fw-bold mb-1">Time</h6>
                        <p class="mb-0" id="workshopTime">${workshop != null ? workshop.time : ''}</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 rounded" style="background: rgba(30, 27, 75, 0.05);">
                        <i class="fas fa-users text-primary mb-2"></i>
                        <h6 class="fw-bold mb-1">Seats</h6>
                        <p class="mb-0" id="workshopSeats">
                            <c:if test="${workshop != null}">
                                ${workshop.seats} seats available
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Registration Section -->
        <div class="section-card">
            <c:if test="${not empty userRegistration}">
                <c:choose>
                    <c:when test="${userRegistration.status == 'approved'}">
                        <h3><i class="fas fa-check-circle me-2" style="color: var(--fl-pink);"></i>Registration Approved!</h3>
                        <p class="text-success">Your registration for this workshop has been approved. See you there!</p>
                    </c:when>
                    <c:when test="${userRegistration.status == 'pending'}">
                        <h3><i class="fas fa-clock me-2" style="color: var(--fl-pink);"></i>Registration Pending</h3>
                        <p class="text-muted">Your registration is pending approval. We'll notify you soon!</p>
                    </c:when>
                    <c:when test="${userRegistration.status == 'rejected'}">
                        <h3><i class="fas fa-times-circle me-2" style="color: var(--fl-pink);"></i>Registration Rejected</h3>
                        <p class="text-danger">Unfortunately, your registration has been rejected.</p>
                    </c:when>
                </c:choose>
            </c:if>
            <c:if test="${empty userRegistration}">
                <h3><i class="fas fa-edit me-2" style="color: var(--fl-pink);"></i>Register for Workshop</h3>
                <form id="registrationForm" action="${pageContext.request.contextPath}/financial-literacy/workshop/register" method="POST">
                    <input type="hidden" name="workshopId" value="${workshop.id}">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
                    </div>
                    <div class="mb-3">
                        <label for="mobile" class="form-label">Mobile Number</label>
                        <input type="text" class="form-control" id="mobile" name="mobile" placeholder="Enter your mobile number" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    <div class="mb-3">
                        <label for="city" class="form-label">City</label>
                        <input type="text" class="form-control" id="city" name="city" placeholder="Enter your city" required>
                    </div>
                    <div class="mb-3">
                        <label for="occupation" class="form-label">Occupation (Optional)</label>
                        <input type="text" class="form-control" id="occupation" name="occupation" placeholder="Enter your occupation">
                    </div>
                    <div class="text-center">
                        <button type="submit" class="register-btn">
                            <i class="fas fa-check-circle me-2"></i>Register Now
                        </button>
                    </div>
                </form>
            </c:if>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function registerWorkshop(event) {
            event.preventDefault();
            alert('Registration successful! We will contact you soon.');
            document.getElementById('registrationForm').reset();
        }
    </script>
</body>
</html>