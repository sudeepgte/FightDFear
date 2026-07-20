<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Video Performance & Rewards — Admin</title>
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

  /* ── TABLE CARDS ── */
  .card-table {
    background:#fff; border-radius:16px; overflow:hidden;
    border:1px solid var(--maroon-border); box-shadow:var(--shadow-sm);
    margin-bottom: 28px;
  }
  .card-table-header {
    background: var(--maroon-pale);
    padding: 16px 20px;
    border-bottom: 1px solid var(--maroon-border);
    font-weight: 700;
    color: var(--maroon-dark);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .table { margin-bottom:0; }
  .table thead th {
    background: rgba(125,42,90,0.03); color:var(--maroon-dark);
    font-size:0.75rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:16px; border:none; border-bottom:1px solid var(--maroon-border); text-align:center;
  }
  .table tbody td {
    padding:16px; vertical-align:middle; border-bottom:1px solid var(--maroon-border);
    font-size:0.9rem; text-align:center;
  }
  .table tbody tr:last-child td { border-bottom: none; }
  .table tbody tr:hover { background:rgba(125,42,90,0.02); }

  .video-preview {
      width: 140px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
      background: #000;
  }

  .uploader-link {
      color: var(--maroon);
      font-weight: 600;
      text-decoration: none;
      transition: color 0.2s;
  }
  .uploader-link:hover { color: var(--maroon-light); text-decoration: underline; }

  .stat-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 0.85rem;
      font-weight: 600;
      background: var(--maroon-pale);
      color: var(--maroon-dark);
      border: 1px solid var(--maroon-border);
  }

  .score-val {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--maroon);
  }

  /* ── REWARD BUTTON ── */
  .reward-btn {
      background: linear-gradient(135deg, #059669, #10b981);
      border: none;
      color: #fff;
      font-weight: 600;
      border-radius: 20px;
      padding: 8px 18px;
      font-size: 0.85rem;
      transition: all 0.2s;
      box-shadow: 0 4px 10px rgba(16,185,129,0.3);
  }
  .reward-btn:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(16,185,129,0.4);
  }
  .reward-btn:disabled {
      background: #e5e7eb;
      color: #9ca3af;
      cursor: not-allowed;
      box-shadow: none;
      border: 1px solid #d1d5db;
  }

  .not-eligible {
      font-size: 0.75rem;
      color: #dc2626;
      display: block;
      margin-top: 6px;
      font-weight: 500;
  }

  .btn-open {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
      background: #fff;
      color: var(--maroon);
      border: 1px solid var(--maroon-border);
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 0.75rem;
      font-weight: 600;
      text-decoration: none;
      margin-top: 6px;
      transition: all 0.2s;
  }
  .btn-open:hover {
      background: var(--maroon);
      color: #fff;
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
    <a class="nl" href="${pageContext.request.contextPath}/video/videoManagement"><i class="fas fa-video"></i> Video Library</a>
    <!-- Adding the active link for video rewards as it falls under moderation/approvals visually -->
    <a class="nl active" href="${pageContext.request.contextPath}/admin/videos"><i class="fas fa-gift"></i> Video Rewards</a>

    <div class="sec-title">Account</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-user-cog"></i> User Management</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/profile/${admin.id}"><i class="fas fa-user"></i> Profile</a>
  </aside>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-gift me-2"></i>Video Performance & Rewards</h4>
          <p>Review user-uploaded videos, track engagement scores, and distribute rewards</p>
        </div>
      </div>

      <!-- Video Rewards Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-chart-line text-success"></i> Performance Metrics
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Rank</th>
                      <th>Video</th>
                      <th>Uploader</th>
                      <th>Engagement</th>
                      <th>Score</th>
                      <th>Reward Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty videos}">
                      <c:forEach var="video" items="${videos}" varStatus="loop">
                          <tr>
                              <td class="fw-bold text-muted">#${loop.index + 1}</td>
                              <td>
                                  <div class="d-flex flex-column align-items-center">
                                      <video class="video-preview" controls preload="metadata">
                                          <source src="${pageContext.request.contextPath}${video.videoPath}" type="video/mp4">
                                      </video>
                                      <!-- Fallback open link for missing videos -->
                                      <a href="${pageContext.request.contextPath}${video.videoPath}" target="_blank" class="btn-open">
                                          <i class="fas fa-external-link-alt"></i> Open Video
                                      </a>
                                  </div>
                              </td>
                              <td>
                                  <c:choose>
                                      <c:when test="${not empty video.user}">
                                          <a href="${pageContext.request.contextPath}/users/profile1/${video.user.id}" class="uploader-link">
                                              <i class="fas fa-user-circle me-1"></i>${video.user.fullName}
                                          </a>
                                      </c:when>
                                      <c:otherwise>
                                          <span class="text-muted fst-italic">Unknown</span>
                                      </c:otherwise>
                                  </c:choose>
                              </td>
                              <td>
                                  <div class="d-flex flex-column gap-2 align-items-center">
                                      <span class="stat-badge"><i class="fas fa-eye text-primary"></i> ${video.viewCount} views</span>
                                      <span class="stat-badge"><i class="fas fa-heart text-danger"></i> ${video.likeCount} likes</span>
                                      <span class="stat-badge"><i class="fas fa-comment text-secondary"></i> ${video.comments.size()} cmts</span>
                                  </div>
                              </td>
                              <td>
                                  <span class="score-val">${video.score}</span>
                              </td>
                              <td>
                                  <form action="${pageContext.request.contextPath}/admin/videos/reward/${video.id}" method="post" class="m-0 p-0">
                                      <button class="reward-btn" ${video.eligibleForReward ? '' : 'disabled'}>
                                          <i class="fas fa-gift me-1"></i> Give Reward
                                      </button>
                                  </form>
                                  <c:if test="${!video.eligibleForReward}">
                                      <span class="not-eligible"><i class="fas fa-clock me-1"></i> Available after 1 month</span>
                                  </c:if>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="6" class="py-5 text-center text-muted">
                              <i class="fas fa-video-slash fa-3x mb-3" style="opacity:0.3;"></i>
                              <h5>No videos found</h5>
                              <p class="small">Wait for users to upload videos to the platform.</p>
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

