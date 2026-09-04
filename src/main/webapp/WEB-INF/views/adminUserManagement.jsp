<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>User Management - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .ap-btn-action { padding: 7px 12px; border-radius: 9px; font-size: 0.8rem; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
    .ap-btn-action:hover { filter: brightness(0.96); }
    .ap-btn-success { background: var(--ap-success-bg); color: var(--ap-success); border: 1px solid #BBF7D0; }
    .ap-btn-warn { background: var(--ap-warn-bg); color: var(--ap-warn); border: 1px solid #FDE68A; }
    .ap-btn-danger { background: var(--ap-danger-bg); color: var(--ap-danger); border: 1px solid #FECACA; }
    .ap-btn-danger:hover { background: var(--ap-danger); color: white; }
    .ap-btn-success-solid { background: var(--ap-success); color: white; }
    .ap-badge-banned { background: #F1F5F9; color: #475569; }
    
    /* ── MODAL ── */
    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center; }
    .modal-overlay.open { display: flex; }
    .modal-box { background: #fff; border-radius: 18px; padding: 32px; max-width: 400px; width: 90%; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.2); animation: slideUpFade 0.3s ease; }
    .modal-box h3 { color: #dc2626; margin-bottom: 10px; font-size: 1.3rem; font-weight: 700; }
    .modal-box p  { color: #4b5563; font-size: 0.95rem; margin-bottom: 24px; }
    .modal-actions { display: flex; gap: 12px; justify-content: center; }
    .btn-confirm-delete { background: #dc2626; color: #fff; border: none; border-radius: 10px; padding: 10px 22px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-confirm-delete:hover { background: #b91c1c; }
    .btn-cancel-delete { background: #f3f4f6; color: #374151; border: none; border-radius: 10px; padding: 10px 22px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-cancel-delete:hover { background: #e5e7eb; }
    @keyframes slideUpFade { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }
  </style>
</head>
<body class="ap-page">

<c:set var="pendingCount" value="${not empty pendingUsers ? pendingUsers.size() : 0}"/>
<c:set var="verifiedCount" value="${not empty verifiedUsers ? verifiedUsers.size() : 0}"/>
<c:set var="bannedCount" value="${not empty bannedUsers ? bannedUsers.size() : 0}"/>
<c:set var="totalUsers" value="${pendingCount + verifiedCount + bannedCount}"/>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:360px;">
          <i class="fas fa-search"></i>
          <input type="search" id="apHeaderSearch" placeholder="Search anything..." aria-label="Search">
          <span class="ap-kbd">Ctrl + K</span>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
          <i class="fas fa-bell"></i>
          <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
        </a>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty admin.profilePhoto}">
                <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
              </c:when>
              <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span>
            <div class="name"><c:out value="${admin.name}"/></div>
            <div class="role">Super Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="ap-main-inner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <span>User Management</span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-users-cog"></i></div>
        <div>
          <h1>User Management</h1>
          <p>Ban, unban, or permanently delete user accounts</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-success mb-3" style="border-radius:12px;background:#F0FDF4;color:#15803D;border:1px solid #BBF7D0;"><i class="fas fa-check-circle me-1"></i> <c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3" style="border-radius:12px;background:#FEF2F2;color:#B91C1C;border:1px solid #FECACA;"><i class="fas fa-exclamation-circle me-1"></i> <c:out value="${error}"/></div>
      </c:if>

      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pendingCount}</div>
          <div class="lbl">Pending Verifications</div>
          <div class="sub">Requires review</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${verifiedCount}</div>
          <div class="lbl">Verified Users</div>
          <div class="sub">Verified users</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-ban"></i></div>
          <div class="val">${bannedCount}</div>
          <div class="lbl">Banned Users</div>
          <div class="sub">Restricted users</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-users"></i></div>
          <div class="val">${totalUsers}</div>
          <div class="lbl">Total Users</div>
          <div class="sub">Across all users</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/users" class="ap-filter-row">
        <div class="grow">
          <input type="text" id="userMgmtSearch" name="q" class="ap-input" placeholder="Search by name, email or phone..." value="${not empty q ? q : ''}">
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-search"></i> Search / Filter</button>
        <c:if test="${not empty q}">
          <a href="${pageContext.request.contextPath}/admin/users" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <!-- ── Search Results ── -->
      <c:if test="${not empty q}">
          <section class="ap-panel mb-4">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${q}"/></strong>"
              <c:choose>
                  <c:when test="${not empty searchResults}"> - ${searchResults.size()} user(s) found</c:when>
                  <c:otherwise> - No users found</c:otherwise>
              </c:choose>
            </div>
            <div class="ap-table-wrap">
              <table class="ap-table">
                  <thead>
                      <tr>
                          <th>#</th><th>Name</th><th>Email</th><th>Phone</th>
                          <th>Status</th><th>Access</th><th>Actions</th>
                      </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                      <c:when test="${not empty searchResults}">
                          <c:forEach var="u" items="${searchResults}">
                              <tr>
                                  <td class="ap-muted">${u.id}</td>
                                  <td><div class="nm" style="font-weight:700;">${u.fullName}</div></td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '-'}</td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${u.verificationStatus == 'VERIFIED'}"><span class="ap-badge ap-badge-approved">VERIFIED</span></c:when>
                                          <c:when test="${u.verificationStatus == 'REJECTED'}"><span class="ap-badge ap-badge-rejected">REJECTED</span></c:when>
                                          <c:otherwise><span class="ap-badge ap-badge-pending">PENDING</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${u.banned}"><span class="ap-badge ap-badge-banned">BANNED</span></c:when>
                                          <c:otherwise><span class="ap-badge ap-badge-reverify">ACTIVE</span></c:otherwise>
                                      </c:choose>
                                  </td>
                                  <td>
                                      <div style="display:flex;gap:6px;align-items:center;">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="ap-btn-view"><i class="fas fa-user"></i> Profile</a>
                                        <c:choose>
                                            <c:when test="${u.banned}">
                                                <form action="${pageContext.request.contextPath}/admin/users/${u.id}/unban" method="post" class="m-0">
                                                    <button type="submit" class="ap-btn-action ap-btn-success"><i class="fas fa-unlock"></i> Unban</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/admin/users/${u.id}/ban" method="post" class="m-0">
                                                    <button type="submit" class="ap-btn-action ap-btn-warn"><i class="fas fa-ban"></i> Ban</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="ap-btn-action ap-btn-danger" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr><td colspan="7"><div class="ap-empty"><i class="fas fa-users fa-2x mb-2 d-block" style="opacity:.35;"></i>No users match your search.</div></td></tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </section>
      </c:if>

      <!-- ── Normal View (Tabs) ── -->
      <c:if test="${empty q}">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab active" href="javascript:void(0)" onclick="switchTab('pending')" id="tab-btn-pending">Pending Verifications (${pendingCount})</a>
            <a class="ap-tab" href="javascript:void(0)" onclick="switchTab('verified')" id="tab-btn-verified">Verified Users (${verifiedCount})</a>
            <a class="ap-tab" href="javascript:void(0)" onclick="switchTab('banned')" id="tab-btn-banned">Banned Users (${bannedCount})</a>
          </div>

          <!-- Pending Verifications Table -->
          <div id="tab-pane-pending" class="tab-pane">
            <div class="ap-table-wrap">
              <table class="ap-table">
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
                                  <td class="ap-muted">${u.id}</td>
                                  <td><div class="nm" style="font-weight:700;">${u.fullName}</div></td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '-'}</td>
                                  <td><code style="color:var(--ap-muted);background:#F1F5F9;padding:2px 6px;border-radius:4px;">${not empty u.identityDocument ? u.identityDocument : '-'}</code></td>
                                  <td>
                                      <div style="display:flex;gap:6px;align-items:center;">
                                          <form action="${pageContext.request.contextPath}/admin/users/${u.id}/approve" method="post" class="m-0">
                                              <button type="submit" class="ap-btn-action ap-btn-success-solid">
                                                  <i class="fas fa-check-circle me-1"></i> Verify
                                              </button>
                                          </form>
                                          <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject" method="post" class="m-0">
                                              <button type="submit" class="ap-btn-action ap-btn-danger">
                                                  <i class="fas fa-times-circle me-1"></i> Reject
                                              </button>
                                          </form>
                                          <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="ap-btn-view">
                                              <i class="fas fa-eye"></i> View
                                          </a>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr><td colspan="6"><div class="ap-empty"><i class="fas fa-users fa-2x mb-2 d-block" style="opacity:.35;"></i>No users in this queue.</div></td></tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Verified Users Table -->
          <div id="tab-pane-verified" class="tab-pane" style="display:none;">
            <div class="ap-table-wrap">
              <table class="ap-table">
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
                              <c:if test="${!u.banned}">
                              <tr>
                                  <td class="ap-muted">${u.id}</td>
                                  <td><div class="nm" style="font-weight:700;">${u.fullName}</div></td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '-'}</td>
                                  <td><span class="ap-badge ap-badge-approved">VERIFIED</span></td>
                                  <td>
                                      <div style="display:flex;gap:6px;align-items:center;">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="ap-btn-view"><i class="fas fa-user"></i> Profile</a>
                                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/ban" method="post" class="m-0">
                                            <button type="submit" class="ap-btn-action ap-btn-warn"><i class="fas fa-ban"></i> Ban</button>
                                        </form>
                                        <button class="ap-btn-action ap-btn-danger" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                              </c:if>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr><td colspan="6"><div class="ap-empty"><i class="fas fa-users fa-2x mb-2 d-block" style="opacity:.35;"></i>No users in this queue.</div></td></tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>

          <!-- Banned Users Table -->
          <div id="tab-pane-banned" class="tab-pane" style="display:none;">
            <div class="ap-table-wrap">
              <table class="ap-table">
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
                              <tr style="background-color: #FFF7F8;">
                                  <td class="ap-muted">${u.id}</td>
                                  <td><div class="nm" style="font-weight:700;">${u.fullName}</div></td>
                                  <td>${u.email}</td>
                                  <td>${not empty u.phoneNumber ? u.phoneNumber : '-'}</td>
                                  <td><span class="ap-badge ap-badge-banned">BANNED</span></td>
                                  <td>
                                      <div style="display:flex;gap:6px;align-items:center;">
                                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile" class="ap-btn-view"><i class="fas fa-user"></i> Profile</a>
                                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/unban" method="post" class="m-0">
                                            <button type="submit" class="ap-btn-action ap-btn-success"><i class="fas fa-unlock"></i> Unban</button>
                                        </form>
                                        <button class="ap-btn-action ap-btn-danger" onclick="confirmDelete(${u.id}, '${u.fullName}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                      </div>
                                  </td>
                              </tr>
                          </c:forEach>
                      </c:when>
                      <c:otherwise>
                          <tr><td colspan="6"><div class="ap-empty"><i class="fas fa-users fa-2x mb-2 d-block" style="opacity:.35;"></i>No users in this queue.</div></td></tr>
                      </c:otherwise>
                  </c:choose>
                  </tbody>
              </table>
            </div>
          </div>
        </section>
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
function switchTab(tabId) {
    document.querySelectorAll('.ap-tab').forEach(function(t) { t.classList.remove('active'); });
    document.getElementById('tab-btn-' + tabId).classList.add('active');
    document.querySelectorAll('.tab-pane').forEach(function(p) { p.style.display = 'none'; });
    document.getElementById('tab-pane-' + tabId).style.display = 'block';
}

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

var hs = document.getElementById('apHeaderSearch');
if (hs) {
  document.addEventListener('keydown', function (e) {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
      e.preventDefault();
      hs.focus();
    }
  });
  hs.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      var q = hs.value.trim();
      if (q) window.location.href = '${pageContext.request.contextPath}/admin/users?q=' + encodeURIComponent(q);
    }
  });
}
</script>

</body>
</html>
