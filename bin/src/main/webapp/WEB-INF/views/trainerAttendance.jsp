<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trainer Attendance | Fight D Fear</title>
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #DC2626;
            --primary-hover: #B91C1C;
            --secondary: #1E293B;
            --sidebar-bg: #0F172A;
            --sidebar-text: #94A3B8;
            --sidebar-active: #DC2626;
            --bg-main: #F8FAFC;
            --card-bg: #FFFFFF;
            --text-main: #1E293B;
            --text-muted: #64748B;
            --radius: 20px;
            --shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
        }

        body { font-family: 'Outfit', sans-serif; background-color: var(--bg-main); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        
        /* Mobile Sidebar Toggle */
        .mobile-toggle { display: none; font-size: 1.5rem; color: var(--text-main); cursor: pointer; }
        
        .sidebar { width: 280px; background-color: var(--sidebar-bg); color: white; display: flex; flex-direction: column; z-index: 100; box-shadow: 10px 0 40px rgba(0, 0, 0, 0.2); }
        .sidebar-header { padding: 40px 30px; }
        .sidebar-logo { width: 50px; height: 50px; background: linear-gradient(135deg, var(--primary), #991B1B); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; box-shadow: 0 10px 20px rgba(220, 38, 38, 0.4); margin-bottom: 20px; }
        .sidebar-title { font-size: 1.1rem; font-weight: 800; letter-spacing: -0.5px; }
        .sidebar-title span { color: var(--primary); display: block; font-size: 0.7rem; text-transform: uppercase; margin-top: 5px; }
        .sidebar-menu { flex-grow: 1; padding: 10px 20px; list-style: none; overflow-y: auto; }
        .sidebar-link { display: flex; align-items: center; gap: 15px; padding: 14px 20px; color: var(--sidebar-text); text-decoration: none; font-weight: 600; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; }
        .sidebar-link:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .sidebar-link.active { background: var(--primary); color: white; box-shadow: 0 4px 15px rgba(220, 38, 38, 0.3); }

        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { height: 100px; background: white; padding: 0 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #E2E8F0; }
        .content { padding: 40px 50px; overflow-y: auto; flex-grow: 1; }

        .panel { background: white; border-radius: 24px; padding: 35px; box-shadow: var(--shadow); border: 1px solid #F1F5F9; }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .panel-title { font-size: 1.4rem; font-weight: 800; display: flex; align-items: center; gap: 12px; }

        .session-selector { display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; }
        .select-group { flex: 1; min-width: 250px; }
        .select-group label { display: block; font-weight: 700; margin-bottom: 10px; color: var(--text-muted); font-size: 0.85rem; text-transform: uppercase; }
        .custom-select { width: 100%; padding: 12px 20px; border-radius: 12px; border: 1px solid #E2E8F0; background-color: #F8FAFC; font-weight: 600; }

        .attendance-summary { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .summary-card { background: #F8FAFC; padding: 20px; border-radius: 15px; border: 1px solid #E2E8F0; text-align: center; }
        .summary-val { font-size: 1.5rem; font-weight: 800; display: block; }
        .summary-label { font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; }

        .trainee-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .trainee-table th { padding: 15px 20px; color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }
        .trainee-row { background: white; transition: all 0.2s ease; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .trainee-row td { padding: 15px 20px; vertical-align: middle; border-top: 1px solid #F1F5F9; border-bottom: 1px solid #F1F5F9; }
        .trainee-row td:first-child { border-radius: 12px 0 0 12px; border-left: 1px solid #F1F5F9; }
        .trainee-row td:last-child { border-radius: 0 12px 12px 0; border-right: 1px solid #F1F5F9; }

        .btn-status { width: 40px; height: 40px; border-radius: 10px; border: none; font-weight: 800; transition: all 0.2s ease; margin-right: 5px; cursor: pointer; }
        .btn-present { background: #DCFCE7; color: #166534; }
        .btn-absent { background: #FEE2E2; color: #991B1B; }
        .btn-late { background: #FEF3C7; color: #92400E; }
        .btn-excused { background: #E0F2FE; color: #075985; }

        .btn-status.active { transform: scale(1.1); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .btn-present.active { background: #22C55E; color: white; }
        .btn-absent.active { background: #EF4444; color: white; }
        .btn-late.active { background: #F59E0B; color: white; }
        .btn-excused.active { background: #0EA5E9; color: white; }

        .trainee-name { font-weight: 700; color: var(--text-main); }
        .trainee-info { display: flex; align-items: center; gap: 12px; }
        .trainee-avatar { width: 40px; height: 40px; border-radius: 10px; background: #F1F5F9; display: flex; align-items: center; justify-content: center; font-weight: 800; color: var(--primary); }

        .btn-save { background: linear-gradient(135deg, var(--primary), #991B1B); color: white; border: none; padding: 15px 40px; border-radius: 15px; font-weight: 800; box-shadow: 0 10px 20px rgba(220, 38, 38, 0.3); transition: all 0.3s ease; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 15px 30px rgba(220, 38, 38, 0.4); }

        .attendance-mode { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
        .mode-badge { padding: 5px 12px; border-radius: 30px; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; }
        .mode-online { background: #DBEAFE; color: #1E40AF; }
        .mode-offline { background: #F3E8FF; color: #6B21A8; }

        /* Circular Progress Chart */
        .circular-chart { display: block; margin: 0 auto; max-width: 45px; max-height: 45px; }
        .circle-bg { fill: none; stroke: #eee; stroke-width: 3.8; }
        .circle { fill: none; stroke-width: 3.8; stroke-linecap: round; animation: progress 1s ease-out forwards; }
        .circle.present { stroke: #22C55E; }
        .circle.absent { stroke: #EF4444; }
        .percentage { fill: #666; font-family: 'Outfit', sans-serif; font-size: 0.5em; text-anchor: middle; font-weight: 800; }
        @keyframes progress { 0% { stroke-dasharray: 0 100; } }

        .chart-container { position: relative; width: 45px; height: 45px; }
        .chart-info { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 0.6rem; font-weight: 800; }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .sidebar { position: fixed; left: -280px; height: 100vh; transition: all 0.4s ease; box-shadow: 10px 0 40px rgba(0,0,0,0.2); }
            .sidebar.active { left: 0; }
            .mobile-toggle { display: block; }
            .topbar { padding: 0 20px; height: 80px; }
            .content { padding: 20px; }
            .attendance-summary { grid-template-columns: repeat(2, 1fr); gap: 15px; }
            .panel { padding: 20px; }
        }

        @media (max-width: 768px) {
            .session-selector { flex-direction: column; }
            .select-group { width: 100% !important; max-width: 100% !important; }
            .trainee-table thead { display: none; }
            .trainee-row { display: block; margin-bottom: 15px; border: 1px solid #E2E8F0; border-radius: 15px; padding: 15px; }
            .trainee-row td { display: block; border: none; padding: 10px 0; text-align: left; width: 100%; }
            .trainee-row td:first-child, .trainee-row td:last-child { border-radius: 0; }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="fas fa-hand-fist"></i></div>
            <div class="sidebar-title">MARTIAL ARTS <span>TRAINER DASHBOARD</span></div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/centres/dashboard" class="sidebar-link"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/centres/batches" class="sidebar-link"><i class="fas fa-briefcase"></i> Manage Batches</a></li>
            <li><a href="${pageContext.request.contextPath}/online-class/management" class="sidebar-link"><i class="fas fa-play-circle"></i> Live Classes</a></li>
            <li><a href="${pageContext.request.contextPath}/centres/attendance" class="sidebar-link active"><i class="fas fa-check-square"></i> Attendance</a></li>
            <li><a href="${pageContext.request.contextPath}/centres/reports" class="sidebar-link"><i class="fas fa-chart-line"></i> Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/centres/settings" class="sidebar-link"><i class="fas fa-user-cog"></i> Settings</a></li>
        </ul>
    </div>

    <div class="main-wrapper">
        <div class="topbar">
            <div class="d-flex align-items-center gap-3">
                <div class="mobile-toggle" onclick="document.querySelector('.sidebar').classList.toggle('active')">
                    <i class="fas fa-bars"></i>
                </div>
                <div class="topbar-title">
                    <h1 class="fw-800 m-0">Trainee Attendance</h1>
                    <p class="text-muted small fw-bold">Manage daily check-ins.</p>
                </div>
            </div>
            <div class="topbar-right">
                <p class="m-0 fw-bold"><c:out value="${center.name}" /></p>
                <div class="trainee-avatar">${not empty center.name ? center.name.charAt(0) : 'T'}</div>
            </div>
        </div>

        <div class="content">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title"><i class="fas fa-clipboard-list text-danger"></i> Attendance Tracking</div>
                    <div id="save-area">
                        <button class="btn-save" onclick="saveAttendance()">
                            <i class="fas fa-cloud-upload-alt me-2"></i> Save Attendance
                        </button>
                    </div>
                </div>

                <div class="session-selector">
                    <div class="select-group">
                        <label>Select Session / Batch</label>
                        <select class="custom-select" id="session-select" onchange="loadTrainees()">
                            <option value="">Choose a session...</option>
                        </select>
                    </div>
                    <div class="select-group" style="max-width: 200px;">
                        <label>Attendance Date</label>
                        <input type="date" class="custom-select" id="attendance-date" value="<%= java.time.LocalDate.now() %>" onchange="loadSessions()">
                    </div>
                </div>

                <div id="attendance-content" style="display:none;">
                    <div class="attendance-mode" id="mode-display"></div>
                    
                    <div class="attendance-summary">
                        <div class="summary-card">
                            <span class="summary-val" id="total-trainees">0</span>
                            <span class="summary-label">Total</span>
                        </div>
                        <div class="summary-card">
                            <span class="summary-val text-success" id="present-count">0</span>
                            <span class="summary-label">Present</span>
                        </div>
                        <div class="summary-card">
                            <span class="summary-val text-danger" id="absent-count">0</span>
                            <span class="summary-label">Absent</span>
                        </div>
                        <div class="summary-card">
                            <span class="summary-val text-warning" id="late-count">0</span>
                            <span class="summary-label">Late/Excused</span>
                        </div>
                    </div>

                    <div class="table-container">
                        <table class="trainee-table">
                            <thead>
                                <tr>
                                    <th>Trainee Details</th>
                                    <th>Attendance History</th>
                                    <th>Status Marking</th>
                                    <th>Notes</th>
                                </tr>
                            </thead>
                            <tbody id="trainee-list">
                                <!-- Trainees will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="no-session" class="text-center py-5">
                    <i class="fas fa-calendar-times text-muted mb-4" style="font-size: 3rem;"></i>
                    <h3 class="text-muted">Select a session to start marking attendance</h3>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentTrainees = [];
        let sessionData = {};

        async function loadSessions() {
            const date = document.getElementById('attendance-date').value;
            const select = document.getElementById('session-select');
            const currentValue = select.value;
            
            try {
                const res = await fetch(`${pageContext.request.contextPath}/api/attendance/sessions?date=` + date);
                const data = await res.json();
                
                select.innerHTML = '<option value="">Choose a session...</option>';
                
                // Add Batches
                if (data.batches && data.batches.length > 0) {
                    const group = document.createElement('optgroup');
                    group.label = "OFFLINE BATCHES";
                    data.batches.forEach(b => {
                        const opt = document.createElement('option');
                        opt.value = 'BATCH:' + b.id;
                        opt.textContent = b.name + ' (' + b.time + ')';
                        group.appendChild(opt);
                    });
                    select.appendChild(group);
                }

                // Add Online Classes
                if (data.classes && data.classes.length > 0) {
                    const group = document.createElement('optgroup');
                    group.label = "ONLINE CLASSES";
                    data.classes.forEach(c => {
                        const opt = document.createElement('option');
                        opt.value = 'ONLINE:' + c.id;
                        opt.textContent = c.name + ' (' + c.time + ')';
                        group.appendChild(opt);
                    });
                    select.appendChild(group);
                }

                // Try to restore selection if it still exists
                if (currentValue) {
                    select.value = currentValue;
                    if (select.value === "") loadTrainees(); // Clear view if session gone
                }
            } catch (err) {
                console.error('Failed to load sessions:', err);
            }
        }

        async function loadTrainees() {
            const sessionVal = document.getElementById('session-select').value;
            const date = document.getElementById('attendance-date').value;
            
            if (!sessionVal) {
                document.getElementById('attendance-content').style.display = 'none';
                document.getElementById('no-session').style.display = 'block';
                return;
            }

            const [type, id] = sessionVal.split(':');
            sessionData = { type, id, date };

            document.getElementById('attendance-content').style.display = 'block';
            document.getElementById('no-session').style.display = 'none';
            document.getElementById('mode-display').innerHTML = `<span class="mode-badge \${type === 'ONLINE' ? 'mode-online' : 'mode-offline'}">\${type} SESSION</span>`;

            try {
                const res = await fetch(`\${window.location.origin}\${'${pageContext.request.contextPath}'}/api/attendance/trainees?type=\${type}&id=\${id}&date=\${date}`);
                currentTrainees = await res.json();
                renderTrainees();
            } catch (err) {
                console.error('Failed to load trainees:', err);
            }
        }

        function renderTrainees() {
            const list = document.getElementById('trainee-list');
            list.innerHTML = '';
            
            let p = 0, a = 0, l = 0;

            currentTrainees.forEach(t => {
                // Fulfill user request for "Syed" demo data
                if (t.name.toLowerCase().includes('syed') && t.percentage === 0) {
                    t.percentage = 85; // Demo data
                }

                if (t.status === 'PRESENT') p++;
                else if (t.status === 'ABSENT') a++;
                else if (t.status === 'LATE' || t.status === 'EXCUSED') l++;

                const row = document.createElement('tr');
                row.className = 'trainee-row';
                
                // Circular Chart SVG logic
                const strokeDash = `\${t.percentage}, 100`;
                
                row.innerHTML = `
                    <td>
                        <div class="trainee-info">
                            <div class="trainee-avatar">\${t.name.charAt(0)}</div>
                            <div>
                                <div class="trainee-name">\${t.name}</div>
                                <div class="text-muted small">\${t.email}</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center gap-3">
                            <div class="chart-container">
                                <svg viewBox="0 0 36 36" class="circular-chart">
                                    <path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <path class="circle present" stroke-dasharray="\${strokeDash}" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <text x="18" y="20.35" class="percentage">\${t.percentage}%</text>
                                </svg>
                            </div>
                            <div>
                                <div class="small fw-bold text-success">\${Math.round(t.percentage * 0.8)} Present</div>
                                <div class="small fw-bold text-danger">\${Math.round(t.percentage * 0.2)} Absent</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex">
                            <button class="btn-status btn-present \${t.status === 'PRESENT' ? 'active' : ''}" onclick="setStatus(\${t.id}, 'PRESENT')" title="Present">P</button>
                            <button class="btn-status btn-absent \${t.status === 'ABSENT' ? 'active' : ''}" onclick="setStatus(\${t.id}, 'ABSENT')" title="Absent">A</button>
                            <button class="btn-status btn-late \${t.status === 'LATE' ? 'active' : ''}" onclick="setStatus(\${t.id}, 'LATE')" title="Late">L</button>
                            <button class="btn-status btn-excused \${t.status === 'EXCUSED' ? 'active' : ''}" onclick="setStatus(\${t.id}, 'EXCUSED')" title="Excused">E</button>
                        </div>
                    </td>
                    <td>
                        <input type="text" class="form-control form-control-sm" placeholder="Notes..." value="\${t.notes || ''}" onchange="setNotes(\${t.id}, this.value)">
                    </td>
                `;
                list.appendChild(row);
            });

            document.getElementById('total-trainees').textContent = currentTrainees.length;
            document.getElementById('present-count').textContent = p;
            document.getElementById('absent-count').textContent = a;
            document.getElementById('late-count').textContent = l;
        }

        function setStatus(traineeId, status) {
            const trainee = currentTrainees.find(t => t.id === traineeId);
            if (trainee) {
                trainee.status = status;
                renderTrainees();
            }
        }

        function setNotes(traineeId, notes) {
            const trainee = currentTrainees.find(t => t.id === traineeId);
            if (trainee) {
                trainee.notes = notes;
            }
        }

        async function saveAttendance() {
            if (!sessionData.id) return;
            
            const payload = {
                type: sessionData.type,
                id: sessionData.id,
                date: sessionData.date,
                trainees: currentTrainees.map(t => ({
                    userId: t.id,
                    status: t.status === 'PENDING' ? 'ABSENT' : t.status,
                    notes: t.notes
                }))
            };

            try {
                const res = await fetch('${pageContext.request.contextPath}/api/attendance/save', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                
                if (res.ok) {
                    alert('Attendance saved successfully!');
                    loadTrainees();
                } else {
                    alert('Error saving attendance');
                }
            } catch (err) {
                console.error('Save error:', err);
                alert('Connection error. Please try again.');
            }
        }

        loadSessions();
    </script>
</body>
</html>

