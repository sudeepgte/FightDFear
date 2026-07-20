<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Edit Admin Profile — Admin</title>
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
  .mainInner { max-width:800px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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

  /* ── FORM CARD ── */
  .form-card {
      background: #fff;
      border-radius: 16px;
      border: 1px solid var(--maroon-border);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
  }
  .form-header {
      background: var(--maroon-pale);
      padding: 20px 25px;
      border-bottom: 1px solid var(--maroon-border);
      font-weight: 700;
      color: var(--maroon-dark);
      display: flex;
      align-items: center;
      gap: 10px;
  }
  .form-body {
      padding: 30px;
  }
  
  .form-group {
      margin-bottom: 20px;
  }
  .form-group label {
      font-weight: 600;
      color: var(--maroon-dark);
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .form-control {
      border: 2px solid var(--maroon-border);
      border-radius: 8px;
      padding: 12px 15px;
      font-family: 'Poppins', sans-serif;
      transition: all 0.2s;
  }
  .form-control:focus {
      border-color: var(--maroon-light);
      box-shadow: 0 0 0 3px rgba(125,42,90,0.15);
  }

  .form-actions {
      padding: 20px 30px;
      background: rgba(125,42,90,0.02);
      border-top: 1px solid var(--maroon-border);
      display: flex;
      gap: 15px;
  }
  
  .btn-submit {
      flex: 1;
      background: var(--maroon);
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 12px;
      font-weight: 600;
      transition: all 0.2s;
  }
  .btn-submit:hover { background: var(--maroon-light); transform: translateY(-2px); box-shadow: 0 4px 12px rgba(125,42,90,0.2); color: #fff;}
  
  .btn-cancel {
      flex: 1;
      background: #fff;
      color: #6b7280;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      padding: 12px;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-cancel:hover { background: #f3f4f6; color: #374151; transform: translateY(-2px); }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--maroon-border);}
  }
  @media(max-width:576px){
    .form-actions { flex-direction: column; }
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
          <h4><i class="fas fa-user-edit me-2"></i>Edit Admin Profile</h4>
          <p>Update your personal account credentials and information</p>
        </div>
      </div>

      <!-- Form Card -->
      <div class="form-card">
          <div class="form-header">
              <i class="fas fa-shield-alt text-primary"></i> Administrator Credentials
          </div>
          
          <form action="${pageContext.request.contextPath}/admin/update" method="post" enctype="multipart/form-data" class="m-0">
              <div class="form-body">
                  <input type="hidden" name="id" value="${admin.id}">
                  
                  <div class="text-center mb-4">
                      <div class="position-relative d-inline-block">
                          <c:choose>
                              <c:when test="${not empty admin.profilePhoto}">
                                  <img src="${pageContext.request.contextPath}${admin.profilePhoto}" id="photoPreview" class="rounded-circle shadow-sm" style="width:120px; height:120px; object-fit:cover; border:3px solid var(--maroon-pale);">
                              </c:when>
                              <c:otherwise>
                                  <div id="photoPreviewPlaceholder" class="rounded-circle shadow-sm bg-light d-flex align-items-center justify-content-center" style="width:120px; height:120px; border:3px solid var(--maroon-pale);">
                                      <i class="fas fa-user-shield fa-3x text-muted"></i>
                                  </div>
                                  <img id="photoPreview" class="rounded-circle shadow-sm d-none" style="width:120px; height:120px; object-fit:cover; border:3px solid var(--maroon-pale);">
                              </c:otherwise>
                          </c:choose>
                          <label for="profileImage" class="position-absolute bottom-0 end-0 bg-maroon text-white rounded-circle d-flex align-items-center justify-content-center shadow" style="width:32px; height:32px; cursor:pointer; background:var(--maroon);">
                              <i class="fas fa-camera fa-xs"></i>
                          </label>
                          <input type="file" id="profileImage" name="profileImage" class="d-none" accept="image/*" onchange="previewImage(this)">
                      </div>
                      <div class="form-text mt-2">Click the camera icon to change photo</div>
                  </div>

                  <div class="form-group">
                      <label><i class="fas fa-user text-muted"></i> Full Name</label>
                      <input type="text" name="name" class="form-control" value="${admin.name}" required placeholder="Enter your full name">
                  </div>
                  
                  <div class="form-group">
                      <label><i class="fas fa-envelope text-muted"></i> Email Address</label>
                      <input type="email" name="email" class="form-control" value="${admin.email}" required placeholder="admin@example.com">
                  </div>
                  
                  <div class="form-group">
                      <label><i class="fas fa-lock text-muted"></i> New Password</label>
                      <input type="password" name="password" class="form-control" required placeholder="Enter a secure password">
                      <div class="form-text mt-2 text-muted"><i class="fas fa-info-circle me-1"></i> You must provide your password (or a new one) to save changes.</div>
                  </div>
              </div>
              
              <script>
                function previewImage(input) {
                    if (input.files && input.files[0]) {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            var preview = document.getElementById('photoPreview');
                            var placeholder = document.getElementById('photoPreviewPlaceholder');
                            preview.src = e.target.result;
                            preview.classList.remove('d-none');
                            if (placeholder) placeholder.classList.add('d-none');
                        }
                        reader.readAsDataURL(input.files[0]);
                    }
                }
              </script>
              
              <div class="form-actions">
                  <a href="${pageContext.request.contextPath}/admin/profile/${admin.id}" class="btn-cancel">
                      <i class="fas fa-times me-1"></i> Cancel
                  </a>
                  <button type="submit" class="btn-submit">
                      <i class="fas fa-save me-1"></i> Update Profile
                  </button>
              </div>
          </form>
      </div>

    </div>
  </main>
</div>

</body>
</html>

