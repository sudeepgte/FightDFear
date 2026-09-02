<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrepreneur Dashboard — Fight D Fear</title>
    <!-- Premium Google Fonts matching index.jsp -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* Hide fragment header to prevent dark blue header override */
        #header {
            display: none !important;
        }

        :root {
            --bg-page: #FFF8FA;          /* Soft Blush background matching screenshot */
            --bg-card: #FFFFFF;
            --text-plum: #1E1B4B;         /* Dark navy/plum text */
            --text-muted-custom: #64748B;
            --brand-pink: #F33F5E;        /* Flame pink / primary */
            --brand-pink-hover: #D92545;
            --pink-soft-bg: #FFEBF0;      /* Active sidebar pill bg */
            --gold-accent: #F59E0B;
            --border-light: #FCE8EB;
            --font-main: 'Outfit', sans-serif;
        }

        body {
            font-family: var(--font-main);
            background-color: var(--bg-page);
            color: var(--text-plum);
            overflow-x: hidden;
            width: 100vw;
            margin: 0;
        }

        /* Top Header Navbar */
        .top-navbar {
            height: 70px;
            background: #FFFFFF;
            border-bottom: 1px solid #FCE8EB;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1020;
        }

        .top-brand {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 800;
            font-size: 1.35rem;
            color: var(--text-plum);
            text-decoration: none;
        }

        .top-brand i {
            color: var(--brand-pink);
            font-size: 1.5rem;
        }

        .top-nav-links {
            display: flex;
            gap: 32px;
            align-items: center;
        }

        .top-nav-link {
            text-decoration: none;
            color: #475569;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 22px 0;
            position: relative;
        }

        .top-nav-link.active {
            color: var(--brand-pink);
        }

        .top-nav-link.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--brand-pink);
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
        }

        .top-user-area {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .notification-btn {
            position: relative;
            background: transparent;
            border: none;
            color: #475569;
            font-size: 1.2rem;
            cursor: pointer;
        }

        .notification-btn .badge-count {
            position: absolute;
            top: -4px;
            right: -6px;
            background: var(--brand-pink);
            color: white;
            font-size: 0.65rem;
            font-weight: 700;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #FCE8EB;
        }

        /* Layout Container */
        #wrapper {
            display: flex;
            width: 100%;
            padding-top: 70px;
        }

        /* Left Sidebar */
        #sidebar-wrapper {
            width: 240px;
            background: #FFF8FA;
            color: var(--text-plum);
            height: calc(100vh - 70px);
            position: fixed;
            top: 70px;
            left: 0;
            z-index: 1000;
            padding: 24px 16px;
            border-right: 1px solid #FCE8EB;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .sidebar-heading {
            padding: 0 12px 20px;
            font-size: 1.15rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-plum);
            border-bottom: 1px solid #FCE8EB;
            margin-bottom: 16px;
        }

        .sidebar-heading i {
            color: var(--brand-pink);
            font-size: 1.2rem;
        }

        .sidebar-link {
            background: transparent;
            color: #475569;
            padding: 12px 16px;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
            transition: all 0.2s;
            border-radius: 12px;
            margin-bottom: 4px;
        }

        .sidebar-link:hover {
            color: var(--brand-pink);
            background: #FFEBF0;
        }

        .sidebar-link.active {
            color: var(--brand-pink);
            background: #FFEBF0;
            font-weight: 700;
        }

        .sidebar-link i {
            font-size: 1.15rem;
        }

        /* Bottom Sidebar Illustration */
        .sidebar-illustration {
            margin-top: auto;
            padding-top: 20px;
            text-align: center;
        }

        .sidebar-illustration svg, .sidebar-illustration img {
            max-width: 100%;
            height: auto;
        }

        /* Page Content Wrapper */
        #page-content-wrapper {
            margin-left: 240px;
            flex: 1;
            min-width: 0;
            padding: 32px 40px;
            min-height: calc(100vh - 70px);
            background-color: var(--bg-page);
        }


        /* Stat Cards */
        .stat-card-box {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 20px;
            border: 1px solid #FCE8EB;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            height: 100%;
        }

        .stat-icon-circle {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 16px;
        }

        .stat-value {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--text-plum);
            margin-bottom: 2px;
        }

        .stat-label {
            color: #64748B;
            font-size: 0.85rem;
            font-weight: 500;
            margin: 0;
        }

        /* Section Panels */
        .content-panel {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #FCE8EB;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            margin-bottom: 24px;
        }

        .panel-header-title {
            font-weight: 800;
            font-size: 1.15rem;
            color: var(--text-plum);
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .pink-vertical-line {
            display: inline-block;
            width: 4px;
            height: 18px;
            background: var(--brand-pink);
            border-radius: 4px;
            margin-right: 10px;
        }

        .view-all-link {
            color: var(--brand-pink);
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
        }

        .view-all-link:hover {
            color: var(--brand-pink-hover);
            text-decoration: underline;
        }

        /* Upgrade Pill Buttons */
        .btn-upgrade-pill {
            border: 1px solid #F33F5E;
            color: #F33F5E;
            background: transparent;
            border-radius: 50px;
            padding: 4px 14px;
            font-size: 0.78rem;
            font-weight: 700;
            transition: all 0.2s;
        }

        .btn-upgrade-pill:hover {
            background: #F33F5E;
            color: #FFFFFF;
        }

        .btn-refresh-outline {
            border: 1px solid #FCE8EB;
            background: #FFFFFF;
            color: #F33F5E;
            border-radius: 50px;
            padding: 6px 18px;
            font-size: 0.85rem;
            font-weight: 700;
            transition: all 0.2s;
        }

        .btn-refresh-outline:hover {
            background: #FFEBF0;
            color: var(--brand-pink-hover);
        }

        @media (max-width: 992px) {
            #sidebar-wrapper { margin-left: -240px; }
            #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
            #page-content-wrapper { margin-left: 0 !important; padding: 20px; }
            .top-nav-links { display: none; }
        }
    
        .bg-brand-pink { background-color: var(--brand-pink) !important; color: white !important; }
        .text-brand-pink { color: var(--brand-pink) !important; }
        .bg-soft-pink { background-color: var(--pink-soft-bg) !important; }
        .badge-brand { background-color: var(--pink-soft-bg) !important; color: var(--brand-pink) !important; border: 1px solid var(--border-light); }
        .btn-brand-pink { background-color: var(--brand-pink) !important; color: white !important; border: none; }
        .btn-brand-pink:hover { background-color: var(--brand-pink-hover) !important; color: white !important; }
</style>
</head>
<body>

<!-- Hidden header for global background scripts -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- Top Navbar Header -->
<div class="top-navbar">
    <a href="${pageContext.request.contextPath}/" class="top-brand">
        <i class="bi bi-fire"></i> Fight D Fear
    </a>
    
    <div class="top-nav-links">
        <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="top-nav-link active">Home</a>
        <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="top-nav-link">My Bookings</a>
        <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="top-nav-link">Wallet</a>
    </div>

    <div class="top-user-area">
        <button type="button" class="notification-btn" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()">
            <i class="bi bi-bell-fill"></i>
            <c:if test="${unreadBroadcastCount > 0}">
                <span class="badge-count">${unreadBroadcastCount}</span>
            </c:if>
            <c:if test="${empty unreadBroadcastCount || unreadBroadcastCount == 0}">
                <span class="badge-count">3</span>
            </c:if>
        </button>

        <div class="user-pill dropdown" data-bs-toggle="dropdown" aria-expanded="false" style="cursor: pointer;">
            <c:choose>
                <c:when test="${not empty entrepreneur.profilePhoto}">
                    <img src="${pageContext.request.contextPath}${entrepreneur.profilePhoto}" alt="User" class="user-avatar">
                </c:when>
                <c:otherwise>
                    <div class="user-avatar bg-warning text-dark fw-bold d-flex align-items-center justify-content-center">
                        ${entrepreneur.fullName != null ? entrepreneur.fullName.substring(0,1) : 'S'}
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="d-none d-sm-block text-start">
                <div class="fw-bold" style="font-size: 0.9rem; line-height: 1.1; color: var(--text-plum);">${entrepreneur.fullName != null ? entrepreneur.fullName : 'Sindhu'}</div>
                <div class="small text-muted" style="font-size: 0.75rem;">Entrepreneur</div>
            </div>
            <i class="bi bi-chevron-down text-muted small ms-1"></i>
        </div>
        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2" style="border: 1px solid #FCE8EB !important;">
            <li><a class="dropdown-item py-2 fw-semibold" style="color: var(--text-plum);" href="${pageContext.request.contextPath}/entrepreneur/profile-completion"><i class="bi bi-person-circle me-2 text-brand-pink"></i> My Profile</a></li>
            <li><a class="dropdown-item py-2 fw-semibold" style="color: var(--text-plum);" href="${pageContext.request.contextPath}/entrepreneur/wallet"><i class="bi bi-wallet2 me-2 text-brand-pink"></i> Wallet</a></li>
            <li><hr class="dropdown-divider my-1"></li>
            <li><a class="dropdown-item py-2 fw-semibold text-brand-pink" href="${pageContext.request.contextPath}/entrepreneur/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
        </ul>
    </div>
</div>

<div id="wrapper">
    <!-- Left Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        
        <div class="d-flex flex-column" style="flex: 1;">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link active">
                <i class="bi bi-house-door-fill"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/chat/0" class="sidebar-link">
                <i class="bi bi-chat-left-dots-fill"></i> Chat
            </a>
            <c:choose>
                <c:when test="${entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED'}">
                    <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link">
                        <i class="bi bi-plus-square-fill"></i> Create Proposal
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="#" class="sidebar-link" style="opacity: 0.6; cursor: not-allowed;" onclick="alert('You cannot create a proposal until your profile is verified by the admin.'); return false;" title="Profile verification pending">
                        <i class="bi bi-plus-square-fill"></i> Create Proposal <i class="bi bi-lock-fill ms-2"></i>
                    </a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="sidebar-link">
                <i class="bi bi-calendar-event-fill"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <a href="#" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()" class="sidebar-link">
                <i class="bi bi-bell-fill"></i> Notifications
                <span class="badge bg-brand-pink rounded-circle ms-auto" style="font-size:0.7rem;">3</span>
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/profile-completion" class="sidebar-link">
                <i class="bi bi-person-circle"></i> My Profile
            </a>

            <hr style="border-top: 1px solid #FCE8EB; margin: 12px 0;">

            <a href="${pageContext.request.contextPath}/entrepreneur/logout" class="sidebar-link text-brand-pink">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid p-0">
            
            <!-- Welcome Header & Refresh -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold m-0" style="color: var(--text-plum);">Hello, ${entrepreneur.fullName != null ? entrepreneur.fullName : 'Sindhu'}! 👋</h2>
                    <p class="text-muted m-0 small mt-1">Manage your business projects and engage with interested funding entities.</p>
                </div>
                <button onclick="location.reload()" class="btn-refresh-outline">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                    <i class="bi bi-check-circle-fill"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>


            <!-- 4 Stat Cards Row (Exact 4 Columns from Mockup) -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card-box">
                        <div class="stat-icon-circle" style="background-color: #FFE4E6; color: #F33F5E;">
                            <i class="bi bi-wallet2"></i>
                        </div>
                        <div class="stat-value">₹${totalRequested != null ? totalRequested : 0.0}</div>
                        <p class="stat-label">Total Funding Requested</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card-box">
                        <div class="stat-icon-circle" style="background-color: var(--pink-soft-bg); color: var(--brand-pink);">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <div class="stat-value">₹${totalRaised != null ? totalRaised : 0.0}</div>
                        <p class="stat-label">Total Raised from Investors</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card-box">
                        <div class="stat-icon-circle" style="background-color: #FEF3D6; color: #D97706;">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <div class="stat-value">₹${remaining > 0 ? remaining : 0}</div>
                        <p class="stat-label">Remaining Funding Needed</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card-box">
                        <div class="stat-icon-circle" style="background-color: #FFE4E6; color: #F33F5E;">
                            <i class="bi bi-file-earmark-text-fill"></i>
                        </div>
                        <div class="stat-value">${proposals != null ? proposals.size() : 0}</div>
                        <p class="stat-label">Active Proposals</p>
                    </div>
                </div>
            </div>

            <!-- Main Grid Section -->
            <div class="row g-4">
                <!-- Left 8 Columns -->
                <div class="col-lg-8">
                    <!-- My Business Proposals Panel -->
                    <div class="content-panel">
                        <div class="panel-header-title">
                            <div>
                                <span class="pink-vertical-line"></span>My Business Proposals
                            </div>
                            <c:choose>
                                <c:when test="${entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED'}">
                                    <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="view-all-link">Create Proposal &rarr;</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="#" onclick="alert('You cannot create a proposal until your profile is verified by the admin.'); return false;" class="view-all-link" style="opacity: 0.6; cursor: not-allowed;">Create Proposal <i class="bi bi-lock-fill ms-1"></i></a>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-borderless align-middle m-0" style="font-size:0.88rem;">
                                <thead>
                                    <tr class="text-muted border-bottom" style="font-size:0.78rem; text-transform: uppercase; letter-spacing:0.5px;">
                                        <th class="ps-0">Proposal Details</th>
                                        <th>Goal / Raised</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="proposal" items="${proposals}">
                                        <tr class="border-bottom">
                                            <td class="ps-0 py-3">
                                                <div class="fw-bold" style="color: var(--text-plum); font-size:0.95rem;">${proposal.title}</div>
                                                <div class="text-muted small">${proposal.category} | ${proposal.status}</div>
                                            </td>
                                            <td class="py-3">
                                                <div class="d-flex justify-content-between small text-muted mb-1" style="font-size:0.75rem;">
                                                    <span>₹${proposal.amountRaised} raised</span>
                                                    <span>₹${proposal.fundingNeeded} target</span>
                                                </div>
                                                <div class="progress" style="height:6px; background-color: #FFE4E6;">
                                                    <div class="progress-bar bg-brand-pink" role="progressbar" style="width: 50%;"></div>
                                                </div>
                                            </td>
                                            <td class="py-3">
                                                <span class="badge bg-soft-pink text-brand-pink rounded-pill px-3 py-1" style="font-size:0.75rem; font-weight:700;">
                                                    &bull; Live
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty proposals}">
                                        <tr class="border-bottom">
                                            <td class="ps-0 py-3">
                                                <div class="fw-bold" style="color: var(--text-plum); font-size:0.95rem;">Launch of Pending Profile Completion</div>
                                                <div class="text-muted small">Tea Shop | Pending</div>
                                            </td>
                                            <td class="py-3">
                                                <div class="d-flex justify-content-between small text-muted mb-1" style="font-size:0.75rem;">
                                                    <span>₹0.0 raised</span>
                                                    <span>₹0.0 target</span>
                                                </div>
                                                <div class="progress" style="height:6px; background-color: #FFE4E6;">
                                                    <div class="progress-bar bg-danger" role="progressbar" style="width: 0%;"></div>
                                                </div>
                                            </td>
                                            <td class="py-3">
                                                <span class="badge bg-soft-pink text-brand-pink rounded-pill px-3 py-1" style="font-size:0.75rem; font-weight:700;">
                                                    &bull; Live
                                                </span>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Interested Funding Entities Panel -->
                    <div class="content-panel">
                        <div class="panel-header-title">
                            <div>
                                <i class="bi bi-people-fill text-brand-pink me-2"></i>Interested Funding Entities
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty interestedInvestors}">
                                <div class="d-flex flex-column gap-3">
                                    <c:forEach var="inv" items="${interestedInvestors}">
                                        <div class="d-flex justify-content-between align-items-center pb-2 border-bottom" style="font-size: 0.88rem;">
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="p-2 rounded-circle bg-soft-pink text-brand-pink d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">
                                                    <i class="bi bi-person-fill"></i>
                                                </div>
                                                <div class="text-start">
                                                    <div class="fw-bold" style="color: var(--text-plum);">${inv.fullName}</div>
                                                    <span class="text-muted small">${inv.email}</span>
                                                </div>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/entrepreneur/chat/${inv.id}" class="btn btn-sm btn-brand-pink rounded-pill px-3" style="font-size:0.75rem; font-weight:600; background-color: var(--brand-pink); border: none;">
                                                    <i class="bi bi-chat-dots-fill"></i> Chat
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <div class="mx-auto rounded-circle bg-soft-pink text-brand-pink d-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px; font-size: 1.5rem;">
                                        <i class="bi bi-people-fill"></i>
                                    </div>
                                    <h6 class="fw-bold" style="color: var(--text-plum);">No interested investors yet.</h6>
                                    <p class="text-muted small mb-3">Your proposals will attract partners once verified!</p>
                                    <c:choose>
                                        <c:when test="${entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED'}">
                                            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="btn-upgrade-pill px-4 py-2 text-decoration-none d-inline-block">
                                                Explore Investors
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" onclick="alert('You cannot create a proposal until your profile is verified by the admin.'); return false;" class="btn-upgrade-pill px-4 py-2 text-decoration-none d-inline-block" style="opacity: 0.6; cursor: not-allowed;">
                                                Explore Investors <i class="bi bi-lock-fill ms-2"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Discover Approved Investors Panel -->
                    <div class="content-panel mt-4 mb-4">
                        <div class="panel-header-title">
                            <div>
                                <i class="bi bi-search text-brand-pink me-2"></i>Discover Active Investors
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty approvedInvestors}">
                                <div class="row g-3">
                                    <c:forEach var="inv" items="${approvedInvestors}">
                                        <div class="col-md-6">
                                            <div class="card h-100 border-0 shadow-sm" style="border-radius: 12px; background: #fff;">
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-center pb-2 mb-2 border-bottom">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="rounded-circle bg-soft-pink text-brand-pink d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.9rem;">
                                                                <i class="bi bi-person-fill"></i>
                                                            </div>
                                                            <div class="fw-bold" style="color: var(--text-plum); font-size: 0.95rem;">${inv.fullName}</div>
                                                        </div>
                                                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2 py-1" style="font-size: 0.7rem;"><i class="bi bi-check-circle-fill me-1"></i>Verified</span>
                                                    </div>
                                                    <div class="small text-muted mb-2">
                                                        <i class="bi bi-envelope-fill me-1"></i> ${inv.email}
                                                    </div>
                                                    <c:if test="${not empty inv.companyName}">
                                                        <div class="small text-dark fw-medium mb-1">
                                                            <i class="bi bi-building me-1 text-muted"></i> ${inv.companyName}
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty inv.investmentInterests}">
                                                        <div class="small text-muted text-truncate" title="${inv.investmentInterests}">
                                                            <i class="bi bi-briefcase me-1"></i> ${inv.investmentInterests}
                                                        </div>
                                                    </c:if>
                                                    <div class="mt-3">
                                                        <a href="${pageContext.request.contextPath}/entrepreneur/chat/${inv.id}" class="btn btn-sm w-100 btn-outline-brand-pink rounded-pill" style="font-size:0.8rem; font-weight:600; color: var(--brand-pink); border-color: var(--brand-pink);">
                                                            <i class="bi bi-chat-dots-fill me-1"></i> Send Pitch / Message
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3">
                                    <p class="text-muted small m-0">No active verified investors available at the moment.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Recent Activity Panel -->
                    <div class="content-panel">
                        <div class="panel-header-title">
                            <div>
                                <i class="bi bi-activity text-brand-pink me-2"></i>Recent Activity
                            </div>
                            <a href="#" class="view-all-link">View All &rarr;</a>
                        </div>

                        <div class="d-flex flex-column gap-3" style="font-size: 0.88rem;">
                            <div class="d-flex justify-content-between align-items-center pb-2 border-bottom">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded-circle bg-soft-pink text-brand-pink fs-6"><i class="bi bi-file-earmark-check-fill"></i></div>
                                    <span class="fw-semibold">Profile submitted for verification</span>
                                </div>
                                <span class="text-muted small">2 days ago</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pb-2 border-bottom">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded-circle bg-warning-subtle text-warning fs-6"><i class="bi bi-lock-fill"></i></div>
                                    <span class="fw-semibold">Proposal "Launch of Tea Shop" created</span>
                                </div>
                                <span class="text-muted small">4 days ago</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pb-2 border-bottom">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded-circle bg-soft-pink text-brand-pink fs-6"><i class="bi bi-person-lines-fill"></i></div>
                                    <span class="fw-semibold">Profile information updated</span>
                                </div>
                                <span class="text-muted small">1 week ago</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded-circle bg-soft-pink text-brand-pink fs-6"><i class="bi bi-person-plus-fill"></i></div>
                                    <span class="fw-semibold">Joined Fight D Fear platform</span>
                                </div>
                                <span class="text-muted small">2 weeks ago</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right 4 Columns (Exact 3 Cards from Mockup) -->
                <div class="col-lg-4">
                    <!-- Consultation Meetings Card -->
                    <div class="content-panel py-4 text-start">
                        <div class="d-flex align-items-center gap-2 mb-4 text-start px-3">
                            <div class="p-2 rounded bg-danger text-white fs-6"><i class="bi bi-calendar-check-fill"></i></div>
                            <h6 class="fw-bold m-0" style="color: var(--text-plum);">Consultation Meetings</h6>
                        </div>
                        <c:choose>
                            <c:when test="${not empty meetings}">
                                <div class="d-flex flex-column gap-3 px-3">
                                    <c:forEach var="meeting" items="${meetings}">
                                        <div class="p-3 rounded border bg-light position-relative" style="font-size: 0.88rem;">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="fw-bold" style="color: var(--text-plum);">${meeting.proposal.title}</span>
                                                <c:choose>
                                                    <c:when test="${meeting.status == 'ACCEPTED'}">
                                                        <span class="badge bg-soft-pink text-brand-pink rounded-pill px-2 py-1" style="font-size:0.7rem;">Accepted</span>
                                                    </c:when>
                                                    <c:when test="${meeting.status == 'REJECTED'}">
                                                        <span class="badge bg-soft-pink text-brand-pink rounded-pill px-2 py-1" style="font-size:0.7rem;">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning-dark rounded-pill px-2 py-1" style="font-size:0.7rem; color: #b45309; background-color: #fef3c7;">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="text-muted mb-1" style="font-size: 0.8rem;">
                                                <i class="bi bi-person-fill text-brand-pink me-1"></i> Investor: <strong>${meeting.investor.fullName}</strong>
                                            </div>
                                            <div class="text-muted mb-1" style="font-size: 0.8rem;">
                                                <i class="bi bi-clock-fill text-brand-pink me-1"></i> Time: ${meeting.meetingTime.toString().replace('T', ' ')}
                                            </div>
                                            <c:if test="${not empty meeting.location}">
                                                <div class="text-muted mb-1" style="font-size: 0.8rem; word-break: break-all;">
                                                    <i class="bi bi-geo-alt-fill text-brand-pink me-1"></i> Location/Link: 
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(meeting.location, 'http')}">
                                                            <a href="${meeting.location}" target="_blank" class="text-brand-pink fw-semibold">${meeting.location}</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${meeting.location}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                            
                                            <!-- Acceptance actions for pending meetings -->
                                            <c:if test="${meeting.status == 'PENDING'}">
                                                <div class="d-flex gap-2 mt-2">
                                                    <form action="${pageContext.request.contextPath}/entrepreneur/meetings/${meeting.id}/accept" method="post" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-brand-pink rounded-pill px-3" style="font-size:0.72rem; font-weight:600;">Accept</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/entrepreneur/meetings/${meeting.id}/reject" method="post" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-brand-pink rounded-pill px-3" style="font-size:0.72rem; font-weight:600;">Reject</button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3">
                                    <p class="text-muted small my-4">No meetings scheduled.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Investor Q&A Board Card -->
                    <div class="content-panel text-start py-4">
                        <div class="d-flex align-items-center gap-2 mb-4 text-start px-3">
                            <div class="p-2 rounded bg-danger text-white fs-6"><i class="bi bi-question-circle-fill"></i></div>
                            <h6 class="fw-bold m-0" style="color: var(--text-plum);">Investor Q&A Board</h6>
                        </div>
                        <c:choose>
                            <c:when test="${not empty questions}">
                                <div class="d-flex flex-column gap-3 px-3">
                                    <c:forEach var="q" items="${questions}">
                                        <div class="p-3 rounded border bg-light" style="font-size: 0.88rem;">
                                            <div class="fw-bold mb-1" style="color: var(--text-plum);">
                                                <i class="bi bi-chat-left-text-fill text-brand-pink me-1"></i>
                                                Q by ${q.investor.fullName} (for: ${q.proposal.title}):
                                            </div>
                                            <p class="text-secondary mb-2" style="font-style: italic;">"${q.question}"</p>
                                            
                                            <c:choose>
                                                <c:when test="${not empty q.answer}">
                                                    <div class="p-2 rounded bg-soft-pink text-brand-pink border border-success-subtle">
                                                        <strong>A:</strong> "${q.answer}"
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/entrepreneur/questions/${q.id}/answer" method="post" class="mt-2">
                                                        <div class="input-group input-group-sm">
                                                            <input type="text" name="answer" class="form-control" placeholder="Write your response..." required autocomplete="off">
                                                            <button class="btn btn-brand-pink" type="submit" style="background-color: var(--brand-pink); border: none;">Submit Answer</button>
                                                        </div>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3">
                                    <p class="text-muted small my-4">No questions asked yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Platform Commissions Card -->
                    <div class="content-panel text-start py-4">
                        <div class="d-flex align-items-center gap-2 mb-4 text-start px-3">
                            <div class="p-2 rounded bg-danger text-white fs-6"><i class="bi bi-wallet2"></i></div>
                            <h6 class="fw-bold m-0" style="color: var(--text-plum);">Platform Commissions</h6>
                        </div>
                        <c:choose>
                            <c:when test="${not empty investments}">
                                <div class="d-flex flex-column gap-3 px-3">
                                    <c:forEach var="inv" items="${investments}">
                                        <!-- Only show commission for active/completed investments -->
                                        <div class="p-3 rounded border bg-light" style="font-size: 0.88rem;">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="fw-bold" style="color: var(--text-plum);">${inv.proposal.title}</span>
                                                <c:choose>
                                                    <c:when test="${inv.commissionPaid}">
                                                        <span class="badge bg-soft-pink text-brand-pink rounded-pill px-2 py-1" style="font-size:0.7rem;">Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning-dark rounded-pill px-2 py-1" style="font-size:0.7rem; color: #b45309; background-color: #fef3c7;">Unpaid</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="text-muted mb-1" style="font-size: 0.8rem;">
                                                Investor: <strong>${inv.investor.fullName}</strong>
                                            </div>
                                            <div class="text-muted mb-1" style="font-size: 0.8rem;">
                                                Investment: <strong>₹${inv.amount}</strong>
                                            </div>
                                            <div class="text-muted mb-2" style="font-size: 0.8rem;">
                                                Commission (2%): <strong class="text-brand-pink">₹${inv.amount * 0.02}</strong>
                                            </div>
                                            <c:if test="${not inv.commissionPaid}">
                                                <button class="btn btn-sm btn-brand-pink rounded-pill px-3 mt-1" style="font-size:0.75rem; font-weight:600; background-color: var(--brand-pink); border: none;" onclick="triggerCheckout('commission', ${inv.id}, ${inv.amount * 0.02}, '${pageContext.request.contextPath}/entrepreneur/commission/pay/${inv.id}')">
                                                    Pay Commission
                                                </button>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-3">
                                    <p class="text-muted small my-4">No commissions to pay yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- MOCK CHECKOUT MODAL (Simulated Razorpay) -->
<div class="modal fade" id="mockCheckoutModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" style="z-index: 2000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <!-- Header -->
            <div class="modal-header bg-dark text-white border-0 py-3" style="border-top-left-radius: 20px; border-top-right-radius: 20px;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-fill-check text-brand-pink fs-3"></i>
                    <div>
                        <h6 class="modal-title fw-bold m-0" style="letter-spacing:1px;">RAZORPAY CHECKOUT</h6>
                        <span class="text-muted small" style="font-size:10px;">Test Mode</span>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" id="checkoutCloseBtn"></button>
            </div>
            <!-- Body -->
            <div class="modal-body p-4 text-center">
                <div class="mb-4">
                    <p class="text-muted mb-1 text-uppercase fw-semibold" style="font-size: 11px;" id="checkoutTypeLabel">Service Payment</p>
                    <h3 class="fw-bold" style="color:var(--text-plum);" id="checkoutAmountLabel">₹0.00</h3>
                </div>

                <!-- Simulation content -->
                <div id="checkoutFormContent">
                    <div class="p-3 border rounded-3 text-start bg-light mb-4" style="font-size:0.9rem;">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Platform:</span>
                            <span class="fw-bold text-navy">FightDFire Investment</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Beneficiary:</span>
                            <span class="fw-bold text-navy">Platform Admin Account</span>
                        </div>
                    </div>
                    
                    <button class="btn w-100 rounded-pill py-3 fw-bold text-white" style="background-color: var(--brand-pink);" onclick="simulatePaymentProcessing()">
                        Pay Securely with Simulated Card
                    </button>
                </div>

                <!-- Loading screen -->
                <div id="checkoutLoadingContent" style="display:none;" class="py-4">
                    <div class="spinner-border text-brand-pink" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5 class="fw-bold text-brand-pink mt-4">Processing Simulated Payment...</h5>
                    <p class="text-muted small">Please do not refresh or close this dialog.</p>
                </div>

                <!-- Success Screen -->
                <div id="checkoutSuccessContent" style="display:none;" class="py-4">
                    <i class="bi bi-check-circle-fill text-brand-pink" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-brand-pink mt-4">Payment Successful!</h5>
                    <p class="text-muted small">Updating platform status...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- BROADCAST NOTIFICATIONS MODAL -->
<div class="modal fade" id="broadcastModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <div class="d-flex align-items-center gap-2">
                    <div class="p-2 rounded-circle bg-soft-pink text-brand-pink fs-5 d-flex align-items-center justify-content-center" style="width:38px; height:38px;">
                        <i class="bi bi-bell-fill"></i>
                    </div>
                    <div>
                        <h6 class="modal-title fw-bold m-0" style="color: var(--text-plum);">Platform Notifications</h6>
                        <span class="text-muted small" style="font-size:12px;">Stay updated on opportunities & announcements</span>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="d-flex flex-column gap-3">
                    <div class="p-3 rounded-3 border bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold text-brand-pink small"><i class="bi bi-megaphone-fill me-1"></i> Admin Announcement</span>
                            <span class="text-muted" style="font-size: 11px;">Today</span>
                        </div>
                        <p class="m-0 text-dark small">Welcome to the Fight D Fear Entrepreneur Portal! Complete your profile verification to connect with active investors.</p>
                    </div>
                    <div class="p-3 rounded-3 border bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold text-warning small"><i class="bi bi-shield-check me-1"></i> Verification Tip</span>
                            <span class="text-muted" style="font-size: 11px;">Yesterday</span>
                        </div>
                        <p class="m-0 text-dark small">Verified business proposals get 5x higher visibility from funding entities and banks.</p>
                    </div>
                    <div class="p-3 rounded-3 border bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold text-primary small"><i class="bi bi-star-fill me-1"></i> Feature Boost</span>
                            <span class="text-muted" style="font-size: 11px;">3 days ago</span>
                        </div>
                        <p class="m-0 text-dark small">Feature your business proposal on the marketplace hero banner to attract top angel investors.</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 pb-4 px-4">
                <button type="button" class="btn w-100 rounded-pill py-2 text-white fw-bold" style="background-color: var(--brand-pink);" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    let activeCheckoutForm = null;

    function markBroadcastsAsRead() {
        const badge = document.querySelector('.badge-count');
        if (badge) {
            badge.style.display = 'none';
        }
    }

    function triggerCheckout(type, id, amount, targetUrl) {
        // Build checkout form dynamically
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = targetUrl;
        
        activeCheckoutForm = form;
        document.body.appendChild(form);

        // Update modal UI
        document.getElementById('checkoutTypeLabel').innerText = type.toUpperCase() + " PAYMENT";
        document.getElementById('checkoutAmountLabel').innerText = "₹" + amount.toFixed(2);

        // Reset Modal states
        document.getElementById('checkoutFormContent').style.display = 'block';
        document.getElementById('checkoutLoadingContent').style.display = 'none';
        document.getElementById('checkoutSuccessContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'block';

        // Show Modal
        const modal = new bootstrap.Modal(document.getElementById('mockCheckoutModal'));
        modal.show();
    }

    function simulatePaymentProcessing() {
        document.getElementById('checkoutFormContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'none';
        document.getElementById('checkoutLoadingContent').style.display = 'block';

        setTimeout(() => {
            document.getElementById('checkoutLoadingContent').style.display = 'none';
            document.getElementById('checkoutSuccessContent').style.display = 'block';

            setTimeout(() => {
                if (activeCheckoutForm) {
                    activeCheckoutForm.submit();
                }
            }, 1000);
        }, 1500);
    }
    
    // Mobile Sidebar Toggle
    const menuToggle = document.getElementById('menu-toggle');
    if (menuToggle) {
        menuToggle.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
        });
    }
</script>
</body>
</html>
