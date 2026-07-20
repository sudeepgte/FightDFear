<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Organizer Dashboard — Women Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; color: #1a1a2e; }
        .page-header { background: linear-gradient(135deg, #1a1a2e 0%, #1e1b4b 100%); padding: 50px 20px; color: white; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; }
        .container-main { max-width: 1100px; margin: 0 auto; padding: 36px 20px 60px; }

        /* Stat cards */
        .stat-card { background: white; border-radius: 20px; padding: 24px; text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-icon { width: 56px; height: 56px; border-radius: 16px; display: flex; align-items: center;
            justify-content: center; font-size: 1.6rem; margin: 0 auto 12px; }
        .stat-num { font-size: 2.2rem; font-weight: 800; line-height: 1; }
        .stat-label { font-size: 0.82rem; color: #888; font-weight: 500; margin-top: 4px; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Events table */
        .events-table { background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .table-header { padding: 20px 24px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f5f0f8; flex-wrap: wrap; gap: 12px; }
        .table-title { font-size: 1.1rem; font-weight: 700; color: #1e1b4b; display: flex; align-items: center; gap: 8px; }
        .create-btn { background: linear-gradient(135deg, #1e1b4b, #a855f7); color: white; border: none;
            border-radius: 20px; padding: 10px 22px; font-family: 'Outfit', sans-serif; font-weight: 600;
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .create-btn:hover { color: white; transform: scale(1.03); box-shadow: 0 6px 20px rgba(124,45,94,0.3); }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #faf7fb; }
        th { padding: 14px 18px; text-align: left; font-size: 0.8rem; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 14px 18px; border-top: 1px solid #f5f0f8; font-size: 0.9rem; vertical-align: middle; }
        tr:hover td { background: #fdf5ff; }

        .status-pill { border-radius: 20px; padding: 4px 12px; font-size: 0.75rem; font-weight: 700; }
        .status-PENDING  { background: #fef9c3; color: #854d0e; }
        .status-APPROVED { background: #dcfce7; color: #166534; }
        .status-REJECTED { background: #ffe4e6; color: #9f1239; }

        .empty-state { text-align: center; padding: 60px 20px; color: #888; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show m-3 rounded-3">
        <i class="bi bi-check-circle-fill me-2"></i>${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="page-header">
    <div style="max-width:1100px; margin:0 auto;">
        <h1><i class="bi bi-calendar-event-fill me-2"></i>Organizer Dashboard</h1>
        <p style="opacity:0.85; margin:0;">Manage your women events and track registrations</p>
    </div>
</div>

<div class="container-main">

    <!-- Stats Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-icon" style="background:#f0e8ff;"><i class="bi bi-calendar-fill" style="color:#1e1b4b;"></i></div>
                <div class="stat-num" style="color:#1e1b4b;">${myEvents.size()}</div>
                <div class="stat-label">Total Events</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-icon" style="background:#dcfce7;"><i class="bi bi-check-circle-fill" style="color:#15803d;"></i></div>
                <div class="stat-num" style="color:#15803d;">${approvedCount}</div>
                <div class="stat-label">Approved</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fef9c3;"><i class="bi bi-hourglass-split" style="color:#854d0e;"></i></div>
                <div class="stat-num" style="color:#854d0e;">${pendingCount}</div>
                <div class="stat-label">Pending Review</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-icon" style="background:#dbeafe;"><i class="bi bi-people-fill" style="color:#1d4ed8;"></i></div>
                <div class="stat-num" style="color:#1d4ed8;">${totalRegistrations}</div>
                <div class="stat-label">Total Registrations</div>
            </div>
        </div>
    </div>

    <!-- My Events Table -->
    <div class="events-table">
        <div class="table-header">
            <div class="table-title"><i class="bi bi-list-ul"></i>My Events</div>
            <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="create-btn">
                <i class="bi bi-plus-circle-fill"></i>Create New Event
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty myEvents}">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Event Name</th>
                                <th>Category</th>
                                <th>Date</th>
                                <th>City</th>
                                <th>Fee</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ev" items="${myEvents}">
                                <tr>
                                    <td>
                                        <div style="font-weight:700;">${ev.name}</div>
                                        <div style="font-size:0.78rem; color:#888;">${ev.organizerType}</div>
                                    </td>
                                    <td><span style="font-size:0.8rem; color:#1e1b4b; font-weight:600;">${ev.category.displayName}</span></td>
                                    <td style="white-space:nowrap; font-size:0.85rem;">${ev.eventDate}</td>
                                    <td>${ev.city}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ev.free}"><span style="color:#15803d; font-weight:700;">FREE</span></c:when>
                                            <c:otherwise><span style="color:#c2410c; font-weight:700;">₹${ev.entryFee}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="status-pill status-${ev.status}">${ev.status}</span></td>
                                    <td>
                                        <div class="d-flex gap-2 flex-wrap">
                                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}"
                                               class="btn btn-outline-primary btn-sm rounded-pill">View</a>
                                            <c:if test="${ev.status == 'APPROVED'}">
                                                <a href="${pageContext.request.contextPath}/women-events/organizer/${ev.id}/attendees"
                                                   class="btn btn-outline-success btn-sm rounded-pill">Attendees</a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="bi bi-calendar-x" style="font-size:3rem; color:#d8b4fe; display:block; margin-bottom:12px;"></i>
                    <h5 style="font-weight:700;">No events created yet</h5>
                    <p>Create your first event and reach thousands of women!</p>
                    <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="create-btn d-inline-flex mt-2">
                        <i class="bi bi-plus-circle-fill"></i>Create Your First Event
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
