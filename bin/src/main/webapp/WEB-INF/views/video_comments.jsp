<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>💬 Video Comments</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --transition-smooth: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .reply-card {
        margin-left: 2rem;
        margin-top: 1rem;
        padding: 1rem;
        background: rgba(248, 249, 255, 0.6);
        border-left: 3px solid var(--primary-purple-light);
        border-radius: 0 12px 12px 0;
        transition: var(--transition-smooth);
    }

    .reply-card:hover {
        background: var(--light-bg);
        border-left-color: var(--primary-coral);
        box-shadow: var(--shadow-sm);
    }

    .reply-card .reply-card {
        margin-left: 1.5rem;
        background: rgba(248, 249, 255, 0.4);
    }

    .reply-card .reply-author {
        font-weight: 600;
        color: var(--primary-purple);
        margin-bottom: 0.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .reply-card .reply-author i {
        color: var(--primary-coral);
        font-size: 0.9rem;
    }

    .reply-card .reply-date {
        font-size: 0.75rem;
        color: var(--primary-purple-light);
        margin-bottom: 0.5rem;
    }

    .reply-card .reply-content {
        color: #333;
        line-height: 1.5;
        margin-bottom: 0.75rem;
    }

    .reply-card .reply-actions {
        display: flex;
        gap: 1rem;
        font-size: 0.8rem;
    }

    .reply-card .reply-actions a {
        color: var(--primary-purple-light);
        text-decoration: none;
        transition: var(--transition-smooth);
    }

    .reply-card .reply-actions a:hover {
        color: var(--primary-coral);
        text-decoration: underline;
    }

    .reply-form {
        margin-top: 1rem;
        padding: 1rem;
        background: white;
        border-radius: 16px;
        box-shadow: var(--shadow-sm);
        transition: var(--transition-smooth);
        border: 1px solid rgba(123, 44, 191, 0.2);
    }

    .reply-form:hover {
        box-shadow: var(--shadow-md);
        border-color: var(--primary-purple-light);
    }

    .reply-form textarea,
    .reply-form input[type="text"] {
        width: 100%;
        padding: 10px 14px;
        border: 1px solid #e2e2e2;
        border-radius: 12px;
        font-family: inherit;
        font-size: 0.9rem;
        transition: var(--transition-smooth);
        resize: vertical;
    }

    .reply-form textarea:focus,
    .reply-form input[type="text"]:focus {
        outline: none;
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
    }

    .reply-form button {
        background: var(--gradient-primary);
        border: none;
        color: white;
        padding: 8px 18px;
        border-radius: 40px;
        font-weight: 600;
        cursor: pointer;
        transition: var(--transition-smooth);
        margin-top: 0.5rem;
    }

    .reply-form button:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .reply-form .btn-cancel {
        background: transparent;
        color: var(--primary-purple-light);
        box-shadow: none;
        margin-left: 0.5rem;
    }

    .reply-form .btn-cancel:hover {
        background: rgba(123, 44, 191, 0.1);
        transform: translateY(-1px);
    }

    @media (max-width: 768px) {
        .reply-card {
            margin-left: 0.75rem;
            padding: 0.75rem;
        }
        .reply-card .reply-card {
            margin-left: 0.5rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in for reply cards */
    .reply-card {
        animation: fadeSlideIn 0.3s ease-out forwards;
    }
    @keyframes fadeSlideIn {
        from {
            opacity: 0;
            transform: translateX(-10px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    /* 2. Button ripple effect on submit/cancel */
    .reply-form button, .reply-form .btn-cancel {
        position: relative;
        overflow: hidden;
    }
    .reply-form button::after, .reply-form .btn-cancel::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .reply-form button:active::after, .reply-form .btn-cancel:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility */
    .reply-form button:focus-visible,
    .reply-form .btn-cancel:focus-visible,
    .reply-form textarea:focus-visible,
    .reply-form input:focus-visible,
    .reply-card .reply-actions a:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 4. Custom scrollbar (brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Reply content hover effect – subtle background */
    .reply-card .reply-content {
        transition: background 0.2s;
        padding: 2px 4px;
        margin: -2px -4px;
        border-radius: 8px;
    }
    .reply-card .reply-content:hover {
        background: rgba(123, 44, 191, 0.04);
    }

    /* 6. Author icon pulse on hover */
    .reply-card .reply-author i {
        transition: transform 0.2s;
    }
    .reply-card .reply-author:hover i {
        transform: scale(1.1);
    }

    /* 7. Form input placeholder styling */
    .reply-form textarea::placeholder,
    .reply-form input::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    .reply-form textarea:focus::placeholder,
    .reply-form input:focus::placeholder {
        opacity: 0.5;
    }

    /* 8. Responsive touch improvements for very small devices */
    @media (max-width: 480px) {
        .reply-card {
            margin-left: 0.25rem;
            padding: 0.5rem;
        }
        .reply-actions {
            flex-wrap: wrap;
            gap: 0.5rem !important;
        }
        .reply-form button, .reply-form .btn-cancel {
            padding: 6px 14px;
            font-size: 0.8rem;
        }
    }

    /* 9. Loading skeleton ready (optional) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .reply-card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style><body class="bg-light m-0 p-0">

<div class="bg-white shadow-sm mx-auto" style="max-width: 500px; min-height: 100vh; position: relative; padding-bottom: 100px;">
    
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center sticky-top bg-white p-3 border-bottom shadow-sm">
        <h5 class="m-0 fw-bold">Comments</h5>
        <a href="${pageContext.request.contextPath}/video/reels" class="btn btn-sm btn-light fw-bold px-3 py-1 text-dark" style="border-radius:20px; border: 1px solid #ddd;">Close</a>
    </div>

    <!-- Comments List -->
    <div id="comments-container" class="p-3">
        <c:if test="${empty comments}">
            <p class="text-center text-muted my-5">No comments yet. Start the conversation!</p>
        </c:if>

        <c:forEach var="comment" items="${comments}">
            <div class="d-flex mb-4" data-comment-id="${comment.id}">
                <!-- Avatar -->
                <img src="${pageContext.request.contextPath}${not empty comment.user.profilePhoto ? comment.user.profilePhoto : '/assets/img/default-avatar.png'}" alt="Avatar" class="rounded-circle me-3 mt-1" style="width: 32px; height: 32px; object-fit: cover; background: #eee;">
                
                <!-- Comment Body -->
                <div class="flex-grow-1">
                    <div>
                        <span class="fw-bold me-1" style="font-size: 0.9rem;">${comment.user.fullName}</span>
                        <span style="font-size: 0.9rem; color: #262626;">${comment.text}</span>
                    </div>
                    
                    <div class="d-flex align-items-center mt-1 text-muted" style="font-size: 0.75rem; font-weight: 500;">
                        <span class="me-3">2h</span>
                        <a href="javascript:void(0)" class="text-muted text-decoration-none me-3" onclick="$(this).closest('.flex-grow-1').find('.reply-form-container').slideToggle();">Reply</a>
                    </div>

                    <!-- Hidden Reply Form -->
                    <div class="reply-form-container mt-2 mb-3" style="display: none;">
                        <form class="reply-form" data-comment-id="${comment.id}">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-white border-end-0 text-muted" style="font-size:0.8rem; border-radius: 20px 0 0 20px;">↳ Replying to @${comment.user.fullName}</span>
                                <input type="text" class="form-control border-start-0 reply-text" placeholder="Write a reply..." style="font-size:0.8rem;" required>
                                <button type="submit" class="btn btn-link text-danger text-decoration-none fw-bold" style="border:1px solid #dee2e6; border-left:none; border-radius: 0 20px 20px 0;">➤</button>
                            </div>
                        </form>
                    </div>

                    <!-- Nested Replies -->
                    <c:if test="${not empty comment.replies}">
                        <div class="mt-2">
                            <a href="javascript:void(0)" class="text-muted text-decoration-none fw-bold" style="font-size:0.75rem;" onclick="$(this).next('.replies-list').slideToggle();">
                                ―― View ${comment.replies.size()} replies
                            </a>
                            <div class="replies-list mt-3" style="display: none;">
                                <c:forEach var="reply" items="${comment.replies}">
                                    <div class="d-flex mb-3" data-comment-id="${reply.id}">
                                        <img src="${pageContext.request.contextPath}${not empty reply.user.profilePhoto ? reply.user.profilePhoto : '/assets/img/default-avatar.png'}" alt="Avatar" class="rounded-circle me-2 mt-1" style="width: 24px; height: 24px; object-fit: cover; background: #eee;">
                                        <div class="flex-grow-1">
                                            <div>
                                                <span class="fw-bold me-1" style="font-size: 0.9rem;">${reply.user.fullName}</span>
                                                <span style="font-size: 0.9rem; color: #262626;">${reply.text}</span>
                                            </div>
                                            <div class="d-flex align-items-center mt-1 text-muted" style="font-size: 0.75rem; font-weight: 500;">
                                                <span class="me-3">1h</span>
                                                <a href="javascript:void(0)" class="text-muted text-decoration-none">Reply</a>
                                            </div>
                                        </div>
                                        <div class="ms-3 text-center">
                                            <i class="bi bi-heart text-muted" style="font-size: 0.7rem; cursor:pointer;" onclick="this.classList.toggle('text-danger'); this.classList.toggle('bi-heart-fill'); this.classList.toggle('bi-heart');"></i>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
                
                <!-- Like Heart (Main Comment) -->
                <div class="ms-3 text-center pt-2">
                    <i class="bi bi-heart text-muted" style="font-size: 0.8rem; cursor:pointer;" onclick="this.classList.toggle('text-danger'); this.classList.toggle('bi-heart-fill'); this.classList.toggle('bi-heart');"></i>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Fixed Bottom Comment Bar -->
    <div class="fixed-bottom bg-white border-top shadow-lg p-2" style="max-width: 500px; margin: 0 auto;">
        <form id="add-comment-form" class="d-flex align-items-center w-100 m-0 py-1 px-2" style="background:#f1f2f6; border-radius:30px;">
            <img src="${pageContext.request.contextPath}${not empty currentUser.profilePhoto ? currentUser.profilePhoto : '/assets/img/default-avatar.png'}" class="rounded-circle me-2 ms-1" style="width: 32px; height: 32px; object-fit: cover; background:#ddd;" alt="Avatar">
            <input type="text" id="comment-text" class="form-control bg-transparent border-0 flex-grow-1 shadow-none" placeholder="Add a comment..." style="font-size:0.95rem; outline:none;" autocomplete="off" required>
            <button type="submit" class="btn btn-link text-danger text-decoration-none fw-bold px-2 py-0" style="font-size: 1.1rem;">➤</button>
        </form>
    </div>
</div>

<div style="height: 100px;"></div>

<script>
$(document).ready(function() {

    // Submit top-level comment
    $('#add-comment-form').on('submit', function(e) {
        e.preventDefault();
        const text = $('#comment-text').val();
        const videoId = '${video.id}';

        $.post('${pageContext.request.contextPath}/video/comment', { videoId: videoId, commentText: text }, function(data) {
            if (!data.error) {
                location.reload();
            } else {
                alert(data.error);
            }
        });
    });

    // Submit reply
    $('.reply-form').on('submit', function(e) {
        e.preventDefault();
        const form = $(this);
        const parentId = form.data('comment-id');
        const text = form.find('.reply-text').val();
        const videoId = '${video.id}';

        $.post('${pageContext.request.contextPath}/video/comment', { videoId: videoId, commentText: text, parentId: parentId }, function(data) {
            if (!data.error) {
                // Append reply dynamically
                const avatarUrl = '${pageContext.request.contextPath}' + ('${not empty currentUser.profilePhoto ? currentUser.profilePhoto : "/assets/img/default-avatar.png"}');
                const replyHtml = '<div class="d-flex mb-3" data-comment-id="' + data.id + '">' +
                    '<img src="' + avatarUrl + '" alt="Avatar" class="rounded-circle me-2 mt-1" style="width: 24px; height: 24px; object-fit: cover; background: #eee;">' +
                    '<div class="flex-grow-1">' +
                        '<div>' +
                            '<span class="fw-bold me-1" style="font-size: 0.9rem;">' + data.user + '</span>' +
                            '<span style="font-size: 0.9rem; color: #262626;">' + data.text + '</span>' +
                        '</div>' +
                        '<div class="d-flex align-items-center mt-1 text-muted" style="font-size: 0.75rem; font-weight: 500;">' +
                            '<span class="me-3">now</span>' +
                            '<a href="javascript:void(0)" class="text-muted text-decoration-none">Reply</a>' +
                        '</div>' +
                    '</div>' +
                    '<div class="ms-3 text-center">' +
                        '<i class="bi bi-heart text-muted" style="font-size: 0.7rem; cursor:pointer;" onclick="this.classList.toggle(\'text-danger\'); this.classList.toggle(\'bi-heart-fill\'); this.classList.toggle(\'bi-heart\');"></i>' +
                    '</div>' +
                '</div>';
                
                // If replies list exists, append to it and reveal it. Otherwise create it.
                let repliesList = form.closest('.flex-grow-1').find('.replies-list');
                if (repliesList.length > 0) {
                    repliesList.append(replyHtml);
                    if (!repliesList.is(":visible")) {
                        repliesList.slideDown();
                    }
                } else {
                    // Create new replies list section
                    const newRepliesSection = '<div class="mt-2">' +
                        '<a href="javascript:void(0)" class="text-muted text-decoration-none fw-bold" style="font-size:0.75rem;" onclick="$(this).next(\'.replies-list\').slideToggle();">' +
                            '―― View replies' +
                        '</a>' +
                        '<div class="replies-list mt-3">' +
                            replyHtml +
                        '</div>' +
                    '</div>';
                    form.closest('.reply-form-container').after(newRepliesSection);
                }
                
                form.find('.reply-text').val('');
                form.closest('.reply-form-container').slideUp();

            } else {
                alert(data.error);
            }
        });
    });

});
</script>

</body>
</html>

