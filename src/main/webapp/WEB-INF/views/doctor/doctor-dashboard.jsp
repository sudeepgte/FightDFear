<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard &mdash; Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #F43F5E;
            --primary-light: #FFE4E6;
            --text-main: #1E1B4B;
            --text-muted: #64748B;
            --bg-page: #F8FAFC;
            --bg-card: #FFFFFF;
            --border: #E2E8F0;
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            --sidebar-width: 260px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg-page); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-width); background: var(--bg-card); border-right: 1px solid var(--border); display: flex; flex-direction: column; height: 100%; position: relative; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; font-weight: 800; font-size: 1.25rem; color: var(--text-main); border-bottom: 1px solid var(--border); }
        .brand img { width: 32px; height: 32px; border-radius: 8px; }
        
        .nav-links { flex: 1; padding: 20px 16px; overflow-y: auto; display: flex; flex-direction: column; gap: 4px; }
        .nav-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-muted); font-weight: 600; text-decoration: none; transition: 0.2s; font-size: 0.95rem; }
        .nav-link i { font-size: 1.1rem; }
        .nav-link:hover { background: #f1f5f9; color: var(--text-main); }
        .nav-link.active { background: var(--primary-light); color: var(--primary); }

        .sidebar-footer { padding: 24px; text-align: center; border-top: 1px solid var(--border); position: relative; overflow: hidden; }
        .sidebar-footer img { max-width: 120px; margin: 0 auto; display: block; opacity: 0.9; }

        /* Main Content */
        .main-content { flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden; }
        
        /* Header */
        .header { background: var(--bg-card); padding: 20px 32px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        .greeting h1 { font-size: 1.4rem; font-weight: 800; margin-bottom: 4px; }
        .greeting h1 span { color: var(--primary); }
        .greeting p { color: var(--text-muted); font-size: 0.9rem; margin: 0; }
        
        .header-actions { display: flex; align-items: center; gap: 20px; }
        .icon-btn { position: relative; background: transparent; border: none; font-size: 1.3rem; color: var(--text-muted); cursor: pointer; }
        .icon-btn .badge { position: absolute; top: -4px; right: -4px; background: var(--primary); color: white; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 50px; border: 2px solid white; }
        
        .status-dropdown { display: flex; align-items: center; gap: 8px; background: var(--bg-page); padding: 8px 16px; border-radius: 50px; font-size: 0.85rem; font-weight: 600; border: 1px solid var(--border); cursor: pointer; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; background: #10B981; }
        
        .btn-add { background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem; border: none; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-add:hover { background: #E11D48; transform: translateY(-1px); }

        /* Content Area */
        .page-body { flex: 1; padding: 32px; overflow-y: auto; }
        
        /* Overview Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 24px; }
        .stat-card { background: var(--bg-card); padding: 20px; border-radius: 16px; border: 1px solid var(--border); display: flex; align-items: flex-start; gap: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; flex-shrink: 0; }
        .stat-info h4 { color: var(--text-muted); font-size: 0.8rem; font-weight: 600; margin: 0 0 4px 0; }
        .stat-info h2 { font-size: 1.6rem; font-weight: 800; margin: 0 0 4px 0; }
        .stat-info p { font-size: 0.75rem; font-weight: 600; margin: 0; color: var(--primary); }
        .stat-info p.muted { color: var(--text-muted); }

        /* Main Grid */
        .main-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; }
        
        .card { background: var(--bg-card); border-radius: 16px; border: 1px solid var(--border); padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-title { font-weight: 800; font-size: 1.1rem; display: flex; align-items: center; gap: 8px; }
        .card-link { color: var(--primary); font-size: 0.85rem; font-weight: 600; text-decoration: none; }

        /* Appointments Table */
        .appt-list { display: flex; flex-direction: column; gap: 12px; }
        .appt-item { display: grid; grid-template-columns: auto 1fr auto auto auto; gap: 16px; align-items: center; padding: 16px 0; border-bottom: 1px solid var(--border); }
        .appt-item:last-child { border-bottom: none; }
        
        .time-box { text-align: center; color: var(--primary); font-weight: 800; font-size: 0.9rem; line-height: 1.2; width: 60px; }
        .time-box span { font-size: 0.75rem; font-weight: 600; display: block; }
        
        .patient-info h4 { font-size: 0.95rem; font-weight: 700; margin: 0 0 4px 0; }
        .patient-info p { font-size: 0.8rem; color: var(--text-muted); margin: 0; }
        
        .appt-mode { font-size: 0.85rem; color: var(--text-muted); font-weight: 500; display: flex; align-items: center; gap: 6px; }
        
        .badge { padding: 4px 12px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
        .badge.upcoming { background: var(--warning-bg); color: var(--warning-text); }
        .badge.confirmed { background: var(--success-bg); color: var(--success-text); }
        .badge.completed { background: var(--success-bg); color: var(--success-text); }
        .badge.cancelled { background: var(--error-bg); color: var(--error-text); }
        
        .appt-actions form { display: inline-block; }
        .action-btn { background: #f1f5f9; border: none; width: 28px; height: 28px; border-radius: 6px; color: var(--text-muted); cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
        .action-btn:hover { background: var(--primary-light); color: var(--primary); }

        /* Quick Actions */
        .quick-actions-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .q-action-btn { background: var(--bg-page); border: 1px solid var(--border); border-radius: 12px; padding: 16px; text-align: center; color: var(--text-main); text-decoration: none; transition: 0.2s; display: flex; flex-direction: column; align-items: center; gap: 8px; font-weight: 600; font-size: 0.8rem; }
        .q-action-btn i { font-size: 1.5rem; color: var(--primary); }
        .q-action-btn:hover { border-color: var(--primary); background: var(--primary-light); }

        /* Reminders */
        .reminder-item { display: flex; align-items: flex-start; gap: 12px; padding: 12px 0; border-bottom: 1px solid var(--border); }
        .reminder-item:last-child { border-bottom: none; }
        .reminder-icon { width: 36px; height: 36px; border-radius: 8px; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .reminder-content { flex: 1; }
        .reminder-content h4 { font-size: 0.9rem; font-weight: 700; margin: 0 0 4px 0; }
        .reminder-content p { font-size: 0.8rem; color: var(--text-muted); margin: 0; }
        
        /* Verification Banner */
        .verify-banner { background: var(--warning-bg); border: 1px solid #fed7aa; border-radius: 12px; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .verify-banner.verified { background: var(--success-bg); border-color: #bbf7d0; }
        .verify-info h4 { color: var(--warning-text); font-weight: 800; font-size: 1rem; margin: 0 0 4px 0; display: flex; align-items: center; gap: 8px; }
        .verify-banner.verified .verify-info h4 { color: var(--success-text); }
        .verify-info p { color: var(--text-main); font-size: 0.85rem; margin: 0; font-weight: 500; }
        
        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 2rem; opacity: 0.5; margin-bottom: 12px; display: block; }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Logo">
            <div>
                Fight D Fear
                <div style="font-size: 0.7rem; color: var(--primary); font-weight: 600;">Women Safety &bull; Healthcare</div>
            </div>
        </div>
        
        <nav class="nav-links">
            <a href="?section=overview" class="nav-link ${section == 'overview' || empty section ? 'active' : ''}"><i class="bi bi-house-door"></i> Dashboard</a>
            <a href="?section=appointments" class="nav-link ${section == 'appointments' ? 'active' : ''}"><i class="bi bi-calendar-event"></i> Appointments</a>
            <a href="?section=patients" class="nav-link ${section == 'patients' ? 'active' : ''}"><i class="bi bi-people"></i> Patients</a>
            <a href="?section=consultations" class="nav-link ${section == 'consultations' ? 'active' : ''}"><i class="bi bi-chat-dots"></i> Consultations</a>
            <a href="?section=prescriptions" class="nav-link ${section == 'prescriptions' ? 'active' : ''}"><i class="bi bi-file-medical"></i> Prescriptions</a>
            <a href="?section=earnings" class="nav-link ${section == 'earnings' ? 'active' : ''}"><i class="bi bi-wallet2"></i> Earnings</a>
            <a href="?section=calendar" class="nav-link ${section == 'calendar' ? 'active' : ''}"><i class="bi bi-calendar3"></i> Calendar</a>
            <a href="?section=reviews" class="nav-link ${section == 'reviews' ? 'active' : ''}"><i class="bi bi-star"></i> Reviews</a>
            <a href="?section=settings" class="nav-link ${section == 'settings' ? 'active' : ''}"><i class="bi bi-gear"></i> Settings</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="margin-top: auto;" onclick="return confirm('Are you sure you want to logout?');"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </nav>
        
        <div class="sidebar-footer">
            <img src="${pageContext.request.contextPath}/assets/img/doctor-illustration.svg" onerror="this.style.display='none'" alt="Doctor">
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <header class="header">
            <div class="greeting">
                <h1>Dr. <span>${doctor.fullName}</span></h1>
                <p>Here's an overview of your clinic today.</p>
            </div>
            <div class="header-actions">
                <!-- Notifications -->
                <div style="position:relative; display:inline-block;">
                    <button class="icon-btn" onclick="document.getElementById('notifMenu').style.display = document.getElementById('notifMenu').style.display === 'block' ? 'none' : 'block'">
                        <i class="bi bi-bell"></i>
                        <c:if test="${unreadNotifCount > 0}">
                            <span class="badge">${unreadNotifCount}</span>
                        </c:if>
                    </button>
                    <div id="notifMenu" style="display:none; position:absolute; right:0; top:45px; background:#fff; border:1px solid #e2e8f0; border-radius:12px; width:300px; box-shadow:0 10px 25px rgba(0,0,0,0.1); z-index:100;">
                        <div style="padding:16px; border-bottom:1px solid #e2e8f0; font-weight:700;">Notifications</div>
                        <div style="max-height:300px; overflow-y:auto;">
                            <c:choose>
                                <c:when test="${empty recentNotifications}">
                                    <div style="padding:16px; text-align:center; color:#64748B;">No new notifications</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="n" items="${recentNotifications}">
                                        <div style="padding:12px 16px; border-bottom:1px solid #f1f5f9; font-size:14px; ${n.readFlag ? 'color:#64748B;' : 'font-weight:600; color:#1E1B4B;'}">
                                            ${n.message}
                                            <div style="font-size:12px; color:#94a3b8; margin-top:4px;">${n.createdAt.toString().substring(0, 16)}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Online Status Toggle -->
                <form action="${pageContext.request.contextPath}/doctors/toggle-online" method="post" style="margin:0;">
                    <button type="submit" class="status-dropdown" style="background:transparent; border:1px solid var(--border); font-size:0.9rem; cursor:pointer;">
                        <span class="status-dot" style="background: ${doctor.isOnline ? '#22c55e' : '#94a3b8'};"></span> 
                        ${doctor.isOnline ? 'Available' : 'Offline'}
                    </button>
                </form>

                <!-- Add Availability Modal Trigger -->
                <button class="btn-add" onclick="document.getElementById('availabilityModal').style.display='flex'"><i class="bi bi-plus-lg"></i> Add Availability</button>
            </div>
        </header>

        <!-- Add Availability Modal -->
        <div id="availabilityModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
            <div style="background:#fff; padding:24px; border-radius:16px; width:100%; max-width:400px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 style="margin:0; font-weight:700;">Add Availability</h3>
                    <button onclick="document.getElementById('availabilityModal').style.display='none'" style="background:none; border:none; font-size:1.5rem; cursor:pointer;">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/doctors/update-availability" method="post">
                    <div style="margin-bottom:16px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">Available Days</label>
                        <input type="text" name="availableDays" value="${doctor.availableDays}" placeholder="e.g. MON,TUE,WED" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <div style="margin-bottom:16px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">Start Time</label>
                        <input type="time" name="startTime" value="${doctor.startTime}" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <div style="margin-bottom:24px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">End Time</label>
                        <input type="time" name="endTime" value="${doctor.endTime}" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <button type="submit" class="btn-primary" style="width:100%; padding:12px; border:none; border-radius:8px; font-weight:600; cursor:pointer;">Save Availability</button>
                </form>
            </div>
        </div>

        <!-- Body -->
        <c:choose>
            <c:when test="${empty doctor.profileCompletionPct || doctor.profileCompletionPct < 100}">
                <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:60vh; text-align:center;">
                    <i class="bi bi-person-lines-fill" style="font-size: 4rem; color: #F43F5E; margin-bottom: 20px;"></i>
                    <h2 style="font-weight: 800; color: #1E1B4B; margin-bottom: 12px;">Update Profile First</h2>
                    <p style="color: #64748B; font-size: 1rem; max-width: 400px; line-height: 1.6; margin-bottom: 24px;">
                        You must complete your profile 100% to access the dashboard and continue the verification process.
                    </p>
                    <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-primary" style="text-decoration: none; display: inline-block; padding: 12px 24px; border-radius: 8px; font-weight: 600;">Complete Profile Now</a>
                </div>
            </c:when>
            <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:60vh; text-align:center;">
                    <i class="bi bi-hourglass-split" style="font-size: 4rem; color: #64748B; margin-bottom: 20px;"></i>
                    <h2 style="font-weight: 800; color: #1E1B4B; margin-bottom: 12px;">Profile Under Review</h2>
                    <p style="color: #64748B; font-size: 1rem; max-width: 400px; line-height: 1.6;">
                        Your profile has been submitted successfully and is currently being reviewed by our administration team. 
                        You will gain full access to your dashboard once approved.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
        <div class="page-body">
            
            <c:if test="${not empty message}">
                <div style="padding:14px 20px; border-radius:12px; background:var(--success-bg); border:1px solid #bbf7d0; color:var(--success-text); font-size:13px; font-weight:600; margin-bottom:24px; display:flex; align-items:center; gap:8px">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                </div>
            </c:if>

            <c:choose>
                <%-- ======================= OVERVIEW ======================= --%>
                <c:when test="${section == 'overview' || empty section}">
                    
                    <c:if test="${doctor.doctorProfileStatus != 'APPROVED' && (empty doctor.profileCompletionPct || doctor.profileCompletionPct < 100)}">
                        <div style="padding:16px 20px; border-radius:12px; background:var(--warning-bg); border:1px solid #fed7aa; color:var(--warning-text); margin-bottom:24px; display:flex; align-items:center; justify-content:space-between; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);">
                            <div>
                                <h4 style="margin:0 0 4px 0; font-weight:800; font-size:1.05rem;"><i class="bi bi-exclamation-triangle-fill"></i> Profile Incomplete (${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%)</h4>
                                <p style="margin:0; font-size:0.85rem; color:var(--text-main); font-weight:500;">Your profile is missing important details. Please complete it to become fully visible to patients.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-add" style="background:#C2410C;"><i class="bi bi-pencil-square"></i> Update Profile</a>
                        </div>
                    </c:if>
                    
                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-calendar-check"></i></div>
                            <div class="stat-info">
                                <h4>Today's Appointments</h4>
                                <h2>${todayTotal}</h2>
                                <p>${upcomingCount} Upcoming</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-person-hearts"></i></div>
                            <div class="stat-info">
                                <h4>Total Patients</h4>
                                <h2>${totalPatients}</h2>
                                <p class="muted">All time</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-chat-dots"></i></div>
                            <div class="stat-info">
                                <h4>Consultations</h4>
                                <h2>${consultationsThisMonth}</h2>
                                <p class="muted">This Month</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                            <div class="stat-info">
                                <h4>Earnings</h4>
                                <h2>&#8377;${earningsThisMonth}</h2>
                                <p class="muted">This Month</p>
                            </div>
                        </div>
                    </div>

                    <div class="main-grid">
                        <!-- Left Column -->
                        <div class="col-left">
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-title"><i class="bi bi-calendar-day" style="color:var(--primary)"></i> Today's Appointments</div>
                                    <a href="?section=appointments" class="card-link">View Calendar <i class="bi bi-chevron-right"></i></a>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${empty todayAppointments}">
                                        <div class="empty-state">
                                            <i class="bi bi-calendar-x"></i>
                                            <p>No appointments scheduled for today.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="appt-list">
                                            <c:forEach var="a" items="${todayAppointments}">
                                                <div class="appt-item">
                                                    <div class="time-box">
                                                        <fmt:parseDate value="${a.appointmentTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedTime" type="both" />
                                                        <fmt:formatDate pattern="hh:mm" value="${parsedTime}" />
                                                        <span><fmt:formatDate pattern="a" value="${parsedTime}" /></span>
                                                    </div>
                                                    <div class="patient-info">
                                                        <h4>${a.user.fullName}</h4>
                                                        <p>${not empty a.reason ? a.reason : 'General Consultation'}</p>
                                                    </div>
                                                    <div class="appt-mode">
                                                        <c:choose>
                                                            <c:when test="${a.consultationType == 'VIDEO'}"><i class="bi bi-camera-video"></i> Video Call</c:when>
                                                            <c:when test="${a.consultationType == 'CLINIC'}"><i class="bi bi-geo-alt"></i> In Clinic</c:when>
                                                            <c:otherwise><i class="bi bi-telephone"></i> Voice Call</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <span class="badge ${a.status == 'PENDING' || a.status == 'CONFIRMED' ? 'upcoming' : a.status.toString().toLowerCase()}">
                                                            ${a.status == 'PENDING' ? 'Upcoming' : a.status == 'CONFIRMED' ? 'Confirmed' : a.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                                                        </span>
                                                    </div>
                                                    <div class="appt-actions">
                                                        <c:if test="${a.status == 'PENDING'}">
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="CONFIRMED"><button class="action-btn" title="Confirm"><i class="bi bi-check-lg"></i></button></form>
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="CANCELLED"><button class="action-btn" title="Reject"><i class="bi bi-x-lg"></i></button></form>
                                                        </c:if>
                                                        <c:if test="${a.status == 'CONFIRMED'}">
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="COMPLETED"><button class="action-btn" title="Mark Completed"><i class="bi bi-check-all"></i></button></form>
                                                        </c:if>
                                                        <c:if test="${a.status != 'CANCELLED'}">
                                                            <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" class="action-btn" target="_blank" title="Chat"><i class="bi bi-chat-dots"></i></a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid var(--border);">
                                    <a href="?section=appointments" class="card-link" style="font-size: 0.9rem;">View All Appointments <i class="bi bi-arrow-right"></i></a>
                                </div>
                            </div>
                            
                            <!-- Verification Banner -->
                            <c:choose>
                                <c:when test="${doctor.verificationStatus == 'VERIFIED'}">
                                    <div class="verify-banner verified">
                                        <div class="verify-info">
                                            <h4><i class="bi bi-patch-check-fill"></i> Verified Doctor</h4>
                                            <p>Your medical credentials have been verified successfully.</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <div class="verify-banner" style="background: #F8FAFC; border-color: var(--border);">
                                        <div class="verify-info">
                                            <h4 style="color: var(--text-muted);"><i class="bi bi-hourglass-split"></i> Under Review</h4>
                                            <p>Your profile is currently under review by the admin team.</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="verify-banner">
                                        <div class="verify-info">
                                            <h4><i class="bi bi-shield-exclamation"></i> Action Required</h4>
                                            <p>Please upload your Medical Council Registration Certificate to complete your verification.</p>
                                        </div>
                                                                                <form action="${pageContext.request.contextPath}/doctors/upload-certificate" method="post" enctype="multipart/form-data" style="display:inline;">
                                            <input type="file" id="certUpload" name="certificate" style="display:none;" onchange="this.form.submit()" accept="image/*,.pdf">
                                            <button type="button" class="btn-add" onclick="document.getElementById('certUpload').click();" style="background:#F43F5E; border:none; color:white;">Upload Now</button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Right Column -->
                        <div class="col-right">
                            <!-- Profile Completion Card -->
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="card" style="text-decoration: none; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; display: block; margin-bottom: 24px;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 10px 25px rgba(0,0,0,0.05)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px -1px rgba(0, 0, 0, 0.02)';">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <div class="card-title" style="margin-bottom: 0;">Profile Status</div>
                                    <i class="bi bi-pencil-square" style="color: var(--primary); font-size: 1.1rem;"></i>
                                </div>
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                                    <div style="flex: 1; height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
                                        <div style="height: 100%; background: #16A34A; width: ${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%; border-radius: 4px;"></div>
                                    </div>
                                    <div style="font-weight: 800; color: #16A34A; font-size: 0.95rem;">${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%</div>
                                </div>
                                <p style="margin: 0; font-size: 0.8rem; color: var(--text-muted); font-weight: 500;">
                                    <c:choose>
                                        <c:when test="${doctor.profileCompletionPct == 100}">Your profile is 100% completed. Click to edit.</c:when>
                                        <c:otherwise>Your profile is incomplete. Click to finish setup.</c:otherwise>
                                    </c:choose>
                                </p>
                            </a>

                            <!-- Chart Card -->
                            <div class="card">
                                <div class="card-title" style="margin-bottom: 20px;">Today's Overview</div>
                                <div style="display: flex; align-items: center; justify-content: space-between; gap: 20px;">
                                    <div style="width: 120px; height: 120px; position: relative;">
                                        <canvas id="overviewChart"></canvas>
                                        <div style="position: absolute; top:0; left:0; right:0; bottom:0; display:flex; flex-direction:column; align-items:center; justify-content:center; font-weight:800; color:var(--text-main); font-size:1.2rem;">
                                            ${todayTotal}<span style="font-size: 0.7rem; font-weight: 600; color:var(--text-muted); display:block;">Total</span>
                                        </div>
                                    </div>
                                    <div style="flex: 1; font-size: 0.85rem; font-weight: 600; display: flex; flex-direction: column; gap: 12px;">
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: var(--primary); font-size: 0.6rem; margin-right:6px;"></i> Upcoming</span> <span>${upcomingCount}</span></div>
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: #10B981; font-size: 0.6rem; margin-right:6px;"></i> Completed</span> <span>${completedCount}</span></div>
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: #EF4444; font-size: 0.6rem; margin-right:6px;"></i> Cancelled</span> <span>${cancelledCount}</span></div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Quick Actions -->
                            <div class="card">
                                <div class="card-title" style="margin-bottom: 16px;">Quick Actions</div>
                                <div class="quick-actions-grid">
                                    <a href="#" class="q-action-btn"><i class="bi bi-person-plus"></i> Add Patient</a>
                                    <a href="?section=prescriptions" class="q-action-btn"><i class="bi bi-journal-medical"></i> New Prescription</a>
                                    <a href="?section=consultations" class="q-action-btn"><i class="bi bi-camera-video"></i> Video Consultation</a>
                                    <a href="?section=patients" class="q-action-btn"><i class="bi bi-file-earmark-medical"></i> Patient Reports</a>
                                </div>
                            </div>

                            <!-- Reminders -->
                            <div class="card">
                                <div class="card-header" style="margin-bottom: 16px;">
                                    <div class="card-title"><i class="bi bi-bell"></i> Upcoming Reminders</div>
                                    <a href="#" class="card-link">View All</a>
                                </div>
                                
                                <div class="reminder-item">
                                    <div class="reminder-icon"><i class="bi bi-calendar2-check"></i></div>
                                    <div class="reminder-content">
                                        <h4>Team Meeting</h4>
                                        <p>Today, 4:30 PM</p>
                                    </div>
                                    <span class="badge" style="background: var(--primary-light); color: var(--primary);">In 2 hrs</span>
                                </div>
                                
                                <!-- Add dynamic reminders here later -->
                            </div>
                        </div>
                    </div>

                    <script>
                        const ctx = document.getElementById('overviewChart').getContext('2d');
                        new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Upcoming', 'Completed', 'Cancelled'],
                                datasets: [{
                                    data: [${upcomingCount}, ${completedCount}, ${cancelledCount}],
                                    backgroundColor: ['#F43F5E', '#10B981', '#EF4444'],
                                    borderWidth: 0,
                                    cutout: '75%'
                                }]
                            },
                            options: { plugins: { legend: { display: false }, tooltip: { enabled: false } }, responsive: true, maintainAspectRatio: false }
                        });
                    </script>
                </c:when>

                                <%-- ======================= OTHER MODULES ======================= --%>
                <c:when test="${section == 'patients'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-people" style="color:var(--primary)"></i> Patients</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty patients}">
                                    <p>No patients found.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="p" items="${patients}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="font-weight:700; color:#1E1B4B; margin-bottom:4px;">${p.fullName}</div>
                                                <div style="color:#64748B; font-size:14px;">${p.email} | ${p.mobileNumber}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'consultations'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-chat-dots" style="color:var(--primary)"></i> Completed Consultations</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty consultations}">
                                    <p>No completed consultations yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="c" items="${consultations}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                                                    <strong style="color:#1E1B4B;">${c.user.fullName}</strong>
                                                    <span style="font-size:14px; color:#64748B;">${c.appointmentTime.toLocalDate()}</span>
                                                </div>
                                                <div style="color:#64748B; font-size:14px;">Type: ${c.consultationType} | Status: ${c.status}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'prescriptions'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-file-medical" style="color:var(--primary)"></i> Prescriptions</h3>
                        </div>
                        <div class="card-body">
                            <div style="margin-bottom:24px; padding:16px; background:#f8fafc; border-radius:12px;">
                                <h4>Add New Prescription</h4>
                                <form action="${pageContext.request.contextPath}/doctors/appointments/addPrescription" method="post" style="display:flex; gap:12px; align-items:flex-start;">
                                    <select name="id" required style="padding:10px; border:1px solid #cbd5e1; border-radius:8px; width:200px;">
                                        <option value="">Select Appointment...</option>
                                        <c:forEach var="a" items="${appointmentsForPrescription}">
                                            <option value="${a.id}">${a.user.fullName} - ${a.appointmentTime.toLocalDate()}</option>
                                        </c:forEach>
                                    </select>
                                    <textarea name="prescriptionText" required placeholder="Type prescription details..." style="flex:1; padding:10px; border:1px solid #cbd5e1; border-radius:8px; min-height:80px;"></textarea>
                                    <button type="submit" class="btn-primary" style="padding:10px 20px; border:none; border-radius:8px; cursor:pointer;">Save</button>
                                </form>
                            </div>
                            
                            <h4>Existing Prescriptions</h4>
                            <c:choose>
                                <c:when test="${empty prescriptions}">
                                    <p>No prescriptions issued yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${prescriptions}">
                                        <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                            <div style="font-weight:700; color:#1E1B4B; margin-bottom:8px;">Patient: ${p.user.fullName} <span style="font-size:12px; color:#64748B; font-weight:normal; margin-left:8px;">(Appt: ${p.appointmentTime.toLocalDate()})</span></div>
                                            <div style="padding:12px; background:#f8fafc; border-radius:8px; font-size:14px; white-space:pre-wrap;">${p.prescriptionText}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'earnings'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-wallet2" style="color:var(--primary)"></i> Earnings</h3>
                        </div>
                        <div class="card-body">
                            <div style="padding:24px; background:linear-gradient(135deg, #4f46e5, #3b82f6); color:white; border-radius:16px; margin-bottom:24px;">
                                <div style="font-size:14px; opacity:0.9;">Total Earnings</div>
                                <div style="font-size:36px; font-weight:800; margin-top:8px;">&#8377;${totalEarnings}</div>
                            </div>
                            
                            <h4>Completed Transactions</h4>
                            <c:choose>
                                <c:when test="${empty paidAppointments}">
                                    <p>No transactions yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <table style="width:100%; border-collapse:collapse; margin-top:16px;">
                                        <thead>
                                            <tr style="text-align:left; border-bottom:2px solid #e2e8f0;">
                                                <th style="padding:12px;">Date</th>
                                                <th style="padding:12px;">Patient</th>
                                                <th style="padding:12px;">Amount</th>
                                                <th style="padding:12px;">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="a" items="${paidAppointments}">
                                                <tr style="border-bottom:1px solid #f1f5f9;">
                                                    <td style="padding:12px;">${a.appointmentTime.toLocalDate()}</td>
                                                    <td style="padding:12px; font-weight:600;">${a.user.fullName}</td>
                                                    <td style="padding:12px; font-weight:700; color:#10b981;">&#8377;${doctor.consultationFee}</td>
                                                    <td style="padding:12px;"><span style="padding:4px 8px; background:#dcfce7; color:#166534; border-radius:999px; font-size:12px; font-weight:600;">COMPLETED</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'chat'}">
                    <div class="card" style="height:600px; display:flex; flex-direction:column;">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-chat-text" style="color:var(--primary)"></i> Chat Box</h3>
                        </div>
                        <div class="card-body" style="flex:1; display:flex; padding:0; overflow:hidden;">
                            <div style="width:300px; border-right:1px solid #e2e8f0; overflow-y:auto; padding:16px;">
                                <h4 style="margin-top:0;">Conversations</h4>
                                <c:choose>
                                    <c:when test="${empty chatPatients}">
                                        <p style="color:#64748B; font-size:14px;">No patients to chat with yet.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="p" items="${chatPatients}">
                                            <a href="#" style="display:block; padding:12px; text-decoration:none; color:inherit; border-radius:8px; margin-bottom:8px; background:#f8fafc; border:1px solid transparent;">
                                                <div style="font-weight:600; color:#1E1B4B;">${p.fullName}</div>
                                                <div style="font-size:12px; color:#64748B;">Tap to view messages</div>
                                            </a>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex:1; display:flex; align-items:center; justify-content:center; flex-direction:column; background:#f8fafc;">
                                <i class="bi bi-chat-dots" style="font-size:3rem; color:#cbd5e1; margin-bottom:16px;"></i>
                                <div style="color:#94a3b8; font-weight:500;">Select a conversation to start chatting</div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'reviews'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-star" style="color:var(--primary)"></i> Patient Reviews</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty reviews}">
                                    <p>No reviews yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="r" items="${reviews}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                                                    <strong style="color:#1E1B4B;">${r.user.fullName}</strong>
                                                    <span style="color:#eab308; font-weight:700;"><i class="bi bi-star-fill"></i> ${r.rating} / 5</span>
                                                </div>
                                                <div style="color:#475569; font-size:14px; line-height:1.6;">${r.comment}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'settings'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-gear" style="color:var(--primary)"></i> Settings</h3>
                        </div>
                        <div class="card-body" style="text-align:center; padding:40px;">
                            <i class="bi bi-person-gear" style="font-size:4rem; color:#cbd5e1; margin-bottom:20px;"></i>
                            <h3>Profile Settings</h3>
                            <p style="color:#64748B; max-width:400px; margin:0 auto 24px auto;">To edit your public profile, upload new certificates, or modify your personal details, use the full Profile Completion page.</p>
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-primary" style="text-decoration:none; padding:12px 24px; border-radius:8px; font-weight:600;">Edit Profile</a>
                        </div>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <div class="card">
                        <div class="card-header">
                            <h3 style="text-transform: capitalize; margin:0;"><i class="bi bi-app-indicator" style="color:var(--primary)"></i>  Module</h3>
                        </div>
                        <div class="card-body">
                            <p>This module is currently being built.</p>
                        </div>
                    </div>
                </c:otherwise>

            </c:choose>
        </div>
            </c:otherwise>
        </c:choose>
    </main>

</body>
</html>










