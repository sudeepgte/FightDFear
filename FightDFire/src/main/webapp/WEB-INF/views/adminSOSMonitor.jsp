<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SOS Live Monitor — Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

    <!-- SockJS + STOMP for real-time WebSocket -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<style>
    :root {
        --sos-red: #ff3b3b;
        --purple: #1e1b4b;
        --bg: #f0f2f5;
        --maroon:        #1e1b4b;
        --maroon-light:  #312e81;
        --maroon-dark:   #0b0920;
        --maroon-pale:   #f8fafc;
        --maroon-border: rgba(30, 27, 75, 0.12);
        --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
        --sidebar-w: 272px;
    }
    
    .topbar {
        background: var(--maroon); color:#fff;
        padding: 0 20px; height: 58px;
        display: flex; align-items: center; justify-content: space-between;
        position: sticky; top: 0; z-index: 1000;
        box-shadow: 0 3px 16px rgba(125,42,90,0.28);
    }
    .layout { display:flex; min-height:calc(100vh - 58px); }
    .sidebar {
        width: var(--sidebar-w); background:#fff;
        border-right:1px solid var(--maroon-border);
        position:sticky; top:58px; height:calc(100vh - 58px);
        padding:14px 12px; overflow-y:auto; flex-shrink:0;
        transition: all 0.3s ease;
    }
    .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
    .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
    .navlink {
        display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
        color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
    }
    .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
    .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
    .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
    .navlink.active i { color: #fff; }
    body { font-family: 'Poppins', sans-serif; background: var(--bg); margin: 0; padding: 0; }
    .header {
        background: linear-gradient(135deg, #d32f2f, #b71c1c);
        color: white; padding: 15px 30px;
        display: flex; justify-content: space-between; align-items: center;
        box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    .header h1 { margin: 0; font-size: 1.4rem; display: flex; align-items: center; gap: 10px; }
    .live-badge {
        display: inline-flex; align-items: center; gap: 6px;
        background: rgba(255,255,255,0.2); padding: 4px 12px; border-radius: 20px;
        font-size: 0.75rem; font-weight: 600;
    }
    .live-dot {
        width: 8px; height: 8px; border-radius: 50%; background: #ff5252;
        animation: livePulse 1.5s infinite;
    }
    @keyframes livePulse { 0%,100% { opacity: 1; box-shadow: 0 0 0 0 rgba(255,82,82,0.4); } 50% { opacity: 0.6; box-shadow: 0 0 0 6px rgba(255,82,82,0); } }

    .container-fluid { padding: 20px; }
    .row { display: flex; gap: 20px; }
    .col-map { flex: 2; background: white; border-radius: 16px; padding: 10px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
    .col-list {
        flex: 1; background: white; border-radius: 16px; padding: 20px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08); max-height: 80vh; overflow-y: auto;
    }
    
    #sosMap { height: 600px; width: 100%; border-radius: 12px; background: #eee; }
    
    .sos-card {
        border: 1px solid #eee; border-left: 5px solid var(--sos-red);
        padding: 16px; border-radius: 12px; margin-bottom: 15px;
        position: relative; transition: all 0.3s;
    }
    .sos-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); transform: translateY(-2px); }
    .sos-card.resolved { border-left-color: #4caf50; opacity: 0.6; }
    .sos-card .time { font-size: 0.8rem; color: #999; margin-bottom: 4px; }
    .sos-card .name {
        font-weight: 700; font-size: 1.1rem; color: var(--purple);
        display: flex; align-items: center; gap: 8px;
    }
    .sos-card .phone { color: #555; font-size: 0.9rem; margin: 2px 0; }
    .sos-card .status-badge {
        display: inline-block; padding: 3px 10px; border-radius: 20px;
        font-size: 0.75rem; font-weight: 600; margin: 6px 0;
    }
    .status-badge.active { background: #ffebee; color: #d32f2f; }
    .status-badge.resolved { background: #e8f5e9; color: #2e7d32; }
    .status-badge.pending { background: #fff3e0; color: #e65100; }

    .btn-resolve {
        background: var(--sos-red); color: white; border: none;
        padding: 6px 14px; border-radius: 8px; cursor: pointer;
        font-size: 0.85rem; font-weight: 600; transition: all 0.2s;
    }
    .btn-resolve:hover { background: #e53935; transform: translateY(-1px); }

    .btn-maps {
        display: inline-block; background: #1976d2; color: white;
        padding: 6px 14px; border-radius: 8px; text-decoration: none;
        font-size: 0.85rem; font-weight: 600; transition: all 0.2s;
    }
    .btn-maps:hover { background: #1565c0; color: white; transform: translateY(-1px); }

    .btn-locate {
        display: inline-block; background: #7b1fa2; color: white;
        padding: 6px 14px; border-radius: 8px; text-decoration: none;
        font-size: 0.85rem; font-weight: 600; cursor: pointer; border: none;
        transition: all 0.2s;
    }
    .btn-locate:hover { background: #6a1b9a; transform: translateY(-1px); }

    .action-row { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }

    .alert-count {
        display: flex; gap: 15px; margin-bottom: 15px;
    }
    .alert-count .count-card {
        flex: 1; text-align: center; padding: 12px; border-radius: 10px;
        border: 1px solid #eee;
    }
    .count-card.active-count { background: #ffebee; }
    .count-card.total-count { background: #e3f2fd; }
    .count-card .count-number { font-size: 28px; font-weight: 700; }
    .count-card .count-label { font-size: 0.75rem; color: #777; }

    .error-log { background: #ffeeee; color: #cc0000; padding: 10px; border: 1px solid #ffcccc; margin-bottom: 10px; border-radius: 8px; display: none; }

    /* New alert toast */
    .sos-toast {
        position: fixed; top: 80px; right: 20px; z-index: 9999;
        background: #d32f2f; color: white; padding: 16px 24px;
        border-radius: 12px; font-weight: 600; font-size: 14px;
        box-shadow: 0 8px 30px rgba(211,47,47,0.4);
        display: none; animation: slideInRight 0.4s ease;
    }
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }

    /* ── MOBILE RESPONSIVE ── */

    /* Tablets */
    @media (max-width: 992px) {
        .row { gap: 16px; }
        .col-map { flex: 1; }
        .col-list { max-height: none; }
        #sosMap { height: 450px; }
        .container-fluid { padding: 16px; }
    }

    /* Phones */
    @media (max-width: 768px) {
        .row { flex-direction: column; gap: 14px; }

        /* Header */
        .header { 
            padding: 12px 16px; 
            flex-direction: column; 
            gap: 10px; 
            text-align: center; 
        }
        .header h1 { 
            font-size: 1.05rem; 
            justify-content: center; 
            flex-wrap: wrap; 
        }
        .header .btn { font-size: 0.78rem; padding: 5px 12px; }

        /* Container */
        .container-fluid { padding: 12px 8px; }

        /* Map */
        .col-map { 
            padding: 8px; 
            border-radius: 12px; 
        }
        #sosMap { height: 280px; border-radius: 10px; }

        /* List */
        .col-list { 
            padding: 14px; 
            border-radius: 12px; 
            max-height: none; 
        }

        /* Count cards */
        .alert-count { gap: 10px; margin-bottom: 12px; }
        .count-card { padding: 10px 8px; border-radius: 8px; }
        .count-card .count-number { font-size: 22px; }
        .count-card .count-label { font-size: 0.7rem; }

        /* SOS cards */
        .sos-card { padding: 12px; border-radius: 10px; margin-bottom: 10px; }
        .sos-card .name { font-size: 0.95rem; }
        .sos-card .phone { font-size: 0.82rem; }
        .sos-card .time { font-size: 0.72rem; }

        /* Action buttons */
        .action-row { 
            gap: 6px; 
            flex-direction: column; 
        }
        .btn-resolve, .btn-maps, .btn-locate { 
            width: 100%; 
            text-align: center; 
            padding: 10px 14px; 
            font-size: 0.82rem; 
            border-radius: 8px; 
        }

        /* Toast */
        .sos-toast { 
            top: auto; bottom: 16px; 
            right: 12px; left: 12px; 
            text-align: center; 
            font-size: 0.82rem; 
            padding: 12px 16px; 
            border-radius: 10px; 
        }

        /* Live badge */
        .live-badge { font-size: 0.65rem; padding: 3px 8px; }
    }

    /* Very small phones */
    @media (max-width: 400px) {
        .header h1 { font-size: 0.9rem; gap: 6px; }
        .header { padding: 10px 10px; }
        .container-fluid { padding: 8px 4px; }
        #sosMap { height: 220px; }
        .col-map { padding: 6px; }
        .col-list { padding: 10px; }
        .sos-card { padding: 10px; }
        .sos-card .name { font-size: 0.88rem; }
        .count-card .count-number { font-size: 18px; }
        .btn-resolve, .btn-maps, .btn-locate { 
            padding: 8px 10px; 
            font-size: 0.75rem; 
        }
    }
</style>
</head>
<body>

<div class="topbar">
  <div style="display:flex;align-items:center;">
    <button class="mobile-toggle" id="sidebarToggle" style="background:none;border:none;color:#fff;font-size:1.2rem;margin-right:15px;display:none;"><i class="fas fa-bars"></i></button>
    <span class="brand" style="font-weight:700;font-size:1.1rem;">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  </div>
  <a href="${pageContext.request.contextPath}/admin/logout" style="background:rgba(255,255,255,0.15); color:#fff; border:1px solid rgba(255,255,255,0.3); border-radius:7px; padding:5px 16px; font-size:0.85rem; font-weight:600; text-decoration:none;">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>
  <main style="flex:1; padding:20px;">
<div class="sos-toast" id="sosToast">
    <i class="fas fa-exclamation-triangle"></i> <span id="toastText">New SOS Alert!</span>
</div>

<div class="container-fluid">
    <div id="globalError" class="error-log"></div>
    
    <div class="row">
        <div class="col-map">
            <div id="sosMap"></div>
        </div>
        <div class="col-list">
            <!-- Summary Counters -->
            <div class="alert-count">
                <div class="count-card active-count">
                    <div class="count-number" id="activeCount" style="color: #d32f2f;">0</div>
                    <div class="count-label">Active</div>
                </div>
                <div class="count-card total-count">
                    <div class="count-number" id="totalCount" style="color: #1976d2;">0</div>
                    <div class="count-label">Total</div>
                </div>
            </div>
            
            <div id="sosList">
                <div style="text-align:center; padding: 50px;">
                    <i class="fas fa-spinner fa-spin fa-2x"></i><br>
                    Connecting to SOS Server...
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Audio alert for new SOS -->
<audio id="sosAudio" preload="auto" loop>
    <source src="${pageContext.request.contextPath}/siren.mp3" type="audio/mpeg">
</audio>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    // GLOBAL ERROR CATCHER
    window.onerror = function(msg, url, line) {
        var errDiv = document.getElementById('globalError');
        errDiv.style.display = 'block';
        errDiv.innerHTML = "<b>JS ERROR:</b> " + msg + " (Line: " + line + ")";
        return false;
    };

    var CTX = '${pageContext.request.contextPath}';
    var map, markers = {};
    var stompClient = null;

    // === Initialize Map ===
    function initMap() {
        map = L.map('sosMap').setView([20.5937, 78.9629], 5);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap'
        }).addTo(map);
    }

    // === Connect WebSocket for real-time alerts ===
    function connectWebSocket() {
        try {
            var socket = new SockJS(CTX + '/ws-sos');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;

            stompClient.connect({}, function(frame) {
                console.log('Admin SOS WebSocket connected');

                // Listen for new SOS alerts in real-time
                stompClient.subscribe('/topic/admin-sos', function(message) {
                    var data = JSON.parse(message.body);
                    console.log('New SOS alert received via WebSocket:', data);

                    // Show toast notification
                    showSosToast(data.userName || 'Someone');
                    
                    // Play alarm sound
                    try { document.getElementById('sosAudio').play(); } catch(e) {}

                    // Immediately refresh the list
                    fetchSosData();
                });
            }, function(err) {
                console.error('WebSocket connection failed:', err);
            });
        } catch (e) {
            console.log('WebSocket not available, using polling only');
        }
    }

    function showSosToast(name) {
        var toast = document.getElementById('sosToast');
        document.getElementById('toastText').textContent = '🚨 New SOS from ' + name + '!';
        toast.style.display = 'block';
        setTimeout(function() { toast.style.display = 'none'; }, 5000);
    }

    // === Fetch SOS Data ===
    function fetchSosData() {
        fetch(CTX + '/admin/sos.json?t=' + Date.now())
            .then(function(res) { return res.json(); })
            .then(function(data) {
                renderList(data);
                updateMap(data);
                updateCounters(data);
            })
            .catch(function(err) {
                console.error("Fetch failed", err);
                document.getElementById('sosList').innerHTML = "<b>Error:</b> " + err.message;
            });
    }

    // === Update Counters ===
    function updateCounters(data) {
        var activeCount = 0;
        for (var i = 0; i < data.length; i++) {
            if (data[i].status === 'ACTIVE') activeCount++;
        }
        document.getElementById('activeCount').textContent = activeCount;
        document.getElementById('totalCount').textContent = data.length;

        // If no active alerts, stop the siren
        if (activeCount === 0) {
            try {
                var audio = document.getElementById('sosAudio');
                audio.pause();
                audio.currentTime = 0;
            } catch(e) {}
        }
    }

    // === Render Alert List ===
    function renderList(data) {
        var list = document.getElementById('sosList');
        if (!data || data.length === 0) {
            list.innerHTML = "<div style='color:#888; text-align:center; padding: 40px;'><i class='fas fa-check-circle fa-3x' style='color: #4caf50; margin-bottom: 10px;'></i><br>No SOS alerts at this time.</div>";
            return;
        }

        var html = "";
        for (var i = 0; i < data.length; i++) {
            var s = data[i];
            var isResolved = (s.status === 'RESOLVED');
            var statusClass = isResolved ? 'resolved' : (s.status === 'ACTIVE' ? 'active' : 'pending');
            var userName = s.userName || 'Unknown';
            var userPhone = s.userPhone || 'N/A';
            var lat = parseFloat(s.lat);
            var lng = parseFloat(s.lng);
            var hasLocation = (!isNaN(lat) && !isNaN(lng) && (lat !== 0 || lng !== 0));

            html += '<div class="sos-card ' + (isResolved ? 'resolved' : '') + '">';
            html += '  <div class="time"><i class="fas fa-clock"></i> ' + (s.time || 'N/A') + '</div>';
            html += '  <div class="name"><i class="fas fa-user"></i> ' + userName + '</div>';
            html += '  <div class="phone"><i class="fas fa-phone"></i> ' + userPhone + '</div>';
            html += '  <div><span class="status-badge ' + statusClass + '"><i class="fas fa-circle" style="font-size:8px;"></i> ' + s.status + '</span></div>';
            
            html += '  <div class="action-row">';
            
            // View on Map button (focuses on location in the embedded Leaflet map)
            if (hasLocation) {
                html += '    <button class="btn-locate" onclick="focusOnMap(' + lat + ',' + lng + ',\'' + userName.replace(/'/g, "\\'") + '\')"><i class="fas fa-crosshairs"></i> View on Map</button>';
                html += '    <a href="https://www.google.com/maps?q=' + lat + ',' + lng + '" target="_blank" class="btn-maps"><i class="fas fa-map-marker-alt"></i> Google Maps</a>';
            } else {
                html += '    <span style="color: #999; font-size: 0.8rem;"><i class="fas fa-map-marker-alt"></i> No location data</span>';
            }

            if (!isResolved) {
                html += '    <button onclick="resolveAlert(\'' + s.id + '\')" class="btn-resolve"><i class="fas fa-check"></i> Resolve</button>';
            }
            
            html += '  </div>';
            html += '</div>';
        }
        list.innerHTML = html;
    }

    // === Focus on specific SOS location on the map ===
    function focusOnMap(lat, lng, name) {
        if (!map) return;
        map.setView([lat, lng], 16);
        
        // Add/update a highlight marker
        L.popup()
            .setLatLng([lat, lng])
            .setContent('<b style="color: #d32f2f;">🚨 SOS: ' + name + '</b><br>Lat: ' + lat.toFixed(5) + '<br>Lng: ' + lng.toFixed(5))
            .openOn(map);
    }

    // === Update Map Markers ===
    function updateMap(data) {
        if (!map) return;
        
        // Remove old markers
        Object.keys(markers).forEach(function(key) {
            map.removeLayer(markers[key]);
            delete markers[key];
        });

        var bounds = [];

        for (var i = 0; i < data.length; i++) {
            var s = data[i];
            var lat = parseFloat(s.lat);
            var lng = parseFloat(s.lng);
            
            if (!isNaN(lat) && !isNaN(lng) && lat !== 0 && lng !== 0) {
                var isActive = (s.status === 'ACTIVE');
                var userName = s.userName || 'Unknown';
                
                var icon = L.divIcon({
                    className: 'custom-sos-marker',
                    html: '<div style="background:' + (isActive ? '#d32f2f' : '#4caf50') + '; width: 14px; height: 14px; border-radius: 50%; border: 3px solid white; box-shadow: 0 0 ' + (isActive ? '10' : '4') + 'px ' + (isActive ? 'rgba(211,47,47,0.6)' : 'rgba(76,175,80,0.4)') + ';' + (isActive ? 'animation: livePulse 1.5s infinite;' : '') + '"></div>',
                    iconSize: [20, 20],
                    iconAnchor: [10, 10]
                });
                
                var m = L.marker([lat, lng], { icon: icon }).addTo(map);
                m.bindPopup(
                    '<div style="min-width: 180px;">'
                    + '<b style="color: #1e1b4b; font-size: 14px;">' + userName + '</b><br>'
                    + '<span style="color: #555;">' + (s.userPhone || 'N/A') + '</span><br>'
                    + '<span class="status-badge ' + (isActive ? 'active' : 'resolved') + '" style="display:inline-block;margin:4px 0;padding:2px 8px;border-radius:10px;font-size:11px;">' + s.status + '</span><br>'
                    + '<a href="https://www.google.com/maps?q=' + lat + ',' + lng + '" target="_blank" style="font-size:12px;">Open in Google Maps →</a>'
                    + '</div>'
                );
                markers[s.id] = m;
                bounds.push([lat, lng]);
            }
        }
        
        // Fit map to show all markers
        if (bounds.length > 0) {
            map.fitBounds(bounds, { padding: [30, 30], maxZoom: 14 });
        }
    }

    // === Resolve Alert ===
    function resolveAlert(id) {
        if (!confirm("Resolve this SOS alert?")) return;
        fetch(CTX + '/admin/sos/' + id + '/resolve', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) { if (data.success) fetchSosData(); });
    }

    // === Init ===
    window.onload = function() {
        initMap();
        fetchSosData();
        connectWebSocket();
        setInterval(fetchSosData, 5000); // Also poll every 5 seconds as fallback
    };
</script>

  </main>
</div>

</body>
</html>


