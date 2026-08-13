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
                            <select class="form-select" id="category" name="category" required>
                                <option value="saving">Saving</option>
                                <option value="investing">Investing</option>
                                <option value="loans">Loans</option>
                                <option value="banking">Banking</option>
                                <option value="insurance">Insurance</option>
                                <option value="government">Government Schemes</option>
                            </select>
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
    </script>
</body>
</html>
