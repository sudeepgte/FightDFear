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
    --primary: #F43F5E;
    --rose-soft: #FFF1F2;
    --bg: #F8FAFC;
    --navy: #0F172A;
    --navy-mid: #1E293B;
    --border: #E2E8F0;
    --text-muted: #64748B;
    --shadow-sm: 0 6px 20px rgba(15, 23, 42, 0.08);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--bg); color:var(--navy-mid); }

  /* ── TOPBAR ── */
  .topbar {
    background: var(--navy); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    border-bottom: 1px solid rgba(255,255,255,0.08);
  }
  .topbar .brand {
    color: #fff;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 1.05rem;
    font-weight: 700;
  }
  .topbar .brand img {
    height: 32px;
    width: 32px;
    border-radius: 8px;
    object-fit: cover;
  }
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
    border-right:1px solid var(--border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
    transition: all 0.3s ease;
  }
  .brand { font-size: 0.9rem; font-weight: 700; color: var(--navy); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
  }
  .navlink i { width: 20px; text-align: center; color: var(--primary); font-size: 1rem; }
  .navlink:hover { background: var(--rose-soft); color: var(--navy); padding-left: 20px; }
  .navlink.active { background: var(--primary); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(244,63,94,0.2); }
  .navlink.active i { color: #fff; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:1200px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
  @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

  /* ── PAGE HEADER ── */
  .pg-header {
    background: linear-gradient(135deg, var(--navy) 0%, var(--navy-mid) 62%, #334155 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 26px rgba(15,23,42,0.22);
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
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(244,63,94,0.18);
  }
  .btn-search {
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 30px;
      padding: 11px 26px;
      font-weight: 600;
      font-size: 0.9rem;
      cursor: pointer;
      transition: all 0.2s;
  }
  .btn-search:hover { background: #e11d48; transform: translateY(-1px); color: #fff; }
  
  .btn-clear {
      color: var(--primary);
      font-size: 0.85rem;
      font-weight: 600;
      text-decoration: none;
      padding: 9px 16px;
      border-radius: 20px;
      border: 2px solid var(--primary);
      transition: all 0.2s;
      align-self: center;
  }
  .btn-clear:hover { background: var(--primary); color: #fff; }

  /* ── SEARCH RESULT BANNER ── */
  .result-banner {
      background: #fff;
      border-left: 4px solid var(--primary);
      border-radius: 10px;
      padding: 12px 18px;
      margin-bottom: 18px;
      font-size: 0.9rem;
      color: var(--navy-mid);
      font-weight: 600;
      box-shadow: var(--shadow-sm);
  }

  /* ── TABLE CARDS ── */
  .card-table {
    background:#fff; border-radius:16px; overflow:hidden;
    border:1px solid var(--border); box-shadow:var(--shadow-sm);
    margin-bottom: 28px;
  }
  .card-table-header {
    background: var(--rose-soft);
    padding: 16px 20px;
    border-bottom: 1px solid var(--border);
    font-weight: 700;
    color: var(--navy);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .table { margin-bottom:0; }
  .table thead th {
    background: #F8FAFC; color:var(--navy);
    font-size:0.75rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:16px; border:none; border-bottom:1px solid var(--border); text-align:center;
  }
  .table tbody td {
    padding:16px; vertical-align:middle; border-bottom:1px solid var(--border);
    font-size:0.9rem; text-align:center;
  }
  .table tbody tr:last-child td { border-bottom: none; }
  .table tbody tr:hover { background:rgba(244,63,94,0.04); }

  /* ── BADGES & BUTTONS ── */
  .badge-status {
    padding:6px 12px; border-radius:999px; font-size:0.75rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-APPROVED, .status-VERIFIED { background:#d1fae5; color:#065f46; border-color:#a7f3d0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background:#fef3c7; color:#92400e; border-color:#fde68a; }
  .status-READY_FOR_VERIFICATION, .status-REVERIFICATION { background:#e0f2fe; color:#075985; border-color:#bae6fd; }
  .status-CHANGES_REQUESTED { background:#ffedd5; color:#9a3412; border-color:#fed7aa; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background:#f1f5f9; color:#475569; border-color:#cbd5e1; }
  .status-REJECTED, .status-SUSPENDED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
  
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
    background: #fff;
    color: var(--primary); 
    border: 1px solid #fecdd3;
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
    background: var(--primary); 
    color: #fff; 
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(244,63,94,0.2);
  }

  .table-responsive {
    width: 100%;
    overflow-x: auto;
  }
  .table-responsive .table {
    min-width: 760px;
  }

  .quick-filter .btn {
    border-radius: 999px;
    font-weight: 600;
  }
  .quick-filter .btn-primary {
    background: var(--primary);
    border-color: var(--primary);
  }
  .quick-filter .btn-outline-primary {
    color: var(--primary);
    border-color: var(--primary);
  }
  .quick-filter .btn-outline-primary:hover {
    background: var(--primary);
    border-color: var(--primary);
  }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--border);}
  }

  @media (max-width: 768px) {
    .topbar { padding: 0 12px; }
    .topbar .brand span { font-size: 0.95rem; }
    .main { padding: 16px 12px 34px; }
    .pg-header { padding: 18px 16px; margin-bottom: 18px; }
    .search-wrap { margin-bottom: 18px; }
    .search-input { min-width: 100%; }
    .search-wrap .form-select, .search-wrap .btn-search, .search-wrap .btn-clear {
      width: 100%;
    }
    .table-responsive .table {
      min-width: 100%;
    }
    .table-responsive.responsive-card-table table,
    .table-responsive.responsive-card-table thead,
    .table-responsive.responsive-card-table tbody,
    .table-responsive.responsive-card-table th,
    .table-responsive.responsive-card-table td,
    .table-responsive.responsive-card-table tr {
      display: block;
      width: 100%;
    }
    .table-responsive.responsive-card-table thead {
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      white-space: nowrap;
      border: 0;
    }
    .table-responsive.responsive-card-table tbody tr {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 12px;
      margin: 12px;
      padding: 8px 10px;
      box-shadow: 0 4px 14px rgba(15,23,42,0.05);
    }
    .table-responsive.responsive-card-table tbody td {
      border: 0;
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
      padding: 8px 2px;
      text-align: left;
      font-size: 0.86rem;
      border-bottom: 1px dashed #e5e7eb;
    }
    .table-responsive.responsive-card-table tbody td:last-child {
      border-bottom: 0;
      padding-bottom: 4px;
    }
    .table-responsive.responsive-card-table tbody td::before {
      content: attr(data-label);
      color: var(--text-muted);
      font-size: 0.72rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.04em;
      flex: 0 0 42%;
      max-width: 42%;
    }
    .table-responsive.responsive-card-table tbody td > * {
      max-width: 58%;
    }
    .table-responsive.responsive-card-table .d-flex {
      justify-content: flex-end !important;
      width: 100%;
    }
  }
</style>
</head>
<body>

<div class="topbar">
  <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
    <span>Fight D Fear Admin</span>
  </a>
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

      <!-- Search + filter -->
      <form method="get" action="${pageContext.request.contextPath}/admin/pending-doctors" class="search-wrap">
          <input type="text" id="doctorSearchInput" name="q" class="search-input" placeholder="Search by name, email, phone, specialization or location..." value="${not empty q ? q : ''}">
          <select name="filter" class="form-select" style="max-width:220px;border-radius:30px;">
              <option value="pending" ${filter == 'pending' ? 'selected' : ''}>Pending queue</option>
              <option value="reverification" ${filter == 'reverification' ? 'selected' : ''}>Re-verification</option>
              <option value="changes_requested" ${filter == 'changes_requested' ? 'selected' : ''}>Changes Requested</option>
              <option value="approved" ${filter == 'approved' ? 'selected' : ''}>Approved</option>
              <option value="rejected" ${filter == 'rejected' ? 'selected' : ''}>Rejected</option>
              <option value="all" ${filter == 'all' ? 'selected' : ''}>All</option>
          </select>
          <button type="submit" class="btn-search">Search / Filter</button>
          <c:if test="${not empty q}">
              <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="btn-clear"><i class="fas fa-times me-1"></i> Clear</a>
          </c:if>
      </form>

      <div class="d-flex flex-wrap gap-2 mb-4 quick-filter">
          <a class="btn btn-sm ${filter == 'pending' ? 'btn-primary' : 'btn-outline-primary'}" href="?filter=pending">Pending (${pendingCount})</a>
          <a class="btn btn-sm ${filter == 'reverification' ? 'btn-primary' : 'btn-outline-primary'}" href="?filter=reverification">Re-verification (${reverificationCount})</a>
          <a class="btn btn-sm ${filter == 'changes_requested' ? 'btn-primary' : 'btn-outline-primary'}" href="?filter=changes_requested">Changes Requested (${changesRequestedCount})</a>
          <a class="btn btn-sm ${filter == 'approved' ? 'btn-primary' : 'btn-outline-primary'}" href="?filter=approved">Approved (${approvedCount})</a>
          <a class="btn btn-sm ${filter == 'rejected' ? 'btn-primary' : 'btn-outline-primary'}" href="?filter=rejected">Rejected (${rejectedCount})</a>
      </div>

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
            <div class="table-responsive responsive-card-table">
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
                                  <td><span class="badge-status status-${d.doctorProfileStatus}">${not empty d.doctorProfileStatusLabel ? d.doctorProfileStatusLabel : d.doctorProfileStatus}</span></td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Review</a>
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
            <div class="table-responsive responsive-card-table">
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
                                  <td><span class="badge-status status-PENDING">${d.doctorProfileStatus}</span></td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Review</a>
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

          <!-- Changes Requested -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-edit text-warning"></i> Changes Requested
            </div>
            <div class="table-responsive responsive-card-table">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Specialization</th>
                          <th>Admin Note</th>
                          <th>Action</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty changesRequested}">
                          <c:forEach var="d" items="${changesRequested}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.specialization}</td>
                                  <td>${not empty d.changesRequestedNote ? d.changesRequestedNote : '—'}</td>
                                  <td>
                                      <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Review</a>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="5" class="py-4 text-center text-muted">No doctors with changes requested.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Re-verification -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-sync text-info"></i> Pending Re-verification
            </div>
            <div class="table-responsive responsive-card-table">
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
                      <c:when test="${not empty reverification}">
                          <c:forEach var="d" items="${reverification}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.specialization}</td>
                                  <td><span class="badge-status status-${d.doctorProfileStatus}">${not empty d.doctorProfileStatusLabel ? d.doctorProfileStatusLabel : d.doctorProfileStatus}</span></td>
                                  <td>
                                      <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Review</a>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="5" class="py-4 text-center text-muted">No pending re-verification requests.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Approved Doctors Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-user-md text-success"></i> Approved Doctors
            </div>
            <div class="table-responsive responsive-card-table">
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
                      <c:when test="${not empty approved}">
                          <c:forEach var="d" items="${approved}">
                              <tr>
                                  <td class="fw-bold">${d.fullName}</td>
                                  <td>${d.email}</td>
                                  <td>${d.specialization}</td>
                                  <td><span class="badge-status status-${d.doctorProfileStatus}">${not empty d.doctorProfileStatusLabel ? d.doctorProfileStatusLabel : d.doctorProfileStatus}</span></td>
                                  <td>
                                      <a href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" class="btn-profile"><i class="fas fa-user"></i> Profile</a>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="5" class="py-4 text-center text-muted">No approved doctors.</td>
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
            <div class="table-responsive responsive-card-table">
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
                                  <td><span class="badge-status status-${d.doctorProfileStatus}">${not empty d.doctorProfileStatusLabel ? d.doctorProfileStatusLabel : d.doctorProfileStatus}</span></td>
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

<script>
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.responsive-card-table table').forEach(function (table) {
      var headers = Array.from(table.querySelectorAll('thead th')).map(function (th) {
        return th.textContent.trim();
      });
      table.querySelectorAll('tbody tr').forEach(function (row) {
        row.querySelectorAll('td').forEach(function (cell, index) {
          if (!cell.hasAttribute('data-label')) {
            cell.setAttribute('data-label', headers[index] || '');
          }
        });
      });
    });
  });
</script>

</body>
</html>

