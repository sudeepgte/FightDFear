<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Marketplace Provider Verification — Admin</title>
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

  /* ── BADGES & BUTTONS ── */
  .badge-status {
    padding:6px 12px; border-radius:999px; font-size:0.75rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-VERIFIED { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-PENDING { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-REJECTED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
  
  .btn-approve {
    background-color: #059669;
    color: white;
    padding: 6px 14px;
    border: none;
    border-radius: 8px;
    font-size: 0.82rem;
    font-weight: 700;
    transition: all 0.2s;
  }
  .btn-approve:hover { background-color: #047857; transform: translateY(-1px); color: white; }

  .btn-reject {
    background-color: #dc2626;
    color: white;
    padding: 6px 14px;
    border: none;
    border-radius: 8px;
    font-size: 0.82rem;
    font-weight: 700;
    transition: all 0.2s;
  }
  .btn-reject:hover { background-color: #b91c1c; transform: translateY(-1px); color: white; }

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
    <a class="nl active" href="${pageContext.request.contextPath}/admin/pending-providers"><i class="fas fa-store"></i> Provider Verification</a>
    <a class="nl" href="${pageContext.request.contextPath}/video/videoManagement"><i class="fas fa-video"></i> Video Library</a>

    <div class="sec-title">Account</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-user-cog"></i> User Management</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/profile/${admin.id}"><i class="fas fa-user"></i> Profile</a>
  </aside>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4>
            <i class="fas fa-store me-2"></i>
            <c:choose>
                <c:when test="${selectedCategory == 'WOMEN_PRODUCTS'}">Women Products Verification</c:when>
                <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Women Lawyer Verification</c:when>
                <c:when test="${selectedCategory == 'FITNESS_ZUMBA'}">Fitness & Zumba Verification</c:when>
                <c:otherwise>Marketplace Provider Verification</c:otherwise>
            </c:choose>
          </h4>
          <p>Review and verify marketplace providers</p>
        </div>
      </div>

      <c:if test="${not empty message}">
          <div class="alert alert-info mb-4" style="border-radius:10px;"><i class="fas fa-info-circle me-1"></i> ${message}</div>
      </c:if>

      <!-- Pending Providers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-clock text-warning"></i> Pending Providers
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Phone</th>
                      <th>Category</th>
                      <th>Location</th>
                      <th>Identity Doc</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty pending}">
                      <c:forEach var="p" items="${pending}">
                          <tr>
                              <td class="fw-bold">${p.fullName}</td>
                              <td>${p.email}</td>
                              <td>${p.phone}</td>
                              <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                              <td>${p.locationText}</td>
                              <td>
                                  <c:choose>
                                      <c:when test="${not empty p.identityDocumentPath}">
                                          <a href="${pageContext.request.contextPath}${p.identityDocumentPath}" target="_blank" class="btn-view-media">
                                            <i class="fas fa-id-card me-1"></i> View ID
                                          </a>
                                      </c:when>
                                      <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                  </c:choose>
                              </td>
                              <td><span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> ${p.verificationStatus}</span></td>
                              <td>
                                  <div class="d-flex justify-content-center align-items-center gap-1">
                                    <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0 p-0">
                                        <button class="btn-approve" type="submit" title="Verify"><i class="fas fa-check"></i></button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/reject" method="post" class="m-0 p-0">
                                        <button class="btn-reject" type="submit" title="Reject"><i class="fas fa-times"></i></button>
                                    </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="8" class="py-4 text-center text-muted"><i class="fas fa-check-circle fa-2x mb-2 d-block text-success" style="opacity:0.4;"></i>No pending providers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Verified Providers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-success"></i> Verified Providers
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Category</th>
                      <th>Status</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty verified}">
                      <c:forEach var="p" items="${verified}">
                          <tr>
                              <td class="fw-bold">${p.fullName}</td>
                              <td>${p.email}</td>
                              <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                              <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="4" class="py-4 text-center text-muted">No verified providers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Rejected Providers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store-alt-slash text-danger"></i> Rejected Providers
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Category</th>
                      <th>Status</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty rejected}">
                      <c:forEach var="p" items="${rejected}">
                          <tr>
                              <td class="fw-bold">${p.fullName}</td>
                              <td>${p.email}</td>
                              <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                              <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="4" class="py-4 text-center text-muted">No rejected providers.</td>
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

