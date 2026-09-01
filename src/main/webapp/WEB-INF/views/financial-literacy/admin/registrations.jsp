<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Workshop & Session Registrations - Fight D Fear Admin</title>

    <!-- Bootstrap 5 & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Shared Admin Portal Light Shell Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">

    <style>
        body.ap-page { margin: 0; }
        .topbar { display: none !important; }
        .layout { display: flex; min-height: 100vh; }
        .main { flex: 1; min-width: 0; background: var(--ap-bg); }

        .nav-tabs {
            border-bottom: 2px solid var(--ap-border);
        }

        .nav-tabs .nav-link {
            color: var(--ap-muted);
            font-weight: 600;
            border: 1px solid transparent;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            padding: 10px 20px;
            transition: all 0.2s ease;
        }

        .nav-tabs .nav-link:hover {
            color: var(--ap-text);
            border-color: var(--ap-border) var(--ap-border) transparent;
        }

        .nav-tabs .nav-link.active {
            color: var(--ap-accent) !important;
            font-weight: 700;
            background-color: #ffffff;
            border-color: var(--ap-border) var(--ap-border) #ffffff !important;
        }

        .table {
            font-size: 0.88rem;
            color: var(--ap-text);
        }

        .table thead th {
            color: var(--ap-text);
            font-family: 'Outfit', 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 0.82rem;
            border-bottom: 2px solid var(--ap-border);
            padding-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .table tbody td {
            color: var(--ap-text);
            vertical-align: middle;
            padding: 12px 10px;
        }

        .badge-pending {
            background: #FEF3C7;
            color: #92400E;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 600;
        }

        .badge-approved {
            background: #DCFCE7;
            color: #166534;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 600;
        }

        .badge-rejected {
            background: #FEE2E2;
            color: #991B1B;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 600;
        }

        .action-btn-group {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex-wrap: nowrap;
            white-space: nowrap;
        }

        .btn-approve {
            background: #16A34A;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.82rem;
            transition: all 0.2s;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .btn-approve:hover {
            background: #15803D;
            color: white;
        }

        .btn-reject {
            background: #DC2626;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.82rem;
            transition: all 0.2s;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .btn-reject:hover {
            background: #B91C1C;
            color: white;
        }

        .action-th, .action-td {
            white-space: nowrap !important;
            width: 1%;
        }

        .ap-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }

        @media (max-width: 768px) {
            .btn-approve, .btn-reject {
                padding: 5px 10px;
                font-size: 0.78rem;
            }
            .action-btn-group {
                gap: 6px;
            }
        }
    </style>
</head>
<body class="ap-page">

<!-- Compute summary counts -->
<c:set var="pendingRegs" value="0"/>
<c:set var="approvedRegs" value="0"/>
<c:set var="rejectedRegs" value="0"/>
<c:forEach var="r" items="${liveSessionRegistrations}">
    <c:choose>
        <c:when test="${r.status == 'pending'}"><c:set var="pendingRegs" value="${pendingRegs + 1}"/></c:when>
        <c:when test="${r.status == 'approved'}"><c:set var="approvedRegs" value="${approvedRegs + 1}"/></c:when>
        <c:when test="${r.status == 'rejected'}"><c:set var="rejectedRegs" value="${rejectedRegs + 1}"/></c:when>
    </c:choose>
</c:forEach>
<c:forEach var="r" items="${workshopRegistrations}">
    <c:choose>
        <c:when test="${r.status == 'pending'}"><c:set var="pendingRegs" value="${pendingRegs + 1}"/></c:when>
        <c:when test="${r.status == 'approved'}"><c:set var="approvedRegs" value="${approvedRegs + 1}"/></c:when>
        <c:when test="${r.status == 'rejected'}"><c:set var="rejectedRegs" value="${rejectedRegs + 1}"/></c:when>
    </c:choose>
</c:forEach>
<c:set var="totalRegs" value="${fn:length(liveSessionRegistrations) + fn:length(workshopRegistrations)}"/>

<div class="layout">
    <!-- Sidebar -->
    <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

    <!-- Main Content -->
    <main class="main">
        <!-- Topbar -->
        <div class="ap-topbar">
            <div class="ap-topbar-left">
                <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
                <div class="ap-search" style="max-width:380px;">
                    <i class="fas fa-search"></i>
                    <input type="search" id="apHeaderSearch" placeholder="Search participant, email, mobile..." aria-label="Search">
                    <span class="ap-kbd">Ctrl + K</span>
                </div>
            </div>
            <div class="ap-topbar-right" style="display:flex;align-items:center;gap:10px;">
                <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
                    <i class="fas fa-bell"></i>
                    <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
                </a>
                <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
                    <span class="ap-avatar">
                        <c:choose>
                            <c:when test="${not empty admin.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
                            </c:when>
                            <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
                        </c:choose>
                    </span>
                    <span>
                        <div class="name"><c:out value="${admin.name}"/></div>
                        <div class="role">Super Admin</div>
                    </span>
                </a>
            </div>
        </div>

        <div class="ap-main-inner">
            <!-- Back Button -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="btn-back-theme">
                    <i class="fas fa-arrow-left me-1"></i> Back
                </a>
            </div>

            <!-- Breadcrumb -->
            <nav class="ap-crumb">
                <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
                <span class="sep">&gt;</span>
                <a href="${pageContext.request.contextPath}/financial-literacy/admin">Financial Literacy</a>
                <span class="sep">&gt;</span>
                <span>Registrations</span>
            </nav>

            <!-- Page Header -->
            <div class="ap-page-head">
                <div class="ap-page-ico"><i class="fas fa-users"></i></div>
                <div>
                    <h1>Workshop & Session Registrations</h1>
                    <p>Review, approve, or reject participant registrations for live virtual sessions and offline workshops</p>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="ap-stats">
                <div class="ap-stat amber">
                    <div class="ico"><i class="fas fa-clock"></i></div>
                    <div class="val">${pendingRegs}</div>
                    <div class="lbl">Pending Review</div>
                    <div class="sub">Awaiting action</div>
                </div>
                <div class="ap-stat green">
                    <div class="ico"><i class="fas fa-check-circle"></i></div>
                    <div class="val">${approvedRegs}</div>
                    <div class="lbl">Approved</div>
                    <div class="sub">Seats confirmed</div>
                </div>
                <div class="ap-stat rose">
                    <div class="ico"><i class="fas fa-times-circle"></i></div>
                    <div class="val">${rejectedRegs}</div>
                    <div class="lbl">Rejected</div>
                    <div class="sub">Registration declined</div>
                </div>
                <div class="ap-stat neutral">
                    <div class="ico"><i class="fas fa-users-line"></i></div>
                    <div class="val">${totalRegs}</div>
                    <div class="lbl">Total Registrations</div>
                    <div class="sub">All programs</div>
                </div>
            </div>

            <!-- Dynamic Search & Status Filter Bar -->
            <div class="ap-panel p-3 mb-4" style="background:#fff;">
                <div class="row g-2 align-items-center">
                    <div class="col-12 col-md-7">
                        <div class="ap-search w-100" style="max-width:100%;">
                            <i class="fas fa-search"></i>
                            <input type="search" id="registrationSearchInput" placeholder="Filter by participant name, email, mobile, program title or city..." aria-label="Search registrations">
                        </div>
                    </div>
                    <div class="col-12 col-md-3">
                        <select id="registrationStatusSelect" class="form-select rounded-3" style="border-color:var(--ap-border); font-size:0.88rem; padding:9px 14px;">
                            <option value="">All Statuses</option>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                    <div class="col-12 col-md-2">
                        <button type="button" id="registrationSearchResetBtn" class="btn btn-outline-secondary w-100 rounded-3" style="padding:9px; font-size:0.88rem; font-weight:600;">
                            <i class="fas fa-redo me-1"></i> Reset
                        </button>
                    </div>
                </div>
            </div>

            <!-- Content Panel -->
            <div class="ap-panel p-4">
                <ul class="nav nav-tabs mb-4" id="registrationTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="live-tab" data-bs-toggle="tab" data-bs-target="#live" type="button" role="tab" aria-controls="live" aria-selected="true">
                            <i class="fas fa-broadcast-tower me-2 text-danger"></i>Live Sessions (${fn:length(liveSessionRegistrations)})
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="workshop-tab" data-bs-toggle="tab" data-bs-target="#workshop" type="button" role="tab" aria-controls="workshop" aria-selected="false">
                            <i class="fas fa-map-marker-alt me-2 text-danger"></i>Workshops (${fn:length(workshopRegistrations)})
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content" id="registrationTabsContent">
                    <!-- Live Sessions Tab -->
                    <div class="tab-pane fade show active" id="live" role="tabpanel" aria-labelledby="live-tab">
                        <c:choose>
                            <c:when test="${empty liveSessionRegistrations}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted fw-semibold">No live session registrations found</h5>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle" id="liveRegsTable">
                                        <thead>
                                            <tr>
                                                <th>Session Title</th>
                                                <th>Participant Name</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>Occupation</th>
                                                <th>Status</th>
                                                <th class="action-th">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="registration" items="${liveSessionRegistrations}">
                                                <tr class="reg-row" data-status="${registration.status}">
                                                    <td>
                                                        <c:forEach var="session" items="${liveSessions}">
                                                            <c:if test="${session.id == registration.sessionId}">
                                                                <span class="fw-bold">${session.title}</span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td class="fw-semibold">${registration.fullName}</td>
                                                    <td>${registration.mobile}</td>
                                                    <td>${registration.email}</td>
                                                    <td>${registration.occupation}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registration.status == 'pending'}">
                                                                <span class="badge-pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'approved'}">
                                                                <span class="badge-approved">Approved</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'rejected'}">
                                                                <span class="badge-rejected">Rejected</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="action-td">
                                                        <c:if test="${registration.status == 'pending'}">
                                                            <div class="action-btn-group">
                                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/approve" method="POST" style="display: inline; margin: 0;">
                                                                    <input type="hidden" name="registrationId" value="${registration.id}">
                                                                    <input type="hidden" name="type" value="live">
                                                                    <button type="submit" class="btn-approve">
                                                                        <i class="fas fa-check me-1"></i> Approve
                                                                    </button>
                                                                </form>
                                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/reject" method="POST" style="display: inline; margin: 0;">
                                                                    <input type="hidden" name="registrationId" value="${registration.id}">
                                                                    <input type="hidden" name="type" value="live">
                                                                    <button type="submit" class="btn-reject">
                                                                        <i class="fas fa-times me-1"></i> Reject
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <span class="text-muted small">-</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Workshops Tab -->
                    <div class="tab-pane fade" id="workshop" role="tabpanel" aria-labelledby="workshop-tab">
                        <c:choose>
                            <c:when test="${empty workshopRegistrations}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted fw-semibold">No workshop registrations found</h5>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle" id="workshopRegsTable">
                                        <thead>
                                            <tr>
                                                <th>Workshop Title</th>
                                                <th>Participant Name</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>City</th>
                                                <th>Occupation</th>
                                                <th>Status</th>
                                                <th class="action-th">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="registration" items="${workshopRegistrations}">
                                                <tr class="reg-row" data-status="${registration.status}">
                                                    <td>
                                                        <c:forEach var="workshop" items="${workshops}">
                                                            <c:if test="${workshop.id == registration.workshopId}">
                                                                <span class="fw-bold">${workshop.title}</span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td class="fw-semibold">${registration.fullName}</td>
                                                    <td>${registration.mobile}</td>
                                                    <td>${registration.email}</td>
                                                    <td>${registration.city}</td>
                                                    <td>${registration.occupation}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registration.status == 'pending'}">
                                                                <span class="badge-pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'approved'}">
                                                                <span class="badge-approved">Approved</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'rejected'}">
                                                                <span class="badge-rejected">Rejected</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="action-td">
                                                        <c:if test="${registration.status == 'pending'}">
                                                            <div class="action-btn-group">
                                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/approve" method="POST" style="display: inline; margin: 0;">
                                                                    <input type="hidden" name="registrationId" value="${registration.id}">
                                                                    <input type="hidden" name="type" value="workshop">
                                                                    <button type="submit" class="btn-approve">
                                                                        <i class="fas fa-check me-1"></i> Approve
                                                                    </button>
                                                                </form>
                                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/reject" method="POST" style="display: inline; margin: 0;">
                                                                    <input type="hidden" name="registrationId" value="${registration.id}">
                                                                    <input type="hidden" name="type" value="workshop">
                                                                    <button type="submit" class="btn-reject">
                                                                        <i class="fas fa-times me-1"></i> Reject
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <span class="text-muted small">-</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Real-Time Dynamic Search & Filter Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('registrationSearchInput');
        const headerSearch = document.getElementById('apHeaderSearch');
        const statusSelect = document.getElementById('registrationStatusSelect');
        const resetBtn = document.getElementById('registrationSearchResetBtn');

        function filterRegistrations() {
            const query = ((searchInput ? searchInput.value : '') || (headerSearch ? headerSearch.value : '')).toLowerCase().trim();
            const statusFilter = statusSelect ? statusSelect.value.toLowerCase().trim() : '';

            document.querySelectorAll('.reg-row').forEach(row => {
                const text = row.textContent.toLowerCase();
                const status = (row.getAttribute('data-status') || '').toLowerCase();
                
                const matchesQuery = !query || text.includes(query);
                const matchesStatus = !statusFilter || status === statusFilter;

                if (matchesQuery && matchesStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        if (searchInput) searchInput.addEventListener('input', filterRegistrations);
        if (headerSearch) headerSearch.addEventListener('input', filterRegistrations);
        if (statusSelect) statusSelect.addEventListener('change', filterRegistrations);
        if (resetBtn) {
            resetBtn.addEventListener('click', function() {
                if (searchInput) searchInput.value = '';
                if (headerSearch) headerSearch.value = '';
                if (statusSelect) statusSelect.value = '';
                filterRegistrations();
            });
        }
    });
</script>
</body>
</html>
