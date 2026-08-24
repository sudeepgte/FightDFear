<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<title>Chat</title>
<meta http-equiv="refresh" content="5"> <!-- Auto-refresh every 5 seconds -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">
  <h4>Chat with ${receiver.name}</h4>
  <div class="border rounded p-3 mb-3 bg-white" style="height:400px; overflow-y:auto;">
    <c:forEach var="msg" items="${chatHistory}">
      <div class="${msg.sender.id == sessionScope.user.id ? 'text-end' : 'text-start'}">
        <span class="badge bg-${msg.sender.id == sessionScope.user.id ? 'primary' : 'secondary'}">
          ${msg.message}
        </span>
        <br>
        <small class="text-muted">${msg.timestamp}</small>
        <hr>
      </div>
    </c:forEach>
  </div>

  <form action="${pageContext.request.contextPath}/chat/send" method="post" class="d-flex">
    <input type="hidden" name="receiverId" value="${receiver.id}">
    <input type="text" name="message" class="form-control me-2" placeholder="Type your message..." required>
    <button class="btn btn-success">Send</button>
  </form>
</div>
</body>
</html>
