<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investor Dashboard — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #0f172a;
            --navy-light: #1e1b4b;
            --primary: #312e81;
            --coral: #f43f5e;
            --coral-hover: #e11d48;
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
            border-left-color: var(--coral);
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
                background: var(--coral) !important;
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
            <i class="bi bi-wallet2"></i> Investor Panel
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link">
                <i class="bi bi-shop"></i> Marketplace
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
                    <h2 class="fw-bold" style="color: var(--navy-dark);">Welcome Back, ${investor.fullName}!</h2>
                    <p class="text-muted">Browse business opportunities and manage your investment portfolios.</p>
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

            <!-- Investor Subscription Premium Offer (Revenue Model) -->
            <c:if test="${not investor.subscribed}">
                <div class="card border-primary mb-4 shadow-sm" style="border-radius:15px; background-color:#f8faff;">
                    <div class="card-body d-flex flex-column flex-md-row justify-content-between align-items-md-center p-4">
                        <div>
                            <h5 class="fw-bold text-primary-emphasis"><i class="bi bi-star-fill text-warning"></i> Access Premium Investment Flows</h5>
                            <p class="text-secondary mb-md-0" style="font-size:0.95rem;">
                                Subscribe to our **Premium Investor Plan for ₹1999/yr** to unlock direct meeting scheduling, Q&A boards, and chat with entrepreneurs.
                            </p>
                        </div>
                        <button class="btn btn-primary fw-bold px-4 py-2 mt-3 mt-md-0 rounded-pill shadow-sm" onclick="triggerCheckout('subscription', null, 1999.00, '${pageContext.request.contextPath}/investor/subscribe')">
                            Subscribe Now (₹1999)
                        </button>
                    </div>
                </div>
            </c:if>

            <!-- Stats grid -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #e0f2fe; color: #0284c7;">
                            <i class="bi bi-safe-fill"></i>
                        </div>
                        <div class="fs-3 fw-bold">₹${totalInvested}</div>
                        <p class="text-muted m-0 small">Total Capital Invested</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #dcfce7; color: #16a34a;">
                            <i class="bi bi-graph-up"></i>
                        </div>
                        <div class="fs-3 fw-bold">₹${estimatedMonthlyROI}</div>
                        <p class="text-muted m-0 small">Estimated Monthly Income (ROI)</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #f3e8ff; color: #a855f7;">
                            <i class="bi bi-building-fill"></i>
                        </div>
                        <div class="fs-3 fw-bold">${investments.size()}</div>
                        <p class="text-muted m-0 small">Businesses Funded</p>
                    </div>
                </div>
            </div>

            <!-- Investment Portfolio Table -->
            <div class="panel">
                <h3 class="panel-title">My Investments Portfolio</h3>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Business Name</th>
                                <th>Category / Location</th>
                                <th>Amount Invested</th>
                                <th>Target Goal</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inv" items="${investments}">
                                <tr>
                                    <td><strong class="text-navy">${inv.proposal.title}</strong></td>
                                    <td>${inv.proposal.category} | ${inv.proposal.location}</td>
                                    <td>
                                        <strong class="text-success">₹${inv.amount}</strong>
                                        <c:if test="${inv.status == 'COMPLETED'}">
                                            <div class="text-muted small" style="font-size:0.7rem; line-height: 1.2;">
                                                Released: ₹${inv.releasedAmount != null ? inv.releasedAmount : inv.amount}
                                                <c:if test="${inv.adminAmount != null && inv.adminAmount > 0}">
                                                    <br>Retained: ₹${inv.adminAmount}
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>₹${inv.proposal.fundingNeeded}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inv.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Awaiting Transfer</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success"><i class="bi bi-check-circle-fill"></i> Transferred</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/investor/proposal/${inv.proposal.id}" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                                            View Progress
                                        </a>
                                        <c:if test="${investor.subscribed}">
                                            <a href="${pageContext.request.contextPath}/investor/chat/${inv.proposal.entrepreneur.id}?proposalId=${inv.proposal.id}" class="btn btn-primary btn-sm rounded-pill px-3 ms-2">
                                                Chat
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty investments}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">You have not made any investments yet. Check the Marketplace to find opportunities!</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Meetings & Questions Section -->
            <div class="row">
                <!-- Left: Scheduled Meetings -->
                <div class="col-lg-6">
                    <div class="panel">
                        <h3 class="panel-title">Consultation Meetings</h3>
                        <div class="list-group list-group-flush">
                            <c:forEach var="meeting" items="${meetings}">
                                <div class="list-group-item py-3 border-0 border-bottom">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="fw-bold"><i class="bi bi-camera-video"></i> ${meeting.proposal.title}</span>
                                        <c:choose>
                                            <c:when test="${meeting.status == 'ACCEPTED'}">
                                                <span class="badge bg-success rounded-pill">Accepted</span>
                                            </c:when>
                                            <c:when test="${meeting.status == 'REJECTED'}">
                                                <span class="badge bg-danger rounded-pill">Declined</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark rounded-pill">Pending Reply</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="text-secondary small">
                                        <strong>Time:</strong> ${meeting.meetingTime}<br>
                                        <strong>Location:</strong> ${meeting.location}<br>
                                        <strong>Notes:</strong> ${meeting.notes}
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty meetings}">
                                <div class="text-center text-muted py-4">No meetings scheduled.</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right: Q&A Board -->
                <div class="col-lg-6">
                    <div class="panel">
                        <h3 class="panel-title">My Asked Questions</h3>
                        <c:forEach var="q" items="${questions}">
                            <div class="mb-3 p-3 border rounded bg-light">
                                <div class="fw-bold small text-navy"><i class="bi bi-question-circle"></i> Question regarding: ${q.proposal.title}</div>
                                <p class="mb-2 text-secondary">"${q.question}"</p>
                                <div class="border-top pt-2">
                                    <div class="small fw-semibold text-success">Entrepreneur Answer:</div>
                                    <p class="text-secondary mb-0">
                                        <c:choose>
                                            <c:when test="${not empty q.answer}">
                                                "${q.answer}"
                                            </c:when>
                                            <c:otherwise>
                                                <em class="text-muted">Awaiting response...</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty questions}">
                            <div class="text-center text-muted py-4">You have not submitted any questions.</div>
                        </c:if>
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
                    <p class="text-muted mb-1 text-uppercase fw-semibold" style="font-size: 11px;" id="checkoutTypeLabel">Investor Premium Plan</p>
                    <h3 class="fw-bold" style="color:var(--navy-dark);" id="checkoutAmountLabel">₹1999.00</h3>
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
                    <h5 class="fw-bold text-success mt-4">Subscription Activated!</h5>
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
