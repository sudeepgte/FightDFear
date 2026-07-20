<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<title>🔥 Reels</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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

    body {
        background: #ffffff;
        color: #222;
        margin: 0;
        padding: 0;
        overflow-x: hidden;
        font-family: 'Poppins', 'Segoe UI', system-ui, -apple-system, sans-serif;
    }
    .reels-page-shell {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }
    .reels-page-main {
        flex: 1;
        display: flex;
        flex-direction: column;
        min-height: 0;
        position: relative;
    }
    #footer.footer {
        margin-top: auto;
        flex-shrink: 0;
    }
    h3, .reels-wrapper p { color: #222 !important; }

    .reel-caption {
        position: absolute;
        bottom: 20px;
        left: 15px;
        right: 80px;
        font-size: 14px;
        line-height: 1.4;
        z-index: 5;
        text-shadow: 0 1px 3px rgba(0,0,0,0.5);
    }
    .reel-caption strong {
        display: block;
        font-weight: 600;
        color: var(--primary-gold);
    }
    .reel-caption span {
        color: #ddd;
    }

    .reels-wrapper {
        display: flex;
        flex-direction: column;
        align-items: center;
        overflow-y: scroll;
        height: calc(100vh - 200px);
        min-height: 420px;
        scroll-snap-type: y mandatory;
        scroll-behavior: smooth;
        flex: 1;
    }
    .reel-container {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin: 50px 0;
        scroll-snap-align: start;
    }
    .reel {
        position: relative;
        width: 420px;
        height: 700px;
        border-radius: 20px;
        overflow: hidden;
        background: #2D0A1F; /* Deep dark wine background for the card */
        box-shadow: var(--shadow-md);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .reel:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-lg);
    }

    video, .reel-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        cursor: pointer;
        position: relative;
        z-index: 1;
    }
    video {
        pointer-events: auto;
    }

    .profile-bar {
        position: absolute;
        top: 10px;
        left: 15px;
        display: flex;
        align-items: center;
        gap: 10px;
        z-index: 5;
        background: rgba(0,0,0,0.4);
        padding: 5px 12px 5px 5px;
        border-radius: 50px;
        backdrop-filter: blur(4px);
    }
    .profile-bar img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: 2px solid var(--primary-gold);
    }

    .side-actions {
        position: absolute;
        right: 15px;
        bottom: 100px;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 20px;
        z-index: 999;
    }
    .side-actions button {
        background: rgba(0,0,0,0.5);
        backdrop-filter: blur(8px);
        border: none;
        color: white;
        font-size: 28px;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s ease;
        box-shadow: var(--shadow-sm);
    }
    .side-actions button:hover {
        transform: scale(1.1);
        background: var(--primary-purple-light);
        color: var(--primary-gold);
    }
    .side-actions button:active {
        transform: scale(0.95);
    }

    .comment-box {
        width: 360px;
        max-height: 700px;
        background: rgba(15, 15, 26, 0.95);
        backdrop-filter: blur(12px);
        border-radius: 20px;
        padding: 15px;
        display: none;
        overflow-y: auto;
        border: 1px solid rgba(255,255,255,0.1);
        box-shadow: var(--shadow-lg);
    }
    .comment-box.active {
        display: block;
        animation: fadeIn 0.2s ease;
    }
    .comment {
        background: rgba(255,255,255,0.08);
        padding: 10px;
        border-radius: 12px;
        margin: 8px 0;
        color: #eee;
        transition: background 0.2s;
    }
    .comment:hover {
        background: rgba(255,255,255,0.15);
    }

    .like-heart {
        position: absolute;
        top: 50%;
        left: 50%;
        font-size: 100px;
        transform: translate(-50%, -50%) scale(0);
        color: var(--primary-coral);
        opacity: 0;
        transition: transform 0.3s cubic-bezier(0.34, 1.2, 0.64, 1), opacity 0.2s;
        pointer-events: none;
        z-index: 10;
        text-shadow: 0 0 15px rgba(255,107,107,0.5);
    }
    .like-heart.show {
        transform: translate(-50%, -50%) scale(1);
        opacity: 1;
    }

    .tapHint {
        position: absolute;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(0,0,0,0.22);
        opacity: 0;
        transition: 0.2s;
        z-index: 2;
        pointer-events: none;
    }
    .tapHint.show {
        opacity: 1;
        backdrop-filter: blur(2px);
    }

    .modal-content {
        background-color: #fff;
        color: #000;
        border-radius: 20px;
        border: none;
        box-shadow: var(--shadow-lg);
    }
    .modal-content .form-check-label {
        color: #000;
    }

    .coin-wallet-link {
        position: fixed;
        top: 88px;
        right: 20px;
        background: var(--gradient-primary);
        color: white;
        padding: 10px 20px;
        border-radius: 40px;
        z-index: 1000;
        text-decoration: none;
        font-weight: bold;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: var(--shadow-md);
        transition: all 0.3s ease;
        backdrop-filter: blur(4px);
    }
    .coin-wallet-link:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-lg);
        color: var(--primary-gold);
        background: var(--primary-purple);
    }
    .coin-icon-gold {
        color: var(--primary-gold);
        font-size: 20px;
    }

    .create-reel-link {
        position: fixed;
        top: 148px;
        right: 20px;
        background: var(--primary-coral);
        color: white;
        padding: 10px 20px;
        border-radius: 40px;
        z-index: 1000;
        text-decoration: none;
        font-weight: bold;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: var(--shadow-md);
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
    }
    .create-reel-link:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-lg);
        background: var(--primary-coral-dark);
        color: white;
    }
    /* Reel studio modal */
    #reelStudioModal .modal-content {
        border-radius: 20px;
        overflow: hidden;
        border: none;
    }
    #reelStudioModal .modal-header {
        background: var(--gradient-primary);
        color: #fff;
    }
    .reel-camera-wrap {
        position: relative;
        background: #000;
        border-radius: 16px;
        overflow: hidden;
        aspect-ratio: 9 / 16;
        max-height: 55vh;
        margin: 0 auto;
    }
    .reel-camera-wrap video {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }
    .reel-rec-indicator {
        position: absolute;
        top: 12px;
        left: 12px;
        background: rgba(220, 38, 38, 0.9);
        color: #fff;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        display: none;
        align-items: center;
        gap: 6px;
    }
    .reel-rec-indicator.active { display: flex; }
    .reel-rec-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #fff;
        animation: reelPulse 1s infinite;
    }
    @keyframes reelPulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.3; }
    }
    .reel-camera-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        justify-content: center;
        margin-top: 14px;
    }
    .reel-edit-preview {
        filter: var(--reel-filter, none);
    }
    .reel-trim-hint {
        font-size: 0.8rem;
        color: #6b7280;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 768px) {
        body { overflow-x: hidden; }
        .reels-wrapper {
            padding: 0;
            height: calc(100dvh - 180px);
        }
        .reel-container { 
            margin: 0; 
            position: relative; 
            width: 100%; 
            height: calc(100dvh - 180px);
            min-height: 480px;
            overflow: hidden; 
        }
        .reel {
            width: 100%;
            height: calc(100dvh - 180px);
            border-radius: 0;
            box-shadow: none;
            position: absolute;
            top: 0; left: 0;
        }
        .reel:hover {
            transform: none;
        }
        .reel::after {
            display: none;
        }
        .comment-box {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100vw;
            max-height: 60vh;
            z-index: 9999;
            border-radius: 20px 20px 0 0;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.5);
            background: rgba(15, 15, 26, 0.98);
        }
        .side-actions {
            right: 10px;
            bottom: 120px;
            z-index: 9000;
        }
        .side-actions button {
            width: 45px;
            height: 45px;
            font-size: 22px;
        }
        .coin-wallet-link, .create-reel-link {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            backdrop-filter: blur(10px);
            background: rgba(15, 15, 26, 0.4);
            border: 1px solid rgba(255,255,255,0.15);
            color: white;
            z-index: 9999;
        }
        .coin-wallet-link {
            width: auto;
            height: 38px;
            padding: 0 12px;
            border-radius: 30px;
            gap: 6px;
            top: 15px;
            right: 15px;
        }
        .create-reel-link {
            width: 42px;
            height: 42px;
            padding: 0;
            border-radius: 50%;
            top: 65px;
            right: 15px;
            background: rgba(219, 39, 119, 0.6);
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole reels wrapper */
    .reels-wrapper {
        animation: fadeInPage 0.6s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Custom scrollbar for reels wrapper (sleek & modern) */
    .reels-wrapper::-webkit-scrollbar {
        width: 5px;
    }
    .reels-wrapper::-webkit-scrollbar-track {
        background: rgba(255,255,255,0.05);
        border-radius: 10px;
    }
    .reels-wrapper::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
        transition: background 0.2s;
    }
    .reels-wrapper::-webkit-scrollbar-thumb:hover {
        background: var(--primary-gold);
    }

    /* 3. Comment box scrollbar styling */
    .comment-box::-webkit-scrollbar {
        width: 4px;
    }
    .comment-box::-webkit-scrollbar-track {
        background: rgba(255,255,255,0.05);
        border-radius: 10px;
    }
    .comment-box::-webkit-scrollbar-thumb {
        background: var(--primary-coral);
        border-radius: 10px;
    }

    /* 4. Profile avatar hover scale */
    .profile-bar img {
        transition: transform 0.2s ease;
    }
    .profile-bar:hover img {
        transform: scale(1.08);
    }

    /* 5. Side actions button glow on hover */
    .side-actions button:hover {
        box-shadow: 0 0 12px var(--primary-gold), var(--shadow-sm);
    }

    /* 6. Focus outlines for accessibility (keyboard navigation) */
    .side-actions button:focus-visible,
    .coin-wallet-link:focus-visible,
    .create-reel-link:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 40px;
    }

    /* 7. Gradient border on reel hover (inner glow) */
    .reel::after {
        content: '';
        position: absolute;
        inset: 0;
        border-radius: 20px;
        padding: 2px;
        background: linear-gradient(145deg, rgba(255,215,0,0.3), transparent);
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        pointer-events: none;
        z-index: 3;
        opacity: 0;
        transition: opacity 0.3s;
    }
    .reel:hover::after {
        opacity: 1;
    }

    /* 8. Gentle pulse animation for coin wallet link (attracts attention) */
    .coin-wallet-link {
        animation: gentlePulse 2s infinite;
    }
    @keyframes gentlePulse {
        0% { box-shadow: 0 0 0 0 rgba(255,215,0,0.4); }
        70% { box-shadow: 0 0 0 8px rgba(255,215,0,0); }
        100% { box-shadow: 0 0 0 0 rgba(255,215,0,0); }
    }
    .coin-wallet-link:hover {
        animation: none;
    }

    /* 9. Tap hint pulse animation */
    .tapHint.show {
        animation: tapPulse 0.3s ease-out;
    }
    @keyframes tapPulse {
        0% { backdrop-filter: blur(2px); opacity: 0; }
        50% { backdrop-filter: blur(8px); opacity: 0.8; }
        100% { backdrop-filter: blur(2px); opacity: 1; }
    }

    /* 10. Video fade-in on load */
    video {
        animation: subtleFadeIn 0.4s ease;
    }
    @keyframes subtleFadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 11. Responsive refinements for very small devices (≤480px) */
    @media (max-width: 480px) {
        .side-actions button {
            width: 40px;
            height: 40px;
            font-size: 20px;
        }
        .profile-bar {
            padding: 3px 8px 3px 3px;
            top: 15px;
            left: 15px;
        }
        .profile-bar img {
            width: 32px;
            height: 32px;
        }
        .reel-caption {
            font-size: 13px;
            bottom: 30px;
            left: 15px;
            right: 60px;
        }
    }

    /* 12. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .reel.skeleton {
        background: linear-gradient(90deg, #2a2a2a 25%, #3a3a3a 50%, #2a2a2a 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>

<body class="reels-page-shell">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">


<main class="reels-page-main">

<a href="${pageContext.request.contextPath}/users/wallet" class="coin-wallet-link">
    <i class="bi bi-coin coin-icon-gold"></i>
    <span class="d-none d-md-inline"><span id="user-reward-points">${user.rewardPoints != null ? user.rewardPoints : 0}</span> Coins 💰</span>
    <span class="d-inline d-md-none ms-1 fw-bold">${user.rewardPoints != null ? user.rewardPoints : 0}</span>
</a>

<button type="button" class="create-reel-link" id="openReelStudioBtn" data-bs-toggle="modal" data-bs-target="#reelStudioModal">
    <i class="bi bi-camera-video-fill"></i> <span class="d-none d-md-inline">Create Reel</span>
</button>

<div class="reels-wrapper">

<c:if test="${empty videos}">
  <div style="display:flex; justify-content:center; align-items:center; min-height:80vh;">
    <div style="
      background: #fff;
      border: 2px solid #c2185b;
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(194,24,91,0.15);
      padding: 50px 60px;
      text-align: center;
      max-width: 480px;
      width: 90%;
    ">
      <div style="font-size: 60px; margin-bottom: 16px;">🎬</div>
      <h3 style="color:#1e1b4b; font-weight:800; margin-bottom:10px; font-size:1.6rem;">No reels yet</h3>
      <p style="color:#312e81; margin-bottom:28px; font-size:1rem;">
        Upload a reel first, then come back to Reels.
      </p>
      <div style="display:flex; gap:12px; justify-content:center;">
        <button type="button" class="btn" data-bs-toggle="modal" data-bs-target="#reelStudioModal"
           style="background:linear-gradient(135deg,#1e1b4b,#f43f5e); color:white; border:none; padding:10px 28px; border-radius:30px; font-weight:700; font-size:0.95rem;">
          Shoot Reel
        </button>
        <a href="${pageContext.request.contextPath}/users/dashboard"
           style="border:2px solid #c2185b; color:#c2185b; padding:10px 28px; border-radius:30px; font-weight:700; text-decoration:none; font-size:0.95rem;">
          Back
        </a>
      </div>
    </div>
  </div>
</c:if>

<c:forEach var="video" items="${videos}">
  <div class="reel-container">

    <!-- Reel -->
    <div class="reel">

      <!-- Profile -->
 <div class="profile-bar">
  <a href="${pageContext.request.contextPath}/users/profile1/${video.user.id}"
     style="text-decoration:none; color:white; display:flex; align-items:center; gap:10px;">
     
    <img src="${pageContext.request.contextPath}${video.user.profilePhoto}">
    <span>${video.user.fullName}</span>
  </a>
  
  <c:if test="${video.user.id != currentUser.id}">
      <c:set var="status" value="${followStatusMap[video.user.id]}" />
      <button id="follow-btn-${video.user.id}" 
              class="btn btn-sm ${status == 'FOLLOW' ? 'btn-danger' : 'btn-outline-light'}"
              style="border-radius:20px; font-weight:bold; margin-left:10px;"
              onclick="followCreator(${video.user.id})"
              ${status != 'FOLLOW' ? 'disabled' : ''}>
          <c:choose>
              <c:when test="${status == 'FOLLOWING'}">Following</c:when>
              <c:when test="${status == 'REQUESTED'}">Requested</c:when>
              <c:otherwise>Follow</c:otherwise>
          </c:choose>
      </button>
  </c:if>
</div>



   <c:choose>
 <c:when test="${video.videoPath.endsWith('.mp4') || video.videoPath.endsWith('.webm')}">
    <video muted playsinline data-video-id="${video.id}">
        <source src="${pageContext.request.contextPath}${video.videoPath}">
    </video>
</c:when>

    <c:otherwise>
        <img src="${pageContext.request.contextPath}${video.videoPath}"
             class="reel-image">
    </c:otherwise>
</c:choose>




<div class="reel-caption">
    <strong>${video.user.fullName}</strong>
    <span>${video.description}</span>
</div>

      <!-- Heart -->
      <div class="like-heart" id="heart-${video.id}">❤</div>
      <div class="tapHint" id="hint-${video.id}">Tap to play</div>

      <!-- Side actions -->
      <div class="side-actions">
     <button onclick="likeVideo(${video.id}, this)">
  <i class="bi bi-heart-fill"
     style="color:${video.likedByCurrentUser ? 'red' : 'white'}"></i>
</button>

<small class="like-count">${video.likeCount}</small>

<small class="view-count" id="view-count-${video.id}">
  👁 ${video.viewCount}
</small>

        <button onclick="toggleComments(${video.id})">
          <i class="bi bi-chat-dots-fill"></i>
        </button>
        <button type="button" class="btn btn-sm" style="background: rgba(0,0,0,0.5); border: none; color: white;" onclick="toggleMute(${video.id}, this)">
            <i class="bi bi-volume-mute-fill"></i>
        </button>
        <button type="button"
        class="btn btn-sm"
        style="background: rgba(0,0,0,0.5); border: none; color: white;"
        onclick="openReportModal(${video.id})">
    🚩
</button>
<small class="d-none d-md-block text-center mt-1" style="font-size:10px; color:#ddd;">Report</small>
       
        
<!-- SHARE -->
 <%-- <button onclick="shareVideo('${pageContext.request.contextPath}${video.videoPath}', '${video.user.fullName}')">
  <i class="bi bi-share-fill"></i>
</button> 
<c:if test="${not empty currentUser}">
    <a href="${pageContext.request.contextPath}/users/searchs/${currentUser.id}?videoId=${video.id}" 
       class="btn btn-outline-light btn-sm">
       Share to Friend
    </a>
</c:if>

<c:if test="${empty currentUser}">
    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm">
       Please login to share
    </a>
</c:if> --%>

  
      <!--   <button>
          <i class="bi bi-share-fill"></i>
        </button> -->
      </div>
    </div>

    <!-- Comments -->
    <div class="comment-box" id="comment-box-${video.id}">
      <h5>Comments</h5>

      <div id="comments-${video.id}">
  <c:forEach var="comment" items="${video.comments}">
    <c:if test="${comment.parent == null}">
      
      <!-- Parent Comment -->
      <div class="comment" id="comment-${comment.id}">
        <strong>${comment.user.fullName}:</strong> ${comment.text}

        <div>
      



        </div>

        <!-- Replies -->
<div id="replies-${comment.id}" style="margin-left:20px; margin-top:5px;">
  <c:forEach var="reply" items="${comment.replies}">
    <div class="comment" style="background:#333; margin-top:3px;">
      <strong>${reply.user.fullName}:</strong> ${reply.text}
    </div>
  </c:forEach>
</div>

<!-- Reply + Share buttons -->
<div style="margin-top:5px;">
  <!-- Reply Button -->
  <button type="button" class="btn btn-sm btn-outline-light"
          onclick="showReplyBox(${video.id}, ${comment.id}, '${comment.user.fullName}')">
      Reply
  </button>

  <!-- Share to Friend button -->

</div>


<!-- Reply Input (hidden initially) -->
<div id="reply-box-${comment.id}" style="display:none; margin-top:5px;">
  <form onsubmit="postReply(event, ${video.id}, ${comment.id})" class="d-flex">
    <input type="text"
           id="reply-input-${comment.id}"
           class="form-control me-2"
           placeholder="Reply..."
           required>
    <button type="submit" class="btn btn-danger btn-sm">Send</button>
  </form>
</div>

      </div>

    </c:if>
  </c:forEach>
</div>


      <form onsubmit="postComment(event, ${video.id})" class="d-flex mt-2">
        <input type="text" id="comment-input-${video.id}" class="form-control me-2" placeholder="Add a comment..." required>
        <button class="btn btn-danger"><i class="bi bi-send"></i></button>
      </form>
    </div>

  </div>
</c:forEach>

</div>
<!-- Report Modal -->

<script>
function toggleComments(id) {
  document.getElementById("comment-box-" + id).classList.toggle("active");
}

function toggleMute(videoId, btn) {
    const video = document.querySelector(`video[data-video-id='${videoId}']`);
    if (!video) return;
    
    // Toggle the specific video
    if (video.muted) {
        video.muted = false;
        btn.innerHTML = '<i class="bi bi-volume-up-fill"></i>';
        
        // Also unmute all other videos so as you scroll, sound stays on
        document.querySelectorAll('video').forEach(v => {
            v.muted = false;
        });
        document.querySelectorAll('.bi-volume-mute-fill').forEach(icon => {
            icon.classList.remove('bi-volume-mute-fill');
            icon.classList.add('bi-volume-up-fill');
        });
    } else {
        video.muted = true;
        btn.innerHTML = '<i class="bi bi-volume-mute-fill"></i>';
        
        // Mute all videos
        document.querySelectorAll('video').forEach(v => {
            v.muted = true;
        });
        document.querySelectorAll('.bi-volume-up-fill').forEach(icon => {
            icon.classList.remove('bi-volume-up-fill');
            icon.classList.add('bi-volume-mute-fill');
        });
    }
}

function followCreator(creatorId) {
    const btn = document.getElementById("follow-btn-" + creatorId);
    if (!btn || btn.disabled) return;

    fetch("${pageContext.request.contextPath}/users/followAjax/" + creatorId, {
        method: "POST"
    })
    .then(res => res.json())
    .then(data => {
        if (data.error === "LOGIN_REQUIRED") {
            alert("Please login to follow creators");
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }

        if (data.status === "FOLLOWING") {
            btn.innerText = "Following";
            btn.classList.remove("btn-danger");
            btn.classList.add("btn-outline-light");
            btn.disabled = true;
        } else if (data.status === "REQUESTED") {
            btn.innerText = "Requested";
            btn.classList.remove("btn-danger");
            btn.classList.add("btn-outline-light");
            btn.disabled = true;
        }
    })
    .catch(err => console.error(err));
}

function likeVideo(videoId, btn) {
	  fetch("${pageContext.request.contextPath}/video/video/like", {
	    method: "POST",
	    headers: { "Content-Type": "application/x-www-form-urlencoded" },
	    body: "videoId=" + videoId
	  })
	  .then(res => res.json())
	  .then(data => {

	    if (data.error === "LOGIN_REQUIRED") {
	      alert("Please login to like");
	      return;
	    }

	    const icon = btn.querySelector("i");
	    const countEl = btn.nextElementSibling;

	    // ❤️ liked
	    if (data.liked) {
	      icon.style.color = "red";
	    } else {
	      icon.style.color = "white";
	    }

	    countEl.innerText = data.likeCount;
	  })
	  .catch(err => console.error(err));
	}

/* Double tap like */
document.querySelectorAll("video").forEach(v => {
  let last = 0;
  v.onclick = () => {
    const now = Date.now();
    if (now - last < 400) {
      const id = v.dataset.id;
      document.getElementById("heart-" + id).classList.add("show");
      setTimeout(() => document.getElementById("heart-" + id).classList.remove("show"), 600);
      v.closest(".reel").querySelector("button").click();
    }
    last = now;
  };
});



function showReplyBox(videoId, commentId, userName) {
	  const box = document.getElementById("reply-box-" + commentId);
	  box.style.display = "block";

	  const input = document.getElementById("reply-input-" + commentId);
	  input.value = "@" + userName + " ";
	  input.focus();
	}

	function postReply(e, videoId, parentId) {
	  e.preventDefault();

	  const input = document.getElementById("reply-input-" + parentId);
	  const text = input.value;

	  fetch("${pageContext.request.contextPath}/video/comment", {
	    method: "POST",
	    headers: { "Content-Type": "application/x-www-form-urlencoded" },
	    body:
	      "videoId=" + videoId +
	      "&commentText=" + encodeURIComponent(text) +
	      "&parentId=" + parentId
	  })
	  .then(res => res.json())
	  .then(data => {
		    // Determine user name correctly
		    const userName = data.user || "${currentUser.fullName}" || "Unknown";

		    // Append reply to the correct replies container
		    const repliesContainer = document.getElementById("replies-" + parentId);
		    const replyDiv = document.createElement("div");
		    replyDiv.className = "comment";
            replyDiv.style.background = "#333";
            replyDiv.style.marginTop = "3px";
		    replyDiv.innerHTML = `<strong>${userName}:</strong> ${data.text}`;

		    repliesContainer.appendChild(replyDiv);
		    input.value = "";
            document.getElementById("reply-box-" + parentId).style.display = "none";
		});
	}

</script>

<!-- TikTok-like autoplay/pause on scroll -->
<script>
  (function(){
    const videos = Array.from(document.querySelectorAll("video[data-video-id]"));
    const hints = new Map();
    videos.forEach(v => {
      const id = v.dataset.videoId;
      hints.set(v, document.getElementById("hint-" + id));
      v.addEventListener("click", () => {
        if (v.paused) v.play().catch(()=>{});
        else v.pause();
      });
    });

    function showHint(v, show){
      const h = hints.get(v);
      if (!h) return;
      if (show) h.classList.add("show");
      else h.classList.remove("show");
    }

    const obs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        const v = entry.target;
        if (entry.isIntersecting && entry.intersectionRatio > 0.75) {
          videos.forEach(o => { if (o !== v) { o.pause(); showHint(o, true); } });
          v.play().then(()=>showHint(v,false)).catch(()=>showHint(v,true));
        } else if (!entry.isIntersecting) {
          v.pause();
          showHint(v, true);
        }
      });
    }, { threshold: [0.25, 0.5, 0.75, 0.9] });

    videos.forEach(v => obs.observe(v));
    videos.forEach(v => showHint(v, true));
  })();
</script>
<script>
function shareVideo(videoUrl, userName) {
    const fullVideoUrl = window.location.origin + videoUrl; // Full absolute URL

    const shareData = {
        title: `Check out this video by ${userName}`,
        text: `Watch this reel by ${userName}!`,
        url: fullVideoUrl
    };

    if (navigator.share) {
        // Mobile: open native share dialog
        navigator.share(shareData)
            .then(() => console.log('Shared successfully'))
            .catch(err => console.error('Error sharing:', err));
    } else {
        // Desktop: show clickable link
        let container = document.getElementById("desktop-share-container");
        if (!container) {
            container = document.createElement("div");
            container.id = "desktop-share-container";
            container.style.position = "fixed";
            container.style.bottom = "20px";
            container.style.right = "20px";
            container.style.background = "#111";
            container.style.color = "white";
            container.style.padding = "10px";
            container.style.borderRadius = "8px";
            container.style.boxShadow = "0 0 10px rgba(0,0,0,0.5)";
            document.body.appendChild(container);
        }

        container.innerHTML = ""; // clear previous

        const link = document.createElement("a");
        link.href = fullVideoUrl;
        link.target = "_blank"; // open in new tab
        link.style.color = "#0d6efd";
        link.style.textDecoration = "underline";
        link.innerText = "Click here to watch the video";

        container.appendChild(link);

        // Optionally copy to clipboard
        copyToClipboard(fullVideoUrl);
    }
}

function copyToClipboard(text) {
    const tempInput = document.createElement('input');
    document.body.appendChild(tempInput);
    tempInput.value = text;
    tempInput.select();
    document.execCommand('copy');
    document.body.removeChild(tempInput);
}
</script>
<script>
function shareVideoToUser(videoId, receiverId) {
    fetch('${pageContext.request.contextPath}/chat/share/send', {
        method: 'POST',
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "videoId=" + videoId + "&receiverId=" + receiverId
    })
    .then(() => alert("Video sent to chat!"))
    .catch(err => console.error(err));
}
</script>
<c:choose>
  <c:when test="${not empty currentUser}">
    <script>
      // External share button
      function shareVideo(videoUrl, userName) {
          const fullVideoUrl = window.location.origin + videoUrl;

          const shareData = {
              title: `Check out this video by ${userName}`,
              text: `Watch this reel by ${userName}!`,
              url: fullVideoUrl
          };

          if (navigator.share) {
              navigator.share(shareData)
                  .then(() => console.log('Shared successfully'))
                  .catch(err => console.error('Error sharing:', err));
          } else {
              let container = document.getElementById("desktop-share-container");
              if (!container) {
                  container = document.createElement("div");
                  container.id = "desktop-share-container";
                  container.style.position = "fixed";
                  container.style.bottom = "20px";
                  container.style.right = "20px";
                  container.style.background = "#111";
                  container.style.color = "white";
                  container.style.padding = "10px";
                  container.style.borderRadius = "8px";
                  container.style.boxShadow = "0 0 10px rgba(0,0,0,0.5)";
                  document.body.appendChild(container);
              }

              container.innerHTML = "";
              const link = document.createElement("a");
              link.href = fullVideoUrl;
              link.target = "_blank";
              link.style.color = "#0d6efd";
              link.style.textDecoration = "underline";
              link.innerText = "Click here to watch the video";
              container.appendChild(link);

              copyToClipboard(fullVideoUrl);
          }
      }

      // Copy helper
      function copyToClipboard(text) {
          const tempInput = document.createElement('input');
          document.body.appendChild(tempInput);
          tempInput.value = text;
          tempInput.select();
          document.execCommand('copy');
          document.body.removeChild(tempInput);
      }

      // Share to friend button
      function shareToFriend(videoId) {
          const currentUserId = ${currentUser.id};
          window.location.href = `${window.location.origin}${'${pageContext.request.contextPath}'}/searchs/${currentUserId}?videoId=${videoId}`;
      }
    </script>
  </c:when>

  <c:otherwise>
    <script>
      function shareVideo(videoUrl, userName) {
          alert("Please login first to share!");
      }
      function shareToFriend(videoId) {
          alert("Please login first to share!");
      }
    </script>
  </c:otherwise>
</c:choose>
<script>
const viewedVideos = new Set();

document.querySelectorAll("video").forEach(video => {

  let timerStarted = false;
  let timeoutId;

  video.addEventListener("play", () => {

    if (timerStarted) return;

    timerStarted = true;

    timeoutId = setTimeout(() => {
      const videoId = video.dataset.videoId;

      if (viewedVideos.has(videoId)) return;

      fetch("${pageContext.request.contextPath}/video/view", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "videoId=" + videoId
      })
      .then(res => res.json())
      .then(data => {
        if (data.viewed) {
          viewedVideos.add(videoId);
          document.getElementById("view-count-" + videoId).innerText =
            "👁 " + data.viewCount;
          
          // Update coins display
          if (data.rewardPoints !== undefined) {
            document.getElementById("user-reward-points").innerText = data.rewardPoints;
          }
        }
      });

    }, 3000); // ⏱ 3 seconds
  });

  video.addEventListener("pause", () => {
    clearTimeout(timeoutId);
    timerStarted = false;
  });

});
</script>

<!-- 🔴 Real-time reels updates via WebSocket -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
  (function () {
    const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
    const client = Stomp.over(socket);
    client.debug = null; // keep console clean

    client.connect({}, function () {
      client.subscribe("/topic/reels", function (frame) {
        try {
          const evt = JSON.parse(frame.body || "{}");
          if (!evt || !evt.type) return;

          if (evt.type === "NEW_UPLOAD") {
            // simplest reliable behavior: reload feed to include new video
            window.location.reload();
            return;
          }

          if (evt.type === "LIKE_UPDATED") {
            const btn = document.querySelector('button[onclick="likeVideo(' + evt.videoId + ', this)"]');
            if (!btn) return;
            const countEl = btn.nextElementSibling;
            if (countEl && countEl.classList.contains("like-count")) {
              countEl.innerText = evt.likeCount;
            }
            return;
          }

          if (evt.type === "VIEW_UPDATED") {
            const viewEl = document.getElementById("view-count-" + evt.videoId);
            if (viewEl) viewEl.innerText = "👁 " + evt.viewCount;
            return;
          }

          if (evt.type === "COMMENT_ADDED") {
            // comment counts are not displayed; no action needed
            return;
          }
        } catch (e) {
          // ignore
        }
      });
    });
  })();
</script>
<script>
function postComment(e, videoId) {
    e.preventDefault();

    const input = document.getElementById("comment-input-" + videoId);
    const text = input.value.trim();
    if (!text) return;

    // Use current logged-in user's name from JSP
    const userName = "${currentUser.fullName}";

    // Append the comment immediately to the DOM
    const commentContainer = document.getElementById("comments-" + videoId);

    const commentId = 'c-' + Date.now(); // temporary ID for new comment
    const commentDiv = document.createElement("div");
    commentDiv.className = "comment";
    commentDiv.id = "comment-" + commentId;
    commentDiv.innerHTML = `
        <strong>${userName}:</strong> ${text}
        <div id="replies-${commentId}" style="margin-left:20px; margin-top:5px;"></div>
        <div style="margin-top:5px;">
            <button type="button" class="btn btn-sm btn-outline-light"
                onclick="showReplyBox(${videoId}, '${commentId}', '${userName}')">
                Reply
            </button>
        </div>
        <div id="reply-box-${commentId}" style="display:none; margin-top:5px;">
            <form onsubmit="postReply(event, ${videoId}, '${commentId}')" class="d-flex">
                <input type="text"
                    id="reply-input-${commentId}"
                    class="form-control me-2"
                    placeholder="Reply..."
                    required>
                <button type="submit" class="btn btn-danger btn-sm">Send</button>
            </form>
        </div>
    `;

    commentContainer.appendChild(commentDiv);

    input.value = ""; // clear input

    // Send to backend
    fetch("${pageContext.request.contextPath}/video/comment", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "videoId=" + videoId + "&commentText=" + encodeURIComponent(text)
    })
    .then(res => res.json())
    .then(data => {
        // Optionally update the temporary comment ID with the real backend ID
        if (data.id) {
            commentDiv.id = "comment-" + data.id;
            const repliesDiv = commentDiv.querySelector('[id^="replies-"]');
            if (repliesDiv) repliesDiv.id = "replies-" + data.id;
            const replyBox = commentDiv.querySelector('[id^="reply-box-"]');
            if (replyBox) replyBox.id = "reply-box-" + data.id;
            const replyInput = commentDiv.querySelector('[id^="reply-input-"]');
            if (replyInput) replyInput.id = "reply-input-" + data.id;
            const replyBtn = commentDiv.querySelector('button[onclick^="showReplyBox"]');
            if (replyBtn) replyBtn.setAttribute('onclick', `showReplyBox(${videoId}, '${data.id}', '${userName}')`);
            const replyForm = commentDiv.querySelector('form[onsubmit^="postReply"]');
            if (replyForm) replyForm.setAttribute('onsubmit', `postReply(event, ${videoId}, '${data.id}')`);
        }
    })
    .catch(err => console.error(err));
}
</script>

<script>
function submitReport() {
    const videoId = document.getElementById("reportVideoId").value;
    const reasonEl = document.querySelector('input[name="reportReason"]:checked');

    if (!reasonEl) {
        alert("Please select a reason");
        return;
    }

    fetch("${pageContext.request.contextPath}/video/video/report", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "videoId=" + videoId + "&reason=" + encodeURIComponent(reasonEl.value)
    })
    .then(res => res.text())
    .then(data => {
        if(data === "SUCCESS") {
            alert("Report submitted successfully");
            const modalEl = document.getElementById("reportModal");
            const bsModal = bootstrap.Modal.getInstance(modalEl);
            if(bsModal) bsModal.hide();
        } else if(data === "LOGIN_REQUIRED") {
            alert("Please login to report");
        } else if(data === "VIDEO_NOT_FOUND") {
            alert("Video not found");
        } else {
            alert("Error submitting report");
        }
    })
    .catch(err => console.error(err));
}

</script>
<!-- Bootstrap FIRST -->
<!-- THEN modal JS -->
<script>
let reportModal;

function openReportModal(videoId) {

    if (typeof bootstrap === "undefined") {
        alert("Bootstrap not loaded");
        return;
    }

    document.getElementById("reportVideoId").value = videoId;

    document
        .querySelectorAll('input[name="reportReason"]')
        .forEach(r => r.checked = false);

    const modalEl = document.getElementById("reportModal");
    reportModal = bootstrap.Modal.getOrCreateInstance(modalEl);
    reportModal.show();
}
</script>


<!-- Report Modal -->
<div class="modal fade" id="reportModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">Report Video</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <form id="reportForm">
          <input type="hidden" id="reportVideoId">

          <div class="form-check">
            <input class="form-check-input" type="radio" name="reportReason" value="NOT_GOOD_CONTENT">
            <label class="form-check-label">Not good content</label>
          </div>

          <div class="form-check">
            <input class="form-check-input" type="radio" name="reportReason" value="SPAM_OR_MISLEADING">
            <label class="form-check-label">Spam or misleading</label>
          </div>

          <div class="form-check">
            <input class="form-check-input" type="radio" name="reportReason" value="HARASSMENT_OR_HATE">
            <label class="form-check-label">Harassment or hate</label>
          </div>

          <div class="form-check">
            <input class="form-check-input" type="radio" name="reportReason" value="SEXUAL_OR_VIOLENCE">
            <label class="form-check-label">Sexual or violent</label>
          </div>
        </form>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button class="btn btn-danger" onclick="submitReport()">Submit</button>
      </div>

    </div>
  </div>
</div>

</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<!-- Reel Studio: camera + edit + upload -->
<div class="modal fade" id="reelStudioModal" tabindex="-1" aria-labelledby="reelStudioModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="reelStudioModalLabel"><i class="bi bi-camera-reels me-2"></i>Create Reel</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <ul class="nav nav-pills nav-fill mb-3" id="reelStudioTabs" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="tab-record" data-bs-toggle="pill" data-bs-target="#pane-record" type="button">Record</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="tab-upload" data-bs-toggle="pill" data-bs-target="#pane-upload" type="button">Upload file</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link disabled" id="tab-edit" data-bs-toggle="pill" data-bs-target="#pane-edit" type="button" disabled>Edit</button>
          </li>
        </ul>

        <div class="tab-content">
          <div class="tab-pane fade show active" id="pane-record" role="tabpanel">
            <div class="reel-camera-wrap">
              <video id="reelLiveVideo" autoplay playsinline muted></video>
              <div class="reel-rec-indicator" id="reelRecIndicator"><span class="reel-rec-dot"></span> REC <span id="reelRecTimer">0:00</span></div>
            </div>
            <div class="reel-camera-actions">
              <button type="button" class="btn btn-outline-secondary btn-sm" id="reelFlipCameraBtn"><i class="bi bi-arrow-repeat"></i> Flip</button>
              <button type="button" class="btn btn-danger" id="reelRecordBtn"><i class="bi bi-record-circle"></i> Start recording</button>
              <button type="button" class="btn btn-secondary d-none" id="reelStopBtn"><i class="bi bi-stop-fill"></i> Stop</button>
            </div>
            <p class="text-muted small text-center mt-2 mb-0">Max 60 seconds. Allow camera access when prompted.</p>
          </div>

          <div class="tab-pane fade" id="pane-upload" role="tabpanel">
            <label class="form-label fw-semibold">Choose a video from your device</label>
            <input type="file" class="form-control" id="reelFileInput" accept="video/*,image/*">
            <p class="text-muted small mt-2 mb-0">MP4, WEBM, or image for a photo reel.</p>
          </div>

          <div class="tab-pane fade" id="pane-edit" role="tabpanel">
            <div class="reel-camera-wrap">
              <video id="reelEditVideo" class="reel-edit-preview" playsinline controls></video>
            </div>
            <div class="row g-2 mt-2">
              <div class="col-md-6">
                <label class="form-label fw-semibold">Title</label>
                <input type="text" class="form-control" id="reelTitle" maxlength="80" placeholder="Reel title" required>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Category</label>
                <select class="form-select" id="reelCategory">
                  <option value="WOMEN_SAFETY">Women Safety</option>
                  <option value="SELF_DEFENSE">Self Defense</option>
                  <option value="AWARENESS">Awareness</option>
                  <option value="COMMUNITY_STORIES">Community Stories</option>
                  <option value="FITNESS">Fitness & Health</option>
                </select>
              </div>
              <div class="col-12">
                <label class="form-label fw-semibold">Caption</label>
                <textarea class="form-control" id="reelDescription" rows="2" maxlength="500" placeholder="Optional caption"></textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Filter</label>
                <select class="form-select" id="reelFilter">
                  <option value="none">Original</option>
                  <option value="brightness(1.08) contrast(1.1) saturate(1.2)">Vivid</option>
                  <option value="sepia(0.35) saturate(1.3)">Warm</option>
                  <option value="hue-rotate(180deg) saturate(0.9)">Cool</option>
                  <option value="grayscale(1) contrast(1.05)">Black & White</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Trim clip</label>
                <div class="d-flex gap-2 align-items-center">
                  <input type="range" class="form-range flex-grow-1" id="reelTrimStart" min="0" max="60" value="0" step="0.1">
                  <input type="range" class="form-range flex-grow-1" id="reelTrimEnd" min="0" max="60" value="60" step="0.1">
                </div>
                <p class="reel-trim-hint mb-0">Start: <span id="reelTrimStartLbl">0s</span> — End: <span id="reelTrimEndLbl">60s</span></p>
              </div>
            </div>
            <div class="reel-camera-actions mt-3">
              <button type="button" class="btn btn-outline-secondary" id="reelRetakeBtn"><i class="bi bi-arrow-counterclockwise"></i> Retake</button>
              <button type="button" class="btn btn-primary" id="reelPublishBtn"><i class="bi bi-cloud-upload"></i> Post reel</button>
            </div>
            <div class="progress mt-2 d-none" id="reelUploadProgressWrap" style="height:8px;">
              <div class="progress-bar" id="reelUploadProgressBar" style="width:0%"></div>
            </div>
            <div id="reelStudioAlert" class="mt-2"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>window.REEL_STUDIO_CTX = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/reel-studio.js"></script>
    </div>
</div>
</body>
</html>


