<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Event Organizer Profile — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon: #1e1b4b;
    --maroon-light: #312e81;
    --maroon-dark: #0b0920;
    --maroon-pale: #f8fafc;
    --maroon-border: rgba(30, 27, 75, 0.12);
    --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; }
  .topbar {
    background: var(--maroon); color:#fff; padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    box-shadow: 0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff; border:1px solid rgba(255,255,255,0.3);
    border-radius:7px; padding:5px 16px; font-size:0.85rem; font-weight:600; text-decoration:none;
  }
  .layout { display:flex; min-height:calc(100vh - 58px); }
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:900px; margin:0 auto; }
  .pg-header {
    background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 28px rgba(125,42,90,0.22);
    display:flex; align-items:center; justify-content:space-between;
  }
  .pg-header h4 { color:#fff; font-weight:700; font-size:1.2rem; margin:0; }
  .pg-header p { color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.85rem; }
  .pg-header .btn-back {
    background: rgba(255,255,255,0.2); color: #fff; border: 1px solid rgba(255,255,255,0.4);
    border-radius: 8px; padding: 6px 14px; font-size: 0.85rem; font-weight: 600; text-decoration: none;
  }
  .profile-card {
    background: #fff; border-radius: 16px; padding: 30px;
    box-shadow: var(--shadow-sm); border: 1px solid var(--maroon-border);
  }
  .profile-header {
    display: flex; flex-direction: column; align-items: center; text-align: center;
    margin-bottom: 30px; padding-bottom: 25px; border-bottom: 1px solid var(--maroon-border);
  }
  .profile-avatar {
    width: 100px; height: 100px; background: var(--maroon-pale); color: var(--maroon);
    border-radius: 50%; display: flex; align-items: center; justify-content: center;
    font-size: 2.5rem; margin-bottom: 15px; border: 2px solid var(--maroon-light);
  }
  .profile-name { font-size: 1.6rem; font-weight: 700; color: var(--maroon-dark); margin-bottom: 5px; }
  .profile-email { color: #6b7280; font-size: 0.95rem; margin-bottom: 15px; }
  .badge-status {
    padding:6px 16px; border-radius:999px; font-size:0.8rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-APPROVED, .status-VERIFIED { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-PENDING, .status-PENDING_ADMIN_APPROVAL { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED, .status-READY_FOR_VERIFICATION { background:#e0e7ff; color:#3730a3; border-color:#c7d2fe; }
  .status-REJECTED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
  .status-CHANGES_REQUESTED { background:#ffedd5; color:#9a3412; border-color:#fed7aa; }
  .section-title {
    font-size: 1.1rem; font-weight: 700; color: var(--maroon);
    margin-bottom: 15px; display: flex; align-items: center; gap: 8px;
  }
  .info-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 20px; margin-bottom: 30px;
  }
  .info-item {
    background: var(--maroon-pale); padding: 16px; border-radius: 12px;
    border: 1px solid var(--maroon-border);
  }
  .info-label {
    font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em;
    color: var(--maroon-light); font-weight: 700; margin-bottom: 6px;
    display: flex; align-items: center; gap: 6px;
  }
  .info-value { font-size: 1.05rem; font-weight: 600; color: var(--maroon-dark); word-break: break-word; }
  .info-item.highlight { background: #fff; border: 2px solid var(--maroon-light); }
  .doc-box {
    background: #fff; border-radius: 12px; padding: 20px;
    display: flex; align-items: center; gap: 16px;
    border: 1px solid var(--maroon-border); margin-bottom: 16px;
  }
  .doc-box-icon {
    width: 50px; height: 50px; background: var(--maroon-pale); color: var(--maroon);
    border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;
  }
  .doc-link { color: var(--maroon); font-weight: 700; text-decoration: none; }
  .action-bar {
    display: flex; justify-content: center; gap: 15px; flex-wrap: wrap;
    padding-top: 25px; border-top: 1px solid var(--maroon-border);
  }
  .btn-verify {
    background: #059669; color: #fff; border: none; border-radius: 10px;
    padding: 12px 28px; font-size: 1rem; font-weight: 600; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .btn-reject {
    background: #dc2626; color: #fff; border: none; border-radius: 10px;
    padding: 12px 28px; font-size: 1rem; font-weight: 600; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .missing-list { margin: 0; padding-left: 1.2rem; font-size: 0.9rem; color: #64748b; }
</style>
</head>
<body>

<div class="topbar">
  <span class="brand"><i class="fas fa-shield-alt me-2"></i>Fight D Fear Admin</span>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">Logout</a>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">

      <div class="pg-header">
        <div>
          <h4><i class="fas fa-calendar-check me-2"></i>Event Organizer Profile</h4>
          <p>Full profile details before approval</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-event-hosts" class="btn-back">
          <i class="fas fa-arrow-left me-1"></i> Back to Organizers
        </a>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-4" style="border-radius:10px;"><i class="fas fa-info-circle me-1"></i> ${message}</div>
      </c:if>

      <c:set var="statusStr" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus : 'PENDING'}"/>

      <div class="profile-card">
        <div class="profile-header">
          <c:choose>
            <c:when test="${not empty host.logoPath}">
              <img src="${pageContext.request.contextPath}${host.logoPath}" class="profile-avatar" style="object-fit:cover;" alt="Organizer Logo">
            </c:when>
            <c:otherwise>
              <div class="profile-avatar"><i class="fas fa-building"></i></div>
            </c:otherwise>
          </c:choose>
          <div class="profile-name">${host.fullName}</div>
          <div class="profile-email">${host.email}</div>
          <span class="badge-status status-${statusStr}">${statusLabel}</span>
        </div>

        <div class="section-title"><i class="fas fa-id-badge"></i> Organizer Information</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
            <div class="info-value">${not empty host.fullName ? host.fullName : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
            <div class="info-value">${not empty host.email ? host.email : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-phone"></i> Phone</div>
            <div class="info-value">${not empty host.phone ? host.phone : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-building"></i> Organization</div>
            <div class="info-value">${not empty host.organizerName ? host.organizerName : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-tag"></i> Organizer Type</div>
            <div class="info-value">${not empty host.organizerType ? host.organizerType : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-id-card"></i> GST / NGO / CIN</div>
            <div class="info-value">${not empty host.credentialNumber ? host.credentialNumber : '—'}</div>
          </div>
          <div class="info-item highlight">
            <div class="info-label"><i class="fas fa-percent"></i> Profile Completion</div>
            <div class="info-value">${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-tasks"></i> Verification Status</div>
            <div class="info-value">${host.verificationStatus != null ? host.verificationStatus : '—'}</div>
          </div>
        </div>

        <div class="section-title"><i class="fas fa-map-marker-alt"></i> Location & Contact</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">Office Address</div>
            <div class="info-value">${not empty host.officeAddress ? host.officeAddress : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">City / State</div>
            <div class="info-value">
              <c:choose>
                <c:when test="${not empty host.city}">${host.city}<c:if test="${not empty host.state}">, ${host.state}</c:if></c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-item">
            <div class="info-label">Pincode</div>
            <div class="info-value">${not empty host.pincode ? host.pincode : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">WhatsApp</div>
            <div class="info-value">${not empty host.whatsappNumber ? host.whatsappNumber : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Website</div>
            <div class="info-value">${not empty host.website ? host.website : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Social</div>
            <div class="info-value" style="font-size:0.9rem;">
              <c:if test="${not empty host.instagram}">IG: ${host.instagram}<br/></c:if>
              <c:if test="${not empty host.facebook}">FB: ${host.facebook}<br/></c:if>
              <c:if test="${not empty host.linkedin}">LI: ${host.linkedin}</c:if>
              <c:if test="${empty host.instagram && empty host.facebook && empty host.linkedin}">—</c:if>
            </div>
          </div>
        </div>

        <div class="section-title"><i class="fas fa-calendar-alt"></i> Events & Services</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">Categories</div>
            <div class="info-value">${not empty host.eventCategories ? host.eventCategories : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Audience</div>
            <div class="info-value">${not empty host.audience ? host.audience : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Experience (years)</div>
            <div class="info-value">${host.yearsExperience != null ? host.yearsExperience : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Expected Participants</div>
            <div class="info-value">${host.expectedParticipants != null ? host.expectedParticipants : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Session Mode / Ticket</div>
            <div class="info-value">
              ${not empty host.sessionMode ? host.sessionMode : '—'}
              <c:if test="${host.typicalPrice != null}"> — ₹<fmt:formatNumber value="${host.typicalPrice}" maxFractionDigits="0"/></c:if>
            </div>
          </div>
          <div class="info-item">
            <div class="info-label">Open Days / Hours</div>
            <div class="info-value" style="font-size:0.9rem;">
              ${not empty host.openDays ? host.openDays : '—'}
              <c:if test="${not empty openTimeLabel}"><br/>${openTimeLabel}<c:if test="${not empty closeTimeLabel}"> – ${closeTimeLabel}</c:if></c:if>
            </div>
          </div>
        </div>

        <div class="section-title"><i class="fas fa-align-left"></i> About</div>
        <div class="info-item mb-4">
          <div class="info-value" style="font-weight:500;"><c:out value="${not empty host.hostBio ? host.hostBio : '—'}"/></div>
        </div>

        <c:if test="${not empty missingItems}">
          <div class="section-title"><i class="fas fa-exclamation-circle"></i> Missing Profile Items</div>
          <ul class="missing-list mb-4">
            <c:forEach var="item" items="${missingItems}">
              <li><c:out value="${item}"/></li>
            </c:forEach>
          </ul>
        </c:if>

        <div class="section-title"><i class="fas fa-file-alt"></i> Documents</div>
        <div class="doc-box">
          <div class="doc-box-icon"><i class="fas fa-image"></i></div>
          <div>
            <div class="text-muted small">Logo / Profile Image</div>
            <c:choose>
              <c:when test="${not empty host.logoPath}">
                <a href="${pageContext.request.contextPath}${host.logoPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View logo</a>
              </c:when>
              <c:otherwise><span class="text-muted">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-box">
          <div class="doc-box-icon"><i class="fas fa-file-contract"></i></div>
          <div>
            <div class="text-muted small">Verification Document</div>
            <c:choose>
              <c:when test="${not empty host.documentPath}">
                <a href="${pageContext.request.contextPath}${host.documentPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View document</a>
              </c:when>
              <c:otherwise><span class="text-muted">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-box mb-4">
          <div class="doc-box-icon"><i class="fas fa-folder-open"></i></div>
          <div>
            <div class="text-muted small">Portfolio</div>
            <c:choose>
              <c:when test="${not empty host.portfolioPath}">
                <a href="${pageContext.request.contextPath}${host.portfolioPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View portfolio</a>
              </c:when>
              <c:otherwise><span class="text-muted">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="section-title"><i class="fas fa-gavel"></i> Admin Decision</div>
        <div class="mb-3">
          <span class="badge-status status-${statusStr}">${statusLabel}</span>
          <c:if test="${not empty host.changesRequestedNote}">
            <div class="mt-2 text-warning small"><strong>Changes requested:</strong> ${host.changesRequestedNote}</div>
          </c:if>
          <c:if test="${not empty host.rejectionReason}">
            <div class="mt-2 text-danger small"><strong>Rejection reason:</strong> ${host.rejectionReason}</div>
          </c:if>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Decision notes / comments</label>
          <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the organizer (required for reject / request changes)"></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Request-change reasons (optional)</label>
          <div class="d-flex flex-wrap gap-3">
            <label><input type="checkbox" class="reason-box" value="Organization details"> Organization details</label>
            <label><input type="checkbox" class="reason-box" value="Location"> Location</label>
            <label><input type="checkbox" class="reason-box" value="Documents"> Documents</label>
            <label><input type="checkbox" class="reason-box" value="Event categories"> Event categories</label>
            <label><input type="checkbox" class="reason-box" value="Pricing"> Pricing</label>
          </div>
        </div>

        <div class="action-bar">
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/approve" method="post" class="m-0">
            <input type="hidden" name="notes" id="approveNotes">
            <button type="submit" class="btn-verify"
                    onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-check-circle"></i> Approve
            </button>
          </form>

          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/request-changes" method="post" class="m-0">
            <input type="hidden" name="notes" id="changesNotes">
            <input type="hidden" name="reasons" id="changesReasons">
            <button type="submit" class="btn btn-warning text-dark fw-semibold" style="border-radius:10px;padding:12px 28px;"
                    onclick="
                      document.getElementById('changesNotes').value=document.getElementById('decisionNotes').value;
                      document.getElementById('changesReasons').value=Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                    ">
              <i class="fas fa-edit"></i> Request Changes
            </button>
          </form>

          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/reject" method="post" class="m-0"
                onsubmit="return confirm('Reject this event organizer?')">
            <input type="hidden" name="notes" id="rejectNotes">
            <button type="submit" class="btn-reject"
                    onclick="document.getElementById('rejectNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-times-circle"></i> Reject
            </button>
          </form>
        </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>
