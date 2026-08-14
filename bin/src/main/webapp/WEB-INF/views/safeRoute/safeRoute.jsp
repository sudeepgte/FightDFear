<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Safe Route Suggestions</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function getUserLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        let latitude = position.coords.latitude;
                        let longitude = position.coords.longitude;
                        $("#userLocation").text(`Your Location: ${latitude}, ${longitude}`);

                        $("#origin").val(latitude + "," + longitude);
                    },
                    (error) => alert("Error fetching location: " + error.message)
                );
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        function findSafeRoute() {
            let origin = $("#origin").val();
            let destination = $("#destination").val();

            if (!origin || !destination) {
                alert("Please enter a valid destination.");
                return;
            }

            $.ajax({
                url: "/safe-route/suggest",
                method: "GET",
                data: { origin: origin, destination: destination },
                success: function(response) {
                    $("#routeDetails").html(`
                        <h4>Route Details</h4>
                        <p><strong>Crime Rate:</strong> ${response.crime_rate}</p>
                        <p><strong>Risk Level:</strong> ${response.risk_level}</p>
                        <p><strong>Route:</strong> ${response.route}</p>
                    `);
                },
                error: function() {
                    alert("Failed to fetch the route. Try again.");
                }
            });
        }
    </script>
</head>
<body onload="getUserLocation()">
    <h2>Safe Route Finder</h2>
    <p id="userLocation">Fetching your location...</p>

    <label>Destination:</label>
    <input type="text" id="destination" placeholder="Enter destination address" required />

    <input type="hidden" id="origin" />

    <button onclick="findSafeRoute()">Find Safe Route</button>

    <div id="routeDetails"></div>
</body>
</html>

