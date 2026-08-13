<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>User Verification</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <!-- Purpose: load Poppins (used by this page) + Montserrat (global headings) -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
    }

    body {
        background: var(--light-bg);
        font-family: 'Poppins', sans-serif;
        margin: 0;
    }

    .card-box {
        background: #fff;
        border-radius: 16px;
        padding: 25px;
        margin: 40px auto;
        max-width: 1100px;
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.2s;
    }
    .card-box:hover {
        box-shadow: var(--shadow-md);
    }

    h3 {
        text-align: center;
        color: var(--primary-purple);
        font-weight: 600;
        margin-bottom: 25px;
    }

    table {
        border-radius: 12px;
        overflow: hidden;
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: var(--gradient-primary);
        color: white;
    }

    th, td {
        text-align: center;
        vertical-align: middle;
        padding: 12px;
    }

    .btn-approve {
        background: var(--primary-teal);
        color: #fff;
        border-radius: 8px;
        font-size: 14px;
        border: none;
        transition: all 0.2s;
    }
    .btn-approve:hover {
        filter: brightness(0.9);
        transform: translateY(-1px);
    }

    .btn-reject {
        background: var(--primary-coral-dark);
        color: #fff;
        border-radius: 8px;
        font-size: 14px;
        border: none;
        transition: all 0.2s;
    }
    .btn-reject:hover {
        filter: brightness(0.9);
        transform: translateY(-1px);
    }

    .doc-link {
        color: var(--primary-purple-light);
        font-weight: 600;
        text-decoration: none;
        transition: color 0.2s;
    }
    .doc-link:hover {
        color: var(--primary-purple);
        text-decoration: underline;
    }

    .empty-msg {
        text-align: center;
        color: rgba(74, 14, 120, 0.6);
        font-style: italic;
    }

    .status-pill {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        display: inline-block;
        color: #fff;
    }

    .status-verified {
        background: var(--primary-teal);
    }

    .status-rejected {
        background: var(--primary-coral-dark);
    }

    .btn-view-profile {
        background: linear-gradient(135deg, var(--primary-purple), var(--primary-purple-light));
        color: #fff !important;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        border: none;
        padding: 5px 12px;
        text-decoration: none;
        transition: all 0.2s;
        display: inline-block;
    }
    .btn-view-profile:hover {
        filter: brightness(0.88);
        transform: translateY(-1px);
        color: #fff;
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the card box */
    .card-box {
        animation: slideUpFade 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes slideUpFade {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Table row hover effect – subtle scale and shadow */
    table tbody tr {
        transition: all 0.2s cubic-bezier(0.2, 0.9, 0.4, 1.1);
    }
    table tbody tr:hover {
        transform: scale(1.01);
        box-shadow: var(--shadow-sm);
    }

    /* 3. Button ripple effect on click (micro-interaction) */
    .btn-approve, .btn-reject {
        position: relative;
        overflow: hidden;
    }
    .btn-approve::after, .btn-reject::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-approve:active::after, .btn-reject:active::after {
        width: 200px;
        height: 200px;
    }

    /* 4. Additional hover lift for buttons (preserve original brightness change) */
    .btn-approve:hover, .btn-reject:hover {
        transform: translateY(-2px);
    }

    /* 5. Focus outlines for accessibility (keyboard navigation) */
    .btn-approve:focus-visible, .btn-reject:focus-visible, .doc-link:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 6px;
    }

    /* 6. Custom scrollbar (matches brand colors) */
    ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 7. Status pill hover effect */
    .status-pill {
        transition: all 0.2s;
    }
    .status-pill:hover {
        transform: scale(1.05);
        filter: brightness(0.95);
    }

    /* 8. Document link underline animation */
    .doc-link {
        position: relative;
        display: inline-block;
    }
    .doc-link::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 0%;
        height: 2px;
        background: var(--primary-purple);
        transition: width 0.2s;
    }
    .doc-link:hover::after {
        width: 100%;
    }

    /* 9. Responsive touch improvements for mobile */
    @media (max-width: 768px) {
        .card-box {
            padding: 15px;
            margin: 20px 15px;
        }
        .btn-approve, .btn-reject {
            padding: 8px 16px;
            font-size: 12px;
        }
        th, td {
            padding: 8px 6px;
            font-size: 12px;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .card-box.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }

    /* ── Search Bar ── */
    .search-wrap {
        display: flex;
        gap: 10px;
        align-items: center;
        margin-bottom: 24px;
        flex-wrap: wrap;
    }
    .search-input {
        flex: 1;
        min-width: 220px;
        padding: 10px 18px;
        border: 2px solid rgba(123,44,191,0.25);
        border-radius: 30px;
        font-family: 'Poppins', sans-serif;
        font-size: 0.92rem;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
        background: #faf7ff;
    }
    .search-input:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123,44,191,0.12);
    }
    .btn-search {
        background: var(--gradient-primary);
        color: #fff;
        border: none;
        border-radius: 30px;
        padding: 10px 24px;
        font-size: 0.9rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        white-space: nowrap;
    }
    .btn-search:hover {
        filter: brightness(0.9);
        transform: translateY(-1px);
    }
    .btn-clear {
        color: var(--primary-coral-dark);
        font-size: 0.85rem;
        font-weight: 600;
        text-decoration: none;
        padding: 8px 14px;
        border-radius: 20px;
        border: 2px solid var(--primary-coral-dark);
        transition: all 0.2s;
        white-space: nowrap;
    }
    .btn-clear:hover {
        background: var(--primary-coral-dark);
        color: #fff;
    }
    .search-results-banner {
        background: linear-gradient(135deg, #f3e8ff, #e8f5ff);
        border-left: 4px solid var(--primary-purple-light);
        border-radius: 10px;
        padding: 12px 18px;
        margin-bottom: 18px;
        font-size: 0.9rem;
        color: var(--primary-purple);
        font-weight: 600;
    }
</style>
</head>

<body>
<div class="card-box">
    <h3>User Verification (Admin)</h3>

    <!-- Purpose: surface flash messages after verify/reject actions. -->
    <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
    </c:if>

    <!-- ── Server-Side Search Bar ── -->
    <form method="get" action="${pageContext.request.contextPath}/admin/pending-users" class="search-wrap">
        <input type="text"
               id="userSearchInput"
               name="q"
               class="search-input"
               placeholder="🔍 Search by name, email or phone..."
               value="${not empty q ? q : ''}">
        <button type="submit" class="btn-search">Search</button>
        <c:if test="${not empty q}">
            <a href="${pageContext.request.contextPath}/admin/pending-users" class="btn-clear">✕ Clear</a>
        </c:if>
    </form>

    <!-- ── Search Results (only shown when ?q= is active) ── -->
    <c:if test="${not empty q}">
        <div class="search-results-banner">
            Showing results for &quot;<strong>${q}</strong>&quot; &nbsp;—&nbsp;
            <c:choose>
                <c:when test="${not empty searchResults}">${searchResults.size()} user(s) found</c:when>
                <c:otherwise>No users found</c:otherwise>
            </c:choose>
        </div>

        <c:choose>
            <c:when test="${not empty searchResults}">
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${searchResults}">
                        <tr>
                            <td>${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.verificationStatus == 'VERIFIED'}">
                                        <span class="status-pill status-verified">VERIFIED</span>
                                    </c:when>
                                    <c:when test="${u.verificationStatus == 'REJECTED'}">
                                        <span class="status-pill status-rejected">REJECTED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill" style="background:#f59e0b;">PENDING</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile"
                                   class="btn btn-sm btn-view-profile">&#128100; Profile</a>
                                <c:if test="${u.verificationStatus != 'VERIFIED'}">
                                    <form action="${pageContext.request.contextPath}/admin/users/${u.id}/verify"
                                          method="post" style="display:inline-block;">
                                        <button class="btn btn-approve btn-sm" type="submit">Verify</button>
                                    </form>
                                </c:if>
                                <c:if test="${u.verificationStatus != 'REJECTED'}">
                                    <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject"
                                          method="post" style="display:inline-block;">
                                        <button class="btn btn-reject btn-sm" type="submit">Reject</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="empty-msg">No users match your search. <a href="${pageContext.request.contextPath}/admin/pending-users">Clear search</a></p>
            </c:otherwise>
        </c:choose>
    </c:if>

    <!-- ── Normal Three-Section View (hidden during search) ── -->
    <c:if test="${empty q}">

    <h5 class="mb-3">Pending Users</h5>
    <c:if test="${empty pending}">
        <p class="empty-msg">No pending users.</p>
    </c:if>
    <c:if test="${not empty pending}">
        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Identity Doc</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${pending}">
                <tr>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phoneNumber}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty u.identityDocument}">
                                <a class="doc-link" target="_blank"
                                   href="${pageContext.request.contextPath}${u.identityDocument}">View</a>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${u.verificationStatus}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile"
                           class="btn btn-sm btn-view-profile" title="View Full Profile">&#128100; Profile</a>
                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/verify"
                              method="post" style="display:inline-block;">
                            <button class="btn btn-approve btn-sm" type="submit">Verify</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject"
                              method="post" style="display:inline-block;">
                            <button class="btn btn-reject btn-sm" type="submit">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <hr>

    <h5 class="mb-3" style="color:#28a745;">Verified Users</h5>
    <c:if test="${empty verified}">
        <p class="empty-msg">No verified users.</p>
    </c:if>
    <c:if test="${not empty verified}">
        <table class="table table-bordered table-hover">
            <thead style="background:#28a745;">
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${verified}">
                <tr>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td><span class="status-pill status-verified">VERIFIED</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile"
                           class="btn btn-sm btn-view-profile">&#128100; Profile</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <hr>

    <h5 class="mb-3" style="color:#dc3545;">Rejected Users</h5>
    <c:if test="${empty rejected}">
        <p class="empty-msg">No rejected users.</p>
    </c:if>
    <c:if test="${not empty rejected}">
        <table class="table table-bordered table-hover">
            <thead style="background:#dc3545;">
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${rejected}">
                <tr>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td><span class="status-pill status-rejected">REJECTED</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/users/${u.id}/profile"
                           class="btn btn-sm btn-view-profile">&#128100; Profile</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    </c:if><!-- end empty q -->

</div>
</body>
</html>

