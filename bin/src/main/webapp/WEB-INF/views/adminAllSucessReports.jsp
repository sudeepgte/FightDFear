<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Success Reports</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- FontAwesome -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>

    <!-- Custom Styles -->
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
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

    body {
        background-color: #ffffff;
        font-family: 'Poppins', sans-serif;
        color: var(--dark-bg);
        padding: 30px;
    }

    h1 {
        color: var(--primary-purple);
        font-weight: bold;
        margin-bottom: 25px;
        text-align: center;
    }

    .custom-table {
        background: var(--light-bg);
        border-radius: 12px;
        overflow: hidden;
        box-shadow: var(--shadow-sm);
    }

    .custom-table thead {
        background-color: var(--primary-purple);
        color: white;
    }

    .custom-table th,
    .custom-table td {
        text-align: center;
        padding: 14px;
        vertical-align: middle;
    }

    .custom-table tbody tr:nth-child(even) {
        background-color: rgba(123, 44, 191, 0.08);
    }

    .custom-table tbody tr:hover {
        background-color: rgba(123, 44, 191, 0.15);
    }

    .btn-primary {
        background: var(--gradient-primary);
        border: none;
        font-weight: bold;
        transition: all 0.2s;
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, var(--primary-purple-light), var(--primary-purple));
        transform: scale(1.05);
    }

    .filter-icon {
        position: absolute;
        top: 30px;
        right: 30px;
        font-size: 24px;
        color: var(--primary-purple);
        cursor: pointer;
    }

    .filter-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0;
        height: 100%;
        width: 100%;
        background: rgba(74, 14, 120, 0.1);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .filter-content {
        background: #fff;
        border: 2px solid var(--primary-purple);
        padding: 25px;
        border-radius: 10px;
        width: 300px;
        text-align: center;
        box-shadow: var(--shadow-sm);
    }

    .filter-content h3 {
        color: var(--primary-purple);
        margin-bottom: 15px;
    }

    .form-select {
        margin-top: 10px;
    }

    .close-btn {
        position: absolute;
        top: 20px;
        right: 35px;
        background: none;
        border: none;
        font-size: 24px;
        color: var(--primary-purple);
        cursor: pointer;
    }

    .back-home-container {
        text-align: center;
        margin-top: 20px;
    }

    .alert-info {
        background-color: rgba(123, 44, 191, 0.1);
        border-color: var(--primary-purple-light);
        color: var(--primary-purple);
        font-weight: bold;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the table */
    .custom-table {
        animation: fadeSlideUp 0.5s ease-out forwards;
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

    /* 2. Hover lift effect for table rows (original hover bg already there, add subtle scale) */
    .custom-table tbody tr {
        transition: transform 0.2s ease, box-shadow 0.2s;
    }
    .custom-table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-primary, .filter-icon, .close-btn {
        position: relative;
        overflow: hidden;
    }
    .btn-primary::after, .filter-icon::after, .close-btn::after {
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
    .btn-primary:active::after, .filter-icon:active::after, .close-btn:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-primary:focus-visible,
    .filter-icon:focus-visible,
    .close-btn:focus-visible,
    .form-select:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 8px;
    }

    /* 5. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
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

    /* 6. Filter overlay animation (when visible) */
    .filter-overlay {
        transition: background 0.2s ease;
    }
    .filter-content {
        animation: popIn 0.2s cubic-bezier(0.34, 1.2, 0.64, 1);
    }
    @keyframes popIn {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }

    /* 7. Alert info hover effect */
    .alert-info {
        transition: all 0.2s;
    }
    .alert-info:hover {
        background-color: rgba(123, 44, 191, 0.2);
        transform: translateX(5px);
    }

    /* 8. Back home container button (if any) – subtle enhancement */
    .back-home-container a {
        display: inline-block;
        transition: all 0.2s;
    }
    .back-home-container a:hover {
        transform: translateY(-2px);
        text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* 9. Responsive touch improvements for buttons */
    @media (max-width: 768px) {
        .btn-primary, .filter-icon, .close-btn {
            padding: 10px 16px;
            font-size: 0.9rem;
        }
        .custom-table th, .custom-table td {
            padding: 10px;
            font-size: 0.85rem;
        }
    }

    /* 10. Loading skeleton effect for table rows (optional – just visual polish) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    /* If you ever add a .loading class, it will be ready; does nothing by default */
    .custom-table.loading tbody tr {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
    }
</style>
</head>

<body>
    <div class="container-fluid p-4 position-relative">
        <h1>All Success Reports</h1>

        <c:if test="${not empty message}">
            <div class="alert alert-info">${message}</div>
        </c:if>

        <!-- Filter Icon -->
        <div class="filter-icon" onclick="toggleFilters()">
            <i class="fas fa-filter"></i>
        </div>

        <!-- Filter Panel -->
        <div id="filterPanel" class="filter-overlay">
            <div class="filter-content">
                <button class="close-btn" onclick="toggleFilters()">&times;</button>
                <h3>Filters</h3>
                <form method="get" action="">
                    <label for="sortOrder">Sort by Rescue Count:</label>
                    <select name="sortOrder" id="sortOrder" class="form-select" onchange="this.form.submit()">
                        <option value="">Select</option>
                        <option value="low" ${sortOrder == 'low' ? 'selected' : ''}>Low to High</option>
                        <option value="high" ${sortOrder == 'high' ? 'selected' : ''}>High to Low</option>
                    </select>
                </form>
            </div>
        </div>

        <!-- Table -->
        <div class="table-responsive mt-4">
            <table class="table custom-table">
                <thead>
                    <tr>
                        <th>Volunteer</th>
                        <th>Description</th>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Rescue Count</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${allSuccessReports}">
                        <tr>
                            <td>${report.volunteer.name}</td>
                            <td>${report.description}</td>
                            <td>${report.location}</td>
                            <td>${report.date}</td>
                            <td>${report.volunteer.rescueCount}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/volunteer/admin/${report.volunteer.id}/profile" 
                                   class="btn btn-primary btn-sm">View Profile</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="back-home-container">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-primary btn-sm">Back Home</a>
        </div>
    </div>

    <!-- JS for Toggle -->
    <script>
        function toggleFilters() {
            var panel = document.getElementById("filterPanel");
            panel.style.display = (panel.style.display === "flex") ? "none" : "flex";
        }
    </script>
</body>
</html>

