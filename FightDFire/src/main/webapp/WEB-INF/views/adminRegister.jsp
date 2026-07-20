<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Registration - Fight D Fear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
        background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }

    .container {
        max-width: 500px;
        margin: 0 auto;
    }

    .card {
        background: white;
        border-radius: 28px;
        box-shadow: var(--shadow-md);
        padding: 35px 30px;
        transition: transform 0.2s, box-shadow 0.2s;
        border: none;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-md);
    }

    h3 {
        color: var(--primary-purple);
        font-weight: 800;
        border-radius: 12px;
        padding: 12px 15px;
        transition: all 0.2s;
    }
    .form-control:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        outline: none;
    }

    .btn-primary {
        background: var(--gradient-primary);
        border: none;
        border-radius: 40px;
        padding: 12px 20px;
        font-weight: 700;
        font-size: 1rem;
        width: 100%;
        transition: all 0.2s;
    }
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
        filter: brightness(1.02);
    }

    a {
        color: var(--primary-purple-light);
        text-decoration: none;
        font-weight: 600;
        transition: color 0.2s;
    }
    a:hover {
        color: var(--primary-purple);
        text-decoration: underline;
    }

    .mt-3 {
        margin-top: 1rem;
        text-align: center;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the card */
    .card {
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

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .btn-primary:focus-visible,
    a:focus-visible,
    .form-control:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 8px;
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

    /* 5. Label / heading hover effect (optional) */
    h3 {
        transition: all 0.2s;
    }
    h3:hover {
        color: var(--primary-purple-light);
        transform: translateX(3px);
    }

    /* 6. Link hover enhancement – add scale */
    a {
        display: inline-block;
        transition: transform 0.2s, color 0.2s;
    }
    a:hover {
        transform: scale(1.02);
    }

    /* 7. Responsive touch improvements for mobile */
    @media (max-width: 576px) {
        body { padding: 15px; }
        .card {
            padding: 30px 20px;
            border-radius: 24px;
        }
        .btn-primary {
            padding: 14px 20px;
            font-size: 1rem;
        }
        h3 {
            font-size: 1.4rem;
            padding: 8px 10px;
            margin-bottom: 20px;
        }
        .form-control {
            padding: 12px 15px;
            border-radius: 12px;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
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
</style>
   </head>
<body>
<div class="container">
    <div class="card">
        <h3>🛡️ Admin Registration</h3>
        <form action="${pageContext.request.contextPath}/admin/registerAdmin" method="post">
            <input type="text" name="name" placeholder="Enter Name" class="form-control mb-3" required>
            <input type="email" name="email" placeholder="Enter Email" class="form-control mb-3" required>
            <input type="password" 
                   name="password" 
                   placeholder="Enter Password" 
                   class="form-control mb-3" 
                   pattern="(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}" 
                   title="At least 6 characters, including a number and a special character" 
                   required>
            <button type="submit" class="btn-primary">Register</button>
        </form>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/admin/loginAdmin">Already have an account? Login →</a>
        </div>
    </div>
</div>
</body>
</html>
