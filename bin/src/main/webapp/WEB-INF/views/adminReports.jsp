<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Reports & Exports — Admin</title>
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
  .mainInner { max-width:1100px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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

  /* ── CARDS ── */
  .export-card {
      background: #fff;
      border-radius: 16px;
      padding: 30px;
      text-align: center;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--maroon-border);
      transition: all 0.2s;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
  }
  .export-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 30px rgba(125,42,90,0.15);
      border-color: var(--maroon-light);
  }
  .export-icon {
      font-size: 3rem;
      color: var(--maroon);
      margin-bottom: 20px;
  }
  .export-title {
      font-size: 1.25rem;
      font-weight: 700;
      color: var(--maroon-dark);
      margin-bottom: 10px;
  }
  .export-desc {
      font-size: 0.9rem;
      color: #6b7280;
      margin-bottom: 25px;
      flex-grow: 1;
  }
  .btn-export {
      background: var(--maroon);
      color: #fff;
      border: none;
      padding: 10px 24px;
      border-radius: 10px;
      font-weight: 600;
      font-size: 0.95rem;
      transition: all 0.2s;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
  }
  .btn-export:hover { background: var(--maroon-dark); color: #fff; transform: translateY(-2px); }

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
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-file-export me-2"></i>Reports & Exports</h4>
          <p>Generate and download official CSV data reports for authorities and NGOs.</p>
        </div>
      </div>

      <c:if test="${not empty error}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-circle me-1"></i> ${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
      </c:if>

      <div class="row g-4">
          <!-- Users Export -->
          <div class="col-md-4">
              <div class="export-card">
                  <div class="export-icon"><i class="fas fa-users"></i></div>
                  <div class="export-title">User Growth Report</div>
                  <div class="export-desc">Download a comprehensive list of all registered users, including their verification status and demographic data.</div>
                  <a href="${pageContext.request.contextPath}/admin/reports/export-users" class="btn-export">
                      <i class="fas fa-download"></i> Download CSV
                  </a>
              </div>
          </div>



          <!-- SOS Export -->
          <div class="col-md-4">
              <div class="export-card">
                  <div class="export-icon"><i class="fas fa-broadcast-tower"></i></div>
                  <div class="export-title">SOS Activations</div>
                  <div class="export-desc">Generate a historical ledger of emergency SOS panic alerts triggered by users across the platform.</div>
                  <a href="${pageContext.request.contextPath}/admin/reports/export-sos" class="btn-export">
                      <i class="fas fa-download"></i> Download CSV
                  </a>
              </div>
          </div>
      </div>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

