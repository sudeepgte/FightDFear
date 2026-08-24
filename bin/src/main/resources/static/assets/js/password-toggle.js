(function () {
  function setVisible(btn, show) {
    var id = btn.getAttribute("data-toggle-password");
    var input = document.getElementById(id);
    if (!input) return;

    input.type = show ? "text" : "password";
    btn.classList.toggle("is-visible", show);
    btn.setAttribute("aria-pressed", show ? "true" : "false");
    btn.setAttribute("aria-label", show ? "Hide password" : "Show password");

    var icon = btn.querySelector("i");
    if (icon) {
      // Visible password -> eye-slash (click to hide); hidden -> eye (click to show)
      icon.className = show ? "bi bi-eye-slash" : "bi bi-eye";
    }
  }

  function initPasswordToggles(root) {
    var scope = root || document;
    scope.querySelectorAll(".password-toggle-btn[data-toggle-password]").forEach(function (btn) {
      if (btn.dataset.bound === "1") return;
      btn.dataset.bound = "1";
      btn.addEventListener("mousedown", function (e) {
        e.preventDefault();
      });
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        var id = btn.getAttribute("data-toggle-password");
        var input = document.getElementById(id);
        if (!input) return;
        setVisible(btn, input.type === "password");
        input.focus();
      });
    });
  }

  function boot() {
    initPasswordToggles();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
  window.initPasswordToggles = initPasswordToggles;
})();
