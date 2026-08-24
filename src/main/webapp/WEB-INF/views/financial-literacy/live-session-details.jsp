<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${session != null ? session.title : 'Live Session Details'} - Financial Literacy</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --fl-purple: #1e1b4b;
            --fl-pink: #f43f5e;
            --fl-gold: #ffd700;
            --fl-bg: #f8fafc;
            --fl-shadow: 0 15px 35px rgba(30, 27, 75, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #F4F6FA;
            color: #333;
            min-height: 100vh;
            padding-top: 70px;
        }

        /* Hero Header */
        .details-hero {
            background: #F4F6FA;
            padding: 35px 0 45px;
            color: #0F172A;
            border-bottom: 1px solid #E2E8F0;
            position: relative;
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 2.2rem;
            color: #0B1736;
            margin-top: 10px;
            margin-bottom: 15px;
            line-height: 1.3;
        }

        /* Card Layout */
        .section-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--fl-shadow);
            border: 1px solid rgba(11, 23, 54, 0.06);
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: #0B1736;
            margin-bottom: 20px;
        }

        /* Metric Info Cards */
        .info-box {
            background: rgba(30, 27, 75, 0.03);
            border-radius: 16px;
            padding: 20px;
            height: 100%;
            border: 1px solid rgba(30, 27, 75, 0.05);
        }

        .info-box i {
            font-size: 1.5rem;
            color: var(--fl-pink);
            margin-bottom: 10px;
        }

        .info-box h6 {
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 5px;
        }

        .info-box p {
            font-weight: 600;
            font-size: 1.05rem;
            color: var(--fl-purple);
            margin-bottom: 0;
        }

        /* Action Buttons & Badges */
        .btn-purple {
            background: linear-gradient(135deg, var(--fl-purple), #312e81);
            color: white;
            border: none;
            font-weight: 600;
        }

        .btn-purple:hover {
            background: linear-gradient(135deg, #312e81, var(--fl-purple));
            color: white;
        }

        .join-btn {
            background: linear-gradient(135deg, var(--fl-purple), var(--fl-pink));
            color: white;
            border: none;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        .join-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(244, 63, 94, 0.3);
            color: white;
        }

        .blink {
            animation: blinker 1.5s linear infinite;
        }

        @keyframes blinker {
            50% { opacity: 0.3; }
        }

        @media (max-width: 768px) {
            .details-hero {
                padding: 35px 0 50px;
                border-bottom-left-radius: 25px;
                border-bottom-right-radius: 25px;
            }
            .details-hero h1 {
                font-size: 1.6rem;
            }
            .section-card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

    <!-- Header Fragment -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <!-- Hero Header -->
    <header class="details-hero">
        <div class="container position-relative">
            <a href="${pageContext.request.contextPath}/financial-literacy" class="btn btn-outline-light btn-sm rounded-pill mb-3">
                <i class="fas fa-arrow-left me-1"></i> Back to Live Sessions
            </a>

            <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                <!-- Category Badge -->
                <span class="badge bg-white text-dark px-3 py-2 rounded-pill fw-bold">
                    <i class="fas fa-tag me-1 text-primary"></i> ${session != null ? session.category : 'General'}
                </span>

                <!-- Session Status Badge -->
                <c:choose>
                    <c:when test="${session.sessionStatus eq 'LIVE NOW'}">
                        <span class="badge bg-danger text-white px-3 py-2 rounded-pill fw-bold">
                            <i class="fas fa-circle text-white me-1 blink"></i> LIVE NOW
                        </span>
                    </c:when>
                    <c:when test="${session.sessionStatus eq 'COMPLETED'}">
                        <span class="badge bg-secondary text-white px-3 py-2 rounded-pill fw-bold">
                            <i class="fas fa-check-circle me-1"></i> COMPLETED
                        </span>
                    </c:when>
                    <c:when test="${session.sessionStatus eq 'CANCELLED'}">
                        <span class="badge bg-dark text-white px-3 py-2 rounded-pill fw-bold">
                            <i class="fas fa-ban me-1"></i> CANCELLED
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold">
                            <i class="fas fa-calendar-alt me-1"></i> UPCOMING
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Title -->
            <h1>${session != null ? session.title : 'Live Session Details'}</h1>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container my-4 my-md-5">
        
        <!-- Registration Success / Notification Alerts -->
        <c:if test="${param.registrationSuccess eq 'true'}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2 fs-5"></i> <strong>Registration Submitted!</strong> Your registration is pending approval by admin.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${param.registrationSuccess eq 'false'}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2 fs-5"></i> <strong>Registration Failed!</strong> You may already be registered or seats are no longer available.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 4-Column Metric Info Grid -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="info-box">
                    <i class="fas fa-user-tie"></i>
                    <h6>Speaker</h6>
                    <p>${session != null ? session.speaker : 'TBA'}</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="info-box">
                    <i class="fas fa-calendar-day"></i>
                    <h6>Date</h6>
                    <p>${(session != null && not empty session.formattedDate) ? session.formattedDate : session.date}</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="info-box">
                    <i class="fas fa-clock"></i>
                    <h6>Time</h6>
                    <p>${(session != null && not empty session.formattedTime) ? session.formattedTime : session.time}</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="info-box">
                    <i class="fas fa-chair"></i>
                    <h6>Available Seats</h6>
                    <p>
                        <c:choose>
                            <c:when test="${session != null && session.seatsLeft > 0}">
                                <span class="text-success fw-bold">${session.seatsLeft}</span> <span class="small text-muted">/ ${session.seats}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-danger fw-bold">Full</span> <span class="small text-muted">(${session.seats})</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>

        <!-- About Session Card -->
        <div class="section-card">
            <h3><i class="fas fa-info-circle me-2 text-primary"></i>About This Session</h3>
            <p class="mb-0 text-secondary leading-relaxed fs-6">
                ${session != null ? session.description : 'No description provided for this session.'}
            </p>
        </div>

        <!-- Dynamic Registration & Action Section -->
        <div class="section-card text-center py-4">
            <c:choose>
                <%-- Case 1: User is Logged-In & Approved --%>
                <c:when test="${not empty userRegistration and userRegistration.status == 'approved'}">
                    <div class="mb-3">
                        <span class="badge bg-success bg-opacity-10 text-success border border-success px-4 py-2 rounded-pill fs-6 fw-bold">
                            <i class="fas fa-check-circle me-2"></i> Registration Approved
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${session.sessionStatus eq 'LIVE NOW' or session.sessionStatus eq 'UPCOMING'}">
                            <button type="button" class="join-btn btn-lg px-5 py-3 rounded-pill shadow" onclick="handleJoinSession(event, '${session.date}', '${session.time}', '${session.meetingUrl}')">
                                <i class="fas fa-video me-2"></i>Join Live Session
                            </button>
                            <p class="text-muted small mt-3 mb-0">Clicking will open the live session meeting link.</p>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-secondary btn-lg px-5 py-3 rounded-pill disabled" disabled>
                                <i class="fas fa-flag-checkered me-2"></i>Session Completed
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <%-- Case 2: User is Logged-In & Pending Approval --%>
                <c:when test="${not empty userRegistration and userRegistration.status == 'pending'}">
                    <div class="py-2">
                        <div class="badge bg-warning bg-opacity-10 text-dark border border-warning px-4 py-3 rounded-pill fs-6 fw-bold mb-2">
                            <i class="fas fa-clock me-2 text-warning"></i> Registration Pending Approval
                        </div>
                        <p class="text-muted small mb-0">Waiting for admin to approve your session registration.</p>
                    </div>
                </c:when>

                <%-- Case 3: User is Logged-In & Rejected --%>
                <c:when test="${not empty userRegistration and userRegistration.status == 'rejected'}">
                    <div class="py-2">
                        <div class="badge bg-danger bg-opacity-10 text-danger border border-danger px-4 py-3 rounded-pill fs-6 fw-bold mb-2">
                            <i class="fas fa-times-circle me-2"></i> Registration Rejected
                        </div>
                        <p class="text-danger small mb-0">Your registration for this session was not approved.</p>
                    </div>
                </c:when>

                <%-- Case 4: Unregistered & Seats Available --%>
                <c:when test="${empty userRegistration and session != null and session.seatsLeft > 0}">
                    <button class="btn btn-purple btn-lg px-5 py-3 rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#registrationModal">
                        <i class="fas fa-clipboard-list me-2"></i> Register for Session
                    </button>
                    <p class="text-muted small mt-3 mb-0">
                        <i class="fas fa-info-circle me-1"></i> ${session.seatsLeft} seats remaining. Reserve your spot now!
                    </p>
                </c:when>

                <%-- Case 5: Unregistered & Session Full --%>
                <c:otherwise>
                    <button class="btn btn-secondary btn-lg px-5 py-3 rounded-pill disabled" disabled style="opacity: 0.7; cursor: not-allowed;">
                        <i class="fas fa-ban me-2"></i> Session Full
                    </button>
                    <p class="text-danger small mt-3 mb-0">All ${session.seats} seats have been reserved for this session.</p>
                </c:otherwise>
            </c:choose>
        </div>

    </main>

    <!-- Registration Modal -->
    <div class="modal fade" id="registrationModal" tabindex="-1" aria-labelledby="registrationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 24px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="registrationModalLabel">Register for Live Session</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" data-bs-target="#registrationModal" aria-label="Close" onclick="bootstrap.Modal.getInstance(document.getElementById('registrationModal')).hide();"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/financial-literacy/live-session/register" method="POST" id="registrationForm">
                        <input type="hidden" name="sessionId" value="${session.id}">
                        
                        <div class="mb-3">
                            <label for="fullName" class="form-label fw-bold small text-muted">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${user != null ? user.fullName : ''}" required placeholder="Enter your full name">
                        </div>

                        <div class="mb-3">
                            <label for="mobile" class="form-label fw-bold small text-muted">Mobile Number <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="mobile" name="mobile" value="${user != null ? user.phoneNumber : ''}" required placeholder="Enter mobile number">
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-bold small text-muted">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" value="${user != null ? user.email : ''}" required placeholder="Enter email address">
                        </div>

                        <div class="mb-4">
                            <label for="occupation" class="form-label fw-bold small text-muted">Occupation (Optional)</label>
                            <input type="text" class="form-control" id="occupation" name="occupation" placeholder="e.g. Student, Working Professional">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-purple py-3 rounded-pill fw-bold" id="submitRegBtn">
                                Confirm Registration
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Session Timing Notice Modal -->
    <div class="modal fade" id="sessionNoticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center p-4 border-0 shadow-lg" style="border-radius: 24px;">
                <div class="modal-body">
                    <div class="mb-3">
                        <i id="noticeIcon" class="fas fa-clock text-warning" style="font-size: 3.5rem;"></i>
                    </div>
                    <h4 id="noticeTitle" class="fw-bold mb-2">Session is yet to start</h4>
                    <p id="noticeMessage" class="text-muted mb-4">This live session is scheduled for a future date/time. Please join when the session starts.</p>
                    <button type="button" class="btn btn-purple px-5 py-2 rounded-pill" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleJoinSession(event, dateStr, timeStr, rawMeetingUrl) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            let meetingUrl = (rawMeetingUrl || '').trim();
            if (meetingUrl.includes('/admin') || meetingUrl === 'admin') {
                meetingUrl = '';
            }

            // Parse date & start time
            let startTimeStr = '00:00';
            if (timeStr) {
                let parts = timeStr.split('-');
                startTimeStr = parts[0].trim();
            }

            let sessionStart = null;
            if (dateStr && dateStr.length >= 10) {
                let cleanDate = dateStr.trim();
                let dtString = cleanDate + 'T' + (startTimeStr.length === 5 ? startTimeStr : (startTimeStr + ':00'));
                sessionStart = new Date(dtString);
            }

            let now = new Date();

            // Allow joining up to 15 minutes before scheduled start time
            if (sessionStart && !isNaN(sessionStart.getTime())) {
                let allowTime = new Date(sessionStart.getTime() - 15 * 60 * 1000);
                if (now < allowTime) {
                    document.getElementById('noticeIcon').className = 'fas fa-clock text-warning';
                    document.getElementById('noticeTitle').innerText = 'Session is yet to start';
                    document.getElementById('noticeMessage').innerText = 'This session is scheduled for ' + (dateStr || '') + (timeStr ? (' at ' + timeStr) : '') + '. Please join when the session starts!';
                    const modalEl = document.getElementById('sessionNoticeModal');
                    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                    modal.show();
                    return false;
                }
            }

            if (!meetingUrl || meetingUrl.length < 5) {
                document.getElementById('noticeIcon').className = 'fas fa-video-slash text-secondary';
                document.getElementById('noticeTitle').innerText = 'Meeting Link Not Available';
                document.getElementById('noticeMessage').innerText = 'The meeting link for this session has not been updated yet. Please check back soon.';
                const modalEl = document.getElementById('sessionNoticeModal');
                const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                modal.show();
                return false;
            }

            if (!meetingUrl.startsWith('http://') && !meetingUrl.startsWith('https://')) {
                meetingUrl = 'https://' + meetingUrl;
            }

            window.open(meetingUrl, '_blank', 'noopener,noreferrer');
            return false;
        }
    </script>
</body>
</html>