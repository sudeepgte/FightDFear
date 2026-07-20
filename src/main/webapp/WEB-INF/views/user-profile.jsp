<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
			<title>User Profile</title>
			<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">

<!-- Icons & CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

			<!-- 🎨 Custom CSS -->
			</head>
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
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    /* ===== Nav Item Theme Color (no box) ===== */
    #navmenu ul li a[href*="/chat/users"],
    #navmenu ul li a[href*="/user/bookings"],
    #navmenu ul li a[href*="/users/wallet"] {
        background: none !important;
        color: #f43f5e !important;
        padding: 5px 14px !important;
        border-radius: 0 !important;
        font-weight: 700 !important;
        box-shadow: none !important;
        letter-spacing: 0.3px;
    }
    #navmenu ul li a[href*="/chat/users"]:hover,
    #navmenu ul li a[href*="/user/bookings"]:hover,
    #navmenu ul li a[href*="/users/wallet"]:hover {
        color: #1e1b4b !important;
        background: none !important;
        transform: none !important;
        filter: none !important;
    }


    #ftco-navbar {
        background-color: var(--primary-purple) !important;
        box-shadow: var(--shadow-sm);
    }

    #ftco-navbar .navbar-brand,
    #ftco-navbar .navbar-brand span {
        color: #ffffff !important;
        font-weight: 700;
    }

    #ftco-navbar .nav-link {
        color: #ffffff !important;
        font-size: 1.2rem !important;
        font-weight: 500;
        letter-spacing: 0.5px;
        padding: 10px 18px !important;
        transition: all 0.3s ease;
    }

    #ftco-navbar .nav-link:hover,
    #ftco-navbar .nav-item.active .nav-link {
        color: var(--primary-gold) !important;
        transform: scale(1.05);
        background-color: rgba(255,255,255,0.05);
        border-radius: 8px;
    }

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
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(123, 44, 191, 0.35);
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
        text-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }

    .hero-section p {
        font-size: 1.2rem;
        color: #f8f9fa;
        margin-bottom: 35px;
        max-width: 650px;
        margin-left: auto;
        margin-right: auto;
        text-shadow: 0 1px 4px rgba(0,0,0,0.3);
    }

    .hero-section a.btn-primary {
        background-color: var(--primary-purple-light);
        border-color: var(--primary-purple-light);
        transition: all 0.3s ease;
        font-weight: 600;
        box-shadow: var(--shadow-sm);
    }
    .hero-section a.btn-primary:hover {
        background-color: var(--primary-purple);
        border-color: var(--primary-purple);
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .hero-section a.btn-outline-light:hover {
        background-color: #fff;
        color: var(--primary-purple-light) !important;
        transform: translateY(-2px);
    }

    .coin-box {
        background: rgba(255, 215, 0, 0.2);
        border: 1px solid var(--primary-gold);
        padding: 12px;
        border-radius: 8px;
        font-size: 18px;
        font-weight: bold;
        color: #b87c00;
        box-shadow: var(--shadow-sm);
    }

    @media (max-width: 768px) {
        #ftco-navbar .nav-link {
            font-size: 1rem !important;
            padding: 8px 12px !important;
        }
        .hero-section h1 {
            font-size: 2rem;
        }
        .hero-section p {
            font-size: 1rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for hero content */
    .hero-section h1 {
        animation: fadeInUp 0.8s ease-out forwards;
    }
    .hero-section p {
        animation: fadeInUp 0.8s ease-out 0.15s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }
    .hero-section a.btn-primary,
    .hero-section a.btn-outline-light {
        animation: fadeInUp 0.8s ease-out 0.3s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
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

    /* 2. Button ripple effect on click (micro-interaction) */
    .hero-section a.btn-primary,
    .hero-section a.btn-outline-light {
        position: relative;
        overflow: hidden;
    }
    .hero-section a.btn-primary::after,
    .hero-section a.btn-outline-light::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .hero-section a.btn-primary:active::after,
    .hero-section a.btn-outline-light:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    #ftco-navbar .nav-link:focus-visible,
    .hero-section a:focus-visible,
    .coin-box:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 8px;
    }

    /* 4. Custom scrollbar (matches brand purple) */
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
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Coin box hover effect */
    .coin-box {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .coin-box:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
    }

    /* 6. Navbar brand hover effect */
    #ftco-navbar .navbar-brand:hover {
        text-shadow: 0 0 6px rgba(255,215,0,0.5);
        transition: text-shadow 0.2s;
    }

    /* 7. Responsive touch improvements */
    @media (max-width: 991px) {
        .user-split-section .row {
            flex-direction: column;
        }
        .user-bg-left {
            padding: 40px 20px !important;
            min-height: auto !important;
            background: var(--gradient-primary) !important;
        }
        .user-details-side {
            padding: 20px !important;
        }
        .user-details {
            padding: 20px !important;
            width: 100%;
        }
        .hero-section h1 {
            font-size: 2rem;
        }
        .hero-section p {
            font-size: 1rem;
        }
        /* Fix: Don't make profile image 300px on mobile */
        .user-bg-left img {
            width: 130px !important;
            height: 130px !important;
            margin-bottom: 20px !important;
        }
        .instagram-stats {
            gap: 20px !important;
            justify-content: center !important;
        }
        .dashboard-bar {
            justify-content: center !important;
            padding: 0 15px !important;
            margin-top: 15px;
            margin-bottom: 15px;
        }
        .dashboard-btn {
            width: 100% !important;
            justify-content: center !important;
            padding: 12px 20px !important;
        }
    }

    @media (max-width: 480px) {
        .hero-section h1 {
            font-size: 1.6rem;
        }
        .hero-section p {
            font-size: 0.9rem;
            padding: 0 15px;
        }
        .hero-section a.btn-primary,
        .hero-section a.btn-outline-light {
            padding: 8px 16px;
            font-size: 0.9rem;
        }
        .coin-box {
            font-size: 14px;
            padding: 8px;
        }
        .instagram-stats {
            gap: 15px !important;
            justify-content: space-around;
        }
        .user-details h2 {
            font-size: 1.5rem;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .coin-box.skeleton {
        background: linear-gradient(90deg, #e0e0e0 25%, #d0d0d0 50%, #e0e0e0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
    /* 9. Dashboard Button Styling */
    .dashboard-bar {
        position: relative;
        z-index: 99;
        margin-top: 10px;
        padding-right: 15px;
    }
    .dashboard-btn {
        background: var(--gradient-primary);
        color: #fff !important;
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        font-family: 'Raleway', sans-serif;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
    }
    .dashboard-btn:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 8px 25px rgba(124, 45, 94, 0.45);
        color: #fff !important;
    }
    .dashboard-btn i {
        font-size: 1.2rem;
        transition: transform 0.3s ease;
    }
    .dashboard-btn:hover i {
        transform: translateX(5px);
    }
</style>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

<div class="dashboard-bar container-fluid container-xl d-flex justify-content-end">
    <a href="${pageContext.request.contextPath}/users/dashboard" class="dashboard-btn">
        Dashboard <i class="bi bi-arrow-right"></i>
    </a>
</div>
<section class="user-split-section" style="padding-top: 0 !important; margin-top: 0 !important; background: transparent;">
					     <div class="container-fluid p-0">
					       <div class="row no-gutters align-items-stretch">
					       <div class="col-md-6 user-bg-left d-flex flex-column align-items-center p-4">
    <img src="${pageContext.request.contextPath}${user.profilePhoto}"
         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
         alt="User Profile Picture"
         style="width:120px;height:120px;border-radius:50%;object-fit:cover;border:3px solid #f43f5e;box-shadow:0 4px 14px rgba(219,39,119,0.35);" class="mb-4">

    <!-- 📊 Account Summary Integrated Here -->
    <div class="text-center text-white px-3">
        <div class="coin-box d-inline-block mb-3 shadow-sm" style="background: rgba(255, 215, 0, 0.2); border: 1px solid var(--primary-gold); color: #fff;">
            🪙 <span style="font-size: 20px;"><strong>${coins}</strong></span> Coins Earned
        </div>
        <h4 class="text-white mb-2" style="font-weight: 700;">Account Overview</h4>
        <p class="small mb-3" style="opacity: 0.8;">Manage your safety profile and contacts below.</p>
        
        <div class="d-flex flex-column gap-2 w-100" style="max-width: 300px;">
            <a href="${pageContext.request.contextPath}/index/contact" class="btn btn-light btn-sm py-2 px-4 rounded-pill" style="color:var(--primary-purple);font-weight:700;">
                <i class="fas fa-comment-alt me-2"></i> Get in Touch
            </a>
            <a href="${pageContext.request.contextPath}/users/${user.id}/emergency-contacts" class="btn btn-outline-light btn-sm py-2 px-4 rounded-pill" style="font-weight: 700;">
                <i class="fas fa-phone-alt me-2"></i> Emergency Contacts
            </a>
        </div>
    </div>

</div>
					          
					         <!-- 📋 Right Side: User Details -->
					         <div class="col-md-6 user-details-side d-flex align-items-start">
					           <div class="user-details p-3 p-lg-5 pt-lg-3">
					             
					             <!-- Header -->
					             <div class="heading-section ftco-animate mb-4">
					               <h2 class="mb-2">Hello, ${user.fullName} 👋</h2>
					               
					               <!-- 📊 Instagram-style Stats -->
					               <div class="d-flex instagram-stats gap-4 my-3 py-2 border-top border-bottom">
					                   <div class="text-center">
					                       <h5 class="mb-0 fw-bold">${postsCount != null ? postsCount : 0}</h5>
					                       <small class="text-muted">Posts</small>
					                   </div>
					                   <div class="text-center">
					                       <h5 class="mb-0 fw-bold">${followersCount != null ? followersCount : 0}</h5>
					                       <small class="text-muted">Followers</small>
					                   </div>
					                   <div class="text-center">
					                       <h5 class="mb-0 fw-bold">${followingCount != null ? followingCount : 0}</h5>
					                       <small class="text-muted">Following</small>
					                   </div>
					               </div>

					               <p class="text-muted">Here’s your complete profile overview</p>
					             </div>

					             <!-- Details List -->
					             <ul class="list-unstyled ftco-animate">
					               <li class="mb-3"><i class="fas fa-envelope text-primary me-2"></i> <strong>Email:</strong> ${user.email}</li>
					               <li class="mb-3"><i class="fas fa-phone text-primary me-2"></i> <strong>Phone:</strong> ${user.phoneNumber}</li>
					               <li class="mb-3"><i class="fas fa-home text-primary me-2"></i> <strong>Address:</strong> ${user.homeAddress}</li>
					               <li class="mb-3"><i class="fas fa-id-badge text-primary me-2"></i> <strong>User ID:</strong> ${user.id}</li>
					               <li class="mb-3">
    <i class="fas fa-calendar-alt text-primary me-2"></i>
    <strong>Date of Birth:</strong> ${user.dob}
</li>
					               
					               <li class="mb-3"><i class="fas fa-calendar-alt text-primary me-2"></i> <strong>Age:</strong> ${user.age}</li>
					               <li class="mb-3"><i class="fas fa-venus-mars text-primary me-2"></i> <strong>Gender:</strong> ${user.gender}</li>
					               <li class="mb-3"><i class="fas fa-file text-primary me-2"></i> 
					                 <strong>ID Document:</strong> 
					                 <a href="${pageContext.request.contextPath}${user.identityDocument}" target="_blank" class="text-decoration-none">View</a>
					               </li>
					             </ul>

					             <!-- 📊 Profile Completion -->
					             <div class="progress-container mt-4">
					               <div class="progress" style="height: 12px; border-radius: 10px;">
					                 <div class="progress-bar bg-primary" role="progressbar"
					                      style="width: ${completionPercentage}%;"
					                      aria-valuenow="${completionPercentage}" aria-valuemin="0" aria-valuemax="100"></div>
					               </div>
					               <p class="mt-2 mb-0 text-muted">
					                 Profile Completion: <strong>${completionPercentage}%</strong>
					               </p>
					             </div>

					             <!-- 🔘 Action Buttons -->
					             <div class="mt-4 d-flex flex-wrap gap-3">
					               <a href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-outline-dark px-4 py-2 fw-bold text-dark border-dark">
					                 <i class="fas fa-home me-2"></i> Back to Dashboard
					               </a>
					               <a href="${pageContext.request.contextPath}/users/update/${user.id}" class="btn btn-primary px-4 py-2 text-white">
					                 <i class="fas fa-user-edit me-2"></i> Edit
					               </a>
					               <a href="${pageContext.request.contextPath}/users/delete/${user.id}" class="btn btn-outline-danger px-4 py-2">
					                 <i class="fas fa-trash-alt me-2"></i> Delete
					               </a>
					             </div>

					           </div>
					         </div>

					       </div>
					     </div>
					   </section>



 <!-- 🌸 Footer -->
  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

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

					      </div>
</div>
</body>
					  </html>

