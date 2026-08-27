<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Doctor Profile &mdash; Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-page); color: var(--navy); }
        
        /* Top Navigation */
        .top-nav {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .brand { display: flex; align-items: center; gap: 10px; font-weight: 800; font-size: 1.15rem; color: var(--navy); text-decoration: none; }
        .brand img { height: 32px; width: 32px; border-radius: 8px; }
        .actions { display: flex; gap: 12px; align-items: center; }
        
        .btn { padding: 8px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem; cursor: pointer; transition: 0.2s; border: none; text-decoration: none; }
        .btn-outline { background: transparent; color: var(--navy); border: 1px solid var(--border-color); }
        .btn-outline:hover { background: #f1f5f9; }
        .btn-primary { background: var(--navy); color: #fff; }
        .btn-primary:hover { background: #312e81; }
        
        /* Layout */
        .layout { display: flex; gap: 30px; max-width: 1200px; margin: 30px auto; padding: 0 20px; align-items: flex-start; }
        .main-col { flex: 1; }
        .side-col { width: 380px; position: sticky; top: 90px; }
        
        /* Progress Box */
        .progress-box { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border-color); padding: 20px; margin-bottom: 24px; }
        .progress-header { display: flex; justify-content: space-between; font-weight: 800; margin-bottom: 12px; }
        .progress-bar-bg { height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden; margin-bottom: 15px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: ${profileCompletion}%; transition: 1s ease-out; }
        .badge { background: #e2e8f0; color: #475569; padding: 4px 10px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
        
        /* Form Sections */
        .form-section { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; margin-bottom: 24px; }
        .form-section h3 { font-size: 1.1rem; font-weight: 800; margin-bottom: 20px; color: var(--navy); }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px; color: var(--navy); }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 8px; font-family: inherit; font-size: 0.95rem; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(244,63,94,0.1); }
        
        /* Submit area */
        .submit-area { background: var(--primary); color: white; padding: 16px; border-radius: 12px; text-align: center; font-weight: 700; cursor: pointer; border: none; width: 100%; font-size: 1.05rem; box-shadow: 0 4px 15px rgba(244,63,94,0.3); transition: 0.2s; }
        .submit-area:hover { background: var(--primary-hover); transform: translateY(-2px); }
        
        /* Live Preview Card */
        .preview-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border-color); overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .preview-header { background: var(--navy); color: white; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }
        .preview-header span.tag { background: var(--primary); font-size: 0.7rem; font-weight: 800; padding: 4px 10px; border-radius: 50px; }
        .preview-body { padding: 24px; }
        .avatar { width: 80px; height: 80px; border-radius: 20px; background: #FFE4E6; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 800; margin-bottom: 16px; }
        .p-name { font-size: 1.4rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; }
        .p-subtitle { color: var(--text-gray); font-size: 0.9rem; margin-bottom: 16px; font-weight: 500; }
        .p-badge { background: #F0FDF4; color: #16A34A; display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; margin-bottom: 20px; }
        
        .p-box { background: var(--bg-page); border: 1px solid var(--border-color); border-radius: 8px; padding: 12px; margin-bottom: 16px; }
        .p-box-title { font-size: 0.75rem; font-weight: 700; color: var(--text-gray); text-transform: uppercase; margin-bottom: 4px; }
        .p-box-value { font-weight: 600; color: var(--navy); font-size: 0.95rem; }
        
        .info-note { font-size: 0.8rem; color: var(--text-gray); display: flex; align-items: center; gap: 6px; }
        
        @media (max-width: 900px) {
            .layout { flex-direction: column; }
            .side-col { width: 100%; position: relative; top: 0; }
        }
    </style>
</head>
<body>
    
    <form action="${pageContext.request.contextPath}/doctors/profile-completion" method="post" enctype="multipart/form-data" id="profileForm">
        <!-- Top Navigation -->
        <header class="top-nav">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"> Fight D Fear
            </a>
            <div class="actions">
                
                <button type="submit" name="action" value="skip" class="btn btn-outline" formnovalidate>Skip for now</button>
                <button type="submit" name="action" value="save" class="btn btn-primary">Save Profile</button>
            </div>
        </header>

        <div class="layout">
            <!-- Main Content Form -->
            <div class="main-col">
                <div class="progress-box">
                    <div class="progress-header">
                        <span>Profile Completion: ${profileCompletion}%</span>
                        <span class="badge">REGISTERED</span>
                    </div>
                    <div class="progress-bar-bg"><div class="progress-bar-fill"></div></div>
                    <p style="font-size: 0.85rem; color: var(--text-gray);">Complete all required sections below to build your public directory profile.</p>
                </div>
                
                <button type="submit" name="action" value="save" class="submit-area mb-4" style="margin-bottom: 24px;">
                    <i class="bi bi-cloud-arrow-up"></i> Save & View Dashboard
                </button>

                <div class="form-section">
                    <h3>1. Doctor Identity</h3>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="fullName" class="form-control" value="${doctor.fullName}" required oninput="document.getElementById('prevName').innerText = this.value || 'Doctor Name'">
                        </div>
                        <div class="form-group">
                            <label>Gender *</label>
                            <select name="gender" class="form-control" required>
                                <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Mobile Number *</label>
                            <input type="tel" name="phone" class="form-control" value="${doctor.phone}" required>
                        </div>
                        <div class="form-group">
                            <label>Profile Image (Optional)</label>
                            <input type="file" name="profilePhoto" class="form-control" accept="image/*">
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>2. Professional Details</h3>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Specialization *</label>
                            <input type="text" name="specialization" class="form-control" value="${doctor.specialization}" placeholder="e.g. Gynecologist, Psychologist" required oninput="document.getElementById('prevSpec').innerText = this.value || 'Specialist'">
                        </div>
                        <div class="form-group">
                            <label>Experience (Years) *</label>
                            <input type="number" name="experienceYears" class="form-control" value="${doctor.experienceYears}" placeholder="e.g. 8" required oninput="document.getElementById('prevExp').innerText = (this.value ? this.value + ' Years Experience' : 'Experience')">
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Medical Reg Number *</label>
                            <input type="text" name="medicalRegNumber" class="form-control" value="${doctor.medicalRegNumber}" placeholder="e.g. MED-12345" required>
                        </div>
                        <div class="form-group">
                            <label>Highest Qualification *</label>
                            <input type="text" name="qualification" class="form-control" value="${doctor.qualification}" placeholder="e.g. MBBS, MD" required oninput="document.getElementById('prevQual').innerText = this.value || 'Qualification'">
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Current Hospital / Clinic</label>
                            <input type="text" name="hospitalName" class="form-control" value="${doctor.hospitalName}" placeholder="e.g. City Care Hospital">
                        </div>
                        <div class="form-group">
                            <label>Base Consultation Fee (&#8377;) *</label>
                            <input type="number" name="consultationFee" class="form-control" value="${doctor.consultationFee}" placeholder="500" required oninput="document.getElementById('prevFee').innerText = '&#8377;' + (this.value || '0')">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Medical License Document (PDF/Image)</label>
                        <input type="file" name="medicalLicense" class="form-control" accept="image/*,.pdf">
                    </div>
                </div>
            </div>

            <!-- Sidebar Live Preview -->
            <div class="side-col">
                <div class="preview-card">
                    <div class="preview-header">
                        <span class="tag"><i class="bi bi-circle-fill" style="font-size: 8px; margin-right: 4px;"></i> LIVE PREVIEW</span>
                        <span style="font-size: 0.75rem; font-weight: 700;">DOCTOR PROFILE</span>
                    </div>
                    <div class="preview-body">
                        <div class="avatar">
                            <c:choose>
                                <c:when test="${not empty doctor.profilePhotoPath}">
                                    <img src="${pageContext.request.contextPath}" style="width: 100%; height: 100%; border-radius: 20px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    ${not empty doctor.fullName ? doctor.fullName.substring(0,1) : 'D'}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="p-name" id="prevName">${not empty doctor.fullName ? doctor.fullName : 'Doctor Name'}</div>
                        <div class="p-subtitle" id="prevSpec">${not empty doctor.specialization ? doctor.specialization : 'Specialist'}</div>
                        <div class="p-badge"><i class="bi bi-patch-check-fill"></i> Verified Professional</div>
                        
                        <div class="p-box">
                            <div class="p-box-title">Qualification & Experience</div>
                            <div class="p-box-value"><span id="prevQual">${not empty doctor.qualification ? doctor.qualification : 'Qualification'}</span> &bull; <span id="prevExp">${not empty doctor.experienceYears ? doctor.experienceYears : '0'} Years Experience</span></div>
                        </div>
                        
                        <div class="p-box">
                            <div class="p-box-title">Consultation Fee</div>
                            <div class="p-box-value" id="prevFee" style="color: var(--primary);">&#8377;${not empty doctor.consultationFee ? doctor.consultationFee : '500'}</div>
                        </div>
                        
                        <div class="info-note mt-3">
                            <i class="bi bi-info-circle"></i> Public client preview &bull; Updates live as you type
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>


