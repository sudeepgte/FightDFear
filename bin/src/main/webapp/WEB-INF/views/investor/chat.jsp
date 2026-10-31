<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collaboration Chat — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --navy-dark: #2E1B33; /* Dark plum header from image */
            --bg-light: #fcf9f9; /* Very light pinkish-white background */
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
            margin: 0;
            padding: 0;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        /* Sidebar Styling */
        #sidebar-wrapper {
            min-width: 250px;
            max-width: 250px;
            background: #ffffff;
            min-height: 100vh;
            border-right: 1px solid #f1f5f9;
            padding-top: 30px;
        }

        .sidebar-heading {
            padding: 10px 25px 30px;
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--navy-dark);
        }

        .sidebar-heading i {
            color: var(--primary-rose);
        }

        .sidebar-link {
            background: transparent;
            color: #475569;
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
            transition: all 0.3s;
            margin: 5px 15px;
            border-radius: 12px;
        }

        .sidebar-link i {
            font-size: 1.1rem;
        }

        .sidebar-link:hover {
            color: var(--primary-rose);
            background: #fff1f2;
        }

        .sidebar-link.active {
            color: var(--primary-rose);
            background: #fff1f2;
        }

        #page-content-wrapper {
            flex: 1;
            padding: 30px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            background-color: var(--bg-light);
        }

        /* Chat Container exactly like Image */
        .chat-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.03);
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Dark Plum Header */
        .chat-header {
            background: var(--navy-dark);
            color: white;
            padding: 20px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .chat-header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .btn-back {
            color: white;
            font-size: 1.4rem;
            transition: opacity 0.2s;
        }
        
        .btn-back:hover {
            opacity: 0.8;
            color: white;
        }

        .chat-header h6 {
            color: white;
            margin: 0;
            font-size: 1.1rem;
        }
        
        .chat-header .subtitle {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.8rem;
            display: block;
        }

        .badge-channel {
            background-color: var(--primary-rose);
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Messages Area */
        .chat-messages {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background: white; /* Image shows white chat area */
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message {
            max-width: 60%;
            padding: 12px 18px;
            border-radius: 12px;
            font-size: 0.95rem;
            position: relative;
            line-height: 1.4;
        }

        /* Own messages (like image: Red background, white text) */
        .message.sent {
            background-color: var(--primary-rose);
            color: white;
            align-self: flex-end;
            border-top-right-radius: 4px;
        }

        /* Other person's messages */
        .message.received {
            background-color: #f1f5f9;
            color: #1e293b;
            align-self: flex-start;
            border-top-left-radius: 4px;
        }

        .msg-time {
            font-size: 0.7rem;
            opacity: 0.85;
            margin-top: 6px;
        }
        .sent .msg-time { text-align: right; }
        .received .msg-time { text-align: left; }

        /* Footer / Input matching image */
        .chat-footer {
            padding: 20px 30px;
            background: var(--bg-light); /* Slightly off-white matching the page background */
        }

        .chat-input-wrapper {
            display: flex;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .chat-input-wrapper input {
            flex: 1;
            border: none;
            padding: 15px 20px;
            font-size: 0.95rem;
            outline: none;
            color: #333;
        }

        .chat-input-wrapper button {
            background-color: var(--primary-rose);
            color: white;
            border: none;
            width: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            cursor: pointer;
            transition: background 0.2s;
        }

        .chat-input-wrapper button:hover {
            background-color: var(--primary-rose-hover);
        }

        /* Mobile Responsiveness */
        @media (max-width: 991px) {
            #sidebar-wrapper {
                position: fixed;
                top: 0;
                left: -280px;
                width: 260px;
                max-width: 260px;
                min-width: 260px;
                height: 100vh;
                z-index: 1050;
                transition: left 0.3s ease-in-out;
                box-shadow: 4px 0 24px rgba(0,0,0,0.1);
            }
            #sidebar-wrapper.show-sidebar {
                left: 0;
            }
            #page-content-wrapper {
                padding: 0;
                width: 100%;
                height: 100vh;
            }
            .chat-container {
                height: 100vh;
                border-radius: 0;
            }
            .chat-header {
                padding: 15px 20px;
            }
            .chat-messages {
                padding: 15px;
            }
            .chat-footer {
                padding: 15px;
            }
            .message {
                max-width: 85%;
            }
        }
    </style>
</head>
<body>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading d-flex justify-content-between align-items-center">
            <div><i class="bi bi-briefcase-fill"></i> Investor Panel</div>
            <button class="btn btn-light btn-sm border-0 d-lg-none shadow-sm" id="closeSidebarBtn"><i class="bi bi-x-lg" style="color: var(--primary-rose);"></i></button>
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-house"></i> Home
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link active">
                <i class="bi bi-chat-dots"></i> Chat
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
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-4">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="chat-container">
            <!-- Header (Dark Plum like image) -->
            <div class="chat-header">
                <div class="chat-header-left">
                    <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-back text-decoration-none">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <button class="btn btn-dark d-lg-none border-0 ms-1 me-2 p-0" id="mobileSidebarToggle" style="background: transparent;">
                        <i class="bi bi-list fs-4 text-white"></i>
                    </button>
                    <div>
                        <h6 class="fw-bold">${entrepreneur.fullName}</h6>
                        <span class="subtitle">${proposal.title}</span>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-light rounded-pill px-3 py-1 fw-bold text-danger border-0 shadow-sm d-flex align-items-center gap-2" onclick="openInvestModal()">
                        <i class="bi bi-shield-lock-fill"></i> Release Funds (Razorpay)
                    </button>
                    <span class="badge-channel">Direct Channel</span>
                </div>
            </div>

            <!-- PROPOSAL & ESCROW RIBBON -->
            <div class="px-4 py-2 bg-light border-bottom d-flex justify-content-between align-items-center flex-wrap gap-2" style="font-size:0.85rem;">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted">Pitch Desk:</span>
                    <strong class="text-dark"><c:out value="${proposal.title}"/></strong>
                    <span class="badge bg-secondary rounded-pill" style="font-size:0.75rem;"><c:out value="${proposal.category}"/></span>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div><span class="text-muted">Needed:</span> <strong>₹<fmt:formatNumber value="${proposal.fundingNeeded}" type="number" maxFractionDigits="2"/></strong></div>
                    <div><span class="text-muted">Raised:</span> <strong class="text-success">₹<fmt:formatNumber value="${proposal.amountRaised}" type="number" maxFractionDigits="2"/></strong></div>
                    <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 py-1 fw-bold" onclick="openInvestModal()">
                        <i class="bi bi-wallet2 me-1"></i> Release Funds
                    </button>
                </div>
            </div>

            <!-- Messages Area -->
            <div class="chat-messages" id="messageArea">
                <c:forEach var="msg" items="${chatHistory}">
                    <c:choose>
                        <c:when test="${fn:contains(msg.message, '💰') or fn:contains(msg.message, 'INVESTOR PAYMENT') or fn:contains(msg.message, 'ADMIN DISBURSEMENT')}">
                            <div class="message" style="max-width:85%; align-self:center; background:#FFFBEB; border:1px solid #FDE68A; color:#92400E; border-radius:14px; padding:12px 18px; text-align:center; font-size:0.88rem; line-height:1.5;">
                                <div style="font-weight:600;"><c:out value="${msg.message}"/></div>
                                <div class="msg-time" style="text-align:center; color:#B45309; margin-top:4px;"><c:out value="${msg.formattedTimestamp}"/></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="message ${msg.senderRole == 'INVESTOR' ? 'sent' : 'received'}">
                                <div><c:out value="${msg.message}"/></div>
                                <div class="msg-time"><c:out value="${msg.formattedTimestamp}"/></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${empty chatHistory}">
                    <div class="text-center text-muted my-auto py-5">
                        <i class="bi bi-chat-heart" style="font-size: 3.5rem; color: #f43f5e; opacity: 0.3;"></i>
                        <p class="mt-3">No messages yet.<br>Say hello to start the conversation!</p>
                    </div>
                </c:if>
            </div>

            <!-- Footer / Input Form (White box, red button like image) -->
            <div class="chat-footer">
                <form action="${pageContext.request.contextPath}/investor/chat/${entrepreneur.id}" method="post" id="chatForm">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <input type="hidden" name="proposalId" value="${proposal.id}">
                    <div class="chat-input-wrapper">
                        <input type="text" name="message" placeholder="Type a message..." required autocomplete="off">
                        <button type="submit">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const area = document.getElementById("messageArea");
        if(area) area.scrollTop = area.scrollHeight;

        const toggleBtn = document.getElementById("mobileSidebarToggle");
        const closeBtn = document.getElementById("closeSidebarBtn");
        const sidebar = document.getElementById("sidebar-wrapper");
        
        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function() {
                sidebar.classList.add("show-sidebar");
            });
        }
        
        if (closeBtn && sidebar) {
            closeBtn.addEventListener("click", function() {
                sidebar.classList.remove("show-sidebar");
            });
        }
    });
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>

<!-- INVESTOR ESCROW RELEASE MODAL -->
<div class="modal fade" id="investFundsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header text-white p-3 border-0" style="background:#2E1B33;">
                <div>
                    <h6 class="modal-title fw-bold m-0"><i class="bi bi-shield-check text-rose me-2"></i>Release Funds via Razorpay</h6>
                    <small class="text-white-50">Transferred to Admin Escrow until verified &amp; released</small>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Selected Proposal</label>
                    <div class="p-2 bg-light rounded-3 fw-bold text-dark"><c:out value="${proposal.title}"/></div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold small" for="chatInvestAmount">Amount to Release to Admin Escrow (₹) *</label>
                    <input type="number" id="chatInvestAmount" class="form-control form-control-lg rounded-3 fw-bold" placeholder="e.g. 10000" min="1" step="100" required>
                    <div class="form-text">This payment goes directly to the Admin Escrow account via Razorpay. Admin will manually disburse funds to the entrepreneur.</div>
                </div>
                <div class="p-3 bg-light rounded-3 d-flex align-items-center gap-3 mb-3 border">
                    <i class="bi bi-shield-lock-fill text-success fs-3"></i>
                    <div class="small text-muted">
                        Secured with Razorpay payment gateway. Traceable transaction recorded in Admin Escrow.
                    </div>
                </div>
                <div id="paymentAlert" class="alert alert-danger d-none py-2 small"></div>
                <button type="button" class="btn btn-danger w-100 py-3 rounded-pill fw-bold" id="btnPayRazorpay" onclick="triggerChatRazorpay()" style="background:var(--primary-rose); border-color:var(--primary-rose);">
                    <i class="bi bi-credit-card-2-front me-2"></i> Pay &amp; Transfer to Admin Escrow
                </button>
            </div>
        </div>
    </div>
</div>

<!-- MOCK CHECKOUT MODAL (TEST FALLBACK) -->
<div class="modal fade" id="mockCheckoutModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-dark text-white p-3 border-0" style="background:#0c2340 !important;">
                <div>
                    <h6 class="modal-title fw-bold m-0" style="letter-spacing:1px;">RAZORPAY GATEWAY</h6>
                    <span class="text-white-50 small" style="font-size:11px;">Simulation Environment</span>
                </div>
            </div>
            <div class="modal-body p-4 text-center">
                <div class="spinner-border text-primary my-3" role="status"></div>
                <h6 class="fw-bold">Processing Escrow Payment...</h6>
                <p class="text-muted small">Transacting with Fight D Fear Admin Escrow.</p>
                <div class="badge bg-success-subtle text-success fs-6 px-3 py-2 border rounded-pill my-2" id="mockAmountDisplay">₹0</div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    var investModalInstance = null;
    var mockModalInstance = null;
    var ctxPath = '${pageContext.request.contextPath}';
    var proposalId = ${proposal.id};
    var razorpayKeyId = '${not empty razorpayKeyId ? razorpayKeyId : "rzp_test_RIlD5bEKRjyn3h"}';

    function openInvestModal() {
        if (!investModalInstance) {
            investModalInstance = new bootstrap.Modal(document.getElementById('investFundsModal'));
        }
        document.getElementById('paymentAlert').classList.add('d-none');
        document.getElementById('chatInvestAmount').value = '';
        investModalInstance.show();
    }

    function triggerChatRazorpay() {
        var amtInput = document.getElementById('chatInvestAmount');
        var amount = parseFloat(amtInput.value);
        var alertBox = document.getElementById('paymentAlert');
        alertBox.classList.add('d-none');

        if (isNaN(amount) || amount <= 0) {
            alertBox.textContent = 'Please enter a valid investment amount greater than 0.';
            alertBox.classList.remove('d-none');
            return;
        }

        var btn = document.getElementById('btnPayRazorpay');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Initiating Razorpay...';

        var csrfToken = document.querySelector('meta[name="_csrf"]').content;
        var csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        // Step 1: Create Order
        fetch(ctxPath + '/investor/proposal/' + proposalId + '/create-order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({ amount: amount })
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-credit-card-2-front me-2"></i> Pay &amp; Transfer to Admin Escrow';

            if (data.error) {
                alertBox.textContent = data.error;
                alertBox.classList.remove('d-none');
                return;
            }

            investModalInstance.hide();

            if (data.isMock) {
                showMockDialog(data.orderId, amount);
            } else {
                var options = {
                    key: data.keyId || razorpayKeyId,
                    amount: data.amount,
                    currency: data.currency || 'INR',
                    name: 'Fight D Fear Admin Escrow',
                    description: 'Escrow Fund Release for ' + '${proposal.title}',
                    order_id: data.orderId,
                    prefill: {
                        name: '${investor.fullName}',
                        email: '${investor.email}',
                        contact: '${investor.phone}'
                    },
                    theme: { color: '#F43F5E' },
                    handler: function(response) {
                        verifyChatPayment(response, amount);
                    }
                };
                var rzp = new Razorpay(options);
                rzp.open();
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-credit-card-2-front me-2"></i> Pay &amp; Transfer to Admin Escrow';
            alertBox.textContent = 'Network error: ' + err.message;
            alertBox.classList.remove('d-none');
        });
    }

    function verifyChatPayment(rzpResponse, amount) {
        var csrfToken = document.querySelector('meta[name="_csrf"]').content;
        var csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        fetch(ctxPath + '/investor/proposal/' + proposalId + '/verify-payment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({
                razorpay_payment_id: rzpResponse.razorpay_payment_id,
                razorpay_order_id: rzpResponse.razorpay_order_id,
                razorpay_signature: rzpResponse.razorpay_signature,
                amount: amount
            })
        })
        .then(function(r) { return r.json(); })
        .then(function(res) {
            if (res.success) {
                window.location.reload();
            } else {
                alert('Payment verification failed: ' + (res.error || 'Unknown error'));
            }
        })
        .catch(function(err) {
            alert('Error verifying payment: ' + err.message);
        });
    }

    function showMockDialog(orderId, amount) {
        if (!mockModalInstance) {
            mockModalInstance = new bootstrap.Modal(document.getElementById('mockCheckoutModal'));
        }
        document.getElementById('mockAmountDisplay').textContent = '₹' + amount.toFixed(2);
        mockModalInstance.show();

        setTimeout(function() {
            mockModalInstance.hide();
            verifyChatPayment({
                razorpay_payment_id: 'pay_mock_' + Date.now(),
                razorpay_order_id: orderId,
                razorpay_signature: 'mock_signature'
            }, amount);
        }, 1200);
    }
</script>

</body>
</html>

