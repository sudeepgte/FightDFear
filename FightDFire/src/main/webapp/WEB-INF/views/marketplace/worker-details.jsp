<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${workerApp.user.fullName} | Verified Worker</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #f8f9fa;
        }
        body { font-family: 'Poppins', sans-serif; background: var(--m-bg); }
        
        .profile-header {
            background: linear-gradient(135deg, var(--m-purple) 0%, var(--m-pink) 100%);
            padding: 80px 0 100px;
            color: white;
            text-align: center;
        }
        
        .profile-container {
            max-width: 900px;
            margin: -60px auto 40px;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            position: relative;
        }

        .profile-img-wrap {
            margin-top: -90px;
            margin-bottom: 20px;
            text-align: center;
        }

        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            object-fit: cover;
        }

        .badge-verified {
            background: #198754;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .info-card i {
            color: var(--m-pink);
            font-size: 1.2rem;
            width: 30px;
        }

        .booking-section {
            background: rgba(124, 45, 94, 0.03);
            border: 2px dashed rgba(124, 45, 94, 0.2);
            border-radius: 15px;
            padding: 30px;
            margin-top: 40px;
        }

        .btn-brand {
            background: var(--m-purple);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 600;
            transition: 0.3s;
        }
        
        .btn-brand:hover {
            background: var(--m-pink);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height: 100vh;">
            
            <div class="profile-header">
                <a href="${pageContext.request.contextPath}/marketplace/workers?category=${workerApp.jobCategory}" class="btn btn-sm btn-light position-absolute" style="top:20px; left:20px;"><i class="bi bi-arrow-left"></i> Back to List</a>
            </div>

            <div class="container">
                <div class="profile-container">
                    
                    <div class="profile-img-wrap">
                        <img src="${pageContext.request.contextPath}${not empty workerApp.user.profilePhoto ? workerApp.user.profilePhoto : '/assets/img/hero-carousel/3.jpg'}" class="profile-img" alt="Profile">
                    </div>

                    <div class="text-center mb-4">
                        <h2 style="font-weight: 800; color: var(--m-purple);">${workerApp.user.fullName}</h2>
                        <span class="badge-verified"><i class="fas fa-check-circle"></i> Background Verified</span>
                        <p class="text-muted mt-2" style="font-size: 1.1rem;">${workerApp.jobSubCategory}</p>
                    </div>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-card">
                                <h5><i class="fas fa-id-card"></i> Professional Details</h5>
                                <hr>
                                <p><strong>Category:</strong> ${workerApp.jobCategory}</p>
                                <p><strong>Role:</strong> ${workerApp.jobSubCategory}</p>
                                <p><strong>Experience:</strong> Verified by Admin</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-card">
                                <h5><i class="fas fa-address-book"></i> Contact Details</h5>
                                <hr>
                                <p><strong>Email:</strong> ${workerApp.user.email}</p>
                                <p><strong>Phone:</strong> ${workerApp.user.phoneNumber}</p>
                                <p><strong>Location:</strong> ${workerApp.user.homeAddress}</p>
                                <hr>
                                <p class="mb-0 fs-5 text-success">
                                    <strong>Hourly Rate:</strong> 
                                    <c:choose>
                                        <c:when test="${not empty workerApp.hourlyRate && workerApp.hourlyRate > 0}">
                                            &#8377;${workerApp.hourlyRate}/hr
                                        </c:when>
                                        <c:otherwise>
                                            <em>Not specified</em>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${workerApp.user.id == sessionScope.user.id}">
                            <div class="alert alert-info mt-4">
                                <i class="fas fa-info-circle"></i> This is your own worker profile. You cannot book your own services.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="booking-section">
                                <h4 class="mb-4" style="color: var(--m-purple); font-weight: 700;"><i class="fas fa-calendar-check text-primary me-2"></i> Book this Professional</h4>
                                <form action="${pageContext.request.contextPath}/marketplace/worker/${workerApp.id}/book" method="POST">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Select Date & Time (Max 2 days in advance)</label>
                                            <input type="datetime-local" class="form-control" name="bookingDate" id="bookingDateInput" required>
                                            <c:if test="${not empty bookedTimes}">
                                                <div class="mt-2 text-danger" style="font-size: 0.9em;">
                                                    <strong>Unavailable Slots:</strong>
                                                    <ul class="mb-0 ps-3">
                                                        <c:forEach var="time" items="${bookedTimes}">
                                                            <li>${time.replace('T', ' ')}</li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Offered Amount (&#8377;)</label>
                                            <input type="number" class="form-control" name="totalAmount" id="totalAmount" min="1" step="0.01" placeholder="e.g. 1000" required>
                                            <small class="text-muted">Enter the amount you are willing to pay for this job.</small>
                                        </div>
                                        <div class="col-md-12 mt-3">
                                            <label class="form-label fw-bold">Special Instructions / Notes</label>
                                            <textarea class="form-control" name="note" rows="2" placeholder="Any specific requirements..."></textarea>
                                        </div>

                                        <div class="col-12 mt-4 text-end">
                                            <button type="submit" class="btn btn-brand btn-lg w-100"><i class="fas fa-paper-plane"></i> Send Booking Request</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const bookedTimes = [
            <c:forEach var="time" items="${bookedTimes}" varStatus="loop">
                "${time}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        // Restrict datetime picker to next 2 days
        const dateInputElem = document.getElementById('bookingDateInput');
        const now = new Date();
        const maxDate = new Date();
        maxDate.setDate(now.getDate() + 2);

        const formatDateTime = (date) => {
            const pad = (n) => n.toString().padStart(2, '0');
            return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate()) + 'T' + pad(date.getHours()) + ':' + pad(date.getMinutes());
        };

        dateInputElem.min = formatDateTime(now);
        dateInputElem.max = formatDateTime(maxDate);

        document.querySelector('form').addEventListener('submit', function(e) {
            const dateInput = dateInputElem.value;
            if (!dateInput) return;
            
            const inputDate = new Date(dateInput);
            
            // Check for 2 days limit on frontend
            if (inputDate > maxDate) {
                e.preventDefault();
                alert("Bookings can only be made up to 2 days in advance.");
                return false;
            }

            // Check for booked times clashes
            for(let timeStr of bookedTimes) {
                const bookedDate = new Date(timeStr);
                const diffMinutes = Math.abs((inputDate - bookedDate) / (1000 * 60));
                if (diffMinutes < 60) {
                    e.preventDefault();
                    alert("This time slot is too close to an existing booking. Please select a time at least 1 hour away from booked slots.");
                    return false;
                }
            }
        });
    </script>
</body>
</html>
