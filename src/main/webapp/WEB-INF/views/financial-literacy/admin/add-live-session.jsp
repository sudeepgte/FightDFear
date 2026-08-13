<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Live Session - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
</head>
<body>
    <c:set var="flAdminTitle" value="Add Live Session" scope="request"/>
    <c:set var="flAdminActive" value="add-live-session" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">

        <%@ include file="_sidebar.jsp" %>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="navlink">
                    <i class="fas fa-home"></i> Home
                </a>
            </div>
            

            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Live Sessions</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="navlink active">
                <i class="fas fa-video"></i> Add Session
            </a>
            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Workshops</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="navlink">
                <i class="fas fa-calendar-check"></i> Add Workshop
            </a>
        </div>


        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <h3>Add New Live Session</h3>
                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" method="POST" id="liveSessionForm" class="needs-validation" novalidate>
                        <div class="mb-3 position-relative">
                            <label for="title" class="form-label">Session Title</label>
                            <input type="text" class="form-control" id="title" name="title" required minlength="5" placeholder="Enter session title">
                            <div class="invalid-feedback">Please provide a valid title (min 5 characters).</div>
                        </div>

                        <div class="mb-3">

                        
                        <div class="mb-3 position-relative">

                            <label for="speaker" class="form-label">Speaker Name</label>
                            <input type="text" class="form-control" id="speaker" name="speaker" required minlength="3" placeholder="Enter speaker name">
                            <div class="invalid-feedback">Please provide the speaker's name (min 3 characters).</div>
                        </div>

                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="text" class="form-control" id="date" name="date" placeholder="Saturday, 15th July" required>
                        </div>
                        <div class="mb-3">
                            <label for="time" class="form-label">Time</label>
                            <input type="text" class="form-control" id="time" name="time" placeholder="6:00 PM" required>
                        </div>
                        <div class="mb-3">

                        
                        <div class="row">
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="date" class="form-label">Date</label>
                                <input type="date" class="form-control" id="date" name="date" required>
                                <div class="invalid-feedback">Please select a valid future date.</div>
                            </div>
                            
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="time" class="form-label">Time</label>
                                <input type="time" class="form-control" id="time" name="time" required>
                                <div class="invalid-feedback">Please select a valid time.</div>
                            </div>
                        </div>
                        
                        <div class="mb-3 position-relative">

                            <label for="meetingUrl" class="form-label">Meeting Link</label>
                            <input type="url" class="form-control" id="meetingUrl" name="meetingUrl" placeholder="https://zoom.us/j/..." required pattern="https?://.+">
                            <div class="invalid-feedback">Please enter a valid URL (e.g., https://zoom.us/...).</div>
                        </div>

                        <div class="mb-3">

                        
                        <div class="mb-3 position-relative">

                            <label for="seats" class="form-label">Number of Seats</label>
                            <input type="number" class="form-control" id="seats" name="seats" min="1" max="1000" required placeholder="100">
                            <div class="invalid-feedback">Please enter a valid number of seats (1-1000).</div>
                        </div>

                        <div class="mb-4">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required maxlength="1000"></textarea>
                        </div>
                        <button type="submit" class="btn-purple full">
                            <i class="fas fa-upload me-2"></i> Publish

                        
                        <div class="mb-4 position-relative">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required minlength="20" placeholder="Provide a brief description..."></textarea>
                            <div class="invalid-feedback">Please provide a description (min 20 characters).</div>
                        </div>
                        
                        <button type="submit" class="btn-purple" id="submitBtn">
                            <i class="fas fa-upload me-2"></i> Publish Session

                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>



    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('liveSessionForm');
            const submitBtn = document.getElementById('submitBtn');
            const inputs = form.querySelectorAll('input, textarea');

            // Set min date to today for date input
            const dateInput = document.getElementById('date');
            if(dateInput) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.setAttribute('min', today);
            }

            // Real-time validation on input/change
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    validateField(this);
                    checkFormValidity();
                });
                
                input.addEventListener('blur', function() {
                    validateField(this);
                });
            });

            function validateField(field) {
                if (field.checkValidity()) {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                } else {
                    field.classList.remove('is-valid');
                    field.classList.add('is-invalid');
                }
            }

            function checkFormValidity() {
                if (form.checkValidity()) {
                    submitBtn.classList.remove('disabled');
                    submitBtn.removeAttribute('disabled');
                } else {
                    submitBtn.classList.add('disabled');
                    submitBtn.setAttribute('disabled', 'true');
                }
            }

            // Form submission validation
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    // Mark all fields to show invalid state
                    inputs.forEach(input => {
                        validateField(input);
                    });
                    
                    // Focus on the first invalid field
                    const firstInvalid = form.querySelector(':invalid');
                    if(firstInvalid) firstInvalid.focus();
                } else {
                    // Show loading state
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Publishing...';
                    // We don't disable it here because some browsers cancel form submission if submit button is disabled
                    submitBtn.style.pointerEvents = 'none';
                    submitBtn.style.opacity = '0.8';
                }
                
                form.classList.add('was-validated');
            }, false);
            
            // Initial check to disable button
            checkFormValidity();
        });
    </script>

</body>
</html>
