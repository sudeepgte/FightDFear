<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${category} Workers | Marketplace</title>
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #fffcfd;
            --m-shadow: 0 15px 35px rgba(30, 27, 75, 0.1);
        }
        body { font-family: 'Poppins', sans-serif; background: var(--m-bg); }
        .hero-section {
            background: linear-gradient(135deg, var(--m-purple) 0%, var(--m-pink) 100%);
            padding: 60px 0; color: white; text-align: center;
        }
        .worker-card {
            background: white; border-radius: 20px; padding: 30px; text-align: center;
            box-shadow: var(--m-shadow); border: 1px solid rgba(124,45,94,0.05); transition: 0.3s;
        }
        .worker-card:hover { transform: translateY(-10px); border-color: var(--m-pink); }
        .worker-avatar {
            width: 100px; height: 100px; border-radius: 50%; object-fit: cover;
            margin: 0 auto 20px; border: 4px solid var(--m-pink);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height: 100vh;">
            <div class="hero-section">
                <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-sm btn-light position-absolute" style="top:20px; left:20px;"><i class="bi bi-arrow-left"></i> Back</a>
                <h2>Verified Workers: ${category}</h2>
                <p>Hire skilled and verified women professionals</p>
            </div>
            <div class="container my-5">
                <div class="row g-4">
                    <c:forEach var="app" items="${workers}">
                        <div class="col-md-6 col-lg-4">
                            <div class="worker-card">
                                <img src="${pageContext.request.contextPath}${not empty app.user.profilePhoto ? app.user.profilePhoto : '/assets/img/hero-carousel/3.jpg'}" class="worker-avatar" alt="Avatar">
                                <h4>${app.user.fullName}</h4>
                                <p class="text-muted mb-2"><i class="fas fa-briefcase"></i> ${app.jobSubCategory}</p>
                                <p class="text-muted mb-3"><i class="fas fa-map-marker-alt"></i> ${app.user.homeAddress}</p>
                                <a href="${pageContext.request.contextPath}/marketplace/worker/${app.id}" class="btn btn-primary w-100 mb-2" style="background:var(--m-purple);border:none;">View Profile & Book</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty workers}">
                        <div class="col-12 text-center">
                            <h4 class="text-muted">No verified workers found in this category.</h4>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
