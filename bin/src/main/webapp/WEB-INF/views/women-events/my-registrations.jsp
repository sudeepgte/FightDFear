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
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; color: #1a1a2e; }

        .page-header { background: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            padding: 50px 20px; color: white; text-align: center; }
        .page-header h1 { font-size: 2.2rem; font-weight: 800; margin-bottom: 8px; }

        .container-main { max-width: 900px; margin: 0 auto; padding: 40px 20px 60px; }

        /* Ticket card */
        .ticket { background: white; border-radius: 24px; overflow: hidden; margin-bottom: 24px;
            box-shadow: 0 8px 40px rgba(244,63,94,0.08); transition: transform 0.3s; }
        .ticket:hover { transform: translateY(-4px); }
        .ticket-header { background: linear-gradient(135deg, #1e1b4b, #f43f5e); color: white;
            padding: 20px 28px; display: flex; justify-content: space-between; align-items: flex-start; }
        .ticket-name { font-size: 1.25rem; font-weight: 800; }
        .ticket-cat { font-size: 0.78rem; opacity: 0.85; margin-top: 4px; }
        .status-badge { border-radius: 20px; padding: 4px 14px; font-size: 0.78rem; font-weight: 700; }
        .status-REGISTERED { background: #bbf7d0; color: #15803d; }
        .status-CANCELLED { background: #fecdd3; color: #be123c; }
        .status-ATTENDED  { background: #e0f2fe; color: #0369a1; }

        .ticket-body { display: grid; grid-template-columns: 1fr auto; gap: 20px; padding: 24px 28px; }
        @media (max-width: 600px) { .ticket-body { grid-template-columns: 1fr; } }

        .ticket-details { display: flex; flex-direction: column; gap: 10px; }
        .detail-row { display: flex; align-items: center; gap: 10px; font-size: 0.9rem; }
        .detail-row .icon { color: #1e1b4b; width: 20px; text-align: center; }
        .detail-label { color: #888; min-width: 100px; }
        .detail-value { font-weight: 600; color: #1a1a2e; }

        /* QR / Ticket code */
        .qr-section { text-align: center; background: #faf7fb; border-radius: 16px; padding: 20px;
            min-width: 160px; display: flex; flex-direction: column; align-items: center; gap: 10px; border: 2px dashed #d8b4fe; }
        .qr-code-box { width: 120px; height: 120px; background: white; border: 2px solid #1e1b4b;
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            position: relative; overflow: hidden; }
        .qr-pattern { width: 100%; height: 100%; background:
            repeating-linear-gradient(0deg, #1e1b4b11 0px, #1e1b4b11 4px, transparent 4px, transparent 8px),
            repeating-linear-gradient(90deg, #1e1b4b11 0px, #1e1b4b11 4px, transparent 4px, transparent 8px); }
        .ticket-code { font-family: monospace; font-size: 1rem; font-weight: 800; color: #1e1b4b;
            letter-spacing: 2px; background: white; border: 2px solid #1e1b4b; border-radius: 8px;
            padding: 6px 14px; display: inline-block; }
        .qr-label { font-size: 0.72rem; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        .ticket-actions { padding: 0 28px 20px; display: flex; gap: 10px; flex-wrap: wrap; }
        .action-btn { border-radius: 20px; padding: 8px 18px; font-size: 0.85rem; font-weight: 600;
            text-decoration: none; border: 1.5px solid; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px; }
        .action-btn-primary { background: #1e1b4b; color: white; border-color: #1e1b4b; }
        .action-btn-primary:hover { background: #f43f5e; color: white; }
        .action-btn-outline { background: transparent; color: #1e1b4b; border-color: #1e1b4b; }
        .action-btn-outline:hover { background: #1e1b4b; color: white; }
        .action-btn-danger { background: transparent; color: #be123c; border-color: #be123c; }
        .action-btn-danger:hover { background: #be123c; color: white; }

        .empty-state { text-align: center; padding: 80px 20px; }
        .empty-state .icon { font-size: 4rem; display: block; margin-bottom: 16px; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip; background: #faf7fb;">

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show m-3 rounded-3">
        <i class="bi bi-check-circle-fill me-2"></i>${success}
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
        <a href="${pageContext.request.contextPath}/women-events" class="btn btn-sm rounded-pill" style="background:linear-gradient(135deg,#1e1b4b,#a855f7); color:white; font-weight:600;">
            <i class="bi bi-search me-1"></i> Browse More Events
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty registrations}">
            <c:forEach var="reg" items="${registrations}">
                <div class="ticket">
                    <div class="ticket-header">
                        <div>
                            <div class="ticket-name">${reg.event.name}</div>
                            <div class="ticket-cat"><i class="bi bi-tag-fill me-1"></i>${reg.event.category.displayName}</div>
                        </div>
                        <span class="status-badge status-${reg.status}">${reg.status}</span>
                    </div>

                    <div class="ticket-body">
                        <div class="ticket-details">
                            <div class="detail-row">
                                <i class="bi bi-calendar3 icon"></i>
                                <span class="detail-label">Date</span>
                                <span class="detail-value">${reg.event.eventDate} <c:if test="${not empty reg.event.eventTime}">at ${reg.event.eventTime}</c:if></span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-geo-alt-fill icon"></i>
                                <span class="detail-label">Venue</span>
                                <span class="detail-value">${reg.event.venue}, ${reg.event.city}</span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-building icon"></i>
                                <span class="detail-label">Organizer</span>
                                <span class="detail-value">${reg.event.organizerName}</span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-cash icon"></i>
                                <span class="detail-label">Entry Fee</span>
                                <span class="detail-value" style="color:${reg.event.free ? '#15803d' : '#c2410c'};">
                                    ${reg.event.free ? 'FREE' : '₹'.concat(reg.event.entryFee.toString())}
                                </span>
                            </div>
                            <div class="detail-row">
                                <i class="bi bi-clock icon"></i>
                                <span class="detail-label">Registered</span>
                                <span class="detail-value" style="font-size:0.82rem; color:#888;">${reg.registeredAt}</span>
                            </div>
                        </div>

                        <div class="qr-section">
                            <div class="qr-label">Digital Ticket</div>
                            <div class="qr-code-box">
                                <div class="qr-pattern"></div>
                                <div style="position:absolute; background:white; padding:6px; border-radius:6px; font-size:1.2rem;">🎫</div>
                            </div>
                            <div class="ticket-code">${reg.ticketCode}</div>
                            <div class="qr-label">Show at entry</div>
                        </div>
                    </div>

                    <div class="ticket-actions">
                        <a href="${pageContext.request.contextPath}/women-events/${reg.event.id}" class="action-btn action-btn-primary">
                            <i class="bi bi-eye-fill"></i> View Event
                        </a>
                        <button onclick="window.print()" class="action-btn action-btn-outline">
                            <i class="bi bi-printer-fill"></i> Print Ticket
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
                <span class="icon">🎫</span>
                <h4 style="font-weight:700; color:#555;">No Registrations Yet</h4>
                <p class="text-muted">You haven't registered for any events yet.</p>
                <a href="${pageContext.request.contextPath}/women-events" class="btn rounded-pill mt-2"
                   style="background:linear-gradient(135deg,#1e1b4b,#f43f5e); color:white; font-weight:700; padding:12px 30px;">
                    Discover Events
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

    </div>
</div>
</body>
</html>
