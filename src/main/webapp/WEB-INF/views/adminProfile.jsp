<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Profile — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon:        #1e1b4b;
    --maroon-light:  #312e81;
    --maroon-dark:   #0b0920;
    --maroon-pale:   #f8fafc;
    --maroon-border: rgba(30, 27, 75, 0.12);
    --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; }

  /* ── TOPBAR ── */
  .topbar {
    background: var(--maroon); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    box-shadow: 0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff;
    border:1px solid rgba(255,255,255,0.3); border-radius:7px;
    padding:5px 16px; font-size:0.85rem; font-weight:600;
    text-decoration:none; transition:background 0.2s;
  }

  /* ── LAYOUT ── */
  .layout { display:flex; min-height:calc(100vh - 58px); }

  /* ── SIDEBAR ── */
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
  }
  .sidebar .brand-label { font-weight:700; color:var(--maroon); font-size:0.95rem; margin-bottom:10px; padding:0 6px; }
  .sidebar .sec-title { margin:14px 8px 6px; font-size:0.72rem; font-weight:700; color:#9ca3af; text-transform:uppercase; letter-spacing:0.06em; }
  .sidebar a.nl {
    display:flex; align-items:center; gap:9px;
    padding:9px 10px; border-radius:9px;
    color:#374151; text-decoration:none; font-weight:500; font-size:0.88rem;
    transition:all 0.18s;
  }
  .sidebar a.nl i { width:18px; text-align:center; color:var(--maroon); font-size:0.9rem; }
  .sidebar a.nl:hover { background:rgba(125,42,90,0.08); padding-left:14px; color:#1a1a2e; }
  .sidebar a.nl.active { background:rgba(125,42,90,0.12); color:var(--maroon); font-weight:700; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:1000px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
  @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

  /* ── PAGE HEADER ── */
  .pg-header {
    background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 28px rgba(125,42,90,0.22);
    display:flex; align-items:center; justify-content:space-between;
  }
  .pg-header h4 { color:#fff; font-weight:700; font-size:1.2rem; margin:0; }
  .pg-header p { color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.85rem; }

  /* ── PROFILE CARD ── */
  .profile-container {
      background: #fff;
      border-radius: 16px;
      border: 1px solid var(--maroon-border);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
      max-width: 600px;
      margin: 0 auto;
  }
  .profile-header {
      background: var(--maroon-pale);
      padding: 30px;
      text-align: center;
      border-bottom: 1px solid var(--maroon-border);
  }
  .profile-avatar {
      width: 100px;
      height: 100px;
      background: #fff;
      border: 3px solid var(--maroon);
      border-radius: 50%;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      color: var(--maroon);
      margin-bottom: 15px;
      box-shadow: 0 4px 15px rgba(125,42,90,0.2);
  }
  .profile-header h3 {
      font-weight: 700;
      color: var(--maroon-dark);
      margin: 0 0 5px;
  }
  .profile-header p {
      color: #6b7280;
      margin: 0;
      font-size: 0.95rem;
  }
  .profile-body {
      padding: 30px;
  }
  
  .info-group {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid rgba(125,42,90,0.08);
  }
  .info-group:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
  }
  .info-label {
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: #9ca3af;
      font-weight: 600;
      margin-bottom: 4px;
      display: block;
  }
  .info-value {
      font-size: 1.05rem;
      font-weight: 500;
      color: #1a1a2e;
      display: flex;
      align-items: center;
      gap: 10px;
  }
  .info-value i {
      color: var(--maroon-light);
      width: 20px;
      text-align: center;
  }

  .profile-actions {
      display: flex;
      gap: 15px;
      padding: 20px 30px;
      background: rgba(125,42,90,0.02);
      border-top: 1px solid var(--maroon-border);
  }
  
  .btn-edit {
      flex: 1;
      background: var(--maroon);
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 10px 15px;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-edit:hover { background: var(--maroon-light); color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
  
  .btn-back {
      flex: 1;
      background: #fff;
      color: var(--maroon);
      border: 1px solid var(--maroon-border);
      border-radius: 8px;
      padding: 10px 15px;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-back:hover { background: var(--maroon-pale); color: var(--maroon-dark); transform: translateY(-2px); }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--maroon-border);}
  }
  @media(max-width:576px){
    .profile-actions { flex-direction: column; }
  }
</style>
</head>
<body>

<div class="topbar">
  <span class="brand">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <aside class="sidebar">
    <div class="brand-label">Admin Menu</div>
    <div class="sec-title">Dashboard</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/adminDashboard"><i class="fas fa-home"></i> Home</a>

    <div class="sec-title">Moderation</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/sos"><i class="fas fa-broadcast-tower"></i> SOS Monitoring</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/reported-videos"><i class="fas fa-flag"></i> Reported Videos</a>
    <a class="nl" href="${pageContext.request.contextPath}/qna/admin/questions"><i class="fas fa-question-circle"></i> Q&amp;A Panel</a>

    <div class="sec-title">Approvals</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/users">
        <i class="fas fa-user-cog"></i> User Management
        <c:if test="${side_pendingUsers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto" style="font-size: 0.65rem; padding: 0.25em 0.6em;">${side_pendingUsers}</span>
        </c:if>
    </a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/martialManagement">
        <i class="fas fa-dumbbell"></i> Martial Arts Centres
        <c:if test="${side_pendingCentres > 0}">
            <span class="badge rounded-pill bg-danger ms-auto" style="font-size: 0.65rem; padding: 0.25em 0.6em;">${side_pendingCentres}</span>
        </c:if>
    </a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-doctors">
        <i class="fas fa-user-md"></i> Doctor Verification
        <c:if test="${side_pendingDoctors > 0}">
            <span class="badge rounded-pill bg-danger ms-auto" style="font-size: 0.65rem; padding: 0.25em 0.6em;">${side_pendingDoctors}</span>
        </c:if>
    </a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-sellers">
        <i class="fas fa-shopping-bag"></i> Seller Verification
        <c:if test="${side_pendingSellers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto" style="font-size: 0.65rem; padding: 0.25em 0.6em;">${side_pendingSellers}</span>
        </c:if>
    </a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-suggestions"><i class="fas fa-users"></i> Volunteer Suggestions</a>
    <a class="nl" href="${pageContext.request.contextPath}/video/videoManagement"><i class="fas fa-video"></i> Video Library</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/videos"><i class="fas fa-gift"></i> Video Rewards</a>

    <div class="sec-title">Account</div>
    <a class="nl active" href="${pageContext.request.contextPath}/admin/profile/${admin.id}"><i class="fas fa-user"></i> Profile</a>
  </aside>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-user-circle me-2"></i>Admin Profile</h4>
          <p>View and manage your personal administrative account details</p>
        </div>
      </div>

      <!-- Profile Card -->
      <div class="profile-container">
          <div class="profile-header">
              <div class="profile-avatar" style="overflow: hidden;">
                  <c:choose>
                      <c:when test="${not empty admin.profilePhoto}">
                          <img src="${pageContext.request.contextPath}${admin.profilePhoto}" style="width: 100%; height: 100%; object-fit: cover;">
                      </c:when>
                      <c:otherwise>
                          <i class="fas fa-user-shield"></i>
                      </c:otherwise>
                  </c:choose>
              </div>
              <h3>${admin.name}</h3>
              <p>System Administrator</p>
          </div>
          
          <div class="profile-body">
              <div class="info-group">
                  <span class="info-label">Admin ID</span>
                  <div class="info-value">
                      <i class="fas fa-id-badge"></i> #${admin.id}
                  </div>
              </div>
              
              <div class="info-group">
                  <span class="info-label">Full Name</span>
                  <div class="info-value">
                      <i class="fas fa-user"></i> ${admin.name}
                  </div>
              </div>
              
              <div class="info-group">
                  <span class="info-label">Email Address</span>
                  <div class="info-value">
                      <i class="fas fa-envelope"></i> ${admin.email}
                  </div>
              </div>
          </div>
          
          <div class="profile-actions">
              <a href="${pageContext.request.contextPath}/admin/edit/${admin.id}" class="btn-edit">
                  <i class="fas fa-pen me-2"></i>Edit Profile
              </a>
              <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn-back">
                  <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
              </a>
          </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>

