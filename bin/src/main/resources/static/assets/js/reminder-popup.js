/* global window */

(function () {
  const ctx = (window.__APP_CTX__ || "").replace(/\/$/, "");

  // Purpose: run only on pages that already define __APP_CTX__ (dashboards).
  if (!ctx) return;

  async function fetchTriggered() {
    const res = await fetch(`${ctx}/reminders/triggered`, { headers: { Accept: "application/json" } });
    if (!res.ok) return null;
    return await res.json().catch(() => null);
  }

  async function markShown(id) {
    const body = new URLSearchParams();
    body.set("id", String(id));
    await fetch(`${ctx}/reminders/shown`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded", Accept: "application/json" },
      body,
    }).catch(() => {});
  }

  function showModal(title, message) {
    // Purpose: lightweight in-app reminder (no external dependencies).
    const wrap = document.createElement("div");
    wrap.style.position = "fixed";
    wrap.style.inset = "0";
    wrap.style.background = "rgba(0,0,0,0.45)";
    wrap.style.zIndex = "9999";
    wrap.style.display = "flex";
    wrap.style.alignItems = "center";
    wrap.style.justifyContent = "center";
    wrap.innerHTML = `
      <div style="background:#fff; border-radius:16px; padding:16px; max-width:520px; width:92%; box-shadow:0 18px 40px rgba(0,0,0,0.25);">
        <div style="font-weight:800; font-size:18px; margin-bottom:6px;">${escapeHtml(title)}</div>
        <div style="color:#374151; margin-bottom:14px;">${escapeHtml(message)}</div>
        <div style="display:flex; gap:10px; justify-content:flex-end;">
          <button id="rpClose" style="border:1px solid #d1d5db; background:#fff; padding:8px 12px; border-radius:10px; font-weight:700;">Close</button>
        </div>
      </div>
    `;
    document.body.appendChild(wrap);
    wrap.querySelector("#rpClose")?.addEventListener("click", () => wrap.remove());
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  async function run() {
    const data = await fetchTriggered();
    const list = data && data.reminders;
    if (!data || !data.ok || !Array.isArray(list) || list.length === 0) return;

    // Purpose: show only one reminder popup at a time.
    const r = list[0];
    showModal(r.title || "Safety reminder", r.message || "");
    if (r.id) markShown(r.id);
  }

  // Purpose: check periodically so reminders appear even if the dashboard is already open.
  setInterval(run, 60000);
  setTimeout(run, 1500);
})();

