<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Attendance - Martial Arts Training</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-purple: #1e1b4b;
            --primary-purple-light: #312e81;
            --accent-coral: #f43f5e;
            --bg-light: #f8f9fa;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #1E293B;
            margin: 0;
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            height: 100vh;
            background: #0F172A;
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            padding: 24px;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
        }

        .sidebar-logo i { font-size: 2rem; }
        .sidebar-logo span { font-weight: 800; font-size: 1.25rem; letter-spacing: -0.5px; }

        .nav-menu { list-style: none; padding: 0; margin: 0; }
        .nav-item { margin-bottom: 8px; }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #94A3B8;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .nav-link:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .nav-link.active { background: #E11D48; color: white; box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3); }
        .nav-link i { font-size: 1.1rem; }

        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 32px;
            min-height: 100vh;
        }

        .dashboard-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            color: var(--primary-purple);
            font-weight: 800;
            font-size: 1.75rem;
            margin: 0;
        }

        /* Summary Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(124, 45, 94, 0.08);
            border-left: 5px solid var(--primary-purple);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--primary-purple);
            margin-top: 0.5rem;
        }

        .stat-icon {
            float: right;
            font-size: 1.5rem;
            color: var(--primary-purple-light);
            opacity: 0.5;
        }

        /* Filters */
        .filter-section {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #eee;
            padding: 0.6rem 1rem;
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: 16px;
            padding: 1rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table thead th {
            background-color: #fcfcfc;
            border-bottom: 2px solid #f1f1f1;
            padding: 1.2rem;
            font-weight: 700;
            color: #555;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }

        .table tbody td {
            padding: 1.2rem;
            vertical-align: middle;
            border-bottom: 1px solid #f8f8f8;
        }

        .btn-back {
            background: white;
            border: 1px solid #eee;
            color: #555;
            padding: 0.6rem 1.2rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 30px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
        }

        .status-badge.PRESENT { background: #dcfce7; color: #166534; }
        .status-badge.ABSENT { background: #fee2e2; color: #991b1b; }
        .status-badge.LATE { background: #fef3c7; color: #92400e; }

        .btn-back:hover {
            background: #f8f9fa;
            color: var(--primary-purple);
            border-color: var(--primary-purple-light);
        }

        .table-footer {
            padding: 1.5rem;
            border-top: 1px solid #f1f1f1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #666;
            font-size: 0.9rem;
        }

        .pagination-disabled {
            opacity: 0.5;
            pointer-events: none;
        }
    </style>
</head>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-hand-fist fa-2x text-danger"></i>
            <span>Fight D Fear</span>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link">
                    <i class="bi bi-grid"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/training-journey" class="nav-link">
                    <i class="bi bi-compass"></i> My Journey
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="nav-link active">
                    <i class="bi bi-calendar-check"></i> Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link">
                    <i class="bi bi-clock-history"></i> My Schedule
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/payment/users/my-payments" class="nav-link">
                    <i class="bi bi-wallet2"></i> Payments
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">
                    <i class="bi bi-person"></i> Profile
                </a>
            </li>
        </ul>

        <div class="mt-auto">
            <div class="card bg-white bg-opacity-10 border-0 rounded-4 p-3 text-center">
                <p class="small mb-2 text-white-50">Need Help?</p>
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-danger btn-sm w-100 rounded-3">Get Support</a>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="dashboard-container">
    <div class="page-header">
        <h1 class="page-title"><i class="fas fa-calendar-check me-2"></i>My Attendance</h1>
        <a href="${pageContext.request.contextPath}/users/training-journey" class="btn-back">
            <i class="fas fa-arrow-left me-2"></i>Back to Journey
        </a>
    </div>

    <!-- Stats Overview -->
    <div class="stats-grid">
        <div class="stat-card">
            <i class="fas fa-book-open stat-icon"></i>
            <div class="stat-label">Total Classes</div>
            <div class="stat-value">${not empty totalClasses ? totalClasses : 0}</div>
        </div>
        <div class="stat-card" style="border-left-color: #22c55e;">
            <i class="fas fa-user-check stat-icon" style="color: #22c55e;"></i>
            <div class="stat-label">Present</div>
            <div class="stat-value">${not empty presentCount ? presentCount : 0}</div>
        </div>
        <div class="stat-card" style="border-left-color: #ef4444;">
            <i class="fas fa-user-times stat-icon" style="color: #ef4444;"></i>
            <div class="stat-label">Absent</div>
            <div class="stat-value">${not empty absentCount ? absentCount : 0}</div>
        </div>
        <div class="stat-card" style="border-left-color: #f59e0b;">
            <i class="fas fa-percent stat-icon" style="color: #f59e0b;"></i>
            <div class="stat-label">Attendance %</div>
            <div class="stat-value">${not empty attendancePercentage ? attendancePercentage : '0.0'}%</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filter-section">
        <div class="flex-grow-1">
            <input type="text" id="searchInput" class="form-control" placeholder="Search by batch or trainer...">
        </div>
        <div>
            <select id="monthFilter" class="form-select">
                <option value="">All Months</option>
                <option value="01">January</option>
                <option value="02">February</option>
                <option value="03">March</option>
                <option value="04">April</option>
                <option value="05">May</option>
                <option value="06">June</option>
                <option value="07">July</option>
                <option value="08">August</option>
                <option value="09">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
            </select>
        </div>
        <div>
            <select id="statusFilter" class="form-select">
                <option value="">All Status</option>
                <option value="PRESENT">Present</option>
                <option value="ABSENT">Absent</option>
                <option value="LATE">Late</option>
            </select>
        </div>
    </div>

    <!-- Today's Online Classes – Self Check-In -->
    <div id="todayClassesPanel" style="display:none; margin-bottom: 1.5rem;">
        <div class="table-card p-3">
            <h5 class="fw-bold mb-3"><i class="fas fa-video text-danger me-2"></i>Today's Online Classes – Check In</h5>
            <div id="todayClassesList" class="row g-3"></div>
        </div>
    </div>

    <!-- Attendance Table -->
    <div class="table-card">
        <div class="table-responsive">
            <table class="table" id="attendanceTable">
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
                        <c:set var="isOnline" value="${empty item.session and not empty item.onlineClass}" />
                        <tr class="attendance-row" 
                            data-month="${not empty item.session ? (item.session.date.monthValue < 10 ? '0' : '') : (item.onlineClass.date.monthValue < 10 ? '0' : '')}${not empty item.session ? item.session.date.monthValue : item.onlineClass.date.monthValue}" 
                            data-status="${item.status}">
                            <td class="fw-bold">
                                <c:choose>
                                    <c:when test="${not empty item.session}">
                                        ${item.session.date.dayOfMonth} ${item.session.date.month} ${item.session.date.year}
                                    </c:when>
                                    <c:otherwise>
                                        ${item.onlineClass.date.dayOfMonth} ${item.onlineClass.date.month} ${item.onlineClass.date.year}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.session}">${item.session.batch.name}</c:when>
                                    <c:otherwise>${item.onlineClass.title}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.session}">${item.session.startTime} – ${item.session.endTime}</c:when>
                                    <c:otherwise>${item.onlineClass.startTime} – ${item.onlineClass.endTime}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.session}">${item.session.trainer}</c:when>
                                    <c:otherwise>${item.onlineClass.trainer.fullName}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="status-badge ${item.status}">${item.status}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.session}">${item.session.duration}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-muted small">
                                <c:choose>
                                    <c:when test="${isOnline and item.notes.contains('Joined live session at')}">
                                        <i class="fas fa-video text-danger me-1"></i>Joined Virtual Dojo
                                    </c:when>
                                    <c:otherwise>${not empty item.notes ? item.notes : '—'}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty attendances}">
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <div class="py-4">
                                    <i class="fas fa-clipboard-list mb-3 text-muted" style="font-size: 3.5rem; opacity: 0.2;"></i>
                                    <h5 class="fw-bold">No attendance records found yet</h5>
                                    <p class="text-muted small">Your attendance will appear here once training sessions begin.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        <div class="table-footer">
            <div>
                Showing ${not empty attendances ? 1 : 0} to ${not empty attendances ? attendances.size() : 0} of ${not empty attendances ? attendances.size() : 0} records
            </div>
            <nav class="pagination-disabled">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                    <li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
                </ul>
            </nav>
        </div>
    </div>
        </div>
    </main>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <script>
        // ---- Today's Online Classes Check-In ----
        (async function() {
            const today = new Date().toISOString().split('T')[0];
            try {
                const res = await fetch('${pageContext.request.contextPath}/api/attendance/sessions?date=' + today);
                if (!res.ok) return;
                const data = await res.json();
                const classes = data.classes || [];
                if (classes.length === 0) return;

                const panel = document.getElementById('todayClassesPanel');
                const list = document.getElementById('todayClassesList');
                panel.style.display = 'block';

                classes.forEach(cls => {
                    const col = document.createElement('div');
                    col.className = 'col-md-4';
                    col.innerHTML = `
                        <div class="card border-0 shadow-sm rounded-4 p-3 d-flex flex-row align-items-center gap-3">
                            <div class="bg-danger bg-opacity-10 rounded-3 p-3">
                                <i class="fas fa-video text-danger fs-4"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="fw-bold">${cls.name}</div>
                                <small class="text-muted">${cls.time}</small>
                            </div>
                            <button class="btn btn-sm btn-danger rounded-pill px-3 checkin-btn"
                                    id="checkin-${cls.id}"
                                    onclick="checkInNow(${cls.id}, '${today}', this)">
                                Check In
                            </button>
                        </div>`;
                    list.appendChild(col);
                });
            } catch(e) { /* silently ignore if no session data */ }
        })();

        async function checkInNow(onlineClassId, date, btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
            try {
                const res = await fetch('${pageContext.request.contextPath}/api/attendance/user-checkin', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ onlineClassId: onlineClassId, date: date })
                });
                if (res.ok) {
                    btn.innerHTML = '✅ Checked In';
                    btn.classList.remove('btn-danger');
                    btn.classList.add('btn-success');
                } else {
                    const msg = await res.text();
                    btn.innerHTML = '❌ Failed';
                    btn.disabled = false;
                    alert(msg || 'Check-in failed. You may not be enrolled in this class.');
                }
            } catch(e) {
                btn.innerHTML = 'Check In';
                btn.disabled = false;
                alert('Network error. Please try again.');
            }
        }

        // ---- Existing table filter logic ----
        document.getElementById('searchInput').addEventListener('input', filterTable);
        document.getElementById('monthFilter').addEventListener('change', filterTable);
        document.getElementById('statusFilter').addEventListener('change', filterTable);

        function filterTable() {
            const search = document.getElementById('searchInput').value.toLowerCase();
            const month = document.getElementById('monthFilter').value;
            const status = document.getElementById('statusFilter').value;

            document.querySelectorAll('.attendance-row').forEach(row => {
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

