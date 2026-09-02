<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
            --navy-dark: #0f172a; /* kept for text */ --primary-rose: #f43f5e; --primary-rose-hover: #e11d48; --primary-plum: #4c0519; /* kept for text */ --primary-rose: #f43f5e; --primary-rose-hover: #e11d48; --primary-plum: #4c0519;
            --navy-light: #4c0519;
            --primary: #f43f5e;
            --coral: #f43f5e;
            --coral-hover: #e11d48;
            --bg-light: #f8fafc; --rose-bg-light: #ffe4e6; --rose-bg-light: #ffe4e6;
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
            width: 210px;
            min-width: 210px;
            max-width: 210px;
            background: #ffffff;
            color: #0f172a;
            height: 100vh; /* Full height down the side */
            position: fixed; /* Make it fixed */
            top: 0;
            left: 0;
            border-radius: 0; /* Fully flush straight bar */
            padding: 20px 0;
            margin: 0; /* NO empty space */
            z-index: 1000;
            box-shadow: 2px 0 16px rgba(244,63,94,0.08); border-right: 1px solid #ffe4e6;
        }

        .sidebar-heading {
            padding: 10px 20px 20px;
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid #ffe4e6;
            color: #4c0519;
        }

        .sidebar-link {
            background: transparent;
            color: #64748b;
            padding: 10px 20px;
            margin-bottom: 8px; /* Added gap between buttons */
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: #f43f5e;
            background: #fff1f2;
            border-left-color: #f43f5e;
        }

        #page-content-wrapper {
            flex: 1;
            margin-left: 210px; /* Must offset the fixed sidebar */
            padding: 20px 30px; 
            overflow-y: auto;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.04);
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%; /* Modern circular design */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
            margin-bottom: 0;
        }
        
        .stat-info {
            display: flex;
            flex-direction: column;
        }
        
        .stat-info .stat-value {
            font-size: 1.15rem;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.1;
        }
        
        .stat-info .stat-label {
            font-size: 0.75rem;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 2px;
        }

        .panel {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            margin-bottom: 20px;
        }

        @media (max-width: 992px) {
            #wrapper {
                flex-direction: column !important;
            }
            #sidebar-wrapper {
                min-width: 100% !important;
                max-width: 100% !important;
                width: 100% !important;
                height: auto !important;
                position: static !important;
                border-radius: 0 0 20px 20px !important;
                padding: 20px 15px !important;
            }
            #sidebar-wrapper .mt-1 {
                display: flex !important;
                flex-wrap: wrap !important;
                flex-direction: row !important;
                gap: 8px !important;
            }
            .sidebar-link {
                padding: 8px 15px !important;
                border-radius: 20px !important;
                border-left: none !important;
                background: #fff1f2 !important;
                display: inline-flex !important;
                white-space: nowrap !important;
                margin-bottom: 0 !important;
            }
            .sidebar-link:hover, .sidebar-link.active {
                border-left-color: transparent !important;
                background: #f43f5e !important;
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 20px 15px !important;
            }
        }
    
        .btn-rose {
            background-color: #f43f5e;
            color: white;
            border: none;
        }
        .btn-rose:hover {
            background-color: #e11d48;
            color: white;
        }
        .btn-outline-rose {
            color: #f43f5e;
            border-color: #f43f5e;
            background-color: transparent;
        }
        .btn-outline-rose:hover {
            background-color: #f43f5e;
            color: white;
        }

        .bg-rose { background-color: #f43f5e !important; color: white !important; }
        .text-rose { color: #f43f5e !important; }
        .badge-rose { background-color: #ffe4e6 !important; color: #f43f5e !important; border: 1px solid #F8C8D4; }
</style>
</head>
<body>

<div style="display: none; visibility: hidden;">
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
</div>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading fs-6 pb-3 px-3 mx-2 mb-2">
            <i class="bi bi-wallet2"></i> Investor Panel
        </div>
        <div class="mt-1 d-flex flex-column">
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-house"></i> Home
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link">
                <i class="bi bi-shop"></i> Marketplace
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard#bookings-section" class="sidebar-link">
                <i class="bi bi-calendar2-check"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard#portfolio-section" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <a href="${pageContext.request.contextPath}/investor/complete-profile" class="sidebar-link">
                <i class="bi bi-person"></i> Profile
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-3">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            
            <div class="text-center mb-4 position-relative">
                <h5 class="fw-bold m-0" style="color: #0f172a;">Welcome Back, ${investor.fullName}!</h5>
                <p class="text-muted small m-0 mt-1">Browse opportunities and manage portfolios.</p>
                <button onclick="location.reload()" class="btn btn-outline-rose rounded-pill btn-sm position-absolute" style="right: 0; top: 0;">
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


            <!-- Stats grid -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #e0f2fe; color: #0284c7;">
                            <i class="bi bi-safe-fill"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value">₹<fmt:formatNumber value="${totalInvested}" maxFractionDigits="0"/></div>
                            <div class="stat-label">Total Capital</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #dcfce7; color: #16a34a;">
                            <i class="bi bi-graph-up"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value">₹<fmt:formatNumber value="${estimatedMonthlyROI}" maxFractionDigits="0"/></div>
                            <div class="stat-label">Est. Income</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #f3e8ff; color: #a855f7;">
                            <i class="bi bi-building-fill"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value">${fn:length(investments)}</div>
                            <div class="stat-label">Businesses Funded</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background-color: #fef3c7; color: #d97706;">
                            <i class="bi bi-calendar2-check"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value">${fn:length(meetings)}</div>
                            <div class="stat-label">Meetings</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Investment Portfolio Table -->
            <div class="panel" id="portfolio-section">
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
                                    <td><strong class="text-dark">${inv.proposal.title}</strong></td>
                                    <td>${inv.proposal.category} | ${inv.proposal.location}</td>
                                    <td>
                                        <strong class="text-rose">â‚¹<fmt:formatNumber value="${inv.amount}" maxFractionDigits="0"/></strong>
                                        <c:if test="${inv.status == 'COMPLETED'}">
                                            <div class="text-muted small" style="font-size:0.7rem; line-height: 1.2;">
                                                Released: â‚¹<fmt:formatNumber value="${inv.releasedAmount != null ? inv.releasedAmount : inv.amount}" maxFractionDigits="0"/>
                                                <c:if test="${inv.adminAmount != null && inv.adminAmount > 0}">
                                                    <br>Retained: â‚¹<fmt:formatNumber value="${inv.adminAmount}" maxFractionDigits="0"/>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>₹<fmt:formatNumber value="${inv.proposal.fundingNeeded}" maxFractionDigits="0"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inv.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Awaiting Transfer</span>
                                            </c:when>
                                            <c:when test="${inv.status == 'WITHDRAWN'}">
                                                <span class="badge bg-secondary"><i class="bi bi-dash-circle"></i> Withdrawn</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-rose"><i class="bi bi-check-circle-fill"></i> Transferred</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-1 flex-wrap">
                                            <c:choose>
                                                <c:when test="${inv.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/investor/investment/${inv.id}/confirm" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-sm btn-rose rounded-pill px-3" onclick="return confirm('Confirm that fund transfer of ₹${inv.amount} is completed?');" style="font-size: 0.78rem;">
                                                            <i class="bi bi-check-lg me-1"></i> Confirm Transfer
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/investor/investment/${inv.id}/withdraw" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="return confirm('Are you sure you want to withdraw this investment interest?');" style="font-size: 0.78rem;">
                                                            Withdraw
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${inv.status == 'COMPLETED'}">
                                                    <c:choose>
                                                        <c:when test="${not empty inv.rating}">
                                                            <div class="d-inline-flex align-items-center gap-1 bg-light px-2 py-1 rounded border" style="font-size: 0.78rem;" title="Review: <c:out value='${inv.review}'/>">
                                                                <span class="text-warning">
                                                                    <c:forEach begin="1" end="${inv.rating}">★</c:forEach>
                                                                </span>
                                                                <span class="fw-bold text-dark">${inv.rating}/5</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-sm btn-outline-rose rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#rateModal${inv.id}" style="font-size: 0.78rem;">
                                                                <i class="bi bi-star-fill text-warning me-1"></i> Rate & Review
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                            </c:choose>

                                            <a href="${pageContext.request.contextPath}/investor/proposal/${inv.proposal.id}" class="btn btn-outline-rose btn-sm rounded-pill px-3" style="font-size: 0.78rem;">
                                                Progress
                                            </a>
                                            <a href="${pageContext.request.contextPath}/investor/chat/${inv.proposal.entrepreneur.id}?proposalId=${inv.proposal.id}" class="btn btn-rose btn-sm rounded-pill px-3" style="font-size: 0.78rem;">
                                                Chat
                                            </a>
                                        </div>

                                        <c:if test="${inv.status == 'COMPLETED' && empty inv.rating}">
                                            <!-- Rate & Review Modal -->
                                            <div class="modal fade" id="rateModal${inv.id}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content rounded-4 border-0 shadow">
                                                        <form action="${pageContext.request.contextPath}/investor/investment/${inv.id}/rate" method="post">
                                                            <div class="modal-header border-bottom-0 pb-0">
                                                                <h5 class="modal-title fw-bold" style="color: var(--primary-plum);">Rate & Review Investment Deal</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body py-3 text-start">
                                                                <p class="text-secondary small mb-3">Provide feedback for <strong>${inv.proposal.title}</strong>.</p>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-semibold small text-dark">Star Rating (1 - 5 Stars) *</label>
                                                                    <select name="rating" class="form-select rounded-3" required>
                                                                        <option value="5">5 Stars - Outstanding (★★★★★)</option>
                                                                        <option value="4">4 Stars - Very Good (★★★★)</option>
                                                                        <option value="3">3 Stars - Average (★★★)</option>
                                                                        <option value="2">2 Stars - Below Expectations (★★)</option>
                                                                        <option value="1">1 Star - Poor (★)</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-semibold small text-dark">Review / Feedback</label>
                                                                    <textarea name="review" class="form-control rounded-3" rows="3" placeholder="Share your experience working with this entrepreneur..."></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer border-top-0 pt-0">
                                                                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-rose rounded-pill px-4">Submit Rating</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </td></tr>
                            </c:forEach>
                            <c:if test="${empty investments}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i class="bi bi-graph-up-arrow" style="font-size: 2.5rem; color: #CBD5E1;"></i>
                                        <p class="text-muted mt-2 mb-2">No investments yet — explore the Marketplace to find your first opportunity!</p>
                                        <a href="${pageContext.request.contextPath}/investor/marketplace" class="btn btn-sm btn-rose rounded-pill px-4">Browse Marketplace</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Meetings & Questions Section -->
            <div class="row">
                <!-- Left: Scheduled Meetings -->
                <div class="col-lg-6" id="bookings-section">
                    <div class="panel">
                        <h3 class="panel-title">Consultation Meetings</h3>
                        <div class="list-group list-group-flush">
                            <c:forEach var="meeting" items="${meetings}">
                                <div class="list-group-item py-3 border-0 border-bottom">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="fw-bold"><i class="bi bi-camera-video"></i> ${meeting.proposal.title}</span>
                                        <c:choose>
                                            <c:when test="${meeting.status == 'ACCEPTED'}">
                                                <span class="badge bg-rose rounded-pill">Accepted</span>
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
                                        <c:if test="${meeting.status == 'ACCEPTED'}">
                                            <div class="mt-2">
                                                <a href="${fn:startsWith(meeting.location, 'http') ? meeting.location : 'https://meet.jit.si/FightDFear-Meeting-'.concat(meeting.id)}" target="_blank" class="btn btn-sm btn-rose rounded-pill px-3 fw-bold text-white d-inline-flex align-items-center gap-1">
                                                    <i class="bi bi-telephone-inbound-fill"></i> Join Meeting
                                                </a>
                                            </div>
                                        </c:if>
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
                                <div class="fw-bold small text-dark"><i class="bi bi-question-circle"></i> Question regarding: ${q.proposal.title}</div>
                                <p class="mb-2 text-secondary">"${q.question}"</p>
                                <div class="border-top pt-2">
                                    <div class="small fw-semibold text-rose">Entrepreneur Answer:</div>
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
                    <i class="bi bi-shield-fill-check text-rose fs-3"></i>
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
                            <span class="fw-bold text-dark">FightDFire Investment</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Beneficiary:</span>
                            <span class="fw-bold text-dark">Platform Admin Account</span>
                        </div>
                    </div>
                    
                    <button class="btn btn-rose w-100 rounded-pill py-3 fw-bold" onclick="simulatePaymentProcessing()">
                        Pay Securely with Simulated Card
                    </button>
                </div>

                <!-- Loading screen -->
                <div id="checkoutLoadingContent" style="display:none;" class="py-4">
                    <div class="spinner-border text-rose" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5 class="fw-bold text-rose mt-4">Processing Simulated Payment...</h5>
                    <p class="text-muted small">Please do not refresh or close this dialog.</p>
                </div>

                <!-- Success Screen -->
                <div id="checkoutSuccessContent" style="display:none;" class="py-4">
                    <i class="bi bi-check-circle-fill text-rose" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-rose mt-4">Subscription Activated!</h5>
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
