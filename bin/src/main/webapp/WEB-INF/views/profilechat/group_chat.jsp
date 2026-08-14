<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>${group.name} - Group Chat</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f0fb;
            font-family: 'Segoe UI', sans-serif;
        }

        .chat-container {
            max-width: 800px;
            margin: 30px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 20px rgba(128, 0, 128, 0.2);
            display: flex;
            flex-direction: column;
            height: 80vh;
        }

        /* HEADER */
        .chat-header {
            padding: 15px 20px;
            background: linear-gradient(45deg, #7b1fa2, #9c27b0);
            color: #fff;
            border-radius: 18px 18px 0 0;
        }

        .chat-header h4 {
            margin: 0;
            font-weight: 600;
        }

        .members a {
            font-size: 13px;
            color: #fff;
            text-decoration: underline;
            cursor: pointer;
        }

        /* CHAT BOX */
        #chat-box {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            background: #efe7f7;
        }

        .msg {
            max-width: 70%;
            padding: 10px 14px;
            margin-bottom: 10px;
            border-radius: 15px;
            font-size: 14px;
        }

        .my-msg {
            background: #9c27b0;
            color: #fff;
            margin-left: auto;
            border-bottom-right-radius: 3px;
        }

        .other-msg {
            background: #fff;
            color: #333;
            margin-right: auto;
            border-bottom-left-radius: 3px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .sender {
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 3px;
            opacity: 0.8;
        }

        /* INPUT */
        .chat-input {
            display: flex;
            padding: 12px;
            border-top: 1px solid #ddd;
            background: #fafafa;
            border-radius: 0 0 18px 18px;
        }

        .chat-input input {
            flex: 1;
            border-radius: 25px;
            padding: 10px 15px;
            border: 1px solid #ccc;
        }

        .chat-input button {
            margin-left: 10px;
            background: #7b1fa2;
            color: #fff;
            border: none;
            border-radius: 25px;
            padding: 10px 20px;
        }

        .bg-purple {
            background-color: #7b1fa2 !important;
        }
    </style>
</head>

<body>

<div class="chat-container">

    <!-- HEADER -->
    <div class="chat-header">
        <h4>${group.name}</h4>
        <div class="members">
            <a data-bs-toggle="modal" data-bs-target="#membersModal">
                View Members (${fn:length(group.members)})
            </a>
          
    |
    <a data-bs-toggle="modal" data-bs-target="#addMemberModal">
        Add Member
    </a>
    |
<a href="#" class="text-white"
   data-bs-toggle="modal"
   data-bs-target="#exitGroupModal">
    Exit Group
</a>
    
 </div>
    </div>

    <!-- CHAT -->
    <div id="chat-box">
        <c:forEach var="msg" items="${messages}">
            <div class="msg ${msg.sender.id == currentUser.id ? 'my-msg' : 'other-msg'}">
                <div class="sender">${msg.sender.fullName}</div>
                ${msg.message}
            </div>
        </c:forEach>
    </div>

    <!-- SEND -->
    <form method="post"
          action="${pageContext.request.contextPath}/users/groups/${group.id}/send"
          class="chat-input">

        <input type="text" name="message" placeholder="Type a message..." required>
        <button type="submit">Send</button>
    </form>

</div>

<!-- MEMBERS MODAL -->
<div class="modal fade" id="membersModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header bg-purple text-white">
                <h5 class="modal-title">Group Members</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Role</th>
                        </tr>
                    </thead>
                   <tbody>
    <c:forEach var="m" items="${group.members}">
        <tr>
            <td>${m.user.fullName}</td>
            <td>${m.user.phoneNumber}</td>
            <td>
                <c:choose>
                    <c:when test="${m.admin}">
                        <span class="badge bg-purple">Admin</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary">Member</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</tbody>

                </table>
            </div>
        </div>
    </div>
</div>
<!-- ADD MEMBER MODAL -->
<div class="modal fade" id="addMemberModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header bg-purple text-white">
                <h5 class="modal-title">Add Members</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="f" items="${friends}">
                        <tr>
                            <td>${f.fullName}</td>
                            <td>${f.email}</td>
                            <td>
                                <c:choose>
                                 
                                    <c:when test="${groupMemberIds.contains(f.id)}">
                                        <span class="badge bg-secondary">Member</span>
                                    </c:when>

                                 
                                    <c:otherwise>
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/users/groups/${group.id}/add-member">
                                            <input type="hidden" name="userId" value="${f.id}">
                                            <button class="btn btn-sm btn-success">
                                                Add
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- EXIT GROUP MODAL -->
<div class="modal fade" id="exitGroupModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Exit Group</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body text-center">
                <p>Are you sure you want to exit this group?</p>

                <form method="post"
                      action="${pageContext.request.contextPath}/users/groups/${group.id}/exit">
                    <button class="btn btn-danger">
                        Exit Group
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    const chatBox = document.getElementById('chat-box');
    if (chatBox) {
        chatBox.scrollTop = chatBox.scrollHeight;
    }
</script>

</body>
</html>

