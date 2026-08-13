<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrepreneur Dashboard — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --navy-light: #312e81;
            --primary: #f43f5e;
            --primary-hover: #e11d48;
            --bg-light: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        #sidebar-wrapper {
            min-width: 260px;
            max-width: 260px;
            background: var(--navy-dark);
            color: white;
            min-height: 100vh;
            border-top-right-radius: 40px;
            padding-top: 30px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
        }

        .sidebar-heading {
            padding: 10px 25px 25px;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: white;
            background: rgba(255,255,255,0.05);
            border-left-color: var(--primary);
        }

        #page-content-wrapper {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
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

        .btn-custom {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-custom:hover {
            background-color: var(--primary-hover);
            color: white;
            transform: translateY(-2px);
        }

        .progress {
            height: 10px;
            border-radius: 10px;
        }

        .badge-premium {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1e1b4b;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            #wrapper {
                flex-direction: column !important;
            }
            #sidebar-wrapper {
                min-width: 100% !important;
                max-width: 100% !important;
                min-height: auto !important;
                border-top-right-radius: 0 !important;
                border-bottom-left-radius: 20px !important;
                border-bottom-right-radius: 20px !important;
                padding: 20px 15px !important;
            }
            #sidebar-wrapper .mt-3 {
                display: flex !important;
                flex-wrap: wrap !important;
                gap: 10px !important;
                margin-top: 10px !important;
            }
            .sidebar-link {
                padding: 10px 15px !important;
                border-radius: 30px !important;
                border-left: none !important;
                background: rgba(255, 255, 255, 0.05) !important;
                display: inline-flex !important;
                white-space: nowrap !important;
            }
            .sidebar-link:hover, .sidebar-link.active {
                border-left-color: transparent !important;
                background: var(--primary) !important;
            }
            #page-content-wrapper {
                padding: 20px 10px !important;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link">
                <i class="bi bi-file-earmark-plus"></i> Create Proposal
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-5">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold" style="color: var(--navy-dark);">Hello, ${entrepreneur.fullName}!</h2>
                    <p class="text-muted">Manage your business projects and engage with interested funding entities.</p>
                </div>
                <button onclick="location.reload()" class="btn btn-outline-secondary rounded-pill btn-sm">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                    <i class="bi bi-check-circle-fill"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Verification Banner (Revenue Model) -->
            <c:if test="${not entrepreneur.verificationFeePaid}">
                <div class="card border-warning mb-4 shadow-sm" style="border-radius:15px; background-color:#fffdf5;">
                    <div class="card-body d-flex flex-column flex-md-row justify-content-between align-items-md-center p-4">
                        <div>
                            <h5 class="fw-bold text-warning-emphasis"><i class="bi bi-shield-exclamation"></i> Business Profile Unverified</h5>
                            <p class="text-secondary mb-md-0" style="font-size:0.95rem;">
                                Pay the one-time **Business Verification Fee of ₹499** to get verified by the FightDFire Admin. Verified profiles get 5x more visibility from banks, angels, and NGOs.
                            </p>
                        </div>
                        <button class="btn btn-warning fw-bold px-4 py-2 mt-3 mt-md-0 rounded-pill shadow-sm" onclick="triggerCheckout('verification', null, 499.00, '${pageContext.request.contextPath}/entrepreneur/pay-verification')">
                            Verify Now (₹499)
                        </button>
                    </div>
                </div>
            </c:if>

            <!-- Stats grid -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #e0f2fe; color: #0284c7;">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <div class="fs-3 fw-bold">₹${totalRequested}</div>
                        <p class="text-muted m-0 small">Total Funding Requested</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #dcfce7; color: #16a34a;">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <div class="fs-3 fw-bold">₹${totalRaised}</div>
                        <p class="text-muted m-0 small">Total Raised from Investors</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #fef2f2; color: #ef4444;">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <div class="fs-3 fw-bold">₹${remaining > 0 ? remaining : 0}</div>
                        <p class="text-muted m-0 small">Remaining Funding Needed</p>
                    </div>
                </div>
            </div>

            <!-- Main Content & Sidebar Layout -->
            <div class="row g-4">
                <!-- Left Column: Proposals and Investors -->
                <div class="col-lg-8">
                    <!-- Proposals Section -->
                    <div class="panel mb-4">
                        <h3 class="panel-title">My Business Proposals</h3>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle" style="font-size:0.9rem;">
                                <thead>
                                    <tr>
                                        <th>Proposal Details</th>
                                        <th>Goal / Raised</th>
                                        <th>Status</th>
                                        <th>Upgrade</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="proposal" items="${proposals}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy">${proposal.title}</div>
                                                <div class="text-muted small">${proposal.category} | ${proposal.location}</div>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-between small text-muted mb-1" style="font-size:0.75rem;">
                                                    <span>₹${proposal.amountRaised} raised</span>
                                                    <span>₹${proposal.fundingNeeded} target</span>
                                                </div>
                                                <div class="progress" style="height:6px;">
                                                    <div class="progress-bar bg-success" role="progressbar" style="width: ${(proposal.amountRaised/proposal.fundingNeeded)*100}%;"></div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${proposal.status == 'VERIFIED'}">
                                                        <span class="badge bg-success rounded-pill px-2 py-1" style="font-size:0.7rem;"><i class="bi bi-check-circle"></i> Live</span>
                                                    </c:when>
                                                    <c:when test="${proposal.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark rounded-pill px-2 py-1" style="font-size:0.7rem;"><i class="bi bi-hourglass-split"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger rounded-pill px-2 py-1" style="font-size:0.7rem;"><i class="bi bi-x-circle"></i> Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-column gap-1">
                                                    <c:if test="${not proposal.premium}">
                                                        <button class="btn btn-outline-secondary btn-xs rounded-pill" style="font-size:0.75rem; padding: 2px 8px;" onclick="triggerCheckout('premium', ${proposal.id}, 999.00, '${pageContext.request.contextPath}/entrepreneur/proposal/premium/${proposal.id}')">
                                                            Premium (₹999)
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${not proposal.featured}">
                                                        <button class="btn btn-outline-secondary btn-xs rounded-pill" style="font-size:0.75rem; padding: 2px 8px;" onclick="triggerCheckout('featured', ${proposal.id}, 999.00, '${pageContext.request.contextPath}/entrepreneur/proposal/featured/${proposal.id}')">
                                                            Feature (₹999)
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${proposal.premium && proposal.featured}">
                                                        <span class="badge bg-info text-dark rounded-pill" style="font-size:0.75rem; font-weight:600;">Fully Upgraded</span>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty proposals}">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted py-4">No proposals submitted. Click "New Proposal" to get started!</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Interested Funding Entities -->
                    <div class="panel">
                        <h3 class="panel-title">Interested Funding Entities</h3>
                        <div class="list-group list-group-flush">
                            <c:forEach var="inv" items="${interestedInvestors}">
                                <div class="list-group-item d-flex justify-content-between align-items-center py-3 border-0 border-bottom">
                                    <div class="d-flex align-items-center gap-3">
                                        <c:choose>
                                            <c:when test="${not empty inv.profilePhoto}">
                                                <img src="${pageContext.request.contextPath}${inv.profilePhoto}" alt="Photo" class="rounded-circle border" style="width:45px; height:45px; object-fit:cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle border d-flex align-items-center justify-content-center bg-secondary-subtle text-secondary" style="width:45px; height:45px; font-weight: 700;">
                                                    ${inv.fullName.substring(0,1).toUpperCase()}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <div class="fw-bold">${inv.fullName}</div>
                                            <div class="text-muted small">${inv.companyName} | Budget: ${inv.budgetRange}</div>
                                        </div>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <c:forEach var="prop" items="${proposals}">
                                            <a href="${pageContext.request.contextPath}/entrepreneur/chat/${inv.id}?proposalId=${prop.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                <i class="bi bi-chat-dots"></i> Chat
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty interestedInvestors}">
                                <div class="text-center text-muted py-4">No interested investors yet. Your proposals will attract partners once verified!</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Sidebar Actions (Meetings, Q&A, Commissions) -->
                <div class="col-lg-4">
                    <!-- Meeting Schedule -->
                    <div class="card border-0 shadow-sm p-4 position-relative mb-4" style="border-radius:16px; background-color:#ffffff; border: 1px solid rgba(0,0,0,0.03);">
                        <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-calendar-check-fill"></i> Consultation Meetings</h5>
                        <div style="max-height: 350px; overflow-y: auto;">
                            <c:forEach var="meeting" items="${meetings}">
                                <div class="border-bottom py-3" style="font-size: 0.85rem;">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="fw-bold text-navy">${meeting.investor.fullName}</span>
                                        <c:choose>
                                            <c:when test="${meeting.status == 'ACCEPTED'}">
                                                <span class="badge bg-success-subtle text-success rounded-pill px-2">Accepted</span>
                                            </c:when>
                                            <c:when test="${meeting.status == 'REJECTED'}">
                                                <span class="badge bg-danger-subtle text-danger rounded-pill px-2">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning rounded-pill px-2">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="text-secondary small mb-2">
                                        <strong>Time:</strong> ${meeting.meetingTime}<br>
                                        <strong>Link:</strong> <span class="text-truncate d-inline-block" style="max-width:150px;">${meeting.location}</span><br>
                                        <strong>Notes:</strong> ${meeting.notes}
                                    </div>
                                    <c:if test="${meeting.status == 'PENDING'}">
                                        <div class="d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/entrepreneur/meetings/${meeting.id}/accept" method="post" class="d-inline">
                                                <button type="submit" class="btn btn-success btn-xs rounded-pill px-3 py-1" style="font-size:0.75rem;">Accept</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/entrepreneur/meetings/${meeting.id}/reject" method="post" class="d-inline">
                                                <button type="submit" class="btn btn-danger btn-xs rounded-pill px-3 py-1" style="font-size:0.75rem;">Decline</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                            <c:if test="${empty meetings}">
                                <div class="text-center text-muted small py-3">No meetings scheduled.</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Q&A Board -->
                    <div class="card border-0 shadow-sm p-4 position-relative mb-4" style="border-radius:16px; background-color:#ffffff; border: 1px solid rgba(0,0,0,0.03);">
                        <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-question-square-fill"></i> Investor Q&A Board</h5>
                        <div style="max-height: 350px; overflow-y: auto;">
                            <c:forEach var="q" items="${questions}">
                                <div class="border-bottom py-2" style="font-size: 0.85rem;">
                                    <div class="fw-bold text-navy small mb-1">Question from ${q.investor.fullName} (on ${q.proposal.title}):</div>
                                    <p class="text-secondary mb-2">"${q.question}"</p>
                                    
                                    <c:choose>
                                        <c:when test="${not empty q.answer}">
                                            <div class="bg-light p-2 rounded small border-start border-success border-3">
                                                <span class="fw-semibold text-success">Your Answer:</span>
                                                <span class="text-secondary">"${q.answer}"</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/entrepreneur/questions/${q.id}/answer" method="post">
                                                <div class="input-group input-group-sm">
                                                    <input type="text" name="answer" class="form-control" placeholder="Write reply..." required>
                                                    <button class="btn btn-primary" type="submit">Reply</button>
                                                </div>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                            <c:if test="${empty questions}">
                                <div class="text-center text-muted small py-3">No questions asked yet.</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Platform Commissions -->
                    <div class="card border-0 shadow-sm p-4 position-relative" style="border-radius:16px; background-color:#ffffff; border: 1px solid rgba(0,0,0,0.03);">
                        <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-wallet2"></i> Platform Commissions</h5>
                        <div style="max-height: 250px; overflow-y: auto;">
                            <c:forEach var="inv" items="${investments}">
                                <div class="border-bottom py-2 d-flex justify-content-between align-items-center" style="font-size:0.85rem;">
                                    <div>
                                        <div class="fw-bold">₹${inv.amount} Investment (${inv.status})</div>
                                        <c:if test="${inv.status == 'COMPLETED'}">
                                            <div class="text-muted small" style="font-size: 0.75rem;">
                                                Released: ₹${inv.releasedAmount != null ? inv.releasedAmount : inv.amount} 
                                                <c:if test="${inv.adminAmount != null && inv.adminAmount > 0}">
                                                    (Retained: ₹${inv.adminAmount})
                                                </c:if>
                                            </div>
                                        </c:if>
                                        <div class="text-muted small">Fee (2%): **₹${(inv.releasedAmount != null ? inv.releasedAmount : inv.amount) * 0.02}**</div>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${inv.commissionPaid}">
                                                <span class="badge bg-success-subtle text-success rounded-pill px-2">Paid</span>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline-danger btn-xs rounded-pill" style="font-size:0.75rem; padding: 2px 8px;" onclick="triggerCheckout('commission', ${inv.id}, ${(inv.releasedAmount != null ? inv.releasedAmount : inv.amount) * 0.02}, '${pageContext.request.contextPath}/entrepreneur/commission/pay/${inv.id}')">
                                                    Pay
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty investments}">
                                <div class="text-center text-muted small py-3">No commissions to pay yet.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- MOCK CHECKOUT MODAL (Simulated Razorpay) -->
<div class="modal fade" id="mockCheckoutModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" style="z-index: 2000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <!-- Header -->
            <div class="modal-header bg-dark text-white border-0 py-3" style="border-top-left-radius: 20px; border-top-right-radius: 20px;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-fill-check text-success fs-3"></i>
                    <div>
                        <h6 class="modal-title fw-bold m-0" style="letter-spacing:1px;">RAZORPAY CHECKOUT</h6>
                        <span class="text-muted small" style="font-size:10px;">Test Mode</span>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" id="checkoutCloseBtn"></button>
            </div>
            <!-- Body -->
            <div class="modal-body p-4 text-center">
                <div class="mb-4">
                    <p class="text-muted mb-1 text-uppercase fw-semibold" style="font-size: 11px;" id="checkoutTypeLabel">Service Payment</p>
                    <h3 class="fw-bold" style="color:var(--navy-dark);" id="checkoutAmountLabel">₹0.00</h3>
                </div>

                <!-- Simulation content -->
                <div id="checkoutFormContent">
                    <div class="p-3 border rounded-3 text-start bg-light mb-4" style="font-size:0.9rem;">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Platform:</span>
                            <span class="fw-bold text-navy">FightDFire Investment</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Beneficiary:</span>
                            <span class="fw-bold text-navy">Platform Admin Account</span>
                        </div>
                    </div>
                    
                    <button class="btn btn-primary w-100 rounded-pill py-3 fw-bold" onclick="simulatePaymentProcessing()">
                        Pay Securely with Simulated Card
                    </button>
                </div>

                <!-- Loading screen -->
                <div id="checkoutLoadingContent" style="display:none;" class="py-4">
                    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5 class="fw-bold text-success mt-4">Processing Simulated Payment...</h5>
                    <p class="text-muted small">Please do not refresh or close this dialog.</p>
                </div>

                <!-- Success Screen -->
                <div id="checkoutSuccessContent" style="display:none;" class="py-4">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-success mt-4">Payment Successful!</h5>
                    <p class="text-muted small">Updating platform status...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    let activeCheckoutForm = null;

    function triggerCheckout(type, id, amount, targetUrl) {
        // Build checkout form dynamically
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = targetUrl;
        
        activeCheckoutForm = form;
        document.body.appendChild(form);

        // Update modal UI
        document.getElementById('checkoutTypeLabel').innerText = type.toUpperCase() + " PAYMENT";
        document.getElementById('checkoutAmountLabel').innerText = "₹" + amount.toFixed(2);

        // Reset Modal states
        document.getElementById('checkoutFormContent').style.display = 'block';
        document.getElementById('checkoutLoadingContent').style.display = 'none';
        document.getElementById('checkoutSuccessContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'block';

        // Show Modal
        const modal = new bootstrap.Modal(document.getElementById('mockCheckoutModal'));
        modal.show();
    }

    function simulatePaymentProcessing() {
        document.getElementById('checkoutFormContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'none';
        document.getElementById('checkoutLoadingContent').style.display = 'block';

        setTimeout(() => {
            document.getElementById('checkoutLoadingContent').style.display = 'none';
            document.getElementById('checkoutSuccessContent').style.display = 'block';

            setTimeout(() => {
                if (activeCheckoutForm) {
                    activeCheckoutForm.submit();
                }
            }, 1000);
        }, 1500);
    }
</script>
</body>
</html>
