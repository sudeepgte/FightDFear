<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Safety | Lawyer Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            --navy: #0F172A;
            --border: #E2E8F0;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--navy); display: flex; min-height: 100vh; overflow-x: hidden; }

        /* Sidebar */
        .sidebar { width: 250px; background: var(--card-bg); border-right: 1px solid var(--border); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; }
        .brand { padding: 24px; font-size: 1.25rem; font-weight: 800; color: var(--primary); display: flex; align-items: center; gap: 10px; border-bottom: 1px solid var(--border); }
        .brand span { color: var(--navy); display: block; font-size: 0.8rem; font-weight: 500; }
        
        .nav-items { flex: 1; padding: 20px 14px; display: flex; flex-direction: column; gap: 6px; }
        .nav-item { padding: 12px 16px; border-radius: 10px; cursor: pointer; display: flex; align-items: center; gap: 14px; font-weight: 600; color: var(--secondary); transition: all 0.2s ease; }
        .nav-item:hover { background: var(--bg); color: var(--navy); }
        .nav-item.active { background: rgba(244, 63, 94, 0.1); color: var(--primary); }
        .nav-item i { font-size: 1.2rem; }

        .logout-btn { margin: 20px 14px; padding: 12px 16px; border-radius: 10px; cursor: pointer; display: flex; align-items: center; gap: 14px; font-weight: 600; color: var(--secondary); text-decoration: none; transition: 0.2s; }
        .logout-btn:hover { background: var(--error-bg); color: var(--error-text); }

        /* Main Content */
        .main-content { margin-left: 250px; flex: 1; display: flex; flex-direction: column; }
        
        /* Header */
        .top-header { background: var(--card-bg); border-bottom: 1px solid var(--border); padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; }
        .menu-toggle { display: none; font-size: 1.5rem; color: var(--secondary); cursor: pointer; }
        .header-right { display: flex; align-items: center; gap: 20px; }
        .notify-btn { font-size: 1.25rem; color: var(--secondary); position: relative; cursor: pointer; }
        .notify-dot { position: absolute; top: 0; right: 0; width: 8px; height: 8px; background: var(--primary); border-radius: 50%; }
        .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; background: var(--bg); }
        .user-info h4 { font-size: 0.9rem; font-weight: 700; color: var(--navy); }
        .user-info span { font-size: 0.75rem; color: var(--secondary); }

        .content-area { padding: 30px; }
        
        /* Tabs */
        .tab-section { display: none; animation: fadeIn 0.3s ease forwards; }
        .tab-section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Welcome Bar */
        .welcome-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .welcome-text h1 { font-size: 1.75rem; font-weight: 800; color: var(--navy); margin-bottom: 6px; display: flex; align-items: center; gap: 8px; }
        .welcome-text h1 span.name { color: var(--primary); }
        .welcome-text h1 i { color: var(--success-text); font-size: 1.25rem; }
        .welcome-text p { color: var(--secondary); font-size: 0.95rem; }
        
        .btn-primary { background: var(--primary); color: white; padding: 12px 24px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; font-size: 0.9rem; text-decoration: none;}
        .btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--card-bg); border-radius: 16px; padding: 24px; border: 1px solid var(--border); display: flex; align-items: center; gap: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); cursor: pointer; transition: 0.2s; }
        .stat-card:hover { border-color: var(--primary); transform: translateY(-2px); }
        .stat-icon { width: 56px; height: 56px; border-radius: 50%; background: #FFF1F2; color: var(--primary); display: flex; justify-content: center; align-items: center; font-size: 1.5rem; flex-shrink: 0; }
        .stat-info h2 { font-size: 1.75rem; font-weight: 800; color: var(--navy); margin-bottom: 2px; }
        .stat-info p { font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 2px; }
        .stat-info span { font-size: 0.75rem; color: var(--secondary); }
        
        .card { background: var(--card-bg); border-radius: 16px; padding: 24px; border: 1px solid var(--border); box-shadow: 0 4px 10px rgba(0,0,0,0.02); margin-bottom: 30px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-header h3 { font-size: 1.15rem; font-weight: 700; color: var(--navy); display: flex; align-items: center; gap: 10px; }
        .card-header h3 i { color: var(--primary); }
        .card-header a { font-size: 0.85rem; font-weight: 600; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 4px; }
        .card-header a:hover { text-decoration: underline; }

        /* Appointment List */
        .apt-list { display: flex; flex-direction: column; gap: 16px; }
        .apt-item { display: flex; align-items: center; gap: 20px; padding-bottom: 16px; border-bottom: 1px solid var(--border); }
        .apt-item:last-child { border-bottom: none; padding-bottom: 0; }
        .apt-date { display: flex; flex-direction: column; align-items: center; min-width: 60px; padding-right: 20px; border-right: 1px solid var(--border); }
        .apt-date .day { font-size: 1.25rem; font-weight: 800; color: var(--navy); }
        .apt-date .month { font-size: 0.8rem; font-weight: 600; color: var(--secondary); text-transform: uppercase; }
        .apt-info { flex: 1; }
        .apt-info h4 { font-size: 0.95rem; font-weight: 700; color: var(--navy); margin-bottom: 4px; }
        .apt-info p { font-size: 0.8rem; color: var(--secondary); display: flex; align-items: center; gap: 14px; }
        .apt-info p i { font-size: 0.9rem; }
        .badge { padding: 4px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        .badge-upcoming { background: var(--warning-bg); color: var(--warning-text); }
        .badge-confirmed { background: var(--success-bg); color: var(--success-text); }
        .badge-cancelled { background: var(--error-bg); color: var(--error-text); }

        /* Action Banner */
        .action-banner { background: var(--warning-bg); border: 1px solid #fed7aa; border-radius: 16px; padding: 20px 24px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 30px; }
        .action-banner.success { background: var(--success-bg); border-color: #bbf7d0; }
        .action-banner.error { background: var(--error-bg); border-color: #fecdd3; }
        .action-icon { width: 48px; height: 48px; border-radius: 50%; background: #ffedd5; color: var(--warning-text); display: flex; justify-content: center; align-items: center; font-size: 1.5rem; flex-shrink: 0; }
        .action-banner.success .action-icon { background: #dcfce7; color: var(--success-text); }
        .action-banner.error .action-icon { background: #ffe4e6; color: var(--error-text); }
        .action-content { flex: 1; margin-left: 16px; }
        .action-content h3 { font-size: 1rem; font-weight: 700; color: var(--warning-text); margin-bottom: 4px; }
        .action-banner.success .action-content h3 { color: var(--success-text); }
        .action-banner.error .action-content h3 { color: var(--error-text); }
        .action-content p { font-size: 0.85rem; color: var(--navy); }
        .btn-upload { background: var(--primary); color: white; padding: 10px 20px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s; text-decoration: none;}
        .btn-upload:hover { background: var(--primary-hover); }

        /* Modal */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); z-index: 1000; align-items: center; justify-content: center; }
        .modal.active { display: flex; }
        .modal-content { background: var(--card-bg); width: 100%; max-width: 500px; border-radius: 16px; padding: 24px; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h3 { font-size: 1.25rem; font-weight: 700; }
        .close-modal { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--secondary); }
        
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 6px; }
        .form-input { width: 100%; padding: 10px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; }
        .form-input:focus { outline: none; border-color: var(--primary); }

        /* Simple Table for other tabs */
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { padding: 14px 16px; text-align: left; border-bottom: 1px solid var(--border); font-size: 0.9rem; }
        .table th { font-weight: 600; color: var(--secondary); background: var(--bg); }
        .table td { color: var(--navy); font-weight: 500; }
        .table tr:last-child td { border-bottom: none; }

        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
            .menu-toggle { display: block; }
            .stats-grid { grid-template-columns: 1fr; }
            .welcome-bar { flex-direction: column; align-items: flex-start; gap: 16px; }
            .action-banner { flex-direction: column; text-align: center; gap: 16px; }
            .action-content { margin-left: 0; }
        }
    </style>
</head>
<body>

    <c:set var="isVerified" value="${lawyer.verificationStatus == 'VERIFIED'}" />
    
    <c:set var="activeCasesCount" value="0" />
    <c:set var="upcomingAptCount" value="0" />
    <c:set var="consultsCount" value="0" />
    <c:set var="earnings" value="0.0" />
    
    <c:forEach var="b" items="${bookings}">
        <c:if test="${b.status == 'PENDING' || b.status == 'CONFIRMED' || b.status == 'PAID'}">
            <c:set var="activeCasesCount" value="${activeCasesCount + 1}" />
        </c:if>
        <c:if test="${b.status == 'CONFIRMED' || b.status == 'PAID'}">
            <c:set var="upcomingAptCount" value="${upcomingAptCount + 1}" />
        </c:if>
        <c:if test="${b.status == 'COMPLETED'}">
            <c:set var="consultsCount" value="${consultsCount + 1}" />
            <c:set var="earnings" value="${earnings + b.totalAmount}" />
        </c:if>
    </c:forEach>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">
            <i class="bi bi-shield-check"></i>
            <div>
                Women Safety
                <span>Legal Support</span>
            </div>
        </div>
        <div class="nav-items">
            <div class="nav-item active" onclick="switchTab('dashboard', this)">
                <i class="bi bi-house"></i> Dashboard
            </div>
            <div class="nav-item" onclick="switchTab('cases', this)">
                <i class="bi bi-briefcase"></i> My Cases
            </div>
            <div class="nav-item" onclick="switchTab('appointments', this)">
                <i class="bi bi-calendar-event"></i> Appointments
            </div>
            <div class="nav-item" onclick="switchTab('consultations', this)">
                <i class="bi bi-chat-left-dots"></i> Consultations
            </div>
            <div class="nav-item" onclick="switchTab('earnings', this)">
                <i class="bi bi-wallet2"></i> Earnings
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" onclick="return confirm('Are you sure you want to logout?');">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <header class="top-header">
            <i class="bi bi-list menu-toggle" onclick="toggleSidebar()"></i>
            <div style="flex: 1"></div>
            <div class="header-right">
                <div class="notify-btn">
                    <i class="bi bi-bell"></i>
                    <div class="notify-dot"></div>
                </div>
                <div class="user-profile">
                    <c:choose>
                        <c:when test="${not empty lawyer.profilePhoto}">
                            <img src="${pageContext.request.contextPath}/uploads/${lawyer.profilePhoto}" class="user-avatar" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="user-avatar" style="display:flex; justify-content:center; align-items:center; background:#FFE4E6; color:var(--primary); font-weight:700;">
                                ${fn:substring(lawyer.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="user-info">
                        <h4>${lawyer.fullName}</h4>
                        <span>Women Lawyer <i class="bi bi-chevron-down"></i></span>
                    </div>
                </div>
            </div>
        </header>

        <div class="content-area">
            
            <c:if test="${not empty message}">
                <div class="action-banner success" style="margin-bottom: 20px; padding: 12px 20px;">
                    <div style="display:flex; align-items:center; gap: 10px;">
                        <i class="bi bi-check-circle-fill" style="color:var(--success-text);"></i>
                        <span style="color:var(--success-text); font-weight:600;">${message}</span>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="action-banner error" style="margin-bottom: 20px; padding: 12px 20px;">
                    <div style="display:flex; align-items:center; gap: 10px;">
                        <i class="bi bi-exclamation-triangle-fill" style="color:var(--error-text);"></i>
                        <span style="color:var(--error-text); font-weight:600;">${error}</span>
                    </div>
                </div>
            </c:if>

            <!-- Dashboard Tab -->
            <div id="dashboard-tab" class="tab-section active">
                
                <div class="welcome-bar">
                    <div class="welcome-text">
                        <h1>Welcome back, <span class="name">${lawyer.fullName}</span> <c:if test="${isVerified}"><i class="bi bi-patch-check-fill"></i></c:if></h1>
                        <p>Here's what's happening with your legal practice today.</p>
                    </div>
                    <button class="btn-primary" onclick="openAvailabilityModal()">
                        <i class="bi bi-plus-lg"></i> Add Availability
                    </button>
                </div>

                <c:if test="${lawyer.profileCompletionPct == null || lawyer.profileCompletionPct < 100}">
                    <div class="action-banner" style="margin-bottom: 30px;">
                        <div class="action-icon"><i class="bi bi-person-lines-fill"></i></div>
                        <div class="action-content">
                            <h3>Complete Your Profile</h3>
                            <p>Your profile is incomplete. Add your practice areas, experience, and details to get verified faster.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-upload" style="text-decoration:none;">Complete Profile</a>
                    </div>
                </c:if>

                <div class="stats-grid">
                    <div class="stat-card" onclick="switchTab('cases', document.querySelectorAll('.nav-item')[1])">
                        <div class="stat-icon"><i class="bi bi-briefcase"></i></div>
                        <div class="stat-info">
                            <h2>${activeCasesCount}</h2>
                            <p>Active Cases</p>
                            <span>Ongoing legal matters</span>
                        </div>
                    </div>
                    <div class="stat-card" onclick="switchTab('appointments', document.querySelectorAll('.nav-item')[2])">
                        <div class="stat-icon" style="background:#FFE4E6;"><i class="bi bi-calendar-check"></i></div>
                        <div class="stat-info">
                            <h2>${upcomingAptCount}</h2>
                            <p>Upcoming Appointments</p>
                            <span>Next 7 days</span>
                        </div>
                    </div>
                    <div class="stat-card" onclick="switchTab('consultations', document.querySelectorAll('.nav-item')[3])">
                        <div class="stat-icon" style="background:#FFE4E6;"><i class="bi bi-chat-dots"></i></div>
                        <div class="stat-info">
                            <h2>${consultsCount}</h2>
                            <p>Consultations</p>
                            <span>This month</span>
                        </div>
                    </div>
                    <div class="stat-card" onclick="switchTab('earnings', document.querySelectorAll('.nav-item')[4])">
                        <div class="stat-icon" style="background:#FFE4E6;"><i class="bi bi-cash-stack"></i></div>
                        <div class="stat-info">
                            <h2>₹<fmt:formatNumber type="number" maxFractionDigits="0" value="${earnings}" /></h2>
                            <p>Earnings</p>
                            <span>This month</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-calendar4-week"></i> Upcoming Appointments</h3>
                        <a href="javascript:void(0)" onclick="switchTab('appointments', document.querySelectorAll('.nav-item')[2])">View All <i class="bi bi-chevron-right"></i></a>
                    </div>
                    <div class="apt-list">
                        <c:set var="hasUpcoming" value="false" />
                        <c:forEach var="b" items="${bookings}" end="3">
                            <c:if test="${b.status == 'PENDING' || b.status == 'CONFIRMED' || b.status == 'PAID'}">
                                <c:set var="hasUpcoming" value="true" />
                                <div class="apt-item">
                                    <div class="apt-date">
                                        <fmt:parseDate value="${b.requestedTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <span class="day"><fmt:formatDate pattern="dd" value="${parsedDate}" /></span>
                                        <span class="month"><fmt:formatDate pattern="MMM" value="${parsedDate}" /></span>
                                    </div>
                                    <div class="apt-info">
                                        <h4>${not empty b.user ? b.user.fullName : 'Client Consultation'} <span style="font-size:0.8rem; color:var(--secondary);">#${b.id}</span></h4>
                                        <p>
                                            <span><fmt:formatDate pattern="hh:mm a" value="${parsedDate}" /></span>
                                            <span><i class="bi bi-camera-video"></i> ${not empty lawyer.serviceMode ? lawyer.serviceMode : 'Video Call'}</span>
                                        </p>
                                    </div>
                                    <div class="badge ${b.status == 'CONFIRMED' || b.status == 'PAID' ? 'badge-confirmed' : 'badge-upcoming'}">
                                        ${b.status == 'PENDING' ? 'Upcoming' : 'Confirmed'}
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasUpcoming}">
                            <p style="color: var(--secondary); font-size: 0.9rem; text-align:center; padding: 20px;">No upcoming appointments.</p>
                        </c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not isVerified}">
                        <div class="action-banner">
                            <div class="action-icon"><i class="bi bi-shield-exclamation"></i></div>
                            <div class="action-content">
                                <h3>Action Required</h3>
                                <p>Please upload your Bar Council ID proof to complete your profile verification.</p>
                            </div>
                            <form id="uploadDocForm" action="${pageContext.request.contextPath}/lawyer/profile/upload-doc" method="post" enctype="multipart/form-data" style="display:none;">
                                <input type="file" id="barCouncilDoc" name="document" accept="image/*,.pdf" onchange="document.getElementById('uploadDocForm').submit();">
                            </form>
                            <button class="btn-upload" onclick="document.getElementById('barCouncilDoc').click();">Upload Now</button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="action-banner success">
                            <div class="action-icon"><i class="bi bi-shield-check"></i></div>
                            <div class="action-content">
                                <h3>Verification Complete</h3>
                                <p>Your profile is fully verified. You can now accept client consultations.</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Cases Tab -->
            <div id="cases-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Cases</h3>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Client Name</th>
                                <th>Case Type</th>
                                <th>Date Requested</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>#${b.id}</td>
                                    <td>${not empty b.user ? b.user.fullName : 'Client'}</td>
                                    <td>Consultation</td>
                                    <td>${fn:substring(b.requestedTime, 0, 10)}</td>
                                    <td><span class="badge ${b.status == 'COMPLETED' ? 'badge-confirmed' : 'badge-upcoming'}">${b.status}</span></td>
                                    <td>
                                        <c:if test="${b.status != 'COMPLETED'}">
                                            <button class="btn-upload" style="padding: 6px 12px; font-size: 0.8rem;" onclick="updateStatus(${b.id}, 'COMPLETED')">Close Case</button>
                                        </c:if>
                                        <c:if test="${b.status == 'COMPLETED'}">
                                            <span style="color:var(--secondary); font-size:0.85rem;">Closed</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Appointments Tab -->
            <div id="appointments-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>All Appointments</h3>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date & Time</th>
                                <th>Client</th>
                                <th>Mode</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>#${b.id}</td>
                                    <td>${fn:replace(b.requestedTime, 'T', ' ')}</td>
                                    <td>#${b.id}</td>
                                    <td>${not empty b.user ? b.user.fullName : 'Client'}</td>
                                    <td><i class="bi bi-camera-video"></i> ${not empty lawyer.serviceMode ? lawyer.serviceMode : 'Video Call'}</td>
                                    <td><span class="badge ${b.status == 'CONFIRMED' || b.status == 'PAID' ? 'badge-confirmed' : (b.status == 'PENDING' ? 'badge-upcoming' : 'badge-cancelled')}">${b.status}</span></td>
                                    <td style="display:flex; gap: 8px;">
                                        <c:if test="${b.status == 'PENDING'}">
                                            <button class="btn-upload" style="padding: 6px 12px; font-size: 0.8rem;" onclick="updateStatus(${b.id}, 'PAID')">Accept</button>
                                            <button class="btn-upload" style="padding: 6px 12px; font-size: 0.8rem; background: var(--error-bg); color: var(--error-text);" onclick="updateStatus(${b.id}, 'CANCELLED')">Reject</button>
                                        </c:if>
                                        <c:if test="${b.status == 'PAID' || b.status == 'CONFIRMED'}">
                                            <button class="btn-upload" style="padding: 6px 12px; font-size: 0.8rem; background: var(--success-bg); color: var(--success-text);" onclick="updateStatus(${b.id}, 'COMPLETED')">Mark Done</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Consultations Tab -->
            <div id="consultations-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>Consultations History</h3>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Client Notes</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>${fn:substring(b.requestedTime, 0, 10)}</td>
                                    <td>₹${b.totalAmount}</td>
                                    <td>${not empty b.note ? b.note : '-'}</td>
                                    <td><span class="badge ${b.status == 'COMPLETED' ? 'badge-confirmed' : 'badge-upcoming'}">${b.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Earnings Tab -->
            <div id="earnings-tab" class="tab-section">
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dcfce7; color:var(--success-text);"><i class="bi bi-wallet2"></i></div>
                        <div class="stat-info">
                            <h2>₹<fmt:formatNumber type="number" maxFractionDigits="0" value="${earnings}" /></h2>
                            <p>Total Earnings</p>
                            <span>Lifetime</span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fef3c7; color:var(--warning-text);"><i class="bi bi-clock-history"></i></div>
                        <div class="stat-info">
                            <h2>₹<fmt:formatNumber type="number" maxFractionDigits="0" value="${lawyer.payoutBalance != null ? lawyer.payoutBalance : 0}" /></h2>
                            <p>Pending Payout</p>
                            <span>To be processed</span>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3>Earnings History</h3>
                    </div>
                    <p style="color:var(--secondary); font-size:0.9rem;">Details of completed consultations and generated revenue.</p>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Availability Modal -->
    <div class="modal" id="availabilityModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add Availability</h3>
                <button class="close-modal" onclick="closeAvailabilityModal()"><i class="bi bi-x"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/lawyer/profile/update" method="post">
                <input type="hidden" name="fullName" value="${lawyer.fullName}">
                <input type="hidden" name="phone" value="${lawyer.phone}">
                <div class="form-group">
                    <label class="form-label">Available Days</label>
                    <input type="text" name="openDays" class="form-input" placeholder="e.g. Mon - Fri" value="${lawyer.openDays}">
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">From Time</label>
                        <input type="time" name="openTime" class="form-input" value="${lawyer.openTime}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">To Time</label>
                        <input type="time" name="closeTime" class="form-input" value="${lawyer.closeTime}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Consultation Type</label>
                    <select name="serviceMode" class="form-input">
                        <option value="Online" ${lawyer.serviceMode == 'Online' ? 'selected' : ''}>Video Call / Online</option>
                        <option value="Offline" ${lawyer.serviceMode == 'Offline' ? 'selected' : ''}>In-person</option>
                    </select>
                </div>
                <button type="submit" class="btn-primary" style="width: 100%; justify-content: center; margin-top: 10px;">Save Availability</button>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabId, el) {
            document.querySelectorAll('.tab-section').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            
            document.getElementById(tabId + '-tab').classList.add('active');
            if (el) el.classList.add('active');
            
            if(window.innerWidth <= 768) {
                document.querySelector('.sidebar').style.transform = 'translateX(-100%)';
            }
        }
        
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            if(sidebar.style.transform === 'translateX(0px)') {
                sidebar.style.transform = 'translateX(-100%)';
            } else {
                sidebar.style.transform = 'translateX(0px)';
            }
        }

        function openAvailabilityModal() {
            document.getElementById('availabilityModal').classList.add('active');
        }

        function closeAvailabilityModal() {
            document.getElementById('availabilityModal').classList.remove('active');
        }

        function updateStatus(id, newStatus) {
            if(!confirm("Are you sure you want to change the status to " + newStatus + "?")) return;
            
            const formData = new FormData();
            formData.append('status', newStatus);

            fetch('${pageContext.request.contextPath}/lawyer/bookings/' + id + '/status', {
                method: 'POST',
                body: formData
            }).then(r => r.json()).then(data => {
                if(data.success) {
                    location.reload();
                } else {
                    alert("Error: " + data.message);
                }
            }).catch(e => alert("Failed to update status"));
        }
    </script>
</body>
</html>






