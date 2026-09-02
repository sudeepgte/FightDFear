<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${trainer.fullName} — Certified Fitness Coach | Fight D Fear</title>
    
    <!-- Dependencies -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --fdf-navy: #0F172A;
            --fdf-navy-light: #1E293B;
            --fdf-rose: #F43F5E;
            --fdf-rose-hover: #E11D48;
            --fdf-rose-soft: #FFF1F2;
            --fdf-rose-border: #FFE4E6;
            --fdf-bg: #F8FAFC;
            --fdf-card-bg: #FFFFFF;
            --fdf-border: #E2E8F0;
            --fdf-text: #0F172A;
            --fdf-muted: #64748B;
            --fdf-radius: 18px;
            --fdf-shadow: 0 4px 20px rgba(15, 23, 42, 0.04);
            --fdf-shadow-hover: 0 10px 30px rgba(15, 23, 42, 0.08);
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--fdf-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* 60/30/10: light page, pink hero (Martial Arts #F43F5E / #E11D48) */
        .trainer-hero {
            background: linear-gradient(135deg, #F43F5E 0%, #E11D48 100%);
            color: #FFFFFF;
            padding: 48px 0 40px;
            border-radius: 0 0 28px 28px;
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.22);
            position: relative;
        }

        .hero-avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255, 255, 255, 0.9);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        .card-clean {
            background: var(--fdf-card-bg);
            border-radius: var(--fdf-radius);
            padding: 28px;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--fdf-shadow);
            margin-bottom: 24px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card-clean:hover {
            box-shadow: var(--fdf-shadow-hover);
        }

        .section-header-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--fdf-navy);
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .spec-chip {
            background: var(--fdf-rose-soft);
            color: var(--fdf-rose-hover);
            border: 1px solid var(--fdf-rose-border);
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 9999px;
            font-size: 0.82rem;
            display: inline-block;
            margin-right: 8px;
            margin-bottom: 8px;
        }

        /* Available Slot Pills */
        .slot-pill {
            background: #FFFFFF;
            border: 1.5px solid var(--fdf-border);
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--fdf-navy);
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .slot-pill:hover:not(.disabled) {
            border-color: var(--fdf-rose);
            background: var(--fdf-rose-soft);
            color: var(--fdf-rose-hover);
            transform: translateY(-1px);
        }

        .slot-pill.active {
            background: var(--fdf-rose);
            border-color: var(--fdf-rose);
            color: #FFFFFF !important;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }

        .slot-pill.disabled {
            background: #F1F5F9;
            border-color: #E2E8F0;
            color: #94A3B8;
            cursor: not-allowed;
            opacity: 0.65;
        }

        .price-summary-box {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 14px;
            padding: 18px;
            margin-bottom: 20px;
        }

        .btn-fdf-rose {
            background: linear-gradient(135deg, #F43F5E 0%, #E11D48 100%);
            color: #FFFFFF;
            font-weight: 700;
            border-radius: 12px;
            border: none;
            padding: 14px 20px;
            transition: all 0.25s ease;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        }

        .btn-fdf-rose:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(244, 63, 94, 0.35);
            color: #FFFFFF;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden; padding: 0;" data-skip-global-back="true">
        
        <!-- Clean Hero Section -->
        <div class="trainer-hero">
            <div class="container-fluid px-4 px-lg-5">
                <a href="${pageContext.request.contextPath}/fitness" class="btn btn-sm btn-outline-light mb-4 rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Browse Coaches
                </a>
                <div class="row align-items-center">
                    <div class="col-md-auto text-center mb-3 mb-md-0">
                        <img src="${not empty trainer.profilePhotoPath ? trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" 
                             class="hero-avatar" alt="${trainer.fullName}">
                    </div>
                    <div class="col-md">
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                            <span class="badge bg-success bg-opacity-25 text-white border border-success border-opacity-50 px-3 py-1 rounded-pill" style="font-size:0.75rem;">
                                <i class="bi bi-patch-check-fill text-success me-1"></i> Verified Coach
                            </span>
                            <span class="badge bg-white bg-opacity-10 text-white border border-white border-opacity-20 px-3 py-1 rounded-pill" style="font-size:0.75rem;">
                                <i class="bi bi-award me-1"></i> ${trainer.experience > 0 ? trainer.experience : 1}+ Yrs Experience
                            </span>
                        </div>
                        <h1 class="fw-bold mb-1 text-white">${trainer.fullName}</h1>
                        <p class="text-white-50 mb-2 small">${not empty trainer.designation ? trainer.designation : 'Certified Fitness & Wellness Specialist'}</p>
                        <div class="d-flex flex-wrap align-items-center gap-3 text-white-50 small">
                            <span class="text-warning fw-bold"><i class="bi bi-star-fill me-1"></i> ${trainer.rating > 0 ? trainer.rating : '5.0'}</span>
                            <span>&bull;</span>
                            <span><i class="bi bi-geo-alt me-1"></i> ${not empty trainer.city ? trainer.city : 'Pan-India / Online'}</span>
                            <span>&bull;</span>
                            <span><i class="bi bi-clock me-1"></i> ${not empty trainer.availableTimings ? trainer.availableTimings : '06:00 AM – 09:00 PM'}</span>
                        </div>
                    </div>
                    <div class="col-md-auto mt-4 mt-md-0 text-md-end">
                        <div class="bg-white bg-opacity-10 p-3 rounded-4 border border-white border-opacity-10 text-center">
                            <span class="text-white-50 text-xs d-block mb-1">Standard Session</span>
                            <h2 class="fw-bold text-white mb-0">₹${trainer.sessionFees > 0 ? trainer.sessionFees : 499}</h2>
                            <small class="text-white-50" style="font-size:0.7rem;">per 60-min slot</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Body -->
        <div class="container-fluid px-4 px-lg-5 py-5">
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-4 mb-4 d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                    <div>${error}</div>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success rounded-4 mb-4 d-flex align-items-center" role="alert">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div>${success}</div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Left Column: Bio, Credentials, Packages, Classes, Reviews -->
                <div class="col-lg-7 col-xl-8">
                    
                    <!-- Bio & Specializations -->
                    <div class="card-clean">
                        <div class="section-header-title">
                            <i class="bi bi-person-lines-fill text-danger"></i> Coach Profile &amp; Bio
                        </div>
                        <p class="text-muted leading-relaxed mb-4">
                            <c:choose>
                                <c:when test="${not empty trainer.bio}">${trainer.bio}</c:when>
                                <c:otherwise>Certified coach specialized in women's personal safety workouts, functional strength, posture correction, prenatal fitness, and self-defense consultation. All certification credentials have been verified by the safety administration panel.</c:otherwise>
                            </c:choose>
                        </p>
                        
                        <h6 class="fw-bold text-dark mb-3">Specializations &amp; Focus Areas</h6>
                        <div class="mb-4">
                            <c:forEach var="cat" items="${categories}">
                                <span class="spec-chip"><i class="bi bi-check2-circle me-1"></i>${cat}</span>
                            </c:forEach>
                        </div>

                        <c:if test="${not empty trainer.certificationsPath}">
                            <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="fw-bold text-dark mb-0">Verified Credentials</h6>
                                    <small class="text-muted">Background verification and trainer qualification documents approved.</small>
                                </div>
                                <a href="${trainer.certificationsPath}" target="_blank" class="btn btn-sm btn-outline-dark rounded-pill px-3">
                                    <i class="bi bi-file-earmark-check me-1"></i> View Certificate
                                </a>
                            </div>
                        </c:if>
                    </div>

                    <!-- Multi-Session Packages -->
                    <c:if test="${not empty packages}">
                        <div class="card-clean">
                            <div class="section-header-title">
                                <i class="bi bi-box-seam-fill text-danger"></i> Value Packages &amp; Passes
                            </div>
                            <div class="row g-3">
                                <c:forEach var="pkg" items="${packages}">
                                    <div class="col-md-6">
                                        <div class="border rounded-4 p-4 bg-white h-100 d-flex flex-column" style="border-color: #E2E8F0;">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h6 class="fw-bold mb-0 text-dark">${pkg.packageName}</h6>
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25" style="font-size:0.7rem;">${pkg.sessionType}</span>
                                            </div>
                                            <span class="badge bg-light text-muted border mb-2 align-self-start">${pkg.category}</span>
                                            <p class="text-muted small mb-3 flex-grow-1">${not empty pkg.description ? pkg.description : 'Full access coaching and workout pass.'}</p>
                                            <div class="mt-auto d-flex justify-content-between align-items-center pt-3 border-top">
                                                <div>
                                                    <div class="fw-bold text-dark fs-5">₹${pkg.price}</div>
                                                    <div class="text-muted" style="font-size:0.75rem;">${pkg.sessionCount == 0 ? 'Unlimited' : pkg.sessionCount} Sessions &bull; ${pkg.durationDays} Days</div>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/fitness/booking/package/buy" method="POST" class="m-0" onsubmit="return confirm('Subscribe to ${pkg.packageName} for ₹${pkg.price}?');">
                                                    <input type="hidden" name="packageId" value="${pkg.id}">
                                                    <button type="submit" class="btn btn-sm btn-fdf-rose px-3">
                                                        Subscribe
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Group Classes -->
                    <c:if test="${not empty trainerClasses}">
                        <div class="card-clean">
                            <div class="section-header-title">
                                <i class="bi bi-calendar2-week-fill text-danger"></i> Scheduled Group Sessions
                            </div>
                            <div class="row g-3">
                                <c:forEach var="fc" items="${trainerClasses}">
                                    <div class="col-md-6">
                                        <div class="border rounded-4 p-3 bg-white h-100 d-flex flex-column">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h6 class="fw-bold mb-0 text-dark">${fc.className}</h6>
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" style="font-size:0.7rem;">${fc.category}</span>
                                            </div>
                                            <div class="small text-dark fw-medium mb-1">
                                                <i class="bi bi-calendar2-check text-danger me-1"></i> ${fc.classDate} @ ${fc.formattedClassTime}
                                            </div>
                                            <div class="small text-muted mb-3">
                                                <i class="bi bi-people me-1"></i> ${fc.maxCapacity - fc.currentEnrollment} Seats Available
                                            </div>
                                            <div class="mt-auto d-flex justify-content-between align-items-center pt-2 border-top">
                                                <div class="fw-bold text-dark fs-5">₹${fc.price}</div>
                                                <button type="button" class="btn btn-sm btn-dark rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#bookClassModal${fc.id}">Enroll</button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Book Class Modal -->
                                    <div class="modal fade" id="bookClassModal${fc.id}" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 rounded-4 shadow-lg">
                                                <div class="modal-header bg-light border-0 rounded-top-4">
                                                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-calendar2-check-fill text-danger me-2"></i> Book Group Class</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/fitness/class/book" method="POST">
                                                    <div class="modal-body p-4">
                                                        <input type="hidden" name="classId" value="${fc.id}">
                                                        <div class="mb-3 text-center">
                                                            <h5 class="fw-bold text-dark mb-1">${fc.className}</h5>
                                                            <span class="badge bg-success bg-opacity-10 text-success">${fc.category}</span>
                                                        </div>
                                                        <div class="p-3 bg-light rounded-3 mb-3">
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Date &amp; Time</span>
                                                                <span class="fw-bold text-dark small">${fc.classDate} @ ${fc.formattedClassTime}</span>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Duration</span>
                                                                <span class="fw-bold text-dark small">${fc.durationMinutes} Minutes</span>
                                                            </div>
                                                            <hr class="my-2">
                                                            <div class="d-flex justify-content-between">
                                                                <span class="text-muted fw-bold">Total Fee</span>
                                                                <span class="fw-bold text-dark fs-5">₹${fc.price}</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-0 pt-0">
                                                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-fdf-rose rounded-pill px-4">Confirm &amp; Pay</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Client Reviews -->
                    <div class="card-clean">
                        <div class="section-header-title">
                            <i class="bi bi-chat-quote-fill text-danger"></i> Client Ratings &amp; Reviews
                        </div>
                        <div class="d-flex align-items-center gap-4 p-3 bg-light rounded-4 mb-4">
                            <div class="text-center">
                                <h1 class="fw-bold text-dark mb-0">${trainer.rating > 0 ? trainer.rating : '5.0'}</h1>
                                <div class="text-warning small">
                                    <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                </div>
                            </div>
                            <div class="border-start ps-4">
                                <h6 class="fw-bold text-dark mb-1">Authentic Client Feedback</h6>
                                <p class="text-muted small mb-0">Ratings are submitted exclusively by users after attending verified sessions.</p>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty reviews}">
                                <div class="text-center py-4 text-muted">
                                    <i class="bi bi-chat-square-heart text-muted fs-3 d-block mb-2"></i>
                                    <p class="small mb-0">No reviews left for this trainer yet.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${reviews}">
                                    <div class="py-3 border-bottom">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <h6 class="fw-bold text-dark mb-0">${r.booking.user.fullName}</h6>
                                            <span class="text-warning small">
                                                <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                            </span>
                                        </div>
                                        <p class="text-muted small mb-1">${r.comment}</p>
                                        <small class="text-muted" style="font-size:0.7rem;">${r.createdAt}</small>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>

                <!-- Right Column: Interactive Booking Panel -->
                <div class="col-lg-5 col-xl-4">
                    <div class="card-clean sticky-top" style="top: 90px; z-index: 10;">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-calendar-plus text-danger me-2"></i>Book Personal Session</h5>
                        
                        <form action="${pageContext.request.contextPath}/fitness/book" method="POST" id="fitnessBookingForm" onsubmit="return validateBookingForm();">
                            <input type="hidden" name="trainerId" value="${trainer.id}">
                            <input type="hidden" name="bookingTime" id="selectedBookingTime" required>
                            
                            <!-- 1. Category -->
                            <div class="mb-3">
                                <label class="form-label text-xs fw-bold text-muted text-uppercase mb-1">Specialization / Focus</label>
                                <select name="category" class="form-select bg-light border-0 py-2 rounded-3 text-sm fw-medium" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}">${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- 2. Package Duration -->
                            <div class="mb-3">
                                <label class="form-label text-xs fw-bold text-muted text-uppercase mb-1">Package Option</label>
                                <select name="duration" id="durationSelect" class="form-select bg-light border-0 py-2 rounded-3 text-sm fw-medium" required onchange="calculatePriceSummary()">
                                    <option value="SINGLE" data-multiplier="1" data-sessions="1" data-discount="0">Single Session (1 Session)</option>
                                    <option value="MONTHLY" data-multiplier="10" data-sessions="12" data-discount="17">Monthly Package (12 Sessions — Save 17%)</option>
                                    <option value="QUARTERLY" data-multiplier="25" data-sessions="36" data-discount="30">Quarterly (36 Sessions — Save 30%)</option>
                                    <option value="HALF_YEAR" data-multiplier="45" data-sessions="72" data-discount="37">6 Months (72 Sessions — Save 37%)</option>
                                    <option value="YEAR" data-multiplier="80" data-sessions="144" data-discount="44">1 Year (144 Sessions — Save 44%)</option>
                                </select>
                            </div>

                            <!-- 3. Date Selection -->
                            <div class="mb-3">
                                <label class="form-label text-xs fw-bold text-muted text-uppercase mb-1">Session Date</label>
                                <input type="date" name="bookingDate" id="bookingDateInput" 
                                       class="form-control bg-light border-0 py-2 rounded-3 text-sm fw-medium" 
                                       required 
                                       min="<%= java.time.LocalDate.now().toString() %>"
                                       value="<%= java.time.LocalDate.now().plusDays(1).toString() %>"
                                       onchange="fetchAvailableSlots()">
                            </div>

                            <!-- 4. Dynamic Time Slots Selection (NO FREE-TEXT ENTRY) -->
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <label class="form-label text-xs fw-bold text-muted text-uppercase mb-0">Select Time Slot</label>
                                    <small id="slotStatusNote" class="text-muted" style="font-size:0.75rem;">Select an available slot</small>
                                </div>

                                <div id="slotsLoadingSpinner" class="text-center py-3 d-none">
                                    <div class="spinner-border spinner-border-sm text-danger" role="status"></div>
                                    <span class="text-muted small ms-2">Checking availability...</span>
                                </div>

                                <div id="slotsContainer" class="d-flex flex-column gap-2" style="max-height: 220px; overflow-y: auto; padding-right: 4px;">
                                    <!-- Dynamic Slots Injected Here -->
                                </div>

                                <div id="noSlotsMessage" class="alert alert-warning py-2 small d-none mt-2 mb-0">
                                    <i class="bi bi-info-circle me-1"></i> No slots available on this date. Please pick another date.
                                </div>
                            </div>

                            <!-- 5. Session Format -->
                            <div class="mb-3">
                                <label class="form-label text-xs fw-bold text-muted text-uppercase mb-1">Session Format</label>
                                <select name="sessionType" class="form-select bg-light border-0 py-2 rounded-3 text-sm fw-medium" required>
                                    <option value="ONLINE">Online 1-on-1 (Zoom / Google Meet)</option>
                                    <option value="OFFLINE">In-Person (Studio / Location)</option>
                                </select>
                            </div>

                            <!-- 6. Payment Method -->
                            <div class="mb-3">
                                <label class="form-label text-xs fw-bold text-muted text-uppercase mb-1">Payment Method</label>
                                <select name="paymentMethod" id="paymentMethodSelect" class="form-select bg-light border-0 py-2 rounded-3 text-sm fw-medium" required onchange="togglePaymentGateway()">
                                    <option value="WALLET">Wallet Balance (Instant Checkout)</option>
                                    <option value="CARD_UPI">Direct Card / UPI / NetBanking</option>
                                </select>
                            </div>

                            <!-- Transparent Price Summary -->
                            <div class="price-summary-box">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Base Rate (<span id="summarySessions">1 Session</span>)</span>
                                    <span class="text-dark fw-semibold" id="summaryBaseFee">₹${trainer.sessionFees}</span>
                                </div>
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Package Savings</span>
                                    <span class="text-success fw-semibold" id="summaryDiscount">- ₹0</span>
                                </div>
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Platform Fee</span>
                                    <span class="text-success fw-semibold">FREE</span>
                                </div>
                                <hr class="my-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-dark">Total Payable</span>
                                    <span class="fw-bold text-dark fs-5" id="summaryTotalAmount">₹${trainer.sessionFees}</span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-fdf-rose w-100 py-3 text-sm" id="btnSubmitBooking">
                                <i class="bi bi-shield-check me-2"></i> Confirm Booking &amp; Pay
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

<script>
    const baseSessionFee = parseFloat("${trainer.sessionFees > 0 ? trainer.sessionFees : 499}");
    const trainerId = "${trainer.id}";

    function calculatePriceSummary() {
        const select = document.getElementById("durationSelect");
        const selected = select.options[select.selectedIndex];
        const multiplier = parseInt(selected.getAttribute("data-multiplier")) || 1;
        const sessions = parseInt(selected.getAttribute("data-sessions")) || 1;
        const discountPct = parseInt(selected.getAttribute("data-discount")) || 0;

        const regularTotal = baseSessionFee * sessions;
        const actualTotal = baseSessionFee * multiplier;
        const savings = regularTotal - actualTotal;

        document.getElementById("summarySessions").innerText = sessions + (sessions === 1 ? " Session" : " Sessions");
        document.getElementById("summaryBaseFee").innerText = "₹" + regularTotal.toLocaleString();
        document.getElementById("summaryDiscount").innerText = savings > 0 ? "- ₹" + savings.toLocaleString() : "- ₹0";
        document.getElementById("summaryTotalAmount").innerText = "₹" + actualTotal.toLocaleString();
    }

    async function fetchAvailableSlots() {
        const dateInput = document.getElementById("bookingDateInput");
        const date = dateInput.value;
        const container = document.getElementById("slotsContainer");
        const spinner = document.getElementById("slotsLoadingSpinner");
        const noSlotsMsg = document.getElementById("noSlotsMessage");
        const selectedTimeInput = document.getElementById("selectedBookingTime");

        if (!date) return;

        selectedTimeInput.value = "";
        container.innerHTML = "";
        spinner.classList.remove("d-none");
        noSlotsMsg.classList.add("d-none");

        try {
            const url = "${pageContext.request.contextPath}/fitness/api/trainer/" + trainerId + "/available-slots?date=" + encodeURIComponent(date);
            const res = await fetch(url);
            const data = await res.json();

            spinner.classList.add("d-none");

            if (data.success && Array.isArray(data.slots) && data.slots.length > 0) {
                let hasAvailable = false;
                data.slots.forEach(slot => {
                    const btn = document.createElement("div");
                    btn.className = "slot-pill" + (slot.available ? "" : " disabled");
                    
                    btn.innerHTML = '<span><i class="bi bi-clock me-2"></i>' + slot.time + '</span>' + 
                                    '<span class="badge ' + (slot.available ? 'bg-success bg-opacity-10 text-success' : 'bg-secondary bg-opacity-25 text-muted') + ' rounded-pill text-xs">' + slot.reason + '</span>';

                    if (slot.available) {
                        hasAvailable = true;
                        btn.onclick = function() {
                            document.querySelectorAll(".slot-pill").forEach(p => p.classList.remove("active"));
                            btn.classList.add("active");
                            selectedTimeInput.value = slot.time;
                            document.getElementById("slotStatusNote").innerText = "Selected: " + slot.time;
                            document.getElementById("slotStatusNote").className = "text-danger fw-bold";
                        };
                    }
                    container.appendChild(btn);
                });

                if (!hasAvailable) {
                    noSlotsMsg.classList.remove("d-none");
                }
            } else {
                noSlotsMsg.classList.remove("d-none");
            }
        } catch (e) {
            spinner.classList.add("d-none");
            noSlotsMsg.innerText = "Error loading slots. Please retry.";
            noSlotsMsg.classList.remove("d-none");
        }
    }

    function validateBookingForm() {
        const slot = document.getElementById("selectedBookingTime").value;
        if (!slot) {
            alert("Please click and select an available time slot before continuing.");
            return false;
        }
        return true;
    }

    function togglePaymentGateway() {
        // Handled cleanly through backend controller based on wallet vs card
    }

    // Initialize on page load
    document.addEventListener("DOMContentLoaded", () => {
        calculatePriceSummary();
        fetchAvailableSlots();
    });
</script>

</body>
</html>
