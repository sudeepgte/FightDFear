<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
  Shared Financial Literacy Admin sidebar.
  Pass active via request attribute "flAdminActive" or request param "active":
  home | add-video | add-live-session | add-workshop | registrations
--%>
<c:set var="activeNav" value="${not empty flAdminActive ? flAdminActive : param.active}" />
<div class="sidebar">
  <div class="mb-4">
    <a href="${pageContext.request.contextPath}/financial-literacy/admin"
       class="navlink ${activeNav == 'home' ? 'active' : ''}">
      <i class="fas fa-book"></i> Financial Educator
    </a>
  </div>

  <h6 class="sidebar-section-title">Videos</h6>
  <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video"
     class="navlink ${activeNav == 'add-video' ? 'active' : ''}">
    <i class="fas fa-plus-circle"></i> Add Recorded Video
  </a>

  <h6 class="sidebar-section-title spaced">Live Sessions</h6>
  <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session"
     class="navlink ${activeNav == 'add-live-session' ? 'active' : ''}">
    <i class="fas fa-video"></i> Add Live Virtual Session
  </a>

  <h6 class="sidebar-section-title spaced">Workshops</h6>
  <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop"
     class="navlink ${activeNav == 'add-workshop' ? 'active' : ''}">
    <i class="fas fa-calendar-check"></i> Add Offline Workshop
  </a>
  <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations"
     class="navlink ${activeNav == 'registrations' ? 'active' : ''}">
    <i class="fas fa-users"></i> View Registrations
  </a>
</div>
