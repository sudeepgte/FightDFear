<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
   <meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>Fight D Fear</title>
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
	
	/* --- Layout --- */
	/* --- Salon Header Section --- */
/* --- Salon Header Layout --- */
.salon-header-section {
    width: 100%;
    margin-top: 80px;
    margin-bottom: 40px;
}

.salon-header {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 25px rgba(0,0,0,0.1);
}

/* --- Left Image Side --- */
.salon-image-side {
    height: 420px;              /* ✅ fixed height */
    overflow: hidden;
}

.salon-img {
    width: 100%;                /* ✅ full width */
    height: 100%;               /* ✅ full height */
    object-fit: cover;          /* ✅ crop correctly */
    display: block;
}

/* --- Right Content Side --- */
.salon-details-side {
    background-color: #fafafa;
    display: flex;
    align-items: center;
}

.salon-details {
    padding: 40px;
}

/* --- Responsive (Mobile) --- */
@media (max-width: 768px) {
    .salon-image-side {
        height: 260px;          /* ✅ smaller image on mobile */
    }

    .salon-details {
        padding: 25px;
    }
}


	    .salon-details-side {
	        padding: 25px;
	    }
	    

	    .salon-name {
	        font-size: 1.6rem;
	    }
	}
	.rating-stars i {
    color: #ffc107;
    font-size: 1.2rem;
}
	
	</style>

  </head>
  <body>
	<header id="header" class="header d-flex align-items-center sticky-top">
	  <div class="container-fluid container-xl d-flex align-items-center">
	    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
	    <nav id="navmenu" class="navmenu">
	      <ul>
	        <li><a href="${pageContext.request.contextPath}/chat/users">Chat</a></li>
	        <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
	        <li><a href="${pageContext.request.contextPath}/users/wallet">Wallet 💰</a></li>
            <li><a href="${pageContext.request.contextPath}/users/dashboard" class="btn-dashboard"><i class="fas fa-th-large me-2"></i> Back to Dashboard</a></li>
            <li class="nav-profile">
                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}${not empty user.profilePhoto ? user.profilePhoto : '/images/default-profile.png'}" 
                         alt="Profile" class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover; border: 2px solid var(--brand-pink);">
                    <span class="ms-2 d-none d-lg-inline text-white">${user.fullName}</span>
                </a>
            </li>
	      </ul>
	      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
	    </nav>
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
			           <h1>${salon.name}</h1>
			           <div class="row justify-content-center">
			            <div class="col-md-7 mb-3">
			            	<p>Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
			            </div>
			          </div>
			           <p>
			           	<a href="${pageContext.request.contextPath}/contact" class="btn btn-primary p-3 px-5 py-4 mr-md-2">Get in Touch</a>
			           	<a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-primary p-3 px-5 py-4 ml-md-2">Contact</a>
			           </p>
			         </div>
			       </div>
			     </div>
			   </section>
				
			   <!-- 🔹 Salon Header Section -->
			  <section class="salon-header-section">
    <div class="container">
        <div class="row salon-header">

            <!-- LEFT IMAGE -->
            <div class="col-md-6 salon-image-side">
                <c:choose>
                    <c:when test="${not empty salon.profileImageUrl}">
                        <img src="${pageContext.request.contextPath}/${salon.profileImageUrl.startsWith('/') ? salon.profileImageUrl.substring(1) : salon.profileImageUrl}"
                             class="salon-img"
                             alt="Salon Image"
                             onerror="this.src='${pageContext.request.contextPath}/beauty/images/default-salon.jpg';">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/beauty/images/default-salon.jpg"
                             class="salon-img"
                             alt="Default Salon">
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- RIGHT DETAILS -->
            <div class="col-md-6 salon-details-side">
                <div class="salon-details">

                    <h2 class="salon-name">
                        <c:out value="${salon.name}"/>
                    </h2>

                    <p>
                        <strong>Address:</strong>
                        <c:out value="${salon.address}"/>,
                        <c:out value="${salon.city}"/>,
                        <c:out value="${salon.state}"/> -
                        <c:out value="${salon.pincode}"/>
                    </p>

                    <p>
                        <strong>Phone:</strong> <c:out value="${salon.phone}"/> |
                        <strong>Email:</strong> <c:out value="${salon.email}"/>
                    </p>

                    <p>
                        <strong>Website:</strong>
                        <a href="${salon.website}" target="_blank">
                            <c:out value="${salon.website}"/>
                        </a>
                    </p>

                    <p><strong>Availability:</strong> <c:out value="${salon.availabilityHours}"/></p>

                    <p>
                        <strong>⭐ Rating:</strong>
                        <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5
                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="bi ${i <= averageRating ? 'bi-star-fill' : 'bi-star'}"></i>
                            </c:forEach>
                        </span>
                    </p>

                    <c:if test="${not empty salon.bio}">
                        <p><strong>About:</strong> <c:out value="${salon.bio}"/></p>
                    </c:if>

                </div>
            </div>
</div>
			           <div class="my-3">
        <a href="${pageContext.request.contextPath}/salon/reviews?id=${salon.id}" class="btn btn-primary w-100 mb-2">
            <i class="bi bi-eye"></i> View All Reviews
        </a>
        <a href="${pageContext.request.contextPath}/salon/reviews?id=${salon.id}#addReview" class="btn btn-outline-dark w-100">
            <i class="bi bi-pen"></i> Rate Us
        </a>
   
        </div>
    </div>
</section>


			   <!-- 💅 Salon Services Section -->
			   <section class="ftco-section ftco-no-pt ftco-no-pb">
			     <div class="container-fluid px-5 position-relative">
					<!-- Section Header -->
					<div class="text-center mb-5">
					  <h3 class="text-primary mb-2">Available Salon Services</h3>
					  <p class="text-muted mx-auto" style="max-width: 600px;">
					    Discover our top salon services  expert care, relaxing treatments, and flawless beauty in every visit.
					  </p>

					</div>


			       <!-- Scrollable Card Container -->
			      <div id="servicesContainer"
     class="d-flex pb-4"
     style="scroll-behavior:smooth; overflow-x:auto; overflow-y:hidden; gap:40px; padding:10px 0;">
			      
			         <c:if test="${not empty serviceList}">
			           <c:forEach var="service" items="${serviceList}">
			         
			            <div class="card flex-shrink-0 shadow-sm border-0 rounded-3"
     style="width: 260px; cursor:pointer;"
     data-bs-toggle="modal"
     data-bs-target="#serviceModal"
     data-service-id="${service.id}"
     onclick="showServiceDetails('${service.name}', '${service.category}', '${service.price}', '${service.durationMinutes}', '${service.ingredients}', '${service.allergenInfo}', '${pageContext.request.contextPath}${service.photoUrl}', '${service.salon.name}', '${service.id}')">
			            
			               <c:choose>
			                 <c:when test="${not empty service.photoUrl}">
			                   <img src="${pageContext.request.contextPath}${service.photoUrl}" alt="${service.name}" class="card-img-top rounded-top" style="height:260px; object-fit:cover;">
			                 </c:when>
			                 <c:otherwise>
			                   <img src="https://via.placeholder.com/260x260" alt="Default Service" class="card-img-top rounded-top" style="height:260px; object-fit:cover;">
			                 </c:otherwise>
			               </c:choose>

			               <div class="card-body text-center">
			                 <h6 class="card-title text-primary mb-1"><c:out value="${service.name}"/></h6>
			                 <p class="mb-1"><strong>Category:</strong> <c:out value="${service.category}"/></p>
			                 <p class="mb-1"><strong>Price:</strong> ₹<fmt:formatNumber value="${service.price}" type="number"/></p>
			                 <p class="mb-0"><strong>Duration:</strong> <c:out value="${service.durationMinutes}"/> mins</p>
			                 <p class="mt-3">
  <a href="${pageContext.request.contextPath}/booking/new?serviceId=${service.id}" 
     class="btn btn-primary btn-sm">
     Book Now
  </a>
</p>
			               </div>
			             </div>
			           </c:forEach>
			         </c:if>

			         <c:if test="${empty serviceList}">
			           <p class="text-muted mt-3 ms-3">No services available right now.</p>
			         </c:if>
			       </div>
				   <!-- 🔹 Service Detail Modal (Larger Version) -->
				   <div class="modal fade" id="serviceModal" tabindex="-1" aria-labelledby="serviceModalLabel" aria-hidden="true">
				     <div class="modal-dialog modal-xl modal-dialog-centered"> <!-- changed to xl for bigger size -->
				       <div class="modal-content border-0 shadow-lg rounded-4">
				         <div class="modal-header bg-light">
				           <h4 class="modal-title text-primary fw-semibold" id="serviceModalLabel">Service Details</h4>
				           <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				         </div>

				         <div class="modal-body py-4 px-4">
				           <div class="row g-4 align-items-center">
				             <!-- Left: Image -->
				             <div class="col-md-6">
				               <img id="modalImage" src="" class="img-fluid rounded-3 shadow-sm"
				                    alt="Service Image"
				                    style="height: 400px; width: 100%; object-fit: cover;">
				             </div>

				             <!-- Right: Details -->
				             <div class="col-md-6">
				               <h3 id="modalName" class="text-primary mb-3 fw-bold"></h3>
				               <p class="mb-2"><strong>Category:</strong> <span id="modalCategory"></span></p>
				               <p class="mb-2"><strong>Price:</strong> &#8377;<span id="modalPrice"></span></p>
				               <p class="mb-2"><strong>Duration:</strong> <span id="modalDuration"></span> mins</p>
				               <p class="mb-3"><strong>Salon:</strong> <span id="modalSalon"></span></p>
				               <hr>
				               <p><strong>Ingredients:</strong> <span id="modalIngredients"></span></p>
				               <p><strong>Allergen Info:</strong> <span id="modalAllergens"></span></p>
				             </div>
				           </div>
				         </div>

				         <div class="modal-footer border-0 pt-0 pb-4 px-4">
				           <button class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Close</button>
				          <a id="bookNowLink" 
   data-base-url="${pageContext.request.contextPath}/booking/new"
   href="#" 
   class="btn btn-primary px-4">
   Book Now
</a>
				          
				         </div>
				       </div>
				     </div>
				   </div>

			       <!-- 🔹 Scroll Arrows -->
			       <button id="scrollLeft" 
			               class="btn btn-light rounded-circle shadow position-absolute top-50 start-0 translate-middle-y" 
			               style="width:45px; height:45px; z-index:10;">
			         <i class="bi bi-chevron-left"></i>
			       </button>
			       <button id="scrollRight" 
			               class="btn btn-light rounded-circle shadow position-absolute top-50 end-0 translate-middle-y" 
			               style="width:45px; height:45px; z-index:10;">
			         <i class="bi bi-chevron-right"></i>
			       </button>
			     </div>
			   </section>

			   <!-- 🔹 JS -->
			   <script>
			     const container = document.getElementById('servicesContainer');
			     const scrollLeftBtn = document.getElementById('scrollLeft');
			     const scrollRightBtn = document.getElementById('scrollRight');
			     let scrollSpeed = 0;

			     // Manual button scroll
			     scrollLeftBtn.onclick = () => container.scrollBy({ left: -300, behavior: 'smooth' });
			     scrollRightBtn.onclick = () => container.scrollBy({ left: 300, behavior: 'smooth' });

			     // Auto scroll on hover edges
			     document.addEventListener('mousemove', (e) => {
			       const rect = container.getBoundingClientRect();
			       const edge = 150; // distance from left/right to trigger scroll
			       if (e.clientX < rect.left + edge) {
			         scrollSpeed = -3;
			       } else if (e.clientX > rect.right - edge) {
			         scrollSpeed = 3;
			       } else {
			         scrollSpeed = 0;
			       }
			     });

			
			     function showServiceDetails(name, category, price, duration, ingredients, allergens, photoUrl, salonName, serviceId) {
			       document.getElementById("modalName").textContent = name;
			       document.getElementById("modalCategory").textContent = category;
			       document.getElementById("modalPrice").textContent = price;
			       document.getElementById("modalDuration").textContent = duration;
			       document.getElementById("modalIngredients").textContent = ingredients;
			       document.getElementById("modalAllergens").textContent = allergens;
			       document.getElementById("modalSalon").textContent = salonName;
			       document.getElementById("modalImage").src = photoUrl || "https://via.placeholder.com/400x400";

			       // 🔹 Set the correct booking link dynamically
			       const bookNow = document.getElementById("bookNowLink");
			       bookNow.href = `${window.location.origin}${bookNow.getAttribute("data-base-url")}?serviceId=${serviceId}`;
			     }
			     
				 </script>


    <!-- Dynamic Treatments Section -->
    <c:if test="${not empty treatmentList}">
    <section class="ftco-section">
        <div class="container-fluid px-md-5">
            <div class="row justify-content-center mb-5 pb-3">
                <div class="col-md-12 heading-section text-center">
                    <h3 class="subheading">Services</h3>
                    <h2 class="mb-1">Treatments</h2>
                </div>
            </div>
            <div class="row">
                <c:forEach var="treatment" items="${treatmentList}">
                <div class="col-lg-3 col-md-4 d-flex align-items-stretch mb-4">
                    <div class="treatment w-100 text-center border p-3 py-4 bg-white rounded shadow-sm">
                        <div class="icon d-flex justify-content-center align-items-center mb-3 text-primary">
                            <i class="bi bi-stars" style="font-size: 2rem;"></i>
                        </div>
                        <div class="text mt-2">
                            <h3 class="text-dark"><c:out value="${treatment.serviceName}"/></h3>
                            <p class="text-muted"><c:out value="${treatment.description}"/></p>
                            <p class="mb-0"><strong class="text-primary">₹<fmt:formatNumber value="${treatment.price}"/></strong> | <c:out value="${treatment.duration}"/> min</p>
                            <a href="${pageContext.request.contextPath}/booking/new?treatmentId=${treatment.id}" class="btn btn-primary btn-sm mt-3">Book Now</a>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>
    </section>
    </c:if>

    <!-- Dynamic Offers Section -->
    <c:if test="${not empty offerList}">
    <section class="ftco-section bg-light">
        <div class="container-fluid px-md-5">
            <div class="row justify-content-center mb-5 pb-3">
                <div class="col-md-12 heading-section text-center">
                    <h3 class="subheading">Deals</h3>
                    <h2 class="mb-1">Special Offers</h2>
                </div>
            </div>
            <div class="row">
                <c:forEach var="offer" items="${offerList}">
                <div class="col-lg-4 col-md-6 d-flex align-items-stretch mb-4">
                    <div class="card w-100 text-center shadow-sm border-0 p-3 py-4">
                        <div class="card-body mt-2">
                            <h3 class="text-primary fw-bold"><c:out value="${offer.title}"/></h3>
                            <p class="text-muted"><c:out value="${offer.description}"/></p>
                            <p class="mb-2 text-success fw-bold">Discount: <c:out value="${offer.discountPercent}"/>%</p>
                            <a href="${pageContext.request.contextPath}/salon/book?offerId=${offer.id}" class="btn btn-outline-primary mt-3">Book Offer</a>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>
    </section>
    </c:if>

	  <section class="ftco-section bg-light">
	    <div class="container">
	      <div class="row justify-content-center mb-5 pb-3">
	        <div class="col-md-7 heading-section ftco-animate text-center">
	          <h3 class="subheading">Our Stylists</h3>
	          <h2 class="mb-1">Meet Our Experts</h2>
	        </div>
	      </div>

	      <c:if test="${not empty stylists}">
	        <div class="row">
	          <c:forEach var="stylist" items="${stylists}">
	            <div class="col-md-4 ftco-animate d-flex">
	              <div class="block-7 text-center d-flex flex-column justify-content-between w-100">
	                
	                <div>
	                  <div class="mb-4">
	                    <img src="${pageContext.request.contextPath}${stylist.profileImage != null ? stylist.profileImage : 'images/default-stylist.jpg'}" 
	                         alt="${stylist.firstName}" 
	                         class="img-fluid rounded mb-3" 
	                         style="width:100%; height:300px; object-fit:cover; border-radius:10px;">
	                  </div>

	                  <h2 class="heading">
	                    <c:out value="${stylist.firstName}" /> <c:out value="${stylist.lastName}" />
	                  </h2>
	                  <span class="excerpt d-block mb-2">
	                    <c:out value="${stylist.specialization}" />
	                  </span>

	                  <ul class="pricing-text mb-4">
	                    <li><strong>Experience:</strong> <fmt:formatNumber value="${stylist.experienceInYears}" /> Years</li>
	                    <c:if test="${stylist.rating != null}">
	                      <li><strong>Rating:</strong> <fmt:formatNumber value="${stylist.rating}" maxFractionDigits="1" /> </li>
	                    </c:if>
	                    
	                  </ul>
	                </div>

	               <!-- <a href="${pageContext.request.contextPath}/user/stylist/view?id=${stylist.id}" 
	                   class="btn btn-primary d-block px-3 py-3 mt-auto">View Profile</a>-->
	              </div>
	            </div>
	          </c:forEach>
	        </div>
	      </c:if>

	      <c:if test="${empty stylists}">
	        <p class="text-center text-muted">No stylists available for this salon.</p>
	      </c:if>

	    </div>
	  </section>

	  

    <section class="ftco-section testimony-section">
      <div class="container">
        <div class="row justify-content-center mb-5 pb-3">
          <div class="col-md-10 heading-section ftco-animate text-center">
            <h3 class="subheading">Testimony</h3>
            <h2 class="mb-1">Successful Stories</h2>
          </div>
        </div>
        <div class="row ftco-animate">
          <div class="col-md-12">
            <div class="carousel-testimony owl-carousel">
              <div class="item">
                <div class="testimony-wrap p-4 pb-5">
                  <div class="text">
                  	<div class="line pl-5">
	                    <p class="mb-4 pb-1">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
	                    <span class="quote d-flex align-items-center justify-content-center">
	                      <i class="icon-quote-left"></i>
	                    </span>
	                  </div>
                    <div class="d-flex align-items-center">
                    	<div class="user-img" style="background-image: url(${pageContext.request.contextPath}/beauty/images/person_1.jpg)">
		                  </div>
		                  <div class="ml-4">
		                  	<p class="name">Gabby Smith</p>
		                    <span class="position">Customer</span>
		                  </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="testimony-wrap p-4 pb-5">
                  <div class="text">
                    <div class="line pl-5">
	                    <p class="mb-4 pb-1">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
	                    <span class="quote d-flex align-items-center justify-content-center">
	                      <i class="icon-quote-left"></i>
	                    </span>
	                  </div>

                    <div class="d-flex align-items-center">
                    	<div class="user-img" style="background-image: url(${pageContext.request.contextPath}/beauty/images/person_2.jpg)">
		                  </div>
		                  <div class="ml-4">
		                  	<p class="name">Floyd Weather</p>
		                    <span class="position">Customer</span>
		                  </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="testimony-wrap p-4 pb-5">
                  <div class="text">
                    <div class="line pl-5">
	                    <p class="mb-4 pb-1">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
	                    <span class="quote d-flex align-items-center justify-content-center">
	                      <i class="icon-quote-left"></i>
	                    </span>
	                  </div>

                    <div class="d-flex align-items-center">
                    	<div class="user-img" style="background-image: url(${pageContext.request.contextPath}/beauty/images/person_3.jpg)">
		                  </div>
		                  <div class="ml-4">
		                  	<p class="name">James Dee</p>
		                    <span class="position">Customer</span>
		                  </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="testimony-wrap p-4 pb-5">
                  <div class="text">
                    <div class="line pl-5">
	                    <p class="mb-4 pb-1">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
	                    <span class="quote d-flex align-items-center justify-content-center">
	                      <i class="icon-quote-left"></i>
	                    </span>
	                  </div>

                    <div class="d-flex align-items-center">
                    	<div class="user-img" style="background-image: url(${pageContext.request.contextPath}/beauty/images/person_4.jpg)">
		                  </div>
		                  <div class="ml-4">
		                  	<p class="name">Lance Roger</p>
		                    <span class="position">Customer</span>
		                  </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="testimony-wrap p-4 pb-5">
                  <div class="text">
                    <div class="line pl-5">
	                    <p class="mb-4 pb-1">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
	                    <span class="quote d-flex align-items-center justify-content-center">
	                      <i class="icon-quote-left"></i>
	                    </span>
	                  </div>

                    <div class="d-flex align-items-center">
                    	<div class="user-img" style="background-image: url(${pageContext.request.contextPath}/beauty/images/person_2.jpg)">
		                  </div>
		                  <div class="ml-4">
		                  	<p class="name">Kenny Bufer</p>
		                    <span class="position">Customer</span>
		                  </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="ftco-counter img" id="section-counter" style="background-image: url(${pageContext.request.contextPath}/beauty/images/bg_3.jpg);" data-stellar-background-ratio="0.5">
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

	<section class="ftco-section bg-light">
	  <div class="container">
	    <div class="row justify-content-center mb-5 pb-3">
	      <div class="col-md-7 heading-section ftco-animate text-center">
	        <h3 class="subheading">Pricing Tables</h3>
	        <h2 class="mb-1">Pricing Treatments</h2>
	      </div>
	    </div>
	    <div class="row">
	        <div class="col-md-4 ftco-animate">
	          <div class="block-7">
	            <div class="text-center">
	            <h2 class="heading">Year Card</h2>
	            <span class="price"><sup>$</sup> <span class="number">449</span></span>
	            <span class="excerpt d-block">For 1 Year</span>
	            
	            <h3 class="heading-2 my-4">Enjoy All The Features</h3>
	            
	            <ul class="pricing-text mb-5">
	              <li>Face Treatments</li>
	              <li>Nail Treatments</li>
	              <li>Medical Treatments</li>
	              <li>Hair Removal</li>
	            </ul>

	            <a href="#" class="btn btn-primary d-block px-2 py-4">Get Started</a>
	            </div>
	          </div>
	        </div>
	        <div class="col-md-4 ftco-animate">
	          <div class="block-7">
	            <div class="text-center">
	            <h2 class="heading">Monthly Card</h2>
	            <span class="price"><sup>$</sup> <span class="number">200</span></span>
	            <span class="excerpt d-block">For 1 Month</span>
	            
	            <h3 class="heading-2 my-4">Enjoy All The Features</h3>
	            
	            <ul class="pricing-text mb-5">
	              <li>Face Treatments</li>
	              <li>Nail Treatments</li>
	              <li>Medical Treatments</li>
	              <li>Hair Removal</li>
	            </ul>

	            <a href="#" class="btn btn-primary d-block px-2 py-4">Get Started</a>
	            </div>
	          </div>
	        </div>
	        <div class="col-md-4 ftco-animate">
	          <div class="block-7">
	            <div class="text-center">
	            <h2 class="heading">Weekly Card</h2>
	            <span class="price"><sup>$</sup> <span class="number">85</span></span>
	            <span class="excerpt d-block">For 1 Week</span>
	            
	            <h3 class="heading-2 my-4">Enjoy All The Features</h3>
	            
	            <ul class="pricing-text mb-5">
	              <li>Face Treatments</li>
	              <li>Nail Treatments</li>
	              <li>Medical Treatments</li>
	              <li>Hair Removal</li>
	            </ul>

	            <a href="#" class="btn btn-primary d-block px-2 py-4">Get Started</a>
	            </div>
	          </div>
	        </div>
	      </div>
	  </div>
	</section>

		<section class="ftco-gallery ftco-section">
    	<div class="container">
    		<div class="row justify-content-center mb-5 pb-3">
          <div class="col-md-7 heading-section ftco-animate text-center">
            <h3 class="subheading">Salon Gallery</h3>
            <h2 class="mb-1">See the salon view</h2>
          </div>
        </div>
    		<div class="row">
					<div class="col-md-3 ftco-animate">
						<a href="${pageContext.request.contextPath}/beauty/images/gallery-1.jpg" class="gallery image-popup img d-flex align-items-center" style="background-image: url(/beauty/images/salon1.jpg);">
							<div class="icon mb-4 d-flex align-items-center justify-content-center">
    						<span class="icon-instagram"></span>
    					</div>
						</a>
					</div>
					<div class="col-md-3 ftco-animate">
						<a href="${pageContext.request.contextPath}/beauty/images/gallery-2.jpg" class="gallery image-popup img d-flex align-items-center" style="background-image: url(/beauty/images/haircut.jpg);">
							<div class="icon mb-4 d-flex align-items-center justify-content-center">
    						<span class="icon-instagram"></span>
    					</div>
						</a>
					</div>
					<div class="col-md-3 ftco-animate">
						<a href="${pageContext.request.contextPath}/beauty/images/gallery-3.jpg" class="gallery image-popup img d-flex align-items-center" style="background-image: url(/beauty/images/salon2.jpg);">
							<div class="icon mb-4 d-flex align-items-center justify-content-center">
    						<span class="icon-instagram"></span>
    					</div>
						</a>
					</div>
					<div class="col-md-3 ftco-animate">
						<a href="${pageContext.request.contextPath}/beauty/images/gallery-4.jpg" class="gallery image-popup img d-flex align-items-center" style="background-image: url(/beauty/images/model2.jpg!d);">
							<div class="icon mb-4 d-flex align-items-center justify-content-center">
    						<span class="icon-instagram"></span>
    					</div>
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
          <a href="${pageContext.request.contextPath}/index/templates" class="d-flex align-items-center">
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
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates">Home</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/about">About us</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates#services">Services</a></li>
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
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
 
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

