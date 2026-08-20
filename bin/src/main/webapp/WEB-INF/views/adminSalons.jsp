<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Salon Verification — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon: #1e1b4b;
    --maroon-light: #312e81;
    --maroon-dark: #1e1b4b;
    --maroon-pale: #fffcfd;
    --maroon-border: rgba(124, 45, 94, 0.12);
    --shadow-premium: 0 20px 40px rgba(124, 45, 94, 0.08);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; background:var(--maroon-pale); margin:0; color:#1a1a2e; }
  .topbar {
    background:var(--maroon); color:#fff; height:58px;
    display:flex; align-items:center; justify-content:space-between;
    padding:0 20px; position:sticky; top:0; z-index:1000;
    box-shadow:0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff;
    border:1px solid rgba(255,255,255,0.3); border-radius:7px;
    padding:5px 16px; font-size:0.85rem; font-weight:600;
    text-decoration:none; transition:background 0.2s;
  }
  .layout { display:flex; min-height:calc(100vh - 58px); }

  /* Standard admin sidebar (globalAdminMenu) */
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
    transition: all 0.3s ease;
  }
  .sidebar .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sidebar .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .sidebar .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
  }
  .sidebar .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
  .sidebar .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
  .sidebar .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
  .sidebar .navlink.active i { color: #fff; }

  .main { flex:1; min-width:0; padding:40px; }
  .card-table { background:#fff; border-radius:24px; overflow:hidden; border:1px solid var(--maroon-border); box-shadow:var(--shadow-premium); margin-bottom:40px; }
  .card-table-header { background: linear-gradient(90deg, #fdfbff 0%, #fff 100%); padding:20px 25px; border-bottom:1px solid var(--maroon-border); font-weight:700; color:var(--maroon-dark); font-size:1.1rem; }
  .btn-approve { background:#10b981; color:#fff; border-radius:10px; padding:8px 18px; font-size:0.85rem; font-weight:600; border:none; transition:0.2s; }
  .btn-approve:hover { background:#059669; transform:translateY(-2px); }
  .btn-reject { background:#ef4444; color:#fff; border-radius:10px; padding:8px 18px; font-size:0.85rem; font-weight:600; border:none; transition:0.2s; }
  .btn-reject:hover { background:#dc2626; transform:translateY(-2px); }
  .flash-msg { padding:15px 25px; border-radius:15px; margin-bottom:30px; background:#ecfdf5; color:#065f46; border:1px solid #a7f3d0; font-weight:500; display:flex; align-items:center; gap:10px; }

  @media (max-width: 992px) {
    .layout { flex-direction: column; }
    .sidebar { width:100%; position:relative; top:0; height:auto; border-right:none; border-bottom:1px solid var(--maroon-border); }
    .main { padding: 20px 15px; }
    .topbar { padding: 0 15px; }
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
    <div class="container-fluid">
      <h4 class="mb-4 fw-bold text-dark">Salon Business Verification</h4>

      <c:if test="${not empty message}">
          <div class="flash-msg">${message}</div>
      </c:if>

      <div class="card-table">
        <div class="card-table-header">Pending Salon Applications</div>
        <div class="table-responsive">
          <table class="table align-middle mb-0">
            <thead class="table-light text-uppercase small fw-bold">
              <tr>
                <th>Salon Details</th>
                <th>Location</th>
                <th>Contact</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${pendingSalons}" var="s">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${s.name}</div>
                    <div class="small text-muted">Est. ${s.establishedYear}</div>
                  </td>
                  <td>
                    <div>${s.address}</div>
                    <div class="small text-muted">${s.city}, ${s.state}</div>
                  </td>
                  <td>
                    <div>${s.phone}</div>
                    <div class="small text-muted">${s.email}</div>
                  </td>
                  <td>
                    <div class="d-flex gap-2">
                      <a href="${pageContext.request.contextPath}/admin/salons/${s.id}/profile" class="btn btn-sm btn-outline-primary"><i class="fas fa-eye"></i> View Profile</a>
                      <form action="${pageContext.request.contextPath}/admin/salons/${s.id}/approve" method="post">
                        <button type="submit" class="btn-approve">Approve</button>
                      </form>
                      <form action="${pageContext.request.contextPath}/admin/salons/${s.id}/reject" method="post">
                        <button type="submit" class="btn-reject">Reject</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty pendingSalons}">
                <tr><td colspan="4" class="text-center py-4 text-muted">No pending salon applications.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">Verified Salons</div>
        <div class="table-responsive">
          <table class="table align-middle mb-0">
            <thead class="table-light text-uppercase small fw-bold">
              <tr>
                <th>Salon Name</th>
                <th>City</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${approvedSalons}" var="s">
                <tr>
                  <td><span class="fw-bold">${s.name}</span></td>
                  <td>${s.city}</td>
                  <td><span class="badge bg-success">Verified</span></td>
                  <td>
                    <div class="d-flex gap-2">
                      <a href="${pageContext.request.contextPath}/admin/salons/${s.id}/profile" class="btn btn-sm btn-outline-primary"><i class="fas fa-eye"></i> View Profile</a>
                      <form action="${pageContext.request.contextPath}/admin/salons/${s.id}/delete" method="post" onsubmit="return confirm('Are you sure you want to delete this salon?');">
                        <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-trash-alt"></i> Delete</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>
