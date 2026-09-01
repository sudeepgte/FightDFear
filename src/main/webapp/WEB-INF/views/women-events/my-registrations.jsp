<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Event Tickets — Women Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css"/>
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    <style>
      .we-modal-overlay { display:none; position:fixed; inset:0; background:rgba(15,23,42,.45); z-index:2000; align-items:center; justify-content:center; padding:20px; }
      .we-modal-overlay.open { display:flex; }
    </style>
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: var(--we-bg); color: var(--we-navy); }

        .page-header { background: var(--we-navy); padding: 44px 20px; color: white; text-align: center; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 8px; }
        .page-header p { opacity: 0.8; margin: 0; }

        .container-main { max-width: 900px; margin: 0 auto; padding: 40px 20px 60px; }

        .ticket { background: white; border-radius: 18px; overflow: hidden; margin-bottom: 20px;
            border: 1px solid var(--we-border); box-shadow: var(--we-shadow); cursor: pointer; }
        .ticket:hover { border-color: #FDA4AF; }
        .ticket-header { background: var(--we-navy); color: white;
            padding: 18px 24px; display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; }
        .ticket-name { font-size: 1.15rem; font-weight: 800; }
        .ticket-cat { font-size: 0.78rem; opacity: 0.85; margin-top: 4px; }

        .ticket-body { display: grid; grid-template-columns: 1fr auto; gap: 20px; padding: 22px 24px; }
        @media (max-width: 600px) { .ticket-body { grid-template-columns: 1fr; } }

        .ticket-details { display: flex; flex-direction: column; gap: 10px; }
        .detail-row { display: flex; align-items: center; gap: 10px; font-size: 0.9rem; }
        .detail-row .icon { color: var(--we-accent); width: 20px; text-align: center; }
        .detail-label { color: var(--we-muted); min-width: 100px; }
        .detail-value { font-weight: 600; color: var(--we-navy); }

        .qr-section { text-align: center; background: var(--we-bg); border-radius: 14px; padding: 16px;
            min-width: 160px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1px dashed var(--we-border); }
        .ticket-code { font-family: ui-monospace, monospace; font-size: 1rem; font-weight: 800; color: var(--we-navy);
            letter-spacing: 1.5px; background: white; border: 1px solid var(--we-border); border-radius: 8px;
            padding: 8px 12px; display: inline-block; }
        .qr-label { font-size: 0.72rem; color: var(--we-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        .ticket-actions { padding: 0 24px 18px; display: flex; gap: 10px; flex-wrap: wrap; }
        .action-btn { border-radius: 10px; padding: 8px 16px; font-size: 0.85rem; font-weight: 700;
            text-decoration: none; border: 1px solid; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; font-family: inherit; }
        .action-btn-primary { background: var(--we-accent); color: white; border-color: var(--we-accent); }
        .action-btn-outline { background: transparent; color: var(--we-navy); border-color: var(--we-border); }
        .action-btn-danger { background: transparent; color: var(--we-danger-text); border-color: #FECACA; }

        .browse-btn { background: var(--we-accent); color: white; font-weight: 700; border: none; }
        .empty-state { text-align: center; padding: 80px 20px; background: white; border-radius: 16px; border: 1px dashed var(--we-border); }
        .empty-state .icon { font-size: 2.4rem; display: block; margin-bottom: 16px; color: var(--we-accent); }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip; background: var(--we-bg);">

<c:if test="${not empty success}">
    <div class="container-main" style="padding-bottom:0;">
        <div class="we-confirm-banner">
            <h3>Registration confirmed</h3>
            <p>${success}</p>
        </div>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show m-3 rounded-3">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Header -->
<div class="page-header">
    <h1><i class="bi bi-ticket-perforated-fill me-2"></i>My Event Tickets</h1>
    <p style="opacity:0.85; margin:0;">Your registered events and digital tickets</p>
</div>

<div class="container-main">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div style="font-weight:600; color:#555;">${registrations.size()} registration${registrations.size() != 1 ? 's' : ''}</div>
        <a href="${pageContext.request.contextPath}/women-events" class="btn btn-sm rounded-pill browse-btn">
            <i class="bi bi-search me-1"></i> Browse events
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty registrations}">
            <c:forEach var="reg" items="${registrations}">
                <div class="ticket" onclick="openTicketPreview(this)"
                     data-name="${reg.event.name}"
                     data-organizer="${reg.event.organizerName}"
                     data-date="${reg.event.eventDate}"
                     data-time="${reg.event.eventTime}"
                     data-venue="${reg.event.venue}"
                     data-city="${reg.event.city}"
                     data-status="${reg.status}"
                     data-role="${reg.role}"
                     data-code="${reg.ticketCode}"
                     data-paid="${reg.paid}"
                     data-amount="${reg.amountPaid}"
                     data-checked="${reg.checkedIn}"
                     data-registered="${reg.registeredAt}"
                     data-event-id="${reg.event.id}"
                     data-can-cancel="${reg.status == 'REGISTERED'}">
                    <div class="ticket-header">
                        <div>
                            <div class="ticket-name">${reg.event.name}</div>
                            <div class="ticket-cat"><i class="bi bi-tag-fill me-1"></i>${reg.event.category.displayName}</div>
                        </div>
                        <span class="we-status ${reg.status == 'REGISTERED' ? 'registered' : (reg.status == 'ATTENDED' ? 'attended' : 'cancelled')}">${reg.status}</span>
                    </div>

                    <div class="ticket-body">
                        <div class="ticket-details">
                            <div class="detail-row">
                                <i class="bi bi-calendar3 icon"></i>
                                <span class="detail-label">Date</span>
                                <span class="detail-value">${not empty reg.event.eventDate ? reg.event.eventDate : 'Not provided'}<c:if test="${not empty reg.event.eventTime}"> · ${reg.event.eventTime}</c:if></span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-geo-alt-fill icon"></i>
                                <span class="detail-label">Venue</span>
                                <span class="detail-value">${not empty reg.event.venue ? reg.event.venue : 'Not provided'}<c:if test="${not empty reg.event.city}">, ${reg.event.city}</c:if></span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-building icon"></i>
                                <span class="detail-label">Organizer</span>
                                <span class="detail-value">${not empty reg.event.organizerName ? reg.event.organizerName : 'Not provided'}</span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-cash icon"></i>
                                <span class="detail-label">Entry</span>
                                <span class="detail-value"><c:choose><c:when test="${reg.event.free}">Free</c:when><c:otherwise>₹${reg.event.entryFee}</c:otherwise></c:choose></span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-person-badge icon"></i>
                                <span class="detail-label">Role</span>
                                <span class="detail-value">${not empty reg.role ? reg.role : 'ATTENDEE'}</span>
                            </div>
                        </div>

                        <div class="qr-section">
                            <div class="qr-label">Ticket code</div>
                            <div class="ticket-code">${reg.ticketCode}</div>
                            <div class="qr-label">Show at entry</div>
                        </div>
                    </div>

                    <div class="ticket-actions" onclick="event.stopPropagation()">
                        <a href="${pageContext.request.contextPath}/women-events/${reg.event.id}" class="action-btn action-btn-primary">
                            <i class="bi bi-eye-fill"></i> Event details
                        </a>
                        <button type="button" class="action-btn action-btn-outline" onclick="openTicketPreview(this.closest('.ticket'))">
                            <i class="bi bi-ticket-detailed"></i> Ticket preview
                        </button>
                        <c:if test="${reg.status == 'REGISTERED'}">
                            <form action="${pageContext.request.contextPath}/women-events/${reg.event.id}/cancel-registration" method="post" style="display:inline;"
                                  onsubmit="return confirm('Cancel your registration for this event?')">
                                <button type="submit" class="action-btn action-btn-danger">
                                    <i class="bi bi-x-circle-fill"></i> Cancel
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="bi bi-ticket-perforated icon"></i>
                <h4 style="font-weight:700; color:var(--we-navy);">No event bookings yet</h4>
                <p class="text-muted">When you register for a Women Event, your ticket will appear here.</p>
                <a href="${pageContext.request.contextPath}/women-events" class="btn rounded-pill mt-2 browse-btn"
                   style="padding:12px 28px;">
                    Discover events
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="ticketPreviewOverlay" class="we-modal-overlay" onclick="if(event.target===this)closeTicketPreview()">
    <div class="we-modal" role="dialog">
        <div class="we-modal-header">
            <div>
                <h3 id="tpName">Ticket</h3>
                <p id="tpStatusLine"></p>
            </div>
            <button type="button" class="we-modal-close" onclick="closeTicketPreview()" aria-label="Close">&times;</button>
        </div>
        <div class="we-modal-body" id="tpBody"></div>
        <div class="we-modal-footer">
            <a id="tpEventLink" href="#" class="we-modal-btn secondary">Event details</a>
            <form id="tpCancelForm" method="post" style="display:none;"
                  onsubmit="return confirm('Cancel your registration for this event?')">
                <button type="submit" class="we-modal-btn secondary">Cancel registration</button>
            </form>
            <button type="button" class="we-modal-btn primary" onclick="closeTicketPreview()">Close</button>
        </div>
    </div>
</div>
<script>
function valOr(v) { return (v && String(v).trim() && String(v) !== 'null') ? v : 'Not provided'; }
function openTicketPreview(el) {
    document.getElementById('tpName').textContent = valOr(el.dataset.name);
    document.getElementById('tpStatusLine').textContent = (el.dataset.status || '') + (el.dataset.role ? ' · ' + el.dataset.role : '');
    document.getElementById('tpBody').innerHTML =
        row('Ticket code', el.dataset.code) +
        row('Organizer', valOr(el.dataset.organizer)) +
        row('Date', valOr(el.dataset.date)) +
        row('Time', valOr(el.dataset.time)) +
        row('Venue', valOr(el.dataset.venue) + (el.dataset.city ? ', ' + el.dataset.city : '')) +
        row('Paid', el.dataset.paid === 'true' ? 'Yes' : 'No') +
        row('Amount paid', el.dataset.amount ? '₹' + el.dataset.amount : '—') +
        row('Checked in', el.dataset.checked === 'true' ? 'Yes' : 'No') +
        row('Registered at', valOr(el.dataset.registered));
    var link = document.getElementById('tpEventLink');
    link.href = '${pageContext.request.contextPath}/women-events/' + el.dataset.eventId;
    var cancel = document.getElementById('tpCancelForm');
    if (el.dataset.canCancel === 'true') {
        cancel.style.display = 'inline';
        cancel.action = '${pageContext.request.contextPath}/women-events/' + el.dataset.eventId + '/cancel-registration';
    } else {
        cancel.style.display = 'none';
    }
    document.getElementById('ticketPreviewOverlay').classList.add('open');
}
function row(k, v) {
    return '<div class="we-modal-row"><span class="k">' + k + '</span><span class="v">' + v + '</span></div>';
}
function closeTicketPreview() {
    document.getElementById('ticketPreviewOverlay').classList.remove('open');
}
</script>
    </div>
</div>
</body>
</html>
