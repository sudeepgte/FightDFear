<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Martial Arts Center Dashboard</title>

    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

    <!-- FontAwesome & Google Fonts -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
    :root {
        --primary: #DC2626;
        --primary-hover: #B91C1C;
        --secondary: #1E293B;
        --accent: #F59E0B;
        --sidebar-bg: #0F172A;
        --sidebar-text: #94A3B8;
        --sidebar-active: #DC2626;
        --bg-main: #F8FAFC;
        --card-bg: #FFFFFF;
        --text-main: #1E293B;
        --text-muted: #64748B;
        --radius: 20px;
        --shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
        --glass: rgba(255, 255, 255, 0.7);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: 'Outfit', sans-serif;
        background-color: var(--bg-main);
        color: var(--text-main);
        display: flex;
        height: 100vh;
        width: 100vw;
        overflow: hidden;
    }

    /* Mobile Sidebar Toggle */
    .mobile-toggle { display: none; font-size: 1.5rem; color: var(--text-main); cursor: pointer; }

    /* Sidebar */
    .sidebar {
        width: 280px;
        background-color: var(--sidebar-bg);
        color: white;
        display: flex;
        flex-direction: column;
        z-index: 100;
        box-shadow: 10px 0 40px rgba(0, 0, 0, 0.2);
    }

    /* Issue 132: Compact sidebar header so all menu items are visible */
    .sidebar-header { padding: 16px 20px; }
    .sidebar-logo {
        width: 36px; height: 36px;
        background: linear-gradient(135deg, var(--primary), #991B1B);
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.1rem;
        box-shadow: 0 6px 14px rgba(220, 38, 38, 0.4);
        margin-bottom: 10px;
    }
    .sidebar-title { font-size: 0.95rem; font-weight: 800; letter-spacing: -0.5px; }
    .sidebar-title span { color: var(--primary); display: block; font-size: 0.65rem; text-transform: uppercase; margin-top: 3px; }

    .sidebar-menu { flex-grow: 1; padding: 6px 14px; list-style: none; overflow-y: auto; }
    .sidebar-link {
        display: flex; align-items: center; gap: 12px;
        padding: 10px 16px; color: var(--sidebar-text);
        text-decoration: none; font-weight: 600; font-size: 0.88rem;
        border-radius: 10px; margin-bottom: 4px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .sidebar-link:hover { background: rgba(255, 255, 255, 0.05); color: white; transform: translateX(4px); }
    .sidebar-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3); }
    .sidebar-link.active i { color: white; }
    
    .sidebar-logout { margin-top: 20px; border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 20px; }
    .logout-btn { 
        color: #f87171 !important; 
        transition: all 0.3s;
    }
    .logout-btn:hover { 
        background: rgba(239, 68, 68, 0.1) !important; 
        color: #ef4444 !important;
        transform: translateX(5px);
    }

    .sidebar-banner {
        margin: 12px 14px;
        padding: 16px 14px;
        background: rgba(255, 255, 255, 0.03);
        border-radius: 14px;
        text-align: center;
        border: 1px solid rgba(255, 255, 255, 0.05);
    }
    .banner-icon { font-size: 1.4rem; color: var(--primary); margin-bottom: 8px; }
    .banner-text { font-size: 0.8rem; font-weight: 700; color: white; margin: 0; }

    /* Main Content */
    .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar {
        height: 100px; background: white; padding: 0 50px;
        display: flex; justify-content: space-between; align-items: center;
        border-bottom: 1px solid #E2E8F0; z-index: 90;
    }
    .topbar-title h1 { font-size: 1.8rem; font-weight: 800; letter-spacing: -1px; }
    .topbar-right { display: flex; align-items: center; gap: 25px; }

    .content { padding: 40px 50px; overflow-y: auto; flex-grow: 1; position: relative; }

    /* Cards */
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 30px; margin-bottom: 40px; }
    .stat-card {
        background: white; padding: 30px; border-radius: var(--radius);
        box-shadow: var(--shadow); transition: transform 0.3s ease;
        display: flex; flex-direction: column; gap: 15px; border: 1px solid #F1F5F9;
    }
    .stat-card:hover { transform: translateY(-8px); }
    .stat-icon { width: 55px; height: 55px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; }
    .stat-icon.red { background: #FEE2E2; color: #DC2626; }
    .stat-icon.green { background: #D1FAE5; color: #10B981; }
    .stat-icon.blue { background: #DBEAFE; color: #3B82F6; }
    .stat-icon.purple { background: #F3E8FF; color: #7C3AED; }

    .stat-val { font-size: 2.2rem; font-weight: 800; color: var(--text-main); }
    .stat-label { font-size: 0.95rem; color: var(--text-muted); font-weight: 600; }

    /* Notifications Dropdown */
    .notif-dropdown {
        position: absolute;
        top: 70px;
        right: 0;
        width: 350px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        z-index: 1100;
        display: none;
        overflow: hidden;
        border: 1px solid #eee;
        text-align: left;
    }
    .notif-dropdown.active { display: block; animation: slideDown 0.3s ease; }
    .notif-header { padding: 20px; border-bottom: 1px solid #F1F5F9; display: flex; justify-content: space-between; align-items: center; }
    .notif-item { padding: 15px 20px; border-bottom: 1px solid #F1F5F9; transition: all 0.2s; cursor: pointer; }
    .notif-item:hover { background: #F8FAFC; }
    .notif-item.unread { border-left: 4px solid var(--primary); background: #FFF5F5; }
    
    @keyframes slideDown {
        from { transform: translateY(-10px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }

    /* Panels */
    .panel { background: white; border-radius: 24px; padding: 35px; box-shadow: var(--shadow); border: 1px solid #F1F5F9; }
    .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .panel-title { font-size: 1.4rem; font-weight: 800; display: flex; align-items: center; gap: 12px; }

    /* Modern Tables */
    .table-container { overflow-x: auto; }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
    .custom-table th { padding: 15px 25px; color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; border: none; }
    .custom-table tr { background: white; transition: all 0.2s ease; }
    .custom-table tr:hover { transform: scale(1.01); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
    .custom-table td { padding: 20px 25px; border: none; vertical-align: middle; background: #fdfdfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
    .custom-table td:first-child { border-radius: 12px 0 0 12px; border-left: 1px solid #f1f5f9; }
    .custom-table td:last-child { border-radius: 0 12px 12px 0; border-right: 1px solid #f1f5f9; }

    .badge-pill { padding: 8px 16px; border-radius: 30px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; }

    /* Animations */
    .fade-in { animation: fadeIn 0.4s ease-out; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

    /* Buttons */
    .btn-premium { background: linear-gradient(135deg, var(--primary), #991B1B); color: white; border: none; padding: 14px 28px; border-radius: 15px; font-weight: 700; transition: all 0.3s ease; box-shadow: 0 10px 20px rgba(220, 38, 38, 0.3); }
    .btn-premium:hover { transform: translateY(-2px); box-shadow: 0 15px 30px rgba(220, 38, 38, 0.4); color: white; }

    /* Class Cards */
    .class-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 35px; }
    .class-card { background: white; border-radius: 24px; overflow: hidden; box-shadow: var(--shadow); border: 1px solid #F1F5F9; transition: all 0.4s ease; }
    .class-card:hover { transform: translateY(-10px); box-shadow: 0 30px 60px -12px rgba(0,0,0,0.15); }
    .class-img { height: 220px; position: relative; }
    .class-img img { width: 100%; height: 100%; object-fit: cover; }
    .class-body { padding: 30px; }
    .class-name { font-size: 1.5rem; font-weight: 800; margin-bottom: 10px; }

    /* Responsive Styles */
    @media (max-width: 992px) {
        body { height: auto; overflow-y: auto !important; display: block; width: 100%; max-width: 100%; }
        .main-wrapper { height: auto; min-height: 100vh; overflow: visible; display: block; width: 100%; max-width: 100%; }
        .sidebar { position: fixed; left: -280px; top: 0; bottom: 0; height: 100%; transition: all 0.4s ease; z-index: 1000; width: 280px; }
        .sidebar.active { left: 0; }
        .sidebar-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 999; }
        .sidebar-overlay.active { display: block; }
        .mobile-toggle { display: block; }
        .topbar { padding: 0 15px; position: sticky; top: 0; background: white; z-index: 99; height: 60px; width: 100%; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .content { padding: 12px; overflow: visible; height: auto; flex: none; width: 100%; }
        .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 15px; }
        .panel { padding: 15px; margin-bottom: 15px; height: auto !important; width: 100%; border-radius: 12px; }
        .topbar-title h1 { font-size: 1.1rem; }
        .stat-card { padding: 12px; gap: 8px; }
        .stat-val { font-size: 1.3rem; }
        .table-container { overflow-x: auto; -webkit-overflow-scrolling: touch; }
    }

    @media (max-width: 576px) {
        .stats-grid { grid-template-columns: 1fr; }
        .panel-header { flex-direction: row; align-items: center; justify-content: space-between; gap: 10px; }
        .custom-table th, .custom-table td { padding: 10px; font-size: 0.75rem; }
        .topbar-title h1 { font-size: 1rem; }
        .topbar-right { display: none; }
    }
    </style>
</head>
<body>

    <!-- SIDEBAR OVERLAY -->
    <div class="sidebar-overlay" onclick="document.querySelector('.sidebar').classList.remove('active'); this.classList.remove('active');"></div>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="fas fa-hand-fist"></i></div>
            <div class="sidebar-title">MARTIAL ARTS <span>TRAINER DASHBOARD</span></div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="#" class="sidebar-link" data-tab="dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="#" class="sidebar-link" data-tab="batches"><i class="fas fa-briefcase"></i> Manage Batches</a></li>
            <li><a href="#" class="sidebar-link" data-tab="live-classes"><i class="fas fa-play-circle"></i> Live Classes</a></li>
            <li><a href="#" class="sidebar-link" data-tab="students"><i class="fas fa-users"></i> Students</a></li>
            <li><a href="#" class="sidebar-link" data-tab="bookings"><i class="fas fa-calendar-alt"></i> Bookings</a></li>
            <li><a href="#" class="sidebar-link" data-tab="class-types"><i class="fas fa-list-alt"></i> Class Types</a></li>
            <li><a href="#" class="sidebar-link" data-tab="attendance"><i class="fas fa-check-square"></i> Attendance</a></li>
            <li><a href="#" class="sidebar-link" data-tab="reports"><i class="fas fa-chart-line"></i> Reports</a></li>
            <li><a href="#" class="sidebar-link" data-tab="settings"><i class="fas fa-user-cog"></i> Settings</a></li>

            <li class="sidebar-logout">
                <a href="${pageContext.request.contextPath}/centres/logout" class="logout-btn" style="display:flex;align-items:center;gap:15px;padding:14px 20px;color:#f87171;text-decoration:none;font-weight:600;border-radius:12px;transition:all 0.3s;">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>



        </ul>
        <div class="sidebar-banner">
            <div class="banner-icon"><i class="fas fa-trophy"></i></div>
            <p class="banner-text">Empower. Train. Achieve.</p>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main-wrapper">
        <div class="topbar">
            <div class="d-flex align-items-center gap-3">
                <div class="mobile-toggle" onclick="document.querySelector('.sidebar').classList.toggle('active'); document.querySelector('.sidebar-overlay').classList.toggle('active');">
                    <i class="fas fa-bars"></i>
                </div>
                <div class="topbar-title">
                    <h1>Trainer Overview</h1>
                    <p class="text-muted small fw-bold">Welcome back, <c:out value="${center.name}" />!</p>
                </div>
            </div>
            <div class="topbar-right">
                <div style="position: relative; cursor: pointer;" onclick="App.toggleNotifications(event)">
                    <i class="far fa-bell" style="font-size: 1.4rem;"></i>
                    <span style="position: absolute; top: -5px; right: -5px; width: 10px; height: 10px; background: var(--primary); border-radius: 50%; border: 2px solid white;"></span>
                    
                    <div id="notif-panel" class="notif-dropdown">
                        <div class="notif-header">
                            <h5 class="fw-bold mb-0">Notifications</h5>
                            <span id="notif-badge" class="badge bg-danger">0 New</span>
                        </div>
                        <div id="notif-list" class="notif-list"></div>
                        <div class="p-2 text-center border-top">
                            <button class="btn btn-sm btn-link text-danger text-decoration-none fw-bold" onclick="App.navigate('notifications')">View All Notifications</button>
                        </div>
                    </div>
                </div>
                <div id="topbar-avatar" style="width: 50px; height: 50px; background: var(--primary); border-radius: 15px; display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; border: 1px solid #E2E8F0; overflow: hidden; font-size: 1.4rem; box-shadow: 0 4px 12px rgba(220, 38, 38, 0.2);">
                    <c:choose>
                        <c:when test="${not empty center.name}">
                            <c:out value="${center.name.substring(0, 1).toUpperCase()}" />
                        </c:when>
                        <c:otherwise>T</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="content" id="app-root">
            <!-- DYNAMIC CONTENT INJECTED HERE -->
        </div>
    </div>

    <script>
        /**
         * DYNAMIC DASHBOARD ENGINE (SPA)
         */
        const App = {
            ctx: '${pageContext.request.contextPath}',
            state: {
                activeTab: '${currentTab}' || 'dashboard',
                batches: ${not empty batchesJson ? batchesJson : '[]'},
                enrollments: ${not empty enrollmentsJson ? enrollmentsJson : '[]'},
                center: ${not empty centerJson ? centerJson : '{}'},
                meta: ${not empty dashboardMetaJson ? dashboardMetaJson : '{}'},
                user: { name: '<c:out value="${center.name}" />' },
                userLogo: null,
                loading: false
            },

            init() {
                if (App.state.center && App.state.center.profilePhoto) {
                    App.state.userLogo = App.ctx + App.state.center.profilePhoto;
                    const avatar = document.getElementById('topbar-avatar');
                    if (avatar) {
                        avatar.innerHTML = '<img src="' + App.state.userLogo + '" style="width:100%;height:100%;object-fit:cover;">';
                    }
                }
                App.renderNotifications();
                console.log('App Initializing...');
                // Intercept Navigation
                document.querySelectorAll('.sidebar-link').forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const tab = link.getAttribute('data-tab');
                        this.navigate(tab);
                        if(window.innerWidth <= 992) {
                            document.querySelector('.sidebar').classList.remove('active');
                            const overlay = document.querySelector('.sidebar-overlay');
                            if(overlay) overlay.classList.remove('active');
                        }
                    });
                });

                // History Support
                window.addEventListener('popstate', (e) => {
                    if (e.state && e.state.tab) this.navigate(e.state.tab, false);
                });

                // Initial navigation
                this.navigate(this.state.activeTab, false);
            },

            navigate(tab, updateHistory = true) {
                console.log('Navigating to:', tab);
                this.state.activeTab = tab || 'dashboard';
                if (updateHistory) {
                    const path = '${pageContext.request.contextPath}/centres/' + this.state.activeTab;
                    window.history.pushState({ tab: this.state.activeTab }, '', path);
                }
                this.render();
                this.updateActiveLink();

                // Fallback for avatar: Only apply if NO logo exists and NO text exists
                const avatar = document.getElementById('topbar-avatar');
                if (avatar && !avatar.querySelector('img') && avatar.innerText.trim() === '') {
                    avatar.innerText = (this.state.user.name || 'T').charAt(0).toUpperCase();
                }
                
                // Re-apply logo if it was uploaded in this session
                if (avatar && this.state.userLogo && !avatar.querySelector('img')) {
                    avatar.innerHTML = `<img src="\${this.state.userLogo}" style="width:100%; height:100%; object-fit:cover;">`;
                }
            },

            updateActiveLink() {
                document.querySelectorAll('.sidebar-link').forEach(link => {
                    link.classList.toggle('active', link.getAttribute('data-tab') === this.state.activeTab);
                });
            },

            filterTrainees(val) {
                const query = val.toLowerCase();
                const rows = document.querySelectorAll('#trainee-table tbody tr');
                rows.forEach(row => {
                    const text = row.innerText.toLowerCase();
                    row.style.display = text.includes(query) ? '' : 'none';
                });
            },

            viewTraineeProfile(id) {
                const trainee = this.state.enrollments.find(e => e.id === id);
                if (!trainee) return;
                alert('Detailed Profile for ' + trainee.traineeName + '\nEmail: ' + trainee.email + '\nLast Attended: ' + (trainee.lastAttendedDate || 'Never'));
                // In a real app, this would open a Modal with more tabs for attendance, payments etc.
            },

            manageBooking(id) {
                const e = this.state.enrollments.find(en => en.id === id);
                if (!e) return;
                const action = confirm('Manage booking for ' + e.traineeName + '\n\nOK to APPROVE, Cancel to REJECT (Mock logic)');
                if (action) {
                    alert('Booking approved for ' + e.traineeName);
                    e.enrollmentStatus = 'APPROVED';
                    e.paymentStatus = 'PAID';
                } else {
                    alert('Booking rejected for ' + e.traineeName);
                    e.enrollmentStatus = 'REJECTED';
                }
                this.render();
            },

            handleLogoUpload(input) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        const preview = document.getElementById('logo-preview');
                        const topbarAvatar = document.getElementById('topbar-avatar');
                        this.state.userLogo = e.target.result;
                        const imgHtml = '<img src="' + e.target.result + '" style="width:100%; height:100%; object-fit:cover;">';
                        if (preview) preview.innerHTML = imgHtml;
                        if (topbarAvatar) topbarAvatar.innerHTML = imgHtml;
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            },

            async saveSettings() {
                const formData = new FormData();
                formData.append('name', document.getElementById('settingsName').value);
                formData.append('email', document.getElementById('settingsEmail').value);
                formData.append('phoneNumber', document.getElementById('settingsPhone').value);
                formData.append('location', document.getElementById('settingsLocation').value);
                formData.append('about', document.getElementById('settingsAbout').value);
                formData.append('howWeTeach', document.getElementById('settingsHowWeTeach').value);
                formData.append('whatWeOffer', document.getElementById('settingsWhatWeOffer').value);
                const logoInput = document.getElementById('logoInput');
                if (logoInput && logoInput.files && logoInput.files[0]) {
                    formData.append('profileImage', logoInput.files[0]);
                }
                const galleryInput = document.getElementById('galleryInput');
                if (galleryInput && galleryInput.files) {
                    for (let i = 0; i < galleryInput.files.length; i++) {
                        formData.append('galleryPhotos', galleryInput.files[i]);
                    }
                }
                try {
                    const res = await fetch(App.ctx + '/centres/settings', { method: 'POST', body: formData });
                    const result = await res.json();
                    if (result.status === 'success') {
                        App.state.center = result.center;
                        App.state.user.name = result.center.name;
                        if (result.center.profilePhoto) {
                            App.state.userLogo = App.ctx + result.center.profilePhoto;
                        }
                        document.querySelector('.topbar-title p').innerHTML = 'Welcome back, ' + App.escapeHtml(result.center.name) + '!';
                        alert(result.message);
                    } else {
                        alert(result.message || 'Could not save profile');
                    }
                } catch (err) {
                    console.error(err);
                    alert('Failed to save settings');
                }
            },

            renderNotifications() {
                const list = document.getElementById('notif-list');
                const badge = document.getElementById('notif-badge');
                const items = (App.state.meta && App.state.meta.notifications) ? App.state.meta.notifications : [];
                const unread = App.state.meta && App.state.meta.unreadCount != null ? App.state.meta.unreadCount : 0;
                if (badge) badge.innerText = unread + ' New';
                if (!list) return;
                if (items.length === 0) {
                    list.innerHTML = '<div class="p-4 text-center text-muted small">No notifications yet</div>';
                    return;
                }
                list.innerHTML = items.slice(0, 5).map(function(n) {
                    return '<div class="notif-item ' + (n.unread ? 'unread' : '') + '">' +
                        '<div class="fw-bold small">' + App.escapeHtml(n.title) + '</div>' +
                        '<div class="text-muted small">' + App.escapeHtml(n.detail) + '</div>' +
                        '<div class="text-primary smaller mt-1" style="font-size:0.7rem;">' + App.escapeHtml(n.timeLabel || '') + '</div></div>';
                }).join('');
            },

            escapeHtml(text) {
                if (text == null) return '';
                return String(text).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
            },

            toggleNotifications(e) {
                if (e) e.stopPropagation();
                const panel = document.getElementById('notif-panel');
                panel.classList.toggle('active');
                
                // Close on outside click
                const closer = (event) => {
                    if (!panel.contains(event.target)) {
                        panel.classList.remove('active');
                        document.removeEventListener('click', closer);
                    }
                };
                if (panel.classList.contains('active')) {
                    document.addEventListener('click', closer);
                }
            },

            async submitBatch() {
                const data = {
                    name: document.getElementById('batchName').value,
                    startDate: document.getElementById('batchStartDate').value,
                    endDate: document.getElementById('batchEndDate').value,
                    instructor: document.getElementById('batchInstructor').value,
                    ageGroup: document.getElementById('batchAgeGroup').value,
                    skillLevel: document.getElementById('batchSkillLevel').value,
                    style: document.getElementById('batchStyle').value,
                    location: document.getElementById('batchLocation').value,
                    batchType: document.getElementById('batchType').value,
                    meetingLink: document.getElementById('batchMeetingLink').value,
                    fee: document.getElementById('batchFee').value,
                    status: document.getElementById('batchStatus').value,
                    capacity: document.getElementById('batchCapacity').value,
                    description: document.getElementById('batchDescription').value,
                    timeSlot: document.getElementById('batchTimeSlot') ? document.getElementById('batchTimeSlot').value : '',
                    availableDays: Array.from(document.querySelectorAll('.day-check:checked'))
                                       .map(cb => cb.value)
                                       .sort((a, b) => {
                                           const order = { 'MON':1, 'TUE':2, 'WED':3, 'THU':4, 'FRI':5, 'SAT':6, 'SUN':7 };
                                           return order[a] - order[b];
                                       })
                                       .join(',')
                };

                if (!data.name || !data.startDate) {
                    alert('Please fill all required fields');
                    return;
                }

                try {
                    const res = await fetch('${pageContext.request.contextPath}/centres/process-batch', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(data)
                    });
                    const result = await res.json();
                    if (result.status === 'success') {
                        alert('Batch created successfully!');
                        location.reload(); // Refresh to get updated state
                    } else {
                        alert('Error: ' + result.message);
                    }
                } catch (err) {
                    console.error('Submit error:', err);
                    alert('Failed to save batch');
                }
            },

            render() {
                const root = document.getElementById('app-root');
                const title = document.querySelector('.topbar-title h1');
                if (!root) return;

                try {
                    root.classList.remove('fade-in');
                    void root.offsetWidth; // Trigger reflow
                    root.classList.add('fade-in');

                    switch(this.state.activeTab) {
                        case 'dashboard': root.innerHTML = this.views.Dashboard(); break;
                        case 'batches': root.innerHTML = this.views.Batches(); break;
                        case 'students': root.innerHTML = this.views.Students(); break;
                        case 'bookings': root.innerHTML = this.views.Bookings(); break;
                        case 'classes': root.innerHTML = this.views.Classes(); break;
                        case 'class-types': root.innerHTML = this.views.Classes(); break;
                        case 'create-batch': root.innerHTML = this.views.CreateBatch(); break;
                        case 'live': root.innerHTML = this.views.Live(); break;
                        case 'live-classes': root.innerHTML = this.views.Live(); break;
                        case 'attendance': root.innerHTML = this.views.Attendance(); break;
                        case 'reports': root.innerHTML = this.views.Reports(); break;
                        case 'settings': root.innerHTML = this.views.Settings(); break;
                        case 'notifications': root.innerHTML = this.views.Notifications(); break;
                        default: root.innerHTML = this.views.Placeholder();
                    }
                    
                    if (title) {
                        const titles = {
                            'dashboard': 'Trainer Overview',
                            'batches': 'Manage Batches',
                            'students': 'Student Directory',
                            'bookings': 'Recent Bookings',
                            'class-types': 'Add Class Type',
                            'create-batch': 'Create New Batch',
                            'live-classes': 'Live Dojo'
                        };
                        title.innerText = titles[this.state.activeTab] || 'Trainer Dashboard';
                    }
                } catch (err) {
                    console.error('Render Error:', err);
                    root.innerHTML = '<div class="alert alert-danger m-5"><h4>Rendering Error</h4><p>' + err.message + '</p><button class="btn btn-sm btn-danger" onclick="location.reload()">Refresh App</button></div>';
                }
            },
            views: {
                Dashboard: function() {
                    var enrolls = App.state.enrollments || [];
                    var batches = (App.state.batches || []).filter(function(b){ return b.isBatch !== false; });
                    var meta = App.state.meta || {};
                    var totalEarnings = enrolls.reduce(function(s,e){return s+(parseFloat(e.amount)||0);},0);
                    var avgTrainees = batches.length > 0 ? (enrolls.length / batches.length).toFixed(1) : 0;
                    var activities = meta.activities || [];
                    var online = meta.onlineBatchCount || 0;
                    var offline = meta.offlineBatchCount || 0;
                    var activityRows = activities.length ? activities.map(function(a) {
                        return '<tr><td class="fw-bold text-primary">'+App.escapeHtml(a.type)+'</td>'+
                            '<td>'+App.escapeHtml(a.detail)+'</td>'+
                            '<td><span class="badge bg-'+(a.statusClass||'info')+'">'+App.escapeHtml(a.status)+'</span></td></tr>';
                    }).join('') : '<tr><td colspan="3" class="text-center py-4 text-muted">No activity for today yet</td></tr>';
                    var onlineDeg = batches.length ? Math.round((online / batches.length) * 360) : 0;
                    return '<div class="stats-grid">'+
                        App.ui.StatCard('Total Trainees',enrolls.length,'red','fa-user-graduate')+
                        App.ui.StatCard('Avg Trainees/Batch',avgTrainees,'green','fa-users')+
                        App.ui.StatCard('Total Bookings',enrolls.length,'blue','fa-bookmark')+
                        App.ui.StatCard('Total Revenue','₹ '+totalEarnings.toLocaleString('en-IN'),'purple','fa-wallet')+
                    '</div>'+
                    '<div class="row">'+
                      '<div class="col-lg-8">'+
                        '<div class="panel mb-4">'+
                          '<div class="panel-header">'+
                            '<div class="panel-title"><i class="fas fa-calendar-day text-danger"></i> Today\'s Activity</div>'+
                            '<button class="btn btn-sm btn-outline-danger" onclick="App.navigate(\'batches\')">View Schedule</button>'+
                          '</div>'+
                          '<div class="table-container"><table class="custom-table">'+
                            '<thead><tr><th>Type</th><th>Details</th><th>Status</th></tr></thead>'+
                            '<tbody>'+activityRows+'</tbody></table></div>'+
                        '</div>'+
                      '</div>'+
                      '<div class="col-lg-4">'+
                        '<div class="panel h-100">'+
                          '<div class="panel-header"><div class="panel-title">Batch Distribution</div></div>'+
                          '<div class="text-center py-4">'+
                            '<div style="width:140px;height:140px;border-radius:50%;border:15px solid var(--primary);border-left-color:#eee;border-top-color:#10B981;border-right-color:#10B981;border-bottom-color:#eee;margin:0 auto 20px;display:flex;align-items:center;justify-content:center;">'+
                              '<div><span class="h2 fw-bold mb-0">'+batches.length+'</span><p class="small text-muted mb-0">Total</p></div>'+
                            '</div>'+
                            '<div class="d-flex justify-content-center gap-3 small text-muted">'+
                              '<span><i class="fas fa-circle text-success"></i> Online ('+online+')</span>'+
                              '<span><i class="fas fa-circle text-danger"></i> Offline ('+offline+')</span>'+
                            '</div>'+
                          '</div>'+
                        '</div>'+
                      '</div>'+
                    '</div>';
                },
                Batches: function() {
                    var batches = (App.state.batches || []).filter(function(b){ return b.isBatch !== false; });
                    return '<div class="panel">'+
                      '<div class="panel-header">'+
                        '<div class="panel-title"><i class="fas fa-layer-group text-danger"></i> Manage Batches ('+batches.length+')</div>'+
                        /* Issue 133: Removed redundant New Batch button here; batch creation is done from Class Types */
                      '</div>'+
                      '<p class="text-muted small px-1 mb-3"><i class="fas fa-info-circle me-1"></i>To add a new batch, go to <a href="#" onclick="App.navigate(\'class-types\')" class="text-danger fw-bold">Class Types</a> and click Create Batch.</p>'+
                      '<div class="table-container"><table class="custom-table">'+
                        '<thead><tr><th>Batch Name</th><th>Style</th><th>Mode</th><th>Schedule</th><th>Days</th><th>Fee</th><th>Status</th></tr></thead>'+
                        '<tbody>'+
                          batches.map(function(b){return '<tr>'+
                            '<td class="fw-bold">'+b.name+'</td>'+
                            '<td>'+b.style+'</td>'+
                            '<td><span class="badge '+(b.batchType==="Online"?"bg-info":"bg-secondary")+'">'+( b.batchType||"Offline")+'</span></td>'+
                            '<td><small class="fw-bold text-muted">'+b.timeSlot+'</small></td>'+
                            '<td><small class="badge bg-light text-dark">'+(b.availableDays||"N/A")+'</small></td>'+
                            '<td class="fw-bold text-danger">₹ '+b.fee+'</td>'+
                            '<td><span class="badge-pill bg-success text-white">'+b.status+'</span></td>'+
                          '</tr>';}).join('')+
                          (batches.length===0?'<tr><td colspan="7" class="text-center py-4">No batches found</td></tr>':'')+
                        '</tbody></table></div></div>';
                },
                Classes: function() {
                    var types = (App.state.meta && App.state.meta.classTypes) ? App.state.meta.classTypes : [];
                    // Issue 131: Use distinct thumbnail images based on the martial-arts style name
                    var styleImages = {
                        'karate':     App.ctx + '/assets/img/karate.jpg',
                        'mma':        App.ctx + '/assets/img/mma.jpg',
                        'kickboxing': App.ctx + '/assets/img/kickboxing.jpg',
                        'bjj':        App.ctx + '/assets/img/bjj.jpg',
                        'judo':       App.ctx + '/assets/img/judo.jpg',
                        'taekwondo':  App.ctx + '/assets/img/taekwondo.jpg',
                        'boxing':     App.ctx + '/assets/img/boxing.jpg',
                        'kalaripayattu': App.ctx + '/assets/img/kalari1.jpeg',
                    };
                    function getTypeImg(name) {
                        if (!name) return App.ctx + '/assets/img/hero-bg.jpg';
                        var key = name.trim().toLowerCase();
                        return styleImages[key] || App.state.userLogo || (App.ctx + '/assets/img/hero-bg.jpg');
                    }
                    if (types.length === 0) {
                        return '<div class="panel text-center py-5"><h4 class="fw-bold">No programs registered</h4>'+
                            '<p class="text-muted">Add martial arts programs during centre registration or create a batch with a custom style.</p>'+
                            '<button class="btn btn-premium" onclick="App.navigate(\'create-batch\')">Create Batch</button></div>';
                    }
                    return '<div class="d-flex justify-content-between align-items-center mb-5"><h2 class="fw-bold m-0 h1">Your Class Types</h2></div>'+
                    '<div class="class-grid">'+
                      types.map(function(t, i){
                        var thumb = getTypeImg(t.name);
                        return '<div class="class-card" onclick="App.navigate(\'create-batch\')">'+ 
                        '<div class="class-img"><img src="'+thumb+'" alt="'+App.escapeHtml(t.name)+'" onerror="this.src=\''+App.ctx+'/assets/img/hero-bg.jpg\'">'+ 
                          (i===0?'<div style="position:absolute;top:20px;right:20px;background:white;padding:8px 15px;border-radius:12px;font-weight:700;font-size:0.75rem;">REGISTERED</div>':'')+
                        '</div>'+
                        '<div class="class-body"><div class="class-name">'+App.escapeHtml(t.name)+'</div>'+
                          '<p class="text-muted small">'+(t.slotCount||0)+' time slots · ₹ '+(t.cost||0)+' base fee</p>'+
                          '<button class="btn btn-premium w-100 mt-2">Create Batch</button>'+
                        '</div></div>';
                      }).join('')+
                    '</div>';
                },
                CreateBatch: function() {
                    var instructors = (App.state.meta && App.state.meta.instructors) ? App.state.meta.instructors : [App.state.user.name];
                    var types = (App.state.meta && App.state.meta.classTypes) ? App.state.meta.classTypes : [];
                    var styleOptions = types.length ? types.map(function(t){return '<option value="'+App.escapeHtml(t.name)+'">'+App.escapeHtml(t.name)+'</option>';}).join('')
                        : '<option>Karate</option><option>MMA</option><option>Kickboxing</option><option>BJJ</option>';
                    var instructorOptions = instructors.map(function(i){return '<option value="'+App.escapeHtml(i)+'">'+App.escapeHtml(i)+'</option>';}).join('');
                    return '<div class="panel p-5">'+
                    '<div class="d-flex align-items-center gap-4 mb-5">'+
                      '<button class="btn btn-light rounded-circle" style="width:50px;height:50px;" onclick="App.navigate(\'class-types\')"><i class="fas fa-arrow-left"></i></button>'+
                      '<div><h2 class="fw-bold mb-1">Create New Batch</h2><p class="text-muted mb-0">Fill in the details below.</p></div>'+
                    '</div>'+
                    '<form id="batchForm" class="row g-4">'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Batch Name *</label><input type="text" id="batchName" class="form-control form-control-lg" placeholder="Enter batch name" required></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Start Date *</label><input type="date" id="batchStartDate" class="form-control form-control-lg" required></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">End Date</label><input type="date" id="batchEndDate" class="form-control form-control-lg"></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Trainer *</label><select id="batchInstructor" class="form-select form-select-lg"><option selected disabled>Select</option>'+instructorOptions+'</select></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Age Group *</label><select id="batchAgeGroup" class="form-select form-select-lg"><option selected disabled>Select</option><option value="Kids (5-12)">Kids (5-12)</option><option value="Teens (13-17)">Teens (13-17)</option><option value="Adults (18+)">Adults (18+)</option></select></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Skill Level *</label><select id="batchSkillLevel" class="form-select form-select-lg"><option selected disabled>Select</option><option>Beginner</option><option>Intermediate</option><option>Advanced</option></select></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Style *</label><select id="batchStyle" class="form-select form-select-lg">'+styleOptions+'</select></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Time Slot *</label><input type="text" id="batchTimeSlot" class="form-control form-control-lg" placeholder="e.g. 6:00 AM - 8:00 AM" required></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Location *</label><input type="text" id="batchLocation" class="form-control form-control-lg" placeholder="Hall or Room #" value="'+App.escapeHtml((App.state.center&&App.state.center.location)||'')+'"></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Mode *</label><select id="batchType" class="form-select form-select-lg" onchange="document.getElementById(\'batchMeetingLink\').disabled=(this.value===\'Offline\')"><option value="Offline" selected>Offline</option><option value="Online">Online</option></select></div>'+
                      '<div class="col-12"><label class="form-label fw-bold">Available Days *</label><div class="d-flex flex-wrap gap-3 p-3 bg-light rounded-4">'+['MON','TUE','WED','THU','FRI','SAT','SUN'].map(function(d){return '<div class="form-check"><input class="form-check-input day-check" type="checkbox" value="'+d+'" id="day-'+d+'"><label class="form-check-label fw-bold" for="day-'+d+'">'+d+'</label></div>';}).join('')+'</div></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Meeting Link</label><input type="url" id="batchMeetingLink" class="form-control form-control-lg" placeholder="https://meet.google.com/..." disabled></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Fee *</label><div class="input-group input-group-lg"><span class="input-group-text">₹</span><input type="number" id="batchFee" class="form-control" placeholder="Amount" required></div></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Status *</label><select id="batchStatus" class="form-select form-select-lg"><option value="Active" selected>Active</option><option value="Draft">Draft</option><option value="Closed">Closed</option></select></div>'+
                      '<div class="col-md-4"><label class="form-label fw-bold">Max Capacity *</label><div class="input-group input-group-lg"><span class="input-group-text"><i class="fas fa-users"></i></span><input type="number" id="batchCapacity" class="form-control" placeholder="Max" required></div></div>'+
                      '<div class="col-12"><label class="form-label fw-bold">Description</label><textarea id="batchDescription" class="form-control" rows="4" placeholder="What will students learn?"></textarea></div>'+
                      '<div class="col-12 d-flex justify-content-end gap-3 mt-5">'+
                        '<button type="button" class="btn btn-lg btn-light px-5" onclick="App.navigate(\'class-types\')">Cancel</button>'+
                        '<button type="button" class="btn btn-lg btn-premium px-5" onclick="App.submitBatch()"><i class="fas fa-plus me-2"></i>Create Batch</button>'+
                      '</div>'+
                    '</form></div>';
                },
                Students: function() {
                    var enrolls = App.state.enrollments || [];
                    return '<div class="panel">'+
                      '<div class="panel-header">'+
                        '<div class="panel-title"><i class="fas fa-user-graduate text-danger"></i> Trainee Directory ('+enrolls.length+')</div>'+
                        '<div class="input-group input-group-sm" style="width:250px;"><span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span><input type="text" class="form-control border-start-0 shadow-none" placeholder="Search..." onkeyup="App.filterTrainees(this.value)"></div>'+
                      '</div>'+
                      '<div class="table-container"><table class="custom-table" id="trainee-table">'+
                        '<thead><tr><th>Trainee Details</th><th>Style &amp; Batch</th><th>Timing &amp; Mode</th><th>Status &amp; Payment</th><th>Stats</th><th>Actions</th></tr></thead>'+
                        '<tbody>'+
                          enrolls.map(function(e){return '<tr>'+
                            '<td><div class="d-flex align-items-center gap-3"><div class="trainee-avatar" style="width:40px;height:40px;background:#F1F5F9;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--primary);">'+(e.traineeName||"S").charAt(0)+'</div><div><div class="fw-bold">'+(e.traineeName||"Student")+'</div><div class="text-muted small">'+(e.gender||"N/A")+', '+(e.age||"N/A")+' yrs | '+(e.phone||"No Phone")+'</div></div></div></td>'+
                            '<td><div class="fw-bold text-danger">'+(e.martialArtType||"N/A")+'</div><div class="small text-muted">'+(e.batchName||"N/A")+'</div></td>'+
                            '<td><div class="fw-bold">'+(e.slot||"N/A")+'</div><span class="badge '+(e.mode==="Online"?"bg-info":"bg-secondary")+' small" style="font-size:0.65rem;">'+(e.mode||"Offline")+'</span></td>'+
                            '<td><span class="badge-pill '+((e.enrollmentStatus==="COMPLETED"||e.enrollmentStatus==="APPROVED")?"bg-success":"bg-warning")+' text-white small" style="font-size:0.7rem;">'+(e.enrollmentStatus||"PENDING")+'</span><div class="mt-1 small fw-bold '+(e.paymentStatus==="PAID"?"text-success":"text-danger")+'">'+(e.paymentStatus||"UNPAID")+'</div></td>'+
                            '<td><div class="small fw-bold">Att: '+(e.attendancePercentage||0)+'%</div><div class="progress" style="height:4px;width:60px;margin-top:5px;"><div class="progress-bar bg-danger" style="width:'+(e.attendancePercentage||0)+'%"></div></div></td>'+
                            '<td><button class="btn btn-sm btn-premium" onclick="App.viewTraineeProfile('+e.id+')">View Profile</button></td>'+
                          '</tr>';}).join('')+
                          (enrolls.length===0?'<tr><td colspan="6" class="text-center py-5"><h5 class="text-muted">No trainees enrolled yet</h5></td></tr>':'')+
                        '</tbody></table></div></div>';
                },
                Bookings: function() {
                    var enrolls = App.state.enrollments || [];
                    return '<div class="panel">'+
                      '<div class="panel-header"><div class="panel-title"><i class="fas fa-bookmark text-danger"></i> Recent Bookings</div></div>'+
                      '<div class="table-container"><table class="custom-table">'+
                        '<thead><tr><th>ID</th><th>Student</th><th>Amount</th><th>Status</th><th>Actions</th></tr></thead>'+
                        '<tbody>'+
                          enrolls.map(function(e){return '<tr>'+
                            '<td class="small fw-bold text-muted">#ENR-'+e.id+'</td>'+
                            '<td class="fw-bold">'+(e.traineeName||"Student")+'</td>'+
                            '<td class="fw-bold text-success">₹ '+(e.amount||0)+'</td>'+
                            '<td><span class="badge-pill '+((e.paymentStatus==="PAID")?"bg-success":"bg-warning")+' text-white">'+(e.paymentStatus||"PENDING")+'</span></td>'+
                            '<td><button class="btn btn-sm btn-premium" onclick="App.manageBooking('+e.id+')">Manage</button></td>'+
                          '</tr>';}).join('')+
                          (enrolls.length===0?'<tr><td colspan="5" class="text-center py-4">No bookings found</td></tr>':'')+
                        '</tbody></table></div></div>';
                },
                Live: function() {
                    var onlineBatches = (App.state.batches||[]).filter(function(b){return b.batchType==='Online';});
                    if(onlineBatches.length===0){
                        return '<div class="panel text-center py-5"><div class="spinner-grow text-danger mb-4" style="width:3rem;height:3rem;"></div><h2 class="fw-bold">Live Portal</h2><p class="text-muted">No online sessions. Create one first.</p><button onclick="App.navigate(\'class-types\')" class="btn btn-premium px-4"><i class="fas fa-plus me-2"></i>Create Online Batch</button></div>';
                    }
                    return '<div class="d-flex justify-content-between align-items-center mb-4"><h2 class="fw-bold m-0"><i class="fas fa-broadcast-tower text-danger me-3"></i>Live Dojo</h2><a href="${pageContext.request.contextPath}/online-class/management" class="btn btn-premium"><i class="fas fa-tasks me-2"></i>Manage Sessions</a></div>'+
                    '<div class="row g-4">'+onlineBatches.map(function(b){var hasLink=!!b.meetingLink;var st=b.status||'BATCH';return '<div class="col-md-4"><div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100"><div class="bg-danger p-4 text-white"><span class="badge bg-white text-danger rounded-pill px-3">'+st+'</span><h4 class="fw-bold mt-3 mb-1">'+b.name+'</h4><small class="opacity-75">'+b.style+'</small></div><div class="p-4"><div class="d-flex align-items-center mb-3 text-muted small"><i class="far fa-clock me-2"></i>'+(b.timeSlot||'Not Set')+'</div>'+(hasLink?'<a href="'+b.meetingLink+'" target="_blank" class="btn btn-premium rounded-pill w-100"><i class="fas fa-video me-2"></i>Join Now</a>':'<a href="${pageContext.request.contextPath}/online-class/management" class="btn btn-outline-danger rounded-pill w-100"><i class="fas fa-plus-circle me-2"></i>Configure</a>')+'</div></div></div>';}).join('')+'</div>';
                },
                Attendance: function() {
                    return '<div class="panel text-center py-5"><div class="mb-4"><i class="fas fa-check-double text-danger" style="font-size:4rem;"></i></div><h2 class="fw-bold">Trainee Attendance</h2><p class="text-muted mx-auto" style="max-width:500px;">Track and manage daily attendance for all your martial arts sessions.</p><div class="mt-4"><a href="${pageContext.request.contextPath}/centres/attendance" class="btn btn-premium px-5 py-3"><i class="fas fa-external-link-alt me-2"></i>Open Attendance Module</a></div></div>';
                },
                Reports: function() {
                    var enrolls = App.state.enrollments || [];
                    var meta = App.state.meta || {};
                    var totalRevenue = enrolls.reduce(function(s,e){return s+(e.amount||0);},0);
                    var avg = enrolls.length>0?(totalRevenue/enrolls.length).toFixed(0):0;
                    var attAvg = meta.avgAttendance != null ? meta.avgAttendance : 0;
                    var completion = meta.completionRate != null ? meta.completionRate : 0;
                    var paidCount = enrolls.filter(function(e){return e.paymentStatus==='PAID';}).length;
                    return '<div class="row g-4 mb-4">'+
                      '<div class="col-md-3">'+App.ui.StatCard('Total Revenue','₹ '+totalRevenue.toLocaleString('en-IN'),'green','fa-wallet')+'</div>'+
                      '<div class="col-md-3">'+App.ui.StatCard('Avg / Student','₹ '+avg,'blue','fa-chart-pie')+'</div>'+
                      '<div class="col-md-3">'+App.ui.StatCard('Attendance Avg',attAvg+'%','red','fa-check-circle')+'</div>'+
                      '<div class="col-md-3">'+App.ui.StatCard('Completion Rate',completion+'%','purple','fa-graduation-cap')+'</div>'+
                    '</div>'+
                    '<div class="panel"><div class="panel-header"><div class="panel-title"><i class="fas fa-chart-line text-danger"></i> Enrollment Summary</div></div>'+
                    '<div class="p-4"><div class="row text-center g-3">'+
                      '<div class="col-md-4"><div class="fw-bold h4 text-danger">'+enrolls.length+'</div><div class="text-muted small">Total Enrollments</div></div>'+
                      '<div class="col-md-4"><div class="fw-bold h4 text-success">'+paidCount+'</div><div class="text-muted small">Paid</div></div>'+
                      '<div class="col-md-4"><div class="fw-bold h4 text-primary">'+(App.state.batches||[]).filter(function(b){return b.isBatch!==false;}).length+'</div><div class="text-muted small">Batches</div></div>'+
                    '</div></div></div>';
                },
                Settings: function() {
                    var c = App.state.center || {};
                    var logoHtml = App.state.userLogo ? '<img src="'+App.state.userLogo+'" style="width:100%;height:100%;object-fit:cover;">' : (c.name||App.state.user.name||'C').charAt(0);
                    return '<div class="row g-4">'+
                      '<div class="col-lg-4"><div class="panel text-center p-5">'+
                        '<div id="logo-preview" class="trainee-avatar mx-auto mb-4" style="width:120px;height:120px;background:#F1F5F9;border-radius:30px;display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--primary);font-size:3rem;overflow:hidden;">'+logoHtml+'</div>'+
                        '<h3 class="fw-bold mb-1">'+App.escapeHtml(c.name||App.state.user.name)+'</h3><p class="text-muted small">Martial Arts Center</p>'+
                        '<input type="file" id="logoInput" style="display:none;" accept="image/*" onchange="App.handleLogoUpload(this)">'+
                        '<button class="btn btn-sm btn-outline-danger rounded-pill px-4 mt-3" onclick="document.getElementById(\'logoInput\').click()">Upload Logo</button>'+
                      '</div></div>'+
                      '<div class="col-lg-8"><div class="panel p-5"><h4 class="fw-bold mb-4">Center Profile</h4>'+
                        '<form id="settingsForm" class="row g-4" onsubmit="event.preventDefault();App.saveSettings();">'+
                          '<div class="col-md-6"><label class="form-label fw-bold small text-muted text-uppercase">Center Name</label><input type="text" id="settingsName" class="form-control form-control-lg border-0 bg-light" value="'+App.escapeHtml(c.name||'')+'" required></div>'+
                          '<div class="col-md-6"><label class="form-label fw-bold small text-muted text-uppercase">Email Address</label><input type="email" id="settingsEmail" class="form-control form-control-lg border-0 bg-light" value="'+App.escapeHtml(c.email||'')+'"></div>'+
                          '<div class="col-md-6"><label class="form-label fw-bold small text-muted text-uppercase">Phone Number</label><input type="tel" id="settingsPhone" class="form-control form-control-lg border-0 bg-light" value="'+App.escapeHtml(c.phoneNumber||'')+'"></div>'+
                          '<div class="col-md-6"><label class="form-label fw-bold small text-muted text-uppercase">Location</label><input type="text" id="settingsLocation" class="form-control form-control-lg border-0 bg-light" value="'+App.escapeHtml(c.location||'')+'"></div>'+
                          '<div class="col-12"><label class="form-label fw-bold small text-muted text-uppercase">About Center</label><textarea id="settingsAbout" class="form-control form-control-lg border-0 bg-light" rows="3">'+App.escapeHtml(c.about||'')+'</textarea></div>'+
                          '<div class="col-12"><label class="form-label fw-bold small text-muted text-uppercase">How We Teach</label><textarea id="settingsHowWeTeach" class="form-control form-control-lg border-0 bg-light" rows="3">'+App.escapeHtml(c.howWeTeach||'')+'</textarea></div>'+
                          '<div class="col-12"><label class="form-label fw-bold small text-muted text-uppercase">What We Offer</label><textarea id="settingsWhatWeOffer" class="form-control form-control-lg border-0 bg-light" rows="3">'+App.escapeHtml(c.whatWeOffer||'')+'</textarea></div>'+
                          '<div class="col-12"><label class="form-label fw-bold small text-muted text-uppercase">Gallery Photos</label>'+
                            '<input type="file" id="galleryInput" class="form-control border-0 bg-light mb-3" multiple accept="image/*">'+
                            '<div id="gallery-preview" class="d-flex flex-wrap gap-2">'+
                              (c.galleryPhotos ? c.galleryPhotos.map(function(p){return '<div class="position-relative" style="width:80px;height:80px;border-radius:10px;overflow:hidden;border:2px solid #eee;"><img src="'+App.ctx+p+'" style="width:100%;height:100%;object-fit:cover;"></div>';}).join('') : '')+
                            '</div>'+
                          '</div>'+
                          '<div class="col-12 d-flex justify-content-end gap-3 mt-4"><button type="button" class="btn btn-lg btn-light px-5" onclick="location.reload()">Reset</button><button type="submit" class="btn btn-lg btn-premium px-5">Save Changes</button></div>'+
                        '</form></div></div>'+
                    '</div>';
                },
                Notifications: function() {
                    var items = (App.state.meta && App.state.meta.notifications) ? App.state.meta.notifications : [];
                    var rows = items.length ? items.map(function(n) {
                        return '<tr class="'+(n.unread?'unread':'')+'"><td class="small fw-bold text-muted">'+App.escapeHtml(n.timeLabel||'')+'</td>'+
                            '<td class="fw-bold text-danger">'+App.escapeHtml(n.title)+'</td>'+
                            '<td>'+App.escapeHtml(n.detail)+'</td>'+
                            '<td><span class="badge '+(n.unread?'bg-danger':'bg-light text-dark')+'">'+(n.unread?'New':'Read')+'</span></td></tr>';
                    }).join('') : '<tr><td colspan="4" class="text-center py-4 text-muted">No notifications yet</td></tr>';
                    return '<div class="panel"><div class="panel-header"><div class="panel-title"><i class="fas fa-bell text-danger"></i> Notification History</div></div>'+
                    '<div class="table-container"><table class="custom-table"><thead><tr><th>Date</th><th>Activity</th><th>Details</th><th>Status</th></tr></thead><tbody>'+rows+'</tbody></table></div></div>';
                },
                Placeholder: function() { return '<div class="panel text-center py-5"><h3 class="text-muted">Module coming soon.</h3></div>'; }
            },
            ui: {
                StatCard: function(label,val,color,icon) {
                    return '<div class="stat-card"><div class="stat-icon '+color+'"><i class="fas '+icon+'"></i></div><div><div class="stat-val">'+val+'</div><div class="stat-label">'+label+'</div></div></div>';
                }
            }
        };

        document.addEventListener('DOMContentLoaded', function() { App.init(); });
    </script>
</body>
</html>
