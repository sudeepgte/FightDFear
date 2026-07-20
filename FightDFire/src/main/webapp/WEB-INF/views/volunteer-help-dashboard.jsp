<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Help Dashboard | Women Safety</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Leaflet Map -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <style>
    :root {
        --pp: #1e1b4b;
        --pp-light: #312e81;
        --coral: #f43f5e;
        --bg-primary: #150510;
        --bg-secondary: #210a1b;
        --text-primary: #ffffff;
        --text-secondary: rgba(255, 255, 255, 0.7);
        --accent-red: #f43f5e;
        --accent-green: #30d158;
        --border-subtle: rgba(255, 255, 255, 0.15);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Inter', sans-serif;
        background: var(--bg-primary);
        color: var(--text-primary);
        min-height: 100vh;
    }

    .top-nav {
        padding: 16px 24px;
        background: linear-gradient(to right, var(--pp), #4a0e2a);
        border-bottom: 2px solid var(--coral);
        display: flex; justify-content: space-between; align-items: center;
    }

    .container {
        max-width: 900px;
        margin: 20px auto;
        padding: 0 20px;
    }

    .help-card {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--border-subtle);
        border-radius: 20px;
        padding: 25px;
        margin-bottom: 20px;
        backdrop-filter: blur(10px);
    }

    .victim-info {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 20px;
    }

    .victim-avatar {
        width: 60px; height: 60px;
        background: var(--coral);
        border-radius: 50%;
        display: flex; justify-content: center; align-items: center;
        font-size: 24px; font-weight: 700;
    }

    .victim-details h2 { font-size: 20px; margin-bottom: 4px; }
    .victim-details p { color: var(--text-secondary); font-size: 14px; }

    #helpMap {
        width: 100%;
        height: 400px;
        border-radius: 15px;
        border: 1px solid var(--border-subtle);
        margin-bottom: 20px;
    }

    .action-buttons {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
    }

    .btn {
        padding: 15px;
        border-radius: 12px;
        border: none;
        font-weight: 700;
        cursor: pointer;
        display: flex; justify-content: center; align-items: center;
        gap: 10px;
        text-decoration: none;
        font-size: 15px;
        transition: transform 0.2s;
    }

    .btn:active { transform: scale(0.98); }

    .btn-call { background: var(--accent-green); color: white; }
    .btn-maps { background: #4285F4; color: white; }
    .btn-back { background: rgba(255,255,255,0.1); color: white; grid-column: span 2; }

    .emergency-badge {
        background: rgba(220, 53, 69, 0.2);
        color: #ff4d4d;
        padding: 6px 12px;
        border-radius: 50px;
        font-size: 12px;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 15px;
    }
    </style>
</head>
<body>

    <div class="top-nav">
        <div style="font-weight: 800; font-size: 1.2rem;">
            <i class="bi bi-shield-fill-exclamation text-danger"></i> Help Dashboard
        </div>
        <a href="${pageContext.request.contextPath}/users/dashboard" style="color: white; text-decoration: none; font-size: 0.9rem;">
            <i class="bi bi-x-lg"></i>
        </a>
    </div>

    <div class="container">
        <div class="help-card">
            <div class="emergency-badge">
                <i class="bi bi-broadcast"></i> ACTIVE EMERGENCY SOS
            </div>
            
            <div class="victim-info">
                <div class="victim-avatar">
                    ${sos.victimName.substring(0,1)}
                </div>
                <div class="victim-details">
                    <h2>${sos.victimName}</h2>
                    <p><i class="bi bi-telephone-fill"></i> ${sos.victimPhone}</p>
                    <p><i class="bi bi-clock-history"></i> Triggered: ${sos.activatedAt}</p>
                </div>
            </div>

            <div id="helpMap"></div>

            <c:if test="${not empty sos.audioPath}">
                <div style="margin-bottom: 20px; background: rgba(220, 53, 69, 0.1); padding: 15px; border-radius: 12px; border: 1px solid rgba(220, 53, 69, 0.3);">
                    <h4 style="font-size: 16px; margin-bottom: 10px; color: #ff4d4d;">
                        <i class="bi bi-mic-fill"></i> Emergency Audio Evidence
                    </h4>
                    <audio src="${pageContext.request.contextPath}${sos.audioPath}" controls style="width: 100%;"></audio>
                </div>
            </c:if>

            <div class="action-buttons">
                <a href="tel:${sos.victimPhone}" class="btn btn-call">
                    <i class="bi bi-telephone-outbound-fill"></i> CALL VICTIM
                </a>
                <a href="https://www.google.com/maps?q=${sos.latitude},${sos.longitude}" target="_blank" class="btn btn-maps">
                    <i class="bi bi-geo-alt-fill"></i> OPEN IN GOOGLE MAPS
                </a>
                <a href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-back">
                    I HAVE REACHED / FINISHED HELPING
                </a>
            </div>
        </div>
    </div>

    <script>
        const victimLat = ${sos.latitude};
        const victimLng = ${sos.longitude};
        const victimName = "${sos.victimName}";

        // Initialize Map
        const map = L.map('helpMap').setView([victimLat, victimLng], 15);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap'
        }).addTo(map);

        // Add Victim Marker
        const victimIcon = L.divIcon({
            className: 'custom-div-icon',
            html: `<div style="background-color:#f43f5e; width:20px; height:20px; border-radius:50%; border:3px solid white; box-shadow:0 0 10px rgba(0,0,0,0.5);"></div>`,
            iconSize: [20, 20],
            iconAnchor: [10, 10]
        });

        L.marker([victimLat, victimLng], {icon: victimIcon})
            .addTo(map)
            .bindPopup(`<b>${sos.victimName} is here!</b>`)
            .openPopup();
            
        // Add a pulsing circle around the victim
        L.circle([victimLat, victimLng], {
            color: '#f43f5e',
            fillColor: '#f43f5e',
            fillOpacity: 0.2,
            radius: 100
        }).addTo(map);
    </script>
</body>
</html>