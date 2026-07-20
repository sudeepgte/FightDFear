<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>User Profile</title>
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap"
	rel="stylesheet">

<!-- Icons & CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css"
	rel="stylesheet">

<!-- 🎨 Custom CSS -->
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

#ftco-navbar {
	background-color: var(--primary-purple) !important;
	box-shadow: var(--shadow-sm);
}

#ftco-navbar .navbar-brand, #ftco-navbar .navbar-brand span {
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

#ftco-navbar .nav-link:hover, #ftco-navbar .nav-item.active .nav-link {
	color: var(--primary-gold) !important;
	background-color: rgba(255, 255, 255, 0.05);
	border-radius: 8px;
}

#ftco-navbar .navbar-toggler {
	border-color: #ffffff;
}

#ftco-navbar .navbar-toggler-icon, #ftco-navbar .oi-menu {
	color: #ffffff;
}

.hero-section::before {
	content: "";
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(255, 215, 0, 0.35);
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
	text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.hero-section p {
	font-size: 1.2rem;
	color: #f8f9fa;
	margin-bottom: 35px;
	max-width: 650px;
	margin-left: auto;
	margin-right: auto;
	text-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
}

.hero-section a.btn-primary {
	background-color: var(--primary-gold);
	border-color: var(--primary-gold);
	color: var(--primary-purple);
	font-weight: 600;
	transition: all 0.3s ease;
}

.hero-section a.btn-primary:hover {
	background-color: #e6c200;
	border-color: #e6c200;
	transform: translateY(-2px);
	box-shadow: var(--shadow-sm);
}

.hero-section a.btn-outline-light:hover {
	background-color: #fff;
	color: var(--primary-gold) !important;
	transform: translateY(-2px);
}

.object-fit-cover {
	object-fit: cover;
}

.bg-gradient-dark {
	background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
}

@media ( max-width : 768px) {
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

.hero-section a.btn-primary, .hero-section a.btn-outline-light {
	animation: fadeInUp 0.8s ease-out 0.3s forwards;
	opacity: 0;
	animation-fill-mode: forwards;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* 2. Button ripple effect on click (micro-interaction) */
.hero-section a.btn-primary, .hero-section a.btn-outline-light {
	position: relative;
	overflow: hidden;
}

.hero-section a.btn-primary::after, .hero-section a.btn-outline-light::after
	{
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

.hero-section a.btn-primary:active::after, .hero-section a.btn-outline-light:active::after
	{
	width: 200px;
	height: 200px;
}

/* 3. Focus outlines for accessibility (keyboard navigation) */
#ftco-navbar .nav-link:focus-visible, .hero-section a:focus-visible {
	outline: 3px solid var(--primary-gold);
	outline-offset: 3px;
	border-radius: 8px;
}

/* 4. Custom scrollbar (matches brand purple/gold) */
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
	background: var(--primary-gold);
}

/* 5. Navbar brand hover effect – subtle text glow */
#ftco-navbar .navbar-brand:hover {
	text-shadow: 0 0 6px rgba(255, 215, 0, 0.5);
	transition: text-shadow 0.2s;
}

/* 6. Additional hover lift for hero buttons (preserves original transform) */
.hero-section a.btn-primary:hover, .hero-section a.btn-outline-light:hover
	{
	transform: translateY(-3px);
}

/* 7. Responsive touch improvements for very small devices */
@media ( max-width : 480px) {
	.hero-section h1 {
		font-size: 1.6rem;
	}
	.hero-section p {
		font-size: 0.9rem;
		padding: 0 15px;
	}
	.hero-section a.btn-primary, .hero-section a.btn-outline-light {
		padding: 8px 16px;
		font-size: 0.9rem;
	}
}

/* 8. Loading skeleton ready (optional – does nothing by default) */
@
keyframes shimmer { 0% {
	background-position: -200% 0;
}

100
%
{
background-position
:
200%
0;
}
}
.hero-section.skeleton .container {
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
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<div
		class="dashboard-bar container-fluid container-xl d-flex justify-content-end">
		<a href="${pageContext.request.contextPath}/users/dashboard"
			class="dashboard-btn"> Dashboard <i class="bi bi-arrow-right"></i>
		</a>
	</div>

	<!-- END nav -->

	<section class="hero-wrap js-fullheight"
		style="background-image: url('${pageContext.request.contextPath}/beauty/images/bg_1.jpg')"
		data-stellar-background-ratio="0.5">
		<div class="overlay"></div>
		<div class="container">
			<div
				class="row no-gutters slider-text js-fullheight align-items-center justify-content-center">
				<div class="col-md-10 ftco-animate text-center">
					<div class="icon">
						<span class="flaticon-lotus"></span>
					</div>
					<h1>${user.fullName}</h1>
					<div class="row justify-content-center">
						<div class="col-md-7 mb-3">
							<p>Manage and update your profile details.</p>
						</div>
					</div>
					<p>
						<a href="${pageContext.request.contextPath}#"
							class="btn btn-primary p-3 px-5 py-4 mr-md-2">Get in Touch</a> <a
							href="${pageContext.request.contextPath}#"
							class="btn btn-outline-primary p-3 px-5 py-4 ml-md-2">Contact</a>
					</p>
				</div>
			</div>
		</div>
	</section>
	<!-- 🌟 User Profile Split Section -->
	<section class="ftco-section user-split-section">
		<div class="container-fluid">
			<div class="row no-gutters align-items-center">
				<div
					class="col-md-6 user-bg-left d-flex justify-content-center align-items-center p-4">
					<img src="${pageContext.request.contextPath}${user.profilePhoto}"
						onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
						alt="User Profile Picture"
						style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #f43f5e; box-shadow: 0 4px 14px rgba(219, 39, 119, 0.35);">
				</div>

				<!-- 📋 Right Side: User Details -->
				<div class="col-md-6 user-details-side d-flex align-items-center">
					<div class="user-details p-5">

						<!-- Header -->
						<div class="heading-section ftcao-animate mb-4">
							<h2 class="mb-2">Hello, ${user.fullName} 👋</h2>

							<!-- 📊 Instagram-style Stats -->
							<div class="d-flex gap-4 my-3 py-2 border-top border-bottom">
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
								<div class="text-center">
									<h5 class="mb-0 fw-bold">${friendsCount != null ? friendsCount : 0}</h5>
									<small class="text-muted">Friends</small>
								</div>
							</div>

							<p class="text-muted">Here’s complete profile overview</p>
							<c:if
								test="${not empty currentUser and currentUser.id ne user.id}">
								<div id="follow-container"
									class="d-flex gap-2 align-items-center">
									<c:choose>
										<c:when test="${isFollowing}">
											<button type="button" class="btn btn-success mt-3 px-4"
												disabled>
												<i class="fas fa-check me-2"></i> Following
											</button>
											<c:if test="${isFriend}">
												<a
													href="${pageContext.request.contextPath}/chat/window/${user.id}"
													class="btn btn-outline-primary mt-3 px-4"> <i
													class="bi bi-chat-dots-fill me-2"></i> Chat
												</a>
											</c:if>
										</c:when>
										<c:when test="${isPending}">
											<button type="button" class="btn btn-warning mt-3 px-4"
												disabled>
												<i class="fas fa-clock me-2"></i> Request Sent
											</button>
										</c:when>
										<c:when test="${hasIncomingRequest}">
											<form
												action="${pageContext.request.contextPath}/users/acceptRequest/${user.id}"
												method="post" style="display: inline;">
												<button type="submit" class="btn btn-success mt-3 px-4">
													<i class="fas fa-check me-2"></i> Accept Request
												</button>
											</form>
											<form
												action="${pageContext.request.contextPath}/users/declineRequest/${user.id}"
												method="post" style="display: inline;">
												<button type="submit"
													class="btn btn-outline-danger mt-3 px-4">
													<i class="fas fa-times me-2"></i> Decline
												</button>
											</form>
										</c:when>
										<c:otherwise>
											<button type="button" id="follow-btn"
												class="btn btn-primary mt-3 px-4"
												onclick="sendFollowRequest(${user.id})">
												<i class="fas fa-user-plus me-2"></i> Follow
											</button>
										</c:otherwise>
									</c:choose>
								</div>
							</c:if>
						</div>

						<!-- Details List -->
						<ul class="list-unstyled ftco-animate">
							<li class="mb-3"><i
								class="fas fa-envelope text-primary me-2"></i> <strong>Email:</strong>
								${user.email}</li>
							<li class="mb-3"><i class="fas fa-phone text-primary me-2"></i>
								<strong>Phone:</strong> ${user.phoneNumber}</li>
							<li class="mb-3"><i class="fas fa-home text-primary me-2"></i>
								<strong>Address:</strong> ${user.homeAddress}</li>
							<li class="mb-3"><i
								class="fas fa-id-badge text-primary me-2"></i> <strong>User
									ID:</strong> ${user.id}</li>
							<li class="mb-3"><i
								class="fas fa-calendar-alt text-primary me-2"></i> <strong>Age:</strong>
								${user.age}</li>
							<li class="mb-3"><i
								class="fas fa-venus-mars text-primary me-2"></i> <strong>Gender:</strong>
								${user.gender}</li>
							<li class="mb-3"><i class="fas fa-file text-primary me-2"></i>
								<strong>ID Document:</strong> <a
								href="${pageContext.request.contextPath}${user.identityDocument}"
								target="_blank" class="text-decoration-none">View</a></li>
						</ul>


					</div>
				</div>

			</div>
		</div>
	</section>
	<!-- 🎥 Profile User Uploaded Videos -->
	<section class="ftco-section">
		<div class="container">

			<div class="row mb-4">
				<div class="col text-center">
					<h3 class="mb-3">Uploaded Videos</h3>
					<p class="text-muted">${user.fullName}'svideos</p>
				</div>
			</div>

			<c:if test="${empty videos}">
				<p class="text-center text-muted">No videos uploaded yet.</p>
			</c:if>

			<div class="row">
				<c:forEach var="video" items="${videos}">
					<div class="col-md-4 col-6 p-1">
						<div class="ratio ratio-1x1 bg-dark"
							style="border-radius: 4px; overflow: hidden; cursor: pointer;">
							<video class="w-100 h-100 object-fit-cover"
								onclick="this.paused ? this.play() : this.pause()">
								<source
									src="${pageContext.request.contextPath}${video.videoPath}"
									type="video/mp4">
							</video>
							<div class="position-absolute top-0 end-0 p-2">
								<c:if
									test="${not empty currentUser and currentUser.id == user.id}">
									<form method="post"
										action="${pageContext.request.contextPath}/video/deleteUpload"
										onsubmit="return confirm('Delete this video?');"
										style="display: inline;">
										<input type="hidden" name="videoId" value="${video.id}">
										<button type="submit"
											class="btn btn-sm btn-danger p-1 opacity-75">
											<i class="bi bi-trash-fill"></i>
										</button>
									</form>
								</c:if>
							</div>
							<div
								class="position-absolute bottom-0 start-0 w-100 p-2 text-white bg-gradient-dark"
								style="background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));">
								<small><i class="bi bi-heart-fill"></i>
									${video.likeCount} • <i class="bi bi-eye-fill"></i>
									${video.viewCount}</small>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

		</div>
	</section>


	<!-- 🌸 Footer -->
	<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

	<!-- Scripts -->
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery-migrate-3.0.1.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/popper.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/bootstrap.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.easing.1.3.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.waypoints.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.stellar.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/owl.carousel.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.magnific-popup.min.js"></script>
	<script src="${pageContext.request.contextPath}/beauty/js/aos.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.animateNumber.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/bootstrap-datepicker.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/jquery.timepicker.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/scrollax.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/beauty/js/google-map.js"></script>
	<script src="${pageContext.request.contextPath}/beauty/js/main.js"></script>

	<script>
					  	function sendFollowRequest(userId) {
					  	    const btn = document.getElementById('follow-btn');
					  	    if (btn) {
					  	        btn.disabled = true;
					  	        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Sending...';
					  	    }
					  	    fetch('${pageContext.request.contextPath}/users/followAjax/' + userId, {
					  	        method: 'POST',
					  	        headers: {
					  	            'Content-Type': 'application/json'
					  	        }
					  	    })
					  	    .then(response => response.json())
					  	    .then(data => {
					  	        const container = document.getElementById('follow-container');
					  	        if (data.status === 'FOLLOWING') {
					  	            let html = '<button type="button" class="btn btn-success mt-3 px-4" disabled><i class="fas fa-check me-2"></i> Following</button>';
					  	            if (data.isFriend) {
					  	                html += '<a href="${pageContext.request.contextPath}/chat/window/' + userId + '" class="btn btn-outline-primary mt-3 px-4 ms-2"><i class="bi bi-chat-dots-fill me-2"></i> Chat</a>';
					  	            }
					  	            container.innerHTML = html;
					  	        } else if (data.status === 'REQUESTED') {
					  	            container.innerHTML = '<button type="button" class="btn btn-warning mt-3 px-4" disabled><i class="fas fa-clock me-2"></i> Request Sent</button>';
					  	        } else if (data.error === 'LOGIN_REQUIRED') {
					  	            alert('Please login to follow users.');
					  	            window.location.href = '${pageContext.request.contextPath}/login';
					  	        } else {
					  	            alert('Failed to send follow request.');
					  	            if (btn) {
					  	                btn.disabled = false;
					  	                btn.innerHTML = '<i class="fas fa-user-plus me-2"></i> Follow';
					  	            }
					  	        }
					  	    })
					  	    .catch(error => {
					  	        console.error('Error:', error);
					  	        alert('An error occurred. Please try again.');
					  	        if (btn) {
					  	            btn.disabled = false;
					  	            btn.innerHTML = '<i class="fas fa-user-plus me-2"></i> Follow';
					  	        }
					  	    });
					  	}
					  	</script>

</body>
</html>

