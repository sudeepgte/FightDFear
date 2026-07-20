<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Broadcast Center — Admin</title>
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
  .mainInner { max-width:1100px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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

  /* ── CARDS ── */
  .admin-card {
      background: #fff;
      border-radius: 16px;
      padding: 25px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--maroon-border);
      margin-bottom: 25px;
  }
  .admin-card .card-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--maroon-dark);
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
  }
  .admin-card .card-title i { color: var(--maroon); }

  /* ── FORM ── */
  .form-control, .form-select {
      border-radius: 10px;
      border: 1px solid #d1d5db;
      padding: 12px 16px;
      font-size: 0.95rem;
      transition: all 0.2s;
  }
  .form-control:focus, .form-select:focus {
      border-color: var(--maroon);
      box-shadow: 0 0 0 4px rgba(125,42,90,0.1);
  }
  .form-label {
      font-weight: 600;
      font-size: 0.85rem;
      color: #374151;
      margin-bottom: 6px;
      text-transform: uppercase;
      letter-spacing: 0.03em;
  }
  .btn-submit {
      background: var(--maroon);
      color: #fff;
      border: none;
      padding: 12px 24px;
      border-radius: 10px;
      font-weight: 600;
      font-size: 1rem;
      transition: all 0.2s;
      width: 100%;
  }
  .btn-submit:hover { background: var(--maroon-dark); transform: translateY(-2px); }

  /* ── TABLE ── */
  .table-responsive {
      border-radius: 12px;
      overflow: hidden;
      border: 1px solid var(--maroon-border);
  }
  table { width: 100%; border-collapse: collapse; background: #fff; margin: 0; }
  th {
      background: var(--maroon-pale);
      color: var(--maroon-dark);
      font-weight: 700;
      font-size: 0.85rem;
      text-transform: uppercase;
      padding: 14px 16px;
      border-bottom: 2px solid var(--maroon-border);
  }
  td {
      padding: 14px 16px;
      font-size: 0.95rem;
      border-bottom: 1px solid #f3f4f6;
      vertical-align: middle;
      color: #374151;
  }
  tr:last-child td { border-bottom: none; }
  
  .badge-type {
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 700;
  }
  .badge-INFO { background: #e0f2fe; color: #0284c7; }
  .badge-WARNING { background: #fef08a; color: #854d0e; }
  .badge-ALERT { background: #fee2e2; color: #b91c1c; }

  .btn-delete {
      background: #fee2e2;
      color: #dc2626;
      border: none;
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 600;
      transition: all 0.2s;
  }
  .btn-delete:hover { background: #dc2626; color: #fff; }

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
          <h4><i class="fas fa-bullhorn me-2"></i>Broadcast Center</h4>
          <p>Send global push notifications, announcements, and safety alerts to all users.</p>
        </div>
      </div>

      <c:if test="${not empty successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="fas fa-check-circle me-1"></i> ${successMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
      </c:if>
      
      <c:if test="${not empty error}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-circle me-1"></i> ${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
      </c:if>

      <div class="row">
          <div class="col-lg-5">
              <!-- Send Broadcast Form -->
              <div class="admin-card">
                  <div class="card-title"><i class="fas fa-paper-plane"></i> Send New Broadcast</div>
                  <form action="${pageContext.request.contextPath}/admin/broadcast/send" method="post">
                      <div class="mb-3">
                          <label class="form-label">Broadcast Type</label>
                          <select name="type" class="form-select" required>
                              <option value="INFO">General Info / Update</option>
                              <option value="WARNING">Warning / Notice</option>
                              <option value="ALERT">Critical Safety Alert</option>
                          </select>
                      </div>
                      <div class="mb-3">
                          <label class="form-label">Title / Headline</label>
                          <input type="text" name="title" class="form-control" placeholder="e.g., Scheduled Maintenance" required>
                      </div>
                      <div class="mb-4">
                          <label class="form-label">Message Content</label>
                          <textarea name="message" class="form-control" rows="4" placeholder="Type your broadcast message here..." required></textarea>
                      </div>
                      <button type="submit" class="btn-submit">
                          <i class="fas fa-broadcast-tower me-1"></i> Transmit to All Users
                      </button>
                  </form>
              </div>
          </div>

          <div class="col-lg-7">
              <!-- History Table -->
              <div class="admin-card">
                  <div class="card-title"><i class="fas fa-history"></i> Broadcast History</div>
                  
                  <c:choose>
                      <c:when test="${not empty broadcasts}">
                          <div class="table-responsive">
                              <table>
                                  <thead>
                                      <tr>
                                          <th>Type</th>
                                          <th>Title & Message</th>
                                          <th>Date</th>
                                          <th>Action</th>
                                      </tr>
                                  </thead>
                                  <tbody>
                                      <c:forEach var="b" items="${broadcasts}">
                                          <tr>
                                              <td>
                                                  <span class="badge-type badge-${b.type}">${b.type}</span>
                                              </td>
                                              <td>
                                                  <div style="font-weight: 600; color: var(--maroon-dark);">${b.title}</div>
                                                  <div style="font-size: 0.85rem; color: #6b7280; margin-top: 4px;">${b.message}</div>
                                              </td>
                                              <td style="white-space: nowrap; font-size: 0.85rem;">
                                                  <!-- Assuming you have a way to format LocalDateTime, otherwise standard output -->
                                                  ${b.sentAt}
                                              </td>
                                              <td>
                                                  <form action="${pageContext.request.contextPath}/admin/broadcast/delete/${b.id}" method="post" onsubmit="return confirm('Delete this broadcast record?');">
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
                          <div class="text-center p-4" style="color: #6b7280; background: #f9fafb; border-radius: 10px;">
                              <i class="fas fa-inbox mb-2" style="font-size: 2rem; color: #d1d5db;"></i>
                              <div>No broadcasts have been sent yet.</div>
                          </div>
                      </c:otherwise>
                  </c:choose>
              </div>
          </div>
      </div>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

