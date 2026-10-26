<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Product Approvals & Review - Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .prod-thumb {
      width: 50px; height: 50px; border-radius: 10px; object-fit: cover; border: 1px solid #e2e8f0; background: #fff;
    }
    .badge-pending { background: #FEF3C7; color: #B45309; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.75rem; display: inline-flex; align-items: center; gap: 4px; }
    .badge-approved { background: #ECFDF5; color: #059669; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.75rem; display: inline-flex; align-items: center; gap: 4px; }
    .badge-rejected { background: #FEF2F2; color: #B91C1C; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.75rem; display: inline-flex; align-items: center; gap: 4px; }
    .prod-actions { display: flex; gap: 8px; align-items: center; }
    .modal-reject { display: none; position: fixed; z-index: 1050; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center; }
  </style>
</head>
<body class="ap-page">

<c:set var="activeFilter" value="${empty filter ? 'pending' : filter}"/>
<c:set var="q" value="${q}"/>

<c:choose>
  <c:when test="${activeFilter == 'approved'}">
    <c:set var="activeList" value="${approved}"/>
  </c:when>
  <c:when test="${activeFilter == 'rejected'}">
    <c:set var="activeList" value="${rejected}"/>
  </c:when>
  <c:otherwise>
    <c:set var="activeList" value="${pending}"/>
  </c:otherwise>
</c:choose>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:360px;">
          <i class="fas fa-search"></i>
          <input type="text" placeholder="Quick find product..." onkeydown="if(event.key==='Enter'){location.href='${pageContext.request.contextPath}/admin/pending-products?q='+encodeURIComponent(this.value);}">
        </div>
      </div>
      <div class="ap-topbar-right">
        <c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>
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
            <div class="role">Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="ap-main-inner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-products">Product Approvals</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'approved'}">Approved Products</c:when>
            <c:when test="${activeFilter == 'rejected'}">Rejected Products</c:when>
            <c:when test="${not empty q}">Search Results</c:when>
            <c:otherwise>Pending Review</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-box-open"></i></div>
        <div>
          <h1>Women Product Approvals</h1>
          <p>Review every product uploaded by sellers before it goes live to customers</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-success mb-3" style="border-radius:12px;"><i class="fas fa-check-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3" style="border-radius:12px;"><i class="fas fa-exclamation-circle me-1"></i><c:out value="${error}"/></div>
      </c:if>

      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${not empty pending ? pending.size() : 0}</div>
          <div class="lbl">Pending Review</div>
          <div class="sub">Requires approval</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${not empty approved ? approved.size() : 0}</div>
          <div class="lbl">Approved</div>
          <div class="sub">Live in shop</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${not empty rejected ? rejected.size() : 0}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Hidden from shop</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/pending-products" class="ap-filter-row" id="productFilterForm">
        <div class="grow">
          <input type="text" name="q" class="ap-input"
                 placeholder="Search by product name, brand, or seller shop name..."
                 value="${not empty q ? q : ''}">
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select" onchange="this.form.submit()">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending Review</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved Products</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected Products</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty q}">
          <a href="${pageContext.request.contextPath}/admin/pending-products?filter=${activeFilter}" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <section class="ap-panel" style="margin-top:20px;">
        <div class="ap-tabs">
          <a class="ap-tab ${activeFilter == 'pending' ? 'active' : ''}" href="?filter=pending">Pending Review (${not empty pending ? pending.size() : 0})</a>
          <a class="ap-tab ${activeFilter == 'approved' ? 'active' : ''}" href="?filter=approved">Approved (${not empty approved ? approved.size() : 0})</a>
          <a class="ap-tab ${activeFilter == 'rejected' ? 'active' : ''}" href="?filter=rejected">Rejected (${not empty rejected ? rejected.size() : 0})</a>
        </div>

        <c:if test="${not empty q}">
          <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
            Showing results for "<strong><c:out value="${q}"/></strong>"
          </div>
        </c:if>

        <div class="ap-table-wrap">
          <table class="ap-table">
            <thead>
              <tr>
                <th>Product</th>
                <th>Seller / Shop</th>
                <th>Category</th>
                <th>Price &amp; Stock</th>
                <th>Status</th>
                <th style="text-align:right;">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty activeList}">
                  <tr>
                    <td colspan="6" style="text-align:center; padding: 40px; color: var(--ap-muted);">
                      <i class="fas fa-box-open" style="font-size:36px; opacity:0.3; margin-bottom:10px; display:block;"></i>
                      No products found in this queue.
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="p" items="${activeList}">
                    <tr>
                      <td>
                        <div style="display:flex; align-items:center; gap:12px;">
                          <c:choose>
                            <c:when test="${not empty p.publicImagePath}">
                              <img src="${fn:startsWith(p.publicImagePath,'http') ? p.publicImagePath : pageContext.request.contextPath.concat(p.publicImagePath)}" class="prod-thumb" alt="">
                            </c:when>
                            <c:otherwise>
                              <div class="prod-thumb" style="display:flex;align-items:center;justify-content:center;color:#ccc;"><i class="fas fa-image"></i></div>
                            </c:otherwise>
                          </c:choose>
                          <div>
                            <div style="font-weight:700; color:var(--ap-dark);"><c:out value="${p.name}"/></div>
                            <div style="font-size:0.75rem; color:var(--ap-muted);">
                              Brand: <c:out value="${not empty p.brand ? p.brand : 'Unbranded'}"/>
                              <c:if test="${not empty p.sku}"> • SKU: <c:out value="${p.sku}"/></c:if>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <div style="font-weight:700; color:var(--ap-dark);"><c:out value="${p.seller != null ? p.seller.businessName : 'Unknown'}"/></div>
                        <div style="font-size:0.75rem; color:var(--ap-muted);">
                          <c:out value="${p.seller != null ? p.seller.fullName : ''}"/>
                          <c:if test="${not empty p.seller.city}"> • <c:out value="${p.seller.city}"/></c:if>
                        </div>
                      </td>
                      <td>
                        <span style="background:#f1f5f9; padding:4px 8px; border-radius:6px; font-size:0.8rem; font-weight:600;"><c:out value="${p.categoryLabel}"/></span>
                      </td>
                      <td>
                        <div style="font-weight:800; color:#059669;">&#8377;<fmt:formatNumber value="${p.price}" maxFractionDigits="2"/></div>
                        <div style="font-size:0.75rem; color:var(--ap-muted);">Stock: ${p.stock} units</div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${p.approvalStatus == 'APPROVED'}">
                            <span class="badge-approved"><i class="fas fa-check-circle"></i> Approved</span>
                          </c:when>
                          <c:when test="${p.approvalStatus == 'REJECTED'}">
                            <span class="badge-rejected" title="<c:out value='${p.adminRemarks}'/>"><i class="fas fa-times-circle"></i> Rejected</span>
                            <c:if test="${not empty p.adminRemarks}">
                              <div style="font-size:0.72rem; color:#b91c1c; margin-top:3px; max-width:180px;"><c:out value="${p.adminRemarks}"/></div>
                            </c:if>
                          </c:when>
                          <c:otherwise>
                            <span class="badge-pending"><i class="fas fa-clock"></i> Pending Review</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td style="text-align:right;">
                        <div class="prod-actions" style="justify-content: flex-end;">
                          <c:if test="${p.approvalStatus != 'APPROVED'}">
                            <form action="${pageContext.request.contextPath}/admin/products/${p.id}/approve" method="post" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="ap-btn ap-btn-primary" style="padding:6px 12px; font-size:0.8rem; background:#059669; border-color:#059669;" title="Accept & Publish to users">
                                <i class="fas fa-check"></i> Approve
                              </button>
                            </form>
                          </c:if>
                          <c:if test="${p.approvalStatus != 'REJECTED'}">
                            <button type="button" class="ap-btn ap-btn-ghost" style="padding:6px 12px; font-size:0.8rem; color:#dc2626;" onclick="openRejectModal('${p.id}', '<c:out value="${p.name}"/>')">
                              <i class="fas fa-times"></i> Reject
                            </button>
                          </c:if>
                          <c:if test="${p.approvalStatus == 'APPROVED'}">
                            <button type="button" class="ap-btn ap-btn-ghost" style="padding:6px 12px; font-size:0.8rem; color:#dc2626;" onclick="openRejectModal('${p.id}', '<c:out value="${p.name}"/>')">
                              <i class="fas fa-ban"></i> Revoke
                            </button>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </main>
</div>

<!-- Reject Modal -->
<div id="rejectModal" class="modal-reject">
  <div style="background:#fff; border-radius:16px; max-width:440px; width:90%; padding:24px; box-shadow:0 20px 40px rgba(0,0,0,0.2);">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
      <h3 style="margin:0; font-size:1.15rem; font-weight:800; color:#b91c1c;"><i class="fas fa-ban"></i> Reject Product</h3>
      <button type="button" onclick="closeRejectModal()" style="background:none; border:none; font-size:20px; cursor:pointer;">&times;</button>
    </div>
    <form id="rejectForm" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <p style="font-size:0.9rem; color:#475569; margin-bottom:12px;">Rejecting <strong id="rejectProdName"></strong>. The seller will see this reason.</p>
      <div style="margin-bottom:16px;">
        <label style="font-size:0.82rem; font-weight:700; color:#334155; display:block; margin-bottom:6px;">Rejection Reason</label>
        <textarea name="reason" rows="3" class="ap-input" style="width:100%;" placeholder="e.g. Prohibited item, copyright infringement, incomplete product details or blurry photo..." required></textarea>
      </div>
      <div style="display:flex; gap:10px; justify-content:flex-end;">
        <button type="button" class="ap-btn ap-btn-ghost" onclick="closeRejectModal()">Cancel</button>
        <button type="submit" class="ap-btn" style="background:#dc2626; color:#fff; border:none; border-radius:10px; font-weight:700; padding:8px 16px;">Confirm Rejection</button>
      </div>
    </form>
  </div>
</div>

<script>
function openRejectModal(id, name) {
  document.getElementById('rejectProdName').textContent = name;
  document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/products/' + id + '/reject';
  document.getElementById('rejectModal').style.display = 'flex';
}
function closeRejectModal() {
  document.getElementById('rejectModal').style.display = 'none';
}
</script>
</body>
</html>
