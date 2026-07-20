<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Discounts &amp; Offers — Fight D Fear</title>
    
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

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--brand-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--brand-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Sub Navigation Pills */
        .glow-nav {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        .glow-nav a {
            padding: 10px 24px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .glow-nav a:hover, .glow-nav a.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.2);
        }

        /* Offers Grid */
        .offers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .offer-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .offer-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .offer-badge {
            position: absolute;
            top: 15px; right: 15px;
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
            color: #fff;
            padding: 6px 14px;
            font-weight: 800;
            font-size: 11px;
            border-radius: 30px;
            z-index: 2;
            box-shadow: 0 4px 10px rgba(255, 65, 108, 0.3);
        }
        .offer-img-wrapper {
            position: relative;
            overflow: hidden;
            height: 180px;
            background-color: #faf8f9;
        }
        .offer-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .offer-card:hover .offer-img {
            transform: scale(1.06);
        }
        .offer-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            text-align: center;
        }
        .offer-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 10px;
        }
        .offer-desc {
            font-size: 13px;
            color: var(--fdf-muted);
            line-height: 1.5;
            margin-bottom: 16px;
            flex-grow: 1;
            min-height: 48px;
        }
        .offer-dates {
            font-size: 11px;
            color: #888;
            margin-bottom: 15px;
            font-weight: 500;
        }
        .price-section {
            margin-bottom: 20px;
            font-size: 14px;
        }
        .real-price {
            text-decoration: line-through;
            color: #9ca3af;
            margin-right: 8px;
        }
        .discounted-price {
            color: #4a00e0;
            font-weight: bold;
            font-size: 18px;
        }
        .btn-offer-action {
            display: block;
            width: 100%;
            padding: 10px 20px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            text-align: center;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
            background: var(--gradient-primary);
            color: #fff;
        }
        .btn-offer-action:hover {
            filter: brightness(1.1);
            color: #fff;
            transform: scale(1.02);
        }
        
        .empty-offers {
            text-align: center;
            padding: 80px 20px;
            color: var(--fdf-muted);
        }
        
        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
            .glow-nav { gap: 8px; margin-top: 20px; }
            .glow-nav a { padding: 8px 16px; font-size: 12px; }
            .offers-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px 15px;
            }
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
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-house-door"></i> Home
                </a>
                <a href="${pageContext.request.contextPath}/user/bookings" class="top-btn">
                    <i class="bi bi-calendar-event"></i> My Bookings
                </a>
            </div>
            
            <h1>Discounts &amp; Offers</h1>
            <p>Grab active salon discount vouchers and customized seasonal treatment packages at incredible rates.</p>
            
            <!-- Category Navigation Tab Pills -->
            <div class="glow-nav">
                <a href="${pageContext.request.contextPath}/index/templates">Overview</a>
                <a href="${pageContext.request.contextPath}/user/salons">Explore Salons</a>
                <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments">SkinCare Treatments</a>
                <a href="${pageContext.request.contextPath}/user/stylists">Stylists</a>
                <a href="${pageContext.request.contextPath}/salon/offers" class="active">Discounts &amp; Offers</a>
            </div>
        </div>

        <!-- Offers Grid -->
        <div class="offers-grid">
            <c:forEach var="offer" items="${offers}">
                <div class="offer-card" data-aos="fade-up">
                    <div class="offer-badge">${offer.discountPercent}% OFF</div>
                    <div class="offer-img-wrapper">
                        <img src="https://img.freepik.com/free-photo/beautiful-spa-composition_23-2147711025.jpg" class="offer-img" alt="${offer.title}">
                    </div>
                    <div class="offer-body">
                        <h3 class="offer-title">${offer.title}</h3>
                        <p class="offer-desc">${offer.description}</p>
                        <span class="offer-dates"><i class="bi bi-calendar-range"></i> Valid: ${offer.startDate} — ${offer.endDate}</span>
                        
                        <div class="price-section">
                            <span class="real-price">₹${offer.originalPrice}</span>
                            <span class="discounted-price">₹${offer.discountedPrice}</span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/salon/book?offerId=${offer.id}" class="btn-offer-action">
                            Book Offer
                        </a>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty offers}">
                <div class="empty-offers col-12">
                    <i class="bi bi-gift display-1 mb-3 text-muted"></i>
                    <h3>No current deals available</h3>
                    <p>Partner salons have not uploaded customized coupon deals yet. Keep checking!</p>
                </div>
            </c:if>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
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

</body>
</html>
