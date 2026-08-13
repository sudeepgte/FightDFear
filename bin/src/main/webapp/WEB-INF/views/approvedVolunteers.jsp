<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
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
        font-family: 'Poppins', sans-serif;
        background-color: var(--light-bg);
        color: var(--primary-purple);
        padding: 30px;
    }

    h2 {
        text-align: center;
        color: var(--primary-purple);
        font-weight: 600;
        margin-bottom: 30px;
    }

    .container {
        background: #ffffff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.2s;
    }
    .container:hover {
        box-shadow: var(--shadow-md);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
        margin-top: 20px;
    }

    th {
        background-color: var(--primary-purple-light);
        color: white;
        font-weight: bold;
        text-align: center;
        padding: 12px;
    }

    td {
        text-align: center;
        padding: 12px;
        vertical-align: middle;
        color: var(--primary-purple);
        border-top: 1px solid rgba(0, 0, 0, 0.08);
    }

    tr:nth-child(even) {
        background-color: rgba(123, 44, 191, 0.06);
    }

    img {
        border-radius: 50%;
        border: 2px solid rgba(123, 44, 191, 0.3);
    }

    .btn-reject {
        background: var(--primary-coral-dark);
        color: white;
        border-radius: 8px;
        padding: 6px 14px;
        font-weight: bold;
        border: none;
        transition: all 0.2s;
    }
    .btn-reject:hover {
        background: var(--primary-coral);
        transform: translateY(-1px);
    }

    a {
        color: var(--primary-purple);
        font-weight: 500;
        text-decoration: underline;
        transition: color 0.2s;
    }
    a:hover {
        color: var(--primary-purple-light);
    }

    .message {
        text-align: center;
        font-weight: bold;
        margin-top: 15px;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the container */
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

    /* 2. Table row hover effect – subtle scale and shadow */
    table tbody tr {
        transition: all 0.2s cubic-bezier(0.2, 0.9, 0.4, 1.1);
    }
    table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-reject {
        position: relative;
        overflow: hidden;
    }
    .btn-reject::after {
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
    .btn-reject:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-reject:focus-visible,
    a:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 6px;
    }

    /* 5. Custom scrollbar (matches brand purple) */
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

    /* 6. Image hover effect */
    img {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    img:hover {
        transform: scale(1.05);
        box-shadow: var(--shadow-sm);
    }

    /* 7. Responsive improvements for mobile */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        .container {
            padding: 15px;
        }
        th, td {
            padding: 8px;
            font-size: 12px;
        }
        .btn-reject {
            padding: 4px 10px;
            font-size: 12px;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
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

<!-- Display Messages -->
<c:if test="${not empty message}">
    <p class="message" style="color:green">${message}</p>
</c:if>
<c:if test="${not empty error}">
    <p class="message" style="color:red">${error}</p>
</c:if>

<div class="container">
    <h2>Approved Volunteers</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Profile Photo</th>
            <th>Name</th>
            <th>Email</th>
            <th>Age</th>
            <th>Gender</th>
            <th>Identity Document</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <c:forEach var="volunteer" items="${volunteers}">
            <c:if test="${volunteer.verificationStatus == 'VERIFIED'}">
                <tr>
                    <td>${volunteer.id}</td>
                    <td>
                        <c:if test="${not empty volunteer.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${volunteer.profilePhoto}" alt="Profile Photo" width="50" height="50">
                        </c:if>
                        <c:if test="${empty volunteer.profilePhoto}">
                            No Photo
                        </c:if>
                    </td>
                    <td>${volunteer.fullName}</td>
                    <td>${volunteer.email}</td>
                    <td>${volunteer.age}</td>
                    <td>${volunteer.gender}</td>
                    <td><a href="${pageContext.request.contextPath}${volunteer.identityDocument}" target="_blank">View Identity</a></td>
                    <td style="color: green; font-weight: bold;">${volunteer.verificationStatus}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/rejectvolunteer/${volunteer.id}" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-reject">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
    </table>
</div>

