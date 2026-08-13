<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Friends | Fight D Fear</title>
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
			
<style>
body { background: #f8f9fa; }

.container {
  max-width: 720px;
  padding-top: 40px;
}

.friend-row {
  display: flex;
  align-items: center;
  background: #fff;
  padding: 12px 16px;
  border-radius: 14px;
  margin-bottom: 12px;
  transition: background 0.2s, box-shadow 0.2s;
}

.friend-row:hover {
  background: #f1f3f5;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.friend-avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 14px;
  cursor: pointer;
}

.friend-info {
  flex-grow: 1;
  cursor: pointer;
}

.friend-name {
  font-size: 1.05rem;
  font-weight: 600;
}

.friend-actions {
  display: flex;
  gap: 8px;
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
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/user/bookings" class="nav-link">My Bookings</a></li>
				          <li class="nav-item"><a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">Profile</a></li>
		      </ul>
		      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
		    </nav>
		    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
		    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
		  </div>
		</header>
<div class="container">
  <h3 class="mb-4 text-primary">Friends</h3>

  <c:forEach var="f" items="${friends}">
    <div class="friend-row">

      <!-- CLICK HERE → SEND REEL -->
      <img src="${pageContext.request.contextPath}${f.profilePhoto}"
           class="friend-avatar"
           onclick="openSendModal(${f.id}, '${f.fullName}')"
           onerror="this.src='${pageContext.request.contextPath}/images/default-user.png'">

      <div class="friend-info"
           onclick="openSendModal(${f.id}, '${f.fullName}')">
        <div class="friend-name">${f.fullName}</div>
      </div>

      <!-- CHAT + UNFOLLOW -->
      <div class="friend-actions">
        <!-- CHAT WORKS 100% -->
        <a href="${pageContext.request.contextPath}/chat/window/${f.id}"
           class="btn btn-outline-primary btn-sm">
          <i class="bi bi-chat-dots"></i>
        </a>

        <form action="${pageContext.request.contextPath}/users/unfollow/${f.id}" method="post">
          <button class="btn btn-outline-danger btn-sm">
            <i class="bi bi-person-x"></i>
          </button>
        </form>
      </div>

    </div>
  </c:forEach>
</div>

<!-- SEND REEL MODAL -->
<div class="modal fade" id="sendModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Send Reel</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <p id="receiverName"></p>
        <button class="btn btn-primary" onclick="sendReel()">Send</button>
      </div>
    </div>
  </div>
</div>


<script>
let receiverId = null;
let videoId = "${videoId}";

function openSendModal(id, name) {
  receiverId = id;
  document.getElementById("receiverName").innerText =
      "Send this reel to " + name + "?";
  new bootstrap.Modal(document.getElementById("sendModal")).show();
}

function sendReel() {
  fetch("${pageContext.request.contextPath}/users/chat/sendReel", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: "receiverId=" + receiverId + "&videoId=" + videoId
  }).then(() => {
    window.location.href =
      "${pageContext.request.contextPath}/chat/window/" + receiverId;
  });
}
</script>

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


