<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>

<meta charset="utf-8">
					<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
					<title>Connect with Members</title>
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
						<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
						<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
						<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
						<link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
						<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
						<link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

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

		
	.user-card {
	  transition: transform 0.3s, box-shadow 0.3s;
	}
	.user-card:hover {
	  transform: translateY(-5px);
	  box-shadow: 0 8px 20px rgba(0,0,0,0.1);
	}
	.btn.active {
	  background-color: #fff !important;
	  color: #000 !important;
	  border: 1px solid #000 !important;
	}

</style>

</head>

<body>
	
	<header id="header" class="header d-flex align-items-center sticky-top">
  <div class="container-fluid container-xl d-flex align-items-center">
    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
    <nav id="navmenu" class="navmenu">
      <ul>

        <li><a href="${pageContext.request.contextPath}/centres/allacceptedcentres">MartialArts Centres</a></li>

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
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

			<!-- END nav -->
			<!-- 🌸 User Social Profile Section -->
			<section class="hero-wrap js-fullheight" style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg'); background-size: cover; background-position: center;" data-stellar-background-ratio="0.5">
			  <div class="overlay"></div>
			  <div class="container">
			    <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center text-center">
					<div class="col-md-10 ftco-animate text-center">
					  
					  <!-- 🖼 Profile Image -->
					<div class="profile-image mb-3 text-center">
  <c:choose>
    <c:when test="${not empty user.profilePhoto}">
    
      <img 
        src="${pageContext.request.contextPath}${user.profilePhoto}" 
        alt="${user.fullName}" 
        class="rounded-circle border border-3 border-light shadow"
        style="width:130px; height:130px; object-fit:cover;"
      />
    </c:when>
    <c:otherwise>
      <img 
        src="${pageContext.request.contextPath}/images/default-avatar.png" 
        alt="Default Avatar" 
        class="rounded-circle border border-3 border-light shadow"
        style="width:130px; height:130px; object-fit:cover;"
      />
    </c:otherwise>
  </c:choose>
</div>
					

					  <!-- 🌸 Icon -->
					  <div class="icon mb-2">
					    <span class="flaticon-lotus text-light" style="font-size: 24px;"></span>
					  </div>

					  <!-- 👤 User Name -->
					    <h1>${user.fullName}</h1>

					  <!-- 📝 Description -->
					  <p >
					    Stay connected with followers, manage requests, and explore your beauty community.
					  </p>
					


			        <!-- 🌺 Tab Buttons -->
			        <div class="mb-5">
			          <button id="btn-followers" class="btn btn-primary p-3 px-5 py-4 mr-md-2" onclick="switchTab('followers')">Followers</button>
			          <button id="btn-following" class="btn btn-primary p-3 px-5 py-4 mr-md-2" onclick="switchTab('following')">Following</button>
			          <button id="btn-requests" class="btn btn-primary p-3 px-5 py-4 mr-md-2" onclick="switchTab('requests')">Requests</button>
			          <button id="btn-search" class="btn btn-primary p-3 px-5 py-4 mr-md-2" onclick="switchTab('search')">Search</button>
			        </div>
			      </div>
			    </div>
			  </div>
			</section>

			<!-- 🌼 Main Tab Container -->
			<div id="main-content" class="container py-5">
			  <!-- 🧍 FOLLOWERS TAB -->
			  <div id="followers" class="tab-content active">
			    <h4 class="mb-4 text-primary">Followers</h4>
			    <div class="row g-4">
			      <c:forEach var="f" items="${followers}">
			        <div class="col-md-3 col-sm-6">
			          <div class="user-card text-center shadow-sm p-3 bg-white rounded">
			            <a href="${pageContext.request.contextPath}/users/profile/${f.id}" class="text-decoration-none text-dark">
			              <img src="${pageContext.request.contextPath}${f.profilePhoto}" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'" alt="${f.fullName}" class="rounded-circle mb-3" width="90" height="90" style="object-fit:cover;">
			              <h5>${f.fullName}</h5>
			            </a>
			            <a href="${pageContext.request.contextPath}/chat/window/${f.id}" class="btn btn-outline-primary btn-sm mt-2">💬 Chat</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>

			  <!-- 👣 FOLLOWING TAB -->
			  <div id="following" class="tab-content d-none">
			    <h4 class="mb-4 text-primary">Following</h4>
			    <div class="row g-4">
			      <c:forEach var="f" items="${following}">
			        <div class="col-md-3 col-sm-6">
			          <div class="user-card text-center shadow-sm p-3 bg-white rounded">
			            <img src="${f.profilePhoto}" alt="${f.fullName}" class="rounded-circle mb-3" width="90" height="90">
			            <h5>${f.fullName}</h5>
			            <a href="${pageContext.request.contextPath}/chat/window/${f.id}" class="btn btn-outline-primary btn-sm mt-2">💬 Chat</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>

			  <!-- ✉ REQUESTS TAB -->
			  <div id="requests" class="tab-content d-none">
			    <h4 class="mb-4 text-primary">Follow Requests</h4>
			    <div class="row g-4">
			      <c:forEach var="req" items="${followRequests}">
			        <div class="col-md-3 col-sm-6">
			          <div class="user-card text-center shadow-sm p-3 bg-white rounded">
			            <a href="${pageContext.request.contextPath}/users/profile/${req.id}" class="text-decoration-none text-dark">
			              <img src="${pageContext.request.contextPath}${req.profilePhoto}" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'" alt="${req.fullName}" class="rounded-circle mb-3" width="90" height="90" style="object-fit:cover;">
			              <h5>${req.fullName}</h5>
			            </a>
			            <div class="d-flex justify-content-center gap-2 mt-2">
			              <form action="${pageContext.request.contextPath}/users/acceptRequest/${req.id}" method="post">
			                <button type="submit" class="btn btn-success btn-sm">Accept</button>
			              </form>
			              <form action="${pageContext.request.contextPath}/users/declineRequest/${req.id}" method="post">
			                <button type="submit" class="btn btn-outline-secondary btn-sm">Decline</button>
			              </form>
			            </div>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>

			  <div id="search" class="tab-content d-none">
			    <h4 class="mb-4 text-primary">Find Members</h4>
			    <form action="${pageContext.request.contextPath}/users/search" method="get" class="d-flex mb-4">
			      <input type="hidden" name="tab" value="search">
			      <input type="text" name="keyword" class="form-control me-2" placeholder="Search by name or email" value="${keyword}">
			      <button type="submit" class="btn btn-primary">Search</button>
			    </form>

			    <div class="row g-4">
			      <c:forEach var="u" items="${users}">
			        <div class="col-md-3 col-sm-6">
			          <div class="user-card text-center shadow-sm p-3 bg-white rounded">
			            <img src="${u.profilePhoto}" alt="${u.fullName}" class="rounded-circle mb-3" width="90" height="90">
			            <h5>${u.fullName}</h5>
			            <p class="text-muted small">Age: ${u.age} | ${u.gender}</p>
			            <c:choose>
			              <c:when test="${followingStatus[u.id]}">
			                <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Following</button>
			              </c:when>
			              <c:when test="${pendingStatus[u.id]}">
			                <button type="button" class="btn btn-outline-warning btn-sm" disabled>Requested</button>
			              </c:when>
			              <c:otherwise>
			                <form action="${pageContext.request.contextPath}/users/follow/${u.id}" method="post">
			                  <button type="submit" class="btn btn-primary btn-sm">Follow</button>
			                </form>
			              </c:otherwise>
		            </c:choose>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
			</div>

			<!-- 🌷 Tab Switching Script -->
			<script>
			function switchTab(tabId, shouldScroll = true) {
			  document.querySelectorAll('.tab-content').forEach(tab => tab.classList.add('d-none'));
			  document.getElementById(tabId).classList.remove('d-none');
			  
			  document.querySelectorAll('.btn').forEach(btn => btn.classList.remove('active'));
			  const btn = document.getElementById('btn-' + tabId);
			  if(btn) btn.classList.add('active');
			  
			  if(shouldScroll) {
			    document.getElementById('main-content').scrollIntoView({ behavior: 'smooth' });
			  }
			}

			window.onload = function() {
			  const urlParams = new URLSearchParams(window.location.search);
			  const tab = urlParams.get('tab');
			  const keyword = urlParams.get('keyword');
			  
			  if (tab) {
			    switchTab(tab, true);
			  } else if (keyword) {
			    switchTab('search', true);
			  }
			};
			</script>
		
	<!-- 🌸 Footer -->
			  	<footer class="ftco-footer ftco-section">
			  	    <div class="container">
			  	        <div class="row d-flex">
			  	            <div class="col-md">
			  	                <div class="ftco-footer-widget mb-4">
			  	                    <h2 class="ftco-heading-2">Fight D Fear</h2>
			                       <p>Empowering women to stay safe, strong, and supported through awareness, self-defense, and action.</p>
			  	                    <ul class="ftco-footer-social list-unstyled float-lft mt-3">
			  	                        <li class="ftco-animate"><a href="${pageContext.request.contextPath}#"><span class="icon-twitter"></span></a></li>
			  	                        <li class="ftco-animate"><a href="${pageContext.request.contextPath}#"><span class="icon-facebook"></span></a></li>
			  	                        <li class="ftco-animate"><a href="${pageContext.request.contextPath}#"><span class="icon-instagram"></span></a></li>
			  	                    </ul>
			  	                </div>
			  	            </div>
			  	            <div class="col-md">
			  	                <div class="ftco-footer-widget mb-4 ml-md-4">
			  	                    <h2 class="ftco-heading-2">Awareness</h2>
			  	                    <ul class="list-unstyled">
			  	                        <li><a href="${pageContext.request.contextPath}#">Self-Defense Tips</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Emergency Contacts</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Safety Workshops</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Women Helpline</a></li>
			  	                    </ul>
			  	                </div>
			  	            </div>
			  	            <div class="col-md">
			  	                <div class="ftco-footer-widget mb-4">
			  	                    <h2 class="ftco-heading-2">Quick Links</h2>
			  	                    <ul class="list-unstyled">
			  	                        <li><a href="${pageContext.request.contextPath}#">About Us</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Safety Resources</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Community Stories</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Join as Volunteer</a></li>
			  	                        <li><a href="${pageContext.request.contextPath}#">Contact Us</a></li>
			  	                    </ul>
			  	                </div>
			  	            </div>
			  	            <div class="col-md">
			  	                <div class="ftco-footer-widget mb-4">
			  	                    <h2 class="ftco-heading-2">Need Help?</h2>
			  	                    <div class="block-23 mb-3">
			  	                        <ul>
			  	                            <li><span class="icon icon-map-marker"></span><span class="text">203 Safe Haven Street, Hyderabad, India</span></li>
			  	                            <li><a href="${pageContext.request.contextPath}#"><span class="icon icon-phone"></span><span class="text">+91 98765 43210</span></a></li>
			  	                            <li><a href="${pageContext.request.contextPath}#"><span class="icon icon-envelope"></span><span class="text">support@Fight D Fear.org</span></a></li>
			  	                        </ul>
			  	                    </div>
			  	                </div>
			  	            </div>
			  	        </div>
			  	        <div class="row text-center mt-3">
			  	            <div class="col-md-12">
			  	                <p class="mb-0">
			  	                    Copyright &copy;<script>document.write(new Date().getFullYear());</script>
			  	                    All rights reserved by <strong>Affitech</strong> | Powered by <span class="text-danger">Fight The Fire</span>
			  	                </p>
			  	            </div>
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

		    </div>
</div>
</body>
		</html>

