<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Routine Safety Reminders</title>
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/reminders-theme.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="fdf-page-shell fdf-page-reminders">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper">

    <main class="fdf-page-main">
      <header class="fdf-page-header">
        <div>
          <h1 class="fdf-page-title">Safety Reminders</h1>
          <p class="fdf-page-subtitle">Web-only: reminders appear when you're online.</p>
        </div>
      </header>

      <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
      </c:if>

      <div class="fdf-card fdf-card--rose">
        <h5 class="fdf-card-title">Add reminder</h5>
        <form action="${pageContext.request.contextPath}/reminders/add" method="post" class="row g-3">
          <div class="col-12 col-md-6 col-lg-2">
            <label class="form-label">Title</label>
            <input class="form-control" name="title" maxlength="40" placeholder="Title" required>
          </div>
          <div class="col-12 col-md-6 col-lg-3">
            <label class="form-label">Message</label>
            <input class="form-control" name="message" maxlength="140" placeholder="Message" required>
          </div>
          <div class="col-12 col-md-4 col-lg-2">
            <label class="form-label">Weekly day</label>
            <select class="form-select" name="dayOfWeek">
              <option value="">-- Weekly Day --</option>
              <c:forEach var="d" items="${days}">
                <option value="${d}">${d}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-12 col-md-4 col-lg-2">
            <label class="form-label">Date</label>
            <input class="form-control" type="date" name="reminderDate">
          </div>
          <div class="col-12 col-md-4 col-lg-2">
            <label class="form-label">Time</label>
            <input class="form-control" type="time" name="timeOfDay" required>
          </div>
          <div class="col-12 col-lg-1 d-grid align-items-end">
            <button class="btn fdf-btn-primary" type="submit">ADD</button>
          </div>
        </form>
      </div>

      <div class="fdf-card">
        <h5 class="fdf-card-title">Your reminders</h5>
        <c:if test="${empty reminders}">
          <div class="fdf-empty-state">No reminders yet.</div>
        </c:if>
        <c:if test="${not empty reminders}">
          <div class="fdf-table-wrap">
            <table class="table align-middle">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Message</th>
                  <th>Day/Date</th>
                  <th>Time</th>
                  <th>Enabled</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:forEach var="r" items="${reminders}">
                <tr>
                  <td class="fw-semibold">${r.title}</td>
                  <td class="small fdf-muted">${r.message}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty r.reminderDate}">
                        <span class="fdf-badge">${r.reminderDate}</span>
                      </c:when>
                      <c:otherwise>
                        <span class="fdf-badge-day">${r.dayOfWeek}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="fw-bold">${r.timeOfDay}</td>
                  <td>
                    <span class="badge ${r.enabled ? 'bg-success' : 'bg-secondary'}">${r.enabled ? 'On' : 'Off'}</span>
                  </td>
                  <td>
                    <div class="d-flex flex-wrap gap-2">
                      <form action="${pageContext.request.contextPath}/reminders/toggle" method="post">
                        <input type="hidden" name="id" value="${r.id}">
                        <button class="btn btn-sm btn-outline-info" type="submit">Toggle</button>
                      </form>
                      <form action="${pageContext.request.contextPath}/reminders/delete" method="post">
                        <input type="hidden" name="id" value="${r.id}">
                        <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>
      </div>
    </main>
  </div>
</div>
</body>
</html>
