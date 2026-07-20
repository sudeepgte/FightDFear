<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
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
        background: var(--light-bg);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
        padding: 20px;
    }

    .safety-container {
        max-width: 600px;
        width: 100%;
        background: white;
        border-radius: 28px;
        box-shadow: var(--shadow-md);
        padding: 40px 30px;
        text-align: center;
        transition: transform 0.2s;
    }
    .safety-container:hover {
        transform: translateY(-5px);
    }

    h2 {
        color: var(--primary-purple);
        font-weight: 700;
        margin-bottom: 20px;
        font-size: 1.8rem;
    }

    .loader {
        margin: 30px auto;
        width: 50px;
        height: 50px;
        border: 5px solid rgba(123, 44, 191, 0.2);
        border-top: 5px solid var(--primary-purple-light);
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .result-card {
        margin-top: 25px;
        padding: 20px;
        border-radius: 20px;
        background: var(--light-bg);
        box-shadow: var(--shadow-sm);
    }
    .result-card h3 {
        font-size: 1.2rem;
        color: var(--dark-bg);
        margin: 10px 0;
    }
    .safety-status {
        font-size: 1.8rem;
        font-weight: 800;
        margin-top: 15px;
        padding: 12px;
        border-radius: 60px;
        display: inline-block;
        width: auto;
    }
    .status-safe {
        background: rgba(32, 201, 151, 0.15);
        color: var(--primary-teal);
        border-left: 5px solid var(--primary-teal);
    }
    .status-unsafe {
        background: rgba(255, 107, 107, 0.15);
        color: var(--primary-coral-dark);
        border-left: 5px solid var(--primary-coral);
    }
    .status-moderate {
        background: rgba(255, 215, 0, 0.15);
        color: #b8860b;
        border-left: 5px solid var(--primary-gold);
    }
    .coordinates {
        font-family: monospace;
        background: white;
        padding: 8px 12px;
        border-radius: 30px;
        display: inline-block;
        font-size: 0.9rem;
        color: var(--primary-purple);
    }
    .btn-back {
        display: inline-block;
        margin-top: 25px;
        text-decoration: none;
        background: var(--gradient-primary);
        color: white;
        padding: 10px 24px;
        border-radius: 40px;
        font-weight: 600;
        transition: all 0.2s;
        box-shadow: var(--shadow-sm);
    }
    .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        color: white;
    }
    @media (max-width: 500px) {
        .safety-container {
            padding: 25px 20px;
        }
        h2 {
            font-size: 1.5rem;
        }
        .safety-status {
            font-size: 1.3rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole container */
    .safety-container {
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

    /* 2. Loader enhancement – add a subtle glow */
    .loader {
        box-shadow: 0 0 8px rgba(123, 44, 191, 0.3);
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-back {
        position: relative;
        overflow: hidden;
    }
    .btn-back::after {
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
    .btn-back:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-back:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 40px;
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

    /* 6. Status pill hover effect – subtle scale */
    .safety-status {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .safety-status:hover {
        transform: scale(1.02);
        box-shadow: var(--shadow-sm);
    }

    /* 7. Coordinates box hover effect – subtle background shift */
    .coordinates {
        transition: background 0.2s, transform 0.2s;
    }
    .coordinates:hover {
        background: rgba(123, 44, 191, 0.05);
        transform: translateY(-1px);
    }

    /* 8. Heading hover effect – subtle text shadow */
    h2 {
        transition: text-shadow 0.2s;
    }
    h2:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.2);
    }

    /* 9. Responsive touch improvements for very small screens */
    @media (max-width: 380px) {
        .safety-container {
            padding: 20px 15px;
        }
        .btn-back {
            padding: 8px 18px;
            font-size: 0.9rem;
        }
        .safety-status {
            font-size: 1.2rem;
            padding: 8px;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .safety-container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
    <title>Safety Check</title>
    <script>
        function fetchLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    let lat = position.coords.latitude;
                    let lon = position.coords.longitude;

                    // Call backend API
                    window.location.href = "/safety/check?latitude=" + lat + "&longitude=" + lon;
                });
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }
    </script>
</head>
<body onload="fetchLocation()"> 
    <h2>Checking Safety...</h2>

    <c:if test="${not empty safety_status}">
        <h3>Your Location: ${latitude}, ${longitude}</h3>
        <h3>AI Prediction: ${safety_status}</h3>
    </c:if>
</body>
</html>

