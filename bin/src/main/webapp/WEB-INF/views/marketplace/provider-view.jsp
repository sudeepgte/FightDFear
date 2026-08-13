<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${provider.fullName} | Women Marketplace</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #f9f6f8;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: #333;
            min-height: 100vh;
        }

        /* Profile Header */
        .profile-header {
            background: white;
            padding: 40px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            margin-bottom: 40px;
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            background: var(--gradient-primary);
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            font-weight: 900;
            margin-right: 25px;
            box-shadow: 0 10px 25px rgba(219, 39, 119, 0.3);
        }

        .provider-info h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            color: var(--m-purple);
            margin-bottom: 5px;
        }

        .badge-verified {
            background: #e7f5ff;
            color: #228be6;
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            margin-left: 10px;
        }

        /* Booking Card */
        .booking-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.05);
            position: sticky;
            top: 100px;
        }

        .form-label {
            font-weight: 700;
            font-size: 0.85rem;
            color: var(--m-purple);
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #eee;
            background: #fdfdfd;
        }

        .form-control:focus {
            border-color: var(--m-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
        }

        /* Class Card */
        .class-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.03);
            transition: 0.3s;
        }

        .class-card:hover {
            transform: scale(1.01);
            border-color: var(--m-pink);
            box-shadow: 0 15px 30px rgba(124, 45, 94, 0.08);
        }

        .class-title {
            font-weight: 800;
            color: var(--m-purple);
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .class-mode {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 800;
        }

        .mode-live { background: #fff5f5; color: #fa5252; }
        .mode-offline { background: #e7f5ff; color: #228be6; }

        .class-meta {
            font-size: 0.85rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .class-meta i { color: var(--m-pink); }

        .btn-join {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-weight: 800;
            width: 100%;
            transition: 0.3s;
        }

        .btn-join:hover {
            filter: brightness(1.1);
            transform: translateY(-2px);
            color: white;
        }

        /* Review Item */
        .review-item {
            padding: 20px;
            background: #fff;
            border-radius: 15px;
            margin-bottom: 15px;
            border-left: 4px solid var(--m-pink);
        }

        .back-link {
            color: #888;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .back-link:hover { color: var(--m-pink); }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="profile-header">
        <div class="container">
            <a href="${pageContext.request.contextPath}/marketplace/list?category=${provider.category}" class="back-link">
                <i class="bi bi-arrow-left"></i> Back to ${provider.category}s
            </a>
            <div class="d-flex align-items-center">
                <div class="profile-avatar-large">
                    ${provider.fullName.charAt(0)}
                </div>
                <div class="provider-info">
                    <div class="d-flex align-items-center">
                        <h1>${provider.fullName}</h1>
                        <span class="badge-verified"><i class="bi bi-patch-check-fill"></i> Verified Partner</span>
                    </div>
                    <div class="text-muted fw-500">
                        <i class="bi bi-geo-alt-fill text-danger me-1"></i> ${provider.locationText} &bull; 
                        <span class="ms-2"><i class="fas fa-star text-warning"></i> <b>${provider.rating > 0 ? provider.rating : 'New'}</b></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Left: Description & Classes -->
            <div class="col-lg-8">
                <div class="bg-white p-4 rounded-4 shadow-sm mb-4">
                    <h4 class="fw-800 mb-3" style="color: var(--m-purple);">About ${provider.fullName}</h4>
                    <p class="text-muted" style="line-height: 1.8;">${provider.description}</p>
                </div>

                <div class="section-title mb-3 d-flex align-items-center justify-content-between">
                    <h4 class="fw-800 m-0" style="color: var(--m-purple);">Available Classes</h4>
                    <span class="badge bg-light text-dark rounded-pill">${classes.size()} Sessions</span>
                </div>

                <c:forEach var="pc" items="${classes}">
                    <div class="class-card">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="class-title">${pc.className}</h5>
                            <span class="class-mode ${pc.mode == 'Live' ? 'mode-live' : 'mode-offline'}">
                                <i class="bi ${pc.mode == 'Live' ? 'bi-broadcast' : 'bi-person-fill'} me-1"></i> ${pc.mode}
                            </span>
                        </div>
                        <p class="text-muted small mb-3">${pc.description}</p>
                        <div class="class-meta">
                            <span><i class="bi bi-calendar-check"></i> ${pc.dateTime}</span>
                            <span><i class="bi bi-clock"></i> ${pc.duration}</span>
                            <span><i class="bi bi-people-fill"></i> ${pc.availableSeats} seats left</span>
                            <span class="ms-auto h5 m-0 fw-800" style="color: var(--m-purple);">₹${pc.price}</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/marketplace/classes/enroll" method="post">
                            <input type="hidden" name="classId" value="${pc.id}">
                            <button type="submit" class="btn btn-join" ${pc.availableSeats <= 0 ? 'disabled' : ''}>
                                ${pc.availableSeats <= 0 ? 'Fully Booked' : 'Join Class Now'}
                            </button>
                        </form>
                    </div>
                </c:forEach>

                <c:if test="${empty classes}">
                    <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                        <i class="bi bi-calendar-x display-4 text-muted opacity-25"></i>
                        <p class="mt-3 text-muted">No classes scheduled by this provider yet.</p>
                    </div>
                </c:if>

                <!-- Reviews Section -->
                <div class="section-title mt-5 mb-3">
                    <h4 class="fw-800" style="color: var(--m-purple);">Client Reviews</h4>
                </div>
                <div class="bg-white p-4 rounded-4 shadow-sm">
                    <c:if test="${canReview}">
                        <form action="${pageContext.request.contextPath}/marketplace/review" method="post" class="mb-4 pb-4 border-bottom">
                            <input type="hidden" name="providerId" value="${provider.id}">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Your Rating</label>
                                    <select class="form-select" name="rating" required>
                                        <option value="5">5 Stars (Excellent)</option>
                                        <option value="4">4 Stars</option>
                                        <option value="3">3 Stars</option>
                                        <option value="2">2 Stars</option>
                                        <option value="1">1 Star</option>
                                    </select>
                                </div>
                                <div class="col-md-9">
                                    <label class="form-label">Feedback</label>
                                    <input class="form-control" name="comment" maxlength="250" placeholder="Share your experience with others...">
                                </div>
                            </div>
                            <button class="btn btn-success mt-3 px-4 fw-700" type="submit" style="border-radius: 10px;">Post Review</button>
                        </form>
                    </c:if>

                    <c:forEach var="r" items="${reviews}">
                        <div class="review-item" style="border-left: 4px solid var(--m-pink); background: rgba(219, 39, 119, 0.02); padding: 20px; border-radius: 16px; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.01);">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div>
                                    <h6 class="m-0 fw-800" style="color: var(--m-purple);">${not empty r.user.fullName ? r.user.fullName : 'Anonymous Client'}</h6>
                                    <small class="text-muted" style="font-size: 0.8rem;">${not empty r.user.email ? r.user.email : ''}</small>
                                </div>
                                <div class="text-warning" style="font-size: 1.1rem;">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= r.rating}">
                                                <i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <p class="small text-muted mb-0" style="line-height: 1.6; font-size: 0.95rem;">${r.comment}</p>
                            <div class="text-end mt-2">
                                <small class="text-muted" style="font-size: 0.75rem;"><i class="bi bi-calendar-event me-1"></i> ${r.createdAt}</small>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <p class="text-muted text-center m-0">No reviews yet. Be the first to rate!</p>
                    </c:if>
                </div>
            </div>

            <!-- Right: Direct Booking -->
            <div class="col-lg-4">
                <div class="booking-card">
                    <h5 class="fw-800 mb-4" style="color: var(--m-purple);">One-on-One Session</h5>
                    <p class="small text-muted mb-4">Can't join a class? Book a personalized private session at your convenience.</p>
                    
                    <form action="${pageContext.request.contextPath}/marketplace/book" method="post">
                        <input type="hidden" name="providerId" value="${provider.id}">
                        <div class="mb-4">
                            <label class="form-label">Preferred Date & Time</label>
                            <input class="form-control" id="requestedTimeInput" type="datetime-local" name="requestedTime" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Session Topic / Note</label>
                            <textarea class="form-control" name="note" rows="3" maxlength="200" placeholder="E.g. I need help with advanced calculus..."></textarea>
                        </div>
                        <button class="btn btn-join py-3" type="submit">
                            Request Personal Session
                        </button>
                    </form>
                    <hr class="my-4">
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="text-decoration-none small fw-700" style="color: var(--m-pink);">
                            <i class="bi bi-clock-history"></i> View My Booking Status
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const requestedTimeInput = document.getElementById('requestedTimeInput');
            if (requestedTimeInput) {
                const now = new Date();
                const tzOffset = now.getTimezoneOffset() * 60000; // offset in milliseconds
                const localISOTime = (new Date(now - tzOffset)).toISOString().slice(0, 16);
                requestedTimeInput.setAttribute('min', localISOTime);
            }
        });
    </script>
</body>
</html>

