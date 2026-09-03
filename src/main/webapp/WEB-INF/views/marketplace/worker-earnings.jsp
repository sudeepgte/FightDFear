<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Earnings & Revenue — Fight D Fear</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-jobs-portal.css">
  <style>
    .wj-edit-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    @media (max-width: 640px) { .wj-edit-grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body class="wj-page">
<div class="wj-overlay" id="overlay" onclick="toggleSidebar()"></div>

<aside class="wj-sidebar" id="sidebar">
  <a class="wj-sidebar-brand" href="${pageContext.request.contextPath}/women-jobs/dashboard" style="display:flex; align-items:center; gap:10px;">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Logo" style="height: 30px; object-fit: contain;">
    <span>Fight D Fear<small>Worker Portal</small></span>
  </a>
  <div class="wj-sidebar-profile">
    <div class="wj-avatar">${user.fullName.charAt(0)}</div>
    <div>
      <div class="name">${user.fullName}</div>
      <div class="spec">${not empty workerApp.designation ? workerApp.designation : workerApp.jobCategory}</div>
    </div>
  </div>
  <nav class="wj-sidebar-nav">
    <div class="wj-nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="wj-nav-item">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <div class="wj-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/women-jobs/profile" class="wj-nav-item">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/women-jobs/earnings" class="wj-nav-item active">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
  </nav>
  <div class="wj-sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="wj-logout">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<main class="wj-main">
  <header class="wj-topbar">
    <div style="display:flex;align-items:center;gap:12px;">
      <button type="button" class="wj-hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
      <div>
        <h1>Earnings &amp; Revenue</h1>
        <p>Track your payments and payouts</p>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/users/dashboard" class="wj-btn-outline">
      <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
  </header>

  <div class="wj-content">
    <c:if test="${not empty success}">
      <div class="wj-alert wj-alert-ok"><i class="bi bi-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="wj-alert wj-alert-err"><i class="bi bi-exclamation-circle"></i> ${error}</div>
    </c:if>
    <c:choose>
        <c:when test="${workerApp.status == 'PENDING'}">
            <div class="wj-card" style="text-align:center; padding:50px 20px; margin-top:20px;">
                <div style="font-size:3rem; color:#F43F5E; margin-bottom:15px;"><i class="bi bi-lock-fill"></i></div>
                <h3 style="color:#1E1B4B; margin-bottom:10px;">Your worker application is pending admin verification</h3>
                <p style="color:#64748B; margin-bottom:25px;">You will be able to access the earnings page and payout settings once approved by our admin team.</p>
                <a href="${pageContext.request.contextPath}/women-jobs/profile" class="wj-btn wj-btn-rose" style="display:inline-block; padding:12px 24px;">Update Profile in the meantime</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="wj-stats">
              <div class="wj-stat"><div class="wj-stat-icon"><i class="bi bi-currency-rupee"></i></div><div><h3>&#8377;${totalEarnings}</h3><p>Total Revenue</p></div></div>
              <div class="wj-stat"><div class="wj-stat-icon"><i class="bi bi-receipt-cutoff"></i></div><div><h3>${paidBookingsCount}</h3><p>Paid Bookings</p></div></div>
              <div class="wj-stat"><div class="wj-stat-icon"><i class="bi bi-cash-stack"></i></div><div><h3>&#8377;${workerApp.hourlyRate}</h3><p>Hourly Rate</p></div></div>
              <div class="wj-stat"><div class="wj-stat-icon"><i class="bi bi-hourglass-split"></i></div><div><h3>&#8377;${pendingRevenue}</h3><p>Pending Revenue</p></div></div>
            </div>

            <div class="wj-card" id="feeBreakdownView">
              <div class="wj-card-h">
                <h2><i class="bi bi-wallet2"></i> Fee &amp; Payout Settings</h2>
                <button type="button" class="wj-btn wj-btn-ghost" onclick="document.getElementById('feeBreakdownView').style.display='none';document.getElementById('feeBreakdownEdit').style.display='block';">
                  <i class="bi bi-pencil-square"></i> Edit
                </button>
              </div>
              <div class="wj-card-b padded">
                <div class="wj-edit-grid">
                  <div>
                    <label class="wj-label" style="margin:0;color:#64748B;">Hourly Rate (₹)</label>
                    <div style="font-size:1.05rem;font-weight:700;color:#1E1B4B;margin-top:4px;">${workerApp.hourlyRate}</div>
                  </div>
                  <div>
                    <label class="wj-label" style="margin:0;color:#64748B;">UPI ID</label>
                    <div style="font-size:0.95rem;font-weight:600;color:#1E1B4B;margin-top:4px;">${not empty workerApp.upiId ? workerApp.upiId : 'Not Set'}</div>
                  </div>
                  <div style="grid-column: 1 / -1;">
                    <label class="wj-label" style="margin:0;color:#64748B;">Bank Details</label>
                    <div style="font-size:0.9rem;color:#1E1B4B;margin-top:4px;white-space:pre-wrap;">${not empty workerApp.bankDetails ? workerApp.bankDetails : 'Not Set'}</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="wj-card" id="feeBreakdownEdit" style="display:none">
              <div class="wj-card-h">
                <h2><i class="bi bi-pencil-square"></i> Edit Payout Settings</h2>
                <button type="button" class="wj-btn wj-btn-ghost" onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';">
                  <i class="bi bi-x-lg"></i> Cancel
                </button>
              </div>
              <div class="wj-card-b padded">
                <form id="earningsUpdateForm" action="${pageContext.request.contextPath}/women-jobs/earnings/update" method="post">
                  <div class="wj-edit-grid">
                    <div>
                      <label class="wj-label">Hourly Rate (₹)</label>
                      <input class="wj-input" type="number" name="hourlyRate" min="1" step="0.01" value="${workerApp.hourlyRate}" required>
                    </div>
                    <div>
                      <label class="wj-label">UPI ID for Payouts</label>
                      <input class="wj-input" type="text" name="upiId" placeholder="e.g. handle@bank" value="${workerApp.upiId}">
                    </div>
                    <div style="grid-column: 1 / -1;">
                      <label class="wj-label">Bank Account / IFSC Details</label>
                      <textarea class="wj-textarea" name="bankDetails" rows="3" placeholder="Bank Name, A/C No, IFSC Code">${workerApp.bankDetails}</textarea>
                    </div>
                  </div>
                  <div style="margin-top:20px;display:flex;gap:10px">
                    <button type="submit" class="wj-btn wj-btn-rose"><i class="bi bi-check-circle"></i> Save Settings</button>
                    <button type="button" class="wj-btn wj-btn-ghost" onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';">Cancel</button>
                  </div>
                </form>
              </div>
            </div>

            <div class="wj-card">
              <div class="wj-card-h"><h2><i class="bi bi-file-earmark-spreadsheet"></i> Earnings History</h2></div>
              <div class="wj-card-b">
                <c:set var="hasCompletedOrPaid" value="false"/>
                <c:if test="${not empty bookings}">
                  <c:forEach var="b" items="${bookings}">
                    <c:if test="${b.status == 'COMPLETED' || b.status == 'PAID'}">
                      <c:set var="hasCompletedOrPaid" value="true"/>
                    </c:if>
                  </c:forEach>
                </c:if>

                <c:if test="${not hasCompletedOrPaid}">
                  <div class="wj-empty"><i class="bi bi-receipt"></i><p>No completed or paid jobs found.</p></div>
                </c:if>
                <c:if test="${hasCompletedOrPaid}">
                  <div style="overflow-x:auto">
                    <table class="wj-table">
                      <thead>
                        <tr>
                          <th>Client</th>
                          <th>Hours</th>
                          <th>Earnings</th>
                          <th>Booking Date</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="b" items="${bookings}">
                          <c:if test="${b.status == 'COMPLETED' || b.status == 'PAID'}">
                            <tr>
                              <td>
                                <div class="wj-user-cell">
                                  <div class="wj-avatar" style="width:32px;height:32px;font-size:0.8rem;">${b.client.fullName.charAt(0)}</div>
                                  <span>${b.client.fullName}</span>
                                </div>
                              </td>
                              <td>${b.hours} hrs</td>
                              <td style="color:#059669; font-weight:700">&#8377; ${b.totalAmount}</td>
                              <td>${b.bookingDate}</td>
                              <td>
                                <c:choose>
                                  <c:when test="${b.status == 'PAID'}"><span class="wj-badge wj-badge-paid"><span class="dot"></span> Paid</span></c:when>
                                  <c:when test="${b.status == 'COMPLETED'}"><span class="wj-badge wj-badge-done"><span class="dot"></span> Completed</span></c:when>
                                </c:choose>
                              </td>
                            </tr>
                          </c:if>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>
                </c:if>
              </div>
            </div>
        </c:otherwise>
    </c:choose>
  </div>
</main>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('overlay');
        if (sidebar && overlay) {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('active');
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        var earningsForm = document.getElementById('earningsUpdateForm');
        if (earningsForm) {
            earningsForm.addEventListener('submit', function(e) {
                var rate = parseFloat((this.hourlyRate.value || '').trim());
                if (isNaN(rate) || rate <= 0) {
                    e.preventDefault();
                    alert('Hourly rate must be greater than zero.');
                }
            });
        }

        const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/worker-bookings/${user.id}', function (message) {
                if (message.body === 'REFRESH') {
                    showRealTimeNotification('Payment or status change detected. Refreshing earnings...');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                }
            });
        });

        function showRealTimeNotification(msg) {
            const toastHTML = `
                <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080;">
                    <div class="toast show align-items-center text-white bg-primary border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="d-flex">
                            <div class="toast-body fw-bold">
                                <i class="fas fa-sync fa-spin me-2"></i> ${msg}
                            </div>
                        </div>
                    </div>
                </div>
            `;
            document.body.insertAdjacentHTML('beforeend', toastHTML);
        }
    });
</script>
</body>
</html>
