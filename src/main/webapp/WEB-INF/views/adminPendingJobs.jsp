<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<style>
    /* Page-scoped Martial Arts 60/30/10 theme — this JSP only */
    body.wj-admin-jobs {
        --maroon: #1e1b4b;
        --maroon-light: #312e81;
        --maroon-dark: #0b0920;
        --maroon-pale: #f8fafc;
        --maroon-border: rgba(30, 27, 75, 0.12);
        --rose: #f43f5e;
        --rose-mid: #c04b7a;
        --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
        --sidebar-w: 272px;
        font-family: 'Poppins', 'Inter', sans-serif;
        margin: 0;
        background: var(--maroon-pale);
        color: #1a1a2e;
    }

    body.wj-admin-jobs .topbar {
        background: #F43F5E;
        color: #fff;
        padding: 0 20px;
        height: 58px;
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 3px 16px rgba(125,42,90,0.28);
        display: flex;
        align-items: center;
    }
    body.wj-admin-jobs .topbar .container-fluid { width: 100%; }
    body.wj-admin-jobs .topbar .wrap {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        min-height: 58px;
    }
    body.wj-admin-jobs .topbar .btn-light {
        background: rgba(255,255,255,0.15);
        color: #fff;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 7px;
        font-weight: 600;
    }
    body.wj-admin-jobs .topbar .btn-light:hover {
        background: rgba(255,255,255,0.25);
        color: #fff;
    }

    body.wj-admin-jobs .layout {
        display: flex;
        min-height: calc(100vh - 58px);
    }
    body.wj-admin-jobs .sidebar {
        width: var(--sidebar-w); background: #fff;
        border-right: 1px solid var(--maroon-border);
        position: sticky; top: 58px; height: calc(100vh - 58px);
        padding: 14px 12px; overflow-y: auto; flex-shrink: 0;
    }
    body.wj-admin-jobs .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
    body.wj-admin-jobs .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
    body.wj-admin-jobs .navlink {
        display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
        color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
    }
    body.wj-admin-jobs .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
    body.wj-admin-jobs .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
    body.wj-admin-jobs .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
    body.wj-admin-jobs .navlink.active i { color: #fff; }

    body.wj-admin-jobs .main { flex: 1; min-width: 0; }
    body.wj-admin-jobs .content { padding: 28px 20px 48px; }
    body.wj-admin-jobs .mainInner { max-width: 1200px; margin: 0 auto; }

    body.wj-admin-jobs .pg-header {
        background: linear-gradient(135deg, #1e1b4b 0%, #581c87 38%, #c04b7a 78%, #f43f5e 100%);
        border-radius: 16px;
        padding: 22px 28px;
        margin-bottom: 24px;
        box-shadow: 0 8px 28px rgba(125,42,90,0.22);
    }
    body.wj-admin-jobs .pg-header h2 { color: #fff; font-weight: 700; font-size: 1.2rem; margin: 0; }
    body.wj-admin-jobs .pg-header p { color: rgba(255,255,255,0.7); margin: 4px 0 0; font-size: 0.85rem; }

    body.wj-admin-jobs .nav-tabs { border: none; gap: 8px; }
    body.wj-admin-jobs .nav-tabs .nav-link {
        border: 1px solid var(--maroon-border);
        border-radius: 10px !important;
        color: var(--maroon-dark);
        font-weight: 700;
        font-size: 0.85rem;
        padding: 10px 16px;
        background: #fff;
    }
    body.wj-admin-jobs .nav-tabs .nav-link:hover {
        border-color: var(--rose);
        color: var(--rose);
        background: #fff;
    }
    body.wj-admin-jobs .nav-tabs .nav-link.active {
        background: var(--rose);
        color: #fff;
        border-color: var(--rose);
        box-shadow: 0 4px 12px rgba(244,63,94,0.28);
    }

    body.wj-admin-jobs .table-responsive {
        background: #fff;
        border-radius: 16px;
        padding: 0;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--maroon-border);
        overflow-x: auto;
    }
    body.wj-admin-jobs .table { margin-bottom: 0; }
    body.wj-admin-jobs .table > thead.table-light > tr > th,
    body.wj-admin-jobs .table thead th {
        background: rgba(125,42,90,0.03);
        color: var(--maroon-dark);
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        padding: 16px;
        border: none;
        border-bottom: 1px solid var(--maroon-border);
    }
    body.wj-admin-jobs .table tbody td {
        padding: 16px;
        vertical-align: middle;
        font-size: 0.9rem;
        border-bottom: 1px solid var(--maroon-border);
        color: #1a1a2e;
    }
    body.wj-admin-jobs .table tbody tr:last-child td { border-bottom: none; }
    body.wj-admin-jobs .table-hover > tbody > tr:hover > * {
        background: rgba(125,42,90,0.02);
        --bs-table-accent-bg: rgba(125,42,90,0.02);
    }

    body.wj-admin-jobs .badge {
        padding: 6px 12px;
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 700;
    }
    body.wj-admin-jobs .badge-pending { background: #FFF7ED; color: #C2410C; border: 1px solid #FFEDD5; }
    body.wj-admin-jobs .badge-approved { background: #f0fdf4; color: #166534; border: 1px solid #dcfce7; }
    body.wj-admin-jobs .badge-rejected { background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; }

    body.wj-admin-jobs .btn-success {
        background: #059669;
        border: none;
        border-radius: 8px;
        font-weight: 700;
        color: #fff;
    }
    body.wj-admin-jobs .btn-success:hover { background: #047857; color: #fff; }
    body.wj-admin-jobs .btn-danger {
        background: #dc2626;
        border: none;
        border-radius: 8px;
        font-weight: 700;
        color: #fff;
    }
    body.wj-admin-jobs .btn-danger:hover { background: #b91c1c; color: #fff; }
    body.wj-admin-jobs .btn-info {
        background: var(--maroon);
        border: none;
        border-radius: 8px;
        font-weight: 700;
    }
    body.wj-admin-jobs .btn-info:hover { background: #3b0764; color: #fff; }
    body.wj-admin-jobs .wj-actions {
        display: flex;
        flex-direction: column;
        align-items: stretch;
        gap: 8px;
        min-width: 138px;
    }
    body.wj-admin-jobs .wj-actions form {
        display: block;
        margin: 0;
        width: 100%;
    }
    body.wj-admin-jobs .wj-actions .btn {
        width: 100%;
        height: 36px;
        margin: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        white-space: nowrap;
        border-radius: 8px;
        box-sizing: border-box;
    }
    body.wj-admin-jobs .btn-outline-primary {
        background: #fdf2f8;
        color: var(--maroon);
        border: 1px solid rgba(244,63,94,0.35);
        border-radius: 8px;
        font-weight: 700;
    }
    body.wj-admin-jobs .btn-outline-primary:hover {
        background: var(--rose);
        color: #fff;
        border-color: var(--rose);
    }
    body.wj-admin-jobs .modal-header {
        background: var(--maroon);
        color: #fff;
        border-bottom: none;
    }
    body.wj-admin-jobs .modal-header .btn-close { filter: invert(1); }
    body.wj-admin-jobs .modal-title { color: #fff; font-weight: 700; }
    body.wj-admin-jobs .empty-row td {
        text-align: center;
        color: #64748B;
        padding: 40px 16px !important;
        background: var(--maroon-pale);
        font-weight: 500;
    }
    @media (max-width: 992px) {
        body.wj-admin-jobs .layout { flex-direction: column; display: block; }
        body.wj-admin-jobs .sidebar { display: none !important; }
        body.wj-admin-jobs .content { padding: 20px 15px; }
        body.wj-admin-jobs .pg-header { padding: 18px; }
        body.wj-admin-jobs .topbar { padding: 0 15px; }
    }
</style>
</head>
<body class="wj-admin-jobs">

    <!-- Topbar -->
    <div class="topbar">
        <div class="container-fluid">
            <div class="wrap">
                <div class="d-flex align-items-center">
                    <p class="title mb-0" style="font-size: 1.25rem;">Fight D Fear Admin Dashboard</p>
                </div>
                <div class="meta">
                    <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-light">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Content -->
    <div class="layout">
        <!-- Sidebar -->
        <%@ include file="globalAdminMenu.jsp" %>

        <!-- Main -->
        <main class="main">
            <div class="content">
                <div class="container-fluid mainInner">
                    
                    <div class="pg-header">
                        <h2>Women Jobs — Worker Verification</h2>
                        <p>Review worker profiles before they appear to clients on Women Jobs.</p>
                    </div>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
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
                                                <td>
                                                    <div class="wj-actions">
                                                    <button type="button" class="btn btn-sm btn-info text-white" data-bs-toggle="modal" data-bs-target="#viewModal${app.id}">
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
                                                <td>
                                                    <div class="wj-actions">
                                                    <button type="button" class="btn btn-sm btn-info text-white" data-bs-toggle="modal" data-bs-target="#viewModalApproved${app.id}">
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
                                                <td>
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
        </main>
    </div>

</body>
</html>
