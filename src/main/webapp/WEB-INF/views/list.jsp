<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SOS Activations</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <h1>SOS Activations</h1>
    <a href="${pageContext.request.contextPath}/sos/new">Create New SOS</a>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Method</th>
                <th>Latitude</th>
                <th>Longitude</th>
                <th>Message</th>
                <th>Status</th>
                <th>Details</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="sos" items="${sosActivations}">
                <tr>
                    <td>${sos.id}</td>
                    <td>${sos.activationMethod}</td>
                    <td>${sos.latitude}</td>
                    <td>${sos.longitude}</td>
                    <td>${sos.sosMessage}</td>
                    <td>${sos.status}</td>
                    <td><a href="${pageContext.request.contextPath}/sos/details/${sos.id}">View Details</a></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>

