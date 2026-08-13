<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>User Profile — Admin View</title>
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
  .mainInner { max-width:900px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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
  .pg-header .btn-back {
      background: rgba(255,255,255,0.2);
      color: #fff;
      border: 1px solid rgba(255,255,255,0.4);
      border-radius: 8px;
      padding: 6px 14px;
      font-size: 0.85rem;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.2s;
  }
  .pg-header .btn-back:hover { background: rgba(255,255,255,0.3); }

  /* ── PROFILE CARD ── */
  .profile-card {
      background: #fff;
      border-radius: 16px;
      padding: 30px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--maroon-border);
  }
  
  .profile-header {
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
      margin-bottom: 30px;
      padding-bottom: 25px;
      border-bottom: 1px solid var(--maroon-border);
  }
  .profile-avatar {
      width: 100px;
      height: 100px;
      background: var(--maroon-pale);
      color: var(--maroon);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      margin-bottom: 15px;
      border: 2px solid var(--maroon-light);
      object-fit: cover;
  }
  .profile-name {
      font-size: 1.6rem;
      font-weight: 700;
      color: var(--maroon-dark);
      margin-bottom: 5px;
  }
  .profile-email {
      color: #6b7280;
      font-size: 0.95rem;
      margin-bottom: 15px;
  }
  
  .badge-status {
    padding:6px 16px; border-radius:999px; font-size:0.8rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-VERIFIED { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-PENDING { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-REJECTED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
  .status-BANNED   { background:#1f2937; color:#f9fafb; border-color:#374151; }

  /* Reward Badge */
  .reward-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: linear-gradient(135deg, #f59e0b, #ef4444);
      color: #fff;
      border-radius: 20px;
      padding: 6px 16px;
      font-size: 0.85rem;
      font-weight: 700;
      margin-top: 15px;
      box-shadow: 0 4px 10px rgba(239,68,68,0.3);
  }

  /* ── INFO GRID ── */
  .section-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--maroon);
      margin-bottom: 15px;
      display: flex;
      align-items: center;
      gap: 8px;
  }
  
  .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
  }
  .info-item {
      background: var(--maroon-pale);
      padding: 16px;
      border-radius: 12px;
      border: 1px solid var(--maroon-border);
  }
  .info-label {
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--maroon-light);
      font-weight: 700;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .info-value {
      font-size: 1rem;
      font-weight: 600;
      color: var(--maroon-dark);
      word-break: break-word;
  }

  /* ── IDENTITY DOCUMENT ── */
  .doc-box {
      background: #fff;
      border-radius: 12px;
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      border: 1px solid var(--maroon-border);
      margin-bottom: 30px;
  }
  .doc-box-icon {
      width: 50px;
      height: 50px;
      background: var(--maroon-pale);
      color: var(--maroon);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
  }
  .doc-box-content .label { font-size: 0.85rem; color: #6b7280; margin-bottom: 4px; }
  .doc-link {
      color: var(--maroon);
      font-weight: 700;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .doc-link:hover { color: var(--maroon-light); text-decoration: underline; }

  /* ── ACTIONS ── */
  .action-bar {
      display: flex;
      justify-content: center;
      gap: 15px;
      flex-wrap: wrap;
      padding-top: 25px;
      border-top: 1px solid var(--maroon-border);
  }
  .btn-verify {
      background: #059669;
      color: #fff;
      border: none;
      border-radius: 10px;
      padding: 10px 24px;
      font-size: 0.95rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
  }
  .btn-verify:hover { background: #047857; transform: translateY(-2px); }
  
  .btn-reject {
      background: #dc2626;
      color: #fff;
      border: none;
      border-radius: 10px;
      padding: 10px 24px;
      font-size: 0.95rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
  }
  .btn-reject:hover { background: #b91c1c; transform: translateY(-2px); }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--maroon-border);}
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
    <a class="nl" href="${pageContext.request.contextPath}/admin/martialManagement"><i class="fas fa-dumbbell"></i> Martial Arts Centres</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-suggestions"><i class="fas fa-users"></i> Volunteer Suggestions</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-doctors"><i class="fas fa-user-md"></i> Doctor Verification</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-providers"><i class="fas fa-store"></i> Provider Verification</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-sellers"><i class="fas fa-shopping-bag"></i> Seller Verification</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/women-product-orders"><i class="fas fa-box-open"></i> Orders & Stock</a>
    
    <div class="sec-title">Content</div>
    <a class="nl" href="${pageContext.request.contextPath}/video/videoManagement"><i class="fas fa-video"></i> Video Library</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/videos"><i class="fas fa-gift"></i> Reels Rewards</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/user-reels"><i class="fas fa-mobile-alt"></i> User Reels Management</a>

    <div class="sec-title">Account</div>
    <a class="nl active" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-user-cog"></i> User Management</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/profile/${admin.id}"><i class="fas fa-user"></i> Profile</a>
  </aside>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-user-shield me-2"></i>User Profile</h4>
          <p>Full profile details for the selected user</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn-back">
            <i class="fas fa-arrow-left me-1"></i> Back to Users
        </a>
      </div>

      <div class="profile-card">
          <!-- Profile Header -->
          <div class="profile-header">
              <c:choose>
                  <c:when test="${not empty user.profilePhoto}">
                      <img src="${pageContext.request.contextPath}${user.profilePhoto}" class="profile-avatar" alt="User Profile">
                  </c:when>
                  <c:otherwise>
                      <div class="profile-avatar">
                          <i class="fas fa-user"></i>
                      </div>
                  </c:otherwise>
              </c:choose>

              <div class="profile-name">${user.fullName}</div>
              <div class="profile-email">${user.email}</div>
              
              <c:choose>
                  <c:when test="${user.verificationStatus == 'VERIFIED'}">
                      <span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span>
                  </c:when>
                  <c:when test="${user.verificationStatus == 'REJECTED'}">
                      <span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span>
                  </c:when>
                  <c:when test="${user.banned}">
                      <span class="badge-status status-BANNED"><i class="fas fa-ban me-1"></i> BANNED</span>
                  </c:when>
                  <c:otherwise>
                      <span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> PENDING</span>
                  </c:otherwise>
              </c:choose>

              <!-- Reward Points -->
              <c:if test="${user.rewardPoints != null && user.rewardPoints > 0}">
                  <div class="reward-badge">
                      <i class="fas fa-star"></i> ${user.rewardPoints} Reward Points
                  </div>
              </c:if>
          </div>

          <!-- User Information -->
          <div class="section-title"><i class="fas fa-id-card"></i> Personal Information</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                  <div class="info-value">${not empty user.fullName ? user.fullName : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                  <div class="info-value">${not empty user.email ? user.email : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-phone"></i> Phone Number</div>
                  <div class="info-value">${not empty user.phoneNumber ? user.phoneNumber : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-venus-mars"></i> Gender</div>
                  <div class="info-value">${not empty user.gender ? user.gender : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-calendar"></i> Date of Birth</div>
                  <div class="info-value">${not empty user.dob ? user.dob : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-hashtag"></i> Age</div>
                  <div class="info-value">${not empty user.age ? user.age : '—'}</div>
              </div>
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-home"></i> Home Address</div>
                  <div class="info-value">${not empty user.homeAddress ? user.homeAddress : '—'}</div>
              </div>
          </div>

          <!-- Identity Document -->
          <div class="section-title"><i class="fas fa-file-alt"></i> Identity Document</div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-file-image"></i></div>
              <div class="doc-box-content">
                  <c:choose>
                      <c:when test="${not empty user.identityDocument}">
                          <div class="label">Uploaded Identity Proof</div>
                          <a href="${pageContext.request.contextPath}${user.identityDocument}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View / Download Document
                          </a>
                      </c:when>
                      <c:otherwise>
                          <div class="text-muted">No identity document uploaded.</div>
                      </c:otherwise>
                  </c:choose>
              </div>
          </div>

          <!-- Action Buttons -->
          <div class="action-bar">
              <c:if test="${user.verificationStatus != 'VERIFIED'}">
                  <form action="${pageContext.request.contextPath}/admin/users/${user.id}/verify" method="post" class="m-0 p-0">
                      <button type="submit" class="btn-verify">
                          <i class="fas fa-check-circle"></i> Verify User
                      </button>
                  </form>
              </c:if>

              <c:if test="${user.verificationStatus != 'REJECTED'}">
                  <form action="${pageContext.request.contextPath}/admin/users/${user.id}/reject" method="post" class="m-0 p-0" onsubmit="return confirm('Are you sure you want to reject this user?')">
                      <button type="submit" class="btn-reject">
                          <i class="fas fa-times-circle"></i> Reject User
                      </button>
                  </form>
              </c:if>
          </div>

      </div>

    </div>
  </main>
</div>

</body>
</html>

