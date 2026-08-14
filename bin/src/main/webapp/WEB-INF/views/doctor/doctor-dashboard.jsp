<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Dashboard — SafeHer</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
</head>
<body class="dd-page">
<div class="dd-overlay" id="overlay" onclick="toggleSidebar()"></div>

<%-- ═══ SIDEBAR ═══ --%>
<aside class="dd-sidebar" id="sidebar">
  <div class="dd-sidebar-brand">
    <div class="brand-icon"><i class="bi bi-heart-pulse"></i></div>
    <div class="brand-text">SafeHer<small>Doctor Portal</small></div>
  </div>
  <div class="dd-sidebar-profile">
    <div class="avatar-placeholder">${doctor.fullName.charAt(0)}</div>
    <div class="profile-info">
      <div class="name">${doctor.fullName}</div>
      <div class="spec">${doctor.specialization}</div>
    </div>
    <div class="status-dot"></div>
  </div>
  <nav class="dd-sidebar-nav">
    <div class="dd-nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=overview" class="dd-nav-item ${section == 'overview' ? 'active' : ''}">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments" class="dd-nav-item ${section == 'appointments' ? 'active' : ''}">
      <i class="bi bi-calendar-check"></i> Appointments
      <c:if test="${appointmentCount > 0}"><span class="badge-count">${appointmentCount}</span></c:if>
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats" class="dd-nav-item ${section == 'chats' ? 'active' : ''}">
      <i class="bi bi-chat-dots"></i> Chats
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=profile" class="dd-nav-item ${section == 'profile' ? 'active' : ''}">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=earnings" class="dd-nav-item ${section == 'earnings' ? 'active' : ''}">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=schedule" class="dd-nav-item ${section == 'schedule' ? 'active' : ''}">
      <i class="bi bi-clock"></i> Schedule
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=prescriptions" class="dd-nav-item ${section == 'prescriptions' ? 'active' : ''}">
      <i class="bi bi-file-earmark-medical"></i> Prescriptions
    </a>
    <div class="dd-nav-label">Other</div>
    <a href="${pageContext.request.contextPath}/doctors/list" class="dd-nav-item">
      <i class="bi bi-people"></i> All Doctors
    </a>
  </nav>
  <div class="dd-sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="dd-nav-item" style="color:rgba(255,107,107,0.8)">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<%-- ═══ MAIN ═══ --%>
<main class="dd-main">
  <header class="dd-topbar">
    <div class="dd-topbar-left">
      <button class="dd-hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
      <div>
        <h1><c:choose>
          <c:when test="${section == 'appointments'}">Appointments</c:when>
          <c:when test="${section == 'profile'}">My Profile</c:when>
          <c:when test="${section == 'earnings'}">Earnings & Fees</c:when>
          <c:when test="${section == 'schedule'}">Schedule</c:when>
          <c:when test="${section == 'prescriptions'}">Prescriptions</c:when>
          <c:when test="${section == 'chats'}">Chats</c:when>
          <c:otherwise>Dashboard</c:otherwise>
        </c:choose></h1>
        <div class="breadcrumb-text">Welcome back, Dr. ${doctor.fullName}!</div>
      </div>
    </div>
    <div class="dd-topbar-right">
      <div class="notif-btn"><i class="bi bi-bell"></i>
        <c:if test="${pendingCount > 0}"><span class="dot"></span></c:if>
      </div>
    </div>
  </header>

  <div class="dd-content">
    <c:if test="${not empty message}">
      <div style="padding:14px 20px;border-radius:12px;background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.2);color:#0d9668;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:8px">
        <i class="bi bi-check-circle"></i> ${message}
      </div>
    </c:if>

    <%-- ══════ OVERVIEW SECTION ══════ --%>
    <c:if test="${section == 'overview'}">
      <div class="dd-stats">
        <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-calendar2-check"></i></div><div class="dd-stat-info"><h3>${appointmentCount}</h3><p>Total Appointments</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingCount}</h3><p>Pending</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-check-circle"></i></div><div class="dd-stat-info"><h3>${confirmedCount}</h3><p>Confirmed</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${doctor.consultationFee != null ? doctor.consultationFee : 0}</h3><p>Consultation Fee</p></div></div>
      </div>
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> Recent Appointments</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}"><div class="dd-empty"><i class="bi bi-calendar-x"></i><p>No appointments yet.</p></div></c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr><th>Patient</th><th>Time</th><th>Status</th><th>Actions</th></tr></thead><tbody>
              <c:forEach var="a" items="${appointments}" begin="0" end="4">
                <tr><td><div class="dd-user-cell"><div class="user-avatar">${a.user.fullName.charAt(0)}</div><span>${a.user.fullName}</span></div></td>
                <td>${a.appointmentTime}</td>
                <td><c:choose><c:when test="${a.status=='PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when><c:when test="${a.status=='CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when><c:when test="${a.status=='COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when><c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise></c:choose></td>
                <td>
                  <div style="display:flex;gap:8px;align-items:center;">
                    <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form"><select name="status"><option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option><option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option><option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option><option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option></select><button type="submit"><i class="bi bi-check2"></i></button></form>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn" style="background:#20c997"><i class="bi bi-chat-dots-fill"></i></a>
                  </div>
                </td></tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ APPOINTMENTS SECTION ══════ --%>
    <c:if test="${section == 'appointments'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> All Appointments (${appointmentCount})</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}"><div class="dd-empty"><i class="bi bi-calendar-x"></i><p>No appointments yet.</p></div></c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr><th>Patient</th><th>Date & Time</th><th>Reason</th><th>Type</th><th>Status</th><th>Actions</th></tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <tr><td><div class="dd-user-cell"><div class="user-avatar">${a.user.fullName.charAt(0)}</div><span>${a.user.fullName}</span></div></td>
                <td>${a.appointmentTime}</td>
                <td>${a.reason != null ? a.reason : '—'}</td>
                <td><c:choose><c:when test="${a.consultationType=='VIDEO'}"><span style="color:#4a90d9"><i class="bi bi-camera-video"></i> Video</span></c:when><c:when test="${a.consultationType=='CLINIC'}"><span style="color:#312e81"><i class="bi bi-hospital"></i> Clinic</span></c:when><c:otherwise><span style="color:#6b7280"><i class="bi bi-chat-dots"></i> General</span></c:otherwise></c:choose></td>
                <td><c:choose><c:when test="${a.status=='PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when><c:when test="${a.status=='CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when><c:when test="${a.status=='COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when><c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise></c:choose></td>
                <td>
                  <div style="display:flex;gap:8px;align-items:center;">
                    <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form"><select name="status"><option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option><option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option><option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option><option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option></select><button type="submit"><i class="bi bi-check2"></i></button></form>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn" style="background:#20c997"><i class="bi bi-chat-dots-fill"></i></a>
                    <c:if test="${a.consultationType=='VIDEO' && a.status=='CONFIRMED'}"><a href="${pageContext.request.contextPath}/consultation/video/${a.id}" target="_blank" class="dd-video-btn"><i class="bi bi-camera-video-fill"></i> Join</a></c:if>
                  </div>
                </td></tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ CHATS SECTION ══════ --%>
    <c:if test="${section == 'chats'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-chat-dots"></i> My Chats</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty chatUsers}"><div class="dd-empty"><i class="bi bi-chat-left-dots"></i><p>No chats available yet.</p></div></c:if>
          <c:if test="${not empty chatUsers}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr><th>User</th><th>Actions</th></tr></thead><tbody>
              <c:forEach var="u" items="${chatUsers}">
                <tr>
                  <td>
                    <div class="dd-user-cell">
                      <div class="user-avatar">${u.fullName.charAt(0)}</div>
                      <span>${u.fullName}</span>
                    </div>
                  </td>
                  <td>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${u.id}" target="_blank" class="dd-video-btn" style="background:#20c997; display: inline-flex; align-items: center; gap: 5px; padding: 6px 12px; text-decoration: none; border-radius: 6px;">
                      <i class="bi bi-chat-dots-fill"></i> Open Chat
                    </a>
                  </td>
                </tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ PROFILE SECTION ══════ --%>
    <c:if test="${section == 'profile'}">
      <!-- VIEW -->
      <div class="dd-section" id="profileView">
        <div class="dd-section-header">
          <h2><i class="bi bi-person"></i> My Profile</h2>
          <button onclick="document.getElementById('profileView').style.display='none';document.getElementById('profileEdit').style.display='block';" class="dd-btn-edit"><i class="bi bi-pencil-square"></i> Edit</button>
        </div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Full Name</span><span class="value">${doctor.fullName}</span></div>
            <div class="dd-profile-item"><span class="label">Email</span><span class="value">${doctor.email}</span></div>
            <div class="dd-profile-item"><span class="label">Phone</span><span class="value">${doctor.phone}</span></div>
            <div class="dd-profile-item"><span class="label">Gender</span><span class="value">${doctor.gender != null ? doctor.gender : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Specialization</span><span class="value">${doctor.specialization}</span></div>
            <div class="dd-profile-item"><span class="label">Qualification</span><span class="value">${doctor.qualification != null ? doctor.qualification : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Experience</span><span class="value">${doctor.experienceYears != null ? doctor.experienceYears : '—'} years</span></div>
            <div class="dd-profile-item"><span class="label">Medical Reg No.</span><span class="value">${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Hospital</span><span class="value">${doctor.hospitalName != null ? doctor.hospitalName : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Consultation Type</span><span class="value">${doctor.consultationType != null ? doctor.consultationType : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Location</span><span class="value">${doctor.locationText != null ? doctor.locationText : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Rating</span><span class="value"><i class="bi bi-star-fill" style="color:#ffd700"></i> ${doctor.rating}</span></div>
          </div>
        </div>
      </div>
      <!-- EDIT -->
      <div class="dd-section" id="profileEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Edit Profile</h2>
          <button onclick="document.getElementById('profileEdit').style.display='none';document.getElementById('profileView').style.display='block';" class="dd-btn-edit"><i class="bi bi-x-lg"></i> Cancel</button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-profile" method="post">
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Full Name</label><input type="text" name="fullName" value="${doctor.fullName}" required></div>
              <div class="dd-edit-field"><label>Email (read-only)</label><input type="email" value="${doctor.email}" disabled style="opacity:0.6"></div>
              <div class="dd-edit-field"><label>Phone</label><input type="tel" name="phone" value="${doctor.phone}" required></div>
              <div class="dd-edit-field">
                <label>Gender</label>
                <select name="gender">
                  <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                  <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                  <option value="OTHER" ${doctor.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                </select>
              </div>
              <div class="dd-edit-field">
                <label>Specialization</label>
                <select name="specialization" required>
                  <option value="Gynecologist" ${doctor.specialization == 'Gynecologist' ? 'selected' : ''}>Gynecologist</option>
                  <option value="Psychologist" ${doctor.specialization == 'Psychologist' ? 'selected' : ''}>Psychologist</option>
                  <option value="General Physician" ${doctor.specialization == 'General Physician' ? 'selected' : ''}>General Physician</option>
                  <option value="Dermatologist" ${doctor.specialization == 'Dermatologist' ? 'selected' : ''}>Dermatologist</option>
                  <option value="Pediatrician" ${doctor.specialization == 'Pediatrician' ? 'selected' : ''}>Pediatrician</option>
                  <option value="Cardiologist" ${doctor.specialization == 'Cardiologist' ? 'selected' : ''}>Cardiologist</option>
                  <option value="Neurologist" ${doctor.specialization == 'Neurologist' ? 'selected' : ''}>Neurologist</option>
                  <option value="Psychiatrist" ${doctor.specialization == 'Psychiatrist' ? 'selected' : ''}>Psychiatrist</option>
                  <option value="Nutritionist" ${doctor.specialization == 'Nutritionist' ? 'selected' : ''}>Nutritionist</option>
                  <option value="Other" ${doctor.specialization == 'Other' ? 'selected' : ''}>Other</option>
                </select>
              </div>
              <div class="dd-edit-field">
                <label>Qualification</label>
                <select name="qualification">
                  <option value="MBBS" ${doctor.qualification == 'MBBS' ? 'selected' : ''}>MBBS</option>
                  <option value="MD" ${doctor.qualification == 'MD' ? 'selected' : ''}>MD</option>
                  <option value="MS" ${doctor.qualification == 'MS' ? 'selected' : ''}>MS</option>
                  <option value="MBBS, MD" ${doctor.qualification == 'MBBS, MD' ? 'selected' : ''}>MBBS, MD</option>
                  <option value="MBBS, MS" ${doctor.qualification == 'MBBS, MS' ? 'selected' : ''}>MBBS, MS</option>
                  <option value="BDS" ${doctor.qualification == 'BDS' ? 'selected' : ''}>BDS</option>
                  <option value="BAMS" ${doctor.qualification == 'BAMS' ? 'selected' : ''}>BAMS</option>
                  <option value="PhD" ${doctor.qualification == 'PhD' ? 'selected' : ''}>PhD</option>
                  <option value="Other" ${doctor.qualification == 'Other' ? 'selected' : ''}>Other</option>
                </select>
              </div>
              <div class="dd-edit-field"><label>Experience (years)</label><input type="number" name="experienceYears" value="${doctor.experienceYears != null ? doctor.experienceYears : ''}" min="0" max="60"></div>
              <div class="dd-edit-field"><label>Medical Reg No.</label><input type="text" name="medicalRegNumber" value="${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : ''}"></div>
              <div class="dd-edit-field"><label>Hospital / Clinic</label><input type="text" name="hospitalName" value="${doctor.hospitalName != null ? doctor.hospitalName : ''}"></div>
              <div class="dd-edit-field">
                <label>Consultation Type</label>
                <select name="consultationType">
                  <option value="ONLINE" ${doctor.consultationType == 'ONLINE' ? 'selected' : ''}>Online</option>
                  <option value="OFFLINE" ${doctor.consultationType == 'OFFLINE' ? 'selected' : ''}>Offline</option>
                  <option value="BOTH" ${doctor.consultationType == 'BOTH' ? 'selected' : ''}>Both</option>
                </select>
              </div>
            </div>
            <div style="margin-top:20px;display:flex;gap:10px">
              <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Changes</button>
              <button type="button" onclick="document.getElementById('profileEdit').style.display='none';document.getElementById('profileView').style.display='block';" class="dd-btn-cancel">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </c:if>

    <%-- ══════ SCHEDULE SECTION ══════ --%>
    <c:if test="${section == 'schedule'}">
      <!-- VIEW MODE -->
      <div class="dd-section" id="scheduleView">
        <div class="dd-section-header">
          <h2><i class="bi bi-clock"></i> Schedule & Availability</h2>
          <button onclick="document.getElementById('scheduleView').style.display='none';document.getElementById('scheduleEdit').style.display='block';" class="dd-btn-edit"><i class="bi bi-pencil-square"></i> Edit</button>
        </div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Available Days</span><span class="value">${doctor.availableDays != null ? doctor.availableDays : 'Not set'}</span></div>
            <div class="dd-profile-item"><span class="label">Timing</span><span class="value">${doctor.startTime != null ? doctor.startTime : '—'} — ${doctor.endTime != null ? doctor.endTime : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Emergency</span><span class="value">${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? '✅ Yes' : '❌ No'}</span></div>
            <div class="dd-profile-item"><span class="label">Clinic Address</span><span class="value">${doctor.clinicAddress != null ? doctor.clinicAddress : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">City</span><span class="value">${doctor.city != null ? doctor.city : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">State</span><span class="value">${doctor.state != null ? doctor.state : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Pincode</span><span class="value">${doctor.pincode != null ? doctor.pincode : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Google Map</span><span class="value">${doctor.googleMapLocation != null ? doctor.googleMapLocation : '—'}</span></div>
          </div>
        </div>
      </div>

      <!-- EDIT MODE -->
      <div class="dd-section" id="scheduleEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Edit Schedule</h2>
          <button onclick="document.getElementById('scheduleEdit').style.display='none';document.getElementById('scheduleView').style.display='block';" class="dd-btn-edit"><i class="bi bi-x-lg"></i> Cancel</button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-schedule" method="post">
            <div class="dd-edit-grid">
              <div class="dd-edit-field full">
                <label>Available Days</label>
                <div class="dd-day-toggles">
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="MONDAY" ${doctor.availableDays != null && doctor.availableDays.contains('MONDAY') ? 'checked' : ''}><span>Mon</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="TUESDAY" ${doctor.availableDays != null && doctor.availableDays.contains('TUESDAY') ? 'checked' : ''}><span>Tue</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="WEDNESDAY" ${doctor.availableDays != null && doctor.availableDays.contains('WEDNESDAY') ? 'checked' : ''}><span>Wed</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="THURSDAY" ${doctor.availableDays != null && doctor.availableDays.contains('THURSDAY') ? 'checked' : ''}><span>Thu</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="FRIDAY" ${doctor.availableDays != null && doctor.availableDays.contains('FRIDAY') ? 'checked' : ''}><span>Fri</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="SATURDAY" ${doctor.availableDays != null && doctor.availableDays.contains('SATURDAY') ? 'checked' : ''}><span>Sat</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="SUNDAY" ${doctor.availableDays != null && doctor.availableDays.contains('SUNDAY') ? 'checked' : ''}><span>Sun</span></label>
                </div>
              </div>
              <div class="dd-edit-field"><label>Start Time</label><input type="time" name="startTime" value="${doctor.startTime != null ? doctor.startTime : '09:00'}"></div>
              <div class="dd-edit-field"><label>End Time</label><input type="time" name="endTime" value="${doctor.endTime != null ? doctor.endTime : '18:00'}"></div>
              <div class="dd-edit-field full">
                <label>Emergency Availability</label>
                <label class="dd-switch-label"><input type="checkbox" name="emergencyAvailable" value="yes" ${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'checked' : ''}><span class="dd-switch-track"><span class="dd-switch-thumb"></span></span> Available for emergencies</label>
              </div>
              <div class="dd-edit-field full"><label>Clinic Address</label><textarea name="clinicAddress" rows="2">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea></div>
              <div class="dd-edit-field"><label>City</label><input type="text" name="city" value="${doctor.city != null ? doctor.city : ''}"></div>
              <div class="dd-edit-field"><label>State</label><input type="text" name="state" value="${doctor.state != null ? doctor.state : ''}"></div>
              <div class="dd-edit-field"><label>Pincode</label><input type="text" name="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6"></div>
              <div class="dd-edit-field"><label>Google Map Link</label><input type="url" name="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}"></div>
            </div>
            <div style="margin-top:20px;display:flex;gap:10px">
              <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Changes</button>
              <button type="button" onclick="document.getElementById('scheduleEdit').style.display='none';document.getElementById('scheduleView').style.display='block';" class="dd-btn-cancel">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </c:if>

    <%-- ══════ EARNINGS SECTION ══════ --%>
    <c:if test="${section == 'earnings'}">

      <!-- Earnings Summary Stats -->
      <div class="dd-stats">
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${totalEarnings}</h3><p>Total Earnings</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-receipt-cutoff"></i></div><div class="dd-stat-info"><h3>${paidCount}</h3><p>Paid Bookings</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-cash-stack"></i></div><div class="dd-stat-info"><h3>&#8377;${doctor.consultationFee != null ? doctor.consultationFee : 0}</h3><p>Consultation Fee</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingCount}</h3><p>Pending</p></div></div>
      </div>

      <!-- Fee Breakdown -->
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-wallet2"></i> Fee Breakdown</h2></div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Consultation Fee</span><span class="value" style="color:#20c997;font-weight:700">&#8377; ${doctor.consultationFee != null ? doctor.consultationFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Chat Fee</span><span class="value">&#8377; ${doctor.chatFee != null ? doctor.chatFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Call Fee</span><span class="value">&#8377; ${doctor.callFee != null ? doctor.callFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Video Fee</span><span class="value">&#8377; ${doctor.videoFee != null ? doctor.videoFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">UPI ID</span><span class="value">${doctor.upiId != null ? doctor.upiId : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Bank Details</span><span class="value">${doctor.bankDetails != null ? doctor.bankDetails : '—'}</span></div>
          </div>
        </div>
      </div>

      <!-- Booking Transactions Table -->
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-table"></i> Booking Transactions (${appointmentCount})</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}">
            <div class="dd-empty"><i class="bi bi-inbox"></i><p>No bookings yet.</p></div>
          </c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr>
              <th>Patient</th>
              <th>Date & Time</th>
              <th>Reason</th>
              <th>Type</th>
              <th>Status</th>
              <th>Payment ID</th>
              <th style="text-align:right">Amount</th>
            </tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <tr>
                  <td>
                    <div class="dd-user-cell">
                      <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                      <div>
                        <span style="font-weight:600">${a.user.fullName}</span>
                        <div style="font-size:11px;color:#6b7280">${a.user.email}</div>
                      </div>
                    </div>
                  </td>
                  <td>${a.appointmentTime}</td>
                  <td>${a.reason != null ? a.reason : '—'}</td>
                  <td>
                    <c:choose>
                      <c:when test="${a.consultationType == 'VIDEO'}"><span style="color:#4a90d9"><i class="bi bi-camera-video"></i> Video</span></c:when>
                      <c:when test="${a.consultationType == 'CLINIC'}"><span style="color:#312e81"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                      <c:otherwise><span style="color:#6b7280"><i class="bi bi-chat-dots"></i> General</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${a.status == 'PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when>
                      <c:when test="${a.status == 'CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when>
                      <c:when test="${a.status == 'COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when>
                      <c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-size:11px;color:#6b7280;font-family:monospace">${a.razorpayPaymentId != null ? a.razorpayPaymentId : '—'}</td>
                  <td style="text-align:right;font-weight:700;color:#20c997">
                    <c:choose>
                      <c:when test="${a.amountPaid != null && a.amountPaid > 0}">&#8377;${a.amountPaid}</c:when>
                      <c:otherwise><span style="color:#6b7280;font-weight:400">Unpaid</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ PRESCRIPTIONS SECTION ══════ --%>
    <c:if test="${section == 'prescriptions'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-file-earmark-medical"></i> Patient Prescriptions</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}">
            <div class="dd-empty"><i class="bi bi-inbox"></i><p>No appointments found.</p></div>
          </c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr>
              <th>Patient</th>
              <th>Date & Time</th>
              <th>Status</th>
              <th>Prescription</th>
              <th>Action</th>
            </tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <c:if test="${a.status == 'COMPLETED'}">
                  <tr>
                    <td>
                      <div class="dd-user-cell">
                        <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                        <div>
                          <span style="font-weight:600">${a.user.fullName}</span>
                        </div>
                      </div>
                    </td>
                    <td>${a.appointmentTime}</td>
                    <td><span class="dd-badge completed"><span class="dot"></span> Completed</span></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty a.prescriptionText}"><span style="color:#20c997;font-weight:600"><i class="bi bi-check-circle"></i> Written</span></c:when>
                        <c:otherwise><span style="color:#6b7280">Not Written</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <textarea id="presc-data-${a.id}" style="display:none;" data-patient-name="<c:out value='${a.user.fullName}'/>"><c:out value="${a.prescriptionText}" /></textarea>
                      <button type="button" class="dd-btn-edit" style="font-size:12px;padding:6px 12px;" onclick="openPrescriptionModal('${a.id}')">
                        <i class="bi bi-pencil-square"></i> ${empty a.prescriptionText ? 'Write' : 'Edit'}
                      </button>
                    </td>
                  </tr>
                </c:if>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
      
      <!-- Prescription Modal -->
      <div id="prescriptionModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:#fff;border-radius:16px;width:100%;max-width:500px;padding:24px;box-shadow:0 10px 40px rgba(0,0,0,0.2);">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
            <h3 style="margin:0;font-size:18px;font-weight:700;"><i class="bi bi-file-earmark-medical" style="color:var(--dd-purple-l)"></i> Write Prescription</h3>
            <button type="button" onclick="closePrescriptionModal()" style="background:transparent;border:none;font-size:20px;cursor:pointer;color:var(--dd-muted)"><i class="bi bi-x-lg"></i></button>
          </div>
          <form id="prescriptionForm" method="post" action="">
            <div style="margin-bottom:16px;">
              <label style="display:block;font-size:12px;font-weight:600;color:var(--dd-muted);margin-bottom:6px;">Patient</label>
              <input type="text" id="prescPatientName" readonly style="width:100%;padding:10px 14px;border:2px solid var(--dd-border);border-radius:10px;font-size:13px;background:var(--dd-bg);outline:none;font-family:'Poppins',sans-serif;">
            </div>
            <div style="margin-bottom:20px;">
              <label style="display:block;font-size:12px;font-weight:600;color:var(--dd-muted);margin-bottom:6px;">Prescription / Rx</label>
              <textarea name="prescriptionText" id="prescText" rows="6" required placeholder="Write medicines, dosage, and instructions here..." style="width:100%;padding:10px 14px;border:2px solid var(--dd-border);border-radius:10px;font-size:13px;outline:none;font-family:'Poppins',sans-serif;resize:vertical;"></textarea>
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
              <button type="button" onclick="closePrescriptionModal()" style="padding:10px 20px;border:none;border-radius:999px;background:rgba(107,114,128,0.1);color:var(--dd-muted);font-size:13px;font-weight:600;cursor:pointer;">Cancel</button>
              <button type="submit" style="padding:10px 20px;border:none;border-radius:999px;background:var(--dd-gradient);color:#fff;font-size:13px;font-weight:700;cursor:pointer;box-shadow:0 4px 12px rgba(123,44,191,0.2);">Save Prescription</button>
            </div>
          </form>
        </div>
      </div>
      <script>
      function openPrescriptionModal(apptId) {
          var dataElem = document.getElementById('presc-data-' + apptId);
          document.getElementById('prescriptionForm').action = '${pageContext.request.contextPath}/doctors/appointments/' + apptId + '/prescription';
          document.getElementById('prescPatientName').value = dataElem.getAttribute('data-patient-name');
          document.getElementById('prescText').value = dataElem.value;
          document.getElementById('prescriptionModal').style.display = 'flex';
      }
      function closePrescriptionModal() {
          document.getElementById('prescriptionModal').style.display = 'none';
      }
      </script>
    </c:if>

  </div>
</main>

<script>
function toggleSidebar(){document.getElementById('sidebar').classList.toggle('open');document.getElementById('overlay').classList.toggle('show');}
</script>
</body>
</html>

