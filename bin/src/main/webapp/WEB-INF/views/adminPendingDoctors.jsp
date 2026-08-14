<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Verification — Admin</title>
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

  /* ── SEARCH BAR ── */
  .search-wrap {
      display: flex;
      gap: 10px;
      margin-bottom: 28px;
      flex-wrap: wrap;
  }
  .search-input {
      flex: 1;
      min-width: 220px;
      padding: 11px 20px;
      border: 2px solid var(--maroon-border);
      border-radius: 30px;
      font-family: 'Poppins', sans-serif;
      font-size: 0.92rem;
      background: #fff;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
  }
  .search-input:focus {
      border-color: var(--maroon-light);
      box-shadow: 0 0 0 3px rgba(125,42,90,0.15);
  }
  .btn-search {
      background: var(--maroon);
      color: #fff;
      border: none;
      border-radius: 30px;
      padding: 11px 26px;
      font-weight: 600;
      font-size: 0.9rem;
      cursor: pointer;
      transition: all 0.2s;
  }
  .btn-search:hover { background: var(--maroon-light); transform: translateY(-1px); color: #fff; }
  
  .btn-clear {
      color: var(--maroon);
      font-size: 0.85rem;
      font-weight: 600;
      text-decoration: none;
      padding: 9px 16px;
      border-radius: 20px;
      border: 2px solid var(--maroon);
      transition: all 0.2s;
      align-self: center;
  }
  .btn-clear:hover { background: var(--maroon); color: #fff; }

  /* ── SEARCH RESULT BANNER ── */
  .result-banner {
      background: #fff;
      border-left: 4px solid var(--maroon-light);
      border-radius: 10px;
      padding: 12px 18px;
      margin-bottom: 18px;
      font-size: 0.9rem;
      color: var(--maroon-dark);
      font-weight: 600;
      box-shadow: var(--shadow-sm);
  }

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

  .btn-profile {
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
    margin-right: 4px;
  }
  .btn-profile:hover { 
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
          <h4><i class="fas fa-user-md me-2"></i>Doctor Verification</h4>
          <p>Review and verify doctor profiles before they appear on the platform</p>
        </div>
      </div>

      <c:if test="${not empty message}">
          <div class="alert alert-info mb-4" style="border-radius:10px;"><i class="fas fa-info-circle me-1"></i> ${message}</div>
      </c:if>

      <!-- Search bar -->
      <form method="get" action="${pageContext.request.contextPath}/admin/pending-doctors" class="search-wrap">
          <input type="text" id="doctorSearchInput" name="q" class="search-input" placeholder="🔍 Search by name, email, phone, specialization or location..." value="${not empty q ? q : ''}">
          <button type="submit" class="btn-search">Search</button>
          <c:if test="${not empty q}">
              <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="btn-clear"><i class="fas fa-times me-1"></i> Clear</a>
          </c:if>
      </form>

      <!-- ── Search Results ── -->
      <c:if test="${not empty q}">
          <div class="result-banner">
              <i class="fas fa-info-circle me-1"></i> Showing results for "<strong>${q}</strong>" —
              <c:choose>
                  <c:when test="${not empty searchResults}">${searchResults.size()} doctor(s) found</c:when>
                  <c:otherwise>No doctors found</c:otherwise>
              </c:choose>
          </div>

          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-search text-primary"></i> Search Results
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Phone</th>
                          <th>Specialization</th>
                          <th>Location</th>
                          <th>Status</th>
                          <th>Action</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty searchResults}">
                          <c:forEach var="d" items="${searchResults}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${not empty d.phone ? d.phone : '—'}</td>
                                  <td>${not empty d.specialization ? d.specialization : '—'}</td>
                                  <td>${not empty d.locationText ? d.locationText : '—'}</td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${d.verificationStatus == 'VERIFIED'}"><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></c:when>
                                          <c:when test="${d.verificationStatus == 'REJECTED'}"><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></c:when>
                                          <c:otherwise><span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> ${d.verificationStatus}</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Profile</a>
                                        <c:if test="${d.verificationStatus != 'VERIFIED'}">
                                            <form action="${pageContext.request.contextPath}/admin/doctors/${d.id}/verify" method="post" class="m-0 p-0 d-inline">
                                                <button class="btn-approve me-1" type="submit"><i class="fas fa-check"></i> Verify</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${d.verificationStatus != 'REJECTED'}">
                                            <form action="${pageContext.request.contextPath}/admin/doctors/${d.id}/reject" method="post" class="m-0 p-0 d-inline">
                                                <button class="btn-reject" type="submit"><i class="fas fa-times"></i> Reject</button>
                                            </form>
                                        </c:if>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="7" class="py-4 text-center text-muted">No doctors match your search.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>
      </c:if>

      <!-- ── Normal View (Pending + Verified + Rejected) ── -->
      <c:if test="${empty q}">

          <!-- Pending Doctors Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-clock text-warning"></i> Pending Doctors
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Phone</th>
                          <th>Specialization</th>
                          <th>Location</th>
                          <th>Identity Doc</th>
                          <th>Status</th>
                          <th>Action</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty pending}">
                          <c:forEach var="d" items="${pending}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.phone}</td>
                                  <td>${d.specialization}</td>
                                  <td>${d.locationText}</td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${not empty d.identityDocumentPath}">
                                              <a class="btn-profile" target="_blank" href="${pageContext.request.contextPath}${d.identityDocumentPath}"><i class="fas fa-id-card"></i> View</a>
                                          </c:when>
                                          <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td><span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> ${d.verificationStatus}</span></td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Profile</a>
                                        <form action="${pageContext.request.contextPath}/admin/doctors/${d.id}/verify" method="post" class="m-0 p-0 d-inline">
                                            <button class="btn-approve me-1" type="submit"><i class="fas fa-check"></i></button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/doctors/${d.id}/reject" method="post" class="m-0 p-0 d-inline">
                                            <button class="btn-reject" type="submit"><i class="fas fa-times"></i></button>
                                        </form>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="8" class="py-4 text-center text-muted"><i class="fas fa-check-circle fa-2x mb-2 d-block text-success" style="opacity:0.4;"></i>No pending doctors.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Verified Doctors Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-user-md text-success"></i> Verified Doctors
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Specialization</th>
                          <th>Status</th>
                          <th>Action</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty verified}">
                          <c:forEach var="d" items="${verified}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.specialization}</td>
                                  <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                                  <td>
                                      <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Profile</a>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="5" class="py-4 text-center text-muted">No verified doctors.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Rejected Doctors Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-user-times text-danger"></i> Rejected Doctors
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Specialization</th>
                          <th>Status</th>
                          <th>Action</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty rejected}">
                          <c:forEach var="d" items="${rejected}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.specialization}</td>
                                  <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                                  <td>
                                      <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Profile</a>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="5" class="py-4 text-center text-muted">No rejected doctors.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
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

