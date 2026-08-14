<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Women Events Admin — Platform Verification</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; }
        .page-header { background: linear-gradient(135deg, #1a1a2e 0%, #1e1b4b 100%);
            padding: 40px 20px; color: white; }
        .container-main { max-width: 1300px; margin: 0 auto; padding: 36px 20px 60px; }

        /* Stats */
        .stat-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 32px; }
        .stat-card { background: white; border-radius: 16px; padding: 20px; text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .stat-num { font-size: 2rem; font-weight: 800; }
        .stat-label { font-size: 0.78rem; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Filter tabs */
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
        .filter-tab { border-radius: 20px; padding: 8px 18px; font-size: 0.85rem; font-weight: 600;
            cursor: pointer; text-decoration: none; border: 2px solid transparent; transition: all 0.2s; }
        .filter-tab.active-all    { background: #1e1b4b; color: white; }
        .filter-tab.active-pending { background: #f59e0b; color: white; }
        .filter-tab:not(.active-all):not(.active-pending) { background: white; color: #555; border-color: #e5e7eb; }
        .filter-tab:hover { border-color: #1e1b4b; }

        /* Table panel */
        .panel { background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #faf7fb; }
        th { padding: 12px 16px; text-align: left; font-size: 0.78rem; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 12px 16px; border-top: 1px solid #f5f0f8; font-size: 0.88rem; vertical-align: middle; }
        tr:hover td { background: #fdf5ff; }

        .status-pill { border-radius: 20px; padding: 4px 12px; font-size: 0.75rem; font-weight: 700; display: inline-block; }
        .s-PENDING  { background: #fef9c3; color: #854d0e; }
        .s-APPROVED { background: #dcfce7; color: #166534; }
        .s-REJECTED { background: #ffe4e6; color: #9f1239; }

        .btn-approve { background: #dcfce7; color: #166534; border: 1.5px solid #166534; border-radius: 20px;
            padding: 5px 14px; font-size: 0.8rem; font-weight: 700; cursor: pointer; font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-approve:hover { background: #166534; color: white; }
        .btn-reject { background: #ffe4e6; color: #9f1239; border: 1.5px solid #9f1239; border-radius: 20px;
            padding: 5px 14px; font-size: 0.8rem; font-weight: 700; cursor: pointer; font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-reject:hover { background: #9f1239; color: white; }
        .btn-feature { background: #fff7ed; color: #c2410c; border: 1.5px solid #c2410c; border-radius: 20px;
            padding: 5px 14px; font-size: 0.8rem; font-weight: 700; cursor: pointer; font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-feature:hover { background: #c2410c; color: white; }
        .btn-delete { background: #fee2e2; color: #991b1b; border: 1.5px solid #991b1b; border-radius: 20px;
            padding: 5px 14px; font-size: 0.8rem; font-weight: 700; cursor: pointer; font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-delete:hover { background: #991b1b; color: white; }

        .flash-alert { position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 380px;
            border-radius: 14px; box-shadow: 0 10px 40px rgba(0,0,0,0.15); animation: slideIn 0.4s ease; }
        @keyframes slideIn { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        
        .nav-pills .nav-link.active {
            background-color: #1e1b4b !important;
            color: white !important;
            border-color: #1e1b4b !important;
        }
        .nav-pills .nav-link:not(.active) {
            background-color: white;
            color: #555;
            border: 1.5px solid #e5e7eb;
        }
        .s-NONE { background: #e2e8f0; color: #475569; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<c:if test="${not empty success}">
    <div class="flash-alert alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle-fill me-2"></i>${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="flash-alert alert alert-danger alert-dismissible fade show">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="page-header">
    <div style="max-width:1300px; margin:0 auto; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
        <div>
            <h1 style="font-size:1.8rem; font-weight:800; margin:0;"><i class="bi bi-calendar-heart-fill me-2"></i>Women Events Admin</h1>
            <p style="opacity:0.85; margin:0; font-size:0.9rem;">Review, approve, and feature women's platform events</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-outline-light rounded-pill">
            <i class="bi bi-chevron-left"></i> Admin Dashboard
        </a>
    </div>
</div>

<div class="container-main">

    <!-- Stats Row -->
    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-num" style="color:#1e1b4b;">${allEvents.size()}</div>
            <div class="stat-label">Total Events</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#854d0e;">
                <c:set var="pendingCount" value="0"/>
                <c:forEach var="ev" items="${allEvents}"><c:if test="${ev.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if></c:forEach>
                ${pendingCount}
            </div>
            <div class="stat-label">Pending Review</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#166534;">
                <c:set var="approvedCount" value="0"/>
                <c:forEach var="ev" items="${allEvents}"><c:if test="${ev.status == 'APPROVED'}"><c:set var="approvedCount" value="${approvedCount + 1}"/></c:if></c:forEach>
                ${approvedCount}
            </div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#9f1239;">
                <c:set var="rejectedCount" value="0"/>
                <c:forEach var="ev" items="${allEvents}"><c:if test="${ev.status == 'REJECTED'}"><c:set var="rejectedCount" value="${rejectedCount + 1}"/></c:if></c:forEach>
                ${rejectedCount}
            </div>
            <div class="stat-label">Rejected</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#c2410c;">
                <c:set var="featuredCount" value="0"/>
                <c:forEach var="ev" items="${allEvents}"><c:if test="${ev.featured}"><c:set var="featuredCount" value="${featuredCount + 1}"/></c:if></c:forEach>
                ${featuredCount}
            </div>
            <div class="stat-label">Featured</div>
        </div>
    </div>

    <!-- Tabs Navigation -->
    <ul class="nav nav-pills mb-4" id="adminEventsTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active rounded-pill px-4 me-2" id="events-tab" data-bs-toggle="tab" data-bs-target="#events-content" type="button" role="tab">
                <i class="bi bi-calendar-event me-2"></i>Events List
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-pill px-4 text-dark" id="hosts-tab" data-bs-toggle="tab" data-bs-target="#hosts-content" type="button" role="tab">
                <i class="bi bi-person-badge me-2"></i>Host Applications
                <c:set var="pendingHostsCount" value="0"/>
                <c:forEach var="host" items="${hostApplications}">
                    <c:if test="${host.verificationStatus == 'PENDING'}">
                        <c:set var="pendingHostsCount" value="${pendingHostsCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:if test="${pendingHostsCount > 0}">
                    <span class="badge bg-danger ms-1">${pendingHostsCount}</span>
                </c:if>
            </button>
        </li>
    </ul>

    <div class="tab-content" id="adminEventsTabsContent">
        <!-- Tab 1: Events List -->
        <div class="tab-pane fade show active" id="events-content" role="tabpanel">
            <div class="panel">
                <div style="padding: 20px 20px 10px; border-bottom: 1px solid #f5f0f8;">
                    <h6 style="color:#1e1b4b; font-weight:700; display:flex; align-items:center; gap:8px; margin:0;">
                        <i class="bi bi-table"></i>All Events
                    </h6>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Event</th>
                                <th>Category</th>
                                <th>Date</th>
                                <th>City</th>
                                <th>Organizer</th>
                                <th>Fee</th>
                                <th>Featured</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ev" items="${allEvents}">
                                <tr>
                                    <td>
                                        <div style="font-weight:700; max-width:180px;">${ev.name}</div>
                                        <div style="font-size:0.75rem; color:#888;">ID: ${ev.id}</div>
                                    </td>
                                    <td><span style="font-size:0.78rem; color:#1e1b4b; font-weight:600;">${ev.category.displayName}</span></td>
                                    <td style="white-space:nowrap; font-size:0.82rem;">${ev.eventDate}</td>
                                    <td>${ev.city}</td>
                                    <td>
                                        <div style="font-weight:600; font-size:0.85rem;">${ev.organizerName}</div>
                                        <div style="font-size:0.75rem; color:#aaa;">${ev.organizerType}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ev.free}"><span style="color:#166534; font-weight:700;">FREE</span></c:when>
                                            <c:otherwise><span style="color:#c2410c; font-weight:700;">₹${ev.entryFee}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${ev.featured}"><i class="bi bi-star-fill" style="color:#f59e0b; font-size:1.1rem;"></i></c:when>
                                            <c:otherwise><i class="bi bi-star" style="color:#d1d5db;"></i></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="status-pill s-${ev.status}">${ev.status}</span></td>
                                    <td>
                                        <div class="d-flex gap-1 flex-wrap">
                                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}" target="_blank" class="btn btn-outline-secondary btn-sm rounded-pill" style="font-size:0.75rem;">View</a>

                                            <c:if test="${ev.status == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/women-events/admin/${ev.id}/approve" method="post" style="display:inline;">
                                                    <button type="submit" class="btn-approve">✓ Approve</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/women-events/admin/${ev.id}/reject" method="post" style="display:inline;">
                                                    <button type="submit" class="btn-reject">✗ Reject</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${ev.status == 'APPROVED'}">
                                                <form action="${pageContext.request.contextPath}/women-events/admin/${ev.id}/feature" method="post" style="display:inline;">
                                                    <button type="submit" class="btn-feature">
                                                        <i class="bi bi-star${ev.featured ? '-fill' : ''}"></i>${ev.featured ? 'Unfeature' : 'Feature'}
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form action="${pageContext.request.contextPath}/women-events/admin/${ev.id}/delete" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Delete this event permanently?')">
                                                <button type="submit" class="btn-delete"><i class="bi bi-trash-fill"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allEvents}">
                                <tr><td colspan="9" class="text-center text-muted py-5">No events submitted yet.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 2: Host Applications -->
        <div class="tab-pane fade" id="hosts-content" role="tabpanel">
            <div class="panel">
                <div style="padding: 20px 20px 10px; border-bottom: 1px solid #f5f0f8;">
                    <h6 style="color:#1e1b4b; font-weight:700; display:flex; align-items:center; gap:8px; margin:0;">
                        <i class="bi bi-people-fill"></i>Event Host Applications
                    </h6>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Applicant</th>
                                <th>Organization Name</th>
                                <th>Organization Type</th>
                                <th>Contact</th>
                                <th>Bio / Purpose</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="host" items="${hostApplications}">
                                <tr>
                                    <td>
                                        <div style="font-weight:700;">${host.fullName}</div>
                                        <div style="font-size:0.75rem; color:#888;">Host ID: ${host.id}</div>
                                    </td>
                                    <td><strong>${host.organizerName}</strong></td>
                                    <td><span style="font-size:0.78rem; color:#1e1b4b; font-weight:600;">${host.organizerType}</span></td>
                                    <td>${host.hostContact}</td>
                                    <td>
                                        <div style="max-width: 250px; font-size: 0.82rem; color: #555; white-space: normal; word-break: break-word;">
                                            ${host.hostBio}
                                        </div>
                                    </td>
                                    <td><span class="status-pill s-${host.verificationStatus}">${host.verificationStatus}</span></td>
                                    <td>
                                        <div class="d-flex gap-1 flex-wrap">
                                            <c:if test="${host.verificationStatus == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/women-events/admin/host/${host.id}/approve" method="post" style="display:inline;">
                                                    <button type="submit" class="btn-approve">✓ Approve</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/women-events/admin/host/${host.id}/reject" method="post" style="display:inline;">
                                                    <button type="submit" class="btn-reject">✗ Reject</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty hostApplications}">
                                <tr><td colspan="7" class="text-center text-muted py-5">No host applications submitted yet.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    setTimeout(() => {
        document.querySelectorAll('.flash-alert').forEach(el => {
            el.style.transition='opacity 0.5s'; el.style.opacity='0';
            setTimeout(()=>el.remove(),500);
        });
    }, 4000);
</script>
</body>
</html>
