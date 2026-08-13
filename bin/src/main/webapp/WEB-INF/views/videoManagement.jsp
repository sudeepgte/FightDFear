<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Manage Videos — Admin</title>
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
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; overflow-x: hidden; }

  /* ── TOPBAR ── */
  .topbar {
    background: var(--maroon); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    box-shadow: 0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { 
    font-size:1.1rem; 
    font-weight:700; 
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    min-width: 0;
  }
  .topbar .btn-logout {
    flex-shrink: 0;
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
  .sidebar .brand { font-weight:700; color:var(--maroon); font-size:0.95rem; margin-bottom:10px; padding:0 6px; }
  .sidebar .sectionTitle { margin:14px 8px 6px; font-size:0.72rem; font-weight:700; color:#9ca3af; text-transform:uppercase; letter-spacing:0.06em; }
  .sidebar a.navlink {
    display:flex; align-items:center; gap:9px;
    padding:9px 10px; border-radius:9px;
    color:#374151; text-decoration:none; font-weight:500; font-size:0.88rem;
    transition:all 0.18s;
  }
  .sidebar a.navlink i { width:18px; text-align:center; color:var(--maroon); font-size:0.9rem; }
  .sidebar a.navlink:hover { background:rgba(125,42,90,0.08); padding-left:14px; color:#1a1a2e; }
  .sidebar a.navlink.active { background:rgba(125,42,90,0.12); color:var(--maroon); font-weight:700; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; overflow-x: hidden; }
  .mainInner { max-width:1200px; margin:0 auto; }
  
  @media (min-width: 993px) {
    .mainInner { animation:fadeUp 0.35s ease-out; }
  }
  @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

  /* ── PAGE HEADER ── */
  .pg-header {
    background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 28px rgba(125,42,90,0.22);
    display:flex; align-items:center; justify-content:space-between;
    flex-wrap: wrap;
    gap: 15px;
  }
  .pg-header h4 { color:#fff; font-weight:700; font-size:1.2rem; margin:0; }
  .pg-header p { color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.85rem; }
  
  .btn-upload {
      background: #fff;
      color: var(--maroon);
      border: none;
      border-radius: 8px;
      padding: 10px 20px;
      font-size: 0.9rem;
      font-weight: 700;
      text-decoration: none;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
  }
  .btn-upload:hover { background: #f8f9fa; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); color: var(--maroon); }

  /* ── FILTER BAR ── */
  .filter-bar {
      background: #fff;
      border: 1px solid var(--maroon-border);
      border-radius: 12px;
      padding: 15px 20px;
      margin-bottom: 25px;
      display: flex;
      align-items: center;
      gap: 15px;
      box-shadow: var(--shadow-sm);
  }
  .filter-bar label {
      font-weight: 600;
      color: var(--maroon-dark);
      margin: 0;
  }
  .filter-select {
      border: 2px solid var(--maroon-border);
      border-radius: 8px;
      padding: 8px 15px;
      outline: none;
      font-family: 'Poppins', sans-serif;
      font-size: 0.9rem;
      color: #374151;
      width: 100%;
      max-width: 100%;
      box-sizing: border-box;
  }
  .filter-select:focus { border-color: var(--maroon-light); }

  .filter-form {
      display: flex;
      gap: 10px;
      align-items: center;
      margin: 0;
      flex: 1;
  }
  
  @media (min-width: 769px) {
    .filter-select { width: auto; min-width: 200px; }
    .filter-form { flex: 0 1 auto; }
  }

  .btn-filter {
      background: var(--maroon);
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 8px 20px;
      font-weight: 600;
      transition: all 0.2s;
  }
  .btn-filter:hover { background: var(--maroon-light); color: #fff; }

  /* ── VIDEO GRID ── */
  .video-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 25px;
  }
  .video-card {
      background: #fff;
      border-radius: 16px;
      overflow: hidden;
      border: 1px solid var(--maroon-border);
      box-shadow: var(--shadow-sm);
      transition: transform 0.2s, box-shadow 0.2s;
      display: flex;
      flex-direction: column;
  }
  .video-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 25px rgba(125,42,90,0.15);
  }
  .video-player {
      width: 100%;
      height: 180px;
      background: #000;
      object-fit: contain;
  }
  .video-info {
      padding: 20px;
      flex: 1;
      display: flex;
      flex-direction: column;
  }
  .video-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--maroon-dark);
      margin-bottom: 8px;
  }
  .video-meta {
      font-size: 0.85rem;
      color: #6b7280;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .badge-category {
      background: var(--maroon-pale);
      color: var(--maroon);
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 600;
      border: 1px solid var(--maroon-border);
  }
  .video-actions {
      margin-top: 20px;
      display: flex;
      gap: 10px;
  }
  .btn-open {
      flex: 1;
      background: var(--maroon-pale);
      color: var(--maroon);
      border: 1px solid var(--maroon-border);
      padding: 8px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-open:hover { background: var(--maroon); color: #fff; }

  .btn-edit {
      flex: 1;
      background: var(--maroon-pale);
      color: var(--maroon);
      border: 1px solid var(--maroon-border);
      padding: 8px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-edit:hover { background: var(--maroon); color: #fff; }
  
  .btn-delete {
      flex: 1;
      background: #fee2e2;
      color: #dc2626;
      border: 1px solid #fecaca;
      padding: 8px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-delete:hover { background: #dc2626; color: #fff; }

  .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: #fff;
      border-radius: 16px;
      border: 1px dashed var(--maroon-border);
  }

  /* ── Mobile toggle button ── */
  .mobile-toggle {
      display: none;
      background: none;
      border: none;
      color: #fff;
      font-size: 1.2rem;
      cursor: pointer;
      padding: 4px 8px;
      margin-right: 10px;
  }
  .sidebar-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1500;
      backdrop-filter: blur(2px);
  }
  .sidebar-overlay.active { display: block; }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .mobile-toggle { display: inline-block; }
    .sidebar{
      position: fixed;
      left: -300px;
      top: 0; bottom: 0;
      width: 280px;
      height: 100vh;
      z-index: 2000;
      transition: left 0.3s ease;
      box-shadow: 10px 0 30px rgba(0,0,0,0.2);
      background: #fff;
      border-right: 1px solid var(--maroon-border);
      padding: 20px 14px;
      overflow-y: auto;
    }
    .sidebar.active { left: 0; }
    .main { padding: 20px 14px 36px; }
  }

  /* Tablets and Phones */
  @media (max-width: 768px) {
    .main { padding: 16px 10px 30px; }
    .pg-header { padding: 18px 20px; border-radius: 12px; flex-direction: column; align-items: flex-start; gap: 12px; }
    .pg-header h4 { font-size: 1.05rem; }
    .pg-header p { font-size: 0.78rem; }
    .btn-upload { width: 100%; text-align: center; padding: 10px; font-size: 0.85rem; }

    .filter-bar { padding: 14px; flex-direction: column; align-items: stretch; gap: 10px; border-radius: 10px; }
    .filter-form { flex-direction: column; align-items: stretch; gap: 10px; display: flex; }
    .filter-select { width: 100%; min-width: 0; padding: 10px; }
    .btn-filter { width: 100%; padding: 10px; }

    .video-grid { grid-template-columns: 1fr; gap: 15px; }
    .video-player { height: 200px; }
  }

    /* Video grid – 2 columns */
    .video-grid {
      grid-template-columns: repeat(2, 1fr);
      gap: 14px;
    }
    .video-player { height: 140px; }
    .video-info { padding: 14px; }
    .video-title { font-size: 0.92rem; margin-bottom: 6px; }
    .video-meta { font-size: 0.78rem; }
    .video-actions { gap: 6px; margin-top: 12px; }
    .btn-open, .btn-edit, .btn-delete { padding: 6px; font-size: 0.75rem; }
  }

  /* Phones */
  @media (max-width: 550px) {
    .main { padding: 12px 6px 24px; }
    .mainInner { width: 100%; overflow-x: hidden; }
    .topbar { padding: 0 12px; }
    .topbar .brand { font-size: 0.95rem; }

    .pg-header { padding: 14px 14px; margin-bottom: 16px; }
    .pg-header h4 { font-size: 0.95rem; }
    .btn-upload { width: 100%; justify-content: center; }

    .filter-bar { padding: 12px 10px; margin-bottom: 16px; }

    /* Video grid – single column on small phones */
    .video-grid {
      grid-template-columns: 1fr;
      gap: 12px;
    }
    .video-card { border-radius: 12px; }
    .video-player { height: 180px; }
    .video-info { padding: 12px; }
    .video-title { font-size: 0.95rem; }
    .video-actions { flex-direction: column; gap: 6px; }
    .btn-open, .btn-edit, .btn-delete { 
      flex: none; 
      width: 100%; 
      padding: 10px; 
      font-size: 0.82rem; 
    }

    .empty-state { padding: 40px 16px; border-radius: 12px; }
  }

  /* Very small phones */
  @media (max-width: 380px) {
    .main { padding: 8px 4px 20px; }
    .pg-header { padding: 12px; }
    .pg-header h4 { font-size: 0.85rem; }
    .pg-header p { font-size: 0.7rem; }
    .btn-upload { padding: 8px 12px; font-size: 0.78rem; }
    .filter-select { padding: 8px 10px; font-size: 0.8rem; }
    .btn-filter { padding: 8px 14px; font-size: 0.8rem; }
    .video-info { padding: 10px; }
    .video-title { font-size: 0.88rem; }
  }
</style>
</head>
<body>

<div class="topbar">
  <div style="display:flex;align-items:center;">
    <button class="mobile-toggle" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <span class="brand">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  </div>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-video me-2"></i>Video Library Management</h4>
          <p>Upload, manage, and categorize educational self-defense videos</p>
        </div>
        <a href="${pageContext.request.contextPath}/video/uploadVideo" class="btn-upload">
            <i class="fas fa-upload"></i> Upload Video
        </a>
      </div>

      <c:if test="${not empty message}">
          <div class="alert alert-info mb-4" style="border-radius:10px;"><i class="fas fa-info-circle me-1"></i> ${message}</div>
      </c:if>

      <!-- Filter Bar -->
      <div class="filter-bar">
          <label for="category"><i class="fas fa-filter me-1"></i> Filter:</label>
          <form action="${pageContext.request.contextPath}/video/videoManagement" method="get" class="filter-form">
              <select name="category" id="category" class="filter-select">
                  <option value="">All Categories</option>
                  <c:forEach var="cat" items="${categories}">
                      <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                  </c:forEach>
              </select>
              <button type="submit" class="btn-filter">Apply</button>
          </form>
      </div>


      <!-- Video Grid -->
      <c:choose>
          <c:when test="${not empty videos}">
              <div class="video-grid">
                  <c:forEach var="video" items="${videos}">
                      <div class="video-card">
                          <video class="video-player" controls preload="metadata">
                              <source src="${pageContext.request.contextPath}${video.filePath}" type="video/mp4">
                              Your browser does not support the video tag.
                          </video>
                          <div class="video-info">
                              <div class="video-title">${video.title}</div>
                              <div class="video-meta">
                                  <i class="fas fa-folder text-muted"></i>
                                  <span class="badge-category">${video.category}</span>
                                  <c:if test="${video.reel}">
                                      <span class="badge-category bg-info text-white ms-2">REEL</span>
                                  </c:if>
                              </div>
                              <div class="video-meta">
                                  <i class="fas fa-user-circle text-muted"></i>
                                  Uploaded By: ${video.uploadedBy.name}
                              </div>
                              
                              <div class="video-actions mt-auto">
                                  <a href="${pageContext.request.contextPath}${video.filePath}" target="_blank" class="btn-open">
                                      <i class="fas fa-external-link-alt me-1"></i> Open
                                  </a>
                                  <a href="${pageContext.request.contextPath}/video/edit/${video.id}" class="btn-edit">
                                      <i class="fas fa-edit me-1"></i> Edit
                                  </a>
                                  <a href="${pageContext.request.contextPath}/video/delete/${video.id}" class="btn-delete" onclick="return confirm('Are you sure you want to delete this video? This action cannot be undone.')">
                                      <i class="fas fa-trash-alt me-1"></i> Delete
                                  </a>
                              </div>
                          </div>
                      </div>
                  </c:forEach>
              </div>
          </c:when>
          <c:otherwise>
              <div class="empty-state">
                  <i class="fas fa-film fa-3x mb-3 text-muted" style="opacity:0.3;"></i>
                  <h5 class="text-muted">No videos found</h5>
                  <p class="text-muted small">Try adjusting your filters or upload a new video to the library.</p>
              </div>
          </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>

<script>
(function() {
    var toggle = document.getElementById('sidebarToggle');
    var sidebar = document.querySelector('.sidebar');
    var overlay = document.getElementById('sidebarOverlay');

    function openSidebar() {
        sidebar.classList.add('active');
        overlay.classList.add('active');
    }
    function closeSidebar() {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
    }

    if (toggle) toggle.addEventListener('click', openSidebar);
    if (overlay) overlay.addEventListener('click', closeSidebar);

    // Close sidebar when a nav link is clicked on mobile
    document.querySelectorAll('.sidebar a.navlink').forEach(function(link) {
        link.addEventListener('click', closeSidebar);
    });
})();
</script>

</body>
</html>

