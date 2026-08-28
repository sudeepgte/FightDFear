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
        /* Marketplace /list only — Martial Arts hub tokens, scoped (no sidebar/header global restyle) */
        body.mp-list-page {
            --m-navy: #0F172A;
            --m-navy-mid: #1E293B;
            --m-rose: #F43F5E;
            --m-rose-hover: #E11D48;
            --m-rose-soft: #FFF1F2;
            --m-bg: #F8FAFC;
            --m-muted: #64748B;
            --m-border: #E2E8F0;
        }
        body.mp-list-page #page-content-wrapper {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: var(--m-navy);
            min-height: 100vh;
        }
        body.mp-list-page .list-header {
            background: #FFFFFF;
            padding: 28px 0 20px;
            color: var(--m-navy);
            margin-bottom: 24px;
            border-bottom: 1px solid var(--m-border);
            box-shadow: none;
        }
        body.mp-list-page .list-header h1 {
            font-family: 'Montserrat', sans-serif;
            color: var(--m-navy);
            letter-spacing: -0.5px;
        }
        body.mp-list-page .list-header p { color: var(--m-muted); }
        body.mp-list-page .list-header .btn-outline-dark,
        body.mp-list-page .list-header .btn-outline-light {
            background: #FFFFFF;
            border: 1px solid var(--m-border);
            color: var(--m-navy);
            min-height: 42px;
        }
        body.mp-list-page .list-header .btn-outline-dark:hover,
        body.mp-list-page .list-header .btn-outline-light:hover {
            background: var(--m-rose);
            border-color: var(--m-rose);
            color: #fff;
        }
        body.mp-list-page .provider-card {
            background: #fff;
            border-radius: 18px;
            padding: 24px;
            transition: 0.25s ease;
            border: 1px solid var(--m-border);
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none;
        }
        body.mp-list-page .provider-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border-color: #CBD5E1;
        }
        body.mp-list-page .provider-avatar {
            width: 60px;
            height: 60px;
            background: var(--m-rose-soft);
            border: 1px solid #FECDD3;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--m-rose);
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 20px;
        }
        body.mp-list-page .rating-badge {
            background: var(--m-rose-soft);
            border: 1px solid #FECDD3;
            color: #9F1239;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        body.mp-list-page .location-tag {
            font-size: 0.85rem;
            color: var(--m-muted);
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
            color: var(--m-muted);
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        body.mp-list-page .btn-view {
            margin-top: auto;
            background: var(--m-rose);
            color: #fff;
            border: none;
            padding: 10px 16px;
            min-height: 42px;
            border-radius: 12px;
            font-weight: 700;
            transition: 0.25s ease;
            text-align: center;
            display: block;
            text-decoration: none;
        }
        body.mp-list-page .btn-view:hover {
            background: var(--m-rose-hover);
            color: #fff;
        }
        body.mp-list-page .btn-primary {
            background: var(--m-rose);
            border-color: var(--m-rose);
            color: #fff;
            min-height: 42px;
        }
        body.mp-list-page .btn-primary:hover {
            background: var(--m-rose-hover);
            border-color: var(--m-rose-hover);
            color: #fff;
        }
        @media (max-width: 768px) {
            body.mp-list-page .list-header { padding: 20px 0 16px; }
            body.mp-list-page .list-header .container {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 16px;
            }
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
