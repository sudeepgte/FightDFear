<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Reported Videos — Admin</title>
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

  /* ── TABLE CARD ── */
  .card-table {
    background:#fff; border-radius:16px; overflow:hidden;
    border:1px solid var(--maroon-border); box-shadow:var(--shadow-sm);
  }
  .table { margin-bottom:0; }
  .table thead th {
    background: var(--maroon); color:#fff;
    font-size:0.75rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:16px; border:none; text-align:center;
  }
  .table tbody td {
    padding:16px; vertical-align:middle; border-bottom:1px solid var(--maroon-border);
    font-size:0.9rem; text-align:center;
  }
  .table tbody tr:hover { background:rgba(125,42,90,0.02); }
  
  .desc-cell { text-align:left !important; max-width:280px; font-size:0.85rem; color:#4b5563; line-height:1.5; }

  /* ── BADGES ── */
  .badge-status {
    padding:6px 12px; border-radius:999px; font-size:0.75rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-PENDING      { background:#fff7ed; color:#9a3412; border-color:#ffedd5; }
  .status-REVIEWED     { background:#eff6ff; color:#1e40af; border-color:#dbeafe; }
  .status-ACTION_TAKEN { background:#f0fdf4; color:#166534; border-color:#dcfce7; }
  
  .text-maroon { color: var(--maroon) !important; }

  /* ── ACTION BUTTONS ── */
  .btn-update {
    background:var(--maroon); color:#fff; border:none;
    padding:6px 14px; border-radius:8px; font-size:0.82rem; font-weight:700;
    transition:all 0.2s;
  }
  .btn-update:hover { background:var(--maroon-light); transform:translateY(-1px); }

  .btn-view-media {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    background: var(--maroon-pale); 
    color: var(--maroon); 
    border: 1px solid var(--maroon-border);
    padding: 6px 14px; 
    border-radius: 8px; 
    font-size: 0.82rem; 
    font-weight: 700;
    text-decoration: none; 
    transition: all 0.2s ease;
    white-space: nowrap;
  }
  .btn-view-media:hover { 
    background: var(--maroon); 
    color: #fff; 
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(125,42,90,0.15);
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
          <h4><i class="fas fa-video-slash me-2"></i>Reported Videos</h4>
          <p>Review community flags and manage inappropriate video content</p>
        </div>
      </div>

      <!-- Table -->
      <div class="card-table">
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Video</th>
                <th>Uploaded By (Email)</th>
                <th>Reported By</th>
                <th>Reason</th>
                <th>Date</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty reports}">
                  <c:forEach var="r" items="${reports}">
                    <tr>
                      <td class="fw-bold">
                        <a href="${pageContext.request.contextPath}${r.video.videoPath}" target="_blank" class="text-maroon text-decoration-none">
                          <i class="fas fa-file-video me-1 text-muted"></i>
                          ${r.video.description != null ? r.video.description : 'View Video'}
                        </a>
                      </td>
                      <td><span class="fw-600">${r.video.user.email}</span></td>
                      <td>${r.reportedBy.fullName}</td>
                      <td>
                        <c:choose>
                            <c:when test="${r.reason == 'NOT_GOOD_CONTENT'}">
                                <span class="badge-status status-REVIEWED">Not Good Content</span>
                            </c:when>
                            <c:when test="${r.reason == 'SPAM_OR_MISLEADING'}">
                                <span class="badge-status status-PENDING">Spam/Misleading</span>
                            </c:when>
                            <c:when test="${r.reason == 'HARASSMENT_OR_HATE'}">
                                <span class="badge-status" style="background:#fef2f2; color:#b91c1c; border-color:#fecaca;">Harassment/Hate</span>
                            </c:when>
                            <c:when test="${r.reason == 'SEXUAL_OR_VIOLENCE'}">
                                <span class="badge-status" style="background:#f1f5f9; color:#0f172a; border-color:#e2e8f0;">Sexual/Violence</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-status status-PENDING">${r.reason}</span>
                            </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-muted small">${r.reportedAt}</td>
                      <td>
                        <div class="d-flex justify-content-center gap-2">
                          <a href="${pageContext.request.contextPath}${r.video.videoPath}" target="_blank" class="btn-view-media">
                            <i class="fas fa-play me-1"></i> View
                          </a>
                          <c:choose>
                              <c:when test="${r.video.blocked}">
                                  <span class="badge bg-secondary d-flex align-items-center px-3" style="border-radius:8px;">Blocked</span>
                              </c:when>
                              <c:otherwise>
                                  <form action="${pageContext.request.contextPath}/admin/reported-videos/block/${r.video.id}" method="post" class="m-0">
                                      <button type="submit" class="btn-update bg-danger" onclick="return confirm('Are you sure you want to block this video? It will be removed from user dashboards.')">
                                        <i class="fas fa-ban me-1"></i> Block
                                      </button>
                                  </form>
                              </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6">
                      <div class="py-5 text-center text-muted">
                        <i class="fas fa-check-circle fa-3x mb-3 d-block text-success" style="opacity:0.6;"></i>
                        <p class="mb-0">No reported videos found. Everything is clear!</p>
                      </div>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>

