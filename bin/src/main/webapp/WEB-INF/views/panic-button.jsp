<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>🚨 Panic Button</title>
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
        --gradient-panic: linear-gradient(135deg, #1e1b4b, #f43f5e);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
    }

    body {
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 20px;
        background: linear-gradient(135deg, var(--light-bg), #ffffff);
        margin: 0;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .container {
        max-width: 400px;
        margin: auto;
        background: white;
        padding: 30px;
        border-radius: 20px;
        box-shadow: var(--shadow-md);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .container:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-md);
    }
    .btn {
        background: var(--gradient-panic);
        color: white;
        border: none;
        padding: 15px;
        width: 100%;
        font-size: 18px;
        cursor: pointer;
        border-radius: 60px;
        font-weight: bold;
        transition: all 0.2s;
        box-shadow: var(--shadow-sm);
    }
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        filter: brightness(1.02);
    }
    .timer {
        font-size: 28px;
        font-weight: bold;
        margin-top: 20px;
        color: var(--primary-purple);
        background: var(--light-bg);
        padding: 15px;
        border-radius: 60px;
        box-shadow: inset 0 1px 4px rgba(0,0,0,0.05), var(--shadow-sm);
    }
    .hidden {
        display: none;
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
    .btn {
        position: relative;
        overflow: hidden;
    }
    .btn::after {
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
    .btn:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outline for accessibility (keyboard navigation) */
    .btn:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 60px;
    }

    /* 4. Custom scrollbar (matches panic coral theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-coral);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-coral-dark);
    }

    /* 5. Timer text hover effect – subtle scale */
    .timer {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .timer:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 6. Add a gentle pulse animation to the button on page load (draws attention) */
    .btn {
        animation: gentlePulse 1.2s ease-in-out 0.3s;
    }
    @keyframes gentlePulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.02); box-shadow: 0 0 0 4px rgba(232,69,69,0.3); }
        100% { transform: scale(1); }
    }

    /* 7. Responsive touch improvements for very small screens */
    @media (max-width: 480px) {
        .container {
            padding: 20px;
        }
        .btn {
            padding: 12px;
            font-size: 16px;
        }
        .timer {
            font-size: 22px;
            padding: 12px;
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
    <script>
        let countdown = 10;  // Set the timer duration (in seconds)
        let timerInterval;

        function getLocationAndSendSOS() {
            document.getElementById("sosButton").disabled = true;
            document.getElementById("timerDiv").classList.remove("hidden");

            // Start countdown
            timerInterval = setInterval(() => {
                document.getElementById("timer").innerText = countdown;
                countdown--;

                if (countdown < 0) {
                    clearInterval(timerInterval);
                    playRingtone();  // Play ringtone after timer ends
                }
            }, 1000);

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((position) => {
                    sendSOS(position.coords.latitude, position.coords.longitude);
                }, (error) => {
                    alert("Error getting location: " + error

