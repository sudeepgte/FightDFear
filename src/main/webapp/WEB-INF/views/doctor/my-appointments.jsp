<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Appointments — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-tokens.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <style>
    :root{
      --primary:#F43F5E;--rose-soft:#FFF1F2;--bg-page:#F8FAFC;--navy:#0F172A;--navy-soft:#1E293B;--border:#E2E8F0;
      --ma-coral:#f43f5e;--ma-teal:#16a34a;--ma-gold:#eab308;--ma-bg:var(--bg-page);--ma-card:#fff;
      --ma-text:var(--navy);--ma-muted:#64748b;--ma-border:var(--border);
      --ma-gradient:linear-gradient(135deg,#0F172A 0%,#1E293B 70%,#F43F5E 140%);
      --ma-shadow:0 4px 20px rgba(15, 23, 42, 0.04);--ma-radius:16px;
      --sidebar-w:240px
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Inter',-apple-system,BlinkMacSystemFont,sans-serif;background:var(--ma-bg);min-height:100vh;color:var(--ma-text);overflow-x:hidden}

    /* Hero */
    .ma-hero{background:var(--ma-gradient);padding:32px 24px 60px;position:relative}
    .ma-hero::after{content:'';position:absolute;bottom:-1px;left:0;right:0;height:40px;background:var(--ma-bg);border-radius:40px 40px 0 0}
    .ma-back{position:absolute;top:16px;left:16px;width:40px;height:40px;border-radius:50%;background:rgba(255,255,255,0.15);display:flex;align-items:center;justify-content:center;color:#fff;text-decoration:none;font-size:18px;z-index:5;transition:all 0.2s}
    .ma-back:hover{background:rgba(255,255,255,0.3)}

    /* Header Card */
    .ma-header-card{margin:-30px 24px 0;position:relative;z-index:3;background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:0 8px 40px rgba(30, 27, 75, 0.12);padding:28px;display:flex;align-items:center;gap:20px}
    .ma-header-icon{width:60px;height:60px;border-radius:16px;background:var(--ma-gradient);display:flex;align-items:center;justify-content:center;font-size:24px;color:#fff;flex-shrink:0}
    .ma-header-info h1{font-size:22px;font-weight:800;margin:0}
    .ma-header-info p{font-size:13px;color:var(--ma-muted);margin:2px 0 0}
    .ma-header-stats{margin-left:auto;display:flex;gap:16px;flex-shrink:0}
    .ma-stat{text-align:center;padding:8px 16px;border-radius:12px;background:var(--rose-soft);min-width:70px}
    .ma-stat .num{font-size:22px;font-weight:800;color:var(--primary)}
    .ma-stat .lbl{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;color:var(--ma-muted)}

    /* Main Layout */
    .ma-main{margin:24px 24px 0;padding:0 0 24px;display:grid;grid-template-columns:var(--sidebar-w) 1fr;gap:24px;align-items:stretch;min-height:calc(100vh - 260px)}
    .ma-page-footer{margin-top:8px;width:100%}
    .ma-page-footer .footer{margin:0}

    /* Sidebar */
    .ma-sidebar{position:sticky;top:24px;background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border);overflow:hidden;display:flex;flex-direction:column}
    .ma-sidebar-nav{display:flex;flex-direction:column;padding:8px;flex:1}
    .ma-sidebar-btn{display:flex;align-items:center;gap:12px;padding:14px 18px;border:none;background:transparent;font-size:14px;font-weight:600;font-family:inherit;color:var(--ma-muted);cursor:pointer;border-radius:10px;transition:all 0.2s;text-align:left;margin-bottom:2px;text-decoration:none}
    .ma-sidebar-btn i{font-size:18px;width:22px;text-align:center}
    .ma-sidebar-btn:hover{background:var(--rose-soft);color:var(--primary)}
    .ma-sidebar-btn.active{background:var(--rose-soft);color:var(--primary);box-shadow:inset 3px 0 0 var(--primary)}
    .ma-sidebar-btn.active i{color:var(--primary)}
    .ma-sidebar-footer{padding:16px 18px;border-top:1px solid var(--ma-border);font-size:11px;color:var(--ma-muted)}
    .ma-sidebar-footer a{color:var(--primary);text-decoration:none;font-weight:600;transition:all 0.2s ease;display:inline-block}
    .ma-sidebar-footer a:hover{color:#e11d48;transform:translateX(3px)}

    /* Content */
    .ma-content{min-width:0;display:flex;flex-direction:column}
    .ma-panel{display:none;animation:maFadeIn 0.3s ease}
    .ma-panel.active{display:flex;flex-direction:column;flex:1}
    @keyframes maFadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

    /* Flash */
    .ma-flash{padding:14px 20px;border-radius:12px;background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.2);color:#0d9668;font-size:13px;font-weight:500;margin-bottom:16px;display:flex;align-items:center;gap:8px}

    /* Appointment Cards */
    .ma-appt-list{display:flex;flex-direction:column;gap:14px;flex:1}
    .ma-appt-card{background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border);padding:20px 24px;display:flex;align-items:center;gap:20px;transition:all 0.25s;cursor:pointer}
    .ma-appt-card:hover{transform:translateY(-2px);box-shadow:0 8px 32px rgba(15, 23, 42, 0.08);border-color:#FECDD3}

    .ma-doc-avatar{width:56px;height:56px;border-radius:50%;background:var(--primary);display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:800;color:#fff;flex-shrink:0}
    .ma-doc-avatar img{width:56px;height:56px;border-radius:50%;object-fit:cover}

    .ma-appt-info{flex:1;min-width:0}
    .ma-appt-info .doc-name{font-size:15px;font-weight:700;margin:0}
    .ma-appt-info .doc-spec{font-size:12px;color:var(--primary);font-weight:600}
    .ma-appt-info .appt-meta{display:flex;gap:16px;margin-top:6px;flex-wrap:wrap}
    .ma-appt-info .appt-meta span{font-size:12px;color:var(--ma-muted);display:flex;align-items:center;gap:4px}
    .ma-appt-info .appt-meta span i{font-size:14px;color:var(--primary)}

    .ma-appt-right{display:flex;flex-direction:column;align-items:flex-end;gap:8px;flex-shrink:0}
    .ma-status{padding:5px 14px;border-radius:999px;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px}
    .ma-status.pending{background:#FEF3C7;color:#92400E}
    .ma-status.confirmed{background:#DCFCE7;color:#166534}
    .ma-status.completed{background:#F1F5F9;color:#475569}
    .ma-status.cancelled{background:#FEE2E2;color:#991B1B}
    .ma-status.rejected{background:#FEE2E2;color:#991B1B}

    .ma-type-badge{padding:4px 12px;border-radius:8px;font-size:10px;font-weight:600;display:inline-flex;align-items:center;gap:4px}
    .ma-type-badge.clinic{background:#DCFCE7;color:#166534}
    .ma-type-badge.video{background:#FFF1F2;color:#BE123C}

    .ma-join-btn{padding:8px 16px;border:none;border-radius:10px;background:var(--ma-teal);color:#fff;font-size:12px;font-weight:700;font-family:inherit;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all 0.2s;min-height:40px}
    .ma-join-btn:hover{filter:brightness(1.08);color:#fff}

    /* Empty state */
    .ma-empty{text-align:center;padding:60px 20px;color:var(--ma-muted);flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border)}
    .ma-empty i{font-size:56px;opacity:0.2;margin-bottom:12px}
    .ma-empty p{font-size:14px;margin:4px 0 0}
    .ma-empty a{margin-top:16px;padding:10px 28px;border-radius:999px;background:var(--primary);color:#fff;text-decoration:none;font-size:13px;font-weight:700}

    /* Responsive */
    @media(max-width:800px){
      .ma-main{grid-template-columns:1fr;gap:16px}
      .ma-sidebar{position:static}
      .ma-sidebar-nav{flex-direction:row;overflow-x:auto;gap:4px;padding:6px}
      .ma-sidebar-btn{padding:10px 14px;font-size:12px;gap:8px;white-space:nowrap;border-radius:10px;margin-bottom:0}
      .ma-sidebar-btn.active{box-shadow:none;background:var(--primary);color:#fff}
      .ma-sidebar-btn.active i{color:#fff}
      .ma-sidebar-footer{display:none}
      .ma-header-card{flex-direction:column;text-align:center}
      .ma-header-stats{margin-left:0;justify-content:center}
      .ma-appt-card{flex-direction:column;text-align:center;align-items:center}
      .ma-appt-right{align-items:center}
      .ma-appt-info .appt-meta{justify-content:center}
    }
    .ma-brand{display:inline-flex;align-items:center;gap:10px;position:absolute;top:16px;left:70px;color:#fff;font-weight:700;font-size:14px}
    .ma-brand img{width:32px;height:32px;border-radius:8px;object-fit:cover}
    @media(max-width:800px){.ma-brand{left:50%;transform:translateX(-50%)}}
  </style>
</head>
<body>

<!-- Hero -->
<div class="ma-hero">
  <a href="${pageContext.request.contextPath}/doctors/list" class="ma-back"><i class="bi bi-arrow-left"></i></a>
  <div class="ma-brand">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
    <span>Fight D Fear</span>
  </div>
</div>

<!-- Header Card -->
<div class="ma-header-card">
  <div class="ma-header-icon"><i class="bi bi-calendar2-check"></i></div>
  <div class="ma-header-info">
    <h1>My Appointments</h1>
    <p>Track your appointment requests and status</p>
  </div>
  <div class="ma-header-stats">
    <div class="ma-stat">
      <div class="num">${appointments != null ? appointments.size() : 0}</div>
      <div class="lbl">Total</div>
    </div>
  </div>
</div>

<!-- Main Layout -->
<div class="ma-main">

  <!-- Sidebar -->
  <aside class="ma-sidebar">
    <nav class="ma-sidebar-nav">
      <button class="ma-sidebar-btn ${empty section || section != 'prescriptions' ? 'active' : ''}" onclick="filterAppts(this,'all')">
        <i class="bi bi-grid"></i><span>All</span>
      </button>
      <button class="ma-sidebar-btn" onclick="filterAppts(this,'pending')">
        <i class="bi bi-hourglass-split"></i><span>Pending</span>
      </button>
      <button class="ma-sidebar-btn" onclick="filterAppts(this,'confirmed')">
        <i class="bi bi-check-circle"></i><span>Confirmed</span>
      </button>
      <button class="ma-sidebar-btn" onclick="filterAppts(this,'completed')">
        <i class="bi bi-trophy"></i><span>Completed</span>
      </button>
      <button class="ma-sidebar-btn ${section == 'prescriptions' ? 'active' : ''}" onclick="filterAppts(this,'prescriptions')">
        <i class="bi bi-file-earmark-medical"></i><span>Prescriptions</span>
      </button>
      <a class="ma-sidebar-btn" href="${pageContext.request.contextPath}/doctors/list">
        <i class="bi bi-search"></i><span>Find Doctors</span>
      </a>
    </nav>
    <div class="ma-sidebar-footer">
      <a href="${pageContext.request.contextPath}/users/dashboard"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
    </div>
  </aside>

  <!-- Content -->
  <div class="ma-content">

    <c:if test="${not empty param.message}">
      <div class="doc-confirm-banner">
        <h3><i class="bi bi-check-circle-fill"></i> Booking confirmed</h3>
        <p>Your appointment request has been sent. The doctor will confirm the slot. You can track it below.</p>
        <c:if test="${not empty appointments}">
          <c:set var="latest" value="${appointments[0]}"/>
          <div class="doc-confirm-grid">
            <div><div class="k">Doctor</div><div class="v">Dr. ${empty latest.doctor.fullName ? 'Doctor' : latest.doctor.fullName}</div></div>
            <div><div class="k">Specialization</div><div class="v">${empty latest.doctor.specialization ? 'General consultation' : latest.doctor.specialization}</div></div>
            <div><div class="k">Date &amp; time</div><div class="v">${empty latest.appointmentTime ? 'To be confirmed' : latest.appointmentTime}</div></div>
            <div><div class="k">Consultation</div><div class="v">${latest.consultationType == 'VIDEO' ? 'Video' : (latest.consultationType == 'ONLINE' ? 'Online' : 'Clinic visit')}</div></div>
            <div><div class="k">Fee</div><div class="v"><c:choose><c:when test="${latest.amountPaid != null}">&#8377;${latest.amountPaid}</c:when><c:otherwise>As listed</c:otherwise></c:choose></div></div>
            <div><div class="k">Status</div><div class="v">${empty latest.status ? 'PENDING' : latest.status}</div></div>
          </div>
        </c:if>
      </div>
    </c:if>
    <c:if test="${empty param.message and not empty message}">
      <div class="ma-flash"><i class="bi bi-check-circle-fill"></i> ${message}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="ma-flash" style="background:rgba(244,63,94,0.1);color:#be123c;border-color:rgba(244,63,94,0.2)">
        <i class="bi bi-exclamation-circle-fill"></i> ${error}
      </div>
    </c:if>

    <c:if test="${empty appointments}">
      <div class="ma-empty">
        <i class="bi bi-calendar-x"></i>
        <h3>No Appointments Yet</h3>
        <p>Book your first appointment with a verified doctor</p>
        <a href="${pageContext.request.contextPath}/doctors/list"><i class="bi bi-search"></i> Browse Doctors</a>
      </div>
    </c:if>

    <c:if test="${not empty appointments}">
      <div class="ma-appt-list" id="apptList">
        <c:forEach var="a" items="${appointments}">
          <div class="ma-appt-card" data-status="${a.status}" data-has-rx="${not empty a.prescriptionText}"
               role="button" tabindex="0"
               onclick="openUserApptPreview(this)"
               onkeydown="if(event.key==='Enter')openUserApptPreview(this)"
               data-doctor="${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}"
               data-spec="${empty a.doctor.specialization ? 'General consultation' : a.doctor.specialization}"
               data-hospital="${empty a.doctor.hospitalName ? '' : a.doctor.hospitalName}"
               data-time="${empty a.appointmentTime ? '' : a.appointmentTime}"
               data-reason="${empty a.reason ? '' : a.reason}"
               data-type="${a.consultationType}"
               data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
               data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
               data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
               data-chat-url="${pageContext.request.contextPath}/doctors/chat/${a.doctor.id}"
               data-video-url="${pageContext.request.contextPath}/doctors/video-call/${a.doctor.id}"
               data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${a.doctor.id}"
               data-profile-url="${pageContext.request.contextPath}/doctors/view/${a.doctor.id}"
               data-rx-url="<c:if test='${not empty a.prescriptionText}'>${pageContext.request.contextPath}/doctors/appointments/${a.id}/prescription/view</c:if>">
            <div class="ma-doc-avatar">
              <c:choose>
                <c:when test="${not empty a.doctor.profilePhotoPath}">
                  <img src="${pageContext.request.contextPath}${a.doctor.profilePhotoPath}" alt="">
                </c:when>
                <c:otherwise>${a.doctor.fullName.charAt(0)}</c:otherwise>
              </c:choose>
            </div>
            <div class="ma-appt-info">
              <div class="doc-name">Dr. ${empty a.doctor.fullName ? 'Doctor' : a.doctor.fullName}</div>
              <div class="doc-spec">${empty a.doctor.specialization ? 'General consultation' : a.doctor.specialization}</div>
              <div class="appt-meta">
                <span><i class="bi bi-calendar3"></i> ${empty a.appointmentTime ? 'Time to be confirmed' : a.appointmentTime}</span>
                <c:choose>
                  <c:when test="${a.reason != null && a.reason != ''}">
                    <span><i class="bi bi-chat-text"></i> ${a.reason}</span>
                  </c:when>
                  <c:otherwise>
                    <span><i class="bi bi-chat-text"></i> No reason provided</span>
                  </c:otherwise>
                </c:choose>
                <c:choose>
                  <c:when test="${a.amountPaid != null}">
                    <span><i class="bi bi-currency-rupee"></i> &#8377;${a.amountPaid}</span>
                  </c:when>
                  <c:otherwise>
                    <span><i class="bi bi-wallet2"></i> Payment pending</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
            <div class="ma-appt-right" onclick="event.stopPropagation()">
              <c:choose>
                <c:when test="${a.status == 'PENDING'}"><span class="ma-status pending">Pending</span></c:when>
                <c:when test="${a.status == 'CONFIRMED'}"><span class="ma-status confirmed">Confirmed</span></c:when>
                <c:when test="${a.status == 'COMPLETED'}"><span class="ma-status completed">Completed</span></c:when>
                <c:when test="${a.status == 'CANCELLED'}"><span class="ma-status cancelled">Cancelled</span></c:when>
                <c:otherwise><span class="ma-status pending">${a.status}</span></c:otherwise>
              </c:choose>

              <c:choose>
                <c:when test="${a.consultationType == 'VIDEO'}">
                  <span class="ma-type-badge video"><i class="bi bi-camera-video"></i> Video</span>
                  <c:if test="${a.status == 'CONFIRMED'}">
                    <a href="${pageContext.request.contextPath}/doctors/video-call/${a.doctor.id}" target="_blank" class="ma-join-btn"><i class="bi bi-camera-video-fill"></i> Join Call</a>
                  </c:if>
                </c:when>
                <c:when test="${a.consultationType == 'ONLINE'}">
                  <span class="ma-type-badge video"><i class="bi bi-chat-dots"></i> Online</span>
                </c:when>
                <c:otherwise>
                  <span class="ma-type-badge clinic"><i class="bi bi-hospital"></i> Clinic visit</span>
                </c:otherwise>
              </c:choose>

              <c:if test="${a.status == 'CONFIRMED' || a.status == 'COMPLETED'}">
                <a href="${pageContext.request.contextPath}/doctors/chat/${a.doctor.id}" class="ma-join-btn" style="background:#F43F5E;text-decoration:none;"><i class="bi bi-chat-dots-fill"></i> Chat</a>
              </c:if>
              
              <c:if test="${not empty a.prescriptionText}">
                <textarea id="rx-data-${a.id}" style="display:none;" 
                  data-doc-name="<c:out value='${a.doctor.fullName}'/>"
                  data-doc-spec="<c:out value='${a.doctor.specialization}'/>"
                  data-hosp-name="<c:out value='${a.doctor.hospitalName}'/>"
                  data-address="<c:out value='${a.doctor.clinicAddress}'/>"
                  data-date="<c:out value='${a.appointmentTime}'/>"
                  data-patient-name="<c:out value='${a.user.fullName}'/>"><c:out value="${a.prescriptionText}" /></textarea>
                <a href="${pageContext.request.contextPath}/doctors/appointments/${a.id}/prescription/view" class="ma-join-btn" style="background:#0F172A;text-decoration:none;">
                  <i class="bi bi-eye"></i> View Rx
                </a>
                <a href="${pageContext.request.contextPath}/doctors/appointments/${a.id}/prescription/download" class="ma-join-btn" style="background:#16A34A;text-decoration:none;">
                  <i class="bi bi-download"></i> Download
                </a>
                <button type="button" class="ma-join-btn" style="background:#1E293B;" onclick="viewPrescription('${a.id}')">
                  <i class="bi bi-printer"></i> Print Preview
                </button>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
      <div class="ma-empty" id="filterEmpty" style="display:none;" aria-live="polite">
        <i class="bi bi-calendar-x" id="filterEmptyIcon"></i>
        <h3 id="filterEmptyTitle">No appointments</h3>
        <p id="filterEmptyText">There are no appointments in this category.</p>
        <a href="${pageContext.request.contextPath}/doctors/list"><i class="bi bi-search"></i> Browse Doctors</a>
      </div>
    </c:if>

  </div>
</div>

<%-- Global app footer (consistent with doctors list and other user pages) --%>
<div class="ma-page-footer">
  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</div>

<div id="rxModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;padding:20px;">
  <div style="background:#fff;border-radius:8px;width:100%;max-width:600px;max-height:90vh;overflow-y:auto;position:relative;box-shadow:0 10px 40px rgba(0,0,0,0.3);">
    <!-- Actions -->
    <div style="position:sticky;top:0;background:#f8f9fa;padding:12px 20px;border-bottom:1px solid #ddd;display:flex;justify-content:flex-end;gap:10px;z-index:10;">
      <button onclick="downloadPDF()" style="padding:6px 12px;border:1px solid #F43F5E;background:#F43F5E;color:#fff;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;"><i class="bi bi-download"></i> Download PDF</button>
      <button onclick="window.print()" style="padding:6px 12px;border:1px solid #ddd;background:#fff;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;"><i class="bi bi-printer"></i> Print</button>
      <button onclick="document.getElementById('rxModal').style.display='none'" style="padding:6px 12px;border:none;background:var(--ma-coral);color:#fff;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;"><i class="bi bi-x-lg"></i> Close</button>
    </div>
    
    <!-- Printable Area -->
    <div id="rxPrintArea" style="padding:40px;background:#fff;color:#333;font-family:'Times New Roman', Times, serif;">
      <!-- Header -->
      <div style="display:flex;justify-content:space-between;border-bottom:2px solid #222;padding-bottom:16px;margin-bottom:16px;">
        <div>
          <h2 id="rxDocName" style="margin:0;font-size:24px;text-transform:uppercase;letter-spacing:1px;color:#222;"></h2>
          <div id="rxDocSpec" style="font-size:14px;color:#555;margin-top:4px;"></div>
        </div>
        <div style="text-align:right;">
          <div style="font-size:24px;font-weight:bold;color:#222;"><i class="bi bi-heart-pulse"></i></div>
          <div id="rxHospName" style="font-size:12px;font-weight:bold;margin-top:4px;text-transform:uppercase;"></div>
        </div>
      </div>
      
      <!-- Sub-header -->
      <div style="display:flex;justify-content:space-between;border-bottom:2px solid #222;padding-bottom:12px;margin-bottom:20px;font-size:12px;">
        <div style="max-width:60%;">
          <strong>Clinic/Address:</strong> <span id="rxAddress"></span>
        </div>
        <div style="text-align:right;">
          <strong>Date & Time:</strong> <span id="rxDate"></span>
        </div>
      </div>
      
      <!-- Patient Details -->
      <div style="display:flex;justify-content:space-between;margin-bottom:30px;font-size:14px;">
        <div><strong>Patient's Name:</strong> <span id="rxPatientName" style="border-bottom:1px solid #888;padding:0 10px;"></span></div>
      </div>
      
      <!-- Rx Symbol & Content -->
      <div style="min-height:300px;position:relative;">
        <div style="margin-bottom:20px;">
          <!-- Outlined Rx Logo -->
          <svg width="60" height="60" viewBox="0 0 100 100" fill="none" stroke="#222" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" xmlns="http://www.w3.org/2000/svg">
            <path d="M 20 80 L 20 20 L 50 20 C 65 20 70 30 70 40 C 70 50 65 60 50 60 L 20 60"/>
            <path d="M 45 60 L 75 90"/>
            <path d="M 60 75 L 80 55"/>
          </svg>
        </div>
        <div id="rxContent" style="font-size:15px;line-height:1.6;white-space:pre-wrap;padding-left:20px;z-index:2;position:relative;"></div>
        
        <!-- Watermark Medicine Bottle -->
        <svg style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:250px;height:250px;opacity:0.04;z-index:1;" viewBox="0 0 100 100" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
          <path d="M 35 10 L 65 10 L 65 18 L 35 18 Z M 30 20 L 70 20 L 70 25 L 65 35 L 65 85 C 65 90 60 95 50 95 C 40 95 35 90 35 85 L 35 35 L 30 25 Z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
          <path d="M 40 60 L 60 60 M 50 50 L 50 70" stroke="currentColor" stroke-width="6" stroke-linecap="round"/>
        </svg>
      </div>
      
      <!-- Footer -->
      <div style="margin-top:40px;border-top:1px solid #ddd;padding-top:20px;display:flex;justify-content:flex-end;">
        <div style="text-align:center;width:200px;">
          <div id="rxDocSignature" style="font-family:'Brush Script MT', 'Lucida Handwriting', cursive;font-size:24px;color:#000;margin-bottom:4px;padding:0 10px;"></div>
          <div style="border-bottom:1px solid #333;margin-bottom:5px;"></div>
          <div style="font-size:12px;font-weight:bold;">Signature</div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
@media print {
  body * { visibility: hidden; }
  #rxPrintArea, #rxPrintArea * { visibility: visible; }
  #rxPrintArea { position: absolute; left: 0; top: 0; width: 100%; padding: 0; }
}
</style>

<script>
function filterAppts(btn, status) {
  var btns = document.querySelectorAll('.ma-sidebar-btn');
  for (var i = 0; i < btns.length; i++) btns[i].classList.remove('active');
  btn.classList.add('active');

  var cards = document.querySelectorAll('.ma-appt-card');
  var visible = 0;
  for (var i = 0; i < cards.length; i++) {
    var show = false;
    if (status === 'all') {
      show = true;
    } else if (status === 'prescriptions') {
      show = cards[i].getAttribute('data-has-rx') === 'true';
    } else {
      show = cards[i].getAttribute('data-status').toLowerCase() === status;
    }
    cards[i].style.display = show ? 'flex' : 'none';
    if (show) visible++;
  }

  var emptyEl = document.getElementById('filterEmpty');
  var listEl = document.getElementById('apptList');
  if (!emptyEl || !listEl) return;

  var messages = {
    pending: {
      title: 'No pending appointments',
      text: 'You do not have any appointments awaiting doctor confirmation.'
    },
    confirmed: {
      title: 'No confirmed appointments',
      text: 'You do not have any confirmed appointments right now.'
    },
    completed: {
      title: 'No completed appointments',
      text: 'Completed consultations will appear here.'
    },
    prescriptions: {
      title: 'No prescriptions yet',
      text: 'When your doctor writes a prescription, it will show up here.'
    },
    all: {
      title: 'No appointments',
      text: 'There are no appointments to display.'
    }
  };

  if (visible === 0) {
    var msg = messages[status] || messages.all;
    document.getElementById('filterEmptyTitle').textContent = msg.title;
    document.getElementById('filterEmptyText').textContent = msg.text;
    emptyEl.style.display = 'flex';
    listEl.style.display = 'none';
  } else {
    emptyEl.style.display = 'none';
    listEl.style.display = 'flex';
  }
}

<c:if test="${section == 'prescriptions'}">
document.addEventListener('DOMContentLoaded', function() {
  var btn = document.querySelector('.ma-sidebar-btn[onclick*="prescriptions"]');
  if (btn) filterAppts(btn, 'prescriptions');
});
</c:if>

function viewPrescription(apptId) {
    var dataElem = document.getElementById('rx-data-' + apptId);
    var docName = dataElem.getAttribute('data-doc-name') || 'Doctor';
    
    document.getElementById('rxDocName').innerText = docName;
    document.getElementById('rxDocSpec').innerText = dataElem.getAttribute('data-doc-spec') || 'Specialist';
    document.getElementById('rxHospName').innerText = dataElem.getAttribute('data-hosp-name') || 'Fight D Fear Clinic';
    document.getElementById('rxAddress').innerText = dataElem.getAttribute('data-address') || '—';
    document.getElementById('rxDate').innerText = dataElem.getAttribute('data-date') || '—';
    document.getElementById('rxPatientName').innerText = dataElem.getAttribute('data-patient-name') || 'Patient';
    document.getElementById('rxContent').innerText = dataElem.value;
    
    // Set cursive signature text
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
  if (e.key === 'Escape') closeUserApptPreview();
});
</script>

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
</body>
</html>

