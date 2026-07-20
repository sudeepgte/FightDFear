<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>User Management — Admin</title>
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

  /* ── FLASH MESSAGES ── */
  .flash-msg {
      padding: 12px 18px;
      border-radius: 10px;
      margin-bottom: 20px;
      font-weight: 600;
      font-size: 0.9rem;
      animation: slideUpFade 0.4s ease;
  }
  .flash-success { background: #d1fadf; color: #0b6e31; border-left: 4px solid #059669; }
  .flash-error   { background: #ffe0e0; color: #9b1b1b; border-left: 4px solid #dc2626; }
  @keyframes slideUpFade {
      from { opacity:0; transform:translateY(10px); }
      to   { opacity:1; transform:translateY(0); }
  }

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

  /* ── STATUS PILLS ── */
  .pill {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 700;
  }
  .pill-verified  { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
  .pill-pending   { background: #fef9c3; color: #854d0e; border: 1px solid #fef08a; }
  .pill-rejected  { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
  .pill-banned    { background: #f3f4f6; color: #374151; border: 1px solid #e5e7eb; }
  .pill-active    { background: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }

  /* ── ACTION BUTTONS ── */
  .btn-action {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 6px 12px;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      margin: 2px;
  }
  .btn-action:hover { transform: translateY(-1px); color: #fff; }
  .btn-ban    { background: #fef3c7; color: #92400e; }
  .btn-ban:hover { background: #f59e0b; color: #fff; }
  
  .btn-unban  { background: #d1fadf; color: #065f46; }
  .btn-unban:hover { background: #10b981; color: #fff; }
  
  .btn-delete { background: #fee2e2; color: #991b1b; }
  .btn-delete:hover { background: #ef4444; color: #fff; }
  
  .btn-profile { background: var(--maroon-pale); color: var(--maroon); border: 1px solid var(--maroon-border); }
  .btn-profile:hover { background: var(--maroon); color: #fff; }

  /* ── MODAL ── */
  .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.6);
      z-index: 9999;
      align-items: center;
      justify-content: center;
  }
  .modal-overlay.open { display: flex; }
  .modal-box {
      background: #fff;
      border-radius: 18px;
      padding: 32px;
      max-width: 400px;
      width: 90%;
      text-align: center;
      box-shadow: 0 20px 40px rgba(0,0,0,0.2);
      animation: slideUpFade 0.3s ease;
  }
  .modal-box h3 { color: #dc2626; margin-bottom: 10px; font-size: 1.3rem; font-weight: 700; }
  .modal-box p  { color: #4b5563; font-size: 0.95rem; margin-bottom: 24px; }
  .modal-actions { display: flex; gap: 12px; justify-content: center; }
  .btn-confirm-delete {
      background: #dc2626;
      color: #fff;
      border: none;
      border-radius: 10px;
      padding: 10px 22px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
  }
  .btn-confirm-delete:hover { background: #b91c1c; }
  .btn-cancel-delete {
      background: #f3f4f6;
      color: #374151;
      border: none;
      border-radius: 10px;
      padding: 10px 22px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
  }
  .btn-cancel-delete:hover { background: #e5e7eb; }

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
          <h4><i class="fas fa-users-cog me-2"></i>User Management</h4>
          <p>Ban, unban, or permanently delete user accounts</p>
        </div>
      </div>

      <!-- Flash messages -->
      <c:if test="${not empty message}">
          <div class="flash-msg flash-success"><i class="fas fa-check-circle me-1"></i> ${message}</div>
      </c:if>
      <c:if test="${not empty error}">
          <div class="flash-msg flash-error"><i class="fas fa-exclamation-circle me-1"></i> ${error}</div>
      </c:if>

      <!-- Search bar -->
      <form method="get" action="${pageContext.request.contextPath}/admin/users" class="search-wrap">
          <input type="text" id="userMgmtSearch" name="q" class="search-input" placeholder="🔍 Search by name, email or phone..." value="${not empty q ? q : ''}">
          <button type="submit" class="btn-search">Search</button>
          <c:if test="${not empty q}">
              <a href="${pageContext.request.contextPath}/admin/users" class="btn-clear"><i class="fas fa-times me-1"></i> Clear</a>
          </c:if>
      </form>

      <!-- ── Search Results ── -->
      <c:if test="${not empty q}">
          <div class="result-banner">
              <i class="fas fa-info-circle me-1"></i> Results for "<strong>${q}</strong>" —
              <c:choose>
                  <c:when test="${not empty searchResults}">${searchResults.size()} user(s) found</c:when>
                  <c:otherwise>No users found</c:otherwise>
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
                          <th>#</th><th>Name</th><th>Email</th><th>Phone</th>
                          <th>Status</th><th>Access</th><th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty searchResults}">
                          <c:forEach var="u" items="${searchResults}" varStatus="s">
                              <tr>
                                  <td class="text-muted">${u.id}</td>
                                  <td class="fw-bold">${u.fullName}</td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${u.verificationStatus == 'VERIFIED'}"><span class="pill pill-verified"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></c:when>
                                          <c:when test="${u.verificationStatus == 'REJECTED'}"><span class="pill pill-rejected"><i class="fas fa-times-circle me-1"></i> REJECTED</span></c:when>
                                          <c:otherwise><span class="pill pill-pending"><i class="fas fa-clock me-1"></i> PENDING</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${u.banned}"><span class="pill pill-banned"><i class="fas fa-ban me-1"></i> BANNED</span></c:when>
                                          <c:otherwise><span class="pill pill-active"><i class="fas fa-check me-1"></i> ACTIVE</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="btn-action btn-profile"><i class="fas fa-user"></i> Profile</a>
                                        <c:choose>
                                            <c:when test="${u.banned}">
                                                <form action="${pageContext.request.contextPath}/admin/users/${u.id}/unban" method="post" class="m-0 p-0 d-inline">
                                                    <button type="submit" class="btn-action btn-unban"><i class="fas fa-unlock"></i> Unban</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/admin/users/${u.id}/ban" method="post" class="m-0 p-0 d-inline">
                                                    <button type="submit" class="btn-action btn-ban"><i class="fas fa-ban"></i> Ban</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="btn-action btn-delete" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="7" class="py-4 text-center text-muted">No users match your search.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>
      </c:if>

      <!-- ── Normal View (Active + Banned sections) ── -->
      <c:if test="${empty q}">

          <!-- Pending Verifications Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-clock text-warning"></i> Pending Verifications
              <span class="badge-count">${not empty pendingUsers ? pendingUsers.size() : 0}</span>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>#</th><th>Name</th><th>Email</th><th>Phone</th>
                          <th>Identity Doc</th><th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty pendingUsers}">
                          <c:forEach var="u" items="${pendingUsers}">
                              <tr>
                                  <td class="text-muted">${u.id}</td>
                                  <td class="fw-bold text-start ps-4">${u.fullName}</td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                  <td><code>${not empty u.identityDocument ? u.identityDocument : '—'}</code></td>
                                  <td>
                                      <div class="d-flex justify-content-center gap-2">
                                          <form action="${pageContext.request.contextPath}/admin/users/${u.id}/approve" method="post" class="m-0">
                                              <button type="submit" class="btn-action bg-success text-white border-0 px-3 py-1 rounded">
                                                  <i class="fas fa-check-circle me-1"></i> Verify
                                              </button>
                                          </form>
                                          <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject" method="post" class="m-0">
                                              <button type="submit" class="btn-action btn-delete">
                                                  <i class="fas fa-times-circle me-1"></i> Reject
                                              </button>
                                          </form>
                                          <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="btn-action btn-profile">
                                              <i class="fas fa-eye me-1"></i> View
                                          </a>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="6" class="py-4 text-center text-muted">No pending verifications at the moment.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Verified Users Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-user-check text-success"></i> Verified Users
              <span class="badge-count">${not empty verifiedUsers ? verifiedUsers.size() : 0}</span>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>#</th><th>Name</th><th>Email</th><th>Phone</th>
                          <th>Status</th><th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty verifiedUsers}">
                          <c:forEach var="u" items="${verifiedUsers}">
                              <tr>
                                  <td class="text-muted">${u.id}</td>
                                  <td class="fw-bold text-start ps-4">${u.fullName}</td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                  <td><span class="pill pill-verified"><i class="fas fa-check me-1"></i> Verified</span></td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="btn-action btn-profile"><i class="fas fa-user"></i> Profile</a>
                                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/ban" method="post" class="m-0 p-0 d-inline">
                                            <button type="submit" class="btn-action btn-ban"><i class="fas fa-ban"></i> Ban</button>
                                        </form>
                                        <button class="btn-action btn-delete" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="6" class="py-4 text-center text-muted">No verified users found.</td>
                          </tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Banned Users Table -->
          <div class="card-table">
            <div class="card-table-header">
              <i class="fas fa-user-slash text-danger"></i> Banned Users
              <span class="badge-count" style="background:var(--maroon-dark);">${not empty bannedUsers ? bannedUsers.size() : 0}</span>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                  <thead>
                      <tr>
                          <th>#</th><th>Name</th><th>Email</th><th>Phone</th>
                          <th>Access</th><th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty bannedUsers}">
                          <c:forEach var="u" items="${bannedUsers}">
                              <tr style="background-color: #fef2f2;">
                                  <td class="text-muted">${u.id}</td>
                                  <td class="fw-bold">${u.fullName}</td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                  <td><span class="pill pill-banned"><i class="fas fa-ban me-1"></i> BANNED</span></td>
                                  <td>
                                      <div class="d-flex justify-content-center align-items-center flex-wrap">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="btn-action btn-profile"><i class="fas fa-user"></i> Profile</a>
                                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/unban" method="post" class="m-0 p-0 d-inline">
                                            <button type="submit" class="btn-action btn-unban"><i class="fas fa-unlock"></i> Unban</button>
                                        </form>
                                        <button class="btn-action btn-delete" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr>
                              <td colspan="6" class="py-4 text-center text-muted">No banned users.</td>
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

<!-- ── Delete Confirmation Modal ── -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <h3><i class="fas fa-exclamation-triangle"></i> Delete User</h3>
        <p>Are you sure you want to <strong>permanently delete</strong> <span id="deleteUserName" class="fw-bold"></span>?<br>
           This action <strong>cannot be undone</strong>.</p>
        <div class="modal-actions">
            <form id="deleteForm" method="post" action="">
                <button type="submit" class="btn-confirm-delete">Yes, Delete</button>
            </form>
            <button class="btn-cancel-delete" onclick="closeModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
function confirmDelete(id, name) {
    document.getElementById('deleteUserName').textContent = name;
    document.getElementById('deleteForm').action =
        '${pageContext.request.contextPath}/admin/users/' + id + '/delete';
    document.getElementById('deleteModal').classList.add('open');
}
function closeModal() {
    document.getElementById('deleteModal').classList.remove('open');
}
// Close on overlay click
document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
</script>

</body>
</html>

