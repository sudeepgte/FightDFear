<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Verified ${category}s | Marketplace</title>
    
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

        .list-header {
            background: linear-gradient(135deg, var(--m-purple) 0%, #4a1e38 100%);
            padding: 50px 0;
            color: white;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .provider-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            transition: 0.3s;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 10px 25px rgba(124, 45, 94, 0.05);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .provider-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(124, 45, 94, 0.12);
            border-color: var(--m-pink);
        }

        .provider-avatar {
            width: 60px;
            height: 60px;
            background: #fdf2f8;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--m-pink);
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .rating-badge {
            background: #fff9db;
            color: #f59f00;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .location-tag {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .provider-name {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--m-purple);
            margin-bottom: 5px;
        }

        .provider-desc {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .btn-view {
            margin-top: auto;
            background: var(--m-purple);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 12px;
            font-weight: 700;
            transition: 0.3s;
        }

        .btn-view:hover {
            background: var(--m-pink);
            color: white;
            transform: scale(1.02);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">


    <header class="list-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-bold mb-1">${category}s</h1>
                <p class="mb-0 opacity-75">Connect with verified experts in your community.</p>
            </div>
            <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-outline-light rounded-pill px-4">
                <i class="bi bi-grid-fill me-2"></i> Categories
            </a>
        </div>
    </header>

    <div class="container mb-5">
        <c:if test="${not empty providers}">
            <div class="row g-4">
                <c:forEach var="p" items="${providers}">
                    <div class="col-md-6 col-lg-4">
                        <div class="provider-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="provider-avatar">
                                    ${p.fullName.charAt(0)}
                                </div>
                                <div class="rating-badge">
                                    <i class="fas fa-star"></i> ${p.rating > 0 ? p.rating : 'New'}
                                </div>
                            </div>
                            <h3 class="provider-name">${p.fullName}</h3>
                            <div class="location-tag">
                                <i class="bi bi-geo-alt-fill"></i> ${p.locationText}
                            </div>
                            <p class="provider-desc">${p.description}</p>
                            <a href="${pageContext.request.contextPath}/marketplace/view/${p.id}" class="btn btn-view">
                                View Profile & Classes
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty providers}">
            <div class="text-center py-5">
                <i class="bi bi-people text-muted display-1 opacity-25"></i>
                <h3 class="mt-4 text-muted">No ${category}s found in your area.</h3>
                <p class="text-muted">Check back later or explore other categories.</p>
                <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-primary mt-3 px-4">Back to Marketplace</a>
            </div>
        </c:if>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    </div>
</div>
</body>
</html>
