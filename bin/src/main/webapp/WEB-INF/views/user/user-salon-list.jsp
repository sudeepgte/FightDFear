<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Explore Salons — Fight D Fear</title>
    
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

        /* Cards Grid */
        .salons-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .salon-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
        }
        .salon-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .salon-img-wrapper {
            position: relative;
            overflow: hidden;
            height: 200px;
            background-color: #faf8f9;
        }
        .salon-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .salon-card:hover .salon-img {
            transform: scale(1.06);
        }
        .salon-img-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #fdf2f8, #f5f3ff);
            font-size: 48px;
            color: var(--brand-pink-light);
        }
        .salon-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .salon-name {
            font-size: 19px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 12px;
        }
        .salon-info-item {
            font-size: 13px;
            color: var(--fdf-muted);
            margin-bottom: 8px;
            display: flex;
            align-items: flex-start;
            gap: 8px;
        }
        .salon-info-item i {
            color: var(--brand-pink);
            font-size: 14px;
            margin-top: 2px;
        }
        .salon-bio {
            font-size: 13px;
            color: #666;
            margin: 12px 0 20px;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex-grow: 1;
        }
        .btn-salon-action {
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
        .btn-salon-action:hover {
            filter: brightness(1.1);
            color: #fff;
            transform: scale(1.02);
        }
        
        .empty-salons {
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
            .salons-grid {
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
                <a href="${pageContext.request.contextPath}/contact" class="top-btn">
                    <i class="bi bi-envelope"></i> Get in Touch
                </a>
            </div>
            
            <h1>Explore Salons</h1>
            <p>Find professional, vetted salon options in your city. Book quality styling, skincare, and bridal appointments directly.</p>
            
            <!-- Category Navigation Tab Pills -->
            <div class="glow-nav">
                <a href="${pageContext.request.contextPath}/index/templates">Overview</a>
                <a href="${pageContext.request.contextPath}/user/salons" class="active">Explore Salons</a>
                <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments">SkinCare Treatments</a>
                <a href="${pageContext.request.contextPath}/user/stylists">Stylists</a>
                <a href="${pageContext.request.contextPath}/salon/offers">Discounts &amp; Offers</a>
            </div>
        </div>

        <!-- Salons Grid -->
        <div class="salons-grid">
            <c:forEach var="salon" items="${salons}">
                <div class="salon-card" data-aos="fade-up">
                    <div class="salon-img-wrapper">
                        <c:choose>
                            <c:when test="${not empty salon.profileImageUrl}">
                                <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" class="salon-img" alt="${salon.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="salon-img-placeholder">
                                    <i class="bi bi-shop"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="salon-body">
                        <h3 class="salon-name">${salon.name}</h3>
                        
                        <div class="salon-info-item">
                            <i class="bi bi-geo-alt-fill"></i>
                            <span>${salon.address}, ${salon.city}, ${salon.state} - ${salon.pincode}</span>
                        </div>
                        
                        <div class="salon-info-item">
                            <i class="bi bi-clock-fill"></i>
                            <span>Hours: ${salon.availabilityHours}</span>
                        </div>
                        
                        <c:if test="${not empty salon.bio}">
                            <p class="salon-bio">${salon.bio}</p>
                        </c:if>
                        
                        <a href="${pageContext.request.contextPath}/user/salon/view?id=${salon.id}" class="btn-salon-action">
                            Explore Salon
                        </a>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty salons}">
                <div class="empty-salons col-12">
                    <i class="bi bi-shop-window display-1 mb-3 text-muted"></i>
                    <h3>No salons available right now</h3>
                    <p>Check back later for updated salons in your area.</p>
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
