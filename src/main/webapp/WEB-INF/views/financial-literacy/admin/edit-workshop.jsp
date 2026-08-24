<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Edit Workshop - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
</head>
<body>
    <c:set var="flAdminTitle" value="Edit Workshop" scope="request"/>
    <c:set var="flAdminActive" value="edit-workshop" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h3 class="mb-0">Edit Workshop</h3>
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

                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/edit-workshop/${workshop.id}" method="POST" id="workshopForm" class="needs-validation" novalidate>
                        <!-- Workshop Title -->
                        <div class="mb-3 position-relative">
                            <label for="title" class="form-label fw-bold">Workshop Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required minlength="5" value="${title}" placeholder="Enter workshop title">
                            <div class="invalid-feedback">Please provide a valid title (min 5 characters).</div>
                        </div>

                        <!-- Category Dropdown -->
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
                            <div class="invalid-feedback">Custom category cannot be empty when 'Others' is selected.</div>
                        </div>

                        <!-- Venue & City -->
                        <div class="row">
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="venue" class="form-label fw-bold">Venue <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="venue" name="venue" required minlength="3" value="${venue}" placeholder="E.g. Town Hall">
                                <div class="invalid-feedback">Please provide the venue (min 3 characters).</div>
                            </div>
                            
                            <div class="col-md-6 mb-3 position-relative">
                                <label for="city" class="form-label fw-bold">City <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="city" name="city" required minlength="2" value="${city}" placeholder="E.g. Mumbai">
                                <div class="invalid-feedback">Please provide the city name.</div>
                            </div>
                        </div>
                        
                        <!-- Date & Timing (Start Time & End Time) -->
                        <div class="row">
                            <div class="col-md-4 mb-3 position-relative">
                                <label for="date" class="form-label fw-bold">Date <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="date" name="date" value="${date}" required>
                                <div class="invalid-feedback">Please select a valid date.</div>
                            </div>
                            
                            <div class="col-md-4 mb-3 position-relative">
                                <label for="startTime" class="form-label fw-bold">Start Time <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="startTime" name="startTime" value="${startTime}" required>
                                <div class="invalid-feedback">Please provide the start time.</div>
                            </div>

                            <div class="col-md-4 mb-3 position-relative">
                                <label for="endTime" class="form-label fw-bold">End Time <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="endTime" name="endTime" value="${endTime}" required>
                                <div class="invalid-feedback">Please provide the end time.</div>
                            </div>
                        </div>
                        
                        <!-- Number of Seats -->
                        <div class="mb-3 position-relative">
                            <label for="seats" class="form-label fw-bold">Number of Seats <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="seats" name="seats" min="1" max="5000" required placeholder="E.g. 50" value="${seats}">
                            <div class="invalid-feedback">Please enter a valid number of seats (1-5000).</div>
                        </div>

                        <!-- Description -->
                        <div class="mb-4 position-relative">
                            <label for="description" class="form-label fw-bold">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="description" name="description" rows="4" required minlength="10" placeholder="Provide a brief description...">${description}</textarea>
                            <div class="invalid-feedback">Please provide a description (min 10 characters).</div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="btn btn-light">Cancel</a>
                            <button type="submit" class="btn-purple" id="submitBtn">
                                <i class="fas fa-save me-2"></i> Update Workshop
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('workshopForm');
            const categorySelect = document.getElementById('category');
            const customCategoryGroup = document.getElementById('customCategoryGroup');
            const customCategoryInput = document.getElementById('customCategory');
            const submitBtn = document.getElementById('submitBtn');

            function toggleCustomCategory() {
                if (categorySelect.value === 'Others') {
                    customCategoryGroup.style.display = 'block';
                    customCategoryInput.setAttribute('required', 'true');
                } else {
                    customCategoryGroup.style.display = 'none';
                    customCategoryInput.removeAttribute('required');
                }
            }

            categorySelect.addEventListener('change', toggleCustomCategory);

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

                if (!valid) {
                    event.preventDefault();
                    event.stopPropagation();
                    form.classList.add('was-validated');
                } else {
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Updating...';
                    submitBtn.disabled = true;
                }
            });
        });
    </script>
</body>
</html>
