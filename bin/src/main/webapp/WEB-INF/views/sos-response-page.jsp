<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SOS Response - Women Safety App</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
    /* ============================================
       ROOT VARIABLES (your brand colors)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --gradient-success: linear-gradient(135deg, #11998e, #38ef7d);
        --gradient-error: linear-gradient(135deg, #ff416c, #ff4b2b);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: var(--gradient-primary);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }

    .response-card {
        background: white;
        border-radius: 20px;
        box-shadow: var(--shadow-lg);
        max-width: 500px;
        width: 100%;
        padding: 40px;
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .response-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
    }

    .icon-circle {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 50px;
        color: white;
    }

    .icon-circle.success {
        background: var(--gradient-success);
    }

    .icon-circle.error {
        background: var(--gradient-error);
    }

    h1 {
        font-size: 28px;
        margin-bottom: 10px;
        color: var(--primary-purple);
    }

    .message {
        font-size: 16px;
        color: #555;
        margin-bottom: 30px;
        line-height: 1.6;
    }

    .details {
        background: var(--light-bg);
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 30px;
        text-align: left;
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid rgba(123, 44, 191, 0.2);
    }
    .detail-row:last-child {
        border-bottom: none;
    }

    .detail-label {
        font-weight: 600;
        color: var(--primary-purple);
    }

    .detail-value {
        color: var(--dark-bg);
    }

    .btn-primary {
        background: var(--gradient-primary);
        color: white;
        border: none;
        padding: 15px 40px;
        border-radius: 50px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        box-shadow: var(--shadow-sm);
    }

    .btn-primary:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
        filter: brightness(1.02);
    }
    .btn-primary:active {
        transform: translateY(0);
    }

    .alert-box {
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    .alert-box.success {
        background: rgba(32, 201, 151, 0.1);
        border: 2px solid var(--primary-teal);
        color: var(--primary-teal);
    }

    .alert-box.error {
        background: rgba(232, 69, 69, 0.1);
        border: 2px solid var(--primary-coral-dark);
        color: var(--primary-coral-dark);
    }

    /* Focus outline for accessibility */
    .btn-primary:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 50px;
    }

    /* Custom scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }
</style>
</head>
<body>
    <div class="response-card">
        <c:choose>
            <c:when test="${success == true}">
                <div class="icon-circle success">
                    <i class="bi bi-check-lg"></i>
                </div>
                <div class="alert-box success">
                    <strong>Response Recorded!</strong>
                </div>
                <h1>Thank You, ${contactName}!</h1>
                <p class="message">${message}</p>
                
                <div class="details">
                    <div class="detail-row">
                        <span class="detail-label">Your Response:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${action == 'accept'}">
                                    <span style="color: #28a745; font-weight: 600;">✅ ACCEPTED - Help is on the way!</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #dc3545; font-weight: 600;">❌ DECLINED</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Status:</span>
                        <span class="detail-value" style="color: #28a745; font-weight: 600;">Confirmed</span>
                    </div>
                </div>

                <c:if test="${action == 'accept'}">
                    <p style="color: #666; font-size: 14px; margin-bottom: 20px;">
                        The person in distress has been notified that you're coming to help.
                    </p>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="icon-circle error">
                    <i class="bi bi-x-lg"></i>
                </div>
                <div class="alert-box error">
                    <strong>Error</strong>
                </div>
                <h1>Invalid Response</h1>
                <p class="message">${message}</p>
            </c:otherwise>
        </c:choose>

        <a href="#" onclick="window.close();" class="btn-primary">
            <i class="bi bi-x-circle"></i> Close This Window
        </a>
    </div>
</body>
</html>

