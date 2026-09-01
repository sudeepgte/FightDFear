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
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  :root {
    --we-navy: #0F172A;
    --we-navy-soft: #1E293B;
    --we-accent: #F43F5E;
    --we-bg: #F8FAFC;
    --we-card: #FFFFFF;
    --we-muted: #64748B;
    --we-border: #E2E8F0;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Outfit',sans-serif; margin:0; background:var(--we-bg); color:var(--we-navy); }
  .topbar {
    background: var(--we-navy); color:#fff; padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
  }
  .topbar .brand { font-size:1.05rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.12); color:#fff; border:1px solid rgba(255,255,255,0.25);
    border-radius:8px; padding:6px 14px; font-size:0.85rem; font-weight:600; text-decoration:none;
  }
  .layout { display:flex; min-height:calc(100vh - 58px); }
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:920px; margin:0 auto; }
  .pg-header {
    background: #fff; border: 1px solid var(--we-border);
    border-radius:16px; padding:20px 24px; margin-bottom:22px;
    display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap;
  }
  .pg-header h4 { color:var(--we-navy); font-weight:800; font-size:1.2rem; margin:0; }
  .pg-header p { color:var(--we-muted); margin:4px 0 0; font-size:0.85rem; }
  .pg-header .btn-back {
    background: #F8FAFC; color: var(--we-navy); border: 1px solid var(--we-border);
    border-radius: 8px; padding: 7px 14px; font-size: 0.85rem; font-weight: 600; text-decoration: none;
  }
  .profile-card {
    background: #fff; border-radius: 16px; padding: 28px;
    box-shadow: 0 4px 20px rgba(15,23,42,0.05); border: 1px solid var(--we-border);
  }
  .profile-header {
    display: flex; flex-direction: column; align-items: center; text-align: center;
    margin-bottom: 28px; padding-bottom: 22px; border-bottom: 1px solid var(--we-border);
  }
  .profile-avatar {
    width: 96px; height: 96px; background: #FFF1F2; color: var(--we-accent);
    border-radius: 50%; display: flex; align-items: center; justify-content: center;
    font-size: 2.2rem; margin-bottom: 14px; border: 1px solid #FECDD3; object-fit: cover;
  }
  .profile-name { font-size: 1.5rem; font-weight: 800; color: var(--we-navy); margin-bottom: 4px; }
  .profile-email { color: var(--we-muted); font-size: 0.95rem; margin-bottom: 12px; }
  .badge-status {
    padding:6px 14px; border-radius:999px; font-size:0.78rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-APPROVED, .status-VERIFIED { background:#DCFCE7; color:#166534; border-color:#BBF7D0; }
  .status-PENDING, .status-PENDING_ADMIN_APPROVAL { background:#FEF3C7; color:#92400E; border-color:#FDE68A; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED, .status-READY_FOR_VERIFICATION { background:#F1F5F9; color:#475569; border-color:#E2E8F0; }
  .status-REJECTED { background:#FEE2E2; color:#991B1B; border-color:#FECACA; }
  .status-CHANGES_REQUESTED { background:#FFEDD5; color:#9A3412; border-color:#FED7AA; }
  .section-title {
    font-size: 1rem; font-weight: 800; color: var(--we-navy);
    margin: 8px 0 14px; display: flex; align-items: center; gap: 8px;
  }
  .info-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 14px; margin-bottom: 24px;
  }
  .info-item {
    background: var(--we-bg); padding: 14px 16px; border-radius: 12px;
    border: 1px solid var(--we-border);
  }
  .info-label {
    font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em;
    color: var(--we-muted); font-weight: 700; margin-bottom: 6px;
  }
  .info-value { font-size: 0.98rem; font-weight: 600; color: var(--we-navy); word-break: break-word; white-space: pre-wrap; }
  .info-item.highlight { background: #fff; border: 1px solid #FECDD3; }
  .bio-block { white-space: pre-wrap; font-weight: 500; line-height: 1.55; }
  .doc-box {
    background: #fff; border-radius: 12px; padding: 16px 18px;
    display: flex; align-items: center; gap: 14px;
    border: 1px solid var(--we-border); margin-bottom: 12px;
  }
  .doc-box-icon {
    width: 44px; height: 44px; background: #FFF1F2; color: var(--we-accent);
    border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
  }
  .doc-link { color: var(--we-navy); font-weight: 700; text-decoration: none; }
  .action-bar {
    display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;
    padding-top: 22px; border-top: 1px solid var(--we-border);
  }
  .btn-verify {
    background: #059669; color: #fff; border: none; border-radius: 10px;
    padding: 11px 22px; font-size: 0.95rem; font-weight: 600; cursor: pointer;
  }
  .btn-reject {
    background: #DC2626; color: #fff; border: none; border-radius: 10px;
    padding: 11px 22px; font-size: 0.95rem; font-weight: 600; cursor: pointer;
  }
  .missing-list { margin: 0; padding-left: 1.2rem; font-size: 0.9rem; color: var(--we-muted); }
  .event-row {
    display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;
    padding:12px 0; border-bottom:1px solid #F1F5F9; font-size:0.9rem;
  }
  .event-row:last-child { border-bottom:none; }
  @media (max-width: 720px) {
    .info-grid { grid-template-columns: 1fr; }
    .profile-card { padding: 20px 16px; }
  }
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
          <h4>Event Organizer Profile</h4>
          <p>Full application preview before approve / reject / request changes</p>
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
          <div class="info-item">
            <div class="info-label">Host contact</div>
            <div class="info-value">${not empty host.hostContact ? host.hostContact : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Facilities</div>
            <div class="info-value">${not empty host.facilities ? host.facilities : '—'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">On-site / door service</div>
            <div class="info-value">${host.doorService == true ? 'Yes' : 'No'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">UPI ID</div>
            <div class="info-value">${not empty host.upiId ? host.upiId : '—'}</div>
          </div>
        </div>

        <div class="section-title"><i class="fas fa-align-left"></i> About</div>
        <div class="info-item mb-4">
          <div class="info-value bio-block"><c:out value="${not empty host.hostBio ? host.hostBio : 'Not provided'}"/></div>
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

        <div class="section-title"><i class="fas fa-calendar-day"></i> Events by this organizer</div>
        <c:choose>
          <c:when test="${not empty hostEvents}">
            <c:forEach var="ev" items="${hostEvents}">
              <div class="event-row">
                <div>
                  <strong><c:out value="${ev.name}"/></strong>
                  <div class="text-muted small">
                    <c:out value="${ev.category}"/> ·
                    <c:out value="${empty ev.eventDate ? 'Date not set' : ev.eventDate}"/>
                    <c:if test="${not empty ev.eventTime}"> · <c:out value="${ev.eventTime}"/></c:if>
                    · <c:out value="${empty ev.city ? 'City not set' : ev.city}"/>
                  </div>
                </div>
                <span class="badge-status status-${ev.status}"><c:out value="${ev.status}"/></span>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <p class="text-muted mb-4">This organizer has not created any events yet.</p>
          </c:otherwise>
        </c:choose>

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
          <c:if test="${statusStr ne 'APPROVED'}">
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/approve" method="post" class="m-0">
            <input type="hidden" name="notes" id="approveNotes">
            <button type="submit" class="btn-verify"
                    onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-check-circle"></i> Approve
            </button>
          </form>
          </c:if>

          <c:if test="${statusStr ne 'REJECTED' and statusStr ne 'SUSPENDED'}">
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
          </c:if>

          <c:if test="${statusStr ne 'REJECTED'}">
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/reject" method="post" class="m-0"
                onsubmit="return confirm('Reject this event organizer?')">
            <input type="hidden" name="notes" id="rejectNotes">
            <button type="submit" class="btn-reject"
                    onclick="document.getElementById('rejectNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-times-circle"></i> Reject
            </button>
          </form>
          </c:if>
        </div>
      </div>

    </div>
  </main>
</div>

</body>
</html>
