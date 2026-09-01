<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Attendees — ${event.name}</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css"/>
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    <style>
        body { font-family: 'Outfit', sans-serif; background: var(--we-bg); }
        .page-header { background: var(--we-navy); padding: 36px 20px; color: white; }
        .container-main { max-width: 1000px; margin: 0 auto; padding: 36px 20px 60px; }
        .panel { background: white; border-radius: 16px; box-shadow: var(--we-shadow); overflow: hidden; border: 1px solid var(--we-border); }
        .panel-header { padding: 20px 24px; border-bottom: 1px solid var(--we-border); display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap; }
        .panel-title { font-weight: 700; color: var(--we-navy); font-size: 1.05rem; }
        table { width: 100%; border-collapse: collapse; }
        th { padding: 12px 18px; text-align: left; font-size: 0.78rem; font-weight: 700; color: var(--we-muted); text-transform: uppercase; letter-spacing: 0.5px; background: var(--we-bg); }
        td { padding: 12px 18px; border-top: 1px solid var(--we-border); font-size: 0.9rem; }
        .ticket-code { font-family: ui-monospace, monospace; font-size: 0.85rem; background: var(--we-bg); color: var(--we-navy); padding: 3px 8px; border-radius: 6px; border: 1px solid var(--we-border); }
        .status-pill { border-radius: 20px; padding: 3px 10px; font-size: 0.75rem; font-weight: 700; }
        .status-REGISTERED { background: var(--we-success-bg); color: var(--we-success-text); }
        .status-CANCELLED  { background: var(--we-danger-bg); color: var(--we-danger-text); }
        .status-ATTENDED   { background: #F1F5F9; color: #475569; }
        @media (max-width: 720px) {
            table { min-width: 720px; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div class="page-header">
    <h2 style="font-weight:800; margin:0;">${event.name}</h2>
    <div style="opacity:0.85; font-size:0.9rem;">${attendees.size()} Registered Attendees</div>
</div>

<div class="container-main">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="btn btn-outline-secondary rounded-pill btn-sm">
            <i class="bi bi-chevron-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div class="panel-title"><i class="bi bi-people-fill me-2"></i>Attendees List</div>
            <div style="font-size:0.85rem; color:#888;">${attendees.size()} / ${not empty event.maxParticipants ? event.maxParticipants : '∞'} spots filled</div>
        </div>
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Ticket Code</th>
                        <th>Registered At</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="reg" items="${attendees}" varStatus="vs">
                        <tr>
                            <td style="color:#888;">${vs.index + 1}</td>
                            <td style="font-weight:600;">${reg.user.fullName}</td>
                            <td>${reg.user.email}</td>
                            <td>${not empty reg.user.phoneNumber ? reg.user.phoneNumber : 'Not provided'}</td>
                            <td><span class="ticket-code">${reg.ticketCode}</span></td>
                            <td style="font-size:0.82rem; color:#888;">${reg.registeredAt}</td>
                            <td><span class="status-pill status-${reg.status}">${reg.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty attendees}">
                        <tr><td colspan="7" class="text-center text-muted py-4">No registrations yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
