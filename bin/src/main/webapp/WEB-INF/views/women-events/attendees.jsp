<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Attendees &amp; Attendance — ${event.name}</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css?v=3"/>
    <style>
        :root {
            --fdf-bg: #F8FAFC;
            --fdf-card-bg: #FFFFFF;
            --fdf-border: #E2E8F0;
            --fdf-navy: #0F172A;
            --fdf-muted: #64748B;
            --fdf-accent: #F43F5E;
            --fdf-accent-dark: #E11D48;
            --fdf-emerald: #10B981;
            --fdf-emerald-light: #ECFDF5;
        }
        body { font-family: 'Outfit', sans-serif; background: var(--fdf-bg); color: var(--fdf-navy); min-height: 100vh; }
        .page-header-banner {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            color: #FFFFFF;
            padding: 40px 20px;
            margin-bottom: 28px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
        }
        .header-container { max-width: 1180px; margin: 0 auto; }
        .container-main { max-width: 1180px; margin: 0 auto; padding: 0 20px 60px; }

        .stat-badge-card {
            background: #FFFFFF;
            border: 1px solid var(--fdf-border);
            border-radius: 18px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(15, 23, 42, 0.03);
            text-align: center;
        }
        .stat-badge-num { font-size: 1.8rem; font-weight: 800; color: var(--fdf-navy); line-height: 1; margin-bottom: 4px; }
        .stat-badge-label { font-size: 0.8rem; font-weight: 600; color: var(--fdf-muted); text-transform: uppercase; letter-spacing: 0.5px; }

        .verify-box {
            background: #FFFFFF;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.04);
            margin-bottom: 28px;
        }

        .panel-card {
            background: #FFFFFF;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.04);
            overflow: hidden;
        }
        .panel-header-bar {
            padding: 20px 24px;
            border-bottom: 1px solid var(--fdf-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .user-cell { display: flex; align-items: center; gap: 12px; }
        .u-avatar {
            width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #F43F5E, #FB7185);
            display: flex; align-items: center; justify-content: center;
            color: #FFFFFF; font-weight: 700; font-size: 0.9rem; flex-shrink: 0;
        }
        .u-name { font-weight: 700; font-size: 0.9rem; color: var(--fdf-navy); }
        .u-email { font-size: 0.78rem; color: var(--fdf-muted); }

        .ticket-code-pill {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 0.85rem;
            font-weight: 700;
            background: #FFF1F2;
            color: #E11D48;
            padding: 4px 10px;
            border-radius: 8px;
            border: 1px solid #FECDD3;
            letter-spacing: 0.5px;
        }

        .status-pill {
            border-radius: 99px;
            padding: 4px 12px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .st-attended { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
        .st-pending  { background: #F1F5F9; color: #64748B; border: 1px solid #CBD5E1; }
        .st-cancelled { background: #FEF2F2; color: #B91C1C; border: 1px solid #FECACA; }

        .btn-action-attendance {
            border-radius: 99px;
            font-weight: 700;
            font-size: 0.78rem;
            padding: 6px 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none !important;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 1.5px solid transparent;
        }
        .btn-mark-present {
            background: #10B981;
            color: #FFFFFF;
        }
        .btn-mark-present:hover {
            background: #059669;
            color: #FFFFFF;
            transform: translateY(-1px);
        }
        .btn-unmark {
            background: #FEE2E2;
            color: #B91C1C;
            border-color: #FECACA;
        }
        .btn-unmark:hover {
            background: #FCA5A5;
            color: #7F1D1D;
        }

        table { width: 100%; border-collapse: collapse; }
        th {
            padding: 14px 20px;
            text-align: left;
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--fdf-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #F8FAFC;
            border-bottom: 1px solid var(--fdf-border);
        }
        td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--fdf-border);
            font-size: 0.88rem;
            vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #FAF5FF20; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<!-- Top Banner -->
<div class="page-header-banner">
    <div class="header-container">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div>
                <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="text-white-50 text-decoration-none small mb-2 d-inline-block">
                    <i class="bi bi-chevron-left"></i> Back to Organizer Dashboard
                </a>
                <h1 style="font-size: clamp(1.6rem, 3vw, 2.2rem); font-weight: 800; margin-bottom: 6px;">
                    ${event.name}
                </h1>
                <div class="d-flex align-items-center gap-3 text-white-50 small flex-wrap">
                    <span><i class="bi bi-calendar3 me-1"></i> ${event.eventDate} <c:if test="${not empty event.eventTime}">· ${event.eventTime}</c:if></span>
                    <span><i class="bi bi-geo-alt-fill me-1"></i> ${event.venue}<c:if test="${not empty event.city}">, ${event.city}</c:if></span>
                    <span><i class="bi bi-tag-fill me-1"></i> ${not empty event.category ? event.category.displayName : 'Event'}</span>
                </div>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/women-events/${event.id}" class="btn btn-outline-light rounded-pill px-3 py-2 fw-bold" target="_blank">
                    <i class="bi bi-box-arrow-up-right me-1"></i> Public Event Page
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container-main">

    <!-- Flash Alerts -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Calculation of Attendance Stats -->
    <c:set var="attendedCount" value="0"/>
    <c:forEach var="a" items="${attendees}">
        <c:if test="${a.checkedIn or a.status == 'ATTENDED'}">
            <c:set var="attendedCount" value="${attendedCount + 1}"/>
        </c:if>
    </c:forEach>
    <c:set var="pendingCount" value="${fn:length(attendees) - attendedCount}"/>

    <!-- Stat Badges -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-badge-card">
                <div class="stat-badge-num">${fn:length(attendees)}</div>
                <div class="stat-badge-label">Registered Attendees</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-badge-card">
                <div class="stat-badge-num text-success">${attendedCount}</div>
                <div class="stat-badge-label">Present / Attended</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-badge-card">
                <div class="stat-badge-num text-muted">${pendingCount}</div>
                <div class="stat-badge-label">Awaiting Arrival</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-badge-card">
                <div class="stat-badge-num" style="color:var(--fdf-accent);">
                    <c:choose>
                        <c:when test="${not empty event.maxParticipants}">${event.maxParticipants}</c:when>
                        <c:otherwise>∞</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-badge-label">Total Capacity</div>
            </div>
        </div>
    </div>

    <!-- Quick Ticket Code Verification Form -->
    <div class="verify-box">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div>
                <h5 class="fw-bold mb-1" style="color:var(--fdf-navy);">
                    <i class="bi bi-qr-code-scan me-2 text-danger"></i> Quick Ticket Verification &amp; Check-In
                </h5>
                <p class="text-muted small mb-0">Enter the attendee's 12-character Ticket Code or scan QR code to verify ticket and mark present instantly.</p>
            </div>
            <form action="${pageContext.request.contextPath}/women-events/organizer/${event.id}/checkin" method="post" class="d-flex gap-2 flex-wrap align-items-center">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input type="text" name="ticketCode" placeholder="Enter ticket code (e.g. 8A72B3C4)..." required
                       style="border:1.5px solid var(--fdf-border); border-radius:12px; padding:10px 16px; font-size:0.95rem; font-family:monospace; min-width:260px; outline:none;"/>
                <button type="submit" class="btn fw-bold px-4 py-2" style="background:linear-gradient(135deg, var(--fdf-accent) 0%, var(--fdf-accent-dark) 100%); color:#FFFFFF; border-radius:12px;">
                    <i class="bi bi-patch-check-fill me-1"></i> Verify &amp; Check In
                </button>
            </form>
        </div>
    </div>

    <!-- Attendees List Panel -->
    <div class="panel-card">
        <div class="panel-header-bar">
            <div>
                <h5 class="fw-bold mb-0" style="color:var(--fdf-navy);"><i class="bi bi-people-fill me-2" style="color:var(--fdf-accent);"></i> Attendees &amp; Attendance Roster</h5>
                <small class="text-muted">Manage participant arrivals and attendance records</small>
            </div>
            <div class="d-flex align-items-center gap-2">
                <div style="position:relative;">
                    <i class="bi bi-search" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:var(--fdf-muted);"></i>
                    <input type="text" id="attendeeSearch" placeholder="Search by name, email, or ticket..." onkeyup="filterAttendeeTable()"
                           style="border:1px solid var(--fdf-border); border-radius:10px; padding:7px 12px 7px 34px; font-size:0.85rem; outline:none; min-width:240px;"/>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table id="attendeesTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Attendee</th>
                        <th>Phone</th>
                        <th>Ticket Code</th>
                        <th>Booked On</th>
                        <th>Attendance</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="reg" items="${attendees}" varStatus="vs">
                        <c:set var="uName" value="${not empty reg.user.fullName ? reg.user.fullName : 'Guest Attendee'}"/>
                        <c:set var="uEmail" value="${not empty reg.user.email ? reg.user.email : '—'}"/>
                        <c:set var="uPhone" value="${not empty reg.user.phoneNumber ? reg.user.phoneNumber : 'Not provided'}"/>
                        <c:set var="rowSearch" value="${fn:toLowerCase(uName)} ${fn:toLowerCase(uEmail)} ${fn:toLowerCase(reg.ticketCode)}"/>
                        <tr data-search="${rowSearch}">
                            <td class="text-muted fw-bold">${vs.index + 1}</td>
                            <td>
                                <div class="user-cell">
                                    <div class="u-avatar">
                                        ${fn:toUpperCase(fn:substring(uName, 0, 1))}
                                    </div>
                                    <div>
                                        <div class="u-name">${uName}</div>
                                        <div class="u-email">${uEmail}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="text-muted" style="font-size:0.85rem;">${uPhone}</td>
                            <td><span class="ticket-code-pill">${reg.ticketCode}</span></td>
                            <td class="text-muted" style="font-size:0.82rem;">${reg.registeredAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${reg.checkedIn or reg.status == 'ATTENDED'}">
                                        <span class="status-pill st-attended"><i class="bi bi-check-circle-fill"></i> Attended</span>
                                        <c:if test="${not empty reg.checkedInAt}">
                                            <div style="font-size:0.7rem; color:var(--fdf-muted); margin-top:2px;">${reg.checkedInAt}</div>
                                        </c:if>
                                    </c:when>
                                    <c:when test="${reg.status == 'CANCELLED'}">
                                        <span class="status-pill st-cancelled"><i class="bi bi-x-circle-fill"></i> Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill st-pending"><i class="bi bi-clock"></i> Not Checked In</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${reg.status == 'CANCELLED'}">
                                        <span class="text-muted small">Cancelled</span>
                                    </c:when>
                                    <c:when test="${reg.checkedIn or reg.status == 'ATTENDED'}">
                                        <form action="${pageContext.request.contextPath}/women-events/organizer/registrations/${reg.id}/attendance" method="post" style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <button type="submit" class="btn-action-attendance btn-unmark" title="Click to unmark attendance">
                                                <i class="bi bi-arrow-counterclockwise"></i> Unmark
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/women-events/organizer/registrations/${reg.id}/attendance" method="post" style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <button type="submit" class="btn-action-attendance btn-mark-present">
                                                <i class="bi bi-check-lg"></i> Mark Present
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty attendees}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-people display-4 d-block mb-3 text-muted" style="opacity:0.4;"></i>
                                <h6 class="fw-bold">No Attendees Registered Yet</h6>
                                <p class="small mb-0">When users book tickets for this event, they will appear here for attendance verification.</p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
function filterAttendeeTable() {
    const q = (document.getElementById('attendeeSearch').value || '').toLowerCase().trim();
    document.querySelectorAll('#attendeesTable tbody tr').forEach(tr => {
        const text = tr.getAttribute('data-search') || '';
        tr.style.display = !q || text.includes(q) ? '' : 'none';
    });
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
