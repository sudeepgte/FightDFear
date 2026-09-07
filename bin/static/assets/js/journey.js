/* global window */

(function () {
  const ctx = (window.__APP_CTX__ || "").replace(/\/$/, "");

  function $(id) {
    return document.getElementById(id);
  }

  const fromEl = $("journeyFrom");
  const destEl = $("journeyDestination");
  const expectedEl = $("journeyExpected");
  const startBtn = $("journeyStart");
  const safeBtn = $("journeySafe");
  const cancelBtn = $("journeyCancel");
  const statusEl = $("journeyStatus");
  const activeBox = $("activeBox");

  function setStatus(msg) {
    if (statusEl) statusEl.textContent = msg || "";
  }

  function fmt(ms) {
    const d = new Date(ms);
    return d.toLocaleString();
  }

  function getLocation() {
    // Purpose: capture start location (optional) for emergency contact context.
    return new Promise((resolve) => {
      if (!navigator.geolocation) return resolve(null);
      navigator.geolocation.getCurrentPosition(
        (pos) => resolve({ lat: pos.coords.latitude, lng: pos.coords.longitude }),
        () => resolve(null),
        { enableHighAccuracy: true, timeout: 6000 }
      );
    });
  }

  async function refreshActive() {
    if (!activeBox) return;
    try {
      const res = await fetch(`${ctx}/journey/active`, { headers: { Accept: "application/json" } });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        activeBox.textContent = (data && data.message) || `Failed (${res.status})`;
        return;
      }

      if (!data.active) {
        activeBox.innerHTML = `<div class="text-muted">No active timer.</div>`;
        return;
      }

      const expected = data.expectedArrivalAt ? new Date(data.expectedArrivalAt).getTime() : null;
      const now = Date.now();
      const deltaMs = expected ? expected - now : null;

      let countdown = "";
      if (deltaMs != null) {
        const abs = Math.abs(deltaMs);
        const min = Math.floor(abs / 60000);
        const sec = Math.floor((abs % 60000) / 1000);
        countdown = deltaMs >= 0 ? `${min}m ${sec}s remaining` : `${min}m ${sec}s overdue`;
      }

      activeBox.innerHTML = `
        <div><b>Start from:</b> ${escapeHtml(data.startFromText || "-")}</div>
        <div><b>Destination:</b> ${escapeHtml(data.destinationText || "-")}</div>
        <div><b>Expected arrival:</b> ${expected ? escapeHtml(fmt(expected)) : "-"}</div>
        <div><b>Status:</b> ${escapeHtml(data.status || "-")}</div>
        <div class="mt-2"><b>Timer:</b> ${escapeHtml(countdown || "-")}</div>
      `;
    } catch (e) {
      activeBox.textContent = e.message || "Failed to load.";
    }
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  async function start() {
    const from = (fromEl?.value || "").trim();
    if (!from) return setStatus("Please enter where you are starting from.");

    const dest = (destEl?.value || "").trim();
    if (!dest) return setStatus("Please enter a destination.");

    const dt = expectedEl?.value;
    if (!dt) return setStatus("Please choose expected arrival time.");

    const epoch = new Date(dt).getTime();
    if (Number.isNaN(epoch)) return setStatus("Invalid expected arrival time.");

    setStatus("Starting timer…");
    const loc = await getLocation();

    const body = new URLSearchParams();
    body.set("startFrom", from);
    body.set("destination", dest);
    body.set("expectedArrivalEpochMs", String(epoch));
    if (loc) {
      body.set("latitude", String(loc.lat));
      body.set("longitude", String(loc.lng));
    }

    const res = await fetch(`${ctx}/journey/start`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded", Accept: "application/json" },
      body,
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) return setStatus((data && data.message) || `Failed (${res.status})`);

    setStatus((data && data.message) || "Started.");
    await refreshActive();
  }

  async function safe() {
    setStatus("Checking in…");
    const res = await fetch(`${ctx}/journey/safe`, { method: "POST", headers: { Accept: "application/json" } });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) return setStatus((data && data.message) || `Failed (${res.status})`);
    setStatus((data && data.message) || "Marked safe.");
    await refreshActive();
  }

  async function cancel() {
    setStatus("Cancelling…");
    const res = await fetch(`${ctx}/journey/cancel`, { method: "POST", headers: { Accept: "application/json" } });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) return setStatus((data && data.message) || `Failed (${res.status})`);
    setStatus((data && data.message) || "Cancelled.");
    await refreshActive();
  }

  startBtn?.addEventListener("click", start);
  safeBtn?.addEventListener("click", safe);
  cancelBtn?.addEventListener("click", cancel);

  refreshActive();
  // Purpose: keep countdown fresh; backend alerts are handled by scheduler.
  setInterval(refreshActive, 5000);
})();

