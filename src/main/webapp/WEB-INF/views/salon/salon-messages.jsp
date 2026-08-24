<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - Fight D Fear</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--light-bg, #f8f9fa);
        }
        
        .chat-container {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 30px;
            height: 70vh;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .chat-bubble {
            max-width: 75%;
            padding: 15px 20px;
            border-radius: 20px;
            position: relative;
        }

        .chat-bubble-received {
            background-color: #f1f3f5;
            color: #333;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
        }

        .chat-bubble-sent {
            background: linear-gradient(135deg, var(--primary-color, #ff4d4d) 0%, var(--secondary-color, #ff1a1a) 100%);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
        }

        .chat-meta {
            font-size: 0.75rem;
            margin-top: 5px;
            opacity: 0.8;
            display: flex;
            justify-content: space-between;
        }
        
        .sender-name {
            font-weight: 700;
            font-size: 0.85rem;
            margin-bottom: 5px;
        }
        
        /* Sidebar layout adjustment */
        :root { --sidebar-width: 280px; }
        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        
        .main-content {
            padding: 25px;
            margin-left: var(--sidebar-width);
        }
    
        /* Unified Premium Sidebar */
        .sidebar {
            background: linear-gradient(180deg, var(--fdf-burgundy) 0%, var(--fdf-burgundy-dark) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-brand-wrapper {
            padding: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            margin-bottom: 20px;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.15rem;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sidebar-brand i {
            color: var(--fdf-pink);
            font-size: 1.5rem;
        }

        .sidebar-brand-wrapper .subtitle {
            font-size: 0.72rem;
            color: rgba(255,255,255,0.4);
            margin-top: 4px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .nav-container {
            flex: 1;
            padding: 0 16px;
            overflow-y: auto;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 16px;
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 4px;
            transition: all 0.2s ease;
            font-weight: 500;
            font-size: 0.88rem;
        }

        .nav-link-custom:hover {
            background: rgba(255,255,255,0.05);
            color: white;
            transform: translateX(4px);
        }

        .nav-link-custom.active {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(219, 39, 119, 0.25);
            font-weight: 600;
        }

        .nav-link-custom i {
            font-size: 1.15rem;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="sidebar-brand-wrapper">
            <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
                <i class="bi bi-gender-female"></i>
                <span>${empty salon.name ? 'Priya Beauty & Wellness' : salon.name}</span>
            </a>
            <div class="subtitle">Women's Salon • Beauty • Wellness • Hair Styling</div>
        </div>

        <div class="nav-container">
            <nav class="nav flex-column">
                <a class="nav-link-custom" active" href="${pageContext.request.contextPath}/salons/dashboard">
                    <i class="bi bi-grid-1x2"></i>
                    <span>Dashboard</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Salon Profile</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                    <i class="bi bi-calendar-check"></i>
                    <span>Appointments</span>
                </a>
                <a class="nav-link-custom" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal">
                    <i class="bi bi-calendar3"></i>
                    <span>Calendar</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                    <i class="bi bi-magic"></i>
                    <span>Services</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists">
                    <i class="bi bi-people"></i>
                    <span>Staff / Stylists</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients">
                    <i class="bi bi-people-fill"></i>
                    <span>Clients</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages">
                    <i class="bi bi-box-seam"></i>
                    <span>Packages & Memberships</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
                    <i class="bi bi-percent"></i>
                    <span>Offers & Discounts</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/billing">
                    <i class="bi bi-receipt"></i>
                    <span>Billing & Invoices</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/payments">
                    <i class="bi bi-credit-card-2-front"></i>
                    <span>Payments & Payouts</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/inventory">
                    <i class="bi bi-box"></i>
                    <span>Inventory</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                    <i class="bi bi-star-half"></i>
                    <span>Reviews & Feedback</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/analytics">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports & Analytics</span>
                </a>

                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/settings">
                    <i class="bi bi-sliders"></i>
                    <span>Settings</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/support">
                    <i class="bi bi-question-circle"></i>
                    <span>Help & Support</span>
                </a>
                <a class="nav-link-custom text-danger mt-3" href="${pageContext.request.contextPath}/salons/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </nav>
        </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Messages</h2>
                <p class="text-muted mb-0">Your conversations with clients and administrators.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/salons/dashboard" class="btn btn-outline-secondary rounded-pill px-4">
                    <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <div class="row g-3 h-100" style="min-height: 70vh;">
            <!-- Left panel: Conversations list -->
            <div class="col-lg-4 col-md-5">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                        <h5 class="fw-bold mb-3">Conversations</h5>
                        <input type="text" class="form-control rounded-pill bg-light border-0 mb-3" id="searchUser" placeholder="Search client...">
                    </div>
                    <div class="card-body p-0" style="overflow-y: auto;" id="userList">
                        <!-- User list dynamically populated -->
                    </div>
                </div>
            </div>

            <!-- Right panel: Active chat -->
            <div class="col-lg-8 col-md-7 d-flex flex-column">
                <div class="card border-0 shadow-sm rounded-4 flex-grow-1 d-flex flex-column">
                    <div class="card-header bg-white border-bottom p-3 d-flex align-items-center" id="chatHeader" style="display: none !important;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width:40px; height:40px;" id="activeUserAvatar">
                                ?
                            </div>
                            <div>
                                <h6 class="mb-0 fw-bold" id="activeUserName">Select a conversation</h6>
                                <small class="text-muted" style="font-size: 0.75rem;">Client</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="chat-container flex-grow-1 p-4" id="chatMessages" style="background: #f8f9fa;">
                        <div class="text-center py-5 m-auto" id="noChatSelected">
                            <i class="bi bi-chat-dots text-muted" style="font-size: 4rem;"></i>
                            <h4 class="mt-3 fw-bold text-secondary">No Conversation Selected</h4>
                            <p class="text-muted">Choose a client from the left to start chatting.</p>
                        </div>
                    </div>
                    
                    <div class="card-footer bg-white border-top p-3" id="chatInputArea" style="display: none !important;">
                        <form id="chatForm" class="d-flex gap-2">
                            <input type="text" class="form-control border-0 bg-light rounded-pill px-4 py-2" id="chatInput" placeholder="Type a message to reply..." required autocomplete="off">
                            <button type="submit" class="btn btn-primary rounded-circle" style="width:45px; height:45px;"><i class="bi bi-send-fill"></i></button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Load SockJS and STOMP -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const salonId = ${sessionScope.loggedSalon.id};
        let stompClient = null;
        let isConnected = false;
        let allMessages = [];
        let groupedChats = {}; // userId -> { user: {}, messages: [] }
        let activeUserId = null;

        // Fetch initial messages and set up websockets
        window.onload = function() {
            fetchChatHistory();
            connectWebSocket();
        };

        function connectWebSocket() {
            const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;
            stompClient.connect({}, function (frame) {
                isConnected = true;
                stompClient.subscribe('/topic/salon/chat/' + salonId, function (message) {
                    const msg = JSON.parse(message.body);
                    handleNewMessage(msg);
                });
            });
        }

        function fetchChatHistory() {
            fetch('${pageContext.request.contextPath}/api/salon/chat')
                .then(response => response.json())
                .then(messages => {
                    allMessages = messages;
                    groupMessages();
                    renderUserList();
                    if(activeUserId) {
                        renderActiveChat();
                    }
                });
        }

        function groupMessages() {
            groupedChats = {};
            allMessages.forEach(msg => {
                // Determine user info from DTO
                const uid = msg.userId;
                if (!uid) return; // Ignore msgs without user for now
                
                if (!groupedChats[uid]) {
                    groupedChats[uid] = {
                        user: { id: uid, fullName: msg.userName, email: msg.userEmail },
                        messages: []
                    };
                }
                groupedChats[uid].messages.push(msg);
            });
        }

        function handleNewMessage(msg) {
            const uid = msg.userId;
            if (uid) {
                if (!groupedChats[uid]) {
                    groupedChats[uid] = {
                        user: { id: uid, fullName: msg.userName || 'User ' + uid, email: msg.userEmail },
                        messages: []
                    };
                }
                groupedChats[uid].messages.push(msg);
                renderUserList();
                if (activeUserId === uid) {
                    renderActiveChat();
                }
            }
        }

        function parseDate(timestamp) {
            if (Array.isArray(timestamp)) {
                return new Date(timestamp[0], timestamp[1] - 1, timestamp[2], timestamp[3], timestamp[4], timestamp[5] || 0);
            }
            return new Date(timestamp || Date.now());
        }

        function renderUserList() {
            const list = document.getElementById('userList');
            list.innerHTML = '';
            const search = document.getElementById('searchUser').value.toLowerCase();
            
            // Sort by most recent message
            const sortedUsers = Object.values(groupedChats).sort((a, b) => {
                const lastA = parseDate(a.messages[a.messages.length - 1].timestamp);
                const lastB = parseDate(b.messages[b.messages.length - 1].timestamp);
                return lastB - lastA;
            });

            sortedUsers.forEach(chat => {
                const u = chat.user;
                const displayName = u.fullName || u.username || u.email || 'Unknown Client';
                if (search && !displayName.toLowerCase().includes(search)) return;

                const lastMsg = chat.messages[chat.messages.length - 1];
                const time = parseDate(lastMsg.timestamp);
                
                let timeStr = "";
                if (!isNaN(time.getTime())) {
                    timeStr = time.getHours().toString().padStart(2, '0') + ':' + time.getMinutes().toString().padStart(2, '0');
                } else {
                    timeStr = "now";
                }
                const isSelected = activeUserId === u.id;
                
                const div = document.createElement('div');
                div.className = 'd-flex align-items-center p-3 border-bottom' + (isSelected ? ' bg-light' : '');
                div.style.cursor = 'pointer';
                div.onclick = () => selectUser(u.id);

                div.innerHTML = `
                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold me-3" style="width:40px; height:40px; min-width:40px;">
                        \${displayName.charAt(0).toUpperCase()}
                    </div>
                    <div class="flex-grow-1 overflow-hidden">
                        <div class="d-flex justify-content-between mb-1">
                            <h6 class="mb-0 fw-bold text-truncate">\${displayName}</h6>
                            <small class="text-muted" style="font-size:0.7rem;">\${timeStr}</small>
                        </div>
                        <p class="mb-0 text-muted small text-truncate">\${lastMsg.senderRole === 'SALON' ? 'You: ' : ''}\${lastMsg.message || ''}</p>
                    </div>
                `;
                list.appendChild(div);
            });
        }

        function selectUser(userId) {
            activeUserId = userId;
            document.getElementById('chatHeader').style.setProperty('display', 'flex', 'important');
            document.getElementById('chatInputArea').style.setProperty('display', 'block', 'important');
            document.getElementById('noChatSelected').style.display = 'none';
            
            const u = groupedChats[userId].user;
            const displayName = u.fullName || u.username || u.email || 'Unknown Client';
            document.getElementById('activeUserName').textContent = displayName;
            document.getElementById('activeUserAvatar').textContent = displayName.charAt(0).toUpperCase();

            renderUserList(); // Update highlight
            renderActiveChat();
        }

        function renderActiveChat() {
            if (!activeUserId || !groupedChats[activeUserId]) return;
            
            const container = document.getElementById('chatMessages');
            container.innerHTML = '';
            
            groupedChats[activeUserId].messages.forEach(msg => {
                const isMine = msg.senderRole === 'SALON';
                
                const div = document.createElement('div');
                div.className = 'mb-3 ' + (isMine ? 'text-end' : 'text-start');
                
                const bubble = document.createElement('div');
                bubble.className = 'chat-bubble shadow-sm ' + (isMine ? 'chat-bubble-sent' : 'chat-bubble-received');
                
                const time = parseDate(msg.timestamp);
                let timeStr = "";
                if (!isNaN(time.getTime())) {
                    timeStr = time.getHours().toString().padStart(2, '0') + ':' + time.getMinutes().toString().padStart(2, '0');
                } else {
                    timeStr = "now";
                }
                
                bubble.innerHTML = `
                    <div class="message-text">\${msg.message || ''}</div>
                    <div class="chat-meta mt-1 \${isMine ? 'text-end' : ''}" style="color: \${isMine ? 'rgba(255,255,255,0.8)' : 'rgba(0,0,0,0.5)'}">
                        <span>\${timeStr} \${isMine ? '<i class="bi bi-check2"></i>' : ''}</span>
                    </div>
                `;
                
                div.appendChild(bubble);
                container.appendChild(div);
            });
            
            container.scrollTop = container.scrollHeight;
        }

        document.getElementById('searchUser').addEventListener('input', renderUserList);

        document.getElementById('chatForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if (message && isConnected && activeUserId) {
                const payload = {
                    salonId: salonId,
                    userId: activeUserId,
                    senderRole: 'SALON',
                    message: message
                };
                stompClient.send("/app/salon/chat", {}, JSON.stringify(payload));
                input.value = '';
            }
        });
    </script>
</body>
</html>

