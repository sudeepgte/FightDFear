<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Product Sellers Verification — Admin</title>
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
  .badge-count {
      background: var(--maroon-light);
      color: #fff;
      border-radius: 20px;
      padding: 2px 10px;
      font-size: 0.75rem;
      font-weight: 700;
      margin-left: auto;
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

  .seller-meta {
      font-size: 0.8rem;
      color: #6b7280;
      margin-top: 4px;
      display: flex;
      flex-direction: column;
      gap: 2px;
      align-items: center;
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
          <h4><i class="fas fa-shopping-bag me-2"></i>Women Product Sellers</h4>
          <p>Review and verify sellers offering safety and women's products</p>
        </div>
      </div>

      <c:if test="${not empty message}">
          <div class="alert alert-success mb-4" style="border-radius:10px;"><i class="fas fa-check-circle me-1"></i> ${message}</div>
      </c:if>

      <!-- Pending Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-clock text-warning"></i> Pending Sellers
          <span class="badge-count">${not empty pending ? pending.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Contact Info</th>
                      <th>Business Address</th>
                      <th>Identity Doc</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty pending}">
                      <c:forEach var="s" items="${pending}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-envelope text-muted me-1"></i> ${s.email}</span>
                                      <span><i class="fas fa-phone text-muted me-1"></i> ${s.phone}</span>
                                  </div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-map-marker-alt text-muted me-1"></i> ${s.address}</span>
                                  </div>
                              </td>
                              <td>
                                  <c:choose>
                                      <c:when test="${not empty s.identityDocPath}">
                                          <a href="${pageContext.request.contextPath}${s.identityDocPath}" target="_blank" class="btn-view-media">
                                            <i class="fas fa-id-card me-1"></i> View ID
                                          </a>
                                      </c:when>
                                      <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                  </c:choose>
                              </td>
                              <td><span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> PENDING</span></td>
                              <td>
                                  <div class="d-flex justify-content-center align-items-center gap-1">
                                    <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-2" title="View Profile">
                                        <i class="fas fa-user"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/verify" method="post" class="m-0 p-0">
                                        <button class="btn-approve" type="submit" title="Verify"><i class="fas fa-check"></i></button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/reject" method="post" class="m-0 p-0">
                                        <button class="btn-reject" type="submit" title="Reject"><i class="fas fa-times"></i></button>
                                    </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="6" class="py-4 text-center text-muted"><i class="fas fa-check-circle fa-2x mb-2 d-block text-success" style="opacity:0.4;"></i>No pending sellers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace women's product partners (alternate registration path) -->
      <c:if test="${not empty pendingMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-warning"></i> Pending — Marketplace Women's Products
          <span class="badge-count">${pendingMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${pendingMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td>${p.locationText}</td>
                  <td><span class="badge-status status-PENDING">PENDING</span></td>
                  <td>
                    <div class="d-flex justify-content-center gap-1">
                      <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-2" title="View"><i class="fas fa-user"></i></a>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0"><button class="btn-approve" type="submit"><i class="fas fa-check"></i></button></form>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/reject" method="post" class="m-0"><button class="btn-reject" type="submit"><i class="fas fa-times"></i></button></form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

      <!-- Verified Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-success"></i> Verified Sellers
          <span class="badge-count" style="background:#166534;">${not empty verified ? verified.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Contact Info</th>
                      <th>Business Address</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty verified}">
                      <c:forEach var="s" items="${verified}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-envelope text-muted me-1"></i> ${s.email}</span>
                                      <span><i class="fas fa-phone text-muted me-1"></i> ${s.phone}</span>
                                  </div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-map-marker-alt text-muted me-1"></i> ${s.address}</span>
                                  </div>
                              </td>
                              <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                              <td>
                                  <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-3" title="View Profile">
                                      <i class="fas fa-user me-1"></i> View Profile
                                  </a>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="5" class="py-4 text-center text-muted">No verified sellers yet.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace verified women's product partners -->
      <c:if test="${not empty verifiedMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-success"></i> Verified — Marketplace Women's Products
          <span class="badge-count" style="background:#166534;">${verifiedMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${verifiedMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td>${p.locationText}</td>
                  <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                  <td>
                    <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-3" title="View"><i class="fas fa-user me-1"></i> View Profile</a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

      <!-- Rejected Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store-alt-slash text-danger"></i> Rejected Sellers
          <span class="badge-count" style="background:#991b1b;">${not empty rejected ? rejected.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Email</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty rejected}">
                      <c:forEach var="s" items="${rejected}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>${s.email}</td>
                              <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                              <td>
                                  <div class="d-flex gap-1">
                                      <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-2" title="View Profile">
                                          <i class="fas fa-user"></i>
                                      </a>
                                      <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/verify" method="post" class="m-0 p-0">
                                          <button class="btn-approve px-3" type="submit" title="Re-verify"><i class="fas fa-undo me-1"></i> Re-verify</button>
                                      </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="4" class="py-4 text-center text-muted">No rejected sellers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace rejected women's product partners -->
      <c:if test="${not empty rejectedMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store-alt-slash text-danger"></i> Rejected — Marketplace Women's Products
          <span class="badge-count" style="background:#991b1b;">${rejectedMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${rejectedMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                  <td>
                    <div class="d-flex gap-1">
                      <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-2" title="View"><i class="fas fa-user"></i></a>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0"><button class="btn-approve px-3" type="submit"><i class="fas fa-undo me-1"></i> Re-verify</button></form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

    </div>
  </main>
</div>

</body>
</html>

