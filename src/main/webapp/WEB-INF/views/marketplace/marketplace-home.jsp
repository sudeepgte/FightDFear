<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Marketplace | Services &amp; Training</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/marketplace-theme.css" rel="stylesheet">
</head>
<body class="fdf-page-shell fdf-page-marketplace">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <div id="page-content-wrapper" data-skip-global-back="true">

        <div class="mp-page-inner">
        
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="top-btn">
                    <i class="bi bi-calendar-check"></i> My Bookings
                </a>
                <a href="${pageContext.request.contextPath}/marketplace/my-classes" class="top-btn">
                    <i class="bi bi-mortarboard"></i> My Classes
                </a>
                <a href="${pageContext.request.contextPath}/marketplace/provider/register" class="top-btn">
                    <i class="bi bi-person-plus"></i> Become a Provider
                </a>
            </div>
            <h1>Women Marketplace</h1>
            <p>Empowering local women creators, educators, and service providers. Discover skilled professionals and browse custom services.</p>
            
            <div class="search-container">
                <div class="search-box">
                    <input type="text" id="marketSearchInput" placeholder="Search for tutors, designers, bakers...">
                    <button type="button" class="btn-search" id="marketSearchBtn">Find Service</button>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="container mt-3"><div class="alert alert-danger">${error}</div></div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="container mt-3"><div class="alert alert-success">${message}</div></div>
        </c:if>

        <div class="market-grid">
            <c:forEach var="pcat" items="${providerCategories}">
                <a href="${pageContext.request.contextPath}/marketplace/list?category=${pcat}" class="category-card" data-aos="fade-up" data-search-type="provider">
                    <div class="cat-icon-box">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <h3>${pcat.displayName}</h3>
                    <p>Browse verified providers in this category.</p>
                </a>
            </c:forEach>

            <c:forEach var="cat" items="${dynamicCategories}">
                <a href="${pageContext.request.contextPath}/marketplace/workers?category=${cat}" class="category-card" data-aos="fade-up" data-search-type="worker">
                    <div class="cat-icon-box">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <h3>${cat}</h3>
                    <p>Find verified professional women specialists in ${cat}.</p>
                </a>
            </c:forEach>
            
            <c:if test="${empty providerCategories && empty dynamicCategories}">
                <div class="mp-empty-state">
                    <i class="bi bi-shop-window display-3 mb-3 d-block"></i>
                    <p class="fs-5 mb-0">No marketplace categories available yet.</p>
                </div>
            </c:if>
        </div>

        <div class="cta-box">
            <h4>Offer your skills on Women Marketplace</h4>
            <p>Register as a verified service provider or apply as a skilled worker to start earning.</p>
            <div class="d-flex flex-wrap justify-content-center gap-2">
                <a href="${pageContext.request.contextPath}/marketplace/provider/register" class="mp-btn-primary">Become a Provider</a>
                <a href="${pageContext.request.contextPath}/marketplace/earn" class="mp-btn-outline">Apply for Women Jobs</a>
            </div>
        </div>

        </div><!-- /.mp-page-inner -->

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('marketSearchInput');
        const searchButton = document.getElementById('marketSearchBtn');
        const categoryCards = document.querySelectorAll('.category-card');

        function performSearch() {
            const query = searchInput.value.trim().toLowerCase();
            categoryCards.forEach(card => {
                const title = card.querySelector('h3').innerText.toLowerCase();
                const desc = card.querySelector('p').innerText.toLowerCase();
                const match = !query || title.includes(query) || desc.includes(query);
                card.style.display = match ? 'flex' : 'none';
            });
        }

        searchInput.addEventListener('input', performSearch);

        searchButton.addEventListener('click', function() {
            const query = searchInput.value.trim().toLowerCase();
            if (!query) {
                categoryCards.forEach(card => card.style.display = 'flex');
                return;
            }
            let matchUrl = null;
            categoryCards.forEach(card => {
                const title = card.querySelector('h3').innerText.toLowerCase();
                const desc = card.querySelector('p').innerText.toLowerCase();
                if (title.includes(query) || desc.includes(query)) {
                    if (!matchUrl) matchUrl = card.getAttribute('href');
                }
            });
            if (matchUrl) {
                window.location.href = matchUrl;
            } else {
                alert('No services matched your query.');
                categoryCards.forEach(card => card.style.display = 'flex');
            }
        });

        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchButton.click();
            }
        });
    });
</script>

</body>
</html>
