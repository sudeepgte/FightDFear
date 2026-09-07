<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${doctor.fullName} | Medical Profile</title>
  
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  
  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  
  <!-- Theme CSS -->
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-tokens.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-view.css">

  <style>
    :root {
      --primary: #F43F5E;
      --rose-soft: #FFF1F2;
      --bg-page: #F8FAFC;
      --navy: #0F172A;
      --navy-soft: #1E293B;
      --border: #E2E8F0;
      --brand-soft-bg: var(--bg-page);
      --text-gray: #64748B;
      --shadow-card: 0 4px 20px rgba(0,0,0,0.03);
    }

        body {
      background-color: var(--brand-soft-bg);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      color: var(--navy-soft);
      overflow-x: hidden;
    }

    .doctor-hero-bg {
      background: #F43F5E;
      height: 4px;
      width: 100%;
      position: relative;
      top: 0;
      left: 0;
      z-index: 1;
    }

    #header.header .logo h1,
    .header .logo h1,
    .logo h1 {
      color: #F43F5E !important;
      -webkit-text-fill-color: #F43F5E !important;
      background: none !important;
    }
    .nav-profile span { color: #1E293B !important; }
    .profile-header-card { margin-top: 28px; }

    .doctor-hero {
      background: linear-gradient(135deg, #F43F5E 0%, #E11D48 100%);
      color: #fff;
      padding: 28px 0 36px;
      border-radius: 0 0 28px 28px;
      box-shadow: 0 10px 30px rgba(244, 63, 94, 0.22);
    }
    .doctor-hero .hero-avatar {
      width: 140px;
      height: 140px;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid rgba(255,255,255,0.9);
      box-shadow: 0 10px 25px rgba(0,0,0,0.25);
      background: rgba(255,255,255,0.15);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.4rem;
      font-weight: 800;
      color: #fff;
    }
    .doctor-hero .hero-avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      border-radius: 50%;
    }
    .doctor-hero h1 { color: #fff; font-weight: 800; font-size: 2rem; }
    .doctor-hero .hero-fee {
      background: rgba(255,255,255,0.12);
      border: 1px solid rgba(255,255,255,0.18);
      border-radius: 16px;
      padding: 16px 22px;
      text-align: center;
      min-width: 160px;
    }
    .action-btn-circle.hero-action {
      width: 48px; height: 48px;
      border-radius: 14px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      text-decoration: none;
      font-size: 1.15rem;
    }

    .text-primary, .bi-patch-check-fill.text-primary { color: #F43F5E !important; }
    .action-btn-circle.bg-primary, .bg-primary { background-color: #F43F5E !important; border-color: #F43F5E !important; }
    .text-accent { color: #F43F5E !important; }

    .profile-header-card {
      background: white;
      border-radius: 16px;
      padding: 28px;
      box-shadow: var(--shadow-card);
      margin-top: 0;
      border: 1px solid var(--border);
      position: relative;
    }

    .doctor-avatar-large {
      width: 120px;
      height: 120px;
      border-radius: 16px;
      object-fit: cover;
      border: 4px solid white;
      box-shadow: 0 8px 24px rgba(15,23,42,0.1);
      margin-top: -72px;
      background: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 2.5rem;
      font-weight: 800;
    }

    .nav-pills-custom .nav-link {
      border-radius: 10px;
      padding: 10px 18px;
      font-weight: 600;
      color: var(--navy-soft);
      transition: all 0.2s ease;
      border: 1px solid transparent;
      margin-right: 8px;
      margin-bottom: 6px;
    }

    .nav-pills-custom .nav-link.active {
      background: var(--rose-soft) !important;
      color: var(--primary) !important;
      border-color: #fecdd3;
    }

    .info-grid-item {
      padding: 20px;
      background: #f8fafc;
      border-radius: 14px;
      border: 1px solid var(--border);
      height: 100%;
    }

    .booking-sticky-card {
      position: sticky;
      top: 24px;
      background: white;
      border-radius: 16px;
      padding: 24px;
      border: 1px solid var(--border);
      box-shadow: var(--shadow-card);
    }

    .day-selector-item {
      flex: 1;
      text-align: center;
      padding: 12px 8px;
      background: #f8fafc;
      border-radius: 12px;
      border: 2px solid var(--border);
      cursor: pointer;
      transition: 0.2s;
      min-width: 64px;
    }

    .day-selector-item.active {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }

    .time-slot-pill {
      display: inline-block;
      padding: 10px 16px;
      background: white;
      border: 2px solid var(--border);
      border-radius: 10px;
      margin: 4px;
      cursor: pointer;
      font-weight: 600;
      font-size: 0.88rem;
      transition: 0.2s;
    }

    .time-slot-pill:hover, .time-slot-pill.selected {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }

    .review-item {
      padding: 20px;
      border-bottom: 1px solid var(--border);
    }

    .review-item:last-child { border-bottom: none; }

    /* Interactive star rating (row-reverse so :checked ~ label fills lower stars) */
    .rating-stars {
      display: flex;
      flex-direction: row-reverse;
      justify-content: center;
      gap: 8px;
      direction: ltr;
    }
    .rating-stars input {
      position: absolute;
      opacity: 0;
      width: 0;
      height: 0;
      pointer-events: none;
    }
    .rating-stars label {
      cursor: pointer;
      font-size: 2rem;
      line-height: 1;
      color: #d1d5db;
      transition: color 0.15s ease, transform 0.15s ease;
      user-select: none;
    }
    .rating-stars label:hover,
    .rating-stars label:hover ~ label,
    .rating-stars input:checked ~ label {
      color: #f59e0b;
    }
    .rating-stars label:hover {
      transform: scale(1.12);
    }

    .action-btn-circle {
      width: 50px;
      height: 50px;
      border-radius: 15px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.3rem;
      transition: 0.3s;
      color: white;
    }

    .btn-book-primary {
      background: var(--primary);
      color: white;
      border: none;
      border-radius: 12px;
      padding: 14px 16px;
      font-weight: 700;
      width: 100%;
      box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
      font-family: inherit;
      min-height: 48px;
      transition: opacity 0.2s, background 0.2s;
    }
    .btn-book-primary:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      box-shadow: none;
    }
    .btn-book-primary:not(:disabled):hover {
      background: #E11D48;
    }

    @media (max-width: 991px) {
      .booking-sticky-card { position: static; margin-top: 24px; }
      .profile-header-card { margin-top: 48px; padding: 20px; }
      .doctor-avatar-large { width: 96px; height: 96px; margin-top: -56px; font-size: 2rem; }
    }
    @media (max-width: 576px) {
      .doctor-hero-bg { height: 160px; }
      .day-selector-item { min-width: 56px; padding: 10px 4px; font-size: 0.8rem; }
      .nav-pills-custom { flex-wrap: wrap; }
    }

    .logo {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
      color: #F43F5E;
    }
    .logo img {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      object-fit: cover;
    }
    .logo h1 {
      margin: 0;
      font-size: 20px;
      font-weight: 800;
      color: #F43F5E !important;
    }
    .header {
      background: #ffffff;
      border-bottom: 1px solid var(--border);
    }
    .navmenu ul li a {
      color: var(--navy-soft);
      font-weight: 600;
    }
    .navmenu ul li a:hover {
      color: var(--primary);
    }
    .btn-getstarted,
    #header .btn-getstarted,
    .header .btn-getstarted,
    .header .btn-getstarted:focus,
    .header .btn-getstarted:hover {
      background: #F43F5E !important;
      background-image: none !important;
      color: #fff !important;
      border: none !important;
      border-radius: 50px !important;
    }
    .header .btn-getstarted:hover {
      background: #E11D48 !important;
    }
    #dateScroll {
      scrollbar-width: thin;
      scrollbar-color: #F43F5E #FFE4E6;
      padding-bottom: 10px;
      border-bottom: 3px solid #F43F5E;
    }
    #dateScroll::-webkit-scrollbar { height: 6px; }
    #dateScroll::-webkit-scrollbar-track { background: #FFE4E6; border-radius: 99px; }
    #dateScroll::-webkit-scrollbar-thumb { background: #F43F5E; border-radius: 99px; }
    body::-webkit-scrollbar { width: 8px; }
    body::-webkit-scrollbar-track { background: #FFF1F2; }
    body::-webkit-scrollbar-thumb {
      background: linear-gradient(180deg, #F43F5E, #E11D48);
      border-radius: 4px;
    }
    body::-webkit-scrollbar-thumb:hover { background: #E11D48; }
    html { scrollbar-color: #F43F5E #FFF1F2; }
    .bg-soft-pink {
      background: var(--rose-soft) !important;
    }
    .text-pink {
      color: var(--primary) !important;
    }
    .text-accent {
      color: var(--primary) !important;
    }
    .btn-outline-accent {
      border-color: var(--border);
      color: var(--navy-soft);
      background: #fff;
    }
    .btn-check:checked + .btn-outline-accent {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
    }
    .btn-accent {
      background: var(--primary);
      color: #fff;
      border: none;
    }
    .btn-accent:hover { background: #E11D48; color: #fff; }
    
    .rating-stars {
      display: inline-flex;
      flex-direction: row-reverse;
      justify-content: center;
    }
    .rating-stars input {
      position: absolute;
      opacity: 0;
      width: 0;
      height: 0;
    }
    .rating-stars label {
      cursor: pointer;
      color: #d1d5db;
      font-size: 2.5rem;
      padding: 0 5px;
      transition: color 0.2s;
    }
    .rating-stars label:before {
      content: '★';
    }
    .rating-stars input:checked ~ label,
    .rating-stars label:hover,
    .rating-stars label:hover ~ label {
      color: #fbbf24;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden; padding: 0;" data-skip-global-back="true">

  <div class="doctor-hero">
    <div class="container-fluid px-4 px-lg-5">
      <a href="${pageContext.request.contextPath}/doctors/list" class="btn btn-sm btn-outline-light mb-4 rounded-pill px-3">
        <i class="bi bi-arrow-left me-1"></i> Browse Doctors
      </a>
      <div class="row align-items-center">
        <div class="col-md-auto text-center mb-3 mb-md-0">
          <div class="hero-avatar mx-auto">
            <c:choose>
              <c:when test="${not empty doctor.profilePhotoPath}">
                <img src="${pageContext.request.contextPath}${doctor.profilePhotoPath}" alt="${doctor.fullName}">
              </c:when>
              <c:otherwise>${doctor.fullName.charAt(0)}</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="col-md">
          <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
            <span class="badge bg-success bg-opacity-25 text-white border border-light border-opacity-50 px-3 py-1 rounded-pill" style="font-size:0.75rem;">
              <i class="bi bi-patch-check-fill me-1"></i> Verified Doctor
            </span>
            <span class="badge bg-white bg-opacity-10 text-white border border-white border-opacity-25 px-3 py-1 rounded-pill" style="font-size:0.75rem;">
              <i class="bi bi-award me-1"></i> ${doctor.experienceYears != null ? doctor.experienceYears : 1}+ Yrs Experience
            </span>
            <c:if test="${not empty doctor.specialization}">
              <span class="badge bg-white bg-opacity-10 text-white border border-white border-opacity-25 px-3 py-1 rounded-pill" style="font-size:0.75rem;">
                ${doctor.specialization}
              </span>
            </c:if>
          </div>
          <h1 class="mb-1">${doctor.fullName}</h1>
          <p class="text-white-50 mb-2 small">${not empty doctor.qualification ? doctor.qualification : 'Womens healthcare specialist'}</p>
          <div class="d-flex flex-wrap align-items-center gap-3 text-white-50 small">
            <span class="text-warning fw-bold"><i class="bi bi-star-fill me-1"></i> ${doctor.rating != null ? doctor.rating : '0.0'}</span>
            <span>&bull;</span>
            <span><i class="bi bi-geo-alt me-1"></i>
              <c:choose>
                <c:when test="${not empty doctor.city}">${doctor.city}<c:if test="${not empty doctor.state}">, ${doctor.state}</c:if></c:when>
                <c:when test="${not empty doctor.locationText}">${doctor.locationText}</c:when>
                <c:otherwise>Online / Clinic</c:otherwise>
              </c:choose>
            </span>
            <span>&bull;</span>
            <span><i class="bi bi-clock me-1"></i> ${not empty doctor.startTime ? doctor.startTime : '—'} – ${not empty doctor.endTime ? doctor.endTime : '—'}</span>
          </div>
        </div>
        <div class="col-md-auto mt-4 mt-md-0 d-flex flex-wrap align-items-center gap-3 justify-content-md-end">
          <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}" class="action-btn-circle hero-action bg-white text-danger" title="Chat" style="color:#F43F5E !important;"><i class="bi bi-chat-dots-fill"></i></a>
          <a href="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}" class="action-btn-circle hero-action bg-success" title="Video Call"><i class="bi bi-camera-video-fill"></i></a>
          <div class="hero-fee">
            <span class="text-white-50 d-block mb-1" style="font-size:0.75rem;">Consultation</span>
            <h2 class="fw-bold text-white mb-0" id="headerFeeDisplay">₹${doctor.consultationFee != null ? doctor.consultationFee : 0}</h2>
            <small class="text-white-50" style="font-size:0.7rem;">per visit</small>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="container-fluid px-4 px-lg-5 py-5">
    <div class="row mt-5 g-4">
      <div class="col-lg-8">
        <ul class="nav nav-pills nav-pills-custom mb-4" id="pills-tab" role="tablist">
          <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#pills-overview" type="button">Overview</button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#pills-schedule" type="button">Schedule</button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#pills-reviews" type="button">Patient Stories</button>
          </li>
        </ul>

        <div class="tab-content" id="pills-tabContent">
          <!-- Overview -->
          <div class="tab-pane fade show active" id="pills-overview">
            <div class="bg-white rounded-4 p-5 border shadow-sm">
              <h4 class="fw-800 mb-4">Professional Background</h4>
              <p class="text-muted lh-lg mb-5">
                Dr. ${doctor.fullName} is a dedicated specialist in ${doctor.specialization} with over ${doctor.experienceYears} years of experience. 
                Providing compassionate care at ${doctor.hospitalName != null ? doctor.hospitalName : 'our partner clinics'}, 
                the doctor specializes in comprehensive women's health and wellness.
              </p>

              <div class="row g-4">
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-pink mb-2"><i class="bi bi-mortarboard-fill fs-4"></i></div>
                    <div class="small fw-700 text-muted">QUALIFICATION</div>
                    <div class="fw-800">${not empty doctor.qualification ? doctor.qualification : 'Not provided'}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-accent mb-2"><i class="bi bi-shield-check fs-4"></i></div>
                    <div class="small fw-700 text-muted">REGISTRATION</div>
                    <div class="fw-800">${not empty doctor.medicalRegNumber ? doctor.medicalRegNumber : 'Not provided'}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-primary mb-2"><i class="bi bi-building fs-4"></i></div>
                    <div class="small fw-700 text-muted">HOSPITAL</div>
                    <div class="fw-800">${not empty doctor.hospitalName ? doctor.hospitalName : 'Not provided'}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-success mb-2"><i class="bi bi-activity fs-4"></i></div>
                    <div class="small fw-700 text-muted">CONSULTATION</div>
                    <div class="fw-800">${not empty doctor.consultationModes ? doctor.consultationModes : (doctor.consultationType != null ? doctor.consultationType : 'Not provided')}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Schedule -->
          <div class="tab-pane fade" id="pills-schedule">
            <div class="bg-white rounded-4 p-5 border shadow-sm">
              <h4 class="fw-800 mb-4">Practice Hours & Location</h4>
              <div class="d-flex flex-wrap gap-2 mb-4">
                <c:forEach var="day" items="${doctor.availableDays.split(',')}">
                  <span class="badge bg-light text-dark border px-3 py-2 fw-700">${day.trim()}</span>
                </c:forEach>
              </div>
              <div class="row g-4 mb-5">
                <div class="col-md-6">
                  <div class="p-4 bg-light rounded-4 text-center">
                    <div class="text-muted small fw-700">MORNING SESSION</div>
                    <div class="fs-4 fw-900">${doctor.startTime}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="p-4 bg-light rounded-4 text-center">
                    <div class="text-muted small fw-700">EVENING SESSION</div>
                    <div class="fs-4 fw-900">${doctor.endTime}</div>
                  </div>
                </div>
              </div>

              <h5 class="fw-800 mb-3">Clinic Address</h5>
              <div class="p-4 border rounded-4 d-flex gap-3 align-items-start">
                <i class="bi bi-geo-alt-fill text-pink fs-4"></i>
                <div>
                  <div class="fw-700">${doctor.clinicAddress}</div>
                  <div class="text-muted">${doctor.city}, ${doctor.state} - ${doctor.pincode}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Reviews -->
          <div class="tab-pane fade" id="pills-reviews">
            <div class="bg-white rounded-4 p-5 border shadow-sm">
              <div class="d-flex justify-content-between align-items-center mb-5">
                <h4 class="fw-800 m-0">Patient Reviews</h4>
                <c:if test="${canReview}">
                  <button class="btn btn-outline-pink rounded-pill fw-700" data-bs-toggle="modal" data-bs-target="#reviewModal">Write a Review</button>
                </c:if>
              </div>

              <c:if test="${empty reviews}">
                <div class="text-center py-5">
                  <i class="bi bi-chat-quote text-muted display-1 mb-3"></i>
                  <p class="text-muted">No reviews yet. Be the first to share your experience!</p>
                </div>
              </c:if>

              <div class="review-list">
                <c:forEach var="r" items="${reviews}">
                  <div class="review-item">
                    <div class="d-flex justify-content-between mb-2">
                      <div class="fw-800">${r.user.fullName}</div>
                      <div class="text-warning">
                        <c:choose>
                          <c:when test="${r.rating != null && r.rating >= 1 && r.rating <= 5}">
                            <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                          </c:when>
                          <c:otherwise>
                            <span class="text-muted small">No rating</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                    <p class="text-muted small mb-0">${r.comment}</p>
                    <div class="mt-2 opacity-50 small fw-600">${r.createdAt}</div>
                  </div>
                </c:forEach>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Booking Card Sticky -->
      <div class="col-lg-4">
        <div class="booking-sticky-card">
          <h4 class="fw-900 mb-4">Book Appointment</h4>
          
          <form id="bookingForm" onsubmit="event.preventDefault(); showBookingPreview();">
            <input type="hidden" id="doctorId" value="${doctor.id}">
            <input type="hidden" id="amount" value="${doctor.consultationFee != null ? doctor.consultationFee : 0}">
            <input type="hidden" id="appointmentTime" value="">
            <input type="hidden" id="clinicFee" value="${doctor.consultationFee != null ? doctor.consultationFee : 0}">
            <input type="hidden" id="videoFee" value="${doctor.videoFee != null ? doctor.videoFee : (doctor.consultationFee != null ? doctor.consultationFee : 0)}">
            <input type="hidden" id="chatFee" value="${doctor.chatFee != null ? doctor.chatFee : (doctor.consultationFee != null ? doctor.consultationFee : 0)}">

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block">PATIENT NAME *</label>
              <input type="text" id="patientName" class="form-control rounded-3 py-2" value="${user.fullName}" required>
            </div>

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block">MOBILE NUMBER *</label>
              <input type="tel" id="patientPhone" class="form-control rounded-3 py-2" value="${user.phoneNumber}" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
            </div>

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block">SELECT DATE</label>
              <div class="d-flex gap-2 overflow-x-auto pb-2" id="dateScroll">
                <!-- Dates dynamically generated -->
              </div>
            </div>

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block">CHOOSE TIME SLOT</label>
              <div id="sessionSlots" class="d-flex flex-wrap gap-1">
                <p class="text-muted small py-3 w-100 text-center">Please select a date first</p>
              </div>
            </div>

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block">CONSULTATION MODE</label>
              <c:set var="modesStr" value="${not empty doctor.consultationModes ? doctor.consultationModes.toUpperCase() : ''}" />
              <c:set var="hasClinic" value="${empty modesStr or modesStr.contains('CLINIC') or modesStr.contains('BOTH') or modesStr.contains('OFFLINE')}" />
              <c:set var="hasVideo" value="${empty modesStr or modesStr.contains('VIDEO') or modesStr.contains('BOTH') or modesStr.contains('ONLINE')}" />
              <div class="btn-group w-100" role="group">
                <c:if test="${hasClinic}">
                  <input type="radio" class="btn-check" name="consultationType" id="mode1" value="CLINIC" ${hasClinic ? 'checked' : ''}>
                  <label class="btn btn-outline-accent py-3 fw-700" for="mode1">Clinic Visit</label>
                </c:if>
                <c:if test="${hasVideo}">
                  <input type="radio" class="btn-check" name="consultationType" id="mode2" value="VIDEO" ${!hasClinic && hasVideo ? 'checked' : ''}>
                  <label class="btn btn-outline-accent py-3 fw-700" for="mode2">Video Call</label>
                </c:if>
                <c:if test="${!hasClinic and !hasVideo}">
                  <input type="radio" class="btn-check" name="consultationType" id="mode1" value="CLINIC" checked>
                  <label class="btn btn-outline-accent py-3 fw-700" for="mode1">Clinic Visit</label>
                </c:if>
              </div>
            </div>

            <div class="mb-4">
              <label class="small fw-800 text-muted mb-2 d-block" for="appointmentReason">REASON FOR VISIT</label>
              <textarea id="appointmentReason" class="form-control rounded-3 py-2" rows="3" maxlength="500"
                        placeholder="Briefly describe your symptoms or reason for consultation (optional)"></textarea>
              <div class="d-flex justify-content-between mt-1">
                <span class="small text-muted">Shown to your doctor after booking</span>
                <span class="small text-muted"><span id="reasonCount">0</span>/500</span>
              </div>
            </div>

            <div id="selectedSummary" class="mb-4 p-3 rounded-3 d-none" style="background:#fff;border:1px solid #fecdd3;box-shadow:0 4px 16px rgba(244,63,94,0.06);">
              <div class="small fw-800 text-muted mb-2" style="letter-spacing:0.04em;">BOOKING SUMMARY</div>
              <div class="d-flex justify-content-between small mb-1"><span class="text-muted">Doctor</span><span class="fw-700">Dr. ${doctor.fullName}</span></div>
              <div class="d-flex justify-content-between small mb-1"><span class="text-muted">When</span><span class="fw-700" id="summaryText">—</span></div>
              <div class="d-flex justify-content-between small mb-1"><span class="text-muted">Mode</span><span class="fw-700" id="summaryMode">Clinic Visit</span></div>
              <div class="d-flex justify-content-between small mb-1"><span class="text-muted">Fee</span><span class="fw-700 text-pink" id="summaryFee">₹0</span></div>
              <div class="d-flex justify-content-between small"><span class="text-muted">Patient</span><span class="fw-700" id="summaryPatient">${user.fullName}</span></div>
            </div>

            <button type="submit" id="payBtn" class="btn-book-primary" disabled style="opacity: 0.6">
              Review booking
            </button>
            <p class="text-center mt-3 small text-muted" id="payHint"><i class="bi bi-shield-lock-fill text-success me-1"></i> Secure Payment by Razorpay</p>
          </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Review Modal -->
  <div class="modal fade" id="reviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content rounded-4 border-0 shadow">
        <div class="modal-header border-0 pb-0">
          <h5 class="modal-title fw-900">Your Experience</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form action="${pageContext.request.contextPath}/doctors/review" method="post" id="doctorReviewForm" novalidate>
          <input type="hidden" name="doctorId" value="${doctor.id}">
          <div class="modal-body p-4">
            <c:if test="${not empty error}">
              <div class="alert alert-danger rounded-4 border-0 mb-3">${error}</div>
            </c:if>
            <div class="mb-4 text-center">
              <div class="rating-stars" role="radiogroup" aria-label="Doctor rating" id="doctorRatingGroup">
                <input type="radio" name="rating" value="5" id="r5" autocomplete="off">
                <label for="r5" title="5 stars"><i class="bi bi-star-fill"></i></label>
                <input type="radio" name="rating" value="4" id="r4" autocomplete="off">
                <label for="r4" title="4 stars"><i class="bi bi-star-fill"></i></label>
                <input type="radio" name="rating" value="3" id="r3" autocomplete="off">
                <label for="r3" title="3 stars"><i class="bi bi-star-fill"></i></label>
                <input type="radio" name="rating" value="2" id="r2" autocomplete="off">
                <label for="r2" title="2 stars"><i class="bi bi-star-fill"></i></label>
                <input type="radio" name="rating" value="1" id="r1" autocomplete="off">
                <label for="r1" title="1 star"><i class="bi bi-star-fill"></i></label>
              </div>
              <div id="ratingError" class="text-danger small fw-700 mt-2" style="display:none;">Please select a star rating.</div>
            </div>
            <textarea name="comment" class="form-control rounded-4 p-3" rows="4" placeholder="How was your visit with Dr. ${doctor.fullName}?"></textarea>
          </div>
          <div class="modal-footer border-0 pt-0">
            <button type="submit" class="btn btn-accent w-100 py-3 rounded-4 fw-800">Post Review</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <div id="bookingPreviewModal" class="doc-modal-overlay" onclick="if(event.target===this)closeBookingPreview()">
    <div class="doc-modal" role="dialog" aria-modal="true" aria-labelledby="bpTitle">
      <div class="doc-modal-header">
        <div>
          <h3 id="bpTitle">Confirm your appointment</h3>
          <p>Review the details before you book with Dr. ${doctor.fullName}</p>
        </div>
        <button type="button" class="doc-modal-close" onclick="closeBookingPreview()" aria-label="Close"><i class="bi bi-x-lg"></i></button>
      </div>
      <div class="doc-modal-body">
        <div class="doc-modal-row"><span class="k">Doctor</span><span class="v">Dr. ${doctor.fullName}</span></div>
        <div class="doc-modal-row"><span class="k">Specialization</span><span class="v">${empty doctor.specialization ? 'General consultation' : doctor.specialization}</span></div>
        <div class="doc-modal-row"><span class="k">When</span><span class="v" id="bpWhen">—</span></div>
        <div class="doc-modal-row"><span class="k">Consultation</span><span class="v" id="bpMode">Clinic visit</span></div>
        <div class="doc-modal-row"><span class="k">Fee</span><span class="v" id="bpFee">₹0</span></div>
        <div class="doc-modal-row"><span class="k">Patient</span><span class="v" id="bpPatient">—</span></div>
        <div class="doc-modal-row"><span class="k">Reason</span><span class="v" id="bpReason">Not provided</span></div>
        <p class="small text-muted mt-3 mb-0" id="bpPayHint">You will complete payment on the next step.</p>
      </div>
      <div class="doc-modal-footer">
        <button type="button" class="doc-modal-btn secondary" onclick="closeBookingPreview()">← Edit</button>
        <button type="button" id="bpConfirmBtn" class="doc-modal-btn primary" onclick="confirmBookingFromPreview()">Confirm &amp; Book</button>
      </div>
    </div>
  </div>

  <div id="bookingSuccessModal" class="doc-modal-overlay">
    <div class="doc-modal" role="dialog" aria-modal="true">
      <div class="doc-modal-header" style="flex-direction:column;align-items:center;text-align:center;gap:8px;">
        <i class="bi bi-check-circle-fill" style="font-size:42px;color:var(--doc-primary, #F43F5E);"></i>
        <h3 id="bsTitle">Appointment Confirmed!</h3>
        <p id="bsDesc">Your appointment with Dr. ${doctor.fullName} has been booked successfully.</p>
      </div>
      <div class="doc-modal-body">
        <div class="doc-modal-row"><span class="k">Doctor</span><span class="v">Dr. ${doctor.fullName}</span></div>
        <div class="doc-modal-row"><span class="k">Specialization</span><span class="v">${empty doctor.specialization ? 'General consultation' : doctor.specialization}</span></div>
        <div class="doc-modal-row"><span class="k">When</span><span class="v" id="bsWhen">—</span></div>
        <div class="doc-modal-row"><span class="k">Consultation</span><span class="v" id="bsMode">—</span></div>
        <div class="doc-modal-row"><span class="k">Fee</span><span class="v" id="bsFee">—</span></div>
        <div class="doc-modal-row"><span class="k">Payment Status</span><span class="v" id="bsPaymentStatus"><span class="badge bg-success">Paid</span></span></div>
        <div class="doc-modal-row" id="bsReceiptRow" style="display:none;"><span class="k">Receipt No</span><span class="v" id="bsReceipt">—</span></div>
      </div>
      <div class="doc-modal-footer" style="justify-content:center;">
        <a class="doc-modal-btn primary" href="${pageContext.request.contextPath}/doctors/myAppointments?message=Booking-Confirmed">View my appointments</a>
        <a class="doc-modal-btn secondary" href="${pageContext.request.contextPath}/doctors/list">Find another doctor</a>
      </div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  
  <script>
    var doctorAvailableDaysStr = "${doctor.availableDays}";
    var doctorStartTime = "${doctor.startTime}";
    var doctorEndTime = "${doctor.endTime}";
    var doctorBreakStart = "${doctor.breakStart}";
    var doctorBreakEnd = "${doctor.breakEnd}";
    var doctorBlockedDatesStr = "${doctor.blockedDates}";
    var doctorSlotDuration = parseInt("${doctor.slotDurationMinutes != null ? doctor.slotDurationMinutes : 30}") || 30;
    var daysMap = { "sunday":0, "monday":1, "tuesday":2, "wednesday":3, "thursday":4, "friday":5, "saturday":6 };
    var availableDays = (doctorAvailableDaysStr || "").split(",").map(d => d.trim().toLowerCase()).filter(d => daysMap[d] !== undefined).map(d => daysMap[d]);

    function parseMinutes(timeStr) {
      if (!timeStr || typeof timeStr !== 'string' || !timeStr.includes(':')) return null;
      var parts = timeStr.trim().split(':');
      var h = parseInt(parts[0], 10);
      var m = parseInt(parts[1] || '0', 10);
      if (isNaN(h) || isNaN(m)) return null;
      return h * 60 + m;
    }

    function currentFee() {
      var type = (document.querySelector('input[name="consultationType"]:checked') || {}).value || 'CLINIC';
      var clinic = parseFloat(document.getElementById('clinicFee').value || '0');
      var video = parseFloat(document.getElementById('videoFee').value || '0');
      var chat = parseFloat(document.getElementById('chatFee').value || '0');
      if (type === 'VIDEO') return isNaN(video) ? 0 : video;
      if (type === 'ONLINE') return isNaN(chat) ? 0 : chat;
      return isNaN(clinic) ? 0 : clinic;
    }

    function syncFeeUi() {
      var fee = currentFee();
      document.getElementById('amount').value = fee;
      var btn = document.getElementById('payBtn');
      var hint = document.getElementById('payHint');
      var header = document.getElementById('headerFeeDisplay');
      var type = (document.querySelector('input[name="consultationType"]:checked') || {}).value || 'CLINIC';
      var modeLabel = type === 'VIDEO' ? 'Video Call' : (type === 'ONLINE' ? 'Chat' : 'Clinic Visit');
      if (header) header.innerText = '₹' + fee;
      var summaryFee = document.getElementById('summaryFee');
      var summaryMode = document.getElementById('summaryMode');
      if (summaryFee) summaryFee.innerText = '₹' + fee;
      if (summaryMode) summaryMode.innerText = modeLabel;
      var summaryPatient = document.getElementById('summaryPatient');
      var patientName = document.getElementById('patientName');
      if (summaryPatient && patientName) summaryPatient.innerText = patientName.value || '—';
      if (fee > 0) {
        btn.innerText = 'Review & Pay ₹' + fee;
        if (hint) hint.innerHTML = '<i class="bi bi-shield-lock-fill text-success me-1"></i> Secure Payment by Razorpay';
      } else {
        btn.innerText = 'Review free booking';
        if (hint) hint.innerHTML = '<i class="bi bi-check-circle-fill text-success me-1"></i> No payment required for this mode';
      }
    }

    function localDateISO(d) {
      var y = d.getFullYear();
      var m = String(d.getMonth() + 1).padStart(2, '0');
      var day = String(d.getDate()).padStart(2, '0');
      return y + '-' + m + '-' + day;
    }

    function renderDates() {
      var dateScroll = document.getElementById('dateScroll');
      if(!availableDays.length) {
        dateScroll.innerHTML = '<p class="text-danger small fw-700 p-2">This doctor has not set their schedule yet.</p>';
        document.getElementById('payBtn').innerText = 'Schedule Unavailable';
        return;
      }

      var blockedList = (doctorBlockedDatesStr || "").split(/[,|]/).map(s => s.trim()).filter(Boolean);
      var html = '';
      var d = new Date();
      var count = 0;
      var firstDateISO = null;

      while(count < 14) {
        if(availableDays.includes(d.getDay())) {
          var dateISO = localDateISO(d);
          if (!blockedList.includes(dateISO)) {
            if (!firstDateISO) firstDateISO = dateISO;
            var dayName = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][d.getDay()];
            html += `<div class="day-selector-item" onclick="selectDate(this, '\${dateISO}')">
                      <div class="small fw-700 opacity-50">\${dayName}</div>
                      <div class="fs-5 fw-900">\${d.getDate()}</div>
                     </div>`;
            count++;
          }
        }
        d.setDate(d.getDate() + 1);
      }
      if(html === '') {
         dateScroll.innerHTML = '<p class="text-danger small fw-700 p-2">No available dates found.</p>';
      } else {
         dateScroll.innerHTML = html;
         var firstEl = dateScroll.querySelector('.day-selector-item');
         if (firstEl && firstDateISO) {
           selectDate(firstEl, firstDateISO);
         }
      }
      syncFeeUi();
    }

    var selectedDateObj = null;
    function selectDate(el, dateISO) {
      document.querySelectorAll('.day-selector-item').forEach(i => i.classList.remove('active'));
      el.classList.add('active');
      selectedDateObj = new Date(dateISO + 'T00:00:00');
      renderTimeSlots();
    }

    function renderTimeSlots() {
      var sessionSlots = document.getElementById('sessionSlots');
      if (!sessionSlots) return;
      if(!doctorStartTime || !doctorEndTime) {
        sessionSlots.innerHTML = '<p class="text-muted small py-3 w-100 text-center">Doctor clinic hours not set.</p>';
        return;
      }

      var start = parseMinutes(doctorStartTime);
      var end = parseMinutes(doctorEndTime);
      if (start === null || end === null) {
        sessionSlots.innerHTML = '<p class="text-muted small py-3 w-100 text-center">Invalid doctor clinic hours.</p>';
        return;
      }

      var bStart = parseMinutes(doctorBreakStart);
      var bEnd = parseMinutes(doctorBreakEnd);

      var now = new Date();
      var isToday = selectedDateObj && (
        selectedDateObj.getFullYear() === now.getFullYear() &&
        selectedDateObj.getMonth() === now.getMonth() &&
        selectedDateObj.getDate() === now.getDate()
      );
      var minMinutesToday = now.getHours() * 60 + now.getMinutes() + 15;

      var step = doctorSlotDuration >= 10 ? doctorSlotDuration : 30;
      var html = '';
      var slotCount = 0;

      for(var m = start; m < end; m += step) {
        // Skip slot if it falls inside doctor's break time
        if (bStart !== null && bEnd !== null && m >= bStart && m < bEnd) {
          continue;
        }
        // Skip slot if date is today and time is in past or too close (less than 15 mins)
        if (isToday && m < minMinutesToday) {
          continue;
        }

        var h = Math.floor(m / 60);
        var mm = m % 60;
        var ampm = h >= 12 ? 'PM' : 'AM';
        var displayH = (h % 12 || 12);
        var t12 = displayH + ':' + (mm < 10 ? '0' : '') + mm + ' ' + ampm;
        var t24 = (h < 10 ? '0' : '') + h + ':' + (mm < 10 ? '0' : '') + mm + ':00';
        html += `<div class="time-slot-pill" onclick="selectTime(this, '\${t24}', '\${t12}')">\${t12}</div>`;
        slotCount++;
      }

      if (slotCount === 0) {
        sessionSlots.innerHTML = '<p class="text-muted small py-3 w-100 text-center">No available time slots on this date (outside break hours).</p>';
      } else {
        sessionSlots.innerHTML = html;
      }
    }

    function selectTime(el, t24, t12) {
      document.querySelectorAll('.time-slot-pill').forEach(i => i.classList.remove('selected'));
      el.classList.add('selected');
      var fullTime = localDateISO(selectedDateObj) + ' ' + t24;
      document.getElementById('appointmentTime').value = fullTime;
      document.getElementById('summaryText').innerText = selectedDateObj.toDateString() + ' at ' + t12;
      document.getElementById('selectedSummary').classList.remove('d-none');
      document.getElementById('payBtn').disabled = false;
      document.getElementById('payBtn').style.opacity = '1';
      syncFeeUi();
    }

    async function bookFree(doctorId, time, type, reason) {
      const res = await fetch('${pageContext.request.contextPath}/api/doctors/' + doctorId + '/appointments', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        credentials: 'same-origin',
        body: JSON.stringify({ appointmentTime: time, consultationType: type, reason: reason || '' })
      });
      let data = {};
      try { data = await res.json(); } catch (e) {}
      if (res.status === 401) {
        alert('Please log in as a patient to book this appointment.');
        window.location.href = '${pageContext.request.contextPath}/login';
        return false;
      }
      if (res.ok && (data.success || data.appointmentId)) {
        showBookingSuccess(data);
        return true;
      }
      alert(data.error || 'Unable to book appointment');
      return false;
    }

    async function initiatePayment() {
      syncFeeUi();
      var payBtn = document.getElementById('payBtn');
      var bpConfirmBtn = document.getElementById('bpConfirmBtn');
      if (payBtn && payBtn.dataset.busy === '1') return;
      if (payBtn) {
        payBtn.dataset.busy = '1';
        payBtn.disabled = true;
        payBtn.dataset.label = payBtn.textContent;
        payBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Processing...';
      }
      if (bpConfirmBtn) {
        bpConfirmBtn.disabled = true;
        bpConfirmBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Processing...';
      }

      const amount = document.getElementById('amount').value;
      const doctorId = document.getElementById('doctorId').value;
      const time = document.getElementById('appointmentTime').value;
      const typeEl = document.querySelector('input[name="consultationType"]:checked');
      const type = typeEl ? typeEl.value : 'CLINIC';
      const reasonEl = document.getElementById('appointmentReason') || document.getElementById('reason');
      const reason = reasonEl ? (reasonEl.value || '').trim() : '';
      const fee = parseFloat(amount || '0');
      const patientName = (document.getElementById('patientName') || {}).value || '${user.fullName}';
      const patientPhone = (document.getElementById('patientPhone') || {}).value || '${user.phoneNumber}';

      function unlockPay() {
        if (payBtn) {
          payBtn.dataset.busy = '0';
          payBtn.disabled = !time;
          payBtn.innerHTML = payBtn.dataset.label || (fee > 0 ? ('Review & Pay ₹' + fee) : 'Review free booking');
        }
        if (bpConfirmBtn) {
          bpConfirmBtn.disabled = false;
          bpConfirmBtn.innerHTML = fee > 0 ? ('Confirm & Pay ₹' + fee) : 'Confirm free booking';
        }
      }

      if (!time) {
        alert('Please select date and time');
        unlockPay();
        return;
      }

      if (fee <= 0) {
        try {
          await bookFree(doctorId, time, type, reason);
        } finally {
          unlockPay();
        }
        return;
      }

      try {
        const orderRes = await fetch('${pageContext.request.contextPath}/payment/create-order', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          credentials: 'same-origin',
          body: JSON.stringify({
            type: 'DOCTOR',
            targetId: doctorId,
            consultationType: type,
            appointmentTime: time,
            reason: reason,
            amount: fee
          })
        });

        if (orderRes.status === 401) {
          alert('Please log in as a patient to proceed with payment.');
          window.location.href = '${pageContext.request.contextPath}/login';
          unlockPay();
          return;
        }

        const order = await orderRes.json().catch(() => ({}));
        if (!orderRes.ok || !order.orderId) {
          throw new Error(order.error || 'Could not create payment order');
        }

        // Mock payment flow (for local development or test mode)
        if (order.mock === true || (order.key && order.key.startsWith('rzp_test_mock'))) {
          const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            credentials: 'same-origin',
            body: JSON.stringify({
              razorpay_order_id: order.orderId,
              razorpay_payment_id: 'mock_pay_' + Date.now(),
              razorpay_signature: 'mock_sig',
              type: 'DOCTOR',
              targetId: doctorId,
              consultationType: type,
              appointmentTime: time,
              reason: reason
            })
          });

          const verifyData = await verifyRes.json().catch(() => ({}));
          if (!verifyRes.ok || verifyData.error) {
            throw new Error(verifyData.error || 'Payment verification failed');
          }
          showBookingSuccess(verifyData);
          return;
        }

        // Real Razorpay gateway
        if (typeof Razorpay === 'undefined') {
          throw new Error('Payment gateway SDK failed to load. Please check your internet connection.');
        }

        const options = {
          key: order.key,
          amount: order.amount,
          currency: order.currency || 'INR',
          name: 'Fight D Fear Healthcare',
          description: 'Consultation with Dr. ${doctor.fullName}',
          order_id: order.orderId,
          handler: async function (response) {
            try {
              const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                credentials: 'same-origin',
                body: JSON.stringify({
                  razorpay_order_id: response.razorpay_order_id,
                  razorpay_payment_id: response.razorpay_payment_id,
                  razorpay_signature: response.razorpay_signature,
                  type: 'DOCTOR',
                  targetId: doctorId,
                  consultationType: type,
                  appointmentTime: time,
                  reason: reason
                })
              });
              const verifyData = await verifyRes.json().catch(() => ({}));
              if (verifyRes.ok && (verifyData.success || verifyData.status === 'success' || verifyData.appointmentId)) {
                showBookingSuccess(verifyData);
              } else {
                alert('Payment verification failed: ' + (verifyData.error || 'Please contact support'));
                unlockPay();
              }
            } catch (err) {
              alert('Error verifying payment: ' + err.message);
              unlockPay();
            }
          },
          prefill: {
            name: patientName,
            email: '${user.email}',
            contact: patientPhone
          },
          theme: { color: '#F43F5E' },
          modal: {
            ondismiss: function () {
              unlockPay();
            }
          }
        };

        const rzp = new Razorpay(options);
        rzp.on('payment.failed', function (resp) {
          alert('Payment failed: ' + (resp.error ? resp.error.description : 'Transaction cancelled'));
          unlockPay();
        });
        rzp.open();

      } catch (e) {
        alert(e.message || 'Payment initiation failed. Please try again.');
        unlockPay();
      }
    }

    function closeBookingPreview() {
      var overlay = document.getElementById('bookingPreviewModal');
      if (overlay) overlay.classList.remove('open');
    }
    function showBookingPreview() {
      var time = document.getElementById('appointmentTime').value;
      if (!time) {
        alert('Please select date and time');
        return;
      }
      var type = (document.querySelector('input[name="consultationType"]:checked') || {}).value || 'CLINIC';
      var modeLabel = type === 'VIDEO' ? 'Video consultation' : (type === 'ONLINE' ? 'Online' : 'Clinic visit');
      var fee = currentFee();
      var reasonEl = document.getElementById('appointmentReason');
      var patient = (document.getElementById('patientName') || {}).value || '${user.fullName}';
      document.getElementById('bpWhen').textContent = (document.getElementById('summaryText') || {}).innerText || time;
      document.getElementById('bpMode').textContent = modeLabel;
      document.getElementById('bpFee').textContent = fee > 0 ? ('₹' + fee) : 'Free';
      document.getElementById('bpPatient').textContent = patient || 'Not provided';
      document.getElementById('bpReason').textContent = (reasonEl && reasonEl.value.trim()) ? reasonEl.value.trim() : 'Not provided';
      document.getElementById('bpPayHint').textContent = fee > 0 ? 'You will complete payment on the next step.' : 'No payment is required.';
      var confirmBtn = document.getElementById('bpConfirmBtn');
      confirmBtn.textContent = fee > 0 ? ('Confirm & Pay ₹' + fee) : 'Confirm free booking';
      document.getElementById('bookingPreviewModal').classList.add('open');
    }
    function confirmBookingFromPreview() {
      closeBookingPreview();
      initiatePayment();
    }
    function showBookingSuccess(data) {
      var overlay = document.getElementById('bookingSuccessModal');
      if (!overlay) {
        window.location.href = '${pageContext.request.contextPath}/doctors/myAppointments?message=Booking-Confirmed';
        return;
      }
      document.getElementById('bsWhen').textContent = (document.getElementById('bpWhen') || {}).textContent || (document.getElementById('summaryText') ? document.getElementById('summaryText').innerText : '—');
      document.getElementById('bsMode').textContent = (document.getElementById('bpMode') || {}).textContent || 'Consultation';
      document.getElementById('bsFee').textContent = (document.getElementById('bpFee') || {}).textContent || '—';
      
      var fee = currentFee();
      var bsTitle = document.getElementById('bsTitle');
      var bsDesc = document.getElementById('bsDesc');
      var bsPaymentStatus = document.getElementById('bsPaymentStatus');
      var bsReceiptRow = document.getElementById('bsReceiptRow');
      var bsReceipt = document.getElementById('bsReceipt');

      if (fee > 0) {
        if (bsTitle) bsTitle.textContent = 'Payment & Booking Confirmed!';
        if (bsDesc) bsDesc.textContent = 'Your payment was successful and your appointment has been confirmed with Dr. ${doctor.fullName}.';
        if (bsPaymentStatus) bsPaymentStatus.innerHTML = '<span class="badge bg-success">Paid</span>';
        if (data && data.receipt && data.receipt.receiptNumber) {
          if (bsReceiptRow) bsReceiptRow.style.display = 'flex';
          if (bsReceipt) bsReceipt.textContent = data.receipt.receiptNumber;
        }
      } else {
        if (bsTitle) bsTitle.textContent = 'Appointment Requested!';
        if (bsDesc) bsDesc.textContent = 'Your booking request has been sent to Dr. ${doctor.fullName}.';
        if (bsPaymentStatus) bsPaymentStatus.innerHTML = '<span class="badge bg-secondary">Free</span>';
      }

      overlay.classList.add('open');
    }

    document.addEventListener('DOMContentLoaded', function() {
      renderDates();


      var reasonBox = document.getElementById('appointmentReason');
      var reasonCount = document.getElementById('reasonCount');
      if (reasonBox && reasonCount) {
        reasonBox.addEventListener('input', function() {
          reasonCount.textContent = reasonBox.value.length;
        });
      }

      var reviewForm = document.getElementById('doctorReviewForm');
      if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
          var selected = reviewForm.querySelector('input[name="rating"]:checked');
          var err = document.getElementById('ratingError');
          if (!selected) {
            e.preventDefault();
            if (err) err.style.display = 'block';
            var modalEl = document.getElementById('reviewModal');
            if (modalEl && window.bootstrap) {
              bootstrap.Modal.getOrCreateInstance(modalEl).show();
            }
            return false;
          }
          if (err) err.style.display = 'none';
        });

        reviewForm.querySelectorAll('input[name="rating"]').forEach(function(radio) {
          radio.addEventListener('change', function() {
            var err = document.getElementById('ratingError');
            if (err) err.style.display = 'none';
          });
        });
      }

      <c:if test="${not empty error}">
      var modalEl = document.getElementById('reviewModal');
      if (modalEl && window.bootstrap) {
        bootstrap.Modal.getOrCreateInstance(modalEl).show();
      }
      </c:if>

      document.querySelectorAll('input[name="consultationType"]').forEach(function(el) {
        el.addEventListener('change', syncFeeUi);
      });
      syncFeeUi();

    });
  </script>
  </div>
</div>
</body>
</html>

