<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Profile — Admin</title>
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

  /* ── SIDEBAR (matches globalAdminMenu / pending-doctors) ── */
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
    transition: all 0.3s ease;
  }
  .sidebar .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sidebar .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .sidebar .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
  }
  .sidebar .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
  .sidebar .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
  .sidebar .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
  .sidebar .navlink.active i { color: #fff; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:900px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
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
  .pg-header .btn-back {
      background: rgba(255,255,255,0.2);
      color: #fff;
      border: 1px solid rgba(255,255,255,0.4);
      border-radius: 8px;
      padding: 6px 14px;
      font-size: 0.85rem;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.2s;
  }
  .pg-header .btn-back:hover { background: rgba(255,255,255,0.3); }

  /* ── PROFILE CARD ── */
  .profile-card {
      background: #fff;
      border-radius: 16px;
      padding: 30px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--maroon-border);
  }
  
  .profile-header {
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
      margin-bottom: 30px;
      padding-bottom: 25px;
      border-bottom: 1px solid var(--maroon-border);
  }
  .profile-avatar {
      width: 100px;
      height: 100px;
      background: var(--maroon-pale);
      color: var(--maroon);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      margin-bottom: 15px;
      border: 2px solid var(--maroon-light);
  }
  .profile-name {
      font-size: 1.6rem;
      font-weight: 700;
      color: var(--maroon-dark);
      margin-bottom: 5px;
  }
  .profile-email {
      color: #6b7280;
      font-size: 0.95rem;
      margin-bottom: 15px;
  }
  
  .badge-status {
    padding:6px 16px; border-radius:999px; font-size:0.8rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }
  .status-VERIFIED { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-PENDING { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-REJECTED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }

  /* ── INFO GRID ── */
  .section-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--maroon);
      margin-bottom: 15px;
      display: flex;
      align-items: center;
      gap: 8px;
  }
  
  .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
  }
  .info-item {
      background: var(--maroon-pale);
      padding: 16px;
      border-radius: 12px;
      border: 1px solid var(--maroon-border);
  }
  .info-label {
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--maroon-light);
      font-weight: 700;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .info-value {
      font-size: 1.05rem;
      font-weight: 600;
      color: var(--maroon-dark);
      word-break: break-word;
  }

  /* Highlight specific items */
  .info-item.highlight { background: #fff; border: 2px solid var(--maroon-light); }
  
  .star-rating {
      color: #f59e0b;
      font-size: 1.1rem;
      letter-spacing: 2px;
  }

  /* ── IDENTITY DOCUMENT ── */
  .doc-box {
      background: #fff;
      border-radius: 12px;
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      border: 1px solid var(--maroon-border);
      margin-bottom: 30px;
  }
  .doc-box-icon {
      width: 50px;
      height: 50px;
      background: var(--maroon-pale);
      color: var(--maroon);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
  }
  .doc-box-content .label { font-size: 0.85rem; color: #6b7280; margin-bottom: 4px; }
  .doc-link {
      color: var(--maroon);
      font-weight: 700;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 6px;
  }
  .doc-link:hover { color: var(--maroon-light); text-decoration: underline; }

  /* ── ACTIONS ── */
  .action-bar {
      display: flex;
      justify-content: center;
      gap: 15px;
      flex-wrap: wrap;
      padding-top: 25px;
      border-top: 1px solid var(--maroon-border);
  }
  .btn-verify {
      background: #059669;
      color: #fff;
      border: none;
      border-radius: 10px;
      padding: 12px 28px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
  }
  .btn-verify:hover { background: #047857; transform: translateY(-2px); }
  
  .btn-reject {
      background: #dc2626;
      color: #fff;
      border: none;
      border-radius: 10px;
      padding: 12px 28px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
  }
  .btn-reject:hover { background: #b91c1c; transform: translateY(-2px); }

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
          <h4><i class="fas fa-user-md me-2"></i>Doctor Profile</h4>
          <p>Full profile details for the selected doctor</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="btn-back">
            <i class="fas fa-arrow-left me-1"></i> Back to Doctors
        </a>
      </div>

      <div class="profile-card">
          <!-- Profile Header -->
          <div class="profile-header">
              <c:choose>
                  <c:when test="${not empty doctor.profilePhotoPath}">
                      <img src="${pageContext.request.contextPath}${doctor.profilePhotoPath}" class="profile-avatar" style="object-fit: cover;" alt="Doctor Profile">
                  </c:when>
                  <c:otherwise>
                      <div class="profile-avatar">
                          <i class="fas fa-stethoscope"></i>
                      </div>
                  </c:otherwise>
              </c:choose>
              <div class="profile-name">${doctor.fullName}</div>
              <div class="profile-email">${doctor.email}</div>
              <span class="badge-status status-PENDING">${statusLabel}</span>
          </div>

          <!-- Doctor Information -->
          <div class="section-title"><i class="fas fa-id-badge"></i> Doctor Information</div>
          <div class="info-grid">
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                  <div class="info-value">${not empty doctor.fullName ? doctor.fullName : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                  <div class="info-value">${not empty doctor.email ? doctor.email : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-phone"></i> Phone</div>
                  <div class="info-value">${not empty doctor.phone ? doctor.phone : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-heartbeat"></i> Specialization</div>
                  <div class="info-value">${not empty doctor.specialization ? doctor.specialization : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-map-marker-alt"></i> Location</div>
                  <div class="info-value">${not empty doctor.locationText ? doctor.locationText : '—'}</div>
              </div>
              <div class="info-item highlight">
                  <div class="info-label"><i class="fas fa-rupee-sign"></i> Consultation Fee</div>
                  <div class="info-value">
                      <c:choose>
                          <c:when test="${not empty doctor.consultationFee}">
                              ₹<fmt:formatNumber value="${doctor.consultationFee}" maxFractionDigits="0"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                      </c:choose>
                  </div>
              </div>
              <div class="info-item highlight">
                  <div class="info-label"><i class="fas fa-star"></i> Rating</div>
                  <div class="info-value">
                      <c:choose>
                          <c:when test="${not empty doctor.rating && doctor.rating > 0}">
                              <span class="star-rating">&#9733;</span>
                              <fmt:formatNumber value="${doctor.rating}" maxFractionDigits="1"/> / 5
                          </c:when>
                          <c:otherwise>No rating yet</c:otherwise>
                      </c:choose>
                  </div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-tasks"></i> Profile Status</div>
                  <div class="info-value">${doctor.doctorProfileStatus != null ? doctor.doctorProfileStatus : '—'}</div>
              </div>
              <div class="info-item">
                  <div class="info-label"><i class="fas fa-percent"></i> Profile Completion</div>
                  <div class="info-value">${doctor.profileCompletionPct != null ? doctor.profileCompletionPct : 0}%</div>
              </div>
          </div>

          <!-- Verification Documents -->
          <div class="section-title"><i class="fas fa-file-medical-alt"></i> Verification Documents</div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-user-circle"></i></div>
              <div class="doc-box-content">
                  <div class="label">Profile Photo</div>
                  <c:choose>
                      <c:when test="${not empty doctor.profilePhotoPath}">
                          <a href="${pageContext.request.contextPath}${doctor.profilePhotoPath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View profile photo
                          </a>
                      </c:when>
                      <c:otherwise><div class="text-muted">Not uploaded</div></c:otherwise>
                  </c:choose>
              </div>
          </div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-id-card"></i></div>
              <div class="doc-box-content">
                  <div class="label">Government ID</div>
                  <c:choose>
                      <c:when test="${not empty doctor.idProofPath}">
                          <a href="${pageContext.request.contextPath}${doctor.idProofPath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View government ID
                          </a>
                      </c:when>
                      <c:when test="${not empty doctor.identityDocumentPath}">
                          <a href="${pageContext.request.contextPath}${doctor.identityDocumentPath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View identity document
                          </a>
                          <c:if test="${fn:startsWith(doctor.identityDocumentPath, 'mobile:') || doctor.identityDocumentPath == 'mobile-pending'}">
                              <div class="text-warning small mt-1">Placeholder only — doctor must re-upload from mobile app.</div>
                          </c:if>
                      </c:when>
                      <c:otherwise><div class="text-muted">Not uploaded</div></c:otherwise>
                  </c:choose>
              </div>
          </div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-file-certificate"></i></div>
              <div class="doc-box-content">
                  <div class="label">Medical Registration Certificate</div>
                  <c:choose>
                      <c:when test="${not empty doctor.degreeCertificatePath}">
                          <a href="${pageContext.request.contextPath}${doctor.degreeCertificatePath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View registration certificate
                          </a>
                      </c:when>
                      <c:otherwise><div class="text-muted">Not uploaded</div></c:otherwise>
                  </c:choose>
              </div>
          </div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-file-medical"></i></div>
              <div class="doc-box-content">
                  <div class="label">Medical License</div>
                  <c:choose>
                      <c:when test="${not empty doctor.medicalLicensePath}">
                          <a href="${pageContext.request.contextPath}${doctor.medicalLicensePath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View medical license
                          </a>
                      </c:when>
                      <c:otherwise><div class="text-muted">Not uploaded</div></c:otherwise>
                  </c:choose>
              </div>
          </div>
          <div class="doc-box">
              <div class="doc-box-icon"><i class="fas fa-certificate"></i></div>
              <div class="doc-box-content">
                  <div class="label">Additional Certificates</div>
                  <c:choose>
                      <c:when test="${not empty doctor.additionalCertificatePath}">
                          <a href="${pageContext.request.contextPath}${doctor.additionalCertificatePath}" target="_blank" class="doc-link">
                              <i class="fas fa-external-link-alt"></i> View additional certificate
                          </a>
                      </c:when>
                      <c:otherwise><div class="text-muted">Not uploaded</div></c:otherwise>
                  </c:choose>
              </div>
          </div>

          <c:if test="${not empty pendingDraft}">
              <div class="section-title"><i class="fas fa-sync-alt"></i> Pending Re-verification Changes</div>
              <div class="alert alert-warning" style="border-radius:12px;">
                  <strong>Status:</strong> ${pendingDraft.status}<br/>
                  <c:if test="${not empty pendingDraft.adminNotes}"><strong>Admin notes:</strong> ${pendingDraft.adminNotes}<br/></c:if>
                  <c:if test="${not empty pendingDraft.submittedAt}"><strong>Submitted:</strong> ${pendingDraft.submittedAt}<br/></c:if>
                  <div class="mt-2 small text-muted">Live approved profile is preserved until these changes are approved.</div>
              </div>
          </c:if>

          <div class="section-title"><i class="fas fa-history"></i> Verification History</div>
          <c:choose>
              <c:when test="${not empty history}">
                  <div class="table-responsive mb-4">
                      <table class="table table-sm align-middle">
                          <thead>
                              <tr>
                                  <th>When</th>
                                  <th>Action</th>
                                  <th>From</th>
                                  <th>To</th>
                                  <th>Notes</th>
                              </tr>
                          </thead>
                          <tbody>
                              <c:forEach var="h" items="${history}">
                                  <tr>
                                      <td>${h.createdAt}</td>
                                      <td>${h.action}</td>
                                      <td>${h.fromStatusLabel}</td>
                                      <td>${h.toStatusLabel}</td>
                                      <td>
                                          <c:if test="${not empty h.reasons}"><div><strong>Reasons:</strong> ${h.reasons}</div></c:if>
                                          <c:if test="${not empty h.notes}">${h.notes}</c:if>
                                          <c:if test="${empty h.notes && empty h.reasons}">—</c:if>
                                      </td>
                                  </tr>
                              </c:forEach>
                          </tbody>
                      </table>
                  </div>
              </c:when>
              <c:otherwise>
                  <div class="text-muted mb-4">No verification history yet.</div>
              </c:otherwise>
          </c:choose>

          <!-- Action Buttons -->
          <div class="section-title"><i class="fas fa-gavel"></i> Admin Decision</div>
          <div class="mb-3">
              <span class="badge-status status-PENDING">${statusLabel}</span>
              <c:if test="${not empty doctor.changesRequestedNote}">
                  <div class="mt-2 text-warning small"><strong>Changes requested:</strong> ${doctor.changesRequestedNote}</div>
              </c:if>
              <c:if test="${not empty doctor.rejectionReason}">
                  <div class="mt-2 text-danger small"><strong>Rejection reason:</strong> ${doctor.rejectionReason}</div>
              </c:if>
          </div>

          <div class="mb-3">
              <label class="form-label fw-semibold">Decision notes / comments</label>
              <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the doctor (required for reject / request changes)"></textarea>
          </div>

          <div class="mb-3">
              <label class="form-label fw-semibold">Request-change reasons (optional checkboxes)</label>
              <div class="d-flex flex-wrap gap-3">
                  <label><input type="checkbox" class="reason-box" value="Professional information"> Professional information</label>
                  <label><input type="checkbox" class="reason-box" value="Clinic details"> Clinic details</label>
                  <label><input type="checkbox" class="reason-box" value="Documents"> Documents</label>
                  <label><input type="checkbox" class="reason-box" value="Availability"> Availability</label>
                  <label><input type="checkbox" class="reason-box" value="Fees"> Fees</label>
              </div>
          </div>

          <div class="action-bar">
              <form id="approveForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/verify" method="post" class="m-0 p-0">
                  <input type="hidden" name="notes" id="approveNotes">
                  <button type="submit" class="btn-verify" onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
                      <i class="fas fa-check-circle"></i> Approve
                  </button>
              </form>

              <form id="changesForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/request-changes" method="post" class="m-0 p-0">
                  <input type="hidden" name="notes" id="changesNotes">
                  <input type="hidden" name="reasons" id="changesReasons">
                  <button type="submit" class="btn btn-warning text-dark fw-semibold"
                          style="border-radius:10px;padding:12px 28px;"
                          onclick="
                            document.getElementById('changesNotes').value=document.getElementById('decisionNotes').value;
                            document.getElementById('changesReasons').value=Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                          ">
                      <i class="fas fa-edit"></i> Request Changes
                  </button>
              </form>

              <form id="rejectForm" action="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/reject" method="post" class="m-0 p-0"
                    onsubmit="return confirm('Reject this doctor?')">
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

