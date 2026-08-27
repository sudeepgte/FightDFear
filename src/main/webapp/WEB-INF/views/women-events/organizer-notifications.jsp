<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Notifications — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css"/>
    <style>
        .notif-count-badge {
            background: var(--fdf-rose-soft); color: var(--fdf-accent);
            border-radius: 12px; padding: 2px 10px; font-size: 0.75rem; font-weight: 700;
        }
        .notif-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 20px; border-bottom: 1px solid var(--fdf-border);
            transition: background 0.15s;
        }
        .notif-item:last-child { border-bottom: none; }
        .notif-item:hover { background: var(--fdf-rose-soft); }
        .notif-icon {
            width: 42px; height: 42px; border-radius: 50%;
            background: var(--fdf-accent); display: flex; align-items: center;
            justify-content: center; font-size: 1.1rem; color: #fff; flex-shrink: 0;
        }
        .notif-body { flex: 1; min-width: 0; }
        .notif-msg { font-size: 0.88rem; font-weight: 600; color: var(--fdf-navy); }
        .notif-msg .accent { color: var(--fdf-accent); }
        .notif-meta { font-size: 0.78rem; color: var(--fdf-text-muted); margin-top: 3px; }
        .notif-time { font-size: 0.75rem; color: var(--fdf-text-muted); white-space: nowrap; }
    </style>
</head>
<body class="org-hub">

<%@ include file="../fragments/organizer-sidebar.jsp" %>

<div class="org-main-wrapper">
    <div class="org-topbar">
        <div class="org-topbar-left">
            <h2>Notifications</h2>
            <p>New event registrations and activity alerts.</p>
        </div>
        <div class="org-topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="org-btn-secondary">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="org-page-content org-page-content--narrow">
        <div class="org-card">
            <div class="org-card-header">
                <div class="org-card-title">
                    <i class="bi bi-bell"></i> Recent Activity
                    <span class="notif-count-badge">${fn:length(notifications)}</span>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach var="reg" items="${notifications}">
                        <div class="notif-item">
                            <div class="notif-icon"><i class="bi bi-person-fill"></i></div>
                            <div class="notif-body">
                                <div class="notif-msg">
                                    <span class="accent"><c:out value="${not empty reg.user ? reg.user.fullName : 'A user'}"/></span>
                                    <c:choose>
                                        <c:when test="${reg.status == 'CANCELLED'}"> cancelled their registration for</c:when>
                                        <c:when test="${reg.status == 'ATTENDED'}"> attended</c:when>
                                        <c:otherwise> registered for</c:otherwise>
                                    </c:choose>
                                    <strong><c:out value="${not empty reg.event ? reg.event.name : 'an event'}"/></strong>
                                </div>
                                <div class="notif-meta">
                                    <c:if test="${not empty reg.ticketCode}">
                                        <i class="bi bi-ticket-perforated"></i> <c:out value="${reg.ticketCode}"/>
                                    </c:if>
                                    <c:if test="${not empty reg.event and not empty reg.event.city}">
                                        &nbsp;&middot;&nbsp;
                                        <i class="bi bi-geo-alt"></i> <c:out value="${reg.event.city}"/>
                                    </c:if>
                                </div>
                            </div>
                            <div class="notif-time"><c:out value="${reg.registeredAt}"/></div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="org-empty">
                        <i class="bi bi-bell-slash"></i>
                        <h5 style="font-weight:700;color:var(--fdf-navy);margin-bottom:8px;">No notifications yet</h5>
                        <p>When users register for your events, notifications will appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
