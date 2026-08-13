<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pending Financial Educators | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <style>
<style>
    body { background: #f8fafc; font-family: 'Poppins', system-ui, -apple-system, sans-serif; margin: 0; }
    .card-panel { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.08); padding: 1.25rem; }
    .btn-approve { background: #059669; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
    .btn-reject { background: #dc2626; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
    .btn-changes { background: #d97706; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
    
    .topbar { background: #1e1b4b; color: white; padding: 14px 18px; font-weight: 600; position: sticky; top: 0; z-index: 1000; display: flex; align-items: center; height: 58px; border-bottom: 1px solid rgba(255,255,255,0.1); }
    .topbar .wrap { display: flex; align-items: center; justify-content: space-between; width: 100%; }
    .layout { display: flex; min-height: calc(100vh - 58px); }
    .main { flex: 1; padding: 24px 20px 40px; background: #f8fafc; min-width: 0; }
    .mainInner { max-width: 1100px; margin: 0 auto; }
</style>
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container-fluid px-2">
            <div class="wrap">
                <h5 class="mb-0 text-white" style="font-weight: 600;">Fight D Fear Admin</h5>
            </div>
        </div>
    </div>

    <!-- Layout -->
    <div class="layout">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

        <!-- Main Content -->
        <main class="main">
            <div class="mainInner">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                    <div>
                        <h1 class="h4 mb-1" style="color: #1e1b4b; font-weight: 700;">Pending Financial Educators</h1>
                        <p class="text-muted mb-0 small">Review Join Us → Financial Literacy submissions (${pendingCount})</p>
                    </div>
                </div>
                <c:if test="${not empty message}"><div class="alert alert-success">${message}</div></c:if>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
  <div class="card-panel">
    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
        <tr><th>Educator</th><th>Status</th><th>Expertise / City</th><th>Contact</th><th>Action</th></tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${not empty pendingEducators}">
            <c:forEach var="e" items="${pendingEducators}">
              <tr>
                <td>
                  <span class="fw-semibold d-block">${e.fullName}</span>
                  <small class="text-muted">${e.email}</small>
                  <div class="small text-muted mt-1">${e.profileCompletionPct != null ? e.profileCompletionPct : 0}% complete</div>
                  <c:if test="${not empty e.bio}"><div class="small text-muted mt-1">${e.bio}</div></c:if>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${e.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}"><span class="badge bg-warning text-dark">Pending approval</span></c:when>
                    <c:when test="${e.partnerProfileStatus == 'READY_FOR_VERIFICATION'}"><span class="badge bg-info text-dark">Ready to submit</span></c:when>
                    <c:when test="${e.partnerProfileStatus == 'CHANGES_REQUESTED'}"><span class="badge text-dark" style="background:#fdba74;">Changes requested</span></c:when>
                    <c:otherwise><span class="badge bg-secondary">${empty e.partnerProfileStatus ? 'Incomplete' : e.partnerProfileStatus}</span></c:otherwise>
                  </c:choose>
                </td>
                <td class="small">
                  <div>${empty e.expertise ? '—' : e.expertise}</div>
                  <div class="text-muted">${empty e.city ? 'No city' : e.city}</div>
                </td>
                <td class="small">${empty e.phone ? '—' : e.phone}</td>
                <td>
                  <div class="d-flex flex-wrap gap-2">
                    <form action="${pageContext.request.contextPath}/admin/educators/${e.id}/approve" method="post" class="m-0">
                      <button type="submit" class="btn-approve"><i class="fas fa-check me-1"></i>Approve</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/educators/${e.id}/reject" method="post" class="m-0"
                          onsubmit="return confirm('Reject this educator?');">
                      <input type="text" name="reason" placeholder="Reason" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-reject"><i class="fas fa-times me-1"></i>Reject</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/educators/${e.id}/request-changes" method="post" class="m-0">
                      <input type="text" name="note" placeholder="Changes note" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-changes"><i class="fas fa-edit me-1"></i>Request changes</button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr><td colspan="5" class="py-4 text-center text-muted">No pending educator applications.</td></tr>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </div>
            </div>
        </main>
    </div>
</body>
</html>
