<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    
	<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>Enrollment Success</title>
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
	

	<!-- ======= Header ======= -->
	<header id="header" class="header d-flex align-items-center sticky-top">
	  <div class="container-fluid container-xl d-flex align-items-center">
	    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
	    <nav id="navmenu" class="navmenu">
	      <ul>

	        <li><a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Centres</a></li>
	        <li><a href="${pageContext.request.contextPath}/video/allVideos">MartialArts</a></li>
	        <li><a href="${pageContext.request.contextPath}/video/reels">Reels</a></li>
	        <li><a href="${pageContext.request.contextPath}/index/templates">Beauty</a></li>
	        <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
	        <li><a href="${pageContext.request.contextPath}/users/profile/${user.id}">Profile</a></li>
	      </ul>
	      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
	    </nav>
	    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
	    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
	  </div>
	</header>
	<!-- END nav -->
				  
				  <!-- 🥋 Enrollment Success Hero Section -->
				  <section class="hero-wrap js-fullheight" 
				           style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg');" >
				          

				    <div class="overlay"></div>

				    <div class="container">
				      <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center">
				        <div class="col-md-10 ftco-animate text-center">

				          <!-- Icon -->
				          <div class="icon mb-4">
				            <span class="flaticon-lotus"></span>
				          </div>

				          <!-- Headings -->
				          <h1 >Enrollment Successful!</h1>
				          <h2 >Welcome to Your Martial Arts Journey</h2>

				          <!-- Message -->
				          <div class="row justify-content-center">
				            <div class="col-md-8 mb-4">
				              <p>
				                <i class="fas fa-check-circle text-success me-2"></i>
				                <c:out value="${message}" />
				                <br>
				                You have successfully joined <strong>${center.name}</strong> for 
				                <strong>${selectedMartialArt.name}</strong> training.
				              </p>
				            </div>
				          </div>

				          <!-- Buttons -->
				          <p class="mt-3">
				            <a href="${pageContext.request.contextPath}/users/dashboard" 
				               class="btn btn-watch-video btn-lg">
				               <i class="fas fa-home me-2"></i> Go to Dashboard
				            </a>  |
				            <a href="${pageContext.request.contextPath}/centres/allcentres" 
				               class="btn btn-watch-video btn-lg">
				               <i class="fas fa-arrow-left me-2"></i> Back to Centres
				            </a>
				          </p>

				        </div>
				      </div>
				    </div>
				  </section>



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
				        <p><span>Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> <span>All Rights Reserved</span></p>
				        <div class="credits">
				          <!-- All the links in the footer should remain intact. -->
				          <!-- You can delete the links only if you've purchased the pro version. -->
				          <!-- Licensing information: https://bootstrapmade.com/license/ -->
				          <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
				         <!--  Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> -->
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

