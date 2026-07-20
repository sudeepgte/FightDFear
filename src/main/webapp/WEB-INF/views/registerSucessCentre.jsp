<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Successful</title>
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
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        font-family: Arial, sans-serif;
        background-color: var(--light-bg);
        text-align: center;
        padding: 50px;
        margin: 0;
    }

    .container {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: var(--shadow-sm);
        display: inline-block;
        transition: box-shadow 0.2s;
    }
    .container:hover {
        box-shadow: var(--shadow-md);
    }

    h2 {
        color: var(--primary-purple);
    }

    .success-message {
        color: var(--primary-teal);
        font-size: 18px;
    }

    .home-link {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        background-color: var(--primary-purple-light);
        color: white;
        text-decoration: none;
        border-radius: 5px;
        transition: all 0.2s;
    }

    .home-link:hover {
        background-color: var(--primary-purple);
        transform: translateY(-2px);
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

    /* 2. Button ripple effect on click (micro-interaction) */
    .home-link {
        position: relative;
        overflow: hidden;
    }
    .home-link::after {
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
    .home-link:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outline for accessibility (keyboard navigation) */
    .home-link:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 5px;
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

    /* 5. Heading hover effect – subtle text shadow */
    h2 {
        transition: text-shadow 0.2s;
    }
    h2:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.15);
    }

    /* 6. Success message hover effect – slight scale */
    .success-message {
        transition: transform 0.2s;
        display: inline-block;
    }
    .success-message:hover {
        transform: scale(1.02);
    }

    /* 7. Responsive improvements for mobile */
    @media (max-width: 480px) {
        body {
            padding: 30px 15px;
        }
        .container {
            padding: 15px;
        }
        .home-link {
            padding: 12px 24px;
            font-size: 1rem;
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
        <h2>Martial Arts Center Registration Successful</h2>
        <p class="success-message">${message}</p>
        <p style="color:#1e1b4b; margin-top:20px;">You cannot sign in until an admin approves your centre.</p>
        <a href="${pageContext.request.contextPath}/centres/login" class="home-link" style="margin-top:16px; display:inline-block;">Go to Centre Login</a>
        <a href="${pageContext.request.contextPath}/" class="home-link" style="margin-top:10px; display:inline-block; background:#6b7280;">Back to Home</a>
    </div>
</body>
</html>


