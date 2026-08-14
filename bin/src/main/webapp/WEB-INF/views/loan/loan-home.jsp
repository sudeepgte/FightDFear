<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Loan Hub</title>
    
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
            --l-purple: #7C2D5E;
            --l-pink: #DB2777;
            --l-gold: #FFD700;
            --l-bg: #fffcfd;
            --l-shadow: 0 15px 35px rgba(124, 45, 94, 0.1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--l-bg);
            color: #333;
            min-height: 100vh;
        }

        /* Hero Header */
        .loan-hero {
            background: linear-gradient(135deg, var(--l-purple) 0%, var(--l-pink) 100%);
            padding: 80px 0 120px;
            color: white;
            text-align: center;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
            position: relative;
            overflow: hidden;
        }

        .loan-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png');
            opacity: 0.1;
        }

        .loan-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 3.5rem;
            margin-bottom: 20px;
            letter-spacing: -1px;
        }

        .loan-hero p {
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

        .loan-search {
            background: white;
            padding: 10px;
            border-radius: 50px;
            display: flex;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .loan-search input {
            border: none;
            flex: 1;
            padding: 10px 25px;
            font-size: 1.1rem;
            border-radius: 50px;
            outline: none !important;
        }

        .loan-search button {
            background: var(--l-pink);
            border: none;
            color: white;
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 700;
            transition: 0.3s;
        }

        .loan-search button:hover {
            transform: scale(1.05);
            background: var(--l-purple);
        }

        /* Category Grid */
        .category-card {
            background: white;
            border-radius: 24px;
            padding: 40px 30px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(124, 45, 94, 0.05);
            box-shadow: var(--l-shadow);
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
            background: linear-gradient(135deg, var(--l-purple), var(--l-pink));
            transform: scaleX(0);
            transition: 0.4s;
            transform-origin: left;
        }

        .category-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 60px rgba(124, 45, 94, 0.2);
            border-color: var(--l-pink);
        }

        .category-card:hover::after {
            transform: scaleX(1);
        }

        .cat-icon {
            font-size: 3.5rem;
            margin-bottom: 25px;
            display: block;
            background: linear-gradient(135deg, var(--l-purple), var(--l-pink));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .category-card h4 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--l-purple);
            margin-bottom: 15px;
        }

        /* Loan Card */
        .loan-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            transition: all 0.4s;
            box-shadow: var(--l-shadow);
            border: 1px solid rgba(124, 45, 94, 0.05);
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none !important;
        }

        .loan-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(124, 45, 94, 0.2);
        }

        .loan-tag {
            background: var(--l-gold);
            color: #333;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            width: fit-content;
            margin-bottom: 15px;
        }

        .loan-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--l-purple);
            margin-bottom: 15px;
        }

        .loan-card p {
            color: #666;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .loan-card .btn-view {
            background: linear-gradient(135deg, var(--l-purple), var(--l-pink));
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 700;
            transition: 0.3s;
        }

        .loan-card .btn-view:hover {
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
            color: var(--l-purple);
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }

        .section-header h2::after {
            content: '';
            position: absolute;
            bottom: 0; left: 25%; width: 50%; height: 4px;
            background: var(--l-pink);
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
            .loan-hero h1 { font-size: 2.2rem; }
            .loan-hero { 
                padding: 60px 15px 100px; 
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
            }
            .loan-search {
                flex-direction: column;
                border-radius: 20px;
                padding: 15px;
                gap: 10px;
            }
            .loan-search input {
                padding: 12px 15px;
                text-align: center;
            }
            .loan-search button {
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
    <header class="loan-hero">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        <div class="container">
            <h1>Women Loan Hub</h1>
            <p>Explore different loan options available for women entrepreneurs, students, professionals, and self-employed women.</p>
        </div>
    </header>

    <div class="search-wrapper container">
        <div class="loan-search">
            <input type="text" id="searchInput" placeholder="Search Loan...">
            <button id="searchButton">Find Loan</button>
        </div>
    </div>

    <main class="container mb-5">
        <div class="section-header">
            <h2>Browse Loan Categories</h2>
        </div>

        <div class="row g-4 mb-5" id="categoryGrid">
            <div class="col-md-6 col-lg-3" data-category="business">
                <div class="category-card">
                    <i class="cat-icon fas fa-briefcase"></i>
                    <h4>Business Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="education">
                <div class="category-card">
                    <i class="cat-icon fas fa-graduation-cap"></i>
                    <h4>Education Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="personal">
                <div class="category-card">
                    <i class="cat-icon fas fa-user"></i>
                    <h4>Personal Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="home">
                <div class="category-card">
                    <i class="cat-icon fas fa-home"></i>
                    <h4>Home Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="gold">
                <div class="category-card">
                    <i class="cat-icon fas fa-gem"></i>
                    <h4>Gold Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="vehicle">
                <div class="category-card">
                    <i class="cat-icon fas fa-car"></i>
                    <h4>Vehicle Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="msme">
                <div class="category-card">
                    <i class="cat-icon fas fa-industry"></i>
                    <h4>MSME Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="startup">
                <div class="category-card">
                    <i class="cat-icon fas fa-rocket"></i>
                    <h4>Startup Loan</h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3" data-category="agriculture">
                <div class="category-card">
                    <i class="cat-icon fas fa-seedling"></i>
                    <h4>Agriculture Loan</h4>
                </div>
            </div>
        </div>

        <div class="section-header">
            <h2>Popular Loans</h2>
        </div>

        <div class="row g-4" id="loanGrid">
            <div class="col-md-6 col-lg-3" data-loan="business">
                <a href="${pageContext.request.contextPath}/loan/details/business" class="loan-card">
                    <div class="loan-tag">POPULAR</div>
                    <h3>Business Loan</h3>
                    <p>Finance your business growth with easy repayment options.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="mudra">
                <a href="${pageContext.request.contextPath}/loan/details/mudra" class="loan-card">
                    <div class="loan-tag">GOVERNMENT</div>
                    <h3>Mudra Loan</h3>
                    <p>Collateral-free loans for micro and small businesses.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="education">
                <a href="${pageContext.request.contextPath}/loan/details/education" class="loan-card">
                    <div class="loan-tag">EDUCATION</div>
                    <h3>Education Loan</h3>
                    <p>Fund your education and career aspirations.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="msme">
                <a href="${pageContext.request.contextPath}/loan/details/msme" class="loan-card">
                    <div class="loan-tag">MSME</div>
                    <h3>MSME Loan</h3>
                    <p>Financial support for micro, small, and medium enterprises.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="personal">
                <a href="${pageContext.request.contextPath}/loan/details/personal" class="loan-card">
                    <div class="loan-tag">POPULAR</div>
                    <h3>Personal Loan</h3>
                    <p>Quick and easy loan for your personal needs and emergencies.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="home">
                <a href="${pageContext.request.contextPath}/loan/details/home" class="loan-card">
                    <div class="loan-tag">HOME</div>
                    <h3>Home Loan</h3>
                    <p>Make your dream home a reality with our home loan options.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="gold">
                <a href="${pageContext.request.contextPath}/loan/details/gold" class="loan-card">
                    <div class="loan-tag">SECURED</div>
                    <h3>Gold Loan</h3>
                    <p>Get instant loan against your gold jewellery with minimal paperwork.</p>
                    <button class="btn-view">View Details</button>
                </a>
            </div>
            <div class="col-md-6 col-lg-3" data-loan="vehicle">
                <a href="${pageContext.request.contextPath}/loan/details/vehicle" class="loan-card">
                    <div class="loan-tag">VEHICLE</div>
                    <h3>Vehicle Loan</h3>
                    <p>Drive home your dream car or two-wheeler with easy EMI options.</p>
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
            const loanCards = document.querySelectorAll('.loan-card');
            const categoryCols = document.querySelectorAll('#categoryGrid > div');
            const loanCols = document.querySelectorAll('#loanGrid > div');

            function performSearch() {
                const query = searchInput.value.trim().toLowerCase();
                
                categoryCols.forEach(col => {
                    const card = col.querySelector('.category-card');
                    const title = card.querySelector('h4').innerText.toLowerCase();
                    if (title.includes(query)) {
                        col.style.display = 'block';
                    } else {
                        col.style.display = 'none';
                    }
                });

                loanCols.forEach(col => {
                    const card = col.querySelector('.loan-card');
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
