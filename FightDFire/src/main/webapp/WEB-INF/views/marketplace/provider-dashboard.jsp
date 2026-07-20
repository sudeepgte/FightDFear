<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Provider Dashboard | Fight D Fear</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Montserrat:wght@800;900&display=swap" rel="stylesheet">
    
    <!-- SockJS & Stomp -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --p-purple-dark: #2D0B2E;
            --p-purple-mid: #4A1E38;
            --p-crimson: #f43f5e;
            --p-crimson-light: #F472B6;
            --p-glass: rgba(255, 255, 255, 0.03);
            --p-glass-border: rgba(255, 255, 255, 0.1);
            --p-text-main: #FFFFFF;
            --p-text-muted: #A1A1AA;
            --transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--p-purple-dark);
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(219, 39, 119, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 90% 80%, rgba(30, 27, 75, 0.1) 0%, transparent 40%);
            color: var(--p-text-main);
            min-height: 100vh;
            overflow-x: hidden;
            scroll-behavior: smooth;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            height: 100vh;
            position: fixed;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--p-glass-border);
            padding: 40px 20px;
            z-index: 1000;
        }

        .brand-box {
            margin-bottom: 50px;
            padding: 0 15px;
        }

        .brand-box h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            background: linear-gradient(135deg, #FFF, var(--p-crimson-light));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .provider-profile {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px;
            background: var(--p-glass);
            border-radius: 24px;
            border: 1px solid var(--p-glass-border);
        }

        .avatar-circle {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--p-crimson), var(--p-purple-mid));
            border-radius: 24px;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 800;
            box-shadow: 0 10px 20px rgba(219, 39, 119, 0.2);
        }

        .sidebar-nav {
            list-style: none;
            padding: 0;
        }

        .sidebar-nav li {
            margin-bottom: 10px;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            color: var(--p-text-muted);
            text-decoration: none;
            border-radius: 16px;
            transition: var(--transition);
            font-weight: 500;
        }

        .sidebar-nav a:hover, .sidebar-nav a.active {
            background: rgba(219, 39, 119, 0.1);
            color: var(--p-crimson-light);
            transform: translateX(5px);
        }

        /* Main Content */
        .main-wrapper {
            margin-left: 280px;
            padding: 40px;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }

        .greeting h2 {
            font-weight: 800;
            margin-bottom: 5px;
        }

        .glass-card {
            background: var(--p-glass);
            backdrop-filter: blur(12px);
            border: 1px solid var(--p-glass-border);
            border-radius: 28px;
            padding: 30px;
            height: 100%;
            transition: var(--transition);
            margin-bottom: 30px;
        }

        .glass-card:hover {
            border-color: rgba(219, 39, 119, 0.3);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        .card-header-custom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .card-header-custom h4 {
            font-weight: 700;
            margin: 0;
            font-size: 1.25rem;
        }

        /* Forms & Inputs Visibility Fix */
        .fdf-input, select.fdf-input, input.fdf-input, textarea.fdf-input {
            background-color: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid var(--p-glass-border) !important;
            border-radius: 14px !important;
            color: #ffffff !important;
            padding: 12px 18px !important;
            font-size: 0.9rem !important;
        }

        .fdf-input::placeholder {
            color: rgba(255, 255, 255, 0.5) !important;
        }

        .fdf-input option {
            background-color: #2D0B2E !important;
            color: #ffffff !important;
        }

        .fdf-input:focus {
            background-color: rgba(255, 255, 255, 0.12) !important;
            border-color: var(--p-crimson) !important;
            color: #ffffff !important;
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1) !important;
        }

        .btn-premium {
            background: linear-gradient(135deg, var(--p-crimson), #A855F7);
            border: none;
            color: white;
            padding: 14px 28px;
            border-radius: 16px;
            font-weight: 700;
            transition: var(--transition);
            box-shadow: 0 10px 20px rgba(219, 39, 119, 0.2);
        }

        .btn-premium:hover {
            transform: scale(1.03) translateY(-2px);
            filter: brightness(1.1);
            color: white;
        }

        /* Tables */
        .premium-table {
            color: var(--p-text-main);
        }

        .premium-table thead th {
            border: none;
            background: rgba(255, 255, 255, 0.05);
            padding: 15px;
            font-weight: 600;
            color: var(--p-text-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
        }

        .premium-table tbody td {
            border-bottom: 1px solid var(--p-glass-border);
            padding: 18px 15px;
            font-size: 0.95rem;
        }

        /* Class Items */
        .class-item {
            padding: 20px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--p-glass-border);
            border-radius: 20px;
            margin-bottom: 15px;
            transition: var(--transition);
        }

        .class-item:hover {
            background: rgba(255, 255, 255, 0.04);
            border-color: var(--p-crimson-light);
        }

        .badge-live {
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
            padding: 5px 12px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.7rem;
        }

        .badge-rec {
            background: rgba(59, 130, 246, 0.1);
            color: #3B82F6;
            border: 1px solid rgba(59, 130, 246, 0.2);
            padding: 5px 12px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.7rem;
        }

        .status-pill {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .status-PENDING { background: rgba(245, 158, 11, 0.1); color: #F59E0B; }
        .status-CONFIRMED, .status-PAID { background: rgba(16, 185, 129, 0.1); color: #10B981; }
        .status-COMPLETED { background: rgba(59, 130, 246, 0.1); color: #3B82F6; }
        .status-CANCELLED { background: rgba(239, 68, 68, 0.1); color: #EF4444; }

        /* Communication Modals */
        .comm-modal {
            background: rgba(0, 0, 0, 0.8) !important;
            backdrop-filter: blur(10px);
        }
        .comm-content {
            background: var(--p-purple-dark) !important;
            border: 1px solid var(--p-glass-border) !important;
            border-radius: 24px !important;
            overflow: hidden;
        }
        .chat-area {
            height: 400px;
            overflow-y: auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .chat-msg {
            max-width: 80%;
            padding: 10px 15px;
            border-radius: 18px;
            font-size: 0.9rem;
        }
        .chat-msg.sent {
            align-self: flex-end;
            background: var(--p-crimson);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .chat-msg.received {
            align-self: flex-start;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-bottom-left-radius: 4px;
        }
        .video-container {
            position: relative;
            width: 100%;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 12px;
            overflow: hidden;
        }
        #remoteVideo {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        #localVideo {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 30%;
            aspect-ratio: 16/9;
            background: #222;
            border: 2px solid var(--p-crimson);
            border-radius: 8px;
            z-index: 10;
            object-fit: cover;
        }

        /* Stats Bar */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--p-glass);
            border: 1px solid var(--p-glass-border);
            padding: 25px;
            border-radius: 24px;
            text-align: center;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--p-crimson-light);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.8rem;
            color: var(--p-text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        @media (max-width: 1000px) {
            .sidebar { transform: translateX(-100%); }
            .main-wrapper { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand-box">
            <h2>Fight D Fear</h2>
        </div>

        <div class="provider-profile">
            <div class="avatar-circle">${provider.fullName.charAt(0)}</div>
            <h5 class="m-0 fw-700">${provider.fullName}</h5>
            <div class="small text-muted mt-1">${provider.category}</div>
            <div class="mt-2"><i class="fas fa-star text-warning"></i> <b>${provider.rating}</b></div>
        </div>

        <ul class="sidebar-nav">
            <li><a href="javascript:void(0)" onclick="showTab('overview')" id="nav-overview" class="active"><i class="bi bi-grid-fill"></i> Overview</a></li>
            <li><a href="javascript:void(0)" onclick="showTab('schedule')" id="nav-schedule"><i class="bi bi-calendar-event"></i> Schedule</a></li>
            <li><a href="javascript:void(0)" onclick="showTab('clients')" id="nav-clients"><i class="bi bi-people"></i> My Clients</a></li>
            <li><a href="javascript:void(0)" onclick="showTab('earnings')" id="nav-earnings"><i class="bi bi-wallet2"></i> Earnings</a></li>
            <li class="mt-5"><a href="${pageContext.request.contextPath}/logout" style="color: #EF4444;"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-wrapper">
        <!-- Global message notice outside tabs for visibility -->
        <c:if test="${not empty message}">
            <div class="alert alert-dismissible fade show rounded-4 mb-4" style="background: rgba(16, 185, 129, 0.1); color: #10B981; border: 1px solid rgba(16, 185, 129, 0.2); z-index: 1000; position: relative;">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 1. OVERVIEW SECTION -->
        <div id="overview-section" class="dashboard-section">
            <div class="top-nav">
                <div class="greeting">
                    <h2>Dashboard Overview</h2>
                    <p class="text-muted m-0">Welcome back! Here's what's happening today.</p>
                </div>
                <div class="d-flex gap-3">
                    <button class="btn btn-outline-light border-0" style="background: var(--p-glass); border-radius: 12px; padding: 10px 15px;">
                        <i class="bi bi-bell"></i>
                    </button>
                </div>
            </div>

            <!-- Stats Bar -->
            <div class="stats-grid">
                <div class="stat-card" style="cursor: pointer;" onclick="showTab('earnings')">
                    <div class="stat-value">₹${totalEarnings}</div>
                    <div class="stat-label">Total Revenue</div>
                </div>
                <div class="stat-card" style="cursor: pointer;" onclick="showTab('clients')">
                    <div class="stat-value">${enrollments.size()}</div>
                    <div class="stat-label">Total Students</div>
                </div>
                <div class="stat-card" style="cursor: pointer;" onclick="showTab('schedule')">
                    <div class="stat-value">${classes.size()}</div>
                    <div class="stat-label">Active Classes</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${provider.rating}</div>
                    <div class="stat-label">Average Rating</div>
                </div>
            </div>

            <!-- Overview Quick Actions and Widgets -->
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="glass-card" style="min-height: 380px;">
                        <div class="card-header-custom">
                            <h4>Recent Scheduled Classes</h4>
                            <a href="javascript:void(0)" onclick="showTab('schedule')" class="text-crimson-light small text-decoration-none fw-600">View Schedule <i class="bi bi-arrow-right"></i></a>
                        </div>
                        <div style="max-height: 280px; overflow-y: auto;">
                            <c:forEach var="c" items="${classes}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="class-item mb-2">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="m-0 fw-700 text-truncate" style="max-width: 200px;">${c.className}</h6>
                                                <small class="text-muted">${c.dateTime}</small>
                                            </div>
                                            <span class="badge-${c.mode == 'Live' ? 'live' : 'rec'}">${c.mode}</span>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty classes}">
                                <div class="text-center py-5">
                                    <i class="bi bi-calendar-x text-muted display-6 opacity-25"></i>
                                    <p class="mt-3 text-muted small">No scheduled classes yet.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="glass-card" style="min-height: 380px;">
                        <div class="card-header-custom">
                            <h4>Recent Bookings</h4>
                            <a href="javascript:void(0)" onclick="showTab('clients')" class="text-crimson-light small text-decoration-none fw-600">Manage Clients <i class="bi bi-arrow-right"></i></a>
                        </div>
                        <div style="max-height: 280px; overflow-y: auto;">
                            <c:forEach var="b" items="${bookings}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="d-flex justify-content-between align-items-center mb-2 p-3 rounded-4" style="background: rgba(255,255,255,0.02); border: 1px solid var(--p-glass-border);">
                                        <div>
                                            <div class="fw-600 small">${b.user.fullName}</div>
                                            <div class="text-muted" style="font-size: 0.75rem;">${b.requestedTime}</div>
                                        </div>
                                        <span class="status-pill status-${b.status}" style="font-size: 0.7rem;">${b.status}</span>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty bookings}">
                                <div class="text-center py-5">
                                    <i class="bi bi-person-x text-muted display-6 opacity-25"></i>
                                    <p class="mt-3 text-muted small">No booking requests yet.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. SCHEDULE SECTION -->
        <div id="schedule-section" class="dashboard-section" style="display: none;">
            <div class="top-nav">
                <div class="greeting">
                    <h2>Class Scheduling & Management</h2>
                    <p class="text-muted m-0">Launch new classes, configure capacity seats, prices, and configure online live class links.</p>
                </div>
            </div>

            <div class="row g-4">
                <!-- Create Class Form -->
                <div class="col-lg-7">
                    <div class="glass-card" style="background: linear-gradient(135deg, rgba(219, 39, 119, 0.05) 0%, rgba(0, 0, 0, 0) 100%);">
                        <h4 class="fw-700 mb-4"><i class="bi bi-plus-circle me-2 text-crimson"></i> Create New Class</h4>
                        <form action="${pageContext.request.contextPath}/marketplace/provider/classes/add" method="post">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label small text-muted text-uppercase fw-700">Class Title</label>
                                    <input type="text" name="className" class="form-control fdf-input" placeholder="e.g. Advanced Yoga for Beginners" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small text-muted text-uppercase fw-700">Duration</label>
                                    <input type="text" name="duration" class="form-control fdf-input" placeholder="Duration (e.g. 1.5h)" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small text-muted text-uppercase fw-700">Mode</label>
                                    <select name="mode" class="form-select fdf-input" required>
                                        <option value="Live">Live Session</option>
                                        <option value="Recorded">Recorded</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small text-muted text-uppercase fw-700">Category</label>
                                    <select name="category" class="form-select fdf-input" required>
                                        <option value="TUTOR">Tutor</option>
                                        <option value="HOME_BAKER">Home Baker</option>
                                        <option value="LANGUAGE_TRAINER">Language Trainer</option>
                                        <option value="WOMEN_PRODUCTS">Women Products</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small text-muted text-uppercase fw-700">Description</label>
                                    <textarea name="description" class="form-control fdf-input" placeholder="Briefly describe what you'll teach..." rows="3" required></textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small text-muted text-uppercase fw-700">Schedule Date & Time</label>
                                    <input type="datetime-local" name="dateTime" class="form-control fdf-input" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small text-muted text-uppercase fw-700">Meeting Link</label>
                                    <input type="url" name="meetingLink" class="form-control fdf-input" placeholder="Zoom/Meet Link" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small text-muted text-uppercase fw-700">Price (₹)</label>
                                    <input type="number" name="price" class="form-control fdf-input" placeholder="₹ 499.00" step="0.01" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small text-muted text-uppercase fw-700">Seat Capacity</label>
                                    <input type="number" name="seats" class="form-control fdf-input" placeholder="25 Seats" required>
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-premium w-100">Launch Class Now</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Active Classes List -->
                <div class="col-lg-5">
                    <div class="glass-card">
                        <div class="card-header-custom">
                            <h4>Active Classes</h4>
                            <span class="badge bg-purple-mid" style="background: var(--p-purple-mid); padding: 5px 12px; border-radius: 8px; font-size: 0.75rem;">${classes.size()} Total</span>
                        </div>
                        
                        <div style="max-height: 520px; overflow-y: auto; padding-right: 5px;">
                            <c:forEach var="c" items="${classes}">
                                <div class="class-item">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h6 class="m-0 fw-700">${c.className}</h6>
                                            <small class="text-muted">${c.dateTime}</small>
                                        </div>
                                        <span class="badge-${c.mode == 'Live' ? 'live' : 'rec'}">${c.mode}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="small fw-500 text-crimson-light">₹${c.price}</div>
                                        <div class="small text-muted"><i class="bi bi-people-fill me-1"></i> ${c.availableSeats} left</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty classes}">
                                <div class="text-center py-5">
                                    <p class="text-muted small m-0">No active classes yet.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. CLIENTS SECTION -->
        <div id="clients-section" class="dashboard-section" style="display: none;">
            <div class="top-nav">
                <div class="greeting">
                    <h2>My Clients & Students</h2>
                    <p class="text-muted m-0">Review 1-on-1 private sessions and track enrolled students across all classes.</p>
                </div>
            </div>

            <div class="row g-4">
                <!-- One-on-One Bookings Requests -->
                <div class="col-12">
                    <div class="glass-card">
                        <div class="card-header-custom">
                            <h4>One-on-One Sessions</h4>
                            <span class="badge bg-purple-mid" style="background: var(--p-purple-mid);">${bookings.size()} Requests</span>
                        </div>
                        
                        <c:if test="${empty bookings}">
                            <div class="text-center py-5">
                                <p class="text-muted small m-0">No private booking requests found.</p>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty bookings}">
                            <div class="table-responsive">
                                <table class="table premium-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Client</th>
                                            <th>Note/Request Details</th>
                                            <th>Schedule Time</th>
                                            <th>Status</th>
                                            <th style="min-width: 180px;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="b" items="${bookings}">
                                        <tr>
                                            <td>
                                                <div class="fw-600">${b.user.fullName}</div>
                                                <div class="small text-muted">#USR-${b.user.id}</div>
                                            </td>
                                            <td>
                                                <div class="small text-muted" style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${b.note}">${not empty b.note ? b.note : 'No session note provided'}</div>
                                            </td>
                                            <td>
                                                <div class="small fw-500">${b.requestedTime}</div>
                                            </td>
                                            <td>
                                                <span class="status-pill status-${b.status}">${b.status}</span>
                                            </td>
                                            <td id="booking-actions-${b.id}">
                                                <div class="d-flex flex-column gap-2">
                                                    <div class="d-flex gap-2 align-items-center">
                                                        <select class="form-select form-select-sm fdf-input" id="status-select-${b.id}" style="width: 120px; background-color: var(--p-purple-dark) !important; color: var(--p-text-main) !important; border: 1px solid var(--p-glass-border) !important;">
                                                            <option value="PENDING" ${b.status.name() == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                            <option value="CONFIRMED" ${b.status.name() == 'CONFIRMED' ? 'selected' : ''}>CONFIRM</option>
                                                            <option value="COMPLETED" ${b.status.name() == 'COMPLETED' ? 'selected' : ''}>COMPLETE</option>
                                                            <option value="CANCELLED" ${b.status.name() == 'CANCELLED' ? 'selected' : ''}>CANCEL</option>
                                                        </select>
                                                        <button class="btn btn-sm btn-premium py-1 px-3 d-flex align-items-center justify-content-center" onclick="updateStatus(${b.id})" title="Update Status"><i class="bi bi-check-lg" style="font-size: 1rem;"></i></button>
                                                    </div>
                                                    
                                                    <div id="comm-buttons-${b.id}" class="${b.status.name() == 'CONFIRMED' ? 'd-flex' : 'd-none'} gap-2">
                                                        <button class="btn btn-sm btn-info w-100 py-1 px-2 rounded-3 text-white" onclick="openChat(${b.id}, '${b.user.fullName}')">
                                                            <i class="bi bi-chat-dots-fill me-1"></i> Chat
                                                        </button>
                                                        <button class="btn btn-sm btn-danger w-100 py-1 px-2 rounded-3" onclick="startVideoCall(${b.id}, '${b.user.fullName}')">
                                                            <i class="bi bi-camera-video-fill me-1"></i> Video
                                                        </button>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Enrolled Class Students -->
                <div class="col-12">
                    <div class="glass-card">
                        <div class="card-header-custom">
                            <h4>Student Enrollments</h4>
                            <span class="badge bg-success" style="background: rgba(16, 185, 129, 0.1); color: #10B981; border: 1px solid rgba(16,185,129,0.2);">${enrollments.size()} Total</span>
                        </div>

                        <c:if test="${empty enrollments}">
                            <div class="text-center py-5">
                                <i class="bi bi-person-plus text-muted display-4 opacity-25"></i>
                                <p class="mt-3 text-muted">No students enrolled in your classes yet.</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty enrollments}">
                            <div class="table-responsive">
                                <table class="table premium-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Student</th>
                                            <th>Enrolled Class</th>
                                            <th>Enrollment Date</th>
                                            <th>Payment Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="e" items="${enrollments}">
                                        <tr>
                                            <td>
                                                <div class="fw-600">${e.user.fullName}</div>
                                                <div class="small text-muted">${e.user.email}</div>
                                            </td>
                                            <td>
                                                <div class="fw-500 text-crimson-light">${e.providerClass.className}</div>
                                            </td>
                                            <td>
                                                <div class="small">${e.enrollmentTime}</div>
                                            </td>
                                            <td>
                                                <span class="status-pill status-${e.paymentStatus}">${e.paymentStatus}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. EARNINGS SECTION -->
        <div id="earnings-section" class="dashboard-section" style="display: none;">
            <div class="top-nav">
                <div class="greeting">
                    <h2>Earnings Ledger & Payouts</h2>
                    <p class="text-muted m-0">Monitor class sales, completed booking logs, and request instant bank settlements.</p>
                </div>
            </div>

            <!-- Earnings stats -->
            <div class="stats-grid">
                <div class="stat-card" style="background: linear-gradient(135deg, rgba(219, 39, 119, 0.1) 0%, rgba(74, 30, 56, 0.3) 100%);">
                    <div class="stat-value">₹${totalEarnings}</div>
                    <div class="stat-label">Settled Revenue</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <c:set var="paidCount" value="0"/>
                        <c:forEach var="e" items="${enrollments}">
                            <c:if test="${e.paymentStatus == 'PAID'}">
                                <c:set var="paidCount" value="${paidCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${paidCount}
                    </div>
                    <div class="stat-label">Paid Class Bookings</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <c:set var="pendingCount" value="0"/>
                        <c:forEach var="e" items="${enrollments}">
                            <c:if test="${e.paymentStatus != 'PAID'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${pendingCount}
                    </div>
                    <div class="stat-label">Pending / Unpaid</div>
                </div>
            </div>

            <!-- Premium ledger -->
            <div class="glass-card">
                <div class="card-header-custom">
                    <h4>Premium Transaction Ledger</h4>
                    <span class="badge bg-success" style="background: rgba(16, 185, 129, 0.1); color: #10B981; border: 1px solid rgba(16, 185, 129, 0.2);">Verified Transactions</span>
                </div>

                <div class="table-responsive">
                    <table class="table premium-table align-middle">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Client/Student</th>
                                <th>Purchased Item</th>
                                <th>Billing Date</th>
                                <th>Settled Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPaid" value="false"/>
                            <c:forEach var="e" items="${enrollments}">
                                <c:if test="${e.paymentStatus == 'PAID'}">
                                    <c:set var="hasPaid" value="true"/>
                                    <tr>
                                        <td class="font-monospace text-crimson-light fw-600">TXN-ENR-${e.id}</td>
                                        <td>
                                            <div class="fw-600">${e.user.fullName}</div>
                                            <div class="small text-muted">${e.user.email}</div>
                                        </td>
                                        <td>
                                            <div class="fw-500">${e.providerClass.className}</div>
                                        </td>
                                        <td>
                                            <div class="small">${e.enrollmentTime}</div>
                                        </td>
                                        <td>
                                            <div class="fw-700">₹${e.providerClass.price}</div>
                                        </td>
                                        <td>
                                            <span class="status-pill status-PAID">SETTLED</span>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasPaid}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-cash-stack display-4 opacity-25"></i>
                                        <p class="mt-3">No paid transactions recorded yet.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Chat Modal -->
    <div class="modal fade comm-modal" id="chatModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content comm-content">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-700" id="chatPartnerName">Chat</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div id="chatArea" class="chat-area"></div>
                    <div class="p-4 pt-0">
                        <div class="input-group">
                            <input type="text" id="chatInput" class="form-control fdf-input" placeholder="Type a message...">
                            <button class="btn btn-premium px-4" onclick="sendMessage()"><i class="bi bi-send-fill"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Video Modal -->
    <div class="modal fade comm-modal" id="videoModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content comm-content">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-700">Video Call: <span id="videoPartnerName"></span></h5>
                    <div class="ms-auto me-3 fw-600 text-accent" id="callTimer">00:00</div>
                    <button type="button" class="btn-close btn-close-white" onclick="endCall()"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="video-container mb-4">
                        <video id="remoteVideo" autoplay playsinline></video>
                        <video id="localVideo" autoplay playsinline muted></video>
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <button id="muteBtn" class="btn btn-outline-light rounded-pill p-3" onclick="toggleMute()" title="Toggle Mute">
                            <i class="bi bi-mic-fill"></i>
                        </button>
                        <button id="videoBtn" class="btn btn-outline-light rounded-pill p-3" onclick="toggleVideo()" title="Toggle Video">
                            <i class="bi bi-camera-video-fill"></i>
                        </button>
                        <button class="btn btn-danger rounded-pill px-5 py-3 fw-700" onclick="endCall()">
                            <i class="bi bi-telephone-x-fill me-2"></i> End Call
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = '${pageContext.request.contextPath}';
        let stompClient = null;
        let currentBookingId = null;
        let localStream = null;
        let peerConnection = null;
        let callTimerInterval = null;
        let secondsElapsed = 0;
        let isMuted = false;
        let isVideoOff = false;
        let iceCandidatesQueue = [];
        const config = { 
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' }
            ] 
        };

        // Initialize WebSocket
        function initWebSocket(bookingId) {
            if (stompClient && currentBookingId === bookingId) return;
            
            if (stompClient) stompClient.disconnect();
            currentBookingId = bookingId;

            const socket = new SockJS(ctx + '/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;

            stompClient.connect({}, () => {
                stompClient.subscribe('/topic/marketplace-chat/' + bookingId, (payload) => {
                    const msg = JSON.parse(payload.body);
                    handleIncomingMessage(msg, bookingId);
                });
            });
        }

        function handleIncomingMessage(msg, bookingId) {
            if (msg.type === 'CHAT') {
                if (currentBookingId === bookingId) {
                    appendChatMessage(msg.content, msg.senderRole === 'PROVIDER' ? 'sent' : 'received');
                }
            } else if (msg.type === 'SIGNAL_OFFER') {
                currentBookingId = bookingId;
                handleOffer(msg.content);
            } else if (msg.type === 'SIGNAL_ANSWER') {
                handleAnswer(msg.content);
            } else if (msg.type === 'SIGNAL_ICE') {
                handleIceCandidate(msg.content);
            } else if (msg.type === 'END_CALL') {
                closeVideoModal();
            }
        }

        // --- Status Update ---
        function updateStatus(id) {
            const status = document.getElementById('status-select-' + id).value;
            fetch(ctx + '/marketplace/provider/bookings/' + id + '/status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'status=' + status
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload(); // Refresh to update badges and UI
                } else {
                    alert(data.message || 'Update failed');
                }
            });
        }

        // --- Chat Logic ---
        function openChat(bookingId, partnerName) {
            document.getElementById('chatPartnerName').innerText = partnerName;
            document.getElementById('chatArea').innerHTML = '';
            initWebSocket(bookingId);
            
            // Load history
            fetch(ctx + '/marketplace/chat-history/' + bookingId)
                .then(res => res.json())
                .then(history => {
                    history.forEach(msg => {
                        appendChatMessage(msg.content, msg.senderRole === 'PROVIDER' ? 'sent' : 'received');
                    });
                    new bootstrap.Modal(document.getElementById('chatModal')).show();
                });
        }

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content || !stompClient) return;

            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'CHAT',
                content: content,
                senderRole: 'PROVIDER'
            }));
            input.value = '';
        }

        function appendChatMessage(content, type) {
            const div = document.createElement('div');
            div.className = 'chat-msg ' + type;
            div.innerText = content;
            const area = document.getElementById('chatArea');
            area.appendChild(div);
            area.scrollTop = area.scrollHeight;
        }

        // --- Video Call Logic (WebRTC) ---
        async function startVideoCall(bookingId, partnerName) {
            document.getElementById('videoPartnerName').innerText = partnerName;
            initWebSocket(bookingId);
            const modal = new bootstrap.Modal(document.getElementById('videoModal'));
            modal.show();

            try {
                localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                document.getElementById('localVideo').srcObject = localStream;
                
                if (peerConnection) peerConnection.close();
                createPeerConnection();
                localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));

                const offer = await peerConnection.createOffer();
                await peerConnection.setLocalDescription(offer);

                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                    type: 'SIGNAL_OFFER',
                    content: JSON.stringify(offer)
                }));
            } catch (err) {
                console.error('Call failed', err);
                alert('Could not access camera/microphone. Please ensure you have granted permissions.');
                modal.hide();
            }
        }

        function createPeerConnection() {
            peerConnection = new RTCPeerConnection(config);
            iceCandidatesQueue = [];

            peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                        type: 'SIGNAL_ICE',
                        content: JSON.stringify(event.candidate)
                    }));
                }
            };

            peerConnection.ontrack = (event) => {
                const remoteVideo = document.getElementById('remoteVideo');
                if (event.streams && event.streams[0]) {
                    remoteVideo.srcObject = event.streams[0];
                } else {
                    let remoteStream = remoteVideo.srcObject;
                    if (!remoteStream) {
                        remoteStream = new MediaStream();
                        remoteVideo.srcObject = remoteStream;
                    }
                    remoteStream.addTrack(event.track);
                }
                remoteVideo.play().catch(e => console.warn("Auto-play blocked", e));
            };

            peerConnection.onconnectionstatechange = () => {
                if (peerConnection.connectionState === 'connected') {
                    startTimer();
                }
            };
        }

        async function handleOffer(content) {
            if (peerConnection) peerConnection.close();
            createPeerConnection();
            
            const offer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
            
            // Process queued candidates
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }

            if (!localStream) {
                try {
                    localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                    document.getElementById('localVideo').srcObject = localStream;
                    localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));
                    new bootstrap.Modal(document.getElementById('videoModal')).show();
                } catch (err) {
                    console.error('Failed to get media', err);
                }
            }

            const answer = await peerConnection.createAnswer();
            await peerConnection.setLocalDescription(answer);

            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'SIGNAL_ANSWER',
                content: JSON.stringify(answer)
            }));
        }

        async function handleAnswer(content) {
            const answer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(answer));
            
            // Process queued candidates
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }
        }

        async function handleIceCandidate(content) {
            const candidate = JSON.parse(content);
            if (peerConnection && peerConnection.remoteDescription) {
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            } else {
                iceCandidatesQueue.push(candidate);
            }
        }

        function toggleMute() {
            if (localStream) {
                isMuted = !isMuted;
                localStream.getAudioTracks().forEach(track => track.enabled = !isMuted);
                const btn = document.getElementById('muteBtn');
                btn.innerHTML = isMuted ? '<i class="bi bi-mic-mute-fill text-danger"></i>' : '<i class="bi bi-mic-fill"></i>';
                btn.classList.toggle('btn-outline-danger', isMuted);
            }
        }

        function toggleVideo() {
            if (localStream) {
                isVideoOff = !isVideoOff;
                localStream.getVideoTracks().forEach(track => track.enabled = !isVideoOff);
                const btn = document.getElementById('videoBtn');
                btn.innerHTML = isVideoOff ? '<i class="bi bi-camera-video-off-fill text-danger"></i>' : '<i class="bi bi-camera-video-fill"></i>';
                btn.classList.toggle('btn-outline-danger', isVideoOff);
            }
        }

        function startTimer() {
            if (callTimerInterval) return;
            secondsElapsed = 0;
            const timerEl = document.getElementById('callTimer');
            callTimerInterval = setInterval(() => {
                secondsElapsed++;
                const mins = Math.floor(secondsElapsed / 60).toString().padStart(2, '0');
                const secs = (secondsElapsed % 60).toString().padStart(2, '0');
                timerEl.innerText = mins + ':' + secs;
            }, 1000);
        }

        function endCall() {
            if (stompClient) {
                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({ type: 'END_CALL' }));
            }
            closeVideoModal();
        }

        function closeVideoModal() {
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
                localStream = null;
            }
            if (peerConnection) {
                peerConnection.close();
                peerConnection = null;
            }
            if (callTimerInterval) {
                clearInterval(callTimerInterval);
                callTimerInterval = null;
            }
            document.getElementById('callTimer').innerText = '00:00';
            // Reset buttons
            isMuted = false;
            isVideoOff = false;
            document.getElementById('muteBtn').innerHTML = '<i class="bi bi-mic-fill"></i>';
            document.getElementById('muteBtn').classList.remove('btn-outline-danger');
            document.getElementById('videoBtn').innerHTML = '<i class="bi bi-camera-video-fill"></i>';
            document.getElementById('videoBtn').classList.remove('btn-outline-danger');
            
            bootstrap.Modal.getInstance(document.getElementById('videoModal')).hide();
        }

        // JS Tabbed Navigation System for Premium Dashboard experience
        function showTab(tabId) {
            // Hide all dashboard sections
            document.querySelectorAll('.dashboard-section').forEach(section => {
                section.style.display = 'none';
            });
            
            // Show the selected section
            const targetSection = document.getElementById(tabId + '-section');
            if (targetSection) {
                targetSection.style.display = 'block';
            }
            
            // Remove active class from all nav items
            document.querySelectorAll('.sidebar-nav a').forEach(link => {
                link.classList.remove('active');
            });
            
            // Add active class to selected nav item
            const activeLink = document.getElementById('nav-' + tabId);
            if (activeLink) {
                activeLink.classList.add('active');
            }
            
            // Save state in sessionStorage so refresh maintains active tab!
            sessionStorage.setItem('provider_active_tab', tabId);
        }

        // Restore active tab on load
        document.addEventListener('DOMContentLoaded', function() {
            const activeTab = sessionStorage.getItem('provider_active_tab') || 'overview';
            showTab(activeTab);

            // Initialize WebSockets for all confirmed bookings to listen for calls
            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.status.name() == 'CONFIRMED'}">
                    initWebSocket(${b.id});
                </c:if>
            </c:forEach>
        });
    </script>
</body>
</html>

