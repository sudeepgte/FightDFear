<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Workshop - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
</head>
<body>
    <c:set var="flAdminTitle" value="Add Workshop" scope="request"/>
    <c:set var="flAdminActive" value="add-workshop" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">

        <!-- Sidebar -->
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>


        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <h3>Add New Workshop</h3>
                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" method="POST" id="workshopForm" class="needs-validation" novalidate>
                        <div class="mb-3 position-relative">
                            <label for="title" class="form-label">Workshop Title</label>
                            <input type="text" class="form-control" id="title" name="title" required minlength="5" placeholder="Enter workshop title">
                            <div class="invalid-feedback">Please provide a valid title (min 5 characters).</div>
                        </div>

                        <div class="mb-3">
                            <label for="venue" class="form-label">Venue</label>
                            <input type="text" class="form-control" id="venue" name="venue" required>
                        </div>
                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="text" class="form-control" id="date" name="date" placeholder="20th July" required>
                        </div>
                        <div class="mb-3">
                            <label for="time" class="form-label">Time</label>
                            <input type="text" class="form-control" id="time" name="time" placeholder="10:00 AM - 4:00 PM" required>
                        </div>
                        <div class="mb-3">
                            <label for="city" class="form-label">City</label>
                            <input type="text" class="form-control" id="city" name="city" required>
                        </div>
                        <div class="mb-3">

                        
                        <div class="row">
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="venue" class="form-label">Venue</label>
                                <input type="text" class="form-control" id="venue" name="venue" required minlength="3" placeholder="E.g. Town Hall">
                                <div class="invalid-feedback">Please provide the venue (min 3 characters).</div>
                            </div>
                            
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="city" class="form-label">City</label>
                                <input type="text" class="form-control" id="city" name="city" required minlength="2" placeholder="E.g. Mumbai">
                                <div class="invalid-feedback">Please provide the city name.</div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4 mb-3 position-relative">
                                <label for="date" class="form-label">Date</label>
                                <input type="date" class="form-control" id="date" name="date" required>
                                <div class="invalid-feedback">Please select a valid future date.</div>
                            </div>
                            
                            <div class="col-md-4 mb-3 position-relative">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                                <div class="invalid-feedback">Please provide the start time.</div>
                            </div>

                            <div class="col-md-4 mb-3 position-relative">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                                <div class="invalid-feedback">Please provide the end time.</div>
                            </div>
                        </div>
                        
                        <div class="mb-3 position-relative">

                            <label for="seats" class="form-label">Number of Seats</label>
                            <input type="number" class="form-control" id="seats" name="seats" min="1" max="5000" required placeholder="E.g. 50">
                            <div class="invalid-feedback">Please enter a valid number of seats (1-5000).</div>
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
                            <i class="fas fa-upload me-2"></i> Publish Workshop

                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>



    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('workshopForm');
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
