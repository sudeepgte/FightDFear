<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${client.user.fullName} | Client Profile</title>

    <!-- Google Fonts -->
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${client.user.fullName} | Client Profile</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f9fa;
            --fdf-border: #eee;
            --theme-red: #ff4d6d;
            --theme-green: #00b894;
            --theme-orange: #fd7e14;
            --text-dark: #2d3436;
            --text-muted: #636e72;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--text-dark);
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar (kept as requested) */
        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 10px 0 30px rgba(0,0,0,0.1);
                background: linear-gradient(135deg, #2b1055 0%, #7597de 100%);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .main-content {
            padding: 40px;
            min-height: 100vh;
            background-color: #fcfcfc;
            /* Dotted pattern in top right */
            background-image: radial-gradient(#d1d1d1 2px, transparent 2px);
            background-size: 20px 20px;
            background-position: top right;
            background-repeat: no-repeat;
        }

        .glass-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }

        /* Profile Card Specifics */
        .profile-card {
            text-align: center;
            padding: 0;
        }

        .profile-card-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 180px;
            background: radial-gradient(circle at top left, rgba(255, 77, 109, 0.15) 0%, transparent 60%);
            z-index: 0;
        }
        
        .profile-card-content {
            position: relative;
            z-index: 1;
            padding: 30px;
        }

        .profile-header-img {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--theme-red);
            padding: 3px;
            background: white;
            margin-bottom: 15px;
        }

        .profile-name {
            font-size: 1.6rem;
            font-weight: 800;
            color: #2b2b2b;
            margin-bottom: 5px;
        }

        .profile-phone {
            color: var(--text-muted);
            font-size: 1rem;
            font-weight: 600;
        }

        /* Contact Info Section */
        .contact-info-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            color: #2b2b2b;
            font-size: 1.1rem;
            margin-top: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f1f2f6;
        }
        
        .contact-info-title i {
            color: var(--theme-red);
            background: #ffe6eb;
            padding: 8px 10px;
            border-radius: 10px;
            font-size: 1.2rem;
        }

        .info-row {
            display: flex;
            align-items: flex-start;
            margin-bottom: 22px;
        }

        .info-icon {
            color: var(--theme-red);
            font-size: 1.2rem;
            margin-right: 15px;
            margin-top: 2px;
            width: 24px;
            text-align: center;
        }

        .info-details {
            flex-grow: 1;
            text-align: left;
        }

        .info-label {
            color: #95a5a6;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .info-value {
            font-weight: 600;
            font-size: 1rem;
            color: #2d3436;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 22px;
        }

        /* Stat Cards */
        .stat-card {
            display: flex;
            align-items: center;
            padding: 25px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            height: 100%;
        }

        .stat-icon-box {
            width: 65px;
            height: 65px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-right: 20px;
            flex-shrink: 0;
        }

        .stat-red { background: #ffe6eb; color: var(--theme-red); }
        .stat-green { background: #e6f8f3; color: var(--theme-green); }
        .stat-orange { background: #fff2e6; color: var(--theme-orange); }

        .stat-details {
            display: flex;
            flex-direction: column;
        }

        .stat-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #95a5a6;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
        }

        .stat-value.red { color: var(--theme-red); }
        .stat-value.green { color: var(--theme-green); }
        .stat-value.orange { color: var(--theme-orange); }

        /* Tabs */
        .nav-pills-custom {
            border-bottom: 1px solid #f1f2f6;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        
        .nav-pills-custom .nav-link {
            color: #95a5a6;
            font-weight: 600;
            border-radius: 8px;
            padding: 8px 20px;
            margin-right: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
            background: transparent;
        }

        .nav-pills-custom .nav-link.active {
            background: var(--theme-red);
            color: white;
            border-radius: 8px;
        }

        /* Timeline History */
        .timeline {
            position: relative;
            padding-left: 20px;
            margin-left: 10px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 5px;
            bottom: 20px;
            width: 2px;
            background: #f1f2f6;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 25px;
        }

        .timeline-dot {
            position: absolute;
            left: -27px;
            top: 15px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: white;
            border: 3px solid;
            z-index: 2;
        }

        .status-confirmed .timeline-dot { border-color: var(--theme-red); }
        .status-pending .timeline-dot { border-color: var(--theme-orange); }
        .status-completed .timeline-dot { border-color: var(--theme-green); }

        .history-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            border-left: 4px solid;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }

        .status-confirmed .history-card { border-left-color: var(--theme-red); }
        .status-pending .history-card { border-left-color: var(--theme-orange); }
        .status-completed .history-card { border-left-color: var(--theme-green); }

        .history-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .badge-status {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-status.confirmed { background: var(--theme-red); color: white; }
        .badge-status.pending { background: var(--theme-orange); color: white; }
        .badge-status.completed { background: var(--theme-green); color: white; }

        .history-date {
            font-size: 0.85rem;
            font-weight: 700;
            color: #636e72;
        }

        .history-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .history-col {
            display: flex;
            flex-direction: column;
        }

        .history-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #95a5a6;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .history-val {
            font-size: 0.95rem;
            font-weight: 700;
            color: #2d3436;
        }

        .history-val.price {
            color: var(--theme-green);
        }

        /* Back Button */
        .btn-back {
            color: var(--theme-red);
            text-decoration: none;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 25px;
            transition: all 0.2s;
            background: white;
            padding: 8px 16px;
            border-radius: 50px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .btn-back:hover {
            transform: translateX(-5px);
            color: var(--theme-red);
        }
    </style>

    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="../fragments/salon-sidebar.jsp">
        <jsp:param name="activeNav" value="clients"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <a href="${pageContext.request.contextPath}/salon/clients" class="btn-back">
                <i class="bi bi-arrow-left"></i> Back to Clients
            </a>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="row g-4">
                <!-- Left Sidebar: Basic Info -->
                <div class="col-xl-4">
                    <div class="glass-card profile-card">
                        <div class="profile-card-bg"></div>
                        <div class="profile-card-content">
                            <div class="text-center">
                                <img src="${not empty client.user.profilePhoto ? pageContext.request.contextPath.concat(client.user.profilePhoto) : 'https://ui-avatars.com/api/?name='.concat(client.user.fullName).concat('&background=ff4d6d&color=fff&size=128')}" class="profile-header-img" alt="Profile">
                                <h3 class="profile-name">${client.user.fullName}</h3>
                                <div class="profile-phone"><i class="bi bi-telephone"></i> ${client.user.phoneNumber}</div>
                            </div>
                            
                            <div class="contact-info-title">
                                <i class="bi bi-person"></i> Contact Info
                            </div>
                            
                            <div class="info-row">
                                <i class="bi bi-envelope info-icon"></i>
                                <div class="info-details">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">${not empty client.user.email ? client.user.email : 'N/A'}</div>
                                </div>
                            </div>
                            
                            <div class="info-row">
                                <i class="bi bi-geo-alt info-icon"></i>
                                <div class="info-details">
                                    <div class="info-label">Address</div>
                                    <div class="info-value">${not empty client.user.homeAddress ? client.user.homeAddress : 'N/A'}</div>
                                </div>
                            </div>
                            
                            <div class="info-grid">
                                <div class="info-row" style="margin-bottom:0;">
                                    <i class="bi bi-calendar3 info-icon"></i>
                                    <div class="info-details">
                                        <div class="info-label">Date of Birth</div>
                                        <div class="info-value">${not empty client.user.dob ? client.user.dob : 'N/A'}</div>
                                    </div>
                                </div>
                                <div class="info-row" style="margin-bottom:0;">
                                    <i class="bi bi-person info-icon"></i>
                                    <div class="info-details">
                                        <div class="info-label">Gender</div>
                                        <div class="info-value">${not empty client.user.gender ? client.user.gender : 'N/A'}</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="info-row mt-3">
                                <i class="bi bi-calendar2-check info-icon"></i>
                                <div class="info-details">
                                    <div class="info-label">Client Since</div>
                                    <div class="info-value">
                                        <fmt:parseDate value="${client.joinedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedJoinedDate" type="both" />
                                        <fmt:formatDate pattern="dd MMM yyyy" value="${parsedJoinedDate}" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Right Content: Stats & History -->
                <div class="col-xl-8">
                    
                    <!-- Stats -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-icon-box stat-red">
                                    <i class="bi bi-eye"></i>
                                </div>
                                <div class="stat-details">
                                    <div class="stat-label">Total Visits</div>
                                    <div class="stat-value red">${totalVisits}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-icon-box stat-green">
                                    <i class="bi bi-wallet2"></i>
                                </div>
                                <div class="stat-details">
                                    <div class="stat-label">Total Spent</div>
                                    <div class="stat-value green">₹${totalSpent}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-icon-box stat-orange">
                                    <i class="bi bi-pie-chart"></i>
                                </div>
                                <div class="stat-details">
                                    <div class="stat-label">Avg. Spending</div>
                                    <div class="stat-value orange">₹<fmt:formatNumber value="${avgSpent}" maxFractionDigits="2" /></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card">
                        <ul class="nav nav-pills nav-pills-custom" id="pills-tab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#pills-history" type="button">
                                    <i class="bi bi-graph-up-arrow"></i> Visit History
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="pill" data-bs-target="#pills-notes" type="button">
                                    <i class="bi bi-file-earmark-text"></i> Notes & Preferences
                                </button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="pills-tabContent">
                            
                            <!-- History Tab -->
                            <div class="tab-pane fade show active" id="pills-history">
                                <c:choose>
                                    <c:when test="${not empty bookings}">
                                        <div class="timeline">
                                            <c:forEach var="booking" items="${bookings}">
                                                <c:set var="statusClass" value=""/>
                                                <c:set var="displayStatus" value="${booking.status}"/>
                                                
                                                <c:if test="${booking.status == 'COMPLETED'}"><c:set var="statusClass" value="status-completed"/></c:if>
                                                <c:if test="${booking.status == 'PENDING'}"><c:set var="statusClass" value="status-pending"/></c:if>
                                                <c:if test="${booking.status == 'CONFIRMED' || booking.status == 'ACCEPTED'}"><c:set var="statusClass" value="status-confirmed"/></c:if>
                                                <c:if test="${empty statusClass}"><c:set var="statusClass" value="status-confirmed"/></c:if>

                                                <div class="timeline-item ${statusClass}">
                                                    <div class="timeline-dot"></div>
                                                    <div class="history-card">
                                                        <div class="history-card-header">
                                                            <span class="badge-status ${statusClass eq 'status-completed' ? 'completed' : (statusClass eq 'status-pending' ? 'pending' : 'confirmed')}">${booking.status}</span>
                                                            <div class="history-date">
                                                                <fmt:parseDate value="${booking.dateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                                <fmt:formatDate pattern="dd MMM yyyy, hh:mm a" value="${parsedDate}" />
                                                            </div>
                                                        </div>
                                                        <div class="history-grid">
                                                            <div class="history-col">
                                                                <div class="history-label">Service</div>
                                                                <div class="history-val">${booking.serviceName}</div>
                                                            </div>
                                                            <div class="history-col">
                                                                <div class="history-label">Stylist</div>
                                                                <div class="history-val">${booking.stylistName}</div>
                                                            </div>
                                                            <div class="history-col">
                                                                <div class="history-label text-end">Price Paid</div>
                                                                <div class="history-val price text-end">
                                                                    <c:if test="${not empty booking.pricePaid}">₹${booking.pricePaid}</c:if>
                                                                    <c:if test="${empty booking.pricePaid}">N/A</c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="bi bi-calendar-x text-muted" style="font-size: 3rem;"></i>
                                            <h5 class="mt-3 fw-bold">No History</h5>
                                            <p class="text-muted">This client has not made any bookings yet.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- Notes Tab -->
                            <div class="tab-pane fade" id="pills-notes">
                                <div class="mb-4 mt-3">
                                    <h5 class="fw-bold mb-3">Salon Notes</h5>
                                    <div class="p-4 rounded-3" style="background: #fff8e1; border-left: 4px solid #ffc107;">
                                        ${not empty client.clientNotes ? client.clientNotes : 'No notes added yet.'}
                                    </div>
                                </div>
                                
                                <div>
                                    <h5 class="fw-bold mb-3">Client Preferences</h5>
                                    <div class="p-4 rounded-3" style="background: #e3f2fd; border-left: 4px solid #2196f3;">
                                        ${not empty client.preferences ? client.preferences : 'No preferences added yet.'}
                                    </div>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
