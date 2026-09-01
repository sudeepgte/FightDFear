<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Registrations — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css"/>
    <style>
        .reg-count-badge {
            background: var(--fdf-rose-soft); color: var(--fdf-accent);
            border-radius: 12px; padding: 2px 10px; font-size: 0.75rem; font-weight: 700;
        }
        .reg-search-wrap { position: relative; }
        .reg-search-wrap i {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: var(--fdf-text-muted); font-size: 0.9rem;
        }
        .reg-search-input {
            border: 1px solid var(--fdf-border); border-radius: 10px;
            padding: 8px 14px 8px 36px; font-family: inherit; font-size: 0.85rem;
            outline: none; width: 220px; background: var(--fdf-white); color: var(--fdf-navy);
        }
        .reg-search-input:focus { border-color: var(--fdf-accent); box-shadow: 0 0 0 3px var(--fdf-accent-shadow); }

        .user-cell { display: flex; align-items: center; gap: 10px; }
        .u-avatar {
            width: 34px; height: 34px; border-radius: 50%; background: var(--fdf-accent);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 700; font-size: 0.85rem; flex-shrink: 0;
        }
        .u-name { font-weight: 700; font-size: 0.87rem; color: var(--fdf-navy); }
        .u-email { font-size: 0.73rem; color: var(--fdf-text-muted); }

        .event-name { font-weight: 700; font-size: 0.87rem; color: var(--fdf-navy); }
        .event-city { font-size: 0.73rem; color: var(--fdf-text-muted); }

        .ticket-code {
            background: var(--fdf-rose-soft); color: var(--fdf-accent);
            padding: 3px 8px; border-radius: 6px; font-size: 0.8rem;
        }

        .status-pill {
            border-radius: 20px; padding: 4px 12px; font-size: 0.72rem;
            font-weight: 700; display: inline-block;
        }
        .st-REGISTERED { background: #F0FDF4; color: #166534; }
        .st-ATTENDED { background: var(--fdf-rose-soft); color: var(--fdf-accent); }
        .st-CANCELLED { background: #FEF2F2; color: #B91C1C; }

        .checked-yes { color: #16A34A; font-weight: 700; font-size: 0.82rem; }
        .checked-no { color: var(--fdf-text-muted); font-size: 0.82rem; }
    </style>
</head>
<body class="org-hub">

<%@ include file="../fragments/organizer-sidebar.jsp" %>

<div class="org-main-wrapper">
    <div class="org-topbar">
        <div class="org-topbar-left">
            <h2>Registrations</h2>
            <p>All users who registered for your events.</p>
        </div>
        <div class="org-topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="org-btn-secondary">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="org-page-content">
        <div class="org-card">
            <div class="org-card-header">
                <div class="org-card-title">
                    <i class="bi bi-people"></i> All Registrations
                    <span class="reg-count-badge">${fn:length(allRegistrations)}</span>
                </div>
                <div class="reg-search-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="reg-search-input" placeholder="Search attendee or event..." id="regSearch" onkeyup="filterRegs()"/>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty allRegistrations}">
                    <div class="org-table-wrap">
                        <table id="regTable">
                            <thead>
                                <tr>
                                    <th>Attendee</th>
                                    <th>Event</th>
                                    <th>Registered On</th>
                                    <th>Ticket Code</th>
                                    <th>Status</th>
                                    <th>Checked In</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reg" items="${allRegistrations}">
                                    <c:set var="userName" value="${reg.user != null ? reg.user.fullName : 'Guest'}"/>
                                    <c:set var="userEmail" value="${reg.user != null ? reg.user.email : '—'}"/>
                                    <c:set var="eventName" value="${reg.event != null ? reg.event.name : '—'}"/>
                                    <c:set var="eventCity" value="${reg.event != null ? reg.event.city : ''}"/>
                                    <c:set var="searchKey" value="${fn:toLowerCase(userName)} ${fn:toLowerCase(eventName)}"/>
                                    <tr data-search="${searchKey}">
                                        <td>
                                            <div class="user-cell">
                                                <div class="u-avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty userName}">${fn:substring(userName, 0, 1)}</c:when>
                                                        <c:otherwise>?</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div>
                                                    <div class="u-name"><c:out value="${userName}"/></div>
                                                    <div class="u-email"><c:out value="${userEmail}"/></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="event-name"><c:out value="${eventName}"/></div>
                                            <div class="event-city"><c:out value="${eventCity}"/></div>
                                        </td>
                                        <td style="font-size:0.83rem;color:var(--fdf-text-muted);">${reg.registeredAt}</td>
                                        <td><code class="ticket-code"><c:out value="${reg.ticketCode}"/></code></td>
                                        <td><span class="status-pill st-${reg.status}">${reg.status}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reg.checkedIn}">
                                                    <span class="checked-yes"><i class="bi bi-check-circle-fill"></i> Yes</span>
                                                </c:when>
                                                <c:otherwise><span class="checked-no">No</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="org-empty">
                        <i class="bi bi-people"></i>
                        <h5 style="font-weight:700;color:var(--fdf-navy);margin-bottom:8px;">No registrations yet</h5>
                        <p>When users register for your events, they'll appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
function filterRegs() {
    const searchEl = document.getElementById('regSearch');
    const table = document.getElementById('regTable');
    if (!searchEl || !table) return;
    const q = searchEl.value.toLowerCase();
    table.querySelectorAll('tbody tr').forEach(r => {
        r.style.display = !q || (r.dataset.search || '').includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
