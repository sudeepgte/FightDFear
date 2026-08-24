<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Volunteer Management</title>
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
        background: #ffffff;
        color: var(--dark-bg);
        font-family: 'Poppins', sans-serif;
        padding: 20px;
    }

    h2 {
        text-align: center;
        color: var(--primary-purple-light);
        font-weight: bold;
        margin-bottom: 30px;
    }

    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }

    .card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(123, 44, 191, 0.2);
        transition: transform 0.3s ease;
    }

    .card:hover {
        transform: translateY(-5px);
    }

    .card-body {
        background-color: rgba(123, 44, 191, 0.05);
        border-radius: 12px;
    }

    .card-title {
        font-size: 18px;
        font-weight: bold;
        color: var(--primary-purple);
        margin-bottom: 10px;
    }

    .card a {
        text-decoration: none;
        color: var(--primary-purple-light);
        font-weight: 500;
        transition: color 0.3s;
    }

    .card a:hover {
        color: var(--primary-purple);
    }

    .back-btn {
        display: block;
        width: 100%;
        text-align: center;
        margin-top: 30px;
        padding: 10px;
        border-radius: 5px;
        background: linear-gradient(to right, var(--primary-purple-light), var(--primary-purple));
        color: white;
        text-decoration: none;
        font-weight: bold;
        transition: all 0.3s;
    }

    .back-btn:hover {
        background: linear-gradient(to right, var(--primary-purple), var(--primary-purple-light));
        transform: scale(1.05);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole page content */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Card grid items appear with staggered animation (if needed – adds polish) */
    .card {
        opacity: 0;
        animation: slideUpFade 0.4s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes slideUpFade {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    /* Optional: delay each card for cascade effect (doesn't affect existing hover) */
    .card:nth-child(1) { animation-delay: 0.05s; }
    .card:nth-child(2) { animation-delay: 0.1s; }
    .card:nth-child(3) { animation-delay: 0.15s; }
    .card:nth-child(4) { animation-delay: 0.2s; }
    .card:nth-child(5) { animation-delay: 0.25s; }
    .card:nth-child(6) { animation-delay: 0.3s; }

    /* 3. Card image or icon scaling (if any icons exist) – generic for any icon inside card */
    .card i, .card svg, .card img {
        transition: transform 0.3s ease;
    }
    .card:hover i, .card:hover svg, .card:hover img {
        transform: scale(1.05);
    }

    /* 4. Button ripple effect on back-btn */
    .back-btn {
        position: relative;
        overflow: hidden;
    }
    .back-btn::after {
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
    .back-btn:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .back-btn:focus-visible,
    .card a:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
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

    /* 7. Card body subtle gradient border on hover (optional – adds depth) */
    .card {
        position: relative;
    }
    .card::before {
        content: '';
        position: absolute;
        inset: 0;
        border-radius: 12px;
        padding: 1px;
        background: linear-gradient(135deg, transparent, var(--primary-purple-light), transparent);
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        opacity: 0;
        transition: opacity 0.3s;
        pointer-events: none;
    }
    .card:hover::before {
        opacity: 1;
    }

    /* 8. Responsive improvements */

    /* Tablets */
    @media (max-width: 768px) {
        body { padding: 16px; }
        h2 { font-size: 1.4rem; margin-bottom: 20px; }
        .card-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
        }
        .card-title { font-size: 15px; margin-bottom: 8px; }
        .card a { font-size: 0.85rem; }
        .card-body { padding: 14px; }
        .back-btn { margin-top: 24px; padding: 12px; font-size: 0.95rem; }
    }

    /* Phones */
    @media (max-width: 550px) {
        body { padding: 12px 8px; }
        h2 { font-size: 1.2rem; margin-bottom: 16px; }
        .container { padding-left: 4px; padding-right: 4px; }
        .card-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }
        .card { border-radius: 10px; }
        .card-body { padding: 12px 10px; border-radius: 10px; }
        .card-title { font-size: 13px; margin-bottom: 6px; line-height: 1.3; }
        .card a { font-size: 0.78rem; }
        .back-btn { 
            padding: 12px; 
            font-size: 0.9rem; 
            margin-top: 20px; 
            border-radius: 8px; 
        }
    }

    /* Very small phones */
    @media (max-width: 380px) {
        body { padding: 8px 4px; }
        h2 { font-size: 1.05rem; margin-bottom: 12px; }
        .card-grid { gap: 8px; }
        .card-body { padding: 10px 8px; }
        .card-title { font-size: 12px; }
        .card a { font-size: 0.72rem; }
        .back-btn { padding: 10px; font-size: 0.82rem; }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
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
    <h2>Admin Volunteer Management</h2>
    
    <div class="card-grid">
        <div class="card">
            <div class="card-body">
                <div class="card-title">Manage Volunteers</div>
                <a href="${pageContext.request.contextPath}/volunteer/admin/volunteers">Go to Management →</a>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="card-title">Volunteers Success</div>
                <a href="${pageContext.request.contextPath}/volunteer/admin/successReports">View Reports →</a>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="card-title">Verified Volunteers</div>
                <a href="${pageContext.request.contextPath}/volunteer/approved-volunteers">See Verified List →</a>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="card-title">Requested Volunteers</div>
                <a href="${pageContext.request.contextPath}/volunteer/pending-volunteers">See Pending List →</a>
            </div>
        </div>

 <div class="card">
            <div class="card-body">
                <div class="card-title">suggested Volunteers</div>
                <a href="${pageContext.request.contextPath}/admin/pending-suggestions">See Pending List →</a>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="card-title">Reported Volunteers</div>
                <a href="${pageContext.request.contextPath}/volunteer/reported-volunteers">See Reported List →</a>
            </div>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="back-btn">⬅ Back to Admin Home</a>
</div>

</body>
</html>

