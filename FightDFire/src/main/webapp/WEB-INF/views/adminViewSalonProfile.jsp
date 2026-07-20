<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Salon Audit Center — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary-maroon: #1e1b4b;
    --maroon-dark: #4A1536;
    --maroon-light: #312e81;
    --bg-light: #FDF9FB;
    --shadow-premium: 0 15px 40px rgba(74, 21, 54, 0.08);
  }
  
  body { 
    font-family:'Poppins', sans-serif; 
    background: var(--bg-light); 
    color: #2D3748; 
    margin: 0; 
    padding: 0;
  }

  /* Header Section */
  .hero-banner {
    background: linear-gradient(135deg, var(--maroon-dark) 0%, var(--primary-maroon) 100%);
    padding: 20px 20px 25px;
    color: white;
    text-align: center;
    position: relative;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }

  .nav-back-container {
    position: absolute;
    top: 15px;
    left: 20px;
  }

  .btn-minimal-back {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    padding: 6px 12px;
    border-radius: 6px;
    text-decoration: none;
    font-size: 0.8rem;
    font-weight: 500;
    transition: 0.3s;
  }

  .btn-minimal-back:hover {
    background: white;
    color: var(--primary-maroon);
  }

  /* Main Profile Card */
  .audit-card {
    max-width: 850px;
    margin: 30px auto 50px; /* Changed to positive margin to remove overlap */
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    overflow: hidden;
    border: 1px solid #E2E8F0;
    transition: transform 0.3s ease;
  }

  .audit-header {
    padding: 20px 30px;
    display: flex;
    align-items: center;
    gap: 25px;
    border-bottom: 1px solid #EDF2F7;
    background: #FFF;
  }

  .salon-img-frame {
    width: 110px;
    height: 110px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border: 1px solid #E2E8F0;
    flex-shrink: 0;
  }

  .salon-img-frame img { width: 100%; height: 100%; object-fit: cover; }

  .salon-info h2 { font-weight: 700; color: #1A202C; margin: 0 0 4px 0; font-size: 1.5rem; }
  .salon-meta { color: #718096; font-size: 0.85rem; margin-bottom: 10px; }
  
  .status-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 12px;
    border-radius: 50px;
    font-size: 0.7rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  .status-pill.verified { background: #E6FFFA; color: #047481; border: 1px solid #B2F5EA; }
  .status-pill.pending { background: #FFF5F5; color: #C53030; border: 1px solid #FED7D7; }

  /* Grid Layout */
  .audit-body { padding: 30px 35px; }
  
  .data-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  .data-section {
    background: #FCFDFF;
    border: 1px solid #EDF2F7;
    border-radius: 12px;
    padding: 20px;
    transition: all 0.2s ease;
  }
  .data-section:hover {
    border-color: var(--primary-maroon);
    box-shadow: 0 5px 15px rgba(124, 45, 94, 0.05);
    transform: translateY(-2px);
  }

  .section-heading {
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--primary-maroon);
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .field-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px solid #F7FAFC;
  }
  .field-row:last-child { border: none; }
  .field-label { color: #718096; font-size: 0.8rem; }
  .field-value { color: #2D3748; font-weight: 600; font-size: 0.85rem; }

  .about-box {
    grid-column: span 2;
    background: #F8FAFC;
    padding: 20px;
    border-radius: 12px;
    border-left: 3px solid var(--primary-maroon);
    transition: 0.2s;
  }
  .about-box:hover { background: #F1F5F9; }

  /* Actions */
  .audit-actions {
    padding: 20px 35px;
    background: #F9FAFB;
    border-top: 1px solid #F1F5F9;
    text-align: center;
    display: flex;
    justify-content: center;
    gap: 12px;
  }

  .btn-action {
    padding: 10px 30px;
    border-radius: 8px;
    font-weight: 600;
    border: none;
    transition: 0.2s;
    font-size: 0.9rem;
  }
  .btn-approve { background: #38A169; color: white; }
  .btn-approve:hover { background: #2F855A; transform: scale(1.02); }
  .btn-reject { background: #E53E3E; color: white; }
  .btn-reject:hover { background: #C53030; transform: scale(1.02); }

  /* ── MOBILE RESPONSIVE ── */

  /* Tablets */
  @media (max-width: 900px) {
    .audit-card { margin: 20px 16px 40px; }
    .audit-body { padding: 24px 20px; }
    .audit-actions { padding: 16px 20px; }
  }

  /* Phones */
  @media (max-width: 600px) {
    /* Hero banner */
    .hero-banner { padding: 50px 16px 18px; }
    .hero-banner h1 { font-size: 1.2rem; }
    .hero-banner p { font-size: 0.78rem; }
    .nav-back-container { top: 10px; left: 12px; }
    .btn-minimal-back { font-size: 0.72rem; padding: 5px 10px; }

    /* Audit card */
    .audit-card { margin: 16px 8px 30px; border-radius: 10px; }

    /* Header: stack vertically */
    .audit-header {
      flex-direction: column;
      align-items: center;
      text-align: center;
      gap: 14px;
      padding: 18px 16px;
    }
    .salon-img-frame { width: 80px; height: 80px; border-radius: 10px; }
    .salon-info h2 { font-size: 1.15rem; }
    .salon-meta { font-size: 0.78rem; }

    /* Body */
    .audit-body { padding: 18px 14px; }

    /* Data grid: single column */
    .data-grid {
      grid-template-columns: 1fr;
      gap: 14px;
    }

    /* About box: full width */
    .about-box { grid-column: span 1; }

    /* Data sections */
    .data-section { padding: 14px; border-radius: 10px; }
    .section-heading { font-size: 0.82rem; margin-bottom: 10px; }

    /* Field rows */
    .field-row { padding: 6px 0; }
    .field-label { font-size: 0.75rem; }
    .field-value { font-size: 0.78rem; max-width: 55%; text-align: right; word-break: break-word; }

    /* Actions */
    .audit-actions {
      flex-direction: column;
      padding: 16px 14px;
      gap: 10px;
    }
    .btn-action {
      width: 100%;
      padding: 12px 20px;
      font-size: 0.88rem;
    }
  }

  /* Very small phones */
  @media (max-width: 380px) {
    .hero-banner h1 { font-size: 1.05rem; }
    .audit-card { margin: 10px 4px 20px; }
    .audit-header { padding: 14px 10px; }
    .salon-img-frame { width: 64px; height: 64px; }
    .salon-info h2 { font-size: 1rem; }
    .audit-body { padding: 14px 10px; }
    .data-section { padding: 10px; }
    .field-label { font-size: 0.7rem; }
    .field-value { font-size: 0.72rem; }
  }

</style>
</head>
<body>

<div class="hero-banner">
  <div class="nav-back-container">
    <a href="${pageContext.request.contextPath}/admin/salons" class="btn-minimal-back">
      <i class="fas fa-arrow-left me-2"></i> Back to Queue
    </a>
  </div>
  <h1 class="fw-bold mb-1">Business Audit Center</h1>
  <p class="opacity-75">Verification ID: SAL-00${salon.id}</p>
</div>

<div class="audit-card">
  <div class="audit-header">
    <div class="salon-img-frame">
      <c:choose>
        <c:when test="${not empty salon.profileImageUrl}">
          <img src="${salon.profileImageUrl}" alt="Salon">
        </c:when>
        <c:otherwise>
          <div class="h-100 d-flex align-items-center justify-content-center bg-light text-muted fs-1 fw-bold">
            ${salon.name.substring(0,1)}
          </div>
        </c:otherwise>
      </c:choose>
    </div>
    
    <div class="salon-info">
      <c:choose>
        <c:when test="${salon.approved}">
          <span class="status-pill verified"><i class="fas fa-check-circle me-1"></i> Verified</span>
        </c:when>
        <c:otherwise>
          <span class="status-pill pending"><i class="fas fa-clock me-1"></i> Pending Review</span>
        </c:otherwise>
      </c:choose>
      <h2>${salon.name}</h2>
      <div class="salon-meta">
        <i class="fas fa-map-pin me-2"></i> ${salon.address}, ${salon.city}
      </div>
    </div>
  </div>

  <div class="audit-body">
    <div class="data-grid">
      
      <!-- Section: Details -->
      <div class="data-section">
        <div class="section-heading"><i class="fas fa-building"></i> Business Details</div>
        <div class="field-row"><span class="field-label">Est. Year</span><span class="field-value">${salon.establishedYear}</span></div>
        <div class="field-row"><span class="field-label">Working Hours</span><span class="field-value">${salon.availabilityHours}</span></div>
        <div class="field-row"><span class="field-label">Eco-Friendly</span><span class="field-value">${salon.isEcoFriendly ? 'Yes' : 'No'}</span></div>
        <div class="field-row"><span class="field-label">Hygiene Cert</span><span class="field-value">${salon.sanitationRating} / 5.0</span></div>
      </div>

      <!-- Section: Security -->
      <div class="data-section">
        <div class="section-heading"><i class="fas fa-lock"></i> Security & Contact</div>
        <div class="field-row"><span class="field-label">Email</span><span class="field-value">${salon.email}</span></div>
        <div class="field-row"><span class="field-label">Phone</span><span class="field-value">${salon.phone}</span></div>
        <div class="field-row"><span class="field-label">Portal ID</span><span class="field-value">${salon.username}</span></div>
        <div class="field-row"><span class="field-label">Website</span><span class="field-value text-primary">${not empty salon.website ? salon.website : 'None'}</span></div>
      </div>

      <!-- Section: About -->
      <div class="about-box">
        <div class="section-heading"><i class="fas fa-file-alt"></i> Business Summary</div>
        <p class="mb-0 text-muted small" style="line-height: 1.6;">
          ${not empty salon.bio ? salon.bio : 'The business owner has not provided a bio.'}
        </p>
      </div>

    </div>
  </div>

  <c:if test="${not salon.approved}">
    <div class="audit-actions">
      <form action="${pageContext.request.contextPath}/admin/salons/${salon.id}/approve" method="post">
        <button type="submit" class="btn-action btn-approve"><i class="fas fa-check me-2"></i> Approve Business</button>
      </form>
      <form action="${pageContext.request.contextPath}/admin/salons/${salon.id}/reject" method="post">
        <button type="submit" class="btn-action btn-reject"><i class="fas fa-times me-2"></i> Reject Salon</button>
      </form>
    </div>
  </c:if>
</div>

</body>
</html>
