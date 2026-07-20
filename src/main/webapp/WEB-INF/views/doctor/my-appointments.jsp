<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Appointments — SafeHer</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <style>
    :root{
      --ma-purple:#1e1b4b;--ma-purple-l:#312e81;--ma-coral:#f43f5e;
      --ma-teal:#20c997;--ma-gold:#ffd700;--ma-bg:#f8fafc;--ma-card:#fff;
      --ma-text:#1a1a2e;--ma-muted:#6b7280;--ma-border:rgba(30, 27, 75, 0.08);
      --ma-gradient:linear-gradient(135deg,#1e1b4b,#312e81,#f43f5e);
      --ma-shadow:0 4px 24px rgba(30, 27, 75, 0.08);--ma-radius:16px;
      --sidebar-w:240px
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Poppins',sans-serif;background:var(--ma-bg);min-height:100vh;color:var(--ma-text)}

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
    .ma-stat{text-align:center;padding:8px 16px;border-radius:12px;background:rgba(123,44,191,0.05);min-width:70px}
    .ma-stat .num{font-size:22px;font-weight:800;color:var(--ma-purple-l)}
    .ma-stat .lbl{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;color:var(--ma-muted)}

    /* Main Layout */
    .ma-main{margin:24px 24px 0;padding:0 0 24px;display:grid;grid-template-columns:var(--sidebar-w) 1fr;gap:24px;align-items:stretch;min-height:calc(100vh - 260px)}

    /* Sidebar */
    .ma-sidebar{position:sticky;top:24px;background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border);overflow:hidden;display:flex;flex-direction:column}
    .ma-sidebar-nav{display:flex;flex-direction:column;padding:8px;flex:1}
    .ma-sidebar-btn{display:flex;align-items:center;gap:12px;padding:14px 18px;border:none;background:transparent;font-size:14px;font-weight:600;font-family:'Poppins',sans-serif;color:var(--ma-muted);cursor:pointer;border-radius:12px;transition:all 0.25s;text-align:left;margin-bottom:2px;text-decoration:none}
    .ma-sidebar-btn i{font-size:18px;width:22px;text-align:center}
    .ma-sidebar-btn:hover{background:rgba(123,44,191,0.04);color:var(--ma-text)}
    .ma-sidebar-btn.active{background:linear-gradient(135deg,rgba(123,44,191,0.1),rgba(74,14,120,0.06));color:var(--ma-purple-l);box-shadow:inset 3px 0 0 var(--ma-purple-l)}
    .ma-sidebar-btn.active i{color:var(--ma-purple-l)}
    .ma-sidebar-footer{padding:16px 18px;border-top:1px solid var(--ma-border);font-size:11px;color:var(--ma-muted)}
    .ma-sidebar-footer a{color:var(--ma-purple-l);text-decoration:none;font-weight:600;transition:all 0.25s ease;display:inline-block}
    .ma-sidebar-footer a:hover{color:var(--ma-purple);text-shadow:0 0 2px rgba(124,45,94,0.15);transform:translateX(3px)}

    /* Content */
    .ma-content{min-width:0;display:flex;flex-direction:column}
    .ma-panel{display:none;animation:maFadeIn 0.3s ease}
    .ma-panel.active{display:flex;flex-direction:column;flex:1}
    @keyframes maFadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

    /* Flash */
    .ma-flash{padding:14px 20px;border-radius:12px;background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.2);color:#0d9668;font-size:13px;font-weight:500;margin-bottom:16px;display:flex;align-items:center;gap:8px}

    /* Appointment Cards */
    .ma-appt-list{display:flex;flex-direction:column;gap:14px;flex:1}
    .ma-appt-card{background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border);padding:20px 24px;display:flex;align-items:center;gap:20px;transition:all 0.25s}
    .ma-appt-card:hover{transform:translateY(-2px);box-shadow:0 8px 32px rgba(30, 27, 75, 0.12)}

    .ma-doc-avatar{width:56px;height:56px;border-radius:50%;background:var(--ma-gradient);display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:800;color:#fff;flex-shrink:0}
    .ma-doc-avatar img{width:56px;height:56px;border-radius:50%;object-fit:cover}

    .ma-appt-info{flex:1;min-width:0}
    .ma-appt-info .doc-name{font-size:15px;font-weight:700;margin:0}
    .ma-appt-info .doc-spec{font-size:12px;color:var(--ma-purple-l);font-weight:600}
    .ma-appt-info .appt-meta{display:flex;gap:16px;margin-top:6px;flex-wrap:wrap}
    .ma-appt-info .appt-meta span{font-size:12px;color:var(--ma-muted);display:flex;align-items:center;gap:4px}
    .ma-appt-info .appt-meta span i{font-size:14px;color:var(--ma-purple-l)}

    .ma-appt-right{display:flex;flex-direction:column;align-items:flex-end;gap:8px;flex-shrink:0}
    .ma-status{padding:5px 14px;border-radius:999px;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px}
    .ma-status.pending{background:rgba(255,193,7,0.12);color:#d4a017}
    .ma-status.confirmed{background:rgba(32,201,151,0.12);color:#0d9668}
    .ma-status.completed{background:rgba(74,144,217,0.12);color:#4a90d9}
    .ma-status.cancelled{background:rgba(255,107,107,0.12);color:var(--ma-coral)}
    .ma-status.rejected{background:rgba(255,107,107,0.12);color:var(--ma-coral)}

    .ma-type-badge{padding:4px 12px;border-radius:8px;font-size:10px;font-weight:600;display:inline-flex;align-items:center;gap:4px}
    .ma-type-badge.clinic{background:rgba(32,201,151,0.08);color:#0d9668}
    .ma-type-badge.video{background:rgba(74,144,217,0.08);color:#4a90d9}

    .ma-join-btn{padding:6px 16px;border:none;border-radius:999px;background:var(--ma-teal);color:#fff;font-size:11px;font-weight:700;font-family:'Poppins',sans-serif;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all 0.2s}
    .ma-join-btn:hover{filter:brightness(1.1);transform:scale(1.05);color:#fff}

    /* Empty state */
    .ma-empty{text-align:center;padding:60px 20px;color:var(--ma-muted);flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;background:var(--ma-card);border-radius:var(--ma-radius);box-shadow:var(--ma-shadow);border:1px solid var(--ma-border)}
    .ma-empty i{font-size:56px;opacity:0.2;margin-bottom:12px}
    .ma-empty p{font-size:14px;margin:4px 0 0}
    .ma-empty a{margin-top:16px;padding:10px 28px;border-radius:999px;background:var(--ma-gradient);color:#fff;text-decoration:none;font-size:13px;font-weight:700}

    /* Responsive */
    @media(max-width:800px){
      .ma-main{grid-template-columns:1fr;gap:16px}
      .ma-sidebar{position:static}
      .ma-sidebar-nav{flex-direction:row;overflow-x:auto;gap:4px;padding:6px}
      .ma-sidebar-btn{padding:10px 14px;font-size:12px;gap:8px;white-space:nowrap;border-radius:10px;margin-bottom:0}
      .ma-sidebar-btn.active{box-shadow:none;background:var(--ma-purple-l);color:#fff}
      .ma-sidebar-btn.active i{color:#fff}
      .ma-sidebar-footer{display:none}
      .ma-header-card{flex-direction:column;text-align:center}
      .ma-header-stats{margin-left:0;justify-content:center}
      .ma-appt-card{flex-direction:column;text-align:center;align-items:center}
      .ma-appt-right{align-items:center}
      .ma-appt-info .appt-meta{justify-content:center}
    }
  </style>
</head>
<body>

<!-- Hero -->
<div class="ma-hero">
  <a href="${pageContext.request.contextPath}/doctors/list" class="ma-back"><i class="bi bi-arrow-left"></i></a>
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
      <button class="ma-sidebar-btn active" onclick="filterAppts(this,'all')">
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
      <div class="ma-flash"><i class="bi bi-check-circle-fill"></i> Appointment booked successfully! Awaiting doctor confirmation.</div>
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
          <div class="ma-appt-card" data-status="${a.status}">
            <div class="ma-doc-avatar">
              <c:choose>
                <c:when test="${not empty a.doctor.profilePhotoPath}">
                  <img src="${pageContext.request.contextPath}${a.doctor.profilePhotoPath}" alt="">
                </c:when>
                <c:otherwise>${a.doctor.fullName.charAt(0)}</c:otherwise>
              </c:choose>
            </div>
            <div class="ma-appt-info">
              <div class="doc-name">${a.doctor.fullName}</div>
              <div class="doc-spec">${a.doctor.specialization}</div>
              <div class="appt-meta">
                <span><i class="bi bi-calendar3"></i> ${a.appointmentTime}</span>
                <c:if test="${a.reason != null && a.reason != ''}">
                  <span><i class="bi bi-chat-text"></i> ${a.reason}</span>
                </c:if>
                <c:if test="${a.amountPaid != null}">
                  <span><i class="bi bi-currency-rupee"></i> &#8377;${a.amountPaid}</span>
                </c:if>
              </div>
            </div>
            <div class="ma-appt-right">
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
                    <a href="${pageContext.request.contextPath}/consultation/video/${a.id}" target="_blank" class="ma-join-btn"><i class="bi bi-camera-video-fill"></i> Join Call</a>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <span class="ma-type-badge clinic"><i class="bi bi-hospital"></i> Clinic</span>
                </c:otherwise>
              </c:choose>
              
              <c:if test="${a.status == 'COMPLETED' && not empty a.prescriptionText}">
                <textarea id="rx-data-${a.id}" style="display:none;" 
                  data-doc-name="<c:out value='${a.doctor.fullName}'/>"
                  data-doc-spec="<c:out value='${a.doctor.specialization}'/>"
                  data-hosp-name="<c:out value='${a.doctor.hospitalName}'/>"
                  data-address="<c:out value='${a.doctor.clinicAddress}'/>"
                  data-date="<c:out value='${a.appointmentTime}'/>"
                  data-patient-name="<c:out value='${a.user.fullName}'/>"><c:out value="${a.prescriptionText}" /></textarea>
                <button type="button" class="ma-join-btn" style="background:#312e81;" onclick="viewPrescription('${a.id}')">
                  <i class="bi bi-file-earmark-medical"></i> View Rx
                </button>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

  </div>
</div>

<div id="rxModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;padding:20px;">
  <div style="background:#fff;border-radius:8px;width:100%;max-width:600px;max-height:90vh;overflow-y:auto;position:relative;box-shadow:0 10px 40px rgba(0,0,0,0.3);">
    <!-- Actions -->
    <div style="position:sticky;top:0;background:#f8f9fa;padding:12px 20px;border-bottom:1px solid #ddd;display:flex;justify-content:flex-end;gap:10px;z-index:10;">
      <button onclick="downloadPDF()" style="padding:6px 12px;border:1px solid #312e81;background:#312e81;color:#fff;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;"><i class="bi bi-download"></i> Download PDF</button>
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
  for(var i=0;i<btns.length;i++) btns[i].classList.remove('active');
  btn.classList.add('active');

  var cards = document.querySelectorAll('.ma-appt-card');
  for(var i=0;i<cards.length;i++){
    if(status === 'all') {
      cards[i].style.display = 'flex';
    } else {
      cards[i].style.display = cards[i].getAttribute('data-status').toLowerCase() === status ? 'flex' : 'none';
    }
  }
}

function viewPrescription(apptId) {
    var dataElem = document.getElementById('rx-data-' + apptId);
    var docName = dataElem.getAttribute('data-doc-name') || 'Doctor';
    
    document.getElementById('rxDocName').innerText = docName;
    document.getElementById('rxDocSpec').innerText = dataElem.getAttribute('data-doc-spec') || 'Specialist';
    document.getElementById('rxHospName').innerText = dataElem.getAttribute('data-hosp-name') || 'SafeHer Clinic';
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
</script>
</body>
</html>

