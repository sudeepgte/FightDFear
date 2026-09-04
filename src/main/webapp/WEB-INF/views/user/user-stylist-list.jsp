<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Verified Stylists — Fight D Fear</title>
    
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

        /* Stylists Grid */
        .stylists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .stylist-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            text-align: center;
        }
        .stylist-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .stylist-img-wrapper {
            position: relative;
            overflow: hidden;
            height: 280px;
            background-color: #faf8f9;
        }
        .stylist-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .stylist-card:hover .stylist-img {
            transform: scale(1.06);
        }
        .stylist-img-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #fdf2f8, #f5f3ff);
            font-size: 48px;
            color: var(--brand-pink-light);
        }
        .stylist-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .stylist-name {
            font-size: 19px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 6px;
        }
        .stylist-spec {
            font-size: 13px;
            font-weight: 700;
            color: var(--brand-pink);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
        }
        .stylist-salon {
            font-size: 13px;
            color: var(--fdf-muted);
            margin-bottom: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .stylist-salon i {
            color: var(--brand-purple-dark);
        }
        .btn-stylist-action {
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
        .btn-stylist-action:hover {
            filter: brightness(1.1);
            color: #fff;
            transform: scale(1.02);
        }
        
        .empty-stylists {
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
            .stylists-grid {
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
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;" data-skip-global-back="true">
        
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
            
            <h1>Verified Stylists</h1>
            <p>Connect with top styling and makeover experts. View portfolios, specialization areas, and book personalized styling sessions.</p>
            
            <!-- Category Navigation Tab Pills -->
            <div class="glow-nav">
                <a href="${pageContext.request.contextPath}/index/templates">Overview</a>
                <a href="${pageContext.request.contextPath}/user/salons">Explore Salons</a>
                <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments">SkinCare Treatments</a>
                <a href="${pageContext.request.contextPath}/user/stylists" class="active">Stylists</a>
                <a href="${pageContext.request.contextPath}/salon/offers">Discounts &amp; Offers</a>
            </div>
        </div>

        <!-- Stylists Grid -->
        <div class="stylists-grid">
            <c:forEach var="stylist" items="${stylists}">
                <div class="stylist-card" data-aos="fade-up">
                    <div class="stylist-img-wrapper">
                        <c:choose>
                            <c:when test="${not empty stylist.profileImage}">
                                <img src="${pageContext.request.contextPath}${stylist.profileImage}" class="stylist-img" alt="${stylist.firstName}">
                            </c:when>
                            <c:otherwise>
                                <div class="stylist-img-placeholder">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stylist-body">
                        <h3 class="stylist-name">${stylist.firstName} ${stylist.lastName}</h3>
                        
                        <div class="stylist-spec">${stylist.specialization}</div>
                        
                        <div class="stylist-salon">
                            <i class="bi bi-shop"></i>
                            <c:choose>
                                <c:when test="${stylist.salon != null}">
                                    <span>${stylist.salon.name}</span>
                                </c:when>
                                <c:otherwise>
                                    <span>Independent Specialist</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        

                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty stylists}">
                <div class="empty-stylists col-12">
                    <i class="bi bi-people-fill display-1 mb-3 text-muted"></i>
                    <h3>No stylists listed</h3>
                    <p>Stylists have not updated their listings yet. Please check back later!</p>
                </div>
            </c:if>
        </div>

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
