<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    /* 🌸 Lavender-Themed Styles */
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(to right, #E6E6FA, #D8BFD8); /* Light to dark lavender */
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    
    .container {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        width: 350px;
        text-align: center;
    }

    h2 {
        color: #6A5ACD; /* Dark lavender */
    }

    input {
        width: 90%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #D8BFD8; /* Light lavender border */
        border-radius: 6px;
        outline: none;
        transition: 0.3s;
    }

    input:focus {
        border-color: #6A5ACD; /* Dark lavender on focus */
        box-shadow: 0px 0px 6px rgba(106, 90, 205, 0.5);
    }

    button {
        background: #6A5ACD; /* Dark lavender */
        color: white;
        border: none;
        padding: 12px;
        width: 100%;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        transition: 0.3s;
    }

    button:hover {
        background: #483D8B; /* Deeper lavender */
    }

    p {
        color: #483D8B;
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

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    button:focus-visible,
    input:focus-visible {
        outline: 3px solid #ffd700; /* gold for contrast */
        outline-offset: 2px;
        border-radius: 6px;
    }

    /* 4. Label hover effect (if labels exist; adds polish) */
    label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    label:hover {
        color: #6A5ACD;
        transform: translateX(2px);
    }

    /* 5. Custom scrollbar (matches lavender theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #E6E6FA;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: #6A5ACD;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #483D8B;
    }

    /* 6. Input placeholder styling (softer) */
    input::placeholder {
        color: rgba(106, 90, 205, 0.4);
        transition: opacity 0.2s;
    }
    input:focus::placeholder {
        opacity: 0.6;
    }

    /* 7. Responsive improvements for mobile */
    @media (max-width: 480px) {
        .container {
            width: 85%;
            padding: 20px;
            margin: 15px;
        }
        button {
            padding: 14px;
            font-size: 1rem;
        }
        input {
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
        <h2>Forgot Password</h2>
        <p>Enter your email to reset your password</p>
        <form action="${pageContext.request.contextPath}/auth/forgot-password" method="POST">
            <input type="email" name="email" placeholder="Enter your email" required>
            <button type="submit">Reset Password</button>
        </form>
        <p>${message}</p>
    </div>

</body>
</html>

