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
            --navy: #1E1B4B;
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
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; margin-bottom: 30px; }
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

        /* Profile Grid */
        .profile-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; margin-top: 24px; }
        .profile-card { background: var(--card-bg); border-radius: 12px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); border: 1px solid var(--border); }
        .profile-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .profile-card-header h3 { font-size: 1.05rem; font-weight: 700; color: var(--navy); display: flex; align-items: center; gap: 8px; }
        .profile-card-header h3 i { color: var(--primary); }
        .btn-edit-link { color: var(--primary); font-size: 0.85rem; font-weight: 600; text-decoration: none; }
        .btn-edit-link:hover { text-decoration: underline; }
        .profile-field { margin-bottom: 16px; }
        .profile-field:last-child { margin-bottom: 0; }
        .profile-field label { display: block; font-size: 0.75rem; color: var(--secondary); font-weight: 600; margin-bottom: 6px; }
        .profile-field div { font-size: 0.95rem; font-weight: 500; color: var(--navy); }
        .tags-container { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
        .tag { padding: 6px 12px; background: rgba(244, 63, 94, 0.05); color: var(--primary); border-radius: 20px; font-size: 0.8rem; font-weight: 600; border: 1px solid rgba(244, 63, 94, 0.1); }
        
        .profile-header-card { display: flex; align-items: center; gap: 24px; background: var(--card-bg); padding: 30px; border-radius: 16px; border: 1px solid var(--border); margin-bottom: 24px; }
        .profile-header-avatar { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; background: #FFE4E6; display: flex; justify-content: center; align-items: center; font-size: 2.5rem; color: var(--primary); font-weight: 700; }
        .profile-header-info h2 { font-size: 1.5rem; font-weight: 800; color: var(--navy); margin-bottom: 8px; }
        .profile-header-info p { color: var(--secondary); font-size: 0.95rem; margin-bottom: 12px; }
        .profile-header-stats { display: flex; gap: 24px; }
        .profile-header-stat { display: flex; flex-direction: column; }
        .profile-header-stat span { font-size: 0.75rem; color: var(--secondary); font-weight: 600; }
        .profile-header-stat strong { font-size: 0.95rem; color: var(--navy); }

        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }
            .sidebar.show { transform: translateX(0); }
            .main-content { margin-left: 0; width: 100%; }
            .menu-toggle { display: block; }
            .stats-grid { grid-template-columns: 1fr; }
            .welcome-bar { flex-direction: column; align-items: flex-start; gap: 16px; }
            .action-banner { flex-direction: column; text-align: center; gap: 16px; }
            .action-content { margin-left: 0; }
            .profile-header-card { flex-direction: column; text-align: center; }
            .profile-header-stats { flex-wrap: wrap; justify-content: center; }
        }
        
        /* ==========================================
           WOMEN LAWYER MOBILE RESPONSIVE
           ========================================== */
        @media (max-width: 480px) {
            body { overflow-x: hidden; width: 100%; }
            .main-content { width: 100vw; overflow-x: hidden; }
            .content-area { padding: 16px; overflow-x: hidden; width: 100%; }
            .card { padding: 16px; width: 100%; }
            .stats-grid { gap: 12px; }
            .stat-card { padding: 16px; flex-direction: column; text-align: center; }
            .apt-item { flex-direction: column; text-align: center; }
            .apt-info { width: 100%; }
            .table-responsive { overflow-x: auto; width: 100%; -webkit-overflow-scrolling: touch; }
            table { width: 100%; min-width: 500px; }
            .welcome-text h1 { font-size: 1.4rem; flex-wrap: wrap; }
            .btn-primary { padding: 10px 16px; font-size: 0.85rem; width: 100%; justify-content: center; }
            .card-header { flex-direction: column; align-items: flex-start; gap: 10px; }
            .top-header { padding: 12px 16px; }
            .profile-header-card { padding: 16px; }
            .profile-card { padding: 16px; }
            input, select, textarea { max-width: 100%; }
            .modal-content { width: 95%; margin: 10px auto; }
        }
    </style>
</head>
<body>

    <c:set var="isVerified" value="${lawyer.verificationStatus == 'VERIFIED'}" />
    
    <c:set var="activeCasesCount" value="0" />
    <c:set var="upcomingAptCount" value="0" />
    <c:set var="consultsCount" value="0" />
    <c:set var="pendingReqCount" value="0" />
    <c:set var="earnings" value="0.0" />
    
    <c:forEach var="b" items="${bookings}">
        <c:if test="${b.status == 'PENDING'}">
            <c:set var="pendingReqCount" value="${pendingReqCount + 1}" />
        </c:if>
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
        <div class="brand" style="padding: 16px 24px;">
            <a href="${pageContext.request.contextPath}/" style="text-decoration:none; display: flex; align-items: center; gap: 10px;">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="FightDFear Logo" style="height:45px; width:auto; filter:drop-shadow(0 2px 8px rgba(243, 63, 94, 0.15));">
                <span style="font-size: 1.25rem; font-weight: 800; color: #1a1a2e; margin: 0; padding: 0;">Fight D Fear</span>
            </a>
        </div>
        <div class="nav-items" style="overflow-y: auto; overflow-x: hidden;">
            <div class="nav-item active" onclick="switchTab('dashboard', this)">
                <i class="bi bi-grid"></i> Dashboard
            </div>
            <div class="nav-item" onclick="switchTab('profile', this)">
                <i class="bi bi-person"></i> My Profile
            </div>
            <c:if test="${lawyer.partnerProfileStatus == 'APPROVED'}">
                <div class="nav-item" onclick="switchTab('appointments', this)">
                    <i class="bi bi-calendar-event"></i> Appointments
                </div>
                <div class="nav-item" onclick="switchTab('consultations', this)">
                    <i class="bi bi-chat-dots"></i> Consultations
                </div>
                <div class="nav-item" onclick="switchTab('clients', this)">
                    <i class="bi bi-people"></i> My Clients
                </div>
                <div class="nav-item" onclick="switchTab('earnings', this)">
                    <i class="bi bi-wallet2"></i> Earnings
                </div>
                <div class="nav-item" onclick="switchTab('reviews', this)">
                    <i class="bi bi-star"></i> Reviews
                </div>
                <div class="nav-item" onclick="switchTab('documents', this)">
                    <i class="bi bi-file-earmark-text"></i> Documents
                </div>
                <div class="nav-item" onclick="switchTab('availability', this)">
                    <i class="bi bi-clock"></i> Availability
                </div>
                <div class="nav-item" onclick="switchTab('gallery', this)">
                    <i class="bi bi-images"></i> Gallery
                </div>
                <div class="nav-item" onclick="switchTab('bank', this)">
                    <i class="bi bi-bank"></i> Bank & Payments
                </div>
                <div class="nav-item" onclick="switchTab('settings', this)">
                    <i class="bi bi-gear"></i> Settings
                </div>
            </c:if>
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
                <div class="notify-btn" onclick="switchTab('appointments')">
                    <i class="bi bi-bell"></i>
                    <c:if test="${pendingReqCount > 0}">
                        <span style="position: absolute; top: -5px; right: -8px; background: var(--primary); color: white; font-size: 0.6rem; padding: 2px 5px; border-radius: 10px; font-weight: 700;">${pendingReqCount}</span>
                    </c:if>
                </div>
                <div class="user-profile">
                    <c:choose>
                        <c:when test="${not empty lawyer.profilePhoto}">
                            <c:set var="pUrl" value="${lawyer.profilePhoto}" />
                            <c:choose>
                                <c:when test="${fn:startsWith(pUrl, 'http')}"></c:when>
                                <c:when test="${fn:startsWith(pUrl, '/')}"><c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" /></c:when>
                                <c:otherwise><c:set var="pUrl" value="${pageContext.request.contextPath}/uploads/${pUrl}" /></c:otherwise>
                            </c:choose>
                            <img src="${pUrl}" class="user-avatar" alt="Avatar">
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
                    <c:if test="${lawyer.partnerProfileStatus == 'APPROVED'}">
                        <button class="btn-primary" onclick="openAvailabilityModal()">
                            <i class="bi bi-plus-lg"></i> Add Availability
                        </button>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${lawyer.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                        <div class="action-banner" style="margin-bottom: 30px; background: #FFFBEB; border: 1px solid #FDE68A;">
                            <div class="action-icon" style="background: #FEF3C7; color: #D97706;"><i class="bi bi-hourglass-split"></i></div>
                            <div class="action-content">
                                <h3 style="color: #92400E;">Profile Under Admin Review</h3>
                                <p style="color: #B45309;">Your profile is currently being reviewed by our admin team. Please wait for approval.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${lawyer.partnerProfileStatus == 'APPROVED'}">
                        <div class="action-banner" style="margin-bottom: 30px; background: #F0FDF4; border: 1px solid #BBF7D0;">
                            <div class="action-icon" style="background: #DCFCE7; color: #16A34A;"><i class="bi bi-patch-check-fill"></i></div>
                            <div class="action-content">
                                <h3 style="color: #166534;">Profile Approved</h3>
                                <p style="color: #15803D;">Your profile has been approved!</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="action-banner" style="margin-bottom: 30px;">
                            <div class="action-icon"><i class="bi bi-person-lines-fill"></i></div>
                            <div class="action-content">
                                <h3>Complete Your Profile</h3>
                                <p>Your profile is incomplete. Please fill it to 100% and submit it for admin verification.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-upload" style="text-decoration:none;">Update Profile</a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${lawyer.partnerProfileStatus == 'APPROVED'}">
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
                </c:if>
            </div>

            <!-- Profile Tab -->
            <div id="profile-tab" class="tab-section">
                <div class="profile-header-card">
                    <c:choose>
                        <c:when test="${not empty lawyer.profilePhoto}">
                            <c:set var="pUrl" value="${lawyer.profilePhoto}" />
                            <c:choose>
                                <c:when test="${fn:startsWith(pUrl, 'http')}"></c:when>
                                <c:when test="${fn:startsWith(pUrl, '/')}"><c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" /></c:when>
                                <c:otherwise><c:set var="pUrl" value="${pageContext.request.contextPath}/uploads/${pUrl}" /></c:otherwise>
                            </c:choose>
                            <img src="${pUrl}" class="profile-header-avatar" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="profile-header-avatar">
                                ${fn:substring(lawyer.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="profile-header-info">
                        <h2>${empty lawyer.fullName ? 'Advocate Name' : lawyer.fullName} <c:if test="${isVerified}"><i class="bi bi-patch-check-fill" style="color:var(--success-text);"></i></c:if></h2>
                        <p>${empty lawyer.designation ? 'Advocate' : lawyer.designation}</p>
                        <div class="profile-header-stats">
                            <div class="profile-header-stat">
                                <span><i class="bi bi-telephone"></i> Official</span>
                                <strong>${empty lawyer.phone ? 'Not added' : lawyer.phone}</strong>
                            </div>
                            <div class="profile-header-stat">
                                <span><i class="bi bi-whatsapp"></i> WhatsApp</span>
                                <strong>${empty lawyer.whatsappNumber ? 'Not added' : lawyer.whatsappNumber}</strong>
                            </div>
                            <div class="profile-header-stat">
                                <span><i class="bi bi-briefcase"></i> Experience</span>
                                <strong>${empty lawyer.experienceYears ? '0' : lawyer.experienceYears} Years</strong>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="profile-grid">
                    <!-- Professional Info -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-person-vcard"></i> Professional Information</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field"><label>Bar Council ID</label><div>${empty lawyer.barCouncilId ? 'Not added' : lawyer.barCouncilId}</div></div>
                        <div class="profile-field"><label>Chamber Address</label><div>${empty lawyer.address ? 'Not added' : lawyer.address}</div></div>
                        <div class="profile-field"><label>City / State</label><div>${empty lawyer.city ? 'City' : lawyer.city}, ${empty lawyer.state ? 'State' : lawyer.state}</div></div>
                        <div class="profile-field"><label>Pincode</label><div>${empty lawyer.pincode ? 'Not added' : lawyer.pincode}</div></div>
                    </div>

                    <!-- Practice Areas -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-briefcase"></i> Practice Areas</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field">
                            <label>Specializations</label>
                            <div class="tags-container">
                                <c:choose>
                                    <c:when test="${not empty lawyer.practiceAreas}">
                                        <c:forEach var="area" items="${fn:split(lawyer.practiceAreas, ',')}">
                                            <span class="tag">${area.trim()}</span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not added</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="profile-field">
                            <label>Who They Serve</label>
                            <div class="tags-container">
                                <c:choose>
                                    <c:when test="${not empty lawyer.audience}">
                                        <c:forEach var="aud" items="${fn:split(lawyer.audience, ',')}">
                                            <span class="tag">${aud.trim()}</span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not added</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Languages & Facilities -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-translate"></i> Languages & Facilities</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field">
                            <label>Languages Known</label>
                            <div class="tags-container">
                                <c:choose>
                                    <c:when test="${not empty lawyer.languages}">
                                        <c:forEach var="lang" items="${fn:split(lawyer.languages, ',')}">
                                            <span class="tag">${lang.trim()}</span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not added</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="profile-field" style="margin-top:16px;">
                            <label>Chamber Facilities</label>
                            <div class="tags-container" style="gap: 12px;">
                                <c:choose>
                                    <c:when test="${not empty lawyer.facilities}">
                                        <c:forEach var="fac" items="${fn:split(lawyer.facilities, ',')}">
                                            <div style="font-size:0.85rem; color:var(--success-text); display:flex; align-items:center; gap:4px;">
                                                <i class="bi bi-check-circle"></i> ${fac.trim()}
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not added</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Working Hours -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-clock"></i> Working Hours</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field"><label>Operating Days</label><div>${empty lawyer.openDays ? 'Not added' : lawyer.openDays}</div></div>
                        <div class="profile-field"><label>Working Time</label><div>${empty lawyer.openTime ? 'HH:MM' : lawyer.openTime} — ${empty lawyer.closeTime ? 'HH:MM' : lawyer.closeTime}</div></div>
                    </div>
                    
                    <!-- Consultation Details -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-chat-dots"></i> Consultation Details</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field"><label>Consultation Fee</label><div>₹ ${empty lawyer.consultationFee ? '0' : lawyer.consultationFee}</div></div>
                        <div class="profile-field"><label>Service Mode</label><div>${empty lawyer.serviceMode ? 'Not added' : lawyer.serviceMode}</div></div>
                        <div class="profile-field">
                            <label>Consultation Mode</label>
                            <div class="tags-container">
                                <c:choose>
                                    <c:when test="${not empty lawyer.consultationMode}">
                                        <c:forEach var="mode" items="${fn:split(lawyer.consultationMode, ',')}">
                                            <span class="tag">${mode.trim()}</span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not added</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Information -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-cash-stack"></i> Payment Information</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field"><label>UPI ID</label><div>${empty lawyer.upiId ? 'Not added' : lawyer.upiId}</div></div>
                        <div class="profile-field"><label>Bank Details</label><div style="white-space: pre-wrap;">${empty lawyer.bankDetails ? 'Not added' : lawyer.bankDetails}</div></div>
                    </div>

                    <!-- About -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-person-lines-fill"></i> About</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div class="profile-field" style="line-height: 1.6;">${empty lawyer.bio ? 'Not added yet' : lawyer.bio}</div>
                    </div>
                    
                    <!-- Gallery -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-images"></i> Gallery</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div style="display:flex; gap:16px;">
                            <div style="flex:1;">
                                <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Profile Photo</label>
                                <c:choose>
                                    <c:when test="${not empty lawyer.profilePhoto}">
                                        <c:set var="pUrl" value="${lawyer.profilePhoto}" />
                                        <c:choose>
                                            <c:when test="${fn:startsWith(pUrl, 'http')}"></c:when>
                                            <c:when test="${fn:startsWith(pUrl, '/')}"><c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" /></c:when>
                                            <c:otherwise><c:set var="pUrl" value="${pageContext.request.contextPath}/uploads/${pUrl}" /></c:otherwise>
                                        </c:choose>
                                        <img src="${pUrl}" style="width:100%; height:120px; object-fit:cover; border-radius:8px;" alt="Profile Photo">
                                    </c:when>
                                    <c:otherwise><div style="width:100%; height:120px; background:var(--bg); border-radius:8px; display:flex; align-items:center; justify-content:center; color:var(--secondary);">Not added</div></c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex:1;">
                                <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Chamber Photo</label>
                                <c:choose>
                                    <c:when test="${not empty lawyer.galleryPhotos}">
                                        <c:set var="cUrl" value="${lawyer.galleryPhotos}" />
                                        <c:choose>
                                            <c:when test="${fn:startsWith(cUrl, 'http')}"></c:when>
                                            <c:when test="${fn:startsWith(cUrl, '/')}"><c:set var="cUrl" value="${pageContext.request.contextPath}${cUrl}" /></c:when>
                                            <c:otherwise><c:set var="cUrl" value="${pageContext.request.contextPath}/uploads/${cUrl}" /></c:otherwise>
                                        </c:choose>
                                        <img src="${cUrl}" style="width:100%; height:120px; object-fit:cover; border-radius:8px;" alt="Chamber Photo">
                                    </c:when>
                                    <c:otherwise><div style="width:100%; height:120px; background:var(--bg); border-radius:8px; display:flex; align-items:center; justify-content:center; color:var(--secondary);">Not added</div></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Status -->
                    <div class="profile-card">
                        <div class="profile-card-header">
                            <h3><i class="bi bi-shield-check"></i> Profile Status</h3>
                            <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-edit-link">Edit</a>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; padding-bottom:12px; border-bottom:1px solid var(--border);">
                            <div style="display:flex; align-items:center; gap:8px; font-weight:600; font-size:0.9rem; color:var(--navy);"><i class="bi bi-check-circle" style="color:var(--success-text);"></i> Profile Completion</div>
                            <strong style="color:var(--primary); font-size:0.9rem;">${empty lawyer.profileCompletionPct ? 0 : lawyer.profileCompletionPct}%</strong>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; padding-bottom:12px; border-bottom:1px solid var(--border);">
                            <div style="display:flex; align-items:center; gap:8px; font-weight:600; font-size:0.9rem; color:var(--navy);"><i class="bi bi-check-circle" style="color:var(--success-text);"></i> Email Verified</div>
                            <strong style="color:var(--success-text); font-size:0.8rem;">Verified</strong>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; padding-bottom:12px; border-bottom:1px solid var(--border);">
                            <div style="display:flex; align-items:center; gap:8px; font-weight:600; font-size:0.9rem; color:var(--navy);"><i class="bi bi-check-circle" style="color:var(--success-text);"></i> Phone Verified</div>
                            <strong style="color:var(--success-text); font-size:0.8rem;">Verified</strong>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div style="display:flex; align-items:center; gap:8px; font-weight:600; font-size:0.9rem; color:var(--navy);"><c:choose><c:when test="${isVerified}"><i class="bi bi-check-circle" style="color:var(--success-text);"></i></c:when><c:otherwise><i class="bi bi-x-circle" style="color:var(--warning-text);"></i></c:otherwise></c:choose> ID Verified</div>
                            <strong style="${isVerified ? 'color:var(--success-text);' : 'color:var(--warning-text);'} font-size:0.8rem;">${isVerified ? 'Verified' : 'Pending'}</strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Clients Tab -->
            <div id="clients-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Clients</h3>
                    </div>
                    <div class="table-responsive">
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
            </div>

            <!-- Appointments Tab -->
            <div id="appointments-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>All Appointments</h3>
                    </div>
                    <div class="table-responsive">
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
            </div>

            <!-- Consultations Tab -->
            <div id="consultations-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>Consultations History</h3>
                    </div>
                    <div class="table-responsive">
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

            <!-- Reviews Tab -->
            <div id="reviews-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Reviews</h3>
                    </div>
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <p style="color:var(--secondary); font-size:0.9rem;">You do not have any reviews yet.</p>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; flex-direction: column; gap: 15px;">
                                <c:forEach var="rev" items="${reviews}">
                                    <div style="border: 1px solid var(--border); border-radius: 12px; padding: 15px; background: #fff;">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                            <strong style="color: var(--text-main);">${rev.user.fullName}</strong>
                                            <div style="color: #F59E0B; font-size: 0.9rem;">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${rev.rating >= i}"><i class="bi bi-star-fill"></i></c:when>
                                                        <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p style="color: var(--secondary); font-size: 0.9rem; margin: 0;">${rev.comment}</p>
                                        <small style="color: var(--secondary); font-size: 0.75rem;">
                                            ${rev.createdAt.toLocalDate()}
                                        </small>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Documents Tab -->
            <div id="documents-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Documents</h3>
                    </div>
                    <p style="color:var(--secondary); font-size:0.9rem;">Upload and manage your case documents here.</p>
                    <div style="margin-top: 15px; display: grid; grid-template-columns: 1fr; gap: 15px;">
                        <div class="profile-field"><label>Bar Council ID</label><div>${empty lawyer.barCouncilId ? 'Not added' : lawyer.barCouncilId}</div></div>
                    </div>
                </div>
            </div>

            <!-- Availability Tab -->
            <div id="availability-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Availability</h3>
                        <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-primary" style="text-decoration:none; padding:8px 16px; font-size:0.8rem; border-radius:8px; color:#fff !important;">Manage Availability</a>
                    </div>
                    <p style="color:var(--secondary); font-size:0.9rem;">Configure your working hours, break times, and unavailable dates.</p>
                    <div style="margin-top: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div class="profile-field"><label>Operating Days</label><div>${empty lawyer.openDays ? 'Not added' : lawyer.openDays}</div></div>
                        <div class="profile-field"><label>Working Time</label><div>${empty lawyer.openTime ? 'HH:MM' : lawyer.openTime} — ${empty lawyer.closeTime ? 'HH:MM' : lawyer.closeTime}</div></div>
                        <div class="profile-field"><label>Consultation Mode</label><div>${empty lawyer.consultationMode ? 'Not added' : lawyer.consultationMode}</div></div>
                        <div class="profile-field"><label>Service Mode</label><div>${empty lawyer.serviceMode ? 'Not added' : lawyer.serviceMode}</div></div>
                    </div>
                </div>
            </div>

            <!-- Gallery Tab -->
            <div id="gallery-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>My Gallery</h3>
                        <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-primary" style="text-decoration:none; padding:8px 16px; font-size:0.8rem; border-radius:8px; color:#fff !important;">Upload Photos</a>
                    </div>
                    <p style="color:var(--secondary); font-size:0.9rem;">Manage your profile and chamber photos.</p>
                    <div style="margin-top: 15px; display:flex; gap:16px;">
                        <div style="flex:1;">
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Profile Photo</label>
                            <c:choose>
                                <c:when test="${not empty lawyer.profilePhoto}">
                                    <c:set var="pUrl" value="${lawyer.profilePhoto}" />
                                    <c:choose>
                                        <c:when test="${fn:startsWith(pUrl, 'http')}"></c:when>
                                        <c:when test="${fn:startsWith(pUrl, '/')}"><c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" /></c:when>
                                        <c:otherwise><c:set var="pUrl" value="${pageContext.request.contextPath}/uploads/${pUrl}" /></c:otherwise>
                                    </c:choose>
                                    <img src="${pUrl}" style="width:100%; height:120px; object-fit:cover; border-radius:8px;" alt="Profile Photo">
                                </c:when>
                                <c:otherwise><div style="width:100%; height:120px; background:var(--bg); border-radius:8px; display:flex; align-items:center; justify-content:center; color:var(--secondary);">Not added</div></c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex:1;">
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Chamber Photo</label>
                            <c:choose>
                                <c:when test="${not empty lawyer.galleryPhotos}">
                                    <c:set var="cUrl" value="${lawyer.galleryPhotos}" />
                                    <c:choose>
                                        <c:when test="${fn:startsWith(cUrl, 'http')}"></c:when>
                                        <c:when test="${fn:startsWith(cUrl, '/')}"><c:set var="cUrl" value="${pageContext.request.contextPath}${cUrl}" /></c:when>
                                        <c:otherwise><c:set var="cUrl" value="${pageContext.request.contextPath}/uploads/${cUrl}" /></c:otherwise>
                                    </c:choose>
                                    <img src="${cUrl}" style="width:100%; height:120px; object-fit:cover; border-radius:8px;" alt="Chamber Photo">
                                </c:when>
                                <c:otherwise><div style="width:100%; height:120px; background:var(--bg); border-radius:8px; display:flex; align-items:center; justify-content:center; color:var(--secondary);">Not added</div></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bank & Payments Tab -->
            <div id="bank-tab" class="tab-section">
                <div class="card">
                    <div class="card-header">
                        <h3>Bank & Payments</h3>
                        <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-primary" style="text-decoration:none; padding:8px 16px; font-size:0.8rem; border-radius:8px; color:#fff !important;">Update Bank Info</a>
                    </div>
                    <p style="color:var(--secondary); font-size:0.9rem;">Manage your payout preferences, UPI ID, and Bank Account details.</p>
                    <div style="margin-top: 15px; display: grid; grid-template-columns: 1fr; gap: 15px;">
                        <div class="profile-field"><label>UPI ID</label><div>${empty lawyer.upiId ? 'Not added' : lawyer.upiId}</div></div>
                        <div class="profile-field"><label>Bank Details</label><div>${empty lawyer.bankDetails ? 'Not added' : lawyer.bankDetails}</div></div>
                    </div>
                </div>
            </div>

            <!-- Settings Tab -->
            <div id="settings-tab" class="tab-section">
                <!-- Profile Settings -->
                <div class="card" style="margin-bottom:20px;">
                    <div class="card-header">
                        <h3><i class="bi bi-person" style="color:var(--primary); margin-right:8px;"></i>Account Details</h3>
                        <a href="${pageContext.request.contextPath}/lawyer/profile-completion" class="btn-primary" style="text-decoration:none; padding:8px 16px; font-size:0.8rem; border-radius:8px; color:#fff !important;">Edit Profile</a>
                    </div>
                    <div style="margin-top: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div class="profile-field"><label>Full Name</label><div style="font-weight:600; color:var(--text);">${empty lawyer.fullName ? 'Not added' : lawyer.fullName}</div></div>
                        <div class="profile-field"><label>Email Address</label><div style="font-weight:600; color:var(--text);">${empty lawyer.email ? 'Not added' : lawyer.email}</div></div>
                        <div class="profile-field"><label>Phone Number</label><div style="font-weight:600; color:var(--text);">${empty lawyer.phone ? 'Not added' : lawyer.phone}</div></div>
                        <div class="profile-field"><label>Role / Category</label><div><span class="badge" style="background:#FFE4E6; color:var(--primary); padding:6px 12px; border-radius:20px; font-weight:600;">${empty lawyer.category ? 'Women Lawyer' : lawyer.category.displayName}</span></div></div>
                    </div>
                </div>

                <!-- Security Settings -->
                <div class="card" style="margin-bottom:20px;">
                    <div class="card-header">
                        <h3><i class="bi bi-shield-lock" style="color:var(--primary); margin-right:8px;"></i>Security</h3>
                    </div>
                    <div style="display:flex; justify-content: space-between; align-items:center; padding: 15px 0; border-bottom: 1px solid var(--border);">
                        <div>
                            <div style="font-weight:600; color:var(--text);">Password</div>
                            <div style="font-size:0.85rem; color:var(--secondary); margin-top:4px;">Change your password to keep your account secure.</div>
                        </div>
                        <button style="padding:8px 16px; border-radius:8px; border:1px solid var(--primary); background:transparent; color:var(--primary); font-weight:600; cursor:pointer;">Update Password</button>
                    </div>
                    <div style="display:flex; justify-content: space-between; align-items:center; padding: 15px 0;">
                        <div>
                            <div style="font-weight:600; color:var(--text);">Two-Factor Authentication</div>
                            <div style="font-size:0.85rem; color:var(--secondary); margin-top:4px;">Add an extra layer of security to your account.</div>
                        </div>
                        <div style="width: 40px; height: 20px; background: var(--border); border-radius: 20px; position: relative; cursor: pointer;">
                            <div style="width: 16px; height: 16px; background: white; border-radius: 50%; position: absolute; top: 2px; left: 2px; box-shadow: 0 1px 3px rgba(0,0,0,0.2);"></div>
                        </div>
                    </div>
                </div>

                <!-- Notification Settings -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-bell" style="color:var(--primary); margin-right:8px;"></i>Notifications</h3>
                    </div>
                    <div style="display:flex; justify-content: space-between; align-items:center; padding: 15px 0; border-bottom: 1px solid var(--border);">
                        <div>
                            <div style="font-weight:600; color:var(--text);">Email Notifications</div>
                            <div style="font-size:0.85rem; color:var(--secondary); margin-top:4px;">Receive updates and appointment details via email.</div>
                        </div>
                        <div style="width: 40px; height: 20px; background: var(--primary); border-radius: 20px; position: relative; cursor: pointer;">
                            <div style="width: 16px; height: 16px; background: white; border-radius: 50%; position: absolute; top: 2px; right: 2px; box-shadow: 0 1px 3px rgba(0,0,0,0.2);"></div>
                        </div>
                    </div>
                    <div style="display:flex; justify-content: space-between; align-items:center; padding: 15px 0;">
                        <div>
                            <div style="font-weight:600; color:var(--text);">SMS Alerts</div>
                            <div style="font-size:0.85rem; color:var(--secondary); margin-top:4px;">Receive immediate SMS alerts for bookings.</div>
                        </div>
                        <div style="width: 40px; height: 20px; background: var(--primary); border-radius: 20px; position: relative; cursor: pointer;">
                            <div style="width: 16px; height: 16px; background: white; border-radius: 50%; position: absolute; top: 2px; right: 2px; box-shadow: 0 1px 3px rgba(0,0,0,0.2);"></div>
                        </div>
                    </div>
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






