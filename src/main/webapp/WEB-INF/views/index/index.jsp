<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Glow Space — Fight D Fear Beauty Services</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Main styles -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: var(--color-page-background);
            --card-bg: var(--color-primary-surface);
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Premium Floating background blobs */
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
        .blob-1 { top: -100px; right: -100px; background: var(--color-secondary-surface); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--color-secondary-rose); animation-delay: -5s; }
        
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
            color: var(--color-text-primary);
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top Bar navigation */
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
            background: var(--color-secondary-surface);
            color: var(--color-accent);
            border-color: var(--color-accent);
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.1);
        }

        /* Service Cards Grid */
        .glow-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            padding: 50px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .glow-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
        }
        .glow-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .card-img-wrapper {
            position: relative;
            overflow: hidden;
            height: 200px;
        }
        .card-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .glow-card:hover .card-img {
            transform: scale(1.08);
        }
        .card-body {
            padding: 28px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .card-category {
            font-size: 11px;
            font-weight: 800;
            color: var(--brand-pink);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }
        .card-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--brand-purple);
            margin: 4px 0 12px;
            line-height: 1.3;
        }
        .card-desc {
            font-size: 14px;
            color: var(--fdf-muted);
            margin-bottom: 24px;
            line-height: 1.6;
            flex-grow: 1;
        }
        .btn-glow-action {
            width: 100%;
            padding: 12px;
            border-radius: 14px;
            font-size: 14px;
            font-weight: 700;
            text-align: center;
            border: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            background: var(--color-accent);
            color: #FFFFFF;
        }
        .btn-glow-action:hover {
            background: var(--color-accent-hover);
            color: #FFFFFF;
            transform: scale(1.02);
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.25);
        }

        /* Mobile Responsive adjustment */
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
            .glow-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px 15px;
            }
            .card-img-wrapper { height: 160px; }
            .card-body { padding: 20px; }
            .card-title { font-size: 18px; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Main page wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;" data-skip-global-back="true">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/user/bookings" class="top-btn">
                    <i class="bi bi-calendar-event"></i> My Bookings
                </a>
            </div>
            
            <h1 style="color: #F43F5E;">Glow Space</h1>
            <p>Elevate your self-care journey. Discover elite nearby salons, connect with verified expert stylists, or book premium skincare treatments instantly.</p>
            
            <!-- Category Navigation Tab Pills -->
            <div class="glow-nav">
                <a href="${pageContext.request.contextPath}/index/templates" class="active">Overview</a>
                <a href="${pageContext.request.contextPath}/user/salons">Explore Salons</a>
                <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments">SkinCare Treatments</a>
                <a href="${pageContext.request.contextPath}/user/stylists">Stylists</a>
                <a href="${pageContext.request.contextPath}/salon/offers">Discounts &amp; Offers</a>
            </div>
        </div>

        <!-- Actions Cards Grid -->
        <div class="glow-grid">
            
            <!-- Card 1: Salons -->
            <div class="glow-card" data-aos="fade-up">
                <div class="card-img-wrapper">
                    <img src="${pageContext.request.contextPath}/beauty/images/salon.jpg" class="card-img" alt="Salons">
                </div>
                <div class="card-body">
                    <span class="card-category">Salons &amp; Parlors</span>
                    <h3 class="card-title">Explore Premium Salons</h3>
                    <p class="card-desc">Find top-rated local beauty spaces. Filter by reviews, facilities, and open slots to book the perfect salon visit.</p>
                    <a href="${pageContext.request.contextPath}/user/salons" class="btn-glow-action">
                        <i class="bi bi-shop"></i> Explore Salons
                    </a>
                </div>
            </div>

            <!-- Card 2: Treatments -->
            <div class="glow-card" data-aos="fade-up" data-aos-delay="100">
                <div class="card-img-wrapper">
                    <img src="${pageContext.request.contextPath}/beauty/images/offer-deal-1.jpg" class="card-img" alt="Treatments">
                </div>
                <div class="card-body">
                    <span class="card-category">Clinical Beauty</span>
                    <h3 class="card-title">SkinCare Treatments</h3>
                    <p class="card-desc">Treat yourself to specialized facials, detox therapies, or therapeutic skin session packages designed by experts.</p>
                    <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments" class="btn-glow-action">
                        <i class="bi bi-droplet-half"></i> Book Treatment
                    </a>
                </div>
            </div>

            <!-- Card 3: Stylists -->
            <div class="glow-card" data-aos="fade-up" data-aos-delay="200">
                <div class="card-img-wrapper">
                    <img src="${pageContext.request.contextPath}/beauty/images/stylist.jpg" class="card-img" alt="Stylists">
                </div>
                <div class="card-body">
                    <span class="card-category">Beauty Experts</span>
                    <h3 class="card-title">Verified Stylists</h3>
                    <p class="card-desc">Select certified hair, makeup, and wedding stylists. Check client portfolios and secure one-on-one sessions.</p>
                    <a href="${pageContext.request.contextPath}/user/stylists" class="btn-glow-action">
                        <i class="bi bi-scissors"></i> Find Stylists
                    </a>
                </div>
            </div>

            <!-- Card 4: Exclusive Offers -->
            <div class="glow-card" data-aos="fade-up" data-aos-delay="300">
                <div class="card-img-wrapper">
                    <img src="${pageContext.request.contextPath}/beauty/images/intro.jpg" class="card-img" alt="Discounts">
                </div>
                <div class="card-body">
                    <span class="card-category">Deals &amp; Packages</span>
                    <h3 class="card-title">Discounts &amp; Offers</h3>
                    <p class="card-desc">Claim hot limited-time deals, special festival bundles, and discount coupons from partner beauty lounges.</p>
                    <a href="${pageContext.request.contextPath}/salon/offers" class="btn-glow-action">
                        <i class="bi bi-gift"></i> View Discounts
                    </a>
                </div>
            </div>

            <!-- Card 5: Bookings Tracker -->
            <div class="glow-card" data-aos="fade-up" data-aos-delay="400">
                <div class="card-img-wrapper">
                    <img src="${pageContext.request.contextPath}/beauty/images/glow.jpg" class="card-img" alt="Bookings">
                </div>
                <div class="card-body">
                    <span class="card-category">My Appointments</span>
                    <h3 class="card-title">Manage Bookings</h3>
                    <p class="card-desc">Quickly monitor your scheduled appointments, view bill receipts, or make modifications to dates and times.</p>
                    <a href="${pageContext.request.contextPath}/user/bookings" class="btn-glow-action">
                        <i class="bi bi-calendar-check"></i> My Bookings
                    </a>
                </div>
            </div>

        </div>


    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    // Initialize animations
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });
</script>

</body>
</html>
