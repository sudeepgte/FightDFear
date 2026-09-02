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
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --navy-dark: #2E1B33; /* Dark plum header from image */
            --bg-light: #fcf9f9; /* Very light pinkish-white background */
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
            margin: 0;
            padding: 0;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        /* Sidebar Styling */
        #sidebar-wrapper {
            min-width: 250px;
            max-width: 250px;
            background: #ffffff;
            min-height: 100vh;
            border-right: 1px solid #f1f5f9;
            padding-top: 30px;
        }

        .sidebar-heading {
            padding: 10px 25px 30px;
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--navy-dark);
        }

        .sidebar-heading i {
            color: var(--primary-rose);
        }

        .sidebar-link {
            background: transparent;
            color: #475569;
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
            transition: all 0.3s;
            margin: 5px 15px;
            border-radius: 12px;
        }

        .sidebar-link i {
            font-size: 1.1rem;
        }

        .sidebar-link:hover {
            color: var(--primary-rose);
            background: #fff1f2;
        }

        .sidebar-link.active {
            color: var(--primary-rose);
            background: #fff1f2;
        }

        #page-content-wrapper {
            flex: 1;
            padding: 30px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            background-color: var(--bg-light);
        }

        /* Chat Container exactly like Image */
        .chat-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.03);
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Dark Plum Header */
        .chat-header {
            background: var(--navy-dark);
            color: white;
            padding: 20px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .chat-header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .btn-back {
            color: white;
            font-size: 1.4rem;
            transition: opacity 0.2s;
        }
        
        .btn-back:hover {
            opacity: 0.8;
            color: white;
        }

        .chat-header h6 {
            color: white;
            margin: 0;
            font-size: 1.1rem;
        }
        
        .chat-header .subtitle {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.8rem;
            display: block;
        }

        .badge-channel {
            background-color: var(--primary-rose);
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Messages Area */
        .chat-messages {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background: white; /* Image shows white chat area */
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message {
            max-width: 60%;
            padding: 12px 18px;
            border-radius: 12px;
            font-size: 0.95rem;
            position: relative;
            line-height: 1.4;
        }

        /* Own messages (like image: Red background, white text) */
        .message.sent {
            background-color: var(--primary-rose);
            color: white;
            align-self: flex-end;
            border-top-right-radius: 4px;
        }

        /* Other person's messages */
        .message.received {
            background-color: #f1f5f9;
            color: #1e293b;
            align-self: flex-start;
            border-top-left-radius: 4px;
        }

        .msg-time {
            font-size: 0.7rem;
            opacity: 0.85;
            margin-top: 6px;
        }
        .sent .msg-time { text-align: right; }
        .received .msg-time { text-align: left; }

        /* Footer / Input matching image */
        .chat-footer {
            padding: 20px 30px;
            background: var(--bg-light); /* Slightly off-white matching the page background */
        }

        .chat-input-wrapper {
            display: flex;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .chat-input-wrapper input {
            flex: 1;
            border: none;
            padding: 15px 20px;
            font-size: 0.95rem;
            outline: none;
            color: #333;
        }

        .chat-input-wrapper button {
            background-color: var(--primary-rose);
            color: white;
            border: none;
            width: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            cursor: pointer;
            transition: background 0.2s;
        }

        .chat-input-wrapper button:hover {
            background-color: var(--primary-rose-hover);
        }
    </style>
</head>
<body>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-house"></i> Dashboard
            </a>
            <a href="#" class="sidebar-link active">
                <i class="bi bi-chat-dots"></i> Chat
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link">
                <i class="bi bi-plus-square"></i> Create Proposal
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-calendar2-check"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/profile-completion" class="sidebar-link">
                <i class="bi bi-person"></i> My Profile
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-4">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="chat-container">
            <!-- Header (Dark Plum like image) -->
            <div class="chat-header">
                <div class="chat-header-left">
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="btn-back text-decoration-none">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <div>
                        <h6 class="fw-bold">${investor.fullName}</h6>
                        <span class="subtitle">${proposal.title}</span>
                    </div>
                </div>
                <span class="badge-channel">Direct Channel</span>
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
                        <i class="bi bi-chat-heart" style="font-size: 3.5rem; color: #f43f5e; opacity: 0.3;"></i>
                        <p class="mt-3">No messages yet.<br>Say hello to start the conversation!</p>
                    </div>
                </c:if>
            </div>

            <!-- Footer / Input Form (White box, red button like image) -->
            <div class="chat-footer">
                <form action="${pageContext.request.contextPath}/entrepreneur/chat/${investor.id}" method="post" id="chatForm">
                    <input type="hidden" name="proposalId" value="${proposal.id}">
                    <div class="chat-input-wrapper">
                        <input type="text" name="message" placeholder="Type a message..." required autocomplete="off">
                        <button type="submit">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const area = document.getElementById("messageArea");
        if(area) area.scrollTop = area.scrollHeight;
    });
</script>
</body>
</html>
