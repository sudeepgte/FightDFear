<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    
	<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>Martial Arts-Video Gallery</title>
			<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">

			<link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/open-iconic-bootstrap.min.css">
						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/animate.css">

						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.carousel.min.css">
						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.theme.default.min.css">
						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/magnific-popup.css">

						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/aos.css">

						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/ionicons.min.css">

						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/bootstrap-datepicker.css">
						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/jquery.timepicker.css">


						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/flaticon.css">
						<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/icomoon.css">
				<link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">
						<!-- Icons & CSS -->
						<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
						<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
						<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
						<link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
						<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
			
		
</head>
<body>
	
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
		  
		  <section class="hero-wrap js-fullheight" style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg');">
		  	  			    <div class="overlay"></div>
		  	  			    <div class="container">
		  	  			      <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center">
		  	  			        <div class="col-md-10 ftco-animate text-center">
		  	  			        	<div class="icon">
		  	  			          	<span class="flaticon-lotus"></span>
		  	  			        	</div>
		  							<h1>Martial Arts Training Videos</h1>
		  							<h2>Master Discipline, Power, and Technique</h2>
		  	  			          <div class="row justify-content-center">
		  	  			            <div class="col-md-7 mb-3">
		  	  			            	 <p>Explore a collection of expert-led martial arts tutorials, fitness sessions, and performance showcases.  
										              Enhance your skills and ignite your warrior spirit.</p>
		  	  			            </div>
		  	  			          </div>
		  	  			          <p>
		  	  			          	<a href="#" class="btn btn-watch-video btn-lg"> Watch Videos</a>  |
		  	  			          	<a href="${pageContext.request.contextPath}/video/uploadVideo" class="btn btn-watch-video btn-lg">Upload Video</a> |
		  	  			          	<a href="${pageContext.request.contextPath}/volunteers/dashboard" class="btn btn-watch-video btn-lg">Back to Dashboard</a>
		  	  			          </p>
		  	  			        </div>
		  	  			      </div>
		  	  			    </div>
		  	  			  </section>
						  <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --gradient-overlay: linear-gradient(135deg, rgba(74, 14, 120, 0.85) 0%, rgba(123, 44, 191, 0.75) 50%, rgba(255, 107, 107, 0.7) 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --hero-min-height-desktop: 70vh;
        --hero-min-height-mobile: 50vh;
        --transition-smooth: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .hero-wrap {
        position: relative;
        min-height: var(--hero-min-height-desktop);
        height: auto;
        background-size: cover !important;
        background-position: center center !important;
        background-attachment: fixed;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }

    .hero-wrap .overlay {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        background: var(--gradient-overlay);
        z-index: 1;
    }

    .hero-wrap .overlay::after {
        content: '';
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.2);
        pointer-events: none;
    }

    .hero-wrap .container {
        position: relative;
        z-index: 2;
    }

    .hero-wrap .slider-text {
        text-align: center;
        color: #fff;
    }

    .hero-wrap .icon {
        margin-bottom: 1rem;
        animation: fadeInUp 0.6s ease-out forwards;
    }

    .hero-wrap .icon span {
        font-size: 4rem;
        color: var(--primary-gold);
        text-shadow: 0 2px 10px rgba(0,0,0,0.3);
    }

    .hero-wrap h1 {
        font-size: clamp(2.2rem, 6vw, 4.5rem);
        font-weight: 800;
        line-height: 1.2;
        margin-bottom: 1rem;
        text-shadow: 0 2px 15px rgba(0, 0, 0, 0.3);
        animation: fadeInUp 0.8s ease-out forwards;
    }

    .hero-wrap h2 {
        font-size: clamp(1rem, 3vw, 1.4rem);
        font-weight: 400;
        margin-bottom: 1.5rem;
        opacity: 0.9;
        max-width: 700px;
        margin-left: auto;
        margin-right: auto;
        text-shadow: 0 1px 8px rgba(0, 0, 0, 0.2);
        animation: fadeInUp 0.8s ease-out 0.15s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }

    .hero-wrap p {
        font-size: 1rem;
        line-height: 1.6;
        text-shadow: 0 1px 5px rgba(0,0,0,0.2);
        animation: fadeInUp 0.8s ease-out 0.3s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }

    .btn-watch-video {
        display: inline-flex;
        align-items: center;
        gap: 0.6rem;
        background: var(--gradient-primary);
        color: white !important;
        font-weight: 600;
        padding: 0.9rem 2rem;
        border-radius: 50px;
        text-decoration: none;
        font-size: 1rem;
        letter-spacing: 0.5px;
        transition: var(--transition-smooth);
        box-shadow: var(--shadow-sm);
        border: none;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        z-index: 1;
        margin: 0 0.5rem;
    }

    .btn-watch-video::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 0%;
        height: 100%;
        background: linear-gradient(135deg, var(--primary-coral-dark), var(--primary-purple));
        transition: width 0.4s ease;
        z-index: -1;
        border-radius: 50px;
    }

    .btn-watch-video:hover::before {
        width: 100%;
    }

    .btn-watch-video:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
        color: white !important;
    }

    .btn-watch-video:active {
        transform: translateY(0);
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @media (max-width: 768px) {
        .hero-wrap {
            min-height: var(--hero-min-height-mobile);
            background-attachment: scroll;
        }
        .hero-wrap h1 {
            font-size: 2rem;
        }
        .hero-wrap h2 {
            font-size: 1.1rem;
        }
        .btn-watch-video {
            padding: 0.7rem 1.5rem;
            font-size: 0.9rem;
            margin: 0.3rem;
        }
    }

    @media (max-width: 480px) {
        .hero-wrap {
            min-height: 45vh;
        }
    }

    .hero-wrap.js-fullheight,
    .hero-wrap .js-fullheight {
        min-height: 85vh !important;
        height: auto !important;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth page-wide fade-in */
    body {
        animation: bodyFadeIn 0.6s ease-out;
    }
    @keyframes bodyFadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Floating animated particles / shapes behind hero (no interaction) */
    .hero-wrap::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image: radial-gradient(circle at 20% 40%, rgba(255,215,0,0.08) 2px, transparent 2px),
                          radial-gradient(circle at 80% 70%, rgba(255,107,107,0.06) 1px, transparent 1px);
        background-size: 40px 40px, 30px 30px;
        pointer-events: none;
        z-index: 0;
        animation: floatParticles 20s linear infinite;
    }
    @keyframes floatParticles {
        0% { background-position: 0 0, 0 0; }
        100% { background-position: 100px 100px, -50px 50px; }
    }

    /* 3. Gradient text effect for h1 (optional, adds depth) */
    .hero-wrap h1 {
        background: linear-gradient(135deg, #fff, var(--primary-gold));
        background-clip: text;
        -webkit-background-clip: text;
        color: transparent;
        text-shadow: none;
    }

    /* 4. Enhanced button focus and ripple (already has ripple, add focus outline) */
    .btn-watch-video:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 4px;
        border-radius: 50px;
    }

    /* 5. Custom scrollbar for the whole page (purple/gold) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
        transition: background 0.2s;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-gold);
    }

    /* 6. Hover effect for lotus icon – subtle scale and glow */
    .hero-wrap .icon span {
        transition: transform 0.3s ease, text-shadow 0.3s;
        display: inline-block;
    }
    .hero-wrap .icon:hover span {
        transform: scale(1.08);
        text-shadow: 0 0 12px rgba(255,215,0,0.6);
    }

    /* 7. Parallax-like background shift on mouse move (very subtle, no JS needed – just a scale on hover) */
    .hero-wrap {
        transition: background-position 0.1s ease;
    }
    .hero-wrap:hover {
        background-position: 52% 48% !important;
    }

    /* 8. Responsive touch improvements for very small devices */
    @media (max-width: 480px) {
        .hero-wrap .icon span {
            font-size: 3rem;
        }
        .btn-watch-video {
            padding: 0.6rem 1.2rem;
            font-size: 0.85rem;
        }
        .hero-wrap p {
            font-size: 0.9rem;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .hero-wrap.skeleton {
        background: linear-gradient(90deg, #e0e0e0 25%, #d0d0d0 50%, #e0e0e0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>			
															<section class="ftco-section bg-light py-5" id="martialVideosSection">

															  <div class="container-fluid px-4 px-md-5">

															   
															    <div class="row justify-content-center mb-4">
															      <div class="col-md-10 text-center ftco-animate">
															        <h2><i class="fas fa-video"></i> Martial Arts Video Gallery</h2>
															        <p class="text-muted">
															          Explore real training sessions, tutorials, and performances from professional martial artists.
															        </p>
															      </div>
															    </div>

															    <div class="row mb-5">
															      <div class="col-12">
															        <form action="${pageContext.request.contextPath}/video/allVideos"
															              method="get"
															              class="d-flex flex-wrap align-items-center justify-content-center gap-3">

															          <label class="fw-semibold">
															            <i class="fas fa-filter text-primary me-2"></i> Filter by Category
															          </label>

															          <select name="category"
															                  class="form-select form-select-lg w-100 w-md-auto"
															                  style="max-width: 320px;">
															            <option value="">All Categories</option>
															            <c:forEach var="cat" items="${categories}">
															              <option value="${cat}" ${param.category == cat ? 'selected' : ''}>
															                ${cat}
															              </option>
															            </c:forEach>
															          </select>

															          <button type="submit" class="btn btn-watch-video ">
															            Apply
															          </button>

															        </form>
															      </div>
															    </div>

															    <div class="row g-4">

															      <c:forEach var="video" items="${videos}">
															        <div class="col-lg-4 col-md-6 col-sm-12">

															          <div class="shadow-sm rounded overflow-hidden"
															               style="background:#fff; transition:0.3s;">
 <div style="position:relative; height:280px; overflow:hidden;">
															              <video
															                class="w-100 h-100"
															                style="object-fit:cover;"
															                controls
															                controlsList="nodownload"
															                oncontextmenu="return false;">
															                <source src="${pageContext.request.contextPath}${video.filePath}" type="video/mp4">
															              </video>

															              <!-- Play Overlay -->
															              <div style="
															                position:absolute;
															                inset:0;
															                background:rgba(0,0,0,0.35);
															                display:flex;
															                align-items:center;
															                justify-content:center;
															                opacity:0;
															                transition:0.3s;
															                pointer-events:none;"
															                onmouseover="this.style.opacity='1'"
															                onmouseout="this.style.opacity='0'">
															                <i class="fas fa-play-circle" style="font-size:60px;color:#fff;"></i>
															              </div>
															            </div>

															            <!-- Title -->
															            <div class="p-3 text-center fw-semibold"
															                 style="min-height:60px; display:flex; align-items:center; justify-content:center;">
															              ${video.title}
															            </div>

															          </div>

															        </div>
															      </c:forEach>

															    </div>

															  </div>
															</section>
<br>
<br>


						  <footer id="footer" class="footer position-relative">
						      <div class="container footer-top">
						        <div class="row gy-4">
						          <div class="col-lg-4 col-md-6 footer-about">
						            <a href="index.html" class="d-flex align-items-center">
						              <span class="sitename">Fight D Fear</span>
						            </a>
						               
						    <div class="pt-3">
						      <p class="fw-semibold">Our Values</p>
						  	<p>Empowering women to stay safe, strong, and supported through awareness, self-defense, and action.</p>
						      <p>Awareness • Safety • Equality • Empowerment</p>
						      <p class="mt-2">Building a safer tomorrow, together.</p>
						    </div>
						  </div>
						          <div class="col-lg-2 col-md-3 footer-links">
						            <h4>Useful Links</h4>
						            <ul>
						              <li><i class="bi bi-chevron-right"></i> <a href="index.html#hero">Home</a></li>
						              <li><i class="bi bi-chevron-right"></i> <a href="index.html#about">About us</a></li>
						              <li><i class="bi bi-chevron-right"></i> <a href="index.html#services">Services</a></li>
						               <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
						                </ul>
						          
						  </a>
						          </div>

						        <div class="col-lg-2 col-md-3 footer-links">
						    <h4>Our Services</h4>
						    <ul>
						      <li><i class="bi bi-chevron-right"></i> <a href="#">Emergency Assistance</a></li>
						      <li><i class="bi bi-chevron-right"></i> <a href="#">Safety Education</a></li>
						      <li><i class="bi bi-chevron-right"></i> <a href="#">Self-defense Training</a></li>
						      <li><i class="bi bi-chevron-right"></i> <a href="#">Community Support</a></li>
						    </ul>
						  </div>

						  <div class="col-lg-4 col-md-12">
						    <h4>Follow Us</h4>
						    <p>Stay connected with us for safety updates, resources, and tips. Empower yourself and others!</p>
						    <div class="social-links d-flex">
						      <a href=""><i class="bi bi-twitter"></i></a>
						      <a href=""><i class="bi bi-facebook"></i></a>
						      <a href=""><i class="bi bi-instagram"></i></a>
						      <a href=""><i class="bi bi-linkedin"></i></a>
						    </div>
						  </div>


						        </div>
						      </div>

						      <div class="container copyright text-center mt-4">
						        <p>© Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> All Rights Reserved</p>
						        <div class="credits">
						           </div>
						      </div>

						    </footer>
						  					  	<!-- Scripts -->
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
						  					  	<script src="${pageContext.request.contextPath}/beauty/js/bootstrap-datepicker.js"></script>
						  					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.timepicker.min.js"></script>
						  					  	<script src="${pageContext.request.contextPath}/beauty/js/scrollax.min.js"></script>
						  					  	<script src="${pageContext.request.contextPath}/beauty/js/google-map.js"></script>
						  					  	<script src="${pageContext.request.contextPath}/beauty/js/main.js"></script>

						  						<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
						  							<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
						  							<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>


						  </body>
						  </html>

