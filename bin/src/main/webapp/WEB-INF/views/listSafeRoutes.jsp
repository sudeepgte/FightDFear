<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Safe Routes - Fight D Fear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
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
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
            padding: 40px 20px;
            color: var(--dark-bg);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 28px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .container:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .header {
            background: var(--gradient-primary);
            padding: 25px 30px;
            color: white;
        }
        .header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
        }
        .header p {
            margin: 8px 0 0;
            opacity: 0.9;
        }

        .table-wrapper {
            padding: 20px 30px 30px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        th {
            background-color: var(--primary-purple);
            color: white;
            padding: 14px 12px;
            text-align: left;
            font-weight: 600;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid rgba(123, 44, 191, 0.15);
            color: var(--dark-bg);
        }

        tr:hover td {
            background-color: rgba(123, 44, 191, 0.05);
        }

        .delete-link {
            display: inline-block;
            background-color: var(--primary-coral-dark);
            color: white;
            padding: 6px 14px;
            border-radius: 40px;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .delete-link:hover {
            background-color: var(--primary-coral);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        @media (max-width: 768px) {
            .header h2 { font-size: 1.4rem; }
            .table-wrapper { padding: 15px; }
            th, td { padding: 10px 8px; font-size: 0.85rem; }
            .delete-link { padding: 4px 10px; }
        }

        /* ============================================
           🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
           ============================================ */

        /* 1. Smooth fade-in animation for the whole container */
        .container {
            animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
        }
        @keyframes fadeSlideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 2. Table row hover effect – subtle scale and shadow (preserves original background) */
        tbody tr {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        tbody tr:hover {
            transform: scale(1.01);
            box-shadow: var(--shadow-sm);
        }

        /* 3. Delete button ripple effect on click (micro-interaction) */
        .delete-link {
            position: relative;
            overflow: hidden;
        }
        .delete-link::after {
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
        .delete-link:active::after {
            width: 200px;
            height: 200px;
        }

        /* 4. Focus outlines for accessibility (keyboard navigation) */
        .delete-link:focus-visible,
        th:focus-visible,
        td:focus-visible {
            outline: 3px solid var(--primary-gold);
            outline-offset: 2px;
            border-radius: 6px;
        }

        /* 5. Custom scrollbar (matches brand purple) */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
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

        /* 6. Header hover effect – subtle background brighten */
        .header {
            transition: filter 0.2s;
        }
        .header:hover {
            filter: brightness(1.02);
        }

        /* 7. Add a subtle border-bottom animation to table headers */
        th {
            position: relative;
        }
        th::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0%;
            height: 2px;
            background: var(--primary-gold);
            transition: width 0.3s ease;
        }
        th:hover::after {
            width: 100%;
        }

        /* 8. Responsive touch improvements for mobile */
        @media (max-width: 768px) {
            .delete-link {
                padding: 6px 12px;
                font-size: 0.75rem;
            }
            body {
                padding: 20px 15px;
            }
        }

        /* 9. Loading skeleton ready (optional – does nothing by default) */
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        .container.skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
            pointer-events: none;
        }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>🛡️ All Safe Routes</h2>
        <p>View and manage community‑verified safe paths</p>
    </div>
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="route" items="${routes}">
                    <tr>
                        <td>${route.id}</td>
                        <td>${route.fromLocation}</td>
                        <td>${route.toLocation}</td>
                        <td>${route.description}</td>
                        <td><a href="${pageContext.request.contextPath}/admin/saferoutes/delete/${route.id}" class="delete-link">Delete</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

