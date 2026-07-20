<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SOS Emergency Alert</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
    .container { max-width: 400px; margin: auto; background: #f8f8f8; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px gray; }
    .btn { background: red; color: white; border: none; padding: 15px; width: 100%; font-size: 18px; cursor: pointer; }
    .btn:disabled { background: gray; cursor: not-allowed; }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth transition for button hover and state changes */
    .btn {
        transition: transform 0.2s, box-shadow 0.2s, background 0.2s;
    }

    /* 2. Button hover effect (only when enabled) */
    .btn:not(:disabled):hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        filter: brightness(1.05);
    }

    /* 3. Button active (click) effect */
    .btn:not(:disabled):active {
        transform: translateY(1px);
    }

    /* 4. Focus outline for accessibility (keyboard navigation) */
    .btn:focus-visible {
        outline: 3px solid #ffd700;
        outline-offset: 2px;
        border-radius: 6px;
    }

    /* 5. Custom scrollbar (matches theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #f0f0f0;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: #c0c0c0;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #a0a0a0;
    }

    /* 6. Container fade-in animation */
    .container {
        animation: fadeSlideUp 0.4s ease-out forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 7. Responsive improvements for small screens */
    @media (max-width: 480px) {
        body {
            padding: 15px;
        }
        .container {
            padding: 15px;
            max-width: 90%;
        }
        .btn {
            padding: 12px;
            font-size: 16px;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .container.skeleton {
        background: linear-gradient(90deg, #e0e0e0 25%, #d0d0d0 50%, #e0e0e0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
    <script>
        function updateLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.watchPosition((position) => {
                    document.getElementById("latitude").value = position.coords.latitude;
                    document.getElementById("longitude").value = position.coords.longitude;
                }, (error) => {
                    alert("Error getting location: " + error.message);
                });
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        function sendSOS() {
            let formData = new FormData(document.getElementById("sosForm"));
            fetch("/sos/activate", {
                method: "POST",
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                alert("🚨 SOS Activated Successfully!");
                window.location.href = "/sos/list";
            })
            .catch(error => alert("Error activating SOS: " + error));
        }

        window.onload = updateLocation;
    </script>
</head>
<body>
    <div class="container">
        <h2>🚨 SOS Emergency Alert</h2>
        <form id="sosForm">
            <label>Live Location:</label><br>
            <input type="text" id="latitude" name="latitude" readonly required>
            <input type="text" id="longitude" name="longitude" readonly required><br><br>

            <label>SOS Message:</label><br>
            <textarea name="message" rows="3" required>Help! I need immediate assistance.</textarea><br><br>

            <button type="button" class="btn" onclick="sendSOS()">Activate SOS</button>
        </form>
    </div>
</body>
</html>


