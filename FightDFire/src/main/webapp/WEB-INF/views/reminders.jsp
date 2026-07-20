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
  <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
<style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {img
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        background: linear-gradient(rgba(15, 15, 26, 0.9), rgba(124, 45, 94, 0.45)), url('${pageContext.request.contextPath}/assets/images/routine1.jpg');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        min-height: 100vh;
        margin: 0;
        font-family: 'Poppins', sans-serif;
        color: #fff;
    }
    /* Cards */

    .card { 
        background: rgba(0, 0, 0, 0.92); 
        border-radius: 20px !important; 
        padding: 25px !important; 
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.6); 
        border: 2px solid var(--primary-purple) !important;
        backdrop-filter: blur(15px);
        transition: transform 0.3s, box-shadow 0.3s;
        margin-bottom: 25px;
    }


    h5 { color: #fff; font-weight: 800; margin-bottom: 25px; letter-spacing: 0.5px; }
    .muted, .text-muted { color: #fff !important; opacity: 0.9; font-weight: 500; }
    .form-control::placeholder { color: rgba(255, 255, 255, 0.6) !important; font-weight: 300; }
    .form-control { color: #fff !important; font-weight: 500; }


    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        border-color: var(--primary-coral) !important;
    }

    /* Form controls */
    .form-control, .form-select {
        border-radius: 0.75rem;
        border: 1px solid rgba(123, 44, 191, 0.3);
        transition: all 0.2s;
    }
    .form-control:focus, .form-select:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        outline: none;
    }

    /* Primary button */
    .btn-primary {
        background: var(--gradient-primary);
        border: none;
        border-radius: 2rem;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
        transition: all 0.2s;
    }
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
        filter: brightness(1.02);
    }

    /* Outline secondary button (Back) */
    .btn-outline-secondary {
        border-color: var(--primary-purple-light);
        color: var(--primary-purple);
        border-radius: 2rem;
        transition: all 0.2s;
    }
    .btn-outline-secondary:hover {
        background-color: var(--primary-purple-light);
        border-color: var(--primary-purple-light);
        color: white;
        transform: translateY(-2px);
    }

    /* Table styling */
    .table {
        border-radius: 1rem;
        overflow: hidden;
    }
    .table thead th {
        background-color: var(--primary-purple);
        color: white;
        font-weight: 600;
        border-bottom: none;
    }
    .table tbody tr:hover {
        background-color: rgba(123, 44, 191, 0.05);
    }

    /* Alert */
    .alert-info {
        background-color: rgba(255, 215, 0, 0.1);
        border-left: 4px solid var(--primary-gold);
        color: var(--dark-bg);
        border-radius: 1rem;
    }

    /* Action buttons inside table */
    .btn-outline-secondary.btn-sm, .btn-outline-danger.btn-sm {
        border-radius: 2rem;
        padding: 0.25rem 0.75rem;
        font-size: 0.75rem;
    }
    .btn-outline-secondary.btn-sm:hover {
        background-color: var(--primary-purple-light);
        border-color: var(--primary-purple-light);
        color: white;
    }
    .btn-outline-danger.btn-sm:hover {
        background-color: var(--primary-coral-dark);
        border-color: var(--primary-coral-dark);
        color: white;
    }

    @media (max-width: 768px) {
        .card .row.g-2 {
            flex-direction: column;
        }
        .card .col-md-1.d-grid {
            margin-top: 0.5rem;
        }
        .table td, .table th {
            font-size: 0.85rem;
            padding: 0.5rem;
        }
        .d-flex.gap-2 {
            flex-direction: column;
            gap: 0.5rem !important;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole page */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Button ripple effect on click (micro-interaction) */
    .btn-primary, .btn-outline-secondary, .btn-outline-secondary.btn-sm, .btn-outline-danger.btn-sm {
        position: relative;
        overflow: hidden;
    }
    .btn-primary::after, .btn-outline-secondary::after, 
    .btn-outline-secondary.btn-sm::after, .btn-outline-danger.btn-sm::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-primary:active::after, .btn-outline-secondary:active::after,
    .btn-outline-secondary.btn-sm:active::after, .btn-outline-danger.btn-sm:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .btn-primary:focus-visible, .btn-outline-secondary:focus-visible,
    .btn-outline-secondary.btn-sm:focus-visible, .btn-outline-danger.btn-sm:focus-visible,
    .form-control:focus-visible, .form-select:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 2rem;
    }

    /* 4. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Table row hover enhancement – subtle scale */
    .table tbody tr {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 6. Card content hover effect – icon/scale inside (if any) */
    .card img, .card i {
        transition: transform 0.2s;
    }
    .card:hover img, .card:hover i {
        transform: scale(1.02);
    }

    /* 7. Alert hover effect – subtle background change */
    .alert-info {
        transition: background-color 0.2s, transform 0.2s;
    }
    .alert-info:hover {
        background-color: rgba(255, 215, 0, 0.2);
        transform: translateX(3px);
    }

    /* 8. Responsive touch improvements for very small screens */
    @media (max-width: 480px) {
        .btn-primary, .btn-outline-secondary {
            padding: 0.6rem 1rem;
            font-size: 0.85rem;
        }
        .card {
            padding: 0.75rem !important;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
    /* Dashboard Button Styling */
    .dashboard-btn {
        background: var(--gradient-primary);
        color: #fff !important;
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        font-family: 'Poppins', sans-serif;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
    }
    .dashboard-btn:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 8px 25px rgba(124, 45, 94, 0.45);
        color: #fff !important;
    }
    .dashboard-btn i {
        font-size: 1.2rem;
        transition: transform 0.3s ease;
    }
    .dashboard-btn:hover i {
        transform: translateX(5px);
    }
</style>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">


<div class="container py-4" style="max-width:1000px;">
  <div class="d-flex justify-content-between align-items-center mb-5" style="border-bottom: 1px solid rgba(124, 45, 94, 0.2); padding-bottom: 20px;">
    <div>
      <h1 class="mb-1" style="font-weight: 800; background: var(--gradient-primary); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Safety Reminders</h1>
      <div class="muted">Web-only: reminders appear when you’re online.</div>
    </div>
    <a href="${pageContext.request.contextPath}/users/dashboard" class="dashboard-btn">
      Dashboard <i class="bi bi-arrow-right"></i>
    </a>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-info">${message}</div>
  </c:if>

  <div class="card">
    <h5 class="mb-4 fw-bold">Add reminder</h5>
    <form action="${pageContext.request.contextPath}/reminders/add" method="post" class="row g-3">
      <div class="col-md-3">
        <input class="form-control" name="title" maxlength="40" placeholder="Title" required style="background: rgba(255, 255, 255, 0.1); border: 2px solid var(--primary-purple); color:#fff; border-radius: 10px;">
      </div>
      <div class="col-md-4">
        <input class="form-control" name="message" maxlength="140" placeholder="Message" required style="background: rgba(255, 255, 255, 0.1); border: 2px solid var(--primary-purple); color:#fff; border-radius: 10px;">
      </div>


      <div class="col-md-2">
        <select class="form-select" name="dayOfWeek" style="background: rgba(255,255,255,0.08); border-color: rgba(166,66,129,0.3); color:#fff;">
          <option value="" style="background: #1a0a1a;">-- Weekly Day --</option>
          <c:forEach var="d" items="${days}">
            <option value="${d}" style="background: #1a0a1a;">${d}</option>
          </c:forEach>
        </select>
      </div>
      <div class="col-md-2">
        <input class="form-control" type="date" name="reminderDate" style="background: rgba(255,255,255,0.08); border-color: rgba(166,66,129,0.3); color:#fff;">
      </div>
      <div class="col-md-2">
        <input class="form-control" type="time" name="timeOfDay" required style="background: rgba(255,255,255,0.08); border-color: rgba(166,66,129,0.3); color:#fff;">
      </div>
      <div class="col-md-1 d-grid">
        <button class="btn" type="submit" style="background: var(--gradient-primary); color:#fff; font-weight:700; border-radius:10px;">ADD</button>
      </div>
    </form>
  </div>

  <div class="card">
    <h5 class="mb-4 fw-bold">Your reminders</h5>
    <c:if test="${empty reminders}">
      <div class="muted">No reminders yet.</div>
    </c:if>
    <c:if test="${not empty reminders}">
      <div class="table-responsive">
        <table class="table align-middle" style="color: #fff; border-color: rgba(124, 45, 94, 0.3);">
          <thead>
            <tr style="background: rgba(124, 45, 94, 0.2);">
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
            <tr style="border-bottom: 1px solid rgba(30, 27, 75, 0.1);">
              <td>${r.title}</td>
              <td class="small">${r.message}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty r.reminderDate}">
                    <span class="badge" style="background: var(--gradient-primary);">${r.reminderDate}</span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-info">${r.dayOfWeek}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="fw-bold">${r.timeOfDay}</td>
              <td>
                <span class="badge ${r.enabled ? 'bg-success' : 'bg-secondary'}">${r.enabled ? 'On' : 'Off'}</span>
              </td>
              <td>
                <div class="d-flex gap-2">
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
</div>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    </div>
</div>
</body>
</html>



