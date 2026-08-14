<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

<style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body {
        font-family: 'Poppins', sans-serif;
        background-color: #f9f5ff;
        color: #4b0082;
        padding: 30px;
    }

    h2 {
        text-align: center;
        color: #6a0dad;
        font-weight: 600;
        margin-bottom: 30px;
    }

    .container {
        background: #ffffff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(106, 13, 173, 0.1);
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
        background-color: #a64ac9;
        color: white;
        font-weight: bold;
        text-align: center;
        padding: 12px;
    }

    td {
        text-align: center;
        padding: 12px;
        vertical-align: middle;
        color: #4b0082;
        border-top: 1px solid #eee;
    }

    tr:nth-child(even) {
        background-color: #f4eaff;
    }

    img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: 2px solid #a64ac9;
        object-fit: cover;
    }

    .btn-verify, .btn-reject {
        padding: 6px 14px;
        border-radius: 8px;
        border: none;
        font-weight: bold;
        font-size: 14px;
        transition: 0.3s;
    }

    .btn-verify {
        background: #312e81;
        color: white;
    }

    .btn-verify:hover {
        background: #5a189a;
    }

    .btn-reject {
        background: #d72638;
        color: white;
        margin-left: 5px;
    }

    .btn-reject:hover {
        background: #a4133c;
    }

    .message {
        text-align: center;
        font-weight: bold;
        margin-top: 10px;
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

    /* 2. Table row hover effect – subtle scale + shadow */
    table tbody tr {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* 3. Image hover effect – scale and border glow */
    img {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    img:hover {
        transform: scale(1.1);
        box-shadow: 0 0 0 2px #ffd700;
    }

    /* 4. Button ripple effect on click (micro-interaction) */
    .btn-verify, .btn-reject {
        position: relative;
        overflow: hidden;
    }
    .btn-verify::after, .btn-reject::after {
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
    .btn-verify:active::after, .btn-reject:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .btn-verify:focus-visible,
    .btn-reject:focus-visible {
        outline: 3px solid #ffd700;
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 6. Custom scrollbar (matches purple theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #f9f5ff;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: #a64ac9;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #312e81;
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
        .btn-verify, .btn-reject {
            padding: 4px 10px;
            font-size: 11px;
        }
        img {
            width: 40px;
            height: 40px;
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

<div class="container">
    <h2>Pending Volunteers</h2>

    <c:if test="${not empty message}">
        <p class="message" style="color:green">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="message" style="color:red">${error}</p>
    </c:if>

    <table class="table table-striped table-hover">
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
            <c:if test="${volunteer.verificationStatus != 'VERIFIED'}">
                <tr>
                    <td>${volunteer.id}</td>
                    <td>
                        <c:if test="${not empty volunteer.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${volunteer.profilePhoto}" alt="Profile Photo">
                        </c:if>
                        <c:if test="${empty volunteer.profilePhoto}">No Photo</c:if>
                    </td>
                    <td>${volunteer.fullName}</td>
                    <td>${volunteer.email}</td>
                    <td>${volunteer.age}</td>
                    <td>${volunteer.gender}</td>
                    <td><a href="${pageContext.request.contextPath}${volunteer.identityDocument}" target="_blank">View Identity</a></td>
                    <td>${volunteer.verificationStatus}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/volunteer/admin/volunteer/${volunteer.id}/verify" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-verify">Verify</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/rejectvolunteer/${volunteer.id}" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-reject">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
    </table>
</div>

