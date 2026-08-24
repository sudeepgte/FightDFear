<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Lawyer Dashboard | Fight D Fear</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #f43f5e;
            --navy: #1e1b4b;
            --muted: #64748b;
            --softBg: #f7f8fa;
            --success-bg: #dcfce7;
            --success-text: #166534;
            --warning-bg: #fef3c7;
            --warning-text: #b45309;
            --info-bg: #e0e7ff;
            --info-text: #3730a3;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--softBg); color: var(--navy); display: flex; min-height: 100vh; overflow-x: hidden; }

        /* Sidebar */
        .sidebar { width: 260px; background: var(--navy); border-right: none; display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; transition: transform 0.3s ease; box-shadow: 10px 0 20px rgba(0,0,0,0.05); }
        .brand { padding: 24px; font-size: 1.25rem; font-weight: 800; color: white; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .brand i { color: var(--primary); font-size: 1.5rem; }
        
        .nav-items { flex: 1; padding: 20px 10px; display: flex; flex-direction: column; gap: 8px; }
        .nav-item { padding: 12px 16px; border-radius: 12px; cursor: pointer; display: flex; align-items: center; gap: 14px; font-weight: 600; color: rgba(255, 255, 255, 0.7); transition: all 0.2s ease; border-left: 4px solid transparent; }
        .nav-item:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .nav-item.active { background: rgba(244, 63, 94, 0.15); color: white; border-left-color: var(--primary); border-radius: 0 12px 12px 0; }
        .nav-item i { font-size: 1.25rem; }

        .logout-btn { margin: 20px; padding: 12px 16px; border-radius: 12px; cursor: pointer; display: flex; align-items: center; gap: 14px; font-weight: 600; color: var(--primary); border-top: 1px solid rgba(255,255,255,0.1); transition: 0.2s; text-decoration: none;}
        .logout-btn:hover { background: var(--primary); color: white; border-color: transparent;}

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 30px 40px; display: flex; flex-direction: column; }
        .tab-section { display: none; animation: fadeIn 0.3s ease forwards; }
        .tab-section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Typography */
        h1 { font-size: 1.75rem; font-weight: 800; margin-bottom: 4px; color: var(--navy); }
        .subtitle { color: var(--muted); font-size: 0.95rem; margin-bottom: 24px; }
        
        /* Hero Card */
        .hero-card { background: white; border-radius: 20px; padding: 24px; display: flex; align-items: center; gap: 20px; box-shadow: 0 8px 30px rgba(0,0,0,0.04); margin-bottom: 24px; position: relative; overflow: hidden; }
        .hero-avatar { width: 70px; height: 70px; border-radius: 50%; background: #ffe4e6; display: flex; justify-content: center; align-items: center; font-size: 2rem; font-weight: 800; color: var(--primary); }
        .hero-info h2 { font-size: 1.35rem; font-weight: 800; margin-bottom: 6px; }
        .hero-badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; margin-bottom: 8px; }
        .badge-approved { background: var(--success-bg); color: var(--success-text); }
        .badge-pending { background: var(--warning-bg); color: var(--warning-text); }

        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 16px; padding: 20px; display: flex; flex-direction: column; align-items: flex-start; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
        .stat-val { font-size: 1.75rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; padding: 4px 12px; border-radius: 10px; }
        .stat-label { font-size: 0.85rem; font-weight: 600; color: var(--muted); }

        /* Generic Card */
        .custom-card { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 15px rgba(0,0,0,0.02); margin-bottom: 20px; }
        .card-header-title { font-size: 1.15rem; font-weight: 800; margin-bottom: 16px; display: flex; align-items: center; justify-content: space-between; }

        /* Bookings List */
        .booking-item { padding: 16px; border: 1px solid #f1f5f9; border-radius: 12px; margin-bottom: 12px; transition: 0.2s; }
        .booking-item:hover { border-color: #cbd5e1; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .b-header { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .b-title { font-weight: 700; font-size: 1.05rem; }
        .b-status { font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 8px; }
        .status-PENDING { background: var(--warning-bg); color: var(--warning-text); }
        .status-CONFIRMED, .status-ACCEPTED { background: var(--success-bg); color: var(--success-text); }
        .status-COMPLETED { background: var(--info-bg); color: var(--info-text); }
        .b-meta { font-size: 0.85rem; color: var(--muted); display: flex; gap: 16px; margin-bottom: 12px;}
        .b-meta i { margin-right: 4px; }
        .b-actions { display: flex; gap: 8px; }
        .btn-sm { padding: 6px 14px; font-size: 0.8rem; font-weight: 600; border-radius: 8px; cursor: pointer; border: none; transition: 0.2s; }
        .btn-accept { background: var(--navy); color: white; }
        .btn-accept:hover { background: #312e81; }
        .btn-complete { background: #10b981; color: white; }
        .btn-complete:hover { background: #059669; }

        /* Forms */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 0.8rem; font-weight: 700; color: var(--navy); margin-bottom: 8px; text-transform: uppercase; }
        .form-input { width: 100%; padding: 12px 16px; border: 2px solid #f1f5f9; border-radius: 10px; background: #f8fafc; font-weight: 500; font-family: 'Inter', sans-serif; transition: 0.3s; }
        .form-input:focus { outline: none; border-color: var(--primary); background: white; }
        .btn-primary { background: var(--primary); color: white; padding: 14px 24px; border: none; border-radius: 10px; font-weight: 700; cursor: pointer; transition: 0.3s; width: 100%; }
        .btn-primary:hover { filter: brightness(1.1); transform: translateY(-1px); }

        /* Alerts */
        .alert { padding: 12px 16px; border-radius: 10px; font-size: 0.9rem; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: var(--success-bg); color: var(--success-text); border: 1px solid #bbf7d0; }
        .alert-error { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; padding: 20px; }
            .form-grid { grid-template-columns: 1fr; }
            /* Add hamburger menu logic if needed, but keeping it simple for now */
        }
    </style>
</head>
<body>

    <c:set var="firstName" value="${fn:split(lawyer.fullName, ' ')[0]}" />
    <c:set var="isApproved" value="${lawyer.partnerProfileStatus == 'APPROVED'}" />
    
    <c:set var="pendingCount" value="0" />
    <c:set var="confirmedCount" value="0" />
    <c:set var="doneCount" value="0" />
    <c:forEach var="b" items="${bookings}">
        <c:if test="${b.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
        <c:if test="${b.status == 'CONFIRMED' || b.status == 'ACCEPTED' || b.status == 'PAID'}"><c:set var="confirmedCount" value="${confirmedCount + 1}" /></c:if>
        <c:if test="${b.status == 'COMPLETED'}"><c:set var="doneCount" value="${doneCount + 1}" /></c:if>
    </c:forEach>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">
            <i class="bi bi-briefcase"></i> Fight D Fear
        </div>
        <div class="nav-items">
            <div class="nav-item active" onclick="switchTab('home', this)">
                <i class="bi bi-dashboard"></i> Home
            </div>
            <div class="nav-item" onclick="switchTab('consults', this)">
                <i class="bi bi-event-note"></i> Consults
            </div>
            <div class="nav-item" onclick="switchTab('finance', this)">
                <i class="bi bi-wallet2"></i> Finance
            </div>
            <div class="nav-item" onclick="switchTab('profile', this)">
                <i class="bi bi-person"></i> Profile
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        
        <c:if test="${not empty message}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> ${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
        </c:if>

        <!-- HOME TAB -->
        <div id="home-tab" class="tab-section active">
            <h1>Good day, ${firstName}</h1>
            <p class="subtitle">Manage consultations from your lawyer dashboard.</p>

            <div class="hero-card">
                <div class="hero-avatar">
                    ${fn:substring(lawyer.fullName, 0, 1)}
                </div>
                <div class="hero-info">
                    <div style="font-size: 0.7rem; font-weight: 800; color: var(--primary); letter-spacing: 1px;">WOMEN LAWYER</div>
                    <h2>${lawyer.fullName}</h2>
                    <c:choose>
                        <c:when test="${isApproved}">
                            <div class="hero-badge badge-approved">Approved</div>
                        </c:when>
                        <c:otherwise>
                            <div class="hero-badge badge-pending">Pending Verification</div>
                        </c:otherwise>
                    </c:choose>
                    <div style="font-size: 0.85rem; color: var(--muted);">
                        <i class="bi bi-geo-alt-fill"></i> ${empty lawyer.city ? 'Location not set' : lawyer.city} &nbsp; 
                        <i class="bi bi-bookmark-fill"></i> ${empty lawyer.practiceAreas ? 'Practice areas not set' : lawyer.practiceAreas}
                    </div>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-val" style="background: var(--warning-bg);">${pendingCount}</div>
                    <div class="stat-label">New Requests</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" style="background: var(--success-bg);">${confirmedCount}</div>
                    <div class="stat-label">Confirmed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" style="background: var(--info-bg);">${doneCount}</div>
                    <div class="stat-label">Completed</div>
                </div>
            </div>

            <div class="custom-card">
                <div class="card-header-title">Recent Incoming Consults</div>
                <c:choose>
                    <c:when test="${not isApproved}">
                        <p style="color: var(--muted); font-size: 0.9rem;">Consult requests will appear here after admin approval.</p>
                    </c:when>
                    <c:when test="${empty bookings}">
                        <p style="color: var(--muted); font-size: 0.9rem;">No consultation requests yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${bookings}" end="2">
                            <div class="booking-item">
                                <div class="b-header">
                                    <div class="b-title">Booking #</div>
                                    <div class="b-status status-${b.status}">${b.status}</div>
                                </div>
                                <div class="b-meta">
                                    <span><i class="bi bi-calendar-event"></i> <fmt:parseDate value="${b.requestedTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" /><fmt:formatDate pattern="MMM dd, yyyy h:mm a" value="${parsedDate}" /></span>
                                    <span><i class="bi bi-currency-rupee"></i> ${b.totalAmount}</span>
                                </div>
                                <c:if test="${not empty b.note}">
                                    <p style="font-size: 0.85rem; margin-bottom: 10px;"><strong>Client Note:</strong> ${b.note}</p>
                                </c:if>
                            </div>
                        </c:forEach>
                        <a href="javascript:void(0)" onclick="switchTab('consults', document.querySelectorAll('.nav-item')[1])" style="font-size: 0.85rem; font-weight: 700; color: var(--primary); text-decoration: none;">View all consultations &rarr;</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- CONSULTS TAB -->
        <div id="consults-tab" class="tab-section">
            <h1>Consultations</h1>
            <p class="subtitle">Manage all your client bookings.</p>
            
            <div class="custom-card">
                <c:choose>
                    <c:when test="${not isApproved}">
                        <p style="color: var(--muted); font-size: 0.9rem;">Available after admin verification.</p>
                    </c:when>
                    <c:when test="${empty bookings}">
                        <p style="color: var(--muted); font-size: 0.9rem;">No consultations yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${bookings}">
                            <div class="booking-item">
                                <div class="b-header">
                                    <div class="b-title">Booking #</div>
                                    <div class="b-status status-${b.status}">${b.status}</div>
                                </div>
                                <div class="b-meta">
                                    <span><i class="bi bi-calendar-event"></i> <fmt:parseDate value="${b.requestedTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" /><fmt:formatDate pattern="MMM dd, yyyy h:mm a" value="${parsedDate}" /></span>
                                    <span><i class="bi bi-currency-rupee"></i> ${b.totalAmount}</span>
                                </div>
                                <c:if test="${not empty b.note}">
                                    <p style="font-size: 0.85rem; margin-bottom: 12px; background: #f8fafc; padding: 10px; border-radius: 8px;"><strong>Client Note:</strong> ${b.note}</p>
                                </c:if>
                                
                                <div class="b-actions">
                                    <c:if test="${b.status == 'PENDING'}">
                                        <button class="btn-sm btn-accept" onclick="updateStatus(, 'ACCEPTED')">Accept</button>
                                        <button class="btn-sm" style="background: #e2e8f0;" onclick="updateStatus(, 'CANCELLED')">Reject</button>
                                    </c:if>
                                    <c:if test="${b.status == 'ACCEPTED' || b.status == 'CONFIRMED' || b.status == 'PAID'}">
                                        <button class="btn-sm btn-complete" onclick="updateStatus(, 'COMPLETED')">Mark Completed</button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- FINANCE TAB -->
        <div id="finance-tab" class="tab-section">
            <h1>Finance</h1>
            <p class="subtitle">Track your earnings and payouts.</p>
            
            <div class="stats-grid">
                <div class="custom-card" style="margin-bottom: 0;">
                    <div style="display:flex; align-items: center; gap: 14px; margin-bottom: 10px;">
                        <div style="width: 40px; height: 40px; border-radius: 10px; background: rgba(244, 63, 94, 0.1); display: flex; justify-content:center; align-items:center; font-size: 1.2rem; color: var(--primary);"><i class="bi bi-wallet2"></i></div>
                        <div style="font-weight: 700; font-size: 1.1rem;">Payout Balance</div>
                    </div>
                    <p style="font-size: 0.85rem; color: var(--muted); margin-bottom: 16px;">
                        <c:choose><c:when test="${empty lawyer.upiId}">Add UPI in Profile to withdraw</c:when><c:otherwise>UPI: ${lawyer.upiId}</c:otherwise></c:choose>
                    </p>
                    <div style="font-size: 2rem; font-weight: 800; color: var(--navy);">?<fmt:formatNumber type="number" maxFractionDigits="2" value="${lawyer.payoutBalance != null ? lawyer.payoutBalance : 0}" /></div>
                </div>
            </div>
        </div>

        <!-- PROFILE TAB -->
        <div id="profile-tab" class="tab-section">
            <h1>Profile Settings</h1>
            <p class="subtitle">Keep your professional details up to date.</p>
            
            <div class="custom-card">
                <form action="${pageContext.request.contextPath}/lawyer/profile/update" method="post" enctype="multipart/form-data">
                    <div class="card-header-title">Account Details</div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-input" value="${lawyer.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Designation</label>
                            <input type="text" name="designation" class="form-input" value="${lawyer.designation}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phone" class="form-input" value="${lawyer.phone}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Profile Picture (JPG/PNG)</label>
                            <input type="file" name="profilePhoto" class="form-input" accept="image/*">
                        </div>
                    </div>

                    <div class="card-header-title mt-4">Professional Details</div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Bar Council ID</label>
                            <input type="text" name="barCouncilId" class="form-input" value="${lawyer.barCouncilId}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Practice Areas</label>
                            <input type="text" name="practiceAreas" class="form-input" value="${lawyer.practiceAreas}" placeholder="e.g. Family Law, Criminal Defense">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Chamber Address</label>
                        <input type="text" name="address" class="form-input" value="${lawyer.address}">
                    </div>
                    
                    <div class="form-grid" style="grid-template-columns: 1fr 1fr 1fr;">
                        <div class="form-group">
                            <label class="form-label">City</label>
                            <input type="text" name="city" class="form-input" value="${lawyer.city}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">State</label>
                            <input type="text" name="state" class="form-input" value="${lawyer.state}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Pincode</label>
                            <input type="text" name="pincode" class="form-input" value="${lawyer.pincode}">
                        </div>
                    </div>
                    
                    <div class="card-header-title mt-4">Availability & Fees</div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Who I Serve</label>
                            <input type="text" name="audience" class="form-input" value="${lawyer.audience}" placeholder="e.g. Women only, All">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Open Days</label>
                            <input type="text" name="openDays" class="form-input" value="${lawyer.openDays}" placeholder="e.g. Mon-Fri">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Open Time</label>
                            <input type="time" name="openTime" class="form-input" value="${lawyer.openTime}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Close Time</label>
                            <input type="time" name="closeTime" class="form-input" value="${lawyer.closeTime}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Consultation Fee (?)</label>
                            <input type="number" step="0.01" name="consultationFee" class="form-input" value="${lawyer.consultationFee}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Duration (Minutes)</label>
                            <input type="number" name="durationMinutes" class="form-input" value="${lawyer.durationMinutes}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Service Mode</label>
                            <select name="serviceMode" class="form-input">
                                <option value="Online" ${lawyer.serviceMode == 'Online' ? 'selected' : ''}>Online / Video Call</option>
                                <option value="Offline" ${lawyer.serviceMode == 'Offline' ? 'selected' : ''}>Offline / In-person</option>
                                <option value="Both" ${lawyer.serviceMode == 'Both' ? 'selected' : ''}>Both (Online & Offline)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">About / Bio</label>
                        <textarea name="bio" class="form-input" rows="4">${lawyer.bio}</textarea>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 10px;">Save Profile Changes</button>
                </form>
            </div>
        </div>

    </div>

    <script>
        function switchTab(tabId, el) {
            document.querySelectorAll('.tab-section').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            
            document.getElementById(tabId + '-tab').classList.add('active');
            el.classList.add('active');
        }

        function updateStatus(id, newStatus) {
            if(!confirm("Are you sure you want to change the status to " + newStatus + "?")) return;
            
            const formData = new FormData();
            formData.append('status', newStatus);

            fetch('${pageContext.request.contextPath}/lawyer/bookings/' + id + '/status', {
                method: 'POST',
                body: formData
            }).then(r => r.json()).then(data => {
                if(data.success) {
                    location.reload();
                } else {
                    alert("Error: " + data.message);
                }
            }).catch(e => alert("Failed to update status"));
        }
    </script>
</body>
</html>
