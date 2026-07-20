<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Beauty/index section header: Home goes to public homepage without logging out. --%>
<header id="header" class="header d-flex align-items-center sticky-top">
  <div class="container-fluid container-xl d-flex align-items-center">
    <c:choose>
      <c:when test="${not empty sessionScope.user || not empty sessionScope.loggedProvider || not empty sessionScope.loggedCentre || not empty sessionScope.loggedDoctor || not empty sessionScope.loggedSalon || not empty sessionScope.loggedStylist || not empty sessionScope.loggedSeller || not empty sessionScope.admin}">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/" class="logo me-auto"><h1>Fight D Fear</h1></a>
      </c:otherwise>
    </c:choose>
    <nav id="navmenu" class="navmenu">
      <ul>
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/index/templates">Beauty</a></li>
        <li><a href="${pageContext.request.contextPath}/user/salons">Salons</a></li>
        <li><a href="${pageContext.request.contextPath}/user/stylists">Stylists</a></li>
        <li><a href="${pageContext.request.contextPath}/index/about">About</a></li>
        <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
      </ul>
      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
    </nav>
    <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
    <c:choose>
      <c:when test="${not empty sessionScope.user || not empty sessionScope.loggedProvider || not empty sessionScope.loggedCentre || not empty sessionScope.loggedDoctor || not empty sessionScope.loggedSalon || not empty sessionScope.loggedStylist || not empty sessionScope.loggedSeller || not empty sessionScope.admin}">
        <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/users/dashboard" />
        <c:if test="${not empty sessionScope.loggedProvider}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/marketplace/provider/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.loggedCentre}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/centres/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.loggedDoctor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/doctors/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.loggedSalon}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/salons/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.loggedStylist}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/stylists/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.loggedSeller}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/women-products/seller/dashboard" /></c:if>
        <c:if test="${not empty sessionScope.admin}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/adminDashboard" /></c:if>
        <a class="btn-getstarted" href="${dashboardUrl}">My Dashboard</a>
      </c:when>
      <c:otherwise>
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/login">Login</a>
      </c:otherwise>
    </c:choose>
  </div>
</header>

