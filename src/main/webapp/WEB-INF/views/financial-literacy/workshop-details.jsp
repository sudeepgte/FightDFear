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
            background: #F4F6FA;
            color: #333;
            min-height: 100vh;
            padding-top: 70px;
        }

        /* Hero Header */
        .details-hero {
            background: #F4F6FA;
            padding: 35px 0 45px;
            color: #0F172A;
            border-bottom: 1px solid #E2E8F0;
            position: relative;
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 2.2rem;
            color: #0B1736;
            margin-top: 10px;
            margin-bottom: 15px;
            line-height: 1.3;
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--fl-shadow);
            border: 1px solid rgba(11, 23, 54, 0.05);
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: #0B1736;
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

        @media (max-width: 768px) {
            .details-hero h1 { font-size: 1.8rem; }
            .details-hero { 
                padding: 25px 15px 35px; 
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
        <div class="container position-relative">
            <a href="${pageContext.request.contextPath}/financial-literacy" class="btn btn-outline-dark btn-sm rounded-pill mb-3 fw-bold px-3">
                <i class="fas fa-arrow-left me-1"></i> Back to Hub
            </a>

            <div class="d-flex flex-wrap align-items-center gap-2 mb-2" id="workshopBadges">
                <c:if test="${workshop != null}">
                    <span class="badge text-white px-3 py-2 rounded-pill fw-bold" style="background: #1e1b4b;">
                        <i class="fas fa-map-marker-alt me-1 text-danger"></i> ${workshop.city != null ? workshop.city : workshop.venue}
                    </span>
                    <span class="badge bg-secondary text-white px-3 py-2 rounded-pill fw-bold">
                        <i class="fas fa-users me-1"></i> ${workshop.seatsLeft != null ? workshop.seatsLeft : workshop.seats} Seats Available
                    </span>
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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success d-flex align-items-center gap-2" role="alert">
                        <i class="fas fa-check-circle"></i> ${message}
                    </div>
                </c:if>
                <form id="registrationForm" action="${pageContext.request.contextPath}/financial-literacy/workshop/register" method="POST" novalidate>
                    <input type="hidden" name="workshopId" value="${workshop.id}">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName"
                               placeholder="Enter your full name"
                               required minlength="2" maxlength="80"
                               pattern="[A-Za-z][A-Za-z .'-]{1,79}"
                               title="2–80 letters; spaces, apostrophes, periods, hyphens allowed">
                    </div>
                    <div class="mb-3">
                        <label for="mobile" class="form-label">Mobile Number *</label>
                        <input type="text" class="form-control" id="mobile" name="mobile"
                               placeholder="10-digit mobile number"
                               required minlength="10" maxlength="10" pattern="[0-9]{10}"
                               inputmode="numeric"
                               title="Exactly 10 digits"
                               oninput="this.value=this.value.replace(/[^0-9]/g,'')">
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address *</label>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Enter your email"
                               required maxlength="100"
                               title="Valid email address required">
                    </div>
                    <div class="mb-3">
                        <label for="city" class="form-label">City *</label>
                        <input type="text" class="form-control" id="city" name="city"
                               placeholder="Enter your city"
                               required minlength="2" maxlength="80"
                               pattern="[A-Za-z][A-Za-z .'-]{1,79}"
                               title="2–80 letters; spaces, apostrophes, periods, hyphens allowed">
                    </div>
                    <div class="mb-3">
                        <label for="occupation" class="form-label">Occupation (Optional)</label>
                        <input type="text" class="form-control" id="occupation" name="occupation"
                               placeholder="Enter your occupation" maxlength="100">
                    </div>
                    <div class="text-center">
                        <button type="submit" class="register-btn">
                            <i class="fas fa-check-circle me-2"></i>Register Now
                        </button>
                    </div>
                </form>
            </c:if>
            <c:if test="${not empty userRegistration and not empty message}">
                <div class="alert alert-success d-flex align-items-center gap-2 mt-3" role="alert">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            var form = document.getElementById('registrationForm');
            if (!form) return;
            form.addEventListener('submit', function (e) {
                var fullName = (form.fullName.value || '').trim();
                var mobile = (form.mobile.value || '').trim();
                var email = (form.email.value || '').trim();
                var city = (form.city.value || '').trim();
                var occupation = (form.occupation.value || '').trim();

                if (!/^[A-Za-z][A-Za-z .'-]{1,79}$/.test(fullName)) {
                    alert('Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed).');
                    e.preventDefault();
                    return;
                }
                if (!/^\d{10}$/.test(mobile)) {
                    alert('Mobile number must be exactly 10 digits.');
                    e.preventDefault();
                    return;
                }
                if (!/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email) || email.length > 100) {
                    alert('Please enter a valid email address.');
                    e.preventDefault();
                    return;
                }
                if (!/^[A-Za-z][A-Za-z .'-]{1,79}$/.test(city)) {
                    alert('City must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed).');
                    e.preventDefault();
                    return;
                }
                if (occupation.length > 100) {
                    alert('Occupation must be at most 100 characters.');
                    e.preventDefault();
                    return;
                }
                form.fullName.value = fullName;
                form.mobile.value = mobile;
                form.email.value = email;
                form.city.value = city;
                form.occupation.value = occupation;
            });
        })();
    </script>
</body>
</html>