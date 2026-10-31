(function () {
  // Purpose: allow this script to work on any deployment context path (/, /app, etc).
  const ctx = (window.__APP_CTX__ || "").replace(/\/$/, "");

  // Purpose: DOM helpers with clear failure modes
  function $(id) {
    return document.getElementById(id);
  }

  const mapEl = $("dangerMap");
  if (!mapEl) return;

  const dpSubmit = $("dpSubmit");
  const dpSeverity = $("dpSeverity");
  const dpCategory = $("dpCategory");
  const dpNote = $("dpNote");
  const dpImage = $("dpImage");
  const dpStatus = $("dpStatus");

  const routeFrom = $("routeFrom");
  const routeTo = $("routeTo");
  const routeMode = $("routeMode"); // Note: OSRM supports driving, walking, cycling
  const routeGo = $("routeGo");
  const routeStatus = $("routeStatus");
  const toggleHeatmap = $("toggleHeatmap");
  const clearRoute = $("clearRoute");

  const defaultCenter = [20.5937, 78.9629]; // India lat, lng

  let map;
  let heatmapLayer;
  let dangerPoints = [];
  let incidents = [];
  let dangerPointMarkers = [];
  let incidentMarkers = [];
  let selectedPointMarker = null;
  let selectedLatLng = null;
  let routeLayer = null;

  function setText(el, msg) {
    if (!el) return;
    el.textContent = msg || "";
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  async function fetchDangerPoints() {
    const res = await fetch(`${ctx}/danger-points`, { headers: { Accept: "application/json" } });
    if (!res.ok) throw new Error(`Failed to load danger points (${res.status})`);
    const data = await res.json();
    dangerPoints = Array.isArray(data) ? data : [];
  }

  async function fetchIncidents() {
    incidents = [];
  }

  function renderHeatmap() {
    if (heatmapLayer) map.removeLayer(heatmapLayer);
    
    // Combine both danger points and incidents for the heatmap
    const heatData = [];
    
    dangerPoints.forEach(p => {
      const sev = Math.max(1, Math.min(5, Number(p.severity) || 1));
      heatData.push([Number(p.lat), Number(p.lng), sev * 0.5]);
    });

    incidents.forEach(i => {
      // Incidents are generally high priority
      heatData.push([Number(i.lat), Number(i.lng), 1.0]); 
    });

    if (window.L && L.heatLayer && heatData.length > 0) {
      heatmapLayer = L.heatLayer(heatData, {
        radius: 28,
        blur: 20,
        maxZoom: 15,
        gradient: { 0.4: 'blue', 0.6: 'lime', 0.8: 'yellow', 1: 'red' }
      }).addTo(map);
    }
  }

  function clearMarkers() {
    for (const m of dangerPointMarkers) map.removeLayer(m);
    dangerPointMarkers = [];
    for (const m of incidentMarkers) map.removeLayer(m);
    incidentMarkers = [];
  }

  function renderMarkers() {
    clearMarkers();
    if (!map) return;

    const TC = { HARASSMENT: '#ef4444', ASSAULT: '#f97316', THEFT: '#3b82f6', OTHER: '#6b7280' };

    // Render Danger Points
    for (const dp of dangerPoints) {
      const pos = [Number(dp.lat), Number(dp.lng)];
      if (Number.isNaN(pos[0]) || Number.isNaN(pos[1])) continue;

      const sev = Math.max(1, Math.min(5, Number(dp.severity) || 1));

      const marker = L.circleMarker(pos, {
        color: '#ffffff',
        weight: 2,
        fillColor: '#e63946',
        fillOpacity: 0.85,
        radius: 6 + sev 
      }).addTo(map);

      const category = (dp.category || "general").toString();
      const createdAt = dp.createdAt ? new Date(dp.createdAt).toLocaleString() : "";
      const locName = dp.locationName || "";
      
      const popupContent = `<div style="min-width:200px">
             <div style="font-weight:700;margin-bottom:6px;color:#e63946;">User Reported Danger Point</div>
             ${locName ? `<div style="margin-bottom:4px;"><b>Location:</b> ${escapeHtml(locName)}</div>` : ""}
             <div><b>Category:</b> ${escapeHtml(category)}</div>
             <div><b>Severity:</b> ${sev}/5</div>
             ${createdAt ? `<div><b>Reported:</b> ${escapeHtml(createdAt)}</div>` : ""}
           </div>`;
           
      marker.bindPopup(popupContent);
      dangerPointMarkers.push(marker);
    }

    // Render Incidents (Admin Heatmap Data)
    for (const inc of incidents) {
        const pos = [Number(inc.lat), Number(inc.lng)];
        if (Number.isNaN(pos[0]) || Number.isNaN(pos[1])) continue;

        const color = TC[inc.type] || '#6b7280';

        const marker = L.circleMarker(pos, {
            color: '#ffffff',
            weight: 2,
            fillColor: color,
            fillOpacity: 0.9,
            radius: 10
        }).addTo(map);

        const type = inc.type || "OTHER";
        const date = inc.reportedAt ? inc.reportedAt.substring(0, 10) : "–";

        const popupContent = `<div style="min-width:220px; font-family: 'Poppins', sans-serif;">
            <div style="font-weight:700; margin-bottom:6px; color:${color}; font-size:1.1rem;">${escapeHtml(type)} INCIDENT</div>
            <hr style="margin:5px 0;">
            <div><b>Location:</b> ${escapeHtml(inc.location || 'Unknown')}</div>
            <div><b>Status:</b> ${escapeHtml(inc.status || 'PENDING')}</div>
            ${inc.description ? `<div style="margin-top:5px; font-size:0.9rem;">${escapeHtml(inc.description)}</div>` : ""}
            <div style="margin-top:5px; color:#666; font-size:0.8rem;">Reported: ${date}</div>
        </div>`;

        marker.bindPopup(popupContent);
        incidentMarkers.push(marker);
    }
  }

  function enableSubmit(enabled) {
    if (!dpSubmit) return;
    dpSubmit.disabled = !enabled;
    dpSubmit.textContent = enabled ? "Submit selected point" : "Click map to select location";
  }

  // Purpose: Reverse Geocoding via Nominatim API
  async function reverseGeocode(lat, lng) {
    try {
      const res = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&zoom=18&addressdetails=1&accept-language=en`);
      if (!res.ok) return null;
      const data = await res.json();
      return data && data.display_name ? data.display_name : null;
    } catch (e) {
      console.error("Reverse geocoding error:", e);
    }
    return null;
  }

  let selectedAddress = null;

  async function onMapClick(e) {
    // Purpose: let user preview exactly where they clicked before submitting
    selectedLatLng = e.latlng; 

    if (selectedPointMarker) map.removeLayer(selectedPointMarker);
    
    // Use a distinctive marker for selection
    selectedPointMarker = L.marker([selectedLatLng.lat, selectedLatLng.lng]).addTo(map);

    enableSubmit(true);
    
    // Show loading state while fetching address
    setText(dpStatus, `Resolving address...`);

    selectedAddress = await reverseGeocode(selectedLatLng.lat, selectedLatLng.lng);
    if (selectedAddress) {
        setText(dpStatus, `Selected Location: ${selectedAddress}`);
    } else {
        setText(dpStatus, `Selected Location: ${selectedLatLng.lat.toFixed(6)}, ${selectedLatLng.lng.toFixed(6)}`);
    }
    
    // Auto-scroll slightly to show the submit button on mobile if needed
    if (window.innerWidth < 768) {
        dpSubmit.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }

  async function submitDangerPoint() {
    if (!selectedLatLng) return;
    if (!dpSeverity || !dpCategory) return;

    enableSubmit(false);
    setText(dpStatus, "Submitting...");

    const body = new FormData();
    body.append("lat", String(selectedLatLng.lat));
    body.append("lng", String(selectedLatLng.lng));
    body.append("severity", String(dpSeverity.value || "3"));
    body.append("category", String(dpCategory.value || "general"));
    if (dpNote && dpNote.value) body.append("note", dpNote.value);
    if (selectedAddress) body.append("locationName", selectedAddress);
    if (dpImage && dpImage.files[0]) body.append("imageFile", dpImage.files[0]);

    const res = await fetch(`${ctx}/danger-points`, {
      method: "POST",
      headers: { Accept: "application/json" },
      body,
    });

    const data = await res.json().catch(() => ({}));

    if (!res.ok) {
      setText(dpStatus, (data && data.message) || `Failed (${res.status})`);
      enableSubmit(true);
      return;
    }

    setText(dpStatus, (data && data.message) || "Saved.");

    // Refresh instantly
    await fetchDangerPoints();
    await fetchIncidents();
    renderHeatmap();
    renderMarkers();

    if (selectedPointMarker) map.removeLayer(selectedPointMarker);
    selectedPointMarker = null;
    selectedLatLng = null;
  }

  // Purpose: Basic Geocoding via free Nominatim API
  async function geocode(address) {
    if (!address || address.length < 2) return null;
    
    // Append India context to improve search accuracy for local cities
    const query = address.toLowerCase().includes("india") ? address : (address + ", India");
    
    try {
        const res = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=1&accept-language=en`);
        if (!res.ok) return null;
        const data = await res.json();
        if (data && data.length > 0) {
          return { lat: Number(data[0].lat), lng: Number(data[0].lon) };
        }
    } catch (e) {
        console.error("Geocoding error:", e);
    }
    return null;
  }

  function haversineMeters(lat1, lon1, lat2, lon2) {
    const R = 6371000; 
    const toRad = deg => deg * Math.PI / 180;
    const dLat = toRad(lat2 - lat1);
    const dLon = toRad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  function scoreRouteGeoJSON(routeCoordinates) {
    // Purpose: Score a GeoJSON line string based on proximity to danger points
    if (!routeCoordinates || !routeCoordinates.length || !dangerPoints.length) return 0;
    
    let score = 0;
    const step = Math.max(1, Math.floor(routeCoordinates.length / 50));
    
    for (let i = 0; i < routeCoordinates.length; i += step) {
      const ptLon = routeCoordinates[i][0];
      const ptLat = routeCoordinates[i][1];

      for (const dp of dangerPoints) {
        const d = haversineMeters(ptLat, ptLon, Number(dp.lat), Number(dp.lng));
        const sev = Math.max(1, Math.min(5, Number(dp.severity) || 1));

        if (d < 500) score += sev * 3;
        else if (d < 1000) score += sev * 1;
      }
    }
    return score;
  }

  function clearCurrentRoute() {
    if (routeLayer) map.removeLayer(routeLayer);
    routeLayer = null;
    setText(routeStatus, "");
  }

  async function findSafestRoute() {
    if (!routeFrom || !routeTo) return;
    const fromStr = (routeFrom.value || "").trim();
    const toStr = (routeTo.value || "").trim();

    if (!fromStr || !toStr) {
      setText(routeStatus, "Please enter both From and To.");
      return;
    }

    setText(routeStatus, "Resolving locations...");
    
    try {
      setText(routeStatus, "Resolving start location...");
      const ptFrom = await geocode(fromStr);
      
      if (!ptFrom) {
        setText(routeStatus, "Could not find start location.");
        return;
      }

      // Nominatim rate limit: small delay between requests
      await new Promise(r => setTimeout(r, 800));
      
      setText(routeStatus, "Resolving destination...");
      const ptTo = await geocode(toStr);
      
      if (!ptTo) {
        setText(routeStatus, "Could not find destination.");
        return;
      }
      
      setText(routeStatus, "Searching safest routes...");
      
      // OSRM handles driving by default, or walking/cycling if configured. Use driving for free pub server.
      let osrmProfile = "driving";
      if (routeMode && routeMode.value === "WALKING") osrmProfile = "foot";
      
      const osrmUrl = `https://router.project-osrm.org/route/v1/${osrmProfile}/${ptFrom.lng},${ptFrom.lat};${ptTo.lng},${ptTo.lat}?overview=full&geometries=geojson&alternatives=true`;
      
      const res = await fetch(osrmUrl);
      const data = await res.json();
      
      if (data.code !== "Ok" || !data.routes || data.routes.length === 0) {
        setText(routeStatus, "No route found.");
        return;
      }

      // Pick safest if alternatives are provided
      let bestRoute = data.routes[0];
      let bestScore = Number.POSITIVE_INFINITY;
      
      for(const route of data.routes) {
        const score = scoreRouteGeoJSON(route.geometry.coordinates);
        if (score < bestScore) {
            bestScore = score;
            bestRoute = route;
        }
      }

      clearCurrentRoute();

      routeLayer = L.geoJSON(bestRoute.geometry, {
        style: { color: '#0a84ff', weight: 5, opacity: 0.8 }
      }).addTo(map);

      // Fit map bounds to the route
      map.fitBounds(routeLayer.getBounds(), { padding: [30, 30] });

      setText(routeStatus, `Route drawn successfully. (Risk score: ${Math.round(bestScore)})`);
    } catch (err) {
       setText(routeStatus, err.message || "Routing failed.");
    }
  }

  async function init() {
    // Purpose: Initialize Leaflet Map
    map = L.map(mapEl).setView(defaultCenter, 5);

    // Free OpenStreetMap Tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Try Geo-location
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition((pos) => {
        map.setView([pos.coords.latitude, pos.coords.longitude], 12);
      }, () => {
        // ignore
      }, { timeout: 5000 });
    }

    if (dpSubmit) {
      map.on("click", onMapClick);
      dpSubmit.addEventListener("click", () => {
        if (dpSubmit.disabled) return;
        submitDangerPoint().catch(err => {
            console.error("Submission error:", err);
            setText(dpStatus, "Error: " + err.message);
            enableSubmit(true);
        });
      });
      enableSubmit(false);
    }

    if (routeGo) {
        routeGo.addEventListener("click", () => findSafestRoute());
    }

    // Bug 123: Add Enter key listener for route search
    [routeFrom, routeTo].forEach(el => {
        if (el) {
            el.addEventListener("keypress", (e) => {
                if (e.key === "Enter") {
                    e.preventDefault();
                    findSafestRoute();
                }
            });
        }
    });

    if (toggleHeatmap) {
      toggleHeatmap.addEventListener("click", () => {
        if (heatmapLayer) {
           if (map.hasLayer(heatmapLayer)) {
               map.removeLayer(heatmapLayer);
           } else {
               map.addLayer(heatmapLayer);
           }
        }
      });
    }
    if (clearRoute) clearRoute.addEventListener("click", clearCurrentRoute);

    try {
      await fetchDangerPoints();
      await fetchIncidents();
      renderHeatmap();
      renderMarkers();
      setText(routeStatus, "Community Map loaded.");
    } catch (err) {
      setText(routeStatus, err.message || "Failed to load map data.");
    }
  }

  // Wait for Leaflet to be fully loaded
  const waitForLeaflet = setInterval(() => {
    if (window.L) {
      clearInterval(waitForLeaflet);
      init().then(() => {
          // Final layout correction to ensure clicks line up with markers
          setTimeout(() => {
              if (map) map.invalidateSize();
          }, 1000);
      }).catch(err => setText(routeStatus, err.message));
    }
  }, 50);

})();
