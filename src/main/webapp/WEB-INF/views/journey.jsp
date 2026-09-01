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
  <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/journey-theme.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="fdf-page-shell fdf-page-journey">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper">

    <main class="fdf-page-main">
      <header class="fdf-page-header">
        <div>
          <h1 class="fdf-page-title">Journey Tracker</h1>
          <p class="fdf-page-subtitle">Set an expected arrival time. If you don't check-in, emergency contacts can be alerted.</p>
        </div>
        <a class="fdf-nav-btn" href="${pageContext.request.contextPath}/users/dashboard">
          <i class="fas fa-arrow-left"></i> Dashboard
        </a>
      </header>

      <div class="row g-4 fdf-full-grid">
        <div class="col-12 col-lg-5">
          <div class="fdf-card fdf-card--rose">
            <h5 class="fdf-card-title">Start a journey timer</h5>

            <div class="mb-3">
              <label class="form-label" for="journeyFrom">Starting from</label>
              <input id="journeyFrom" class="form-control" maxlength="100" placeholder="Example: College / Office / Gym">
            </div>

            <div class="mb-3">
              <label class="form-label" for="journeyDestination">Destination</label>
              <input id="journeyDestination" class="form-control" maxlength="100" placeholder="Example: Home / Bus stop / Hostel / MG Road">
            </div>

            <div class="mb-3">
              <label class="form-label" for="journeyExpected">Expected arrival time</label>
              <input id="journeyExpected" type="datetime-local" class="form-control">
              <div class="fdf-muted small mt-2">You must set a time at least 1 minute in the future.</div>
            </div>

            <div class="d-grid gap-3">
              <button id="journeyStart" class="btn fdf-btn-primary" type="button">
                <i class="fas fa-clock me-2"></i> START TIMER
              </button>
              <button id="journeySafe" class="btn fdf-btn-success" type="button">
                <i class="fas fa-check me-2"></i> I'M SAFE (CHECK-IN)
              </button>
              <button id="journeyCancel" class="btn fdf-btn-danger-outline" type="button">
                CANCEL TIMER
              </button>
            </div>

            <div id="journeyStatus" class="small fdf-muted mt-3"></div>
          </div>
        </div>

        <div class="col-12 col-lg-7">
          <div class="fdf-card h-100">
            <h5 class="fdf-card-title">Active timer</h5>
            <div id="activeBox" class="fdf-muted small">Loading…</div>
          </div>
        </div>
      </div>
    </main>

    <script>
      window.__APP_CTX__ = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/journey.js"></script>
  </div>
</div>
</body>
</html>
