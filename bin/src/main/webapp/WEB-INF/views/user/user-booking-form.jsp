<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
			
			/* 🔧 Fix button visibility */
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
            <li><a href="${pageContext.request.contextPath}/users/dashboard" class="btn-dashboard"><i class="fas fa-th-large"></i> Back to Dashboard</a></li>
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
				           <h1>${stylist.firstName}${stylist.lastName}</h1>
				           <div class="row justify-content-center">
				            <div class="col-md-7 mb-3">
				            	<p>Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.</p>
				            </div>
				          </div>
				           <p>
				           	<a href="#" class="btn btn-primary p-3 px-5 py-4 mr-md-2">Get in Touch</a>
				           	<a href="#" class="btn btn-outline-primary p-3 px-5 py-4 ml-md-2">Contact</a>
				           </p>
				         </div>
				       </div>
				     </div>
				   </section>

				   <!-- 💇‍♀️ Booking Form Section (Contact style layout) -->
				   <section class="ftco-section contact-section">
				     <div class="container">
				       
				       <!-- Error Message Display -->
				       <c:if test="${not empty error}">
				         <div class="row justify-content-center mb-4">
				           <div class="col-md-8">
				             <div class="alert alert-danger text-center" role="alert">
				               <strong>⚠️ ${error}</strong>
				               <br>
				               <a href="${pageContext.request.contextPath}/user/stylist/view?id=${stylist.id}" class="btn btn-sm btn-outline-dark mt-2">
				                 ← Back to Stylist Profile
				               </a>
				             </div>
				           </div>
				         </div>
				       </c:if>
				       
				       <div class="row block-9 justify-content-center">
				         
				         <div class="col-md-6 ftco-animate">
				           <form id="bookingForm" onsubmit="event.preventDefault(); initiatePayment();" class="contact-form bg-light p-5 rounded shadow">
				             
				             <h3 class="text-center mb-4">
				               Book ${service.name} with ${stylist.firstName} ${stylist.lastName}
				             </h3>

				             <input type="hidden" id="stylistId" value="${stylist.id}">
				             <input type="hidden" id="serviceId" value="${service.id}">
                             <input type="hidden" id="amount" value="${service.price}">

                             <div class="mb-4 text-center">
                                 <div class="h4 text-primary fw-bold">Amount: ₹${service.price}</div>
                             </div>

                             <div class="form-group mb-4">
                               <label for="userName" class="form-label fw-semibold">Your Name *</label>
                               <input type="text" id="userName" class="form-control" value="${user.fullName}" required>
                             </div>

                             <div class="form-group mb-4">
                               <label for="userPhone" class="form-label fw-semibold">Mobile Number *</label>
                               <input type="tel" id="userPhone" class="form-control" value="${user.phoneNumber}" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                             </div>

				             <div class="form-group mb-4">
				               <label for="bookingTime" class="form-label fw-semibold">Select Date & Time</label>
				               <input type="datetime-local" id="bookingTime" class="form-control" required>
				             </div>

				             <div class="form-group mb-4">
				               <label for="coupon" class="form-label fw-semibold">Coupon Code</label>
				               <input type="text" id="coupon" class="form-control" placeholder="Optional">
				             </div>

				             <div class="form-group text-center">
				               <button type="submit" class="btn btn-primary py-3 px-5" id="payBtn">
				                 💳 Pay & Confirm Booking
				               </button>
				             </div>
				           </form>
				         </div>

                         <!-- Razorpay SDK -->
                         <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
                         <script>
                             async function initiatePayment() {
                                 const payBtn = document.getElementById('payBtn');
                                 const amount = document.getElementById('amount').value;
                                 const stylistId = document.getElementById('stylistId').value;
                                 const serviceId = document.getElementById('serviceId').value;
                                 const bookingTime = document.getElementById('bookingTime').value;
                                 const coupon = document.getElementById('coupon').value;

                                 if(!bookingTime) {
                                     alert('Please select booking time');
                                     return;
                                 }

                                 payBtn.disabled = true;
                                 payBtn.innerText = 'Initializing...';

                                 try {
                                     const response = await fetch('${pageContext.request.contextPath}/payment/create-order', {
                                         method: 'POST',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify({ amount, type: 'BEAUTY' })
                                     });

                                     const order = await response.json();

                                     const options = {
                                         key: order.key,
                                         amount: order.amount,
                                         currency: 'INR',
                                         name: 'Fight D Fear Beauty',
                                         description: 'Stylist Service Payment',
                                         order_id: order.orderId,
                                         handler: async function (response) {
                                             const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                                                 method: 'POST',
                                                 headers: { 'Content-Type': 'application/json' },
                                                 body: JSON.stringify({
                                                     razorpay_order_id: response.razorpay_order_id,
                                                     razorpay_payment_id: response.razorpay_payment_id,
                                                     razorpay_signature: response.razorpay_signature,
                                                     type: 'BEAUTY',
                                                     targetId: serviceId,
                                                     stylistId: stylistId,
                                                     amount: amount,
                                                     bookingTime: bookingTime,
                                                     coupon: coupon
                                                 })
                                             });

                                             if (verifyRes.ok) {
                                                 window.location.href = '${pageContext.request.contextPath}/user/bookings?message=Success';
                                             } else {
                                                 const errorData = await verifyRes.json();
                                                 alert('Verification Failed: ' + (errorData.error || 'Unknown error'));
                                                 payBtn.disabled = false;
                                                 payBtn.innerText = '💳 Pay & Confirm Booking';
                                             }
                                         },
                                         prefill: {
                                             name: '${user.fullName}',
                                             email: '${user.email}',
                                             contact: '${user.phoneNumber}'
                                         },
                                         theme: { color: '#6a0dad' },
                                         modal: {
                                             ondismiss: function() {
                                                 payBtn.disabled = false;
                                                 payBtn.innerText = '💳 Pay & Confirm Booking';
                                             }
                                         }
                                     };

                                     const rzp = new Razorpay(options);
                                     rzp.open();
                                 } catch (error) {
                                     console.error(error);
                                     alert('Could not initiate payment.');
                                     payBtn.disabled = false;
                                     payBtn.innerText = '💳 Pay & Confirm Booking';
                                 }
                             }
                         </script>

				       </div>
				     </div>
				   </section>

  <!-- 🌸 Footer -->
			  <footer id="footer" class="footer position-relative">

   

    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="${pageContext.request.contextPath}/index/templates" class="d-flex align-items-center">
            <span class="sitename">Fight D Fear</span>
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
      <p>© <span>Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> <span>All Rights Reserved</span></p>
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

