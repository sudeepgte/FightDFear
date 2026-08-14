<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Training Journey | Fight D Fear</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-red: #E11D48;
            --primary-dark: #0F172A;
            --bg-light: #F8FAFC;
            --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #1E293B;
            margin: 0;
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--primary-dark);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            padding: 24px;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
        }

        .sidebar-logo img { width: 32px; }
        .sidebar-logo span { font-weight: 800; font-size: 1.25rem; letter-spacing: -0.5px; }

        .nav-menu { list-style: none; padding: 0; margin: 0; }
        .nav-item { margin-bottom: 8px; }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #94A3B8;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-link:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .nav-link.active { background: var(--primary-red); color: white; box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3); }
        .nav-link i { font-size: 1.1rem; }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 32px;
            min-height: 100vh;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .header-title h2 { font-weight: 800; margin-bottom: 4px; }
        .header-title p { color: #64748B; margin: 0; }

        .user-actions { display: flex; align-items: center; gap: 20px; }
        .icon-btn { 
            width: 40px; height: 40px; border-radius: 10px; 
            background: white; border: 1px solid #E2E8F0;
            display: flex; align-items: center; justify-content: center;
            color: #64748B; cursor: pointer; transition: var(--transition);
        }
        .icon-btn:hover { border-color: var(--primary-red); color: var(--primary-red); }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            border: 1px solid #F1F5F9;
            transition: var(--transition);
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-label { font-size: 0.8rem; color: #64748B; font-weight: 600; margin-bottom: 12px; display: block; }
        .stat-value { font-weight: 700; font-size: 1.2rem; display: block; margin-bottom: 8px; }
        .stat-link { font-size: 0.75rem; color: var(--primary-red); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 4px; }

        /* Main Layout Grid */
        .layout-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }

        .card-custom {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: var(--card-shadow);
            border: 1px solid #F1F5F9;
            height: 100%;
        }

        .card-header-custom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .card-title-custom { font-weight: 700; font-size: 1.1rem; margin: 0; }
        .card-link-custom { font-size: 0.8rem; color: var(--primary-red); text-decoration: none; font-weight: 600; }

        /* Timeline */
        .timeline-compact { padding-left: 15px; position: relative; }
        .timeline-compact::before {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 2px; background: #E2E8F0;
        }
        .timeline-item-compact {
            position: relative; padding-bottom: 20px; padding-left: 20px;
        }
        .timeline-item-compact::before {
            content: ''; position: absolute; left: -5px; top: 0;
            width: 12px; height: 12px; border-radius: 50%;
            background: white; border: 2px solid var(--primary-red);
        }

        /* Skills */
        .skill-item { margin-bottom: 16px; }
        .skill-info { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 0.85rem; }
        .progress-compact { height: 6px; border-radius: 10px; background: #F1F5F9; overflow: hidden; }
        .progress-bar-red { background: var(--primary-red); height: 100%; }

        /* Donut Chart Simulation */
        .donut-container {
            width: 150px; height: 150px; margin: 0 auto 20px;
            position: relative; display: flex; align-items: center; justify-content: center;
        }
        .donut-val { position: absolute; text-align: center; }
        .donut-val h3 { margin: 0; font-weight: 800; }
        .donut-val span { font-size: 0.7rem; color: #64748B; text-transform: uppercase; }

        /* Streak */
        .streak-dots { display: flex; justify-content: space-between; margin-top: 20px; }
        .streak-dot { 
            width: 32px; height: 32px; border-radius: 50%; border: 2px solid #E2E8F0;
            display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #64748B;
        }
        .streak-dot.active { border-color: var(--primary-red); background: #FFF1F2; color: var(--primary-red); font-weight: 700; }

        /* Belt Progress */
        .belt-path {
            display: flex; justify-content: space-between; align-items: center; padding: 20px 0;
        }
        .belt-node { text-align: center; position: relative; }
        .belt-icon { 
            width: 48px; height: 48px; border-radius: 50%; background: #F8FAFC;
            display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
            margin-bottom: 8px; border: 2px solid #E2E8F0;
        }
        .belt-node.active .belt-icon { background: #FFF1F2; border-color: var(--primary-red); color: var(--primary-red); }
        
        /* Secondary Grid */
        .secondary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            gap: 24px;
        }

        @media (max-width: 1200px) {
            .layout-grid { grid-template-columns: 1fr; }
            .secondary-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-hand-fist fa-2x text-danger"></i>
            <span>Fight D Fear</span>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link">
                    <i class="bi bi-grid"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/training-journey" class="nav-link active">
                    <i class="bi bi-compass"></i> My Journey
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="nav-link">
                    <i class="bi bi-calendar-check"></i> Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link">
                    <i class="bi bi-clock-history"></i> My Schedule
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/payment/users/my-payments" class="nav-link">
                    <i class="bi bi-wallet2"></i> Payments
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">
                    <i class="bi bi-person"></i> Profile
                </a>
            </li>
        </ul>

        <div class="mt-auto">
            <div class="card bg-white bg-opacity-10 border-0 rounded-4 p-3 text-center">
                <p class="small mb-2 text-white-50">Need Help?</p>
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-danger btn-sm w-100 rounded-3">Get Support</a>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="header-top">
            <div class="header-title">
                <h2>My Training Journey</h2>
                <p>Track your progress, stay consistent and achieve excellence.</p>
            </div>
            <div class="user-actions">
                <div class="icon-btn"><i class="bi bi-bell"></i></div>
                <div class="icon-btn" onclick="location.href='${pageContext.request.contextPath}/attendance/my-attendance'"><i class="bi bi-calendar"></i></div>
                <div class="dropdown">
                    <div class="icon-btn" onclick="location.href='${pageContext.request.contextPath}/users/profile/${user.id}'">
                        <i class="bi bi-person-circle"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Current Batch</span>
                <span class="stat-value">${not empty activeEnrollment ? activeEnrollment.batch.name : 'Not Enrolled'}</span>
                <a href="${not empty activeEnrollment ? pageContext.request.contextPath.concat('/centres/details/').concat(activeEnrollment.batch.center.id) : '#'}" class="stat-link">View Details <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="stat-card">
                <span class="stat-label">Trainer</span>
                <span class="stat-value">${not empty activeEnrollment ? activeEnrollment.batch.instructor : 'Not Assigned'}</span>
                <!-- Issue 140: Link trainer card to the centre details page which shows trainer info -->
                <a href="${not empty activeEnrollment ? pageContext.request.contextPath.concat('/centres/details/').concat(activeEnrollment.batch.center.id) : '#'}" class="stat-link">View Profile <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="stat-card">
                <div class="d-flex align-items-center gap-3">
                    <div class="donut-container" style="width: 60px; height: 60px;">
                        <canvas id="attendanceMini"></canvas>
                        <div class="donut-val">
                            <span class="fw-bold" style="font-size: 0.7rem;">${attendancePercentage}%</span>
                        </div>
                    </div>
                    <div>
                        <span class="stat-label mb-1">Attendance</span>
                        <small class="d-block text-muted">Present: ${presentCount}</small>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <span class="stat-label">Total Classes</span>
                <span class="stat-value">${totalClasses}</span>
                <small class="text-muted">Attended: ${attendedCount}</small>
            </div>
            <div class="stat-card">
                <span class="stat-label">Training Hours</span>
                <span class="stat-value">${totalHours}</span>
                <small class="text-muted">Total Journey</small>
            </div>
            <div class="stat-card">
                <span class="stat-label">Current Belt</span>
                <span class="stat-value">${currentBelt}</span>
                <div class="progress-compact mt-2">
                    <div class="progress-bar-red" style="width: ${beltProgress}%"></div>
                </div>
            </div>
        </div>

        <!-- Main Grid -->
        <div class="layout-grid">
            <!-- Training Timeline -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom">Training Timeline</h5>
                    <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="card-link-custom">View All</a>
                </div>
                <div class="timeline-compact">
                    <c:forEach var="item" items="${attendances}" varStatus="status">
                        <c:if test="${status.index < 4}">
                            <div class="timeline-item-compact">
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="fw-bold small">${not empty item.session ? item.session.batch.name : item.onlineClass.title}</span>
                                    <span class="text-muted" style="font-size: 0.7rem;">${not empty item.session ? item.session.date : item.onlineClass.date}</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-light text-dark small p-1 px-2 border" style="font-size: 0.65rem;">
                                        ${not empty item.session ? item.session.startTime : item.onlineClass.startTime}
                                    </span>
                                    <span class="text-success small fw-bold" style="font-size: 0.65rem;">${item.status}</span>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${empty attendances}">
                        <div class="text-center py-4">
                            <i class="bi bi-calendar-x fs-1 text-muted opacity-25 mb-3"></i>
                            <h6 class="fw-bold">No training sessions yet</h6>
                            <p class="text-muted small">Your training journey will appear here once classes begin.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Skill Progress -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom">Skill Progress</h5>
                    <a href="#" class="card-link-custom">View All</a>
                </div>
                <div class="skill-item">
                    <div class="skill-info">
                        <span><i class="fas fa-shoe-prints me-2"></i> Footwork</span>
                        <span class="fw-bold">${attendedCount * 2 > 100 ? 100 : attendedCount * 2}%</span>
                    </div>
                    <div class="progress-compact"><div class="progress-bar-red" style="width: ${attendedCount * 2 > 100 ? 100 : attendedCount * 2}%"></div></div>
                </div>
                <div class="skill-item">
                    <div class="skill-info">
                        <span><i class="fas fa-shield-alt me-2"></i> Blocking</span>
                        <span class="fw-bold">${attendedCount * 1.5 > 100 ? 100 : attendedCount * 1.5}%</span>
                    </div>
                    <div class="progress-compact"><div class="progress-bar-red" style="width: ${attendedCount * 1.5 > 100 ? 100 : attendedCount * 1.5}%"></div></div>
                </div>
                <div class="skill-item">
                    <div class="skill-info">
                        <span><i class="fas fa-hand-fist me-2"></i> Striking</span>
                        <span class="fw-bold">${attendedCount * 3 > 100 ? 100 : attendedCount * 3}%</span>
                    </div>
                    <div class="progress-compact"><div class="progress-bar-red" style="width: ${attendedCount * 3 > 100 ? 100 : attendedCount * 3}%"></div></div>
                </div>
                <div class="skill-item">
                    <div class="skill-info">
                        <span><i class="fas fa-dumbbell me-2"></i> Stamina</span>
                        <span class="fw-bold">${attendedCount * 1 > 100 ? 100 : attendedCount * 1}%</span>
                    </div>
                    <div class="progress-compact"><div class="progress-bar-red" style="width: ${attendedCount * 1 > 100 ? 100 : attendedCount * 1}%"></div></div>
                </div>
            </div>

            <!-- Attendance Overview -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom">Attendance Overview</h5>
                </div>
                <div class="donut-container">
                    <canvas id="attendanceMain"></canvas>
                    <div class="donut-val">
                        <h3>${attendancePercentage}%</h3>
                        <span>Attendance</span>
                    </div>
                </div>
                <div class="d-flex flex-column gap-2 mt-3">
                    <div class="d-flex justify-content-between align-items-center small">
                        <span><i class="bi bi-circle-fill text-success me-2"></i> Present</span>
                        <span class="fw-bold">${presentCount}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center small">
                        <span><i class="bi bi-circle-fill text-danger me-2"></i> Absent</span>
                        <span class="fw-bold">${absentCount}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center small">
                        <span><i class="bi bi-circle-fill text-warning me-2"></i> Late</span>
                        <span class="fw-bold">${lateCount}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Secondary Grid -->
        <div class="secondary-grid">
            <!-- Trainer Feedback -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom"><i class="bi bi-chat-quote text-danger me-2"></i> Feedback</h5>
                </div>
                <div class="bg-light p-4 rounded-4 text-center">
                    <p class="small text-muted mb-0 italic">No feedback available yet</p>
                </div>
            </div>

            <!-- Upcoming Class -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom">Upcoming Class</h5>
                    <a href="${pageContext.request.contextPath}/users/my-schedule" class="card-link-custom">View Schedule</a>
                </div>
                <div class="text-center py-3">
                    <c:choose>
                        <c:when test="${not empty upcomingClass}">
                            <h6 class="fw-bold mb-1">${upcomingClass.title}</h6>
                            <p class="text-muted small mb-3">${upcomingClass.date} @ ${upcomingClass.startTime}</p>
                            <a href="${upcomingClass.meetingLink}" class="btn btn-primary w-100 btn-sm rounded-pill"><i class="bi bi-camera-video me-2"></i>Join Session</a>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small mb-3">No upcoming classes scheduled</p>
                            <button class="btn btn-outline-secondary w-100 btn-sm rounded-pill" disabled><i class="bi bi-calendar-plus me-2"></i>Add to Calendar</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Training Streak -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom"><i class="bi bi-fire text-danger me-2"></i> Training Streak</h5>
                </div>
                <div class="text-center">
                    <h2 class="fw-extrabold mb-0">${streak} Days</h2>
                    <p class="text-muted small">Current Streak</p>
                    <div class="streak-dots">
                        <div class="streak-dot">M</div>
                        <div class="streak-dot">T</div>
                        <div class="streak-dot">W</div>
                        <div class="streak-dot">T</div>
                        <div class="streak-dot">F</div>
                        <div class="streak-dot">S</div>
                        <div class="streak-dot">S</div>
                    </div>
                </div>
            </div>

            <!-- Achievements -->
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="card-title-custom">Achievements</h5>
                    <a href="#" class="card-link-custom">View All</a>
                </div>
                <div class="text-center py-3">
                    <p class="text-muted small">No achievements unlocked yet</p>
                </div>
            </div>
        </div>

        <!-- Belt Progress Full Width -->
        <div class="card-custom mt-4">
            <h5 class="card-title-custom mb-4">Belt Progression Path</h5>
            <div class="belt-path">
                <div class="belt-node ${attendedCount >= 0 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal"></i></div>
                    <span class="small fw-bold d-block">White</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 0 ? 'Current' : 'Locked'}</span>
                </div>
                <i class="bi bi-arrow-right text-muted"></i>
                <div class="belt-node ${attendedCount >= 10 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal" style="color: #FFD700;"></i></div>
                    <span class="small fw-bold d-block">Yellow</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 10 ? 'Achieved' : '10 Classes'}</span>
                </div>
                <i class="bi bi-arrow-right text-muted"></i>
                <div class="belt-node ${attendedCount >= 25 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal" style="color: #FF8C00;"></i></div>
                    <span class="small fw-bold d-block">Orange</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 25 ? 'Achieved' : '25 Classes'}</span>
                </div>
                <i class="bi bi-arrow-right text-muted"></i>
                <div class="belt-node ${attendedCount >= 50 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal" style="color: #2E8B57;"></i></div>
                    <span class="small fw-bold d-block">Green</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 50 ? 'Achieved' : '50 Classes'}</span>
                </div>
                <i class="bi bi-arrow-right text-muted"></i>
                <div class="belt-node ${attendedCount >= 100 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal" style="color: #0000FF;"></i></div>
                    <span class="small fw-bold d-block">Blue</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 100 ? 'Achieved' : '100 Classes'}</span>
                </div>
                <i class="bi bi-arrow-right text-muted"></i>
                <div class="belt-node ${attendedCount >= 200 ? 'active' : ''}">
                    <div class="belt-icon"><i class="fas fa-medal" style="color: #000000;"></i></div>
                    <span class="small fw-bold d-block">Black</span>
                    <span class="text-muted" style="font-size: 0.65rem;">${attendedCount >= 200 ? 'Achieved' : '200 Classes'}</span>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Attendance Donut Chart
        const ctx = document.getElementById('attendanceMain').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Present', 'Absent', 'Late'],
                datasets: [{
                    data: [${presentCount}, ${absentCount}, ${lateCount}],
                    backgroundColor: ['#198754', '#dc3545', '#ffc107'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                cutout: '80%',
                plugins: { 
                    legend: { display: false },
                    tooltip: { enabled: true }
                }
            }
        });

        // Mini Attendance Donut
        const ctxMini = document.getElementById('attendanceMini').getContext('2d');
        new Chart(ctxMini, {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [${attendancePercentage}, ${100 - attendancePercentage}],
                    backgroundColor: ['#E11D48', '#F1F5F9'],
                    borderWidth: 0
                }]
            },
            options: {
                cutout: '85%',
                plugins: { legend: { display: false }, tooltip: { enabled: false } }
            }
        });
    </script>
</body>
</html>

