<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Service Partner Profile — Admin View</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.wp-admin-wp { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; }
  body.wp-admin-wp .layout { display: flex; min-height: 100vh; }
  body.wp-admin-wp .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  body.wp-admin-wp .mainInner { max-width: 900px; margin: 0 auto; padding: 22px 24px 48px; }
  body.wp-admin-wp .profile-card {
      background: var(--ap-card); border-radius: var(--ap-radius); padding: 30px;
      box-shadow: var(--ap-shadow); border: 1px solid var(--ap-border);
  }
  body.wp-admin-wp .profile-header {
      display: flex; flex-direction: column; align-items: center; text-align: center;
      margin-bottom: 30px; padding-bottom: 25px; border-bottom: 1px solid var(--ap-border);
  }
  body.wp-admin-wp .profile-avatar {
      width: 100px; height: 100px; background: #FFF1F2; color: var(--ap-accent);
      border-radius: 50%; display: flex; align-items: center; justify-content: center;
      font-size: 2.5rem; margin-bottom: 15px; border: 2px solid #FDA4AF; overflow: hidden;
  }
  body.wp-admin-wp .profile-name { font-size: 1.6rem; font-weight: 800; color: var(--ap-text); margin-bottom: 5px; }
  body.wp-admin-wp .profile-business { color: var(--ap-accent); font-size: 1.1rem; font-weight: 600; margin-bottom: 15px; }
  body.wp-admin-wp .badge-status {
    padding: 6px 16px; border-radius: 999px; font-size: 0.8rem; font-weight: 700; display: inline-block;
  }
  body.wp-admin-wp .status-VERIFIED { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-APPROVED { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-PENDING { background: #FEF3C7; color: #B45309; }
  body.wp-admin-wp .status-REJECTED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .section-title {
      font-size: 1.05rem; font-weight: 800; color: var(--ap-text); margin-bottom: 15px;
      display: flex; align-items: center; gap: 8px;
  }
  body.wp-admin-wp .info-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 16px; margin-bottom: 30px;
  }
  body.wp-admin-wp .info-item {
      background: #F8FAFC; padding: 16px; border-radius: 12px; border: 1px solid var(--ap-border);
  }
  body.wp-admin-wp .info-label {
      font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.05em;
      color: var(--ap-muted); font-weight: 700; margin-bottom: 6px;
      display: flex; align-items: center; gap: 6px;
  }
  body.wp-admin-wp .info-value { font-size: 1rem; font-weight: 600; color: var(--ap-text); word-break: break-word; }
  body.wp-admin-wp .doc-box {
      background: #F8FAFC; border-radius: 12px; padding: 20px; display: flex; align-items: center;
      gap: 16px; border: 1px solid var(--ap-border); margin-bottom: 30px;
  }
  body.wp-admin-wp .doc-box-icon {
      width: 50px; height: 50px; background: #fff; color: var(--ap-accent); border-radius: 10px;
      display: flex; align-items: center; justify-content: center; font-size: 1.5rem;
      border: 1px solid var(--ap-border);
  }
  body.wp-admin-wp .doc-box-content .label { font-size: 0.85rem; color: var(--ap-muted); margin-bottom: 4px; }
  body.wp-admin-wp .doc-link { color: var(--ap-accent); font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 6px; }
  body.wp-admin-wp .action-bar {
      display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;
      padding-top: 25px; border-top: 1px solid var(--ap-border);
  }
  body.wp-admin-wp .btn-verify {
      background: var(--ap-success); color: #fff; border: none; border-radius: 9px;
      padding: 10px 20px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
  }
  body.wp-admin-wp .btn-reject {
      background: var(--ap-danger); color: #fff; border: none; border-radius: 9px;
      padding: 10px 20px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
      display: inline-flex; align-items: center; gap: 8px;
  }
  body.wp-admin-wp .ap-btn-back {
      display: inline-flex; align-items: center; gap: 6px; height: 36px; padding: 7px 14px;
      border-radius: 9px; border: 1px solid var(--ap-border); background: #fff; color: var(--ap-text);
      font-weight: 600; font-size: 0.85rem; text-decoration: none; margin-left: auto;
  }
  body.wp-admin-wp .ap-page-head { align-items: center; }
  @media (max-width: 700px) { body.wp-admin-wp .mainInner { padding: 16px 14px 40px; } }
</style>
</head>
<body class="ap-page wp-admin-wp">
<c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>
  <main class="main">
    <div class="ap-topbar topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${apAdmin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty apAdmin.profilePhoto}"><img src="${pageContext.request.contextPath}${apAdmin.profilePhoto}" alt=""></c:when>
              <c:otherwise>${fn:substring(apAdmin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span><div class="name"><c:out value="${apAdmin.name}"/></div><div class="role">Super Admin</div></span>
        </a>
      </div>
    </div>
    <div class="mainInner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-providers">Service Partners</a>
        <span class="sep">&gt;</span>
        <span>Provider Profile</span>
      </nav>
      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-user-tie"></i></div>
        <div>
          <h1>Provider Profile</h1>
          <p>Full verification details for the service partner</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-providers${not empty provider.category ? '?category='.concat(provider.category) : ''}" class="ap-btn-back">
            <i class="fas fa-arrow-left"></i> Back to Queue
        </a>
      </div>

      <div class="profile-card">
          <!-- Profile Header -->
          <div class="profile-header">
              <div class="profile-avatar">
                  <c:choose>
                      <c:when test="${not empty provider.profilePhoto}">
                          <img src="${pageContext.request.contextPath}${provider.profilePhoto}" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                      </c:when>
                      <c:otherwise>
                          <i class="fas fa-user"></i>
                      </c:otherwise>
                  </c:choose>
              </div>

              <div class="profile-name">${provider.fullName}</div>
              <div class="profile-business">
                  ${not empty provider.category ? provider.category : 'Service Partner'}
                  ${not empty provider.designation ? ' - '.concat(provider.designation) : ''}
              </div>
              
              <c:choose>
                  <c:when test="${provider.verificationStatus == 'VERIFIED' || provider.verificationStatus == 'APPROVED'}">
                      <span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span>
                  </c:when>
                  <c:when test="${provider.verificationStatus == 'REJECTED'}">
                      <span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span>
                  </c:when>
                  <c:otherwise>
                      <span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> PENDING</span>
                  </c:otherwise>
              </c:choose>
          </div>

          <!-- 1. Personal Information -->
          <div class="section-title"><i class="fas fa-user-circle"></i> 1. Personal Information</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                  <div class="info-value">${not empty provider.fullName ? provider.fullName : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                  <div class="info-value">${not empty provider.email ? provider.email : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-phone"></i> Mobile Number</div>
                  <div class="info-value">${not empty provider.phone ? provider.phone : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fab fa-whatsapp"></i> Whatsapp Number</div>
                  <div class="info-value">${not empty provider.whatsappNumber ? provider.whatsappNumber : '-'}</div>
              </div>
          </div>

          <!-- 2. Professional Details -->
          <div class="section-title"><i class="fas fa-briefcase"></i> 2. Professional Details</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-layer-group"></i> Category</div>
                  <div class="info-value"><span class="badge bg-light text-dark border">${not empty provider.category ? provider.category : '-'}</span></div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-gavel"></i> Bar Council ID / License</div>
                  <div class="info-value">${not empty provider.barCouncilId ? provider.barCouncilId : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-history"></i> Experience</div>
                  <div class="info-value">${not empty provider.experienceYears ? provider.experienceYears.concat(' Years') : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-rupee-sign"></i> Consultation Fee</div>
                  <div class="info-value">${not empty provider.consultationFee ? 'Rs '.concat(provider.consultationFee) : '-'}</div>
              </div>
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-tags"></i> Practice Areas / Specializations</div>
                  <div class="info-value">${not empty provider.practiceAreas ? provider.practiceAreas : '-'}</div>
              </div>
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-align-left"></i> Professional Bio</div>
                  <div class="info-value">${not empty provider.description ? provider.description : '-'}</div>
              </div>
          </div>

          <!-- 3. Address & Location -->
          <div class="section-title"><i class="fas fa-map-marker-alt"></i> 3. Address & Location</div>
          <div class="info-grid">
              <div class="info-item" style="grid-column: 1 / -1;">
                  <div class="info-label"><i class="fas fa-map"></i> Full Address</div>
                  <div class="info-value">${not empty provider.address ? provider.address : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-city"></i> City</div>
                  <div class="info-value">${not empty provider.city ? provider.city : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-map-pin"></i> State & Pincode</div>
                  <div class="info-value">${not empty provider.state ? provider.state : '-'} ${not empty provider.pincode ? '- '.concat(provider.pincode) : ''}</div>
              </div>
          </div>

          <!-- 4. Target Audience & Services -->
          <div class="section-title"><i class="fas fa-users"></i> 4. Services & Audience</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-users"></i> Target Audience</div>
                  <div class="info-value">${not empty provider.audience ? provider.audience : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-language"></i> Languages</div>
                  <div class="info-value">${not empty provider.languages ? provider.languages : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-laptop-medical"></i> Service Mode</div>
                  <div class="info-value">${not empty provider.serviceMode ? provider.serviceMode : (not empty provider.consultationMode ? provider.consultationMode : '-')}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-concierge-bell"></i> Facilities</div>
                  <div class="info-value">${not empty provider.facilities ? provider.facilities : '-'}</div>
              </div>
          </div>

          <!-- 5. Operating Hours -->
          <div class="section-title"><i class="fas fa-clock"></i> 5. Operating Hours</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-calendar-alt"></i> Available Days</div>
                  <div class="info-value">${not empty provider.openDays ? provider.openDays : '-'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-hourglass-half"></i> Working Hours</div>
                  <div class="info-value">${not empty provider.openTime ? provider.openTime : '-'} to ${not empty provider.closeTime ? provider.closeTime : '-'}</div>
              </div>
          </div>

          <!-- 6. Bank & Payment Details -->
          <div class="section-title"><i class="fas fa-money-check-alt"></i> 6. Bank & Payment Details</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-mobile-alt"></i> UPI ID</div>
                  <div class="info-value">${not empty provider.upiId ? provider.upiId : '-'}</div>
              </div>
              <div class="info-item" style="grid-column: span 2;">
                  <div class="info-label"><i class="fas fa-university"></i> Bank Details</div>
                  <div class="info-value">${not empty provider.bankDetails ? provider.bankDetails : '-'}</div>
              </div>
          </div>

          <!-- 7. Identity Verification -->
          <div class="section-title"><i class="fas fa-id-card"></i> 7. Identity Verification</div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-file-contract"></i></div>
              <div class="doc-box-content">
                  <c:choose>
                      <c:when test="${not empty provider.identityDocumentPath && provider.identityDocumentPath != 'web-pending'}">
                          <div class="label">Identity Proof (Aadhaar/Bar License)</div>
                          <a href="${pageContext.request.contextPath}${provider.identityDocumentPath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View Document
                          </a>
                      </c:when>
                      <c:otherwise>
                          <div class="text-muted">No identity document uploaded.</div>
                      </c:otherwise>
                  </c:choose>
              </div>
          </div>

          <!-- Decision Panel -->
          <div class="section-title mt-4"><i class="fas fa-gavel"></i> Administrator Decision</div>
          <div class="doc-box" style="display:block;">
              <c:if test="${not empty provider.changesRequestedNote}">
                  <div class="alert alert-warning py-2 small mb-3"><strong>Previous Changes Requested:</strong> ${provider.changesRequestedNote}</div>
              </c:if>
              <c:if test="${not empty provider.rejectionReason}">
                  <div class="alert alert-danger py-2 small mb-3"><strong>Previous Rejection Reason:</strong> ${provider.rejectionReason}</div>
              </c:if>
              
              <div class="mb-3">
                  <label class="form-label fw-semibold" style="font-size:0.9rem; color:var(--ap-text);">Decision notes / comments</label>
                  <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the provider (required for reject / request changes)"></textarea>
              </div>

              <div class="action-bar" style="border-top:none; padding-top:10px; justify-content:flex-start;">
                  <c:if test="${provider.verificationStatus != 'VERIFIED' && provider.verificationStatus != 'APPROVED'}">
                      <form id="approveForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/verify" method="post" class="m-0 p-0">
                          <button type="submit" class="btn-verify">
                              <i class="fas fa-check-circle"></i> Approve Provider
                          </button>
                      </form>
                  </c:if>

                  <form id="changesForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/request-changes" method="post" class="m-0 p-0"
                        onsubmit="var n = document.getElementById('decisionNotes').value.trim(); if(!n){alert('Please provide notes to request changes.'); return false;} document.getElementById('changesNote').value=n;">
                      <input type="hidden" name="note" id="changesNote">
                      <button type="submit" class="btn-changes" style="background:#F59E0B; color:#fff; border:none; border-radius:9px; padding:10px 20px; font-size:0.9rem; font-weight:700; cursor:pointer; display:inline-flex; align-items:center; gap:8px;">
                          <i class="fas fa-edit"></i> Request Changes
                      </button>
                  </form>

                  <c:if test="${provider.verificationStatus != 'REJECTED'}">
                      <form id="rejectForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/reject" method="post" class="m-0 p-0" 
                            onsubmit="var r = document.getElementById('decisionNotes').value.trim(); if(!r){alert('Please provide a reason to reject the provider.'); return false;} document.getElementById('rejectReason').value=r; return confirm('Are you sure you want to reject this provider?')">
                          <input type="hidden" name="reason" id="rejectReason">
                          <button type="submit" class="btn-reject">
                              <i class="fas fa-times-circle"></i> Reject Application
                          </button>
                      </form>
                  </c:if>
              </div>
          </div>

      </div>

    </div>
  </main>
</div>

</body>
</html>
