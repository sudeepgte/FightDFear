<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Safety Points & Routes — Admin</title>
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
  .table thead th {
    background: rgba(125,42,90,0.03); color:var(--maroon-dark);
    font-size:0.75rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:16px; border:none; border-bottom:1px solid var(--maroon-border); text-align:center;
  }
  .table tbody td {
    padding:16px; vertical-align:middle; border-bottom:1px solid var(--maroon-border);
    font-size:0.9rem; text-align:center;
  }

  /* ── BUTTONS ── */
  .btn-approve { background-color: #059669; color: #fff; border-radius: 8px; font-weight: 600; padding: 6px 14px; font-size: 0.85rem; }
  .btn-approve:hover { background-color: #047857; color: #fff; }
  .btn-delete { background-color: #ef4444; color: #fff; border-radius: 8px; font-weight: 600; padding: 6px 14px; font-size: 0.85rem; }
  .btn-delete:hover { background-color: #dc2626; color: #fff; }

  .severity-badge { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #fff; margin: 0 auto; }
  .sev-1 { background: #10b981; }
  .sev-2 { background: #f59e0b; }
  .sev-3 { background: #f97316; }
  .sev-4 { background: #ef4444; }
  .sev-5 { background: #991b1b; }

  .flash-msg { padding: 12px 18px; border-radius: 10px; margin-bottom: 20px; font-weight: 500; font-size: 0.9rem; }
  .flash-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }

  @media(max-width:992px){
    .layout{flex-direction:column; display: block;}
    .sidebar{display: none !important;}
    .main { padding: 20px 15px; }
    .topbar { padding: 0 15px; }
  }
</style>
</head>
<body>

<div class="topbar">
  <div class="d-flex align-items-center gap-2">
    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="text-white d-lg-none me-2" title="Back to Dashboard">
        <i class="fas fa-arrow-left"></i>
    </a>
    <span class="brand">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  </div>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">
      
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-shield-alt me-2"></i>Safety Verification</h4>
          <p>Review user-reported danger points and safe routes before publishing them to the public map.</p>
        </div>
      </div>

      <c:if test="${not empty message}">
          <div class="flash-msg flash-success"><i class="fas fa-check-circle me-1"></i> ${message}</div>
      </c:if>

      <!-- ── SECTION: DANGER POINTS ── -->
      <div class="card-table">
          <div class="card-table-header text-danger">
              <i class="fas fa-exclamation-triangle"></i> Pending Danger Point Reports
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>User</th>
                          <th>Location</th>
                          <th>Category</th>
                          <th>Note</th>
                          <th>Evidence</th>
                          <th>Severity</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${pendingPoints}" var="p">
                          <tr>
                              <td>
                                  <div class="d-flex align-items-center gap-2 text-start ms-4">
                                      <img src="${pageContext.request.contextPath}${p.user.profilePhoto}" 
                                           class="rounded-circle" width="32" height="32" 
                                           onerror="this.src='https://ui-avatars.com/api/?name=${p.user.fullName}&background=random'">
                                      <div>
                                          <div class="fw-bold">
                                              <a href="${pageContext.request.contextPath}/admin/users/${p.user.id}/profile" class="text-decoration-none text-dark">
                                                  ${p.user.fullName}
                                                  <c:if test="${p.user.verificationStatus == 'VERIFIED'}">
                                                      <i class="fas fa-check-circle text-primary small" title="Verified User"></i>
                                                  </c:if>
                                              </a>
                                          </div>
                                          <div class="small text-muted">${p.user.email}</div>
                                      </div>
                                  </div>
                              </td>
                              <td class="text-start">
                                  <div class="fw-bold text-maroon" id="loc-pending-${p.id}" data-lat="${p.latitude}" data-lng="${p.longitude}">${not empty p.locationName ? p.locationName : 'Unknown Area'}</div>
                                  <div class="small text-muted">${p.latitude}, ${p.longitude}</div>
                              </td>
                              <td><span class="badge bg-danger-subtle text-danger">${p.category}</span></td>
                              <td class="text-start small">${p.note}</td>
                              <td>
                                  <c:if test="${not empty p.imagePath}">
                                      <a href="${pageContext.request.contextPath}${p.imagePath}" target="_blank">
                                          <img src="${pageContext.request.contextPath}${p.imagePath}" class="rounded" width="60" height="40" style="object-fit: cover; border: 1px solid #ddd;">
                                      </a>
                                  </c:if>
                                  <c:if test="${empty p.imagePath}">
                                      <span class="text-muted small">No photo</span>
                                  </c:if>
                              </td>
                              <td><div class="severity-badge sev-${p.severity}">${p.severity}</div></td>
                              <td>
                                  <div class="d-flex gap-2 justify-content-center">
                                      <form action="${pageContext.request.contextPath}/admin/safety-points/danger/${p.id}/verify" method="post">
                                          <button type="submit" class="btn btn-approve">Approve</button>
                                      </form>
                                      <form action="${pageContext.request.contextPath}/admin/safety-points/danger/${p.id}/delete" method="post">
                                          <button type="submit" class="btn btn-delete">Reject</button>
                                      </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty pendingPoints}">
                          <tr><td colspan="7" class="py-4 text-muted">No pending danger point reports.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

      <!-- ── SECTION: SAFE ROUTES ── -->
      <div class="card-table">
          <div class="card-table-header text-success">
              <i class="fas fa-route"></i> Pending Safe Route Suggestions
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>Route</th>
                          <th>Description</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${pendingRoutes}" var="r">
                          <tr>
                              <td>
                                  <div class="fw-bold">${r.fromLocation}</div>
                                  <i class="fas fa-arrow-down small text-muted"></i>
                                  <div class="fw-bold">${r.toLocation}</div>
                              </td>
                              <td class="text-start">${r.description}</td>
                              <td>
                                  <div class="d-flex gap-2 justify-content-center">
                                      <form action="${pageContext.request.contextPath}/admin/safety-points/route/${r.id}/verify" method="post">
                                          <button type="submit" class="btn btn-approve">Verify</button>
                                      </form>
                                      <form action="${pageContext.request.contextPath}/admin/safety-points/route/${r.id}/delete" method="post">
                                          <button type="submit" class="btn btn-delete">Reject</button>
                                      </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty pendingRoutes}">
                          <tr><td colspan="3" class="py-4 text-muted">No pending safe route suggestions.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

      <hr class="my-5 opacity-25">

      <!-- ── SECTION: VERIFIED DANGER POINTS ── -->
      <div class="card-table">
          <div class="card-table-header bg-dark text-white">
              <i class="fas fa-check-double"></i> Verified Danger Points (Live on Map)
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>Reported By</th>
                          <th>Location</th>
                          <th>Category</th>
                          <th>Note</th>
                          <th>Evidence</th>
                          <th>Severity</th>
                          <th>Status</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${verifiedPoints}" var="p">
                          <tr>
                              <td>
                                  <div class="d-flex align-items-center gap-2 text-start ms-4">
                                      <img src="${pageContext.request.contextPath}${p.user.profilePhoto}" 
                                           class="rounded-circle" width="32" height="32" 
                                           onerror="this.src='https://ui-avatars.com/api/?name=${p.user.fullName}&background=random'">
                                      <div>
                                          <div class="fw-bold small">${p.user.fullName}</div>
                                          <div class="text-muted" style="font-size: 0.7rem;">ID: #U-0${p.user.id}</div>
                                      </div>
                                  </div>
                              </td>
                              <td class="text-start">
                                  <div class="fw-bold text-maroon" id="loc-verified-${p.id}" data-lat="${p.latitude}" data-lng="${p.longitude}">${not empty p.locationName ? p.locationName : 'Unknown Area'}</div>
                                  <div class="small text-muted">${p.latitude}, ${p.longitude}</div>
                              </td>
                              <td><span class="badge bg-danger">${p.category}</span></td>
                              <td class="text-start small">${p.note}</td>
                              <td>
                                  <c:if test="${not empty p.imagePath}">
                                      <a href="${pageContext.request.contextPath}${p.imagePath}" target="_blank">
                                          <img src="${pageContext.request.contextPath}${p.imagePath}" class="rounded" width="60" height="40" style="object-fit: cover; border: 1px solid #ddd;">
                                      </a>
                                  </c:if>
                                  <c:if test="${empty p.imagePath}">
                                      <span class="text-muted small">No photo</span>
                                  </c:if>
                              </td>
                              <td><div class="severity-badge sev-${p.severity}">${p.severity}</div></td>
                              <td><span class="badge bg-success"><i class="fas fa-globe"></i> LIVE</span></td>
                              <td>
                                  <form action="${pageContext.request.contextPath}/admin/safety-points/danger/${p.id}/delete" method="post" onsubmit="return confirm('Remove this point from the live map?');">
                                      <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i> Remove</button>
                                  </form>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty verifiedPoints}">
                          <tr><td colspan="5" class="py-4 text-muted">No verified danger points yet.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

      <!-- ── SECTION: VERIFIED SAFE ROUTES ── -->
      <div class="card-table">
          <div class="card-table-header bg-dark text-white">
              <i class="fas fa-check-double"></i> Verified Safe Routes (Live on Map)
          </div>
          <div class="table-responsive">
              <table class="table">
                  <thead>
                      <tr>
                          <th>Route</th>
                          <th>Description</th>
                          <th>Status</th>
                          <th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach items="${verifiedRoutes}" var="r">
                          <tr>
                              <td>
                                  <div class="fw-bold text-success">${r.fromLocation}</div>
                                  <i class="fas fa-arrow-down small text-muted"></i>
                                  <div class="fw-bold text-success">${r.toLocation}</div>
                              </td>
                              <td class="text-start">${r.description}</td>
                              <td><span class="badge bg-success"><i class="fas fa-check-circle"></i> ACTIVE</span></td>
                              <td>
                                  <form action="${pageContext.request.contextPath}/admin/safety-points/route/${r.id}/delete" method="post" onsubmit="return confirm('Remove this route?');">
                                      <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i> Remove</button>
                                  </form>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty verifiedRoutes}">
                          <tr><td colspan="4" class="py-4 text-muted">No verified safe routes yet.</td></tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
      </div>

    </div>
  </main>
</div>

<script>
  async function reverseGeocode(lat, lng, elementId) {
    try {
      const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&zoom=18&addressdetails=1`);
      const data = await response.json();
      if (data && data.display_name) {
        document.getElementById(elementId).textContent = data.display_name.split(',')[0] + ', ' + (data.address.suburb || data.address.city || '');
        document.getElementById(elementId).title = data.display_name;
      }
    } catch (error) {
      console.error('Geocoding failed:', error);
    }
  }

  // Auto-resolve unknown areas
  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-lat]').forEach(el => {
      if (el.textContent.trim() === 'Unknown Area') {
        reverseGeocode(el.dataset.lat, el.dataset.lng, el.id);
      }
    });
  });
</script>

</body>
</html>

