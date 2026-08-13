<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Q&A Thread</title>




<style>
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-gold: #ffd700;
        --dark-bg: #150510;
        --text-primary: #ffffff;
        --text-secondary: rgba(255, 255, 255, 0.7);
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
    }

    body {
        font-family: 'Inter', -apple-system, sans-serif;
        margin: 0;
        padding: 0;
        background: var(--dark-bg);
        color: var(--text-primary);
        min-height: 100vh;
    }

    .bg-grid {
        position: fixed; inset: 0;
        background-image:
            radial-gradient(circle at 20% 50%, rgba(124, 45, 94, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(219, 39, 119, 0.15) 0%, transparent 50%);
        z-index: 0;
    }

    /* Header */
    .top-nav {
        position: fixed; top: 0; left: 0; right: 0;
        padding: 16px 24px;
        display: flex; justify-content: space-between; align-items: center;
        background: linear-gradient(to right, var(--primary-purple), #4a0e2a);
        backdrop-filter: blur(20px);
        border-bottom: 2px solid var(--primary-coral);
        z-index: 100;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    }
    .top-nav .brand { font-weight:700; font-size:18px; color: white; text-decoration: none; display:flex; align-items:center; gap:8px; }
    .top-nav .back-btn {
        color: var(--text-secondary); text-decoration:none; font-size:14px;
        display:flex; align-items:center; gap:6px; transition: color 0.2s;
    }
    .top-nav .back-btn:hover { color: var(--text-primary); }

    .container {
        position: relative;
        z-index: 1;
        width: 90%;
        max-width: 900px;
        margin: 0 auto;
        padding: 100px 0 40px;
    }

    .card {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(15px);
        border-radius: 20px;
        padding: 30px;
        margin-bottom: 25px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.2);
    }

    h3 {
        color: var(--primary-coral);
        font-size: 24px;
        font-weight: 800;
        margin-bottom: 10px;
    }

    .meta {
        font-size: 13px;
        color: var(--text-secondary);
        margin-bottom: 20px;
    }

    .admin-reply {
        background: rgba(30, 27, 75, 0.1);
        border-left: 4px solid var(--primary-purple-light);
        padding: 20px;
        border-radius: 0 12px 12px 0;
        margin: 25px 0;
    }

    .reply {
        margin-left: 20px;
        padding: 15px;
        background: rgba(255, 255, 255, 0.02);
        border-left: 2px dashed rgba(255,255,255,0.1);
        border-radius: 0 12px 12px 0;
        margin-top: 15px;
    }

    .reply-btn, .toggle-btn {
        color: var(--primary-coral);
        background: rgba(219, 39, 119, 0.1);
        border: none;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        padding: 6px 14px;
        border-radius: 20px;
        transition: all 0.3s;
        margin-right: 10px;
    }
    .reply-btn:hover, .toggle-btn:hover {
        background: var(--primary-coral);
        color: white;
    }

    textarea {
        width: 100%;
        min-height: 80px;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 12px;
        padding: 14px;
        color: white;
        font-family: inherit;
        font-size: 14px;
        margin-top: 15px;
        transition: all 0.3s;
    }
    textarea:focus {
        border-color: var(--primary-coral);
        background: rgba(255, 255, 255, 0.1);
        outline: none;
        box-shadow: 0 0 15px rgba(219, 39, 119, 0.3);
    }

    .submit-btn {
        background: var(--gradient-primary);
        color: white;
        padding: 10px 24px;
        border: none;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 700;
        margin-top: 10px;
        cursor: pointer;
        transition: all 0.3s;
    }
    .submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(219, 39, 119, 0.4);
    }

    .hidden {
        display: none;
    }
</style>

<script>
    function toggleReplies(sectionId) {
        const el = document.getElementById(sectionId);
        el.classList.toggle('hidden');
    }

    function toggleReplyForm(formId) {
        const el = document.getElementById(formId);
        el.classList.toggle('hidden');
    }

    // Emoji Pickers
    window.addEventListener('DOMContentLoaded', () => {
        const pickers = document.querySelectorAll('.emoji-btn');
        pickers.forEach(btn => {
            const picker = new EmojiButton({
                theme: 'light',
                position: 'top-end',
                autoHide: false
            });

            const targetTextarea = document.getElementById(btn.dataset.target);

            picker.on('emoji', emoji => {
                const start = targetTextarea.selectionStart;
                const end = targetTextarea.selectionEnd;
                const text = targetTextarea.value;
                targetTextarea.value = text.slice(0, start) + emoji + text.slice(end);
                targetTextarea.focus();
            });

            btn.addEventListener('click', () => {
                picker.togglePicker(btn);
            });
        });
    });
</script>

    <script src="https://cdn.jsdelivr.net/npm/@joeattardi/emoji-button@4.6.4/dist/index.min.js"></script>
    
</head>
<body>
<div class="bg-grid"></div>

<nav class="top-nav">
    <a href="${pageContext.request.contextPath}/qna" class="brand"><i class="bi bi-chat-left-text-fill" style="color: var(--primary-gold);"></i> View Discussion</a>
    <a href="${pageContext.request.contextPath}/qna" class="back-btn">
        <i class="bi bi-arrow-left"></i> Forum Home
    </a>
</nav>

<div class="container">

    <!-- Main Question -->
    <h3>${thread.content}</h3>
    <p class="meta">Asked by ${thread.displayName} | ${thread.postedAt}</p>

    <!-- Admin Answer as Top Comment -->
    <c:if test="${not empty thread.answer}">
        <div class="admin-reply">
            <p><strong>Admin:</strong> ${thread.answer.content}</p>
            <small class="meta">Answered at ${thread.answer.answeredAt}</small>

            <!-- View Replies Toggle -->
            <button class="toggle-btn" onclick="toggleReplies('replies-to-answer')">View Replies</button>
            |
            <!-- Toggle Reply Input -->
            <button class="reply-btn" onclick="toggleReplyForm('reply-to-answer-form')">💬 Reply</button>

            <!-- Replies to Admin -->
            <div id="replies-to-answer" class="hidden">
                <c:forEach var="comment" items="${thread.comments}">
                    <c:if test="${comment.parentType == 'ANSWER'}">
                        <div class="reply">
                            <p>${comment.content}</p>
                            <small class="meta"><b>${comment.displayName}</b> at ${comment.commentedAt}</small>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <!-- Reply Input Box -->
            <form id="reply-to-answer-form" class="hidden" action="${pageContext.request.contextPath}/qna/thread/${thread.id}/comment" method="post">
                <input type="hidden" name="parentType" value="ANSWER"/>
                <input type="hidden" name="parentId" value="${thread.answer.id}"/>
                <textarea name="content" required placeholder="Reply to admin..."></textarea>
                <button type="submit" class="submit-btn">Post Reply</button>
            </form>
        </div>
    </c:if>

    <!-- Other Comments on Question -->
    <c:forEach var="comment" items="${thread.comments}">
        <c:if test="${comment.parentType == 'QUESTION'}">
            <div class="reply">
                <p>${comment.content}</p>
                <small class="meta"><b>${comment.displayName}</b> at ${comment.commentedAt}</small>
            </div>
        </c:if>
    </c:forEach>
<button class="reply-btn" onclick="toggleReplyForm('comment-on-question-form')">💬 Comment</button>

    <!-- Add comment to Question -->
   <form id="comment-on-question-form" class="hidden" action="${pageContext.request.contextPath}/qna/thread/${thread.id}/comment" method="post">
    <input type="hidden" name="parentType" value="QUESTION"/>
    <input type="hidden" name="parentId" value="${thread.id}"/>
    <textarea name="content" required placeholder="Add a public comment..."></textarea>
    <button type="submit" class="submit-btn">Post Comment</button>
</form>
</div>
</div>
</body>
</html>

