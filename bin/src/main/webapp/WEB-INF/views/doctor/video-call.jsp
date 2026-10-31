<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
  <c:when test="${not empty appointment and not empty appointment.doctor}">
    <c:redirect url="/doctors/video-call/${appointment.doctor.id}?userId=${appointment.user.id}&notify=true"/>
  </c:when>
  <c:when test="${not empty doctorId}">
    <c:redirect url="/doctors/video-call/${doctorId}?notify=true"/>
  </c:when>
  <c:otherwise>
    <c:redirect url="/doctors/dashboard"/>
  </c:otherwise>
</c:choose>
