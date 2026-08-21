<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
  Standard salon partner sidebar.
  Expects optional: salon (entity), salonId, activeNav (dashboard|profile|bookings|services|treatments|offers|reviews)
--%>
<c:set var="sid" value="${not empty salonId ? salonId : (not empty salon ? salon.id : '')}" />
<a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand sidebar-brand-desktop">
    <i class="bi bi-stars"></i>
    <span>Fight D Fear</span>
</a>

<nav class="nav flex-column">
    <a class="nav-link-custom ${activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/salons/dashboard">
        <i class="bi bi-grid-1x2-fill"></i>
        <span>Dashboard</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/salons/profile">
        <i class="bi bi-person-circle"></i>
        <span>Salon Profile</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/booking/list">
        <i class="bi bi-calendar-check"></i>
        <span>Manage Bookings</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'services' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/viewServices">
        <i class="bi bi-magic"></i>
        <span>Service Menu</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'treatments' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/treatments/view">
        <i class="bi bi-droplet-half"></i>
        <span>Specialized Treatments</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'offers' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sid}">
        <i class="bi bi-percent"></i>
        <span>Offers &amp; Promotions</span>
    </a>
    <a class="nav-link-custom ${activeNav == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/reviews/list">
        <i class="bi bi-star-half"></i>
        <span>Customer Reviews</span>
    </a>
    <div class="mt-5">
        <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/salons/logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Sign Out</span>
        </a>
    </div>
</nav>
