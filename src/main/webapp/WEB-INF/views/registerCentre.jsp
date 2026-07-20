<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Martial Arts Center</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/jquery-3.6.0.min.js"></script>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Poppins', sans-serif; min-height:100vh; display:flex; background:#fff; color:var(--fdf-text); }
        .auth-container { flex:1; display:flex; width:100%; }
        /* === Left Panel — Visual Side === */
        .left-panel {
            flex: 1;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 40px;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: -100px; right: -100px;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }

        .left-panel::after {
            content: '';
            position: absolute;
            bottom: -150px; left: -80px;
            width: 500px; height: 500px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }

        .left-panel .brand {
            position: relative; z-index: 2;
            text-align: center;
            color: white;
        }

        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 16px;
        }

        .brand-logo i {
            font-size: 2.22rem;
            margin-right: 8px;
            opacity: 0.9;
        }

        .brand-tagline {
            font-size: 1.15rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 360px;
            line-height: 1.7;
            margin-bottom: 40px;
        }

        .feature-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
            text-align: left;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 14px;
            color: rgba(255,255,255,0.9);
            font-size: 0.95rem;
            font-weight: 400;
        }

        .feature-list li .feat-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: rgba(255,255,255,0.15);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .form-panel { flex:1.2; display:flex; justify-content:center; align-items:center; padding:40px; background:#fff; overflow-y:auto; }
        .reg-card { width:100%; max-width:700px; }
        .reg-card h2 { font-family:'Montserrat', sans-serif; font-size:1.8rem; font-weight:900; color:var(--brand-purple-darker); margin-bottom:25px; border-left:5px solid var(--brand-pink); padding-left:15px; }
        .fdf-row { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:15px; }
        .fdf-group { margin-bottom:15px; }
        .fdf-group label { display:block; font-size:0.75rem; font-weight:800; color:var(--brand-purple-dark); margin-bottom:6px; text-transform:uppercase; }
        .fdf-input { width:100%; padding:12px 16px; border:1px solid var(--fdf-border); border-radius:12px; background:#fdf2f8; outline:none; transition:0.3s; font-family:inherit; }
        .fdf-input:focus { border-color:var(--brand-pink); background:#fff; box-shadow:0 0 0 4px rgba(219,39,119,0.05); }
        .btn-fdf { width:100%; padding:16px; background:var(--gradient-primary); color:#fff; border:none; border-radius:14px; font-size:1rem; font-weight:800; cursor:pointer; }
        .dr-progress { display:flex; justify-content:flex-start; gap:15px; margin-bottom:30px; }
        .dr-step-dot { width:32px; height:32px; border-radius:50%; background:#f1f5f9; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.8rem; cursor:pointer; border:2px solid transparent; transition:0.3s; color:var(--fdf-muted); }
        .dr-step-dot.active { background:var(--brand-pink); color:#fff; transform:scale(1.15); box-shadow:0 0 15px rgba(219,39,119,0.3); }
        .dr-step-dot.completed { background:var(--brand-purple); color:#fff; }
        .dr-step-panel { display:none; animation:fadeIn 0.4s ease; }
        .dr-step-panel.active { display:block; }
        @keyframes fadeIn { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }
        .btn-dr { padding:14px 28px; border-radius:12px; font-weight:800; cursor:pointer; transition:0.3s; border:none; }
        .btn-dr-next { background:var(--gradient-primary); color:#fff; }
        .btn-dr-prev { background:#f1f5f9; color:var(--fdf-muted); }

        .martial-art-type { background:rgba(219,39,119,0.03); padding:20px; border-radius:16px; margin-bottom:15px; border:1px dashed var(--brand-pink-light); }
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel {
                min-height: 25vh;
                padding: 40px 20px;
                text-align: center;
            }
            .feature-list { display: none; }
            .brand-tagline { margin: 0 auto; font-size: 1rem; }
            .form-panel {
                padding: 40px 20px;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
            }
            .reg-card h2 { font-size: 1.8rem; }
        }

        @media (max-width: 600px) {
            .fdf-row { grid-template-columns: 1fr; gap: 0; }
            .dr-progress { justify-content: center; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .reg-card h2 { font-size: 1.5rem; }
            .fdf-input { padding: 10px 14px; }
            .btn-fdf { padding: 14px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo"><i class="fas fa-dumbbell"></i> Fight D Fear</div>
                <p class="brand-tagline">Empower your students with professional martial arts training and safety education.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-person-badge-fill"></i></span> Learn Self-Defense from Experts</li>
                    <li><span class="feat-icon"><i class="bi bi-graph-up-arrow"></i></span> Beginner to Advanced Training Programs</li>
                    <li><span class="feat-icon"><i class="bi bi-award-fill"></i></span> Build Confidence & Strength</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-shaded"></i></span> Stay Prepared for Real-Life Situations</li>
                </ul>
            </div>
        </div>
        <div class="form-panel">
            <div class="reg-card">                <div class="dr-progress">
                    <div class="dr-step-dot active" data-step="1" onclick="showStep(1)" style="cursor:pointer;">1</div>
                    <div class="dr-step-dot" data-step="2" onclick="showStep(2)" style="cursor:pointer;">2</div>
                    <div class="dr-step-dot" data-step="3" onclick="showStep(3)" style="cursor:pointer;">3</div>
                </div>

                <h2>Martial Arts Center</h2>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="border-radius:12px; margin-bottom:16px;">${error}</div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success" style="border-radius:12px; margin-bottom:16px;">${message}</div>
                </c:if>
                <form:form action="${pageContext.request.contextPath}/centres/register" method="post" modelAttribute="martialArtsCenter" enctype="multipart/form-data" id="registerForm">
                    
                    <!-- Step 1: Identity & Contact -->
                    <div class="dr-step-panel active" id="step1">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker);">Basic Identity</h3>
                        <div class="fdf-row">
                            <div class="fdf-group"><label>Center Name</label><form:input path="name" class="fdf-input" placeholder="Elite Martial Arts" required="required"/></div>
                            <div class="fdf-group"><label>Location</label><form:input path="location" class="fdf-input" placeholder="City, Area" required="required"/></div>
                        </div>
                        
                        <div class="fdf-row">
                            <div class="fdf-group"><label>Phone Number</label><form:input path="phoneNumber" class="fdf-input" type="tel" placeholder="10-digit number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required="required"/></div>
                            <div class="fdf-group"><label>Email Address</label><form:input path="email" type="email" class="fdf-input" placeholder="contact@center.com" required="required"/></div>
                        </div>
                        <div class="fdf-group"><label>Access Password</label><form:password path="password" class="fdf-input" pattern="(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}" placeholder="••••••••" required="required"/></div>

                        <div class="fdf-group">
                            <label>Working Days</label>
                            <div style="display:flex; flex-wrap:wrap; gap:10px; margin-top:5px;">
                                <c:forEach var="day" items="${AvailableDays}">
                                    <label style="display:flex; align-items:center; gap:5px; font-size:0.8rem; font-weight:700; cursor:pointer;">
                                        <form:checkbox path="availableDays" value="${day}"/><span>${fn:substring(day, 0, 3)}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <button type="button" class="btn-dr btn-dr-next w-100" onclick="nextStep(1)">Continue to Center Details</button>
                    </div>

                    <!-- Step 2: Center Details & Media -->
                    <div class="dr-step-panel" id="step2">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker);">Center Background & Media</h3>
                        
                        <div class="fdf-group"><label>About Center</label><form:textarea path="about" class="fdf-input" rows="2" placeholder="History and mission..." required="required"/></div>
                        <div class="fdf-group"><label>Teaching Methodology</label><form:textarea path="howWeTeach" class="fdf-input" rows="2" placeholder="Training style and approach..." required="required"/></div>
                        <div class="fdf-group"><label>Facilities & Offers</label><form:textarea path="whatWeOffer" class="fdf-input" rows="2" placeholder="Gym, changing rooms, etc." required="required"/></div>

                        <div class="fdf-row">
                            <div class="fdf-group"><label>Profile Image</label><input type="file" name="profileimage" class="fdf-input" style="padding:10px;" accept="image/*"/></div>
                            <div class="fdf-group"><label>Gallery Photos</label><input type="file" name="galleryPhotos" class="fdf-input" style="padding:10px;" accept="image/*" multiple/></div>
                        </div>
                        <div class="fdf-group"><label>Affiliation Certificate</label><input type="file" name="certificate" class="fdf-input" style="padding:10px;" accept="application/pdf,image/*" ></div>

                        <div style="display:flex; justify-content:space-between; gap:15px; margin-top:30px;">
                            <button type="button" class="btn-dr btn-dr-prev w-50" onclick="prevStep(2)">Back</button>
                            <button type="button" class="btn-dr btn-dr-next w-50" onclick="nextStep(2)">Manage Programs</button>
                        </div>
                    </div>

                    <!-- Step 3: Programs List -->
                    <div class="dr-step-panel" id="step3">
                        <h3 style="margin-bottom:20px; color:var(--brand-purple-darker);">Martial Arts Programs</h3>
                        <div class="fdf-group">
                            <label>Martial Arts Programs & Scheduling</label>
                            <div id="martialArtsTypesContainer"></div>
                            <button type="button" class="btn btn-sm btn-outline-primary" id="addMartialArtType" style="border-radius:10px; font-weight:700; padding:8px 15px; margin-top:10px;"><i class="fas fa-plus"></i> Add Program</button>
                        </div>
                        <input type="hidden" name="martialArtsJson" id="martialArtsJson"/>
                        
                        <div style="display:flex; justify-content:space-between; gap:15px; margin-top:30px;">
                            <button type="button" class="btn-dr btn-dr-prev w-50" onclick="prevStep(3)">Back</button>
                            <button type="submit" class="btn-dr btn-dr-next w-50">Complete Registration</button>
                        </div>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    <script>
    function showStep(s) {
        document.querySelectorAll('.dr-step-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('step' + s).classList.add('active');
        document.querySelectorAll('.dr-step-dot').forEach(d => {
            const step = parseInt(d.dataset.step);
            d.classList.remove('active', 'completed');
            if (step === s) d.classList.add('active');
            else if (step < s) d.classList.add('completed');
        });
    }
    function nextStep(s) {
        const panel = document.getElementById('step' + s);
        const req = panel.querySelectorAll('[required]');
        let valid = true;
        req.forEach(el => { if (!el.value) { el.style.borderColor = 'red'; valid = false; } else { el.style.borderColor = ''; } });
        if (valid) showStep(s + 1);
    }
    function prevStep(s) { showStep(s - 1); }

    $(document).ready(function() {
        function createMartialArtHtml(index) {
            return `<div class="martial-art-type" data-index="${index}">
                <div class="fdf-row">
                    <div class="fdf-group"><label>Program Name</label><input type="text" class="fdf-input martial-art-name" placeholder="e.g. Karate" required></div>
                    <div class="fdf-group"><label>Monthly Cost (₹)</label><input type="number" class="fdf-input martial-art-cost" placeholder="0.00" required></div>
                </div>
                <div class="slotsContainer"></div>
                <div style="display:flex; gap:10px; margin-top:10px;">
                    <button type="button" class="btn btn-sm btn-info add-slot" style="font-weight:700; color:#fff;">+ Add Slot</button>
                    <button type="button" class="btn btn-sm btn-danger remove-type" style="font-weight:700;">Remove</button>
                </div>
            </div>`;
        }
        function createSlotHtml() {
            return `<div class="input-group mb-2 slot" style="margin-top:10px;">
                <input type="text" class="fdf-input slot-time" style="border-radius:10px 0 0 10px;" placeholder="Time range (e.g. 5PM-6PM)" required>
                <button type="button" class="btn btn-danger remove-slot" style="border-radius:0 10px 10px 0;">×</button>
            </div>`;
        }
        let martialIndex = 0;
        $("#addMartialArtType").click(function() { $("#martialArtsTypesContainer").append(createMartialArtHtml(martialIndex++)); });
        $(document).on("click", ".add-slot", function() { $(this).closest('.martial-art-type').find(".slotsContainer").append(createSlotHtml()); });
        $(document).on("click", ".remove-slot", function() { $(this).closest(".slot").remove(); });
        $(document).on("click", ".remove-type", function() { $(this).closest(".martial-art-type").remove(); });
        $("#registerForm").submit(function(e) {
            let martialArts = [];
            $("#martialArtsTypesContainer .martial-art-type").each(function() {
                let typeName = ($(this).find(".martial-art-name").val() || "").trim();
                let costVal = $(this).find(".martial-art-cost").val();
                let cost = costVal === "" ? 0 : parseFloat(costVal);
                let slots = [];
                $(this).find(".slot").each(function() {
                    let tr = ($(this).find(".slot-time").val() || "").trim();
                    if (tr) slots.push({ timeRange: tr });
                });
                if (typeName) martialArts.push({ name: typeName, cost: cost, slots: slots });
            });
            if (martialArts.length === 0) {
                e.preventDefault();
                alert("Please add at least one martial arts program with at least one time slot.");
                showStep(3);
                return false;
            }
            $("#martialArtsJson").val(JSON.stringify(martialArts));
        });

        // Default first program row so registration is not submitted empty
        if ($("#martialArtsTypesContainer .martial-art-type").length === 0) {
            $("#addMartialArtType").click();
            $("#martialArtsTypesContainer .martial-art-type").last().find(".add-slot").click();
        }
    });
    </script>
</body>

</body>
</html>


