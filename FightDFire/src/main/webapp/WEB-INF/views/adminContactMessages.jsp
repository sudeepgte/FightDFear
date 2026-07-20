<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Contact Messages — Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --light-bg: #fffcfd;
        --dark-bg: #0f0f1a;
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --maroon: #1e1b4b;
        --maroon-light: #312e81;
        --maroon-dark: #0b0920;
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
        box-shadow: var(--shadow-sm);
    }
    .topbar .wrap {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }
    .topbar .title { font-size: 1.25rem; margin: 0; }
    .topbar .meta {
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .layout { display: flex; min-height: calc(100vh - 0px); }

    .sidebar {
        width: var(--sidebar-w);
        background: #fff;
        border-right: 1px solid var(--maroon-border);
        position: sticky;
        top: 58px;
        height: calc(100vh - 58px);
        padding: 14px 12px;
        overflow-y: auto;
        flex-shrink: 0;
        transition: all 0.3s ease;
    }
    .brand {
        font-size: 0.9rem;
        font-weight: 700;
        color: var(--maroon);
        padding: 10px 15px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    .sectionTitle {
        font-size: 0.7rem;
        font-weight: 700;
        color: #9ca3af;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin: 20px 15px 8px;
    }
    .navlink {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 15px;
        border-radius: 12px;
        color: #4b5563;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.9rem;
        transition: all 0.2s;
        margin-bottom: 2px;
    }
    .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
    .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
    .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
    .navlink.active i { color: #fff; }

    .main { flex: 1; min-width: 0; }
    .content { padding: 28px 16px 36px; }
    .mainInner { max-width: 1100px; margin: 0 auto; }

    .pg-header {
        background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
        border-radius: 16px;
        padding: 22px 28px;
        margin-bottom: 28px;
        box-shadow: 0 8px 28px rgba(125,42,90,0.22);
    }
    .pg-header h4 { color: #fff; font-weight: 700; font-size: 1.2rem; margin: 0; }
    .pg-header p { color: rgba(255,255,255,0.75); margin: 4px 0 0; font-size: 0.85rem; }

    .admin-card {
        background: #fff;
        border-radius: 16px;
        padding: 25px;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--maroon-border);
    }
    .table-responsive { border-radius: 12px; overflow: hidden; border: 1px solid var(--maroon-border); }
    table { width: 100%; border-collapse: collapse; background: #fff; margin: 0; }
    th {
        background: var(--maroon-pale);
        color: var(--maroon-dark);
        font-weight: 700;
        font-size: 0.8rem;
        text-transform: uppercase;
        padding: 14px 16px;
        border-bottom: 2px solid var(--maroon-border);
    }
    td { padding: 14px 16px; font-size: 0.92rem; border-bottom: 1px solid #f3f4f6; vertical-align: top; }
    tr.unread td { background: #fff9fb; }
    tr:last-child td { border-bottom: none; }
    .msg-preview { font-size: 0.85rem; color: #6b7280; margin-top: 4px; white-space: pre-wrap; }
    .badge-new { background: #fee2e2; color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 20px; }
    .badge-read { background: #e5e7eb; color: #4b5563; font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 20px; }
    .btn-mark, .btn-delete {
        border: none;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 0.8rem;
        font-weight: 600;
    }
    .btn-mark { background: var(--maroon-pale); color: var(--maroon); }
    .btn-mark:hover { background: var(--maroon); color: #fff; }
    .btn-delete { background: #fee2e2; color: #dc2626; }
    .btn-delete:hover { background: #dc2626; color: #fff; }

    .mobile-toggle {
        display: none;
        background: none;
        border: none;
        color: white;
        font-size: 1.25rem;
        cursor: pointer;
        padding: 5px;
        margin-right: 15px;
    }
    @media (max-width: 992px) {
        .mobile-toggle { display: block; }
        .layout { flex-direction: column; }
        .sidebar {
            position: fixed;
            left: -100%;
            top: 0;
            bottom: 0;
            z-index: 2000;
            width: 280px;
            height: 100vh;
            transition: left 0.3s ease;
            box-shadow: 10px 0 30px rgba(0,0,0,0.2);
            background: #fff;
            padding: 20px;
        }
        .sidebar.active { left: 0; }
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1500;
            backdrop-filter: blur(2px);
        }
        .sidebar-overlay.active { display: block; }
    }
</style>
</head>
<body>

    <div class="topbar">
        <div class="container">
            <div class="wrap">
                <div class="d-flex align-items-center">
                    <button class="mobile-toggle" id="sidebarToggle" type="button" aria-label="Open menu">
                        <i class="fas fa-bars"></i>
                    </button>
                    <p class="title mb-0">Fight D Fear Admin — Contact Messages</p>
                </div>
                <div class="meta">
                    <c:if test="${unreadContactMessages > 0}">
                        <span class="badge bg-light text-dark badge-pill">${unreadContactMessages} unread</span>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-sm btn-outline-light">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-light">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="layout">
        <%@ include file="globalAdminMenu.jsp" %>

        <main class="main">
            <div class="content">
                <div class="container mainInner">

                    <div class="pg-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div>
                            <h4><i class="fas fa-envelope me-2"></i>Contact Messages</h4>
                            <p>Messages submitted from the public contact form on the home page.</p>
                        </div>
                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="admin-card">
                        <c:choose>
                            <c:when test="${not empty contactMessages}">
                                <div class="table-responsive">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Status</th>
                                                <th>From</th>
                                                <th>Subject &amp; Message</th>
                                                <th>Sent</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cm" items="${contactMessages}">
                                                <tr class="${cm.readByAdmin ? '' : 'unread'}">
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${cm.readByAdmin}"><span class="badge-read">Read</span></c:when>
                                                            <c:otherwise><span class="badge-new">New</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight:600; color:var(--maroon-dark);">${cm.name}</div>
                                                        <div style="font-size:0.85rem;"><a href="mailto:${cm.email}">${cm.email}</a></div>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight:600;">${cm.subject}</div>
                                                        <div class="msg-preview">${cm.message}</div>
                                                    </td>
                                                    <td style="white-space:nowrap; font-size:0.85rem;">${cm.submittedAt}</td>
                                                    <td style="white-space:nowrap;">
                                                        <c:if test="${!cm.readByAdmin}">
                                                            <form action="${pageContext.request.contextPath}/admin/contact-messages/${cm.id}/read" method="post" class="d-inline">
                                                                <button type="submit" class="btn-mark"><i class="fas fa-check"></i> Mark read</button>
                                                            </form>
                                                        </c:if>
                                                        <form action="${pageContext.request.contextPath}/admin/contact-messages/delete/${cm.id}" method="post" class="d-inline"
                                                              onsubmit="return confirm('Delete this message?');">
                                                            <button type="submit" class="btn-delete"><i class="fas fa-trash-alt"></i></button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center p-5 text-muted">
                                    <i class="fas fa-inbox mb-2" style="font-size:2.5rem; color:#d1d5db;"></i>
                                    <p class="mb-0">No contact messages yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const toggleBtn = document.getElementById('sidebarToggle');
        const closeBtn = document.getElementById('closeSidebar');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        if (toggleBtn && sidebar && overlay) {
            toggleBtn.addEventListener('click', () => {
                sidebar.classList.add('active');
                overlay.classList.add('active');
            });
        }
        if (closeBtn && sidebar && overlay) {
            closeBtn.addEventListener('click', () => {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            });
        }
        if (overlay && sidebar) {
            overlay.addEventListener('click', () => {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            });
        }
        document.querySelectorAll('.sidebar a.navlink').forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 992 && sidebar && overlay) {
                    sidebar.classList.remove('active');
                    overlay.classList.remove('active');
                }
            });
        });
    </script>
</body>
</html>

