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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/wallet-theme.css" rel="stylesheet">
</head>
<body class="wallet-page-shell fdf-page-shell">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<c:set var="userCoins" value="${user.rewardPoints != null ? user.rewardPoints : 0}" />
<c:set var="userCash" value="${user.walletBalance != null ? user.walletBalance : 0.0}" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper">

        <main class="fdf-page-main wallet-page">
            <div class="wallet-container">

                <!-- Wallet Summary Card -->
                <section class="wallet-summary-card" aria-label="Wallet balances">
                    <div class="wallet-summary-glow"></div>
                    <div class="wallet-summary-glow wallet-summary-glow--left"></div>
                    <div class="wallet-summary-grid">
                        <div class="wallet-balance-block wallet-balance-block--coins">
                            <p class="wallet-balance-label">
                                <i class="bi bi-coin" aria-hidden="true"></i>
                                Coin Balance
                            </p>
                            <div class="wallet-balance-value">
                                <i class="bi bi-coin coin-icon-gold" aria-hidden="true"></i>
                                <span id="current-coins" class="wallet-coins-value">${userCoins}</span>
                            </div>
                            <p class="wallet-balance-hint">Keep watching Reels to earn more coins!</p>
                        </div>
                        <div class="wallet-balance-block wallet-balance-block--cash">
                            <p class="wallet-balance-label">
                                <i class="bi bi-wallet2" aria-hidden="true"></i>
                                Cash Balance (&#8377;)
                            </p>
                            <div class="wallet-balance-value">
                                <i class="bi bi-wallet2 coin-icon-gold" aria-hidden="true"></i>
                                <span id="current-cash" class="${userCash < 0 ? 'wallet-cash-value--negative' : ''}">${userCash}</span>
                            </div>
                            <p class="wallet-balance-hint">Earnings from your bookings</p>
                        </div>
                    </div>
                </section>

                <!-- Redeem Rewards Hero -->
                <section class="wallet-redeem-hero">
                    <div class="wallet-redeem-hero-orb"></div>
                    <div class="wallet-redeem-hero-inner">
                        <div class="wallet-redeem-icon-wrap" aria-hidden="true">
                            <i class="bi bi-gift"></i>
                        </div>
                        <div>
                            <h1 class="wallet-redeem-title fdf-page-title">REDEEM REWARDS</h1>
                            <p class="wallet-redeem-subtitle fdf-page-subtitle">Unlock exclusive benefits with your earned coins</p>
                        </div>
                    </div>
                </section>

                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show wallet-alert" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show wallet-alert" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty coupon}">
                    <div class="coupon-box">
                        <h5>&#127873; Your Reward Coupon!</h5>
                        <p>Use this code to redeem your reward:</p>
                        <div class="coupon-code">${coupon}</div>
                        <p class="small mt-2">Take a screenshot or copy this code.</p>
                    </div>
                </c:if>

                <h4 class="wallet-section-title">Redeem Rewards &#127873;</h4>
                <div class="row wallet-rewards-grid">
                    <div class="col-md-4 d-flex">
                        <div class="card reward-card w-100">
                            <div class="card-body">
                                <div class="reward-card-icon" aria-hidden="true">
                                    <i class="bi bi-scissors"></i>
                                </div>
                                <h5 class="card-title">10% Salon Discount</h5>
                                <p class="card-text">Get 10% off on any salon service of your choice.</p>
                                <div class="reward-card-footer">
                                    <span class="coin-badge"><i class="bi bi-coin"></i> 100</span>
                                    <form action="${pageContext.request.contextPath}/users/redeem" method="POST">
                                        <input type="hidden" name="cost" value="100">
                                        <input type="hidden" name="rewardName" value="10% Salon Discount">
                                        <button type="submit" class="btn btn-redeem">Redeem</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex">
                        <div class="card reward-card w-100">
                            <div class="card-body">
                                <div class="reward-card-icon" aria-hidden="true">
                                    <i class="bi bi-shield-fill-check"></i>
                                </div>
                                <h5 class="card-title">Free Martial Arts Class</h5>
                                <p class="card-text">One free trial session at any registered Martial Arts Centre.</p>
                                <div class="reward-card-footer">
                                    <span class="coin-badge"><i class="bi bi-coin"></i> 200</span>
                                    <form action="${pageContext.request.contextPath}/users/redeem" method="POST">
                                        <input type="hidden" name="cost" value="200">
                                        <input type="hidden" name="rewardName" value="Free Martial Arts Class">
                                        <button type="submit" class="btn btn-redeem">Redeem</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex">
                        <div class="card reward-card w-100">
                            <div class="card-body">
                                <div class="reward-card-icon" aria-hidden="true">
                                    <i class="bi bi-award"></i>
                                </div>
                                <h5 class="card-title">Safety Badge</h5>
                                <p class="card-text">Exclusive profile badge showing your support for community safety.</p>
                                <div class="reward-card-footer">
                                    <span class="coin-badge"><i class="bi bi-coin"></i> 50</span>
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

                <!-- Transaction History -->
                <section class="wallet-transactions">
                    <div class="wallet-transactions-header">
                        <i class="bi bi-clock-history" aria-hidden="true"></i>
                        <h4>Transaction History</h4>
                    </div>
                    <c:choose>
                        <c:when test="${empty transactions}">
                            <div class="wallet-empty-state">
                                <i class="bi bi-inbox" aria-hidden="true"></i>
                                <p>No recent transactions.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
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
                </section>

            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </div>
</div>
</body>
</html>
