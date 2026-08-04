<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Marketplace | Services &amp; Training</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--brand-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--brand-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Search wrapper */
        .search-container {
            max-width: 600px;
            margin: 30px auto 10px;
            position: relative;
        }
        .search-box {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-radius: 50px;
            padding: 6px 10px 6px 20px;
            box-shadow: var(--shadow-sm);
        }
        .search-box input {
            border: none;
            outline: none;
            flex-grow: 1;
            font-size: 14px;
            color: var(--fdf-text);
        }
        .btn-search {
            background: var(--gradient-primary);
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 8px 24px;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-search:hover {
            filter: brightness(1.1);
        }

        /* Categories Grid */
        .market-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .category-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 30px 24px;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none !important;
        }
        .category-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .cat-icon-box {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #fff5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: var(--brand-pink);
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .category-card:hover .cat-icon-box {
            background: var(--gradient-primary);
            color: #fff;
        }
        .category-card h3 {
            font-size: 18px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 10px;
        }
        .category-card p {
            font-size: 13px;
            color: var(--fdf-muted);
            line-height: 1.5;
            margin-bottom: 0;
        }

        /* Call To Action Box */
        .cta-box {
            max-width: 750px;
            margin: 40px auto 60px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            padding: 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .cta-box h4 {
            font-size: 20px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 10px;
        }
        .cta-box p {
            font-size: 14px;
            color: var(--fdf-muted);
            margin-bottom: 24px;
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
            .market-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px 15px;
            }
            .cta-box { padding: 25px 15px; margin: 20px 15px 40px; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <h1>Women Marketplace</h1>
            <p>Empowering local women creators, educators, and service providers. Discover skilled professionals and browse custom services.</p>
            
            <!-- Search bar -->
            <div class="search-container">
                <div class="search-box">
                    <input type="text" placeholder="Search for tutors, designers, bakers...">
                    <button class="btn-search">Find Service</button>
                </div>
            </div>
        </div>

        <!-- Categories Grid -->
        <div class="market-grid">
            <c:forEach var="cat" items="${dynamicCategories}">
                <div class="col-12" style="display: contents;">
                    <a href="${pageContext.request.contextPath}/marketplace/workers?category=${cat}" class="category-card" data-aos="fade-up">
                        <div class="cat-icon-box">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h3>${cat}</h3>
                        <p>Find verified professional women specialists in ${cat}.</p>
                    </a>
                </div>
            </c:forEach>
            
            <c:if test="${empty dynamicCategories}">
                <div class="col-12 text-center py-5 text-muted">
                    <i class="bi bi-shop-window display-3 mb-3"></i>
                    <p class="fs-5">No verified worker categories available yet.</p>
                </div>
            </c:if>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.querySelector('.search-box input');
        const searchButton = document.querySelector('.search-box button');
        const categoryCards = document.querySelectorAll('.category-card');

        function performSearch() {
            const query = searchInput.value.trim().toLowerCase();
            
            categoryCards.forEach(card => {
                const title = card.querySelector('h3').innerText.toLowerCase();
                const desc = card.querySelector('p').innerText.toLowerCase();
                const parentCol = card.parentElement;

                if (title.includes(query) || desc.includes(query)) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        searchInput.addEventListener('input', performSearch);

        searchButton.addEventListener('click', function() {
            const query = searchInput.value.trim().toLowerCase();
            let matchUrl = null;
            categoryCards.forEach(card => {
                const title = card.querySelector('h3').innerText.toLowerCase();
                const desc = card.querySelector('p').innerText.toLowerCase();
                if (title.includes(query) || desc.includes(query)) {
                    if (!matchUrl) matchUrl = card.getAttribute('href');
                }
            });
            if (matchUrl) {
                window.location.href = matchUrl;
            } else {
                alert('No services matched your query.');
                categoryCards.forEach(card => card.style.display = 'flex');
            }
        });

        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchButton.click();
            }
        });
    });
</script>

</body>
</html>
