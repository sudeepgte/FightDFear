<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trusted Contacts | Women Safety</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
    /* ============================================
       ROOT VARIABLES (your brand colors)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --gradient-secondary: linear-gradient(135deg, #312e81, #bf5af2);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
        
        /* Map brand colors to component accents */
        --accent-blue: var(--primary-purple-light);
        --accent-green: var(--primary-teal);
        --accent-orange: var(--primary-gold);
        --accent-red: var(--primary-coral);
        --accent-purple: var(--primary-purple-light);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Inter', -apple-system, sans-serif;
        background: #150510;
        color: #f0f0f5;
        min-height: 100vh;
    }

    .bg-gradient {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background-image:
            radial-gradient(circle at 20% 50%, rgba(124, 45, 94, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(219, 39, 119, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 50% 80%, rgba(30, 27, 75, 0.1) 0%, transparent 50%);
        background-size: cover;
        z-index: 0;
    }

    .container {
        position: relative;
        z-index: 1;
        max-width: 900px;
        margin: 0 auto;
        padding: 80px 20px 40px;
    }

    .top-nav {
        position: fixed;
        top: 0; left: 0; right: 0;
        padding: 16px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: linear-gradient(to right, var(--primary-purple), #4a0e2a);
        backdrop-filter: blur(20px);
        border-bottom: 2px solid var(--primary-coral);
        z-index: 100;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    }

    .top-nav .brand {
        font-weight: 700;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .top-nav .brand i { color: var(--accent-blue); }

    .top-nav .back-btn {
        color: #8a8a9a;
        text-decoration: none;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: color 0.2s;
    }

    .top-nav .back-btn:hover { color: #f0f0f5; }

    .page-header {
        margin-bottom: 30px;
    }

    .page-header h1 {
        font-size: 32px;
        font-weight: 800;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 12px;
        color: #f0f0f5;
    }

    .page-header h1 i { color: var(--accent-blue); }

    .page-header p {
        color: #8a8a9a;
        font-size: 14px;
    }

    .add-contact-btn {
        background: var(--gradient-primary);
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 30px;
        transition: transform 0.2s, box-shadow 0.2s;
        box-shadow: var(--shadow-sm);
    }

    .add-contact-btn:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .contacts-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .contact-card {
        background: rgba(255,255,255,0.04);
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 16px;
        padding: 20px;
        backdrop-filter: blur(20px);
        transition: all 0.3s ease;
    }

    .contact-card:hover {
        border-color: rgba(123, 44, 191, 0.3);
        transform: translateY(-2px);
    }

    .contact-card.primary {
        border-color: rgba(32, 201, 151, 0.3);
        background: rgba(32, 201, 151, 0.05);
    }

    .contact-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 15px;
    }

    .contact-info {
        display: flex;
        align-items: center;
        gap: 15px;
        flex: 1;
    }

    .contact-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: var(--gradient-secondary);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 20px;
        flex-shrink: 0;
    }

    .contact-card.primary .contact-avatar {
        background: linear-gradient(135deg, var(--primary-teal), #00c853);
    }

    .contact-details h3 {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 4px;
        display: flex;
        align-items: center;
        gap: 8px;
        color: #f0f0f5;
    }

    .primary-badge {
        background: var(--primary-teal);
        color: white;
        padding: 2px 8px;
        border-radius: 10px;
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .contact-details p {
        color: #8a8a9a;
        font-size: 13px;
        margin-bottom: 2px;
    }

    .contact-details p i {
        width: 16px;
        margin-right: 4px;
    }

    .contact-actions {
        display: flex;
        gap: 8px;
    }

    .action-btn {
        background: rgba(255,255,255,0.06);
        border: 1px solid rgba(255,255,255,0.08);
        color: #8a8a9a;
        padding: 8px 12px;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        font-size: 12px;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    .action-btn:hover {
        background: rgba(255,255,255,0.1);
        color: #f0f0f5;
    }

    .action-btn.delete:hover {
        background: rgba(255, 107, 107, 0.15);
        border-color: rgba(255, 107, 107, 0.3);
        color: var(--primary-coral);
    }

    .notification-preferences {
        display: flex;
        gap: 15px;
        margin-top: 12px;
        padding-top: 12px;
        border-top: 1px solid rgba(255,255,255,0.08);
    }

    .pref-item {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 12px;
        color: #8a8a9a;
    }

    .pref-item i {
        font-size: 14px;
    }

    .pref-item.enabled i { color: var(--primary-teal); }
    .pref-item.disabled i { color: #8a8a9a; opacity: 0.3; }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #8a8a9a;
    }

    .empty-state i {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.3;
    }

    .empty-state h3 {
        font-size: 20px;
        margin-bottom: 8px;
        color: #f0f0f5;
    }

    /* Modal Styles */
    .modal-overlay {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(0, 0, 0, 0.8);
        backdrop-filter: blur(10px);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 200;
    }

    .modal-overlay.active { display: flex; }

    .modal {
        background: #12121a;
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 20px;
        padding: 30px;
        max-width: 500px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
    }

    .modal h2 {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #f0f0f5;
    }

    .modal h2 i { color: var(--accent-blue); }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #8a8a9a;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 12px;
        background: rgba(255,255,255,0.06);
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 10px;
        color: #f0f0f5;
        font-size: 14px;
        font-family: inherit;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: var(--accent-blue);
    }

    .checkbox-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .checkbox-item {
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
    }

    .checkbox-item input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
    }

    .modal-actions {
        display: flex;
        gap: 10px;
        margin-top: 25px;
    }

    .btn {
        flex: 1;
        padding: 12px;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        border: none;
        transition: all 0.2s;
    }

    .btn-primary {
        background: var(--gradient-primary);
        color: white;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .btn-secondary {
        background: rgba(255,255,255,0.06);
        border: 1px solid rgba(255,255,255,0.08);
        color: #8a8a9a;
    }

    .btn-secondary:hover {
        background: rgba(255,255,255,0.1);
        color: #f0f0f5;
    }

    .toast {
        position: fixed;
        top: 80px;
        left: 50%;
        transform: translateX(-50%);
        padding: 12px 24px;
        background: rgba(32, 201, 151, 0.15);
        border: 1px solid rgba(32, 201, 151, 0.3);
        border-radius: 12px;
        color: var(--primary-teal);
        font-size: 13px;
        font-weight: 500;
        z-index: 300;
        display: none;
        backdrop-filter: blur(20px);
    }

    .toast.error {
        background: rgba(255, 107, 107, 0.15);
        border-color: rgba(255, 107, 107, 0.3);
        color: var(--primary-coral);
    }

    .toast.show {
        display: block;
        animation: slideDown 0.3s ease, fadeOut 0.3s ease 2.5s forwards;
    }

    @keyframes slideDown {
        from { opacity: 0; transform: translateX(-50%) translateY(-20px); }
        to { opacity: 1; transform: translateX(-50%) translateY(0); }
    }

    @keyframes fadeOut {
        to { opacity: 0; }
    }

    @media (max-width: 768px) {
        .container { padding: 70px 15px 30px; }
        .page-header h1 { font-size: 24px; }
        .contact-header { flex-direction: column; gap: 15px; }
        .contact-actions { align-self: flex-end; }
    }

    /* Additional enhancements (no backend changes) */
    ::-webkit-scrollbar {
        width: 6px;
    }
    ::-webkit-scrollbar-track {
        background: #0a0a0f;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-gold);
    }

    .btn-primary, .add-contact-btn, .action-btn, .back-btn {
        transition: all 0.2s ease;
    }
    .btn-primary:active, .add-contact-btn:active {
        transform: translateY(1px);
    }
    .btn-primary:focus-visible, .add-contact-btn:focus-visible,
    .action-btn:focus-visible, .back-btn:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
    }
</style>
</head>
<body>
    <div class="bg-gradient"></div>

    <!-- Top Navigation -->
    <nav class="top-nav">
        <div class="brand">
            <i class="bi bi-people-fill"></i> Trusted Contacts
        </div>
        <a href="${pageContext.request.contextPath}/users/dashboard" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </nav>

    <!-- Toast Notification -->
    <div class="toast" id="toast"></div>

    <!-- Main Container -->
    <div class="container">
        <div class="page-header">
            <h1><i class="bi bi-shield-check"></i> My Trusted Contacts</h1>
            <p>Manage your emergency contacts who will be notified when you trigger SOS</p>
        </div>

        <button class="add-contact-btn" onclick="openModal()">
            <i class="bi bi-plus-circle"></i> Add New Contact
        </button>

        <!-- Contacts List -->
        <div class="contacts-list" id="contactsList">
            <c:choose>
                <c:when test="${not empty contacts}">
                    <c:forEach var="contact" items="${contacts}">
                        <div class="contact-card ${contact.primary ? 'primary' : ''}">
                            <div class="contact-header">
                                <div class="contact-info">
                                    <div class="contact-avatar">${contact.name.substring(0, 1)}</div>
                                    <div class="contact-details">
                                        <h3>
                                            ${contact.name}
                                            <c:if test="${contact.primary}">
                                                <span class="primary-badge">Primary</span>
                                            </c:if>
                                        </h3>
                                        <p><i class="bi bi-telephone"></i> ${contact.phone}</p>
                                        <c:if test="${not empty contact.email}">
                                            <p><i class="bi bi-envelope"></i> ${contact.email}</p>
                                        </c:if>
                                        <c:if test="${not empty contact.relation}">
                                            <p><i class="bi bi-person-badge"></i> ${contact.relation}</p>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="contact-actions">
                                    <button class="action-btn" onclick="editContact(${contact.id})">
                                        <i class="bi bi-pencil"></i> Edit
                                    </button>
                                    <button class="action-btn delete" onclick="deleteContact(${contact.id})">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                            <div class="notification-preferences">
                                <div class="pref-item ${contact.canReceiveSMS ? 'enabled' : 'disabled'}">
                                    <i class="bi bi-chat-dots"></i> SMS
                                </div>
                                <div class="pref-item ${contact.canReceiveEmail ? 'enabled' : 'disabled'}">
                                    <i class="bi bi-envelope"></i> Email
                                </div>
                                <div class="pref-item ${contact.canReceiveCall ? 'enabled' : 'disabled'}">
                                    <i class="bi bi-telephone"></i> Call
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-person-x"></i>
                        <h3>No Trusted Contacts Yet</h3>
                        <p>Add contacts who will be notified when you trigger SOS</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Add/Edit Contact Modal -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal">
            <h2><i class="bi bi-person-plus"></i> <span id="modalTitle">Add New Contact</span></h2>
            <form id="contactForm" action="${pageContext.request.contextPath}/users/${userId}/trusted-contacts" method="post">
                <input type="hidden" id="contactId" name="contactId" value="">
                
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" required placeholder="e.g., Mom">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" required placeholder="e.g., +919876543210">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="e.g., mom@example.com">
                </div>

                <div class="form-group">
                    <label for="relation">Relation *</label>
                    <select id="relation" name="relation" required>
                        <option value="">Select relation</option>
                        <option value="Mother">Mother</option>
                        <option value="Father">Father</option>
                        <option value="Sister">Sister</option>
                        <option value="Brother">Brother</option>
                        <option value="Friend">Friend</option>
                        <option value="Spouse">Spouse</option>
                        <option value="Colleague">Colleague</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="checkbox-item">
                        <input type="checkbox" id="isPrimary" name="isPrimary" value="true">
                        <span>Set as Primary Contact (will be auto-called first)</span>
                    </label>
                </div>

                <div class="form-group">
                    <label>Notification Preferences</label>
                    <div class="checkbox-group">
                        <label class="checkbox-item">
                            <input type="checkbox" id="canReceiveSMS" name="canReceiveSMS" value="true" checked>
                            <span><i class="bi bi-chat-dots"></i> Send SMS notifications</span>
                        </label>
                        <label class="checkbox-item">
                            <input type="checkbox" id="canReceiveEmail" name="canReceiveEmail" value="true" checked>
                            <span><i class="bi bi-envelope"></i> Send Email notifications</span>
                        </label>
                        <label class="checkbox-item">
                            <input type="checkbox" id="canReceiveCall" name="canReceiveCall" value="true" checked>
                            <span><i class="bi bi-telephone"></i> Allow auto-calls</span>
                        </label>
                    </div>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Contact</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function openModal(contactId = null) {
            document.getElementById('modalOverlay').classList.add('active');
            document.getElementById('contactForm').reset();
            document.getElementById('contactId').value = '';

            if (contactId) {
                // Edit mode - fetch contact data
                document.getElementById('modalTitle').textContent = 'Edit Contact';
                // You can add AJAX call to fetch contact details here
            } else {
                document.getElementById('modalTitle').textContent = 'Add New Contact';
            }
        }

        function closeModal() {
            document.getElementById('modalOverlay').classList.remove('active');
        }

        function editContact(contactId) {
            openModal(contactId);
            // Add logic to populate form with contact data
        }

        function deleteContact(contactId) {
            if (confirm('Are you sure you want to delete this contact?')) {
                fetch(contextPath + '/users/trusted-contacts/' + contactId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        showToast('Contact deleted successfully');
                        setTimeout(() => location.reload(), 500);
                    } else {
                        showToast('Failed to delete contact', true);
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    showToast('Failed to delete contact', true);
                });
            }
        }

        function showToast(message, isError = false) {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast show' + (isError ? ' error' : '');
            setTimeout(() => { toast.classList.remove('show'); }, 3000);
        }

        // Close modal when clicking outside
        document.getElementById('modalOverlay').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        // Form submission
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            fetch(this.action, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    showToast('Contact saved successfully');
                    closeModal();
                    setTimeout(() => location.reload(), 500);
                } else {
                    showToast('Failed to save contact', true);
                }
            })
            .catch(err => {
                console.error('Error:', err);
                showToast('Failed to save contact', true);
            });
        });
    </script>
</body>
</html>

