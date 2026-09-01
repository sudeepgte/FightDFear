<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${workshop != null ? workshop.title : 'Workshop Details'} — Financial Literacy</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
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
            --fl-shadow: 0 15px 35px rgba(30, 27, 75, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #F8FAFC;
            color: #333;
            min-height: 100vh;
            padding-top: 0 !important;
        }

        #wrapper, #page-content-wrapper {
            width: 100% !important;
            max-width: 100vw !important;
            box-sizing: border-box !important;
        }

        /* Hero Header */
        .details-hero {
            background: #FFFFFF;
            padding: 24px 28px;
            color: #0F172A;
            border: 1px solid #E2E8F0;
            border-radius: 20px;
            position: relative;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            color: #0B1736;
            margin-top: 10px;
            margin-bottom: 10px;
            line-height: 1.3;
        }

        /* Card Layout */
        .section-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid #E2E8F0;
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: #0B1736;
            margin-bottom: 18px;
        }

        /* Metric Info Cards */
        .info-box {
            background: #FFF1F2;
            border-radius: 16px;
            padding: 18px;
            height: 100%;
            border: 1px solid #FFE4E6;
        }

        .info-box i {
            font-size: 1.4rem;
            color: var(--fl-pink);
            margin-bottom: 8px;
        }

        .info-box h6 {
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748B;
            margin-bottom: 4px;
        }
        .info-box p {
            font-weight: 700;
            font-size: 1.05rem;
            color: #1E1B4B;
            margin-bottom: 0;
        }

        .btn-back-theme {
            background-color: #1E1B4B !important;
            color: #FFFFFF !important;
            border: 1px solid #1E1B4B !important;
            padding: 7px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.88rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none !important;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(30, 27, 75, 0.15);
        }

        .btn-back-theme:hover {
            background-color: #F43F5E !important;
            border-color: #F43F5E !important;
            color: #FFFFFF !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.25);
        }

        @media (max-width: 768px) {
            html, body {
                overflow-x: hidden !important;
                width: 100% !important;
                max-width: 100vw !important;
                box-sizing: border-box !important;
            }
            .details-hero {
                padding: 16px 14px !important;
                border-radius: 16px !important;
            }
            .details-hero h1 {
                font-size: 1.3rem !important;
                word-break: break-word !important;
            }
            .section-card {
                padding: 16px 12px !important;
                border-radius: 16px !important;
                margin-bottom: 16px !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }
            .register-btn {
                width: 100% !important;
                font-size: 1rem !important;
                padding: 12px 20px !important;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- User Dashboard Shell Wrapper -->
<div id="wrapper">
    <!-- User Dashboard Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <!-- Content wrapper -->
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden; padding-top: 10px !important;">

        <!-- Breadcrumb Navigation -->
        <nav class="ap-crumb mb-3" style="font-size: 0.88rem; font-weight: 600; color: #64748B;">
            <a href="${pageContext.request.contextPath}/users/dashboard" style="color: #64748B; text-decoration: none;">Dashboard</a>
            <span class="mx-2">&gt;</span>
            <a href="${pageContext.request.contextPath}/financial-literacy" style="color: #64748B; text-decoration: none;">Financial Literacy Hub</a>
            <span class="mx-2">&gt;</span>
            <span style="color: #F43F5E;">Offline Workshops</span>
        </nav>

        <!-- Hero Header -->
        <header class="details-hero mb-4">
            <div class="container-fluid position-relative p-0">
                <a href="${pageContext.request.contextPath}/financial-literacy" class="btn-back-theme mb-3">
                    <i class="fas fa-arrow-left me-1"></i> Back
                </a>

                <div class="d-flex flex-wrap align-items-center gap-2 mb-2" id="workshopBadges">
                    <c:if test="${workshop != null}">
                        <span class="badge text-white px-3 py-2 rounded-pill fw-bold" style="background: #1e1b4b;">
                            <i class="fas fa-map-marker-alt me-1 text-danger"></i> ${workshop.city != null ? workshop.city : workshop.venue}
                        </span>
                        <span class="badge bg-secondary text-white px-3 py-2 rounded-pill fw-bold">
                            <i class="fas fa-users me-1"></i> ${workshop.seatsLeft != null ? workshop.seatsLeft : workshop.seats} Seats Available
                        </span>
                        <span class="badge text-dark px-3 py-2 rounded-pill fw-bold" style="background: #ffd700;">
                            <i class="fas fa-tag me-1"></i> ${workshop.category != null ? workshop.category : 'Financial Literacy'}
                        </span>
                    </c:if>
                </div>

                <h1 id="workshopTitle">${workshop != null ? workshop.title : 'Offline Workshop Details'}</h1>
            </div>
        </header>

        <main class="container-fluid p-0 mb-5">

            <!-- Alert Notifications -->
            <c:if test="${param.registrationSuccess eq 'true'}">
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2 fs-5"></i> <strong>Registration Submitted!</strong> Your workshop registration is pending approval by admin.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.registrationSuccess eq 'false'}">
                <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
                    <i class="fas fa-exclamation-circle me-2 fs-5"></i> <strong>Registration Failed!</strong> You may already be registered or seats are full.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Info Cards Grid -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="info-box">
                        <i class="fas fa-user-tie"></i>
                        <h6>Trainer / Speaker</h6>
                        <p id="infoTrainer">${workshop != null ? workshop.speaker : 'TBA'}</p>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="info-box">
                        <i class="fas fa-calendar-day"></i>
                        <h6>Date</h6>
                        <p id="infoDate">${(workshop != null && not empty workshop.formattedDate) ? workshop.formattedDate : workshop.date}</p>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="info-box">
                        <i class="fas fa-clock"></i>
                        <h6>Time</h6>
                        <p id="infoTime">${(workshop != null && not empty workshop.formattedTime) ? workshop.formattedTime : workshop.time}</p>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="info-box">
                        <i class="fas fa-rupee-sign"></i>
                        <h6>Entry Fee</h6>
                        <p id="infoFee">
                            <c:choose>
                                <c:when test="${workshop != null && workshop.fee != null && workshop.fee > 0}">
                                    Rs ${workshop.fee}
                                </c:when>
                                <c:otherwise>Free Entry</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Venue Details Card -->
            <div class="section-card">
                <h3 class="fw-bold mb-3" style="color: #1e1b4b;"><i class="fas fa-building me-2 text-danger"></i>Venue Details</h3>
                <div class="p-3.5 rounded-4 bg-light border border-light-subtle">
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <div class="mb-2">
                                <span class="fw-bold text-dark d-block mb-1 fs-6"><i class="fas fa-map-pin text-danger me-2"></i>Venue Name / Address</span>
                                <span id="infoVenue" class="text-secondary fs-6 leading-normal">${workshop != null ? workshop.venue : 'TBA'}</span>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="mb-2">
                                <span class="fw-bold text-dark d-block mb-1 fs-6"><i class="fas fa-city text-primary me-2"></i>City / Region</span>
                                <span id="infoCity" class="text-secondary fs-6 leading-normal">${workshop != null ? workshop.city : 'TBA'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Description Card -->
            <div class="section-card">
                <h3 class="fw-bold mb-3" style="color: #1e1b4b;"><i class="fas fa-align-left me-2 text-primary"></i>About This Workshop</h3>
                <p id="workshopDescription" class="text-secondary leading-relaxed fs-6 mb-0">
                    ${workshop != null ? workshop.description : 'No description provided.'}
                </p>
            </div>

            <!-- Dynamic Registration Action Card -->
            <div class="section-card text-center py-4">
                <c:choose>
                    <%-- Case 1: User Logged-In & Approved --%>
                    <c:when test="${not empty userRegistration and userRegistration.status == 'approved'}">
                        <div class="py-2">
                            <span class="badge px-4 py-3 rounded-pill fs-6 fw-bold mb-2" style="background-color: #DCFCE7; color: #166534; border: 1px solid #86EFAC;">
                                <i class="fas fa-check-circle me-2 text-success"></i> Registration Approved
                            </span>
                            <p class="text-muted small mb-0">You are officially registered for this offline workshop! Show this at the venue.</p>
                        </div>
                    </c:when>

                    <%-- Case 2: User Logged-In & Pending Approval --%>
                    <c:when test="${not empty userRegistration and userRegistration.status == 'pending'}">
                        <div class="py-2">
                            <div class="badge px-4 py-3 rounded-pill fs-6 fw-bold mb-2" style="background-color: #FEF3C7; color: #92400E; border: 1px solid #FCD34D;">
                                <i class="fas fa-clock me-2" style="color: #D97706;"></i> Registration Pending Approval
                            </div>
                            <p class="text-muted small mb-0">Your workshop seat request is awaiting admin approval.</p>
                        </div>
                    </c:when>

                    <%-- Case 3: User Logged-In & Rejected --%>
                    <c:when test="${not empty userRegistration and userRegistration.status == 'rejected'}">
                        <div class="py-2">
                            <div class="badge px-4 py-3 rounded-pill fs-6 fw-bold mb-2" style="background-color: #FFF1F3; color: #DC2626; border: 1px solid #FCA5A5;">
                                <i class="fas fa-times-circle me-2 text-danger"></i> Registration Rejected
                            </div>
                            <p class="text-danger small mb-0 fw-medium">Your registration request for this workshop was rejected.</p>
                        </div>
                    </c:when>

                    <%-- Case 4: Unregistered & Seats Available --%>
                    <c:when test="${empty userRegistration and workshop != null and (workshop.seatsLeft == null || workshop.seatsLeft > 0)}">
                        <button class="btn btn-danger btn-lg px-5 py-3 rounded-pill shadow-sm fw-bold register-btn" data-bs-toggle="modal" data-bs-target="#workshopModal" style="background-color: #f43f5e; border-color: #f43f5e;">
                            <i class="fas fa-user-plus me-2"></i> Register for Offline Workshop
                        </button>
                        <p class="text-muted small mt-3 mb-0">
                            <i class="fas fa-ticket-alt me-1 text-danger"></i> Seats are limited. Reserve your spot today!
                        </p>
                    </c:when>

                    <%-- Case 5: Unregistered & Workshop Full --%>
                    <c:otherwise>
                        <button class="btn btn-secondary btn-lg px-5 py-3 rounded-pill disabled" disabled style="opacity: 0.7; cursor: not-allowed;">
                            <i class="fas fa-ban me-2"></i> Workshop Full
                        </button>
                        <p class="text-danger small mt-3 mb-0">All seats for this offline workshop have been booked.</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>
    </div>
</div>

<!-- Registration Modal -->
<div class="modal fade" id="workshopModal" tabindex="-1" aria-labelledby="workshopModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 24px;">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="workshopModalLabel" style="color: #1e1b4b;">Register for Offline Workshop</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form action="${pageContext.request.contextPath}/financial-literacy/workshop/register" method="POST">
                    <input type="hidden" name="workshopId" value="${workshop.id}">
                    
                    <div class="mb-3">
                        <label for="wFullName" class="form-label fw-bold small text-muted">Full Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="wFullName" name="fullName" value="${user != null ? user.fullName : ''}" required placeholder="Enter full name">
                    </div>

                    <div class="mb-3">
                        <label for="wMobile" class="form-label fw-bold small text-muted">Mobile Number <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" id="wMobile" name="mobile" value="${user != null ? user.phoneNumber : ''}" required placeholder="Enter mobile number">
                    </div>

                    <div class="mb-3">
                        <label for="wEmail" class="form-label fw-bold small text-muted">Email Address <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="wEmail" name="email" value="${user != null ? user.email : ''}" required placeholder="Enter email address">
                    </div>

                    <div class="mb-4">
                        <label for="wCity" class="form-label fw-bold small text-muted">City / Locality</label>
                        <input type="text" class="form-control" id="wCity" name="city" placeholder="Your current city">
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn text-white py-3 rounded-pill fw-bold" style="background-color: #f43f5e; border-color: #f43f5e;">
                            Confirm Workshop Registration
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>