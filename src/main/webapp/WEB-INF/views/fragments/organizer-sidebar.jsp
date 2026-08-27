<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="nav" value="${empty organizerNavActive ? 'dashboard' : organizerNavActive}"/>
<c:set var="hostInitial" value="${not empty host.fullName ? fn:substring(host.fullName, 0, 1) : 'H'}"/>

<aside class="org-sidebar">
    <div class="org-sidebar-brand">
        <div class="brand-icon"><i class="bi bi-calendar-heart-fill"></i></div>
        <span>Fight D Fear<br>Event Host</span>
    </div>
    <nav class="org-sidebar-nav">
        <div class="org-nav-label">Main</div>
        <a href="${ctx}/women-events/organizer/dashboard" class="org-nav-item ${nav eq 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i><span>Dashboard</span>
        </a>
        <a href="${ctx}/women-events/organizer/my-events" class="org-nav-item ${nav eq 'events' ? 'active' : ''}">
            <i class="bi bi-calendar3"></i><span>My Events</span>
        </a>
        <a href="${ctx}/women-events/organizer/create" class="org-nav-item ${nav eq 'create' ? 'active' : ''}">
            <i class="bi bi-plus-circle"></i><span>Create Event</span>
        </a>
        <a href="${ctx}/women-events/organizer/registrations" class="org-nav-item ${nav eq 'registrations' ? 'active' : ''}">
            <i class="bi bi-people"></i><span>Registrations</span>
        </a>
        <a href="${ctx}/women-events/organizer/notifications" class="org-nav-item ${nav eq 'notifications' ? 'active' : ''}">
            <i class="bi bi-bell"></i><span>Notifications</span>
            <c:if test="${newNotifCount != null && newNotifCount > 0}">
                <span class="nav-badge">${newNotifCount}</span>
            </c:if>
        </a>
        <div class="org-nav-label">Account</div>
        <a href="${ctx}/women-events/organizer/profile-completion" class="org-nav-item ${nav eq 'profile' ? 'active' : ''}">
            <i class="bi bi-person-circle"></i><span>Profile Completion</span>
        </a>
        <a href="${ctx}/women-events/organizer/settings" class="org-nav-item ${nav eq 'settings' ? 'active' : ''}">
            <i class="bi bi-gear"></i><span>Settings</span>
        </a>
        <a href="${ctx}/women-events/host/logout" class="org-nav-item">
            <i class="bi bi-box-arrow-right"></i><span>Logout</span>
        </a>
    </nav>
    <div class="org-sidebar-user">
        <div class="org-user-avatar">${hostInitial}</div>
        <div class="org-user-info">
            <div class="name"><c:out value="${not empty host.fullName ? host.fullName : 'Event Host'}"/></div>
            <div class="role"><c:out value="${not empty host.organizerType ? host.organizerType : 'Organizer'}"/></div>
        </div>
    </div>
</aside>
