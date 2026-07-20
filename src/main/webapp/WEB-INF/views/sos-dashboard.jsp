<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SOS Emergency Alert | Women Safety</title>
    <meta name="description" content="Emergency SOS alert system - One tap to alert contacts, volunteers, and emergency services">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- SockJS + STOMP for WebSocket -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --pp: #1e1b4b;
        --pp-light: #312e81;
        --coral: #f43f5e;
        --gold: #ffd700;
        --bg-primary: #1e1b4b;
        --bg-secondary: #0f0d26;
        --bg-card: rgba(255, 255, 255, 0.03);
        --bg-glass: rgba(255, 255, 255, 0.05);
        --text-primary: #ffffff;
        --text-secondary: rgba(255, 255, 255, 0.7);
        --accent-red: #f43f5e;
        --accent-red-glow: rgba(244, 63, 94, 0.4);
        --accent-green: #30d158;
        --accent-orange: #f1c232;
        --accent-blue: #00bcd4;
        --accent-purple: #312e81;
        --border-subtle: rgba(255, 255, 255, 0.1);
        --shadow-heavy: 0 25px 50px rgba(0, 0, 0, 0.4);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Inter', -apple-system, sans-serif;
        background: var(--bg-primary);
        color: var(--text-primary);
        min-height: 100vh;
        overflow-x: hidden;
    }

    /* === Animated Background === */
    .bg-grid {
        position: fixed; top: 0; left: 0; right: 0; bottom: 0;
        background-color: var(--bg-primary);
        background-image: 
            linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px),
            radial-gradient(circle at 20% 50%, rgba(49, 46, 129, 0.6) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(244, 63, 94, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 50% 80%, rgba(49, 46, 129, 0.4) 0%, transparent 50%);
        background-size: 30px 30px, 30px 30px, cover, cover, cover;
        z-index: 0;
    }

    .bg-grid::after {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        background: radial-gradient(circle at center, transparent 30%, var(--bg-primary) 100%);
        pointer-events: none;
    }

    .bg-grid.sos-active {
        animation: emergencyPulse 1.5s ease-in-out infinite;
    }

    @keyframes emergencyPulse {
        0%, 100% { background-image:
            radial-gradient(circle at 20% 50%, rgba(244, 63, 94, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(244, 63, 94, 0.1) 0%, transparent 50%),
            radial-gradient(circle at 50% 80%, rgba(244, 63, 94, 0.08) 0%, transparent 50%); }
        50% { background-image:
            radial-gradient(circle at 20% 50%, rgba(244, 63, 94, 0.35) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(244, 63, 94, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 50% 80%, rgba(244, 63, 94, 0.2) 0%, transparent 50%); }
    }

    /* === Top Navigation === */
    .top-nav {
        position: fixed; top: 0; left: 0; right: 0;
        padding: 16px 24px;
        display: flex; justify-content: space-between; align-items: center;
        background: rgba(30, 27, 75, 0.8);
        backdrop-filter: blur(20px);
        border-bottom: 2px solid var(--coral);
        z-index: 100;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    }

    .top-nav .brand {
        font-weight: 700; font-size: 18px;
        display: flex; align-items: center; gap: 8px;
    }

    .top-nav .brand i { color: var(--accent-red); }
    .top-nav .back-btn {
        color: var(--text-secondary);
        text-decoration: none; font-size: 14px;
        display: flex; align-items: center; gap: 6px;
        transition: color 0.2s;
    }
    .top-nav .back-btn:hover { color: var(--text-primary); }

    /* === Main Container === */
    .sos-container {
        position: relative; z-index: 1;
        max-width: 480px; margin: 0 auto;
        padding: 80px 20px 40px;
        min-height: 100vh;
        display: flex; flex-direction: column; align-items: center;
    }

    /* === Status Bar HUD === */
    .status-bar {
        width: 100%; padding: 14px 20px;
        background: rgba(15, 13, 38, 0.7);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(244, 63, 94, 0.4);
        border-radius: 8px;
        display: flex; align-items: center; gap: 12px;
        margin-bottom: 30px;
        font-family: 'Courier New', Courier, monospace;
        font-size: 13px; color: #a5b4fc;
        text-transform: uppercase;
        letter-spacing: 1px;
        box-shadow: inset 0 0 15px rgba(244, 63, 94, 0.15), 0 5px 15px rgba(0,0,0,0.4);
        position: relative;
        overflow: hidden;
    }
    .status-bar::before {
        content: ''; position: absolute; top: 0; left: -100%; width: 50%; height: 2px;
        background: linear-gradient(90deg, transparent, var(--accent-red));
        animation: scanline 3s linear infinite;
    }
    @keyframes scanline { 100% { left: 200%; } }
    .status-bar .dot {
        width: 8px; height: 8px; border-radius: 50%;
        background: var(--accent-green);
        animation: blink 2s infinite;
    }
    .status-bar.danger .dot { background: var(--accent-red); }
    @keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }

    /* Premium Tactical Box for SOS */
    .sos-outer-box {
        background: rgba(15, 13, 38, 0.4);
        border: 1px solid rgba(244, 63, 94, 0.2);
        backdrop-filter: blur(20px);
        border-radius: 30px;
        padding: 50px 40px;
        margin: 20px 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        box-shadow: 0 0 40px rgba(0,0,0,0.5), inset 0 0 20px rgba(244, 63, 94, 0.05);
        position: relative;
    }

    .sos-btn-wrapper {
        position: relative;
        width: 280px; height: 280px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .sos-btn-ring {
        position: absolute;
        border-radius: 50%;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        pointer-events: none;
    }
    
    .ring-1 {
        width: 220px; height: 220px;
        border: 2px dashed rgba(244, 63, 94, 0.5);
        animation: spinRight 10s linear infinite;
    }
    .ring-2 {
        width: 260px; height: 260px;
        border: 1px solid rgba(244, 63, 94, 0.2);
        animation: pulseRing 2s ease-out infinite;
    }
    .ring-3 {
        width: 300px; height: 300px;
        border: 2px dotted rgba(244, 63, 94, 0.3);
        animation: spinLeft 15s linear infinite;
    }

    @keyframes spinRight { 100% { transform: translate(-50%, -50%) rotate(360deg); } }
    @keyframes spinLeft { 100% { transform: translate(-50%, -50%) rotate(-360deg); } }
    @keyframes pulseRing {
        0% { width: 180px; height: 180px; opacity: 1; }
        100% { width: 350px; height: 350px; opacity: 0; }
    }

    .sos-btn {
        width: 170px; height: 170px;
        border-radius: 50%;
        border: 4px solid #fff;
        background: radial-gradient(circle at center, #fb7185, #be123c);
        color: white;
        font-family: 'Inter', sans-serif;
        font-size: 48px;
        font-weight: 900;
        letter-spacing: 2px;
        cursor: pointer;
        box-shadow: 0 0 30px rgba(244, 63, 94, 0.6), inset 0 0 20px rgba(0,0,0,0.3);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        z-index: 10;
    }

    .sos-btn:hover {
        transform: scale(1.05);
        background: radial-gradient(circle at center, #f43f5e, #9f1239);
        box-shadow: 0 0 60px rgba(244, 63, 94, 0.8);
    }

    .sos-btn-label {
        text-align: center;
        font-size: 14px;
        font-weight: 500;
        color: var(--text-secondary);
        margin-top: 25px;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    /* === Countdown Overlay === */
    .countdown-overlay {
        display: none;
        position: fixed; inset: 0;
        background: rgba(10, 10, 15, 0.95);
        backdrop-filter: blur(30px);
        z-index: 200;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    .countdown-overlay.active { display: flex; }

    .countdown-number {
        font-size: 120px;
        font-weight: 900;
        color: var(--accent-red);
        text-shadow: 0 0 60px var(--accent-red-glow);
        line-height: 1;
        animation: countdownPop 1s ease-in-out infinite;
    }

    @keyframes countdownPop {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.08); }
    }

    .countdown-text {
        font-size: 16px;
        color: var(--text-secondary);
        margin-top: 20px;
        text-align: center;
        max-width: 300px;
    }

    .countdown-cancel-btn {
        margin-top: 40px;
        padding: 14px 40px;
        border-radius: 50px;
        border: 2px solid rgba(255, 255, 255, 0.2);
        background: transparent;
        color: white;
        font-family: 'Inter', sans-serif;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }

    .countdown-cancel-btn:hover {
        background: rgba(255, 255, 255, 0.1);
        border-color: rgba(255, 255, 255, 0.4);
    }

    /* === Alert Progress === */
    .alert-progress {
        width: 100%;
        display: none;
    }

    .alert-progress.active { display: block; }

    .progress-step {
        display: flex; align-items: center; gap: 14px;
        padding: 14px 16px;
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        margin-bottom: 12px;
        font-size: 14px;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .progress-step.active {
        border-color: rgba(255, 45, 85, 0.3);
        background: rgba(255, 45, 85, 0.08);
    }

    .progress-step.done {
        border-color: rgba(48, 209, 88, 0.3);
        background: rgba(48, 209, 88, 0.08);
    }

    .progress-step .step-icon {
        width: 32px; height: 32px;
        border-radius: 50%;
        display: flex; justify-content: center; align-items: center;
        font-size: 14px;
        flex-shrink: 0;
    }

    .progress-step .step-icon.pending { background: var(--bg-card); color: var(--text-secondary); }
    .progress-step.active .step-icon { background: rgba(255, 45, 85, 0.2); color: var(--accent-red); }
    .progress-step.done .step-icon { background: rgba(48, 209, 88, 0.2); color: var(--accent-green); }

    .progress-step .step-info { flex: 1; }
    .progress-step .step-title { font-weight: 600; font-size: 13px; }
    .progress-step .step-desc { font-size: 11px; color: var(--text-secondary); margin-top: 2px; }

    .spinner {
        width: 16px; height: 16px;
        border: 2px solid transparent;
        border-top-color: var(--accent-red);
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* === Quick Actions === */
    .quick-actions {
        width: 100%;
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        margin-top: 20px;
    }

    .quick-action-btn {
        padding: 18px 14px;
        border-radius: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(12px);
        color: var(--text-primary);
        font-family: 'Inter', sans-serif;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 6px;
        text-decoration: none;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    }

    .quick-action-btn:hover {
        background: rgba(255, 255, 255, 0.08);
        border-color: rgba(244, 63, 94, 0.4);
        transform: translateY(-5px);
        color: var(--text-primary);
        box-shadow: 0 12px 25px rgba(244, 63, 94, 0.2);
    }

    .quick-action-btn i {
        font-size: 20px;
    }

    .quick-action-btn.police i { color: var(--accent-blue); }
    .quick-action-btn.ambulance i { color: var(--accent-green); }
    .quick-action-btn.contacts i { color: var(--accent-purple); }
    .quick-action-btn.location i { color: var(--accent-orange); }

    /* === Info Section === */
    .info-card {
        width: 100%;
        padding: 18px;
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        margin-top: 20px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .info-card h4 {
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 8px;
        display: flex; align-items: center; gap: 8px;
    }

    .info-card p {
        font-size: 12px;
        color: var(--text-secondary);
        line-height: 1.6;
    }

    /* === Responded Banner === */
    .responded-banner {
        display: none;
        width: 100%;
        padding: 16px;
        background: rgba(48, 209, 88, 0.1);
        border: 1px solid rgba(48, 209, 88, 0.3);
        border-radius: 12px;
        margin-top: 16px;
        text-align: center;
    }

    .responded-banner.active { display: block; }
    .responded-banner.h4 { color: var(--accent-green); font-size: 15px; margin-bottom: 4px; }
    .responded-banner p { font-size: 12px; color: var(--text-secondary); }

    /* === Toast Notification === */
    .toast-notification {
        position: fixed;
        top: 80px; left: 50%; transform: translateX(-50%);
        padding: 12px 24px;
        background: rgba(48, 209, 88, 0.15);
        border: 1px solid rgba(48, 209, 88, 0.3);
        border-radius: 12px;
        color: var(--accent-green);
        font-size: 13px; font-weight: 500;
        z-index: 300;
        display: none;
        backdrop-filter: blur(20px);
    }

    .toast-notification.error {
        background: rgba(255, 45, 85, 0.15);
        border-color: rgba(255, 45, 85, 0.3);
        color: var(--accent-red);
    }

    .toast-notification.show {
        display: block;
        animation: slideDown 0.3s ease, fadeOut 0.3s ease 2.5s forwards;
    }

    @keyframes slideDown { from { opacity: 0; transform: translateX(-50%) translateY(-20px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } }
    @keyframes fadeOut { to { opacity: 0; } }

    /* === Contact Response Panel === */
    .contact-response-panel {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 20px;
        padding: 20px;
        margin-top: 20px;
        backdrop-filter: blur(20px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }

    .response-summary {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 10px;
        margin-bottom: 20px;
    }

    .summary-card {
        padding: 15px;
        border-radius: 16px;
        text-align: center;
        border: 1px solid rgba(255, 255, 255, 0.05);
        background: rgba(255, 255, 255, 0.02);
        backdrop-filter: blur(10px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .summary-card.accepted {
        background: rgba(48, 209, 88, 0.1);
        border-color: rgba(48, 209, 88, 0.3);
    }

    .summary-card.pending {
        background: rgba(255, 159, 10, 0.1);
        border-color: rgba(255, 159, 10, 0.3);
    }

    .summary-card.rejected {
        background: rgba(255, 45, 85, 0.1);
        border-color: rgba(255, 45, 85, 0.3);
    }

    .summary-number {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 5px;
    }

    .summary-card.accepted .summary-number { color: var(--accent-green); }
    .summary-card.pending .summary-number { color: var(--accent-orange); }
    .summary-card.rejected .summary-number { color: var(--accent-red); }

    .summary-label {
        font-size: 12px;
        color: var(--text-secondary);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 4px;
    }

    .contact-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .contact-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px;
        background: var(--bg-glass);
        border-radius: 10px;
        border: 1px solid var(--border-subtle);
        transition: all 0.3s ease;
    }

    .contact-item.accepted {
        background: rgba(48, 209, 88, 0.08);
        border-color: rgba(48, 209, 88, 0.2);
    }

    .contact-item.rejected {
        background: rgba(255, 45, 85, 0.08);
        border-color: rgba(255, 45, 85, 0.2);
    }

    .contact-info {
        display: flex;
        align-items: center;
        gap: 12px;
        flex: 1;
    }

    .contact-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--accent-blue), var(--accent-purple));
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        font-size: 16px;
    }

    .contact-details h5 {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 2px;
    }

    .contact-details p {
        font-size: 11px;
        color: var(--text-secondary);
    }

    .contact-status {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
    }

    .contact-status.accepted {
        background: rgba(48, 209, 88, 0.15);
        color: var(--accent-green);
    }

    .contact-status.rejected {
        background: rgba(255, 45, 85, 0.15);
        color: var(--accent-red);
    }

    .contact-status.pending {
        background: rgba(255, 159, 10, 0.15);
        color: var(--accent-orange);
    }

    /* === Responsive === */
    @media (max-width: 480px) {
        .sos-container { padding: 70px 16px 30px; }
        .sos-btn { width: 180px; height: 180px; font-size: 36px; }
        .sos-btn-wrapper { width: 180px; height: 180px; }
        .countdown-number { font-size: 90px; }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth page fade-in */
    body {
        animation: fadeInPage 0.6s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Custom scrollbar (dark themed) */
    ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    ::-webkit-scrollbar-track {
        background: var(--bg-secondary);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--accent-purple);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--accent-red);
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .sos-btn:focus-visible,
    .quick-action-btn:focus-visible,
    .countdown-cancel-btn:focus-visible,
    .back-btn:focus-visible {
        outline: 3px solid var(--accent-orange);
        outline-offset: 3px;
        border-radius: 50%;
    }

    /* 4. Button ripple effect on click (micro-interaction) */
    .sos-btn, .quick-action-btn, .countdown-cancel-btn {
        position: relative;
        overflow: hidden;
    }
    .sos-btn::after, .quick-action-btn::after, .countdown-cancel-btn::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: translate(-50%, -50%);
        transition: width 0.5s ease, height 0.5s ease;
        pointer-events: none;
    }
    .sos-btn:active::after, .quick-action-btn:active::after, .countdown-cancel-btn:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Glass morphism hover enhancement for cards */
    .contact-item, .summary-card, .info-card, .progress-step {
        transition: transform 0.2s ease, border-color 0.2s, background 0.2s;
    }
    .contact-item:hover, .summary-card:hover, .info-card:hover, .progress-step:hover {
        transform: translateY(-2px);
        border-color: rgba(255, 255, 255, 0.2);
        background: rgba(255, 255, 255, 0.08);
    }

    /* 6. Countdown overlay cancel button pulse on hover */
    .countdown-cancel-btn:hover {
        animation: cancelGlow 0.6s ease;
    }
    @keyframes cancelGlow {
        0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.2); }
        100% { box-shadow: 0 0 0 10px rgba(255, 255, 255, 0); }
    }

    /* 7. Status bar dot glow enhancement */
    .status-bar .dot {
        box-shadow: 0 0 4px currentColor;
    }

    /* 8. Quick action icons subtle scale on hover */
    .quick-action-btn i {
        transition: transform 0.2s;
    }
    .quick-action-btn:hover i {
        transform: scale(1.1);
    }

    /* 9. Loading spinner for progress steps (already has one, but add smooth rotation) */
    .spinner {
        animation: spin 0.8s linear infinite;
        will-change: transform;
    }

    /* 10. Additional responsive polish for very small devices */
    @media (max-width: 380px) {
        .response-summary {
            grid-template-columns: 1fr;
            gap: 8px;
        }
        .quick-actions {
            grid-template-columns: 1fr;
        }
        .sos-btn-wrapper {
            transform: scale(0.9);
        }
    }

    /* 11. Smooth loading skeleton ready (optional) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .skeleton {
        background: linear-gradient(90deg, var(--bg-card) 25%, var(--bg-glass) 50%, var(--bg-card) 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
    /* Dashboard Button Styling */
    .dashboard-bar {
        position: relative;
        z-index: 99;
        margin-top: 10px;
        padding-right: 15px;
    }
    .dashboard-btn {
        background: linear-gradient(135deg, #312e81 0%, #1e1b4b 50%, #f43f5e 100%);
        color: #fff !important;
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        font-family: 'Inter', sans-serif;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
    }
    .dashboard-btn:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 8px 25px rgba(244, 63, 94, 0.45);
        color: #fff !important;
    }
    .dashboard-btn i {
        font-size: 1.2rem;
        transition: transform 0.3s ease;
    }
    .dashboard-btn:hover i {
        transform: translateX(5px);
    }
    /* === Recording Indicator === */
    .recording-badge {
        display: flex;
        align-items: center;
        gap: 6px;
        background: rgba(239, 68, 68, 0.15);
        color: #ef4444;
        padding: 4px 10px;
        border-radius: 50px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.5px;
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    .recording-dot {
        width: 8px;
        height: 8px;
        background: #ef4444;
        border-radius: 50%;
        display: inline-block;
        animation: blink 1s ease-in-out infinite;
    }

    @keyframes blink {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.3; }
    }
</style>
</head>
<body>

    <div class="bg-grid" id="bgGrid"></div>

    <!-- Top Nav -->
    <nav class="top-nav">
        <div class="brand"><i class="bi bi-shield-exclamation"></i> SOS Emergency</div>
    </nav>
    <div class="dashboard-bar container-fluid container-xl d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="dashboard-btn">
            Dashboard <i class="bi bi-arrow-right"></i>
        </a>
    </div>

    <!-- Toast -->
    <div class="toast-notification" id="toast"></div>

    <!-- Main SOS Container -->
    <div class="sos-container">

        <!-- Status -->
        <div class="status-bar" id="statusBar">
            <div class="dot"></div>
            <span id="statusText">System ready &mdash; Location tracking active</span>
        </div>

        <!-- SOS Button Card -->
        <div class="sos-outer-box">
            <div class="sos-btn-wrapper">
                <div class="sos-btn-ring ring-1"></div>
                <div class="sos-btn-ring ring-2"></div>
                <div class="sos-btn-ring ring-3"></div>
                <button class="sos-btn" id="sosBtn" onclick="initiateSOS()">SOS</button>
            </div>
            <div class="sos-btn-label">Tap to send emergency alert</div>
        </div>

        <!-- Stop SOS Button (hidden until triggered) -->
        <div id="stopSosContainer" style="display: none; text-align: center; margin-top: 20px;">
            <button class="btn btn-danger btn-lg px-5 py-3 fw-bold shadow" onclick="cancelCountdown()" style="border-radius: 50px; background: #dc3545; border: none; color: white;">
                <i class="bi bi-stop-circle"></i> STOP SOS
            </button>
            <p class="text-muted mt-2" style="font-size: 0.85rem; color: rgba(255,255,255,0.6) !important;">Only stop if you are safe</p>
        </div>

        <!-- Alert Progress (hidden until triggered) -->
        <div class="alert-progress" id="alertProgress">
            <div class="progress-step" id="step1">
                <div class="step-icon pending"><i class="bi bi-geo-alt"></i></div>
                <div class="step-info">
                    <div class="step-title">Getting Location</div>
                    <div class="step-desc">Acquiring GPS coordinates...</div>
                </div>
            </div>
            <div class="progress-step" id="step2">
                <div class="step-icon pending"><i class="bi bi-envelope-exclamation"></i></div>
                <div class="step-info">
                    <div class="step-title">Alerting Emergency Contacts</div>
                    <div class="step-desc">Sending email with your location...</div>
                </div>
            </div>
            <div class="progress-step" id="step3">
                <div class="step-icon pending"><i class="bi bi-people"></i></div>
                <div class="step-info">
                    <div class="step-title">Notifying Nearby Volunteers</div>
                    <div class="step-desc">Searching within 20km radius...</div>
                </div>
            </div>
            <div class="progress-step" id="step4">
                <div class="step-icon pending"><i class="bi bi-telephone"></i></div>
                <div class="step-info">
                    <div class="step-title">Auto-Call</div>
                    <div class="step-desc">Dialing emergency contact...</div>
                </div>
            </div>
        </div>

        <!-- Real-Time Contact Response Panel -->
        <div class="contact-response-panel" id="contactResponsePanel" style="display: none;">
            <h4 style="margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-people-fill" style="color: var(--accent-blue);"></i>
                Contact Response Status
            </h4>
            
            <!-- Summary Cards -->
            <div class="response-summary" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px;">
                <div class="summary-card accepted">
                    <div class="summary-number" id="acceptedCount">0</div>
                    <div class="summary-label"><i class="bi bi-check-circle"></i> Accepted</div>
                </div>
                <div class="summary-card pending">
                    <div class="summary-number" id="pendingCount">0</div>
                    <div class="summary-label"><i class="bi bi-hourglass-split"></i> Pending</div>
                </div>
                <div class="summary-card rejected">
                    <div class="summary-number" id="rejectedCount">0</div>
                    <div class="summary-label"><i class="bi bi-x-circle"></i> Declined</div>
                </div>
            </div>

            <!-- Contact List -->
            <div class="contact-list" id="contactList">
                <!-- Contacts will be dynamically added here -->
            </div>
        </div>

        <!-- Volunteer Responded Banner -->
        <div class="responded-banner" id="respondedBanner">
            <h4><i class="bi bi-check-circle"></i> Volunteer Responding!</h4>
            <p id="respondedText">A verified volunteer is on their way to help you.</p>
            <div id="bannerRecordingStatus" style="margin-top: 10px; font-size: 0.9rem; color: #ef4444; font-weight: bold; display: none;">
                <span class="recording-dot"></span> Audio Evidence being recorded...
            </div>
        </div>

        <!-- Real-Time Volunteer Response Panel -->
        <div class="contact-response-panel" id="volunteerResponsePanel" style="display: none; margin-top: 20px; border-top: 2px solid #e9ecef; padding-top: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h4 style="margin: 0; display: flex; align-items: center; gap: 8px;">
                    <i class="bi bi-shield-check" style="color: #10B981;"></i>
                    Nearby Volunteer Status (5km Radius)
                </h4>
                <div id="liveRecordingBadge" class="recording-badge" style="display: none;">
                    <span class="recording-dot"></span> LIVE RECORDING
                </div>
            </div>

            <!-- Volunteer Summary Cards -->
            <div class="response-summary" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px;">
                <div class="summary-card accepted" style="background: rgba(16, 185, 129, 0.1); border-color: rgba(16, 185, 129, 0.2);">
                    <div class="summary-number" id="volAcceptedCount" style="color: #10B981;">0</div>
                    <div class="summary-label" style="color: #10B981;"><i class="bi bi-check-circle"></i> Accepted</div>
                </div>
                <div class="summary-card pending" style="background: rgba(245, 158, 11, 0.1); border-color: rgba(245, 158, 11, 0.2);">
                    <div class="summary-number" id="volPendingCount" style="color: #f59e0b;">0</div>
                    <div class="summary-label" style="color: #f59e0b;"><i class="bi bi-hourglass-split"></i> Pending</div>
                </div>
                <div class="summary-card rejected" style="background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.2);">
                    <div class="summary-number" id="volRejectedCount" style="color: #ef4444;">0</div>
                    <div class="summary-label" style="color: #ef4444;"><i class="bi bi-x-circle"></i> Declined</div>
                </div>
            </div>
            
            <div id="volunteerList">
                <!-- Volunteers will be dynamically added here -->
            </div>
        </div>

        <!-- Audio Evidence Panel -->
        <div class="contact-response-panel" id="audioEvidenceContainer" style="display: none; margin-top: 20px; border-top: 2px solid #e9ecef; padding-top: 20px;">
            <h4 style="margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-mic-fill" style="color: #ef4444;"></i>
                Emergency Audio Evidence
            </h4>
            <div class="alert alert-info" style="font-size: 0.9rem;">
                <i class="bi bi-info-circle"></i> This audio was automatically recorded during the SOS activation as evidence.
            </div>
            <audio id="sosAudioPlayer" controls style="width: 100%; margin-top: 10px;"></audio>
        </div>

        <!-- Help Instructions -->
        <div class="quick-actions">
            <a href="tel:100" class="quick-action-btn police">
                <i class="bi bi-shield-fill"></i>
                Call Police (100)
            </a>
            <a href="tel:108" class="quick-action-btn ambulance">
                <i class="bi bi-heart-pulse"></i>
                Ambulance (108)
            </a>
            <a href="${pageContext.request.contextPath}/users/${userId}/emergency-contacts" class="quick-action-btn contacts">
                <i class="bi bi-person-lines-fill"></i>
                My Contacts
            </a>
            <button class="quick-action-btn location" onclick="shareLocation()">
                <i class="bi bi-pin-map-fill"></i>
                Share Location
            </button>
        </div>

        <!-- How it works -->
        <div class="info-card">
            <h4><i class="bi bi-info-circle"></i> How SOS Works</h4>
            <p>
                1. Tap the SOS button to start a <strong>15-second countdown</strong><br>
                2. You can <strong>cancel</strong> during the countdown if pressed accidentally<br>
                3. After countdown: your <strong>location is sent</strong> to emergency contacts via email<br>
                4. <strong>Nearby verified volunteers</strong> receive real-time alerts<br>
                5. <strong>Auto-call</strong> dials your first emergency contact automatically
            </p>
        </div>
    </div>

    <!-- Countdown Overlay -->
    <div class="countdown-overlay" id="countdownOverlay">
        <div class="countdown-number" id="countdownNumber">15</div>
        <div class="countdown-text">
            Sending SOS alert when countdown reaches zero.<br>
            <strong>Tap below to cancel if pressed accidentally.</strong>
        </div>
        <button class="countdown-cancel-btn" onclick="cancelCountdown()">
            <i class="bi bi-x-circle"></i> &nbsp; Cancel SOS
        </button>
    </div>

    <!-- Alarm Sound -->
    <audio id="alarmSound" loop>
        <source src="${pageContext.request.contextPath}/siren.mp3" type="audio/mpeg">
    </audio>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const userId = '${userId}';
        let countdownTimer = null;
        let countdownValue = 15;
        let currentSosId = ${activeSosId != null ? activeSosId : 'null'};
        let isInitiallyActive = ${isSosActive};
        let userLatitude = null;
        let userLongitude = null;
        let autoCallPhone = null;
        let stompClient = null;
        let mediaRecorder = null;
        let audioChunks = [];

        // === Initialize: Get location on page load ===
        window.addEventListener('load', () => {
            initLocation();
            connectWebSocket();
            requestAudioPermission();
            
            // Restore state if SOS was active before refresh
            if (isInitiallyActive && currentSosId) {
                restoreActiveSOSState();
            }
        });

        async function requestAudioPermission() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                // We just want to check permission here, so we stop the tracks immediately
                stream.getTracks().forEach(track => track.stop());
                console.log('Microphone permission granted');
            } catch (err) {
                console.error('Microphone permission denied:', err);
                showToast('Warning: Microphone access is required for emergency audio evidence.');
            }
        }

        async function startAudioRecording() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                mediaRecorder = new MediaRecorder(stream);
                audioChunks = [];

                mediaRecorder.ondataavailable = (event) => {
                    audioChunks.push(event.data);
                };

                mediaRecorder.onstop = async () => {
                    const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
                    uploadAudioRecording(audioBlob);
                    stream.getTracks().forEach(track => track.stop());
                };

                mediaRecorder.start();
                console.log('Audio recording started');
                
                // Show recording status indicators
                document.getElementById('liveRecordingBadge').style.display = 'flex';
                document.getElementById('bannerRecordingStatus').style.display = 'block';
            } catch (err) {
                console.error('Error starting audio recording:', err);
            }
        }

        function stopAudioRecording() {
            if (mediaRecorder && mediaRecorder.state !== 'inactive') {
                mediaRecorder.stop();
                console.log('Audio recording stopped');
                
                // Hide recording status indicators
                document.getElementById('liveRecordingBadge').style.display = 'none';
                document.getElementById('bannerRecordingStatus').style.display = 'none';
            }
        }

        async function uploadAudioRecording(blob) {
            if (!currentSosId) return;

            const formData = new FormData();
            formData.append('sosId', currentSosId);
            formData.append('audio', blob, 'sos_recording.webm');

            try {
                const response = await fetch(contextPath + '/api/sos/audio/upload', {
                    method: 'POST',
                    body: formData
                });
                const data = await response.json();
                if (data.success) {
                    console.log('Audio recording uploaded successfully:', data.audioPath);
                    // Update the UI with audio player if needed
                    updateAudioPlayer(data.audioPath);
                }
            } catch (err) {
                console.error('Error uploading audio recording:', err);
            }
        }

        function updateAudioPlayer(audioPath) {
            const playerContainer = document.getElementById('audioEvidenceContainer');
            if (playerContainer && audioPath) {
                playerContainer.style.display = 'block';
                const player = document.getElementById('sosAudioPlayer');
                player.src = contextPath + audioPath;
            }
        }

        function restoreActiveSOSState() {
             console.log('Restoring active SOS state for ID:', currentSosId);
             
             // Update UI
             updateStatusBar('🚨 SOS Active — Help is on the way', true);
             document.getElementById('sosBtn').classList.add('pressed');
             document.getElementById('bgGrid').classList.add('sos-active');
             document.getElementById('stopSosContainer').style.display = 'block';
             
             // Show progress steps (all done since it's already triggered)
             const progress = document.getElementById('alertProgress');
             progress.classList.add('active');
             setStepDone('step1');
             setStepDone('step2');
             setStepDone('step3');
             setStepDone('step4');
             
             // Start recording if not already started
             if (!mediaRecorder || mediaRecorder.state === 'inactive') {
                 startAudioRecording();
             }
             
             // Start polling for responses
             startContactResponsePolling();
         }

        function initLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.watchPosition(
                    (pos) => {
                        userLatitude = pos.coords.latitude;
                        userLongitude = pos.coords.longitude;
                        document.getElementById('statusText').textContent =
                            'System ready — Location: ' + userLatitude.toFixed(4) + ', ' + userLongitude.toFixed(4);
                    },
                    (err) => {
                        document.getElementById('statusText').textContent =
                            'Location unavailable — Enable GPS for best results';
                        document.getElementById('statusBar').classList.add('danger');
                    },
                    { enableHighAccuracy: true, timeout: 10000, maximumAge: 5000 }
                );
            } else {
                document.getElementById('statusText').textContent = 'Geolocation not supported by browser';
                document.getElementById('statusBar').classList.add('danger');
            }
        }

        // === WebSocket Connection ===
        function connectWebSocket() {
            try {
                // Use the same WebSocket endpoint as the chat or SOS updates
                const socket = new SockJS(contextPath + '/ws-chat');
                stompClient = Stomp.over(socket);
                stompClient.debug = null; 

                stompClient.connect({}, (frame) => {
                    console.log('WebSocket connected');

                    // Subscribe to personal SOS updates
                    stompClient.subscribe('/topic/sos-updates/user-' + userId, (message) => {
                        const data = JSON.parse(message.body);
                        handleWebSocketMessage(data);
                    });
                });
            } catch (e) {
                console.log('WebSocket connection failed, will use polling');
            }
        }

        function handleWebSocketMessage(data) {
            if (data.type === 'SOS_ACTIVATED') {
                currentSosId = data.sosId;
                updateStatusBar('🚨 SOS Active — Help is on the way', true);
                startContactResponsePolling();
            } else if (data.type === 'CONTACT_ACCEPTED') {
                fetchContactResponses(); // Refresh list
                showToast(data.contactName + ' has accepted your SOS!');
            } else if (data.type === 'VOLUNTEER_ACCEPTED') {
                const banner = document.getElementById('respondedBanner');
                document.getElementById('respondedText').textContent =
                    data.volunteerName + ' is on their way to help you!';
                banner.classList.add('active');
                
                // Show recording status in banner to reassure user
                document.getElementById('bannerRecordingStatus').style.display = 'block';
                
                fetchContactResponses(); // Refresh list to show volunteers
                showToast('Volunteer ' + data.volunteerName + ' is responding!');
            } else if (data.type === 'VOLUNTEER_DECLINED') {
                fetchContactResponses(); // Refresh counts
            } else if (data.type === 'SOS_CANCELLED') {
                showToast('SOS has been cancelled');
                setTimeout(() => window.location.reload(), 2000);
            }
        }

        // === SOS Flow ===
        function initiateSOS() {
            // Start countdown
            document.getElementById('countdownOverlay').classList.add('active');
            document.getElementById('sosBtn').classList.add('pressed');
            document.getElementById('bgGrid').classList.add('sos-active');
            countdownValue = 15;
            document.getElementById('countdownNumber').textContent = countdownValue;

            countdownTimer = setInterval(() => {
                countdownValue--;
                document.getElementById('countdownNumber').textContent = countdownValue;

                if (countdownValue <= 0) {
                    clearInterval(countdownTimer);
                    countdownTimer = null;
                    document.getElementById('countdownOverlay').classList.remove('active');
                    executeSOS();
                }
            }, 1000);
        }

        function cancelCountdown() {
            if (countdownTimer) {
                clearInterval(countdownTimer);
                countdownTimer = null;
            }
            
            // Stop Audio Recording
            stopAudioRecording();
            
            // Stop Siren
            try {
                const alarm = document.getElementById('alarmSound');
                alarm.pause();
                alarm.currentTime = 0;
            } catch(e) {}

            document.getElementById('countdownOverlay').classList.remove('active');
            document.getElementById('sosBtn').classList.remove('pressed');
            document.getElementById('bgGrid').classList.remove('sos-active');
            document.getElementById('stopSosContainer').style.display = 'none';

            // If SOS was already triggered, cancel it on server
            if (currentSosId) {
                fetch(contextPath + '/sos/cancel/' + currentSosId + '?userId=' + userId, { method: 'POST' })
                    .then(r => r.json())
                    .then(data => {
                        showToast(data.message || 'SOS cancelled');
                        currentSosId = null;
                        setTimeout(() => window.location.reload(), 1500);
                    });
            } else {
                showToast('SOS cancelled — false alarm');
            }
        }

        function executeSOS() {
            const progress = document.getElementById('alertProgress');
            progress.classList.add('active');

            // Step 1: Get Location
            setStepActive('step1');

            if (!userLatitude || !userLongitude) {
                // Try one more time
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        (pos) => {
                            userLatitude = pos.coords.latitude;
                            userLongitude = pos.coords.longitude;
                            proceedWithSOS();
                        },
                        (err) => {
                            // Use default/fallback
                            userLatitude = 0;
                            userLongitude = 0;
                            showToast('Could not get location — sending alert anyway', true);
                            proceedWithSOS();
                        },
                        { enableHighAccuracy: true, timeout: 5000 }
                    );
                } else {
                    userLatitude = 0;
                    userLongitude = 0;
                    proceedWithSOS();
                }
            } else {
                proceedWithSOS();
            }
        }

        function proceedWithSOS() {
            setStepDone('step1');

            // Step 2 & 3: Send to server
            setStepActive('step2');
            updateStatusBar('Sending emergency alerts...', true);

            const formData = new URLSearchParams();
            formData.append('latitude', userLatitude);
            formData.append('longitude', userLongitude);

            fetch(contextPath + '/sos/trigger', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    showToast(data.error, true);
                    return;
                }

                currentSosId = data.sosId;
                autoCallPhone = data.autoCallPhone;
                document.getElementById('stopSosContainer').style.display = 'block';

                // Start Audio Recording for Evidence
                startAudioRecording();

                // Play Siren
                try {
                    document.getElementById('alarmSound').play();
                } catch(e) {
                    console.warn("Audio play blocked");
                }

                // Step 2: Done - contacts notified
                const contactCount = data.contactsNotified || 0;
                document.querySelector('#step2 .step-desc').textContent =
                    contactCount + ' contact(s) notified via email';
                setStepDone('step2');

                // Step 3: Done - volunteers alerted
                setTimeout(() => {
                    const volCount = data.volunteersAlerted || 0;
                    document.querySelector('#step3 .step-desc').textContent =
                        volCount + ' volunteer(s) alerted nearby';
                    setStepDone('step3');

                    // Step 4: Auto-call
                    setTimeout(() => {
                        setStepActive('step4');
                        triggerAutoCall();
                    }, 1000);
                }, 800);

                updateStatusBar('🚨 SOS Active — Help is on the way', true);

                // Start polling for contact responses
                startContactResponsePolling();
            })
            .catch(err => {
                console.error('SOS trigger failed:', err);
                showToast('Failed to send SOS. Trying auto-call directly...', true);
                // Fallback: try auto-call even if server fails
                autoCallPhone = '100';
                setTimeout(triggerAutoCall, 1000);
            });
        }

        function triggerAutoCall() {
            const phone = autoCallPhone || '100';
            document.querySelector('#step4 .step-desc').textContent =
                'Dialing ' + phone + '...';

            // Mark auto-call on server
            if (currentSosId) {
                fetch(contextPath + '/sos/auto-call/' + currentSosId, { method: 'POST' }).catch(() => {});
            }

            setTimeout(() => {
                setStepDone('step4');
                // Open phone dialer
                window.location.href = 'tel:' + phone;
            }, 1500);
        }

        // === UI Helpers ===
        function setStepActive(stepId) {
            const step = document.getElementById(stepId);
            step.classList.remove('done');
            step.classList.add('active');
            step.querySelector('.step-icon').classList.remove('pending');
            step.querySelector('.step-icon').innerHTML = '<div class="spinner"></div>';
        }

        function setStepDone(stepId) {
            const step = document.getElementById(stepId);
            step.classList.remove('active');
            step.classList.add('done');
            step.querySelector('.step-icon').innerHTML = '<i class="bi bi-check-lg"></i>';
        }

        function updateStatusBar(text, isDanger) {
            const bar = document.getElementById('statusBar');
            document.getElementById('statusText').textContent = text;
            if (isDanger) bar.classList.add('danger');
            else bar.classList.remove('danger');
        }

        function showToast(message, isError) {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast-notification show' + (isError ? ' error' : '');
            setTimeout(() => { toast.classList.remove('show'); }, 3000);
        }

        function shareLocation() {
            if (userLatitude && userLongitude) {
                const url = 'https://www.google.com/maps?q=' + userLatitude + ',' + userLongitude;
                if (navigator.share) {
                    navigator.share({ title: 'My Location - Emergency', url: url });
                } else {
                    navigator.clipboard.writeText(url).then(() => {
                        showToast('Location link copied to clipboard!');
                    });
                }
            } else {
                showToast('Location not available yet', true);
            }
        }

        // === Real-Time Contact Response Tracking ===
        let responsePollingInterval = null;

        function startContactResponsePolling() {
            // Show the response panels
            document.getElementById('contactResponsePanel').style.display = 'block';
            document.getElementById('volunteerResponsePanel').style.display = 'block';
            
            // Initial fetch
            fetchContactResponses();
            
            // Poll every 3 seconds for updates
            responsePollingInterval = setInterval(fetchContactResponses, 3000);
        }

        function stopContactResponsePolling() {
            if (responsePollingInterval) {
                clearInterval(responsePollingInterval);
                responsePollingInterval = null;
            }
        }

        function fetchContactResponses() {
            if (!currentSosId) return;

            fetch(contextPath + '/sos/status/' + currentSosId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        updateContactResponseUI(data);
                    }
                })
                .catch(err => console.error('Failed to fetch contact responses:', err));
        }

        function updateContactResponseUI(data) {
            // Update summary counts
            document.getElementById('acceptedCount').textContent = data.contactsAccepted || 0;
            document.getElementById('pendingCount').textContent = data.contactsPending || 0;
            document.getElementById('rejectedCount').textContent = data.contactsRejected || 0;

            // Update Volunteer summary counts
            if (document.getElementById('volAcceptedCount')) {
                document.getElementById('volAcceptedCount').textContent = data.volunteersAccepted || 0;
                document.getElementById('volPendingCount').textContent = data.volunteersPending || 0;
                document.getElementById('volRejectedCount').textContent = data.volunteersDeclined || 0;
                
                // Show recording status if help is coming
                if (data.volunteersAccepted > 0 && mediaRecorder && mediaRecorder.state === 'recording') {
                    document.getElementById('liveRecordingBadge').style.display = 'flex';
                    document.getElementById('bannerRecordingStatus').style.display = 'block';
                }
            }

            // Update Audio Evidence
            if (data.audioPath) {
                updateAudioPlayer(data.audioPath);
            }

            // Update contact list
            const contactList = document.getElementById('contactList');
            contactList.innerHTML = ''; // Clear existing

            if (data.contacts && data.contacts.length > 0) {
                data.contacts.forEach(c => {
                    const statusClass = (c.status || 'pending').toLowerCase();
                    const item = document.createElement('div');
                    item.className = 'contact-item ' + statusClass;
                    item.innerHTML = `
                        <div class="contact-info">
                            <div class="contact-details">
                                <h5>${c.name || 'Unknown'} (${c.relation || 'Contact'})</h5>
                                <p><i class="bi bi-telephone"></i> ${c.phone || 'No phone'}</p>
                            </div>
                        </div>
                        <div class="contact-status ${statusClass}">
                            ${c.status || 'Pending'}
                        </div>
                    `;
                    contactList.appendChild(item);
                });
            } else {
                contactList.innerHTML = '<p style="text-align: center; color: var(--text-secondary); padding: 20px;">No contacts added yet</p>';
            }

            // Update Volunteer List
            const vList = document.getElementById('volunteerList');
            const vPanel = document.getElementById('volunteerResponsePanel');
            
            // Show panel if we have alerted anyone or have any responses
            if ((data.volunteersAlerted && data.volunteersAlerted > 0) || (data.volunteers && data.volunteers.length > 0)) {
                vPanel.style.display = 'block';
                vList.innerHTML = '';
                
                if (data.volunteers && data.volunteers.length > 0) {
                    data.volunteers.forEach(v => {
                        if (v.status === 'ACCEPTED') {
                            const item = document.createElement('div');
                            item.className = 'contact-item accepted';
                            item.style.borderLeft = '4px solid #10B981';
                            item.innerHTML = `
                                <div class="contact-info">
                                    <div class="contact-details">
                                        <h5><i class="bi bi-shield-fill-check text-success"></i> ${v.name}</h5>
                                        <p><i class="bi bi-telephone"></i> ${v.phone || 'Phone hidden'}</p>
                                    </div>
                                </div>
                                <div class="contact-status accepted">
                                    HELPING
                                </div>
                            `;
                            vList.appendChild(item);
                        }
                    });
                }
            } else {
                vPanel.style.display = 'none';
            }
        }

        function createContactItem(contact) {
            const div = document.createElement('div');
            div.className = 'contact-item ' + (contact.responseStatus || 'pending').toLowerCase();

            const statusIcon = getStatusIcon(contact.responseStatus);
            const statusText = getStatusText(contact.responseStatus);
            const initials = getInitials(contact.contactName);
            const respondedTime = contact.respondedAt ? formatTime(contact.respondedAt) : '';

            var html = '<div class="contact-info">';
            html += '<div class="contact-avatar">' + initials + '</div>';
            html += '<div class="contact-details">';
            html += '<h5>' + (contact.contactName || 'Unknown') + '</h5>';
            html += '<p>' + (contact.relation || 'Contact') + ' • ' + (contact.contactPhone || 'No phone') + '</p>';
            html += '</div></div>';
            html += '<div class="contact-status ' + (contact.responseStatus || 'pending').toLowerCase() + '">';
            html += statusIcon + ' ' + statusText;
            if (respondedTime) {
                html += '<span style="margin-left: 4px; opacity: 0.7;">' + respondedTime + '</span>';
            }
            html += '</div>';

            div.innerHTML = html;

            return div;
        }

        function getStatusIcon(status) {
            switch(status) {
                case 'ACCEPTED': return '<i class="bi bi-check-circle-fill"></i>';
                case 'REJECTED': return '<i class="bi bi-x-circle-fill"></i>';
                case 'ON_THE_WAY': return '<i class="bi bi-car-front-fill"></i>';
                default: return '<i class="bi bi-hourglass-split"></i>';
            }
        }

        function getStatusText(status) {
            switch(status) {
                case 'ACCEPTED': return 'Accepted';
                case 'REJECTED': return 'Declined';
                case 'ON_THE_WAY': return 'On the way';
                case 'NO_RESPONSE': return 'No response';
                default: return 'Pending';
            }
        }

        function getInitials(name) {
            if (!name) return '?';
            return name.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2);
        }

        function formatTime(dateTimeStr) {
            if (!dateTimeStr) return '';
            const date = new Date(dateTimeStr);
            const now = new Date();
            const diffMs = now - date;
            const diffSec = Math.floor(diffMs / 1000);
            
            if (diffSec < 60) return 'Just now';
            if (diffSec < 3600) return Math.floor(diffSec / 60) + 'm ago';
            return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        }

        // Cleanup polling when page unloads
        window.addEventListener('beforeunload', () => {
            stopContactResponsePolling();
        });
    </script>
</body>
</html>

