<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Video</title>
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
        background-color: var(--light-bg);
        font-family: 'Poppins', sans-serif;
        color: var(--primary-purple);
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
    }

    .form-container {
        background: white;
        padding: 30px 40px;
        border-radius: 12px;
        box-shadow: var(--shadow-sm);
        width: 100%;
        max-width: 500px;
        transition: box-shadow 0.2s;
    }
    .form-container:hover {
        box-shadow: var(--shadow-md);
    }

    h2 {
        text-align: center;
        color: var(--primary-purple-light);
        margin-bottom: 25px;
        font-weight: 600;
    }

    label {
        font-weight: 500;
        color: var(--primary-purple);
        margin-top: 15px;
    }

    input[type="text"],
    select,
    input[type="file"] {
        width: 100%;
        padding: 10px 12px;
        margin-top: 6px;
        border-radius: 6px;
        border: 1px solid var(--primary-purple-light);
        font-size: 15px;
        transition: all 0.2s;
    }
    input[type="text"]:focus,
    select:focus {
        border-color: var(--primary-purple);
        outline: none;
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
    }

    input[type="file"] {
        background-color: var(--light-bg);
    }

    button {
        margin-top: 25px;
        width: 100%;
        padding: 12px;
        background: var(--gradient-primary);
        color: white;
        font-size: 16px;
        border: none;
        border-radius: 6px;
        font-weight: bold;
        transition: all 0.2s ease;
        cursor: pointer;
    }

    button:hover {
        filter: brightness(0.95);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the form container */
    .form-container {
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

    /* 2. Button ripple effect on click (micro-interaction) */
    button {
        position: relative;
        overflow: hidden;
    }
    button::after {
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
    button:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Label hover effect (subtle shift) */
    label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    label:hover {
        color: var(--primary-purple-light);
        transform: translateX(2px);
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    button:focus-visible,
    input:focus-visible,
    select:focus-visible {
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

    /* 6. Input placeholder styling (softer) */
    input::placeholder,
    select::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    input:focus::placeholder,
    select:focus::placeholder {
        opacity: 0.6;
    }

    /* 7. Responsive improvements for mobile */
    @media (max-width: 640px) {
        .form-container {
            padding: 20px 25px;
            margin: 20px;
        }
        button {
            padding: 14px;
            font-size: 1rem;
        }
        input, select {
            padding: 12px;
            font-size: 16px; /* prevents zoom on iOS */
        }
        h2 {
            font-size: 1.5rem;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .form-container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>

    <div class="form-container">
        <h2>Edit Video</h2>
        <form action="${pageContext.request.contextPath}/video/update/${video.id}" method="post" enctype="multipart/form-data">
            
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" value="${video.title}" required>

            <label for="category">Category:</label>
            <select id="category" name="category">
                <c:forEach var="category" items="${categories}">
                    <option value="${category}" ${category == video.category ? 'selected' : ''}>${category}</option>
                </c:forEach>
            </select>

            <label for="videoFile">Upload New Video:</label>
            <input type="file" id="videoFile" name="videoFile" accept="video/*" required>

            <button type="submit">Update</button>
        </form>
    </div>

</body>
</html>

