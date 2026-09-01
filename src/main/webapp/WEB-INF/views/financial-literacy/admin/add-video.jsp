<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Recorded Video - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
    <style>
        :root {
            --fl-heading: #0B1736;
            --fl-text: #17233D;
            --fl-muted: #5B6B86;
            --fl-accent: #FF3B5C;
            --fl-accent-hover: #D92B4B;
            --fl-purple: #312E81;
            --fl-bg-light: #FFF1F3;
            --fl-border: #D9E0EA;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: #F4F6FA;
            color: var(--fl-text);
        }

        .topbar {
            background: #0B1736;
            color: white;
            padding: 14px 18px;
            font-weight: 600;
        }

        .layout {
            display: flex;
            min-height: calc(100vh - 56px);
        }

        .main {
            flex: 1;
            padding: 24px 20px 40px;
            min-width: 0;
        }

        .mainInner.narrow {
            max-width: 800px;
            margin: 0 auto;
        }

        .admin-card {
            background: white;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 10px 30px rgba(11, 23, 54, 0.06);
            border: 1px solid var(--fl-border);
        }

        .admin-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--fl-heading);
        }

        .form-label {
            color: var(--fl-heading) !important;
            font-weight: 600;
        }

        .form-label .text-danger {
            color: var(--fl-accent) !important;
        }

        .form-control, .form-select {
            color: var(--fl-text) !important;
            border: 1px solid var(--fl-border) !important;
            background-color: #FFFFFF !important;
            border-radius: 10px;
            padding: 10px 14px;
        }

        .form-control::placeholder {
            color: var(--fl-muted) !important;
            opacity: 0.85;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--fl-accent) !important;
            box-shadow: 0 0 0 3px rgba(255, 59, 92, 0.15) !important;
            color: var(--fl-text) !important;
        }

        .btn-outline-secondary {
            color: var(--fl-text) !important;
            border-color: var(--fl-border) !important;
            background-color: #FFFFFF !important;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-outline-secondary:hover {
            color: #FFFFFF !important;
            background-color: var(--fl-accent) !important;
            border-color: var(--fl-accent) !important;
        }

        .btn-purple, .btn-primary {
            background-color: var(--fl-accent) !important;
            color: #FFFFFF !important;
            border: none !important;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-purple:hover, .btn-primary:hover {
            background-color: var(--fl-accent-hover) !important;
            color: #FFFFFF !important;
        }

        .btn-light {
            color: var(--fl-text) !important;
            background-color: #F1F5F9 !important;
            border: 1px solid var(--fl-border) !important;
            font-weight: 600;
        }

        .btn-light:hover {
            background-color: #E2E8F0 !important;
            color: var(--fl-heading) !important;
        }

        .text-primary {
            color: var(--fl-accent) !important;
        }

        .text-muted {
            color: var(--fl-muted) !important;
        }
    </style>
</head>
<body>
    <c:set var="flAdminTitle" value="Add Recorded Video" scope="request"/>
    <c:set var="flAdminActive" value="add-video" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h3 class="mb-0">Add Recorded Video</h3>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Back
                        </a>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-video" method="POST" id="videoForm" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <!-- 1. Video Title -->
                        <div class="mb-3 position-relative">
                            <label for="title" class="form-label fw-bold">Video Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required value="${title}" placeholder="Enter video title">
                            <div class="invalid-feedback">Video Title cannot be empty.</div>
                        </div>
                        
                        <!-- 2. Description -->
                        <div class="mb-3 position-relative">
                            <label for="description" class="form-label fw-bold">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="description" name="description" rows="4" required placeholder="Enter description of the video">${description}</textarea>
                            <div class="invalid-feedback">Description cannot be empty.</div>
                        </div>

                        <!-- 3. Category Dropdown -->
                        <div class="mb-3 position-relative">
                            <label for="category" class="form-label fw-bold">Category <span class="text-danger">*</span></label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="" disabled <c:if test="${empty category}">selected</c:if>>Select Category</option>
                                <option value="Saving" <c:if test="${category eq 'Saving'}">selected</c:if>>Saving</option>
                                <option value="Investing" <c:if test="${category eq 'Investing'}">selected</c:if>>Investing</option>
                                <option value="Loans" <c:if test="${category eq 'Loans'}">selected</c:if>>Loans</option>
                                <option value="Banking" <c:if test="${category eq 'Banking'}">selected</c:if>>Banking</option>
                                <option value="Insurance" <c:if test="${category eq 'Insurance'}">selected</c:if>>Insurance</option>
                                <option value="Government Schemes" <c:if test="${category eq 'Government Schemes'}">selected</c:if>>Government Schemes</option>
                                <option value="Others" <c:if test="${category eq 'Others'}">selected</c:if>>Others</option>
                            </select>
                            <div class="invalid-feedback">Category cannot be empty.</div>
                        </div>

                        <!-- Custom Category Input (shown when Others is selected) -->
                        <div class="mb-3 position-relative" id="customCategoryGroup" style="display: <c:choose><c:when test="${category eq 'Others'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                            <label for="customCategory" class="form-label fw-bold">Enter Category <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm" id="customCategory" name="customCategory" value="${customCategory}" placeholder="Enter Category">
                            <div class="invalid-feedback" id="customCategoryError">Custom category cannot be empty when 'Others' is selected.</div>
                        </div>

                        <!-- 4. Video URL / Upload Video -->
                        <div class="mb-4 position-relative">
                            <label class="form-label fw-bold d-block">Video URL / Upload Video <span class="text-danger">*</span></label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="videoUrl" class="form-label text-muted small">Video URL (YouTube / Hosted URL)</label>
                                    <input type="url" class="form-control" id="videoUrl" name="videoUrl" value="${videoUrl}" placeholder="https://www.youtube.com/watch?v=...">
                                </div>
                                <div class="col-md-6">
                                    <label for="videoFile" class="form-label text-muted small">Upload Video File <span class="text-primary">(Supports large files up to 1GB+)</span></label>
                                    <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/*">
                                </div>
                            </div>
                            <div id="sourceError" class="text-danger small mt-1" style="display: none;">Video URL / uploaded video cannot be empty.</div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="btn btn-light">Cancel</a>
                            <button type="submit" class="btn-purple" id="submitBtn">
                                <i class="fas fa-save me-2"></i> Save Video
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('videoForm');
            const categorySelect = document.getElementById('category');
            const customCategoryGroup = document.getElementById('customCategoryGroup');
            const customCategoryInput = document.getElementById('customCategory');
            const videoUrlInput = document.getElementById('videoUrl');
            const videoFileInput = document.getElementById('videoFile');
            const sourceError = document.getElementById('sourceError');
            const submitBtn = document.getElementById('submitBtn');

            function toggleCustomCategory() {
                if (categorySelect.value === 'Others') {
                    customCategoryGroup.style.display = 'block';
                    customCategoryInput.setAttribute('required', 'true');
                } else {
                    customCategoryGroup.style.display = 'none';
                    customCategoryInput.removeAttribute('required');
                    customCategoryInput.value = '';
                }
            }

            categorySelect.addEventListener('change', toggleCustomCategory);

            function validateVideoSource() {
                const urlVal = videoUrlInput.value.trim();
                const fileVal = videoFileInput.files.length > 0;
                if (!urlVal && !fileVal) {
                    sourceError.style.display = 'block';
                    videoUrlInput.classList.add('is-invalid');
                    videoFileInput.classList.add('is-invalid');
                    return false;
                } else {
                    sourceError.style.display = 'none';
                    videoUrlInput.classList.remove('is-invalid');
                    videoFileInput.classList.remove('is-invalid');
                    return true;
                }
            }

            videoUrlInput.addEventListener('input', validateVideoSource);
            videoFileInput.addEventListener('change', validateVideoSource);

            form.addEventListener('submit', function (event) {
                let valid = true;

                if (!form.checkValidity()) {
                    valid = false;
                }

                if (categorySelect.value === 'Others' && !customCategoryInput.value.trim()) {
                    customCategoryInput.classList.add('is-invalid');
                    valid = false;
                } else {
                    customCategoryInput.classList.remove('is-invalid');
                }

                if (!validateVideoSource()) {
                    valid = false;
                }

                if (!valid) {
                    event.preventDefault();
                    event.stopPropagation();
                    form.classList.add('was-validated');
                } else {
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Saving...';
                    submitBtn.disabled = true;
                }
            });
        });
    </script>
</body>
</html>
