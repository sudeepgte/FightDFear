<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${doctor.fullName} | Medical Profile</title>
  
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  
  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  
  <!-- Theme CSS -->
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
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
    }

    body {
      background-color: var(--brand-soft-bg);
      font-family: 'Poppins', sans-serif;
      color: var(--navy-soft);
    }

    .doctor-hero-bg {
      background: linear-gradient(135deg, #7f1d1d 0%, var(--primary) 100%);
      height: 280px;
      width: 100%;
      position: absolute;
      top: 0;
      left: 0;
      z-index: -1;
    }

    .profile-header-card {
      background: white;
      border-radius: 32px;
      padding: 40px;
      box-shadow: 0 20px 50px rgba(0,0,0,0.05);
      margin-top: 100px;
      border: 1px solid var(--border);
      position: relative;
    }

    .doctor-avatar-large {
      width: 180px;
      height: 180px;
      border-radius: 40px;
      object-fit: cover;
      border: 8px solid white;
      box-shadow: 0 15px 35px rgba(0,0,0,0.1);
      margin-top: -120px;
      background: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 4rem;
      font-weight: 800;
    }

    .nav-pills-custom .nav-link {
      border-radius: 12px;
      padding: 12px 25px;
      font-weight: 600;
      color: var(--navy-soft);
      transition: all 0.3s ease;
      border: 1px solid transparent;
      margin-right: 10px;
    }

    .nav-pills-custom .nav-link.active {
      background: var(--rose-soft) !important;
      color: var(--primary) !important;
      border-color: #fecdd3;
    }

    .info-grid-item {
      padding: 25px;
      background: #f8fafc;
      border-radius: 24px;
      border: 1px solid var(--border);
      height: 100%;
    }

    .booking-sticky-card {
      position: sticky;
      top: 40px;
      background: white;
      border-radius: 28px;
      padding: 30px;
      border: 1px solid var(--border);
      box-shadow: 0 15px 40px rgba(0,0,0,0.03);
    }

    .day-selector-item {
      flex: 1;
      text-align: center;
      padding: 15px 10px;
      background: #f8fafc;
      border-radius: 16px;
      border: 2px solid var(--border);
      cursor: pointer;
      transition: 0.3s;
    }

    .day-selector-item.active {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }

    .time-slot-pill {
      display: inline-block;
      padding: 10px 20px;
      background: white;
      border: 2px solid var(--border);
      border-radius: 12px;
      margin: 5px;
      cursor: pointer;
      font-weight: 600;
      font-size: 0.9rem;
      transition: 0.3s;
    }

    .time-slot-pill:hover, .time-slot-pill.selected {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }

    .review-item {
      padding: 25px;
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
      border-radius: 18px;
      padding: 18px;
      font-weight: 800;
      width: 100%;
      box-shadow: 0 10px 25px rgba(244, 63, 94, 0.24);
    }

    .logo {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
      color: var(--navy);
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
      color: var(--navy);
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
    .btn-getstarted {
      background: var(--primary);
      color: #fff;
      border: none;
    }
    .btn-getstarted:hover {
      filter: brightness(1.06);
      color: #fff;
    }
    .bg-soft-pink {
      background: var(--rose-soft) !important;
    }
    .text-pink {
      color: var(--primary) !important;
    }
    .text-purple {
      color: var(--navy) !important;
    }
    .btn-outline-purple {
      border-color: var(--border);
      color: var(--navy-soft);
      background: #fff;
    }
    .btn-check:checked + .btn-outline-purple {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
    }
    
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
  <header id="header" class="header d-flex align-items-center sticky-top">
    <div class="container-fluid container-xl d-flex align-items-center">
      <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto">
        <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
        <h1>Fight D Fear</h1>
      </a>
      <nav id="navmenu" class="navmenu">
        <ul>
          <li><a href="${pageContext.request.contextPath}/chat/users">Chat</a></li>
          <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
          <li><a href="${pageContext.request.contextPath}/users/wallet">Wallet 💰</a></li>
          <li class="nav-profile">
              <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="d-flex align-items-center">
                  <img src="${pageContext.request.contextPath}${not empty user.profilePhoto ? user.profilePhoto : '/images/default-profile.png'}" 
                       alt="Profile" class="rounded-circle" style="width: 35px; height: 35px; object-fit: cover; border: 2px solid var(--brand-pink);">
                  <span class="ms-2 d-none d-lg-inline text-white">${user.fullName}</span>
              </a>
          </li>
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>
      <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
  </header>

  <div class="doctor-hero-bg"></div>

  <div class="container py-5">
    <!-- Profile Header Section -->
    <div class="profile-header-card">
      <div class="row align-items-end">
        <div class="col-lg-auto text-center text-lg-start">
          <div class="doctor-avatar-large mx-auto">
            <c:choose>
              <c:when test="${not empty doctor.profilePhotoPath}">
                <img src="${pageContext.request.contextPath}${doctor.profilePhotoPath}" class="w-100 h-100 rounded-inherit" style="object-fit: cover; border-radius: 32px;">
              </c:when>
              <c:otherwise>${doctor.fullName.charAt(0)}</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="col-lg mt-4 mt-lg-0">
          <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
            <span class="badge bg-soft-pink text-pink px-3 py-2 rounded-pill fw-700">${doctor.specialization}</span>
            <div class="text-warning"><i class="bi bi-star-fill"></i> <span class="fw-800 text-dark">${doctor.rating}</span> <span class="text-muted small">(45+ Reviews)</span></div>
          </div>
          <h1 class="fw-900 mb-2" style="font-family: 'Montserrat';">${doctor.fullName} <i class="bi bi-patch-check-fill text-primary fs-4"></i></h1>
          <p class="text-muted mb-0"><i class="bi bi-geo-alt-fill text-pink me-1"></i> ${doctor.locationText}</p>
        </div>
        <div class="col-lg-auto mt-4 mt-lg-0">
          <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}" class="action-btn-circle bg-primary" title="Chat"><i class="bi bi-chat-dots-fill"></i></a>
            <a href="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}" class="action-btn-circle bg-success" title="Video Call"><i class="bi bi-camera-video-fill"></i></a>
            <div class="vr mx-2"></div>
            <div class="text-end">
              <div class="small text-muted fw-600">CONSULTATION FEE</div>
              <div class="fs-3 fw-900 text-purple" id="headerFeeDisplay">₹${doctor.consultationFee != null ? doctor.consultationFee : 0}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Tabs -->
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
                    <div class="fw-800">${doctor.qualification != null ? doctor.qualification : 'Verified MD/MBBS'}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-purple mb-2"><i class="bi bi-shield-check fs-4"></i></div>
                    <div class="small fw-700 text-muted">REGISTRATION</div>
                    <div class="fw-800">${doctor.medicalRegNumber}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-primary mb-2"><i class="bi bi-building fs-4"></i></div>
                    <div class="small fw-700 text-muted">HOSPITAL</div>
                    <div class="fw-800">${doctor.hospitalName != null ? doctor.hospitalName : 'Fight D Fear Clinic'}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="info-grid-item">
                    <div class="text-success mb-2"><i class="bi bi-activity fs-4"></i></div>
                    <div class="small fw-700 text-muted">CONSULTATION</div>
                    <div class="fw-800">${doctor.consultationType} Available</div>
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
          
          <form id="bookingForm" onsubmit="event.preventDefault(); initiatePayment();">
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
              <div class="btn-group w-100" role="group">
                <input type="radio" class="btn-check" name="consultationType" id="mode1" value="CLINIC" checked>
                <label class="btn btn-outline-purple py-3 fw-700" for="mode1">Clinic Visit</label>
                
                <input type="radio" class="btn-check" name="consultationType" id="mode2" value="VIDEO">
                <label class="btn btn-outline-purple py-3 fw-700" for="mode2">Video Call</label>
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

              <label class="small fw-800 text-muted mb-2 d-block">REASON FOR VISIT</label>
              <textarea id="reason" class="form-control rounded-3 py-2" rows="2" placeholder="Briefly describe your symptoms or reason for visit (optional)"></textarea>

            </div>

            <div id="selectedSummary" class="mb-4 p-3 bg-soft-pink rounded-3 text-pink small fw-700 text-center d-none">
              <i class="bi bi-clock-fill me-1"></i> <span id="summaryText"></span>
            </div>

            <button type="submit" id="payBtn" class="btn-book-primary" disabled style="opacity: 0.6">
              Book Appointment
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

              <div class="rating-stars text-warning">
                <input type="radio" name="rating" value="5" id="r5" required><label for="r5"></label>
                <input type="radio" name="rating" value="4" id="r4"><label for="r4"></label>
                <input type="radio" name="rating" value="3" id="r3"><label for="r3"></label>
                <input type="radio" name="rating" value="2" id="r2"><label for="r2"></label>
                <input type="radio" name="rating" value="1" id="r1"><label for="r1"></label>

              </div>
              <div id="ratingError" class="text-danger small fw-700 mt-2" style="display:none;">Please select a star rating.</div>
            </div>
            <textarea name="comment" class="form-control rounded-4 p-3" rows="4" placeholder="How was your visit with Dr. ${doctor.fullName}?"></textarea>
          </div>
          <div class="modal-footer border-0 pt-0">
            <button type="submit" class="btn btn-purple w-100 py-3 rounded-4 fw-800">Post Review</button>
          </div>
        </form>
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
    var daysMap = { "sunday":0, "monday":1, "tuesday":2, "wednesday":3, "thursday":4, "friday":5, "saturday":6 };
    var availableDays = (doctorAvailableDaysStr || "").split(",").map(d => d.trim().toLowerCase()).filter(d => daysMap[d] !== undefined).map(d => daysMap[d]);

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
      if (header) header.innerText = '₹' + fee;
      if (fee > 0) {
        btn.innerText = 'Book Appointment & Pay ₹' + fee;
        if (hint) hint.innerHTML = '<i class="bi bi-shield-lock-fill text-success me-1"></i> Secure Payment by Razorpay';
      } else {
        btn.innerText = 'Request Free Booking';
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
      
      var html = '';
      var d = new Date();
      var count = 0;
      while(count < 14) {
        if(availableDays.includes(d.getDay())) {
          var dateISO = localDateISO(d);
          var dayName = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][d.getDay()];
          html += `<div class="day-selector-item" onclick="selectDate(this, '\${dateISO}')">
                    <div class="small fw-700 opacity-50">\${dayName}</div>
                    <div class="fs-5 fw-900">\${d.getDate()}</div>
                   </div>`;
          count++;
        }
        d.setDate(d.getDate() + 1);
      }
      if(html === '') {
         dateScroll.innerHTML = '<p class="text-danger small fw-700 p-2">No available dates found.</p>';
      } else {
         dateScroll.innerHTML = html;
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
      if(!doctorStartTime || !doctorEndTime) return;

      var html = '';
      var start = parseInt(doctorStartTime.split(':')[0]) * 60 + parseInt(doctorStartTime.split(':')[1] || 0);
      var end = parseInt(doctorEndTime.split(':')[0]) * 60 + parseInt(doctorEndTime.split(':')[1] || 0);
      
      for(var m = start; m < end; m += 30) {
        var h = Math.floor(m/60);
        var mm = m%60;
        var ampm = h >= 12 ? 'PM' : 'AM';
        var t12 = (h%12 || 12) + ':' + (mm < 10 ? '0' : '') + mm + ' ' + ampm;
        var t24 = (h < 10 ? '0' : '') + h + ':' + (mm < 10 ? '0' : '') + mm + ':00';
        html += `<div class="time-slot-pill" onclick="selectTime(this, '\${t24}', '\${t12}')">\${t12}</div>`;
      }
      sessionSlots.innerHTML = html;
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

    async function bookFree(doctorId, time, type) {
      const res = await fetch('${pageContext.request.contextPath}/api/doctors/' + doctorId + '/appointments', {
        method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ appointmentTime: time, consultationType: type, reason: '' })
      });
      const data = await res.json();
      if (res.ok && data.success) {
        window.location.href = '${pageContext.request.contextPath}/doctors/myAppointments?message=Booking-Confirmed';
      } else {
        alert(data.error || 'Unable to book appointment');
      }
    }

    async function initiatePayment() {
      syncFeeUi();
      const amount = document.getElementById('amount').value;
      const doctorId = document.getElementById('doctorId').value;
      const time = document.getElementById('appointmentTime').value;
      const type = document.querySelector('input[name="consultationType"]:checked').value;

      const reason = (document.getElementById('appointmentReason').value || '').trim();

      const reason = document.getElementById('reason').value;
      const fee = parseFloat(amount || '0');

      if (!time) {
        alert('Please select date and time');
        return;
      }

      if (fee <= 0) {
        await bookFree(doctorId, time, type);
        return;
      }


      try {
        const res = await fetch('${pageContext.request.contextPath}/payment/create-order', {
          method: 'POST', headers: {'Content-Type':'application/json'},
          body: JSON.stringify({
            type: 'DOCTOR',
            targetId: doctorId,
            consultationType: type,
            appointmentTime: time,
            amount: amount
          })
        });
        const order = await res.json();
        if (!res.ok || !order.orderId) {
          alert(order.error || 'Unable to create payment order');
          return;
        }
        if (order.mock) {
          const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
            method: 'POST', headers: {'Content-Type':'application/json'},
            body: JSON.stringify({
              razorpay_order_id: order.orderId,
              razorpay_payment_id: 'mock_pay_' + Date.now(),
              razorpay_signature: 'mock_sig',
              type: 'DOCTOR', targetId: doctorId, amount,
              appointmentTime: time, consultationType: type
            })
          });
          if (verifyRes.ok) window.location.href = '${pageContext.request.contextPath}/doctors/myAppointments?message=Booking-Confirmed';
          else alert('Verification failed');
          return;
        }
        const options = {
          key: order.key, amount: order.amount, currency: 'INR',
          name: 'Fight D Fear Medical', description: 'Consultation with Dr. ${doctor.fullName}',
          order_id: order.orderId,
          handler: async function(response) {
            const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
              method: 'POST', headers: {'Content-Type':'application/json'},
              body: JSON.stringify({
                razorpay_order_id: response.razorpay_order_id,
                razorpay_payment_id: response.razorpay_payment_id,
                razorpay_signature: response.razorpay_signature,

                type: 'DOCTOR', targetId: doctorId, amount,
                appointmentTime: time, consultationType: type,
                reason: reason

                type: 'DOCTOR', targetId: doctorId, amount, reason: reason,
                appointmentTime: time, consultationType: type

              })
            });
            if(verifyRes.ok) window.location.href = '${pageContext.request.contextPath}/doctors/myAppointments?message=Booking-Confirmed';
          }
        };
        new Razorpay(options).open();
      } catch(e) { alert('Payment failed. Please try again.'); }
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
</body>
</html>

