<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty proposal.title ? proposal.title : 'Proposal Details'} - Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.ap-page { margin: 0; font-family: 'Poppins', sans-serif; background: var(--ap-bg); color: var(--ap-text); }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; padding: 22px 24px 48px; background: var(--ap-bg); }
  .mainInner { max-width: 1100px; margin: 0 auto; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    text-decoration: none; font-weight: 600; font-size: 0.88rem; margin-bottom: 14px;
  }
  .back-nav:hover { color: var(--ap-accent); }

  .header-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 18px; box-shadow: var(--ap-shadow);
  }
  .header-card h1 { margin: 0; font-size: 1.45rem; font-weight: 800; color: var(--ap-text); font-family: Outfit, Poppins, sans-serif; }
  .header-card .contact-line { color: var(--ap-muted); font-size: 0.88rem; }
  .header-card .contact-line a { color: var(--ap-text); text-decoration: none; font-weight: 600; }
  
  .avatar-box {
    width: 96px; height: 96px; border-radius: 16px; overflow: hidden; flex-shrink: 0;
    border: 3px solid #FFE4E6; background: var(--ap-accent-soft);
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  
  .review-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 16px; box-shadow: var(--ap-shadow);
  }
  .section-header {
    display: flex; align-items: center; gap: 10px; margin-bottom: 16px;
    padding-bottom: 12px; border-bottom: 1px solid var(--ap-border);
  }
  .section-header i {
    width: 34px; height: 34px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: inline-flex; align-items: center; justify-content: center;
  }
  .section-header h3 { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--ap-text); font-family: Outfit, Poppins, sans-serif; }

  .info-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: 14px 18px; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    display: block; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
    text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px;
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-text); word-break: break-word; }
  .info-field-value-text { font-size: 0.95rem; font-weight: 500; color: var(--ap-text); word-break: break-word; line-height: 1.5; white-space: pre-wrap; background: #F8FAFC; padding: 12px; border-radius: 8px; border: 1px solid var(--ap-border); }
  .empty-text { color: #94A3B8; font-size: 0.88rem; font-style: italic; }

  .action-buttons-container { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--ap-border); }
  .btn-action-approve, .btn-action-reject {
    display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px;
    font-family: 'Poppins', sans-serif; font-weight: 700; font-size: 1.05rem;
    border: none; border-radius: 8px; cursor: pointer; color: white;
  }
  .btn-action-approve { background-color: #0FA958; }
  .btn-action-reject { background-color: #DE2828; }
</style>
</head>
<body class="ap-page">

<div class="layout">
  <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>
  <main class="main">
    <div class="mainInner">
      <a href="${pageContext.request.contextPath}/admin/pending-proposals" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Pending Proposals
      </a>

      <!-- 1. Hero header -->
      <div class="header-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
             <c:choose>
                 <c:when test="${not empty proposal.photos}">
                     <c:set var="firstPhoto" value="${fn:split(proposal.photos, ',')[0]}"/>
                     <img src="${pageContext.request.contextPath}${firstPhoto}" alt="Proposal Icon">
                 </c:when>
                 <c:otherwise>
                     <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light">
                        <i class="bi bi-briefcase-fill" style="font-size:2.6rem;color:#94a3b8;"></i>
                     </div>
                 </c:otherwise>
             </c:choose>
          </div>
          <div class="flex-grow-1">
            <h1><c:out value="${not empty proposal.title ? proposal.title : 'Untitled Proposal'}"/></h1>
            <div class="d-flex flex-wrap gap-3 mt-2 contact-line">
              <div><i class="bi bi-tag-fill me-1" style="color:var(--ap-accent);"></i> <strong style="color:var(--ap-navy-mid);">Category:</strong> <c:out value="${not empty proposal.category ? proposal.category : 'Not specified'}"/></div>
              <div><i class="bi bi-geo-alt-fill me-1" style="color:var(--ap-accent);"></i> <span class="fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="${not empty proposal.location ? proposal.location : 'Not specified'}"/></span></div>
              <c:if test="${not empty proposal.status}">
                 <div>
                    <i class="bi bi-info-circle-fill me-1" style="color:var(--ap-accent);"></i> <strong style="color:var(--ap-navy-mid);">Status:</strong> 
                    <span class="badge ${proposal.status == 'VERIFIED' ? 'bg-success' : (proposal.status == 'REJECTED' ? 'bg-danger' : 'bg-warning text-dark')}">${proposal.status}</span>
                 </div>
              </c:if>
            </div>
          </div>
        </div>
      </div>

      <!-- 2. Financial & Core Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-currency-rupee"></i>
          <h3>Financial & Core Requirements</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Investment / Capital Needed</span>
            <div class="h4 fw-bold text-success mb-0 mt-1">₹<c:out value="${proposal.fundingNeeded != null ? proposal.fundingNeeded : '0'}"/></div>
          </div>
          <div class="info-field">
            <span class="info-field-label">Expected Monthly Income</span>
            <div class="h4 fw-bold text-primary mb-0 mt-1">₹<c:out value="${proposal.expectedMonthlyIncome != null ? proposal.expectedMonthlyIncome : '0'}"/></div>
          </div>
          <div class="info-field span-all mt-2">
            <span class="info-field-label">Business Description / Pitch</span>
            <c:choose>
                <c:when test="${not empty proposal.description}">
                    <div class="info-field-value-text"><c:out value="${proposal.description}"/></div>
                </c:when>
                <c:otherwise>
                    <span class="empty-text">No description provided</span>
                </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 3. Media & Attachments -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-images"></i>
          <h3>Media & Attachments</h3>
        </div>
        <div class="info-grid">
          <!-- Photos -->
          <div class="info-field span-all">
            <span class="info-field-label">Business Photos</span>
            <div class="d-flex flex-wrap gap-2 p-3 border rounded-2 bg-light">
                <c:choose>
                    <c:when test="${not empty proposal.photos}">
                        <c:forEach var="photo" items="${fn:split(proposal.photos, ',')}">
                            <a href="${pageContext.request.contextPath}${photo}" target="_blank">
                                <img src="${pageContext.request.contextPath}${photo}" alt="Business Photo" style="height: 120px; width: 160px; object-fit: cover; border-radius: 8px; border: 1px solid var(--ap-border); transition: transform 0.2s;">
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No photos uploaded</span>
                    </c:otherwise>
                </c:choose>
            </div>
          </div>

          <!-- Documents -->
          <div class="info-field span-all">
            <span class="info-field-label">Business Documents</span>
            <div class="d-flex flex-wrap gap-2 p-3 border rounded-2 bg-light">
                <c:choose>
                    <c:when test="${not empty proposal.documents}">
                        <c:forEach var="doc" items="${fn:split(proposal.documents, ',')}">
                            <a href="${pageContext.request.contextPath}${doc}" target="_blank" class="btn btn-outline-secondary bg-white">
                                <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i> View Document
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No documents uploaded</span>
                    </c:otherwise>
                </c:choose>
            </div>
          </div>

          <!-- Video Pitch -->
          <div class="info-field span-all">
            <span class="info-field-label">Video Pitch</span>
            <div class="p-3 border rounded-2 bg-light">
                <c:choose>
                    <c:when test="${not empty proposal.videoPitch}">
                        <video controls style="max-width: 100%; width: 600px; height: auto; border-radius: 8px; border: 1px solid var(--ap-border); background: black;">
                            <source src="${pageContext.request.contextPath}${proposal.videoPitch}" type="video/mp4">
                        </video>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No video pitch provided</span>
                    </c:otherwise>
                </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="action-buttons-container">
          <c:if test="${proposal.status != 'VERIFIED'}">
          <form action="${pageContext.request.contextPath}/admin/proposals/${proposal.id}/approve" method="post" class="m-0">
              <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this proposal for platform access?');">
                  <i class="bi bi-check-circle-fill me-1"></i> Approve Proposal
              </button>
          </form>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/proposals/${proposal.id}/reject" method="post" class="m-0">
              <button type="submit" class="btn-action-reject" onclick="return confirm('Reject this proposal?');">
                  <i class="bi bi-x-circle-fill me-1"></i> Reject Proposal
              </button>
          </form>
      </div>

    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
