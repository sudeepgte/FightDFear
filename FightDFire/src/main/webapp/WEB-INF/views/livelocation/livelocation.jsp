<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Location - Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" crossorigin="" />
    <style>
        :root {
            --primary: #3B82F6;
            --primary-dark: #1D4ED8;
            --primary-glow: rgba(59,130,246,0.3);
            --accent: #1e1b4b;
            --danger: #EF4444;
            --success: #10B981;
            --warning: #F59E0B;
            --bg: #0f0f1a;
            --card: rgba(255,255,255,0.05);
            --card-border: rgba(255,255,255,0.08);
            --text: #f1f1f1;
            --text-muted: rgba(255,255,255,0.45);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* Top bar */
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 24px;
            background: rgba(15,15,26,0.9);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--card-border);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .topbar-left a {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 1.2rem;
            transition: color 0.2s;
        }
        .topbar-left a:hover { color: var(--text); }

        .topbar-title {
            font-size: 1.1rem;
            font-weight: 700;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--text-muted);
        }
        .status-dot.active {
            background: var(--success);
            animation: dotPulse 1.5s ease-in-out infinite;
        }
        @keyframes dotPulse {
            0%, 100% { opacity: 1; box-shadow: 0 0 0 0 rgba(16,185,129,0.4); }
            50% { opacity: 0.7; box-shadow: 0 0 0 6px rgba(16,185,129,0); }
        }

        .status-text {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-muted);
        }
        .status-text.active { color: var(--success); }

        /* Main layout */
        .main-layout {
            display: grid;
            grid-template-columns: 340px 1fr;
            height: calc(100vh - 57px);
        }

        /* Side panel */
        .side-panel {
            padding: 24px;
            overflow-y: auto;
            border-right: 1px solid var(--card-border);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .panel-card {
            background: var(--card);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 20px;
        }

        .panel-card-title {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--text-muted);
            margin-bottom: 16px;
        }

        /* Location info card */
        .coords-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .coord-item {
            background: rgba(255,255,255,0.03);
            border-radius: 12px;
            padding: 14px;
            text-align: center;
        }

        .coord-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
        }

        .coord-value {
            font-size: 1.15rem;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }

        .accuracy-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 14px;
            padding: 10px 14px;
            background: rgba(16,185,129,0.08);
            border-radius: 10px;
            font-size: 0.8rem;
            color: var(--success);
        }

        .accuracy-bar i { font-size: 1rem; }

        /* Tracking button */
        .tracking-btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 14px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.25s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .tracking-btn.start {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: 0 8px 30px var(--primary-glow);
        }
        .tracking-btn.start:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px var(--primary-glow);
        }

        .tracking-btn.stop {
            background: linear-gradient(135deg, var(--danger), #DC2626);
            color: white;
            box-shadow: 0 8px 30px rgba(239,68,68,0.3);
        }
        .tracking-btn.stop:hover {
            transform: translateY(-2px);
        }

        /* Share link */
        .share-section { margin-top: 4px; }

        .share-link-box {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--card-border);
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 12px;
        }

        .share-link-box input {
            flex: 1;
            background: none;
            border: none;
            color: var(--text);
            font-family: 'Inter', sans-serif;
            font-size: 0.8rem;
            outline: none;
        }

        .share-link-box button {
            background: var(--primary);
            border: none;
            color: white;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: background 0.2s;
        }
        .share-link-box button:hover { background: var(--primary-dark); }

        /* Updates log */
        .updates-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            max-height: 180px;
            overflow-y: auto;
        }

        .update-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            background: rgba(255,255,255,0.02);
            border-radius: 10px;
            font-size: 0.8rem;
        }

        .update-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--primary);
            flex-shrink: 0;
        }

        .update-time {
            color: var(--text-muted);
            font-size: 0.7rem;
            margin-left: auto;
            white-space: nowrap;
        }

        /* Map area */
        .map-container {
            position: relative;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        /* Map overlay stats */
        .map-overlay {
            position: absolute;
            top: 16px;
            right: 16px;
            z-index: 500;
            display: flex;
            gap: 8px;
        }

        .map-stat {
            background: rgba(15,15,26,0.85);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            border-radius: 12px;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .map-stat i { color: var(--primary); }

        /* Responsive */
        @media (max-width: 768px) {
            .main-layout {
                grid-template-columns: 1fr;
                grid-template-rows: 50vh 1fr;
            }
            .side-panel {
                order: 2;
                border-right: none;
                border-top: 1px solid var(--card-border);
            }
            .map-container { order: 1; }
        }
    </style>
</head>
<body>
    <!-- Top Bar -->
    <div class="topbar">
        <div class="topbar-left">
            <a href="${pageContext.request.contextPath}/"><i class="bi bi-arrow-left"></i></a>
            <span class="topbar-title"><i class="bi bi-geo-alt-fill" style="color:var(--primary)"></i> Live Location</span>
        </div>
        <div class="topbar-right">
            <span class="status-dot" id="statusDot"></span>
            <span class="status-text" id="statusText">Idle</span>
        </div>
    </div>

    <!-- Main Layout -->
    <div class="main-layout">
        <!-- Side Panel -->
        <div class="side-panel">

            <!-- Tracking Control -->
            <div class="panel-card">
                <div class="panel-card-title">Tracking Control</div>
                <button class="tracking-btn start" id="trackBtn" onclick="toggleTracking()">
                    <i class="bi bi-broadcast"></i> Start Tracking
                </button>
                <p style="font-size:0.75rem; color:var(--text-muted); margin-top:12px; text-align:center;">
                    Your location updates every 5 seconds while tracking.
                </p>
            </div>

            <!-- Current Location -->
            <div class="panel-card">
                <div class="panel-card-title">Current Position</div>
                <div class="coords-grid">
                    <div class="coord-item">
                        <div class="coord-label">Latitude</div>
                        <div class="coord-value" id="latValue">--</div>
                    </div>
                    <div class="coord-item">
                        <div class="coord-label">Longitude</div>
                        <div class="coord-value" id="lngValue">--</div>
                    </div>
                </div>
                <div class="accuracy-bar" id="accuracyBar" style="display:none;">
                    <i class="bi bi-bullseye"></i>
                    <span>Accuracy: <strong id="accuracyValue">--</strong> meters</span>
                </div>
            </div>

            <!-- Share Link -->
            <div class="panel-card share-section">
                <div class="panel-card-title">Share Location</div>
                <div class="share-link-box">
                    <input type="text" id="shareLink" readonly placeholder="Start tracking to generate link">
                    <button onclick="copyLink()">Copy</button>
                </div>
                <p style="font-size:0.72rem; color:var(--text-muted);">
                    Share this Google Maps link with trusted contacts.
                </p>
            </div>

            <!-- Update Log -->
            <div class="panel-card">
                <div class="panel-card-title">Activity Log</div>
                <div class="updates-list" id="updateLog">
                    <div class="update-item" style="color:var(--text-muted)">
                        No activity yet. Start tracking.
                    </div>
                </div>
            </div>
        </div>

        <!-- Map -->
        <div class="map-container">
            <div id="map"></div>
            <div class="map-overlay">
                <div class="map-stat">
                    <i class="bi bi-clock-history"></i>
                    <span id="updateCount">0</span> updates
                </div>
                <div class="map-stat">
                    <i class="bi bi-speedometer2"></i>
                    <span id="trackDuration">0:00</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" crossorigin=""></script>
    <script>
        const ctx = "${pageContext.request.contextPath}";
        const userId = ${user.id};

        let map, marker, pathLine;
        let isTracking = false;
        let watchId = null;
        let trackInterval = null;
        let updateCount = 0;
        let startTime = null;
        let pathCoords = [];

        // Initialize map
        map = L.map('map', {
            zoomControl: false
        }).setView([20.5937, 78.9629], 5); // Default: India center

        L.control.zoom({ position: 'bottomright' }).addTo(map);

        L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; CartoDB',
            maxZoom: 19
        }).addTo(map);

        // Custom marker icon
        var userIcon = L.divIcon({
            html: '<div style="width:20px;height:20px;background:#3B82F6;border:3px solid #fff;border-radius:50%;box-shadow:0 0 15px rgba(59,130,246,0.6);"></div>',
            iconSize: [20, 20],
            iconAnchor: [10, 10],
            className: ''
        });

        function toggleTracking() {
            if (isTracking) {
                stopTracking();
            } else {
                startTracking();
            }
        }

        function startTracking() {
            if (!navigator.geolocation) {
                alert('Geolocation not supported by your browser.');
                return;
            }

            isTracking = true;
            startTime = Date.now();
            pathCoords = [];
            updateCount = 0;

            var btn = document.getElementById('trackBtn');
            btn.className = 'tracking-btn stop';
            btn.innerHTML = '<i class="bi bi-stop-circle"></i> Stop Tracking';

            document.getElementById('statusDot').className = 'status-dot active';
            document.getElementById('statusText').className = 'status-text active';
            document.getElementById('statusText').textContent = 'Tracking';

            addLog('Tracking started');

            // Get initial position
            updatePosition();

            // Update every 5 seconds
            trackInterval = setInterval(updatePosition, 5000);

            // Update duration display
            setInterval(updateDuration, 1000);
        }

        function stopTracking() {
            isTracking = false;

            if (trackInterval) clearInterval(trackInterval);
            if (watchId) { navigator.geolocation.clearWatch(watchId); watchId = null; }

            var btn = document.getElementById('trackBtn');
            btn.className = 'tracking-btn start';
            btn.innerHTML = '<i class="bi bi-broadcast"></i> Start Tracking';

            document.getElementById('statusDot').className = 'status-dot';
            document.getElementById('statusText').className = 'status-text';
            document.getElementById('statusText').textContent = 'Stopped';

            addLog('Tracking stopped');
        }

        function updatePosition() {
            navigator.geolocation.getCurrentPosition(
                function(pos) {
                    var lat = pos.coords.latitude;
                    var lng = pos.coords.longitude;
                    var acc = pos.coords.accuracy;

                    // Update display
                    document.getElementById('latValue').textContent = lat.toFixed(6);
                    document.getElementById('lngValue').textContent = lng.toFixed(6);
                    document.getElementById('accuracyBar').style.display = 'flex';
                    document.getElementById('accuracyValue').textContent = Math.round(acc);

                    // Update share link
                    document.getElementById('shareLink').value =
                        'https://www.google.com/maps?q=' + lat + ',' + lng;

                    // Update map
                    var latlng = [lat, lng];
                    if (!marker) {
                        marker = L.marker(latlng, { icon: userIcon }).addTo(map);
                        map.setView(latlng, 16);
                    } else {
                        marker.setLatLng(latlng);
                    }

                    // Draw path
                    pathCoords.push(latlng);
                    if (pathLine) map.removeLayer(pathLine);
                    if (pathCoords.length > 1) {
                        pathLine = L.polyline(pathCoords, {
                            color: '#3B82F6',
                            weight: 3,
                            opacity: 0.7,
                            dashArray: '8, 6'
                        }).addTo(map);
                    }

                    map.panTo(latlng);

                    // Save to server
                    saveToServer(lat, lng);

                    updateCount++;
                    document.getElementById('updateCount').textContent = updateCount;

                    addLog('Position updated (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')');
                },
                function(err) {
                    addLog('Error: ' + err.message);
                },
                { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
            );
        }

        function saveToServer(lat, lng) {
            fetch(ctx + '/livelocation/save', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    latitude: lat,
                    longitude: lng,
                    userId: userId
                })
            }).catch(function(e) {
                console.warn('Save failed:', e);
            });
        }

        function addLog(msg) {
            var log = document.getElementById('updateLog');
            var now = new Date();
            var time = now.getHours().toString().padStart(2,'0') + ':' +
                       now.getMinutes().toString().padStart(2,'0') + ':' +
                       now.getSeconds().toString().padStart(2,'0');

            var item = document.createElement('div');
            item.className = 'update-item';
            item.innerHTML = '<span class="update-dot"></span><span>' + msg + '</span><span class="update-time">' + time + '</span>';

            // Remove "no activity" message
            if (updateCount === 0 && log.children.length === 1) {
                log.innerHTML = '';
            }

            log.insertBefore(item, log.firstChild);

            // Keep only last 20
            while (log.children.length > 20) {
                log.removeChild(log.lastChild);
            }
        }

        function updateDuration() {
            if (!isTracking || !startTime) return;
            var elapsed = Math.floor((Date.now() - startTime) / 1000);
            var mins = Math.floor(elapsed / 60);
            var secs = elapsed % 60;
            document.getElementById('trackDuration').textContent =
                mins + ':' + secs.toString().padStart(2, '0');
        }

        function copyLink() {
            var input = document.getElementById('shareLink');
            if (!input.value || input.value.indexOf('google') === -1) {
                alert('Start tracking first to generate a link.');
                return;
            }
            input.select();
            navigator.clipboard.writeText(input.value).then(function() {
                var btn = input.nextElementSibling;
                btn.textContent = 'Copied!';
                setTimeout(function() { btn.textContent = 'Copy'; }, 2000);
            });
        }
    </script>
</body>
</html>

