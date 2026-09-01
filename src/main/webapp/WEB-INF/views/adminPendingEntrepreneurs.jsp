<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Entrepreneur Management | Fight D Fear Admin Portal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-dark: #0f0d26;
            --navy-primary: #1e1b4b;
            --navy-light: #312e81;
            --rose-primary: #f43f5e;
            --rose-light: #ffe4e6;
            --card-bg: #ffffff;
            --page-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            background-color: var(--page-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
            margin: 0;
            padding-bottom: 60px;
        }

        /* Topbar */
        .admin-topbar {
            background: var(--navy-primary);
            color: white;
            padding: 14px 24px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .admin-topbar .brand {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 700;
        }

        .admin-topbar .brand img {
            height: 32px;
            width: 32px;
            border-radius: 8px;
            object-fit: cover;
        }

        .container-main {
            max-width: 1240px;
            margin: 28px auto 0;
            padding: 0 16px;
        }

        /* Header banner */
        .page-header-banner {
            background: linear-gradient(135deg, var(--navy-primary) 0%, var(--navy-light) 60%, var(--rose-primary) 100%);
            border-radius: 20px;
            padding: 28px 32px;
            color: white;
            box-shadow: 0 10px 25px rgba(30, 27, 75, 0.15);
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }

        .page-header-banner h1 {
            font-size: 1.6rem;
            font-weight: 800;
            margin: 0 0 4px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header-banner p {
            margin: 0;
            color: rgba(255,255,255,0.8);
            font-size: 0.92rem;
        }

        /* Section Card */
        .table-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 16px rgba(0,0,0,0.04);
            padding: 24px;
            margin-bottom: 28px;
        }

        .table-card-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--navy-primary);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-custom {
            width: 100%;
            vertical-align: middle;
        }

        .table-custom th {
            font-size: 0.76rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
            background: #f8fafc;
            padding: 14px 16px;
            border-bottom: 2px solid var(--border-color);
        }

        .table-custom td {
            padding: 16px;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border-color);
        }

        .badge-status-sm {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
            text-transform: uppercase;
        }

        .status-APPROVED { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .status-CHANGES_REQUESTED { background: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; }
        .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        .btn-profile-view {
            background: #ffffff;
            color: var(--navy-primary);
            border: 1px solid #cbd5e1;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-profile-view:hover {
            background: var(--navy-primary);
            color: white;
            border-color: var(--navy-primary);
        }

        .btn-approve-sm {
            background: #10b981;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-approve-sm:hover { background: #059669; color: white; }

        .btn-reject-sm {
            background: #ef4444;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-reject-sm:hover { background: #dc2626; color: white; }
    </style>
</head>
<body>

    <!-- Topbar -->
    <header class="admin-topbar">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear Admin Portal</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-sm btn-outline-light">
                <i class="bi bi-speedometer2 me-1"></i> Admin Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-outline-light">
                <i class="bi bi-box-arrow-right"></i> Sign Out
            </a>
        </div>
    </header>

    <div class="container-main">

        <!-- Flash messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- BANNER -->
        <div class="page-header-banner">
            <div>
                <h1><i class="bi bi-briefcase-fill"></i> Entrepreneur Management</h1>
                <p>Review partnership requests, profile completion details, and manage verified entrepreneur profiles</p>
            </div>
            <div>
                <span class="badge bg-white text-dark fw-bold px-3 py-2 fs-6">
                    <i class="bi bi-clock-history text-warning me-1"></i> ${pendingCount} Pending Requests
                </span>
            </div>
        </div>

        <!-- PENDING REQUESTS TABLE -->
        <div class="table-card">
            <div class="table-card-title text-warning">
                <i class="bi bi-clock-fill"></i> Pending Requests
            </div>
            <div class="table-responsive">
                <table class="table table-custom">
                    <thead>
                        <tr>
                            <th>Entrepreneur Name</th>
                            <th>Status</th>
                            <th>Business / Category</th>
                            <th>Location</th>
                            <th>Contact</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty pendingEntrepreneurs}">
                                <c:forEach var="e" items="${pendingEntrepreneurs}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${e.fullName}"/></div>
                                            <div class="small text-muted"><c:out value="${e.email}"/></div>
                                        </td>
                                        <td>
                                            <span class="badge-status-sm status-${e.partnerProfileStatus != null ? e.partnerProfileStatus : 'PENDING'}">
                                                ${e.partnerProfileStatus != null ? e.partnerProfileStatus : 'PENDING'}
                                            </span>
                                            <div class="small text-muted mt-1">${e.profileCompletionPct != null ? e.profileCompletionPct : 0}% Complete</div>
                                        </td>
                                        <td>
                                            <div class="fw-semibold"><c:out value="${not empty e.businessName ? e.businessName : 'Venture Pending'}"/></div>
                                            <div class="small text-muted"><c:out value="${not empty e.businessCategory ? e.businessCategory : 'General'}"/></div>
                                        </td>
                                        <td>
                                            <c:out value="${not empty e.city ? e.city : (not empty e.businessLocation ? e.businessLocation : 'Not specified')}"/>
                                        </td>
                                        <td>
                                            <div><c:out value="${not empty e.phone ? e.phone : 'Not provided'}"/></div>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-inline-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/entrepreneurs/about/${e.id}" class="btn-profile-view">
                                                    <i class="bi bi-person-fill"></i> Profile
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/approve" method="post" class="m-0">
                                                    <button type="submit" class="btn-approve-sm" onclick="return confirm('Approve entrepreneur ${e.fullName}?');">
                                                        <i class="bi bi-check-lg"></i> Approve
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/reject" method="post" class="m-0">
                                                    <button type="submit" class="btn-reject-sm" onclick="return confirm('Reject entrepreneur ${e.fullName}?');">
                                                        <i class="bi bi-x-lg"></i> Reject
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="bi bi-check-circle fs-3 d-block mb-2 text-success"></i>
                                        No pending entrepreneur applications awaiting approval.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ALL ENTREPRENEURS TABLE -->
        <div class="table-card">
            <div class="table-card-title text-primary">
                <i class="bi bi-people-fill"></i> All Entrepreneurs
            </div>
            <div class="table-responsive">
                <table class="table table-custom">
                    <thead>
                        <tr>
                            <th>Entrepreneur Name</th>
                            <th>Status</th>
                            <th>Business Details</th>
                            <th>Location</th>
                            <th>Investment Needed</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty allEntrepreneurs}">
                                <c:forEach var="e" items="${allEntrepreneurs}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${e.fullName}"/></div>
                                            <div class="small text-muted"><c:out value="${e.email}"/></div>
                                        </td>
                                        <td>
                                            <span class="badge-status-sm status-${e.partnerProfileStatus != null ? e.partnerProfileStatus : 'REGISTERED'}">
                                                ${e.partnerProfileStatus != null ? e.partnerProfileStatus : 'REGISTERED'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="fw-semibold"><c:out value="${not empty e.businessName ? e.businessName : 'Not specified'}"/></div>
                                            <div class="small text-muted"><c:out value="${not empty e.businessCategory ? e.businessCategory : 'General'}"/></div>
                                        </td>
                                        <td><c:out value="${not empty e.city ? e.city : e.businessLocation}"/></td>
                                        <td><span class="fw-bold text-success">₹<c:out value="${e.investmentNeeded != null ? e.investmentNeeded : 0}"/></span></td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/entrepreneurs/about/${e.id}" class="btn-profile-view">
                                                <i class="bi bi-person-fill"></i> Profile
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No entrepreneurs registered yet.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
