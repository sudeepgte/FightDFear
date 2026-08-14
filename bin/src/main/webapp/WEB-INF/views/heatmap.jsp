<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Community Safety Heat Map - India</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Rajdhani:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --neon-red: #ff3131; --neon-green: #39ff14; --neon-blue: #00d4ff; --neon-yellow: #faff00; --glass: rgba(10, 10, 20, 0.85); }
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; font-family: 'Rajdhani', sans-serif; background: #0b0b0f; }
        #map { position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; }
        
        /* HUD Interface */
        .hud-ui { position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 10; pointer-events: none; }
        .hud-header { position: absolute; top: 25px; left: 25px; background: var(--glass); padding: 15px 30px; border-radius: 12px; border-left: 5px solid var(--neon-blue); backdrop-filter: blur(10px); pointer-events: auto; }
        .hud-header h1 { margin: 0; color: #fff; font-size: 1.5rem; font-family: 'Orbitron'; letter-spacing: 1px; }
        .hud-header p { margin: 5px 0 0; color: var(--neon-blue); font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }

        .search-container { position: absolute; top: 25px; left: 350px; width: 350px; pointer-events: auto; }
        .leaflet-control-geocoder { background: var(--glass) !important; border: 1px solid rgba(0, 212, 255, 0.3) !important; border-radius: 10px !important; width: 100% !important; padding: 5px !important; }
        .leaflet-control-geocoder-icon { background-color: transparent !important; filter: invert(1); }
        .leaflet-control-geocoder-form input { background: transparent !important; color: #fff !important; font-family: 'Rajdhani' !important; font-size: 1rem !important; border:none !important; }

        .safety-stats { position: absolute; top: 25px; right: 85px; display: flex; gap: 20px; pointer-events: auto; }
        .stat-box { background: var(--glass); padding: 10px 20px; border-radius: 10px; border: 1px solid rgba(0, 212, 255, 0.3); text-align: center; }
        .stat-val { font-size: 1.4rem; font-weight: 800; font-family: 'Orbitron'; color: var(--neon-blue); }
        .stat-label { font-size: 0.65rem; color: #888; text-transform: uppercase; margin-top: 2px; }

        .control-panel { position: absolute; bottom: 35px; left: 25px; background: var(--glass); padding: 25px; border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1); width: 320px; pointer-events: auto; backdrop-filter: blur(15px); }
        .status-pill { display: inline-block; padding: 6px 15px; border-radius: 4px; font-weight: 900; background: var(--neon-green); color: #000; margin-bottom: 15px; font-size: 0.8rem; font-family: 'Orbitron'; }
        .danger .status-pill { background: var(--neon-red); animation: pulse 1s infinite; }
        @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(255, 49, 49, 0.7); } 70% { box-shadow: 0 0 0 10px rgba(255, 49, 49, 0); } 100% { box-shadow: 0 0 0 0 rgba(255, 49, 49, 0); } }

        .legend { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 15px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px; }
        .leg-item { display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: #fff; font-weight: 600; }
        .heat-grad { width: 40px; height: 10px; border-radius: 5px; background: linear-gradient(to right, blue, green, yellow, red); }
        
        .close-btn { position: absolute; top: 25px; right: 25px; z-index: 100; background: #ff3131; border: none; color: #fff; width: 45px; height: 45px; border-radius: 10px; cursor: pointer; pointer-events: auto; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        
        /* Map Customization */
        .leaflet-container { background: #0b0b0f !important; }
    </style>
</head>
<body>
    <div id="map"></div>

    <div class="hud-ui">
        <div class="hud-header">
            <h1>C-SAFETY MAP</h1>
            <p><i class="fas fa-circle" style="font-size: 8px; vertical-align: middle; color: var(--neon-red); animation: blink 1s infinite;"></i> India Live Network Active</p>
        </div>

        <div class="search-container" id="searchBox"></div>

        <div class="safety-stats">
            <div class="stat-box"><div class="stat-val" id="safetyScore">--%</div><div class="stat-label">Zone Safety</div></div>
            <div class="stat-box"><div class="stat-val" id="reportCount">0</div><div class="stat-label">Local Reports</div></div>
        </div>

        <button class="close-btn" onclick="window.history.back()"><i class="fas fa-times"></i></button>

        <div class="control-panel" id="safetyPanel">
            <div class="status-pill" id="statusBadge">ANALYZING...</div>
            <div style="color: #fff; font-size: 1.1rem; font-weight: 700;">Community Risk Heatmap</div>
            <div id="sector-info" style="color: #00d4ff; font-size: 0.75rem; margin-top: 4px; font-weight: 600;">Aggregation of recent reports in this sector.</div>
            
            <div class="legend">
                <div class="leg-item"><div class="heat-grad"></div> Risk Heat</div>
                <div class="leg-item"><span style="width:12px; height:12px; background:var(--neon-green); border-radius:50%; display:inline-block;"></span> Safe Hub</div>
                <div class="leg-item"><span style="width:12px; height:12px; background:var(--neon-red); border-radius:50%; display:inline-block;"></span> Danger Pt</div>
                <div class="leg-item"><span style="width:12px; height:12px; background:#fff; border-radius:50%; display:inline-block;"></span> My Location</div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/Leaflet/Leaflet.heat@gh-pages/dist/leaflet-heat.js"></script>
    <script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>
    <script>
        const map = L.map('map', { attributionControl: false, zoomControl: false }).setView([20.5937, 78.9629], 5);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png').addTo(map);

        const geocoder = L.Control.geocoder({ defaultMarkGeocode: false, placeholder: "Search Area (e.g. Bangalore, Delhi...)" })
            .on('markgeocode', function(e) {
                const center = e.geocode.center;
                map.setView(center, 15);
                updateHeatmap(center.lat, center.lng);
            })
            .addTo(map);

        document.getElementById('searchBox').appendChild(geocoder.getContainer());

        let heatLayer = L.heatLayer([], { radius: 35, blur: 20, maxZoom: 17, gradient: {0.4: 'blue', 0.6: 'cyan', 0.7: 'lime', 0.8: 'yellow', 1: 'red'} }).addTo(map);
        let userMarker = null;

        if (navigator.geolocation) {
            navigator.geolocation.watchPosition(p => {
                const {latitude: lat, longitude: lng} = p.coords;
                if (!userMarker) {
                    map.setView([lat, lng], 15);
                    userMarker = L.circleMarker([lat, lng], { radius: 8, color: '#fff', weight: 3, fillOpacity: 1, fillColor: '#00d4ff' }).addTo(map);
                } else {
                    userMarker.setLatLng([lat, lng]);
                }
                updateHeatmap(lat, lng);
            }, null, {enableHighAccuracy: true});
        }

        async function updateHeatmap(uLat, uLng) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/danger-points');
                const points = await response.json();
                
                const heatData = [];
                let localCount = 0;
                let dangerLevel = 0;

                map.eachLayer(l => { if(l instanceof L.Circle && l !== userMarker) map.removeLayer(l); });

                points.forEach(pt => {
                    const dist = map.distance([uLat, uLng], [pt.lat, pt.lng]);
                    heatData.push([pt.lat, pt.lng, pt.severity / 5]);
                    
                    if (dist < 2000) localCount++;
                    if (dist < 300) dangerLevel = Math.max(dangerLevel, pt.severity);

                    if (pt.severity >= 4) {
                        L.circle([pt.lat, pt.lng], { radius: 40, color: 'var(--neon-red)', fillOpacity: 0.3 }).addTo(map)
                         .bindPopup(`<b>DANGER ZONE</b><br>${pt.category}`);
                    }
                });

                heatLayer.setLatLngs(heatData);
                document.getElementById('reportCount').innerText = localCount;
                document.getElementById('sector-info').innerText = `Aggregation of ${localCount} recent reports in this sector.`;

                let safetyScore = 100 - (dangerLevel * 15);
                if (localCount > 10) safetyScore -= 10;
                safetyScore = Math.max(10, Math.min(100, safetyScore));
                
                document.getElementById('safetyScore').innerText = safetyScore + "%";
                const panel = document.getElementById('safetyPanel');
                const badge = document.getElementById('statusBadge');
                
                if (safetyScore < 70 || dangerLevel >= 4) {
                    panel.classList.add('danger');
                    badge.innerText = "ZONE: UNGUARDED / RISK";
                } else {
                    panel.classList.remove('danger');
                    badge.innerText = "ZONE: SECURE";
                }

            } catch (e) { console.error("Map Update Failed", e); }
        }
    </script>
</body>
</html>

