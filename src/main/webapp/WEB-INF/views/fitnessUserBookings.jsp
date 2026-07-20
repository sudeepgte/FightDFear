<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Fitness Bookings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #f43f5e;
            --dark-navy: #1e1b4b;
            --gradient: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            --shadow: 0 10px 30px rgba(244, 63, 94, 0.05);
        }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            color: var(--dark-navy);
        }
        .card-custom {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: var(--shadow);
            border: none;
            margin-bottom: 30px;
        }
        .btn-custom {
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.85rem;
            padding: 8px 20px;
        }
        .btn-primary-custom {
            background: var(--gradient);
            color: white;
            border: none;
        }
        .btn-primary-custom:hover {
            opacity: 0.9;
            color: white;
        }
        .avatar-small {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

        <div class="col-md-9 col-lg-10 p-4">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <div>
                        <h2 class="fw-bold mb-1">My Fitness Bookings</h2>
                        <p class="text-muted text-xs">Track requested coaching classes, cancel sessions, or review completed bookings.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/fitness" class="btn btn-outline-success btn-custom"><i class="bi bi-search me-1"></i> Browse More Coaches</a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 15px;">
                        <i class="bi bi-check-circle-fill me-2"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="border-radius: 15px;">${error}</div>
                </c:if>

                <div class="card-custom">
                    <ul class="nav nav-tabs mb-4" id="bookingTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="upcoming-tab" data-bs-toggle="tab" data-bs-target="#upcomingContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Scheduled / Requested Classes
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="past-tab" data-bs-toggle="tab" data-bs-target="#pastContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Historical Classes
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="bookingTabContents">
                        
                        <!-- UPCOMING CLASSES -->
                        <div class="tab-pane fade show active" id="upcomingContent" role="tabpanel">
                            <c:set var="hasUpcoming" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status eq 'PENDING' or b.status eq 'APPROVED'}">
                                    <c:set var="hasUpcoming" value="true" />
                                    <div class="border rounded-4 p-3 mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty b.trainer.profilePhotoPath ? b.trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" class="avatar-small">
                                            <div>
                                                <h6 class="fw-bold mb-1">${b.trainer.fullName}</h6>
                                                <span class="badge bg-light text-dark me-2">${b.category}</span>
                                                <span class="text-muted text-xs"><i class="bi bi-clock me-1"></i> ${b.bookingDate} @ ${b.bookingTime}</span>
                                                <span class="text-muted text-xs ms-2"><i class="bi bi-laptop me-1"></i> Format: <strong>${b.sessionType}</strong></span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:choose>
                                                <c:when test="${b.status eq 'PENDING'}">
                                                    <span class="badge bg-warning text-dark px-3 py-2" style="border-radius:20px;">Requested</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success px-3 py-2" style="border-radius:20px;">Confirmed</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <form action="${pageContext.request.contextPath}/fitness/booking/cancel" method="POST" onsubmit="return confirm('Cancel this session? Fully refunded if paid.');">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-custom py-1 px-3">Cancel</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasUpcoming}">
                                <p class="text-muted text-center py-4 small">No upcoming slots booked. Choose from categories above.</p>
                            </c:if>
                        </div>

                        <!-- HISTORICAL CLASSES -->
                        <div class="tab-pane fade" id="pastContent" role="tabpanel">
                            <c:set var="hasPast" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status ne 'PENDING' and b.status ne 'APPROVED'}">
                                    <c:set var="hasPast" value="true" />
                                    <div class="border rounded-4 p-3 mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty b.trainer.profilePhotoPath ? b.trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" class="avatar-small">
                                            <div>
                                                <h6 class="fw-bold mb-1">${b.trainer.fullName}</h6>
                                                <span class="badge bg-light text-dark me-2">${b.category}</span>
                                                <span class="text-muted text-xs"><i class="bi bi-calendar-event me-1"></i> ${b.bookingDate}</span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:choose>
                                                <c:when test="${b.status eq 'COMPLETED'}">
                                                    <span class="badge bg-primary px-3 py-2" style="border-radius:20px;">Completed</span>
                                                    <!-- Trigger Rate Modal -->
                                                    <button type="button" class="btn btn-primary-custom btn-custom py-1" data-bs-toggle="modal" data-bs-target="#rateModal${b.id}">
                                                        Leave Review
                                                    </button>
                                                </c:when>
                                                <c:when test="${b.status eq 'REJECTED'}">
                                                    <span class="badge bg-danger px-3 py-2" style="border-radius:20px;">Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary px-3 py-2" style="border-radius:20px;">Cancelled</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Rating Modal -->
                                    <div class="modal fade" id="rateModal${b.id}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content" style="border-radius: 24px; padding: 20px;">
                                                <div class="modal-header border-0">
                                                    <h5 class="fw-bold modal-title">Rate Coach ${b.trainer.fullName}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body border-0">
                                                    <form action="${pageContext.request.contextPath}/fitness/booking/rate" method="POST">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <div class="mb-3">
                                                            <label class="form-label text-xs fw-bold text-muted uppercase">Star Rating</label>
                                                            <select name="rating" class="form-select bg-light border-0" required style="border-radius:10px;">
                                                                <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                                                                <option value="4">⭐⭐⭐⭐ (Good)</option>
                                                                <option value="3">⭐⭐⭐ (Average)</option>
                                                                <option value="2">⭐⭐ (Fair)</option>
                                                                <option value="1">⭐ (Poor)</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label text-xs fw-bold text-muted uppercase">Coaching Feedback / Comments</label>
                                                            <textarea name="comment" class="form-control bg-light border-0" rows="3" required style="border-radius:10px;" placeholder="Leave a review comment..."></textarea>
                                                        </div>
                                                        <button type="submit" class="btn btn-primary-custom w-100 py-2 text-xs btn-custom">Submit Feedback</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPast}">
                                <p class="text-muted text-center py-4 small">No past session records found.</p>
                            </c:if>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
