(function() {
    let lastAlertId = null;

    function checkSosAlerts() {
        fetch('/sos/alerts')
            .then(response => response.json())
            .then(data => {
                if (data.sosActive) {
                    playSiren();
                    // Show a more helpful notification
                    if (confirm("🚨 EMERGENCY SOS! Someone nearby needs help. View details?")) {
                        window.location.href = "/sos/dashboard";
                    }
                }
            })
            .catch(err => console.error("SOS Alert Check failed:", err));
    }

    function playSiren() {
        try {
            let audio = new Audio('/resources/sounds/alarm.mp3'); 
            audio.play();
        } catch(e) {
            console.warn("Could not play alarm sound:", e);
        }
    }

    // Check every 10 seconds
    setInterval(checkSosAlerts, 10000);
})();
