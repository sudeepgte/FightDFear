<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<title>Share Video</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        background: var(--light-bg);
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 20px;
    }
    .container {
        max-width: 650px;
        margin: auto;
    }
    .card {
        border-radius: 15px;
        border: none;
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.3s ease;
    }
    .card:hover {
        box-shadow: var(--shadow-md);
    }
    h5 {
        font-weight: 600;
        color: var(--dark-bg);
    }
    .share-card {
        display: flex;
        align-items: center;
        border-bottom: 1px solid rgba(123, 44, 191, 0.15);
        padding: 12px 10px;
        transition: all 0.3s ease;
        border-radius: 12px;
    }
    .share-card:hover {
        background-color: rgba(123, 44, 191, 0.05);
        transform: scale(1.02);
    }
    .share-card img {
        width: 55px;
        height: 55px;
        border-radius: 50%;
        border: 2px solid var(--primary-purple-light);
        margin-right: 15px;
        object-fit: cover;
        transition: all 0.3s ease;
    }
    .share-card img:hover {
        transform: rotate(-3deg) scale(1.05);
    }
    .share-card span {
        font-weight: 500;
        color: var(--dark-bg);
    }
    .share-card form {
        margin-left: auto;
    }
    .btn-outline-primary {
        border-radius: 20px;
        padding: 5px 16px;
        transition: all 0.3s ease;
        border: 1px solid var(--primary-purple-light);
        background: transparent;
        color: var(--primary-purple-light);
    }
    .btn-outline-primary:hover {
        background-color: var(--primary-purple-light);
        color: #fff;
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }
    .alert {
        border-radius: 10px;
        font-size: 0.9rem;
        background-color: rgba(255, 215, 0, 0.1);
        border-left: 4px solid var(--primary-gold);
        color: var(--dark-bg);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole page */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Container fade-in with slight slide */
    .container {
        animation: fadeSlideUp 0.4s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-outline-primary {
        position: relative;
        overflow: hidden;
    }
    .btn-outline-primary::after {
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
    .btn-outline-primary:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-outline-primary:focus-visible,
    .share-card:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 12px;
    }

    /* 5. Custom scrollbar (matches brand purple) */
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

    /* 6. Card hover enhancement – subtle scale (preserves original box-shadow) */
    .card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .card:hover {
        transform: translateY(-4px);
    }

    /* 7. Share card image glow on hover (adds to existing rotation/scale) */
    .share-card img {
        transition: transform 0.3s ease, box-shadow 0.2s;
    }
    .share-card img:hover {
        box-shadow: 0 0 0 3px rgba(255,215,0,0.4);
    }

    /* 8. Alert hover effect – subtle background shift */
    .alert {
        transition: background-color 0.2s, transform 0.2s;
    }
    .alert:hover {
        background-color: rgba(255, 215, 0, 0.2);
        transform: translateX(3px);
    }

    /* 9. Responsive improvements for very small screens */
    @media (max-width: 480px) {
        body {
            padding: 12px;
        }
        .share-card {
            padding: 8px 6px;
        }
        .share-card img {
            width: 45px;
            height: 45px;
        }
        .btn-outline-primary {
            padding: 4px 12px;
            font-size: 0.8rem;
        }
        h5 {
            font-size: 1rem;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>

<body class="bg-light p-4">
<div class="container">
  <div class="card p-4 shadow-sm mt-4">
    <h5 class="mb-3 text-center"> Share ${video.title}</h5>

    <c:if test="${param.success == 'true'}">
      <div class="alert alert-success text-center"> Shared successfully!</div>
    </c:if>

    <h6 class="text-muted mb-2 mt-3"> Followers</h6>
    <c:forEach var="follow" items="${user.followers}">
      <div class="share-card">
        <img src="${follow.follower.profilePhoto}" alt="pfp">
        <span>${follow.follower.fullName}</span>
        <form action="${pageContext.request.contextPath}/video/share/send" method="post">
          <input type="hidden" name="videoId" value="${video.id}">
          <input type="hidden" name="receiverId" value="${follow.follower.id}">
          <button type="submit" class="btn btn-outline-primary btn-sm">Send</button>
        </form>
      </div>
    </c:forEach>

    <h6 class="text-muted mt-4 mb-2"> Following</h6>
    <c:forEach var="follow" items="${user.following}">
      <div class="share-card">
        <img src="${follow.followed.profilePhoto}" alt="pfp">
        <span>${follow.followed.fullName}</span>
        <form action="${pageContext.request.contextPath}/video/share/send" method="post">
          <input type="hidden" name="videoId" value="${video.id}">
          <input type="hidden" name="receiverId" value="${follow.followed.id}">
          <button type="submit" class="btn btn-outline-primary btn-sm">Send</button>
        </form>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>
