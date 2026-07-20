<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Our Specialists | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <style>
        :root {
            --fdf-mulberry: #6a0dad;
            --fdf-plum: #312e81;
            --fdf-rose: #d63384;
            --brand-purple: #7d265a;
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

        .specialist-hero {
            background: linear-gradient(rgba(106, 13, 173, 0.4), rgba(0, 0, 0, 0.7)), 
                        url('${pageContext.request.contextPath}/beauty/images/stylist.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            padding: 150px 0 100px;
            color: white;
            text-align: center;
        }

        .specialist-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: 0.3s;
            border: 1px solid #eee;
        }

        .specialist-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(166, 66, 129, 0.2);
            border-color: var(--fdf-plum);
        }

        .specialist-img {
            height: 300px;
            width: 100%;
            object-fit: cover;
        }

        .specialist-info {
            padding: 25px;
            text-align: center;
        }

        .role-pill {
            background: rgba(166, 66, 129, 0.1);
            color: var(--fdf-plum);
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/index-beauty-header.jsp" />

    <!-- Hero -->
    <div class="specialist-hero">
        <div class="container">
            <h1 class="display-4 fw-bold">Meet Our Specialists</h1>
            <p class="lead">Expert hands dedicated to your beauty and well-being.</p>
        </div>
    </div>

    <!-- Specialists Grid -->
    <section class="ftco-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="specialist-card">
                        <img src="${pageContext.request.contextPath}/beauty/images/trainer-1.jpg" class="specialist-img" alt="Elizabeth Nelson">
                        <div class="specialist-info">
                            <div class="role-pill">Head Stylist</div>
                            <h3>Elizabeth Nelson</h3>
                            <p class="small text-muted">10+ Years Experience in Hair Design</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="specialist-card">
                        <img src="${pageContext.request.contextPath}/beauty/images/trainer-2.jpg" class="specialist-img" alt="Scarlett Torres">
                        <div class="specialist-info">
                            <div class="role-pill">Skin Expert</div>
                            <h3>Scarlett Torres</h3>
                            <p class="small text-muted">Certified Dermatological Specialist</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="specialist-card">
                        <img src="${pageContext.request.contextPath}/beauty/images/trainer-3.jpg" class="specialist-img" alt="Victoria Wright">
                        <div class="specialist-info">
                            <div class="role-pill">Spa Manager</div>
                            <h3>Victoria Wright</h3>
                            <p class="small text-muted">Holistic Wellness & Massage Expert</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="specialist-card">
                        <img src="${pageContext.request.contextPath}/beauty/images/trainer-4.jpg" class="specialist-img" alt="Stella Perry">
                        <div class="specialist-info">
                            <div class="role-pill">Colorist</div>
                            <h3>Stella Perry</h3>
                            <p class="small text-muted">Master of Creative Hair Coloring</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
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
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-12">
                    <h4>Follow Us</h4>
                    <p>Stay connected for safety updates.</p>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

