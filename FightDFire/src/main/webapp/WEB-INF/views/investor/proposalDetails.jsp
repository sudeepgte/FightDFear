<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${proposal.title} — Fight D Fear</title>
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
        }

        .details-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            max-width: 1000px;
            margin: 0 auto;
        }

        .masked-blur {
            filter: blur(5px);
            user-select: none;
            pointer-events: none;
        }

        .premium-overlay-card {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 10;
            width: 90%;
            max-width: 450px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            border: 1.5px solid rgba(49, 46, 129, 0.1);
        }

        .progress {
            height: 12px;
            border-radius: 12px;
        }

        .business-img {
            border-radius: 12px;
            width: 100%;
            height: 180px;
            object-fit: cover;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
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
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link active">
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
        <div class="details-container">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/investor/marketplace" class="text-secondary text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Back to Marketplace
                </a>
            </div>

            <!-- Top Header Details -->
            <div class="d-flex justify-content-between align-items-start border-bottom pb-4 mb-4">
                <div>
                    <h3 class="fw-bold" style="color: var(--navy-dark);">${proposal.title}</h3>
                    <p class="text-muted mb-0">${proposal.category} | <i class="bi bi-geo-alt"></i> ${proposal.location}</p>
                </div>
                <c:if test="${investor.subscribed}">
                    <a href="${pageContext.request.contextPath}/investor/chat/${proposal.entrepreneur.id}?proposalId=${proposal.id}" class="btn btn-primary rounded-pill px-4" style="background-color: var(--primary); border: none;">
                        <i class="bi bi-chat-dots-fill"></i> Chat with Entrepreneur
                    </a>
                </c:if>
            </div>

            <!-- Funding Progress Bar -->
            <div class="mb-5 bg-light p-4 rounded-4">
                <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-graph-up-arrow"></i> Funding Target</h5>
                <div class="d-flex justify-content-between mb-2 fw-semibold" style="font-size:0.95rem;">
                    <span class="text-success">₹${proposal.amountRaised} Raised</span>
                    <span class="text-navy">₹${proposal.fundingNeeded} Target</span>
                </div>
                <div class="progress mb-3">
                    <div class="progress-bar bg-success" role="progressbar" style="width: ${(proposal.amountRaised/proposal.fundingNeeded)*100}%;"></div>
                </div>
                <div class="text-muted small d-flex justify-content-between flex-wrap">
                    <span>Remaining required capital: <strong>₹${proposal.fundingNeeded - proposal.amountRaised}</strong></span>
                    <c:if test="${pendingAmount > 0}">
                        <span class="text-warning">Pending gateway transfer: <strong>₹${pendingAmount}</strong></span>
                    </c:if>
                </div>
            </div>

            <!-- Business Details & Sidebar Column -->
            <div class="row g-4">
                <!-- Main Content Column -->
                <div class="col-lg-8">
                    <div class="panel">
                        <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-file-text-fill"></i> Project Description</h5>
                        <p class="text-secondary" style="line-height:1.7; font-size:0.95rem;">
                            ${proposal.description}
                        </p>

                        <!-- Media Grid -->
                        <c:if test="${not empty proposal.photos}">
                            <h5 class="fw-bold mb-3 mt-4" style="color: var(--navy-dark);"><i class="bi bi-images"></i> Business Photos</h5>
                            <div class="row g-3 mb-3">
                                <c:forEach var="photo" items="${fn:split(proposal.photos, ',')}">
                                    <div class="col-6 col-sm-4">
                                        <img src="${pageContext.request.contextPath}${photo}" alt="Photos" class="business-img">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <!-- Video Pitch Player -->
                        <c:if test="${not empty proposal.videoPitch}">
                            <h5 class="fw-bold mb-3 mt-4" style="color: var(--navy-dark);"><i class="bi bi-play-btn-fill"></i> Video Pitch</h5>
                            <div class="ratio ratio-16x9 rounded-3 overflow-hidden border shadow-sm mt-3" style="max-width:100%;">
                                <video controls class="w-100">
                                    <source src="${pageContext.request.contextPath}${proposal.videoPitch}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Right Sidebar Column -->
                <div class="col-lg-4">
                    <!-- Entrepreneur Profile Card -->
                    <div class="card border-0 shadow-sm p-4 position-relative mb-4" style="border-radius:16px; background-color:#fafaff; border: 1px solid rgba(0,0,0,0.03);">
                        <c:choose>
                            <c:when test="${investor.subscribed}">
                                <!-- Unmasked Profile -->
                                <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-person-fill-check"></i> Entrepreneur Profile</h5>
                                <div class="text-center mb-3">
                                    <img src="${pageContext.request.contextPath}${proposal.entrepreneur.profilePhoto}" alt="Profile" class="rounded-circle border" style="width:75px; height:75px; object-fit:cover;">
                                    <h6 class="fw-bold mt-2 mb-0">${proposal.entrepreneur.fullName}</h6>
                                    <span class="text-muted small">${proposal.entrepreneur.businessExperience} Years Experience</span>
                                </div>
                                <div class="small text-secondary" style="font-size:0.85rem; line-height:1.6;">
                                    <strong>Email:</strong> ${proposal.entrepreneur.email}<br>
                                    <strong>Phone:</strong> ${proposal.entrepreneur.phone}<br>
                                    <strong>Aadhaar:</strong> ${proposal.entrepreneur.aadhaarNumber} (Verified)<br>
                                    <strong>Expected Monthly Profit:</strong> ₹${proposal.expectedMonthlyIncome}<br>
                                    <strong>Bank:</strong> ${proposal.entrepreneur.bankName}<br>
                                    <strong>Account:</strong> ${proposal.entrepreneur.accountNumber}<br>
                                    <strong>UPI ID:</strong> ${proposal.entrepreneur.upiId}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Masked Profile & Pay Banner -->
                                <div class="premium-overlay-card p-4 text-center">
                                    <i class="bi bi-lock-fill text-warning fs-1"></i>
                                    <h6 class="fw-bold mt-2">Unlock Profile Details</h6>
                                    <p class="text-muted small mb-3">Reveal identity documents, direct contacts, bank details, schedule meetings and invest.</p>
                                    <button class="btn btn-warning fw-bold btn-sm rounded-pill px-4" onclick="triggerCheckout('subscription', null, 1999.00, '${pageContext.request.contextPath}/investor/subscribe')">
                                        Subscribe for ₹1999
                                    </button>
                                </div>
                                <div class="masked-blur">
                                    <h5 class="fw-bold mb-3"><i class="bi bi-person-fill"></i> Profile Details</h5>
                                    <div class="text-center mb-3">
                                        <div class="rounded-circle border mx-auto" style="width:75px; height:75px; background-color:#ccc;"></div>
                                        <h6 class="fw-bold mt-2 mb-0">Jane Doe</h6>
                                        <span class="text-muted small">5 Years Experience</span>
                                    </div>
                                    <div class="small text-secondary">
                                        <strong>Email:</strong> jane.doe@example.com<br>
                                        <strong>Phone:</strong> 555-019-2831<br>
                                        <strong>Aadhaar:</strong> 000000000000<br>
                                        <strong>Expected Profit:</strong> ₹500<br>
                                        <strong>Bank Name:</strong> Sandbox Bank
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Funding Selector Card -->
                    <div class="card border-0 shadow-sm p-4 position-relative mb-4" style="border-radius: 16px; border: 1px solid rgba(0,0,0,0.03);">
                        <c:if test="${not investor.subscribed}">
                            <div class="premium-overlay-card p-3 text-center">
                                <i class="bi bi-lock-fill text-warning fs-3"></i>
                                <h6 class="fw-bold mt-1" style="font-size:0.9rem;">Unlock Investments</h6>
                                <p class="text-muted small mb-2" style="font-size:0.75rem;">Purchase subscription to invest.</p>
                                <button class="btn btn-warning fw-bold btn-xs rounded-pill px-3 py-1" style="font-size:0.75rem;" onclick="triggerCheckout('subscription', null, 1999.00, '${pageContext.request.contextPath}/investor/subscribe')">
                                    Subscribe
                                </button>
                            </div>
                        </c:if>
                        <div class="${not investor.subscribed ? 'masked-blur' : ''}">
                            <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-cash-stack"></i> Funding Selector</h5>
                            
                            <c:choose>
                                <c:when test="${proposal.amountRaised >= proposal.fundingNeeded}">
                                    <div class="alert alert-success text-center py-2 mb-0" style="font-size: 0.8rem;">
                                        <i class="bi bi-patch-check-fill"></i> 100% Fully Funded!
                                    </div>
                                </c:when>
                                <c:when test="${openRemaining <= 0}">
                                     <div class="alert alert-warning text-center py-2 mb-0" style="font-size: 0.8rem;">
                                         <i class="bi bi-hourglass-split"></i> Fully Committed (Awaiting Admin Gateway Transfer)
                                     </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Choose Investment Amount (₹):</label>
                                        <input type="range" class="form-range" id="fundingSlider" min="100" max="${openRemaining}" step="100" value="100" oninput="updateInvestmentDisplay(this.value)">
                                        <div class="d-flex justify-content-between small text-muted mt-1" style="font-size:0.75rem;">
                                            <span>Min: ₹100</span>
                                            <span class="fw-bold text-navy" id="sliderValueDisplay">₹100</span>
                                            <span>Max: ₹${openRemaining}</span>
                                        </div>
                                    </div>
                                    <button class="btn btn-primary w-100 py-2 rounded-pill fw-bold" style="background-color: var(--coral); border:none; font-size:0.85rem;" onclick="triggerInvestmentCheckout()">
                                        Submit Investment
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Meetings Scheduling Card (Restricted if not Premium) -->
                    <div class="card border-0 shadow-sm p-4 position-relative mb-4" style="border-radius: 16px; border: 1px solid rgba(0,0,0,0.03);">
                        <c:if test="${not investor.subscribed}">
                            <div class="premium-overlay-card p-3 text-center">
                                <i class="bi bi-lock-fill text-warning fs-3"></i>
                                <h6 class="fw-bold mt-1" style="font-size:0.9rem;">Unlock Meetings</h6>
                                <p class="text-muted small mb-2" style="font-size:0.75rem;">Schedule meetings to ask details.</p>
                                <button class="btn btn-warning fw-bold btn-xs rounded-pill px-3 py-1" style="font-size:0.75rem;" onclick="triggerCheckout('subscription', null, 1999.00, '${pageContext.request.contextPath}/investor/subscribe')">
                                    Subscribe
                                </button>
                            </div>
                        </c:if>
                        <div class="${not investor.subscribed ? 'masked-blur' : ''}">
                            <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-calendar-check-fill"></i> Schedule Meeting</h5>
                            <form action="${pageContext.request.contextPath}/investor/proposal/${proposal.id}/meeting" method="post">
                                <div class="mb-2">
                                    <label class="form-label small fw-semibold">Date & Time *</label>
                                    <input type="datetime-local" name="meetingTime" class="form-control form-control-sm" required>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label small fw-semibold">Location / Link *</label>
                                    <input type="text" name="location" class="form-control form-control-sm" placeholder="e.g. Google Meet link or address" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Agenda Notes *</label>
                                    <textarea name="notes" class="form-control form-control-sm" rows="2" placeholder="Describe meeting agenda..." required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill" style="background-color: var(--primary); border:none;">Request Meeting</button>
                            </form>
                        </div>
                    </div>

                    <!-- Q&A Section Card (Restricted if not Premium) -->
                    <div class="card border-0 shadow-sm p-4 position-relative" style="border-radius: 16px; border: 1px solid rgba(0,0,0,0.03);">
                        <c:if test="${not investor.subscribed}">
                            <div class="premium-overlay-card p-3 text-center">
                                <i class="bi bi-lock-fill text-warning fs-3"></i>
                                <h6 class="fw-bold mt-1" style="font-size:0.9rem;">Unlock Q&A Board</h6>
                                <p class="text-muted small mb-2" style="font-size:0.75rem;">Submit questions regarding project.</p>
                                <button class="btn btn-warning fw-bold btn-xs rounded-pill px-3 py-1" style="font-size:0.75rem;" onclick="triggerCheckout('subscription', null, 1999.00, '${pageContext.request.contextPath}/investor/subscribe')">
                                    Subscribe
                                </button>
                            </div>
                        </c:if>
                        <div class="${not investor.subscribed ? 'masked-blur' : ''}">
                            <h5 class="fw-bold mb-3" style="color: var(--navy-dark);"><i class="bi bi-question-square-fill"></i> Q&A Board</h5>
                            
                            <!-- Ask Box -->
                            <form action="${pageContext.request.contextPath}/investor/proposal/${proposal.id}/ask" method="post" class="mb-3">
                                <div class="input-group input-group-sm">
                                    <input type="text" name="question" class="form-control" placeholder="Ask a question..." required>
                                    <button class="btn btn-primary" type="submit" style="background-color: var(--primary); border: none;">Ask</button>
                                </div>
                            </form>

                            <!-- Questions List -->
                            <div style="max-height: 250px; overflow-y: auto;">
                                <c:forEach var="q" items="${qna}">
                                    <div class="border-bottom py-2" style="font-size:0.8rem;">
                                        <div class="fw-bold text-navy"><i class="bi bi-chat-left-text"></i> Q by ${q.investor.fullName}:</div>
                                        <p class="text-secondary mb-1">"${q.question}"</p>
                                        <div class="ps-2 border-start py-1 bg-light">
                                            <span class="fw-semibold text-success">A:</span>
                                            <span class="text-secondary">
                                                <c:choose>
                                                    <c:when test="${not empty q.answer}">
                                                        "${q.answer}"
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Awaiting response...</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty qna}">
                                    <div class="text-center text-muted small py-2">No questions asked yet.</div>
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
                    <p class="text-muted mb-1 text-uppercase fw-semibold" style="font-size: 11px;" id="checkoutTypeLabel">Investment</p>
                    <h3 class="fw-bold" style="color:var(--navy-dark);" id="checkoutAmountLabel">₹0.00</h3>
                </div>

                <!-- Simulation content -->
                <div id="checkoutFormContent">
                    <div class="p-3 border rounded-3 text-start bg-light mb-4" style="font-size:0.9rem;">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Proposal Title:</span>
                            <span class="fw-bold text-navy">${proposal.title}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Entrepreneur:</span>
                            <span class="fw-bold text-navy">${proposal.entrepreneur.fullName}</span>
                        </div>
                    </div>
                    
                    <button class="btn btn-primary w-100 rounded-pill py-3 fw-bold" onclick="simulatePaymentProcessing()">
                        Confirm Simulated Investment
                    </button>
                </div>

                <!-- Loading screen -->
                <div id="checkoutLoadingContent" style="display:none;" class="py-4">
                    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5 class="fw-bold text-success mt-4">Processing Simulated Transfer...</h5>
                    <p class="text-muted small">Please do not refresh or close this dialog.</p>
                </div>

                <!-- Success Screen -->
                <div id="checkoutSuccessContent" style="display:none;" class="py-4">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-success mt-4">Investment Successful!</h5>
                    <p class="text-muted small">Recording transactions...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    let activeCheckoutForm = null;

    function updateInvestmentDisplay(val) {
        document.getElementById('sliderValueDisplay').innerText = "₹" + val;
    }

    function triggerInvestmentCheckout() {
        const investVal = document.getElementById('fundingSlider').value;
        const amount = parseFloat(investVal);

        triggerCheckout('investment', ${proposal.id}, amount, '${pageContext.request.contextPath}/investor/proposal/${proposal.id}/invest?amount=' + amount);
    }

    function triggerCheckout(type, id, amount, targetUrl) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = targetUrl;
        
        activeCheckoutForm = form;
        document.body.appendChild(form);

        document.getElementById('checkoutTypeLabel').innerText = type.toUpperCase() + " PAYMENT";
        document.getElementById('checkoutAmountLabel').innerText = "₹" + amount.toFixed(2);

        document.getElementById('checkoutFormContent').style.display = 'block';
        document.getElementById('checkoutLoadingContent').style.display = 'none';
        document.getElementById('checkoutSuccessContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'block';

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
