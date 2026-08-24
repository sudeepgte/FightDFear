<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Event — Women Events Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
    :root {
        --primary:      #1E1B4A;
        --primary-light:#2B275F;
        --accent:       #F43F5E;
        --accent-dark:  #E82A50;
        --background:   #FEF0EF;
        --card-bg:      #FFFFFF;
        --soft-pink:    #FEDBDF;
        --light-pink:   #FFF3F4;
        --text-dark:    #1E1B4A;
        --text-gray:    #6B7280;
        --border:       #E5E7EB;
    }

    *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
    body { font-family: 'Outfit', sans-serif; background: var(--background); color: var(--text-dark); display:flex; min-height:100vh; overflow-x:hidden; }

    /* ── SIDEBAR ── */
    .sidebar {
        width: 220px; min-width:220px;
        background: var(--primary);
        color: #fff;
        display: flex;
        flex-direction: column;
        padding: 0;
        position: fixed;
        top:0; left:0; bottom:0;
        z-index: 100;
        overflow-y: auto;
    }
    .sidebar-brand {
        display: flex; align-items: center; gap: 10px;
        padding: 22px 20px 18px;
        border-bottom: 1px solid rgba(255,255,255,0.08);
        font-size: 1.05rem; font-weight: 800; color: #fff;
    }
    .sidebar-brand .brand-icon {
        width: 36px; height: 36px; background: var(--accent);
        border-radius: 10px; display: flex; align-items:center; justify-content:center;
        font-size: 1.1rem;
    }
    .sidebar-nav { flex:1; padding: 12px 10px; }
    .nav-label { font-size: 0.68rem; font-weight: 700; color: rgba(255,255,255,0.35);
        letter-spacing: 1px; text-transform: uppercase; padding: 14px 10px 6px; }
    .nav-item {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 12px; border-radius: 10px;
        color: rgba(255,255,255,0.7); text-decoration: none;
        font-size: 0.9rem; font-weight: 600;
        transition: all 0.2s; margin-bottom: 2px;
        position: relative;
    }
    .nav-item:hover { background: rgba(255,255,255,0.08); color:#fff; }
    .nav-item.active { background: var(--accent); color:#fff; }
    .nav-item .nav-badge {
        margin-left: auto; background: var(--accent-dark); color:#fff;
        font-size:0.65rem; font-weight:700; padding:2px 6px; border-radius:20px;
    }
    .sidebar-user {
        padding: 14px 16px;
        border-top: 1px solid rgba(255,255,255,0.08);
        display: flex; align-items: center; gap: 10px;
    }
    .user-avatar-sm {
        width: 34px; height: 34px; border-radius: 50%;
        background: linear-gradient(135deg, var(--accent-dark), var(--accent));
        display: flex; align-items:center; justify-content:center;
        font-size:0.9rem; font-weight:700; color:#fff; flex-shrink:0;
    }
    .user-info-sm .name { font-size:0.85rem; font-weight:700; color:#fff; }
    .user-info-sm .role { font-size:0.72rem; color:rgba(255,255,255,0.5); }

    /* ── MAIN WRAPPER ── */
    .main-wrapper { margin-left: 220px; flex:1; display:flex; flex-direction:column; min-height:100vh; }

    /* Top bar */
    .topbar {
        background: var(--card-bg); padding: 14px 28px;
        display: flex; align-items: center; justify-content: space-between;
        border-bottom: 1px solid var(--border); position: sticky; top:0; z-index:50;
    }
    .topbar-left h2 { font-size:1.1rem; font-weight:800; color: var(--primary); }
    .topbar-left p  { font-size:0.8rem; color: var(--text-gray); margin-top:1px; }
    .topbar-right { display:flex; align-items:center; gap:14px; }
    .topbar-icon-btn {
        width:38px; height:38px; border-radius:50%; border:1.5px solid var(--border);
        background: var(--card-bg); display:flex; align-items:center; justify-content:center;
        cursor:pointer; font-size:1rem; color: var(--text-gray); position:relative;
    }
    .notif-dot { position:absolute; top:4px; right:4px; width:8px; height:8px;
        background: var(--accent); border-radius:50%; border:2px solid #fff; }
    .topbar-avatar {
        width:38px; height:38px; border-radius:50%;
        background: linear-gradient(135deg, var(--accent-dark), var(--accent));
        display:flex; align-items:center; justify-content:center;
        font-weight:800; color:#fff; font-size:0.9rem;
    }
    .back-btn {
        border:1.5px solid var(--border); background: var(--card-bg); color: var(--text-gray);
        border-radius:10px; padding:8px 16px; font-family:'Outfit',sans-serif;
        font-weight:600; font-size:0.85rem; text-decoration:none;
        display:flex; align-items:center; gap:6px; transition:all 0.2s;
    }
    .back-btn:hover { border-color: var(--accent); color: var(--accent); }

    /* Page content */
    .page-content { padding: 24px 28px; flex:1; }

    /* Progress steps */
    .progress-steps {
        display:flex; align-items:center; gap:0; margin-bottom:24px; background: var(--card-bg);
        border-radius:14px; padding:16px 24px; box-shadow:0 2px 12px rgba(30,27,74,0.06);
    }
    .step {
        display:flex; align-items:center; gap:10px; flex:1;
    }
    .step-num {
        width:32px; height:32px; border-radius:50%; border:2px solid var(--border);
        display:flex; align-items:center; justify-content:center;
        font-size:0.85rem; font-weight:800; color:#aaa; flex-shrink:0;
        transition:all 0.3s;
    }
    .step.active .step-num { background: var(--accent); border-color: var(--accent); color:#fff; }
    .step.done .step-num   { background:#16a34a; border-color:#16a34a; color:#fff; }
    .step-label { font-size:0.82rem; font-weight:700; color:#aaa; }
    .step.active .step-label { color: var(--primary); }
    .step.done .step-label   { color:#16a34a; }
    .step-divider { flex:1; height:2px; background: var(--border); margin:0 8px; }
    .step-divider.done { background:#16a34a; }

    /* Form layout */
    .form-grid { display:grid; grid-template-columns:1fr 320px; gap:20px; align-items:start; }

    /* Card */
    .form-card {
        background: var(--card-bg); border-radius:16px;
        box-shadow:0 2px 12px rgba(30,27,74,0.06); overflow:hidden;
    }
    .form-card-header {
        padding:18px 24px; border-bottom:1px solid var(--soft-pink);
        display:flex; align-items:center; gap:10px;
    }
    .form-card-header h3 { font-size:1rem; font-weight:800; color: var(--primary); }
    .form-card-header .header-icon {
        width:36px; height:36px; border-radius:10px;
        display:flex; align-items:center; justify-content:center; font-size:1rem; flex-shrink:0;
    }
    .form-card-body { padding:22px 24px; }

    /* Form fields */
    .fg { margin-bottom:16px; }
    .fg label {
        display:block; font-weight:700; font-size:0.82rem;
        color: var(--text-gray); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.4px;
    }
    .fg label .req { color: var(--accent); margin-left:2px; }
    .fg input, .fg select, .fg textarea {
        width:100%; border:1.5px solid var(--border); border-radius:10px;
        padding:10px 14px; font-family:'Outfit',sans-serif; font-size:0.92rem;
        outline:none; transition:border-color 0.2s, box-shadow 0.2s;
        background:#fafafa; color: var(--text-dark);
    }
    .fg input:focus, .fg select:focus, .fg textarea:focus {
        border-color: var(--accent); background: var(--card-bg);
        box-shadow:0 0 0 3px rgba(244,63,94,0.08);
    }
    .fg textarea { resize:vertical; min-height:110px; }
    .fg .hint { font-size:0.75rem; color:#aaa; margin-top:4px; }
    .two-col { display:grid; grid-template-columns:1fr 1fr; gap:14px; }

    /* Fee toggle */
    .fee-toggle { display:flex; gap:10px; margin-bottom:10px; }
    .fee-option {
        flex:1; border:1.5px solid var(--border); border-radius:10px;
        padding:10px 14px; cursor:pointer; transition:all 0.2s;
        display:flex; align-items:center; gap:8px; font-weight:600; font-size:0.88rem;
    }
    .fee-option input { display:none; }
    .fee-option:has(input:checked) { border-color: var(--accent); background: var(--light-pink); color: var(--accent); }

    /* Upload zone */
    .upload-zone {
        border:2px dashed var(--soft-pink); border-radius:12px; padding:28px 20px;
        text-align:center; cursor:pointer; transition:all 0.2s; background: var(--light-pink);
    }
    .upload-zone:hover { background: var(--soft-pink); border-color: var(--accent); }
    .upload-preview { max-width:100%; max-height:180px; border-radius:10px; margin-top:12px; display:none; }

    /* Virtual toggle */
    .virtual-toggle {
        display:flex; align-items:center; gap:10px;
        padding:12px 14px; border:1.5px solid var(--border); border-radius:10px;
        cursor:pointer; font-weight:600; font-size:0.88rem; transition:all 0.2s;
        background:#fafafa;
    }
    .virtual-toggle input { width:18px; height:18px; cursor:pointer; accent-color: var(--accent); }
    .virtual-toggle:has(input:checked) { border-color: var(--accent); background: var(--light-pink); color: var(--accent); }

    /* Submit area */
    .submit-card {
        background: var(--card-bg); border-radius:16px;
        box-shadow:0 2px 12px rgba(30,27,74,0.06); padding:20px 24px;
        display:flex; flex-direction:column; gap:12px;
    }
    .submit-btn {
        width:100%; background:linear-gradient(135deg, var(--accent-dark), var(--accent)); color:#fff;
        border:none; border-radius:12px; padding:16px;
        font-family:'Outfit',sans-serif; font-size:1rem; font-weight:800;
        cursor:pointer; transition:all 0.2s; display:flex; align-items:center;
        justify-content:center; gap:8px;
    }
    .submit-btn:hover { transform:translateY(-2px); box-shadow:0 10px 28px rgba(244,63,94,0.35); }
    .cancel-btn {
        width:100%; background: var(--card-bg); color: var(--text-gray); border:1.5px solid var(--border);
        border-radius:12px; padding:13px; font-family:'Outfit',sans-serif;
        font-size:0.92rem; font-weight:700; cursor:pointer; transition:all 0.2s;
        text-align:center; text-decoration:none; display:block;
    }
    .cancel-btn:hover { border-color: var(--accent); color: var(--accent); }

    /* Info box */
    .info-box {
        background:#f0f9ff; border:1px solid #bae6fd; border-radius:12px;
        padding:14px 16px; font-size:0.83rem; color:#075985;
        display:flex; align-items:flex-start; gap:8px;
    }
    .info-box i { flex-shrink:0; margin-top:1px; }

    /* Tips card */
    .tips-card {
        background: linear-gradient(160deg, var(--primary), var(--primary-light));
        border-radius:16px; padding:20px; color:#fff;
        box-shadow:0 2px 12px rgba(30,27,74,0.15);
    }
    .tips-card h4 { font-size:0.95rem; font-weight:800; margin-bottom:14px; display:flex; align-items:center; gap:8px; }
    .tip-item { display:flex; gap:10px; margin-bottom:13px; font-size:0.82rem; line-height:1.5; }
    .tip-icon { width:28px; height:28px; border-radius:8px; background:rgba(255,255,255,0.12);
        display:flex; align-items:center; justify-content:center; font-size:0.9rem; flex-shrink:0; }

    /* Section separator */
    .section-sep {
        font-size:0.78rem; font-weight:800; text-transform:uppercase;
        letter-spacing:1px; color: var(--accent); margin:22px 0 14px;
        display:flex; align-items:center; gap:8px;
    }
    .section-sep::after { content:''; flex:1; height:1px; background: var(--soft-pink); }

    @media(max-width:960px) { .form-grid { grid-template-columns:1fr; } }
    @media(max-width:768px) {
        .sidebar { width:64px; min-width:64px; }
        .sidebar-brand span, .nav-item span, .nav-badge, .user-info-sm, .nav-label { display:none; }
        .sidebar-brand { padding:16px 14px; }
        .nav-item { justify-content:center; }
        .main-wrapper { margin-left:64px; }
        .two-col { grid-template-columns:1fr; }
        .progress-steps { overflow-x:auto; }
    }
    </style>
</head>
<body>

<!-- ═══════════════════ SIDEBAR ═══════════════════ -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-calendar-event-fill"></i></div>
        <span>Women Event<br>Organizer</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Main</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-speedometer2"></i><span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-calendar3"></i><span>My Events</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="nav-item active">
            <i class="bi bi-plus-circle-fill"></i><span>Create Event</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-people-fill"></i><span>Registrations</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-bar-chart-fill"></i><span>Event Analytics</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-chat-dots-fill"></i><span>Messages</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-bell-fill"></i><span>Notifications</span>
            <span class="nav-badge">3</span>
        </a>
        <div class="nav-label">Account</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/edit-profile" class="nav-item">
            <i class="bi bi-person-circle"></i><span>Edit Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-gear-fill"></i><span>Settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/host/logout" class="nav-item">
            <i class="bi bi-box-arrow-right"></i><span>Logout</span>
        </a>
    </nav>
    <div class="sidebar-user">
        <div class="user-avatar-sm">O</div>
        <div class="user-info-sm">
            <div class="name">Organizer</div>
            <div class="role">Organizer</div>
        </div>
    </div>
</aside>

<!-- ═══════════════════ MAIN WRAPPER ═══════════════════ -->
<div class="main-wrapper">

    <!-- TOP BAR -->
    <div class="topbar">
        <div class="topbar-left">
            <h2>Create New Event</h2>
            <p>Fill in the details below — your event will be reviewed by the admin team.</p>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="back-btn">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
            <div class="topbar-icon-btn">
                <i class="bi bi-bell-fill"></i>
                <span class="notif-dot"></span>
            </div>
            <div class="topbar-avatar">O</div>
        </div>
    </div>

    <!-- PAGE CONTENT -->
    <div class="page-content">

        <!-- Error alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-3 rounded-3">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Progress Steps -->
        <div class="progress-steps">
            <div class="step active">
                <div class="step-num">1</div>
                <div class="step-label">Basic Info</div>
            </div>
            <div class="step-divider"></div>
            <div class="step">
                <div class="step-num">2</div>
                <div class="step-label">Date &amp; Location</div>
            </div>
            <div class="step-divider"></div>
            <div class="step">
                <div class="step-num">3</div>
                <div class="step-label">Fee &amp; Capacity</div>
            </div>
            <div class="step-divider"></div>
            <div class="step">
                <div class="step-num">4</div>
                <div class="step-label">Banner &amp; Submit</div>
            </div>
        </div>

        <!-- Form Grid -->
        <form action="${pageContext.request.contextPath}/women-events/organizer/create" method="post" enctype="multipart/form-data" id="createEventForm">
        <div class="form-grid">

            <!-- LEFT: Main form -->
            <div style="display:flex; flex-direction:column; gap:16px;">

                <!-- Basic Information -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#ede9fe;"><i class="bi bi-info-circle-fill" style="color:#6d28d9;"></i></div>
                        <h3>Basic Information</h3>
                    </div>
                    <div class="form-card-body">
                        <div class="fg">
                            <label>Event Name <span class="req">*</span></label>
                            <input type="text" name="name" required placeholder="e.g., Women's Day Yoga &amp; Wellness Camp"/>
                        </div>
                        <div class="two-col">
                            <div class="fg">
                                <label>Category <span class="req">*</span></label>
                                <select name="category" required>
                                    <option value="">Select Category</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}">${cat.displayName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="fg">
                                <label>Organizer Type <span class="req">*</span></label>
                                <select name="organizerType" required>
                                    <option value="">Select Type</option>
                                    <option value="NGO">NGO</option>
                                    <option value="Government">Government</option>
                                    <option value="College">College / University</option>
                                    <option value="Company">Company</option>
                                    <option value="Community">Community</option>
                                    <option value="Gym">Gym / Fitness Centre</option>
                                    <option value="Hospital">Hospital / Clinic</option>
                                    <option value="Fitness Trainer">Fitness Trainer</option>
                                    <option value="Women Entrepreneur">Women Entrepreneur</option>
                                </select>
                            </div>
                        </div>
                        <div class="fg">
                            <label>Organizer / Organization Name <span class="req">*</span></label>
                            <input type="text" name="organizerName" required placeholder="e.g., She Leads Foundation"/>
                        </div>
                        <div class="fg">
                            <label>Event Description <span class="req">*</span></label>
                            <textarea name="description" required rows="5"
                                placeholder="Describe your event — what will happen, who should attend, what they'll gain..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Date, Time & Location -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#dbeafe;"><i class="bi bi-clock-fill" style="color:#2563eb;"></i></div>
                        <h3>Date, Time &amp; Location</h3>
                    </div>
                    <div class="form-card-body">
                        <div class="two-col">
                            <div class="fg">
                                <label>Event Date <span class="req">*</span></label>
                                <input type="date" name="eventDate" required/>
                            </div>
                            <div class="fg">
                                <label>Event Time</label>
                                <input type="time" name="eventTime"/>
                            </div>
                        </div>

                        <div class="fg">
                            <label class="virtual-toggle">
                                <input type="checkbox" name="virtual" value="true" onchange="toggleVirtual(this)"/>
                                <span>💻 This is a Virtual / Online Event</span>
                            </label>
                        </div>

                        <div class="fg" id="streamLinkGroup" style="display:none;">
                            <label>Live Stream / Meeting Link</label>
                            <input type="url" name="streamLink" placeholder="e.g., Zoom, Google Meet, YouTube stream URL"/>
                            <div class="hint">Only registered attendees will be able to access this link.</div>
                        </div>

                        <div class="two-col" id="locationFields">
                            <div class="fg">
                                <label>Venue / Location <span class="req">*</span></label>
                                <input type="text" name="venue" id="venueField" required placeholder="e.g., City Community Hall, 3rd Floor"/>
                            </div>
                            <div class="fg">
                                <label>City <span class="req">*</span></label>
                                <input type="text" name="city" id="cityField" required placeholder="e.g., Mumbai"/>
                            </div>
                        </div>

                        <div class="fg" id="mapsFieldGroup">
                            <label>Google Maps Location / Address</label>
                            <input type="text" name="mapsLocation" placeholder="Paste maps link or address for embedded map"/>
                            <div class="hint">This will show an embedded map on the event page.</div>
                        </div>
                    </div>
                </div>

                <!-- Fee & Capacity -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#fef9c3;"><i class="bi bi-cash-coin" style="color:#d97706;"></i></div>
                        <h3>Entry Fee, Booth Booking &amp; Capacity</h3>
                    </div>
                    <div class="form-card-body">
                        <div class="two-col">
                            <div class="fg">
                                <label>Entry Fee</label>
                                <div class="fee-toggle">
                                    <label class="fee-option">
                                        <input type="radio" name="isFree" value="true" id="freeRadio" onchange="toggleFee(true)" checked/>
                                        <i class="bi bi-gift-fill" style="color:#16a34a;"></i> Free Event
                                    </label>
                                    <label class="fee-option">
                                        <input type="radio" name="isFree" value="false" id="paidRadio" onchange="toggleFee(false)"/>
                                        <i class="bi bi-currency-rupee" style="color:#d97706;"></i> Paid Event
                                    </label>
                                </div>
                                <div id="feeInput" style="display:none;">
                                    <input type="number" name="entryFee" id="entryFeeField" min="0" placeholder="Enter amount in ₹" value="0"/>
                                    <div class="hint">Fee will be collected at the venue by the organizer.</div>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Booth / Stall Booking Fee</label>
                                <input type="number" name="boothFee" min="0" placeholder="e.g., ₹2000 for stall booking" value="0"/>
                                <div class="hint">Optional fee for booking a booth/stall at exhibitions.</div>
                            </div>
                        </div>
                        <div class="fg" style="max-width:260px;">
                            <label>Maximum Participants</label>
                            <input type="number" name="maxParticipants" min="1" placeholder="Leave blank for unlimited"/>
                        </div>
                    </div>
                </div>

                <!-- Contact -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#dcfce7;"><i class="bi bi-telephone-fill" style="color:#16a34a;"></i></div>
                        <h3>Contact Information</h3>
                    </div>
                    <div class="form-card-body">
                        <div class="fg">
                            <label>Contact Info <span class="req">*</span></label>
                            <input type="text" name="contactInfo" required placeholder="Phone number, email, or WhatsApp"/>
                        </div>
                    </div>
                </div>

                <!-- Banner -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#fce7f3;"><i class="bi bi-image-fill" style="color:#db2777;"></i></div>
                        <h3>Event Banner</h3>
                    </div>
                    <div class="form-card-body">
                        <div class="upload-zone" onclick="document.getElementById('bannerFile').click()">
                            <i class="bi bi-cloud-arrow-up-fill" style="font-size:2.4rem; color:#a855f7; display:block; margin-bottom:10px;"></i>
                            <div style="font-weight:700; color:#555; font-size:0.95rem;" id="uploadLabel">Click to upload banner image</div>
                            <div class="hint" style="margin-top:6px;">Recommended: 1200×600px · JPG or PNG · Max 5MB</div>
                            <img id="bannerPreview" class="upload-preview" alt="Banner preview"/>
                        </div>
                        <input type="file" id="bannerFile" name="bannerImage" accept="image/*" style="display:none;" onchange="previewBanner(this)"/>
                    </div>
                </div>

            </div><!-- end left column -->

            <!-- RIGHT: Sidebar panel -->
            <div style="display:flex; flex-direction:column; gap:16px; position:sticky; top:80px;">

                <!-- Submit card -->
                <div class="submit-card">
                    <div class="info-box">
                        <i class="bi bi-info-circle-fill"></i>
                        Your event will be submitted for admin approval. Once approved, it will be publicly listed on the platform.
                    </div>
                    <button type="submit" class="submit-btn">
                        <i class="bi bi-send-fill"></i> Submit Event for Approval
                    </button>
                    <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="cancel-btn">
                        Cancel
                    </a>
                </div>

                <!-- Checklist card -->
                <div class="form-card">
                    <div class="form-card-header">
                        <div class="header-icon" style="background:#ede9fe;"><i class="bi bi-check2-all" style="color:#6d28d9;"></i></div>
                        <h3>Checklist</h3>
                    </div>
                    <div class="form-card-body" style="padding:16px 20px;">
                        <div id="checklistItems" style="display:flex; flex-direction:column; gap:10px;">
                            <div class="check-item" id="chk-name" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Event name filled</span>
                            </div>
                            <div class="check-item" id="chk-cat" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Category selected</span>
                            </div>
                            <div class="check-item" id="chk-desc" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Description added</span>
                            </div>
                            <div class="check-item" id="chk-date" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Date &amp; time set</span>
                            </div>
                            <div class="check-item" id="chk-venue" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Venue &amp; city added</span>
                            </div>
                            <div class="check-item" id="chk-contact" style="display:flex; align-items:center; gap:10px; font-size:0.85rem; color:#888;">
                                <i class="bi bi-circle" style="color:#ddd; font-size:1rem;"></i>
                                <span>Contact info added</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tips card -->
                <div class="tips-card">
                    <h4><i class="bi bi-lightbulb-fill" style="color:#fbbf24;"></i> Tips for a Great Event</h4>
                    <div class="tip-item">
                        <div class="tip-icon"><i class="bi bi-image"></i></div>
                        <span>Upload a high-quality banner — events with images get 3× more registrations.</span>
                    </div>
                    <div class="tip-item">
                        <div class="tip-icon"><i class="bi bi-pencil-fill"></i></div>
                        <span>Write a clear, detailed description to attract the right audience.</span>
                    </div>
                    <div class="tip-item">
                        <div class="tip-icon"><i class="bi bi-calendar-check-fill"></i></div>
                        <span>Publish at least 2 weeks before the event date for best results.</span>
                    </div>
                    <div class="tip-item">
                        <div class="tip-icon"><i class="bi bi-geo-alt-fill"></i></div>
                        <span>Add a maps link so attendees can find the venue easily.</span>
                    </div>
                </div>

            </div><!-- end right column -->
        </div><!-- end form-grid -->
        </form>

    </div><!-- end page-content -->
</div><!-- end main-wrapper -->

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
/* ── Live checklist ── */
function updateChecklist() {
    function setCheck(id, filled) {
        const el = document.getElementById(id);
        if (!el) return;
        const icon = el.querySelector('i');
        const span = el.querySelector('span');
        if (filled) {
            icon.className = 'bi bi-check-circle-fill';
            icon.style.color = '#16a34a';
            span.style.color = '#1a1a2e';
        } else {
            icon.className = 'bi bi-circle';
            icon.style.color = '#ddd';
            span.style.color = '#aaa';
        }
    }
    setCheck('chk-name',    document.querySelector('[name="name"]')?.value.trim().length > 0);
    setCheck('chk-cat',     document.querySelector('[name="category"]')?.value !== '');
    setCheck('chk-desc',    document.querySelector('[name="description"]')?.value.trim().length > 10);
    setCheck('chk-date',    document.querySelector('[name="eventDate"]')?.value !== '');
    setCheck('chk-venue',   document.querySelector('[name="venue"]')?.value.trim().length > 0
                         && document.querySelector('[name="city"]')?.value.trim().length > 0);
    setCheck('chk-contact', document.querySelector('[name="contactInfo"]')?.value.trim().length > 0);
}
document.querySelectorAll('input, select, textarea').forEach(el => el.addEventListener('input', updateChecklist));
updateChecklist();

/* ── Fee toggle ── */
function toggleFee(isFree) {
    const feeInput = document.getElementById('feeInput');
    const feeField = document.getElementById('entryFeeField');
    feeInput.style.display = isFree ? 'none' : 'block';
    if (isFree) {
        feeField.value = '0';
        feeField.min = '0';
    } else {
        feeField.min = '1';
        if (feeField.value === '0') feeField.value = '';
    }
    feeField.required = !isFree;
}

/* ── Virtual toggle ── */
function toggleVirtual(checkbox) {
    const isVirtual = checkbox.checked;
    document.getElementById('streamLinkGroup').style.display = isVirtual ? 'block' : 'none';
    const venueField = document.getElementById('venueField');
    const cityField  = document.getElementById('cityField');
    const mapsGroup  = document.getElementById('mapsFieldGroup');
    if (isVirtual) {
        venueField.value = 'Online / Virtual';
        cityField.value  = 'Virtual';
        mapsGroup.style.display = 'none';
    } else {
        venueField.value = '';
        cityField.value  = '';
        mapsGroup.style.display = 'block';
    }
    updateChecklist();
}

/* ── Banner preview ── */
function previewBanner(input) {
    const preview = document.getElementById('bannerPreview');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => { preview.src = e.target.result; preview.style.display = 'block'; };
        reader.readAsDataURL(input.files[0]);
        document.getElementById('uploadLabel').textContent = input.files[0].name;
    }
}
</script>
</body>
</html>
