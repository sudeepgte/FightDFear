<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platform Revenue Analytics — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --navy-light: #312e81;
            --primary: #f43f5e;
            --bg-light: #f4f6fa;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
        }

        .container {
            max-width: 1000px;
            margin-top: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            text-align: center;
        }

        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 12px;
        }

        .panel {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            margin-bottom: 30px;
        }

        .panel-title {
            font-weight: 700;
            color: var(--navy-dark);
            margin-bottom: 25px;
            font-size: 1.2rem;
            border-left: 4px solid var(--primary);
            padding-left: 12px;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold" style="color: var(--navy-dark);"><i class="bi bi-graph-up-arrow text-success"></i> Platform Revenue Desk</h2>
            <p class="text-muted">Overview of platform commissions, verification fees, and premium listings.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-outline-secondary rounded-pill btn-sm">
            <i class="bi bi-chevron-left"></i> Admin Dashboard
        </a>
    </div>

    <!-- Stats summary card -->
    <div class="card border-0 shadow-sm p-4 mb-4 bg-dark text-white text-center" style="border-radius: 20px; background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);">
        <p class="text-white-50 text-uppercase fw-semibold mb-1" style="font-size: 0.8rem; letter-spacing: 1px;">Total Investment Platform Revenue</p>
        <h1 class="fw-bold display-4 text-warning">₹${totalRevenue}</h1>
    </div>

    <!-- Breakdown Grid -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #fee2e2; color: #ef4444;"><i class="bi bi-shield-check"></i></div>
                <div class="fs-4 fw-bold">₹${verificationFees}</div>
                <p class="text-muted small m-0">Verification Fees</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #e0f2fe; color: #0ea5e9;"><i class="bi bi-award"></i></div>
                <div class="fs-4 fw-bold">₹${premiumListingFees}</div>
                <p class="text-muted small m-0">Premium Listings</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #fef3c7; color: #d97706;"><i class="bi bi-star"></i></div>
                <div class="fs-4 fw-bold">₹${featuredListingFees}</div>
                <p class="text-muted small m-0">Featured Pins</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #dcfce7; color: #16a34a;"><i class="bi bi-percent"></i></div>
                <div class="fs-4 fw-bold">₹${platformCommissions}</div>
                <p class="text-muted small m-0">Platform Commissions</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #f3e8ff; color: #a855f7;"><i class="bi bi-person-fill-check"></i></div>
                <div class="fs-4 fw-bold">₹${subscriptionFees}</div>
                <p class="text-muted small m-0">Investor Subscriptions</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background-color: #ffedd5; color: #ea580c;"><i class="bi bi-bank"></i></div>
                <div class="fs-4 fw-bold">₹${adminRetainedAmount}</div>
                <p class="text-muted small m-0">Admin Retained Funds</p>
            </div>
        </div>
    </div>

    <!-- Investments Commission Tracker -->
    <div class="panel">
        <h3 class="panel-title">Funded Transactions & Commissions (2% Platform Commission)</h3>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>Proposal Title</th>
                        <th>Investor</th>
                        <th>Entrepreneur</th>
                        <th>Gateway Total</th>
                        <th>Released</th>
                        <th>Retained</th>
                        <th>Commission Fee (2%)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${investments}">
                        <tr>
                            <td><strong>${inv.proposal.title}</strong></td>
                            <td>${inv.investor.fullName}</td>
                            <td>${inv.proposal.entrepreneur.fullName}</td>
                            <td>₹${inv.amount}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.status == 'COMPLETED'}">
                                        ₹${inv.releasedAmount != null ? inv.releasedAmount : inv.amount}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">₹0 (Pending)</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.status == 'COMPLETED'}">
                                        ₹${inv.adminAmount != null ? inv.adminAmount : 0.0}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">₹0 (Pending)</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong class="text-success">₹${(inv.releasedAmount != null ? inv.releasedAmount : inv.amount) * 0.02}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.commissionPaid}">
                                        <span class="badge bg-success rounded-pill px-3"><i class="bi bi-check-circle-fill"></i> Paid</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark rounded-pill px-3"><i class="bi bi-hourglass-split"></i> Awaiting Payout</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty investments}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">No completed investments recorded.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
