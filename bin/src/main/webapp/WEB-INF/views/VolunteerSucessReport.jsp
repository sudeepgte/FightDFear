<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>   
    <meta charset="UTF-8">
    <title>Success Reports</title>

 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>

    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body {
        background: linear-gradient(to right, #f3d9ff, #f8edff);
        font-family: 'Poppins', sans-serif;
    }

    .container {
        margin-top: 50px;
        background: #ffffff;
        padding: 40px;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(123, 44, 191, 0.12);
    }

    h1 {
        text-align: center;
        color: #312e81;
        font-weight: bold;
        margin-bottom: 30px;
        font-family: 'Playfair Display', serif;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 12px;
    }

    h1 i {
        color: #312e81;
    }

    .message {
        text-align: center;
        color: #28a745;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .table {
        border-radius: 12px;
        overflow: hidden;
    }

    .table thead th {
        background-color: #312e81;
        color: #fff;
        text-align: center;
        vertical-align: middle;
    }

    .table tbody td {
        background-color: #f6efff;
        color: #4a148c;
        text-align: center;
        vertical-align: middle;
    }

    .table-striped > tbody > tr:nth-of-type(odd) {
        background-color: #f3e8ff;
    }

    .btn-action {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        padding: 6px 14px;
        border-radius: 6px;
        font-weight: 500;
        text-decoration: none;
    }

    .btn-edit {
        background-color: #6a0572;
        color: white;
        border: none;
    }

    .btn-edit:hover {
        background-color: #4e034f;
    }

    .btn-danger {
        background-color: #e91e63;
        color: white;
        border: none;
    }

    .btn-danger:hover {
        background-color: #c2185b;
    }

    .action-buttons form {
        display: inline;
    }

    .btn-add {
        background-color: #312e81;
        color: white;
        font-weight: 600;
        padding: 10px 20px;
        border-radius: 8px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: background-color 0.3s ease;
    }

    .btn-add:hover {
        background-color: #5a189a;
    }

    .footer-buttons {
        display: flex;
        justify-content: center;
        gap: 16px;
        flex-wrap: wrap;
        margin-top: 30px;
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
    }

    /* 2. Smooth fade-in animation for the container */
    .container {
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

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-edit, .btn-danger, .btn-add {
        position: relative;
        overflow: hidden;
    }
    .btn-edit::after, .btn-danger::after, .btn-add::after {
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
    .btn-edit:active::after, .btn-danger:active::after, .btn-add:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-edit:focus-visible, .btn-danger:focus-visible, .btn-add:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 6px;
    }

    /* 5. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #f3d9ff;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 6. Table row hover effect – subtle scale and shadow */
    .table tbody tr {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 7. Heading icon hover effect */
    h1 i {
        transition: transform 0.2s;
    }
    h1:hover i {
        transform: scale(1.1);
    }

    /* 8. Message alert styling enhancement */
    .message {
        background: rgba(40, 167, 69, 0.1);
        border-left: 4px solid var(--primary-teal);
        padding: 12px;
        border-radius: 8px;
        transition: background 0.2s;
    }
    .message:hover {
        background: rgba(40, 167, 69, 0.15);
    }

    /* 9. Responsive improvements for very small screens */
    @media (max-width: 576px) {
        .container {
            padding: 20px;
            margin-top: 30px;
        }
        .btn-edit, .btn-danger, .btn-add {
            padding: 4px 10px;
            font-size: 12px;
        }
        h1 {
            font-size: 1.5rem;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>

<div class="container">
    <h1><i class="fas fa-award"></i> Your Success Reports</h1>

    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>

    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th><i class="fas fa-align-left"></i> Description</th>
                    <th><i class="fas fa-map-marker-alt"></i> Location</th>
                    <th><i class="fas fa-calendar-alt"></i> Date</th>
                     <th><i class="fas fa-file"></i> Evidence</th>  
                    <th><i class="fas fa-cogs"></i> Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="report" items="${successReports}">
                    <tr>
                        <td>${report.description}</td>
                        <td>${report.location}</td>
                        <td>${report.date}</td>
                         <td>
                <c:if test="${not empty report.mediaPath}">
                    <a href="${pageContext.request.contextPath}${report.mediaPath}" 
                       target="_blank" class="btn btn-sm btn-primary">
                        <i class="fas fa-file-download"></i> View File
                    </a>
                </c:if>
            </td>
                        <td class="action-buttons">
                            <a href="${pageContext.request.contextPath}/volunteer/${volunteerId}/successReports/${report.id}/edit" class="btn btn-edit btn-action">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <form action="${pageContext.request.contextPath}/volunteer/${volunteerId}/successReports/${report.id}/delete" method="post" onsubmit="return confirm('Are you sure you want to delete this report?');">
                                <button type="submit" class="btn btn-danger btn-action">
                                    <i class="fas fa-trash-alt"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="footer-buttons">
        <a href="${pageContext.request.contextPath}/volunteer/${volunteerId}/addSuccessReport" class="btn-add">
            <i class="fas fa-plus-circle"></i> Add Report
        </a>
        <a href="${pageContext.request.contextPath}/volunteer/dashboard" class="btn-add">
            <i class="fas fa-home"></i> Back to Home
        </a>
    </div>
</div>

</body>
</html>

