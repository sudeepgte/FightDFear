(function() {
    let lastAlertId = null;
    let alertActive = false;
    let sirenAudio = null;
    let stompClient = null;
    let playOnInteractionHandler = null;
    let respondedIds = JSON.parse(localStorage.getItem('respondedSosIds') || '[]');

    // Create modal HTML if it doesn't exist
    function createAlertModal() {
        if (document.getElementById('sosAlertModal')) return;

        const modalHtml = `
            <div class="modal fade" id="sosAlertModal" tabindex="-1" aria-labelledby="sosAlertModalLabel" aria-hidden="true" data-bs-backdrop="static">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content" style="border: 4px solid #dc3545; border-radius: 20px; box-shadow: 0 0 30px rgba(220, 53, 69, 0.5);">
                        <div class="modal-header bg-danger text-white py-3">
                            <h5 class="modal-title w-100 text-center fw-bold" id="sosAlertModalLabel">
                                <i class="bi bi-exclamation-triangle-fill"></i> CRITICAL SOS ALERT
                            </h5>
                        </div>
                        <div class="modal-body text-center py-4">
                            <div class="mb-3 animate-pulse">
                                <i class="bi bi-person-pulse" style="font-size: 4rem; color: #dc3545;"></i>
                            </div>
                            <h3 class="fw-bold mb-2">Help Needed Nearby!</h3>
                            <p class="fs-5 text-muted">A user has triggered an emergency SOS within 5km of your location.</p>
                            <div class="alert alert-danger py-2 mt-3 mb-3">
                                <i class="bi bi-info-circle-fill"></i> Please respond immediately if you are able to assist.
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="window.playSiren()">
                                <i class="bi bi-volume-up-fill"></i> Play Sound Again
                            </button>
                        </div>
                        <div class="modal-footer justify-content-center gap-3 py-3 border-0">
                            <button type="button" class="btn btn-success btn-lg px-5 py-3 fw-bold shadow-sm" onclick="event.stopPropagation(); window.respondToSOS('accept')" style="border-radius: 12px;">
                                <i class="bi bi-check-lg"></i> I AM COMING TO HELP
                            </button>
                            <button type="button" class="btn btn-link text-muted fw-bold" onclick="event.stopPropagation(); window.respondToSOS('decline')">
                                DECLINE
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <style>
                @keyframes pulse {
                    0% { transform: scale(1); opacity: 1; }
                    50% { transform: scale(1.1); opacity: 0.8; }
                    100% { transform: scale(1); opacity: 1; }
                }
                .animate-pulse { animation: pulse 1.5s infinite ease-in-out; }
                #sosAlertModal { z-index: 99999 !important; }
            </style>
        `;
        const div = document.createElement('div');
        div.innerHTML = modalHtml;
        document.body.appendChild(div);
    }

    function initWebSocket() {
        if (typeof SockJS === 'undefined' || typeof Stomp === 'undefined') {
            console.warn("SockJS or Stomp not loaded, falling back to polling only.");
            return;
        }

        try {
            const socket = new SockJS(window.__APP_CTX__ + '/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null; 

            stompClient.connect({}, (frame) => {
                console.log('Volunteer Notification WebSocket Connected');
                
                // Subscribe to nearby alerts topic
                stompClient.subscribe('/topic/volunteer-alerts', (message) => {
                    const data = JSON.parse(message.body);
                    if (data.type === 'NEARBY_SOS' && data.sosId !== lastAlertId && !respondedIds.includes(data.sosId)) {
                        lastAlertId = data.sosId;
                        showAlert(data.sosId);
                    }
                });
            }, (error) => {
                console.warn('WebSocket connection error, will continue with polling');
            });
        } catch (e) {
            console.warn('WebSocket init failed');
        }
    }

    function checkSosAlerts() {
        if (alertActive) return;

        fetch(window.__APP_CTX__ + '/sos/alerts')
            .then(response => response.json())
            .then(data => {
                if (data.sosActive && data.sosId !== lastAlertId && !respondedIds.includes(data.sosId)) {
                    lastAlertId = data.sosId;
                    showAlert(data.sosId);
                }
            })
            .catch(err => console.error("SOS Alert Check failed:", err));
    }

    function showAlert(sosId) {
        if (alertActive || respondedIds.includes(sosId)) return;
        
        console.log("Showing alert for SOS ID:", sosId);
        alertActive = true;
        window.currentSosIdForAlert = sosId;
        
        // Ensure modal exists in DOM
        createAlertModal();
        
        // Play siren
        window.playSiren();
        
        // Small delay to ensure DOM is updated and Bootstrap is ready
        setTimeout(() => {
            const modalElement = document.getElementById('sosAlertModal');
            if (!modalElement) {
                console.error("SOS Alert Modal element not found in DOM");
                alertActive = false;
                return;
            }

            // Try to show modal using various methods
            try {
                if (window.bootstrap && window.bootstrap.Modal) {
                    console.log("Using Bootstrap 5 Modal API");
                    const modal = new bootstrap.Modal(modalElement);
                    modal.show();
                } else if (window.jQuery && typeof window.jQuery.fn.modal === 'function') {
                    console.log("Using jQuery/Bootstrap Modal API");
                    window.jQuery(modalElement).modal('show');
                } else {
                    // If no bootstrap found, use a fallback notification
                    console.warn("No Bootstrap modal system found, using fallback");
                    showFallbackNotice();
                }
            } catch (e) {
                console.error("Error showing SOS modal:", e);
                showFallbackNotice();
            }
        }, 500);
    }

    function showFallbackNotice() {
        const existing = document.getElementById('sos-fallback-notice');
        if (existing) return;

        const fallbackDiv = document.createElement('div');
        fallbackDiv.id = "sos-fallback-notice";
        fallbackDiv.style.cssText = "position:fixed; top:20px; left:50%; transform:translateX(-50%); z-index:99999; background:#dc3545; color:white; padding:20px; border-radius:10px; box-shadow:0 10px 30px rgba(0,0,0,0.5); text-align:center; width:90%; max-width:400px; border:3px solid white;";
        fallbackDiv.innerHTML = `
            <h3 style="margin-bottom:10px; font-weight:bold;">🚨 EMERGENCY SOS ALERT</h3>
            <p style="margin-bottom:15px; font-size:1.1rem;">Someone nearby needs immediate help!</p>
            <div style="display:flex; gap:10px; justify-content:center;">
                <button onclick="respondToSOS('accept')" style="background:#198754; color:white; border:none; padding:12px 24px; border-radius:8px; font-weight:bold; cursor:pointer; font-size:1rem;">I AM COMING TO HELP</button>
                <button onclick="respondToSOS('decline')" style="background:rgba(255,255,255,0.2); color:white; border:none; padding:12px 24px; border-radius:8px; cursor:pointer; font-size:1rem;">DECLINE</button>
            </div>
        `;
        document.body.appendChild(fallbackDiv);
    }

    window.respondToSOS = function(action) {
        console.log("Responding to SOS with action:", action);
        const sosId = window.currentSosIdForAlert;
        
        // Stop siren first
        stopSiren();

        // Remove fallback if exists
        const fallback = document.getElementById('sos-fallback-notice');
        if (fallback) fallback.remove();

        if (!sosId) return;

        const formData = new URLSearchParams();
        formData.append('sosId', sosId);
        formData.append('action', action);

        fetch(window.__APP_CTX__ + '/sos/volunteer/respond', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(response => response.json())
        .then(data => {
            console.log("Response recorded:", data);
            // Save to responded IDs so we don't show it again
            respondedIds.push(sosId);
            if (respondedIds.length > 50) respondedIds.shift(); // Keep only last 50
            localStorage.setItem('respondedSosIds', JSON.stringify(respondedIds));

            const modalElement = document.getElementById('sosAlertModal');
            if (modalElement) {
                if (window.bootstrap && window.bootstrap.Modal) {
                    const modalInstance = bootstrap.Modal.getInstance(modalElement);
                    if (modalInstance) modalInstance.hide();
                } else if (window.jQuery && typeof window.jQuery.fn.modal === 'function') {
                    window.jQuery(modalElement).modal('hide');
                }
            }
            
            if (action === 'accept') {
                window.location.href = window.__APP_CTX__ + "/sos/help-dashboard?sosId=" + sosId;
            } else {
                alertActive = false;
            }
        })
        .catch(err => {
            console.error("Response failed:", err);
            alertActive = false;
        });
    };

    window.playSiren = function() {
        console.log("Attempting to play siren...");
        try {
            if (!sirenAudio) {
                // Primary: Local siren.mp3. Backup: Public siren sound
                sirenAudio = new Audio(window.__APP_CTX__ + '/siren.mp3');
                sirenAudio.loop = true;
                
                // Monitor for accidental plays
                sirenAudio.onplay = function() {
                    if (!alertActive) {
                        console.log("Blocking accidental siren play");
                        sirenAudio.pause();
                        sirenAudio.currentTime = 0;
                    }
                };

                // Add an error handler to switch to backup if local fails
                sirenAudio.onerror = function() {
                    console.warn("Local siren.mp3 not found or blocked, using public siren fallback");
                    sirenAudio.src = "https://actions.google.com/sounds/v1/emergency/ambulance_siren_distant.ogg"; 
                    if (alertActive) sirenAudio.play().catch(e => console.error("Fallback also failed", e));
                };
            }
            sirenAudio.currentTime = 0;
            const playPromise = sirenAudio.play();
            
            if (playPromise !== undefined) {
                playPromise.then(() => {
                    console.log("Siren playing successfully");
                }).catch(error => {
                    console.warn("Audio play blocked. Setting up click-to-play fallback.");
                    
                    // Remove existing handler if any
                    if (playOnInteractionHandler) {
                        document.removeEventListener('click', playOnInteractionHandler);
                        document.removeEventListener('keydown', playOnInteractionHandler);
                    }

                    playOnInteractionHandler = () => {
                        if (alertActive && sirenAudio) {
                            sirenAudio.play().catch(e => console.warn("Still blocked"));
                        }
                        document.removeEventListener('click', playOnInteractionHandler);
                        document.removeEventListener('keydown', playOnInteractionHandler);
                        playOnInteractionHandler = null;
                    };
                    document.addEventListener('click', playOnInteractionHandler);
                    document.addEventListener('keydown', playOnInteractionHandler);
                });
            }
        } catch(e) {
            console.warn("Could not play alarm sound:", e);
        }
    };

    function stopSiren() {
        console.log("Stopping siren...");
        alertActive = false; // Mark as inactive immediately
        
        if (playOnInteractionHandler) {
            document.removeEventListener('click', playOnInteractionHandler);
            document.removeEventListener('keydown', playOnInteractionHandler);
            playOnInteractionHandler = null;
        }

        if (sirenAudio) {
            sirenAudio.pause();
            sirenAudio.currentTime = 0;
            // Force volume to 0 as a secondary precaution
            sirenAudio.volume = 0;
            // Completely remove the source to ensure it stops
            const oldSrc = sirenAudio.src;
            sirenAudio.src = "";
            sirenAudio.load();
            // Restore src for next time if needed
            setTimeout(() => { 
                if (sirenAudio) {
                    sirenAudio.src = oldSrc;
                    sirenAudio.volume = 1;
                }
            }, 500);
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

    function initialize() {
        createAlertModal();
        initWebSocket();
        
        // Check every 10 seconds (backup to WebSocket)
        setInterval(checkSosAlerts, 10000);
        // Initial check after a short delay
        setTimeout(checkSosAlerts, 2000);
    }
})();