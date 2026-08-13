<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Online Class Management | Trainer</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #DC2626;
            --primary-hover: #B91C1C;
            --secondary: #0F172A;
            --bg-main: #F8FAFC;
            --radius: 20px;
            --shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.1);
        }
        body { font-family: 'Outfit', sans-serif; background-color: var(--bg-main); color: #1E293B; }
        .sidebar { width: 280px; background-color: var(--secondary); color: white; height: 100vh; position: fixed; left: 0; top: 0; padding: 40px 20px; }
        .main-content { margin-left: 280px; padding: 50px; }
        .panel { background: white; border-radius: var(--radius); padding: 35px; box-shadow: var(--shadow); border: 1px solid #E2E8F0; margin-bottom: 30px; }
        .btn-premium { background: linear-gradient(135deg, var(--primary), #991B1B); color: white; border: none; padding: 12px 25px; border-radius: 12px; font-weight: 700; transition: all 0.3s; }
        .btn-premium:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(220, 38, 38, 0.3); color: white; }
        .class-card { border: 1px solid #E2E8F0; border-radius: 18px; padding: 25px; background: white; transition: all 0.3s; height: 100%; }
        .class-card:hover { transform: translateY(-5px); box-shadow: var(--shadow); }
        .status-badge { padding: 5px 12px; border-radius: 30px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .status-upcoming { background: #DBEAFE; color: #1E40AF; }
        .status-live { background: #FEE2E2; color: #DC2626; animation: pulse 2s infinite; }
        .status-completed { background: #D1FAE5; color: #065F46; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="mb-5">
            <h4 class="fw-bold mb-0 text-white"><i class="fas fa-video me-2"></i>Virtual Dojo</h4>
            <p class="text-white-50 small">Online Class Management</p>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item mb-2"><a href="${pageContext.request.contextPath}/centres/dashboard" class="nav-link text-white opacity-75"><i class="fas fa-arrow-left me-2"></i> Back to Dashboard</a></li>
            <li class="nav-item mb-2"><a href="#" class="nav-link text-white fw-bold"><i class="fas fa-plus-circle me-2"></i> Create Live Class</a></li>
            <li class="nav-item mb-2"><a href="#" class="nav-link text-white opacity-75"><i class="fas fa-history me-2"></i> Past Sessions</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-extrabold m-0">Manage Your Online Dojo</h2>
            <button class="btn btn-premium" data-bs-toggle="modal" data-bs-target="#createClassModal"><i class="fas fa-plus me-2"></i> Create Live Class</button>
        </div>

        <div class="row g-4">
            <c:forEach var="oc" items="${classes}">
                <div class="col-md-6 col-lg-4">
                    <div class="class-card d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <span class="status-badge status-${oc.status.toString().toLowerCase()}">${oc.status}</span>
                            <div class="d-flex align-items-center">
                                <small class="text-muted fw-bold me-2">${oc.date}</small>
                                <button class="btn btn-sm btn-link text-danger p-0" onclick="deleteClass(${oc.id})" title="Delete Class">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                        <h5 class="fw-bold mb-1">${oc.title}</h5>
                        <p class="text-muted small mb-3">${oc.martialArtType} • ${oc.batch.name}</p>
                        
                        <div class="mb-4">
                            <div class="d-flex align-items-center mb-1 text-muted small"><i class="fas fa-clock me-2"></i> ${oc.startTime} - ${oc.endTime}</div>
                            <div class="d-flex align-items-center mb-1 text-muted small"><i class="fas fa-tag me-2"></i> ${oc.sessionType}</div>
                            <div class="d-flex align-items-center text-muted small"><i class="fas fa-users me-2"></i> Max Students: ${oc.maxStudents}</div>
                        </div>
                        
                        <c:if test="${not empty oc.notes}">
                            <div class="mb-3 p-2 bg-light rounded-3 small text-muted">
                                <i class="fas fa-sticky-note me-1"></i> ${oc.notes}
                            </div>
                        </c:if>

                        <div class="mt-auto d-grid gap-2">
                            
                            <c:if test="${oc.status == 'UPCOMING'}">
                                <button class="btn btn-primary rounded-pill" onclick="startClass(${oc.id})"><i class="fas fa-play me-2"></i> Start Class</button>
                            </c:if>
                            <c:if test="${oc.status == 'LIVE'}">
                                <button class="btn btn-danger rounded-pill" onclick="endClass(${oc.id})"><i class="fas fa-stop me-2"></i> End Session</button>
                                <button class="btn btn-warning rounded-pill" onclick="openControlPanel(${oc.id}, '${oc.title}')"><i class="fas fa-tools me-2"></i> Control Panel</button>
                                <a href="${oc.meetingLink}" target="_blank" class="btn btn-outline-primary rounded-pill"><i class="fas fa-external-link-alt me-2"></i> Join Meeting</a>
                            </c:if>
                            <c:if test="${oc.status == 'COMPLETED'}">
                                <button class="btn btn-outline-success rounded-pill" disabled><i class="fas fa-check-circle me-2"></i> Completed</button>
                                <button class="btn btn-sm btn-light" onclick="openRecordingModal(${oc.id}, '${oc.recordingLink}')"><i class="fas fa-cloud-upload-alt me-2"></i> ${empty oc.recordingLink ? 'Upload Recording' : 'Update Recording'}</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty classes}">
                <div class="col-12 text-center py-5 panel">
                    <i class="fas fa-video fa-3x text-muted mb-3"></i>
                    <h4>No Online Classes Scheduled</h4>
                    <p class="text-muted">Create your first live session to start training trainees remotely.</p>
                </div>
            </c:if>
        </div>
    </div>


    <!-- Create Class Modal -->
    <div class="modal fade" id="createClassModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius: 24px;">
                <div class="modal-header border-0 p-4">
                    <h4 class="modal-title fw-bold">Schedule Live Session</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="createClassForm" class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Class Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g. Morning Kickboxing Essentials" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Associated Batch</label>
                            <select name="batchId" class="form-select" required>
                                <c:forEach var="b" items="${batches}">
                                    <option value="${b.id}">${b.name} (${b.style})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Session Type</label>
                            <select name="sessionType" class="form-select" required>
                                <option value="Group Session">Group Session</option>
                                <option value="Personal 1-to-1 Session">Personal 1-to-1 Session</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Martial Art Type</label>
                            <input type="text" name="martialArtType" class="form-control" placeholder="e.g. Karate" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Date</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Start Time</label>
                            <input type="time" name="startTime" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">End Time</label>
                            <input type="time" name="endTime" class="form-control" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-bold">Jitsi/Meeting Link</label>
                            <input type="url" name="meetingLink" class="form-control" placeholder="https://meet.jit.si/..." required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Max Trainees</label>
                            <input type="number" name="maxStudents" class="form-control" value="20" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Session Notes (Equipment, Dress Code etc.)</label>
                            <textarea name="notes" class="form-control" rows="2" placeholder="e.g. Please bring your hand wraps and water bottle."></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0 p-4">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-premium px-5" onclick="submitCreateClass()">Schedule Class</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Control Panel Modal -->
    <div class="modal fade" id="controlPanelModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius: 24px;">
                <div class="modal-header border-0 p-4">
                    <h5 class="modal-title fw-bold">Live Session Control: <span id="ctrlSessionTitle"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-7">
                            <h6 class="fw-bold mb-3">Joined Trainees</h6>
                            <div id="joinedTraineeList" class="list-group list-group-flush border rounded-4 overflow-hidden" style="max-height: 400px; overflow-y: auto;">
                                <div class="text-center p-4">Loading trainees...</div>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <h6 class="fw-bold mb-3">Session Controls</h6>
                            <div class="d-grid gap-2">
                                <button class="btn btn-light rounded-pill text-start"><i class="fas fa-microphone-slash me-2"></i> Mute All Trainees</button>
                                <button class="btn btn-light rounded-pill text-start"><i class="fas fa-record-vinyl me-2"></i> Start Recording</button>
                                <button class="btn btn-light rounded-pill text-start"><i class="fas fa-desktop me-2"></i> Share Screen</button>
                                <hr>
                                <button class="btn btn-danger rounded-pill" id="ctrlEndBtn"><i class="fas fa-stop me-2"></i> End Session</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recording Modal -->
    <div class="modal fade" id="recordingModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content" style="border-radius: 24px;">
                <div class="modal-header border-0 p-4">
                    <h5 class="modal-title fw-bold">Upload Session Recording</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" id="recordingClassId">
                    <label class="form-label fw-bold">Recording URL (YouTube/Drive)</label>
                    <input type="url" id="recordingLink" class="form-control" placeholder="https://youtube.com/watch?v=...">
                </div>
                <div class="modal-footer border-0 p-4">
                    <button type="button" class="btn btn-premium w-100" onclick="submitRecording()">Save Recording</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        async function submitCreateClass() {
            const form = document.getElementById('createClassForm');
            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());

            try {
                const res = await fetch('${pageContext.request.contextPath}/online-class/create', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                if (res.ok) {
                    alert('Class scheduled successfully!');
                    location.reload();
                } else {
                    alert('Error creating class');
                }
            } catch (err) {
                console.error(err);
                alert('Network error');
            }
        }

        async function startClass(id) {
            if(!confirm('Start this class and go live?')) return;
            const res = await fetch(`${pageContext.request.contextPath}/online-class/start/\${id}`, { method: 'POST' });
            if(res.ok) {
                const data = await res.json();
                window.open(data.meetingLink, '_blank');
                location.reload();
            }
        }

        async function endClass(id) {
            if(!confirm('End this class? Attendance will be marked for participants.')) return;
            const res = await fetch(`${pageContext.request.contextPath}/online-class/end/\${id}`, { method: 'POST' });
            if(res.ok) {
                alert('Class ended and attendance finalized.');
                location.reload();
            }
        }

        function openRecordingModal(id, currentLink) {
            document.getElementById('recordingClassId').value = id;
            document.getElementById('recordingLink').value = currentLink || '';
            new bootstrap.Modal(document.getElementById('recordingModal')).show();
        }

        async function submitRecording() {
            const id = document.getElementById('recordingClassId').value;
            const link = document.getElementById('recordingLink').value;
            const res = await fetch(`${pageContext.request.contextPath}/online-class/upload-recording/\${id}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ recordingLink: link })
            });
            if(res.ok) {
                alert('Recording updated.');
                location.reload();
            }
        }

        let controlPollInterval;
        async function openControlPanel(classId, title) {
            document.getElementById('ctrlSessionTitle').innerText = title;
            document.getElementById('ctrlEndBtn').onclick = () => endClass(classId);
            const modal = new bootstrap.Modal(document.getElementById('controlPanelModal'));
            modal.show();

            fetchJoinedTrainees(classId);
            controlPollInterval = setInterval(() => fetchJoinedTrainees(classId), 5000);

            document.getElementById('controlPanelModal').addEventListener('hidden.bs.modal', () => {
                clearInterval(controlPollInterval);
            });
        }

        async function fetchJoinedTrainees(classId) {
            try {
                const res = await fetch(`${pageContext.request.contextPath}/online-class/\${classId}/joined-trainees`);
                const joined = await res.json();
                
                // Also fetch all invited/approved trainees to show who is NOT joined
                const resAll = await fetch(`${pageContext.request.contextPath}/online-class/\${classId}/session-trainees`);
                const all = await resAll.json();

                const listDiv = document.getElementById('joinedTraineeList');
                if (all.length === 0) {
                    listDiv.innerHTML = '<div class="p-4 text-center text-muted">No trainees invited to this session.</div>';
                    return;
                }

                const joinedIds = new Set(joined.map(j => j.traineeId));

                listDiv.innerHTML = all.map(t => {
                    const isJoined = joinedIds.has(t.traineeId || t.id);
                    return `
                        <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div class="d-flex align-items-center">
                                <div class="position-relative me-3">
                                    <img src="\${t.profilePhoto || '${pageContext.request.contextPath}/assets/img/default-user.png'}" class="rounded-circle" width="40" height="40" style="object-fit: cover;">
                                    <span class="position-absolute bottom-0 end-0 p-1 \${isJoined ? 'bg-success' : 'bg-danger'} border border-light rounded-circle"></span>
                                </div>
                                <div>
                                    <div class="fw-bold small">\${t.fullName}</div>
                                    <div class="text-muted" style="font-size: 0.7rem;">\${isJoined ? 'Online' : 'Not Joined'}</div>
                                </div>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-light rounded-circle" data-bs-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item small" href="#"><i class="fas fa-microphone-slash me-2"></i> Mute</a></li>
                                    <li><a class="dropdown-item small text-danger" href="#"><i class="fas fa-user-times me-2"></i> Remove</a></li>
                                </ul>
                            </div>
                        </div>
                    `;
                }).join('');

            } catch (err) {
                console.error(err);
            }
        }
        async function deleteClass(id) {
            if(!confirm('Are you sure you want to delete this class? This action cannot be undone.')) return;
            try {
                const res = await fetch(`${pageContext.request.contextPath}/online-class/delete/\${id}`, {
                    method: 'DELETE'
                });
                if(res.ok) {
                    alert('Class deleted successfully.');
                    location.reload();
                } else {
                    const data = await res.json();
                    alert(data.message || 'Error deleting class.');
                }
            } catch (err) {
                alert('Network error.');
            }
        }
    </script>
</body>
</html>
