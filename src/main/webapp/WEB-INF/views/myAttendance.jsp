<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <style>
        :root {
            --rose: #F43F5E;
            --rose-soft: #FFF1F2;
            --navy: #0F172A;
            --muted: #64748B;
            --bg: #F8FAFC;
            --border: #E2E8F0;
        }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); color: var(--navy); margin: 0; }
        .att-wrap { padding: 96px 20px 40px; max-width: 1100px; }
        .card-panel {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(15,23,42,0.04);
            padding: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 18px;
            height: 100%;
            box-shadow: 0 2px 12px rgba(15,23,42,0.03);
        }
        .stat-label { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: var(--muted); letter-spacing: 0.04em; }
        .stat-value { font-size: 1.5rem; font-weight: 800; color: var(--navy); margin-top: 4px; }
        .stat-icon {
            width: 40px; height: 40px; border-radius: 50%;
            background: var(--rose-soft); color: var(--rose);
            display: inline-flex; align-items: center; justify-content: center;
            margin-bottom: 8px;
        }
        .btn-rose {
            background: var(--rose); color: #fff; border: none;
            border-radius: 999px; font-weight: 700; padding: 10px 20px;
        }
        .btn-rose:hover { background: #E11D48; color: #fff; }
        .btn-outline-rose {
            border: 1px solid var(--border); color: var(--navy);
            background: #fff; border-radius: 999px; font-weight: 600;
            padding: 8px 16px; text-decoration: none;
        }
        .btn-outline-rose:hover { background: var(--rose-soft); color: var(--navy); }
        .qr-visual {
            width: 120px; height: 120px; border-radius: 16px;
            background: var(--rose-soft); border: 2px dashed #FECDD3;
            display: flex; align-items: center; justify-content: center;
            color: var(--rose); font-size: 2.5rem; flex-shrink: 0;
        }
        .status-badge {
            padding: 4px 10px; border-radius: 999px; font-size: 0.72rem; font-weight: 700;
        }
        .status-badge.PRESENT { background: #DCFCE7; color: #166534; }
        .status-badge.ABSENT { background: #FEE2E2; color: #991B1B; }
        .status-badge.LATE { background: #FEF3C7; color: #92400E; }
        .filter-row { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 16px; }
        .filter-row .form-control, .filter-row .form-select {
            border-radius: 10px; border-color: var(--border); min-width: 160px;
        }
        .att-table { width: 100%; border-collapse: collapse; }
        .att-table th {
            font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em;
            color: var(--muted); font-weight: 700; padding: 12px; border-bottom: 1px solid var(--border);
            background: #FAFBFC;
        }
        .att-table td { padding: 12px; border-bottom: 1px solid #F1F5F9; font-size: 0.9rem; vertical-align: middle; }
        .att-mobile-card {
            display: none;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 14px;
            margin-bottom: 10px;
            background: #fff;
        }
        @media (max-width: 768px) {
            .att-wrap { padding-top: 24px; }
            .att-table-wrap { display: none; }
            .att-mobile-card { display: block; }
            .qr-checkin-inner { flex-direction: column !important; text-align: center; }
        }
        @media (min-width: 769px) {
            .att-mobile-list { display: none; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height:100vh; background:var(--bg);">
            <div class="container att-wrap">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                    <div>
                        <h1 class="h3 fw-bold mb-1">Attendance</h1>
                        <p class="text-muted mb-0">Track your Martial Arts training attendance and check into active sessions.</p>
                    </div>
                    <a class="btn-outline-rose" href="${pageContext.request.contextPath}/centres/allacceptedcentres">
                        <i class="bi bi-arrow-left me-1"></i> Back to Martial Arts
                    </a>
                </div>

                <!-- Check-in -->
                <div class="card-panel">
                    <h5 class="fw-bold mb-1">Check in to your Martial Arts class</h5>
                    <p class="text-muted small mb-3">
                        Scan the QR displayed by your Martial Arts centre using the Fight D Fear mobile app,
                        or enter the session code manually below.
                    </p>
                    <div class="d-flex flex-wrap align-items-center gap-4 qr-checkin-inner">
                        <div class="qr-visual" aria-hidden="true">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width:240px;">
                            <p class="small text-muted mb-2"><strong>Mobile:</strong> Open Martial Arts → Scan QR to Check In</p>
                            <label class="form-label small fw-semibold mb-1">Session Code</label>
                            <div class="d-flex flex-wrap gap-2">
                                <input type="text" id="qrTokenInput" class="form-control" style="max-width:320px;" placeholder="Paste or enter session token">
                                <button type="button" class="btn-rose" onclick="submitQrCheckIn()">Check In</button>
                            </div>
                            <p id="qrCheckInMsg" class="small mt-2 mb-0"></p>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-lg-3">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-journal-check"></i></div>
                            <div class="stat-label">Total Classes</div>
                            <div class="stat-value">${not empty totalClasses ? totalClasses : 0}</div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#DCFCE7;color:#166534;"><i class="bi bi-check-circle"></i></div>
                            <div class="stat-label">Present</div>
                            <div class="stat-value">${not empty presentCount ? presentCount : 0}</div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#FEE2E2;color:#991B1B;"><i class="bi bi-x-circle"></i></div>
                            <div class="stat-label">Absent</div>
                            <div class="stat-value">${not empty absentCount ? absentCount : 0}</div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="stat-card">
                            <div class="stat-icon" style="background:#FEF3C7;color:#92400E;"><i class="bi bi-percent"></i></div>
                            <div class="stat-label">Attendance %</div>
                            <div class="stat-value">${not empty attendancePercentage ? attendancePercentage : '0.0'}%</div>
                        </div>
                    </div>
                </div>

                <!-- Online classes today -->
                <div id="todayClassesPanel" style="display:none;" class="card-panel mb-3">
                    <h5 class="fw-bold mb-3"><i class="bi bi-camera-video text-danger me-2"></i>Today's Online Classes</h5>
                    <div id="todayClassesList" class="row g-3"></div>
                </div>

                <!-- Filters -->
                <div class="card-panel">
                    <h5 class="fw-bold mb-3">Attendance History</h5>
                    <div class="filter-row">
                        <input type="text" id="searchInput" class="form-control flex-grow-1" placeholder="Search by batch or trainer...">
                        <select id="monthFilter" class="form-select">
                            <option value="">All Months</option>
                            <option value="01">January</option><option value="02">February</option>
                            <option value="03">March</option><option value="04">April</option>
                            <option value="05">May</option><option value="06">June</option>
                            <option value="07">July</option><option value="08">August</option>
                            <option value="09">September</option><option value="10">October</option>
                            <option value="11">November</option><option value="12">December</option>
                        </select>
                        <select id="statusFilter" class="form-select">
                            <option value="">All Status</option>
                            <option value="PRESENT">Present</option>
                            <option value="ABSENT">Absent</option>
                            <option value="LATE">Late</option>
                        </select>
                    </div>

                    <!-- Desktop table -->
                    <div class="att-table-wrap table-responsive">
                        <table class="att-table" id="attendanceTable">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Batch</th>
                                    <th>Time Slot</th>
                                    <th>Trainer</th>
                                    <th>Status</th>
                                    <th>Duration</th>
                                    <th>Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${attendances}">
                                    <c:set var="monthVal" value="" />
                                    <c:choose>
                                        <c:when test="${not empty item.session}">
                                            <c:set var="monthVal" value="${item.session.date.monthValue}" />
                                        </c:when>
                                        <c:when test="${not empty item.onlineClass}">
                                            <c:set var="monthVal" value="${item.onlineClass.date.monthValue}" />
                                        </c:when>
                                    </c:choose>
                                    <tr class="attendance-row"
                                        data-month="${monthVal < 10 ? '0' : ''}${monthVal}"
                                        data-status="${item.status}">
                                        <td class="fw-semibold">
                                            <c:choose>
                                                <c:when test="${not empty item.session}">${item.session.date}</c:when>
                                                <c:when test="${not empty item.onlineClass}">${item.onlineClass.date}</c:when>
                                                <c:otherwise>${item.attendanceDate}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.session && not empty item.session.batch}">${item.session.batch.name}</c:when>
                                                <c:when test="${not empty item.batch}">${item.batch.name}</c:when>
                                                <c:when test="${not empty item.onlineClass}">${item.onlineClass.title}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.session}">${item.session.startTime} – ${item.session.endTime}</c:when>
                                                <c:when test="${not empty item.onlineClass}">${item.onlineClass.startTime} – ${item.onlineClass.endTime}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.session}"><c:out value="${item.session.trainer}"/></c:when>
                                                <c:when test="${not empty item.trainer}"><c:out value="${item.trainer.fullName}"/></c:when>
                                                <c:when test="${not empty item.onlineClass && not empty item.onlineClass.trainer}"><c:out value="${item.onlineClass.trainer.fullName}"/></c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="status-badge ${item.status}">${item.status}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.session}"><c:out value="${item.session.duration}"/></c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small"><c:out value="${not empty item.notes ? item.notes : '—'}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <c:if test="${empty attendances}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-clipboard-x display-4 d-block mb-2 opacity-25"></i>
                                <p class="fw-semibold mb-0">No attendance records yet.</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Mobile cards (same rows, filtered by JS) -->
                    <div class="att-mobile-list">
                        <c:forEach var="item" items="${attendances}">
                            <c:set var="monthVal" value="" />
                            <c:choose>
                                <c:when test="${not empty item.session}"><c:set var="monthVal" value="${item.session.date.monthValue}" /></c:when>
                                <c:when test="${not empty item.onlineClass}"><c:set var="monthVal" value="${item.onlineClass.date.monthValue}" /></c:when>
                            </c:choose>
                            <div class="att-mobile-card attendance-row"
                                 data-month="${monthVal < 10 ? '0' : ''}${monthVal}"
                                 data-status="${item.status}">
                                <div class="d-flex justify-content-between mb-1">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty item.session && not empty item.session.batch}">${item.session.batch.name}</c:when>
                                            <c:when test="${not empty item.onlineClass}">${item.onlineClass.title}</c:when>
                                            <c:otherwise>Training</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span class="status-badge ${item.status}">${item.status}</span>
                                </div>
                                <div class="small text-muted">
                                    <c:choose>
                                        <c:when test="${not empty item.session}">${item.session.date}</c:when>
                                        <c:when test="${not empty item.onlineClass}">${item.onlineClass.date}</c:when>
                                        <c:otherwise>${item.attendanceDate}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty attendances}">
                            <p class="text-muted text-center py-4 mb-0">No attendance records yet.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        async function submitQrCheckIn() {
            const input = document.getElementById('qrTokenInput');
            const msg = document.getElementById('qrCheckInMsg');
            const token = (input.value || '').trim();
            msg.style.color = '#64748B';
            if (!token) {
                msg.style.color = '#DC2626';
                msg.textContent = 'Enter the session code from your centre.';
                return;
            }
            msg.textContent = 'Checking in...';
            try {
                const res = await fetch('${pageContext.request.contextPath}/api/attendance/qr-checkin', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ token: token })
                });
                const data = await res.json();
                if (!res.ok || data.success === false) {
                    msg.style.color = '#DC2626';
                    msg.textContent = data.error || 'Check-in failed. Ask your centre for a new QR if it expired.';
                    return;
                }
                msg.style.color = '#F43F5E';
                msg.textContent = data.message || 'Attendance recorded successfully.';
                input.value = '';
                setTimeout(function() { location.reload(); }, 800);
            } catch (e) {
                msg.style.color = '#DC2626';
                msg.textContent = 'Network error. Please try again.';
            }
        }

        document.getElementById('searchInput').addEventListener('input', filterTable);
        document.getElementById('monthFilter').addEventListener('change', filterTable);
        document.getElementById('statusFilter').addEventListener('change', filterTable);

        function filterTable() {
            const search = document.getElementById('searchInput').value.toLowerCase();
            const month = document.getElementById('monthFilter').value;
            const status = document.getElementById('statusFilter').value;
            document.querySelectorAll('.attendance-row').forEach(function(row) {
                const text = row.innerText.toLowerCase();
                const rowMonth = row.dataset.month || '';
                const rowStatus = row.dataset.status || '';
                const matchSearch = !search || text.includes(search);
                const matchMonth = !month || rowMonth === month;
                const matchStatus = !status || rowStatus === status;
                row.style.display = (matchSearch && matchMonth && matchStatus) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
