import re

jsp_path = r"c:\Users\Hp\git\FightDFear\src\main\webapp\WEB-INF\views\salon\salon-profile.jsp"
with open(jsp_path, "r", encoding="utf-8") as f:
    jsp_src = f.read()

# 1. Update pt-steps HTML to give each step and its status element clear IDs
old_pt_steps_pattern = r'<div class="pt-steps".*?<!-- Tabs Navigation -->'

new_pt_steps = """<div class="pt-steps" id="ptStepsBar" style="--progress: ${completionPercentage}%;">
                    <div class="pt-step ${stepBasicInfo ? 'done' : ''}" id="stepBasicInfo" onclick="openEditMode('tab-business')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Basic<br>Information</div>
                        <div class="pt-status" id="statusBasicInfo">${stepBasicInfo ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepSalonDetails ? 'done' : ''}" id="stepSalonDetails" onclick="openEditMode('tab-details')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Salon<br>Details</div>
                        <div class="pt-status" id="statusSalonDetails">${stepSalonDetails ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepServices ? 'done' : ''}" id="stepServices" onclick="openEditMode('tab-services')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Services<br>Offered</div>
                        <div class="pt-status" id="statusServices">${stepServices ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepPhotos ? 'done' : ''}" id="stepPhotos" onclick="window.scrollTo({top:0, behavior:'smooth'})" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Photos</div>
                        <div class="pt-status" id="statusPhotos">${stepPhotos ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepFacilities ? 'done' : ''}" id="stepFacilities" onclick="openEditMode('tab-facilities')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Facilities &<br>Amenities</div>
                        <div class="pt-status" id="statusFacilities">${stepFacilities ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepDocs ? 'done' : ''}" id="stepDocs" onclick="openEditMode('tab-documents')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Documents</div>
                        <div class="pt-status" id="statusDocs">${docsCount}/${docsTotal} Completed</div>
                    </div>
                    <div class="pt-step ${stepSocial ? 'done' : ''}" id="stepSocial" onclick="openEditMode('tab-social')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Social<br>Media</div>
                        <div class="pt-status" id="statusSocial">${socialCount}/${socialTotal} Completed</div>
                    </div>
                    <div class="pt-step ${stepPref ? 'done' : ''}" id="stepPref" onclick="openEditMode('tab-preferences')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Preferences</div>
                        <div class="pt-status" id="statusPref">${stepPref ? 'Completed' : 'Pending'}</div>
                    </div>
                </div>
                
                <a href="javascript:void(0)" onclick="openEditMode()" class="btn-visibility">Increase Visibility <i class="bi bi-arrow-right"></i></a>
            </div>

            <!-- Tabs Navigation -->"""

jsp_src = re.sub(old_pt_steps_pattern, new_pt_steps, jsp_src, flags=re.DOTALL)

# Also ensure circle inner and wrap have IDs
jsp_src = jsp_src.replace(
    """<div class="pt-circle-wrap" style="background: conic-gradient(var(--brand-pink) ${completionPercentage}%, #f0f0f0 0);">
                        <div class="pt-circle-inner">${completionPercentage}%</div>
                    </div>""",
    """<div class="pt-circle-wrap" id="ptCircleWrap" style="background: conic-gradient(var(--brand-pink) ${completionPercentage}%, #f0f0f0 0);">
                        <div class="pt-circle-inner" id="ptCircleInner">${completionPercentage}%</div>
                    </div>"""
)

# 2. Add initial state constants to JS
constants_js = """        // Initial Server-Rendered State for Accurate Completion Sync
        const hasExistingServices = ${stepServices ? 'true' : 'false'};
        const hasExistingProfilePhoto = ${(not empty salon.profileImageUrl and not fn:contains(salon.profileImageUrl, 'ui-avatars')) ? 'true' : 'false'};
        const hasExistingCover = ${(not empty salon.coverImageUrl or (not empty salon.interiorImagesJson and salon.interiorImagesJson != '[]')) ? 'true' : 'false'};
        const hasExistingFacilities = ${(salon.hasAc or salon.hasWifi or salon.hasParking or salon.hasPowerBackup) ? 'true' : 'false'};
        const initialDocsCount = ${docsCount};
        const initialSocialCount = ${socialCount};
        const hasExistingPreferences = ${(not empty salon.preferencesJson and salon.preferencesJson != '{}') ? 'true' : 'false'};
"""

if "const initialDocsCount" not in jsp_src:
    jsp_src = jsp_src.replace("const savedCity = \"${salon.city}\";", "const savedCity = \"${salon.city}\";\n" + constants_js)

# 3. Replace recalculateSalonProgress with accurate 20-milestone calculation (5% each)
old_recalc_pattern = r'// Dynamic progress calculation\s+function recalculateSalonProgress\(\) \{.*?\}\s+// Cascading State & District Setup'

new_recalc = """// Dynamic progress calculation (20 milestones, 5% each = 100%)
        function updateStepStatus(stepId, statusId, isDone, customText) {
            const stepEl = document.getElementById(stepId);
            const statusEl = document.getElementById(statusId);
            if (stepEl) {
                if (isDone) stepEl.classList.add('done');
                else stepEl.classList.remove('done');
            }
            if (statusEl) {
                statusEl.textContent = customText ? customText : (isDone ? 'Completed' : 'Pending');
            }
        }

        function recalculateSalonProgress() {
            let filled = 0;
            const total = 20;

            // 1. Salon Name (>= 3 chars)
            const hasName = val('salonName').length >= 3;
            if (hasName) filled++;

            // 2. Business Type
            const hasType = val('salonType') !== '' || val('salonCategory') !== '';
            if (hasType) filled++;

            // 3. Description / Bio (>= 10 chars)
            const hasBio = val('salonBio').length >= 10;
            if (hasBio) filled++;

            // 4. Official Phone (10 digits starting with 6-9)
            const hasPhone = /^[6-9]\\d{9}$/.test(val('salonPhone'));
            if (hasPhone) filled++;

            // 5. Official Email (valid email format)
            const hasEmail = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/.test(val('salonEmail'));
            if (hasEmail) filled++;

            // 6. Full Address (>= 5 chars)
            const hasAddress = val('salonAddress').length >= 5;
            if (hasAddress) filled++;

            // 7. State
            const hasState = val('stateSelect') !== '';
            if (hasState) filled++;

            // 8. District / City
            const dist = val('districtSelect');
            const customCity = val('customCityInput');
            const cityVal = (dist && dist !== 'Other') ? dist : (customCity || val('inputCity'));
            const hasCity = cityVal !== '';
            if (hasCity) filled++;

            const hasPincode = /^\\d{6}$/.test(val('salonPincode'));

            // Step 1: Basic Info Done Flag
            const basicDone = hasName && hasType && hasBio && hasPhone && hasAddress && hasState && hasCity && hasPincode;
            updateStepStatus('stepBasicInfo', 'statusBasicInfo', basicDone);

            // 9. Salon Category
            const hasCategory = val('salonCategory') !== '';
            if (hasCategory) filled++;

            // 10. Established Year (valid 4-digit year 1900-currentYear)
            const yearVal = parseInt(val('establishedYear'), 10);
            const currentYear = new Date().getFullYear();
            const hasYear = !isNaN(yearVal) && yearVal >= 1900 && yearVal <= currentYear;
            if (hasYear) filled++;

            // 11. Total Chairs / Stations (>= 1)
            const chairsVal = parseInt(val('totalChairs'), 10);
            const hasChairs = !isNaN(chairsVal) && chairsVal >= 1 && chairsVal <= 500;
            if (hasChairs) filled++;

            // 12. Salon Size (>= 50 sq.ft)
            const sizeVal = parseInt(val('salonSizeSqFt'), 10);
            const hasSize = !isNaN(sizeVal) && sizeVal >= 50 && sizeVal <= 50000;
            if (hasSize) filled++;

            // Step 2: Salon Details Done Flag
            const detailsDone = hasCategory && hasChairs && hasSize;
            updateStepStatus('stepSalonDetails', 'statusSalonDetails', detailsDone);

            // 13. Services Offered (at least 1 service)
            const hasService = hasExistingServices || val('serviceName').length >= 2;
            if (hasService) filled++;
            updateStepStatus('stepServices', 'statusServices', hasService);

            // 14. Profile Photo / Logo
            const profileInput = document.getElementById('profileImageInput');
            const hasUploadedProfile = profileInput && profileInput.files && profileInput.files.length > 0;
            const hasProfileImg = hasUploadedProfile || hasExistingProfilePhoto;
            if (hasProfileImg) filled++;

            // 15. Cover Photo / Interior Photos
            const coverInput = document.getElementById('coverImageInput');
            const interiorInput = document.getElementById('interiorImageInput');
            const hasUploadedCover = (coverInput && coverInput.files && coverInput.files.length > 0) ||
                                     (interiorInput && interiorInput.files && interiorInput.files.length > 0);
            const hasCoverImg = hasUploadedCover || hasExistingCover;
            if (hasCoverImg) filled++;

            // Step 4: Photos Done Flag
            const photosDone = hasProfileImg || hasCoverImg;
            updateStepStatus('stepPhotos', 'statusPhotos', photosDone);

            // 16. Facilities & Amenities
            const hasFacilities = val('hasAc') === 'true' || val('hasWifi') === 'true' ||
                                  val('hasParkingFacility') === 'true' || val('hasPowerBackup') === 'true' ||
                                  hasExistingFacilities;
            if (hasFacilities) filled++;
            updateStepStatus('stepFacilities', 'statusFacilities', hasFacilities);

            // 17 & 18. Documents (up to 5)
            let uploadedDocs = 0;
            ['fileBus', 'fileLic', 'fileGst', 'fileHyg', 'fileFire'].forEach(id => {
                const inp = document.getElementById(id);
                if (inp && inp.files && inp.files.length > 0) uploadedDocs++;
            });
            const totalDocsCount = Math.min(5, initialDocsCount + uploadedDocs);
            if (totalDocsCount >= 1) filled++;
            if (totalDocsCount >= 2) filled++;
            updateStepStatus('stepDocs', 'statusDocs', totalDocsCount > 0, totalDocsCount + '/5 Completed');

            // 19. Social Media (up to 3)
            let typedSocial = 0;
            if (val('socialInstagram') !== '') typedSocial++;
            if (val('socialFacebook') !== '') typedSocial++;
            if (val('socialWebsite') !== '') typedSocial++;
            const totalSocialCount = Math.max(typedSocial, initialSocialCount);
            if (totalSocialCount > 0) filled++;
            updateStepStatus('stepSocial', 'statusSocial', totalSocialCount > 0, Math.min(3, totalSocialCount) + '/3 Completed');

            // 20. Preferences
            const hasPref = hasExistingPreferences || val('pref_onlineBooking') !== '' || val('pref_cancelAllowed') !== '';
            if (hasPref) filled++;
            updateStepStatus('stepPref', 'statusPref', hasPref);

            // Accurate Percentage: 20 milestones, each 5%
            const pct = Math.min(100, Math.round((100 * filled) / total));

            // Update UI elements
            const circleInner = document.getElementById('ptCircleInner');
            const circleWrap = document.getElementById('ptCircleWrap');
            if (circleInner) circleInner.textContent = pct + '%';
            if (circleWrap) circleWrap.style.background = 'conic-gradient(var(--brand-pink) ' + pct + '%, #f0f0f0 0)';

            const stepsBar = document.getElementById('ptStepsBar');
            if (stepsBar) stepsBar.style.setProperty('--progress', pct + '%');
        }

        // Cascading State & District Setup"""

jsp_src = re.sub(old_recalc_pattern, lambda m: new_recalc, jsp_src, flags=re.DOTALL)

with open(jsp_path, "w", encoding="utf-8") as f:
    f.write(jsp_src)

print("Updated salon-profile.jsp with synchronized accurate percentage.")
