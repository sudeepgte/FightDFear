<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Worker Dashboard — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
  <style>
    /* Status pill compatibility overrides */
    .status-pill {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
    }
    .status-PENDING { background: #fffbeb; color: #d97706; }
    .status-ACCEPTED, .status-CONFIRMED { background: #e0f2fe; color: #0284c7; }
    .status-PAID { background: #fef9c3; color: #ca8a04; }
    .status-COMPLETED { background: #dcfce7; color: #16a34a; }
    .status-REJECTED, .status-CANCELLED { background: #fee2e2; color: #ef4444; }
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
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="dd-nav-item active">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/women-jobs/profile" class="dd-nav-item">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/women-jobs/earnings" class="dd-nav-item">
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
        <h1>Dashboard</h1>
        <div class="breadcrumb-text">Welcome back, ${user.fullName}!</div>
      </div>
    </div>
    <div class="dd-topbar-right">
      <div class="notif-btn" id="bellIcon" style="cursor: pointer; position: relative;">
        <i class="bi bi-bell"></i>
      </div>
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

    <%-- ══════ OVERVIEW SECTION ══════ --%>
    <div class="dd-stats">
      <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-briefcase"></i></div><div class="dd-stat-info"><h3>${totalBookings}</h3><p>Total Bookings</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingBookings}</h3><p>Pending Requests</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-check-circle"></i></div><div class="dd-stat-info"><h3>${completedBookings}</h3><p>Completed Jobs</p></div></div>
      <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${totalEarnings}</h3><p>Total Earnings</p></div></div>
    </div>

    <div class="dd-section">
      <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> Recent Job Bookings</h2></div>
      <div class="dd-section-body">
        <c:if test="${empty incomingBookings}">
          <div class="dd-empty"><i class="bi bi-calendar-x"></i><p>No incoming job requests yet.</p></div>
        </c:if>
        <c:if test="${not empty incomingBookings}">
          <div style="overflow-x:auto">
            <table class="dd-table">
              <thead>
                <tr>
                  <th>Client</th>
                  <th>Hours</th>
                  <th>Total Amount</th>
                  <th>Booking Date</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="b" items="${incomingBookings}">
                  <tr>
                    <td>
                      <div class="dd-user-cell">
                        <div class="user-avatar">${b.client.fullName.charAt(0)}</div>
                        <span>${b.client.fullName}</span>
                      </div>
                    </td>
                    <td>${b.hours} hrs</td>
                    <td>&#8377;${b.totalAmount}</td>
                    <td>${b.bookingDate}</td>
                    <td>
                      <c:choose>
                        <c:when test="${b.status=='PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when>
                        <c:when test="${b.status=='CONFIRMED' || b.status=='ACCEPTED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when>
                        <c:when test="${b.status=='COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when>
                        <c:when test="${b.status=='PAID'}"><span class="dd-badge completed" style="background: rgba(32, 201, 151, 0.12); color: #0d9668;"><span class="dot" style="background: #0d9668;"></span> Paid</span></c:when>
                        <c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div style="display:flex;gap:8px;align-items:center;">
                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" 
                                data-bs-toggle="modal" 
                                data-bs-target="#bookingDetailsModal"
                                data-client-name="${b.client.fullName}"
                                data-client-phone="${b.client.phoneNumber}"
                                data-client-email="${b.client.email}"
                                data-booking-date="${b.bookingDate}"
                                data-hours="${b.hours}"
                                data-amount="${b.totalAmount}"
                                data-status="${b.status}"
                                data-note="${b.note}">
                            Details
                        </button>
                        
                        <c:if test="${b.status == 'PENDING'}">
                          <form action="${pageContext.request.contextPath}/women-jobs/booking/${b.id}/status" method="post" class="d-inline">
                              <input type="hidden" name="status" value="ACCEPTED">
                              <button type="submit" class="btn btn-sm btn-success rounded-pill px-3">Accept</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/women-jobs/booking/${b.id}/status" method="post" class="d-inline">
                              <input type="hidden" name="status" value="REJECTED">
                              <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3">Reject</button>
                          </form>
                        </c:if>
                        
                        <c:if test="${b.status == 'ACCEPTED' || b.status == 'PAID'}">
                          <form action="${pageContext.request.contextPath}/women-jobs/booking/${b.id}/status" method="post" class="d-inline">
                              <input type="hidden" name="status" value="COMPLETED">
                              <button type="submit" class="btn btn-sm btn-success rounded-pill px-3">Complete</button>
                          </form>
                        </c:if>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>
      </div>
    </div>

    <!-- Bookings Traffic Graph Section -->
    <div class="dd-section">
      <div class="dd-section-header"><h2><i class="bi bi-graph-up"></i> Bookings Traffic Graph</h2></div>
      <div class="dd-section-body padded">
        <canvas id="bookingsChart" height="100"></canvas>
      </div>
    </div>

  </div>
</main>

<!-- Booking Details Modal -->
<div class="modal fade" id="bookingDetailsModal" tabindex="-1" aria-labelledby="bookingDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-3">
            <div class="modal-header bg-light border-bottom-0">
                <h5 class="modal-title fw-bold" id="bookingDetailsModalLabel" style="color: var(--dd-purple, #1e1b4b);"><i class="fas fa-file-invoice"></i> Booking Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <span class="text-muted small fw-bold text-uppercase d-block mb-1">Client Information</span>
                    <h6 class="fw-bold mb-1" id="modalClientName"></h6>
                    <p class="small text-muted mb-0"><i class="fas fa-envelope me-1"></i> <span id="modalClientEmail"></span></p>
                    <p class="small text-muted mb-0"><i class="fas fa-phone me-1"></i> <span id="modalClientPhone"></span></p>
                </div>
                <hr class="text-muted opacity-25">
                <div class="row mb-3">
                    <div class="col-6">
                        <span class="text-muted small fw-bold text-uppercase d-block mb-1">Date & Time</span>
                        <span class="small fw-semibold" id="modalBookingDate"></span>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small fw-bold text-uppercase d-block mb-1">Duration</span>
                        <span class="small fw-semibold" id="modalHours"></span>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-6">
                        <span class="text-muted small fw-bold text-uppercase d-block mb-1">Total Payout</span>
                        <span class="badge bg-success text-white" id="modalAmount"></span>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small fw-bold text-uppercase d-block mb-1">Status</span>
                        <span id="modalStatus"></span>
                    </div>
                </div>
                <hr class="text-muted opacity-25">
                <div>
                    <span class="text-muted small fw-bold text-uppercase d-block mb-1">Client Notes</span>
                    <p class="small text-muted fst-italic mb-0" id="modalNote"></p>
                </div>
            </div>
            <div class="modal-footer border-top-0">
                <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        // Modal Details Populate logic
        const bookingDetailsModal = document.getElementById('bookingDetailsModal');
        if (bookingDetailsModal) {
            bookingDetailsModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                const clientName = button.getAttribute('data-client-name');
                const clientEmail = button.getAttribute('data-client-email');
                const clientPhone = button.getAttribute('data-client-phone');
                const bookingDate = button.getAttribute('data-booking-date');
                const hours = button.getAttribute('data-hours');
                const amount = button.getAttribute('data-amount');
                const status = button.getAttribute('data-status');
                const note = button.getAttribute('data-note');

                bookingDetailsModal.querySelector('#modalClientName').textContent = clientName;
                bookingDetailsModal.querySelector('#modalClientEmail').textContent = clientEmail;
                bookingDetailsModal.querySelector('#modalClientPhone').textContent = clientPhone;
                bookingDetailsModal.querySelector('#modalBookingDate').textContent = bookingDate;
                bookingDetailsModal.querySelector('#modalHours').textContent = hours + ' hrs';
                bookingDetailsModal.querySelector('#modalAmount').textContent = '₹' + amount;
                bookingDetailsModal.querySelector('#modalStatus').textContent = status;
                bookingDetailsModal.querySelector('#modalStatus').className = 'status-pill status-' + status;
                bookingDetailsModal.querySelector('#modalNote').textContent = note;
            });
        }

        // WebSocket live updates handler
        const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null; // Disable debug log

        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/worker-bookings/${user.id}', function (message) {
                if (message.body === 'REFRESH') {
                    showRealTimeNotification('New updates received. Refreshing dashboard...');
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

        // Graph Logic
        var ctx = document.getElementById('bookingsChart');
        if (ctx) {
            if (typeof Chart === 'undefined') {
                console.error("Chart.js failed to load!");
                return;
            }
            var rawBookings = [
                <c:forEach var="b" items="${incomingBookings}" varStatus="status">
                    {
                        time: '${b.bookingDate}',
                        status: '${b.status}'
                    }${!status.last ? ',' : ''}
                </c:forEach>
            ];

            var buckets = {
                "00:00": 0, "04:00": 0, "08:00": 0,
                "12:00": 0, "16:00": 0, "20:00": 0
            };

            rawBookings.forEach(function(b) {
                var dateObj = new Date(b.time);
                if (!isNaN(dateObj)) {
                    var hour = dateObj.getHours();
                    var bucket = "00:00";
                    if (hour >= 4 && hour < 8) bucket = "04:00";
                    else if (hour >= 8 && hour < 12) bucket = "08:00";
                    else if (hour >= 12 && hour < 16) bucket = "12:00";
                    else if (hour >= 16 && hour < 20) bucket = "16:00";
                    else if (hour >= 20) bucket = "20:00";
                    
                    buckets[bucket]++;
                }
            });

            var labels = Object.keys(buckets);
            var dataValues = Object.values(buckets);
            
            var maxVal = Math.max(...dataValues);
            if (maxVal < 5) maxVal = 5;

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Bookings Served',
                        data: dataValues,
                        borderColor: '#7b2cbf',
                        backgroundColor: 'rgba(123, 44, 191, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: '#7b2cbf',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        x: { title: { display: true, text: 'Time (4 Hours Format)' } },
                        y: { 
                            min: 0, 
                            max: maxVal + 1, 
                            title: { display: true, text: 'Number of Bookings' }, 
                            ticks: { stepSize: 1 } 
                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>
