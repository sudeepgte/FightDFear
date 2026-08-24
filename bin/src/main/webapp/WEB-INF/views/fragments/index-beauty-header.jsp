<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Beauty/index section header: Home goes to public homepage without logging out.
     Dashboard link is role-aware: logged-in USER always gets User Dashboard first. --%>
<header id="header" class="header d-flex align-items-center sticky-top">
  <div class="container-fluid container-xl d-flex align-items-center">
    <c:choose>
      <c:when test="${not empty sessionScope.user}">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedSalon}">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="logo me-auto"><h1>Fight D Fear</h1></a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedProvider || not empty sessionScope.loggedCentre || not empty sessionScope.loggedDoctor || not empty sessionScope.loggedStylist || not empty sessionScope.loggedSeller || not empty sessionScope.admin}">
        <a href="${pageContext.request.contextPath}/" class="logo me-auto"><h1>Fight D Fear</h1></a>
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
      <c:when test="${not empty sessionScope.user}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/users/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedProvider}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/marketplace/provider/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedCentre}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/centres/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedDoctor}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/doctors/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedSalon}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/salons/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedStylist}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/stylists/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.loggedSeller}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/women-products/seller/dashboard">My Dashboard</a>
      </c:when>
      <c:when test="${not empty sessionScope.admin}">
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/admin/adminDashboard">My Dashboard</a>
      </c:when>
      <c:otherwise>
        <a class="btn-getstarted" href="${pageContext.request.contextPath}/login">Login</a>
      </c:otherwise>
    </c:choose>
  </div>
</header>
