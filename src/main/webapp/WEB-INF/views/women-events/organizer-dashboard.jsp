<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Organizer Dashboard — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .event-thumb {
            width: 40px; height: 40px; border-radius: 10px;
            background: var(--fdf-accent); color: #fff;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .event-name-cell { display: flex; align-items: center; gap: 10px; }
        .event-name-main { font-weight: 700; font-size: 0.88rem; color: var(--fdf-navy); }
        .event-name-sub { font-size: 0.73rem; color: var(--fdf-text-muted); }
        .status-APPROVED { background: #F0FDF4; color: #166534; border-radius: 20px; padding: 4px 12px; font-size: 0.72rem; font-weight: 700; }
        .status-PENDING { background: #FFFBEB; color: #92400E; border-radius: 20px; padding: 4px 12px; font-size: 0.72rem; font-weight: 700; }
        .status-REJECTED { background: #FEF2F2; color: #B91C1C; border-radius: 20px; padding: 4px 12px; font-size: 0.72rem; font-weight: 700; }
        .action-btns { display: flex; gap: 6px; }
        .action-btn {
            width: 30px; height: 30px; border-radius: 8px; border: 1px solid var(--fdf-border);
            background: var(--fdf-white); display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem; color: var(--fdf-text-muted); text-decoration: none;
        }
        .action-btn:hover { border-color: var(--fdf-accent); color: var(--fdf-accent); background: var(--fdf-rose-soft); }
        .perf-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; padding: 16px 20px; }
        .perf-stat-item { text-align: center; }
        .perf-stat-icon { font-size: 1.3rem; margin-bottom: 6px; color: var(--fdf-accent); }
        .perf-stat-num { font-size: 1.2rem; font-weight: 800; color: var(--fdf-navy); }
        .perf-stat-label { font-size: 0.72rem; color: var(--fdf-text-muted); font-weight: 600; }
        .reg-meta { margin-left: auto; text-align: right; }
        .reg-date { font-size: 0.72rem; color: var(--fdf-text-muted); }
        .reg-status { font-size: 0.68rem; font-weight: 700; padding: 2px 8px; border-radius: 20px; margin-top: 3px; display: inline-block; }
        .reg-status.confirmed { background: #F0FDF4; color: #166534; }
        .reg-status.pending { background: #FFFBEB; color: #92400E; }
        .reg-name { font-size: 0.85rem; font-weight: 700; color: var(--fdf-navy); }
        .reg-event { font-size: 0.73rem; color: var(--fdf-text-muted); }
    </style>
</head>
<body class="org-hub">

<c:set var="hostStatus" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus : 'PROFILE_INCOMPLETE'}"/>
<c:set var="hostApproved" value="${hostStatus eq 'APPROVED' || host.verificationStatus eq 'VERIFIED'}"/>

<%@ include file="../fragments/organizer-sidebar.jsp" %>

<div class="org-main-wrapper">
    <div class="org-topbar">
        <div class="org-topbar-left">
            <h2>Welcome back, <c:out value="${not empty host.fullName ? host.fullName : 'Organizer'}"/>!</h2>
            <p>Here's what's happening with your events today.</p>
        </div>
        <div class="org-topbar-right">
            <span class="org-status-pill ${hostApproved ? 'ok' : fn:contains(hostStatus, 'PENDING') ? 'wait' : 'bad'}">
                <i class="bi bi-shield-check"></i> ${hostStatus}
            </span>
            <c:choose>
                <c:when test="${hostApproved}">
                    <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="org-btn-primary">
                        <i class="bi bi-plus-lg"></i> Create Event
                    </a>
                </c:when>
                <c:otherwise>
                    <button type="button" class="org-btn-primary" style="opacity:0.65;cursor:not-allowed;"
                            onclick="alert('Complete profile and wait for admin approval before creating events.')">
                        <i class="bi bi-lock-fill"></i> Create Event
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="org-page-content">
        <c:if test="${!hostApproved}">
            <div class="org-banner-verify">
                <i class="bi bi-info-circle-fill me-1" style="color:var(--fdf-accent);"></i>
                <strong>Verification: ${hostStatus}</strong> —
                <c:choose>
                    <c:when test="${hostStatus eq 'PENDING_ADMIN_APPROVAL'}">Your profile is under admin review. Event creation unlocks after approval.</c:when>
                    <c:when test="${hostStatus eq 'CHANGES_REQUESTED'}">Admin requested updates. <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion">Update profile</a>.</c:when>
                    <c:otherwise>Complete your profile and submit for verification. <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion">Complete profile (${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%)</a>.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="org-banner-verify" style="background:#F0FDF4;border-color:#BBF7D0;">
                <i class="bi bi-check-circle-fill me-1" style="color:#16A34A;"></i> ${success}
            </div>
        </c:if>

        <div class="org-stats-grid">
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-calendar-event"></i></div>
                <div><div class="org-stat-label">Total Events</div><div class="org-stat-num">${fn:length(myEvents)}</div></div>
            </div>
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-check-circle"></i></div>
                <div><div class="org-stat-label">Approved</div><div class="org-stat-num">${approvedCount}</div></div>
            </div>
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-hourglass-split"></i></div>
                <div><div class="org-stat-label">Pending</div><div class="org-stat-num">${pendingCount}</div></div>
            </div>
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-people"></i></div>
                <div><div class="org-stat-label">Registrations</div><div class="org-stat-num">${totalRegistrations}</div></div>
            </div>
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-file-earmark"></i></div>
                <div><div class="org-stat-label">Drafts</div><div class="org-stat-num">${empty draftCount ? 0 : draftCount}</div></div>
            </div>
            <div class="org-stat-card">
                <div class="org-stat-icon"><i class="bi bi-currency-rupee"></i></div>
                <div><div class="org-stat-label">Net earnings</div><div class="org-stat-num">₹${empty netEarnings ? 0 : netEarnings}</div></div>
            </div>
        </div>

        <div class="org-content-grid">
            <div class="org-card">
                <div class="org-card-header">
                    <div class="org-card-title"><i class="bi bi-calendar3"></i> My Events</div>
                    <a href="${pageContext.request.contextPath}/women-events/organizer/my-events" class="org-link-accent">View all</a>
                </div>
                <c:if test="${not empty myEvents}">
                    <div class="org-table-toolbar">
                        <div class="org-search-wrap" style="flex:1;">
                            <i class="bi bi-search"></i>
                            <input type="text" class="org-search-input" placeholder="Search events..." id="eventSearch" onkeyup="filterEvents()"/>
                        </div>
                        <select class="org-filter-select" id="statusFilter" onchange="filterEvents()">
                            <option value="">All Status</option>
                            <option value="DRAFT">Draft</option>
                            <option value="APPROVED">Approved</option>
                            <option value="PENDING">Pending</option>
                            <option value="REJECTED">Rejected</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                </c:if>
                <c:choose>
                    <c:when test="${not empty myEvents}">
                        <div class="org-table-wrap">
                            <table id="eventsTable">
                                <thead>
                                    <tr>
                                        <th>Event</th>
                                        <th>Date</th>
                                        <th>Location</th>
                                        <th>Status</th>
                                        <th>Fee</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ev" items="${myEvents}">
                                        <tr data-name="${fn:toLowerCase(ev.name)}" data-status="${ev.status}">
                                            <td>
                                                <div class="event-name-cell">
                                                    <div class="event-thumb"><i class="bi bi-calendar-heart"></i></div>
                                                    <div>
                                                        <div class="event-name-main"><c:out value="${ev.name}"/></div>
                                                        <div class="event-name-sub"><c:out value="${ev.category != null ? ev.category.displayName : 'Not provided'}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${ev.eventDate}</td>
                                            <td><c:out value="${ev.city}"/><br/><span style="font-size:0.72rem;color:var(--fdf-text-muted);"><c:out value="${ev.venue}"/></span></td>
                                            <td><span class="status-${ev.status}">${ev.status}</span></td>
                                            <td><c:choose><c:when test="${ev.free}">FREE</c:when><c:otherwise>₹${ev.entryFee}</c:otherwise></c:choose></td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="action-btn" title="View"><i class="bi bi-eye"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="org-empty">
                            <i class="bi bi-calendar-x"></i>
                            <h5 style="font-weight:700;margin-bottom:8px;">No events created yet</h5>
                            <p style="margin-bottom:12px;">
                                <c:choose>
                                    <c:when test="${hostApproved}">Create your first event to start receiving registrations.</c:when>
                                    <c:otherwise>Create your first event when your profile is approved.</c:otherwise>
                                </c:choose>
                            </p>
                            <c:choose>
                                <c:when test="${hostApproved}">
                                    <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="org-btn-primary">
                                        <i class="bi bi-plus-lg"></i> Create Event
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion" class="org-btn-primary">
                                        <i class="bi bi-person-check"></i> Complete Profile
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="org-card">
                <div class="org-card-header">
                    <div class="org-card-title"><i class="bi bi-clock-history"></i> Recent Registrations</div>
                </div>
                <c:choose>
                    <c:when test="${not empty recentRegistrations}">
                        <c:forEach var="reg" items="${recentRegistrations}">
                            <div class="org-reg-item">
                                <div class="org-reg-avatar">
                                    <c:choose>
                                        <c:when test="${reg.user != null && not empty reg.user.fullName}">${fn:substring(reg.user.fullName, 0, 1)}</c:when>
                                        <c:otherwise>?</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <div class="reg-name"><c:out value="${reg.user != null ? reg.user.fullName : 'Guest'}"/></div>
                                    <div class="reg-event"><c:out value="${reg.event != null ? reg.event.name : 'Event'}"/></div>
                                </div>
                                <div class="reg-meta">
                                    <div class="reg-date">${reg.registeredAt}</div>
                                    <span class="reg-status ${reg.status eq 'CANCELLED' ? 'pending' : 'confirmed'}">${reg.status}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="org-empty" style="padding:32px 16px;">
                            <i class="bi bi-inbox"></i>
                            <p>No registrations yet</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="org-analytics-grid">
            <div class="org-card">
                <div class="org-card-header">
                    <div class="org-card-title"><i class="bi bi-graph-up-arrow"></i> Event Performance</div>
                </div>
                <div class="perf-stats">
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-people"></i></div>
                        <div class="perf-stat-num">${totalRegistrations}</div>
                        <div class="perf-stat-label">Registrations</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-check2-circle"></i></div>
                        <div class="perf-stat-num">${approvedCount}</div>
                        <div class="perf-stat-label">Approved Events</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-hourglass"></i></div>
                        <div class="perf-stat-num">${pendingCount}</div>
                        <div class="perf-stat-label">Pending Events</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-cash-coin"></i></div>
                        <div class="perf-stat-num">₹${commissionsDue != null ? commissionsDue : 0}</div>
                        <div class="perf-stat-label">Commission Due</div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
function filterEvents() {
    const searchEl = document.getElementById('eventSearch');
    const table = document.getElementById('eventsTable');
    if (!searchEl || !table) return;
    const q = searchEl.value.toLowerCase();
    const status = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : '';
    table.querySelectorAll('tbody tr').forEach(r => {
        const nameMatch = !q || (r.dataset.name || '').includes(q);
        const statusMatch = !status || r.dataset.status === status;
        r.style.display = (nameMatch && statusMatch) ? '' : 'none';
    });
}
</script>
</body>
</html>
