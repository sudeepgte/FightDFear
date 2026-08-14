<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page import="in.sp.main.Entities.TrainingStatus" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment- Martial Arts Centers</title>
  <script src="<%= request.getContextPath() %>/resources/bootstrap/js/popper.min.js"></script>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script> 
    <script src="<%= request.getContextPath() %>/resources/bootstrap/js/jquery-3.6.0.min.js"></script>
    
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    /* Custom Styles using theme variables */
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, var(--light-bg, #fffcfd), #e8e0f0);
        padding: 30px;
    }
    
    .table-container {
        max-width: 1000px;
        margin: auto;
        background: white;
        padding: 25px;
        border-radius: 16px;
        box-shadow: var(--shadow-md, 0 20px 40px rgba(0,0,0,0.12));
    }
    
    h2 {
        text-align: center;
        color: var(--primary-purple, #1e1b4b);
        margin-bottom: 20px;
        font-weight: bold;
    }

    /* Table Styling */
    .table {
        border-radius: 10px;
        overflow: hidden;
        background: white;
    }
    
    .table thead {
        background: linear-gradient(135deg, var(--primary-purple, #1e1b4b), var(--primary-purple-light, #312e81));
        color: white;
    }
    
    .table tbody tr:hover {
        background: rgba(123, 44, 191, 0.06);
    }
    
    /* Buttons */
    .btn-primary {
        background: var(--primary-purple-light, #312e81) !important;
        border: none;
        transition: 0.3s;
    }

    .btn-primary:hover {
        background: var(--primary-purple, #1e1b4b) !important;
    }

    .text-muted {
        color: #6c757d;
    }

    /* Icons */
    .status-icon {
        margin-right: 5px;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Root variables (already defined, but ensure they exist) */
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
    }

    /* 2. Smooth fade-in animation for the table container */
    .table-container {
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

    /* 3. Table row hover – subtle scale and shadow (preserves original background) */
    .table tbody tr {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 4. Button ripple effect on click */
    .btn-primary {
        position: relative;
        overflow: hidden;
    }
    .btn-primary::after {
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
    .btn-primary:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .btn-primary:focus-visible,
    .table:focus-visible {
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

    /* 7. Heading hover effect – subtle color shift */
    h2 {
        transition: color 0.2s, text-shadow 0.2s;
    }
    h2:hover {
        color: var(--primary-purple-light);
        text-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    /* 8. Responsive improvements for mobile */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        .table-container {
            padding: 15px;
            margin: 15px;
        }
        .table th, .table td {
            padding: 8px;
            font-size: 0.85rem;
        }
        .btn-primary {
            padding: 8px 16px;
            font-size: 0.9rem;
        }
        h2 {
            font-size: 1.5rem;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .table-container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>

<div class="container table-container">
    <h2><i class="fa-solid fa-list-check"></i> Enrollment Dashboard</h2>

    <!-- Search Filter -->
    <div class="mb-4">
        <input type="text" id="searchInput" class="form-control" placeholder="Search by martial arts type or status...">
    </div>

    <c:if test="${not empty enrollments}">
        <table class="table table-bordered table-striped" id="enrollmentTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Martial Arts Type</th>
                    <th>Selected Slot</th>
                    <th>Preferred Days</th>
                    <th>Status</th>
                    <th>Certificate</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="enrollment" items="${enrollments}">
                    <tr class="enrollment-row">
                        <td>${enrollment.id}</td>
                        <td class="searchable-type">${enrollment.martialArtsType.name}</td>
                        <td>${enrollment.selectedSlot.timeRange}</td>
                        <td>${enrollment.preferredDays}</td>
                        <td class="searchable-status">
                         <c:choose>
    <c:when test="${enrollment.status.toString() eq 'COMPLETED'}">
        <span class="badge bg-success"><i class="fa-solid fa-check-circle status-icon"></i>Completed</span>
    </c:when>
    <c:when test="${enrollment.status.toString() eq 'IN_PROGRESS'}">
        <span class="badge bg-warning text-dark"><i class="fa-solid fa-spinner status-icon"></i>On Progress</span>
    </c:when>
    <c:otherwise>
        <span class="badge bg-secondary"><i class="fa-solid fa-clock status-icon"></i>Pending</span>
    </c:otherwise>
</c:choose>

                        </td>
                       <td>
   <c:if test="${enrollment.status.toString() eq 'COMPLETED'}">
    <c:if test="${not empty enrollment.certificateDetails}">
        <a href="${pageContext.request.contextPath}/enrollment/downloadCertificate/${enrollment.id}" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-download"></i> Download Certificate
        </a>
    </c:if>
    <c:if test="${empty enrollment.certificateDetails}">
        <span class="text-muted"><i class="fa-solid fa-ban"></i> No certificate available</span>
    </c:if>
</c:if>
<c:if test="${enrollment.status.toString() ne 'COMPLETED'}">
    <span class="text-muted"><i class="fa-solid fa-lock"></i> Training not completed</span>
</c:if>

</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty enrollments}">
        <p class="text-center text-muted"><i class="fa-solid fa-info-circle"></i> No enrollments found for this user.</p>
    </c:if>

    <c:if test="${not empty message}">
        <div class="alert alert-info text-center"><i class="fa-solid fa-exclamation-circle"></i> ${message}</div>
    </c:if>

</div>

<script>
  (function () {
    // Search functionality
    const searchInput = document.getElementById('searchInput');
    const tableRows = document.querySelectorAll('.enrollment-row');

    searchInput.addEventListener('keyup', function(e) {
      const searchTerm = e.target.value.toLowerCase();

      tableRows.forEach(function(row) {
        const type = row.querySelector('.searchable-type').textContent.toLowerCase();
        const status = row.querySelector('.searchable-status').textContent.toLowerCase();

        if (type.includes(searchTerm) || status.includes(searchTerm)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    });

    // Auto-refresh functionality
    const userId = "${sessionScope.user.id}";
    let initialSignature = "";
    try {
      initialSignature = [
        <c:forEach var="enrollment" items="${enrollments}">
          "${enrollment.id}|${enrollment.status}|${enrollment.certificateDetails};",
        </c:forEach>
      ].join("");
    } catch (e) {}

    async function checkForUpdates() {
      try {
        const res = await fetch("${pageContext.request.contextPath}/enrollment/listEnrollments/" + userId + ".meta", {
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

