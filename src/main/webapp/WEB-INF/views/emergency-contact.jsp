<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emergency Contacts | Women Safety</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
    /* ============================================
       ROOT VARIABLES (your brand colors)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        
        /* Dark theme specific (using your brand colors) */
        --bg-primary: var(--dark-bg);
        --bg-card: rgba(255,255,255,0.04);
        --bg-glass: rgba(255,255,255,0.06);
        --text-primary: #f0f0f5;
        --text-secondary: #8a8a9a;
        --accent-red: var(--primary-coral-dark);
        --accent-green: var(--primary-teal);
        --accent-blue: var(--primary-purple-light);
        --accent-purple: var(--primary-purple-light);
        --accent-orange: var(--primary-gold);
        --border-subtle: rgba(255,255,255,0.08);
    }
    
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
        font-family: 'Inter', -apple-system, sans-serif;
        background: #150510;
        color: var(--text-primary);
        min-height: 100vh;
    }
    .bg-grid {
        position: fixed; inset: 0;
        background-image:
            radial-gradient(circle at 20% 50%, rgba(124, 45, 94, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(219, 39, 119, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 50% 80%, rgba(30, 27, 75, 0.1) 0%, transparent 50%);
        background-size: cover;
        z-index: 0;
    }

    /* Top Nav */
    .top-nav {
        position: fixed; top: 0; left: 0; right: 0;
        padding: 16px 24px;
        display: flex; justify-content: space-between; align-items: center;
        background: linear-gradient(to right, var(--primary-purple), #4a0e2a);
        backdrop-filter: blur(20px);
        border-bottom: 2px solid var(--primary-coral);
        z-index: 100;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    }
    .top-nav .brand { font-weight:700; font-size:18px; display:flex; align-items:center; gap:8px; }
    .top-nav .brand i { color: var(--accent-purple); }
    .top-nav .back-btn {
        color: var(--text-secondary); text-decoration:none; font-size:14px;
        display:flex; align-items:center; gap:6px; transition: color 0.2s;
    }
    .top-nav .back-btn:hover { color: var(--text-primary); }

    /* Container */
    .page-container {
        position: relative; z-index: 1;
        max-width: 600px; margin: 0 auto;
        padding: 80px 20px 40px;
    }

    /* Header */
    .page-header {
        text-align: center;
        margin-bottom: 30px;
    }
    .page-header h1 {
        font-size: 24px; font-weight: 800;
        margin-bottom: 8px;
    }
    .page-header p {
        font-size: 13px; color: var(--text-secondary);
        max-width: 400px; margin: 0 auto;
    }

    /* Alert Banner */
    .alert-banner {
        padding: 14px 16px;
        background: rgba(255,215,0,0.1);
        border: 1px solid rgba(255,215,0,0.25);
        border-radius: 12px;
        margin-bottom: 24px;
        display: flex; align-items: flex-start; gap: 10px;
        font-size: 12px; color: var(--accent-orange);
    }
    .alert-banner i { font-size: 16px; margin-top: 1px; }

    /* Contact Card */
    .contact-card {
        background: var(--bg-glass);
        border: 1px solid var(--border-subtle);
        border-radius: 14px;
        padding: 16px 18px;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 14px;
        transition: all 0.3s;
    }
    .contact-card:hover {
        border-color: rgba(255,255,255,0.15);
        background: rgba(255,255,255,0.08);
    }
    .contact-card .avatar {
        width: 44px; height: 44px;
        border-radius: 50%;
        display: flex; justify-content: center; align-items: center;
        font-size: 18px; font-weight: 700;
        flex-shrink: 0;
    }
    .contact-card .avatar.personal { background: rgba(124, 45, 94, 0.2); color: var(--primary-purple-light); }
    .contact-card .avatar.police { background: rgba(0, 188, 212, 0.2); color: #00bcd4; }
    .contact-card .avatar.medical { background: rgba(48, 209, 88, 0.2); color: var(--accent-green); }

    .contact-card .info { flex: 1; min-width: 0; }
    .contact-card .info .name {
        font-size: 14px; font-weight: 600;
        white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .contact-card .info .meta {
        font-size: 11px; color: var(--text-secondary);
        margin-top: 2px;
        display: flex; flex-wrap: wrap; gap: 8px;
    }
    .contact-card .info .meta span { display: flex; align-items: center; gap: 3px; }

    .contact-card .actions {
        display: flex; gap: 6px; flex-shrink: 0;
    }
    .contact-card .actions a, .contact-card .actions button {
        width: 34px; height: 34px;
        border-radius: 50%;
        border: 1px solid var(--border-subtle);
        background: transparent;
        color: var(--text-secondary);
        display: flex; justify-content: center; align-items: center;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.2s;
        text-decoration: none;
    }
    .contact-card .actions a:hover, .contact-card .actions button:hover {
        background: rgba(255,255,255,0.1);
        color: var(--text-primary);
    }
    .contact-card .actions .call-btn:hover { background: rgba(32,201,151,0.2); color: var(--accent-green); }
    .contact-card .actions .delete-btn:hover { background: rgba(232,69,69,0.2); color: var(--accent-red); }

    /* Badges */
    .badge-notify {
        display: inline-flex; align-items: center; gap: 4px;
        padding: 3px 8px; border-radius: 20px;
        font-size: 10px; font-weight: 600;
    }
    .badge-email { background: rgba(123,44,191,0.15); color: var(--accent-purple); }
    .badge-call { background: rgba(32,201,151,0.15); color: var(--accent-green); }
    .badge-default { background: rgba(255,255,255,0.06); color: var(--text-secondary); }

    /* Add Form */
    .add-form-card {
        background: var(--bg-glass);
        border: 1px solid var(--border-subtle);
        border-radius: 14px;
        padding: 24px;
        margin-top: 24px;
    }
    .add-form-card h3 {
        font-size: 16px; font-weight: 700;
        margin-bottom: 20px;
        display: flex; align-items: center; gap: 8px;
    }
    .add-form-card h3 i { color: var(--accent-green); }

    .form-group {
        margin-bottom: 16px;
    }
    .form-group label {
        display: block;
        font-size: 12px; font-weight: 600;
        color: var(--text-secondary);
        margin-bottom: 6px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .form-group input, .form-group select {
        width: 100%;
        padding: 12px 14px;
        background: rgba(255,255,255,0.05);
        border: 1px solid var(--border-subtle);
        border-radius: 10px;
        color: var(--text-primary);
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        transition: border-color 0.2s;
    }
    .form-group input:focus, .form-group select:focus {
        outline: none;
        border-color: var(--accent-purple);
    }
    .form-group input::placeholder { color: rgba(255,255,255,0.2); }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

    .submit-btn {
        width: 100%;
        padding: 14px;
        border-radius: 12px;
        border: none;
        background: var(--gradient-primary);
        color: white;
        font-family: 'Inter', sans-serif;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        margin-top: 8px;
    }
    .submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(123,44,191,0.4);
    }

    /* Section title */
    .section-title {
        font-size: 13px; font-weight: 700;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1px;
        margin: 24px 0 12px;
        display: flex; align-items: center; gap: 8px;
    }
    .section-title .line { flex: 1; height: 1px; background: var(--border-subtle); }

    /* Info card */
    .info-card {
        padding: 14px 16px;
        background: rgba(32,201,151,0.06);
        border: 1px solid rgba(32,201,151,0.15);
        border-radius: 12px;
        margin-top: 24px;
        font-size: 12px; color: var(--text-secondary);
        line-height: 1.7;
    }
    .info-card strong { color: var(--accent-green); }

    /* Responsive */
    @media (max-width: 480px) {
        .form-row { grid-template-columns: 1fr; }
        .page-container { padding: 70px 16px 30px; }
    }

    /* Toast */
    .toast {
        position: fixed; top: 80px; left: 50%; transform: translateX(-50%);
        padding: 12px 24px;
        background: rgba(32,201,151,0.15); border: 1px solid rgba(32,201,151,0.3);
        border-radius: 12px; color: var(--accent-green);
        font-size: 13px; font-weight: 500; z-index: 300; display: none;
        backdrop-filter: blur(20px);
    }
    .toast.show { display: block; animation: slideIn 0.3s ease; }
    @keyframes slideIn { from { opacity:0; transform: translateX(-50%) translateY(-20px); } to { opacity:1; transform: translateX(-50%) translateY(0); } }
</style>
</head>
<body>

<div class="bg-grid"></div>

<!-- Toast -->
<div class="toast" id="toast"></div>

<!-- Top Nav -->
<nav class="top-nav">
    <div class="brand"><i class="bi bi-person-lines-fill"></i> Emergency Contacts</div>
    <a href="${pageContext.request.contextPath}/sos/dashboard" class="back-btn">
        <i class="bi bi-arrow-left"></i> SOS Dashboard
    </a>
</nav>

<div class="page-container">

    <!-- Header -->
    <div class="page-header">
        <h1>🛡️ My Emergency Contacts</h1>
        <p>These contacts will be <strong>emailed</strong> and <strong>auto-called</strong> when you trigger an SOS alert.</p>
    </div>

    <!-- Alert if no personal contacts -->
    <c:if test="${empty contacts or contacts.size() <= 2}">
        <div class="alert-banner">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <div>
                <strong>Add your emergency contacts!</strong><br>
                Without personal contacts, SOS will only notify default Police (100) and Ambulance (108). 
                Add at least one contact with a valid <strong>email</strong> and <strong>phone number</strong> for best protection.
            </div>
        </div>
    </c:if>

    <!-- Default Contacts -->
    <div class="section-title">
        <span>Default Emergency Services</span>
        <div class="line"></div>
    </div>

    <div class="contact-card">
        <div class="avatar police"><i class="bi bi-shield-fill"></i></div>
        <div class="info">
            <div class="name">Police</div>
            <div class="meta">
                <span><i class="bi bi-telephone"></i> 100</span>
                <span class="badge-notify badge-default">Always available</span>
            </div>
        </div>
        <div class="actions">
            <a href="tel:100" class="call-btn" title="Call"><i class="bi bi-telephone-fill"></i></a>
        </div>
    </div>

    <div class="contact-card">
        <div class="avatar medical"><i class="bi bi-heart-pulse-fill"></i></div>
        <div class="info">
            <div class="name">Ambulance</div>
            <div class="meta">
                <span><i class="bi bi-telephone"></i> 108</span>
                <span class="badge-notify badge-default">Always available</span>
            </div>
        </div>
        <div class="actions">
            <a href="tel:108" class="call-btn" title="Call"><i class="bi bi-telephone-fill"></i></a>
        </div>
    </div>

    <!-- Personal Contacts -->
    <div class="section-title">
        <span>Your Personal Contacts</span>
        <div class="line"></div>
    </div>

    <c:set var="hasPersonal" value="false" />
    <c:forEach var="contact" items="${contacts}">
        <c:if test="${contact.name != 'Police' and contact.name != 'Ambulance'}">
            <c:set var="hasPersonal" value="true" />
            <div class="contact-card">
                <div class="avatar personal">
                    ${contact.name.substring(0,1).toUpperCase()}
                </div>
                <div class="info">
                    <div class="name">${contact.name}</div>
                    <div class="meta">
                        <span><i class="bi bi-telephone"></i> ${contact.phone}</span>
                        <c:if test="${not empty contact.email}">
                            <span><i class="bi bi-envelope"></i> ${contact.email}</span>
                        </c:if>
                        <c:if test="${not empty contact.relation}">
                            <span><i class="bi bi-people"></i> ${contact.relation}</span>
                        </c:if>
                    </div>
                    <div class="meta" style="margin-top: 6px;">
                        <c:if test="${not empty contact.email}">
                            <span class="badge-notify badge-email"><i class="bi bi-envelope-check"></i> Email on SOS</span>
                        </c:if>
                        <c:if test="${not empty contact.phone}">
                            <span class="badge-notify badge-call"><i class="bi bi-telephone-forward"></i> Auto-call on SOS</span>
                        </c:if>
                    </div>
                </div>
                <div class="actions">
                    <a href="tel:${contact.phone}" class="call-btn" title="Call now">
                        <i class="bi bi-telephone-fill"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/users/${userId}/emergency-contacts/delete/${contact.id}" 
                       class="delete-btn" title="Remove"
                       onclick="return confirm('Remove ${contact.name} from emergency contacts?');">
                        <i class="bi bi-trash3"></i>
                    </a>
                </div>
            </div>
        </c:if>
    </c:forEach>

    <c:if test="${hasPersonal == 'false'}">
        <div style="text-align: center; padding: 30px 0; color: var(--text-secondary); font-size: 13px;">
            <i class="bi bi-person-plus" style="font-size: 32px; display: block; margin-bottom: 10px; opacity: 0.4;"></i>
            No personal contacts added yet.<br>
            Add contacts below to get notified during SOS.
        </div>
    </c:if>

    <!-- Add Contact Form -->
    <div class="add-form-card">
        <h3><i class="bi bi-plus-circle-fill"></i> Add Emergency Contact</h3>
        <form action="${pageContext.request.contextPath}/users/${userId}/emergency-contacts" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" placeholder="e.g. Mom, Dad, Sister" required>
                </div>
                <div class="form-group">
                    <label>Relation</label>
                    <input type="text" name="relation" placeholder="e.g. Mother, Friend" required>
                </div>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" placeholder="+91 9876543210" required>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="contact@email.com" required>
            </div>
            <button type="submit" class="submit-btn">
                <i class="bi bi-plus-lg"></i> &nbsp; Add Contact
            </button>
        </form>
    </div>

    <!-- Info -->
    <div class="info-card">
        <strong><i class="bi bi-info-circle"></i> How contacts are used during SOS:</strong><br>
        📧 <strong>Email alert</strong> — All contacts with email receive an emergency email with your <strong>live Google Maps location</strong><br>
        📞 <strong>Auto-call</strong> — Your <strong>first personal contact</strong> is auto-dialed after the SOS countdown expires<br>
        🔔 <strong>Multiple contacts</strong> — Add family, friends, neighbors for maximum safety coverage
    </div>
</div>

</body>
</html>

