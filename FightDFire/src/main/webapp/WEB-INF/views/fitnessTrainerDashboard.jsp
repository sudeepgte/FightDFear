<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trainer Studio - Dashboard</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --primary-purple: #1e1b4b; 
            --primary-purple-light: #312e81; 
            --primary-coral: #f43f5e; 
            --primary-teal: #20c997;
            --primary-gold: #ffd700;
            --light-bg: #f4f6fa;
            --shadow-sm: 0 4px 15px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 10px 30px rgba(0, 0, 0, 0.08);
            --sidebar-text: rgba(255, 255, 255, 0.7);
        }

        body {
            background: var(--light-bg);
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
            color: #1a1a2e;
        }

        /* === Sidebar Layout CSS === */
        #wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        
        #sidebar-wrapper {
            min-width: 260px;
            max-width: 260px;
            background: var(--primary-purple);
            color: white;
            transition: all 0.3s ease-in-out;
            min-height: calc(100vh - 80px); 
            z-index: 1000;
            position: sticky;
            top: 80px; 
            height: calc(100vh - 80px);
            overflow-y: auto;
            border-top-right-radius: 40px;
            padding-top: 20px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
        }
        
        #sidebar-wrapper::-webkit-scrollbar { width: 4px; }
        #sidebar-wrapper::-webkit-scrollbar-thumb { background-color: var(--primary-purple-light); border-radius: 10px; }
        
        .sidebar-heading {
            padding: 10px 25px 25px;
            font-size: 1.1rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .list-group-item {
            background: transparent;
            color: var(--sidebar-text);
            border: none;
            padding: 12px 25px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            text-decoration: none;
            cursor: pointer;
            width: 100%;
            text-align: left;
        }
        .list-group-item i { font-size: 1.1rem; width: 20px; text-align: center; }
        .list-group-item:hover, .list-group-item.active {
            color: white;
            background: transparent;
        }
        .list-group-item:hover::before, .list-group-item.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            height: 70%;
            width: 4px;
            background: var(--primary-coral);
            border-radius: 0 4px 4px 0;
        }

        #page-content-wrapper {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            padding: 25px 30px;
        }
        
        .dashboard-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .dashboard-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-purple);
            margin: 0;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .logout-btn {
            background: var(--primary-coral);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }
        .logout-btn:hover { background: #e11d48; color: white; transform: translateY(-2px); }

        .dashboard-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        /* Stat cards */
        .stat-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        .stat-card-new {
            background: white;
            border-radius: 20px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
            transition: transform 0.3s ease;
            border: 1px solid rgba(0,0,0,0.02);
        }
        .stat-card-new:hover { transform: translateY(-5px); box-shadow: var(--shadow-md); }
        .stat-icon-new {
            width: 60px;
            height: 60px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
        }
        .stat-info h3 { margin: 0; font-size: 1.8rem; font-weight: 800; color: var(--primary-purple); line-height: 1.2; }
        .stat-info p { margin: 0; font-size: 0.85rem; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Workspace Panels */
        .panel-new {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(0,0,0,0.02);
        }

        /* Lists & Forms */
        .list-item-box {
            border: 1.5px solid #f5f0f8;
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 16px;
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .list-item-box:hover { border-color: #d1d5db; }
        .btn-action { font-size: 0.85rem; font-weight: 600; border-radius: 20px; padding: 6px 20px; }
        .form-label { font-weight: 600; font-size: 0.85rem; color: #555; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .form-control, .form-select { border-radius: 12px; border: 1.5px solid #e2e8f0; padding: 12px; font-size: 0.95rem; }
        .form-control:focus, .form-select:focus { border-color: var(--primary-teal); box-shadow: 0 0 0 3px rgba(32,201,151,0.15); }
        .btn-submit { background: linear-gradient(135deg, var(--primary-teal), #10b981); color: white; border: none; border-radius: 12px; font-weight: 700; padding: 12px; transition: all 0.2s; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(16,185,129,0.3); color: white; }
        
        @media (max-width: 1200px) {
            #wrapper {
                flex-direction: column;
            }
            #sidebar-wrapper {
                min-width: 100%;
                max-width: 100%;
                height: auto;
                min-height: auto;
                position: relative;
                top: 0;
                border-top-right-radius: 0;
                border-bottom-left-radius: 30px;
                border-bottom-right-radius: 30px;
                padding-bottom: 20px;
            }
            #studioTab {
                flex-direction: row !important;
                flex-wrap: wrap;
                gap: 8px;
                padding: 10px 15px;
            }
            #studioTab .list-group-item {
                width: auto !important;
                padding: 8px 16px;
                border-radius: 20px;
                background: rgba(255,255,255,0.05);
                white-space: nowrap;
                display: inline-flex;
            }
            #studioTab .list-group-item::before {
                display: none !important;
            }
            #studioTab .list-group-item.active {
                background: var(--primary-coral);
                color: white;
            }
            #page-content-wrapper {
                padding: 20px 15px;
            }
            .dashboard-header-flex {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            .header-actions {
                width: 100%;
                justify-content: flex-end;
            }
        }
        @media (max-width: 768px) {
            .tab-pane#messagesContent .row {
                height: 800px !important;
                flex-direction: column;
            }
            .tab-pane#messagesContent .col-md-4 {
                height: 250px !important;
                border-bottom: 1px solid #dee2e6;
                border-right: none !important;
            }
            .tab-pane#messagesContent .col-md-8 {
                height: 550px !important;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-heart-pulse-fill text-warning"></i> Trainer Studio
        </div>
        <div class="nav flex-column nav-pills" id="studioTab" role="tablist">
            <button class="list-group-item active" id="requests-tab" data-bs-toggle="tab" data-bs-target="#requestsContent" type="button" role="tab">
                <i class="bi bi-bell-fill text-warning"></i> Booking Requests <span class="badge bg-warning text-dark ms-auto rounded-pill">${requests.size()}</span>
            </button>
            <button class="list-group-item" id="active-tab" data-bs-toggle="tab" data-bs-target="#activeContent" type="button" role="tab">
                <i class="bi bi-calendar3 text-info"></i> Upcoming Sessions <span class="badge bg-info text-white ms-auto rounded-pill">${activeBookings.size()}</span>
            </button>
            <button class="list-group-item" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completedContent" type="button" role="tab">
                <i class="bi bi-journal-check text-success"></i> Completed Classes
            </button>
            <button class="list-group-item" id="classes-tab" data-bs-toggle="tab" data-bs-target="#classesContent" type="button" role="tab">
                <i class="bi bi-people-fill" style="color: #a855f7;"></i> Manage Classes
            </button>
            <button class="list-group-item" id="messages-tab" data-bs-toggle="tab" data-bs-target="#messagesContent" type="button" role="tab">
                <i class="bi bi-chat-dots-fill text-danger"></i> Messages
            </button>
            <button class="list-group-item" id="schedule-tab" data-bs-toggle="tab" data-bs-target="#scheduleContent" type="button" role="tab">
                <i class="bi bi-gear-fill text-secondary"></i> Settings & Fees
            </button>
            <button class="list-group-item" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviewsContent" type="button" role="tab">
                <i class="bi bi-star-fill text-warning"></i> Feedback Ratings
            </button>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="dashboard-header-flex">
            <div>
                <h1 class="dashboard-title">Welcome back, ${trainer.fullName} 👋</h1>
                <p class="text-muted small mt-1 mb-0">Manage your schedule, classes, and coaching requests.</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/fitness/trainer/logout" class="logout-btn"><i class="bi bi-box-arrow-right me-1"></i> Logout</a>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show mb-4" style="border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <i class="bi bi-check-circle-fill me-2"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4" style="border-radius: 12px;">${error}</div>
        </c:if>

        <div class="dashboard-container">
            <!-- Analytics overview cards -->
            <div class="stat-cards-grid">
                <div class="stat-card-new">
                    <div class="stat-icon-new" style="background:#e6fcf5; color:var(--primary-teal);"><i class="bi bi-wallet2"></i></div>
                    <div class="stat-info">
                        <h3>₹${totalEarnings}</h3>
                        <p>Accumulated Earnings</p>
                    </div>
                </div>
                <div class="stat-card-new">
                    <div class="stat-icon-new" style="background:#eff6ff; color:#3b82f6;"><i class="bi bi-calendar-check"></i></div>
                    <div class="stat-info">
                        <h3>${activeBookings.size()}</h3>
                        <p>Active Classes Scheduled</p>
                    </div>
                </div>
                <div class="stat-card-new">
                    <div class="stat-icon-new" style="background:#fff7ed; color:#f97316;"><i class="bi bi-chat-left-heart"></i></div>
                    <div class="stat-info">
                        <h3>${reviews.size()}</h3>
                        <p>Coaching Reviews</p>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="panel-new tab-content" id="studioTabContent">
                
                <!-- BOOKING REQUESTS -->
                <div class="tab-pane fade show active" id="requestsContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark">Booking Requests</h4>
                    
                    <c:choose>
                        <c:when test="${empty requests}">
                            <div class="text-center py-5">
                                <i class="bi bi-inbox text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No pending booking requests currently.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${requests}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div>
                                        <h6 class="fw-bold mb-1">${r.user.fullName}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="badge bg-light border text-dark">${r.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-laptop me-1"></i> ${r.sessionType}</span>
                                        </div>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-event text-primary me-1"></i> ${r.bookingDate} @ ${r.bookingTime}</span>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${r.id}">
                                            <input type="hidden" name="action" value="APPROVE">
                                            <button type="submit" class="btn btn-success btn-action"><i class="bi bi-check-lg me-1"></i> Accept</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${r.id}">
                                            <input type="hidden" name="action" value="REJECT">
                                            <button type="submit" class="btn btn-outline-danger btn-action"><i class="bi bi-x-lg me-1"></i> Reject</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- UPCOMING SESSIONS -->
                <div class="tab-pane fade" id="activeContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark">Upcoming Coaching Classes</h4>
                    
                    <c:choose>
                        <c:when test="${empty activeBookings}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No upcoming scheduled classes currently.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${activeBookings}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div style="flex:1; min-width:250px;">
                                        <h6 class="fw-bold mb-1">${b.user.fullName}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">${b.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-broadcast me-1"></i> ${b.sessionType}</span>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">
                                                <c:choose>
                                                    <c:when test="${b.duration == 'SINGLE'}">Single Session</c:when>
                                                    <c:when test="${b.duration == 'MONTHLY'}">Monthly Package</c:when>
                                                    <c:when test="${b.duration == 'QUARTERLY'}">Quarterly Package</c:when>
                                                    <c:when test="${b.duration == 'HALF_YEAR'}">6 Months Package</c:when>
                                                    <c:when test="${b.duration == 'YEAR'}">1 Year Package</c:when>
                                                    <c:otherwise>Active Plan</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-muted small fw-medium mb-2"><i class="bi bi-calendar-check text-primary me-1"></i> Validity: ${b.startDate} to ${b.endDate} @ ${b.bookingTime}</div>
                                        
                                        <c:set var="pct" value="0" />
                                        <c:if test="${b.totalSessions > 0}">
                                            <c:set var="pct" value="${(b.completedSessions * 100) / b.totalSessions}" />
                                        </c:if>
                                        <div class="w-100" style="max-width:350px;">
                                            <div class="d-flex justify-content-between mb-1 small text-muted">
                                                <span>Progress</span>
                                                <span>${b.completedSessions} / ${b.totalSessions} Sessions</span>
                                            </div>
                                            <div class="progress" style="height: 6px; border-radius: 3px;">
                                                <div class="progress-bar bg-success" role="progressbar" style="width: ${pct}%" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${b.id}">
                                            <input type="hidden" name="action" value="COMPLETE">
                                            <button type="submit" class="btn btn-primary btn-action">
                                                <c:choose>
                                                    <c:when test="${b.totalSessions > 1}">
                                                        <i class="bi bi-check2-circle me-1"></i> Log Attended Session
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-check2-circle me-1"></i> Mark Completed
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- COMPLETED CLASSES -->
                <div class="tab-pane fade" id="completedContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark">Completed Session Logs</h4>
                    
                    <c:choose>
                        <c:when test="${empty completed}">
                            <div class="text-center py-5">
                                <i class="bi bi-journal-x text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No historical completed classes.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${completed}">
                                <div class="list-item-box d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-bold mb-1">${b.user.fullName}</h6>
                                        <span class="badge bg-light border text-dark me-2">${b.category}</span>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-event text-secondary me-1"></i> ${b.bookingDate}</span>
                                    </div>
                                    <div>
                                        <span class="badge bg-success px-3 py-2" style="font-size:0.85rem;"><i class="bi bi-check-lg me-1"></i> +₹${b.paymentAmount}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- MANAGE GROUP CLASSES -->
                <div class="tab-pane fade" id="classesContent" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark mb-0">Scheduled Group Classes</h4>
                        <button class="btn btn-submit btn-sm px-3" data-bs-toggle="modal" data-bs-target="#createClassModal"><i class="bi bi-plus-lg"></i> New Class</button>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty trainerClasses}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-event text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No scheduled group classes yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="fc" items="${trainerClasses}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div>
                                        <h6 class="fw-bold mb-1">${fc.className}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25">${fc.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-clock me-1"></i> ${fc.durationMinutes} mins</span>
                                            <span class="badge ${fc.currentEnrollment >= fc.maxCapacity ? 'bg-danger' : 'bg-success'} text-white px-2 rounded-pill small">${fc.currentEnrollment} / ${fc.maxCapacity} Enrolled</span>
                                        </div>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-check text-primary me-1"></i> ${fc.classDate} @ ${fc.formattedClassTime}</span>
                                    </div>
                                    <div class="fw-bold text-success fs-5 d-flex flex-column align-items-end gap-2">
                                        <div>₹${fc.price}</div>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-sm btn-outline-primary edit-class-btn"
                                                    data-id="${fc.id}"
                                                    data-name="${fc.className}"
                                                    data-category="${fc.category}"
                                                    data-description="${fc.description}"
                                                    data-date="${fc.classDate}"
                                                    data-time="${fc.classTime}"
                                                    data-duration="${fc.durationMinutes}"
                                                    data-type="${fc.sessionType}"
                                                    data-capacity="${fc.maxCapacity}"
                                                    data-price="${fc.price}"
                                                    data-location="${fc.meetingLinkOrLocation}"
                                                    style="border-radius: 20px; font-size: 0.8rem; font-weight:600; padding:4px 12px;">
                                                <i class="bi bi-pencil-fill"></i> Edit
                                            </button>
                                            <form action="${pageContext.request.contextPath}/fitness/trainer/class/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete this class? This will refund all enrolled students.');" class="m-0">
                                                <input type="hidden" name="classId" value="${fc.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" style="border-radius: 20px; font-size: 0.8rem; font-weight:600; padding:4px 12px;">
                                                    <i class="bi bi-trash-fill"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Embedded Attendees List -->
                                <div class="bg-light p-3 rounded-bottom-4 border border-top-0 mt-[-10px] mb-4">
                                    <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-people-fill text-primary me-2"></i> Registered Attendees</h6>
                                    <c:set var="attendees" value="${classAttendees[fc.id]}" />
                                    <c:choose>
                                        <c:when test="${empty attendees}">
                                            <p class="text-muted small mb-0 fw-medium"><i class="bi bi-info-circle me-1"></i> No one has registered for this class yet.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive bg-white border rounded-3 p-2">
                                                <table class="table table-sm table-borderless align-middle mb-0">
                                                    <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                                        <tr>
                                                            <th class="ps-3">Student Name</th>
                                                            <th>Email Address</th>
                                                            <th>Phone Number</th>
                                                            <th>Payment Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody style="font-size: 0.9rem;">
                                                        <c:forEach var="booking" items="${attendees}">
                                                            <tr style="border-bottom: 1px solid #f8f9fa;">
                                                                <td class="fw-bold text-dark ps-3 py-2">
                                                                    <i class="bi bi-person-circle text-secondary me-2 fs-5 align-middle"></i>${booking.user.fullName}
                                                                </td>
                                                                <td class="text-muted">${booking.user.email}</td>
                                                                <td class="text-muted">${booking.user.phoneNumber != null ? booking.user.phoneNumber : '<span class="text-white-50">N/A</span>'}</td>
                                                                <td><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1"><i class="bi bi-check-circle-fill me-1"></i> Paid</span></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- SCHEDULE & CONFIG -->
                <div class="tab-pane fade" id="scheduleContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark">Schedule & Fees Configuration</h4>
                    
                    <form action="${pageContext.request.contextPath}/fitness/trainer/update-schedule" method="POST">
                        <div class="mb-4">
                            <label class="form-label">Session Fees (₹ per Class)</label>
                            <input type="number" name="sessionFees" class="form-control" value="${trainer.sessionFees}" min="0" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Available Hours</label>
                            <input type="text" name="availableTimings" class="form-control" value="${trainer.availableTimings}" required>
                            <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Example: "09:00 - 13:00, 16:00 - 20:00"</div>
                        </div>

                        <div class="mb-5">
                            <label class="form-label">Coaching Specialties</label>
                            <select name="specializations" class="form-select" multiple required style="height: 180px;">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${trainer.specializations.contains(cat) ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                            <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Hold Ctrl/Cmd to select multiple categories.</div>
                        </div>

                        <button type="submit" class="btn btn-submit w-100"><i class="bi bi-save2-fill me-1"></i> Save Configuration</button>
                    </form>
                </div>

                <!-- RATINGS FEEDBACK -->
                <div class="tab-pane fade" id="reviewsContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark">Client Feedback & Ratings</h4>
                    
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="text-center py-5">
                                <i class="bi bi-star text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No client reviews submitted yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reviews}">
                                <div class="list-item-box bg-light border-0">
                                    <div class="d-flex justify-content-between mb-2">
                                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-person-circle text-secondary me-2"></i>${r.booking.user.fullName}</h6>
                                        <span class="text-warning small">
                                            <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                        </span>
                                    </div>
                                    <p class="text-muted small mb-0 ps-4">"${r.comment}"</p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- MESSAGES -->
                <div class="tab-pane fade" id="messagesContent" role="tabpanel">
                    <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-chat-dots text-danger me-2"></i> Client Messages</h4>
                    <div class="row g-0 border rounded-4 overflow-hidden bg-white shadow-sm" style="height: 600px;">
                        <!-- Contacts List -->
                        <div class="col-md-4 border-end bg-light overflow-auto h-100">
                            <div class="p-3 border-bottom bg-white sticky-top z-2 shadow-sm">
                                <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-people-fill text-primary me-2"></i> Your Clients</h6>
                            </div>
                            <c:choose>
                                <c:when test="${empty chatUsers}">
                                    <div class="p-5 text-center text-muted">
                                        <i class="bi bi-person-x opacity-25" style="font-size: 3rem;"></i>
                                        <p class="small mt-2 fw-medium">No clients available to chat yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group list-group-flush" id="chatContactList">
                                        <c:forEach var="u" items="${chatUsers}">
                                            <button class="list-group-item list-group-item-action d-flex align-items-center gap-3 p-3 chat-contact-btn border-bottom" 
                                                    onclick="loadChat(${u.id}, ${trainer.id}, '${u.fullName}')">
                                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; min-width: 45px;">
                                                    <i class="bi bi-person-fill fs-5"></i>
                                                </div>
                                                <div class="text-truncate">
                                                    <h6 class="mb-1 fw-bold text-dark">${u.fullName}</h6>
                                                    <small class="text-muted text-truncate d-block"><i class="bi bi-envelope me-1"></i>${u.email}</small>
                                                </div>
                                            </button>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Chat Box -->
                        <div class="col-md-8 d-flex flex-column h-100 position-relative bg-white" id="chatBoxArea">
                            <!-- Empty State -->
                            <div class="d-flex flex-column align-items-center justify-content-center h-100 text-muted" id="chatEmptyState">
                                <i class="bi bi-chat-heart text-light" style="font-size: 6rem;"></i>
                                <h5 class="mt-3 fw-bold text-secondary">Your Messages</h5>
                                <p class="fw-medium">Select a client from the left to start chatting</p>
                            </div>
                            
                            <!-- Active Chat -->
                            <div id="activeChatArea" class="d-none flex-column h-100">
                                <!-- Chat Header -->
                                <div class="p-3 border-bottom bg-white d-flex align-items-center gap-3 shadow-sm z-1">
                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-5"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-0 fw-bold text-dark" id="chatUserName">Client Name</h5>
                                        <small class="text-success fw-medium"><i class="bi bi-circle-fill text-success" style="font-size:0.5rem; vertical-align: middle;"></i> Connected</small>
                                    </div>
                                </div>
                                
                                <!-- Chat Messages -->
                                <div class="flex-grow-1 p-4 overflow-auto" id="chatMessages" style="background-color: #f0f2f5;">
                                    <!-- Messages loaded via JS -->
                                </div>
                                
                                <!-- Chat Input -->
                                <div class="p-3 border-top bg-white">
                                    <form id="chatForm" onsubmit="sendMessage(event)" class="d-flex gap-2">
                                        <input type="hidden" id="chatUserId">
                                        <input type="hidden" id="chatTrainerId" value="${trainer.id}">
                                        <input type="text" id="chatInput" class="form-control rounded-pill bg-light border-0 px-4 py-2" placeholder="Type your message here..." required autocomplete="off">
                                        <button type="submit" class="btn btn-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; min-width: 45px;">
                                            <i class="bi bi-send-fill ms-1"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Create Class Modal -->
<div class="modal fade" id="createClassModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-plus-circle-fill text-primary me-2"></i> Create New Class</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form id="createClassForm" action="${pageContext.request.contextPath}/fitness/trainer/class/create" method="POST" onsubmit="return validateCreateClassForm()">
          <div class="modal-body p-4">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Class Name</label>
                    <input type="text" name="className" class="form-control" required placeholder="e.g. Morning Power Yoga">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-select" required>
                        <option value="" disabled selected>Select Category</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="2" required placeholder="What will attendees learn?" maxlength="2000"></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date</label>
                    <input type="date" name="classDate" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Time</label>
                    <input type="time" name="classTime" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Duration (Mins)</label>
                    <input type="number" name="durationMinutes" class="form-control" required value="60">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Format</label>
                    <select name="sessionType" class="form-select" required>
                        <option value="ONLINE">Online</option>
                        <option value="OFFLINE">In-Person</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Max Capacity</label>
                    <input type="number" name="maxCapacity" class="form-control" required value="10" min="1" max="9999">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" name="price" class="form-control" required value="500" min="0.01" max="999999" step="0.01">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Location Address / Zoom Link</label>
                    <input type="text" name="meetingLinkOrLocation" class="form-control" required>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Create Class</button>
          </div>
      </form>
    </div>
  </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Class Modal -->
<div class="modal fade" id="editClassModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i> Edit Class</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form id="editClassForm" action="${pageContext.request.contextPath}/fitness/trainer/class/edit" method="POST" onsubmit="return validateEditClassForm()">
          <div class="modal-body p-4">
            <input type="hidden" name="classId" id="editClassId">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Class Name</label>
                    <input type="text" name="className" id="editClassName" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="category" id="editClassCategory" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" id="editClassDescription" class="form-control" rows="2" required maxlength="2000"></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date</label>
                    <input type="date" name="classDate" id="editClassDate" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Time</label>
                    <input type="time" name="classTime" id="editClassTime" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Duration (Mins)</label>
                    <input type="number" name="durationMinutes" id="editClassDuration" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Format</label>
                    <select name="sessionType" id="editClassType" class="form-select" required>
                        <option value="ONLINE">Online</option>
                        <option value="OFFLINE">In-Person</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Max Capacity</label>
                    <input type="number" name="maxCapacity" id="editClassCapacity" class="form-control" required min="1" max="9999">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" name="price" id="editClassPrice" class="form-control" required min="0.01" max="999999" step="0.01">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Location Address / Zoom Link</label>
                    <input type="text" name="meetingLinkOrLocation" id="editClassLocation" class="form-control" required>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Update Class</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Chat Script for Trainer -->
<script>
    let chatPollingInterval;

    function loadChat(userId, trainerId, userName) {
        // UI Updates
        document.getElementById('chatEmptyState').classList.add('d-none');
        document.getElementById('activeChatArea').classList.remove('d-none');
        document.getElementById('activeChatArea').classList.add('d-flex');
        document.getElementById('chatUserName').innerText = userName;
        document.getElementById('chatUserId').value = userId;

        // Highlight active contact
        document.querySelectorAll('.chat-contact-btn').forEach(btn => btn.classList.remove('active', 'bg-primary', 'text-white'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active', 'bg-primary', 'text-white');
        }

        fetchChatMessages(userId, trainerId);

        // Start polling
        if(chatPollingInterval) clearInterval(chatPollingInterval);
        chatPollingInterval = setInterval(() => fetchChatMessages(userId, trainerId, false), 3000);
    }

    function fetchChatMessages(userId, trainerId, scrollToBottom = true) {
        fetch(`${pageContext.request.contextPath}/api/fitness/chat/` + userId + `/` + trainerId)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById('chatMessages');
                
                // Keep track of scroll to see if user is already at the bottom
                const isAtBottom = chatBox.scrollHeight - chatBox.scrollTop === chatBox.clientHeight;

                chatBox.innerHTML = '';
                
                data.forEach(msg => {
                    const isMe = (msg.senderType === 'TRAINER');
                    const align = isMe ? 'justify-content-end' : 'justify-content-start';
                    const bgClass = isMe ? 'text-white' : 'bg-white text-dark border shadow-sm';
                    
                    // Realistic Chat Bubble Styling
                    const customBg = isMe ? 'background: linear-gradient(135deg, #0ea5e9, #2563eb);' : '';
                    const radiusClass = isMe ? 'border-radius: 18px 18px 0px 18px;' : 'border-radius: 18px 18px 18px 0px;';
                    
                    const dateObj = new Date(msg.timestamp);
                    const timeString = isNaN(dateObj) ? '' : dateObj.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                    
                    const msgElement = `
                        <div class="d-flex mb-3 `+align+`">
                            <div class="p-3 `+bgClass+`" style="`+customBg+` `+radiusClass+` max-width: 85%; line-height: 1.4;">
                                <p class="mb-1" style="font-size: 0.95rem;">`+msg.message+`</p>
                                <small class="d-block `+(isMe ? 'text-white-50' : 'text-muted')+` text-end" style="font-size: 0.7rem; margin-top: 4px;">`+timeString+`</small>
                            </div>
                        </div>
                    `;
                    chatBox.innerHTML += msgElement;
                });
                
                if (scrollToBottom || isAtBottom) {
                    chatBox.scrollTop = chatBox.scrollHeight;
                }
            })
            .catch(err => console.error("Error fetching messages:", err));
    }

    function sendMessage(e) {
        e.preventDefault();
        const userId = document.getElementById('chatUserId').value;
        const trainerId = document.getElementById('chatTrainerId').value;
        const input = document.getElementById('chatInput');
        const message = input.value;

        if(!message.trim()) return;

        const formData = new URLSearchParams();
        formData.append('userId', userId);
        formData.append('trainerId', trainerId);
        formData.append('message', message);

        fetch(`${pageContext.request.contextPath}/api/fitness/chat/send`, {
            method: 'POST',
            body: formData,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => {
            if(res.ok) {
                input.value = '';
                fetchChatMessages(userId, trainerId, true);
            }
        });
    }
    function validateCreateClassForm() {
        const maxCapacityInput = document.querySelector('#createClassModal input[name="maxCapacity"]');
        const priceInput = document.querySelector('#createClassModal input[name="price"]');
        
        if (maxCapacityInput) {
            const val = parseInt(maxCapacityInput.value, 10);
            if (isNaN(val) || val < 1 || val > 9999) {
                alert("Please enter a logical Maximum Capacity between 1 and 9,999.");
                maxCapacityInput.focus();
                return false;
            }
        }
        
        if (priceInput) {
            const val = parseFloat(priceInput.value);
            if (isNaN(val) || val < 0.01 || val > 999999) {
                alert("Please enter a logical Price between ₹0.01 and ₹999,999.");
                priceInput.focus();
                return false;
            }
        }
        return true;
    }

    document.querySelectorAll('.edit-class-btn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editClassId').value = this.dataset.id;
            document.getElementById('editClassName').value = this.dataset.name;
            document.getElementById('editClassCategory').value = this.dataset.category;
            document.getElementById('editClassDescription').value = this.dataset.description;
            document.getElementById('editClassDate').value = this.dataset.date;
            document.getElementById('editClassTime').value = this.dataset.time;
            document.getElementById('editClassDuration').value = this.dataset.duration;
            document.getElementById('editClassType').value = this.dataset.type;
            document.getElementById('editClassCapacity').value = this.dataset.capacity;
            document.getElementById('editClassPrice').value = this.dataset.price;
            document.getElementById('editClassLocation').value = this.dataset.location;
            
            const editModal = new bootstrap.Modal(document.getElementById('editClassModal'));
            editModal.show();
        });
    });

    function validateEditClassForm() {
        const maxCapacityInput = document.querySelector('#editClassModal input[name="maxCapacity"]');
        const priceInput = document.querySelector('#editClassModal input[name="price"]');
        
        if (maxCapacityInput) {
            const val = parseInt(maxCapacityInput.value, 10);
            if (isNaN(val) || val < 1 || val > 9999) {
                alert("Please enter a logical Maximum Capacity between 1 and 9,999.");
                maxCapacityInput.focus();
                return false;
            }
        }
        
        if (priceInput) {
            const val = parseFloat(priceInput.value);
            if (isNaN(val) || val < 0.01 || val > 999999) {
                alert("Please enter a logical Price between ₹0.01 and ₹999,999.");
                priceInput.focus();
                return false;
            }
        }
        return true;
    }
</script>

</body>
</html>
