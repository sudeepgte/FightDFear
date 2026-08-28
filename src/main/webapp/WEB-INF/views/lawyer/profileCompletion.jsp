<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Complete Lawyer Profile | Fight D Fear</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --navy: #0F172A;
            --border: #E2E8F0;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--navy); display: flex; flex-direction: column; min-height: 100vh; }

        /* Top Bar */
        .topbar { background: var(--card-bg); padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 50; }
        .brand { font-size: 1.25rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .brand i { color: var(--primary); font-size: 1.5rem; }
        .topbar-actions { display: flex; gap: 12px; }
        .btn-skip { background: transparent; color: var(--navy); padding: 10px 20px; border: 1px solid var(--border); border-radius: 20px; font-weight: 600; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .btn-skip:hover { background: #f1f5f9; }
        .btn-save { background: var(--navy); color: white; padding: 10px 20px; border: none; border-radius: 20px; font-weight: 600; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; text-decoration: none;}
        .btn-save:hover { background: #1e293b; }

        /* Main Container */
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; width: 100%; }

        /* Left Side: Form */
        .form-section { background: var(--card-bg); border-radius: 16px; padding: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); border: 1px solid var(--border); }
        .progress-box { margin-bottom: 24px; }
        .progress-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .progress-header h2 { font-size: 1.15rem; font-weight: 800; }
        .status-badge { background: #e2e8f0; color: var(--secondary); font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 6px; text-transform: uppercase; }
        
        .progress-bar-bg { width: 100%; height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden; margin-bottom: 12px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: ${lawyer.profileCompletionPct != null ? lawyer.profileCompletionPct : 0}%; transition: 0.3s; }
        .progress-text { font-size: 0.85rem; color: var(--secondary); margin-bottom: 12px; }
        
        .steps { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 24px; }
        .step-badge { font-size: 0.75rem; font-weight: 600; color: var(--warning-text); background: var(--warning-bg); border: 1px solid #fed7aa; padding: 4px 10px; border-radius: 20px; display: flex; align-items: center; gap: 4px; }
        
        .btn-submit-admin { width: 100%; background: var(--primary); color: white; padding: 14px; border: none; border-radius: 12px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 30px; }
        .btn-submit-admin:hover { background: var(--primary-hover); }

        .section-title { font-size: 1.1rem; font-weight: 800; color: var(--navy); margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: span 2; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: var(--navy); }
        .form-input { padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; transition: 0.3s; }
        .form-input:focus { outline: none; border-color: var(--primary); }
        .form-select { padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; background: white; cursor: pointer; }

        /* Right Side: Preview */
        .preview-section { position: sticky; top: 90px; }
        .preview-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; }
        .preview-header { background: var(--navy); padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; }
        .live-badge { background: var(--primary); color: white; font-size: 0.7rem; font-weight: 800; padding: 4px 8px; border-radius: 12px; display: flex; align-items: center; gap: 4px; }
        .preview-header span { color: white; font-size: 0.75rem; font-weight: 600; letter-spacing: 1px; }
        
        .preview-body { padding: 24px; }
        .prev-avatar { width: 70px; height: 70px; border-radius: 16px; background: #ffe4e6; color: var(--primary); font-size: 2rem; font-weight: 800; display: flex; justify-content: center; align-items: center; margin-bottom: 16px; }
        .prev-name { font-size: 1.25rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; display: flex; align-items: center; gap: 6px; }
        .prev-name i { color: var(--success-text); font-size: 1rem; }
        .prev-role { font-size: 0.85rem; font-weight: 600; color: var(--primary); margin-bottom: 4px; }
        .prev-location { font-size: 0.8rem; color: var(--secondary); display: flex; align-items: center; gap: 4px; margin-bottom: 20px; }
        
        .prev-box { background: var(--bg); border-radius: 10px; padding: 12px; margin-bottom: 16px; }
        .prev-box-title { font-size: 0.7rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-bottom: 4px; }
        .prev-box-val { font-size: 0.9rem; font-weight: 600; color: var(--navy); }
        
        .prev-section-title { font-size: 0.8rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-top: 20px; margin-bottom: 8px; }
        .prev-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .prev-tag { background: #ffe4e6; color: var(--primary); padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .prev-desc { font-size: 0.85rem; color: var(--navy); line-height: 1.5; margin-top: 10px; }
        .prev-footer { margin-top: 16px; font-size: 0.75rem; color: var(--secondary); display: flex; align-items: center; gap: 4px; }

        @media (max-width: 992px) {
            .container { grid-template-columns: 1fr; }
            .preview-section { display: none; }
        }
    </style>
</head>
<body>

    <form id="profileForm" action="${pageContext.request.contextPath}/lawyer/profile-completion/save" method="post">
        <!-- Top Bar -->
        <header class="topbar">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <i class="bi bi-shield-check"></i> Fight D Fear
            </a>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/lawyer/dashboard" class="btn-skip">Skip for now</a>
                <button type="submit" class="btn-save">Save Profile</button>
            </div>
        </header>

        <div class="container">
            <!-- Left Form -->
            <div class="form-section">
                <div class="progress-box">
                    <div class="progress-header">
                        <h2>Profile Completion: ${lawyer.profileCompletionPct != null ? lawyer.profileCompletionPct : 0}%</h2>
                        <span class="status-badge">${lawyer.partnerProfileStatus != null ? lawyer.partnerProfileStatus : 'REGISTERED'}</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                    <p class="progress-text">Complete all required sections below to submit your profile for Admin verification.</p>
                    
                    <div class="steps">
                        <span class="step-badge"><i class="bi bi-exclamation-circle"></i> Add Specialization</span>
                        <span class="step-badge"><i class="bi bi-exclamation-circle"></i> Set Hours</span>
                        <span class="step-badge"><i class="bi bi-exclamation-circle"></i> Upload Bar Council ID</span>
                        <span class="step-badge"><i class="bi bi-exclamation-circle"></i> Add Experience</span>
                    </div>
                </div>

                <button type="submit" class="btn-submit-admin" onclick="return confirm('Save and submit for verification?');">
                    <i class="bi bi-send-fill"></i> Submit for Admin Verification
                </button>

                <h3 class="section-title">1. Lawyer Identity</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">1.1 Full name *</label>
                        <input type="text" name="fullName" class="form-input" value="${lawyer.fullName}" required oninput="updatePreview('prevName', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">1.2 Designation</label>
                        <input type="text" name="designation" class="form-input" value="${lawyer.designation != null ? lawyer.designation : 'Advocate'}" oninput="updatePreview('prevRole', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">1.3 Official phone *</label>
                        <input type="tel" name="phone" class="form-input" value="${lawyer.phone}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">1.4 Bar Council ID *</label>
                        <input type="text" name="barCouncilId" class="form-input" value="${lawyer.barCouncilId}" placeholder="e.g. MAH/1234/2020" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">1.5 Years of Experience</label>
                        <input type="number" name="experienceYears" class="form-input" value="${lawyer.experienceYears}" placeholder="e.g. 8">
                    </div>
                    <div class="form-group">
                        <label class="form-label">1.6 Languages Spoken</label>
                        <input type="text" name="languages" class="form-input" value="${lawyer.languages}" placeholder="English, Hindi, Marathi">
                    </div>
                </div>

                <h3 class="section-title">2. Professional Details</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">2.1 Practice Areas / Specialization</label>
                        <input type="text" name="practiceAreas" class="form-input" value="${lawyer.practiceAreas}" placeholder="e.g. Family Law, Domestic Violence, Property Law" oninput="updateTagsPreview('prevPractice', this.value)">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">2.2 Bio / About</label>
                        <textarea name="bio" class="form-input" rows="4" placeholder="Brief professional background..." oninput="updatePreview('prevBio', this.value)">${lawyer.bio}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">2.3 City</label>
                        <input type="text" name="city" class="form-input" value="${lawyer.city}" oninput="updatePreview('prevCity', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">2.4 State</label>
                        <input type="text" name="state" class="form-input" value="${lawyer.state}">
                    </div>
                </div>

                <h3 class="section-title">3. Availability & Service</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">3.1 Operating Days</label>
                        <input type="text" name="openDays" class="form-input" value="${lawyer.openDays}" placeholder="e.g. Mon-Sat">
                    </div>
                    <div class="form-group">
                        <label class="form-label">3.2 Service Mode</label>
                        <select name="serviceMode" class="form-select">
                            <option value="Online">Online / Video Call</option>
                            <option value="Offline">Offline / In Person</option>
                            <option value="Both">Both (Online & Offline)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">3.3 Open Time</label>
                        <input type="time" name="openTime" class="form-input" value="${lawyer.openTime}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">3.4 Close Time</label>
                        <input type="time" name="closeTime" class="form-input" value="${lawyer.closeTime}">
                    </div>
                </div>
            </div>

            <!-- Right Preview -->
            <div class="preview-section">
                <div class="preview-card">
                    <div class="preview-header">
                        <div class="live-badge"><span style="width:6px;height:6px;background:white;border-radius:50%;"></span> LIVE PREVIEW</div>
                        <span>LAWYER PROFILE</span>
                    </div>
                    <div class="preview-body">
                        <div class="prev-avatar">
                            <span id="prevInitials">${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1)}</span>
                        </div>
                        <div class="prev-name">
                            <span id="prevName">${empty lawyer.fullName ? 'Advocate Name' : lawyer.fullName}</span> <i class="bi bi-check-circle-fill"></i>
                        </div>
                        <div class="prev-role" id="prevRole">${empty lawyer.designation ? 'Advocate' : lawyer.designation}</div>
                        <div class="prev-location"><i class="bi bi-geo-alt-fill"></i> <span id="prevCity">${empty lawyer.city ? 'City' : lawyer.city}</span>, <span id="prevState">${empty lawyer.state ? 'State' : lawyer.state}</span></div>

                        <div class="prev-box" style="display:flex; justify-content:space-between;">
                            <div>
                                <div class="prev-box-title">Operating Timings</div>
                                <div class="prev-box-val">09:00 - 18:00</div>
                            </div>
                            <div style="text-align:right;">
                                <div class="prev-box-title">Service Type</div>
                                <div class="prev-box-val">Consultation</div>
                            </div>
                        </div>

                        <div class="prev-section-title">Practice Areas</div>
                        <div class="prev-tags" id="prevPractice">
                            <div class="prev-tag">Family Law</div>
                            <div class="prev-tag">Domestic Violence</div>
                        </div>

                        <div class="prev-section-title">About Lawyer</div>
                        <div class="prev-desc" id="prevBio">
                            ${empty lawyer.bio ? 'Professional lawyer dedicated to women\'s legal empowerment, guidance, and justice.' : lawyer.bio}
                        </div>

                        <div class="prev-footer">
                            <i class="bi bi-shield-lock-fill"></i> Public client preview • Updates live as you type
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function updatePreview(id, value) {
            document.getElementById(id).textContent = value || (id === 'prevName' ? 'Advocate Name' : (id === 'prevRole' ? 'Advocate' : (id === 'prevCity' ? 'City' : '')));
            if(id === 'prevName' && value.length > 0) {
                document.getElementById('prevInitials').textContent = value.charAt(0).toUpperCase();
            }
        }
        function updateTagsPreview(id, value) {
            const container = document.getElementById(id);
            container.innerHTML = '';
            if(!value) {
                container.innerHTML = '<div class="prev-tag">Family Law</div>';
                return;
            }
            const parts = value.split(',');
            parts.forEach(p => {
                const trimmed = p.trim();
                if(trimmed) {
                    const tag = document.createElement('div');
                    tag.className = 'prev-tag';
                    tag.textContent = trimmed;
                    container.appendChild(tag);
                }
            });
        }
    </script>
</body>
</html>
