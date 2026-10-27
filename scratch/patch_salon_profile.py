import re

jsp_path = r"c:\Users\Hp\git\FightDFear\src\main\webapp\WEB-INF\views\salon\salon-profile.jsp"

with open(jsp_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add validation CSS styles before </style>
css_addition = """
        /* Enhanced Validation and Helper Styling */
        .f-control.is-invalid {
            border-color: #ef4444 !important;
            background-color: #fffbfa !important;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
        }
        .f-control.is-valid {
            border-color: #10b981 !important;
        }
        .error-msg {
            display: none;
            font-size: 0.72rem;
            color: #ef4444;
            font-weight: 500;
            margin-top: 4px;
            align-items: center;
            gap: 4px;
        }
        .error-msg.show {
            display: flex;
        }
        .field-hint {
            font-size: 0.72rem;
            color: #64748b;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .cascade-info {
            font-size: 0.72rem;
            color: var(--brand-pink);
            font-weight: 500;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .validation-alert-toast {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            background: #ef4444;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            font-size: 0.85rem;
            font-weight: 500;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
"""

if ".f-control.is-invalid" not in content:
    content = content.replace("    </style>\n\n    <!-- Global Dashboard Theme -->", css_addition + "    </style>\n\n    <!-- Global Dashboard Theme -->")

# 2. Update Header Save button to call handleProfileSave()
content = content.replace(
    """<button type="button" class="btn-header-save" \nonclick="document.getElementById('profileForm').submit()">Save Profile</button>""",
    """<button type="button" class="btn-header-save" id="btnHeaderSave" onclick="handleProfileSave(event)">Save Profile</button>"""
)
content = content.replace(
    """<button type="button" class="btn-header-save" onclick="document.getElementById('profileForm').submit()">Save Profile</button>""",
    """<button type="button" class="btn-header-save" id="btnHeaderSave" onclick="handleProfileSave(event)">Save Profile</button>"""
)

# 3. Update form tag with onsubmit
content = content.replace(
    '<form id="profileForm" action="${pageContext.request.contextPath}/salons/updateProfile${not empty _csrf ? \'?\'.concat(_csrf.parameterName).concat(\'=\').concat(_csrf.token) : \'\'}" method="post" enctype="multipart/form-data">',
    '<form id="profileForm" action="${pageContext.request.contextPath}/salons/updateProfile${not empty _csrf ? \'?\'.concat(_csrf.parameterName).concat(\'=\').concat(_csrf.token) : \'\'}" method="post" enctype="multipart/form-data" onsubmit="return handleProfileSave(event)" novalidate>'
)

# 4. Replace Tab: Business Info and Contact Info
old_business_pattern = r'<!-- Tab: Business Info -->.*?<!-- End Tab Business -->'

new_business_section = """<!-- Tab: Business Info -->
                <div class="tab-pane active" id="tab-business">
                    <div class="form-grid-2col">
                        <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-journal-text"></i>
                        <h4>Basic Information</h4>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="salonName">Salon Name <span class="req">*</span></label>
                            <input type="text" class="f-control" id="salonName" name="name" value="${salon.name}" placeholder="e.g. Aura Beauty Lounge" maxlength="150" required>
                            <div class="error-msg" id="err-name"><i class="bi bi-exclamation-circle-fill"></i> Salon name is required (at least 3 characters).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonType">Business Type <span class="req">*</span></label>
                            <select class="f-control" name="salonType" id="salonType" required>
                                <option value="">-- Select Business Type --</option>
                                <option value="Beauty, Wellness & Hair Salon" ${salon.salonType == 'Beauty, Wellness & Hair Salon' or (empty salon.salonType and salon.salonCategory == 'Beauty, Wellness & Hair Salon') ? 'selected' : ''}>Beauty, Wellness & Hair Salon</option>
                                <option value="Hair Salon" ${salon.salonType == 'Hair Salon' ? 'selected' : ''}>Hair Salon</option>
                                <option value="Beauty Parlour" ${salon.salonType == 'Beauty Parlour' ? 'selected' : ''}>Beauty Parlour</option>
                                <option value="Unisex Salon" ${salon.salonType == 'Unisex Salon' ? 'selected' : ''}>Unisex Salon</option>
                                <option value="Bridal & Makeup Studio" ${salon.salonType == 'Bridal & Makeup Studio' ? 'selected' : ''}>Bridal & Makeup Studio</option>
                                <option value="Spa & Wellness Centre" ${salon.salonType == 'Spa & Wellness Centre' ? 'selected' : ''}>Spa & Wellness Centre</option>
                                <option value="Nail Studio & Bar" ${salon.salonType == 'Nail Studio & Bar' ? 'selected' : ''}>Nail Studio & Bar</option>
                                <option value="Skin Clinic & Aesthetics" ${salon.salonType == 'Skin Clinic & Aesthetics' ? 'selected' : ''}>Skin Clinic & Aesthetics</option>
                                <option value="Ayurvedic & Natural Care" ${salon.salonType == 'Ayurvedic & Natural Care' ? 'selected' : ''}>Ayurvedic & Natural Care</option>
                                <c:if test="${not empty salon.salonType and salon.salonType != 'Beauty, Wellness & Hair Salon' and salon.salonType != 'Hair Salon' and salon.salonType != 'Beauty Parlour' and salon.salonType != 'Unisex Salon' and salon.salonType != 'Bridal & Makeup Studio' and salon.salonType != 'Spa & Wellness Centre' and salon.salonType != 'Nail Studio & Bar' and salon.salonType != 'Skin Clinic & Aesthetics' and salon.salonType != 'Ayurvedic & Natural Care'}">
                                    <option value="${salon.salonType}" selected>${salon.salonType}</option>
                                </c:if>
                            </select>
                            <div class="error-msg" id="err-salonType"><i class="bi bi-exclamation-circle-fill"></i> Please select a business type.</div>
                        </div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonTagline">Tagline / Motto</label>
                        <input type="text" class="f-control" id="salonTagline" name="salonTagline" value="${salon.salonTagline}" placeholder="Enhancing Beauty, Elevating Confidence" maxlength="255">
                        <div class="field-hint"><i class="bi bi-info-circle"></i> Short memorable slogan displayed on your public profile</div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="businessRegistrationNo">Business Registration No.</label>
                            <input type="text" class="f-control" id="businessRegistrationNo" name="businessRegistrationNo" value="${salon.businessRegistrationNo}" placeholder="e.g. KA03AB1234C" maxlength="50">
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="gstNumber">GST Number (Optional)</label>
                            <input type="text" class="f-control" id="gstNumber" name="gstNumber" value="${salon.gstNumber}" placeholder="29ABCDE1234F1Z5" maxlength="15" style="text-transform:uppercase;">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 15-character Goods and Services Tax ID</div>
                            <div class="error-msg" id="err-gstNumber"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid 15-character GST format (e.g. 29ABCDE1234F1Z5).</div>
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="establishedYear">Established Year</label>
                            <input type="text" inputmode="numeric" class="f-control" id="establishedYear" name="establishedYear" value="${salon.establishedYear}" placeholder="e.g. 2018" maxlength="4" autocomplete="off">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 4-digit year (1900 - 2026)</div>
                            <div class="error-msg" id="err-establishedYear"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 4-digit year between 1900 and 2026.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonCategory">Salon Category <span class="req">*</span></label>
                            <select class="f-control" name="salonCategory" id="salonCategory" required>
                                <option value="">-- Select Category --</option>
                                <option value="Premium Salon" ${salon.salonCategory == 'Premium Salon' ? 'selected' : ''}>Premium Salon</option>
                                <option value="Luxury Salon" ${salon.salonCategory == 'Luxury Salon' ? 'selected' : ''}>Luxury Salon</option>
                                <option value="Standard Salon" ${salon.salonCategory == 'Standard Salon' ? 'selected' : ''}>Standard Salon</option>
                                <option value="Boutique Salon" ${salon.salonCategory == 'Boutique Salon' ? 'selected' : ''}>Boutique Salon</option>
                                <option value="Budget / Economy Salon" ${salon.salonCategory == 'Budget / Economy Salon' ? 'selected' : ''}>Budget / Economy Salon</option>
                                <option value="Family Salon" ${salon.salonCategory == 'Family Salon' ? 'selected' : ''}>Family Salon</option>
                                <option value="Unisex Salon" ${salon.salonCategory == 'Unisex Salon' ? 'selected' : ''}>Unisex Salon</option>
                                <option value="Bridal & Event Studio" ${salon.salonCategory == 'Bridal & Event Studio' ? 'selected' : ''}>Bridal & Event Studio</option>
                                <option value="Organic & Eco-Friendly Salon" ${salon.salonCategory == 'Organic & Eco-Friendly Salon' ? 'selected' : ''}>Organic & Eco-Friendly Salon</option>
                                <option value="Express Salon" ${salon.salonCategory == 'Express Salon' ? 'selected' : ''}>Express Salon</option>
                                <c:if test="${not empty salon.salonCategory and salon.salonCategory != 'Premium Salon' and salon.salonCategory != 'Luxury Salon' and salon.salonCategory != 'Standard Salon' and salon.salonCategory != 'Boutique Salon' and salon.salonCategory != 'Budget / Economy Salon' and salon.salonCategory != 'Family Salon' and salon.salonCategory != 'Unisex Salon' and salon.salonCategory != 'Bridal & Event Studio' and salon.salonCategory != 'Organic & Eco-Friendly Salon' and salon.salonCategory != 'Express Salon'}">
                                    <option value="${salon.salonCategory}" selected>${salon.salonCategory}</option>
                                </c:if>
                            </select>
                            <div class="error-msg" id="err-salonCategory"><i class="bi bi-exclamation-circle-fill"></i> Please select a salon category.</div>
                        </div>
                        <div class="f-group text-end">
                            <label class="f-label">Women Only Salon</label>
                            <div class="toggle-switch justify-content-end pt-1">
                                <label class="switch" for="isWomenOnlySwitch">
                                    <input type="checkbox" id="isWomenOnlySwitch" name="isWomenOnly" value="true" ${salon.isWomenOnly ? 'checked' : ''}>
                                    <span class="slider"></span>
                                </label>
                                <span style="font-size:0.75rem; font-weight:500;">Yes</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="f-group mt-2">
                        <label class="f-label" for="salonBio">Description <span class="req">*</span></label>
                        <textarea class="f-control" id="salonBio" name="bio" rows="4" placeholder="Enter salon description, specialty services, ambiance, hygiene promises..." maxlength="2000" required>${salon.bio}</textarea>
                        <div class="d-flex justify-content-between align-items-center mt-1">
                            <div class="error-msg" id="err-bio"><i class="bi bi-exclamation-circle-fill"></i> Description is required (at least 10 characters).</div>
                            <div class="char-count" id="bioCharCount">0 / 2000</div>
                        </div>
                    </div>
                </div>

                </div>
                
                <!-- Col 2: Contact Info -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-person-lines-fill"></i>
                        <h4>Contact Information</h4>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonPhone">Phone Number <span class="req">*</span></label>
                        <input type="tel" inputmode="numeric" class="f-control" id="salonPhone" name="phone" value="${salon.phone}" placeholder="10-digit mobile number" maxlength="10" autocomplete="tel" required>
                        <div class="field-hint"><i class="bi bi-info-circle"></i> 10 digits starting with 6, 7, 8, or 9</div>
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Valid 10-digit phone number starting with 6-9 is required.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="alternateNumber">Alternate Number</label>
                        <input type="tel" inputmode="numeric" class="f-control" id="alternateNumber" name="alternateNumber" value="${salon.alternateNumber}" placeholder="Optional 10-digit mobile number" maxlength="10" autocomplete="tel">
                        <div class="field-hint"><i class="bi bi-info-circle"></i> Optional secondary phone (must differ from primary phone)</div>
                        <div class="error-msg" id="err-alternateNumber"><i class="bi bi-exclamation-circle-fill"></i> Alternate number must be 10 digits and distinct from primary phone.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonEmail">Email Address <span class="req">*</span></label>
                        <input type="email" class="f-control" id="salonEmail" name="email" value="${salon.email}" placeholder="contact@salon.com" maxlength="100" autocomplete="email" required>
                        <div class="error-msg" id="err-email"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid email address.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonAddress">Full Address <span class="req">*</span></label>
                        <textarea class="f-control" id="salonAddress" name="address" rows="3" placeholder="Door / Building No, Street, Area / Locality..." maxlength="500" required>${salon.address}</textarea>
                        <div class="error-msg" id="err-address"><i class="bi bi-exclamation-circle-fill"></i> Full address is required (at least 5 characters).</div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="stateSelect">State <span class="req">*</span></label>
                            <select class="f-control" name="state" id="stateSelect" required>
                                <option value="">-- Select State --</option>
                            </select>
                            <div class="cascade-info"><i class="bi bi-info-circle"></i> Updates districts</div>
                            <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> State is required.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="districtSelect">District / City <span class="req">*</span></label>
                            <select class="f-control" id="districtSelect" required>
                                <option value="">-- Select State First --</option>
                            </select>
                            <div class="cascade-info"><i class="bi bi-check-circle"></i> Filters to chosen state</div>
                            <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> District / City is required.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonPincode">Pincode <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="salonPincode" name="pincode" value="${salon.pincode}" placeholder="6-digit Pincode" maxlength="6" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 6 digits postal code</div>
                            <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Valid 6-digit pincode is required.</div>
                        </div>
                    </div>

                    <div class="f-group mt-2" id="customCityGroup" style="display:none;">
                        <label class="f-label" for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                        <input type="text" id="customCityInput" class="f-control" placeholder="Type city or town name" maxlength="60">
                        <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                    </div>

                    <!-- Hidden input submitted as the official city param -->
                    <input type="hidden" name="city" id="inputCity" value="${salon.city}">
                    
                    <div class="f-group mt-2">
                        <label class="f-label" for="salonLandmark">Landmark</label>
                        <input type="text" class="f-control" id="salonLandmark" name="landmark" value="${salon.landmark}" placeholder="Near Metro Station, Opposite Central Mall" maxlength="200">
                    </div>
                </div>

                </div>
                </div> <!-- End Tab Business -->"""

content = re.sub(old_business_pattern, new_business_section, content, flags=re.DOTALL)

# 5. Update bottom action bar button
content = content.replace(
    '<button type="submit" class="btn-save">Save Changes</button>',
    '<button type="submit" class="btn-save" id="btnBottomSave">Save Changes</button>'
)

# 6. Add toast notification container right before </main-content> or </body>
toast_html = """
    <!-- Toast notification container -->
    <div id="validationToast" class="validation-alert-toast">
        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
        <span id="validationToastMsg">Please fill all required fields correctly before saving.</span>
    </div>
"""
if "validationToast" not in content:
    content = content.replace("    <!-- Bootstrap JS for dropdowns -->", toast_html + "\n    <!-- Bootstrap JS for dropdowns -->")

# 7. Add comprehensive location & validation JS before </body>
script_tag = """
    <!-- Enhanced Location Selectors & Strict Live Validation -->
    <script>
        const savedState = "${salon.state}";
        const savedCity = "${salon.city}";

        const locationData = {
            "India": {
                "Andhra Pradesh": ["Ananthapuramu", "Chittoor", "East Godavari", "Eluru", "Guntur", "Kakinada", "Krishna", "Kurnool", "NTR", "Palnadu", "Prakasam", "Srikakulam", "Sri Potti Sriramulu Nellore", "Tirupati", "Visakhapatnam", "Vizianagaram", "West Godavari", "YSR Kadapa", "Other"],
                "Arunachal Pradesh": ["Itanagar", "Tawang", "West Kameng", "East Kameng", "Papum Pare", "Kurung Kumey", "Kra Daadi", "Lower Subansiri", "Upper Subansiri", "West Siang", "East Siang", "Siang", "Upper Siang", "Lower Siang", "Lower Dibang Valley", "Dibang Valley", "Anjaw", "Lohit", "Namsai", "Changlang", "Tirap", "Longding", "Other"],
                "Assam": ["Guwahati (Kamrup Metro)", "Kamrup", "Dibrugarh", "Silchar (Cachar)", "Jorhat", "Nagaon", "Tinsukia", "Tezpur (Sonitpur)", "Barpeta", "Dhubri", "Goalpara", "Golaghat", "Hailakandi", "Karimganj", "Kokrajhar", "Lakhimpur", "Morigaon", "Nalbari", "Sivasagar", "Bongaigaon", "Other"],
                "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif (Nalanda)", "Arrah (Bhojpur)", "Begusarai", "Katihar", "Munger", "Chhapra (Saran)", "Danapur", "Saharsa", "Sasaram (Rohtas)", "Hajipur (Vaishali)", "Dehri", "Siwan", "Motihari (East Champaran)", "Bettiah (West Champaran)", "Other"],
                "Chhattisgarh": ["Raipur", "Bhilai (Durg)", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur (Bastar)", "Ambikapur (Surguja)", "Raigarh", "Dhamtari", "Mahasamund", "Kanker", "Kawardha (Kabirdham)", "Janjgir-Champa", "Other"],
                "Goa": ["North Goa", "South Goa", "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Other"],
                "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar", "Junagadh", "Anand", "Navsari", "Morbi", "Nadiad (Kheda)", "Surendranagar", "Bharuch", "Mehsana", "Bhuj (Kutch)", "Porbandar", "Palanpur (Banaskantha)", "Valsad", "Vapi", "Other"],
                "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", "Karnal", "Sonipat", "Panchkula", "Bhiwani", "Sirsa", "Bahadurgarh (Jhajjar)", "Jind", "Thanesar (Kurukshetra)", "Kaithal", "Rewari", "Palwal", "Other"],
                "Himachal Pradesh": ["Shimla", "Dharamshala (Kangra)", "Mandi", "Solan", "Kullu", "Hamirpur", "Una", "Bilaspur", "Chamba", "Sirmaur (Nahan)", "Kinnaur", "Lahaul and Spiti", "Other"],
                "Jharkhand": ["Ranchi", "Jamshedpur (East Singhbhum)", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Giridih", "Ramgarh", "Medininagar (Palamu)", "Dumka", "Chaibasa (West Singhbhum)", "Other"],
                "Karnataka": ["Bengaluru Urban", "Bengaluru Rural", "Mysuru", "Hubballi-Dharwad", "Mangaluru (Dakshina Kannada)", "Belagavi", "Kalaburagi (Gulbarga)", "Davanagere", "Ballari", "Vijayapura (Bijapur)", "Shivamogga (Shimoga)", "Tumakuru", "Bidar", "Raichur", "Udupi", "Hassan", "Mandya", "Chikkamagaluru", "Bagalkote", "Gadag", "Kolar", "Chitradurga", "Other"],
                "Kerala": ["Thiruvananthapuram", "Ernakulam (Kochi)", "Kozhikode", "Thrissur", "Kollam", "Palakkad", "Malappuram", "Kannur", "Kottayam", "Alappuzha", "Kasaragod", "Pathanamthitta", "Idukki", "Wayanad", "Other"],
                "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna", "Ratlam", "Rewa", "Katni", "Singrauli", "Burhanpur", "Khandwa", "Bhind", "Chhindwara", "Guna", "Shivpuri", "Vidisha", "Damoh", "Other"],
                "Maharashtra": ["Mumbai City", "Mumbai Suburban", "Pune", "Nagpur", "Thane", "Nashik", "Chhatrapati Sambhajinagar (Aurangabad)", "Solapur", "Kolhapur", "Amravati", "Navi Mumbai", "Nanded", "Jalgaon", "Akola", "Latur", "Dhule", "Ahmednagar", "Chandrapur", "Parbhani", "Jalna", "Raigad", "Satara", "Sangli", "Wardha", "Other"],
                "Manipur": ["Imphal West", "Imphal East", "Thoubal", "Bishnupur", "Churachandpur", "Ukhrul", "Senapati", "Tamenglong", "Chandel", "Kangpokpi", "Other"],
                "Meghalaya": ["Shillong (East Khasi Hills)", "West Khasi Hills", "South West Khasi Hills", "Ri-Bhoi", "Tura (West Garo Hills)", "East Garo Hills", "South Garo Hills", "North Garo Hills", "Jowai (West Jaintia Hills)", "East Jaintia Hills", "Other"],
                "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Kolasib", "Serchhip", "Lawngtlai", "Mamit", "Saiha", "Other"],
                "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Zunheboto", "Mon", "Phek", "Chumoukedima", "Niuland", "Other"],
                "Odisha": ["Bhubaneswar (Khurda)", "Cuttack", "Rourkela (Sundargarh)", "Berhampur (Ganjam)", "Sambalpur", "Puri", "Balasore", "Bhadrak", "Baripada (Mayurbhanj)", "Jharsuguda", "Jeypore (Koraput)", "Angul", "Bargarh", "Balangir", "Kendujhar", "Other"],
                "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "SAS Nagar (Mohali)", "Hoshiarpur", "Pathankot", "Moga", "Abohar (Fazilka)", "Batala (Gurdaspur)", "Khanna", "Firozpur", "Kapurthala", "Sangrur", "Barnala", "Faridkot", "Rupnagar", "Other"],
                "Rajasthan": ["Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Bharatpur", "Sikar", "Pali", "Sri Ganganagar", "Hanumangarh", "Tonk", "Kishangarh", "Beawar", "Jhunjhunu", "Chittorgarh", "Barmer", "Nagaur", "Other"],
                "Sikkim": ["Gangtok (East Sikkim)", "Namchi (South Sikkim)", "Gyalshing (West Sikkim)", "Mangan (North Sikkim)", "Pakyong", "Soreng", "Other"],
                "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Ranipet", "Vellore", "Erode", "Thoothukudi", "Dindigul", "Thanjavur", "Hosur (Krishnagiri)", "Nagercoil (Kanyakumari)", "Kanchipuram", "Kumarapalayam", "Karaikkudi", "Neyveli", "Cuddalore", "Other"],
                "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam (Peddapalli)", "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet", "Miryalaguda", "Siddipet", "Mancherial", "Rangareddy", "Medchal-Malkajgiri", "Sangareddy", "Other"],
                "Tripura": ["Agartala (West Tripura)", "Dharmanagar (North Tripura)", "Udaipur (Gomati)", "Kailashahar (Unakoti)", "Belonia (South Tripura)", "Khowai", "Ambassa (Dhalai)", "Sepahijala", "Other"],
                "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj (Allahabad)", "Gautam Buddha Nagar (Noida / Greater Noida)", "Ghaziabad", "Meerut", "Bareilly", "Aligarh", "Moradabad", "Saharanpur", "Gorakhpur", "Firozabad", "Jhansi", "Muzaffarnagar", "Mathura", "Ayodhya", "Budaun", "Rampur", "Shahjahanpur", "Farrukhabad", "Other"],
                "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani (Nainital)", "Rudraprayag", "Kashipur (Udham Singh Nagar)", "Rishikesh", "Pithoragarh", "Almora", "Tehri Garhwal", "Pauri Garhwal", "Chamoli", "Uttarkashi", "Other"],
                "West Bengal": ["Kolkata", "Howrah", "North 24 Parganas", "South 24 Parganas", "Hooghly", "Durgapur (Paschim Bardhaman)", "Asansol", "Siliguri (Darjeeling)", "Bardhaman", "Malda", "Baharampur (Murshidabad)", "Habra", "Kharagpur (Paschim Medinipur)", "Shantipur (Nadia)", "Dankuni", "Jalpaiguri", "Cooch Behar", "Purulia", "Bankura", "Other"],
                "Andaman and Nicobar Islands": ["Port Blair (South Andaman)", "North and Middle Andaman", "Nicobar", "Other"],
                "Chandigarh": ["Chandigarh", "Other"],
                "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa", "Other"],
                "Delhi": ["Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North East Delhi", "North West Delhi", "Shahdara", "South Delhi", "South East Delhi", "South West Delhi", "West Delhi", "Other"],
                "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua", "Udhampur", "Budgam", "Pulwama", "Kupwara", "Poonch", "Rajouri", "Other"],
                "Ladakh": ["Leh", "Kargil", "Other"],
                "Lakshadweep": ["Kavaratti", "Agatti", "Andrott", "Minicoy", "Other"],
                "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam", "Other"]
            }
        };

        function setStatus(id, errId, isInvalid, customMsg) {
            const input = document.getElementById(id);
            const errEl = document.getElementById(errId);
            if (input) {
                if (isInvalid) {
                    input.classList.add('is-invalid');
                    input.classList.remove('is-valid');
                } else {
                    input.classList.remove('is-invalid');
                    if (input.value && input.value.trim().length > 0) {
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                    }
                }
            }
            if (errEl) {
                if (customMsg) errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + customMsg;
                if (isInvalid) errEl.classList.add('show');
                else errEl.classList.remove('show');
            }
            return !isInvalid;
        }

        function val(id) {
            const el = document.getElementById(id);
            return el ? el.value.trim() : '';
        }

        // Field-specific validation functions
        function validateSalonName(strict) {
            const v = val('salonName');
            if (!v) return setStatus('salonName', 'err-name', strict, 'Salon name is required.');
            if (v.length < 3) return setStatus('salonName', 'err-name', true, 'Salon name must be at least 3 characters.');
            if (v.length > 150) return setStatus('salonName', 'err-name', true, 'Salon name cannot exceed 150 characters.');
            return setStatus('salonName', 'err-name', false);
        }

        function validateSalonType(strict) {
            const v = val('salonType');
            if (!v) return setStatus('salonType', 'err-salonType', strict, 'Please select a business type.');
            return setStatus('salonType', 'err-salonType', false);
        }

        function validateSalonCategory(strict) {
            const v = val('salonCategory');
            if (!v) return setStatus('salonCategory', 'err-salonCategory', strict, 'Please select a salon category.');
            return setStatus('salonCategory', 'err-salonCategory', false);
        }

        function validateEstablishedYear(strict) {
            const v = val('establishedYear');
            if (!v) {
                return setStatus('establishedYear', 'err-establishedYear', false);
            }
            if (!/^\\d{4}$/.test(v)) {
                return setStatus('establishedYear', 'err-establishedYear', true, 'Established year must be exactly 4 digits.');
            }
            const y = parseInt(v, 10);
            const currentYear = new Date().getFullYear();
            if (y < 1900 || y > currentYear) {
                return setStatus('establishedYear', 'err-establishedYear', true, 'Year must be between 1900 and ' + currentYear + '.');
            }
            return setStatus('establishedYear', 'err-establishedYear', false);
        }

        function validateGstNumber(strict) {
            const v = val('gstNumber');
            if (!v) return setStatus('gstNumber', 'err-gstNumber', false);
            const gstRegex = /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/;
            if (!gstRegex.test(v)) {
                return setStatus('gstNumber', 'err-gstNumber', true, 'Please enter a valid 15-character GSTIN (e.g. 29ABCDE1234F1Z5).');
            }
            return setStatus('gstNumber', 'err-gstNumber', false);
        }

        function validateSalonBio(strict) {
            const v = val('salonBio');
            if (!v) return setStatus('salonBio', 'err-bio', strict, 'Salon description is required.');
            if (v.length < 10) return setStatus('salonBio', 'err-bio', true, 'Description must be at least 10 characters.');
            if (v.length > 2000) return setStatus('salonBio', 'err-bio', true, 'Description cannot exceed 2000 characters.');
            return setStatus('salonBio', 'err-bio', false);
        }

        function validateSalonPhone(strict) {
            const v = val('salonPhone');
            if (!v) return setStatus('salonPhone', 'err-phone', strict, 'Phone number is required.');
            if (!/^[6-9]\\d{9}$/.test(v)) {
                return setStatus('salonPhone', 'err-phone', true, 'Phone number must be exactly 10 digits starting with 6, 7, 8, or 9.');
            }
            return setStatus('salonPhone', 'err-phone', false);
        }

        function validateAlternateNumber(strict) {
            const v = val('alternateNumber');
            if (!v) return setStatus('alternateNumber', 'err-alternateNumber', false);
            if (!/^[6-9]\\d{9}$/.test(v)) {
                return setStatus('alternateNumber', 'err-alternateNumber', true, 'Alternate number must be exactly 10 digits starting with 6-9.');
            }
            const primary = val('salonPhone');
            if (primary && v === primary) {
                return setStatus('alternateNumber', 'err-alternateNumber', true, 'Alternate number cannot be identical to primary phone.');
            }
            return setStatus('alternateNumber', 'err-alternateNumber', false);
        }

        function validateSalonEmail(strict) {
            const v = val('salonEmail');
            if (!v) return setStatus('salonEmail', 'err-email', strict, 'Email address is required.');
            const emailRegex = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/;
            if (!emailRegex.test(v)) {
                return setStatus('salonEmail', 'err-email', true, 'Please enter a valid email address.');
            }
            return setStatus('salonEmail', 'err-email', false);
        }

        function validateSalonAddress(strict) {
            const v = val('salonAddress');
            if (!v) return setStatus('salonAddress', 'err-address', strict, 'Full address is required.');
            if (v.length < 5) return setStatus('salonAddress', 'err-address', true, 'Address must be at least 5 characters.');
            return setStatus('salonAddress', 'err-address', false);
        }

        function validateSalonState(strict) {
            const v = val('stateSelect');
            if (!v) return setStatus('stateSelect', 'err-state', strict, 'State is required.');
            return setStatus('stateSelect', 'err-state', false);
        }

        function validateSalonCity(strict) {
            const dist = val('districtSelect');
            if (!dist) return setStatus('districtSelect', 'err-city', strict, 'District / City is required.');
            if (dist === 'Other') {
                const custom = val('customCityInput');
                if (!custom || custom.length < 2) {
                    setStatus('customCityInput', 'err-customCity', true, 'Please enter your city/town name (at least 2 characters).');
                    return false;
                }
                setStatus('customCityInput', 'err-customCity', false);
            }
            return setStatus('districtSelect', 'err-city', false);
        }

        function validateSalonPincode(strict) {
            const v = val('salonPincode');
            if (!v) return setStatus('salonPincode', 'err-pincode', strict, 'Pincode is required.');
            if (!/^\\d{6}$/.test(v)) return setStatus('salonPincode', 'err-pincode', true, 'Pincode must be exactly 6 digits.');
            return setStatus('salonPincode', 'err-pincode', false);
        }

        // Dynamic progress calculation
        function recalculateSalonProgress() {
            let filled = 0;
            const total = 12;

            if (val('salonName').length >= 3) filled++;
            if (val('salonType')) filled++;
            if (val('salonCategory')) filled++;
            if (val('salonBio').length >= 10) filled++;
            if (/^[6-9]\\d{9}$/.test(val('salonPhone'))) filled++;
            if (/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/.test(val('salonEmail'))) filled++;
            if (val('salonAddress').length >= 5) filled++;
            if (val('stateSelect')) filled++;
            if (val('inputCity')) filled++;
            if (/^\\d{6}$/.test(val('salonPincode'))) filled++;
            
            // Established year or tagline or gst
            if (val('establishedYear') || val('salonTagline') || val('businessRegistrationNo')) filled++;
            
            // Image uploaded or existing
            const hasImg = document.getElementById('profileImgPreview') && document.getElementById('profileImgPreview').src.indexOf('ui-avatars') === -1;
            if (hasImg) filled++;

            const pct = Math.min(100, Math.round((100 * filled) / total));

            const circleInner = document.getElementById('ptCircleInner') || document.querySelector('.pt-circle-inner');
            const circleWrap = document.getElementById('ptCircleWrap') || document.querySelector('.pt-circle-wrap');
            if (circleInner) circleInner.textContent = pct + '%';
            if (circleWrap) circleWrap.style.background = 'conic-gradient(var(--brand-pink) ' + pct + '%, #f0f0f0 0)';

            const stepsBar = document.getElementById('ptStepsBar') || document.querySelector('.pt-steps');
            if (stepsBar) stepsBar.style.setProperty('--progress', pct + '%');

            // Update basic info step indicator
            const basicDone = (val('salonName').length >= 3 && /^[6-9]\\d{9}$/.test(val('salonPhone')) && val('stateSelect') && val('inputCity'));
            const basicStep = document.getElementById('stepIndicatorBasic') || document.querySelector('.pt-step');
            if (basicStep) {
                if (basicDone) {
                    basicStep.classList.add('done');
                    const st = basicStep.querySelector('.pt-status');
                    if (st) st.textContent = 'Completed';
                } else {
                    basicStep.classList.remove('done');
                    const st = basicStep.querySelector('.pt-status');
                    if (st) st.textContent = 'Pending';
                }
            }
        }

        // Cascading State & District Setup
        function initLocationSelectors() {
            const stateSelect = document.getElementById('stateSelect');
            const districtSelect = document.getElementById('districtSelect');
            const customCityGroup = document.getElementById('customCityGroup');
            const customCityInput = document.getElementById('customCityInput');
            const cityInput = document.getElementById('inputCity');

            const indiaStates = locationData["India"] || {};
            const stateNames = Object.keys(indiaStates).sort();

            stateSelect.innerHTML = '<option value="">-- Select State --</option>';
            stateNames.forEach(st => {
                const opt = document.createElement('option');
                opt.value = st;
                opt.textContent = st;
                if (savedState && (st.toLowerCase() === savedState.toLowerCase().trim())) {
                    opt.selected = true;
                }
                stateSelect.appendChild(opt);
            });

            function populateDistricts(selectedState, selectedDistrict) {
                districtSelect.innerHTML = '<option value="">-- Select District / City --</option>';
                if (!selectedState) {
                    districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    return;
                }

                const districts = indiaStates[selectedState] || ["Other"];
                const targetCity = selectedDistrict || savedCity || '';
                let matched = false;

                districts.forEach(dist => {
                    const opt = document.createElement('option');
                    opt.value = dist;
                    opt.textContent = dist;
                    if (targetCity && dist.toLowerCase() === targetCity.toLowerCase().trim()) {
                        opt.selected = true;
                        matched = true;
                    }
                    districtSelect.appendChild(opt);
                });

                if (targetCity && !matched && targetCity !== "Other") {
                    districtSelect.value = "Other";
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.value = targetCity;
                    if (cityInput) cityInput.value = targetCity;
                } else if (districtSelect.value === "Other") {
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (cityInput && customCityInput) cityInput.value = customCityInput.value.trim();
                } else {
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    if (cityInput) cityInput.value = districtSelect.value;
                }
            }

            if (stateSelect.value) {
                populateDistricts(stateSelect.value, savedCity);
            }

            stateSelect.addEventListener('change', function () {
                validateSalonState(true);
                populateDistricts(this.value, '');
                validateSalonCity(false);
                recalculateSalonProgress();
            });

            districtSelect.addEventListener('change', function () {
                if (this.value === 'Other') {
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.focus();
                    if (cityInput && customCityInput) cityInput.value = customCityInput.value.trim();
                } else {
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    if (cityInput) cityInput.value = this.value;
                }
                validateSalonCity(true);
                recalculateSalonProgress();
            });

            if (customCityInput) {
                customCityInput.addEventListener('input', function () {
                    if (districtSelect.value === 'Other' && cityInput) {
                        cityInput.value = this.value.trim();
                    }
                    validateSalonCity(true);
                    recalculateSalonProgress();
                });
            }
        }

        // Master Save Validation Handler
        function handleProfileSave(e) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }

            // Sync city input before validation
            const dist = val('districtSelect');
            const cityInput = document.getElementById('inputCity');
            if (dist === 'Other') {
                if (cityInput) cityInput.value = val('customCityInput');
            } else if (dist) {
                if (cityInput) cityInput.value = dist;
            }

            const isNameValid = validateSalonName(true);
            const isTypeValid = validateSalonType(true);
            const isCategoryValid = validateSalonCategory(true);
            const isYearValid = validateEstablishedYear(true);
            const isGstValid = validateGstNumber(true);
            const isBioValid = validateSalonBio(true);
            const isPhoneValid = validateSalonPhone(true);
            const isAltValid = validateAlternateNumber(true);
            const isEmailValid = validateSalonEmail(true);
            const isAddressValid = validateSalonAddress(true);
            const isStateValid = validateSalonState(true);
            const isCityValid = validateSalonCity(true);
            const isPincodeValid = validateSalonPincode(true);

            const allValid = isNameValid && isTypeValid && isCategoryValid && isYearValid &&
                             isGstValid && isBioValid && isPhoneValid && isAltValid &&
                             isEmailValid && isAddressValid && isStateValid && isCityValid && isPincodeValid;

            if (!allValid) {
                const firstInvalid = document.querySelector('.f-control.is-invalid, select.is-invalid, textarea.is-invalid');
                if (firstInvalid) {
                    // Switch to tab containing invalid field
                    const parentPane = firstInvalid.closest('.tab-pane');
                    if (parentPane && parentPane.id) {
                        const tabBtn = document.querySelector('.custom-tab[data-target="' + parentPane.id + '"]');
                        if (tabBtn) tabBtn.click();
                    }
                    setTimeout(() => {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstInvalid.focus();
                    }, 100);
                }

                const toast = document.getElementById('validationToast');
                if (toast) {
                    toast.style.display = 'flex';
                    setTimeout(() => { toast.style.display = 'none'; }, 4000);
                }
                return false;
            }

            // Ensure editable section is displayed so backend accepts the fields
            const editSec = document.getElementById('editableSections');
            if (editSec) editSec.style.display = 'block';

            document.getElementById('profileForm').submit();
            return true;
        }

        // DOM Initialization
        document.addEventListener("DOMContentLoaded", function () {
            initLocationSelectors();

            // Bio char count
            const bioArea = document.getElementById('salonBio');
            const bioCounter = document.getElementById('bioCharCount');
            if (bioArea && bioCounter) {
                const updateBioCount = () => {
                    bioCounter.textContent = bioArea.value.length + ' / 2000';
                };
                bioArea.addEventListener('input', () => {
                    updateBioCount();
                    validateSalonBio(false);
                    recalculateSalonProgress();
                });
                updateBioCount();
            }

            // Strict numeric filters
            const phoneEl = document.getElementById('salonPhone');
            if (phoneEl) {
                phoneEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 10);
                    validateSalonPhone(false);
                    if (val('alternateNumber')) validateAlternateNumber(false);
                    recalculateSalonProgress();
                });
                phoneEl.addEventListener('blur', () => validateSalonPhone(true));
            }

            const altPhoneEl = document.getElementById('alternateNumber');
            if (altPhoneEl) {
                altPhoneEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 10);
                    validateAlternateNumber(false);
                    recalculateSalonProgress();
                });
                altPhoneEl.addEventListener('blur', () => validateAlternateNumber(true));
            }

            const pincodeEl = document.getElementById('salonPincode');
            if (pincodeEl) {
                pincodeEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 6);
                    validateSalonPincode(false);
                    recalculateSalonProgress();
                });
                pincodeEl.addEventListener('blur', () => validateSalonPincode(true));
            }

            const yearEl = document.getElementById('establishedYear');
            if (yearEl) {
                yearEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\\D/g, '').slice(0, 4);
                    validateEstablishedYear(false);
                    recalculateSalonProgress();
                });
                yearEl.addEventListener('blur', () => validateEstablishedYear(true));
            }

            const gstEl = document.getElementById('gstNumber');
            if (gstEl) {
                gstEl.addEventListener('input', function () {
                    this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 15);
                    validateGstNumber(false);
                });
                gstEl.addEventListener('blur', () => validateGstNumber(true));
            }

            // Bind other fields
            const nameEl = document.getElementById('salonName');
            if (nameEl) {
                nameEl.addEventListener('input', () => { validateSalonName(false); recalculateSalonProgress(); });
                nameEl.addEventListener('blur', () => validateSalonName(true));
            }

            const typeEl = document.getElementById('salonType');
            if (typeEl) {
                typeEl.addEventListener('change', () => { validateSalonType(true); recalculateSalonProgress(); });
            }

            const catEl = document.getElementById('salonCategory');
            if (catEl) {
                catEl.addEventListener('change', () => { validateSalonCategory(true); recalculateSalonProgress(); });
            }

            const emailEl = document.getElementById('salonEmail');
            if (emailEl) {
                emailEl.addEventListener('input', () => { validateSalonEmail(false); recalculateSalonProgress(); });
                emailEl.addEventListener('blur', () => validateSalonEmail(true));
            }

            const addrEl = document.getElementById('salonAddress');
            if (addrEl) {
                addrEl.addEventListener('input', () => { validateSalonAddress(false); recalculateSalonProgress(); });
                addrEl.addEventListener('blur', () => validateSalonAddress(true));
            }

            recalculateSalonProgress();
        });
    </script>
"""

if "initLocationSelectors" not in content:
    content = content.replace("    <script src=\"${pageContext.request.contextPath}/resources/js/csrf-sync.js\"></script>", script_tag + "\n    <script src=\"${pageContext.request.contextPath}/resources/js/csrf-sync.js\"></script>")

with open(jsp_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Successfully applied updates to salon-profile.jsp")
