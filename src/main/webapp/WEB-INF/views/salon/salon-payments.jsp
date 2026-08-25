<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payments & Payouts | Fight D Fear</title>

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

        .stat-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); text-align: center; }
        .stat-val { font-size: 2.2rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .stat-label { color: #6c757d; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; }

        .content-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); height: 100%; }
        .table-custom th { background: #f8f9fa; color: var(--brand-purple-darker); font-weight: 700; border-bottom: 2px solid #eee; text-transform: uppercase; font-size: 0.85rem; }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid #eee; color: #4a5568; }

        .btn-action { background: var(--gradient-primary); color: white; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; width: 100%; font-size: 1rem; }
        .btn-action:hover { filter: brightness(1.1); transform: translateY(-2px); }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="payments"/>
</jsp:include>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-800 text-purple m-0">Payments & Payouts</h2>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <!-- Financial Summary Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-success">₹${totalRevenue}</div><div class="stat-label">Total Revenue</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-danger">₹${totalExpenses}</div><div class="stat-label">Total Expenses</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-primary">₹${netProfit}</div><div class="stat-label">Net Profit</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-warning">₹${pendingPayouts}</div><div class="stat-label">Pending Payouts</div></div></div>
            </div>

            <div class="row g-4">
                <!-- Add Expense & Request Payout -->
                <div class="col-lg-4">
                    <div class="content-panel mb-4" style="height: auto;">
                        <h5 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-cart-dash me-2"></i> Record Expense</h5>
                        <form action="${pageContext.request.contextPath}/salon/payments/addExpense" method="POST">
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Category</label>
                                <select name="category" class="form-select rounded-pill">
                                    <option value="Supplies">Supplies & Inventory</option>
                                    <option value="Rent">Rent & Utilities</option>
                                    <option value="Marketing">Marketing</option>
                                    <option value="Salaries">Staff Salaries</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Description</label>
                                <input type="text" name="description" class="form-control rounded-pill" required>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Amount (₹)</label>
                                <input type="number" name="amount" class="form-control rounded-pill" step="0.01" required>
                            </div>
                            <div class="mb-4">
                                <label class="fw-bold mb-1">Date</label>
                                <input type="date" name="expenseDate" class="form-control rounded-pill" required>
                            </div>
                            <button type="submit" class="btn-action"><i class="bi bi-plus-circle me-2"></i> Add Expense</button>
                        </form>
                    </div>

                    <div class="content-panel" style="height: auto;">
                        <h5 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-bank me-2"></i> Request Payout</h5>
                        <form action="${pageContext.request.contextPath}/salon/payments/requestPayout" method="POST">
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Amount to withdraw (₹)</label>
                                <input type="number" name="amount" class="form-control rounded-pill" step="0.01" required>
                            </div>
                            <button type="submit" class="btn-action bg-dark text-white"><i class="bi bi-arrow-right-circle me-2"></i> Request Withdrawal</button>
                        </form>
                    </div>
                </div>

                <!-- History Tables -->
                <div class="col-lg-8">
                    <div class="content-panel mb-4" style="height: auto;">
                        <h5 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-clock-history me-2"></i> Expense History</h5>
                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Category</th>
                                        <th>Description</th>
                                        <th>Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="exp" items="${expenses}">
                                        <tr>
                                            <td>${exp.expenseDate}</td>
                                            <td><span class="badge bg-light text-dark border">${exp.category}</span></td>
                                            <td>${exp.description}</td>
                                            <td class="fw-bold text-danger">-₹${exp.amount}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty expenses}">
                                        <tr><td colspan="4" class="text-center text-muted py-4">No expenses recorded yet.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="content-panel" style="height: auto;">
                        <h5 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-list-check me-2"></i> Payout History</h5>
                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Ref ID</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="pay" items="${payouts}">
                                        <tr>
                                            <td>${pay.payoutDate}</td>
                                            <td>${pay.transactionReference}</td>
                                            <td class="fw-bold text-success">+₹${pay.amount}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pay.status == 'PENDING'}"><span class="badge bg-warning text-dark">PENDING</span></c:when>
                                                    <c:otherwise><span class="badge bg-success">${pay.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty payouts}">
                                        <tr><td colspan="4" class="text-center text-muted py-4">No payouts requested yet.</td></tr>
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

