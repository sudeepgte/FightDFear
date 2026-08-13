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
        <div class="sidebar">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="navlink">
                    <i class="fas fa-home"></i> Home
                </a>
            </div>
            

            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Live Sessions</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="navlink">
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
                    <h3>Add New Video</h3>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form id="addVideoForm" action="${pageContext.request.contextPath}/financial-literacy/admin/add-video" method="POST" novalidate>
                        <div class="mb-3">
                            <label for="title" class="form-label">Video Title *</label>
                            <input type="text" class="form-control" id="title" name="title" required maxlength="150">
                        </div>

                        <div class="mb-3">
                            <label for="category" class="form-label">Category *</label>

                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-video" method="POST" id="videoForm" class="needs-validation" novalidate>
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


                        <div class="mb-3">
                            <label for="description" class="form-label">Description *</label>
                            <textarea class="form-control" id="description" name="description" rows="4"
                                      required maxlength="1000"
                                      placeholder="Enter a clear video description (max 1000 characters)"></textarea>
                            <div id="descCounter" class="char-counter">0 / 1000</div>
                        </div>

                        <div class="mb-4">
                            <label for="videoUrl" class="form-label">Video File / YouTube URL</label>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl" placeholder="https://youtube.com/watch?v=..." maxlength="500">
                        </div>

                        <button type="submit" class="btn-purple full">
                            <i class="fas fa-upload me-2"></i> Publish

                        
                        <div class="mb-3 position-relative">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required minlength="10" placeholder="Brief description of the video..."></textarea>
                            <div class="invalid-feedback">Please provide a description (min 10 characters).</div>
                        </div>
                        
                        <div class="mb-4 position-relative">
                            <label for="videoUrl" class="form-label">Video File / YouTube URL</label>
                            <input type="url" class="form-control" id="videoUrl" name="videoUrl" required placeholder="https://youtube.com/watch?v=..." pattern="https?://.+">
                            <div class="invalid-feedback">Please provide a valid URL starting with http:// or https://.</div>
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

      (function () {
        var MAX = 1000;
        var desc = document.getElementById('description');
        var counter = document.getElementById('descCounter');
        var form = document.getElementById('addVideoForm');

        function updateCounter() {
          var len = (desc.value || '').length;
          counter.textContent = len + ' / ' + MAX;
          counter.classList.toggle('warn', len >= MAX * 0.9 && len <= MAX);
          counter.classList.toggle('over', len > MAX);
        }

        if (desc) {
          desc.addEventListener('input', function () {
            if (desc.value.length > MAX) {
              desc.value = desc.value.substring(0, MAX);
            }
            updateCounter();
          });
          updateCounter();
        }

        if (form) {
          form.addEventListener('submit', function (e) {
            var text = (desc.value || '').trim();
            if (!text) {
              alert('Description is required.');
              e.preventDefault();
              return;
            }
            if (text.length > MAX) {
              alert('Description must be at most ' + MAX + ' characters.');
              e.preventDefault();
            }
          });
        }
      })();

        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('videoForm');
            const submitBtn = document.getElementById('submitBtn');
            const inputs = form.querySelectorAll('input, select, textarea');

            // Real-time validation on input/change
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    validateField(this);
                    checkFormValidity();
                });
                
                input.addEventListener('change', function() {
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
