<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Verified ${not empty categoryLabel ? categoryLabel : category}s | Marketplace</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">

    <style>
        /* Marketplace list only — Martial Arts 60/30/10, does not restyle sidebar/header globally */
        body.mp-list-page {
            --m-navy: #1E1B4B;
            --m-navy-mid: #312E81;
            --m-rose: #F43F5E;
            --m-rose-mid: #C04B7A;
            --m-bg: #F8FAFC;
            --m-ink: #1a1a2e;
            --m-border: rgba(30, 27, 75, 0.12);
        }
        body.mp-list-page #page-content-wrapper {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: var(--m-ink);
            min-height: 100vh;
        }
        body.mp-list-page .list-header {
            background: linear-gradient(135deg, var(--m-navy) 0%, var(--m-navy-mid) 48%, var(--m-rose-mid) 100%);
            padding: 50px 0;
            color: #fff;
            margin-bottom: 40px;
            box-shadow: 0 8px 28px rgba(125, 42, 90, 0.18);
        }
        body.mp-list-page .list-header h1 { color: #fff; }
        body.mp-list-page .list-header p { color: rgba(255,255,255,0.78); }
        body.mp-list-page .list-header .btn-outline-dark,
        body.mp-list-page .list-header .btn-outline-light {
            border-color: rgba(255,255,255,0.45);
            color: #fff;
        }
        body.mp-list-page .list-header .btn-outline-dark:hover,
        body.mp-list-page .list-header .btn-outline-light:hover {
            background: var(--m-rose);
            border-color: var(--m-rose);
            color: #fff;
        }
        body.mp-list-page .provider-card {
            background: #fff;
            border-radius: 20px;
            padding: 25px;
            transition: 0.3s;
            border: 1px solid var(--m-border);
            box-shadow: 0 6px 20px rgba(125, 42, 90, 0.08);
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none;
        }
        body.mp-list-page .provider-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 32px rgba(125, 42, 90, 0.12);
            border-color: var(--m-rose);
        }
        body.mp-list-page .provider-avatar {
            width: 60px;
            height: 60px;
            background: #FFE4E6;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--m-rose);
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 20px;
        }
        body.mp-list-page .rating-badge {
            background: #FFF7ED;
            color: #C2410C;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        body.mp-list-page .location-tag {
            font-size: 0.8rem;
            color: #64748B;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        body.mp-list-page .provider-name {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--m-navy);
            margin-bottom: 5px;
        }
        body.mp-list-page .provider-desc {
            font-size: 0.9rem;
            color: #64748B;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        body.mp-list-page .btn-view {
            margin-top: auto;
            background: var(--m-navy);
            color: #fff;
            border: none;
            padding: 10px;
            border-radius: 12px;
            font-weight: 700;
            transition: 0.3s;
            text-align: center;
            display: block;
            text-decoration: none;
        }
        body.mp-list-page .btn-view:hover {
            background: var(--m-rose);
            color: #fff;
            transform: scale(1.02);
        }
        body.mp-list-page .btn-primary {
            background: var(--m-rose);
            border-color: var(--m-rose);
            color: #fff;
        }
        body.mp-list-page .btn-primary:hover {
            background: #E11D48;
            border-color: #E11D48;
            color: #fff;
        }
        @media (max-width: 768px) {
            body.mp-list-page .list-header { padding: 28px 0; }
        }
    </style>
</head>
<body class="mp-list-page">
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">


    <header class="list-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-bold mb-1">${not empty categoryLabel ? categoryLabel : category}s</h1>
                <p class="mb-0 opacity-75">Connect with verified experts in your community.</p>
            </div>
            <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-outline-dark rounded-pill px-4">
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
                <h3 class="mt-4 text-muted">No ${not empty categoryLabel ? categoryLabel : category}s found in your area.</h3>
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
