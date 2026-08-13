<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>User Reels Management — Admin</title>
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
    transition: all 0.3s ease;
  }
  .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
  }
  .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
  .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
  .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
  .navlink.active i { color: #fff; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:1200px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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

  /* ── REELS GRID ── */
  .reels-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 20px;
  }

  .reel-card {
      background: #fff;
      border-radius: 16px;
      overflow: hidden;
      border: 1px solid var(--maroon-border);
      box-shadow: var(--shadow-sm);
      display: flex;
      flex-direction: column;
      transition: transform 0.2s, box-shadow 0.2s;
  }
  .reel-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 30px rgba(125,42,90,0.15);
  }

  .reel-video-container {
      width: 100%;
      height: 200px;
      background: #000;
      position: relative;
  }
  .reel-video {
      width: 100%;
      height: 100%;
      object-fit: contain;
  }

  .reel-info {
      padding: 15px;
      flex: 1;
      display: flex;
      flex-direction: column;
  }
  
  .reel-uploader {
      font-weight: 700;
      color: var(--maroon-dark);
      font-size: 0.95rem;
      margin-bottom: 5px;
      display: flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
  }
  .reel-uploader:hover { text-decoration: underline; color: var(--maroon); }
  
  .reel-stats {
      display: flex;
      gap: 15px;
      margin-bottom: 15px;
      font-size: 0.85rem;
      color: #6b7280;
  }
  .reel-stats span { display: flex; align-items: center; gap: 4px; }
  .reel-stats i.fa-eye { color: #3b82f6; }
  .reel-stats i.fa-heart { color: #ef4444; }

  .reel-actions {
      margin-top: auto;
      display: flex;
      gap: 10px;
  }
  .btn-view {
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
  .btn-view:hover { background: var(--maroon); color: #fff; }

  .btn-delete {
      flex: 1;
      background: #fff;
      color: #dc2626;
      border: 1px solid #fca5a5;
      padding: 8px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      text-align: center;
      text-decoration: none;
      transition: all 0.2s;
  }
  .btn-delete:hover { background: #dc2626; color: #fff; border-color: #dc2626; }

  .empty-state {
      grid-column: 1 / -1;
      text-align: center;
      padding: 60px 20px;
      background: #fff;
      border-radius: 16px;
      border: 1px dashed var(--maroon-border);
      color: #6b7280;
  }
  .empty-state i {
      font-size: 3rem;
      color: var(--maroon-pale);
      margin-bottom: 15px;
  }

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
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-mobile-alt me-2"></i>User Reels Management</h4>
          <p>Review all user-uploaded short videos and remove inappropriate content.</p>
        </div>
      </div>

      <c:if test="${not empty successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="fas fa-check-circle me-1"></i> ${successMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
      </c:if>
      
      <c:if test="${not empty error}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-circle me-1"></i> ${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
      </c:if>

      <!-- Reels Grid -->
      <div class="reels-grid">
          <c:choose>
              <c:when test="${not empty reels}">
                  <c:forEach var="reel" items="${reels}">
                      <div class="reel-card">
                          <div class="reel-video-container">
                              <video class="reel-video" controls preload="metadata">
                                  <source src="${pageContext.request.contextPath}${reel.videoPath}" type="video/mp4">
                              </video>
                          </div>
                          <div class="reel-info">
                              <c:choose>
                                  <c:when test="${not empty reel.user}">
                                      <a href="${pageContext.request.contextPath}/users/profile1/${reel.user.id}" class="reel-uploader">
                                          <i class="fas fa-user-circle"></i> ${reel.user.fullName}
                                      </a>
                                  </c:when>
                                  <c:otherwise>
                                      <span class="reel-uploader text-muted">
                                          <i class="fas fa-user-circle"></i> Unknown User
                                      </span>
                                  </c:otherwise>
                              </c:choose>
                              
                              <div class="reel-stats">
                                  <span><i class="fas fa-eye"></i> ${reel.viewCount}</span>
                                  <span><i class="fas fa-heart"></i> ${reel.likeCount}</span>
                              </div>
                              
                              <div class="reel-actions">
                                  <a href="${pageContext.request.contextPath}${reel.videoPath}" target="_blank" class="btn-view">
                                      <i class="fas fa-external-link-alt"></i> Open
                                  </a>
                                  <form action="${pageContext.request.contextPath}/admin/user-reels/delete/${reel.id}" method="post" style="flex:1; margin:0;" onsubmit="return confirm('Are you sure you want to permanently delete this reel?');">
                                      <button type="submit" class="btn-delete w-100">
                                          <i class="fas fa-trash-alt"></i> Delete
                                      </button>
                                  </form>
                              </div>
                          </div>
                      </div>
                  </c:forEach>
              </c:when>
              <c:otherwise>
                  <div class="empty-state">
                      <i class="fas fa-video-slash"></i>
                      <h5>No Reels Found</h5>
                      <p>Users have not uploaded any videos yet.</p>
                  </div>
              </c:otherwise>
          </c:choose>
      </div>

    </div>
  </main>
</div>

</body>
</html>

