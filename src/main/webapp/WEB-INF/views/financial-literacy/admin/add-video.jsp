<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Video - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
</head>
<body>
    <c:set var="flAdminTitle" value="Add Video" scope="request"/>
    <c:set var="flAdminActive" value="add-video" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">

        <%@ include file="_sidebar.jsp" %>

        <!-- Sidebar -->
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>


        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <h3>Add New Video</h3>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-video" method="POST" id="videoForm" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <div class="mb-3 position-relative">
                            <label for="title" class="form-label">Video Title</label>
                            <input type="text" class="form-control" id="title" name="title" required minlength="5" placeholder="Enter video title">
                            <div class="invalid-feedback">Please provide a valid title (min 5 characters).</div>
                        </div>
                        
                        <div class="mb-3 position-relative">
                            <label for="category" class="form-label">Category</label>

                            <select class="form-select" id="category" name="category" required>
                                <option value="" disabled selected>Select a category</option>
                                <option value="saving">Saving</option>
                                <option value="investing">Investing</option>
                                <option value="loans">Loans</option>
                                <option value="banking">Banking</option>
                                <option value="insurance">Insurance</option>
                                <option value="government">Government Schemes</option>
                            </select>
                            <div class="invalid-feedback">Please select a category.</div>
                        </div>



                        <div class="mb-3 position-relative">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required minlength="10" maxlength="5000" placeholder="Brief description of the video..."></textarea>
                            <div class="invalid-feedback">Please provide a description (between 10 and 5000 characters).</div>
                        </div>
                        
                        <div class="mb-4 position-relative">
                            <label class="form-label d-block">Video Source (Optional: Provide URL OR Upload File)</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="videoUrl" class="form-label" style="font-size: 0.85rem; color: #666;">YouTube / External URL</label>
                                    <input type="url" class="form-control" id="videoUrl" name="videoUrl" placeholder="https://youtube.com/watch?v=..." pattern="https?://.+">
                                </div>
                                <div class="col-md-6">
                                    <label for="videoFile" class="form-label" style="font-size: 0.85rem; color: #666;">Upload Video File</label>
                                    <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/*">
                                </div>
                            </div>
                            <div id="sourceError" class="invalid-feedback" style="display: none;">Please provide either a video URL or upload a video file.</div>
                        </div>
                        
                        <button type="submit" class="btn-purple" id="submitBtn">
                            <i class="fas fa-upload me-2"></i> Publish Video

                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>

        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('videoForm');
            const submitBtn = document.getElementById('submitBtn');
            const inputs = form.querySelectorAll('input, select, textarea');

            const urlInput = document.getElementById('videoUrl');
            const fileInput = document.getElementById('videoFile');
            const sourceError = document.getElementById('sourceError');

            function validateSource() {
                // Made optional as requested by user
                sourceError.style.display = 'none';
                urlInput.classList.remove('is-invalid');
                fileInput.classList.remove('is-invalid');
                return true;
            }

            // Real-time validation on input/change
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    if (this !== urlInput && this !== fileInput) validateField(this);
                    checkFormValidity();
                });
                
                input.addEventListener('change', function() {
                    if (this !== urlInput && this !== fileInput) {
                        validateField(this);
                    } else {
                        validateSource();
                    }
                    checkFormValidity();
                });
                
                input.addEventListener('blur', function() {
                    if (this !== urlInput && this !== fileInput) validateField(this);
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
                const isFormValid = form.checkValidity();
                const isSourceValid = validateSource();
                
                if (isFormValid && isSourceValid) {
                    submitBtn.classList.remove('disabled');
                    submitBtn.removeAttribute('disabled');
                } else {
                    submitBtn.classList.add('disabled');
                    submitBtn.setAttribute('disabled', 'true');
                }
            }

            // Form submission validation
            form.addEventListener('submit', function (event) {
                const isFormValid = form.checkValidity();
                const isSourceValid = validateSource();
                
                if (!isFormValid || !isSourceValid) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    // Mark all fields to show invalid state
                    inputs.forEach(input => {
                        if (input !== urlInput && input !== fileInput) validateField(input);
                    });
                    
                    // Focus on the first invalid field
                    const firstInvalid = form.querySelector('.is-invalid, :invalid');
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
