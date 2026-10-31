<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Proposal Chats - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .chat-card { background:#fff; border:1px solid var(--ap-border); border-radius:14px; overflow:hidden; margin-bottom:14px; transition:box-shadow .2s; }
    .chat-card:hover { box-shadow:0 4px 20px rgba(0,0,0,.07); }
    .chat-card-header { display:flex; align-items:center; gap:14px; padding:14px 18px; cursor:pointer; border-bottom:1px solid transparent; }
    .chat-card-header.open { border-color:var(--ap-border); }
    .chat-avatar { width:40px;height:40px;border-radius:10px;background:#FFF1F2;color:#F43F5E;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1rem;flex-shrink:0; }
    .chat-meta { flex:1; min-width:0; }
    .chat-name { font-weight:700; color:#1E293B; font-size:.92rem; }
    .chat-sub { font-size:.76rem; color:var(--ap-muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .chat-badge { background:#F0FDF4;color:#15803D;border:1px solid #BBF7D0;border-radius:999px;font-size:.72rem;font-weight:700;padding:3px 10px;white-space:nowrap; }
    .chat-body { display:none; padding:16px 18px; }
    .chat-body.open { display:block; }
    .msg { display:flex; gap:10px; margin-bottom:10px; }
    .msg.investor { flex-direction:row-reverse; }
    .msg-bubble { max-width:70%; padding:9px 14px; border-radius:12px; font-size:.85rem; line-height:1.5; }
    .msg.entrepreneur .msg-bubble { background:#F1F5F9; color:#1E293B; border-bottom-left-radius:4px; }
    .msg.investor .msg-bubble { background:#F0FDF4; color:#15803D; border-bottom-right-radius:4px; }
    .msg-time { font-size:.7rem; color:var(--ap-muted); margin-top:3px; }
    .msg.investor .msg-time { text-align:right; }
    .no-chats { text-align:center; padding:60px 20px; color:var(--ap-muted); }
    .no-chats i { font-size:2.5rem; opacity:.3; display:block; margin-bottom:10px; }
    .stat-bar { display:flex; gap:14px; flex-wrap:wrap; margin-bottom:22px; }
    .stat-pill { background:#fff;border:1px solid var(--ap-border);border-radius:999px;padding:8px 18px;font-size:.85rem;font-weight:600;display:flex;align-items:center;gap:8px; }
    .stat-pill .val { font-size:1.1rem; font-weight:800; color:var(--ap-accent); }
  </style>
</head>
<body class="ap-page">
<div class="layout">
  <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>
  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
      </div>
    </div>
    <div class="ap-main-inner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <i class="fas fa-chevron-right"></i>
        <a href="${pageContext.request.contextPath}/admin/pending-proposals">Proposals</a>
        <i class="fas fa-chevron-right"></i>
        <span>Chat Transcripts</span>
      </nav>

      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h1 style="font-size:1.5rem; font-weight:800; color:#1E293B; margin:0;">
            <i class="fas fa-comments me-2" style="color:#F43F5E;"></i>Proposal Chat Transcripts
          </h1>
          <p style="font-size:.85rem; color:var(--ap-muted); margin:4px 0 0;">Admin view of all investor and entrepreneur conversations.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-proposals" class="ap-btn ap-btn-secondary">
          <i class="fas fa-arrow-left me-1"></i> Back to Proposals
        </a>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-success border-0 rounded-3 mb-3">${message}</div>
      </c:if>

      <div class="stat-bar">
        <div class="stat-pill"><i class="fas fa-comments" style="color:#F43F5E;"></i><span>Total Messages:</span> <span class="val">${totalChats}</span></div>
        <div class="stat-pill"><i class="fas fa-users" style="color:#3B82F6;"></i><span>Active Conversations:</span> <span class="val">${fn:length(chatPairs)}</span></div>
      </div>

      <c:choose>
        <c:when test="${not empty chatPairs}">
          <c:forEach var="pair" items="${chatPairs}" varStatus="st">
            <div class="chat-card" id="chatcard-${st.index}">
              <div class="chat-card-header" onclick="toggleChat(${st.index}, ${pair.proposal.id}, ${pair.investor.id})" id="chatheader-${st.index}">
                <div class="chat-avatar">
                  <c:choose>
                    <c:when test="${not empty pair.investor.fullName}">${fn:substring(pair.investor.fullName,0,1)}</c:when>
                    <c:otherwise>I</c:otherwise>
                  </c:choose>
                </div>
                <div class="chat-meta">
                  <div class="chat-name">
                    <i class="fas fa-user-tie me-1" style="color:#3B82F6;font-size:.8rem;"></i><c:out value="${pair.investor.fullName}"/> (Investor)
                    <span style="color:#94A3B8;font-weight:400;font-size:.78rem;"> vs </span>
                    <i class="fas fa-lightbulb me-1" style="color:#F59E0B;font-size:.8rem;"></i><c:out value="${pair.entrepreneur.fullName}"/> (Entrepreneur)
                  </div>
                  <div class="chat-sub">Proposal: <strong><c:out value="${pair.proposal.title}"/></strong> - Last: <c:out value="${pair.lastTime}"/></div>
                </div>
                <span class="chat-badge"><i class="fas fa-comment me-1"></i>${pair.messageCount} msgs</span>
                <span style="color:var(--ap-muted);font-size:.85rem;flex-shrink:0;" id="chattoggle-${st.index}"><i class="fas fa-chevron-down"></i></span>
              </div>
              <div class="chat-body" id="chatbody-${st.index}">
                <div class="text-center text-muted py-3" id="chatloading-${st.index}"><i class="fas fa-spinner fa-spin me-2"></i>Loading...</div>
                <div id="chatmsgs-${st.index}"></div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="no-chats">
            <i class="fas fa-comment-slash"></i>
            <h5 style="font-weight:700; color:#1E293B;">No Chats Yet</h5>
            <p>No conversations between investors and entrepreneurs have started yet.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>
<script>
  var ctxPath = '${pageContext.request.contextPath}';
  var csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
  var openPanels = {};
  function toggleChat(idx, proposalId, investorId) {
    var body = document.getElementById('chatbody-' + idx);
    var header = document.getElementById('chatheader-' + idx);
    var toggle = document.getElementById('chattoggle-' + idx);
    var isOpen = body.classList.contains('open');
    if (isOpen) { body.classList.remove('open'); header.classList.remove('open'); toggle.innerHTML = '<i class="fas fa-chevron-down"></i>'; }
    else { body.classList.add('open'); header.classList.add('open'); toggle.innerHTML = '<i class="fas fa-chevron-up"></i>'; if (!openPanels[idx]) { loadChatHistory(idx, proposalId, investorId); openPanels[idx] = true; } }
  }
  function loadChatHistory(idx, proposalId, investorId) {
    var loading = document.getElementById('chatloading-' + idx);
    var msgs = document.getElementById('chatmsgs-' + idx);
    fetch(ctxPath + '/admin/chats/history?proposalId=' + proposalId + '&investorId=' + investorId, { headers: { 'X-CSRF-TOKEN': csrfToken } })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      loading.style.display = 'none';
      if (!data || data.length === 0) { msgs.innerHTML = '<div class="text-center text-muted py-2 small">No messages yet.</div>'; return; }
      var html = '';
      data.forEach(function(m) {
        var side = m.role === 'INVESTOR' ? 'investor' : 'entrepreneur';
        var icon = m.role === 'INVESTOR' ? '<i class="fas fa-user-tie" style="color:#3B82F6;"></i>' : '<i class="fas fa-lightbulb" style="color:#F59E0B;"></i>';
        html += '<div class="msg ' + side + '"><div><div class="msg-bubble">' + escHtml(m.message) + '</div><div class="msg-time">' + icon + ' ' + escHtml(m.sender) + ' - ' + escHtml(m.timestamp) + '</div></div></div>';
      });
      msgs.innerHTML = html;
    })
    .catch(function() { loading.innerHTML = '<span class="text-danger small">Failed to load. Try again.</span>'; });
  }
  function escHtml(s) { if (!s) return ''; return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  var sidebarToggle = document.getElementById('sidebarToggle');
  if (sidebarToggle) { sidebarToggle.addEventListener('click', function() { document.querySelector('.ap-sidebar') && document.querySelector('.ap-sidebar').classList.toggle('open'); }); }
</script>
</body>
</html>
