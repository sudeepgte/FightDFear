p = 'src/main/webapp/WEB-INF/views/centreDashboard.jsp'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Verification banner right after <div class="content-container">
target1 = """        <!-- Content Area -->
        <div class="content-container">

            <!-- Tab 1: Overview Workspace -->"""

repl1 = """        <!-- Content Area -->
        <div class="content-container">

            <!-- Flash Status Message -->
            <c:if test="${not empty message}">
                <div style="background: #ECFDF5; border: 1.5px solid #A7F3D0; color: #065F46; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 700; font-size: 0.92rem; box-shadow: 0 2px 6px rgba(0,0,0,0.03);">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 1.25rem;"></i>
                    <span><c:out value="${message}"/></span>
                </div>
            </c:if>

            <!-- Pending Verification Banner (When submitted / waiting for admin review) -->
            <c:if test="${loggedCentre.centreProfileStatus == 'PENDING_ADMIN_APPROVAL' || (!loggedCentre.approved && loggedCentre.centreProfileStatus != 'APPROVED')}">
                <div class="verification-pending-card" style="background: linear-gradient(135deg, #FFFBEB 0%, #FEF3C7 100%); border: 1.5px solid #FCD34D; border-left: 6px solid #F59E0B; border-radius: 16px; padding: 20px 24px; margin-bottom: 24px; box-shadow: 0 4px 16px rgba(245, 158, 11, 0.12);">
                    <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; flex-wrap: wrap;">
                        <div style="display: flex; align-items: flex-start; gap: 14px; max-width: 720px;">
                            <div style="width: 48px; height: 48px; border-radius: 12px; background: #FEF3C7; color: #D97706; display: flex; align-items: center; justify-content: center; font-size: 1.6rem; flex-shrink: 0; border: 1px solid #FDE68A;">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                            <div>
                                <h3 style="font-size: 1.12rem; font-weight: 800; color: #92400E; margin: 0 0 6px;">Profile Submitted — Wait for Admin Verification</h3>
                                <p style="font-size: 0.88rem; color: #78350F; margin: 0 0 10px; line-height: 1.5;">
                                    Your centre profile has been submitted and is currently being reviewed by our Admin team. While under review, batch creation, attendance tracking, and student enrollments are locked. They will unlock automatically once your centre is approved.
                                </p>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                                    <span style="background: #FDE68A; color: #78350F; font-size: 0.78rem; font-weight: 800; padding: 5px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.4px;">
                                        <i class="bi bi-shield-lock-fill me-1"></i> Features Locked: Waiting for Verification
                                    </span>
                                    <span style="font-size: 0.82rem; color: #92400E;">
                                        <i class="bi bi-clock-history me-1"></i> Review usually takes 12-24 hours
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div style="align-self: center;">
                            <a href="${pageContext.request.contextPath}/centres/profile-completion" style="display: inline-flex; align-items: center; gap: 8px; background: #92400E; color: #FFFFFF; font-size: 0.85rem; font-weight: 700; padding: 10px 18px; border-radius: 10px; text-decoration: none; box-shadow: 0 2px 8px rgba(146, 64, 14, 0.25);">
                                <i class="bi bi-eye-fill"></i> View Submitted Profile
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Tab 1: Overview Workspace -->"""

# 2. Quick Actions Toolbar with verification check
target2 = """                <!-- Clean Quick Actions Toolbar matching Fitness -->
                <div class="quick-actions-bar">
                    <button type="button" class="btn-quick-pill primary" onclick="switchTab('batches'); openCreateBatchModal();">
                        <i class="bi bi-plus-circle-fill"></i> Create Batch
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('attendance');">
                        <i class="bi bi-clipboard-check-fill"></i> Trainee Attendance
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('live'); openCreateLiveClassModal();">
                        <i class="bi bi-camera-video-fill"></i> Create Live Class
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('past-sessions');">
                        <i class="bi bi-clock-history"></i> Past Sessions
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('students');">
                        <i class="bi bi-people-fill"></i> Manage Students
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('grading');">
                        <i class="bi bi-award-fill"></i> Belt Grading
                    </button>
                </div>"""

repl2 = """                <!-- Clean Quick Actions Toolbar matching Fitness -->
                <div class="quick-actions-bar">
                    <c:choose>
                        <c:when test="${loggedCentre.approved || loggedCentre.centreProfileStatus == 'APPROVED'}">
                            <button type="button" class="btn-quick-pill primary" onclick="switchTab('batches'); openCreateBatchModal();">
                                <i class="bi bi-plus-circle-fill"></i> Create Batch
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="switchTab('attendance');">
                                <i class="bi bi-clipboard-check-fill"></i> Trainee Attendance
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="switchTab('live'); openCreateLiveClassModal();">
                                <i class="bi bi-camera-video-fill"></i> Create Live Class
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="switchTab('past-sessions');">
                                <i class="bi bi-clock-history"></i> Past Sessions
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="switchTab('students');">
                                <i class="bi bi-people-fill"></i> Manage Students
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="switchTab('grading');">
                                <i class="bi bi-award-fill"></i> Belt Grading
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn-quick-pill primary" style="opacity: 0.88;" onclick="showVerificationLockedModal('Batch Creation');">
                                <i class="bi bi-lock-fill"></i> Create Batch <span style="background: #FDE68A; color: #92400E; font-size: 0.65rem; padding: 2px 6px; border-radius: 10px; margin-left: 4px; font-weight: 800;">Wait for Verification</span>
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="showVerificationLockedModal('Trainee Attendance');">
                                <i class="bi bi-lock-fill text-warning"></i> Trainee Attendance
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="showVerificationLockedModal('Live Classes');">
                                <i class="bi bi-lock-fill text-warning"></i> Create Live Class
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="showVerificationLockedModal('Past Sessions');">
                                <i class="bi bi-lock-fill text-warning"></i> Past Sessions
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="showVerificationLockedModal('Student Management');">
                                <i class="bi bi-lock-fill text-warning"></i> Manage Students
                            </button>
                            <button type="button" class="btn-quick-pill" onclick="showVerificationLockedModal('Belt Grading');">
                                <i class="bi bi-lock-fill text-warning"></i> Belt Grading
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>"""

# 3. Add Modal at the end before </body>
target3 = "</body>"
repl3 = """    <!-- Verification Lock Modal -->
    <div id="verificationLockModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.65); backdrop-filter: blur(4px); z-index: 2000; align-items: center; justify-content: center; padding: 20px;">
        <div style="background: #FFFFFF; border-radius: 20px; max-width: 520px; width: 100%; padding: 28px; text-align: center; box-shadow: 0 20px 50px rgba(0,0,0,0.2);">
            <div style="width: 64px; height: 64px; border-radius: 50%; background: #FEF3C7; color: #D97706; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 16px; border: 2px solid #FDE68A;">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 800; color: #0F172A; margin-bottom: 8px;">Feature Locked &bull; Wait for Verification</h3>
            <p style="font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 16px;">
                <strong id="lockFeatureName" style="color: #0F172A;">This feature</strong> is temporarily locked because your centre profile is awaiting Admin Verification. Once approved, all batch creation, attendance tracking, and student admission tools will be fully activated.
            </p>
            <div style="margin-bottom: 20px;">
                <span style="background: #FEF3C7; color: #92400E; font-size: 0.78rem; font-weight: 800; padding: 6px 14px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.5px; border: 1px solid #FDE68A;">
                    <i class="bi bi-clock-history me-1"></i> Status: Under Admin Review
                </span>
            </div>
            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <button type="button" onclick="closeVerificationLockModal()" style="padding: 10px 20px; background: #F1F5F9; color: #334155; border: 1px solid #CBD5E1; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer;">
                    Close
                </button>
                <a href="${pageContext.request.contextPath}/centres/profile-completion" style="padding: 10px 22px; background: #F43F5E; color: #FFFFFF; border: none; border-radius: 10px; font-weight: 700; font-size: 0.9rem; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                    <i class="bi bi-eye-fill"></i> View Submitted Profile
                </a>
            </div>
        </div>
    </div>

    <script>
        function showVerificationLockedModal(featureName) {
            const el = document.getElementById('lockFeatureName');
            if (el) el.textContent = featureName || 'This feature';
            const m = document.getElementById('verificationLockModal');
            if (m) m.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closeVerificationLockModal() {
            const m = document.getElementById('verificationLockModal');
            if (m) m.style.display = 'none';
            document.body.style.overflow = '';
        }
    </script>
</body>"""

assert target1 in content, 'target1 not found in centreDashboard.jsp'
assert target2 in content, 'target2 not found in centreDashboard.jsp'
assert target3 in content, 'target3 not found in centreDashboard.jsp'

content = content.replace(target1, repl1, 1).replace(target2, repl2, 1).replace(target3, repl3, 1)

with open(p, 'w', encoding='utf-8', newline='') as f:
    f.write(content)

print('Successfully updated centreDashboard.jsp with verification pending banner and locked features')
