<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
   <meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>Fight d Fire</title>
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
				
			<!-- 🎨 Custom CSS -->
			<style>
			.hero-section::before {
			    content: "";
			    position: absolute;
			    top: 0; left: 0;
			    width: 100%;
			    height: 100%;
			    background: rgba(255, 215, 0, 0.35); /* 💛 Light golden transparent overlay */
			    z-index: 1;
			}

			.hero-section .container {
			    position: relative;
			    z-index: 2;
			    padding-top: 100px;
			}

			.hero-section h1 {
			    font-size: 2.8rem;
			    font-weight: 700;
			    margin-bottom: 20px;
			    font-family: 'Playfair Display', serif;
			    color: #fff;
			}

			.hero-section p {
			    font-size: 1.2rem;
			    color: #f8f9fa;
			    margin-bottom: 35px;
			    max-width: 650px;
			    margin-left: auto;
			    margin-right: auto;
			}

			.hero-section a.btn-primary {
			    background-color: #e6b800;  /* ✨ Soft gold */
			    border-color: #e6b800;
			    transition: 0.3s;
			}

			.hero-section a.btn-primary:hover {
			    background-color: #f1c232;  /* Slightly brighter on hover */
			    border-color: #f1c232;
			}

			.hero-section a.btn-outline-light:hover {
			    background-color: #fff;
			    color: #e6b800 !important;
			}
			/* ✨ Increase only nav item font size */
			#ftco-navbar .nav-link {
			  font-size: 1.2rem !important;  /* Slightly larger font */
			  font-weight: 300;              /* Make text a bit bolder */
			  letter-spacing: 0.5px;         /* Add spacing for cleaner look */
			  padding: 10px 18px !important; /* Slightly larger clickable area */
			  transition: all 0.3s ease;
			}

		
			</style>
</head>

<body>

<!-- 🌷 Navbar -->
<header id="header" class="header d-flex align-items-center sticky-top">
		  <div class="container-fluid container-xl d-flex align-items-center">
		    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
		    <nav id="navmenu" class="navmenu">
		      <ul>
				<li class="nav-item"><a href="${pageContext.request.contextPath}/users/dashboard" class="nav-link">Home</a></li>
				           <li class="nav-item"><a href="${pageContext.request.contextPath}/user/salons" class="nav-link">Explore Salons</a></li>
				          <li class="nav-item active"><a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments" class="nav-link">SkinCare Treatments</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/user/stylists" class="nav-link">Stylists</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/user/bookings" class="nav-link">My Bookings</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">Profile</a></li>
		      </ul>
		      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
		    </nav>
		    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
		    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
		  </div>
		</header>

<section class="hero-wrap js-fullheight" style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg')" data-stellar-background-ratio="0.5">
				     <div class="overlay"></div>
				     <div class="container">
				       <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center">
				         <div class="col-md-10 ftco-animate text-center">
				         	<div class="icon">
				          	<span class="flaticon-lotus"></span>
				         	</div>
				           <h1>${stylist.firstName}${stylist.lastName}</h1>
				           <div class="row justify-content-center">
				            <div class="col-md-7 mb-3">
				            	<p>Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
				            </div>
				          </div>
				           <p>
				           	<a href="${pageContext.request.contextPath}#" class="btn btn-primary p-3 px-5 py-4 mr-md-2">Get in Touch</a>
				           	<a href="${pageContext.request.contextPath}#" class="btn btn-outline-primary p-3 px-5 py-4 ml-md-2">Contact</a>
				           </p>
				         </div>
				       </div>
				     </div>
				   </section>
				   
				   <section class="ftco-section ftco-intro" style="background-image: url(${pageContext.request.contextPath}/beauty/images/intro.jpg);">
				   			
							  <div class="container">
							  				       <div class="row justify-content-end">
							  				         <div class="col-md-6">
							  				           <div class="heading-section ftco-animate mb-4">
							  				             <h2 class="mb-4 text-black">Booking Confirmed!</h2>
							  				           </div>

							  				           <div class="ftco-animate bg-light p-4 rounded shadow-sm">
							  				             <p><strong>Booking ID:</strong> ${booking.id}</p>
							  				             <p><strong>Stylist:</strong> ${booking.stylist.firstName} ${booking.stylist.lastName}</p>
							  				             <p><strong>Service:</strong> ${booking.service.name}</p>
							  				             <p><strong>Date & Time:</strong> ${booking.bookingTime}</p>
							  				             <p><strong>Price Paid:</strong> ₹${booking.pricePaid}</p>
							  				             <p><strong>Status:</strong> ${booking.status}</p>
							  				             <a href="${pageContext.request.contextPath}/user/bookings" 
							  				                class="btn btn-primary mt-3 px-4 py-2">
							  				               View My Bookings
							  				             </a>
							  				           </div>

							  				         </div>
				   			</div>
				   		</section>
				  
<!-- 🌸 Footer -->
			  	<footer id="footer" class="footer position-relative">

   

    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="index.html" class="d-flex align-items-center">
            Fight D Fear
          </a>
             
  <div class="pt-3">
    <p class="fw-semibold">Our Values</p>
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
      <p>© Copyright <strong class="px-1 sitename">Fight D Fear</strong> All Rights Reserved</p>
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

					  </body>
					  </html>



