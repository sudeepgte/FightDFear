<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Stylist Audit Center — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary-accent: #F43F5E;
    --accent-dark: #E11D48;
    --text-muted: #64748B;
    --bg-page: #F8FAFC;
    --bg-card: #FFFFFF;
    
    --success-bg: #F0FDF4;
    --success-text: #16A34A;
    --success-border: #DCFCE7;
    
    --warning-bg: #FFF7ED;
    --warning-text: #C2410C;
    --warning-border: #FFEDD5;
    
    --danger-bg: #FEF2F2;
    --danger-text: #DC2626;
    --danger-border: #FEE2E2;

    --shadow-premium: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
  }
  
  body { 
    font-family:'Poppins', sans-serif; 
    background: var(--bg-page); 
    color: #0F172A; 
    margin: 0; 
    padding: 0;
  }

  /* Header Section */
  .hero-banner {
    background: linear-gradient(135deg, var(--accent-dark) 0%, var(--primary-accent) 100%);
    padding: 20px 20px 25px;
    color: white;
    text-align: center;
    position: relative;
    box-shadow: 0 2px 10px rgba(244, 63, 94, 0.15);
  }

  .nav-back-container {
    position: absolute;
    top: 15px;
    left: 20px;
  }

  .btn-minimal-back {
    background: rgba(255, 255, 255, 0.15);
    border: 1px solid rgba(255, 255, 255, 0.3);
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
    color: var(--primary-accent);
  }

  /* Main Profile Card */
  .audit-card {
    max-width: 850px;
    margin: 30px auto 50px;
    background: var(--bg-card);
    border-radius: 12px;
    box-shadow: var(--shadow-premium);
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
    background: var(--bg-card);
  }

  .stylist-img-frame {
    width: 110px;
    height: 110px;
    border-radius: 50%; /* Circle for individual profile */
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    border: 3px solid var(--bg-page);
    flex-shrink: 0;
  }

  .stylist-img-frame img { width: 100%; height: 100%; object-fit: cover; }

  .stylist-info h2 { font-weight: 700; color: #0F172A; margin: 0 0 4px 0; font-size: 1.5rem; }
  .stylist-meta { color: var(--text-muted); font-size: 0.85rem; margin-bottom: 10px; }
  
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
  .status-pill.verified { background: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); }
  .status-pill.pending { background: var(--warning-bg); color: var(--warning-text); border: 1px solid var(--warning-border); }

  /* Grid Layout */
  .audit-body { padding: 30px 35px; }
  
  .data-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  .data-section {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 12px;
    padding: 20px;
    transition: all 0.2s ease;
  }
  .data-section:hover {
    border-color: var(--primary-accent);
    box-shadow: 0 5px 15px rgba(244, 63, 94, 0.08);
    transform: translateY(-2px);
  }

  .section-heading {
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--primary-accent);
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .field-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px solid #F1F5F9;
  }
  .field-row:last-child { border: none; }
  .field-label { color: var(--text-muted); font-size: 0.8rem; }
  .field-value { color: #0F172A; font-weight: 600; font-size: 0.85rem; }

  .about-box {
    grid-column: span 2;
    background: var(--bg-page);
    padding: 20px;
    border-radius: 12px;
    border-left: 3px solid var(--primary-accent);
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
  .btn-approve { background: var(--success-text); color: white; }
  .btn-approve:hover { background: #15803D; transform: scale(1.02); }
  .btn-reject { background: var(--danger-text); color: white; }
  .btn-reject:hover { background: #B91C1C; transform: scale(1.02); }

  /* Mobile Responsiveness */
  @media (max-width: 768px) {
    .nav-back-container {
      position: static;
      margin-bottom: 15px;
      text-align: left;
    }
    .hero-banner {
      padding: 15px 15px 25px;
    }
    .hero-banner h1 {
      font-size: 1.5rem;
    }
    .audit-card {
      margin: 15px;
    }
    .audit-header {
      flex-direction: column;
      text-align: center;
      gap: 15px;
    }
    .data-grid {
      grid-template-columns: 1fr;
    }
    .about-box {
      grid-column: 1;
    }
    .audit-body {
      padding: 20px;
    }
    .audit-actions {
      flex-direction: column;
    }
    .btn-action {
      width: 100%;
    }
  }

</style>
</head>
<body>

<div class="hero-banner">
  <div class="nav-back-container">
    <a href="${pageContext.request.contextPath}/admin/stylists" class="btn-minimal-back">
      <i class="fas fa-arrow-left me-2"></i> Back to Queue
    </a>
  </div>
  <h1 class="fw-bold mb-1">Stylist Audit Center</h1>
  <p class="opacity-75">Professional Verification ID: STY-00${stylist.id}</p>
</div>

<div class="audit-card">
  <div class="audit-header">
    <div class="stylist-img-frame">
      <c:choose>
        <c:when test="${not empty stylist.profileImage}">
          <img src="${stylist.profileImage}" alt="Stylist">
        </c:when>
        <c:otherwise>
          <div class="h-100 d-flex align-items-center justify-content-center bg-light text-muted fs-1 fw-bold">
            ${stylist.firstName.substring(0,1)}
          </div>
        </c:otherwise>
      </c:choose>
    </div>
    
    <div class="stylist-info">
      <c:choose>
        <c:when test="${stylist.approved}">
          <span class="status-pill verified"><i class="fas fa-check-circle me-1"></i> Verified Partner</span>
        </c:when>
        <c:otherwise>
          <span class="status-pill pending"><i class="fas fa-clock me-1"></i> Pending Audit</span>
        </c:otherwise>
      </c:choose>
      <h2>${stylist.firstName} ${stylist.lastName}</h2>
      <div class="stylist-meta">
        <i class="fas fa-star text-warning me-1"></i> <strong>${stylist.rating}</strong> Rating • ${stylist.specialization}
      </div>
    </div>
  </div>

  <div class="audit-body">
    <div class="data-grid">
      
      <!-- Section: Professional Info -->
      <div class="data-section">
        <div class="section-heading"><i class="fas fa-user-tie"></i> Professional Profile</div>
        <div class="field-row"><span class="field-label">Specialization</span><span class="field-value">${stylist.specialization}</span></div>
        <div class="field-row"><span class="field-label">Experience</span><span class="field-value">${stylist.experienceInYears} Years</span></div>
        <div class="field-row"><span class="field-label">Working At</span><span class="field-value">${not empty stylist.salon ? stylist.salon.name : 'Independent'}</span></div>
        <div class="field-row"><span class="field-label">Account Type</span><span class="field-value">${stylist.isIndependent ? 'Independent Contractor' : 'Salon Employee'}</span></div>
      </div>

      <!-- Section: Contact Details -->
      <div class="data-section">
        <div class="section-heading"><i class="fas fa-id-card"></i> Identity & Contact</div>
        <div class="field-row"><span class="field-label">Email Address</span><span class="field-value text-lowercase">${stylist.email}</span></div>
        <div class="field-row"><span class="field-label">Phone Number</span><span class="field-value">${stylist.contactNumber}</span></div>
        <div class="field-row"><span class="field-label">Registered Date</span><span class="field-value">${stylist.createdAt.toLocalDate()}</span></div>
        <div class="field-row"><span class="field-label">Current Status</span><span class="field-value text-success">${stylist.available ? 'Available' : 'Offline'}</span></div>
      </div>

      <!-- Section: Bio/About -->
      <div class="about-box">
        <div class="section-heading"><i class="fas fa-quote-left"></i> Professional Bio</div>
        <p class="mb-0 text-muted small" style="line-height: 1.6;">
          ${not empty stylist.bio ? stylist.bio : 'No professional biography has been provided for this stylist.'}
        </p>
      </div>

    </div>
  </div>

  <c:if test="${not stylist.approved}">
    <div class="audit-actions">
      <form action="${pageContext.request.contextPath}/admin/stylists/${stylist.id}/approve" method="post">
        <button type="submit" class="btn-action btn-approve"><i class="fas fa-check me-2"></i> Approve Stylist</button>
      </form>
      <form action="${pageContext.request.contextPath}/admin/stylists/${stylist.id}/reject" method="post" onsubmit="return confirm('Reject and delete this profile?');">
        <button type="submit" class="btn-action btn-reject"><i class="fas fa-times me-2"></i> Reject Profile</button>
      </form>
    </div>
  </c:if>
</div>

</body>
</html>
