<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>${stylist.firstName} ${stylist.lastName} - Profile</title>
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
			/* Purple navbar */
#ftco-navbar {
  background-color: #6a0dad !important; /* purple */
}

/* Brand text */
#ftco-navbar .navbar-brand,
#ftco-navbar .navbar-brand span {
  color: #ffffff !important;
}

/* Nav links */
#ftco-navbar .nav-link {
  color: #ffffff !important;
}

/* Hover & active */
#ftco-navbar .nav-link:hover,
#ftco-navbar .nav-item.active .nav-link {
  color: #ffd6ff !important; /* light purple/white */
}

/* Toggler icon (mobile) */
#ftco-navbar .navbar-toggler {
  border-color: #ffffff;
}

#ftco-navbar .navbar-toggler-icon,
#ftco-navbar .oi-menu {
  color: #ffffff;
}
			
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
			
			/* 🔧 Fix button visibility issues */
			.btn-primary {
				background-color: #6a0dad !important;
				border-color: #6a0dad !important;
				color: #ffffff !important;
				font-weight: 600;
				padding: 12px 30px;
				border-radius: 8px;
				transition: all 0.3s ease;
				box-shadow: 0 4px 6px rgba(106, 13, 173, 0.3);
			}
			
			.btn-primary:hover {
				background-color: #5a0c94 !important;
				border-color: #5a0c94 !important;
				transform: translateY(-2px);
				box-shadow: 0 6px 12px rgba(106, 13, 173, 0.4);
			}
			
			.btn-outline-primary {
				border: 2px solid #6a0dad !important;
				color: #6a0dad !important;
				background-color: transparent !important;
				font-weight: 600;
				padding: 10px 28px;
				border-radius: 8px;
				transition: all 0.3s ease;
			}
			
			.btn-outline-primary:hover {
				background-color: #6a0dad !important;
				color: #ffffff !important;
			}
			
			/* Service card button specific styles */
			.block-7 .btn-primary {
				display: inline-block !important;
				width: auto !important;
				min-width: 150px;
				z-index: 10;
				position: relative;
			}
			
			/* Availability badge */
			.availability-badge {
				display: inline-block;
				padding: 6px 14px;
				border-radius: 20px;
				font-size: 0.85rem;
				font-weight: 600;
				margin-top: 10px;
			}
			
			.availability-badge.available {
				background-color: #d4edda;
				color: #155724;
				border: 1px solid #c3e6cb;
			}
			
			.availability-badge.unavailable {
				background-color: #f8d7da;
				color: #721c24;
				border: 1px solid #f5c6cb;
			}
	/* 🌸 Stylist Split Section */
	.stylist-split-section {
	  background: #fff;
	}

	.stylist-bg-left {
	  background-size: cover;
	  background-position: center top;
	  height: 600px;
	  border-radius: 0 20px 20px 0;
	}

	.stylist-details-side {
	  background: #fff;
	  color: #000;
	  min-height: 500px;
	}

	.stylist-details {
	  width: 85%;
	  margin: 0 auto;
	}

	.stylist-details h2 {
	  font-size: 2rem;
	  font-weight: 700;
	  color: #111;
	}

	.stylist-details p {
	  font-size: 17px;
	  color: #222;
	  margin-bottom: 10px;
	  line-height: 1.6;
	}

	@media (max-width: 768px) {
	  .stylist-bg-left {
	    height: 300px;
	    border-radius: 0;
	  }
	  .stylist-details-side {
	    padding: 2rem;
	  }
	}
</style>
</head>
<body>
	<header id="header" class="header d-flex align-items-center sticky-top">
		  <div class="container-fluid container-xl d-flex align-items-center">
		    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
		    <nav id="navmenu" class="navmenu">
		      <ul>
				<li class="nav-item"><a href="${pageContext.request.contextPath}/users/dashboard" class="nav-link">Home</a></li>
				           <li class="nav-item"><a href="${pageContext.request.contextPath}/user/salons" class="nav-link">Explore Salons</a></li>
				          <li class="nav-item active"><a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments" class="nav-link">SkinCare Treatments</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/user/stylists" class="nav-link">Stylists</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/chat/users" class="nav-link">Chat</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/user/bookings" class="nav-link">My Bookings</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">Profile</a></li>
		      </ul>
		      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
		    </nav>
		    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
		    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
		  </div>
		</header>
		    <!-- END nav -->
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
				
			   <!-- 💅 Stylist Intro Section (Split Background Style) -->
			   <section class="ftco-section stylist-split-section">
			     <div class="container-fluid">
			       <div class="row no-gutters align-items-center">
			         
			         <!-- 🖼️ Left Side Background Image -->
			         <div class="col-md-6 stylist-bg-left" 
			              style="background-image: url('${pageContext.request.contextPath}${not empty stylist.profileImage ? stylist.profileImage : '/beauty/images/default-stylist.jpg'}');">
			         </div>

			         <!-- 💁‍♀️ Right Side Details -->
			         <div class="col-md-6 stylist-details-side d-flex align-items-center">
			           <div class="stylist-details p-5">
			             <div class="heading-section ftco-animate mb-4">
			               <h2 class="mb-4">Meet ${stylist.firstName} ${stylist.lastName}</h2>
			             </div>

			             <p class="ftco-animate mb-3">
			               <strong>💇 Specialization:</strong> ${stylist.specialization}
			             </p>

			             <p class="ftco-animate mb-3">
			               <strong>🕒 Experience:</strong> ${stylist.experienceInYears} years
			             </p>

			             <p class="ftco-animate mb-3">
			               <strong>🏩 Salon:</strong>
			               <c:choose>
			                 <c:when test="${stylist.salon != null}">
			                   ${stylist.salon.name}
			                 </c:when>
			                 <c:otherwise>Independent Stylist</c:otherwise>
			               </c:choose>
			             </p>

			             <p class="ftco-animate mb-3">
			               <strong>⭐ Rating:</strong> 
			               <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> / 5
			             </p>
			             		             
			             <!-- Availability Status -->
			             <p class="ftco-animate mb-3">
			               <strong>📅 Availability:</strong>
			               <c:choose>
			                 <c:when test="${stylist.available}">
			                   <span class="availability-badge available">✓ Available for Booking</span>
			                 </c:when>
			                 <c:otherwise>
			                   <span class="availability-badge unavailable">✗ Currently Unavailable</span>
			                 </c:otherwise>
			               </c:choose>
			             </p>

			             <p class="ftco-animate mb-3">
			               <strong>📞 Contact:</strong>
			               <c:choose>
			                 <c:when test="${canViewContact}">
			                   ${stylist.contactNumber}
			                 </c:when>
			                 <c:otherwise>
			                   <span class="text-muted">Visible after completing a booking</span>
			                 </c:otherwise>
			               </c:choose>
			             </p>

			             <p class="ftco-animate mb-3">
			               <strong>📧 Email:</strong>
			               <c:choose>
			                 <c:when test="${canViewContact}">
			                   ${stylist.email}
			                 </c:when>
			                 <c:otherwise>
			                   <span class="text-muted">Visible after completing a booking</span>
			                 </c:otherwise>
			               </c:choose>
			             </p>

			             <c:if test="${not empty stylist.bio}">
			               <p class="ftco-animate"><strong>📝 About:</strong> ${stylist.bio}</p>
			             </c:if>
			           </div>
			         </div>

			       </div>
			     </div>
			   </section>

			   <!-- 💅 Salon Services Section (Pricing Style) -->
			   <section class="ftco-section bg-light">
			     <div class="container">
			       
			       <!-- Section Header -->
			       <div class="row justify-content-center mb-5 pb-3">
			         <div class="col-md-8 heading-section ftco-animate text-center">
			           <h3 class="subheading text-primary">Services Offered</h3>
			           <h2 class="mb-1">Services & Packages</h2>
			           <p class="text-muted">Experience beauty & care with our curated salon services — from soothing facials to stylish makeovers.</p>
			         </div>
			       </div>

			       <!-- Services Cards -->
			       <div class="row">
			         <c:forEach var="service" items="${services}">
			           <div class="col-md-4 ftco-animate mb-4">
			             <div class="block-7 shadow-sm h-100 d-flex flex-column justify-content-between">
			               <div class="text-center p-4">
			                 
			                 <!-- Service Header -->
			                 <h2 class="heading text-primary">${service.name}</h2>
			                 <span class="price d-inline-block mt-3">
			                   <sup>₹</sup><span class="number">${service.price}</span>
			                 </span>
			                 <span class="excerpt d-block mt-1">${service.durationMinutes} mins session</span>

			                 <h3 class="heading-2 my-4">Service Highlights</h3>

			                 <!-- Service Details -->
			                 <ul class="pricing-text mb-5 text-start mx-auto" style="max-width: 250px;">
			                   <li><strong>Ingredients:</strong> ${service.ingredients}</li>
			                   <li><strong>Allergens:</strong> ${service.allergenInfo}</li>
			                 </ul>

			                 <!-- ✅ Show Book Now button (disabled if unavailable) -->
			                 <c:choose>
			                   <c:when test="${stylist.available}">
			                     <a href="${pageContext.request.contextPath}/user/book?stylistId=${stylist.id}&serviceId=${service.id}" 
			                        class="btn btn-primary d-block px-2 py-4 rounded-pill">
			                        Book Now
			                     </a>
			                   </c:when>
			                   <c:otherwise>
			                     <button class="btn btn-secondary d-block px-2 py-4 rounded-pill" disabled
			                             style="background-color: #6c757d !important; border-color: #6c757d !important; cursor: not-allowed; opacity: 0.6;">
			                       Stylist Unavailable
			                     </button>
			                   </c:otherwise>
			                 </c:choose>

			               </div>
			             </div>
			           </div>
			         </c:forEach>
			       </div>

			       <!-- No Services Available -->
			       <c:if test="${empty services}">
			         <div class="text-center mt-4">
			           <p class="text-muted">No services available right now. Please check back later!</p>
			         </div>
			       </c:if>

			     </div>
			   </section>


	<!-- 💅 Available Booking Slots Section -->
	<%-- <section class="ftco-section">
	  <div class="container">
	    <!-- Section Header -->
	    <div class="row justify-content-center mb-5 pb-3">
	      <div class="col-md-7 heading-section ftco-animate text-center">
	        <h3 class="subheading">Book Your Time</h3>
	        <h2 class="mb-1">Available Booking Slots</h2>
	      </div>
	    </div>

	    <div class="row">
	      <c:if test="${not empty confirmedBookings}">
	        <c:forEach var="b" items="${confirmedBookings}" varStatus="loop">
	          <div class="col-md-4 ftco-animate mb-4">
	            <div class="block-7 shadow-sm rounded">
	              <div class="text-center p-4">
	                <h2 class="heading mb-3">Slot ${loop.index + 1}</h2>
	                <span class="price">
	                  <span class="number fs-3 text-primary">
	                    🕒 ${b.bookingTime}
	                  </span>
	                </span>
	                <span class="excerpt d-block mt-2 text-muted">Available for Booking</span>

	                <h3 class="heading-2 my-4">Confirm Your Appointment</h3>

	                <ul class="pricing-text mb-4">
	                  <li>Professional Stylist</li>
	                  <li>Sanitized Tools & Space</li>
	                  <li>On-Time Service Guarantee</li>
	                </ul>

	                <a href="${pageContext.request.contextPath}/user/book?slotId=${b.id}"
	                   class="btn btn-primary d-block px-2 py-3">
	                   Book This Slot
	                </a>
	              </div>
	            </div>
	          </div>
	        </c:forEach>
	      </c:if>

	      <c:if test="${empty confirmedBookings}">
	        <div class="col-md-12 text-center">
	          <p class="text-muted mt-3 fs-5">
	            😔 Stylist has not assigned booking timings yet.
	          </p>
	        </div>
	      </c:if>
	    </div>
	  </div>
	</section> --%>


	<section class="ftco-section ftco-section-services bg-light">
		<div class="container-fluid px-md-5">
			<div class="row">
				<div class="col-md-6 col-lg-3">
						<div class="services text-center ftco-animate">
							<div class="icon d-flex justify-content-center align-items-center">
								<span class="flaticon-candle"></span>
							</div>
							<div class="text mt-3">
								<h3>Haircut</h3>
								<p>Professional haircut and styling to suit your face and fashion, ensuring a confident and refreshing look.</p>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-lg-3">
						<div class="services text-center ftco-animate">
							<div class="icon d-flex justify-content-center align-items-center">
								<span class="flaticon-beauty-treatment"></span>
							</div>
							<div class="text mt-3">
								<h3>Manicure</h3>
								<p>Get perfectly groomed nails with a relaxing hand massage and polish finish that shines with confidence.</p>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-lg-3">
						<div class="services text-center ftco-animate">
							<div class="icon d-flex justify-content-center align-items-center">
								<span class="flaticon-stone"></span>
							</div>
							<div class="text mt-3">
								<h3>Pedicure</h3>
								<p>Revitalize tired feet with our rejuvenating pedicure service that smoothens, cleanses, and relaxes.</p>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-lg-3">
						<div class="services text-center ftco-animate">
							<div class="icon d-flex justify-content-center align-items-center">
								<span class="flaticon-relax"></span>
							</div>
							<div class="text mt-3">
								<h3>Spa</h3>
							    <p>Unwind your senses with our full-body spa sessions designed to rejuvenate mind, body, and soul.</p>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-lg-3">
									<div class="services text-center ftco-animate">
										<div class="icon d-flex justify-content-center align-items-center">
											<span class="flaticon-massage"></span>
										</div>
										<div class="text mt-3">
											<h3>Massage</h3>
											<p>Relax and relieve stress with soothing massage therapies performed by skilled professionals.</p>
										</div>
									</div>
								</div>
								<div class="col-md-6 col-lg-3">
									<div class="services text-center ftco-animate">
										<div class="icon d-flex justify-content-center align-items-center">
											<span class="flaticon-lotus"></span>
										</div>
										<div class="text mt-3">
											<h3>Facial</h3>
											<p>Refresh your skin with premium facial treatments that bring out your natural glow and smooth texture.</p>
										</div>
									</div>
								</div>
								<div class="col-md-6 col-lg-3">
									<div class="services text-center ftco-animate">
										<div class="icon d-flex justify-content-center align-items-center">
											<span class="flaticon-beauty-treatment"></span>
										</div>
										<div class="text mt-3">
											<h3>Eyebrow Shaping</h3>
											<p>Perfectly define your brows for a sharp, elegant, and confident look that frames your face beautifully.</p>
										</div>
									</div>
								</div>
								<div class="col-md-6 col-lg-3">
									<div class="services text-center ftco-animate">
										<div class="icon d-flex justify-content-center align-items-center">
											<span class="flaticon-spa-1"></span>
										</div>
										<div class="text mt-3">
											<h3>Hair Spa</h3>
											<p>Rejuvenate dull and damaged hair with deep-conditioning treatments for silky, healthy, and strong strands.</p>
										</div>
									</div>
								</div>

				</div>
		</div>
	</section>
	<section class="ftco-section">
	  	<div class="container-fluid px-md-5">
	  		<div class="row justify-content-center mb-5 pb-3">
	        <div class="col-md-12 heading-section ftco-animate text-center">
	          <h3 class="subheading">Services</h3>
	          <h2 class="mb-1">Treatments</h2>
	        </div>
	      </div>
	      <div class="row align-items-center">
	      	<div class="col-lg-4">
	      		<div class="row no-gutters">
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-right-0 border-bottom-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-candle"></span>
									</div>
									<div class="text mt-2">
										<h3>Facial Glow</h3>
										<p>Instant radiance and hydration for soft, youthful skin.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-bottom-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-massage"></span>
									</div>
									<div class="text mt-2">
										<h3>Hair Spa</h3>
									 <p>Repair, nourish, and smoothen your hair for a silky shine.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-right-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-beauty-treatment"></span>
									</div>
									<div class="text mt-2">
										<h3>Makeover</h3>
										<p>Transform your look with professional makeup artistry.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-stone"></span>
									</div>
									<div class="text mt-2">
										<h3>Manicure</h3>
										<p>Clean, polish, and refresh your hands to perfection.</p>
									</div>
								</div>
	      			</div>
	      		</div>
	      	</div>


	      	<div class="col-lg-4 d-flex align-items-stretch">
	      		<div id="accordion" class="myaccordion w-100 text-center py-5 px-1 px-md-4">
	      			<div>
	        			<h3>Prices</h3>
	        			<p>Transparent pricing for every pampering experience.</p>
	      			</div>
					<!-- Facial & Hair -->
					        <div class="card">
					          <div class="card-header" id="headingOne">
					            <h2 class="mb-0">
					              <button class="d-flex align-items-center justify-content-between btn btn-link" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
					                Facial & Hair Care
					                <i class="fa" aria-hidden="true"></i>
					              </button>
					            </h2>
					          </div>
					          <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordion">
					            <div class="card-body text-left">
					              <ul>
					                <li class="d-flex justify-content-between">
					                  <span>Classic Facial</span><span>45 min</span><span>₹699</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Hair Spa</span><span>60 min</span><span>₹899</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Detan Treatment</span><span>40 min</span><span>₹599</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Head Massage</span><span>30 min</span><span>₹499</span>
					                </li>
					              </ul>
					            </div>
					          </div>
					        </div>

					        <!-- Body & Massage -->
					        <div class="card">
					          <div class="card-header" id="headingTwo">
					            <h2 class="mb-0">
					              <button class="d-flex align-items-center justify-content-between btn btn-link collapsed" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
					                Body & Massage Therapies
					                <i class="fa" aria-hidden="true"></i>
					              </button>
					            </h2>
					          </div>
					          <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordion">
					            <div class="card-body text-left">
					              <ul>
					                <li class="d-flex justify-content-between">
					                  <span>Full Body Massage</span><span>60 min</span><span>₹1499</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Back & Neck Massage</span><span>30 min</span><span>₹799</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Aromatherapy</span><span>45 min</span><span>₹999</span>
					                </li>
					                <li class="d-flex justify-content-between">
					                  <span>Body Scrub</span><span>50 min</span><span>₹1299</span>
					                </li>
					              </ul>
					            </div>
					          </div>
					        </div>

					      </div>
					    </div>

	      	<div class="col-lg-4">
	      		<div class="row no-gutters">
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-right-0 border-bottom-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-massage"></span>
									</div>
									<div class="text mt-2">
										<h3>Massage</h3>
										<p>Relax, unwind, and ease muscle tension naturally.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-bottom-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-beauty-treatment"></span>
									</div>
									<div class="text mt-2">
										<h3>Eyebrow Shaping</h3>
									    <p>Perfect arches for a confident and elegant look.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border border-right-0 p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-candle"></span>
									</div>
									<div class="text mt-2">
										<h3>Pedicure</h3>
										<p>Soft, refreshed feet with a soothing polish finish.</p>
									</div>
								</div>
	      			</div>
	      			<div class="col-md-6 d-flex align-items-stretch">
	      				<div class="treatment w-100 text-center ftco-animate border p-3 py-4">
									<div class="icon d-flex justify-content-center align-items-center">
										<span class="flaticon-spa-1"></span>
									</div>
									<div class="text mt-2">
										<h3>Aroma Spa</h3>
									    <p>Calming essential oils for body and mind balance.</p>
									</div>
								</div>
	      			</div>
	      		</div>
	      	</div>
	      </div>
	  	</div>
	  </section>
	  <section class="ftco-counter img" id="section-counter" style="background-image: url(/beauty/images/bg_3.jpg);" data-stellar-background-ratio="0.5">
	  		<div class="overlay"></div>
	       <div class="container">
	         <div class="row justify-content-center">
	         	<div class="col-md-10">
	         		<div class="row">
	  	          <div class="col-md-6 col-lg-3 d-flex justify-content-center counter-wrap ftco-animate">
	  	            <div class="block-18 text-center">
	  	              <div class="text">
	  	              	<strong class="number" data-number="2560">0</strong>
	  	              	<span>Happy Customers</span>
	  	              </div>
	  	            </div>
	  	          </div>
	  	          <div class="col-md-6 col-lg-3 d-flex justify-content-center counter-wrap ftco-animate">
	  	            <div class="block-18 text-center">
	  	              <div class="text">
	  	              	<strong class="number" data-number="60">0</strong>
	  	              	<span>Treatments</span>
	  	              </div>
	  	            </div>
	  	          </div>
	  	          <div class="col-md-6 col-lg-3 d-flex justify-content-center counter-wrap ftco-animate">
	  	            <div class="block-18 text-center">
	  	              <div class="text">
	  	              	<strong class="number" data-number="50">0</strong>
	  	              	<span>Years of Experience</span>
	  	              </div>
	  	            </div>
	  	          </div>
	  	          <div class="col-md-6 col-lg-3 d-flex justify-content-center counter-wrap ftco-animate">
	  	            <div class="block-18 text-center">
	  	              <div class="text">
	  	              	<strong class="number" data-number="100">0</strong>
	  	              	<span>Lesson Conducted</span>
	  	              </div>
	  	            </div>
	  	          </div>
	  	        </div>
	  	      </div>
	         </div>
	       </div>
	     </section>

	<!-- 🌟 Dynamic Reviews Section (Equal Height Cards - Balanced Carousel Style) -->
	<section class="ftco-section testimony-section">
	  <div class="container">
	    <!-- Section Header -->
	    <div class="row justify-content-center mb-5 pb-3">
	      <div class="col-md-10 heading-section ftco-animate text-center">
	        <h3 class="subheading">Customer Reviews</h3>
	        <h2 class="mb-1">What People Are Saying</h2>
	        <h5 class="mt-2 text-warning">⭐ Average Rating: ${avgRating}/5</h5>
	      </div>
	    </div>

	    <!-- Carousel -->
	    <div class="row ftco-animate">
	      <div class="col-md-12">
	        <div class="carousel-testimony owl-carousel">

	          <!-- Dynamic Reviews -->
	          <c:choose>
	            <c:when test="${not empty reviews}">
	              <c:forEach var="r" items="${reviews}">
	                <div class="item">
	                  <div class="testimony-wrap p-4 pb-5 h-100 d-flex flex-column justify-content-between shadow-sm rounded bg-white"
	                       style="height: 340px; display: flex; flex-direction: column; justify-content: space-between;">
	                    
	                    <!-- Comment -->
	                    <div class="text flex-grow-1 d-flex flex-column justify-content-between">
	                      <div class="line pl-4" style="min-height: 120px;">
	                        <p class="mb-4 text-secondary" style="overflow: hidden; text-overflow: ellipsis;">
	                          <i class="icon-quote-left text-primary mr-2"></i> ${r.comment}
	                        </p>
	                      </div>
	                    </div>

	                    <!-- Reviewer Info -->
	                    <div class="d-flex align-items-center pt-3 border-top mt-auto">
	                      <div class="user-img flex-shrink-0"
	                           style="background-image: url('<c:out value="${pageContext.request.contextPath}${r.user.profilePhoto != null ? r.user.profilePhoto : '/beauty/images/default_user.jpg'}"/>');
	                                  width: 60px; height: 60px; background-size: cover; background-position: center; border-radius: 50%;">
	                      </div>
	                      <div class="ml-3">
	                        <p class="name mb-0 text-dark fw-bold">${r.user.fullName}</p>
	                        <span class="position text-warning">⭐ ${r.rating}/5</span><br>
	                        <small class="text-muted">${r.createdAt}</small>
	                      </div>
	                    </div>
	                  </div>
	                </div>
	              </c:forEach>
	            </c:when>

	            <c:otherwise>
	              <div class="item">
	                <div class="testimony-wrap p-4 pb-5 text-center bg-white shadow-sm rounded"
	                     style="height: 340px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
	                  <p class="mb-3">No reviews yet. Be the first to share your experience!</p>
	                  <span class="quote d-flex align-items-center justify-content-center mt-3">
	                    <i class="icon-quote-left"></i>
	                  </span>
	                </div>
	              </div>
	            </c:otherwise>
	          </c:choose>

	        </div>
	      </div>
	    </div>

	    <!-- Add Review Form -->
	 <!-- Add Review Form (Always Visible) -->
<div class="row justify-content-center mt-5">
  <div class="col-md-8">
    <div class="card p-4 shadow-sm border-0">
      <h5 class="text-primary mb-3 text-center">Add Your Review</h5>

      <form action="${pageContext.request.contextPath}/user/stylist/review" method="post">
        <input type="hidden" name="stylistId" value="${stylist.id}" />

        <div class="form-group">
          <label>Rating:</label>
          <select name="rating" class="form-control" required>
            <option value="">Select Rating</option>
            <option value="5">⭐⭐⭐⭐⭐ (5)</option>
            <option value="4">⭐⭐⭐⭐ (4)</option>
            <option value="3">⭐⭐⭐ (3)</option>
            <option value="2">⭐⭐ (2)</option>
            <option value="1">⭐ (1)</option>
          </select>
        </div>

        <div class="form-group">
          <label>Comment:</label>
          <textarea name="comment"
                    class="form-control"
                    rows="3"
                    placeholder="Write your review..."
                    required></textarea>
        </div>

        <div class="text-center">
          <button type="submit" class="btn btn-primary px-4">
            Submit Review
          </button>
        </div>
      </form>
    </div>
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



<!-- loader -->
<div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>


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



