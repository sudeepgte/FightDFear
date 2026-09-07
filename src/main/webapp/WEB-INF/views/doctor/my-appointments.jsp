<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Appointments — Fight D Fear</title>
  
  <!-- Fonts & Icons -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Caveat:wght@600;700&family=Inter:wght@400;500;600;700;800;900&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-tokens.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

  <style>
    :root {
      --primary: #F43F5E;
      --primary-hover: #E11D48;
      --rose-soft: #FFF1F2;
      --rose-border: #FECDD3;
      --rose-tint: #FFF5F6;
      --bg-page: #F8FAFC;
      --navy: #0F172A;
      --navy-soft: #1E293B;
      --text-muted: #64748B;
      --border: #E2E8F0;
      --card-shadow: 0 4px 20px rgba(15, 23, 42, 0.04);
      --card-radius: 20px;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Poppins', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      background: var(--bg-page);
      min-height: 100vh;
      color: var(--navy);
      overflow-x: hidden;
    }

    #page-content-wrapper {
      flex: 1;
      min-width: 0;
      display: flex;
      flex-direction: column;
      padding: 24px 28px 40px !important;
      background: var(--bg-page) !important;
    }

    /* Page Heading Header */
    .ma-page-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 24px;
      position: relative;
    }
    .ma-header-text h1 {
      font-size: 28px;
      font-weight: 800;
      color: var(--navy);
      margin: 0 0 6px;
      letter-spacing: -0.4px;
    }
    .ma-header-text p {
      font-size: 14px;
      color: var(--text-muted);
      margin: 0;
    }
    .ma-slogan-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      color: #E11D48;
      font-family: 'Caveat', cursive;
      font-size: 22px;
      line-height: 1.15;
      text-align: right;
      transform: rotate(-3deg);
    }
    .ma-slogan-badge i {
      font-size: 26px;
      color: #F43F5E;
    }

    /* Alert Banner */
    .ma-alert-banner {
      background: #FFF1F2;
      border: 1px solid #FECDD3;
      border-radius: 16px;
      padding: 16px 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: 24px;
      position: relative;
      animation: fadeIn 0.3s ease;
    }
    .ma-alert-icon {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: #E11D48;
      color: #ffffff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: 900;
      flex-shrink: 0;
    }
    .ma-alert-title {
      font-size: 14px;
      font-weight: 800;
      color: #9F1239;
      margin-bottom: 2px;
    }
    .ma-alert-desc {
      font-size: 13px;
      color: #BE123C;
    }

    /* Filter Pills */
    .ma-filter-bar {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
      overflow-x: auto;
      padding-bottom: 4px;
    }
    .ma-pill-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 9px 18px;
      border-radius: 50px;
      font-size: 13px;
      font-weight: 700;
      border: 1px solid var(--border);
      background: #ffffff;
      color: var(--navy-soft);
      cursor: pointer;
      transition: all 0.2s ease;
      white-space: nowrap;
      text-decoration: none;
    }
    .ma-pill-btn:hover {
      border-color: var(--rose-border);
      background: var(--rose-soft);
      color: var(--primary);
    }
    .ma-pill-btn.active {
      background: var(--rose-soft);
      border-color: var(--rose-border);
      color: var(--primary);
      box-shadow: 0 2px 8px rgba(244, 63, 94, 0.12);
    }
    .ma-pill-count {
      padding: 2px 8px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 800;
      background: #F1F5F9;
      color: var(--navy-soft);
    }
    .ma-pill-btn.active .ma-pill-count {
      background: rgba(244, 63, 94, 0.18);
      color: var(--primary);
    }

    /* 3-Column Grid Layout */
    .ma-board-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 20px;
      align-items: start;
      width: 100%;
      max-width: 100%;
      min-width: 0;
      box-sizing: border-box;
    }
    @media (max-width: 1280px) {
      .ma-board-grid {
        grid-template-columns: repeat(auto-fit, minmax(min(100%, 310px), 1fr));
        gap: 18px;
      }
    }
    @media (max-width: 991px) {
      .ma-board-grid {
        grid-template-columns: 1fr;
        gap: 16px;
      }
    }

    /* Column Container */
    .ma-column {
      background: #FFF9FA;
      border: 1px solid #FFE4E6;
      border-radius: var(--card-radius);
      padding: 20px;
      min-height: 480px;
      display: flex;
      flex-direction: column;
      min-width: 0;
      max-width: 100%;
      box-sizing: border-box;
    }
    .ma-column-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 18px;
      padding-bottom: 12px;
      border-bottom: 1px solid #FFE4E6;
      min-width: 0;
    }
    .ma-col-icon {
      width: 42px;
      height: 42px;
      border-radius: 12px;
      background: #FFF1F2;
      border: 1px solid var(--rose-border);
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 18px;
      flex-shrink: 0;
    }
    .ma-col-title {
      font-size: 15px;
      font-weight: 800;
      color: var(--navy);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .ma-col-desc {
      font-size: 12px;
      color: var(--text-muted);
      margin: 2px 0 0;
    }

    /* Appointment Card */
    .ma-cards-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
      flex: 1;
      min-width: 0;
    }
    .ma-card-item {
      background: #ffffff;
      border-radius: 14px;
      border: 1px solid #F1F5F9;
      box-shadow: var(--card-shadow);
      padding: 14px 16px;
      transition: all 0.25s ease;
      cursor: pointer;
      position: relative;
      text-decoration: none;
      color: inherit;
      min-width: 0;
      max-width: 100%;
      overflow: hidden;
      box-sizing: border-box;
    }
    .ma-card-item:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 24px rgba(244, 63, 94, 0.08);
      border-color: var(--rose-border);
    }
    .ma-card-head {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
      flex-wrap: wrap;
      min-width: 0;
    }
    .ma-card-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
      background: var(--rose-soft);
      border: 2px solid #FFE4E6;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
      color: var(--primary);
      font-size: 15px;
      flex-shrink: 0;
    }
    .ma-card-avatar img {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      object-fit: cover;
    }
    .ma-card-names {
      flex: 1 1 110px;
      min-width: 0;
    }
    .ma-card-name {
      font-size: 13.5px;
      font-weight: 800;
      color: var(--navy);
      margin: 0;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .ma-card-sub {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 1px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .ma-status-tag {
      padding: 3px 10px;
      border-radius: 50px;
      font-size: 10.5px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      flex-shrink: 0;
      margin-left: auto;
    }
    .ma-status-tag.pending {
      background: #FFF1F2;
      color: #E11D48;
      border: 1px solid #FECDD3;
    }
    .ma-status-tag.confirmed {
      background: #FFF1F2;
      color: #E11D48;
      border: 1px solid #FECDD3;
    }
    .ma-status-tag.completed {
      background: #F1F5F9;
      color: #475569;
      border: 1px solid #CBD5E1;
    }
    .ma-status-tag.cancelled {
      background: #FEE2E2;
      color: #991B1B;
      border: 1px solid #FCA5A5;
    }

    .ma-card-details {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-size: 12px;
      min-width: 0;
    }
    .ma-detail-row {
      display: flex;
      align-items: center;
      gap: 8px;
      color: #334155;
      font-weight: 600;
      min-width: 0;
    }
    .ma-detail-row span {
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      min-width: 0;
    }
    .ma-detail-row i {
      color: var(--primary);
      font-size: 13px;
      width: 16px;
      text-align: center;
      flex-shrink: 0;
    }
    .ma-reason-box {
      margin-top: 4px;
      padding-top: 8px;
      border-top: 1px dashed #F1F5F9;
      min-width: 0;
    }
    .ma-reason-lbl {
      font-size: 10px;
      font-weight: 700;
      color: #94A3B8;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }
    .ma-reason-txt {
      font-size: 12px;
      color: var(--navy-soft);
      margin-top: 1px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .ma-card-arrow {
      display: none;
    }

    /* Prescription specific card styles */
    .btn-view-rx {
      border: 1.5px solid var(--primary);
      background: #ffffff;
      color: var(--primary);
      border-radius: 50px;
      font-weight: 700;
      font-size: 11px;
      padding: 4px 10px;
      transition: all 0.2s ease;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      white-space: nowrap;
      flex-shrink: 0;
      margin-left: auto;
    }
    .btn-view-rx:hover {
      background: var(--primary);
      color: #ffffff;
    }
    .ma-rx-footer-box {
      margin-top: auto;
      padding-top: 18px;
      min-width: 0;
    }
    .ma-rx-quote-box {
      background: #FFF1F2;
      border: 1px dashed #FECDD3;
      border-radius: 14px;
      padding: 12px 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      text-align: center;
      min-width: 0;
    }
    .ma-rx-quote-box i {
      font-size: 20px;
      color: var(--primary);
    }
    .ma-rx-quote-title {
      font-size: 12px;
      font-weight: 800;
      color: #9F1239;
    }
    .ma-rx-quote-sub {
      font-size: 11px;
      color: #BE123C;
      font-weight: 500;
    }

    /* Empty state inside column */
    .ma-col-empty {
      text-align: center;
      padding: 40px 16px;
      color: var(--text-muted);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      flex: 1;
    }
    .ma-col-empty i {
      font-size: 36px;
      opacity: 0.25;
      margin-bottom: 8px;
      color: var(--primary);
    }
    .ma-col-empty p {
      font-size: 13px;
      margin: 0;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-6px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Mobile & Tablet Responsive Enhancements */
    @media (max-width: 768px) {
      #page-content-wrapper {
        padding: 16px 12px 36px !important;
      }
      .ma-page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 6px;
        margin-bottom: 16px;
      }
      .ma-header-text h1 {
        font-size: 22px;
      }
      .ma-header-text p {
        font-size: 13px;
      }
      .ma-alert-banner {
        padding: 12px 14px;
        gap: 12px;
        border-radius: 12px;
        margin-bottom: 16px;
      }
      .ma-filter-bar {
        gap: 8px;
        margin-bottom: 16px;
        scrollbar-width: none;
      }
      .ma-filter-bar::-webkit-scrollbar {
        display: none;
      }
      .ma-pill-btn {
        padding: 7px 12px;
        font-size: 12px;
      }
      .ma-column {
        padding: 14px 12px;
        border-radius: 16px;
        min-height: auto;
      }
      .ma-col-header {
        gap: 10px;
        margin-bottom: 12px;
        padding-bottom: 10px;
      }
      .ma-col-icon {
        width: 36px;
        height: 36px;
        font-size: 16px;
        border-radius: 10px;
      }
      .ma-col-title {
        font-size: 14px;
      }
      .ma-col-desc {
        font-size: 11px;
      }
      .ma-card-item {
        padding: 12px 14px;
        border-radius: 12px;
      }
      .ma-card-avatar {
        width: 36px;
        height: 36px;
        font-size: 14px;
      }
      .ma-card-name {
        font-size: 13px;
      }
      .btn-view-rx {
        font-size: 10.5px;
        padding: 4px 8px;
      }
    }
  </style>
</head>
<body>

<!-- Universal Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- Main Dashboard Layout Shell -->
<div id="wrapper">
  <!-- Universal Sidebar -->
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

  <!-- Main Page Content Wrapper -->
  <div id="page-content-wrapper" data-skip-global-back="true">
    
    <!-- Page Title & Slogan Header -->
    <div class="ma-page-header">
      <div class="ma-header-text">
        <h1>My Appointments</h1>
        <p>View and manage your patient appointments, consultations and prescriptions.</p>
      </div>
      <div class="ma-slogan-badge d-none d-md-flex">
        <div>Healthier<br>Stronger<br>Brighter You</div>
        <i class="bi bi-heart"></i>
      </div>
    </div>

    <!-- Alert Banner -->
    <c:if test="${not empty param.message or not empty message}">
      <div class="ma-alert-banner alert alert-dismissible fade show" role="alert">
        <div class="ma-alert-icon">
          <i class="bi bi-check-lg"></i>
        </div>
        <div>
          <div class="ma-alert-title">${not empty message ? message : 'Booking Confirmed'}</div>
          <div class="ma-alert-desc">Your appointment has been successfully booked. You can track its confirmation and details below.</div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    </c:if>

    <!-- Categorized Count Calculations -->
    <c:set var="pendingCount" value="0" />
    <c:set var="confirmedCount" value="0" />
    <c:set var="prescriptionCount" value="0" />

    <c:forEach var="a" items="${appointments}">
      <c:if test="${a.status == 'PENDING'}">
        <c:set var="pendingCount" value="${pendingCount + 1}" />
      </c:if>
      <c:if test="${a.status == 'CONFIRMED' || a.status == 'COMPLETED'}">
        <c:set var="confirmedCount" value="${confirmedCount + 1}" />
      </c:if>
      <c:if test="${not empty a.prescriptionText}">
        <c:set var="prescriptionCount" value="${prescriptionCount + 1}" />
      </c:if>
    </c:forEach>

    <!-- Filter Pills Bar -->
    <div class="ma-filter-bar">
      <button type="button" class="ma-pill-btn active" onclick="filterBoard('all', this)">
        <i class="bi bi-grid-fill text-pink"></i> All Columns
      </button>
      <button type="button" class="ma-pill-btn" onclick="filterBoard('pending', this)">
        <i class="bi bi-clock-history text-danger"></i> Pending <span class="ma-pill-count">${pendingCount}</span>
      </button>
      <button type="button" class="ma-pill-btn" onclick="filterBoard('confirmed', this)">
        <i class="bi bi-calendar-check text-success"></i> Confirmed <span class="ma-pill-count">${confirmedCount}</span>
      </button>
      <button type="button" class="ma-pill-btn" onclick="filterBoard('prescriptions', this)">
        <i class="bi bi-file-earmark-medical text-primary"></i> Prescriptions <span class="ma-pill-count">${prescriptionCount}</span>
      </button>
    </div>

    <!-- 3-Column Board Layout -->
    <div class="ma-board-grid" id="boardGrid">

      <!-- Column 1: Pending Appointments -->
      <div class="ma-column" id="colPending">
        <div class="ma-column-header">
          <div class="ma-col-icon"><i class="bi bi-clock-history"></i></div>
          <div>
            <h3 class="ma-col-title">Pending Appointments (${pendingCount})</h3>
            <div class="ma-col-desc">Appointments awaiting confirmation or consultation.</div>
          </div>
        </div>

        <div class="ma-cards-list">
          <c:set var="hasPending" value="false" />
          <c:forEach var="a" items="${appointments}">
            <c:if test="${a.status == 'PENDING'}">
              <c:set var="hasPending" value="true" />
              <div class="ma-card-item"
                   role="button"
                   onclick="openUserApptPreview(this)"
                   data-doctor="${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}"
                   data-spec="${empty a.doctor.specialization ? 'General consultation' : a.doctor.specialization}"
                   data-hospital="${empty a.doctor.hospitalName ? '' : a.doctor.hospitalName}"
                   data-time="${empty a.appointmentTime ? '' : a.appointmentTime}"
                   data-reason="${empty a.reason ? '' : a.reason}"
                   data-type="${a.consultationType}"
                   data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
                   data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
                   data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
                   data-status="${a.status}"
                   data-chat-url="${pageContext.request.contextPath}/doctors/chat/${a.doctor.id}"
                   data-video-url="${pageContext.request.contextPath}/doctors/video-call/${a.doctor.id}"
                   data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${a.doctor.id}"
                   data-profile-url="${pageContext.request.contextPath}/doctors/view/${a.doctor.id}"
                   data-rx-url="<c:if test='${not empty a.prescriptionText}'>${pageContext.request.contextPath}/doctors/appointments/${a.id}/prescription/view</c:if>">
                
                <div class="ma-card-head">
                  <div class="ma-card-avatar">
                    <c:choose>
                      <c:when test="${not empty a.doctor.profilePhotoPath}">
                        <img src="${pageContext.request.contextPath}${a.doctor.profilePhotoPath}" alt="">
                      </c:when>
                      <c:otherwise>${empty a.doctor.fullName ? 'D' : a.doctor.fullName.charAt(0)}</c:otherwise>
                    </c:choose>
                  </div>
                  <div class="ma-card-names">
                    <div class="ma-card-name">Dr. ${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}</div>
                    <div class="ma-card-sub">${empty a.doctor.specialization ? 'General Physician' : a.doctor.specialization}</div>
                  </div>
                  <span class="ma-status-tag pending"><i class="bi bi-clock"></i> Pending</span>
                </div>

                <div class="ma-card-details">
                  <div class="ma-detail-row">
                    <i class="bi bi-calendar3"></i>
                    <span>${empty a.appointmentTime ? 'Time to be confirmed' : a.appointmentTime}</span>
                  </div>
                  <div class="ma-detail-row">
                    <c:choose>
                      <c:when test="${a.consultationType == 'VIDEO'}">
                        <i class="bi bi-camera-video"></i> <span>Video Consultation</span>
                      </c:when>
                      <c:when test="${a.consultationType == 'ONLINE'}">
                        <i class="bi bi-chat-dots"></i> <span>Online Chat</span>
                      </c:when>
                      <c:otherwise>
                        <i class="bi bi-geo-alt"></i> <span>In-clinic Visit</span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="ma-reason-box">
                    <div class="ma-reason-lbl">Reason for Visit</div>
                    <div class="ma-reason-txt text-truncate">${empty a.reason ? 'Regular check-up' : a.reason}</div>
                  </div>
                </div>

                <i class="bi bi-chevron-right ma-card-arrow"></i>
              </div>
            </c:if>
          </c:forEach>

          <c:if test="${!hasPending}">
            <div class="ma-col-empty">
              <i class="bi bi-clock-history"></i>
              <p>No pending appointment requests.</p>
            </div>
          </c:if>
        </div>
      </div>

      <!-- Column 2: Confirmed Appointments -->
      <div class="ma-column" id="colConfirmed">
        <div class="ma-column-header">
          <div class="ma-col-icon"><i class="bi bi-calendar2-check"></i></div>
          <div>
            <h3 class="ma-col-title">Confirmed Appointments (${confirmedCount})</h3>
            <div class="ma-col-desc">Upcoming and completed consultations.</div>
          </div>
        </div>

        <div class="ma-cards-list">
          <c:set var="hasConfirmed" value="false" />
          <c:forEach var="a" items="${appointments}">
            <c:if test="${a.status == 'CONFIRMED' || a.status == 'COMPLETED'}">
              <c:set var="hasConfirmed" value="true" />
              <div class="ma-card-item"
                   role="button"
                   onclick="openUserApptPreview(this)"
                   data-doctor="${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}"
                   data-spec="${empty a.doctor.specialization ? 'General consultation' : a.doctor.specialization}"
                   data-hospital="${empty a.doctor.hospitalName ? '' : a.doctor.hospitalName}"
                   data-time="${empty a.appointmentTime ? '' : a.appointmentTime}"
                   data-reason="${empty a.reason ? '' : a.reason}"
                   data-type="${a.consultationType}"
                   data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
                   data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
                   data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
                   data-status="${a.status}"
                   data-chat-url="${pageContext.request.contextPath}/doctors/chat/${a.doctor.id}"
                   data-video-url="${pageContext.request.contextPath}/doctors/video-call/${a.doctor.id}"
                   data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${a.doctor.id}"
                   data-profile-url="${pageContext.request.contextPath}/doctors/view/${a.doctor.id}"
                   data-rx-url="<c:if test='${not empty a.prescriptionText}'>${pageContext.request.contextPath}/doctors/appointments/${a.id}/prescription/view</c:if>">
                
                <div class="ma-card-head">
                  <div class="ma-card-avatar">
                    <c:choose>
                      <c:when test="${not empty a.doctor.profilePhotoPath}">
                        <img src="${pageContext.request.contextPath}${a.doctor.profilePhotoPath}" alt="">
                      </c:when>
                      <c:otherwise>${empty a.doctor.fullName ? 'D' : a.doctor.fullName.charAt(0)}</c:otherwise>
                    </c:choose>
                  </div>
                  <div class="ma-card-names">
                    <div class="ma-card-name">Dr. ${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}</div>
                    <div class="ma-card-sub">${empty a.doctor.specialization ? 'General Physician' : a.doctor.specialization}</div>
                  </div>
                  <c:choose>
                    <c:when test="${a.status == 'CONFIRMED'}">
                      <span class="ma-status-tag confirmed"><i class="bi bi-check-circle"></i> Confirmed</span>
                    </c:when>
                    <c:otherwise>
                      <span class="ma-status-tag completed"><i class="bi bi-check2-all"></i> Completed</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <div class="ma-card-details">
                  <div class="ma-detail-row">
                    <i class="bi bi-calendar3"></i>
                    <span>${empty a.appointmentTime ? 'Time to be confirmed' : a.appointmentTime}</span>
                  </div>
                  <div class="ma-detail-row">
                    <c:choose>
                      <c:when test="${a.consultationType == 'VIDEO'}">
                        <i class="bi bi-camera-video"></i> <span>Video Consultation</span>
                      </c:when>
                      <c:when test="${a.consultationType == 'ONLINE'}">
                        <i class="bi bi-chat-dots"></i> <span>Online Chat</span>
                      </c:when>
                      <c:otherwise>
                        <i class="bi bi-geo-alt"></i> <span>In-clinic Visit</span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="ma-reason-box">
                    <div class="ma-reason-lbl">Reason for Visit</div>
                    <div class="ma-reason-txt text-truncate">${empty a.reason ? 'Follow-up consultation' : a.reason}</div>
                  </div>
                </div>

                <i class="bi bi-chevron-right ma-card-arrow"></i>
              </div>
            </c:if>
          </c:forEach>

          <c:if test="${!hasConfirmed}">
            <div class="ma-col-empty">
              <i class="bi bi-calendar2-check"></i>
              <p>No confirmed appointments yet.</p>
            </div>
          </c:if>
        </div>
      </div>

      <!-- Column 3: Prescriptions -->
      <div class="ma-column" id="colPrescriptions">
        <div class="ma-column-header">
          <div class="ma-col-icon"><i class="bi bi-file-earmark-medical"></i></div>
          <div>
            <h3 class="ma-col-title">Prescriptions (${prescriptionCount})</h3>
            <div class="ma-col-desc">View and download your prescriptions.</div>
          </div>
        </div>

        <div class="ma-cards-list">
          <c:set var="hasRx" value="false" />
          <c:forEach var="a" items="${appointments}">
            <c:if test="${not empty a.prescriptionText}">
              <c:set var="hasRx" value="true" />
              <div class="ma-card-item" onclick="viewPrescription('${a.id}')">
                <textarea id="rx-data-${a.id}" style="display:none;" 
                  data-doc-name="<c:out value='${a.doctor.fullName}'/>"
                  data-doc-spec="<c:out value='${a.doctor.specialization}'/>"
                  data-hosp-name="<c:out value='${a.doctor.hospitalName}'/>"
                  data-address="<c:out value='${a.doctor.clinicAddress}'/>"
                  data-date="<c:out value='${a.appointmentTime}'/>"
                  data-patient-name="<c:out value='${a.user.fullName}'/>"><c:out value="${a.prescriptionText}" /></textarea>

                <div class="ma-card-head">
                  <div class="ma-card-avatar">
                    <c:choose>
                      <c:when test="${not empty a.doctor.profilePhotoPath}">
                        <img src="${pageContext.request.contextPath}${a.doctor.profilePhotoPath}" alt="">
                      </c:when>
                      <c:otherwise>${empty a.doctor.fullName ? 'D' : a.doctor.fullName.charAt(0)}</c:otherwise>
                    </c:choose>
                  </div>
                  <div class="ma-card-names">
                    <div class="ma-card-name">Dr. ${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}</div>
                    <div class="ma-card-sub">${empty a.doctor.specialization ? 'General Physician' : a.doctor.specialization}</div>
                  </div>
                  <button type="button" class="btn-view-rx" onclick="event.stopPropagation(); viewPrescription('${a.id}');">
                    View Prescription
                  </button>
                </div>

                <div class="ma-card-details">
                  <div class="ma-detail-row">
                    <i class="bi bi-calendar3"></i>
                    <span>${empty a.appointmentTime ? 'Recently Issued' : a.appointmentTime}</span>
                  </div>
                  <div class="ma-detail-row">
                    <i class="bi bi-file-earmark-text"></i>
                    <span>Medical Prescription &amp; Dosage</span>
                  </div>
                </div>

                <i class="bi bi-chevron-right ma-card-arrow"></i>
              </div>
            </c:if>
          </c:forEach>

          <c:if test="${!hasRx}">
            <div class="ma-col-empty">
              <i class="bi bi-file-earmark-medical"></i>
              <p>No prescriptions issued yet.</p>
            </div>
          </c:if>
        </div>

        <div class="ma-rx-footer-box">
          <div class="ma-rx-quote-box">
            <i class="bi bi-heart-pulse-fill"></i>
            <div class="text-start">
              <div class="ma-rx-quote-title">Better Conversations</div>
              <div class="ma-rx-quote-sub">Healthier Tomorrows</div>
            </div>
          </div>
        </div>
      </div>

    </div>

  </div>
</div>

<!-- Prescription View & Print Modal -->
<div id="rxModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(15,23,42,0.6);backdrop-filter:blur(4px);z-index:9999;align-items:center;justify-content:center;padding:20px;">
  <div style="background:#fff;border-radius:18px;width:100%;max-width:620px;max-height:90vh;overflow-y:auto;position:relative;box-shadow:0 20px 60px rgba(0,0,0,0.3);border:1px solid #FFE4E6;">
    <!-- Actions Header -->
    <div style="position:sticky;top:0;background:#FFF1F2;padding:14px 20px;border-bottom:1px solid #FECDD3;display:flex;justify-content:space-between;align-items:center;z-index:10;">
      <div style="font-weight:800;color:#9F1239;font-size:15px;display:flex;align-items:center;gap:6px;">
        <i class="bi bi-file-earmark-medical-fill"></i> Medical Prescription
      </div>
      <div style="display:flex;gap:8px;">
        <button onclick="downloadPDF()" style="padding:6px 14px;border:none;background:#F43F5E;color:#fff;border-radius:20px;cursor:pointer;font-size:12px;font-weight:700;"><i class="bi bi-download"></i> Download PDF</button>
        <button onclick="window.print()" style="padding:6px 14px;border:1px solid #E2E8F0;background:#fff;border-radius:20px;cursor:pointer;font-size:12px;font-weight:700;"><i class="bi bi-printer"></i> Print</button>
        <button onclick="document.getElementById('rxModal').style.display='none'" style="padding:6px 12px;border:none;background:#64748B;color:#fff;border-radius:20px;cursor:pointer;font-size:12px;font-weight:700;"><i class="bi bi-x-lg"></i></button>
      </div>
    </div>
    
    <!-- Printable Prescription Area -->
    <div id="rxPrintArea" style="padding:36px;background:#fff;color:#1E293B;font-family:'Inter', sans-serif;">
      <!-- Header -->
      <div style="display:flex;justify-content:space-between;align-items:center;border-bottom:2px solid #F43F5E;padding-bottom:16px;margin-bottom:16px;">
        <div>
          <h2 id="rxDocName" style="margin:0;font-size:20px;font-weight:900;color:#0F172A;"></h2>
          <div id="rxDocSpec" style="font-size:13px;color:#F43F5E;font-weight:700;margin-top:2px;"></div>
        </div>
        <div style="text-align:right;">
          <div style="font-size:22px;font-weight:bold;color:#F43F5E;"><i class="bi bi-heart-pulse-fill"></i></div>
          <div id="rxHospName" style="font-size:12px;font-weight:800;color:#64748B;text-transform:uppercase;"></div>
        </div>
      </div>
      
      <!-- Sub-header -->
      <div style="display:flex;justify-content:space-between;border-bottom:1px dashed #E2E8F0;padding-bottom:12px;margin-bottom:20px;font-size:12px;color:#64748B;">
        <div style="max-width:60%;">
          <strong style="color:#0F172A;">Clinic:</strong> <span id="rxAddress"></span>
        </div>
        <div style="text-align:right;">
          <strong style="color:#0F172A;">Date:</strong> <span id="rxDate"></span>
        </div>
      </div>
      
      <!-- Patient Details -->
      <div style="display:flex;justify-content:space-between;margin-bottom:24px;font-size:13px;background:#F8FAFC;padding:10px 14px;border-radius:10px;">
        <div><strong style="color:#0F172A;">Patient Name:</strong> <span id="rxPatientName" style="font-weight:700;color:#F43F5E;"></span></div>
      </div>
      
      <!-- Rx Symbol & Content -->
      <div style="min-height:240px;position:relative;">
        <div style="margin-bottom:14px;color:#F43F5E;font-size:24px;font-weight:900;font-style:italic;">
          ℞
        </div>
        <div id="rxContent" style="font-size:14px;line-height:1.7;white-space:pre-wrap;padding-left:10px;color:#1E293B;position:relative;z-index:2;"></div>
      </div>
      
      <!-- Footer & Signature -->
      <div style="margin-top:30px;border-top:1px solid #E2E8F0;padding-top:16px;display:flex;justify-content:flex-end;">
        <div style="text-align:center;width:200px;">
          <div id="rxDocSignature" style="font-family:'Caveat', cursive;font-size:26px;color:#0F172A;margin-bottom:2px;"></div>
          <div style="border-bottom:1.5px solid #0F172A;margin-bottom:4px;"></div>
          <div style="font-size:11px;font-weight:800;color:#64748B;text-transform:uppercase;">Doctor Signature</div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Appointment Preview Modal -->
<div id="userApptModal" class="doc-modal-overlay" onclick="if(event.target===this)closeUserApptPreview()">
  <div class="doc-modal" role="dialog" aria-modal="true" aria-labelledby="uaName">
    <div class="doc-modal-header">
      <div class="doc-appt-avatar" id="uaAvatar">D</div>
      <div>
        <h3 id="uaName">Doctor</h3>
        <p id="uaSpec">Appointment details</p>
      </div>
      <button type="button" class="doc-modal-close" onclick="closeUserApptPreview()" aria-label="Close"><i class="bi bi-x-lg"></i></button>
    </div>
    <div class="doc-modal-body">
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">1</span> Appointment</h4>
        <div class="doc-modal-row"><span class="k">Date &amp; time</span><span class="v" id="uaTime">—</span></div>
        <div class="doc-modal-row"><span class="k">Consultation</span><span class="v" id="uaType">—</span></div>
        <div class="doc-modal-row"><span class="k">Status</span><span class="v"><span id="uaStatus" class="doc-status pending">Pending</span></span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">2</span> Reason</h4>
        <div class="doc-modal-row"><span class="k">You provided</span><span class="v" id="uaReason">Not provided</span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">3</span> Payment</h4>
        <div class="doc-modal-row"><span class="k">Payment</span><span class="v" id="uaPayment">—</span></div>
        <div class="doc-modal-row"><span class="k">Receipt</span><span class="v" id="uaReceipt">Not issued</span></div>
      </div>
    </div>
    <div class="doc-modal-footer">
      <a id="uaChatBtn" class="doc-modal-btn primary" href="#" style="display:none"><i class="bi bi-chat-dots-fill"></i> Chat</a>
      <a id="uaCallBtn" class="doc-modal-btn success" href="#" target="_blank" style="display:none"><i class="bi bi-telephone-fill"></i> Call</a>
      <a id="uaVideoBtn" class="doc-modal-btn success" href="#" target="_blank" style="display:none"><i class="bi bi-camera-video-fill"></i> Join video</a>
      <a id="uaRxBtn" class="doc-modal-btn secondary" href="#" style="display:none"><i class="bi bi-file-earmark-medical"></i> Prescription</a>
      <a id="uaProfileBtn" class="doc-modal-btn secondary" href="#"><i class="bi bi-person"></i> Doctor profile</a>
      <button type="button" class="doc-modal-btn secondary" onclick="closeUserApptPreview()">Close</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
function filterBoard(category, btn) {
  document.querySelectorAll('.ma-pill-btn').forEach(function(b) { b.classList.remove('active'); });
  if (btn) btn.classList.add('active');

  var colPending = document.getElementById('colPending');
  var colConfirmed = document.getElementById('colConfirmed');
  var colPrescriptions = document.getElementById('colPrescriptions');
  var grid = document.getElementById('boardGrid');

  if (!colPending || !colConfirmed || !colPrescriptions || !grid) return;

  if (category === 'all') {
    colPending.style.display = 'flex';
    colConfirmed.style.display = 'flex';
    colPrescriptions.style.display = 'flex';
    grid.style.gridTemplateColumns = '';
  } else if (category === 'pending') {
    colPending.style.display = 'flex';
    colConfirmed.style.display = 'none';
    colPrescriptions.style.display = 'none';
    grid.style.gridTemplateColumns = '1fr';
  } else if (category === 'confirmed') {
    colPending.style.display = 'none';
    colConfirmed.style.display = 'flex';
    colPrescriptions.style.display = 'none';
    grid.style.gridTemplateColumns = '1fr';
  } else if (category === 'prescriptions') {
    colPending.style.display = 'none';
    colConfirmed.style.display = 'none';
    colPrescriptions.style.display = 'flex';
    grid.style.gridTemplateColumns = '1fr';
  }
}

document.addEventListener('DOMContentLoaded', function() {
  try {
    var params = new URLSearchParams(window.location.search);
    var sec = params.get('section');
    if (sec === 'prescriptions') {
      var rxBtn = document.querySelector(".ma-pill-btn[onclick*='prescriptions']");
      filterBoard('prescriptions', rxBtn);
    } else if (sec === 'pending') {
      var pBtn = document.querySelector(".ma-pill-btn[onclick*='pending']");
      filterBoard('pending', pBtn);
    } else if (sec === 'confirmed') {
      var cBtn = document.querySelector(".ma-pill-btn[onclick*='confirmed']");
      filterBoard('confirmed', cBtn);
    }
  } catch(e) {}
});

function viewPrescription(apptId) {
  var dataElem = document.getElementById('rx-data-' + apptId);
  if (!dataElem) return;
  var docName = dataElem.getAttribute('data-doc-name') || 'Doctor';
  
  document.getElementById('rxDocName').innerText = 'Dr. ' + docName;
  document.getElementById('rxDocSpec').innerText = dataElem.getAttribute('data-doc-spec') || 'Specialist';
  document.getElementById('rxHospName').innerText = dataElem.getAttribute('data-hosp-name') || 'Fight D Fear Medical';
  document.getElementById('rxAddress').innerText = dataElem.getAttribute('data-address') || '—';
  document.getElementById('rxDate').innerText = dataElem.getAttribute('data-date') || '—';
  document.getElementById('rxPatientName').innerText = dataElem.getAttribute('data-patient-name') || 'Patient';
  document.getElementById('rxContent').innerText = dataElem.value;
  document.getElementById('rxDocSignature').innerText = docName;
  
  document.getElementById('rxModal').style.display = 'flex';
}

function downloadPDF() {
  const element = document.getElementById('rxPrintArea');
  const opt = {
    margin:       0.5,
    filename:     'Prescription.pdf',
    image:        { type: 'jpeg', quality: 0.98 },
    html2canvas:  { scale: 2 },
    jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
  };
  html2pdf().set(opt).from(element).save();
}

function openUserApptPreview(el) {
  var overlay = document.getElementById('userApptModal');
  if (!overlay || !el) return;
  var doctor = el.getAttribute('data-doctor') || 'Doctor';
  var spec = el.getAttribute('data-spec') || 'General consultation';
  var hospital = el.getAttribute('data-hospital') || '';
  var time = el.getAttribute('data-time') || 'Time to be confirmed';
  var reason = el.getAttribute('data-reason') || '';
  var type = el.getAttribute('data-type') || 'CLINIC';
  var status = (el.getAttribute('data-status') || 'PENDING').toUpperCase();
  var payment = el.getAttribute('data-payment') || '';
  var amount = el.getAttribute('data-amount') || '';
  var receipt = el.getAttribute('data-receipt') || '';
  var chatUrl = el.getAttribute('data-chat-url') || '';
  var videoUrl = el.getAttribute('data-video-url') || '';
  var callUrl = el.getAttribute('data-call-url') || '';
  var profileUrl = el.getAttribute('data-profile-url') || '';
  var rxUrl = el.getAttribute('data-rx-url') || '';
  var typeLabel = type === 'VIDEO' ? 'Video consultation' : (type === 'ONLINE' ? 'Online' : 'Clinic visit');
  
  document.getElementById('uaAvatar').textContent = doctor.charAt(0).toUpperCase();
  document.getElementById('uaName').textContent = 'Dr. ' + doctor;
  document.getElementById('uaSpec').textContent = spec + (hospital ? ' · ' + hospital : '');
  document.getElementById('uaTime').textContent = time;
  document.getElementById('uaType').textContent = typeLabel;
  document.getElementById('uaReason').textContent = reason || 'Not provided';
  document.getElementById('uaStatus').textContent = status;
  document.getElementById('uaStatus').className = 'doc-status ' + status.toLowerCase();
  document.getElementById('uaPayment').textContent = amount ? ((payment || 'Paid') + ' · ₹' + amount) : (payment || 'Payment pending');
  document.getElementById('uaReceipt').textContent = receipt || 'Not issued';
  
  var chatBtn = document.getElementById('uaChatBtn');
  var videoBtn = document.getElementById('uaVideoBtn');
  var callBtn = document.getElementById('uaCallBtn');
  var profileBtn = document.getElementById('uaProfileBtn');
  var rxBtn = document.getElementById('uaRxBtn');
  
  var canChat = status === 'CONFIRMED' || status === 'COMPLETED';
  var canJoin = status === 'CONFIRMED' && (type === 'VIDEO' || type === 'ONLINE');
  
  if (chatUrl && canChat) { chatBtn.href = chatUrl; chatBtn.style.display = 'inline-flex'; } else { chatBtn.style.display = 'none'; }
  if (videoUrl && canJoin) { videoBtn.href = videoUrl; videoBtn.style.display = 'inline-flex'; } else { videoBtn.style.display = 'none'; }
  if (callUrl && canJoin) { callBtn.href = callUrl; callBtn.style.display = 'inline-flex'; } else { callBtn.style.display = 'none'; }
  if (profileUrl) { profileBtn.href = profileUrl; profileBtn.style.display = 'inline-flex'; } else { profileBtn.style.display = 'none'; }
  if (rxUrl) { rxBtn.href = rxUrl; rxBtn.style.display = 'inline-flex'; } else { rxBtn.style.display = 'none'; }
  
  overlay.classList.add('open');
}

function closeUserApptPreview() {
  var overlay = document.getElementById('userApptModal');
  if (overlay) overlay.classList.remove('open');
}

document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') {
    closeUserApptPreview();
    var rxModal = document.getElementById('rxModal');
    if (rxModal) rxModal.style.display = 'none';
  }
});
</script>

</body>
</html>
