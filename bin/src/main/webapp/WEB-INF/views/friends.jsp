<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Friends | Fight D Fear</title>

<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body {
      background: #f8f9fa;
    }
    .container {
      padding-top: 50px;
    }
    .user-card {
      transition: transform 0.3s, box-shadow 0.3s;
      cursor: pointer;
    }
    .user-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .user-card img {
      transition: transform 0.3s;
    }
    .user-card:hover img {
      transform: scale(1.05);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the container and cards */
    .container {
        animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Staggered animation for user cards (optional, enhances visual flow) */
    .user-card {
        opacity: 0;
        animation: cardFadeIn 0.4s forwards;
    }
    @keyframes cardFadeIn {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    /* Delay each card slightly for cascade effect */
    .user-card:nth-child(1) { animation-delay: 0.05s; }
    .user-card:nth-child(2) { animation-delay: 0.1s; }
    .user-card:nth-child(3) { animation-delay: 0.15s; }
    .user-card:nth-child(4) { animation-delay: 0.2s; }
    .user-card:nth-child(5) { animation-delay: 0.25s; }
    .user-card:nth-child(6) { animation-delay: 0.3s; }

    /* 3. Focus outline for keyboard accessibility (cards are clickable) */
    .user-card:focus-visible {
        outline: 3px solid #ffd700;
        outline-offset: 4px;
        border-radius: 12px;
        transition: outline 0.1s;
    }

    /* 4. Custom scrollbar (matches light theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: #c0c0c0;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #a0a0a0;
    }

    /* 5. Add subtle shadow on card focus and improve hover feedback */
    .user-card:focus {
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        transform: translateY(-5px);
    }

    /* 6. Responsive improvements for mobile */
    @media (max-width: 768px) {
        .container {
            padding-top: 30px;
            padding-left: 15px;
            padding-right: 15px;
        }
        .user-card {
            margin-bottom: 15px;
        }
        .user-card:hover {
            transform: translateY(-3px);
        }
        .user-card:hover img {
            transform: scale(1.02);
        }
    }

    /* 7. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .user-card.skeleton {
        background: linear-gradient(90deg, #e0e0e0 25%, #d0d0d0 50%, #e0e0e0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>

<body>

<div class="container">
  <h2 class="mb-4 text-primary">Friends</h2>

  <div class="row g-4">
    <c:forEach var="f" items="${friends}">
      <div class="col-lg-3 col-md-4 col-sm-6">
        <div class="user-card text-center shadow-sm p-4 bg-white rounded"
             onclick="openSendModal(${f.id}, '${f.fullName}')">

          <!-- PROFILE IMAGE -->
          <img src="${pageContext.request.contextPath}${f.profilePhoto}"
               class="rounded-circle mb-3"
               style="width:90px;height:90px;object-fit:cover;"
               onerror="this.src='${pageContext.request.contextPath}/images/default-user.png'">

          <!-- NAME -->
          <h5 class="mb-3">${f.fullName}</h5>

          <!-- CHAT BUTTON -->
          <a href="${pageContext.request.contextPath}/chat/window/${f.id}"
             class="btn btn-outline-primary btn-sm w-100 mb-2"
             onclick="event.stopPropagation();">
            💬 Chat
          </a>

          <!-- UNFOLLOW -->
          <form action="${pageContext.request.contextPath}/users/unfollow/${f.id}"
                method="post"
                onclick="event.stopPropagation();">
            <button class="btn btn-outline-danger btn-sm w-100">
              ❌ Unfollow
            </button>
          </form>

        </div>
      </div>
    </c:forEach>
  </div>
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

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>


