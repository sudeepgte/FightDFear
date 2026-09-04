<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard - Job Applications</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
    /* Scoped to this Women Jobs admin page only — Martial Arts admin-portal language */
    body.wj-admin-jobs { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; }
    body.wj-admin-jobs .layout { display: flex; min-height: 100vh; }
    body.wj-admin-jobs .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    body.wj-admin-jobs .content { padding: 0; }
    body.wj-admin-jobs .mainInner { max-width: 1400px; margin: 0 auto; padding: 22px 24px 48px; }
    body.wj-admin-jobs .nav-tabs {
        display: flex; flex-wrap: wrap; gap: 4px; border: 0; border-bottom: 1px solid var(--ap-border);
        padding: 0 8px; margin-bottom: 0; background: var(--ap-card);
    }
    body.wj-admin-jobs .nav-tabs .nav-link {
        border: 0 !important; border-bottom: 2px solid transparent !important; border-radius: 0 !important;
        color: var(--ap-muted); font-weight: 600; font-size: 0.86rem; padding: 12px 14px; background: transparent;
        margin-bottom: -1px;
    }
    body.wj-admin-jobs .nav-tabs .nav-link:hover { color: var(--ap-text); background: transparent; }
    body.wj-admin-jobs .nav-tabs .nav-link.active {
        color: var(--ap-accent) !important; background: transparent !important;
        border-bottom-color: var(--ap-accent) !important; box-shadow: none;
    }
    body.wj-admin-jobs .tab-content { background: var(--ap-card); border: 1px solid var(--ap-border); border-top: 0;
        border-radius: 0 0 var(--ap-radius) var(--ap-radius); box-shadow: var(--ap-shadow); overflow: hidden; }
    body.wj-admin-jobs .table-responsive { overflow-x: auto; }
    body.wj-admin-jobs .table { margin-bottom: 0; min-width: 780px; }
    body.wj-admin-jobs .table thead th {
        text-align: left; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
        text-transform: uppercase; letter-spacing: 0.04em; padding: 12px 14px;
        border-bottom: 1px solid var(--ap-border); background: #FCFCFD; white-space: nowrap;
    }
    body.wj-admin-jobs .table tbody td {
        padding: 14px; border-bottom: 1px solid #F1F5F9; vertical-align: middle; font-size: 0.86rem; color: var(--ap-text);
    }
    body.wj-admin-jobs .table-hover > tbody > tr:hover > * { background: #FFF7F8; --bs-table-accent-bg: #FFF7F8; }
    body.wj-admin-jobs .badge-pending { background: #FEF3C7; color: #B45309; }
    body.wj-admin-jobs .badge-approved { background: var(--ap-success-bg); color: var(--ap-success); }
    body.wj-admin-jobs .badge-rejected { background: var(--ap-danger-bg); color: var(--ap-danger); }
    body.wj-admin-jobs .btn-success { background: var(--ap-success); border: 0; border-radius: 9px; font-weight: 700; color: #fff; }
    body.wj-admin-jobs .btn-danger { background: var(--ap-danger); border: 0; border-radius: 9px; font-weight: 700; color: #fff; }
    body.wj-admin-jobs .btn-info { background: #fff; color: var(--ap-text); border: 1px solid var(--ap-border); border-radius: 9px; font-weight: 600; }
    body.wj-admin-jobs .btn-info:hover { border-color: #FDA4AF; color: var(--ap-accent); background: #fff; }
    body.wj-admin-jobs .ap-filter-row { display: flex; flex-direction: row; align-items: center; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
    body.wj-admin-jobs .ap-filter-row .grow { flex: 1; min-width: 250px; }
    body.wj-admin-jobs .ap-filter-row .ap-input { margin-bottom: 0; width: 100%; height: 40px; }
    body.wj-admin-jobs .ap-filter-row .ap-btn { height: 40px; display: inline-flex; align-items: center; }
    body.wj-admin-jobs .wj-actions { display: flex; flex-wrap: nowrap; gap: 6px; align-items: center; }
    body.wj-admin-jobs .wj-actions form { display: inline-flex; margin: 0; }
    body.wj-admin-jobs .wj-actions .btn { height: 32px; padding: 4px 10px; font-size: 0.8rem; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; }
    body.wj-admin-jobs .table td.action-td { white-space: nowrap; }
    body.wj-admin-jobs .btn-outline-primary {
        background: #fff; color: var(--ap-text); border: 1px solid var(--ap-border); border-radius: 9px; font-weight: 600; white-space: nowrap;
    }
    body.wj-admin-jobs .btn-outline-primary:hover { border-color: #FDA4AF; color: var(--ap-accent); background: #fff; }
    body.wj-admin-jobs .modal-header { background: #fff; color: var(--ap-text); border-bottom: 1px solid var(--ap-border); }
    body.wj-admin-jobs .modal-header .btn-close { filter: none; }
    body.wj-admin-jobs .modal-title { color: var(--ap-text); font-weight: 700; }
    body.wj-admin-jobs .empty-row td { text-align: center; color: var(--ap-muted); padding: 36px 16px !important; background: #FCFCFD; }
    @media (max-width: 700px) {
        body.wj-admin-jobs .mainInner { padding: 16px 14px 40px; }
        body.wj-admin-jobs .ap-stats { grid-template-columns: 1fr !important; }
    }
</style>
</head>
<body class="ap-page wj-admin-jobs">
<c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>

    <div class="layout">
        <%@ include file="globalAdminMenu.jsp" %>

        <main class="main">
            <div class="ap-topbar topbar">
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
                <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${apAdmin.id}">
                  <span class="ap-avatar">
                    <c:choose>
                      <c:when test="${not empty apAdmin.profilePhoto}">
                        <img src="${pageContext.request.contextPath}${apAdmin.profilePhoto}" alt="">
                      </c:when>
                      <c:otherwise>${fn:substring(apAdmin.name,0,1)}</c:otherwise>
                    </c:choose>
                  </span>
                  <span>
                    <div class="name"><c:out value="${apAdmin.name}"/></div>
                    <div class="role">Super Admin</div>
                  </span>
                </a>
              </div>
            </div>

            <div class="content">
                <div class="container-fluid mainInner">
                    <nav class="ap-crumb">
                      <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
                      <span class="sep">&gt;</span>
                      <span>Women Jobs</span>
                    </nav>
                    <div class="ap-page-head">
                      <div class="ap-page-ico"><i class="fas fa-briefcase"></i></div>
                      <div>
                        <h1>Women Jobs — Worker Verification</h1>
                        <p>Review worker profiles before they appear to clients on Women Jobs.</p>
                      </div>
                    </div>
                    <div class="ap-stats" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
                      <div class="ap-stat amber">
                        <div class="ico"><i class="fas fa-clock"></i></div>
                        <div class="val">${pendingApplications.size()}</div>
                        <div class="lbl">Pending</div>
                        <div class="sub">Awaiting review</div>
                      </div>
                      <div class="ap-stat green">
                        <div class="ico"><i class="fas fa-check-circle"></i></div>
                        <div class="val">${approvedApplications.size()}</div>
                        <div class="lbl">Approved</div>
                        <div class="sub">Live on Women Jobs</div>
                      </div>
                      <div class="ap-stat rose">
                        <div class="ico"><i class="fas fa-times-circle"></i></div>
                        <div class="val">${rejectedApplications.size()}</div>
                        <div class="lbl">Rejected</div>
                        <div class="sub">Not listed</div>
                      </div>
                    </div>
                    <div class="ap-filter-row">
                      <div class="grow">
                        <input type="text" id="wjAdminSearch" class="ap-input" placeholder="Search name, email, category...">
                      </div>
                      <button type="button" class="ap-btn ap-btn-primary" id="wjAdminSearchBtn"><i class="fas fa-filter"></i> Search / Filter</button>
                      <button type="button" class="ap-btn ap-btn-ghost" id="wjAdminClearBtn"><i class="fas fa-times"></i> Clear</button>
                    </div>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="ap-panel">
                    <ul class="nav nav-tabs mb-0" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="true">Pending (${pendingApplications.size()})</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved" type="button" role="tab" aria-controls="approved" aria-selected="false">Approved (${approvedApplications.size()})</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="rejected-tab" data-bs-toggle="tab" data-bs-target="#rejected" type="button" role="tab" aria-controls="rejected" aria-selected="false">Rejected (${rejectedApplications.size()})</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <!-- PENDING TAB -->
                        <div class="tab-pane fade show active" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Applicant Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Job Category</th>
                                            <th>Sub Category</th>
                                            <th>Rate</th>
                                            <th>Document</th>
                                            <th>Applied At</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="app" items="${pendingApplications}">
                                            <tr>
                                                <td>${app.user.fullName}</td>
                                                <td>${app.user.email}</td>
                                                <td>${app.user.phoneNumber}</td>
                                                <td><span class="badge badge-pending">${app.jobCategory}</span></td>
                                                <td>${app.jobSubCategory}</td>
                                                <td>Rs ${app.hourlyRate}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty app.documentPath}">
                                                            <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-file-earmark-text"></i> View Proof
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">No document</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${app.appliedAt.toLocalDate()}</td>
                                                <td class="action-td">
                                                    <div class="wj-actions">
                                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewModal${app.id}">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/approve" method="POST">
                                                        <button type="submit" class="btn btn-sm btn-success"><i class="bi bi-check-circle"></i> Approve</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/reject" method="POST">
                                                        <button type="submit" class="btn btn-sm btn-danger"><i class="bi bi-x-circle"></i> Reject</button>
                                                    </form>
                                                    </div>

                                                    <!-- View Modal -->
                                                    <div class="modal fade" id="viewModal${app.id}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content text-dark" style="white-space: normal;">
                                                                <div class="modal-header bg-light">
                                                                    <h5 class="modal-title">Application Details</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body text-start" style="font-size:0.9rem;">
                                                                    <p><strong>Name:</strong> ${app.user.fullName}</p>
                                                                    <p><strong>Email:</strong> ${app.user.email}</p>
                                                                    <p><strong>Phone:</strong> ${app.user.phoneNumber}</p>
                                                                    <hr>
                                                                    <p><strong>Job Category:</strong> ${app.jobCategory}</p>
                                                                    <p><strong>Specific Job:</strong> ${app.jobSubCategory}</p>
                                                                    <p><strong>Hourly rate:</strong> Rs ${app.hourlyRate}</p>
                                                                    <p><strong>Applied At:</strong> ${app.appliedAt}</p>
                                                                    <c:if test="${not empty app.note}">
                                                                        <hr>
                                                                        <p><strong>Profile details:</strong></p>
                                                                        <pre style="white-space:pre-wrap; font-family:inherit; font-size:0.85rem; background:#f8fafc; padding:10px; border-radius:8px;">${app.note}</pre>
                                                                    </c:if>
                                                                    <hr>
                                                                    <c:choose>
                                                                        <c:when test="${not empty app.documentPath}">
                                                                            <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-file-earmark-text"></i> Open Proof Document</a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">No proof document uploaded.</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty pendingApplications}">
                                            <tr class="empty-row"><td colspan="9">No pending applications found.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- APPROVED TAB -->
                        <div class="tab-pane fade" id="approved" role="tabpanel" aria-labelledby="approved-tab">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Applicant Name</th>
                                            <th>Email</th>
                                            <th>Job Category</th>
                                            <th>Sub Category</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="app" items="${approvedApplications}">
                                            <tr>
                                                <td>${app.user.fullName}</td>
                                                <td>${app.user.email}</td>
                                                <td>${app.jobCategory}</td>
                                                <td>${app.jobSubCategory}</td>
                                                <td><span class="badge badge-approved">Approved</span></td>
                                                <td class="action-td">
                                                    <div class="wj-actions">
                                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewModalApproved${app.id}">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/reject" method="POST">
                                                        <button type="submit" class="btn btn-sm btn-danger">Revoke (Reject)</button>
                                                    </form>
                                                    </div>

                                                    <!-- View Modal Approved -->
                                                    <div class="modal fade" id="viewModalApproved${app.id}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content text-dark" style="white-space: normal;">
                                                                <div class="modal-header bg-light">
                                                                    <h5 class="modal-title">Application Details (Approved)</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body text-start" style="font-size:0.9rem;">
                                                                    <p><strong>Name:</strong> ${app.user.fullName}</p>
                                                                    <p><strong>Email:</strong> ${app.user.email}</p>
                                                                    <p><strong>Phone:</strong> ${app.user.phoneNumber}</p>
                                                                    <hr>
                                                                    <p><strong>Job Category:</strong> ${app.jobCategory}</p>
                                                                    <p><strong>Specific Job:</strong> ${app.jobSubCategory}</p>
                                                                    <p><strong>Hourly rate:</strong> Rs ${app.hourlyRate}</p>
                                                                    <p><strong>Applied At:</strong> ${app.appliedAt}</p>
                                                                    <c:if test="${not empty app.note}">
                                                                        <hr>
                                                                        <p><strong>Profile details:</strong></p>
                                                                        <pre style="white-space:pre-wrap; font-family:inherit; font-size:0.85rem; background:#f8fafc; padding:10px; border-radius:8px;">${app.note}</pre>
                                                                    </c:if>
                                                                    <hr>
                                                                    <c:choose>
                                                                        <c:when test="${not empty app.documentPath}">
                                                                            <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-file-earmark-text"></i> Open Proof Document</a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">No proof document uploaded.</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty approvedApplications}">
                                            <tr class="empty-row"><td colspan="6">No approved workers yet.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- REJECTED TAB -->
                        <div class="tab-pane fade" id="rejected" role="tabpanel" aria-labelledby="rejected-tab">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Applicant Name</th>
                                            <th>Email</th>
                                            <th>Job Category</th>
                                            <th>Sub Category</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="app" items="${rejectedApplications}">
                                            <tr>
                                                <td>${app.user.fullName}</td>
                                                <td>${app.user.email}</td>
                                                <td>${app.jobCategory}</td>
                                                <td>${app.jobSubCategory}</td>
                                                <td><span class="badge badge-rejected">Rejected</span></td>
                                                <td class="action-td">
                                                    <div class="wj-actions">
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/approve" method="POST">
                                                        <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                                    </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty rejectedApplications}">
                                            <tr class="empty-row"><td colspan="6">No rejected applications.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    </div>

                </div>
            </div>
        </main>
    </div>

<script>
(function () {
  var input = document.getElementById('wjAdminSearch');
  var header = document.getElementById('apHeaderSearch');
  function apply() {
    var q = ((input && input.value) || '').toLowerCase().trim();
    document.querySelectorAll('.tab-pane table tbody tr').forEach(function (tr) {
      if (tr.classList.contains('empty-row')) return;
      tr.style.display = !q || tr.textContent.toLowerCase().indexOf(q) !== -1 ? '' : 'none';
    });
  }
  if (input) {
    document.getElementById('wjAdminSearchBtn') && document.getElementById('wjAdminSearchBtn').addEventListener('click', apply);
    document.getElementById('wjAdminClearBtn') && document.getElementById('wjAdminClearBtn').addEventListener('click', function () {
      input.value = ''; if (header) header.value = ''; apply();
    });
    input.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); apply(); } });
  }
  if (header) {
    document.addEventListener('keydown', function (e) {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') { e.preventDefault(); header.focus(); }
    });
    header.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') { e.preventDefault(); if (input) input.value = header.value; apply(); }
    });
  }
})();
</script>
</body>
</html>
