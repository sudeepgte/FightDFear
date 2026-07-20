<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Manage Q&A — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon:        #1e1b4b;
    --maroon-light:  #312e81;
    --maroon-dark:   #0b0920;
    --maroon-pale:   #f8fafc;
    --maroon-border: rgba(30, 27, 75, 0.12);
    --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; }

  /* ── TOPBAR ── */
  .topbar {
    background: var(--maroon); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    box-shadow: 0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff;
    border:1px solid rgba(255,255,255,0.3); border-radius:7px;
    padding:5px 16px; font-size:0.85rem; font-weight:600;
    text-decoration:none; transition:background 0.2s;
  }

  /* ── LAYOUT ── */
  .layout { display:flex; min-height:calc(100vh - 58px); }

  /* ── SIDEBAR ── */
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
  }
  .sidebar .brand-label { font-weight:700; color:var(--maroon); font-size:0.95rem; margin-bottom:10px; padding:0 6px; }
  .sidebar .sec-title { margin:14px 8px 6px; font-size:0.72rem; font-weight:700; color:#9ca3af; text-transform:uppercase; letter-spacing:0.06em; }
  .sidebar a.nl {
    display:flex; align-items:center; gap:9px;
    padding:9px 10px; border-radius:9px;
    color:#374151; text-decoration:none; font-weight:500; font-size:0.88rem;
    transition:all 0.18s;
  }
  .sidebar a.nl i { width:18px; text-align:center; color:var(--maroon); font-size:0.9rem; }
  .sidebar a.nl:hover { background:rgba(125,42,90,0.08); padding-left:14px; color:#1a1a2e; }
  .sidebar a.nl.active { background:rgba(125,42,90,0.12); color:var(--maroon); font-weight:700; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:1200px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
  @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

  /* ── PAGE HEADER ── */
  .pg-header {
    background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 28px rgba(125,42,90,0.22);
    display:flex; align-items:center; justify-content:space-between;
  }
  .pg-header h4 { color:#fff; font-weight:700; font-size:1.2rem; margin:0; }
  .pg-header p { color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.85rem; }

  /* ── QnA CARDS ── */
  .question-card {
      background-color: #fff;
      border-radius: 12px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--maroon-border);
      margin-bottom: 20px;
      padding: 20px;
      transition: box-shadow 0.2s, transform 0.2s;
  }
  .question-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 30px rgba(125,42,90,0.15);
  }

  .question-header {
      font-weight: 700;
      font-size: 1.05rem;
      color: var(--maroon-dark);
      margin-bottom: 6px;
  }

  .meta {
      font-size: 0.85rem;
      color: #6b7280;
      margin-bottom: 12px;
  }

  .answer-preview {
      background: var(--maroon-pale);
      border-left: 4px solid var(--maroon-light);
      padding: 12px 16px;
      border-radius: 6px;
      margin-bottom: 15px;
      font-size: 0.95rem;
      color: #374151;
  }

  textarea {
      width: 100%;
      min-height: 80px;
      border-radius: 8px;
      border: 1px solid var(--maroon-border);
      padding: 12px;
      font-size: 0.95rem;
      display: block;
      margin-top: 10px;
      font-family: inherit;
      transition: all 0.2s;
  }
  textarea:focus {
      border-color: var(--maroon-light);
      outline: none;
      box-shadow: 0 0 0 3px rgba(125,42,90,0.15);
  }

  .btn-custom {
      background-color: var(--maroon);
      color: white;
      padding: 8px 16px;
      border: none;
      border-radius: 8px;
      margin-top: 10px;
      cursor: pointer;
      font-weight: 600;
      font-size: 0.85rem;
      box-shadow: var(--shadow-sm);
      transition: all 0.2s;
  }
  .btn-custom:hover {
      background-color: var(--maroon-light);
      transform: translateY(-1px);
      color: white;
  }

  .btn-delete {
      background-color: transparent;
      color: #b91c1c;
      border: 1px solid #fca5a5;
      padding: 8px 16px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 0.85rem;
      margin-left: 10px;
      margin-top: 10px;
      transition: all 0.2s;
  }
  .btn-delete:hover {
      background-color: #fef2f2;
      border-color: #b91c1c;
      transform: translateY(-1px);
  }

  .toggle-section {
      display: none;
      margin-top: 15px;
  }

  .action-bar {
      display: flex;
      align-items: center;
      margin-top: 15px;
  }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--maroon-border);}
  }
</style>
<script>
    function toggleAnswerForm(id) {
        const section = document.getElementById("form-" + id);
        section.style.display = section.style.display === "none" ? "block" : "none";
    }
</script>
</head>
<body>

<div class="topbar">
  <span class="brand">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <aside class="sidebar">
    <div class="brand-label">Admin Menu</div>
    <div class="sec-title">Dashboard</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/adminDashboard"><i class="fas fa-home"></i> Home</a>

    <div class="sec-title">Moderation</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/sos"><i class="fas fa-broadcast-tower"></i> SOS Monitoring</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/reported-videos"><i class="fas fa-flag"></i> Reported Videos</a>
    <a class="nl active" href="${pageContext.request.contextPath}/qna/admin/questions"><i class="fas fa-question-circle"></i> Q&amp;A Panel</a>

    <div class="sec-title">Approvals</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/martialManagement"><i class="fas fa-dumbbell"></i> Martial Arts Centres</a>
    <a class="nl" href="${pageContext.request.contextPath}/admin/pending-suggestions"><i class="fas fa-users"></i> Volunteer Suggestions</a>
    <a class="nl" href="${pageContext.request.contextPath}/video/videoManagement"><i class="fas fa-video"></i> Video Library</a>

    <div class="sec-title">Account</div>
    <a class="nl" href="${pageContext.request.contextPath}/admin/profile/${admin.id}"><i class="fas fa-user"></i> Profile</a>
  </aside>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-comments me-2"></i>Q&amp;A Panel</h4>
          <p>Manage community questions and provide official answers</p>
        </div>
      </div>

      <c:choose>
        <c:when test="${not empty questions}">
          <c:forEach var="q" items="${questions}">
              <div class="question-card">
                  <div class="question-header">Q: ${q.content}</div>
                  <div class="meta">
                    <i class="fas fa-user-circle me-1"></i> ${q.displayName} 
                    <span class="mx-2">•</span> 
                    <i class="far fa-clock me-1"></i> ${formattedTimestamps[q.id]}
                  </div>

                  <c:if test="${not empty q.answer}">
                      <div class="answer-preview">
                          <strong class="text-maroon"><i class="fas fa-check-circle me-1"></i>Official Answer:</strong><br>
                          ${q.answer.content}
                      </div>
                  </c:if>

                  <div class="action-bar">
                      <button class="btn-custom" onclick="toggleAnswerForm('${q.id}')">
                          <i class="fas fa-pen me-1"></i> ${not empty q.answer ? 'Edit Answer' : 'Answer Question'}
                      </button>

                      <form action="${pageContext.request.contextPath}/qna/admin/qna/delete" method="post" style="display:inline;">
                          <input type="hidden" name="questionId" value="${q.id}" />
                          <button type="submit" class="btn-delete" onclick="return confirm('Are you sure you want to delete this question?');">
                            <i class="fas fa-trash-alt me-1"></i> Delete
                          </button>
                      </form>
                  </div>

                  <div class="toggle-section" id="form-${q.id}">
                      <form action="${pageContext.request.contextPath}/qna/admin/qna/answer" method="post">
                          <input type="hidden" name="questionId" value="${q.id}" />
                          <textarea name="content" required placeholder="Write your official answer here...">${q.answer.content}</textarea>
                          <button type="submit" class="btn-custom"><i class="fas fa-paper-plane me-1"></i> Post Answer</button>
                      </form>
                  </div>
              </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="py-5 text-center text-muted">
            <i class="fas fa-inbox fa-3x mb-3 d-block text-secondary" style="opacity:0.5;"></i>
            <p class="mb-0">No questions asked by the community yet.</p>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>

</body>
</html>

