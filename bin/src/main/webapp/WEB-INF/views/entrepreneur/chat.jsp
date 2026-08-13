<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collaboration Chat — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --navy-light: #312e81;
            --primary: #f43f5e;
            --bg-light: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        #sidebar-wrapper {
            min-width: 260px;
            max-width: 260px;
            background: var(--navy-dark);
            color: white;
            min-height: 100vh;
            border-top-right-radius: 40px;
            padding-top: 30px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
        }

        .sidebar-heading {
            padding: 10px 25px 25px;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: white;
            background: rgba(255,255,255,0.05);
            border-left-color: var(--primary);
        }

        #page-content-wrapper {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            height: calc(100vh - 80px);
        }

        .chat-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
            width: 100%;
        }

        .chat-header {
            background: var(--navy-dark);
            color: white;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #f1f5f9;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message {
            max-width: 70%;
            padding: 12px 18px;
            border-radius: 16px;
            font-size: 0.95rem;
            position: relative;
            line-height: 1.4;
        }

        .message.sent {
            background-color: var(--primary);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 2px;
        }

        .message.received {
            background-color: white;
            color: #1e293b;
            align-self: flex-start;
            border-bottom-left-radius: 2px;
            border: 1px solid #e2e8f0;
        }

        .msg-time {
            font-size: 0.7rem;
            opacity: 0.8;
            margin-top: 5px;
            text-align: right;
        }

        .chat-footer {
            padding: 20px;
            background: white;
            border-top: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link">
                <i class="bi bi-file-earmark-plus"></i> Create Proposal
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-5">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="chat-container">
            <!-- Header -->
            <div class="chat-header">
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="text-white text-decoration-none fs-4">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <div>
                        <h6 class="fw-bold m-0">${investor.fullName}</h6>
                        <span class="small text-white-50">${proposal.title}</span>
                    </div>
                </div>
                <span class="badge bg-success rounded-pill px-3">Direct Channel</span>
            </div>

            <!-- Messages Area -->
            <div class="chat-messages" id="messageArea">
                <c:forEach var="msg" items="${chatHistory}">
                    <div class="message ${msg.senderRole == 'ENTREPRENEUR' ? 'sent' : 'received'}">
                        <div>${msg.message}</div>
                        <div class="msg-time">${msg.timestamp}</div>
                    </div>
                </c:forEach>
                <c:if test="${empty chatHistory}">
                    <div class="text-center text-muted my-auto py-5">
                        <i class="bi bi-chat-heart" style="font-size: 3rem; color: var(--primary);"></i>
                        <p class="mt-3 small">Connection initialized. Send a message to start collaborating!</p>
                    </div>
                </c:if>
            </div>

            <!-- Footer / Input Form -->
            <div class="chat-footer">
                <form action="${pageContext.request.contextPath}/entrepreneur/chat/${investor.id}" method="post" id="chatForm">
                    <input type="hidden" name="proposalId" value="${proposal.id}">
                    <div class="input-group">
                        <input type="text" name="message" class="form-control rounded-pill-start py-3 px-4 border-end-0" placeholder="Type a message..." required autocomplete="off">
                        <button class="btn btn-primary rounded-pill-end px-4" type="submit" style="background-color: var(--primary); border: none;">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Keep scroll at bottom of chat messages
    document.addEventListener("DOMContentLoaded", function() {
        const area = document.getElementById("messageArea");
        area.scrollTop = area.scrollHeight;
    });
</script>
</body>
</html>
