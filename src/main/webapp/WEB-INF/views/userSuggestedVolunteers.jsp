<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Suggested Volunteers</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body {
        background: #f6f2fb;
        font-family: 'Poppins', sans-serif;
    }

    .page-card {
        background: #ffffff;
        border-radius: 14px;
        padding: 25px;
        box-shadow: 0 6px 18px rgba(128, 0, 128, 0.15);
    }

    h3 {
        color: #6a0dad;
        font-weight: 600;
        margin-bottom: 20px;
    }

    .btn-purple {
        background: linear-gradient(45deg, #8000ff, #a020f0);
        color: #fff;
        border: none;
        font-weight: 500;
        padding: 8px 18px;
        border-radius: 8px;
    }

    .btn-purple:hover {
        background: linear-gradient(45deg, #6a0dad, #8000ff);
        color: #fff;
    }

    table {
        border-radius: 12px;
        overflow: hidden;
    }

    thead {
        background: #6a0dad;
        color: #fff;
    }

    thead th {
        border: none;
        font-weight: 500;
        text-align: center;
    }

    tbody td {
        text-align: center;
        vertical-align: middle;
    }

    tbody tr:hover {
        background-color: #f3e9fb;
    }

    .badge {
        font-size: 13px;
        padding: 6px 12px;
        border-radius: 20px;
    }

    .badge-warning {
        background-color: #ffb703;
    }

    .badge-success {
        background-color: #2ec4b6;
    }

    .badge-danger {
        background-color: #e63946;
    }

    a.view-link {
        color: #6a0dad;
        font-weight: 500;
        text-decoration: none;
    }

    a.view-link:hover {
        text-decoration: underline;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Root variables (your brand colors) */
    :root {
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

    /* 2. Map existing colors to root variables (preserve original appearance) */
    body {
        background: var(--light-bg);
    }
    .page-card {
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.3s, transform 0.2s;
    }
    .page-card:hover {
        box-shadow: var(--shadow-md);
        transform: translateY(-3px);
    }
    h3 {
        color: var(--primary-purple);
    }
    .btn-purple {
        background: var(--gradient-primary);
        transition: all 0.2s;
    }
    .btn-purple:hover {
        background: linear-gradient(135deg, var(--primary-purple-light), var(--primary-purple));
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }
    thead {
        background: var(--primary-purple);
    }
    tbody tr:hover {
        background-color: rgba(123, 44, 191, 0.06);
    }
    .badge-warning {
        background-color: var(--primary-gold);
        color: var(--primary-purple);
    }
    .badge-success {
        background-color: var(--primary-teal);
    }
    .badge-danger {
        background-color: var(--primary-coral-dark);
    }
    a.view-link {
        color: var(--primary-purple);
    }
    a.view-link:hover {
        color: var(--primary-purple-light);
    }

    /* 3. Smooth fade-in animation for the page card */
    .page-card {
        animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 4. Button ripple effect on click (micro-interaction) */
    .btn-purple {
        position: relative;
        overflow: hidden;
    }
    .btn-purple::after {
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
    .btn-purple:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .btn-purple:focus-visible,
    a.view-link:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 6. Custom scrollbar (matches brand purple) */
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

    /* 7. Table row hover enhancement – subtle scale */
    tbody tr {
        transition: transform 0.2s, background-color 0.2s;
    }
    tbody tr:hover {
        transform: scale(1.01);
    }

    /* 8. Badge hover effect */
    .badge {
        transition: transform 0.2s;
    }
    .badge:hover {
        transform: scale(1.05);
    }

    /* 9. Responsive improvements for very small screens */
    @media (max-width: 640px) {
        .page-card {
            padding: 15px;
            margin: 15px;
        }
        h3 {
            font-size: 1.4rem;
        }
        .btn-purple {
            padding: 6px 14px;
            font-size: 0.85rem;
        }
        table {
            font-size: 0.8rem;
        }
        .badge {
            font-size: 11px;
            padding: 4px 8px;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .page-card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>

<body>

<div class="container mt-5">
    <div class="page-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>Suggested Volunteers (<c:out value="${count}"/>)</h3>

            <a href="${pageContext.request.contextPath}/users/suggest-volunteer"
               class="btn btn-purple">
                + Suggest Volunteer
            </a>
        </div>

        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Govt ID</th>
                <th>Status</th>
            </tr>
            </thead>

            <tbody id="suggestionsBody">
            <c:forEach var="v" items="${suggestions}">
                <tr>
                    <td><c:out value="${v.name}"/></td>
                    <td><c:out value="${v.email}"/></td>
                    <td><c:out value="${v.phone}"/></td>
                    <td>
                        <a class="view-link" href="${v.govtIdPath}" target="_blank">
                            View
                        </a>
                    </td>
                    <td>
                     <c:choose>
    <c:when test="${v.status == 'PENDING'}">
        <span class="badge badge-warning">PENDING</span>
    </c:when>

    <c:when test="${v.status == 'VERIFIED'}">
        <span class="badge badge-success">VERIFIED</span>
    </c:when>

    <c:when test="${v.status == 'REJECTED'}">
        <span class="badge badge-danger">REJECTED</span>
    </c:when>
</c:choose>

                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </div>
</div>

<script>
  (function () {
    let initialSignature = "";
    try {
      initialSignature = [
        <c:forEach var="v" items="${suggestions}">
          "${v.id}|${v.status};",
        </c:forEach>
      ].join("");
    } catch (e) {}

    async function checkForUpdates() {
      try {
        const res = await fetch("${pageContext.request.contextPath}/users/suggested-volunteers.meta", {
          headers: { "Accept": "application/json" }
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data && data.signature && data.signature !== initialSignature) {
          window.location.reload();
        }
      } catch (e) {
        // ignore
      }
    }

    setInterval(checkForUpdates, 8000);
  })();
</script>

</body>
</html>

