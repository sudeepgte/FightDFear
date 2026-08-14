<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Classes | Marketplace</title>
    
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
            --m-bg: #fffcfd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: #333;
            min-height: 100vh;
        }

        .header-bg {
            background: linear-gradient(135deg, var(--m-purple) 0%, #4a1e38 100%);
            padding: 50px 0;
            color: white;
            margin-bottom: 40px;
        }

        .class-card-premium {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(124, 45, 94, 0.05);
            border: 1px solid rgba(0,0,0,0.05);
            transition: 0.3s;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .class-card-premium:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(124, 45, 94, 0.12);
            border-color: var(--m-pink);
        }

        .status-badge {
            font-size: 0.7rem;
            font-weight: 800;
            padding: 5px 12px;
            border-radius: 50px;
            text-transform: uppercase;
        }

        .nav-tabs-custom {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        .nav-tabs-custom a {
            text-decoration: none;
            color: #888;
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 12px;
            transition: 0.3s;
        }

        .nav-tabs-custom a.active {
            color: var(--m-purple);
            background: #fdf2f8;
        }

        .class-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--m-purple);
            margin-bottom: 10px;
        }

        .btn-action {
            margin-top: auto;
            border-radius: 12px;
            padding: 12px;
            font-weight: 700;
            transition: 0.3s;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="header-bg">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-900 m-0">My Marketplace</h1>
                <p class="m-0 opacity-75">Access your scheduled classes and session history.</p>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="nav-tabs-custom">
            <a href="${pageContext.request.contextPath}/marketplace/myBookings">Personal Sessions</a>
            <a href="${pageContext.request.contextPath}/marketplace/my-classes" class="active">Joined Classes</a>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="enrollment" items="${enrollments}">
                <div class="col-md-6 col-lg-4">
                    <div class="class-card-premium">
                        <div class="d-flex justify-content-between mb-3">
                            <span class="status-badge ${enrollment.providerClass.mode == 'Live' ? 'bg-danger text-white' : 'bg-primary text-white'}">
                                ${enrollment.providerClass.mode}
                            </span>
                            <span class="status-badge ${enrollment.paymentStatus == 'PAID' ? 'bg-success text-white' : 'bg-warning text-dark'}">
                                ${enrollment.paymentStatus}
                            </span>
                        </div>
                        <h4 class="class-title">${enrollment.providerClass.className}</h4>
                        <p class="text-muted small mb-4">${enrollment.providerClass.description}</p>
                        <div class="row g-2 small mb-4">
                            <div class="col-12"><i class="bi bi-calendar-event text-danger"></i> <b>${enrollment.providerClass.dateTime}</b></div>
                            <div class="col-12"><i class="bi bi-clock text-danger"></i> ${enrollment.providerClass.duration}</div>
                        </div>

                        <c:choose>
                            <c:when test="${enrollment.paymentStatus == 'PENDING'}">
                                <a href="${pageContext.request.contextPath}/marketplace/payment/${enrollment.id}" class="btn btn-warning btn-action">
                                    <i class="bi bi-credit-card-fill"></i> Finish Payment
                                </a>
                            </c:when>
                            <c:when test="${enrollment.providerClass.mode == 'Live'}">
                                <c:choose>
                                    <c:when test="${now.isAfter(enrollment.providerClass.dateTime.minusMinutes(10))}">
                                        <a href="${enrollment.providerClass.meetingLink}" target="_blank" class="btn btn-success btn-action">
                                            <i class="bi bi-play-circle-fill"></i> Join Live Class
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-secondary btn-action" disabled title="Check back 10 mins before class">
                                            <i class="bi bi-clock-history"></i> Starts at ${enrollment.providerClass.dateTime}
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <a href="${enrollment.providerClass.meetingLink}" target="_blank" class="btn btn-primary btn-action">
                                    <i class="bi bi-play-btn-fill"></i> Watch Recorded Class
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty enrollments}">
            <div class="text-center py-5 bg-white rounded-4 shadow-sm border">
                <i class="bi bi-mortarboard display-1 text-muted opacity-25"></i>
                <h4 class="mt-4 text-muted">No classes joined yet.</h4>
                <p class="text-muted">Explore the marketplace and join live or recorded sessions.</p>
                <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-primary mt-3 px-4 py-2" style="border-radius: 12px; font-weight: 700;">Explore Marketplace</a>
            </div>
        </c:if>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

