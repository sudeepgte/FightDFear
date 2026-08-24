<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Buddy Mode</title>

  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <!-- Purpose: global typography used by assets/css/main.css -->
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
        background: linear-gradient(rgba(15, 15, 26, 0.85), rgba(124, 45, 94, 0.4)), url('${pageContext.request.contextPath}/assets/img/connect-collage1.jpg');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        min-height: 100vh;
        margin: 0;
        font-family: 'Poppins', sans-serif;
        color: #fff;
        overflow-x: clip;
    }
    h2, h5 { color: #fff; }
    .muted, .text-muted { color: rgba(255, 255, 255, 0.7) !important; }
    #incomingList .text-muted, #outgoingList .text-muted { 
        color: var(--primary-coral) !important; 
        font-weight: 500;
        text-shadow: 0 0 10px rgba(219, 39, 119, 0.3);
    }



   

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
 
    .pill { 
        border-radius: 999px; 
        padding: 6px 14px; 
        font-size: 11px; 
        font-weight: 800; 
        display: inline-block;
        letter-spacing: 0.5px;
    }

    .pill-ok { 
        background: rgba(32, 201, 151, 0.12);
        color: var(--primary-teal); 
    }

    .pill-warn { 
        background: rgba(255, 107, 107, 0.12);
        color: var(--primary-coral-dark); 
    }



    .matchItem { 
        border: 1px solid rgba(123, 44, 191, 0.14);
        border-radius: 14px; 
        padding: 12px; 
        transition: background 0.2s;
    }
    .matchItem:hover {
        background: rgba(123, 44, 191, 0.04);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole body content */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. CardX icon/image scaling on hover (if any inside) */
    .cardX img, .cardX i, .cardX svg {
        transition: transform 0.3s ease;
    }
    .cardX:hover img, .cardX:hover i, .cardX:hover svg {
        transform: scale(1.05);
    }

    /* 3. MatchItem hover enhancement – add slight translateX and shadow */
    .matchItem {
        transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
    }
    .matchItem:hover {
        transform: translateX(4px);
        box-shadow: var(--shadow-sm);
    }

    /* 4. Pill hover effect (subtle scale) */
    .pill {
        transition: transform 0.2s;
    }
    .pill:hover {
        transform: scale(1.05);
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .cardX:focus-within,
    .matchItem:focus-within,
    .pill:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 12px;
    }

    /* 6. Custom scrollbar (matches brand purple) */
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

    /* 7. Responsive improvements for mobile */
    @media (max-width: 640px) {
        .cardX {
            padding: 12px;
        }
        .matchItem {
            padding: 8px;
        }
        .pill {
            font-size: 10px;
            padding: 4px 8px;
        }
        .muted {
            font-size: 0.85rem;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .cardX.skeleton, .matchItem.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

<div class="container-fluid px-md-5 py-4">
  <div class="d-flex justify-content-between align-items-center mb-5" style="border-bottom: 1px solid rgba(124, 45, 94, 0.2); padding-bottom: 20px;">
    <div>
      <h1 class="mb-1" style="font-weight: 800; background: var(--gradient-primary); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Buddy Mode</h1>
      <div class="muted">Find nearby verified users traveling to a similar destination. Stay safe together.</div>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-10 offset-lg-1">
  <div class="row g-4 justify-content-center">
    
    <div class="col-lg-7">
      <!-- 🛠️ Your Buddy Controls -->
      <div class="cardX mb-4">
        <div class="d-flex justify-content-between align-items-start gap-2 mb-3">
          <div>
            <h5 class="mb-1 fw-bold">Your buddy status</h5>
            <div class="muted small">Verified profile required for safety.</div>
          </div>
          <c:choose>
            <c:when test="${user.verificationStatus == 'VERIFIED'}">
              <span class="pill pill-ok">VERIFIED</span>
            </c:when>
            <c:otherwise>
              <span class="pill pill-warn">${user.verificationStatus}</span>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="mb-3">
          <label class="form-label fw-600">Where are you going?</label>
          <input id="buddyDestination" type="text" class="form-control" maxlength="80" placeholder="Example: MG Road / Hitech City" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(30, 27, 75, 0.1);">
        </div>

        <div class="row g-2 mb-3">
          <div class="col-md-6">
            <label class="form-label">Time window</label>
            <select id="buddyWindow" class="form-select" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(30, 27, 75, 0.1);">
              <option value="10">10 min</option>
              <option value="20">20 min</option>
              <option value="30" selected>30 min</option>
              <option value="60">60 min</option>
              <option value="120">120 min</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">Radius</label>
            <select id="buddyRadius" class="form-select" style="border: 2px solid var(--primary-purple); box-shadow: 0 2px 8px rgba(30, 27, 75, 0.1);">
              <option value="2">2 km</option>
              <option value="3" selected>3 km</option>
              <option value="5">5 km</option>
            </select>
          </div>
        </div>

        <div class="d-grid gap-2">
          <button id="buddyStart" class="btn" type="button" 
                  style="background: var(--gradient-primary); color: #fff; padding: 15px; font-weight: 800; border: none; border-radius: 12px; transition: 0.3s; box-shadow: 0 5px 15px rgba(124, 45, 94, 0.4);">
            <i class="fas fa-walking me-2"></i> START BUDDY MODE
          </button>
          <div class="row g-2">
            <div class="col-6">
                <button id="buddyFind" class="btn btn-outline-primary w-100" type="button">Find matches</button>
            </div>
            <div class="col-6">
                <button id="buddyStop" class="btn btn-outline-danger w-100" type="button">Stop</button>
            </div>
          </div>
        </div>

        <div id="buddyStatus" class="small muted mt-3 text-center"></div>
      </div>

      <!-- 👥 Matches & Requests -->
      <div class="cardX mb-4">
        <h5 class="mb-3 fw-bold"><i class="fas fa-users-viewfinder text-primary me-2"></i>Nearby matches</h5>
        <div id="matchList" class="d-grid gap-3">
            <div class="muted small text-center py-4">No active matches found nearby yet.</div>
        </div>
      </div>
    </div>
    <div class="col-lg-12">
      <div class="cardX">
        <div class="row g-4">
          <div class="col-md-6 border-end">
            <h5 class="mb-3 fw-bold"><i class="fas fa-arrow-down text-success me-2"></i>Incoming requests</h5>
            <div id="incomingList" class="d-grid gap-2"></div>
          </div>
          <div class="col-md-6">
            <h5 class="mb-3 fw-bold"><i class="fas fa-arrow-up text-primary me-2"></i>Outgoing requests</h5>
            <div id="outgoingList" class="d-grid gap-2"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</div>
</div>



<!-- Success/Acceptance Connection Modal -->
<div class="modal fade" id="buddyConnectionModal" tabindex="-1" aria-hidden="true" style="color: #333;">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content text-center p-4" style="border-radius: 20px; border: 2px solid var(--primary-purple); background: #fffcfd; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);">
      <div class="modal-body">
        <div class="mb-3">
          <i class="bi bi-people-fill text-success" style="font-size: 3.5rem;"></i>
        </div>
        <h4 class="fw-bold mb-2 text-dark" style="font-family: 'Montserrat', sans-serif;">Buddy Connected! 🎉</h4>
        <p class="text-muted mb-4">You have accepted the travel request. You can now coordinate, travel together, and make friends!</p>
        
        <div class="d-grid gap-2">
          <a id="btnModalChat" href="#" class="btn btn-primary btn-lg rounded-pill" style="background: var(--gradient-primary); border: none; font-weight: 700; font-size: 1rem; padding: 12px; transition: 0.2s;">
            <i class="bi bi-chat-text-fill me-2"></i> Open Text Chat
          </a>
          <a id="btnModalVoiceCall" href="#" target="_blank" class="btn btn-outline-success btn-lg rounded-pill" style="font-weight: 700; font-size: 1rem; padding: 12px; transition: 0.2s;">
            <i class="bi bi-telephone-fill me-2"></i> Voice Call Buddy
          </a>
          <a id="btnModalVideoCall" href="#" target="_blank" class="btn btn-outline-primary btn-lg rounded-pill" style="font-weight: 700; font-size: 1rem; padding: 12px; transition: 0.2s;">
            <i class="bi bi-camera-video-fill me-2"></i> Video Call Buddy
          </a>
          <button type="button" class="btn btn-link text-secondary btn-sm mt-3" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div style="position: relative; z-index: 10; margin-top: 4rem;">
  
</div>

<script>
  // Purpose: JS needs contextPath for API calls in any deployment.
  window.__APP_CTX__ = "${pageContext.request.contextPath}";

  // Purpose: requests loaded via /buddy/requests (single source, no duplicate render).
  window.__BUDDY_BOOT__ = { incoming: [], outgoing: [] };
</script>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/buddy.js"></script>

    </div>
</div>
</body>
</html>



