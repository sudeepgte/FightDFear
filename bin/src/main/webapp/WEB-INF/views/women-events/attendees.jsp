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
    <style>
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; }
        .page-header { background: linear-gradient(135deg, #1e1b4b, #a855f7); padding: 40px 20px; color: white; }
        .container-main { max-width: 1000px; margin: 0 auto; padding: 36px 20px 60px; }
        .panel { background: white; border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; }
        .panel-header { padding: 20px 24px; border-bottom: 1px solid #f5f0f8; display: flex; justify-content: space-between; align-items: center; }
        .panel-title { font-weight: 700; color: #1e1b4b; font-size: 1.05rem; }
        table { width: 100%; border-collapse: collapse; }
        th { padding: 12px 18px; text-align: left; font-size: 0.78rem; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 0.5px; background: #faf7fb; }
        td { padding: 12px 18px; border-top: 1px solid #f5f0f8; font-size: 0.9rem; }
        .ticket-code { font-family: monospace; font-size: 0.85rem; background: #f5f0f8; color: #1e1b4b; padding: 3px 8px; border-radius: 6px; }
        .status-pill { border-radius: 20px; padding: 3px 10px; font-size: 0.75rem; font-weight: 700; }
        .status-REGISTERED { background: #dcfce7; color: #166534; }
        .status-CANCELLED  { background: #ffe4e6; color: #9f1239; }
        .status-ATTENDED   { background: #dbeafe; color: #1e40af; }
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
                            <td>${reg.user.phoneNumber}</td>
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
