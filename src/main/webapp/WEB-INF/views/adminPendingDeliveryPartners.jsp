<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pending Delivery Partners | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <style>
    body { background: #f8fafc; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; }
    .page-wrap { max-width: 1100px; margin: 2rem auto; padding: 0 1rem; }
    .card-panel { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.08); padding: 1.25rem; }
    .btn-approve { background: #059669; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
    .btn-reject { background: #dc2626; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
    .btn-changes { background: #d97706; color: #fff; border: 0; border-radius: 8px; padding: .35rem .75rem; font-size: .85rem; }
  </style>
</head>
<body>
<div class="page-wrap">
  <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
    <div>
      <h1 class="h4 mb-1">Pending Delivery Partners</h1>
      <p class="text-muted mb-0 small">Review Join Us → Delivery Guy submissions (${pendingCount})</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-outline-secondary btn-sm">
      <i class="fas fa-arrow-left me-1"></i> Dashboard
    </a>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-success">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="card-panel">
    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
        <tr>
          <th>Partner</th>
          <th>Status</th>
          <th>City / Vehicle</th>
          <th>Contact</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${not empty pendingPartners}">
            <c:forEach var="d" items="${pendingPartners}">
              <tr>
                <td>
                  <span class="fw-semibold d-block">${d.fullName}</span>
                  <small class="text-muted">${d.email}</small>
                  <div class="small text-muted mt-1">${d.profileCompletionPct != null ? d.profileCompletionPct : 0}% complete</div>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${d.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                      <span class="badge bg-warning text-dark">Pending approval</span>
                    </c:when>
                    <c:when test="${d.partnerProfileStatus == 'READY_FOR_VERIFICATION'}">
                      <span class="badge bg-info text-dark">Ready to submit</span>
                    </c:when>
                    <c:when test="${d.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                      <span class="badge text-dark" style="background:#fdba74;">Changes requested</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary">${empty d.partnerProfileStatus ? 'Incomplete' : d.partnerProfileStatus}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="small">
                  <div>${empty d.city ? '—' : d.city}</div>
                  <div class="text-muted">${empty d.vehicleType ? 'No vehicle' : d.vehicleType} · ${empty d.serviceArea ? '' : d.serviceArea}</div>
                </td>
                <td class="small">${empty d.phone ? '—' : d.phone}</td>
                <td>
                  <div class="d-flex flex-wrap gap-2">
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/approve" method="post" class="m-0">
                      <button type="submit" class="btn-approve"><i class="fas fa-check me-1"></i>Approve</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/reject" method="post" class="m-0"
                          onsubmit="return confirm('Reject this delivery partner?');">
                      <input type="text" name="reason" placeholder="Reason" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-reject"><i class="fas fa-times me-1"></i>Reject</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/request-changes" method="post" class="m-0">
                      <input type="text" name="note" placeholder="Changes note" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-changes"><i class="fas fa-edit me-1"></i>Request changes</button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="5" class="py-4 text-center text-muted">
                <i class="fas fa-check-circle fa-2x mb-2 d-block" style="opacity:.4;"></i>
                No pending delivery partner requests.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
