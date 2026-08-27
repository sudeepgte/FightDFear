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
        --primary-purple: #F8FAFC;
        --primary-purple-light: #F43F5E;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: #FFFFFF;
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    /* ===== Nav Item Theme Color (desktop only) ===== */
    @media (min-width: 1200px) {
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
        background: rgba(244, 63, 94, 0.05);
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
    .profile-back-btn {
        background: #fff;
        color: var(--primary-purple) !important;
        border: 2px solid var(--primary-purple);
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
        transition: all 0.25s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }
    .profile-back-btn:hover {
        background: rgba(30, 27, 75, 0.08);
        color: var(--primary-purple) !important;
        border-color: var(--brand-pink);
        transform: translateY(-1px);
    }

    .profile-back-btn .back-label-short {
        display: none;
    }

    /* Profile page mobile: sidebar + content layout */
    @media (max-width: 768px) {
        body {
            overflow-x: hidden;
        }

        #wrapper {
            flex-direction: column !important;
            width: 100% !important;
            margin-top: 68px !important;
        }

        #page-content-wrapper {
            margin-left: 0 !important;
            padding: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box !important;
        }

        .profile-back-bar {
            padding: 10px 12px 0 !important;
            margin-bottom: 8px !important;
        }

        .profile-back-btn {
            font-size: 14px;
            padding: 10px 16px;
        }

        .user-split-section {
            margin-top: 0 !important;
        }

        .user-split-section .container-fluid {
            padding: 0 !important;
            max-width: 100% !important;
        }

        .user-bg-left {
            padding: 28px 16px !important;
            border-radius: 0 0 20px 20px;
        }

        .user-details-side {
            width: 100% !important;
            min-width: 0 !important;
        }

        .user-details {
            padding: 18px 14px 24px !important;
        }

        .user-details li {
            font-size: 14px;
            word-break: break-word;
        }

        .user-details .mt-4.d-flex.flex-wrap.gap-3 {
            flex-direction: column;
            gap: 10px !important;
        }

        .user-details .mt-4.d-flex.flex-wrap.gap-3 .btn {
            width: 100%;
            justify-content: center;
        }

        .instagram-stats {
            justify-content: space-between !important;
            gap: 8px !important;
        }
    }

    @media (max-width: 430px) {
        .profile-back-btn {
            width: 100%;
            justify-content: center;
            font-size: 13px;
        }

        .profile-back-btn .back-label-long {
            display: none;
        }

        .profile-back-btn .back-label-short {
            display: inline;
        }

        .user-bg-left img {
            width: 110px !important;
            height: 110px !important;
        }

        .user-details h2 {
            font-size: 1.35rem;
        }

        .instagram-stats h5 {
            font-size: 1rem;
        }

        .instagram-stats small {
            font-size: 11px;
        }
    }
</style>
<body>

    <!-- Header -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">

<section class="user-split-section" style="padding-top: 0 !important; margin-top: 0 !important; background: #F8FAFC;">
					     <div class="container-fluid p-0">
					       <div class="row no-gutters align-items-stretch" style="background: #FFFFFF; border-radius: 24px; box-shadow: 0 4px 24px rgba(0,0,0,0.04); margin: 30px auto; max-width: 1200px; overflow: hidden; border: 1px solid #E2E8F0;">
					       <div class="col-md-5 user-bg-left d-flex flex-column align-items-center p-5" style="background: #FFFFFF; border-right: 1px solid #E2E8F0;">
    <img src="${pageContext.request.contextPath}${user.profilePhoto}"
         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
         alt="User Profile Picture"
         style="width:150px;height:150px;border-radius:50%;object-fit:cover;border:4px solid #F43F5E;box-shadow:0 4px 20px rgba(244,63,94,0.25);" class="mb-4">

    <!-- 📊 Account Summary Integrated Here -->
    <div class="text-center px-3" style="color: #0F172A;">
        <div class="coin-box d-inline-block mb-3 shadow-sm" style="background: #FFF7ED; border: 1px solid #C2410C; color: #C2410C;">
            🪙 <span style="font-size: 20px;"><strong>${user.rewardPoints != null ? user.rewardPoints : 0}</strong></span> Coins Earned
        </div>
        <h4 class="mb-2" style="color: #0F172A; font-weight:800;">Account Overview</h4>
        <p class="small mb-3" style="color: #64748B;">Manage your safety profile and contacts below.</p>
        
        <div class="d-flex flex-column gap-2 w-100" style="max-width: 300px;">
            <a href="${pageContext.request.contextPath}/index/contact" class="btn btn-sm py-2 px-4 rounded-pill" style="background:#F43F5E; color:#FFF; font-weight:700;">
                <i class="fas fa-comment-alt me-2"></i> Get in Touch
            </a>
            <a href="${pageContext.request.contextPath}/users/${user.id}/emergency-contacts" class="btn btn-outline-danger btn-sm py-2 px-4 rounded-pill" style="color:#F43F5E; border-color:#F43F5E; font-weight: 700;">
                <i class="fas fa-phone-alt me-2"></i> Emergency Contacts
            </a>
        </div>
    </div>

</div>
					          
					         <!-- 📋 Right Side: User Details -->
					         <div class="col-md-7 user-details-side d-flex align-items-start" style="background: #FFFFFF;">
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
					               <li class="mb-3"><i class="fas fa-envelope me-2" style="color: #F43F5E;"></i> <strong>Email:</strong> ${user.email}</li>
					               <li class="mb-3"><i class="fas fa-phone me-2" style="color: #F43F5E;"></i> <strong>Phone:</strong> ${user.phoneNumber}</li>
					               <li class="mb-3"><i class="fas fa-home me-2" style="color: #F43F5E;"></i> <strong>Address:</strong> ${user.homeAddress}</li>
					               <li class="mb-3"><i class="fas fa-id-badge me-2" style="color: #F43F5E;"></i> <strong>User ID:</strong> ${user.id}</li>
					               <li class="mb-3">
    <i class="fas fa-calendar-alt me-2" style="color: #F43F5E;"></i>
    <strong>Date of Birth:</strong> ${user.dob}
</li>
					               
					               <li class="mb-3"><i class="fas fa-calendar-alt me-2" style="color: #F43F5E;"></i> <strong>Age:</strong> ${user.age}</li>
					               <li class="mb-3"><i class="fas fa-venus-mars me-2" style="color: #F43F5E;"></i> <strong>Gender:</strong> ${user.gender}</li>
					               <li class="mb-3"><i class="fas fa-file me-2" style="color: #F43F5E;"></i> 
					                 <strong>ID Document:</strong> 
					                 <a href="${pageContext.request.contextPath}${user.identityDocument}" target="_blank" class="text-decoration-none">View</a>
					               </li>
					             </ul>

					             <!-- 📊 Profile Completion -->
					             <div class="progress-container mt-4">
					               <div class="progress" style="height: 12px; border-radius: 10px;">
					                 <div class="progress-bar" style="background-color: #F43F5E;" role="progressbar"
					                      style="width: ${completionPercentage}%;"
					                      aria-valuenow="${completionPercentage}" aria-valuemin="0" aria-valuemax="100"></div>
					               </div>
					               <p class="mt-2 mb-0 text-muted">
					                 Profile Completion: <strong>${completionPercentage}%</strong>
					               </p>
					             </div>

					             <!-- 🔘 Action Buttons -->
					             <div class="mt-4 d-flex flex-wrap gap-3">
					               <a href="${pageContext.request.contextPath}/users/update/${user.id}" class="btn px-4 py-2 text-white" style="background:#F43F5E; border-color:#F43F5E;">
					                 <i class="fas fa-user-edit me-2"></i> Edit
					               </a>
					               <a href="${pageContext.request.contextPath}/users/delete/${user.id}" class="btn btn-outline-danger px-4 py-2" style="color: #DC2626; border-color: #DC2626;">
					                 <i class="fas fa-trash-alt me-2"></i> Delete
					               </a>
					             </div>

					           </div>
					         </div>

					       </div>
					     </div>
					   </section>



 <!-- 🌸 Footer -->
  

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





