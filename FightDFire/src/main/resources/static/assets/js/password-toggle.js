(function () {
  function initPasswordToggles(root) {
    var scope = root || document;
    scope.querySelectorAll("[data-toggle-password]").forEach(function (btn) {
      if (btn.dataset.bound === "1") return;
      btn.dataset.bound = "1";
      btn.addEventListener("click", function () {
        var id = btn.getAttribute("data-toggle-password");
        var input = document.getElementById(id);
        if (!input) return;
        var show = input.type === "password";
        input.type = show ? "text" : "password";
        var icon = btn.querySelector("i");
        if (icon) {
          icon.classList.toggle("bi-eye", !show);
          icon.classList.toggle("bi-eye-slash", show);
        }
        btn.setAttribute("aria-label", show ? "Hide password" : "Show password");
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initPasswordToggles();
  });
  window.initPasswordToggles = initPasswordToggles;
})();
