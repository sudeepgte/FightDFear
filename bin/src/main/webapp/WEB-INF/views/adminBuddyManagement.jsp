<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Buddy Oversight — Admin</title>
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

  /* ── STATS CARDS ── */
  .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 25px; }
  .stat-card { background: #fff; padding: 20px; border-radius: 12px; border: 1px solid var(--maroon-border); box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 15px; }
  .stat-icon { width: 45px; height: 45px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
  .stat-val { font-size: 1.4rem; font-weight: 700; color: var(--maroon-dark); }
  .stat-lbl { font-size: 0.75rem; color: #6b7280; text-transform: uppercase; font-weight: 600; }

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

  /* ── BADGES ── */
  .badge-status {
    padding:5px 12px; border-radius:20px; font-size:0.75rem; font-weight:700;
    display:inline-block;
  }
  .status-ACTIVE { background:#f0fdf4; color:#166534; }
  .status-ACCEPTED { background:#eff6ff; color:#1e40af; }
  .status-PENDING { background:#fffbeb; color:#92400e; }
  
  .user-info { display: flex; align-items: center; gap: 10px; text-align: left; }
  .user-avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; background: #eee; }

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
          <h4><i class="fas fa-user-friends me-2"></i>Buddy Oversight</h4>
          <p>Monitor active travel buddies and travel requests to ensure user safety.</p>
        </div>
      </div>

      <!-- Stats -->
      <div class="stats-grid">
          <div class="stat-card">
              <div class="stat-icon bg-success-subtle text-success"><i class="fas fa-toggle-on"></i></div>
              <div>
                  <div class="stat-lbl">Available Buddies</div>
                  <div class="stat-val">${availabilities.size()}</div>
              </div>
          </div>
          <div class="stat-card">
              <div class="stat-icon bg-primary-subtle text-primary"><i class="fas fa-link"></i></div>
              <div>
                  <div class="stat-lbl">Active/Pending Matches</div>
                  <div class="stat-val">${requests.size()}</div>
              </div>
          </div>
      </div>

      <!-- Table: Active Requests/Matches -->
      <div class="card-table">
          <div class="card-table-header">
              <i class="fas fa-handshake text-primary"></i> Active Matches & Requests
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>Requester</th>
                          <th>Target Buddy</th>
                          <th>Destination</th>
                          <th>Status</th>
                          <th>Created At</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${requests}" var="r">
                          <tr>
                              <td>
                                  <div class="user-info">
                                      <img src="${pageContext.request.contextPath}${r.fromUser.profilePhoto}" class="user-avatar" onerror="this.src='https://ui-avatars.com/api/?name=${r.fromUser.fullName}&background=random'">
                                      <div>
                                          <div class="fw-bold">${r.fromUser.fullName}</div>
                                          <div class="text-muted small">${r.fromUser.email}</div>
                                      </div>
                                  </div>
                              </td>
                              <td>
                                  <div class="user-info">
                                      <img src="${pageContext.request.contextPath}${r.toUser.profilePhoto}" class="user-avatar" onerror="this.src='https://ui-avatars.com/api/?name=${r.toUser.fullName}&background=random'">
                                      <div>
                                          <div class="fw-bold">${r.toUser.fullName}</div>
                                          <div class="text-muted small">${r.toUser.email}</div>
                                      </div>
                                  </div>
                              </td>
                              <td>
                                  <span class="badge bg-light text-dark">
                                      <i class="fas fa-map-marker-alt text-danger me-1"></i> ${r.availability.destinationText}
                                  </span>
                              </td>
                              <td>
                                  <span class="badge-status status-${r.status}">${r.status}</span>
                              </td>
                              <td>
                                  <fmt:formatDate value="${r.createdAt}" pattern="dd MMM, HH:mm" />
                              </td>
                              <td>
                                  <button class="btn btn-sm btn-outline-danger" title="Flag for review">
                                      <i class="fas fa-flag"></i>
                                  </button>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty requests}">
                          <tr><td colspan="6" class="py-4 text-muted">No active buddy matches found.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

      <!-- Table: Available Buddies -->
      <div class="card-table">
          <div class="card-table-header">
              <i class="fas fa-user-check text-success"></i> Currently Available Buddies
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>User</th>
                          <th>Route Summary</th>
                          <th>Status</th>
                          <th>Expires At</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${availabilities}" var="a">
                          <tr>
                              <td>
                                  <div class="user-info">
                                      <img src="${pageContext.request.contextPath}${a.user.profilePhoto}" class="user-avatar" onerror="this.src='https://ui-avatars.com/api/?name=${a.user.fullName}&background=random'">
                                      <div>
                                          <div class="fw-bold">${a.user.fullName}</div>
                                          <div class="text-muted small">ID: #${a.user.id}</div>
                                      </div>
                                  </div>
                              </td>
                              <td>
                                  <div class="text-start ms-4">
                                      <div class="small text-muted"><i class="fas fa-circle-dot me-1 text-primary"></i> Current Area</div>
                                      <div class="fw-bold mb-1"><i class="fas fa-arrow-right me-1"></i> Heading to: ${a.destinationText}</div>
                                  </div>
                              </td>
                              <td>
                                  <span class="badge-status status-ACTIVE">AVAILABLE</span>
                              </td>
                              <td>
                                  <fmt:formatDate value="${a.expiresAt}" pattern="HH:mm" />
                              </td>
                              <td>
                                  <a href="${pageContext.request.contextPath}/admin/users/${a.user.id}/profile" class="btn btn-sm btn-outline-primary">
                                      <i class="fas fa-id-card"></i> Vetting
                                  </a>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty availabilities}">
                          <tr><td colspan="5" class="py-4 text-muted">No users are currently looking for buddies.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>

