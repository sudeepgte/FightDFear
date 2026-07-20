<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${trainer.fullName} - Trainer Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #f43f5e;
            --primary-light: #ffe4e6;
            --dark-navy: #1e1b4b;
            --gradient: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            --shadow: 0 10px 30px rgba(244,63,94,0.05);
        }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            color: var(--dark-navy);
        }
        .profile-header {
            background: linear-gradient(135deg, #1e1b4b 0%, #0f172a 100%);
            color: white;
            padding: 80px 0;
            border-radius: 0 0 40px 40px;
        }
        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .card-custom {
            background: white;
            border: none;
            border-radius: 24px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }
        .spec-badge {
            background: var(--primary-light);
            color: #9f1239;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin-right: 8px;
            margin-bottom: 8px;
            display: inline-block;
        }
        .btn-booking {
            background: var(--gradient);
            color: white;
            font-weight: 600;
            border-radius: 30px;
            border: none;
            padding: 12px;
            transition: all 0.3s;
        }
        .btn-booking:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.25);
            color: white;
        }
        .rating-num {
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden; padding: 0;">
            <!-- Profile header banner -->
            <div class="profile-header text-center text-md-start">
                <div class="container px-5">
                    <div class="row align-items-center">
                        <div class="col-md-3 text-center mb-3 mb-md-0">
                            <img src="${not empty trainer.profilePhotoPath ? trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" class="profile-img" alt="${trainer.fullName}">
                        </div>
                        <div class="col-md-9">
                            <span class="badge bg-success mb-2 px-3 py-2" style="border-radius: 20px;">Certified Fitness Trainer</span>
                            <h1 class="fw-bold mb-1">${trainer.fullName}</h1>
                            <p class="text-white-50 lead mb-3">${trainer.experience} Years of Active Experience</p>
                            <div class="d-flex align-items-center gap-3">
                                <span class="fs-5 text-warning fw-bold"><i class="bi bi-star-fill"></i> ${trainer.rating > 0 ? trainer.rating : 'New'}</span>
                                <span class="text-white-50">|</span>
                                <span class="text-white-50"><i class="bi bi-geo-alt"></i> Available Hours: ${trainer.availableTimings}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="container-fluid px-5 py-5">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="border-radius:15px;">${error}</div>
                </c:if>

                <div class="row">
                    <!-- Profile Info & Reviews -->
                    <div class="col-lg-8">
                        <div class="card-custom">
                            <h4 class="fw-bold mb-3"><i class="bi bi-journal-text text-success me-2"></i> About / Bio</h4>
                            <p class="text-muted leading-relaxed">Certified coach specialized in safety workouts, strength, prenatal training, and self-defense consultation. Certified documents have been verified by the safety administrative panel.</p>
                            
                            <h5 class="fw-bold mt-4 mb-3">Specializations</h5>
                            <div>
                                <c:forEach var="cat" items="${categories}">
                                    <span class="spec-badge">${cat}</span>
                                </c:forEach>
                            </div>

                            <c:if test="${not empty trainer.certificationsPath}">
                                <h5 class="fw-bold mt-4 mb-3">Trainer Credentials</h5>
                                <a href="${trainer.certificationsPath}" target="_blank" class="btn btn-sm btn-outline-success" style="border-radius:20px;">
                                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> View Verification Certification
                                </a>
                            </c:if>
                        </div>

                        <!-- Available Group Classes -->
                        <c:if test="${not empty trainerClasses}">
                            <div class="card-custom">
                                <h4 class="fw-bold mb-4"><i class="bi bi-calendar-event text-success me-2"></i> Upcoming Group Classes</h4>
                                <div class="row g-3">
                                    <c:forEach var="fc" items="${trainerClasses}">
                                        <div class="col-md-6">
                                            <div class="border rounded-4 p-3 bg-white shadow-sm h-100 d-flex flex-column" style="transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h6 class="fw-bold mb-0 text-dark">${fc.className}</h6>
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" style="font-size:0.7rem;">${fc.category}</span>
                                                </div>
                                                
                                                <div class="d-flex align-items-center gap-2 mb-2 small text-dark fw-medium">
                                                    <i class="bi bi-calendar2-check text-primary"></i> ${fc.classDate} @ ${fc.formattedClassTime}
                                                </div>
                                                <div class="d-flex align-items-center gap-2 mb-3 small text-dark fw-medium">
                                                    <i class="bi bi-people-fill text-info"></i> ${fc.maxCapacity - fc.currentEnrollment} Seats Left
                                                </div>
                                                
                                                <div class="mt-auto d-flex justify-content-between align-items-center pt-2 border-top">
                                                    <div class="fw-bold text-success fs-5">₹${fc.price}</div>
                                                    <button type="button" class="btn btn-sm" style="background: linear-gradient(135deg, #0f766e, #10b981); color: white; border-radius: 20px; font-weight: 600; padding: 6px 16px; border: none; box-shadow: 0 4px 10px rgba(16,185,129,0.2);" data-bs-toggle="modal" data-bs-target="#bookClassModal${fc.id}">Enroll</button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Book Class Modal -->
                                        <div class="modal fade" id="bookClassModal${fc.id}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 rounded-4 shadow-lg">
                                                    <div class="modal-header bg-light border-0 rounded-top-4">
                                                        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-calendar2-check-fill text-success me-2"></i> Book Group Class</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/fitness/class/book" method="POST">
                                                        <div class="modal-body p-4">
                                                            <input type="hidden" name="classId" value="${fc.id}">
                                                            <div class="mb-4 text-center">
                                                                <h4 class="fw-bold text-dark mb-1">${fc.className}</h4>
                                                                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 mb-3">${fc.category}</span>
                                                            </div>
                                                            
                                                            <div class="p-3 bg-light rounded-3 mb-4">
                                                                <div class="d-flex justify-content-between mb-2">
                                                                    <span class="text-muted small">Date & Time</span>
                                                                    <span class="fw-bold text-dark small">${fc.classDate} @ ${fc.formattedClassTime}</span>
                                                                </div>
                                                                <div class="d-flex justify-content-between mb-2">
                                                                    <span class="text-muted small">Duration</span>
                                                                    <span class="fw-bold text-dark small">${fc.durationMinutes} Minutes</span>
                                                                </div>
                                                                <div class="d-flex justify-content-between mb-2">
                                                                    <span class="text-muted small">Format</span>
                                                                    <span class="fw-bold text-dark small">${fc.sessionType}</span>
                                                                </div>
                                                                <hr class="my-2">
                                                                <div class="d-flex justify-content-between">
                                                                    <span class="text-muted fw-bold">Total Payable</span>
                                                                    <span class="fw-bold text-success fs-5">₹${fc.price}</span>
                                                                </div>
                                                            </div>

                                                            <div class="alert alert-warning py-2 mb-0" style="font-size:0.85rem;">
                                                                <i class="bi bi-info-circle-fill me-1"></i> The fee of ₹${fc.price} will be deducted directly from your wallet balance.
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer border-0 pt-0">
                                                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-success rounded-pill px-4">Confirm Booking</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- User Feedback -->
                        <div class="card-custom">
                            <h4 class="fw-bold mb-4"><i class="bi bi-chat-left-heart text-success me-2"></i> Client Reviews</h4>
                            <div class="row align-items-center mb-4">
                                <div class="col-md-4 text-center">
                                    <div class="rating-num">${trainer.rating > 0 ? trainer.rating : '0.0'}</div>
                                    <span class="text-muted text-xs">Out of 5 Stars</span>
                                </div>
                                <div class="col-md-8 text-center text-md-start">
                                    <h6 class="fw-bold">Reviews average rating based on bookings completed.</h6>
                                    <p class="text-muted text-xs mb-0">Certified safety trainers have been evaluated for performance, feedback metrics, and security alignment.</p>
                                </div>
                            </div>

                            <hr>

                            <c:choose>
                                <c:when test="${empty reviews}">
                                    <p class="text-muted text-center py-3">No reviews left for this trainer yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="r" items="${reviews}">
                                        <div class="py-3">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="fw-bold mb-0">${r.booking.user.fullName}</h6>
                                                <span class="text-warning text-xs">
                                                    <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                                </span>
                                            </div>
                                            <p class="text-muted text-sm mb-0">${r.comment}</p>
                                            <small class="text-xs text-white-50">${r.createdAt}</small>
                                        </div>
                                        <hr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Side Booking Slot Panel -->
                    <div class="col-lg-4">
                        <div class="card-custom sticky-top" style="top: 100px; z-index:100;">
                            <h4 class="fw-bold mb-4"><i class="bi bi-wallet2 text-success me-2"></i>Book a Session</h4>
                            
                            <form action="${pageContext.request.contextPath}/fitness/book" method="POST" id="fitnessBookingForm">
                                <input type="hidden" name="trainerId" value="${trainer.id}">
                                
                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Select Category</label>
                                    <select name="category" class="form-select bg-light border-0" required style="border-radius:12px;">
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat}">${cat}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Package Duration</label>
                                    <select name="duration" id="durationSelect" class="form-select bg-light border-0" required style="border-radius:12px;" onchange="updateTotalFee()">
                                        <option value="SINGLE" data-multiplier="1">Single Session (1 Session)</option>
                                        <option value="MONTHLY" data-multiplier="10">Monthly Package (12 Sessions - Save 17%)</option>
                                        <option value="QUARTERLY" data-multiplier="25">Quarterly Package (36 Sessions - Save 30%)</option>
                                        <option value="HALF_YEAR" data-multiplier="45">6 Months Package (72 Sessions - Save 37%)</option>
                                        <option value="YEAR" data-multiplier="80">1 Year Package (144 Sessions - Save 44%)</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Start Date</label>
                                    <input type="date" name="bookingDate" class="form-control bg-light border-0" required style="border-radius:12px;" min="<%= java.time.LocalDate.now().toString() %>">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Choose Timing Slot</label>
                                    <input type="text" name="bookingTime" class="form-control bg-light border-0" placeholder="e.g. 10:00 - 11:00 AM" required style="border-radius:12px;">
                                    <small class="text-muted text-xs">Trainer Hours: ${trainer.availableTimings}</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Session Format</label>
                                    <select name="sessionType" class="form-select bg-light border-0" required style="border-radius:12px;">
                                        <option value="ONLINE">Online Class (Zoom/Meet)</option>
                                        <option value="OFFLINE">Offline Class (At Location)</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-xs fw-bold text-muted uppercase">Payment Option</label>
                                    <select name="paymentMethod" id="paymentMethodSelect" class="form-select bg-light border-0" required style="border-radius:12px;" onchange="togglePaymentInputs()">
                                        <option value="WALLET">Pay with Wallet Balance</option>
                                        <option value="CARD_UPI">Direct Card / UPI Payment</option>
                                    </select>
                                </div>

                                <!-- Dynamic Card / UPI details form -->
                                <div id="checkoutDetails" class="d-none border p-3 rounded-4 bg-light mb-3">
                                    <h6 class="fw-bold mb-3 text-dark small" style="letter-spacing:0.5px; text-transform:uppercase;">Mock Checkout Gateway</h6>
                                    
                                    <!-- Card option details -->
                                    <div class="mb-2">
                                        <label class="form-label text-xs text-muted mb-1">Card Number</label>
                                        <input type="text" id="cardNumberInput" class="form-control bg-white border-0 py-2 text-sm" placeholder="1234 5678 9876 5432" maxlength="19" style="border-radius:8px;">
                                    </div>
                                    <div class="row g-2 mb-2">
                                        <div class="col-6">
                                            <label class="form-label text-xs text-muted mb-1">Expiry Date</label>
                                            <input type="text" id="cardExpiryInput" class="form-control bg-white border-0 py-2 text-sm" placeholder="MM/YY" maxlength="5" style="border-radius:8px;">
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label text-xs text-muted mb-1">CVV</label>
                                            <input type="password" id="cardCvvInput" class="form-control bg-white border-0 py-2 text-sm" placeholder="***" maxlength="3" style="border-radius:8px;">
                                        </div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label text-xs text-muted mb-1">Or UPI ID (GPay / PhonePe)</label>
                                        <input type="text" id="upiIdInput" class="form-control bg-white border-0 py-2 text-sm" placeholder="username@upi" style="border-radius:8px;">
                                    </div>
                                </div>

                                <div class="mb-4 pt-3 border-top">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted text-sm">Total package fee</span>
                                        <strong class="text-success fs-5" id="displayedTotalFee">₹${trainer.sessionFees}</strong>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-booking w-100 py-3 text-sm">Confirm Booking & Pay</button>
                            </form>
                        </div>
                    </div>

                    <script>
                        const baseSessionFee = parseFloat("${trainer.sessionFees}");

                        function updateTotalFee() {
                            const select = document.getElementById("durationSelect");
                            const selectedOption = select.options[select.selectedIndex];
                            const multiplier = parseInt(selectedOption.getAttribute("data-multiplier"));
                            const total = baseSessionFee * multiplier;
                            document.getElementById("displayedTotalFee").innerText = "₹" + total.toLocaleString();
                        }

                        function togglePaymentInputs() {
                            const method = document.getElementById("paymentMethodSelect").value;
                            const detailsDiv = document.getElementById("checkoutDetails");
                            
                            const cardNumber = document.getElementById("cardNumberInput");
                            const expiry = document.getElementById("cardExpiryInput");
                            const cvv = document.getElementById("cardCvvInput");

                            if (method === "CARD_UPI") {
                                detailsDiv.classList.remove("d-none");
                                cardNumber.required = true;
                                expiry.required = true;
                                cvv.required = true;
                            } else {
                                detailsDiv.classList.add("d-none");
                                cardNumber.required = false;
                                expiry.required = false;
                                cvv.required = false;
                            }
                        }
                    </script>
                </div>

            </div>
        </div>
    </div>

</body>
</html>
