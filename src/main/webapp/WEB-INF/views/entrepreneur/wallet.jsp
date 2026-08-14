<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wallet | Entrepreneur Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --rose-primary: #f43f5e;
            --rose-light: #fff1f2;
            --rose-hover: #e11d48;
        }
        body { font-family: 'Poppins', sans-serif; background-color: #f8fafc; }
        
        /* Sidebar Styles (matching dashboard) */
        #wrapper { display: flex; width: 100%; align-items: stretch; }
        #sidebar-wrapper {
            min-width: 280px; max-width: 280px; background: var(--navy-dark); color: #fff;
            min-height: 100vh; transition: all 0.3s ease-in-out;
            display: flex; flex-direction: column; position: sticky; top: 0; z-index: 1000;
        }
        .sidebar-heading {
            padding: 1.5rem 1.25rem; font-size: 1.5rem; font-weight: 800;
            background: rgba(0,0,0,0.1); border-bottom: 1px solid rgba(255,255,255,0.05);
            display: flex; align-items: center; gap: 12px;
        }
        .sidebar-heading i { color: var(--rose-primary); }
        .sidebar-link {
            padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none;
            display: flex; align-items: center; gap: 12px; font-weight: 500;
            transition: all 0.2s ease; margin: 4px 12px; border-radius: 8px;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background: rgba(244, 63, 94, 0.1); color: var(--rose-primary);
        }
        .sidebar-link i { font-size: 1.1rem; }
        
        /* Main Content */
        #page-content-wrapper { flex-grow: 1; padding: 20px; background: #f8fafc; width: 100%; }
        .content-card {
            background: white; border-radius: 16px; border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03); padding: 30px; margin-top: 20px;
        }
        
        .wallet-card {
            background: linear-gradient(135deg, var(--navy-dark), #312e81);
            color: white; border-radius: 16px; padding: 30px; margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(30, 27, 75, 0.2);
            position: relative; overflow: hidden;
        }
        .wallet-card::after {
            content: ''; position: absolute; top: -50%; right: -20%;
            width: 300px; height: 300px; background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }
    </style>
</head>
<body>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3 d-flex flex-column" style="flex: 1;">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link">
                <i class="bi bi-file-earmark-plus"></i> Create Proposal
            </a>
            
            <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="sidebar-link">
                <i class="bi bi-calendar-check"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="sidebar-link active">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light rounded-pill mx-3 mt-4 mb-3 text-start" style="font-size: 0.9rem; padding: 10px 15px;">
                <i class="bi bi-house-door me-2"></i> Back to Main Site
            </a>
        </div>
        
        <div class="p-3 border-top border-secondary">
            <div class="d-flex align-items-center mb-3">
                <div class="rounded-circle bg-light text-dark d-flex justify-content-center align-items-center fw-bold me-3" style="width: 45px; height: 45px; font-size: 1.2rem;">
                    ${fn:substring(loggedEntrepreneur.fullName, 0, 1)}
                </div>
                <div>
                    <div class="fw-bold text-white">${loggedEntrepreneur.fullName}</div>
                    <div class="small text-white-50 text-truncate" style="max-width: 150px;">${loggedEntrepreneur.email}</div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger w-100 fw-bold rounded-pill">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid py-4">
            <h2 class="fw-bold mb-4" style="color: var(--navy-dark);">Wallet & Payouts</h2>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="wallet-card">
                        <h5 class="fw-normal mb-1 opacity-75">Available Balance</h5>
                        <h1 class="fw-bold mb-4 display-4">Rs. ${loggedEntrepreneur.payoutBalance != null ? loggedEntrepreneur.payoutBalance : 0.0}</h1>
                        <p class="mb-0 small opacity-75"><i class="bi bi-info-circle me-1"></i> Balance can be requested for payout.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="content-card h-100 mt-0 d-flex flex-column justify-content-center align-items-center">
                        <i class="bi bi-cash-stack text-success mb-3" style="font-size: 3rem;"></i>
                        <h4 class="fw-bold">Request Payout</h4>
                        <p class="text-muted text-center mb-4">Transfer your available balance to your registered bank account or UPI ID.</p>
                        
                        <button class="btn btn-success rounded-pill px-4" disabled>
                            <i class="bi bi-bank"></i> Request Transfer
                        </button>
                        <small class="text-muted mt-2 d-block">Payouts will be enabled once your balance reaches the minimum threshold.</small>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
