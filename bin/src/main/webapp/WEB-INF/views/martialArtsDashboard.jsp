<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Martial Arts Center Dashboard</title>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Martial Arts Center</a>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/centres/about/${center.id}" class="btn btn-warning me-2">Profile</a>
                <a href="${pageContext.request.contextPath}/centres/logout" class="btn btn-danger">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2 class="text-center">Enrolled Users</h2>
        <input type="text" id="searchUser" class="form-control mb-3" placeholder="Search user by name..." onkeyup="filterUsers()">
        
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Martial Arts Type</th>
                    <th>Slot</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="userTable">
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.martialArtType}</td>
                        <td>${user.slot}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/updateEnrollmentStatus" method="post">
                                <input type="hidden" name="userId" value="${user.id}">
                                <select name="status" class="form-select">
                                    <option value="Pending" ${user.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Approved" ${user.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                    <option value="Rejected" ${user.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                    <option value="Completed" ${user.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                </select>
                                <input type="text" name="message" class="form-control mt-2" placeholder="Message (optional)">
                                <button type="submit" class="btn btn-primary mt-2">Update</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        function filterUsers() {
            let input = document.getElementById("searchUser").value.toLowerCase();
            let rows = document.querySelectorAll("#userTable tr");
            rows.forEach(row => {
                let name = row.cells[0].textContent.toLowerCase();
                row.style.display = name.includes(input) ? "" : "none";
            });
        }
    </script>

</body>
</html>

