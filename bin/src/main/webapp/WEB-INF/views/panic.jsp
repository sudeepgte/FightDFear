<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panic Button - Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #f43f5e;
            --primary-dark: #9D174D;
            --accent: #1e1b4b;
            --danger-glow: rgba(219, 39, 119, 0.35);
            --bg: #0f0f1a;
            --card-bg: rgba(255,255,255,0.04);
            --text: #f1f1f1;
            --text-muted: rgba(255,255,255,0.5);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            overflow-y: auto;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 50%; left: 50%;
            width: 500px; height: 500px;
            background: radial-gradient(circle, var(--danger-glow) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            border-radius: 50%;
            animation: bgPulse 4s ease-in-out infinite;
            z-index: 0;
        }
        @keyframes bgPulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.25; }
            50% { transform: translate(-50%, -50%) scale(1.2); opacity: 0.5; }
        }

        .panic-wrapper {
            position: relative;
            z-index: 1;
            text-align: center;
            padding: 20px;
            width: 100%;
            max-width: 420px;
        }

        .panic-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(219,39,119,0.12);
            border: 1px solid rgba(219,39,119,0.25);
            color: var(--primary);
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            margin-bottom: 35px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        .panic-title {
            font-size: 2rem;
            font-weight: 900;
            color: var(--text);
            margin-bottom: 12px;
        }

        .panic-subtitle {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-bottom: 40px;
            line-height: 1.6;
        }

        /* Big circular panic button */
        .panic-btn-container {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 0 auto 40px;
        }

        .panic-btn-ring {
            position: absolute;
            inset: 0;
            border-radius: 50%;
            border: 3px solid rgba(219,39,119,0.2);
            animation: ringPulse 2.5s ease-in-out infinite;
        }
        .panic-btn-ring:nth-child(2) { inset: -15px; animation-delay: 0.5s; opacity: 0.5; }
        .panic-btn-ring:nth-child(3) { inset: -30px; animation-delay: 1s; opacity: 0.3; }

        @keyframes ringPulse {
            0%, 100% { transform: scale(1); opacity: 0.3; }
            50% { transform: scale(1.05); opacity: 0.6; }
        }

        .panic-btn {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            border: none;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            font-family: 'Inter', sans-serif;
            font-size: 1.1rem;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 15px 50px var(--danger-glow);
            position: relative;
            z-index: 2;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .panic-btn i {
            font-size: 2.5rem;
        }

        .panic-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 20px 60px rgba(219,39,119,0.5);
        }
        .panic-btn:active {
            transform: scale(0.98);
        }

        /* Timer presets */
        .presets {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin-bottom: 35px;
        }

        .preset-chip {
            padding: 10px 22px;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.05);
            color: var(--text-muted);
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s;
            backdrop-filter: blur(8px);
        }
        .preset-chip:hover, .preset-chip.active {
            background: rgba(219,39,119,0.15);
            border-color: rgba(219,39,119,0.4);
            color: var(--primary);
        }

        .custom-input {
            display: none;
            margin: -10px auto 25px;
            text-align: center;
        }

        .custom-input input {
            width: 100px;
            padding: 10px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.15);
            background: rgba(255,255,255,0.06);
            color: var(--text);
            font-size: 1.1rem;
            font-weight: 700;
            text-align: center;
            font-family: 'Inter', sans-serif;
            outline: none;
        }
        .custom-input input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--danger-glow);
        }

        .custom-input label {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-left: 8px;
        }

        /* Back link */
        .back-link {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--text); }

        @media (max-width: 480px) {
            .panic-btn-container { width: 170px; height: 170px; }
            .panic-btn { width: 170px; height: 170px; font-size: 0.95rem; }
            .panic-btn i { font-size: 2rem; }
            .panic-title { font-size: 1.6rem; }
        }
    </style>
</head>
<body>
    <div class="panic-wrapper">
        <div class="panic-badge">
            <i class="bi bi-shield-exclamation"></i> Emergency Mode
        </div>

        <h1 class="panic-title">Panic Alert</h1>
        <p class="panic-subtitle">Set a countdown timer. If you don't cancel it in time, your location will be sent to your emergency contacts.</p>

        <!-- Timer presets -->
        <div class="presets">
            <button class="preset-chip" data-time="5" onclick="selectTime(5, this)">5s</button>
            <button class="preset-chip active" data-time="10" onclick="selectTime(10, this)">10s</button>
            <button class="preset-chip" data-time="30" onclick="selectTime(30, this)">30s</button>
            <button class="preset-chip" data-time="60" onclick="selectTime(60, this)">60s</button>
            <button class="preset-chip" onclick="showCustom()">Custom</button>
        </div>

        <div class="custom-input" id="customInput">
            <input type="number" id="customTime" value="15" min="3" max="300">
            <label>seconds</label>
        </div>

        <!-- Big Panic Button -->
        <div class="panic-btn-container">
            <div class="panic-btn-ring"></div>
            <div class="panic-btn-ring"></div>
            <div class="panic-btn-ring"></div>
            <button class="panic-btn" onclick="activatePanic()">
                <i class="bi bi-exclamation-triangle-fill"></i>
                ACTIVATE
            </button>
        </div>

        <a href="${pageContext.request.contextPath}/" class="back-link">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </div>

    <script>
        let selectedTime = 10;
        const ctx = "${pageContext.request.contextPath}";

        function selectTime(time, el) {
            selectedTime = time;
            document.getElementById('customInput').style.display = 'none';
            document.querySelectorAll('.preset-chip').forEach(function(c) { c.classList.remove('active'); });
            if (el) el.classList.add('active');
        }

        function showCustom() {
            document.querySelectorAll('.preset-chip').forEach(function(c) { c.classList.remove('active'); });
            document.getElementById('customInput').style.display = 'block';
        }

        function activatePanic() {
            var customInput = document.getElementById('customInput');
            if (customInput.style.display === 'block') {
                var val = parseInt(document.getElementById('customTime').value);
                if (!val || val < 3) { alert('Minimum 3 seconds'); return; }
                selectedTime = val;
            }
            window.location.href = ctx + '/panic/timer?time=' + selectedTime;
        }
    </script>
</body>
</html>

