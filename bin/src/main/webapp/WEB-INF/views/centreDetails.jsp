<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    
	<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>Martial Arts Centre Details</title>
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
						<link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
			
	<!-- Issue 134: Ensure hero banner text is readable over dark background image -->
	<style>
		.hero-wrap h1, .hero-wrap h2, .hero-wrap p {
			color: #ffffff !important;
			text-shadow: 0 2px 12px rgba(0,0,0,0.8), 0 1px 4px rgba(0,0,0,0.6) !important;
		}
		.hero-wrap .overlay {
			background: rgba(0, 0, 0, 0.55);
		}
		/* Issue 135: Ensure the enrollment header text is visible */
		.enrollment-header h1, .enrollment-header p {
			color: #ffffff !important;
		}
	</style>
</head>
<body>
	

	<!-- ======= Header ======= -->
	<header id="header" class="header d-flex align-items-center sticky-top">
	  <div class="container-fluid container-xl d-flex align-items-center">
	    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
	    <nav id="navmenu" class="navmenu">
	      <ul>

	        <li><a href="${pageContext.request.contextPath}/centres/allacceptedcentres">MartialArts Centres</a></li>

	        <li><a href="${pageContext.request.contextPath}/video/reels">Reels</a></li>
	        <li><a href="${pageContext.request.contextPath}/index/templates">Beauty</a></li>
	        <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
	        <c:if test="${not empty user}">
	        <li><a href="${pageContext.request.contextPath}/users/profile/${user.id}">Profile</a></li>
	        </c:if>
	      </ul>
	      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
	    </nav>
	    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
	    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
	  </div>
	</header>
	<!-- END nav -->
			  
			  <section class="hero-wrap js-fullheight" style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg');" data-stellar-background-ratio="0.5">
			  	  	  			    <div class="overlay"></div>
			  	  	  			    <div class="container">
			  	  	  			      <div class="row no-gutters slider-text align-items-center justify-content-center" style="min-height: 60vh;">
			  	  	  			        <div class="col-md-10 ftco-animate text-center">
			  	  	  			        	<div class="icon">
			  	  	  			          	<span class="flaticon-lotus"></span>
			  	  	  			        	</div>
											<h1>Discover Martial Arts Centers</h1>
											<h2>Find the Best Training Spots Near You</h2>
			  	  	  			          <div class="row justify-content-center">
			  	  	  			            <div class="col-md-7 mb-3">
												<p>Explore top-rated martial arts centers offering expert-led training in Karate, Taekwondo, Judo, and more.  
												              Join a community of passionate learners and start your discipline journey today.</p>
			  	  	  			            </div>
			  	  	  			          </div>
			  	  	  			          <p>
			  	  	  			          	<c:choose>
			  	  	  			          	  <c:when test="${not empty user}">
			  	  	  			          	    <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}" class="btn btn-watch-video btn-lg">Enroll Now</a>
			  	  	  			          	  </c:when>
			  	  	  			          	  <c:otherwise>
			  	  	  			          	    <a href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}" class="btn btn-watch-video btn-lg">Login to Enroll</a>
			  	  	  			          	  </c:otherwise>
			  	  	  			          	</c:choose>
			  	  	  			          	<a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-watch-video btn-lg">All Centres</a>
			  	  	  			          </p>
			  	  	  			        </div>
			  	  	  			      </div>
			  	  	  			    </div>
									</section>
									<section class="ftco-section bg-light">
									  <div class="container-fluid px-4 px-md-5 py-5">

									    <div class="card shadow-lg border-0 rounded-4">

									      <!-- Header -->
									      <div class="footer card-header bg-footer text-white text-center py-5">
									        <h2 class="mb-2 text-white">${center.name}</h2>
									        <p class="mb-0">Discipline • Strength • Confidence</p>
									      </div>

									      <!-- Body -->
									      <div class="card-body px-4 px-md-5 py-5">

									        <!-- About -->
									        <div class="mb-5">
									          <h4 class="mb-3">About the Centre</h4>
									         <p class="text-muted">
												<c:out value="${center.about}" default="${center.name} is a professionally managed martial arts training center dedicated to developing physical strength, mental discipline, and self-confidence in every student." />
									          </p>
									        </div>

									        <!-- How We Teach -->
									        <div class="mb-5">
									          <h4 class="mb-3">How We Teach</h4>
									          <div class="text-muted">
									            <c:choose>
									                <c:when test="${not empty center.howWeTeach}">
									                    ${center.howWeTeach}
									                </c:when>
									                <c:otherwise>
									                    <ul class="list-unstyled">
									                        <li>✔ Proper warm-up and stretching before every session</li>
									                        <li>✔ Step-by-step technique training from basic to advanced</li>
									                        <li>✔ Strength, flexibility, and endurance conditioning</li>
									                        <li>✔ Controlled sparring for real-world application</li>
									                        <li>✔ Focus on discipline, respect, and confidence building</li>
									                        <li>✔ Individual attention based on skill level</li>
									                    </ul>
									                </c:otherwise>
									            </c:choose>
									          </div>
									        </div>

									        <!-- Dynamic Details Grid -->
									        <div class="row mb-5">

									          <!-- Available Training Batches -->
									          <div class="col-12 mb-5">
									            <h4 class="mb-4 text-dark fw-bold"><i class="fas fa-calendar-alt text-primary me-3"></i>Available Training Batches</h4>
									            <div class="row g-4">
									              <c:forEach var="batch" items="${batches}">
	                                			        <div class="col-md-6 col-lg-4">
                                			          <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden training-batch-card" style="transition: transform 0.3s ease; border: 1px solid rgba(0,0,0,0.05) !important;">
                                			            <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
                                			                <div class="d-flex justify-content-between align-items-start">
                                			                    <div>
                                			                        <span class="badge bg-primary-subtle text-primary rounded-pill px-3 mb-2">${batch.batchType}</span>
                                			                        <h5 class="fw-bold text-dark mb-0">${batch.name}</h5>
                                			                    </div>
                                			                    <div class="text-end">
                                                                <c:choose>
                                                                    <c:when test="${batch.fee == null || batch.fee == 0}">
                                                                        <span class="fw-bold text-success fs-5">FREE</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="fw-bold text-primary fs-5">&#8377;${batch.fee}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                			                </div>
                                			            </div>
                                			            <div class="card-body p-4">
                                			                <div class="d-flex align-items-center mb-3">
                                			                    <div class="bg-light rounded-circle p-2 me-3" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                			                        <i class="fas fa-user-tie text-primary small"></i>
                                			                    </div>
                                			                    <div>
                                			                        <small class="text-muted d-block">Instructor</small>
                                			                        <span class="fw-semibold small">${batch.instructor}</span>
                                			                    </div>
                                			                </div>
                                			                <div class="d-flex align-items-center mb-3">
                                			                    <div class="bg-light rounded-circle p-2 me-3" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                			                        <i class="fas fa-hand-fist text-primary small"></i>
                                			                    </div>
                                			                    <div>
                                			                        <small class="text-muted d-block">Style</small>
                                			                        <span class="fw-semibold small">${batch.style}</span>
                                			                    </div>
                                			                </div>
                                			                <div class="d-flex align-items-center mb-3">
                                			                    <div class="bg-light rounded-circle p-2 me-3" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                			                        <i class="fas fa-clock text-primary small"></i>
                                			                    </div>
                                			                    <div>
                                			                        <small class="text-muted d-block">Time Slot</small>
                                			                        <span class="fw-semibold small">${batch.timeSlot}</span>
                                			                    </div>
                                			                </div>
                                                        <%-- Seat count display --%>
                                                        <c:if test="${batch.capacity != null && batch.capacity > 0}">
                                                            <c:set var="enrolled" value="${enrolledCountByBatch[batch.id]}"/>
                                                            <c:set var="isFull" value="${enrolled >= batch.capacity}"/>
                                                            <div class="mt-2">
                                                                <small class="text-muted">Seats: </small>
                                                                <c:choose>
                                                                    <c:when test="${isFull}">
                                                                        <span class="badge bg-danger rounded-pill">FULL</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-success rounded-pill">${enrolled} / ${batch.capacity} filled</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:if>
                                			            </div>
                                			            <div class="card-footer bg-light border-0 p-3 text-center">
                                			                <c:set var="batchEnrolled" value="${enrolledCountByBatch[batch.id]}"/>
                                			                <c:set var="batchFull" value="${batch.capacity != null && batch.capacity > 0 && batchEnrolled >= batch.capacity}"/>
                                			                <c:choose>
                                			                    <c:when test="${batchFull}">
                                			                        <button class="btn btn-sm btn-secondary rounded-pill px-4" disabled>Batch Full</button>
                                			                    </c:when>
                                			                    <c:when test="${not empty user}">
                                			                        <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batch.id}" class="btn btn-sm btn-primary rounded-pill px-4">
                                			                          Book This Batch
                                			                        </a>
                                			                    </c:when>
                                			                    <c:otherwise>
                                			                        <a href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}%3FbatchId%3D${batch.id}" class="btn btn-sm btn-primary rounded-pill px-4">
                                			                          Login to Book
                                			                        </a>
                                			                    </c:otherwise>
                                			                </c:choose>
                                			            </div>
                                			          </div>
                                			        </div>
									              </c:forEach>
									              <c:if test="${empty batches}">
									                <div class="col-12">
									                    <div class="alert alert-info rounded-4 border-0 shadow-sm p-4 text-center">
									                        <i class="fas fa-info-circle fa-2x mb-3 d-block"></i>
									                        <p class="mb-0">No specific batches listed currently. Please contact the centre for schedule.</p>
									                    </div>
									                </div>
									              </c:if>
									            </div>
									          </div>

									          <!-- Location -->
									          <div class="col-md-3 mb-4">
									            <h5 class="mb-3">Location</h5>
									            <p class="text-muted">
									              ✔ ${center.location}
									            </p>
									          </div>
<!-- Available Days -->
									          <div class="col-md-4 mb-4">
									            <h5 class="mb-3">Available Days</h5>
									            <p class="text-muted">
									              <c:forEach var="day" items="${sortedAvailableDays}" varStatus="status">
									                ✔ ${day}
									                <c:if test="${!status.last}"><br></c:if>
									              </c:forEach>
									            </p>
									          </div>

									        </div>

									        <!-- What We Offer -->
									        <div class="mb-5">
									          <h4 class="mb-3">What We Offer</h4>
									          <div class="text-muted">
									            <c:choose>
									                <c:when test="${not empty center.whatWeOffer}">
									                    ${center.whatWeOffer}
									                </c:when>
									                <c:otherwise>
									                    <ul class="list-unstyled">
									                        <li>✔ Certified and experienced martial arts instructors</li>
									                        <li>✔ Separate batches for kids, adults, and advanced students</li>
									                        <li>✔ Fitness-oriented martial arts training</li>
									                        <li>✔ Self-defense techniques for real-life situations</li>
									                        <li>✔ Flexible training schedules</li>
									                        <li>✔ Positive, disciplined, and respectful environment</li>
									                    </ul>
									                </c:otherwise>
									            </c:choose>
									          </div>
									        </div>

									        <!-- Gallery -->
									        <div class="mb-5">
									          <h4 class="mb-4">Training Gallery</h4>
									          <div class="row g-3">
									            <c:choose>
									                <c:when test="${not empty center.galleryPhotos}">
									                    <c:forEach var="photo" items="${center.galleryPhotos}">
									                        <div class="col-md-3 col-6">
									                          <img src="${pageContext.request.contextPath}${photo}" class="img-fluid rounded shadow-sm" style="height: 200px; width: 100%; object-fit: cover;">
									                        </div>
									                    </c:forEach>
									                </c:when>
									                <c:otherwise>
									                    <div class="col-md-3 col-6">
									                      <img src="${pageContext.request.contextPath}/assets/img/kalari1.jpeg" class="img-fluid rounded shadow-sm">
									                    </div>
									                    <div class="col-md-3 col-6">
									                      <img src="${pageContext.request.contextPath}/assets/img/kalari2.jpeg" class="img-fluid rounded shadow-sm">
									                    </div>
									                    <div class="col-md-3 col-6">
									                      <img src="${pageContext.request.contextPath}/assets/img/kalarei3.jpeg" class="img-fluid rounded shadow-sm">
									                    </div>
									                    <div class="col-md-3 col-6">
									                      <img src="${pageContext.request.contextPath}/assets/img/kalari4.jpeg" class="img-fluid rounded shadow-sm">
									                    </div>
									                </c:otherwise>
									            </c:choose>
									          </div>
									        </div>

									        <!-- Buttons -->
									        <div class="text-center mt-5">
									          <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}"
									             class="btn btn-watch-video btn-lg">
									            Enroll Now
									          </a>  |
									          <a href="${pageContext.request.contextPath}/centres/allcentres"
									             class="btn btn-watch-video btn-lg">
									            Back to Centres
									          </a>
									        </div>

									      </div>

									      <!-- Footer -->
									      <div class="card-footer bg-white text-center text-muted py-3">
									        🕒 Flexible batches • Open for all age groups
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
									      <p>©<span>Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> <span>All Rights Reserved</span></p>
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

