<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loyalty Program | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }
        
        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
            .main-content { margin-left: var(--sidebar-width); }
        }

        .content-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); height: 100%; }
        .table-custom th { background: #f8f9fa; color: var(--brand-purple-darker); font-weight: 700; border-bottom: 2px solid #eee; text-transform: uppercase; font-size: 0.85rem; }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid #eee; color: #4a5568; }

        .btn-action { background: var(--gradient-primary); color: white; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; font-size: 1rem; }
        .btn-action:hover { filter: brightness(1.1); transform: translateY(-2px); }

        .form-switch .form-check-input { width: 3em; height: 1.5em; cursor: pointer; }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value=""/>
</jsp:include>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-800 text-purple m-0">Customer Loyalty Program</h2>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <div class="row g-4">
                <!-- Loyalty Settings Form -->
                <div class="col-lg-5">
                    <div class="content-panel" style="height: auto;">
                        <h4 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-gear-fill me-2"></i> Program Rules</h4>
                        
                        <form action="${pageContext.request.contextPath}/salon/loyalty/updateSettings" method="POST">
                            
                            <div class="form-check form-switch mb-4 pb-3 border-bottom">
                                <input class="form-check-input" type="checkbox" name="isActive" id="flexSwitchCheckDefault" ${settings.active ? 'checked' : ''}>
                                <label class="form-check-label ms-2 fw-bold" for="flexSwitchCheckDefault" style="margin-top: 3px;">Enable Loyalty Program</label>
                            </div>

                            <div class="mb-4">
                                <label class="fw-bold text-muted small text-uppercase mb-2">Points Earnings</label>
                                <div class="d-flex align-items-center gap-3">
                                    <span>Earn</span>
                                    <input type="number" name="pointsPerHundredSpent" class="form-control text-center fw-bold" value="${settings.pointsPerHundredSpent}" style="width: 80px;">
                                    <span>points for every <b>₹100</b> spent.</span>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="fw-bold text-muted small text-uppercase mb-2">Points Redemption Value</label>
                                <div class="d-flex align-items-center gap-3">
                                    <span>1 Point = <b>₹</b></span>
                                    <input type="number" name="pointValueInRupees" class="form-control text-center fw-bold" value="${settings.pointValueInRupees}" step="0.01" style="width: 100px;">
                                </div>
                                <div class="form-text mt-1">Example: 0.50 means 100 points = ₹50 discount.</div>
                            </div>

                            <div class="mb-4">
                                <label class="fw-bold text-muted small text-uppercase mb-2">Tier Thresholds (Points Required)</label>
                                <div class="row g-2">
                                    <div class="col-4">
                                        <label class="small text-muted mb-1"><i class="bi bi-award-fill text-secondary"></i> Silver</label>
                                        <input type="number" name="silverTierThreshold" class="form-control" value="${settings.silverTierThreshold}">
                                    </div>
                                    <div class="col-4">
                                        <label class="small text-muted mb-1"><i class="bi bi-award-fill text-warning"></i> Gold</label>
                                        <input type="number" name="goldTierThreshold" class="form-control" value="${settings.goldTierThreshold}">
                                    </div>
                                    <div class="col-4">
                                        <label class="small text-muted mb-1"><i class="bi bi-award-fill text-info"></i> Platinum</label>
                                        <input type="number" name="platinumTierThreshold" class="form-control" value="${settings.platinumTierThreshold}">
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn-action w-100"><i class="bi bi-save2 me-2"></i> Save Settings</button>
                        </form>
                    </div>
                </div>

                <!-- Customer Leaderboard -->
                <div class="col-lg-7">
                    <div class="content-panel" style="height: auto;">
                        <h4 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-people-fill me-2"></i> Top Loyalty Customers</h4>
                        
                        <c:if test="${not settings.active}">
                            <div class="alert alert-warning">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> The loyalty program is currently disabled. Customers will not earn points.
                            </div>
                        </c:if>

                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th>Customer</th>
                                        <th>Tier</th>
                                        <th>Lifetime Earned</th>
                                        <th>Available Balance</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}">
                                        <tr>
                                            <td class="fw-bold text-purple">
                                                ${customer.clientName}
                                                <div class="small fw-normal text-muted">${customer.clientPhone}</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${customer.currentTier == 'Platinum'}"><span class="badge bg-info text-white px-3 py-2"><i class="bi bi-award-fill me-1"></i> Platinum</span></c:when>
                                                    <c:when test="${customer.currentTier == 'Gold'}"><span class="badge bg-warning text-dark px-3 py-2"><i class="bi bi-award-fill me-1"></i> Gold</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary text-white px-3 py-2"><i class="bi bi-award-fill me-1"></i> Silver</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="fw-bold text-success">${customer.totalPointsEarned}</span> pts</td>
                                            <td><span class="fw-bold text-primary">${customer.currentPointsBalance}</span> pts</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty customers}">
                                        <tr><td colspan="4" class="text-center text-muted py-4">No customers have earned loyalty points yet.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

