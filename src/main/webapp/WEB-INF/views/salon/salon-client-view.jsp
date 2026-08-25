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
            --dashboard-bg: #f8f5ff;
            --brand-purple: #6a0dad;
            --brand-purple-darker: #4a0080;
            --gradient-dark: linear-gradient(135deg, #2b1055 0%, #7597de 100%);
            --fdf-border: #eee;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--brand-purple-darker);
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar */
        .sidebar {
            background: var(--gradient-dark);
            color: white;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            text-decoration: none;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            min-height: 100vh;
        }

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
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .glass-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            margin-bottom: 24px;
            height: 100%;
        }
        
        .profile-header-img {
            width: 120px;
            height: 120px;
            border-radius: 24px;
            object-fit: cover;
            border: 4px solid var(--dashboard-bg);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .nav-pills-custom .nav-link {
            color: #6c757d;
            font-weight: 600;
            border-radius: 50px;
            padding: 10px 24px;
            margin-right: 10px;
        }
        
        .nav-pills-custom .nav-link.active {
            background: var(--brand-purple);
            color: white;
        }
        
        .info-label {
            color: #6c757d;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--brand-purple-darker);
            margin-bottom: 20px;
        }
        
        .history-card {
            border-left: 4px solid var(--brand-purple);
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 0 12px 12px 0;
            margin-bottom: 15px;
            transition: all 0.2s;
        }
        
        .history-card:hover {
            background: white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transform: translateX(5px);
        }

        .btn-back {
            color: #6c757d;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            transition: all 0.2s;
        }
        
        .btn-back:hover {
            color: var(--brand-purple);
            transform: translateX(-5px);
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
                    <div class="glass-card">
                        <div class="text-center mb-4">
                            <img src="${not empty client.user.profilePhoto ? pageContext.request.contextPath.concat(client.user.profilePhoto) : 'https://ui-avatars.com/api/?name='.concat(client.user.fullName).concat('&background=6a0dad&color=fff&size=128')}" class="profile-header-img mb-3" alt="Profile">
                            <h3 class="fw-bold mb-1">${client.user.fullName}</h3>
                            <p class="text-muted"><i class="bi bi-telephone"></i> ${client.user.phoneNumber}</p>
                        </div>
                        
                        <hr class="text-muted">
                        
                        <h5 class="fw-bold mb-4">Contact Info</h5>
                        <div class="info-label">Email</div>
                        <div class="info-value">${not empty client.user.email ? client.user.email : 'N/A'}</div>
                        
                        <div class="info-label">Address</div>
                        <div class="info-value">${not empty client.user.homeAddress ? client.user.homeAddress : 'N/A'}</div>
                        
                        <div class="row">
                            <div class="col-6">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value">${not empty client.user.dob ? client.user.dob : 'N/A'}</div>
                            </div>
                            <div class="col-6">
                                <div class="info-label">Gender</div>
                                <div class="info-value">${not empty client.user.gender ? client.user.gender : 'N/A'}</div>
                            </div>
                        </div>
                        
                        <div class="info-label">Client Since</div>
                        <div class="info-value">
                            <fmt:parseDate value="${client.joinedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedJoinedDate" type="both" />
                            <fmt:formatDate pattern="dd MMM yyyy" value="${parsedJoinedDate}" />
                        </div>
                    </div>
                </div>
                
                <!-- Right Content: Stats & History -->
                <div class="col-xl-8">
                    
                    <!-- Stats -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="glass-card text-center" style="padding: 20px;">
                                <div class="info-label">Total Visits</div>
                                <div class="fs-1 fw-bold text-primary">${totalVisits}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="glass-card text-center" style="padding: 20px;">
                                <div class="info-label">Total Spent</div>
                                <div class="fs-1 fw-bold text-success">₹${totalSpent}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="glass-card text-center" style="padding: 20px;">
                                <div class="info-label">Avg. Spending</div>
                                <div class="fs-1 fw-bold text-warning">₹<fmt:formatNumber value="${avgSpent}" maxFractionDigits="2" /></div>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card">
                        <ul class="nav nav-pills nav-pills-custom mb-4" id="pills-tab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#pills-history" type="button">Visit History</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="pill" data-bs-target="#pills-notes" type="button">Notes & Preferences</button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="pills-tabContent">
                            
                            <!-- History Tab -->
                            <div class="tab-pane fade show active" id="pills-history">
                                <c:choose>
                                    <c:when test="${not empty bookings}">
                                        <c:forEach var="booking" items="${bookings}">
                                            <div class="history-card">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="badge ${booking.status == 'COMPLETED' ? 'bg-success' : 'bg-primary'}">${booking.status}</span>
                                                    <small class="text-muted fw-bold">
                                                        <fmt:parseDate value="${booking.dateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate pattern="dd MMM yyyy, hh:mm a" value="${parsedDate}" />
                                                    </small>
                                                </div>
                                                <div class="row align-items-center">
                                                    <div class="col-md-4">
                                                        <div class="info-label">Service</div>
                                                        <div class="fw-bold">${booking.serviceName}</div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="info-label">Stylist</div>
                                                        <div class="fw-bold">${booking.stylistName}</div>
                                                    </div>
                                                    <div class="col-md-4 text-md-end">
                                                        <div class="info-label">Price Paid</div>
                                                        <div class="fw-bold text-success fs-5">
                                                            <c:if test="${not empty booking.pricePaid}">₹${booking.pricePaid}</c:if>
                                                            <c:if test="${empty booking.pricePaid}">N/A</c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
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
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h5 class="fw-bold mb-0">Salon Notes</h5>
                                        <!-- Editable form could go here in future -->
                                    </div>
                                    <div class="p-4 rounded-3" style="background: #fff8e1; border-left: 4px solid #ffc107;">
                                        ${not empty client.clientNotes ? client.clientNotes : 'No notes added yet.'}
                                    </div>
                                </div>
                                
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h5 class="fw-bold mb-0">Client Preferences</h5>
                                    </div>
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

