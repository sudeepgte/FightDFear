<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Complete Worker Profile | Fight D Fear</title>
    
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
            --warning-bg: #fff7ed;
            --warning-text: #c2410c;
            --success-text: #10b981;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--navy); display: flex; flex-direction: column; min-height: 100vh; overflow-x: hidden; }

        .topbar { background: var(--card-bg); padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 50; }
        .brand { font-size: 1.25rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .brand i { color: var(--primary); font-size: 1.5rem; }
        .topbar-actions { display: flex; gap: 12px; }
        .btn-skip { background: transparent; color: var(--navy); padding: 10px 20px; border: 1px solid var(--border); border-radius: 20px; font-weight: 600; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .btn-skip:hover { background: #f1f5f9; }
        .btn-save { background: var(--navy); color: white; padding: 10px 20px; border: none; border-radius: 20px; font-weight: 600; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; text-decoration: none;}
        .btn-save:hover { background: #1e293b; }

        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; width: 100%; }

        .form-section { background: var(--card-bg); border-radius: 16px; padding: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); border: 1px solid var(--border); }
        .progress-box { margin-bottom: 24px; }
        .progress-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .progress-header h2 { font-size: 1.15rem; font-weight: 800; }
        .status-badge { background: #e2e8f0; color: var(--secondary); font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 6px; text-transform: uppercase; }
        
        .progress-bar-bg { width: 100%; height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden; margin-bottom: 12px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: 0%; transition: 0.3s; }
        .progress-text { font-size: 0.85rem; color: var(--secondary); margin-bottom: 12px; }
        
        .btn-submit-admin { width: 100%; background: var(--primary); color: white; padding: 14px; border: none; border-radius: 12px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 30px; }
        .btn-submit-admin:hover { background: var(--primary-hover); }

        .section-title { font-size: 1.1rem; font-weight: 800; color: var(--navy); margin-top: 30px; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; padding-bottom: 10px; border-bottom: 1px solid var(--border); }
        .section-title:first-of-type { margin-top: 0; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
        .form-group.full { grid-column: span 2; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: var(--navy); }
        .form-input { width: 100%; padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; transition: 0.3s; }
        .form-input:focus { outline: none; border-color: var(--primary); }
        .form-select { width: 100%; padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; background: white; cursor: pointer; }

        .preview-section { position: sticky; top: 90px; }
        .preview-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; }
        .preview-header { background: var(--navy); padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; }
        .live-badge { background: var(--primary); color: white; font-size: 0.7rem; font-weight: 800; padding: 4px 8px; border-radius: 12px; display: flex; align-items: center; gap: 4px; }
        .preview-header span { color: white; font-size: 0.75rem; font-weight: 600; letter-spacing: 1px; }
        
        .preview-body { padding: 24px; }
        .prev-avatar { width: 70px; height: 70px; border-radius: 16px; background: #ffe4e6; color: var(--primary); font-size: 2rem; font-weight: 800; display: flex; justify-content: center; align-items: center; margin-bottom: 16px; }
        .prev-name { font-size: 1.25rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; display: flex; align-items: center; gap: 6px; }
        .prev-role { font-size: 0.85rem; font-weight: 600; color: var(--primary); margin-bottom: 4px; }
        .prev-location { font-size: 0.8rem; color: var(--secondary); display: flex; align-items: center; gap: 4px; margin-bottom: 20px; }
        
        .prev-box { background: var(--bg); border-radius: 10px; padding: 12px; margin-bottom: 16px; }
        .prev-box-title { font-size: 0.7rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-bottom: 4px; }
        .prev-box-val { font-size: 0.9rem; font-weight: 600; color: var(--navy); }
        
        .prev-section-title { font-size: 0.8rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-top: 20px; margin-bottom: 8px; }
        .prev-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .prev-tag { background: #ffe4e6; color: var(--primary); padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .prev-desc { font-size: 0.85rem; color: var(--navy); line-height: 1.5; margin-top: 10px; }
        
        @media (max-width: 992px) {
            .container { grid-template-columns: minmax(0, 1fr); }
            .preview-section { display: none; }
        }
        @media (max-width: 768px) {
            .topbar { padding: 12px 15px; flex-wrap: wrap; gap: 12px; }
            .brand span { font-size: 1.1rem !important; white-space: nowrap; }
            .topbar-actions { display: flex; gap: 8px; width: 100%; justify-content: space-between; }
            .btn-skip, .btn-save { padding: 8px 12px; font-size: 0.85rem; white-space: nowrap; flex: 1; justify-content: center; text-align: center; }
            .form-grid { grid-template-columns: minmax(0, 1fr); }
            .form-group.full { grid-column: span 1; }
            .container { margin: 15px auto; padding: 0 10px; width: 100%; max-width: 100vw; box-sizing: border-box; overflow-x: hidden; }
            .form-section { padding: 20px 15px; }
            .form-input, .form-select { width: 100%; }
        }
    </style>
</head>
<body>
    <form id="profileForm" action="${pageContext.request.contextPath}/women-jobs/profile" method="post" enctype="multipart/form-data">
        <header class="topbar">
            <a href="${pageContext.request.contextPath}/" class="brand" style="text-decoration:none;">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Logo" style="height: 30px; object-fit: contain;">
                <span style="font-size: 1.25rem; font-weight: 800; color: #1a1a2e; margin: 0; padding: 0;">Fight D Fear</span>
            </a>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="btn-skip">Skip for now</a>
                <button type="submit" class="btn-save">Save Profile</button>
            </div>
        </header>

        <div class="container">
            <div class="form-section">
                <div class="progress-box">
                    <div class="progress-header">
                        <h2>Profile Details</h2>
                        <span class="status-badge">${workerApp.status != null ? workerApp.status : 'REGISTERED'}</span>
                    </div>
                    <div class="progress-bar-bg"><div class="progress-bar-fill" id="pbFill"></div></div>
                    <div class="progress-text" id="pbText">0% Completed</div>
                </div>

                <h3 class="section-title">1. Worker Identity</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Full name</label>
                        <input type="text" name="fullName" class="form-input" value="${workerApp.user.fullName}" oninput="updatePreview('prevName', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Role type / designation</label>
                        <input type="text" name="designation" class="form-input" value="${workerApp.designation}" oninput="updatePreview('prevRole', this.value)" placeholder="e.g. Senior Baby Care Specialist">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Official phone</label>
                        <input type="text" name="phone" class="form-input" value="${workerApp.user.phoneNumber}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">WhatsApp Number</label>
                        <input type="text" name="whatsappNumber" class="form-input" value="${workerApp.whatsappNumber}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Years of experience</label>
                        <input type="number" name="yearsExperience" class="form-input" value="${workerApp.yearsExperience}">
                    </div>
                </div>

                <h3 class="section-title">2. Location</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Landmark / address</label>
                        <textarea name="address" class="form-input" rows="2">${workerApp.address}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-input" value="${workerApp.city}" oninput="updatePreview('prevCity', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">State</label>
                        <input type="text" name="state" class="form-input" value="${workerApp.state}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Pincode</label>
                        <input type="text" name="pincode" class="form-input" value="${workerApp.pincode}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Latitude</label>
                        <input type="number" step="any" name="latitude" class="form-input" value="${workerApp.latitude}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Longitude</label>
                        <input type="number" step="any" name="longitude" class="form-input" value="${workerApp.longitude}">
                    </div>
                </div>

                <h3 class="section-title">3. Work categories</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Categories offered</label>
                        <textarea name="categoriesOffered" class="form-input" rows="2">${workerApp.categoriesOffered}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Primary category</label>
                        <select id="jobCategory" name="jobCategory" class="form-select" onchange="updateSubCategories()">
                            <option value="">Select Category</option>
                            <option value="Caregiver" ${workerApp.jobCategory == 'Caregiver' ? 'selected' : ''}>Caregiver</option>
                            <option value="Babysitting" ${workerApp.jobCategory == 'Babysitting' ? 'selected' : ''}>Babysitting</option>
                            <option value="Housekeeping" ${workerApp.jobCategory == 'Housekeeping' ? 'selected' : ''}>Housekeeping</option>
                            <option value="Cooking" ${workerApp.jobCategory == 'Cooking' ? 'selected' : ''}>Cooking</option>
                            <option value="Beauty & Salon" ${workerApp.jobCategory == 'Beauty & Salon' ? 'selected' : ''}>Beauty & Salon</option>
                            <option value="Healthcare" ${workerApp.jobCategory == 'Healthcare' ? 'selected' : ''}>Healthcare</option>
                            <option value="Teaching" ${workerApp.jobCategory == 'Teaching' ? 'selected' : ''}>Teaching</option>
                            <option value="Office Jobs" ${workerApp.jobCategory == 'Office Jobs' ? 'selected' : ''}>Office Jobs</option>
                            <option value="Retail" ${workerApp.jobCategory == 'Retail' ? 'selected' : ''}>Retail</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Role / sub category</label>
                        <select id="jobSubCategory" name="jobSubCategory" class="form-select">
                            <option value="${workerApp.jobSubCategory}"><c:out value="${empty workerApp.jobSubCategory ? 'Select specific job' : workerApp.jobSubCategory}"/></option>
                        </select>
                    </div>
                </div>

                <h3 class="section-title">4. Who I serve</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Audience</label>
                        <input type="text" name="audience" class="form-input" value="${workerApp.audience}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Door visits</label>
                        <select name="doorService" class="form-select">
                            <option value="true" ${workerApp.doorService == true ? 'selected' : ''}>Yes</option>
                            <option value="false" ${workerApp.doorService != true ? 'selected' : ''}>No</option>
                        </select>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Languages</label>
                        <input type="text" name="languages" class="form-input" value="${workerApp.languages}" placeholder="e.g. English, Hindi, Tamil">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Skills</label>
                        <input type="text" name="skills" class="form-input" value="${workerApp.skills}" oninput="updateTagsPreview('prevSkills', this.value)" placeholder="e.g. CPR, Cooking, Tutoring">
                    </div>
                </div>

                <h3 class="section-title">5. Facilities & readiness</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Amenities / readiness</label>
                        <textarea name="facilities" class="form-input" rows="2">${workerApp.facilities}</textarea>
                    </div>
                </div>

                <h3 class="section-title">6. Hours & calendar</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Open days</label>
                        <input type="text" name="openDays" class="form-input" value="${workerApp.openDays}" placeholder="e.g. Mon-Fri">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Open time</label>
                        <input type="time" name="openTime" class="form-input" value="${workerApp.openTime}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Close time</label>
                        <input type="time" name="closeTime" class="form-input" value="${workerApp.closeTime}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Break start</label>
                        <input type="time" name="breakStart" class="form-input" value="${workerApp.breakStart}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Break end</label>
                        <input type="time" name="breakEnd" class="form-input" value="${workerApp.breakEnd}">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Blocked dates</label>
                        <textarea name="blockedDates" class="form-input" rows="2">${workerApp.blockedDates}</textarea>
                    </div>
                </div>

                <h3 class="section-title">7. About you</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">About</label>
                        <textarea name="bio" class="form-input" rows="4" oninput="updatePreview('prevBio', this.value)">${workerApp.bio}</textarea>
                    </div>
                </div>

                <h3 class="section-title">8. First offering</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Hourly rate (&#8377;)</label>
                        <input type="number" name="hourlyRate" class="form-input" value="${workerApp.hourlyRate}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration (minutes)</label>
                        <input type="number" name="durationMinutes" class="form-input" value="${workerApp.durationMinutes}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Buffer (minutes)</label>
                        <input type="number" name="bufferMinutes" class="form-input" value="${workerApp.bufferMinutes}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Service mode</label>
                        <input type="text" name="serviceMode" class="form-input" value="${workerApp.serviceMode}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Work type</label>
                        <input type="text" name="workType" class="form-input" value="${workerApp.workType}">
                    </div>
                </div>

                <h3 class="section-title">9. Payout</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">UPI ID</label>
                        <input type="text" name="upiId" class="form-input" value="${workerApp.upiId}">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Bank details</label>
                        <textarea name="bankDetails" class="form-input" rows="2" placeholder="Bank Name, A/C No, IFSC Code">${workerApp.bankDetails}</textarea>
                    </div>
                </div>

                <h3 class="section-title">10. Documents (optional)</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Profile photo</label>
                        <input type="file" name="profileImage" class="form-input" accept="image/*">
                        <c:if test="${not empty workerApp.profileImageUrl}">
                            <div style="margin-top:5px; font-size:0.8rem;">Current: ${workerApp.profileImageUrl}</div>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Proof document</label>
                        <input type="file" name="proofDocument" class="form-input" accept="image/*,.pdf">
                        <c:if test="${not empty workerApp.documentPath}">
                            <div style="margin-top:5px; font-size:0.8rem;">
                                <a href="${pageContext.request.contextPath}${workerApp.documentPath}" target="_blank">View existing proof document</a>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <h3 class="section-title">11. Work photos (optional)</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Gallery photos</label>
                        <input type="file" name="galleryPhotos" class="form-input" accept="image/*" multiple>
                        <c:if test="${not empty workerApp.galleryPhotos}">
                            <div style="margin-top:5px; font-size:0.8rem;">Current: ${workerApp.galleryPhotos}</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Right Preview -->
            <div class="preview-section">
                <div class="preview-card">
                    <div class="preview-header">
                        <div class="live-badge"><i class="bi bi-broadcast"></i> LIVE PREVIEW</div>
                        <span>WORKER PROFILE</span>
                    </div>
                    <div class="preview-body">
                        <div class="prev-avatar">${workerApp.user != null && workerApp.user.fullName != null && workerApp.user.fullName.length() > 0 ? workerApp.user.fullName.substring(0,1).toUpperCase() : 'W'}</div>
                        <div class="prev-name"><span id="prevName">${empty workerApp.user.fullName ? 'Your Name' : workerApp.user.fullName}</span> <i class="bi bi-check-circle-fill"></i></div>
                        <div class="prev-role" id="prevRole">${empty workerApp.designation ? 'Worker Role' : workerApp.designation}</div>
                        <div class="prev-location"><i class="bi bi-geo-alt-fill"></i> <span id="prevCity">${empty workerApp.city ? 'City' : workerApp.city}</span></div>

                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
                            <div class="prev-box">
                                <div class="prev-box-title">Experience</div>
                                <div class="prev-box-val">${empty workerApp.yearsExperience ? '0' : workerApp.yearsExperience} Years</div>
                            </div>
                            <div class="prev-box">
                                <div class="prev-box-title">Hourly Rate</div>
                                <div class="prev-box-val">&#8377; ${empty workerApp.hourlyRate ? '0' : workerApp.hourlyRate}</div>
                            </div>
                        </div>

                        <div class="prev-section-title">Skills</div>
                        <div class="prev-tags" id="prevSkills">
                            <div class="prev-tag">Skill 1</div>
                        </div>

                        <div class="prev-section-title">ABOUT WORKER</div>
                        <div class="prev-desc" id="prevBio">
                            ${empty workerApp.bio ? 'Professional worker ready to serve.' : workerApp.bio}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    function updatePreview(id, value) {
        document.getElementById(id).textContent = value || (id.replace('prev',''));
    }
    function updateTagsPreview(id, value) {
        let container = document.getElementById(id);
        if(!value) { container.innerHTML = '<div class="prev-tag">Skill</div>'; return; }
        let html = '';
        value.split(',').forEach(function(item){
            if(item.trim()) html += '<div class="prev-tag">' + item.trim() + '</div>';
        });
        container.innerHTML = html;
    }

    var categories = {
        "Caregiver": ["Baby Care", "Elderly Care", "Patient Care", "Nanny", "Special Needs Care"],
        "Babysitting": ["Full-time Babysitter", "Part-time Babysitter", "Night Nanny"],
        "Housekeeping": ["Maid", "Deep Cleaning", "Laundry Service", "Organizing"],
        "Cooking": ["Chef", "Home Cook", "Baking", "Dietary Special Meals"],
        "Beauty & Salon": ["Beautician", "Makeup Artist", "Hair Stylist", "Mehendi Artist", "Massage Therapist"],
        "Healthcare": ["Nurse", "Physiotherapist", "Midwife", "Yoga Instructor", "Dietician"],
        "Teaching": ["Tutor", "Preschool Teacher", "Music Teacher", "Art Instructor", "Language Tutor"],
        "Office Jobs": ["Receptionist", "Data Entry", "Accountant", "HR Assistant", "Telecaller"],
        "Retail": ["Salesgirl", "Cashier", "Store Manager", "Customer Service Agent"],
        "Hospitality": ["Waitress", "Event Coordinator", "Hostess", "Hotel Housekeeping"],
        "Customer Support": ["BPO Executive", "Chat Support", "Tech Support"],
        "Delivery & Logistics": ["Delivery Executive", "Packer", "Driver"],
        "Domestic Help": ["Japa Maid", "Pet Sitter", "Gardener"],
        "Tailoring & Fashion": ["Tailor", "Boutique Assistant", "Fashion Designer", "Knitting & Stitching"],
        "Digital Jobs": ["Graphic Designer", "Content Writer", "Social Media Manager", "Video Editor"],
        "Freelancing": ["Virtual Assistant", "Translator", "Online Tutor"],
        "Entrepreneurship": ["Sell Handmade Products", "Home Bakery", "Boutique Owner"]
    };
    window.updateSubCategories = function () {
        var categorySelect = document.getElementById("jobCategory");
        var subCategorySelect = document.getElementById("jobSubCategory");
        if (!categorySelect || !subCategorySelect) return;
        var selectedCategory = categorySelect.value;
        var current = subCategorySelect.value;
        subCategorySelect.innerHTML = '<option value="">Select Specific Job</option>';
        if (selectedCategory && categories[selectedCategory]) {
            categories[selectedCategory].forEach(function (subCat) {
                var option = document.createElement("option");
                option.value = subCat;
                option.text = subCat;
                if (subCat === current) option.selected = true;
                subCategorySelect.appendChild(option);
            });
        }
        if (current && !subCategorySelect.value) {
            var keep = document.createElement("option");
            keep.value = current;
            keep.text = current;
            keep.selected = true;
            subCategorySelect.appendChild(keep);
        }
    };
    
    function calculateProgress() {
        const inputs = document.querySelectorAll('.form-input, .form-select');
        let filled = 0;
        let total = 0;
        inputs.forEach(input => {
            if (input.type === 'file') return;
            total++;
            if (input.value && input.value.trim() !== '') {
                filled++;
            }
        });
        const percent = total === 0 ? 0 : Math.round((filled / total) * 100);
        document.getElementById('pbFill').style.width = percent + '%';
        document.getElementById('pbText').textContent = percent + '% Completed';
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateSubCategories();
        // Initialize dynamic previews on load
        if(document.querySelector('input[name="skills"]')) updateTagsPreview('prevSkills', document.querySelector('input[name="skills"]').value);
        
        calculateProgress();
        const allInputs = document.querySelectorAll('.form-input, .form-select');
        allInputs.forEach(input => {
            input.addEventListener('input', calculateProgress);
            input.addEventListener('change', calculateProgress);
        });
    });
</script>
</body>
</html>
