<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Training Journey | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <style>
        :root {
            --rose: #F43F5E;
            --rose-hover: #E11D48;
            --rose-soft: #FFF1F2;
            --rose-border: #FECDD3;
            --navy: #0F172A;
            --navy-light: #1E293B;
            --muted: #64748B;
            --bg: #F8FAFC;
            --border: #E2E8F0;
            --card-bg: #FFFFFF;
        }

        html, body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--navy);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        #page-content-wrapper {
            flex: 1;
            margin-left: 260px;
            min-width: 0;
            min-height: auto !important;
            padding: 24px 30px 30px !important;
            background: var(--bg) !important;
            box-sizing: border-box;
        }

        .journey-container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            padding: 0;
        }

        .journey-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.03);
            padding: 20px 22px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }

        .journey-card:hover {
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
        }

        /* 3x2 Spacious Stat Grid */
        .stat-card {
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            min-height: 98px;
            height: 100%;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.02);
            transition: all 0.2s ease;
        }

        .stat-card:hover {
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.06);
            border-color: #CBD5E1;
            transform: translateY(-2px);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: var(--rose-soft);
            color: var(--rose);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .stat-content {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .stat-label {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 2px;
            line-height: 1.2;
        }

        .stat-value {
            font-size: 1.12rem;
            font-weight: 800;
            color: var(--navy);
            line-height: 1.3;
            word-break: break-word;
        }

        .stat-sub {
            font-size: 0.78rem;
            color: var(--muted);
            line-height: 1.3;
            margin-top: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .progress-compact {
            height: 7px;
            background: #F1F5F9;
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-bar-rose {
            height: 100%;
            background: var(--rose);
            border-radius: 999px;
        }

        .status-banner {
            border: 1px solid var(--border);
            border-left: 4px solid var(--rose);
            border-radius: 16px;
            padding: 16px 20px;
            background: #FFFFFF;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.02);
        }

        .status-banner.pending {
            border-left-color: #F59E0B;
            background: #FFFDF5;
        }

        .status-banner.pay {
            border-left-color: var(--rose);
            background: var(--rose-soft);
        }

        .btn-rose {
            background: var(--rose);
            color: #FFFFFF;
            border: none;
            border-radius: 999px;
            font-weight: 700;
            padding: 8px 20px;
            font-size: 0.88rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .btn-rose:hover {
            color: #FFFFFF;
            background: var(--rose-hover);
            transform: translateY(-1px);
        }

        .timeline-item {
            border-bottom: 1px solid #F1F5F9;
            padding: 12px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .timeline-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .timeline-item:first-child {
            padding-top: 0;
        }

        .badge-rose {
            background: var(--rose-soft);
            color: var(--rose);
            border: 1px solid var(--rose-border);
            font-weight: 700;
            font-size: 0.74rem;
            padding: 4px 10px;
            border-radius: 999px;
        }

        .section-title {
            font-size: 1.02rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .section-title i {
            color: var(--rose);
            font-size: 1rem;
        }

        @media (max-width: 768px) {
            #page-content-wrapper {
                margin-left: 0;
                padding: 16px !important;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper">
            <div class="journey-container">
                <!-- Page Top Header -->
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                    <div>
                        <h1 class="h4 fw-bold mb-1 text-dark">My Training Journey</h1>
                        <p class="text-muted small mb-0">Track your martial arts milestones, attendance record, and belt progression.</p>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a class="btn btn-outline-secondary btn-sm rounded-pill fw-semibold px-3 py-1" href="${pageContext.request.contextPath}/attendance/my-attendance">
                            <i class="bi bi-calendar-check me-1"></i> Attendance
                        </a>
                        <a class="btn btn-outline-secondary btn-sm rounded-pill fw-semibold px-3 py-1" href="${pageContext.request.contextPath}/centres/allacceptedcentres">
                            <i class="bi bi-shield me-1"></i> Martial Arts
                        </a>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty enrollments}">
                        <div class="journey-card text-center py-5 my-3">
                            <div class="stat-icon mx-auto mb-3" style="width: 54px; height: 54px; font-size: 1.4rem;">
                                <i class="bi bi-shield"></i>
                            </div>
                            <h5 class="fw-bold mb-2">No Martial Arts Enrollment Yet</h5>
                            <p class="text-muted small mb-3">Discover verified martial arts centres and enroll in a training batch to start your journey.</p>
                            <a class="btn-rose" href="${pageContext.request.contextPath}/centres/allacceptedcentres">
                                <i class="bi bi-compass"></i> Explore Martial Arts
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Pending / Payment Banners if applicable -->
                        <c:if test="${activeEnrollment.status == 'PENDING'}">
                            <div class="status-banner pending d-flex align-items-center justify-content-between flex-wrap gap-3">
                                <div>
                                    <div class="fw-bold text-dark d-flex align-items-center gap-2">
                                        <i class="bi bi-clock-history text-warning fs-5"></i>
                                        <span>Application Pending Centre Approval</span>
                                    </div>
                                    <div class="small text-muted mt-1 ps-4">
                                        <c:out value="${activeEnrollment.batch != null ? activeEnrollment.batch.name : 'Batch'}"/> at <c:out value="${activeEnrollment.center != null ? activeEnrollment.center.name : 'Centre'}"/>
                                    </div>
                                </div>
                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold">Pending</span>
                            </div>
                        </c:if>
                        <c:if test="${activeEnrollment.status == 'APPROVED' && (empty activeEnrollment.paymentStatus || activeEnrollment.paymentStatus == 'PENDING')}">
                            <div class="status-banner pay d-flex align-items-center justify-content-between flex-wrap gap-3">
                                <div>
                                    <div class="fw-bold text-dark d-flex align-items-center gap-2">
                                        <i class="bi bi-credit-card text-danger fs-5"></i>
                                        <span>Payment Required</span>
                                    </div>
                                    <div class="small text-muted mt-1 ps-4">Complete fee payment to activate your seat in this batch.</div>
                                </div>
                                <a class="btn-rose" href="${pageContext.request.contextPath}/enrollment/payment/${activeEnrollment.id}">
                                    Complete Payment <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </c:if>

                        <!-- Key Stats Grid (3 columns x 2 rows for spacious readable cards) -->
                        <div class="row g-3 mb-4">
                            <!-- Batch -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-bookmark-star"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Active Batch</div>
                                        <div class="stat-value">
                                            <c:out value="${not empty activeEnrollment.batch ? activeEnrollment.batch.name : 'Not Enrolled'}"/>
                                        </div>
                                        <div class="stat-sub">
                                            <c:out value="${not empty activeEnrollment.center ? activeEnrollment.center.name : 'Martial Arts Academy'}"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Trainer -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-person-badge"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Trainer / Coach</div>
                                        <div class="stat-value">
                                            <c:out value="${not empty activeEnrollment.batch && not empty activeEnrollment.batch.instructor ? activeEnrollment.batch.instructor : 'Assigned by Centre'}"/>
                                        </div>
                                        <div class="stat-sub">Certified Instructor</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Attendance -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-pie-chart"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Attendance Rate</div>
                                        <div class="stat-value">${attendancePercentage}%</div>
                                        <div class="stat-sub">Present: ${presentCount} / Attended: ${attendedCount}</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Total Classes -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-calendar-event"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Total Classes</div>
                                        <div class="stat-value">${totalClasses} Sessions</div>
                                        <div class="stat-sub">${attendedCount} attended of ${totalClasses} total</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Training Hours -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-stopwatch"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Training Hours</div>
                                        <div class="stat-value">${totalHours} Hours</div>
                                        <div class="stat-sub">Completed practice time</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Belt -->
                            <div class="col-12 col-sm-6 col-lg-4">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="bi bi-award"></i></div>
                                    <div class="stat-content">
                                        <div class="stat-label">Belt Status</div>
                                        <div class="stat-value">
                                            <c:out value="${currentBelt}"/>
                                        </div>
                                        <c:choose>
                                            <c:when test="${beltAssessed}">
                                                <div class="d-flex align-items-center gap-2 mt-1">
                                                    <div class="progress-compact flex-grow-1">
                                                        <div class="progress-bar-rose" style="width:${beltProgress}%"></div>
                                                    </div>
                                                    <span class="small fw-bold text-muted">${beltProgress}%</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="stat-sub">Awaiting belt grading</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Main 2-Column Section -->
                        <div class="row g-3">
                            <!-- Left Column: Timeline & Belt Progression -->
                            <div class="col-lg-7 col-xl-8 d-flex flex-column gap-3">
                                <!-- Training Timeline -->
                                <div class="journey-card">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="section-title mb-0">
                                            <i class="bi bi-clock-history"></i> Training Timeline
                                        </div>
                                        <a class="small fw-semibold text-decoration-none" style="color:var(--rose);" href="${pageContext.request.contextPath}/attendance/my-attendance">
                                            View All Attendance <i class="bi bi-chevron-right ms-1"></i>
                                        </a>
                                    </div>

                                    <c:forEach var="item" items="${attendances}" varStatus="status">
                                        <c:if test="${status.index < 6}">
                                            <div class="timeline-item">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="stat-icon" style="width: 36px; height: 36px; font-size: 0.95rem; border-radius: 10px;">
                                                        <i class="bi bi-check2-circle"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold small text-dark">
                                                            <c:choose>
                                                                <c:when test="${not empty item.session && not empty item.session.batch}"><c:out value="${item.session.batch.name}"/></c:when>
                                                                <c:when test="${not empty item.onlineClass}"><c:out value="${item.onlineClass.title}"/></c:when>
                                                                <c:otherwise>Training Session</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="small text-muted" style="font-size: 0.78rem;">
                                                            <c:choose>
                                                                <c:when test="${not empty item.session}"><c:out value="${item.session.date}"/></c:when>
                                                                <c:when test="${not empty item.onlineClass}"><c:out value="${item.onlineClass.date}"/></c:when>
                                                                <c:otherwise><c:out value="${item.attendanceDate}"/></c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                                <span class="badge badge-rose">${item.status}</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty attendances}">
                                        <p class="text-muted small mb-0 py-2">No attendance records logged yet.</p>
                                    </c:if>
                                </div>

                                <!-- Belt & Skill Progress -->
                                <div class="journey-card">
                                    <div class="section-title">
                                        <i class="bi bi-graph-up-arrow"></i> Skill & Belt Progression
                                    </div>

                                    <c:choose>
                                        <c:when test="${beltAssessed && not empty beltSkills}">
                                            <div class="d-flex justify-content-between align-items-center small mb-2">
                                                <span><strong>Current Belt:</strong> <c:out value="${currentBelt}"/></span>
                                                <span><strong>Target:</strong> <c:out value="${not empty beltTarget ? beltTarget : '—'}"/></span>
                                            </div>
                                            <div class="progress-compact mb-3">
                                                <div class="progress-bar-rose" style="width:${beltProgress}%"></div>
                                            </div>

                                            <div class="row g-2">
                                                <c:forEach var="entry" items="${beltSkills}">
                                                    <div class="col-sm-6">
                                                        <div class="p-2 rounded" style="background:#F8FAFC; border:1px solid #E2E8F0;">
                                                            <div class="d-flex justify-content-between small mb-1">
                                                                <span class="fw-semibold text-dark"><c:out value="${entry.key}"/></span>
                                                                <strong style="color:var(--rose);"><c:out value="${entry.value}"/>%</strong>
                                                            </div>
                                                            <div class="progress-compact">
                                                                <div class="progress-bar-rose" style="width:${entry.value}%"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="p-3 rounded text-center" style="background:#F8FAFC; border:1px solid #E2E8F0;">
                                                <p class="text-muted small mb-0">No belt assessment on record. Skill ratings and progression appear once your centre conducts a belt grading.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Right Column: Quick Status & Insights -->
                            <div class="col-lg-5 col-xl-4 d-flex flex-column gap-3">
                                <!-- Upcoming Class -->
                                <div class="journey-card">
                                    <div class="section-title">
                                        <i class="bi bi-camera-video"></i> Upcoming Class
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty upcomingClass}">
                                            <div class="fw-bold text-dark mb-1"><c:out value="${upcomingClass.title}"/></div>
                                            <div class="text-muted small mb-3">
                                                <i class="bi bi-calendar3 me-1"></i> <c:out value="${upcomingClass.date}"/> at <c:out value="${upcomingClass.startTime}"/>
                                            </div>
                                            <c:if test="${not empty upcomingClass.meetingLink}">
                                                <a class="btn-rose w-100 justify-content-center btn-sm" href="${upcomingClass.meetingLink}" target="_blank">
                                                    <i class="bi bi-box-arrow-up-right"></i> Join Session
                                                </a>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-0">No upcoming live classes scheduled at this time.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Attendance Overview & Streak -->
                                <div class="journey-card">
                                    <div class="section-title">
                                        <i class="bi bi-activity"></i> Attendance Breakdown
                                    </div>
                                    <div class="d-flex justify-content-between text-center p-3 rounded mb-3" style="background:#F8FAFC; border:1px solid #E2E8F0;">
                                        <div>
                                            <div class="small fw-bold text-success">Present</div>
                                            <div class="h5 fw-bold mb-0 text-dark">${presentCount}</div>
                                        </div>
                                        <div style="border-left:1px solid #E2E8F0;"></div>
                                        <div>
                                            <div class="small fw-bold text-danger">Absent</div>
                                            <div class="h5 fw-bold mb-0 text-dark">${absentCount}</div>
                                        </div>
                                        <div style="border-left:1px solid #E2E8F0;"></div>
                                        <div>
                                            <div class="small fw-bold text-warning">Late</div>
                                            <div class="h5 fw-bold mb-0 text-dark">${lateCount}</div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between p-2 px-3 rounded" style="background:var(--rose-soft); border:1px solid var(--rose-border);">
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="bi bi-fire text-danger fs-5"></i>
                                            <span class="small fw-bold text-dark">Active Streak</span>
                                        </div>
                                        <span class="h5 fw-bold mb-0" style="color:var(--rose);">${streak} Days</span>
                                    </div>
                                </div>

                                <!-- Feedback & Achievements -->
                                <div class="journey-card">
                                    <div class="section-title">
                                        <i class="bi bi-chat-heart"></i> Trainer Feedback
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty beltRemarks}">
                                            <p class="small text-dark mb-3"><c:out value="${beltRemarks}"/></p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-3">No feedback available yet.</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="pt-2 border-top">
                                        <div class="section-title mb-2" style="font-size:0.92rem;">
                                            <i class="bi bi-trophy"></i> Achievements
                                        </div>
                                        <p class="text-muted small mb-0">No achievements unlocked yet.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
