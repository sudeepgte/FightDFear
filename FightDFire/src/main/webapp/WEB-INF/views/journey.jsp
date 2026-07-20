<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Journey Safety Tracker</title>

  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

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
    }

    body { 
		margin: 0;
		 padding: 0;
		 min-height: 100vh;
		 width: 100%;

		 background: 
		     linear-gradient(rgba(15, 15, 26, 0.9), rgba(124, 45, 94, 0.45)),
		     url('${pageContext.request.contextPath}/assets/img/timer1.jpg');

		 background-size: cover;          /* fills entire screen */
		 background-position: center;     /* center image properly */
		 background-repeat: no-repeat;    /* no repeat */
		 background-attachment: fixed;    /* optional (parallax effect) */

		 font-family: 'Poppins', sans-serif;
		 color: #fff;
    }
    h2, h5 { color: #fff; }
    .muted { color: rgba(255, 255, 255, 0.6) !important; }


    .cardX { 
        background: rgba(15, 5, 10, 0.85); 
        border-radius: 20px; 
        padding: 25px; 
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4); 
        border: 2px solid var(--primary-purple);
        backdrop-filter: blur(15px);
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .cardX:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        border-color: var(--primary-coral);
    }

    .muted { 
        color: rgba(74, 14, 120, 0.6);
    }

    .big { 
        font-size: 1.8rem; 
        font-weight: 800; 
        color: var(--primary-purple);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for body content */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Card image/icon scaling on hover (if any) */
    .cardX img, .cardX i, .cardX svg {
        transition: transform 0.3s ease;
    }
    .cardX:hover img, .cardX:hover i, .cardX:hover svg {
        transform: scale(1.05);
    }

    /* 3. Subtle glow on card hover (adds depth) */
    .cardX {
        position: relative;
        overflow: hidden;
    }
    .cardX::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: var(--gradient-primary);
        transform: scaleX(0);
        transform-origin: left;
        transition: transform 0.3s ease;
    }
    .cardX:hover::before {
        transform: scaleX(1);
    }

    /* 4. Focus outline for accessibility (keyboard navigation) */
    .cardX:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 16px;
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

    /* 6. Hover effect for muted text (adds interactivity) */
    .muted {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    .muted:hover {
        color: var(--primary-purple);
        transform: translateX(2px);
    }
    
    h2, .small.muted {
        color: #fff !important;
        text-shadow: none;
    }
    /* 7. Big text hover effect – subtle scale */
    .big {
        transition: text-shadow 0.2s, transform 0.2s;
        display: inline-block;
    }
    .big:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.2);
        transform: scale(1.01);
    }

    /* 8. Responsive improvements */
    @media (max-width: 768px) {
        .cardX {
            padding: 14px;
        }
        .big {
            font-size: 1.4rem;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .cardX.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-5" style="border-bottom: 1px solid rgba(124, 45, 94, 0.2); padding-bottom: 20px;">
    <div>
      <h1 class="mb-1" style="font-weight: 800; background: var(--gradient-primary); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Journey Tracker</h1>
      <div class="muted">Set an expected arrival time. If you don’t check-in, emergency contacts can be alerted.</div>
    </div>
    <a class="btn" style="border-radius: 50px; background: var(--gradient-primary); color: #fff; padding: 10px 25px; border: none; font-weight: 700; box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);" href="${pageContext.request.contextPath}/users/dashboard">
      <i class="fas fa-arrow-left me-2"></i> Dashboard
    </a>
  </div>

  <div class="row g-4">
    <div class="col-lg-5">
      <div class="cardX">
        <h5 class="mb-3">Start a journey timer</h5>

        <div class="mb-3">
          <label class="form-label">Starting from</label>
          <input id="journeyFrom" class="form-control" maxlength="100" placeholder="Example: College / Office / Gym" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(124,45,94,0.1);">
        </div>

        <div class="mb-3">
          <label class="form-label">Destination</label>
          <input id="journeyDestination" class="form-control" maxlength="100" placeholder="Example: Home / Bus stop / Hostel / MG Road" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(124,45,94,0.1);">
        </div>

        <div class="mb-3">
          <label class="form-label">Expected arrival time</label>
          <input id="journeyExpected" type="datetime-local" class="form-control" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(124,45,94,0.1);">
          <div class="muted small mt-1">You must set a time at least 1 minute in the future.</div>
        </div>

        <div class="d-grid gap-3">
          <button id="journeyStart" class="btn" type="button" 
                  style="background: var(--gradient-primary); color: #fff; padding: 15px; font-weight: 800; border: none; border-radius: 12px; transition: 0.3s; box-shadow: 0 5px 15px rgba(124, 45, 94, 0.4);">
            <i class="fas fa-clock me-2"></i> START TIMER
          </button>
          <button id="journeySafe" class="btn btn-success" type="button" style="border-radius: 12px; padding: 12px; font-weight: 700;">
            <i class="fas fa-check me-2"></i> I’M SAFE (CHECK-IN)
          </button>
          <button id="journeyCancel" class="btn btn-outline-danger" type="button" style="border-radius: 12px; padding: 12px; font-weight: 700;">
            CANCEL TIMER
          </button>
        </div>

        <div id="journeyStatus" class="small muted mt-3"></div>
      </div>


    </div>

    <div class="col-lg-7">
      <div class="cardX">
        <h5 class="mb-3">Active timer</h5>
        <div id="activeBox" class="muted small">Loading…</div>
      </div>
    </div>
  </div>
</div>


<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script>
  // Purpose: JS needs contextPath for API calls in any deployment.
  window.__APP_CTX__ = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/journey.js"></script>

    </div>
</div>
</body>
</html>



