<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Funding Hub</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --f-purple: #7C2D5E;
            --f-pink: #DB2777;
            --f-gold: #FFD700;
            --f-bg: #fffcfd;
            --f-shadow: 0 15px 35px rgba(124, 45, 94, 0.1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--f-bg);
            color: #333;
            min-height: 100vh;
        }

        /* Hero Header */
        .funding-hero {
            background: linear-gradient(135deg, var(--f-purple) 0%, var(--f-pink) 100%);
            padding: 80px 0 120px;
            color: white;
            text-align: center;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
            position: relative;
            overflow: hidden;
        }

        .funding-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png');
            opacity: 0.1;
        }

        .funding-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 3.5rem;
            margin-bottom: 20px;
            letter-spacing: -1px;
        }

        .funding-hero p {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Search Box */
        .search-wrapper {
            max-width: 700px;
            margin: -40px auto 60px;
            position: relative;
            z-index: 10;
        }

        .funding-search {
            background: white;
            padding: 10px;
            border-radius: 50px;
            display: flex;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .funding-search input {
            border: none;
            flex: 1;
            padding: 10px 25px;
            font-size: 1.1rem;
            border-radius: 50px;
            outline: none !important;
        }

        .funding-search button {
            background: var(--f-pink);
            border: none;
            color: white;
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 700;
            transition: 0.3s;
        }

        .funding-search button:hover {
            transform: scale(1.05);
            background: var(--f-purple);
        }

        /* Category Grid */
        .category-card {
            background: white;
            border-radius: 24px;
            padding: 40px 30px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(124, 45, 94, 0.05);
            box-shadow: var(--f-shadow);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
            text-decoration: none !important;
            cursor: pointer;
        }

        .category-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 6px;
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            transform: scaleX(0);
            transition: 0.4s;
            transform-origin: left;
        }

        .category-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 60px rgba(124, 45, 94, 0.2);
            border-color: var(--f-pink);
        }

        .category-card:hover::after {
            transform: scaleX(1);
        }

        .cat-icon {
            font-size: 3.5rem;
            margin-bottom: 25px;
            display: block;
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .category-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--f-purple);
            margin-bottom: 15px;
        }

        .category-card p {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 0;
        }

        /* Scheme Card */
        .scheme-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            transition: all 0.4s;
            box-shadow: var(--f-shadow);
            border: 1px solid rgba(124, 45, 94, 0.05);
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none !important;
        }

        .scheme-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(124, 45, 94, 0.2);
        }

        .scheme-badge {
            background: var(--f-gold);
            color: #333;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            width: fit-content;
            margin-bottom: 15px;
        }

        .scheme-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--f-purple);
            margin-bottom: 15px;
        }

        .scheme-card p {
            color: #666;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .scheme-card .btn-view {
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 700;
            transition: 0.3s;
        }

        .scheme-card .btn-view:hover {
            transform: scale(1.05);
        }

        /* Section Title */
        .section-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-header h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 2.2rem;
            color: var(--f-purple);
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }

        .section-header h2::after {
            content: '';
            position: absolute;
            bottom: 0; left: 25%; width: 50%; height: 4px;
            background: var(--f-pink);
            border-radius: 2px;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            top: 30px;
            left: 30px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0.8;
            transition: 0.3s;
            z-index: 100;
        }

        .back-btn:hover {
            opacity: 1;
            transform: translateX(-5px);
        }

        @media (max-width: 768px) {
            .funding-hero h1 { font-size: 2.2rem; }
            .funding-hero { 
                padding: 60px 15px 100px; 
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
            }
            .funding-search {
                flex-direction: column;
                border-radius: 20px;
                padding: 15px;
                gap: 10px;
            }
            .funding-search input {
                padding: 12px 15px;
                text-align: center;
            }
            .funding-search button {
                width: 100%;
            }
            .search-wrapper {
                margin: -40px 15px 40px;
            }
        }

        /* 📱 Global Mobile Fixes */
        html, body {
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }
        .container {
            padding-left: 20px !important;
            padding-right: 20px !important;
        }
        .row {
            margin-left: 0 !important;
            margin-right: 0 !important;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <header class="funding-hero">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        <div class="container">
            <h1>Women Funding Hub</h1>
            <p>Find government schemes, startup funding, business grants, and financial support available for women.</p>
        </div>
    </header>

    <div class="search-wrapper container">
        <div class="funding-search">
            <input type="text" id="searchInput" placeholder="Search Funding Scheme...">
            <button id="searchButton">Find Scheme</button>
        </div>
    </div>

    <main class="container mb-5">
        <div class="section-header">
            <h2>Browse Categories</h2>
        </div>

        <div class="row g-4 mb-5" id="categoryGrid">
            <div class="col-md-6 col-lg-3" data-category="government">
                <div class="category-card">
                    <i class="cat-icon fas fa-landmark"></i>
                    <h3>Government Schemes</h3>
                    <p>Central and state government schemes for women entrepreneurs.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="startup">
                <div class="category-card">
                    <i class="cat-icon fas fa-rocket"></i>
                    <h3>Startup Funding</h3>
                    <p>Seed funding, angel investment, and venture capital for women-led startups.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="grant">
                <div class="category-card">
                    <i class="cat-icon fas fa-hand-holding-usd"></i>
                    <h3>Business Grants</h3>
                    <p>Free grants and subsidies for women-owned businesses.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="ngo">
                <div class="category-card">
                    <i class="cat-icon fas fa-hands-helping"></i>
                    <h3>NGO Funding</h3>
                    <p>Financial support from NGOs and non-profit organizations.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="msme">
                <div class="category-card">
                    <i class="cat-icon fas fa-industry"></i>
                    <h3>MSME Funding</h3>
                    <p>Loans and schemes for Micro, Small & Medium Enterprises.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="education">
                <div class="category-card">
                    <i class="cat-icon fas fa-graduation-cap"></i>
                    <h3>Education Funding</h3>
                    <p>Scholarships and educational loans for women.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="shg">
                <div class="category-card">
                    <i class="cat-icon fas fa-users"></i>
                    <h3>SHG Funding</h3>
                    <p>Self-Help Group loans and microfinance options.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="skill">
                <div class="category-card">
                    <i class="cat-icon fas fa-tools"></i>
                    <h3>Skill Development</h3>
                    <p>Funding for skill training and capacity building programs.</p>
                </div>
            </div>
        </div>

        <div class="section-header">
            <h2>Popular Funding Schemes</h2>
        </div>

        <div class="row g-4" id="schemeGrid">
            <div class="col-md-6 col-lg-3" data-scheme="pm-mudra">
                <a href="${pageContext.request.contextPath}/funding/details/pm-mudra" class="scheme-card">
                    <div class="scheme-badge">POPULAR</div>
                    <h3>PM Mudra Yojana</h3>
                    <p>Collateral-free loans up to ₹10 lakh for micro and small businesses.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="standup-india">
                <a href="${pageContext.request.contextPath}/funding/details/standup-india" class="scheme-card">
                    <div class="scheme-badge">GOVERNMENT</div>
                    <h3>Stand-Up India</h3>
                    <p>Bank loans for SC/ST and women entrepreneurs for setting up greenfield enterprises.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="mahila-samriddhi">
                <a href="${pageContext.request.contextPath}/funding/details/mahila-samriddhi" class="scheme-card">
                    <div class="scheme-badge">SCHEME</div>
                    <h3>Mahila Samriddhi Yojana</h3>
                    <p>Scheme for economic empowerment of women through micro-enterprises.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="pmegp">
                <a href="${pageContext.request.contextPath}/funding/details/pmegp" class="scheme-card">
                    <div class="scheme-badge">MSME</div>
                    <h3>PMEGP</h3>
                    <p>Credit linked subsidy for setting up micro-enterprises in non-farm sector.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="annapurna">
                <a href="${pageContext.request.contextPath}/funding/details/annapurna" class="scheme-card">
                    <div class="scheme-badge">SCHEME</div>
                    <h3>Annapurna Scheme</h3>
                    <p>Loan scheme for women entrepreneurs in food business (catering, tiffin services).</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="udyogini">
                <a href="${pageContext.request.contextPath}/funding/details/udyogini" class="scheme-card">
                    <div class="scheme-badge">GOVERNMENT</div>
                    <h3>Udyogini Scheme</h3>
                    <p>Financial support for women entrepreneurs to start small businesses.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="stree-shakti">
                <a href="${pageContext.request.contextPath}/funding/details/stree-shakti" class="scheme-card">
                    <div class="scheme-badge">POPULAR</div>
                    <h3>Stree Shakti Package</h3>
                    <p>Special package for women entrepreneurs with concession in interest rate.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-scheme="bmb">
                <a href="${pageContext.request.contextPath}/funding/details/bmb" class="scheme-card">
                    <div class="scheme-badge">SCHEME</div>
                    <h3>Bharatiya Mahila Bank</h3>
                    <p>Exclusive loan schemes for women from Bharatiya Mahila Bank.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            const searchButton = document.getElementById('searchButton');
            const categoryCards = document.querySelectorAll('.category-card');
            const schemeCards = document.querySelectorAll('.scheme-card');
            const categoryCols = document.querySelectorAll('#categoryGrid > div');
            const schemeCols = document.querySelectorAll('#schemeGrid > div');

            function performSearch() {
                const query = searchInput.value.trim().toLowerCase();
                
                categoryCols.forEach(col => {
                    const card = col.querySelector('.category-card');
                    const title = card.querySelector('h3').innerText.toLowerCase();
                    const desc = card.querySelector('p').innerText.toLowerCase();

                    if (title.includes(query) || desc.includes(query)) {
                        col.style.display = 'block';
                    } else {
                        col.style.display = 'none';
                    }
                });

                schemeCols.forEach(col => {
                    const card = col.querySelector('.scheme-card');
                    const title = card.querySelector('h3').innerText.toLowerCase();
                    const desc = card.querySelector('p').innerText.toLowerCase();

                    if (title.includes(query) || desc.includes(query)) {
                        col.style.display = 'block';
                    } else {
                        col.style.display = 'none';
                    }
                });
            }

            searchInput.addEventListener('input', performSearch);

            searchButton.addEventListener('click', performSearch);

            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        });
    </script>
</body>
</html>
