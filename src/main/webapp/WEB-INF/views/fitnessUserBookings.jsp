<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Fitness Bookings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #f43f5e;
            --primary-hover: #e11d48;
            --primary-light: #ffe4e6;
            --dark-navy: #0f172a;
            --gradient: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
            --shadow: 0 10px 30px rgba(244, 63, 94, 0.05);
        }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            color: var(--dark-navy);
        }

        .card-custom {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: var(--shadow);
            border: none;
            margin-bottom: 30px;
        }
        .btn-custom {
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.85rem;
            padding: 8px 20px;
        }
        .btn-primary-custom {
            background: var(--gradient);
            color: white;
            border: none;
        }
        .btn-primary-custom:hover {
            opacity: 0.9;
            color: white;
        }
        .avatar-small {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
        }

        #wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
            overflow-x: hidden;
        }
        #page-content-wrapper {
            flex: 1;
            min-width: 0;
            padding-top: 20px;
        }
        
        @media (max-width: 768px) {
            #wrapper {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <div>
                        <h2 class="fw-bold mb-1">My Fitness Bookings</h2>
                        <p class="text-muted text-xs">Track requested coaching classes, cancel sessions, or review completed bookings.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/fitness" class="btn btn-outline-success btn-custom"><i class="bi bi-search me-1"></i> Browse More Coaches</a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 15px;">
                        <i class="bi bi-check-circle-fill me-2"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="border-radius: 15px;">${error}</div>
                </c:if>

                <!-- Progress & Stats Banner -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted small fw-bold text-uppercase">Workouts Attended</span>
                                    <h3 class="fw-bold text-dark mb-0 mt-1">${progressSummary.totalWorkoutsAttended != null ? progressSummary.totalWorkoutsAttended : 0}</h3>
                                </div>
                                <div class="bg-success bg-opacity-10 text-success rounded-circle p-3 fs-4">
                                    <i class="bi bi-fire"></i>
                                </div>
                            </div>
                            <div class="small text-muted mt-2"><i class="bi bi-lightning-charge-fill text-warning me-1"></i> Current Streak: <strong>${progressSummary.currentStreakDays != null ? progressSummary.currentStreakDays : 0} Days</strong></div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted small fw-bold text-uppercase">Latest Weight</span>
                                    <h3 class="fw-bold text-dark mb-0 mt-1">${progressSummary.latestWeight != null ? progressSummary.latestWeight : '—'} <small class="fs-6 text-muted">kg</small></h3>
                                </div>
                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle p-3 fs-4">
                                    <i class="bi bi-speedometer2"></i>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center small text-muted mt-2">
                                <span><i class="bi bi-calendar-event me-1"></i> Evaluated: ${progressSummary.lastLogDate != null ? progressSummary.lastLogDate : 'Not recorded yet'}</span>
                                <button type="button" class="btn btn-sm btn-link text-primary p-0 text-decoration-none fw-semibold" data-bs-toggle="modal" data-bs-target="#logProgressModal">
                                    <i class="bi bi-plus-circle me-1"></i>Log Weight
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted small fw-bold text-uppercase">Active Fitness Passes</span>
                                    <h3 class="fw-bold text-dark mb-0 mt-1">${activePassesCount != null ? activePassesCount : 0}</h3>
                                </div>
                                <div class="bg-danger bg-opacity-10 text-danger rounded-circle p-3 fs-4">
                                    <i class="bi bi-tag-fill"></i>
                                </div>
                            </div>
                            <div class="small text-muted mt-2"><i class="bi bi-shield-check text-success me-1"></i> Verified Coach Access (${activePassesCount != null ? activePassesCount : 0} Active)</div>
                        </div>
                    </div>
                </div>

                <!-- CLIENT SELF CHECK-IN CARD (Matches Martial Arts Dojo Experience) -->
                <div class="card border-0 rounded-4 shadow-sm p-4 mb-4 bg-white" style="border: 1.5px solid #fecdd3 !important;">
                    <div class="d-flex flex-wrap align-items-center gap-4">
                        <div class="rounded-4 d-flex align-items-center justify-content-center flex-shrink-0 shadow-sm" 
                             style="width: 100px; height: 100px; background: #fff1f2; border: 2px dashed #fecdd3; color: #f43f5e; font-size: 2.5rem;">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width: 260px;">
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="badge px-2 py-1 rounded-pill" style="font-size: 0.72rem; background: #ffe4e6; color: #e11d48; font-weight: 700;">Client Self Check-In</span>
                                <h5 class="fw-bold mb-0 text-dark">Check In to your Workout Session</h5>
                            </div>
                            <p class="text-muted small mb-3">
                                Scan the QR code displayed by your coach or enter the session code to verify attendance and deduct 1 workout credit from your pass.
                            </p>
                            <div class="d-flex flex-wrap gap-2 align-items-center">
                                <div class="input-group" style="max-width: 360px;">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-key-fill"></i></span>
                                    <input type="text" id="fitnessQrTokenInput" class="form-control border-start-0" placeholder="Paste or enter Session Code (e.g. FIT-...)">
                                </div>
                                <button type="button" class="btn btn-danger rounded-pill px-4 fw-bold shadow-sm" style="background: #f43f5e; border: none;" onclick="submitFitnessUserCheckIn()">
                                    <span id="fitnessCheckInSpinner" class="spinner-border spinner-border-sm me-1 d-none" role="status"></span>
                                    <span id="fitnessCheckInBtnText"><i class="bi bi-check2-circle me-1"></i> Check In</span>
                                </button>
                            </div>
                            <div id="fitnessCheckInMsg" class="small mt-2" style="font-weight: 600;"></div>
                        </div>
                    </div>
                </div>

                <div class="card-custom">
                    <ul class="nav nav-tabs mb-4" id="bookingTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="upcoming-tab" data-bs-toggle="tab" data-bs-target="#upcomingContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Scheduled / Requested Classes
                                <c:if test="${upcomingCount > 0}">
                                    <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger ms-1">${upcomingCount}</span>
                                </c:if>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="attendance-tab" data-bs-toggle="tab" data-bs-target="#attendanceContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Attendance History (${not empty attendanceList ? attendanceList.size() : 0})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="past-tab" data-bs-toggle="tab" data-bs-target="#pastContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Completed Classes
                                <c:if test="${completedCount > 0}">
                                    <span class="badge rounded-pill bg-secondary bg-opacity-10 text-secondary ms-1">${completedCount}</span>
                                </c:if>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="progress-tab" data-bs-toggle="tab" data-bs-target="#progressContent" type="button" role="tab" style="color:var(--primary); font-weight:600;">
                                Progress & Milestones
                                <c:if test="${not empty progressLogs}">
                                    <span class="badge rounded-pill bg-primary bg-opacity-10 text-primary ms-1">${progressLogs.size()}</span>
                                </c:if>
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="bookingTabContents">
                        
                        <!-- TAB 1: UPCOMING / SCHEDULED CLASSES -->
                        <div class="tab-pane fade show active" id="upcomingContent" role="tabpanel">
                            <c:set var="hasUpcoming" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status eq 'PENDING' or b.status eq 'APPROVED' or b.status eq 'CONFIRMED' or (not empty b.remainingSessions and b.remainingSessions > 0 and b.status ne 'COMPLETED' and b.status ne 'CANCELLED' and b.status ne 'REJECTED')}">
                                    <c:set var="hasUpcoming" value="true" />
                                    <div class="border rounded-4 p-3 mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty b.trainer.profilePhotoPath ? b.trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" class="avatar-small">
                                            <div>
                                                <h6 class="fw-bold mb-1">${b.trainer.fullName}</h6>
                                                <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                                    <span class="badge bg-light text-dark">${b.category}</span>
                                                    <c:if test="${not empty b.fitnessPackage}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">${b.fitnessPackage.packageName}</span>
                                                    </c:if>
                                                </div>
                                                <span class="text-muted text-xs"><i class="bi bi-clock me-1"></i> ${b.bookingDate} @ ${b.bookingTime}</span>
                                                <span class="text-muted text-xs ms-2"><i class="bi bi-laptop me-1"></i> Format: <strong>${b.sessionType}</strong></span>
                                                <c:if test="${b.totalSessions > 1}">
                                                    <div class="text-muted text-xs mt-1">Sessions Used: <strong>${b.completedSessions != null ? b.completedSessions : 0} / ${b.totalSessions}</strong> &bull; Valid Until: ${b.validUntil}</div>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${b.status eq 'PENDING'}">
                                                    <span class="badge bg-warning text-dark px-3 py-2" style="border-radius:20px;">Requested</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success px-3 py-2" style="border-radius:20px;">Active Pass</span>
                                                    <button type="button" class="btn btn-sm btn-danger btn-custom py-1 px-3 shadow-sm" style="background:#f43f5e; border:none;" onclick="promptCheckInForTrainer('${b.trainer.fullName}')">
                                                        <i class="bi bi-qr-code me-1"></i> Check In
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <form action="${pageContext.request.contextPath}/fitness/booking/cancel" method="POST" onsubmit="return confirm('Cancel this session? Fully refunded if paid.');">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-custom py-1 px-3">Cancel</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasUpcoming}">
                                <div class="text-center py-5">
                                    <i class="bi bi-calendar2-plus text-muted" style="font-size: 2.5rem;"></i>
                                    <h6 class="fw-bold text-dark mt-2">No Active or Scheduled Classes</h6>
                                    <p class="text-muted small mb-3">You don't have any pending or active workout bookings right now.</p>
                                    <a href="${pageContext.request.contextPath}/fitness" class="btn btn-danger btn-custom px-4" style="background: #f43f5e; border: none;">
                                        <i class="bi bi-search me-1"></i> Browse Coaches & Book a Session
                                    </a>
                                </div>
                            </c:if>
                        </div>

                        <!-- TAB 2: ATTENDANCE HISTORY -->
                        <div class="tab-pane fade" id="attendanceContent" role="tabpanel">
                            <c:choose>
                                <c:when test="${empty attendanceList}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-calendar-check text-muted" style="font-size: 2.5rem;"></i>
                                        <h6 class="fw-bold text-dark mt-2">No Attendance Check-Ins Yet</h6>
                                        <p class="text-muted small mb-3">When you check in using your session code or your coach marks attendance, your workout history will appear here.</p>
                                        <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3" onclick="document.getElementById('fitnessQrTokenInput')?.focus();">
                                            <i class="bi bi-qr-code-scan me-1"></i> Check In to a Workout
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                                <tr>
                                                    <th>Date</th>
                                                    <th>Coach</th>
                                                    <th>Session Slot</th>
                                                    <th>Attendance Status</th>
                                                    <th>Verification Method</th>
                                                    <th>Workout Notes</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="att" items="${attendanceList}">
                                                    <tr>
                                                        <td class="fw-medium text-dark">
                                                            <i class="bi bi-calendar-event text-danger me-1"></i>${att.sessionDate}
                                                        </td>
                                                        <td class="fw-bold text-dark">
                                                            ${not empty att.trainer ? att.trainer.fullName : (not empty att.booking and not empty att.booking.trainer ? att.booking.trainer.fullName : 'Coach')}
                                                        </td>
                                                        <td class="text-muted">
                                                            <i class="bi bi-clock me-1"></i>${not empty att.sessionTime ? att.sessionTime : 'Session Slot'}
                                                        </td>
                                                        <td>
                                                            <span class="badge ${att.status == 'PRESENT' ? 'bg-success' : 'bg-warning text-dark'} bg-opacity-10 text-${att.status == 'PRESENT' ? 'success' : 'warning'} border px-2 py-1">
                                                                <i class="bi bi-check-circle-fill me-1"></i>${att.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-light text-muted border">
                                                                <i class="bi bi-patch-check-fill text-success me-1"></i>Session Verified
                                                            </span>
                                                        </td>
                                                        <td class="text-muted small">${not empty att.notes ? att.notes : 'Standard Workout Attendance Verified'}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>


                        <!-- TAB 3: COMPLETED CLASSES -->
                        <div class="tab-pane fade" id="pastContent" role="tabpanel">
                            <c:set var="hasPast" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status eq 'COMPLETED' or (b.completedSessions != null and b.completedSessions > 0 and b.remainingSessions == 0) or b.status eq 'REJECTED' or b.status eq 'CANCELLED'}">
                                    <c:set var="hasPast" value="true" />
                                    <div class="border rounded-4 p-3 mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty b.trainer.profilePhotoPath ? b.trainer.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" class="avatar-small">
                                            <div>
                                                <h6 class="fw-bold mb-1">${b.trainer.fullName}</h6>
                                                <span class="badge bg-light text-dark me-2">${b.category}</span>
                                                <span class="text-muted text-xs"><i class="bi bi-calendar-event me-1"></i> ${b.bookingDate}</span>
                                                <c:if test="${not empty b.fitnessPackage}">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 ms-1">${b.fitnessPackage.packageName}</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${b.status eq 'COMPLETED' or (b.completedSessions != null and b.completedSessions > 0)}">
                                                    <span class="badge bg-primary px-3 py-2" style="border-radius:20px;">Completed</span>
                                                    <!-- Trigger Rate Modal -->
                                                    <button type="button" class="btn btn-primary-custom btn-custom py-1" data-bs-toggle="modal" data-bs-target="#rateModal${b.id}">
                                                        Leave Review
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/fitness/trainer/${b.trainer.id}" class="btn btn-outline-danger btn-custom py-1">
                                                        <i class="bi bi-arrow-repeat me-1"></i> Book Again
                                                    </a>
                                                </c:when>
                                                <c:when test="${b.status eq 'REJECTED'}">
                                                    <span class="badge bg-danger px-3 py-2" style="border-radius:20px;">Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary px-3 py-2" style="border-radius:20px;">Cancelled</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Rating Modal -->
                                    <div class="modal fade" id="rateModal${b.id}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content" style="border-radius: 24px; padding: 20px;">
                                                <div class="modal-header border-0">
                                                    <h5 class="fw-bold modal-title">Rate Coach ${b.trainer.fullName}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body border-0">
                                                    <form action="${pageContext.request.contextPath}/fitness/booking/rate" method="POST">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <div class="mb-3">
                                                            <label class="form-label text-xs fw-bold text-muted uppercase">Star Rating</label>
                                                            <select name="rating" class="form-select bg-light border-0" required style="border-radius:10px;">
                                                                <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                                                                <option value="4">⭐⭐⭐⭐ (Good)</option>
                                                                <option value="3">⭐⭐⭐ (Average)</option>
                                                                <option value="2">⭐⭐ (Fair)</option>
                                                                <option value="1">⭐ (Poor)</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label text-xs fw-bold text-muted uppercase">Coaching Feedback / Comments</label>
                                                            <textarea name="comment" class="form-control bg-light border-0" rows="3" required style="border-radius:10px;" placeholder="Leave a review comment..."></textarea>
                                                        </div>
                                                        <button type="submit" class="btn btn-primary-custom w-100 py-2 text-xs btn-custom">Submit Feedback</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPast}">
                                <div class="text-center py-5">
                                    <i class="bi bi-clock-history text-muted" style="font-size: 2.5rem;"></i>
                                    <h6 class="fw-bold text-dark mt-2">No Past Session Records</h6>
                                    <p class="text-muted small">Your completed workout sessions and past records will be archived here.</p>
                                </div>
                            </c:if>
                        </div>

                        <!-- TAB 4: PROGRESS & MILESTONES -->
                        <div class="tab-pane fade" id="progressContent" role="tabpanel">
                            <!-- Milestone Badges Grid -->
                            <div class="card border-0 rounded-4 p-3 mb-4 bg-light">
                                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                                    <div>
                                        <h6 class="fw-bold text-dark mb-0"><i class="bi bi-trophy-fill text-warning me-1"></i> Fitness Journey Milestones</h6>
                                        <small class="text-muted">Earn badges as you attend workouts and stay consistent</small>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-danger rounded-pill px-3 fw-bold" style="background:#f43f5e; border:none;" data-bs-toggle="modal" data-bs-target="#logProgressModal">
                                        <i class="bi bi-plus-circle me-1"></i> Log Today's Weight & Metrics
                                    </button>
                                </div>
                                <div class="row g-2">
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 rounded-3 text-center ${progressSummary.totalWorkoutsAttended >= 1 ? 'bg-white shadow-sm border border-success' : 'bg-white opacity-50 border'}">
                                            <div class="fs-4 text-warning mb-1"><i class="bi bi-star-fill"></i></div>
                                            <div class="fw-bold small text-dark">First Workout</div>
                                            <div class="text-xs ${progressSummary.totalWorkoutsAttended >= 1 ? 'text-success fw-bold' : 'text-muted'}">
                                                ${progressSummary.totalWorkoutsAttended >= 1 ? '✓ Unlocked' : '1 Workout'}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 rounded-3 text-center ${progressSummary.totalWorkoutsAttended >= 3 || progressSummary.currentStreakDays >= 3 ? 'bg-white shadow-sm border border-success' : 'bg-white opacity-50 border'}">
                                            <div class="fs-4 text-danger mb-1"><i class="bi bi-fire"></i></div>
                                            <div class="fw-bold small text-dark">Consistency Streak</div>
                                            <div class="text-xs ${progressSummary.totalWorkoutsAttended >= 3 || progressSummary.currentStreakDays >= 3 ? 'text-success fw-bold' : 'text-muted'}">
                                                ${progressSummary.totalWorkoutsAttended >= 3 || progressSummary.currentStreakDays >= 3 ? '✓ Unlocked' : '3 Workouts'}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 rounded-3 text-center ${progressSummary.totalWorkoutsAttended >= 5 ? 'bg-white shadow-sm border border-success' : 'bg-white opacity-50 border'}">
                                            <div class="fs-4 text-primary mb-1"><i class="bi bi-lightning-charge-fill"></i></div>
                                            <div class="fw-bold small text-dark">Workout Warrior</div>
                                            <div class="text-xs ${progressSummary.totalWorkoutsAttended >= 5 ? 'text-success fw-bold' : 'text-muted'}">
                                                ${progressSummary.totalWorkoutsAttended >= 5 ? '✓ Unlocked' : '5 Workouts'}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 rounded-3 text-center ${progressSummary.totalWorkoutsAttended >= 10 ? 'bg-white shadow-sm border border-success' : 'bg-white opacity-50 border'}">
                                            <div class="fs-4 text-success mb-1"><i class="bi bi-award-fill"></i></div>
                                            <div class="fw-bold small text-dark">Elite Club</div>
                                            <div class="text-xs ${progressSummary.totalWorkoutsAttended >= 10 ? 'text-success fw-bold' : 'text-muted'}">
                                                ${progressSummary.totalWorkoutsAttended >= 10 ? '✓ Unlocked' : '10 Workouts'}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Progress Logs List -->
                            <c:choose>
                                <c:when test="${empty progressLogs}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-graph-up-arrow text-muted" style="font-size: 2.5rem;"></i>
                                        <h6 class="fw-bold text-dark mt-2">No Progress Logs Recorded Yet</h6>
                                        <p class="text-muted small mb-3">Track your transformation by recording your weight and body metrics after workouts.</p>
                                        <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#logProgressModal">
                                            <i class="bi bi-plus-circle me-1"></i> Log First Weight & Metrics
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-3">
                                        <c:forEach var="log" items="${progressLogs}">
                                            <div class="col-md-6">
                                                <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100" style="border-left: 4px solid #f43f5e !important;">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <h6 class="fw-bold mb-0 text-dark">
                                                            <i class="bi bi-person-check text-danger me-1"></i>
                                                            ${not empty log.trainer ? log.trainer.fullName : 'Self Logged'}
                                                        </h6>
                                                        <span class="badge bg-light text-muted border">${log.logDate}</span>
                                                    </div>
                                                    <div class="d-flex gap-3 mb-2">
                                                        <div class="bg-light rounded-3 p-2 flex-grow-1 text-center">
                                                            <small class="text-muted d-block text-xs text-uppercase fw-bold">Weight</small>
                                                            <strong class="text-dark">${not empty log.weightKg ? log.weightKg : (not empty log.currentWeight ? log.currentWeight : '—')} kg</strong>
                                                        </div>
                                                        <c:if test="${not empty log.bodyFatPct}">
                                                            <div class="bg-light rounded-3 p-2 flex-grow-1 text-center">
                                                                <small class="text-muted d-block text-xs text-uppercase fw-bold">Body Fat</small>
                                                                <strong class="text-dark">${log.bodyFatPct}%</strong>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${not empty log.workoutsCompleted and log.workoutsCompleted > 0}">
                                                            <div class="bg-light rounded-3 p-2 flex-grow-1 text-center">
                                                                <small class="text-muted d-block text-xs text-uppercase fw-bold">Workouts</small>
                                                                <strong class="text-success">${log.workoutsCompleted} completed</strong>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="small fw-semibold text-dark mb-1">Workout & Evaluation Notes:</div>
                                                    <p class="small text-muted mb-0">${not empty log.workoutNotes ? log.workoutNotes : (not empty log.coachNotes ? log.coachNotes : 'Routine executed consistently.')}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </div>
            </div>
    </div>
</div>

<!-- Modal: User Self-Log Fitness Progress -->
<div class="modal fade" id="logProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 24px; padding: 15px;">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold modal-title text-dark"><i class="bi bi-speedometer2 text-danger me-2"></i>Log Weight & Fitness Metrics</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body border-0 pt-2">
                <p class="text-muted small mb-3">Record your latest body weight and workout notes to keep your streak and milestones updated.</p>
                <form id="fitnessProgressLogForm" action="${pageContext.request.contextPath}/fitness/progress/log" method="POST" onsubmit="return submitFitnessProgressLog(event);">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <div id="progressLogAlert" class="alert d-none py-2 px-3 small rounded-3 mb-3"></div>
                    <div class="mb-3">
                        <label class="form-label text-xs fw-bold text-muted text-uppercase">Current Weight (kg) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" step="0.1" min="20" max="300" name="weightKg" id="logWeightKg" class="form-control bg-light border-0" required placeholder="e.g. 68.5" style="border-radius: 10px 0 0 10px;">
                            <span class="input-group-text bg-light border-0 text-muted fw-bold" style="border-radius: 0 10px 10px 0;">kg</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-xs fw-bold text-muted text-uppercase">Body Fat % (Optional)</label>
                        <div class="input-group">
                            <input type="number" step="0.1" min="3" max="60" name="bodyFatPct" id="logBodyFatPct" class="form-control bg-light border-0" placeholder="e.g. 21.0" style="border-radius: 10px 0 0 10px;">
                            <span class="input-group-text bg-light border-0 text-muted fw-bold" style="border-radius: 0 10px 10px 0;">%</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-xs fw-bold text-muted text-uppercase">Workout Notes / Reflections (Optional)</label>
                        <textarea name="workoutNotes" id="logWorkoutNotes" class="form-control bg-light border-0" rows="3" placeholder="e.g. Completed upper body workout, feeling energized..." style="border-radius:10px;"></textarea>
                    </div>
                    <button type="submit" id="progressLogSubmitBtn" class="btn btn-danger w-100 py-2 fw-bold shadow-sm" style="background:#f43f5e; border:none; border-radius: 12px;">
                        <span id="progressLogSpinner" class="spinner-border spinner-border-sm me-1 d-none" role="status"></span>
                        <span id="progressLogBtnText"><i class="bi bi-check2-circle me-1"></i> Save Progress Entry</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function promptCheckInForTrainer(trainerName) {
        var input = document.getElementById('fitnessQrTokenInput');
        if (input) {
            input.focus();
            input.scrollIntoView({ behavior: 'smooth', block: 'center' });
            var msg = document.getElementById('fitnessCheckInMsg');
            if (msg) {
                msg.style.color = '#0284c7';
                msg.innerHTML = '<i class="bi bi-info-circle-fill me-1"></i> Enter the session code displayed by coach <strong>' + trainerName + '</strong> above.';
            }
        }
    }

    async function submitFitnessUserCheckIn(customToken) {
        const input = document.getElementById('fitnessQrTokenInput');
        const msg = document.getElementById('fitnessCheckInMsg');
        const btnText = document.getElementById('fitnessCheckInBtnText');
        const spinner = document.getElementById('fitnessCheckInSpinner');

        const token = (customToken || (input ? input.value : '')).trim();

        if (!token) {
            if (msg) {
                msg.style.color = '#dc2626';
                msg.textContent = 'Please enter the session code displayed by your trainer.';
            }
            if (input) input.focus();
            return;
        }

        if (msg) {
            msg.style.color = '#64748b';
            msg.textContent = 'Verifying and recording your workout session...';
        }
        if (spinner) spinner.classList.remove('d-none');
        if (btnText) btnText.textContent = 'Checking in...';

        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';

        const headers = { 'Content-Type': 'application/json' };
        if (csrfToken) headers[csrfHeader] = csrfToken;

        try {
            // First try calling the active endpoint
            let res = await fetch('${pageContext.request.contextPath}/api/fitness/qr/check-in', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify({ token: token })
            });

            if (res.status === 404) {
                res = await fetch('${pageContext.request.contextPath}/fitness/api/qr-checkin', {
                    method: 'POST',
                    headers: headers,
                    body: JSON.stringify({ token: token })
                });
            }

            const data = await res.json().catch(() => ({}));

            if (res.ok && data.success) {
                if (msg) {
                    msg.style.color = '#059669';
                    const coachName = data.trainerName ? ' with Coach ' + data.trainerName : '';
                    msg.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i> Checked in successfully' + coachName + '! 1 pass credit deducted.';
                }
                if (input) input.value = '';
                setTimeout(() => { location.reload(); }, 900);
            } else {
                if (msg) {
                    msg.style.color = '#dc2626';
                    let err = data.error || data.message || 'Check-in failed. Please verify the session code with your trainer.';
                    if (data.alreadyCheckedIn) {
                        msg.style.color = '#0284c7';
                        err = data.message || 'You have already checked in for today\'s session!';
                    }
                    msg.innerHTML = '<i class="bi bi-exclamation-triangle-fill me-1"></i> ' + err;
                }
                if (spinner) spinner.classList.add('d-none');
                if (btnText) btnText.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Check In';
            }
        } catch (e) {
            if (msg) {
                msg.style.color = '#dc2626';
                msg.textContent = 'Network error while checking in. Please try again.';
            }
            if (spinner) spinner.classList.add('d-none');
            if (btnText) btnText.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Check In';
        }
    }

    async function submitFitnessProgressLog(e) {
        if (e && e.preventDefault) e.preventDefault();
        var alertBox = document.getElementById('progressLogAlert');
        var spinner = document.getElementById('progressLogSpinner');
        var btnText = document.getElementById('progressLogBtnText');
        var submitBtn = document.getElementById('progressLogSubmitBtn');
        var weightInput = document.getElementById('logWeightKg');
        var bodyFatInput = document.getElementById('logBodyFatPct');
        var notesInput = document.getElementById('logWorkoutNotes');

        var weight = weightInput ? weightInput.value.trim() : '';
        if (!weight || parseFloat(weight) < 20 || parseFloat(weight) > 300) {
            if (alertBox) {
                alertBox.className = 'alert alert-danger py-2 px-3 small rounded-3 mb-3';
                alertBox.textContent = 'Please enter a valid weight between 20kg and 300kg.';
            }
            if (weightInput) weightInput.focus();
            return false;
        }

        if (spinner) spinner.classList.remove('d-none');
        if (btnText) btnText.textContent = 'Saving...';
        if (submitBtn) submitBtn.disabled = true;

        var formData = new URLSearchParams();
        formData.append('weightKg', weight);
        if (bodyFatInput && bodyFatInput.value.trim()) {
            formData.append('bodyFatPct', bodyFatInput.value.trim());
        }
        if (notesInput && notesInput.value.trim()) {
            formData.append('workoutNotes', notesInput.value.trim());
        }

        var csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
        var csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';
        var headers = {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        };
        if (csrfToken) headers[csrfHeader] = csrfToken;

        try {
            var res = await fetch('${pageContext.request.contextPath}/fitness/progress/log', {
                method: 'POST',
                headers: headers,
                body: formData.toString()
            });

            var data = await res.json().catch(function() { return {}; });

            if (res.ok && data.success) {
                if (alertBox) {
                    alertBox.className = 'alert alert-success py-2 px-3 small rounded-3 mb-3';
                    alertBox.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i> ' + (data.message || 'Progress logged successfully!');
                }
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/fitness/bookings';
                }, 700);
            } else {
                if (alertBox) {
                    alertBox.className = 'alert alert-danger py-2 px-3 small rounded-3 mb-3';
                    alertBox.innerHTML = '<i class="bi bi-exclamation-circle-fill me-1"></i> ' + (data.error || 'Failed to record progress log.');
                }
                if (spinner) spinner.classList.add('d-none');
                if (btnText) btnText.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Save Progress Entry';
                if (submitBtn) submitBtn.disabled = false;
            }
        } catch (err) {
            document.getElementById('fitnessProgressLogForm').submit();
        }
        return false;
    }
</script>

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
