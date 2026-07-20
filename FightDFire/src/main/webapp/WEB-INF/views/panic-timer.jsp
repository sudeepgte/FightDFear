<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panic Timer - Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #f43f5e;
            --primary-dark: #9D174D;
            --accent: #1e1b4b;
            --danger-glow: rgba(219, 39, 119, 0.4);
            --success: #10B981;
            --bg: #0f0f1a;
            --card-bg: rgba(255,255,255,0.06);
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
            overflow: hidden;
            position: relative;
        }

        /* Animated background pulse */
        body::before {
            content: '';
            position: fixed;
            top: 50%; left: 50%;
            width: 600px; height: 600px;
            background: radial-gradient(circle, var(--danger-glow) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            border-radius: 50%;
            animation: bgPulse 3s ease-in-out infinite;
            z-index: 0;
        }
        @keyframes bgPulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.3; }
            50% { transform: translate(-50%, -50%) scale(1.3); opacity: 0.6; }
        }

        /* When alarm is active, background pulses faster and red */
        body.alarm-active::before {
            animation: bgAlarm 0.8s ease-in-out infinite;
            background: radial-gradient(circle, rgba(239,68,68,0.5) 0%, transparent 70%);
        }
        @keyframes bgAlarm {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.4; }
            50% { transform: translate(-50%, -50%) scale(1.5); opacity: 0.8; }
        }

        .panic-wrapper {
            position: relative;
            z-index: 1;
            text-align: center;
            padding: 20px;
            width: 100%;
            max-width: 420px;
        }

        /* Status badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(219,39,119,0.15);
            border: 1px solid rgba(219,39,119,0.3);
            color: var(--primary);
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }
        .status-badge .dot {
            width: 8px; height: 8px;
            background: var(--primary);
            border-radius: 50%;
            animation: dotPulse 1.5s ease-in-out infinite;
        }
        @keyframes dotPulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(0.7); }
        }

        /* Circular timer */
        .timer-ring-container {
            position: relative;
            width: 260px;
            height: 260px;
            margin: 0 auto 30px;
        }

        .timer-ring {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .timer-ring-bg {
            fill: none;
            stroke: rgba(255,255,255,0.08);
            stroke-width: 8;
        }

        .timer-ring-progress {
            fill: none;
            stroke: var(--primary);
            stroke-width: 8;
            stroke-linecap: round;
            stroke-dasharray: 754;
            stroke-dashoffset: 0;
            transition: stroke-dashoffset 1s linear, stroke 0.3s;
            filter: drop-shadow(0 0 12px var(--danger-glow));
        }

        .timer-content {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .timer-number {
            font-size: 5rem;
            font-weight: 900;
            color: var(--text);
            line-height: 1;
            letter-spacing: -3px;
        }

        .timer-label {
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-top: 5px;
        }

        /* Alert icon that appears when alarm triggers */
        .alert-icon {
            font-size: 4rem;
            color: #EF4444;
            animation: alertShake 0.5s ease-in-out infinite;
            display: none;
        }
        .alert-icon.visible { display: block; }
        @keyframes alertShake {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(-15deg); }
            75% { transform: rotate(15deg); }
        }

        /* Status message */
        .status-message {
            font-size: 1rem;
            color: var(--text-muted);
            margin-bottom: 30px;
            min-height: 24px;
            font-weight: 500;
        }
        .status-message.active {
            color: #EF4444;
            font-weight: 700;
            font-size: 1.15rem;
            animation: textPulse 1s ease-in-out infinite;
        }
        .status-message.sent {
            color: var(--success);
            font-weight: 700;
        }
        @keyframes textPulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        /* Buttons */
        .btn-group-panic {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-panic {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 32px;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-cancel {
            background: rgba(255,255,255,0.08);
            color: var(--text);
            border: 1px solid rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
        }
        .btn-cancel:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }

        .btn-stop {
            background: linear-gradient(135deg, #EF4444, #DC2626);
            color: white;
            box-shadow: 0 8px 30px rgba(239,68,68,0.3);
            display: none;
        }
        .btn-stop:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(239,68,68,0.4);
        }
        .btn-stop.visible { display: inline-flex; }

        .btn-safe {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            box-shadow: 0 8px 30px rgba(16,185,129,0.3);
            display: none;
        }
        .btn-safe.visible { display: inline-flex; }

        /* Info footer */
        .info-footer {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 24px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
        }

        .info-item .info-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: rgba(255,255,255,0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: var(--text-muted);
        }

        .info-item .info-text {
            font-size: 0.7rem;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .timer-ring-container { width: 220px; height: 220px; }
            .timer-number { font-size: 4rem; }
            .btn-panic { padding: 12px 24px; font-size: 0.9rem; }
            .info-footer { gap: 16px; }
        }
    </style>
</head>
<body>
    <div class="panic-wrapper">
        <!-- Status Badge -->
        <div class="status-badge" id="statusBadge">
            <span class="dot"></span>
            <span id="badgeText">Panic Timer Active</span>
        </div>

        <!-- Circular Timer -->
        <div class="timer-ring-container" id="timerContainer">
            <svg class="timer-ring" viewBox="0 0 260 260">
                <circle class="timer-ring-bg" cx="130" cy="130" r="120" />
                <circle class="timer-ring-progress" id="timerProgress" cx="130" cy="130" r="120" />
            </svg>
            <div class="timer-content">
                <div class="timer-number" id="timerNumber">${time}</div>
                <div class="timer-label" id="timerLabel">seconds</div>
            </div>
        </div>

        <!-- Alert Icon (hidden initially) -->
        <div class="alert-icon" id="alertIcon">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>

        <!-- Status Message -->
        <p class="status-message" id="statusMessage">Timer counting down... Stay calm.</p>

        <!-- Buttons -->
        <div class="btn-group-panic">
            <button class="btn-panic btn-cancel" id="cancelBtn" onclick="cancelPanic()">
                <i class="bi bi-x-lg"></i> I'm Safe
            </button>
            <button class="btn-panic btn-stop" id="stopBtn" onclick="stopAlarm()">
                <i class="bi bi-volume-mute-fill"></i> Stop Alarm
            </button>
        </div>

        <!-- Info Footer -->
        <div class="info-footer">
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-geo-alt"></i></div>
                <div class="info-text">GPS Ready</div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-envelope"></i></div>
                <div class="info-text">Email Alert</div>
            </div>
            <div class="info-item">
                <div class="info-icon"><i class="bi bi-shield-check"></i></div>
                <div class="info-text">Encrypted</div>
            </div>
        </div>
    </div>

    <!-- Alarm Sound -->
    <audio id="ringtone" src="${pageContext.request.contextPath}/siren.mp3" loop></audio>

    <script>
        const TOTAL_TIME = ${time};
        let timeRemaining = TOTAL_TIME;
        let timer;
        let alarmTimeout;
        let locationSent = false;
        const ctx = "${pageContext.request.contextPath}";

        // Circle math
        const circle = document.getElementById('timerProgress');
        const circumference = 2 * Math.PI * 120; // r=120
        circle.style.strokeDasharray = circumference;
        circle.style.strokeDashoffset = 0;

        // Auto-start on page load
        window.addEventListener('DOMContentLoaded', startCountdown);

        function updateRing() {
            const fraction = timeRemaining / TOTAL_TIME;
            const offset = circumference * (1 - fraction);
            circle.style.strokeDashoffset = offset;

            // Change color as time runs low
            if (fraction <= 0.3) {
                circle.style.stroke = '#EF4444';
            } else if (fraction <= 0.6) {
                circle.style.stroke = '#F59E0B';
            }
        }

        function startCountdown() {
            updateRing();

            timer = setInterval(function() {
                timeRemaining--;
                document.getElementById('timerNumber').textContent = timeRemaining;
                updateRing();

                if (timeRemaining <= 3 && timeRemaining > 0) {
                    document.getElementById('statusMessage').textContent = 'Alerting in ' + timeRemaining + '...';
                    document.getElementById('statusMessage').className = 'status-message active';
                }

                if (timeRemaining <= 0) {
                    clearInterval(timer);
                    triggerAlarm();
                }
            }, 1000);
        }

        function triggerAlarm() {
            document.body.classList.add('alarm-active');

            // Hide timer, show alert icon
            document.getElementById('timerContainer').style.display = 'none';
            document.getElementById('alertIcon').classList.add('visible');

            // Update badge
            document.getElementById('badgeText').textContent = 'EMERGENCY ALERT';
            document.getElementById('statusBadge').style.background = 'rgba(239,68,68,0.2)';
            document.getElementById('statusBadge').style.borderColor = 'rgba(239,68,68,0.5)';
            document.getElementById('statusBadge').style.color = '#EF4444';

            // Update status
            document.getElementById('statusMessage').textContent = 'ALARM ACTIVATED! Sending location...';
            document.getElementById('statusMessage').className = 'status-message active';

            // Show stop button, hide cancel
            document.getElementById('cancelBtn').style.display = 'none';
            document.getElementById('stopBtn').classList.add('visible');

            // Play siren
            var ringtone = document.getElementById('ringtone');
            ringtone.play().catch(function(e) { console.warn('Audio blocked:', e); });

            // Send location after 5 seconds
            alarmTimeout = setTimeout(sendLocation, 5000);
        }

        function cancelPanic() {
            clearInterval(timer);
            window.location.href = ctx + '/panic';
        }

        function stopAlarm() {
            clearTimeout(alarmTimeout);
            var ringtone = document.getElementById('ringtone');
            ringtone.pause();
            ringtone.currentTime = 0;
            document.body.classList.remove('alarm-active');

            document.getElementById('stopBtn').classList.remove('visible');
            document.getElementById('alertIcon').classList.remove('visible');
            document.getElementById('statusMessage').textContent = 'Alarm stopped. You are safe.';
            document.getElementById('statusMessage').className = 'status-message sent';

            document.getElementById('badgeText').textContent = 'Safe';
            document.getElementById('statusBadge').style.background = 'rgba(16,185,129,0.15)';
            document.getElementById('statusBadge').style.borderColor = 'rgba(16,185,129,0.3)';
            document.getElementById('statusBadge').style.color = '#10B981';

            setTimeout(function() {
                if (confirm('Set a new timer?')) {
                    window.location.href = ctx + '/panic';
                } else {
                    window.location.href = ctx + '/';
                }
            }, 1000);
        }

        function sendLocation() {
            if (locationSent) return;
            locationSent = true;

            if (!navigator.geolocation) {
                document.getElementById('statusMessage').textContent = 'Geolocation not supported. Call for help!';
                return;
            }

            document.getElementById('statusMessage').textContent = 'Getting your location...';

            navigator.geolocation.getCurrentPosition(
                function(position) {
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;

                    document.getElementById('statusMessage').textContent = 'Sending location to emergency contacts...';

                    fetch(ctx + '/panic/send-location', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'latitude=' + lat + '&longitude=' + lng
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        document.getElementById('statusMessage').textContent =
                            'Location sent! ' + (data.emailsSent || 0) + ' contact(s) notified.';
                        document.getElementById('statusMessage').className = 'status-message sent';
                    })
                    .catch(function() {
                        document.getElementById('statusMessage').textContent =
                            'Error sending. Please call emergency services!';
                        document.getElementById('statusMessage').className = 'status-message active';
                    });
                },
                function() {
                    document.getElementById('statusMessage').textContent =
                        'Location access denied. Share location manually!';
                    document.getElementById('statusMessage').className = 'status-message active';
                }
            );
        }
    </script>
</body>
</html>

