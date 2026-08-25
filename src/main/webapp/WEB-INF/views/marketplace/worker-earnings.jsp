<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Earnings & Revenue — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
  <style>
    /* Styling overrides for editing grid */
    .dd-edit-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .dd-edit-field {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .dd-edit-field label {
      font-size: 12px;
      font-weight: 600;
      color: var(--dd-muted);
    }
    .dd-edit-field input, .dd-edit-field textarea {
      padding: 10px 14px;
      border: 1px solid var(--dd-border);
      border-radius: 8px;
      font-size: 13px;
      font-family: inherit;
      outline: none;
    }
    .dd-edit-field input:focus, .dd-edit-field textarea:focus {
      border-color: var(--dd-purple-light);
    }
    .dd-btn-edit, .dd-btn-save, .dd-btn-cancel {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      border: none;
      transition: all 0.2s;
    }
    .dd-btn-edit {
      background: rgba(123, 44, 191, 0.1);
      color: var(--dd-purple-light);
    }
    .dd-btn-edit:hover {
      background: var(--dd-purple-light);
      color: #fff;
    }
    .dd-btn-save {
      background: var(--dd-purple-light);
      color: #fff;
    }
    .dd-btn-save:hover {
      background: var(--dd-purple);
    }
    .dd-btn-cancel {
      background: rgba(107, 114, 128, 0.1);
      color: #4b5563;
    }
    .dd-btn-cancel:hover {
      background: #4b5563;
      color: #fff;
    }
    .dd-profile-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .dd-profile-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .dd-profile-item .label {
      font-size: 12px;
      color: var(--dd-muted);
      font-weight: 500;
    }
    .dd-profile-item .value {
      font-size: 14px;
      font-weight: 600;
      color: var(--dd-text);
    }
  </style>
</head>
<body class="dd-page">
<div class="dd-overlay" id="overlay" onclick="toggleSidebar()"></div>

<%-- ═══ SIDEBAR ═══ --%>
<aside class="dd-sidebar" id="sidebar">
  <div class="dd-sidebar-brand">
    <div class="brand-icon"><i class="bi bi-briefcase"></i></div>
    <div class="brand-text">Fight D Fear<small>Worker Portal</small></div>
  </div>
  <div class="dd-sidebar-profile">
    <div class="avatar-placeholder">${user.fullName.charAt(0)}</div>
    <div class="profile-info">
      <div class="name">${user.fullName}</div>
      <div class="spec">${not empty workerApp.designation ? workerApp.designation : workerApp.jobCategory}</div>
    </div>
    <div class="status-dot"></div>
  </div>
  <nav class="dd-sidebar-nav">
    <div class="dd-nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="dd-nav-item">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/women-jobs/profile" class="dd-nav-item">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/women-jobs/earnings" class="dd-nav-item active">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
  </nav>
  <div class="dd-sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="dd-nav-item" style="color:rgba(255,107,107,0.8)">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<%-- ═══ MAIN ═══ --%>
<main class="dd-main">
  <header class="dd-topbar">
    <div class="dd-topbar-left">
      <button class="dd-hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
      <div>
        <h1>Earnings & Revenue</h1>
        <div class="breadcrumb-text">Track your payments and payouts</div>
      </div>
    </div>
    <div class="dd-topbar-right">
      <a href="${pageContext.request.contextPath}/users/dashboard" class="dd-nav-item" style="color: var(--dd-text); border: 1px solid var(--dd-border); border-radius: 12px; padding: 8px 16px; font-weight: 600; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 8px;">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
      </a>
    </div>
  </header>

  <div class="dd-content">
    <c:if test="${not empty success}">
      <div style="padding:14px 20px;border-radius:12px;background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.2);color:#0d9668;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:8px">
        <i class="bi bi-check-circle"></i> ${success}
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div style="padding:14px 20px;border-radius:12px;background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.2);color:#be123c;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:8px">
        <i class="bi bi-exclamation-circle"></i> ${error}
      </div>
    </c:if>

    <%-- ══════ EARNINGS SUMMARY STATS ══════ --%>
    <div class="dd-stats">
      <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${totalEarnings}</h3><p>Total Revenue</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-receipt-cutoff"></i></div><div class="dd-stat-info"><h3>${paidBookingsCount}</h3><p>Paid Bookings</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-cash-stack"></i></div><div class="dd-stat-info"><h3>&#8377;${workerApp.hourlyRate}</h3><p>Hourly Rate</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>&#8377;${pendingRevenue}</h3><p>Pending Revenue</p></div></div>
    </div>

    <%-- ══════ FEE BREAKDOWN SECTION ══════ --%>
    <div class="dd-section" id="feeBreakdownView">
      <div class="dd-section-header">
        <h2><i class="bi bi-wallet2"></i> Fee & Payout Settings</h2>
        <button onclick="document.getElementById('feeBreakdownView').style.display='none';document.getElementById('feeBreakdownEdit').style.display='block';" class="dd-btn-edit">
          <i class="bi bi-pencil-square"></i> Edit
        </button>
      </div>
      <div class="dd-section-body padded">
        <div class="dd-profile-grid">
          <div class="dd-profile-item"><span class="label">Hourly Rate</span><span class="value" style="color:#20c997;font-weight:700">&#8377; ${workerApp.hourlyRate} / hr</span></div>
          <div class="dd-profile-item"><span class="label">UPI ID for Payouts</span><span class="value">${not empty workerApp.upiId ? workerApp.upiId : '—'}</span></div>
          <div class="dd-profile-item" style="grid-column: 1 / -1;"><span class="label">Bank Account / IFSC Details</span><span class="value">${not empty workerApp.bankDetails ? workerApp.bankDetails : '—'}</span></div>
        </div>
      </div>
    </div>

    <div class="dd-section" id="feeBreakdownEdit" style="display:none">
      <div class="dd-section-header">
        <h2><i class="bi bi-pencil-square"></i> Edit Payout Settings</h2>
        <button type="button" class="dd-btn-edit" onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';">
          <i class="bi bi-x-lg"></i> Cancel
        </button>
      </div>
      <div class="dd-section-body padded">
        <form action="${pageContext.request.contextPath}/women-jobs/earnings/update" method="post">
          <div class="dd-edit-grid">
            <div class="dd-edit-field">
              <label>Hourly Rate (₹)</label>
              <input type="number" name="hourlyRate" min="1" step="0.01" value="${workerApp.hourlyRate}" required>
            </div>
            <div class="dd-edit-field">
              <label>UPI ID for Payouts</label>
              <input type="text" name="upiId" placeholder="e.g. handle@bank" value="${workerApp.upiId}">
            </div>
            <div class="dd-edit-field" style="grid-column: 1 / -1;">
              <label>Bank Account / IFSC Details</label>
              <textarea name="bankDetails" rows="3" placeholder="Bank Name, A/C No, IFSC Code">${workerApp.bankDetails}</textarea>
            </div>
          </div>
          <div style="margin-top:20px;display:flex;gap:10px">
            <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Settings</button>
            <button type="button" class="dd-btn-cancel" onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';">Cancel</button>
          </div>
        </form>
      </div>
    </div>

    <%-- ══════ COMPLETED / PAID BOOKINGS LOG ══════ --%>
    <div class="dd-section">
      <div class="dd-section-header"><h2><i class="bi bi-credit-card-2-front"></i> Completed & Paid Bookings Log</h2></div>
      <div class="dd-section-body">
        <c:set var="hasCompletedOrPaid" value="false" />
        <c:forEach var="b" items="${bookings}">
          <c:if test="${b.status == 'COMPLETED' || b.status == 'PAID'}">
            <c:set var="hasCompletedOrPaid" value="true" />
          </c:if>
        </c:forEach>

        <c:if test="${!hasCompletedOrPaid}">
          <div class="dd-empty"><i class="bi bi-receipt"></i><p>No completed or paid jobs found.</p></div>
        </c:if>
        <c:if test="${hasCompletedOrPaid}">
          <div style="overflow-x:auto">
            <table class="dd-table">
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
                        <div class="dd-user-cell">
                          <div class="user-avatar">${b.client.fullName.charAt(0)}</div>
                          <span>${b.client.fullName}</span>
                        </div>
                      </td>
                      <td>${b.hours} hrs</td>
                      <td style="color:#20c997; font-weight:700">&#8377; ${b.totalAmount}</td>
                      <td>${b.bookingDate}</td>
                      <td>
                        <c:choose>
                          <c:when test="${b.status == 'PAID'}"><span class="dd-badge completed" style="background: rgba(32, 201, 151, 0.12); color: #0d9668;"><span class="dot" style="background: #0d9668;"></span> Paid</span></c:when>
                          <c:otherwise><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:otherwise>
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
        // WebSocket live updates handler
        const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null; // Disable debug log

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
