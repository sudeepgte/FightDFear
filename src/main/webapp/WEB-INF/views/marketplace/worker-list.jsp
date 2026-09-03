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
        body.mp-list-page {
            --bg-neutral: #F8FAFC;
            --surface-white: #FFFFFF;
            
            --struct-rose-light: #FFF1F2; /* 30% soft rose */
            --struct-border: #E2E8F0;
            
            --accent-rose: #F43F5E; /* 10% accent */
            --accent-hover: #E11D48;
            
            --text-primary: #0F172A;
            --text-secondary: #64748B;
        }
        
        body.mp-list-page #page-content-wrapper {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-neutral);
            color: var(--text-primary);
        }

        body.mp-list-page .hero-section {
            background: var(--struct-rose-light);
            padding: 60px 0; 
            color: var(--text-primary); 
            text-align: center;
            border-bottom: 1px solid var(--struct-border);
            position: relative;
        }

        body.mp-list-page .hero-section h2 {
            font-weight: 800;
            color: var(--text-primary);
        }
        body.mp-list-page .hero-section p {
            color: var(--text-secondary);
            font-weight: 500;
        }

        body.mp-list-page .worker-card {
            background: var(--surface-white); 
            border-radius: 20px; 
            padding: 30px; 
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid var(--struct-border); 
            transition: 0.3s;
        }

        body.mp-list-page .worker-card:hover { 
            transform: translateY(-5px); 
            border-color: var(--accent-rose);
            box-shadow: 0 10px 20px rgba(244, 63, 94, 0.08);
        }

        body.mp-list-page .worker-avatar {
            width: 100px; height: 100px; border-radius: 50%; object-fit: cover;
            margin: 0 auto 20px; 
            border: 3px solid var(--struct-rose-light);
        }

        body.mp-list-page .btn-primary {
            background: var(--accent-rose) !important;
            color: white !important;
            border: none !important;
            font-weight: 600;
            border-radius: 12px;
            padding: 10px 20px;
        }

        body.mp-list-page .btn-primary:hover { 
            background: var(--accent-hover) !important; 
        }

        body.mp-list-page .btn-back {
            background: var(--surface-white);
            color: var(--text-primary);
            border: 1px solid var(--struct-border);
            font-weight: 600;
            border-radius: 20px;
            padding: 6px 16px;
            transition: 0.2s;
        }
        body.mp-list-page .btn-back:hover {
            background: var(--struct-rose-light);
            color: var(--accent-rose);
            border-color: var(--accent-rose);
        }

        body.mp-list-page h4 { color: var(--text-primary); font-weight: 700; }
        body.mp-list-page .text-muted { color: var(--text-secondary) !important; }
        
        body.mp-list-page .card-icon {
            color: var(--accent-rose);
            width: 20px;
            text-align: center;
            margin-right: 6px;
        }
        
        @media (max-width: 768px) {
            body.mp-list-page .hero-section { padding: 48px 16px 36px; }
        }
    </style>
</head>
<body class="mp-list-page">
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height: 100vh; padding: 0 !important;" data-skip-global-back="true">
            <div class="hero-section">
                <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-back position-absolute" style="top:20px; left:20px;"><i class="bi bi-arrow-left"></i> Back</a>
                <h2>Verified Workers: ${category}</h2>
                <p>Hire skilled and verified women professionals</p>
            </div>
            <div class="container my-5">
                <div class="row g-4">
                    <c:forEach var="app" items="${workers}">
                        <div class="col-md-6 col-lg-4">
                            <div class="worker-card">
                                <img src="${pageContext.request.contextPath}${not empty app.profileImageUrl ? app.profileImageUrl : (not empty app.user.profilePhoto ? app.user.profilePhoto : '/assets/img/hero-carousel/3.jpg')}" class="worker-avatar" alt="Avatar">
                                <h4>${app.user.fullName}</h4>
                                <p class="text-muted mb-2">
                                    <i class="fas fa-briefcase card-icon"></i> ${not empty app.jobSubCategory ? app.jobSubCategory : app.jobCategory}
                                    <c:if test="${not empty app.yearsExperience}">
                                        &bull; ${app.yearsExperience} yrs exp
                                    </c:if>
                                </p>
                                <p class="text-muted mb-3">
                                    <i class="fas fa-map-marker-alt card-icon"></i> 
                                    <c:choose>
                                        <c:when test="${not empty app.city}">${app.city}</c:when>
                                        <c:when test="${not empty app.user.city}">${app.user.city}</c:when>
                                        <c:when test="${not empty app.address}">${app.address}</c:when>
                                        <c:when test="${not empty app.user.homeAddress}">${app.user.homeAddress}</c:when>
                                        <c:otherwise>Location not provided</c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="${pageContext.request.contextPath}/marketplace/worker/${app.id}" class="btn btn-primary w-100 mb-2">View Profile & Book</a>
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
