<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Form | Fight D Fear</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

    <style>
        :root {
            --primary-red: #f43f5e; /* Matching Fight D Fear vibrant theme */
            --primary-dark: #0f172a;
            --accent-purple: #1e1b4b;
            --soft-bg: #f8fafc;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
            --card-radius: 16px;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--soft-bg);
            color: #334155;
        }

        h1, h2, h3, h4, h5, .outfit-font {
            font-family: 'Outfit', sans-serif;
        }

        .enrollment-header {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--accent-purple) 100%);
            padding: 60px 0;
            color: white;
            border-radius: 0 0 40px 40px;
            margin-bottom: -40px;
        }
        /* Issue 135: Enforce white text on the enrollment header */
        .enrollment-header h1, .enrollment-header p {
            color: #ffffff !important;
        }

        .form-section-card {
            background: white;
            border-radius: var(--card-radius);
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(226, 232, 240, 0.8);
            box-shadow: var(--card-shadow);
            transition: transform 0.2s ease;
        }

        .form-section-card:hover {
            transform: translateY(-2px);
        }

        .section-title {
            color: var(--primary-dark);
            font-weight: 700;
            font-size: 1.25rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--primary-red);
            font-size: 1.4rem;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #64748b;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-red);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
        }

        .summary-card {
            position: sticky;
            top: 100px;
            background: var(--primary-dark);
            color: white;
            border-radius: var(--card-radius);
            padding: 25px;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.2);
        }

        .summary-title {
            font-size: 1.2rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        .summary-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .summary-icon {
            width: 32px;
            height: 32px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-red);
        }

        .summary-label {
            font-size: 0.8rem;
            color: #94a3b8;
            display: block;
        }

        .summary-value {
            font-weight: 600;
            font-size: 0.95rem;
        }

        .fee-badge {
            background: var(--primary-red);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            margin-top: 20px;
        }

        .fee-label {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .fee-value {
            font-size: 1.5rem;
            font-weight: 800;
            display: block;
        }

        .btn-submit {
            background: var(--primary-red);
            color: white;
            border: none;
            padding: 18px 30px;
            border-radius: 12px;
            font-weight: 700;
            width: 100%;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-submit:hover {
            background: #be185d;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(219, 39, 119, 0.3);
            color: white;
        }

        .checkbox-group {
            background: #f1f5f9;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 15px;
        }

        .form-check-input:checked {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .motivation-box {
            background: #f8fafc;
            border: 2px dashed #e2e8f0;
            padding: 20px;
            border-radius: 12px;
        }

        /* Responsive Fixes */
        @media (max-width: 991px) {
            .summary-card {
                position: static;
                margin-top: 30px;
            }
        }
    </style>
</head>
<body>

    <!-- ======= Header ======= -->
    <header id="header" class="header d-flex align-items-center sticky-top shadow-sm" style="background: white;">
        <div class="container-fluid container-xl d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto">
                <h1 style="color: var(--primary-red); font-weight: 800; margin: 0;">Fight D Fear</h1>
            </a>
            <nav id="navmenu" class="navmenu">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/users/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Centres</a></li>
                    <li><a href="${pageContext.request.contextPath}/video/reels">Reels</a></li>
                </ul>
                <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
            </nav>
            <a class="btn btn-danger btn-sm rounded-pill px-4 ms-3" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </header>

    <div class="enrollment-header text-center">
        <div class="container">
            <h1 class="display-5 fw-bold mb-2">Enrollment Form</h1>
            <p class="lead opacity-75">Fill in your details to enroll in our training program</p>
        </div>
    </div>

    <main class="container my-5">
        <div class="row g-4">
            
            <!-- Left Side: Form -->
            <div class="col-lg-8">
                <form id="complexEnrollmentForm">
                    <!-- Hidden Data -->
                    <input type="hidden" id="centerId" value="${center.id}">

                    <!-- 1. Personal Details -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-person-circle"></i>
                            <span>1. Personal Details</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Full Name *</label>
                                <input type="text" id="fullName" class="form-control" placeholder="Enter full name" required oninput="updateSummary()">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Date of Birth *</label>
                                <input type="date" id="dob" class="form-control" required onchange="calculateAge(); updateSummary()" max="<%= java.time.LocalDate.now() %>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Age</label>
                                <input type="text" id="age" class="form-control bg-light" readonly placeholder="Auto">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Gender *</label>
                                <select id="gender" class="form-select" required>
                                    <option value="">Select</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Phone Number *</label>
                                <input type="tel" id="phone" class="form-control" value="${user.phoneNumber}" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Email Address *</label>
                                <input type="email" id="email" class="form-control" value="${user.email}" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Residential Address *</label>
                                <textarea id="address" class="form-control" rows="2" placeholder="Enter complete address" required></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Emergency Contact -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-telephone-plus"></i>
                            <span>2. Emergency Contact Details</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Emergency Contact Name *</label>
                                <input type="text" id="eName" class="form-control" required>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Training Preference -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-star"></i>
                            <span>3. Training Preference</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Preferred Batch *</label>
                                <c:choose>
                                    <c:when test="${empty batches}">
                                        <div class="alert alert-warning py-2 px-3 rounded-3 small">
                                            <i class="bi bi-exclamation-triangle me-2"></i>
                                            No batches have been added for this centre yet. Please check back later or contact the centre.
                                        </div>
                                        <input type="hidden" id="batchId" value="">
                                    </c:when>
                                    <c:otherwise>
                                        <select id="batchId" name="batchId" class="form-select" required onchange="updateBatchInfo(); updateSummary()">
                                            <option value="">Select a batch</option>
                                            <c:forEach var="batch" items="${batches}">
                                                <option value="${batch.id}"
                                                        data-style="${batch.style}"
                                                        data-level="${batch.skillLevel}"
                                                        data-days="${batch.availableDays}"
                                                        data-slot="${batch.timeSlot}"
                                                        data-fee="${batch.fee}"
                                                        data-instructor="${batch.instructor}"
                                                        data-agegroup="${batch.ageGroup}"
                                                        ${batch.id == preselectedBatchId ? 'selected' : ''}>
                                                    ${batch.name} (${batch.style})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Skill Level</label>
                                <input type="text" id="skillLevel" class="form-control bg-light" readonly placeholder="Auto from batch">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Preferred Days</label>
                                <div class="checkbox-group d-flex flex-wrap gap-3" id="daysGroup">
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="MONDAY" id="mon" onchange="updateSummary()">
                                        <label class="form-check-label" for="mon">Mon</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="TUESDAY" id="tue" onchange="updateSummary()">
                                        <label class="form-check-label" for="tue">Tue</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="WEDNESDAY" id="wed" onchange="updateSummary()">
                                        <label class="form-check-label" for="wed">Wed</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="THURSDAY" id="thu" onchange="updateSummary()">
                                        <label class="form-check-label" for="thu">Thu</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="FRIDAY" id="fri" onchange="updateSummary()">
                                        <label class="form-check-label" for="fri">Fri</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="SATURDAY" id="sat" onchange="updateSummary()">
                                        <label class="form-check-label" for="sat">Sat</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input day-check" type="checkbox" value="SUNDAY" id="sun" onchange="updateSummary()">
                                        <label class="form-check-label" for="sun">Sun</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Training Goal *</label>
                                <select id="goal" class="form-select" required onchange="updateSummary()">
                                    <option value="">Select primary goal</option>
                                    <option value="Self-defense">Self-defense</option>
                                    <option value="Fitness">Fitness</option>
                                    <option value="Competition">Competition</option>
                                    <option value="Discipline">Discipline</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Trainer Preference (Optional)</label>
                                <!-- Issue 136: Dropdown to select trainer from available batch instructors -->
                                <select id="trainerPref" class="form-select">
                                    <option value="">Any available trainer</option>
                                    <%-- Options populated dynamically by JS after batch selection --%>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Health Information -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-heart-pulse"></i>
                            <span>4. Health Information</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Medical Conditions / Injuries</label>
                                <textarea id="medical" class="form-control" rows="2" placeholder="Specify if any"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Allergies</label>
                                <textarea id="allergies" class="form-control" rows="2" placeholder="Specify if any"></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Fitness Notes / Restrictions</label>
                                <textarea id="fitnessNotes" class="form-control" rows="2" placeholder="Any notes for the trainer"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- 5. Motivation -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-quote"></i>
                            <span>5. Additional Information</span>
                        </div>
                        <div class="motivation-box">
                            <label class="form-label d-block mb-3">Why do you want to learn martial arts? *</label>
                            <textarea id="motivation" class="form-control border-0 bg-white" rows="4" placeholder="Share your motivation and goals (optional)" required></textarea>
                        </div>
                    </div>

                    <!-- 6. Enrollment Details -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-calendar-check"></i>
                            <span>6. Enrollment Details</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Proposed Start Date *</label>
                                <!-- Issue 137: Only allow future dates for proposed start date -->
                                <input type="date" id="startDate" class="form-control" required onchange="updateSummary()">
                            </div>
                        </div>
                    </div>

                    <!-- 7. Consent -->
                    <div class="form-section-card" data-aos="fade-up">
                        <div class="section-title">
                            <i class="bi bi-check2-all"></i>
                            <span>7. Consent</span>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="consentAcc" required>
                            <label class="form-check-label small" for="consentAcc">
                                I confirm that the information provided is accurate to the best of my knowledge.
                            </label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="consentRules" required>
                            <label class="form-check-label small" for="consentRules">
                                I agree to follow the academy rules, safety guidelines, and training policies.
                            </label>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="mb-5">
                        <button type="submit" id="submitBtn" class="btn-submit">
                            <i class="bi bi-send-fill"></i>
                            Submit Enrollment
                        </button>
                    </div>

                </form>
            </div>

            <!-- Right Side: Summary Sticky -->
            <div class="col-lg-4">
                <div class="summary-card" data-aos="fade-left">
                    <div class="summary-title">Enrollment Summary</div>
                    
                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-fist-raised"></i></div>
                        <div>
                            <span class="summary-label">Martial Art Style</span>
                            <span class="summary-value" id="sStyle">Not selected</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-chart-line"></i></div>
                        <div>
                            <span class="summary-label">Skill Level</span>
                            <span class="summary-value" id="sLevel">--</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-layer-group"></i></div>
                        <div>
                            <span class="summary-label">Preferred Batch</span>
                            <span class="summary-value" id="sBatch">--</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-calendar-alt"></i></div>
                        <div>
                            <span class="summary-label">Preferred Days</span>
                            <span class="summary-value" id="sDays">--</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-clock"></i></div>
                        <div>
                            <span class="summary-label">Time Slot</span>
                            <span class="summary-value" id="sSlot">--</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-bullseye"></i></div>
                        <div>
                            <span class="summary-label">Training Goal</span>
                            <span class="summary-value" id="sGoal">--</span>
                        </div>
                    </div>

                    <div class="summary-item">
                        <div class="summary-icon"><i class="fas fa-play"></i></div>
                        <div>
                            <span class="summary-label">Proposed Start Date</span>
                            <span class="summary-value" id="sStart">--</span>
                        </div>
                    </div>

                    <div class="fee-badge">
                        <span class="fee-label">Monthly Enrollment Fee</span>
                        <span class="fee-value">₹ <span id="sFee">0.00</span></span>
                    </div>

                    <div class="mt-4 p-3 rounded-4" style="background: rgba(255,255,255,0.05); font-size: 0.85rem;">
                        <p class="mb-0 text-white-50"><i class="bi bi-info-circle me-2"></i> Your information is safe with us and will only be used for training and communication purposes.</p>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center p-4">
                <div class="mb-3">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                </div>
                <h3 class="fw-bold" id="successModalTitle">Enrollment Submitted!</h3>
                <p class="text-muted" id="successModalBody">Your details have been saved. Proceed to payment to finalize your enrollment.</p>
                <button id="proceedPaymentBtn" class="btn btn-danger w-100 py-3 rounded-pill fw-bold">Proceed to Payment</button>
                <a id="goToDashboardBtn" href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-success w-100 py-3 rounded-pill fw-bold mt-2" style="display:none;">Go to My Dashboard</a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <script>
        AOS.init({ duration: 800, once: true });

        // Auto-trigger batch info if a batch was preselected from URL
        document.addEventListener('DOMContentLoaded', function() {
            const batchSelect = document.getElementById('batchId');
            if (batchSelect && batchSelect.value) {
                updateBatchInfo();
                updateSummary();
            }
        });

        function calculateAge() {
            const dobInput = document.getElementById('dob');
            const dob = dobInput.value;
            if (!dob) return;
            const birthDate = new Date(dob);
            const today = new Date();
            today.setHours(0,0,0,0);
            
            if (birthDate > today) {
                alert("Date of Birth cannot be in the future!");
                dobInput.value = "";
                document.getElementById('age').value = "";
                return;
            }

            let age = today.getFullYear() - birthDate.getFullYear();
            const m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            document.getElementById('age').value = age;
        }

        function updateBatchInfo() {
            const select = document.getElementById('batchId');
            const option = select.options[select.selectedIndex];
            if (select.value) {
                document.getElementById('skillLevel').value = option.dataset.level;

                // Issue 139: Lock schedule days to match selected batch, not user-overridable
                const days = option.dataset.days ? option.dataset.days.toUpperCase() : '';
                document.querySelectorAll('.day-check').forEach(chk => {
                    const dayMatch = days.split(',').some(d => days.includes(chk.value.substring(0,3)));
                    // Match MON -> MONDAY, TUE -> TUESDAY, etc.
                    const abbr = {
                        'MONDAY': 'MON', 'TUESDAY': 'TUE', 'WEDNESDAY': 'WED',
                        'THURSDAY': 'THU', 'FRIDAY': 'FRI', 'SATURDAY': 'SAT', 'SUNDAY': 'SUN'
                    };
                    const abbrVal = abbr[chk.value] || chk.value.substring(0,3);
                    const isInBatch = days.includes(abbrVal);
                    chk.checked = isInBatch;
                    chk.disabled = true; // Issue 139: Disable to prevent override
                });

                // Issue 136: Populate trainer dropdown with the batch instructor
                const trainerSelect = document.getElementById('trainerPref');
                trainerSelect.innerHTML = '<option value="">Any available trainer</option>';
                const instructor = option.dataset.instructor || '';
                if (instructor) {
                    const opt = document.createElement('option');
                    opt.value = instructor;
                    opt.text = instructor;
                    opt.selected = true;
                    trainerSelect.appendChild(opt);
                }
            } else {
                // Re-enable if no batch selected
                document.querySelectorAll('.day-check').forEach(chk => {
                    chk.disabled = false;
                    chk.checked = false;
                });
            }
        }

        function updateSummary() {
            const batchSelect = document.getElementById('batchId');
            const batchOpt = batchSelect.options[batchSelect.selectedIndex];

            if (batchSelect.value) {
                document.getElementById('sStyle').innerText = batchOpt.dataset.style;
                document.getElementById('sLevel').innerText = batchOpt.dataset.level;
                document.getElementById('sBatch').innerText = batchOpt.text;
                document.getElementById('sSlot').innerText = batchOpt.dataset.slot;
                document.getElementById('sFee').innerText = parseFloat(batchOpt.dataset.fee).toLocaleString();
            }

            document.getElementById('sGoal').innerText = document.getElementById('goal').value || '--';
            document.getElementById('sStart').innerText = document.getElementById('startDate').value || '--';

            // Days
            const checkedDays = Array.from(document.querySelectorAll('.day-check:checked')).map(c => c.parentElement.innerText.trim());
            document.getElementById('sDays').innerText = checkedDays.join(', ') || '--';
        }

        // Form Submit
        document.getElementById('complexEnrollmentForm').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('submitBtn');

            // Issue 138: Validate age group against selected batch
            const batchSel = document.getElementById('batchId');
            const batchOpt = batchSel.options[batchSel.selectedIndex];
            const ageGroup = batchOpt ? (batchOpt.dataset.agegroup || '') : '';
            const userAge = parseInt(document.getElementById('age').value) || 0;
            if (ageGroup && userAge > 0) {
                let ageOk = true;
                if (ageGroup.toLowerCase().includes('kids') && (userAge < 5 || userAge > 12)) ageOk = false;
                else if (ageGroup.toLowerCase().includes('teens') && (userAge < 13 || userAge > 17)) ageOk = false;
                else if (ageGroup.toLowerCase().includes('adults') && userAge < 18) ageOk = false;
                if (!ageOk) {
                    alert('Your age (' + userAge + ') does not match the required age group for this batch: ' + ageGroup);
                    return;
                }
            }

            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Submitting...';

            const payload = {
                centerId: document.getElementById('centerId').value,
                batchId: document.getElementById('batchId').value,
                fullName: document.getElementById('fullName').value,
                dob: document.getElementById('dob').value,
                age: parseInt(document.getElementById('age').value),
                gender: document.getElementById('gender').value,
                phoneNumber: document.getElementById('phone').value,
                email: document.getElementById('email').value,
                address: document.getElementById('address').value,
                emergencyName: document.getElementById('eName').value,
                skillLevel: document.getElementById('skillLevel').value,
                preferredDays: Array.from(document.querySelectorAll('.day-check:checked')).map(c => c.value),
                goal: document.getElementById('goal').value,
                motivation: document.getElementById('motivation').value,
                medicalConditions: document.getElementById('medical').value,
                allergies: document.getElementById('allergies').value,
                fitnessNotes: document.getElementById('fitnessNotes').value,
                startDate: document.getElementById('startDate').value,
                trainerPreference: document.getElementById('trainerPref').value,
                monthlyFee: parseFloat(document.getElementById('sFee').innerText.replace(/,/g, '')),
                consentAccuracy: document.getElementById('consentAcc').checked,
                consentRules: document.getElementById('consentRules').checked
            };

            try {
                const res = await fetch('${pageContext.request.contextPath}/enrollment/api/enrollments', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (res.status === 409) {
                    // Batch is full
                    alert('⚠️ This batch is full! No more seats are available. Please choose another batch.');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-send-fill"></i> Submit Enrollment';
                    return;
                }

                if (res.ok) {
                    const data = await res.json();

                    if (data.free === true) {
                        // FREE BATCH: skip Razorpay, show success directly
                        document.getElementById('successModalTitle').innerText = '🎉 Enrollment Confirmed!';
                        document.getElementById('successModalBody').innerText = 'You have been enrolled for free! Your training starts soon. Check your dashboard for updates.';
                        document.getElementById('proceedPaymentBtn').style.display = 'none';
                        document.getElementById('goToDashboardBtn').style.display = 'block';
                        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                        successModal.show();
                    } else {
                        // PAID BATCH: open Razorpay
                        document.getElementById('successModalTitle').innerText = 'Enrollment Submitted!';
                        document.getElementById('successModalBody').innerText = 'Your details have been saved. Proceed to payment to finalize your enrollment.';
                        document.getElementById('proceedPaymentBtn').style.display = 'block';
                        document.getElementById('goToDashboardBtn').style.display = 'none';
                        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                        successModal.show();

                        document.getElementById('proceedPaymentBtn').onclick = () => {
                            initiateRazorpay(data.enrollmentId, payload.monthlyFee);
                        };
                    }
                } else {
                    const err = await res.text();
                    alert("Error: " + err);
                }
            } catch (err) {
                alert("Network error: " + err.message);
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-send-fill"></i> Submit Enrollment';
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Issue 137: Set min date to tomorrow for proposed start date
            const startDateInput = document.getElementById('startDate');
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            startDateInput.min = tomorrow.toISOString().split('T')[0];

            const preId = '${preselectedBatchId}';
            if (preId && preId !== '' && preId !== 'null') {
                const sel = document.getElementById('batchId');
                sel.value = preId;
                updateBatchInfo();
                updateSummary();
            }
        });

        async function initiateRazorpay(enrollmentId, amount) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/payment/create-order', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ amount, type: 'MARTIAL_ARTS' })
                });

                if (!response.ok) throw new Error('Order creation failed');
                const order = await response.json();

                const options = {
                    key: order.key,
                    amount: order.amount,
                    currency: 'INR',
                    name: 'Fight D Fear Martial Arts',
                    description: 'Batch Enrollment Fee',
                    order_id: order.orderId,
                    handler: async function (response) {
                        const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_signature: response.razorpay_signature,
                                type: 'MARTIAL_ARTS',
                                enrollmentId: enrollmentId,
                                centerId: document.getElementById('centerId').value,
                                batchId: document.getElementById('batchId').value,
                                amount: amount
                            })
                        });

                        if (verifyRes.ok) {
                            alert('Success! You are now enrolled.');
                            window.location.href = '${pageContext.request.contextPath}/enrollment/enrollmentSuccess';
                        } else {
                            const errData = await verifyRes.json().catch(() => ({}));
                            alert('Payment verification failed: ' + (errData.error || 'Unknown error. Please contact support.'));
                        }
                    },
                    prefill: {
                        name: document.getElementById('fullName').value,
                        email: document.getElementById('email').value,
                        contact: document.getElementById('phone').value
                    },
                    theme: { color: '#f43f5e' }
                };

                const rzp = new Razorpay(options);
                rzp.open();
            } catch (error) {
                alert('Razorpay error: ' + error.message);
            }
        }
    </script>
</body>
</html>

