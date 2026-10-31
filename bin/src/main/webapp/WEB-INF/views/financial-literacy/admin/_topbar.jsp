<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%-- Shared FL Admin Topbar --%>
<div class="ap-topbar">
  <div class="ap-topbar-left">
    <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
    <div class="ap-search" style="max-width:360px;">
      <i class="fas fa-search"></i>
      <input type="search" id="apHeaderSearch" placeholder="Search anything..." aria-label="Search">
      <span class="ap-kbd">Ctrl + K</span>
    </div>
  </div>
  <div class="ap-topbar-right" style="display:flex;align-items:center;gap:10px;">
    <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
      <i class="fas fa-bell"></i>
      <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
    </a>
    <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
      <span class="ap-avatar">
        <c:choose>
          <c:when test="${not empty admin.profilePhoto}">
            <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
          </c:when>
          <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
        </c:choose>
      </span>
      <span>
        <div class="name"><c:out value="${admin.name}"/></div>
        <div class="role">Super Admin</div>
      </span>
    </a>
  </div>
</div>
