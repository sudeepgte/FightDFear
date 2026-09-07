<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Book Stylist — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        .booking-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow-md);
            margin: 40px auto;
            max-width: 600px;
        }

        .booking-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .booking-header h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--brand-purple);
        }

        .stylist-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8fafc;
            border-radius: 12px;
        }

        .stylist-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--brand-pink);
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 12px;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
        }
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.2);
            border-color: var(--brand-pink);
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--brand-pink), #e11d48);
            color: white;
            font-weight: 700;
            padding: 14px;
            border-radius: 12px;
            width: 100%;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(244, 63, 94, 0.3);
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;" data-skip-global-back="true">
        
        <div class="container">
            <div class="booking-card" data-aos="fade-up">
                <div class="booking-header">
                    <h2>Book Specialist</h2>
                    <p class="text-muted">Fill out the details to confirm your appointment.</p>
                </div>

                <div class="stylist-info">
                    <c:choose>
                        <c:when test="${not empty stylist.profileImage}">
                            <img src="${pageContext.request.contextPath}${stylist.profileImage}" class="stylist-avatar" alt="${stylist.firstName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default-profile.png" class="stylist-avatar" alt="${stylist.firstName}">
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <h5 class="mb-1 fw-bold">${stylist.firstName} ${stylist.lastName}</h5>
                        <p class="mb-0 text-muted small"><i class="bi bi-star-fill text-warning"></i> Specialist: ${stylist.specialization}</p>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/user/stylist/book" method="POST">
                    <input type="hidden" name="stylistId" value="${stylist.id}">

                    <div class="mb-4">
                        <label class="form-label">Category (Specialization)</label>
                        <input type="text" class="form-control" value="${stylist.specialization}" readonly disabled>
                    </div>

                    <div class="mb-4">
                        <label for="bookingTime" class="form-label">Time & Date</label>
                        <input type="datetime-local" class="form-control" id="bookingTime" name="bookingTime" required>
                    </div>

                    <div class="mb-4">
                        <label for="workMode" class="form-label">Work Mode</label>
                        <select class="form-select" id="workMode" name="workMode" required>
                            <option value="">Select Mode...</option>
                            <option value="In-Salon">In-Salon</option>
                            <option value="Home Visit">Home Visit</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="clientName" class="form-label">Name</label>
                        <input type="text" class="form-control" id="clientName" name="clientName" value="${sessionScope.user.fullName}" required>
                    </div>

                    <div class="mb-4">
                        <label for="clientContact" class="form-label">Contact Number</label>
                        <input type="tel" class="form-control" id="clientContact" name="clientContact" value="${sessionScope.user.phoneNumber}" pattern="[0-9]{10}" maxlength="10" required>
                    </div>

                    <button type="submit" class="btn-submit mt-2">
                        <i class="bi bi-calendar-check me-2"></i> Book Appointment
                    </button>
                </form>
            </div>
        </div>

    </div>
</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 600,
        once: true
    });
</script>

</body>
</html>
