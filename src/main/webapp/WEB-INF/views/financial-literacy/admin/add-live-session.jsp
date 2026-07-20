<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Live Session - Financial Literacy</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-purple: #7C2D5E;
            --primary-purple-light: #a64281;
            --primary-coral: #DB2777;
            --primary-gold: #ffd700;
            --dark-bg: #0f0f1a;
            --light-bg: #fffcfd;
            --light-gray: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: var(--light-bg);
        }

        /* Topbar */
        .topbar {
            background: var(--primary-purple);
            color: white;
            padding: 14px 18px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .topbar .wrap {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Layout */
        .layout {
            display: flex;
            min-height: calc(100vh - 56px);
        }

        .sidebar {
            width: 272px;
            background: #fff;
            border-right: 1px solid rgba(124, 45, 94, 0.18);
            padding: 14px 12px;
            height: calc(100vh - 56px);
            position: sticky;
            top: 56px;
            overflow-y: auto;
            flex-shrink: 0;
        }

        .navlink {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            border-radius: 12px;
            color: #4b5563;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.2s;
            margin-bottom: 2px;
        }

        .navlink:hover {
            background: rgba(124, 45, 94, 0.1);
            color: var(--primary-purple);
        }

        .navlink.active {
            background: var(--primary-purple);
            color: white;
        }

        .main {
            flex: 1;
            padding: 28px 16px 36px;
        }

        .mainInner {
            max-width: 700px;
            margin: 0 auto;
        }

        /* Section Card */
        .admin-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(124, 45, 94, 0.1);
        }

        .admin-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--primary-purple);
            margin-bottom: 24px;
        }

        .form-label {
            font-weight: 600;
            color: var(--primary-purple);
        }

        .btn-purple {
            background: var(--primary-purple);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s;
            width: 100%;
        }

        .btn-purple:hover {
            background: var(--primary-purple-light);
            transform: translateY(-2px);
            color: white;
        }
    </style>
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container">
            <div class="wrap">
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="text-decoration-none text-white" style="font-weight: 700;">
                        <i class="fas fa-arrow-left me-2"></i> Back
                    </a>
                </div>
                <h5 class="mb-0">Add Live Session</h5>
            </div>
        </div>
    </div>

    <!-- Layout -->
    <div class="layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="navlink">
                    <i class="fas fa-home"></i> Home
                </a>
            </div>
            
            <h6 class="mb-2" style="font-weight:700; color: #666; font-size: 0.8rem;">Videos</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="navlink">
                <i class="fas fa-plus-circle"></i> Add Video
            </a>
            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Live Sessions</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="navlink active">
                <i class="fas fa-video"></i> Add Session
            </a>
            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Workshops</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="navlink">
                <i class="fas fa-calendar-check"></i> Add Workshop
            </a>
        </div>

        <!-- Main Content -->
        <main class="main">
            <div class="mainInner">
                
                <div class="admin-card">
                    <h3>Add New Live Session</h3>
                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" method="POST">
                        <div class="mb-3">
                            <label for="title" class="form-label">Session Title</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="speaker" class="form-label">Speaker Name</label>
                            <input type="text" class="form-control" id="speaker" name="speaker" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="text" class="form-control" id="date" name="date" placeholder="Saturday, 15th July" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="time" class="form-label">Time</label>
                            <input type="text" class="form-control" id="time" name="time" placeholder="6:00 PM" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="meetingUrl" class="form-label">Meeting Link</label>
                            <input type="text" class="form-control" id="meetingUrl" name="meetingUrl" placeholder="https://zoom.us/j/..." required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="seats" class="form-label">Number of Seats</label>
                            <input type="number" class="form-control" id="seats" name="seats" min="1" required>
                        </div>
                        
                        <div class="mb-4">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                        </div>
                        
                        <button type="submit" class="btn-purple">
                            <i class="fas fa-upload me-2"></i> Publish
                        </button>
                    </form>
                </div>

            </div>
        </main>
    </div>

</body>
</html>