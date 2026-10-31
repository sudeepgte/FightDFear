import os, glob

files = [
    'src/main/webapp/WEB-INF/views/creatorMyProfile.jsp',
    'src/main/webapp/WEB-INF/views/creatorHubFeed.jsp',
    'src/main/webapp/WEB-INF/views/creatorHubChat.jsp',
    'src/main/webapp/WEB-INF/views/creatorHubCoins.jsp'
]

replacement = '''    <div class="nav-actions" style="gap: 8px;">
        <a href="${pageContext.request.contextPath}/creator-hub/profile" class="icon-btn" title="Profile" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-regular fa-user"></i> <span class="desktop-only">Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/feed" class="icon-btn" title="CreatorHub" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-clapperboard"></i> <span class="desktop-only">CreatorHub</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/chat" class="icon-btn" title="Chat" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-regular fa-comment-dots"></i> <span class="desktop-only">Chat</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/coins" class="icon-btn" title="Coins" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-coins"></i> <span class="desktop-only">Coins</span>
        </a>
        <div class="icon-btn" id="notifToggleBtn" onclick="toggleNotifPanel()" title="Notifications" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px; cursor:pointer;">
            <i class="fa-regular fa-bell"></i> <span class="desktop-only">Notifications</span>
            <c:if test="${unreadNotifCount > 0}">
                <span class="notif-badge">${unreadNotifCount}</span>
            </c:if>
        </div>
        <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="icon-btn" title="Settings" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-gear"></i> <span class="desktop-only">Settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="icon-btn" title="Logout" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px; color:var(--accent); border-color:var(--accent);">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> <span class="desktop-only">Logout</span>
        </a>
    </div>'''

import re

for f in files:
    if not os.path.exists(f): 
        print(f"Skipping {f}")
        continue
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Replace nav-actions block
    content = re.sub(r'<div class="nav-actions">.*?</nav>', replacement + '\n</nav>', content, flags=re.DOTALL)
    
    # Hide sidebar visually
    content = content.replace('class="left-sidebar desktop-sidebar"', 'class="left-sidebar desktop-sidebar" style="display:none;"')
    
    # Fix grid-template-columns
    content = content.replace('grid-template-columns: 240px 1fr 340px;', 'grid-template-columns: 1fr 340px;')
    content = content.replace('grid-template-columns: 240px 1fr 300px;', 'grid-template-columns: 1fr 300px;')
    content = content.replace('grid-template-columns: 250px 1fr 300px;', 'grid-template-columns: 1fr 300px;')
    content = content.replace('grid-template-columns: 240px 1fr;', 'grid-template-columns: 1fr;')
    
    with open(f, 'w', encoding='utf-8') as file:
        file.write(content)
    print(f'Updated {f}')
