<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>About Us | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/open-iconic-bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/aos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/ionicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

    <style>
    /* ===============================
       🎨 UNIVERSAL THEME: MULBERRY & ROSE
       =============================== */
    :root {
        --fdf-mulberry: #6a0dad;
        --fdf-plum: #312e81;
        --fdf-rose: #d63384;
    }

    /* Navbar Theme */
    #header {
        background: #7d265a !important; /* wine/deep plum */
        box-shadow: 0 2px 15px rgba(0,0,0,0.2);
    }
    #header .logo h1, #header .navmenu a {
        color: #fff !important;
    }
    #header .navmenu a:hover, #header .navmenu .active {
        color: #ffd6ff !important;
    }

    /* Hero Section */
    .hero-wrap {
        height: 60vh !important;
        min-height: 500px !important;
    }
    .hero-highlight-text {
        background: rgba(166, 66, 129, 0.15);
        display: inline-block;
        padding: 12px 30px;
        border-radius: 50px;
        backdrop-filter: blur(8px);
        border: 1px solid rgba(255, 255, 255, 0.25);
        font-weight: 500;
        font-size: 1.15rem;
        color: #fff;
        margin-bottom: 20px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        text-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }

    .subheading {
        color: var(--fdf-plum) !important;
        text-transform: uppercase;
        letter-spacing: 2px;
        font-weight: 700;
        font-size: 1rem;
    }

    .btn-watch-video {
        background: var(--fdf-plum) !important;
        color: #fff !important;
        border-radius: 50px;
        padding: 12px 30px;
        font-weight: 600;
        text-transform: uppercase;
    }

    /* 📱 Mobile Responsive Fixes */
    html, body {
        overflow-x: hidden;
        width: 100%;
    }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/index-beauty-header.jsp" />

    <section class="hero-wrap js-fullheight" 
             style="background-image: linear-gradient(rgba(166, 66, 129, 0.3), rgba(0, 0, 0, 0.7)), url('${pageContext.request.contextPath}/beauty/images/bg_2.jpg'); background-position: center; background-size: cover; background-attachment: fixed;">
        <div class="overlay"></div>
        <div class="container">
            <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center">
                <div class="col-md-10 ftco-animate text-center">
                    <div class="icon"><span class="flaticon-lotus"></span></div>
                    <h1 class="mb-4">Our Vision & Mission</h1>
                    <div class="row justify-content-center">
                        <div class="col-md-9 mb-3">
                            <p class="hero-highlight-text">Empowering women through safety, beauty, and confidence.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section">
        <div class="container">
            <div class="row justify-content-center mb-5 pb-3">
                <div class="col-md-7 heading-section ftco-animate text-center">
                    <h3 class="subheading">About Fight D Fear</h3>
                    <h2 class="mb-4">More Than Just Beauty</h2>
                    <p>At Fight D Fear, we believe that empowerment comes in many forms. Whether it's the strength found in self-defense or the confidence that comes from professional self-care, we are here to support every woman's journey toward a safer and more confident life.</p>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-4 ftco-animate">
                    <div class="services p-4 text-center border rounded">
                        <div class="icon mb-3"><i class="fa-solid fa-shield-heart fa-2x" style="color:var(--fdf-plum);"></i></div>
                        <h3>Safety First</h3>
                        <p>Our platform integrates core safety features, emergency support, and verified service providers for peace of mind.</p>
                    </div>
                </div>
                <div class="col-md-4 ftco-animate">
                    <div class="services p-4 text-center border rounded">
                        <div class="icon mb-3"><i class="fa-solid fa-star fa-2x" style="color:var(--fdf-plum);"></i></div>
                        <h3>Premium Quality</h3>
                        <p>We partner with top-tier salons and certified stylists to ensure you receive the highest standard of care.</p>
                    </div>
                </div>
                <div class="col-md-4 ftco-animate">
                    <div class="services p-4 text-center border rounded">
                        <div class="icon mb-3"><i class="fa-solid fa-handshake-angle fa-2x" style="color:var(--fdf-plum);"></i></div>
                        <h3>Supportive Community</h3>
                        <p>Joining Fight D Fear means becoming part of a community dedicated to mutual support and empowerment.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer id="footer" class="footer position-relative">
        <div class="container footer-top">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6 footer-about">
                    <a href="${pageContext.request.contextPath}/index/templates" class="d-flex align-items-center">Fight D Fear</a>
                    <div class="pt-3">
                        <p class="fw-semibold">Our Values</p>
                        <p>Awareness • Safety • Equality • Empowerment</p>
                        <p class="mt-2">Building a safer tomorrow, together.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-3 footer-links">
                    <h4>Useful Links</h4>
                    <ul>
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates">Home</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/about">About us</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates#services">Services</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-3 footer-links">
                    <h4>Our Services</h4>
                    <ul>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">Emergency Assistance</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">Safety Education</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">Community Support</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-12">
                    <h4>Follow Us</h4>
                    <p>Stay connected for safety updates and resources.</p>
                    <div class="social-links d-flex">
                        <a href="#"><i class="bi bi-twitter"></i></a>
                        <a href="#"><i class="bi bi-facebook"></i></a>
                        <a href="#"><i class="bi bi-instagram"></i></a>
                        <a href="#"><i class="bi bi-linkedin"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery-migrate-3.0.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.easing.1.3.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.stellar.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/aos.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.animateNumber.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/scrollax.min.js"></script>
    <script src="${pageContext.request.contextPath}/beauty/js/main.js"></script>
</body>
</html>

