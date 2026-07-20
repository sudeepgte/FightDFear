<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wallet | Fight D Fear</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
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
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        background: #0f0f1a;
        min-height: 100vh;
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #fff;
    }
    h4, h5, p { color: #fff; }
    .card h5, .card p { color: var(--dark-bg); }


    .navbar {
        background: linear-gradient(135deg, var(--primary-purple) 0%, var(--primary-purple-light) 100%);
        padding: 15px 0;
        box-shadow: var(--shadow-sm);
    }
    .navbar-brand {
        font-weight: bold;
        font-size: 24px;
        color: white !important;
        transition: opacity 0.3s;
    }
    .navbar-brand:hover {
        opacity: 0.9;
    }

    .wallet-header {
        background: var(--gradient-primary);
        color: white;
        padding: 40px 0;
        border-radius: 0 0 30px 30px;
        text-align: center;
        margin-bottom: 30px;
        box-shadow: var(--shadow-md);
    }
    .coin-balance {
        font-size: 48px;
        font-weight: bold;
        margin: 10px 0;
        text-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }
    .coin-icon {
        color: var(--primary-gold);
        font-size: 40px;
        filter: drop-shadow(0 2px 5px rgba(0,0,0,0.2));
    }

    .reward-card {
        border: none;
        border-radius: 20px;
        box-shadow: var(--shadow-sm);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        margin-bottom: 25px;
        overflow: hidden;
        background: white;
    }
    .reward-card:hover {
        transform: translateY(-6px);
        box-shadow: var(--shadow-md);
    }
    .reward-card .card-body {
        padding: 25px;
    }

    .btn-redeem {
        background: var(--gradient-primary);
        color: white;
        border-radius: 40px;
        padding: 8px 28px;
        font-weight: 600;
        border: none;
        transition: all 0.3s ease;
        box-shadow: var(--shadow-sm);
    }
    .btn-redeem:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        filter: brightness(1.02);
        color: white;
    }
    .btn-redeem:active {
        transform: translateY(0);
    }

    .coupon-box {
        background: linear-gradient(135deg, #fff8e7, #fff3cd);
        border: 2px dashed var(--primary-gold);
        padding: 15px;
        border-radius: 16px;
        margin-top: 20px;
        text-align: center;
        box-shadow: var(--shadow-sm);
    }
    .coupon-code {
        font-family: 'Courier New', monospace;
        font-size: 24px;
        font-weight: bold;
        color: var(--primary-purple);
        letter-spacing: 1px;
    }

    @media (max-width: 768px) {
        .coin-balance {
            font-size: 36px;
        }
        .coin-icon {
            font-size: 30px;
        }
        .wallet-header {
            padding: 25px 0;
        }
        .reward-card .card-body {
            padding: 18px;
        }
        .coupon-code {
            font-size: 18px;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole page */
    body {
        animation: fadeInPage 0.6s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Wallet header subtle glow effect */
    .wallet-header {
        position: relative;
        overflow: hidden;
    }
    .wallet-header::after {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
        animation: headerGlow 8s ease-in-out infinite;
        pointer-events: none;
    }
    @keyframes headerGlow {
        0%, 100% { transform: translate(0, 0); opacity: 0.5; }
        50% { transform: translate(5%, 5%); opacity: 1; }
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-redeem {
        position: relative;
        overflow: hidden;
    }
    .btn-redeem::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-redeem:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Focus outlines for accessibility (keyboard navigation) */
    .btn-redeem:focus-visible,
    .navbar-brand:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 40px;
    }

    /* 5. Custom scrollbar (matches brand purple) */
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
        transition: background 0.2s;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-gold);
    }

    /* 6. Coin icon hover effect – subtle scale and rotation */
    .coin-icon {
        transition: transform 0.3s ease;
        display: inline-block;
    }
    .coin-icon:hover {
        transform: scale(1.1) rotate(5deg);
    }

    /* 7. Reward card image/icon zoom (if any) */
    .reward-card img, .reward-card i {
        transition: transform 0.3s ease;
    }
    .reward-card:hover img, .reward-card:hover i {
        transform: scale(1.02);
    }

    /* 8. Coupon box hover effect – lift and deeper shadow */
    .coupon-box {
        transition: transform 0.3s ease, box-shadow 0.3s;
    }
    .coupon-box:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
    }

    /* 9. Responsive improvements for very small devices */
    @media (max-width: 480px) {
        .coin-balance {
            font-size: 28px;
        }
        .coin-icon {
            font-size: 24px;
        }
        .btn-redeem {
            padding: 6px 20px;
            font-size: 0.85rem;
        }
        .coupon-code {
            font-size: 14px;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .reward-card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">


<div class="wallet-header">
    <div class="container">
    <div class="container row mx-auto text-center">
        <div class="col-md-6 mb-3">
            <h5>Coin Balance</h5>
            <div class="coin-balance">
                <i class="bi bi-coin coin-icon"></i> 
                <span id="current-coins">${user.rewardPoints != null ? user.rewardPoints : 0}</span>
            </div>
            <p>Keep watching Reels to earn more coins!</p>
        </div>
        <div class="col-md-6 mb-3 border-start border-light border-opacity-25">
            <h5>Cash Balance (&#8377;)</h5>
            <div class="coin-balance" style="color: var(--primary-teal);">
                <i class="bi bi-wallet2 me-2 text-white"></i> 
                <span id="current-cash">${user.walletBalance != null ? user.walletBalance : 0.0}</span>
            </div>
            <p>Earnings from your bookings</p>
        </div>
    </div>
    </div>
</div>

<!-- Rewards Section Header -->
<div class="container mb-5">
    <div class="p-5 rounded-4 shadow-lg text-center" style="background: rgba(30, 27, 75, 0.1); border: 2px solid rgba(219, 39, 119, 0.3); backdrop-filter: blur(15px); position: relative; overflow: hidden;">
        <div style="position: absolute; top: -10%; right: -5%; width: 200px; height: 200px; background: radial-gradient(circle, rgba(219, 39, 119, 0.2), transparent); border-radius: 50%;"></div>
        <h1 class="mb-2" style="color: #fff; font-weight: 800; letter-spacing: 2px;">
            <i class="bi bi-gift me-3" style="color: var(--primary-coral);"></i>REDEEM REWARDS
        </h1>
        <p class="text-white-50" style="font-size: 1.1rem;">Unlock exclusive benefits with your earned coins</p>
    </div>
</div>

<div class="container">
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty coupon}">
        <div class="coupon-box mb-4">
            <h5>🎁 Your Reward Coupon!</h5>
            <p>Use this code to redeem your reward:</p>
            <div class="coupon-code">${coupon}</div>
            <p class="small mt-2">Take a screenshot or copy this code.</p>
        </div>
    </c:if>

    <h4 class="mb-4">Redeem Rewards 🎁</h4>
    <div class="row">
        <div class="col-md-4">
            <div class="card reward-card">
                <div class="card-body">
                    <h5 class="card-title">10% Salon Discount</h5>
                    <p class="card-text text-muted">Get 10% off on any salon service of your choice.</p>
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <span class="fw-bold"><i class="bi bi-coin text-warning"></i> 100</span>
                        <form action="${pageContext.request.contextPath}/users/redeem" method="POST">
                            <input type="hidden" name="cost" value="100">
                            <input type="hidden" name="rewardName" value="10% Salon Discount">
                            <button type="submit" class="btn btn-redeem">Redeem</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card reward-card">
                <div class="card-body">
                    <h5 class="card-title">Free Martial Arts Class</h5>
                    <p class="card-text text-muted">One free trial session at any registered Martial Arts Centre.</p>
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <span class="fw-bold"><i class="bi bi-coin text-warning"></i> 200</span>
                        <form action="${pageContext.request.contextPath}/users/redeem" method="POST">
                            <input type="hidden" name="cost" value="200">
                            <input type="hidden" name="rewardName" value="Free Martial Arts Class">
                            <button type="submit" class="btn btn-redeem">Redeem</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card reward-card">
                <div class="card-body">
                    <h5 class="card-title">Safety Badge</h5>
                    <p class="card-text text-muted">Exclusive profile badge showing your support for community safety.</p>
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <span class="fw-bold"><i class="bi bi-coin text-warning"></i> 50</span>
                        <form action="${pageContext.request.contextPath}/users/redeem" method="POST">
                            <input type="hidden" name="cost" value="50">
                            <input type="hidden" name="rewardName" value="Safety Badge">
                            <button type="submit" class="btn btn-redeem">Redeem</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Transaction History Section -->
    <div class="mt-5 mb-5 p-4 rounded-4 shadow-sm" style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1);">
        <h4 class="mb-4">Transaction History <i class="bi bi-clock-history"></i></h4>
        <c:choose>
            <c:when test="${empty transactions}">
                <p class="text-muted">No recent transactions.</p>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-dark table-hover table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tx" items="${transactions}">
                                <tr>
                                    <td>
                                        <div class="small">${tx.transactionDate.toLocalDate()}</div>
                                        <div class="text-muted" style="font-size: 0.8em;">${tx.transactionDate.toLocalTime()}</div>
                                    </td>
                                    <td>${tx.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.type == 'CREDIT'}">
                                                <span class="badge bg-success">+ &#8377;${tx.amount}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">- &#8377;${tx.amount}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </div>
</div>
</body>
</html>
