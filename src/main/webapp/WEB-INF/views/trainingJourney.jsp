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
            --rose-soft: #FFF1F2;
            --navy: #0F172A;
            --muted: #64748B;
            --bg: #F8FAFC;
            --border: #E2E8F0;
        }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); color: var(--navy); margin: 0; }
        .journey-wrap { padding: 96px 20px 40px; }
        .journey-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(15,23,42,0.04);
            padding: 20px;
            height: 100%;
        }
        .stat-label { font-size: 0.72rem; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase; color: var(--muted); }
        .stat-value { font-size: 1.15rem; font-weight: 800; color: var(--navy); display: block; margin-top: 4px; }
        .progress-compact { height: 8px; background: #F1F5F9; border-radius: 999px; overflow: hidden; }
        .progress-bar-rose { height: 100%; background: var(--rose); border-radius: 999px; }
        .status-banner {
            border: 1px solid var(--border);
            border-left: 4px solid var(--rose);
            border-radius: 14px;
            padding: 16px 18px;
            background: #fff;
            margin-bottom: 16px;
        }
        .status-banner.pending { border-left-color: #F59E0B; background: #FFFBEB; }
        .status-banner.pay { border-left-color: var(--rose); background: var(--rose-soft); }
        .icon-circle {
            width: 40px; height: 40px; border-radius: 50%;
            background: var(--rose-soft); color: var(--rose);
            display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-rose {
            background: var(--rose); color: #fff; border: none;
            border-radius: 999px; font-weight: 700; padding: 10px 18px;
            text-decoration: none; display: inline-block;
        }
        .btn-rose:hover { color: #fff; background: #E11D48; }
        .timeline-item { border-bottom: 1px solid #F1F5F9; padding: 10px 0; }
        .timeline-item:last-child { border-bottom: none; }
        @media (max-width: 991px) {
            .journey-wrap { padding-top: 24px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height:100vh; background:var(--bg);">
            <div class="container journey-wrap" style="max-width:1100px;">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                    <div>
                        <h1 class="h3 fw-bold mb-1">My Training Journey</h1>
                        <p class="text-muted mb-0">Track your progress, stay consistent and achieve excellence.</p>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a class="btn btn-outline-secondary btn-sm rounded-pill" href="${pageContext.request.contextPath}/attendance/my-attendance">Attendance</a>
                        <a class="btn btn-outline-secondary btn-sm rounded-pill" href="${pageContext.request.contextPath}/centres/allacceptedcentres">Martial Arts</a>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty enrollments}">
                        <div class="journey-card text-center py-5">
                            <div class="icon-circle mx-auto mb-3"><i class="bi bi-shield"></i></div>
                            <h5 class="fw-bold">No Martial Arts enrollment yet.</h5>
                            <p class="text-muted">Discover verified centres and enroll in a training batch.</p>
                            <a class="btn-rose" href="${pageContext.request.contextPath}/centres/allacceptedcentres">Explore Martial Arts</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${activeEnrollment.status == 'PENDING'}">
                            <div class="status-banner pending">
                                <strong>Application pending centre approval.</strong>
                                <div class="small mt-1"><c:out value="${activeEnrollment.batch != null ? activeEnrollment.batch.name : 'Batch'}"/> at <c:out value="${activeEnrollment.center != null ? activeEnrollment.center.name : 'Centre'}"/></div>
                            </div>
                        </c:if>
                        <c:if test="${activeEnrollment.status == 'APPROVED' && (empty activeEnrollment.paymentStatus || activeEnrollment.paymentStatus == 'PENDING')}">
                            <div class="status-banner pay">
                                <strong>Payment required.</strong>
                                <div class="small mt-1">Complete payment to activate your enrollment.</div>
                                <a class="btn-rose mt-2" href="${pageContext.request.contextPath}/enrollment/payment/${activeEnrollment.id}">Complete Payment →</a>
                            </div>
                        </c:if>

                        <div class="row g-3 mb-4">
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Current Batch</span>
                                    <span class="stat-value"><c:out value="${not empty activeEnrollment.batch ? activeEnrollment.batch.name : 'Not Enrolled'}"/></span>
                                </div>
                            </div>
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Trainer</span>
                                    <span class="stat-value"><c:out value="${not empty activeEnrollment.batch && not empty activeEnrollment.batch.instructor ? activeEnrollment.batch.instructor : 'Not Assigned'}"/></span>
                                </div>
                            </div>
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Attendance</span>
                                    <span class="stat-value">${attendancePercentage}%</span>
                                    <small class="text-muted">Present: ${presentCount}</small>
                                </div>
                            </div>
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Total Classes</span>
                                    <span class="stat-value">${totalClasses}</span>
                                    <small class="text-muted">Attended: ${attendedCount}</small>
                                </div>
                            </div>
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Training Hours</span>
                                    <span class="stat-value">${totalHours}</span>
                                </div>
                            </div>
                            <div class="col-6 col-lg-4">
                                <div class="journey-card">
                                    <span class="stat-label">Current Belt</span>
                                    <span class="stat-value"><c:out value="${currentBelt}"/></span>
                                    <c:if test="${beltAssessed}">
                                        <div class="progress-compact mt-2"><div class="progress-bar-rose" style="width:${beltProgress}%"></div></div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-lg-6">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Training Timeline</h5>
                                    <c:forEach var="item" items="${attendances}" varStatus="status">
                                        <c:if test="${status.index < 8}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between">
                                                    <strong class="small">
                                                        <c:choose>
                                                            <c:when test="${not empty item.session && not empty item.session.batch}"><c:out value="${item.session.batch.name}"/></c:when>
                                                            <c:when test="${not empty item.onlineClass}"><c:out value="${item.onlineClass.title}"/></c:when>
                                                            <c:otherwise>Training session</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <span class="small text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty item.session}"><c:out value="${item.session.date}"/></c:when>
                                                            <c:when test="${not empty item.onlineClass}"><c:out value="${item.onlineClass.date}"/></c:when>
                                                            <c:otherwise><c:out value="${item.attendanceDate}"/></c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <span class="badge rounded-pill" style="background:var(--rose-soft);color:var(--rose);">${item.status}</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty attendances}">
                                        <p class="text-muted small mb-0">No attendance records yet.</p>
                                    </c:if>
                                    <a class="small fw-semibold d-inline-block mt-2" style="color:var(--rose);" href="${pageContext.request.contextPath}/attendance/my-attendance">View all attendance</a>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Skill Progress</h5>
                                    <c:choose>
                                        <c:when test="${beltAssessed && not empty beltSkills}">
                                            <c:forEach var="entry" items="${beltSkills}">
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between small mb-1">
                                                        <span><c:out value="${entry.key}"/></span>
                                                        <strong><c:out value="${entry.value}"/>%</strong>
                                                    </div>
                                                    <div class="progress-compact"><div class="progress-bar-rose" style="width:${entry.value}%"></div></div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-0">Not assessed. Skills appear after your centre completes a belt grading.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Attendance Overview</h5>
                                    <p class="mb-1"><span class="text-success">●</span> Present: <strong>${presentCount}</strong></p>
                                    <p class="mb-1"><span class="text-danger">●</span> Absent: <strong>${absentCount}</strong></p>
                                    <p class="mb-0"><span class="text-warning">●</span> Late: <strong>${lateCount}</strong></p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Upcoming Class</h5>
                                    <c:choose>
                                        <c:when test="${not empty upcomingClass}">
                                            <h6 class="fw-bold"><c:out value="${upcomingClass.title}"/></h6>
                                            <p class="text-muted small"><c:out value="${upcomingClass.date}"/> @ <c:out value="${upcomingClass.startTime}"/></p>
                                            <c:if test="${not empty upcomingClass.meetingLink}">
                                                <a class="btn-rose btn-sm" href="${upcomingClass.meetingLink}">Join Session</a>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-0">No upcoming classes scheduled.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="journey-card text-center">
                                    <div class="icon-circle mx-auto mb-2"><i class="bi bi-fire"></i></div>
                                    <h5 class="fw-bold mb-1">Training Streak</h5>
                                    <div class="display-6 fw-bold" style="color:var(--rose);">${streak}</div>
                                    <p class="text-muted small mb-0">Days</p>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Feedback</h5>
                                    <c:choose>
                                        <c:when test="${not empty beltRemarks}">
                                            <p class="mb-0"><c:out value="${beltRemarks}"/></p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-0">No feedback available yet.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="journey-card">
                                    <h5 class="fw-bold mb-3">Belt Progression</h5>
                                    <c:choose>
                                        <c:when test="${beltAssessed}">
                                            <p class="mb-1"><strong>Current:</strong> <c:out value="${currentBelt}"/></p>
                                            <p class="mb-1"><strong>Target:</strong> <c:out value="${not empty beltTarget ? beltTarget : '—'}"/></p>
                                            <div class="progress-compact mt-2"><div class="progress-bar-rose" style="width:${beltProgress}%"></div></div>
                                            <small class="text-muted">Score from latest centre grading: ${beltProgress}%</small>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-0">Not assessed. Belt progress appears after centre grading.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="journey-card mt-3">
                            <h5 class="fw-bold mb-2">Achievements</h5>
                            <p class="text-muted small mb-0">No achievements unlocked yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
