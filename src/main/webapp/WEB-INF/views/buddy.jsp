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
  <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/buddy-theme.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="fdf-page-shell fdf-page-buddy">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper">

    <main class="fdf-page-main">
      <header class="fdf-page-header">
        <div>
          <h1 class="fdf-page-title">Buddy Mode</h1>
          <p class="fdf-page-subtitle">Find nearby verified users traveling to a similar destination. Stay safe together.</p>
        </div>
      </header>

      <div class="row g-4 fdf-full-grid">
        <div class="col-12 col-xl-7">
          <div class="fdf-card fdf-card--rose mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
              <div>
                <h5 class="fdf-card-title mb-1">Your buddy status</h5>
                <div class="fdf-muted small">Verified profile required for safety.</div>
              </div>
              <c:choose>
                <c:when test="${user.verificationStatus == 'VERIFIED'}">
                  <span class="fdf-pill fdf-pill-ok">VERIFIED</span>
                </c:when>
                <c:otherwise>
                  <span class="fdf-pill fdf-pill-warn">${user.verificationStatus}</span>
                </c:otherwise>
              </c:choose>
            </div>

            <div class="mb-3">
              <label class="form-label" for="buddyDestination">Where are you going?</label>
              <input id="buddyDestination" type="text" class="form-control" maxlength="80" placeholder="Example: MG Road / Hitech City">
            </div>

            <div class="row g-3 mb-3">
              <div class="col-12 col-md-6">
                <label class="form-label" for="buddyWindow">Time window</label>
                <select id="buddyWindow" class="form-select">
                  <option value="10">10 min</option>
                  <option value="20">20 min</option>
                  <option value="30" selected>30 min</option>
                  <option value="60">60 min</option>
                  <option value="120">120 min</option>
                </select>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label" for="buddyRadius">Radius</label>
                <select id="buddyRadius" class="form-select">
                  <option value="2">2 km</option>
                  <option value="3" selected>3 km</option>
                  <option value="5">5 km</option>
                </select>
              </div>
            </div>

            <div class="d-grid gap-2">
              <button id="buddyStart" class="btn fdf-btn-primary" type="button">
                <i class="fas fa-walking me-2"></i> START BUDDY MODE
              </button>
              <div class="row g-2">
                <div class="col-6">
                  <button id="buddyFind" class="btn fdf-btn-outline w-100" type="button">Find matches</button>
                </div>
                <div class="col-6">
                  <button id="buddyStop" class="btn fdf-btn-danger-outline w-100" type="button">Stop</button>
                </div>
              </div>
            </div>

            <div id="buddyStatus" class="small fdf-muted mt-3 text-center"></div>
          </div>

          <div class="fdf-card">
            <h5 class="fdf-card-title"><i class="fas fa-users-viewfinder fdf-icon-accent me-2"></i>Nearby matches</h5>
            <div id="matchList" class="d-grid gap-3">
              <div class="fdf-empty-state">No active matches found nearby yet.</div>
            </div>
          </div>
        </div>

        <div class="col-12 col-xl-5">
          <div class="fdf-card h-100">
            <div class="row g-4">
              <div class="col-12 col-md-6 fdf-split-section border-end">
                <h5 class="fdf-card-title"><i class="fas fa-arrow-down fdf-icon-accent me-2"></i>Incoming requests</h5>
                <div id="incomingList" class="d-grid gap-2"></div>
              </div>
              <div class="col-12 col-md-6">
                <h5 class="fdf-card-title"><i class="fas fa-arrow-up fdf-icon-accent me-2"></i>Outgoing requests</h5>
                <div id="outgoingList" class="d-grid gap-2"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Connection Modal -->
    <div class="modal fade" id="buddyConnectionModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content fdf-modal-content text-center p-2">
          <div class="modal-body">
            <div class="mb-3">
              <i class="bi bi-people-fill fdf-modal-icon"></i>
            </div>
            <h4 class="fw-bold mb-2">Buddy Connected!</h4>
            <p class="fdf-muted mb-4">You have accepted the travel request. You can now coordinate, travel together, and make friends!</p>
            <div class="d-grid gap-2">
              <a id="btnModalChat" href="#" class="btn fdf-btn-primary btn-lg rounded-pill">
                <i class="bi bi-chat-text-fill me-2"></i> Open Text Chat
              </a>
              <a id="btnModalVoiceCall" href="#" target="_blank" class="btn fdf-btn-success btn-lg rounded-pill">
                <i class="bi bi-telephone-fill me-2"></i> Voice Call Buddy
              </a>
              <a id="btnModalVideoCall" href="#" target="_blank" class="btn fdf-btn-outline btn-lg rounded-pill">
                <i class="bi bi-camera-video-fill me-2"></i> Video Call Buddy
              </a>
              <button type="button" class="btn btn-link fdf-muted btn-sm mt-2" data-bs-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      window.__APP_CTX__ = "${pageContext.request.contextPath}";
      window.__BUDDY_BOOT__ = { incoming: [], outgoing: [] };
    </script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/buddy.js"></script>
  </div>
</div>
</body>
</html>
