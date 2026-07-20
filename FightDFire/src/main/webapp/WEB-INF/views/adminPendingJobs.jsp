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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<style>
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --maroon: #1e1b4b;
        --maroon-light: #312e81;
        --maroon-pale: #f8fafc;
        --maroon-border: rgba(30, 27, 75, 0.12);
        --sidebar-w: 272px;
    }

    body {
        font-family: 'Poppins', sans-serif;
        margin: 0;
        background: linear-gradient(180deg, var(--light-bg) 0%, #f5f5f5 100%);
        color: var(--dark-bg);
    }

    .topbar {
        background: var(--primary-purple);
        color: white;
        padding: 14px 18px;
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    }

    .topbar .wrap {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .layout {
        display: flex;
        min-height: calc(100vh - 58px);
    }

    .sidebar {
        width: var(--sidebar-w); background:#fff;
        border-right:1px solid var(--maroon-border);
        position:sticky; top:58px; height:calc(100vh - 58px);
        padding:14px 12px; overflow-y:auto; flex-shrink:0;
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

    .main {
        flex: 1;
        min-width: 0;
    }

    .content {
        padding: 28px 16px 36px;
    }

    .mainInner {
        max-width: 1100px;
        margin: 0 auto;
    }

    .table-responsive { background: white; border-radius: 15px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
    .badge-pending { background-color: #ffc107; color: #000; }
    .badge-approved { background-color: #198754; color: #fff; }
    .badge-rejected { background-color: #dc3545; color: #fff; }
</style>
</head>
<body>

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
                    
                    <h2 class="mb-4" style="font-weight: 700; color: var(--primary-purple);">Manage Job Applications</h2>

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
                                                <td><span class="badge bg-info text-dark">${app.jobCategory}</span></td>
                                                <td>${app.jobSubCategory}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-file-earmark-text"></i> View Proof
                                                    </a>
                                                </td>
                                                <td>${app.appliedAt.toLocalDate()}</td>
                                                <td>
                                                    <button type="button" class="btn btn-sm btn-info text-white" data-bs-toggle="modal" data-bs-target="#viewModal${app.id}">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/approve" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-success"><i class="bi bi-check-circle"></i> Approve</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/reject" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-danger"><i class="bi bi-x-circle"></i> Reject</button>
                                                    </form>

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
                                                                    <p><strong>Applied At:</strong> ${app.appliedAt}</p>
                                                                    <hr>
                                                                    <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-file-earmark-text"></i> Open Proof Document</a>
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
                                            <tr><td colspan="8" class="text-center">No pending applications found.</td></tr>
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
                                                    <button type="button" class="btn btn-sm btn-info text-white" data-bs-toggle="modal" data-bs-target="#viewModalApproved${app.id}">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/reject" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-danger">Revoke (Reject)</button>
                                                    </form>

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
                                                                    <p><strong>Applied At:</strong> ${app.appliedAt}</p>
                                                                    <hr>
                                                                    <a href="${pageContext.request.contextPath}${app.documentPath}" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-file-earmark-text"></i> Open Proof Document</a>
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
                                                    <form action="${pageContext.request.contextPath}/admin/job-applications/${app.id}/approve" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
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
