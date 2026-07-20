<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Payments | Fight D Fear</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-red: #E11D48;
            --primary-purple: #1e1b4b;
            --primary-dark: #0F172A;
            --bg-light: #F8FAFC;
            --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #1E293B;
            margin: 0;
            display: flex;
        }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--primary-dark);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            padding: 24px;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-logo { display: flex; align-items: center; gap: 12px; margin-bottom: 40px; }
        .sidebar-logo span { font-weight: 800; font-size: 1.25rem; letter-spacing: -0.5px; }

        .nav-menu { list-style: none; padding: 0; margin: 0; }
        .nav-item { margin-bottom: 8px; }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #94A3B8;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-link:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .nav-link.active { background: var(--primary-red); color: white; box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3); }

        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 32px;
            min-height: 100vh;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .payment-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            border: 1px solid #F1F5F9;
            box-shadow: var(--card-shadow);
            height: 100%;
        }

        .stat-label { font-size: 0.75rem; color: #64748B; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; display: block; }
        .stat-value { font-size: 1.75rem; font-weight: 800; color: #1E293B; }

        .history-card {
            background: white;
            border-radius: 24px;
            border: 1px solid #F1F5F9;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-top: 32px;
        }

        .card-header {
            padding: 20px 24px;
            background: white;
            border-bottom: 1px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-custom { margin: 0; }
        .table-custom thead th {
            background: #F8FAFC;
            padding: 16px 24px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748B;
            text-transform: uppercase;
            border-bottom: 1px solid #F1F5F9;
        }
        .table-custom tbody td {
            padding: 16px 24px;
            vertical-align: middle;
            border-bottom: 1px solid #F1F5F9;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status-success { background: #DCFCE7; color: #166534; }
        .status-failed { background: #FEE2E2; color: #991B1B; }

        .btn-back {
            background: white;
            border: 1px solid #E2E8F0;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            color: #64748B;
            text-decoration: none;
            transition: var(--transition);
        }
        .btn-back:hover { border-color: var(--primary-red); color: var(--primary-red); }

        #loading-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: white;
            display: flex; align-items: center; justify-content: center;
            z-index: 2000;
        }
    </style>
</head>
<body>

    <div id="loading-overlay">
        <div class="text-center">
            <i class="fas fa-spinner fa-spin fa-3x text-danger mb-3"></i>
            <p class="fw-bold">Loading Payment History...</p>
        </div>
    </div>

    <aside class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-hand-fist fa-2x text-danger"></i>
            <span>Fight D Fear</span>
        </div>
        <ul class="nav-menu">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link"><i class="bi bi-grid"></i> Dashboard</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/users/training-journey" class="nav-link"><i class="bi bi-compass"></i> My Journey</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/attendance/my-attendance" class="nav-link"><i class="bi bi-calendar-check"></i> Attendance</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link"><i class="bi bi-clock-history"></i> My Schedule</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/payment/users/my-payments" class="nav-link active"><i class="bi bi-wallet2"></i> Payments</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link"><i class="bi bi-person"></i> Profile</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h2 style="font-weight: 800; color: var(--primary-purple); margin: 0;">My Payments</h2>
                <p class="text-muted mb-0">Track your billing and transaction history.</p>
            </div>
            <a href="${pageContext.request.contextPath}/users/training-journey" class="btn-back">
                <i class="bi bi-arrow-left me-2"></i>Back to Journey
            </a>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="payment-card">
                    <span class="stat-label">Total Paid</span>
                    <div class="stat-value text-success" id="totalPaid">₹0.00</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="payment-card">
                    <span class="stat-label">Pending Balance</span>
                    <div class="stat-value text-danger" id="pendingAmount">₹0.00</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="payment-card">
                    <span class="stat-label">Next Due Date</span>
                    <div class="stat-value" id="nextDueDate">--</div>
                </div>
            </div>
        </div>

        <div class="history-card">
            <div class="card-header">
                <i class="bi bi-clock-history fs-5 text-danger"></i>
                <h5 class="mb-0 fw-bold">Transaction History</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-custom">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Description</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="transaction-body">
                        <!-- Loaded via JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            const apiUrl = '${pageContext.request.contextPath}/payment/api/payments/my-payments';
            
            $.ajax({
                url: apiUrl,
                method: 'GET',
                success: function(data) {
                    $('#totalPaid').text('₹' + data.totalPaid.toLocaleString());
                    $('#pendingAmount').text('₹' + data.pendingAmount.toLocaleString());
                    $('#nextDueDate').text(data.nextDueDate);

                    const tbody = $('#transaction-body');
                    tbody.empty();

                    if (data.transactions && data.transactions.length > 0) {
                        data.transactions.forEach(t => {
                            const statusClass = t.status === 'Success' ? 'status-success' : 'status-failed';
                            tbody.append(`
                                <tr>
                                    <td class="text-muted small">${t.date}</td>
                                    <td class="fw-bold">${t.description}</td>
                                    <td class="fw-extrabold">₹${t.amount.toLocaleString()}</td>
                                    <td><span class="status-badge ${statusClass}">${t.status}</span></td>
                                </tr>
                            `);
                        });
                    } else {
                        tbody.append('<tr><td colspan="4" class="text-center py-5 text-muted">No transactions found.</td></tr>');
                    }
                },
                error: function(xhr) {
                    console.error("Payment API Error:", xhr);
                    $('#transaction-body').append('<tr><td colspan="4" class="text-center py-5 text-danger">Failed to load payment history.</td></tr>');
                },
                complete: function() {
                    $('#loading-overlay').fadeOut();
                }
            });
        });
    </script>
</body>
</html>

