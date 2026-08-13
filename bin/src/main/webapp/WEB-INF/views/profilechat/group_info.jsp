<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Group Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .bg-purple{
        background:#1e1b4b;
        color:white;
    }

    .profile-img{
        object-fit:cover;
    }
</style>

</head>
<body>

<div class="container mt-4">

    <!-- GROUP HEADER -->
    <div class="text-center">

        <img src="${group.profilePhoto}"
             class="rounded-circle mb-2 profile-img"
             width="120"
             height="120">

        <h4>${group.name}</h4>

        <p class="text-muted">
            ${fn:length(group.members)} members
        </p>
    </div>

    <hr>

    <!-- MEMBERS LIST -->
    <ul class="list-group">

        <c:forEach var="m" items="${group.members}">

            <li class="list-group-item d-flex justify-content-between align-items-center">

                <div class="d-flex align-items-center">

                    <img src="${m.user.profilePhoto}"
                         class="rounded-circle me-3 profile-img"
                         width="45"
                         height="45">

                    <div>
                        <strong>${m.user.fullName}</strong>
                        <br>

                        <small>
                            ${m.user.phone}
                        </small>
                    </div>

                </div>

                <div>

                    <!-- ADMIN BADGE -->
                    <c:if test="${m.admin}">
                        <span class="badge bg-purple">
                            Admin
                        </span>
                    </c:if>

                    <!-- REMOVE BUTTON -->
                    <c:if test="${isAdmin && m.user.id != currentUser.id}">

                        <a href="${pageContext.request.contextPath}/groups/remove/${group.id}/${m.id}"
                           class="btn btn-sm btn-outline-danger ms-2">

                            Remove

                        </a>

                    </c:if>

                </div>

            </li>

        </c:forEach>

    </ul>

</div>

</body>
</html>