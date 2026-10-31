import re

jsp_path = r"c:\Users\Hp\git\FightDFear\src\main\webapp\WEB-INF\views\salon\salon-profile.jsp"

with open(jsp_path, "r", encoding="utf-8") as f:
    content = f.read()

# -------------------------------------------------------------------------
# 1. Update Tab: Salon Details
# -------------------------------------------------------------------------
old_details_pattern = r'<!-- Tab: Salon Details -->.*?<!-- End Tab Details -->'

new_details_section = """<!-- Tab: Salon Details -->
                <div class="tab-pane" id="tab-details" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-gem"></i>
                        <h4>Salon Information</h4>
                    </div>
                    
                    <!-- Weekly Operating Hours Grid -->
                    <div class="section-header mt-4 mb-3">
                        <i class="bi bi-clock"></i>
                        <h4>Weekly Operating Hours</h4>
                    </div>
                    <style>
                        .hours-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; background: #fff; padding: 10px; border: 1px solid #e9ecef; border-radius: 8px; flex-wrap: wrap; gap: 10px; }
                        .hours-day { width: 90px; font-weight: 500; font-size: 0.95rem; }
                        .hours-inputs { display: flex; align-items: center; gap: 10px; flex-grow: 1; flex-wrap: wrap; }
                        .hours-input { padding: 6px; border: 1px solid #d1d5db; border-radius: 4px; max-width: 110px; width: 100%; font-size: 0.85rem; }
                        .hours-closed { display: flex; align-items: center; gap: 5px; font-size: 0.85rem; white-space: nowrap; }
                        @media (max-width: 767px) {
                            .hours-day { width: 100%; }
                        }
                    </style>
                    <div class="hours-grid">
                        <c:forEach var="day" items="monday,tuesday,wednesday,thursday,friday,saturday,sunday">
                            <div class="hours-row">
                                <div class="hours-day" style="text-transform: capitalize;">${day}</div>
                                <div class="hours-inputs">
                                    <input type="time" class="hours-input" id="hours_${day}_open" name="hours_${day}_open" value="${fn:split(salonHours[day], ' - ')[0]}">
                                    <span>to</span>
                                    <input type="time" class="hours-input" id="hours_${day}_close" name="hours_${day}_close" value="${fn:split(salonHours[day], ' - ')[1]}">
                                </div>
                                <div class="hours-closed">
                                    <input type="checkbox" id="hours_${day}_closed" name="hours_${day}_closed" value="true" ${salonHours[day] == 'Closed' ? 'checked' : ''}> Closed
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="field-hint mb-3"><i class="bi bi-info-circle"></i> Set standard daily operating opening and closing timings, or check Closed for rest days</div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="totalChairs">Total Chairs / Stations <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="totalChairs" name="totalChairs" value="${not empty salon.totalChairs ? salon.totalChairs : 12}" placeholder="e.g. 12" maxlength="3" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Active styling or cutting stations (1–500)</div>
                            <div class="error-msg" id="err-totalChairs"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of chairs (1 to 500).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="treatmentRooms">Total Treatment Rooms</label>
                            <input type="text" inputmode="numeric" class="f-control" id="treatmentRooms" name="treatmentRooms" value="${not empty salon.treatmentRooms ? salon.treatmentRooms : 4}" placeholder="e.g. 4" maxlength="3">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Private therapy, facial, or spa rooms (0–100)</div>
                            <div class="error-msg" id="err-treatmentRooms"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of rooms (0 to 100).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasReceptionArea">Reception Area</label>
                            <select class="f-control" id="hasReceptionArea" name="hasReceptionArea">
                                <option value="true" ${salon.hasReceptionArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasReceptionArea ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Dedicated desk for customer greetings & billing</div>
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="hasWaitingArea">Waiting Area</label>
                            <select class="f-control" id="hasWaitingArea" name="hasWaitingArea">
                                <option value="true" ${salon.hasWaitingArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWaitingArea ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Comfortable seated lounge for waiting guests</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasParking">Parking Facility</label>
                            <select class="f-control" id="hasParking" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Customer parking space or valet support</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="washrooms">Washrooms</label>
                            <input type="text" inputmode="numeric" class="f-control" id="washrooms" name="washrooms" value="${not empty salon.washrooms ? salon.washrooms : 2}" placeholder="e.g. 2" maxlength="2">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Clean restroom facilities for customers (0–50)</div>
                            <div class="error-msg" id="err-washrooms"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of washrooms (0 to 50).</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="salonSizeSqFt">Salon Size (sq.ft) <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="salonSizeSqFt" name="salonSizeSqFt" value="${not empty salon.salonSizeSqFt ? salon.salonSizeSqFt : 1500}" placeholder="e.g. 1500" maxlength="5" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Total carpet / floor area in square feet (50–50,000)</div>
                            <div class="error-msg" id="err-salonSizeSqFt"><i class="bi bi-exclamation-circle-fill"></i> Please enter an area between 50 and 50,000 sq.ft.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonLicenseNo">Salon License No.</label>
                            <input type="text" class="f-control" id="salonLicenseNo" name="salonLicenseNo" value="${salon.salonLicenseNo}" placeholder="e.g. BBMP/2020/12345" maxlength="50">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Municipal trade or health license reference number</div>
                            <div class="error-msg" id="err-salonLicenseNo"><i class="bi bi-exclamation-circle-fill"></i> License number cannot exceed 50 characters.</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="hygieneStandard">Hygiene Standard</label>
                            <select class="f-control" id="hygieneStandard" name="hygieneStandard">
                                <option value="Premium" ${salon.hygieneStandard == 'Premium' ? 'selected' : ''}>Premium (Hospital-grade sterilization)</option>
                                <option value="Standard" ${salon.hygieneStandard == 'Standard' ? 'selected' : ''}>Standard (Regular sanitization)</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Sanitation protocol and hygiene level followed</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="languagesSpoken">Languages Spoken</label>
                            <input type="text" class="f-control" id="languagesSpoken" name="languagesSpoken" value="${salon.languagesSpoken}" placeholder="English, Hindi, Kannada" maxlength="150">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Languages spoken by styling & front-desk staff</div>
                            <div class="error-msg" id="err-languagesSpoken"><i class="bi bi-exclamation-circle-fill"></i> Languages list cannot exceed 150 characters.</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Details -->"""

content = re.sub(old_details_pattern, new_details_section, content, flags=re.DOTALL)

# -------------------------------------------------------------------------
# 2. Update Tab: Services Offered
# -------------------------------------------------------------------------
old_services_pattern = r'<!-- Tab: Services Offered -->.*?<!-- End Tab Services -->'

new_services_section = """<!-- Tab: Services Offered -->
                <div class="tab-pane" id="tab-services" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-scissors"></i>
                        <h4>Services Offered</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label" for="serviceCategory">Service Category</label>
                            <select name="serviceCategory" id="serviceCategory" class="f-control">
                                <option value="Haircut">Haircut</option>
                                <option value="Hair Styling">Hair Styling</option>
                                <option value="Hair Coloring">Hair Coloring</option>
                                <option value="Facial">Facial</option>
                                <option value="Massage">Massage</option>
                                <option value="Manicure">Manicure</option>
                                <option value="Pedicure">Pedicure</option>
                                <option value="Makeup">Makeup</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Select category under which this service will be listed</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="serviceName">Service Name</label>
                            <input type="text" name="serviceName" id="serviceName" class="f-control" placeholder="e.g. Premium Hair Spa & Scalp Therapy" maxlength="100">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Distinctive service or treatment name</div>
                            <div class="error-msg" id="err-serviceName"><i class="bi bi-exclamation-circle-fill"></i> Service name must be at least 2 characters.</div>
                        </div>
                    </div>

                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="servicePrice">Price (₹)</label>
                            <input type="text" inputmode="numeric" name="servicePrice" id="servicePrice" class="f-control" placeholder="e.g. 799" maxlength="6">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Price charged in Indian Rupees (₹)</div>
                            <div class="error-msg" id="err-servicePrice"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid price (₹ 0 or more).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="serviceDuration">Duration (Minutes)</label>
                            <input type="text" inputmode="numeric" name="serviceDuration" id="serviceDuration" class="f-control" placeholder="e.g. 45" maxlength="3">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Estimated service duration in minutes (5–480)</div>
                            <div class="error-msg" id="err-serviceDuration"><i class="bi bi-exclamation-circle-fill"></i> Duration must be between 5 and 480 minutes.</div>
                        </div>
                    </div>

                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="serviceIngredients">Ingredients / Products Used</label>
                            <input type="text" name="serviceIngredients" id="serviceIngredients" class="f-control" placeholder="e.g. Argan oil, Keratin complex, L'Oreal Professional" maxlength="200">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Primary brand products or active ingredients</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="serviceAllergenInfo">Allergen Information</label>
                            <input type="text" name="serviceAllergenInfo" id="serviceAllergenInfo" class="f-control" placeholder="e.g. Contains almond extracts, patch test recommended" maxlength="200">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Sensitive skin notices or contraindications</div>
                        </div>
                    </div>
                    
                    <div class="f-group mt-3">
                        <label class="f-label" for="servicePhoto">Service Photo</label>
                        <input type="file" name="servicePhoto" id="servicePhoto" accept="image/*" class="f-control">
                        <div class="field-hint"><i class="bi bi-info-circle"></i> Showcase image for this service (PNG, JPG, max 5MB)</div>
                    </div>
                </div>
                </div> <!-- End Tab Services -->"""

content = re.sub(old_services_pattern, new_services_section, content, flags=re.DOTALL)

# -------------------------------------------------------------------------
# 3. Update Tab: Facilities & Amenities
# -------------------------------------------------------------------------
old_facilities_pattern = r'<div class="tab-pane" id="tab-facilities".*?<!-- End Tab Facilities -->'

new_facilities_section = """<div class="tab-pane" id="tab-facilities" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-star"></i>
                        <h4>Facilities & Amenities</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label" for="hasAc">Air Conditioning (AC)</label>
                            <select class="f-control" id="hasAc" name="hasAc">
                                <option value="true" ${salon.hasAc ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasAc ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Fully air-conditioned styling space and treatment rooms</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasWifi">Free Wi-Fi</label>
                            <select class="f-control" id="hasWifi" name="hasWifi">
                                <option value="true" ${salon.hasWifi ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWifi ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> High-speed internet access available for customers</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="hasParkingFacility">Customer Parking</label>
                            <select class="f-control" id="hasParkingFacility" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Dedicated 2-wheeler or 4-wheeler parking on premises</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasPowerBackup">Power Backup</label>
                            <select class="f-control" id="hasPowerBackup" name="hasPowerBackup">
                                <option value="true" ${salon.hasPowerBackup ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasPowerBackup ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Inverter or generator backup to avoid service interruptions</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Facilities -->"""

content = re.sub(old_facilities_pattern, new_facilities_section, content, flags=re.DOTALL)

# -------------------------------------------------------------------------
# 4. Update Tab: Social Media
# -------------------------------------------------------------------------
old_social_pattern = r'<!-- Tab: Social Media -->.*?<!-- End Tab Social Media -->'

new_social_section = """<!-- Tab: Social Media -->
                <div class="tab-pane" id="tab-social" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-share"></i>
                        <h4>Social Media Links</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label" for="socialInstagram"><i class="bi bi-instagram text-pink"></i> Instagram Username or URL</label>
                            <input type="text" class="f-control" id="socialInstagram" name="socialInstagram" placeholder="@beautysalon or instagram.com/salon" maxlength="100">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> e.g. @aurasalon or https://instagram.com/aurasalon</div>
                            <div class="error-msg" id="err-socialInstagram"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid Instagram handle or URL.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="socialFacebook"><i class="bi bi-facebook text-primary"></i> Facebook Page or URL</label>
                            <input type="text" class="f-control" id="socialFacebook" name="socialFacebook" placeholder="facebook.com/beautysalon" maxlength="150">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> e.g. facebook.com/aurasalon</div>
                            <div class="error-msg" id="err-socialFacebook"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid Facebook URL or handle.</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="socialWebsite"><i class="bi bi-globe"></i> Website Link</label>
                            <input type="url" class="f-control" id="socialWebsite" name="socialWebsite" placeholder="https://www.mysalon.com" maxlength="200">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Official salon website (https://...)</div>
                            <div class="error-msg" id="err-socialWebsite"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid website URL starting with http:// or https://.</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Social Media -->"""

content = re.sub(old_social_pattern, new_social_section, content, flags=re.DOTALL)

# -------------------------------------------------------------------------
# 5. Update Tab: Documents with helpful hints
# -------------------------------------------------------------------------
content = content.replace(
    '<div class="doc-title">Business Registration <br>Certificate</div>',
    '<div class="doc-title">Business Registration <br>Certificate</div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> PDF, PNG, JPG (max 5 MB)</div>'
)
content = content.replace(
    '<div class="doc-title"><br>Salon License</div>',
    '<div class="doc-title"><br>Salon License</div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> Trade license copy (max 5 MB)</div>'
)
content = content.replace(
    '<div class="doc-title">GST Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(If Applicable)</span></div>',
    '<div class="doc-title">GST Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(If Applicable)</span></div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> GST registration certificate</div>'
)
content = content.replace(
    '<div class="doc-title"><br>Hygiene Certificate</div>',
    '<div class="doc-title"><br>Hygiene Certificate</div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> Safety inspection certificate</div>'
)
content = content.replace(
    '<div class="doc-title"><br>Fire Safety Certificate</div>',
    '<div class="doc-title"><br>Fire Safety Certificate</div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> Fire NOC or safety certificate</div>'
)
content = content.replace(
    '<div class="doc-title">Insurance Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(Optional)</span></div>',
    '<div class="doc-title">Insurance Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(Optional)</span></div><div class="field-hint" style="font-size:0.62rem; margin-top:2px;"><i class="bi bi-file-earmark-arrow-up"></i> Liability / property insurance</div>'
)

# -------------------------------------------------------------------------
# 6. Add JS validations for all these fields into our script section
# -------------------------------------------------------------------------
js_extra_funcs = """
        // Validation functions for Tab: Salon Details
        function validateTotalChairs(strict) {
            const v = val('totalChairs');
            if (!v) return setStatus('totalChairs', 'err-totalChairs', strict, 'Total chairs is required.');
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 1 || n > 500) {
                return setStatus('totalChairs', 'err-totalChairs', true, 'Total chairs must be between 1 and 500.');
            }
            return setStatus('totalChairs', 'err-totalChairs', false);
        }

        function validateTreatmentRooms(strict) {
            const v = val('treatmentRooms');
            if (!v) return setStatus('treatmentRooms', 'err-treatmentRooms', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 0 || n > 100) {
                return setStatus('treatmentRooms', 'err-treatmentRooms', true, 'Treatment rooms must be between 0 and 100.');
            }
            return setStatus('treatmentRooms', 'err-treatmentRooms', false);
        }

        function validateWashrooms(strict) {
            const v = val('washrooms');
            if (!v) return setStatus('washrooms', 'err-washrooms', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 0 || n > 50) {
                return setStatus('washrooms', 'err-washrooms', true, 'Washrooms must be between 0 and 50.');
            }
            return setStatus('washrooms', 'err-washrooms', false);
        }

        function validateSalonSize(strict) {
            const v = val('salonSizeSqFt');
            if (!v) return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', strict, 'Salon size is required.');
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 50 || n > 50000) {
                return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', true, 'Salon size must be between 50 and 50,000 sq.ft.');
            }
            return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', false);
        }

        function validateSalonLicenseNo(strict) {
            const v = val('salonLicenseNo');
            if (!v) return setStatus('salonLicenseNo', 'err-salonLicenseNo', false);
            if (v.length > 50) return setStatus('salonLicenseNo', 'err-salonLicenseNo', true, 'License number cannot exceed 50 characters.');
            return setStatus('salonLicenseNo', 'err-salonLicenseNo', false);
        }

        function validateLanguagesSpoken(strict) {
            const v = val('languagesSpoken');
            if (!v) return setStatus('languagesSpoken', 'err-languagesSpoken', false);
            if (v.length > 150) return setStatus('languagesSpoken', 'err-languagesSpoken', true, 'Languages list cannot exceed 150 characters.');
            return setStatus('languagesSpoken', 'err-languagesSpoken', false);
        }

        function validateServiceName(strict) {
            const v = val('serviceName');
            if (!v) return setStatus('serviceName', 'err-serviceName', false);
            if (v.length < 2) return setStatus('serviceName', 'err-serviceName', true, 'Service name must be at least 2 characters.');
            return setStatus('serviceName', 'err-serviceName', false);
        }

        function validateServicePrice(strict) {
            const v = val('servicePrice');
            if (!v) return setStatus('servicePrice', 'err-servicePrice', false);
            const n = parseFloat(v);
            if (isNaN(n) || n < 0) return setStatus('servicePrice', 'err-servicePrice', true, 'Enter a valid price (₹ 0 or more).');
            return setStatus('servicePrice', 'err-servicePrice', false);
        }

        function validateServiceDuration(strict) {
            const v = val('serviceDuration');
            if (!v) return setStatus('serviceDuration', 'err-serviceDuration', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 5 || n > 480) return setStatus('serviceDuration', 'err-serviceDuration', true, 'Duration must be between 5 and 480 minutes.');
            return setStatus('serviceDuration', 'err-serviceDuration', false);
        }

        function validateSocialInstagram(strict) {
            const v = val('socialInstagram');
            if (!v) return setStatus('socialInstagram', 'err-socialInstagram', false);
            if (v.length > 100) return setStatus('socialInstagram', 'err-socialInstagram', true, 'Instagram handle too long.');
            return setStatus('socialInstagram', 'err-socialInstagram', false);
        }

        function validateSocialFacebook(strict) {
            const v = val('socialFacebook');
            if (!v) return setStatus('socialFacebook', 'err-socialFacebook', false);
            if (v.length > 150) return setStatus('socialFacebook', 'err-socialFacebook', true, 'Facebook URL or handle too long.');
            return setStatus('socialFacebook', 'err-socialFacebook', false);
        }

        function validateSocialWebsite(strict) {
            const v = val('socialWebsite');
            if (!v) return setStatus('socialWebsite', 'err-socialWebsite', false);
            if (!/^(https?:\\/\\/)?([\\w-]+\\.)+[\\w-]+(\\/\\S*)?$/i.test(v)) {
                return setStatus('socialWebsite', 'err-socialWebsite', true, 'Please enter a valid URL (e.g. https://www.salon.com).');
            }
            return setStatus('socialWebsite', 'err-socialWebsite', false);
        }
"""

content = content.replace("        function validateSalonPincode(strict) {", js_extra_funcs + "\n        function validateSalonPincode(strict) {")

# Update handleProfileSave to validate details fields as well
old_save_checks = """            const isStateValid = validateSalonState(true);
            const isCityValid = validateSalonCity(true);
            const isPincodeValid = validateSalonPincode(true);

            const allValid = isNameValid && isTypeValid && isCategoryValid && isYearValid &&
                             isGstValid && isBioValid && isPhoneValid && isAltValid &&
                             isEmailValid && isAddressValid && isStateValid && isCityValid && isPincodeValid;"""

new_save_checks = """            const isStateValid = validateSalonState(true);
            const isCityValid = validateSalonCity(true);
            const isPincodeValid = validateSalonPincode(true);

            // Tab: Salon Details Validations
            const isChairsValid = validateTotalChairs(true);
            const isRoomsValid = validateTreatmentRooms(true);
            const isWashroomsValid = validateWashrooms(true);
            const isSizeValid = validateSalonSize(true);
            const isLicValid = validateSalonLicenseNo(true);
            const isLangValid = validateLanguagesSpoken(true);

            // Optional Services & Social validations
            const isSvcNameValid = validateServiceName(true);
            const isSvcPriceValid = validateServicePrice(true);
            const isSvcDurValid = validateServiceDuration(true);
            const isInstaValid = validateSocialInstagram(true);
            const isFbValid = validateSocialFacebook(true);
            const isWebValid = validateSocialWebsite(true);

            const allValid = isNameValid && isTypeValid && isCategoryValid && isYearValid &&
                             isGstValid && isBioValid && isPhoneValid && isAltValid &&
                             isEmailValid && isAddressValid && isStateValid && isCityValid && isPincodeValid &&
                             isChairsValid && isRoomsValid && isWashroomsValid && isSizeValid && isLicValid && isLangValid &&
                             isSvcNameValid && isSvcPriceValid && isSvcDurValid && isInstaValid && isFbValid && isWebValid;"""

content = content.replace(old_save_checks, new_save_checks)

# Add listeners in DOMContentLoaded for details and services
old_dom_content = """            // Strict numeric filters
            const phoneEl = document.getElementById('salonPhone');"""

new_dom_content = """            // Strict numeric filters for details
            const chairsEl = document.getElementById('totalChairs');
            if (chairsEl) {
                chairsEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 3);
                    validateTotalChairs(false);
                    recalculateSalonProgress();
                });
                chairsEl.addEventListener('blur', () => validateTotalChairs(true));
            }

            const roomsEl = document.getElementById('treatmentRooms');
            if (roomsEl) {
                roomsEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 3);
                    validateTreatmentRooms(false);
                });
                roomsEl.addEventListener('blur', () => validateTreatmentRooms(true));
            }

            const washEl = document.getElementById('washrooms');
            if (washEl) {
                washEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 2);
                    validateWashrooms(false);
                });
                washEl.addEventListener('blur', () => validateWashrooms(true));
            }

            const sizeEl = document.getElementById('salonSizeSqFt');
            if (sizeEl) {
                sizeEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 5);
                    validateSalonSize(false);
                    recalculateSalonProgress();
                });
                sizeEl.addEventListener('blur', () => validateSalonSize(true));
            }

            const svcPriceEl = document.getElementById('servicePrice');
            if (svcPriceEl) {
                svcPriceEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 6);
                    validateServicePrice(false);
                });
                svcPriceEl.addEventListener('blur', () => validateServicePrice(true));
            }

            const svcDurEl = document.getElementById('serviceDuration');
            if (svcDurEl) {
                svcDurEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 3);
                    validateServiceDuration(false);
                });
                svcDurEl.addEventListener('blur', () => validateServiceDuration(true));
            }

            const svcNameEl = document.getElementById('serviceName');
            if (svcNameEl) {
                svcNameEl.addEventListener('input', () => validateServiceName(false));
                svcNameEl.addEventListener('blur', () => validateServiceName(true));
            }

            const licEl = document.getElementById('salonLicenseNo');
            if (licEl) {
                licEl.addEventListener('input', () => validateSalonLicenseNo(false));
                licEl.addEventListener('blur', () => validateSalonLicenseNo(true));
            }

            const langEl = document.getElementById('languagesSpoken');
            if (langEl) {
                langEl.addEventListener('input', () => validateLanguagesSpoken(false));
                langEl.addEventListener('blur', () => validateLanguagesSpoken(true));
            }

            const instaEl = document.getElementById('socialInstagram');
            if (instaEl) {
                instaEl.addEventListener('input', () => validateSocialInstagram(false));
                instaEl.addEventListener('blur', () => validateSocialInstagram(true));
            }

            const fbEl = document.getElementById('socialFacebook');
            if (fbEl) {
                fbEl.addEventListener('input', () => validateSocialFacebook(false));
                fbEl.addEventListener('blur', () => validateSocialFacebook(true));
            }

            const webEl = document.getElementById('socialWebsite');
            if (webEl) {
                webEl.addEventListener('input', () => validateSocialWebsite(false));
                webEl.addEventListener('blur', () => validateSocialWebsite(true));
            }

            // Strict numeric filters
            const phoneEl = document.getElementById('salonPhone');"""

content = content.replace(old_dom_content, new_dom_content)

# Update recalculateSalonProgress to account for totalChairs, salonSizeSqFt, facilities
content = content.replace(
    """            // Established year or tagline or gst
            if (val('establishedYear') || val('salonTagline') || val('businessRegistrationNo')) filled++;""",
    """            // Established year or tagline or gst
            if (val('establishedYear') || val('salonTagline') || val('businessRegistrationNo')) filled++;
            // Chairs & size
            if (val('totalChairs') && parseInt(val('totalChairs'), 10) >= 1) filled++;
            if (val('salonSizeSqFt') && parseInt(val('salonSizeSqFt'), 10) >= 50) filled++;"""
)

with open(jsp_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Enhanced all salon profile fields successfully!")
