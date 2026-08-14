<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Funding Scheme Details</title>
    
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
        .details-hero {
            background: linear-gradient(135deg, var(--f-purple) 0%, var(--f-pink) 100%);
            padding: 60px 0 80px;
            color: white;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
            position: relative;
            overflow: hidden;
        }

        .details-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png');
            opacity: 0.1;
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 3rem;
            margin-bottom: 10px;
            letter-spacing: -1px;
        }

        .details-hero .scheme-tag {
            background: var(--f-gold);
            color: #333;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            display: inline-block;
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--f-shadow);
            border: 1px solid rgba(124, 45, 94, 0.05);
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--f-purple);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-card h3 i {
            color: var(--f-pink);
        }

        .section-card p, .section-card ul {
            color: #555;
            line-height: 1.8;
        }

        .section-card ul {
            padding-left: 20px;
        }

        .section-card li {
            margin-bottom: 10px;
        }

        /* Badge List */
        .badge-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .badge-item {
            background: rgba(124, 45, 94, 0.1);
            color: var(--f-purple);
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
        }

        /* Step List */
        .step-list {
            counter-reset: step;
        }

        .step-item {
            position: relative;
            padding-left: 60px;
            padding-bottom: 30px;
        }

        .step-item:last-child {
            padding-bottom: 0;
        }

        .step-item::before {
            counter-increment: step;
            content: counter(step);
            position: absolute;
            left: 0;
            top: 0;
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-family: 'Montserrat', sans-serif;
        }

        .step-item::after {
            content: '';
            position: absolute;
            left: 19px;
            top: 40px;
            width: 2px;
            height: calc(100% - 40px);
            background: var(--f-purple);
            opacity: 0.3;
        }

        .step-item:last-child::after {
            display: none;
        }

        /* Related Schemes */
        .related-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            box-shadow: var(--f-shadow);
            transition: all 0.3s;
            text-decoration: none !important;
            display: block;
        }

        .related-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(124, 45, 94, 0.2);
        }

        .related-card h4 {
            color: var(--f-purple);
            font-weight: 700;
            margin-bottom: 10px;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            top: 25px;
            left: 25px;
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
            .details-hero h1 { font-size: 2rem; }
            .details-hero { 
                padding: 60px 15px 80px; 
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <header class="details-hero">
        <a href="${pageContext.request.contextPath}/funding" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Funding Hub
        </a>
        <div class="container text-center">
            <span class="scheme-tag" id="schemeTag">POPULAR</span>
            <h1 id="schemeName">PM Mudra Yojana</h1>
            <a href="${pageContext.request.contextPath}/funding/application" class="btn btn-light btn-lg mt-4 px-5 fw-bold" style="color: var(--f-purple);">
                <i class="fas fa-paper-plane me-2"></i> Apply Now
            </a>
        </div>
    </header>

    <main class="container mt-5 mb-5">
        <!-- Overview -->
        <div class="section-card">
            <h3><i class="fas fa-info-circle"></i> Overview</h3>
            <p id="overview">PM Mudra Yojana is a flagship scheme of the Government of India to provide collateral-free loans to micro and small enterprises. The scheme aims to encourage entrepreneurship among women, SC/ST, and other backward classes by providing easy access to credit.</p>
        </div>

        <!-- Purpose -->
        <div class="section-card">
            <h3><i class="fas fa-bullseye"></i> Purpose</h3>
            <div id="purpose">
                <p>To provide financial support to micro-enterprises and small businesses.</p>
                <ul>
                    <li>Promote entrepreneurship among women and youth</li>
                    <li>Provide access to institutional credit without collateral</li>
                    <li>Support income generation activities in non-farm sector</li>
                    <li>Encourage self-employment opportunities</li>
                </ul>
            </div>
        </div>

        <!-- Eligibility -->
        <div class="section-card">
            <h3><i class="fas fa-user-check"></i> Eligibility</h3>
            <ul id="eligibility">
                <li><strong>Age:</strong> Minimum 18 years, no upper age limit</li>
                <li><strong>Gender:</strong> All women entrepreneurs are eligible</li>
                <li><strong>Business Type:</strong> Micro, small, and medium enterprises in non-farm sector</li>
                <li><strong>Income Criteria:</strong> No specific income criteria</li>
                <li><strong>Other Conditions:</strong> Should not be a defaulter to any financial institution</li>
            </ul>
        </div>

        <!-- Funding Amount -->
        <div class="section-card">
            <h3><i class="fas fa-rupee-sign"></i> Funding Amount</h3>
            <div class="badge-list" id="fundingAmount">
                <div class="badge-item">Shishu: Up to ₹50,000</div>
                <div class="badge-item">Kishor: ₹50,001 to ₹5,00,000</div>
                <div class="badge-item">Tarun: ₹5,00,001 to ₹10,00,000</div>
            </div>
        </div>

        <!-- Required Documents -->
        <div class="section-card">
            <h3><i class="fas fa-file-alt"></i> Required Documents</h3>
            <ul id="requiredDocuments">
                <li>Aadhaar Card (Identity Proof)</li>
                <li>PAN Card</li>
                <li>Address Proof (Electricity Bill, Ration Card, etc.)</li>
                <li>Business Plan (for higher loan amounts)</li>
                <li>Bank Passbook (Last 6 months)</li>
                <li>Passport Size Photographs</li>
                <li>Business Registration Certificate (if applicable)</li>
            </ul>
        </div>

        <!-- Eligible Business Types -->
        <div class="section-card">
            <h3><i class="fas fa-briefcase"></i> Eligible Business Types</h3>
            <div class="badge-list" id="businessTypes">
                <div class="badge-item">Tailoring</div>
                <div class="badge-item">Food Business</div>
                <div class="badge-item">Beauty Salon</div>
                <div class="badge-item">Handicrafts</div>
                <div class="badge-item">Bakery</div>
                <div class="badge-item">Retail Shop</div>
                <div class="badge-item">Agriculture (Allied activities)</div>
                <div class="badge-item">Online Business</div>
                <div class="badge-item">Clothing Store</div>
                <div class="badge-item">Tuition Center</div>
            </div>
        </div>

        <!-- Application Process -->
        <div class="section-card">
            <h3><i class="fas fa-tasks"></i> Application Process</h3>
            <div class="step-list" id="applicationProcess">
                <div class="step-item">
                    <h5>Check Eligibility</h5>
                    <p>Verify if you meet the eligibility criteria for the scheme. Check your business type and loan requirement.</p>
                </div>
                <div class="step-item">
                    <h5>Prepare Documents</h5>
                    <p>Gather all required documents including identity proof, address proof, and business-related documents.</p>
                </div>
                <div class="step-item">
                    <h5>Fill Application Form</h5>
                    <p>Visit the nearest bank or apply online through the official Mudra portal. Fill the application form with accurate details.</p>
                </div>
                <div class="step-item">
                    <h5>Verification</h5>
                    <p>The bank will verify your documents and application. They may conduct a field visit if required.</p>
                </div>
                <div class="step-item">
                    <h5>Funding Approval</h5>
                    <p>Once verified, the loan will be approved and disbursed to your bank account within a few working days.</p>
                </div>
            </div>
        </div>

        <!-- Benefits -->
        <div class="section-card">
            <h3><i class="fas fa-star"></i> Benefits</h3>
            <ul id="benefits">
                <li>Financial Support without collateral</li>
                <li>Low Interest Rates compared to private lenders</li>
                <li>Flexible repayment tenure</li>
                <li>Helps in Business Growth and expansion</li>
                <li>Women Empowerment through financial independence</li>
                <li>Employment Generation for self and others</li>
            </ul>
        </div>

        <!-- Important Points -->
        <div class="section-card">
            <h3><i class="fas fa-exclamation-triangle"></i> Important Points</h3>
            <ul id="importantPoints">
                <li>Read eligibility criteria carefully before applying</li>
                <li>Keep all documents ready and organized</li>
                <li>Business plan should be clear and realistic</li>
                <li>Maintain proper records of all transactions</li>
                <li>Contact the bank or financial institution for any queries</li>
            </ul>
        </div>

        <!-- Related Schemes -->
        <div class="section-card">
            <h3><i class="fas fa-link"></i> Related Schemes</h3>
            <div class="row g-4">
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/standup-india" class="related-card" data-scheme="standup-india">
                        <h4>Stand-Up India</h4>
                        <p class="text-muted">Bank loans for women entrepreneurs</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/pmegp" class="related-card" data-scheme="pmegp">
                        <h4>PMEGP</h4>
                        <p class="text-muted">Credit linked subsidy for micro-enterprises</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/mahila-samriddhi" class="related-card" data-scheme="mahila-samriddhi">
                        <h4>Mahila Samriddhi</h4>
                        <p class="text-muted">Economic empowerment scheme</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/annapurna" class="related-card" data-scheme="annapurna">
                        <h4>Annapurna Scheme</h4>
                        <p class="text-muted">For food business entrepreneurs</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/udyogini" class="related-card" data-scheme="udyogini">
                        <h4>Udyogini</h4>
                        <p class="text-muted">For women-owned small businesses</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/stree-shakti" class="related-card" data-scheme="stree-shakti">
                        <h4>Stree Shakti</h4>
                        <p class="text-muted">Special package for women entrepreneurs</p>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/funding/details/bmb" class="related-card" data-scheme="bmb">
                        <h4>Bharatiya Mahila Bank</h4>
                        <p class="text-muted">Exclusive loans for women</p>
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const schemes = {
            'pm-mudra': {
                tag: 'POPULAR',
                name: 'PM Mudra Yojana',
                overview: 'PM Mudra Yojana is a flagship scheme of the Government of India to provide collateral-free loans to micro and small enterprises. The scheme aims to encourage entrepreneurship among women, SC/ST, and other backward classes by providing easy access to credit.',
                purpose: `
                    <p>To provide financial support to micro-enterprises and small businesses.</p>
                    <ul>
                        <li>Promote entrepreneurship among women and youth</li>
                        <li>Provide access to institutional credit without collateral</li>
                        <li>Support income generation activities in non-farm sector</li>
                        <li>Encourage self-employment opportunities</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> Minimum 18 years, no upper age limit</li>
                    <li><strong>Gender:</strong> All women entrepreneurs are eligible</li>
                    <li><strong>Business Type:</strong> Micro, small, and medium enterprises in non-farm sector</li>
                    <li><strong>Income Criteria:</strong> No specific income criteria</li>
                    <li><strong>Other Conditions:</strong> Should not be a defaulter to any financial institution</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Shishu: Up to ₹50,000</div>
                    <div class="badge-item">Kishor: ₹50,001 to ₹5,00,000</div>
                    <div class="badge-item">Tarun: ₹5,00,001 to ₹10,00,000</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card (Identity Proof)</li>
                    <li>PAN Card</li>
                    <li>Address Proof (Electricity Bill, Ration Card, etc.)</li>
                    <li>Business Plan (for higher loan amounts)</li>
                    <li>Bank Passbook (Last 6 months)</li>
                    <li>Passport Size Photographs</li>
                    <li>Business Registration Certificate (if applicable)</li>
                `,
                businessTypes: `
                    <div class="badge-item">Tailoring</div>
                    <div class="badge-item">Food Business</div>
                    <div class="badge-item">Beauty Salon</div>
                    <div class="badge-item">Handicrafts</div>
                    <div class="badge-item">Bakery</div>
                    <div class="badge-item">Retail Shop</div>
                    <div class="badge-item">Agriculture (Allied activities)</div>
                    <div class="badge-item">Online Business</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                        <p>Verify if you meet the eligibility criteria for the scheme. Check your business type and loan requirement.</p>
                    </div>
                    <div class="step-item">
                        <h5>Prepare Documents</h5>
                        <p>Gather all required documents including identity proof, address proof, and business-related documents.</p>
                    </div>
                    <div class="step-item">
                        <h5>Fill Application Form</h5>
                        <p>Visit the nearest bank or apply online through the official Mudra portal. Fill the application form with accurate details.</p>
                    </div>
                    <div class="step-item">
                        <h5>Verification</h5>
                        <p>The bank will verify your documents and application. They may conduct a field visit if required.</p>
                    </div>
                    <div class="step-item">
                        <h5>Funding Approval</h5>
                        <p>Once verified, the loan will be approved and disbursed to your bank account within a few working days.</p>
                    </div>
                `,
                benefits: `
                    <li>Financial Support without collateral</li>
                    <li>Low Interest Rates compared to private lenders</li>
                    <li>Flexible repayment tenure</li>
                    <li>Helps in Business Growth and expansion</li>
                    <li>Women Empowerment through financial independence</li>
                    <li>Employment Generation for self and others</li>
                `,
                importantPoints: `
                    <li>Read eligibility criteria carefully before applying</li>
                    <li>Keep all documents ready and organized</li>
                    <li>Business plan should be clear and realistic</li>
                    <li>Maintain proper records of all transactions</li>
                    <li>Contact the bank or financial institution for any queries</li>
                `
            },
            'standup-india': {
                tag: 'GOVERNMENT',
                name: 'Stand-Up India',
                overview: 'Stand-Up India is a government scheme to promote entrepreneurship among women and SC/ST communities by providing bank loans for setting up greenfield enterprises.',
                purpose: `
                    <p>To support women and SC/ST entrepreneurs in starting new ventures.</p>
                    <ul>
                        <li>Facilitate bank loans between ₹10 lakh and ₹1 crore</li>
                        <li>Promote inclusive growth and development</li>
                        <li>Encourage women empowerment through entrepreneurship</li>
                        <li>Create employment opportunities</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> Minimum 18 years</li>
                    <li><strong>Gender:</strong> Women entrepreneurs or SC/ST entrepreneurs</li>
                    <li><strong>Business Type:</strong> Greenfield enterprises in manufacturing, services, or trading</li>
                    <li><strong>Other Conditions:</strong> Borrower must have 51% stake in the enterprise</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Loan Range: ₹10 Lakh to ₹1 Crore</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Caste Certificate (for SC/ST)</li>
                    <li>Business Plan</li>
                    <li>Project Report</li>
                    <li>Address Proof</li>
                `,
                businessTypes: `
                    <div class="badge-item">Manufacturing</div>
                    <div class="badge-item">Services</div>
                    <div class="badge-item">Trading</div>
                    <div class="badge-item">E-commerce</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Project Preparation</h5>
                        <p>Prepare a detailed project report for your proposed business.</p>
                    </div>
                    <div class="step-item">
                        <h5>Bank Selection</h5>
                        <p>Choose a bank branch designated for Stand-Up India.</p>
                    </div>
                    <div class="step-item">
                        <h5>Application Submission</h5>
                        <p>Submit the application along with all required documents.</p>
                    </div>
                    <div class="step-item">
                        <h5>Sanction</h5>
                        <p>Bank will sanction the loan after verification.</p>
                    </div>
                    <div class="step-item">
                        <h5>Disbursement</h5>
                        <p>Loan amount will be disbursed to your account.</p>
                    </div>
                `,
                benefits: `
                    <li>Collateral-free loan</li>
                    <li>Lower interest rates</li>
                    <li>Repayment tenure up to 7 years</li>
                    <li>Government support and guidance</li>
                `,
                importantPoints: `
                    <li>Must be a greenfield enterprise</li>
                    <li>51% stake required for eligible borrower</li>
                    <li>Apply through designated bank branches</li>
                `
            },
            'mahila-samriddhi': {
                tag: 'SCHEME',
                name: 'Mahila Samriddhi Yojana',
                overview: 'Mahila Samriddhi Yojana is designed for the economic empowerment of women through the promotion of micro-enterprises.',
                purpose: `
                    <p>To empower women economically through self-employment and micro-enterprises.</p>
                    <ul>
                        <li>Provide financial assistance to women entrepreneurs</li>
                        <li>Promote women-led businesses</li>
                        <li>Enhance women's participation in economic activities</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> Only women</li>
                    <li><strong>Business Type:</strong> Micro-enterprises</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Up to ₹5 Lakh</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Address Proof</li>
                    <li>Business Proposal</li>
                `,
                businessTypes: `
                    <div class="badge-item">Handicrafts</div>
                    <div class="badge-item">Tailoring</div>
                    <div class="badge-item">Beauty Services</div>
                    <div class="badge-item">Food Processing</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Registration</h5>
                        <p>Register on the official portal or visit the nearest office.</p>
                    </div>
                    <div class="step-item">
                        <h5>Application</h5>
                        <p>Fill the application form with required details.</p>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                        <p>Submit documents for verification.</p>
                    </div>
                    <div class="step-item">
                        <h5>Approval</h5>
                        <p>Get approval and receive funds.</p>
                    </div>
                `,
                benefits: `
                    <li>Low interest rates</li>
                    <li>No collateral required</li>
                    <li>Flexible repayment options</li>
                `,
                importantPoints: `
                    <li>Only women can apply</li>
                    <li>Business must be owned and operated by woman</li>
                `
            },
            'pmegp': {
                tag: 'MSME',
                name: 'PMEGP',
                overview: 'Prime Minister\'s Employment Generation Programme (PMEGP) is a credit-linked subsidy scheme for setting up micro-enterprises in the non-farm sector.',
                purpose: `
                    <p>To generate employment opportunities through the establishment of micro-enterprises.</p>
                    <ul>
                        <li>Provide credit-linked subsidy for new enterprises</li>
                        <li>Generate continuous and sustainable employment</li>
                        <li>Support traditional artisans and unemployed youth</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> All (women get higher subsidy)</li>
                    <li><strong>Education:</strong> At least VIII standard pass for projects costing above ₹10 lakh in manufacturing sector</li>
                    <li><strong>Business Type:</strong> New micro-enterprises in non-farm sector</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Manufacturing: Up to ₹25 Lakh</div>
                    <div class="badge-item">Service: Up to ₹10 Lakh</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Educational Certificates</li>
                    <li>Project Report</li>
                    <li>Caste Certificate (if applicable)</li>
                `,
                businessTypes: `
                    <div class="badge-item">Manufacturing</div>
                    <div class="badge-item">Services</div>
                    <div class="badge-item">Food Processing</div>
                    <div class="badge-item">Handlooms</div>
                    <div class="badge-item">Handicrafts</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Apply Online</h5>
                        <p>Visit PMEGP e-portal and fill application form.</p>
                    </div>
                    <div class="step-item">
                        <h5>Upload Documents</h5>
                        <p>Upload all required documents and project report.</p>
                    </div>
                    <div class="step-item">
                        <h5>Forward to Bank</h5>
                        <p>Application is forwarded to the bank for sanction.</p>
                    </div>
                    <div class="step-item">
                        <h5>Sanction & Disbursement</h5>
                        <p>Bank sanctions loan and disburses with subsidy.</p>
                    </div>
                `,
                benefits: `
                    <li>Subsidy of 15-35% of project cost</li>
                    <li>Women, SC/ST, OBC get higher subsidy</li>
                    <li>No collateral required</li>
                    <li>Easy repayment terms</li>
                `,
                importantPoints: `
                    <li>Only for new enterprises</li>
                    <li>Must not have availed any other government subsidy</li>
                `
            },
            'annapurna': {
                tag: 'SCHEME',
                name: 'Annapurna Scheme',
                overview: 'Annapurna Scheme is designed for women entrepreneurs in the food business sector, providing loans for catering, tiffin services, food stalls, and more.',
                purpose: `
                    <p>To support women entrepreneurs in establishing and expanding food-related businesses.</p>
                    <ul>
                        <li>Provide financial assistance for food business ventures</li>
                        <li>Empower women to start their own catering/tiffin services</li>
                        <li>Encourage women entrepreneurship in food industry</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> Only women</li>
                    <li><strong>Business Type:</strong> Food business (catering, tiffin, bakery, etc.)</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Up to ₹50,000</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Address Proof</li>
                    <li>Business Proposal</li>
                `,
                businessTypes: `
                    <div class="badge-item">Catering</div>
                    <div class="badge-item">Tiffin Services</div>
                    <div class="badge-item">Bakery</div>
                    <div class="badge-item">Food Stall</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Prepare Business Plan</h5>
                        <p>Outline your food business proposal clearly.</p>
                    </div>
                    <div class="step-item">
                        <h5>Visit Bank/Financial Institution</h5>
                        <p>Approach the bank offering Annapurna Scheme.</p>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application & Documents</h5>
                        <p>Provide all necessary documents with your application.</p>
                    </div>
                    <div class="step-item">
                        <h5>Verification & Approval</h5>
                        <p>Bank will verify and approve the loan.</p>
                    </div>
                `,
                benefits: `
                    <li>Collateral-free loan</li>
                    <li>Low interest rates</li>
                    <li>Flexible repayment tenure</li>
                    <li>Quick processing</li>
                `,
                importantPoints: `
                    <li>Only for women entrepreneurs</li>
                    <li>Business must be food-related</li>
                `
            },
            'udyogini': {
                tag: 'GOVERNMENT',
                name: 'Udyogini Scheme',
                overview: 'Udyogini Scheme provides financial support to women entrepreneurs to start small businesses in rural and urban areas.',
                purpose: `
                    <p>To promote and support women-led small businesses across various sectors.</p>
                    <ul>
                        <li>Provide term loans for setting up small businesses</li>
                        <li>Empower women economically</li>
                        <li>Generate self-employment opportunities</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> Women</li>
                    <li><strong>Residence:</strong> Indian resident</li>
                    <li><strong>Business Type:</strong> Small business ventures</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Up to ₹1 Lakh</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Address Proof</li>
                    <li>Business Plan</li>
                `,
                businessTypes: `
                    <div class="badge-item">Retail Shop</div>
                    <div class="badge-item">Handicrafts</div>
                    <div class="badge-item">Tailoring</div>
                    <div class="badge-item">Beauty Salon</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Business Plan Preparation</h5>
                        <p>Prepare a detailed business plan for your venture.</p>
                    </div>
                    <div class="step-item">
                        <h5>Apply to Bank/RRBs</h5>
                        <p>Submit application to participating banks or regional rural banks.</p>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                        <p>Bank will verify your documents and business plan.</p>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval</h5>
                        <p>Once approved, loan amount will be disbursed.</p>
                    </div>
                `,
                benefits: `
                    <li>Subsidized interest rates for women</li>
                    <li>Flexible repayment terms</li>
                    <li>No collateral for smaller loans</li>
                    <li>Supports rural and urban women</li>
                `,
                importantPoints: `
                    <li>Priority to women from weaker sections</li>
                    <li>Subsidy available for eligible beneficiaries</li>
                `
            },
            'stree-shakti': {
                tag: 'POPULAR',
                name: 'Stree Shakti Package',
                overview: 'Stree Shakti Package is a special loan initiative for women entrepreneurs offering interest rate concessions and other benefits.',
                purpose: `
                    <p>To empower women entrepreneurs through favorable loan terms and support.</p>
                    <ul>
                        <li>Offer concession in interest rate to women borrowers</li>
                        <li>Provide easy access to credit</li>
                        <li>Encourage women in business</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> Women</li>
                    <li><strong>Business Ownership:</strong> Must have 50% or more ownership in business</li>
                    <li><strong>Other:</strong> Should be part of Entrepreneurship Development Programmes</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Up to ₹20 Lakh</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Business Registration Proof</li>
                    <li>Financial Statements</li>
                    <li>Project Report</li>
                `,
                businessTypes: `
                    <div class="badge-item">Manufacturing</div>
                    <div class="badge-item">Services</div>
                    <div class="badge-item">Retail</div>
                    <div class="badge-item">Trading</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                        <p>Ensure you meet all scheme criteria.</p>
                    </div>
                    <div class="step-item">
                        <h5>Prepare Documents</h5>
                        <p>Gather all required documents and project report.</p>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                        <p>Submit application at participating bank branch.</p>
                    </div>
                    <div class="step-item">
                        <h5>Loan Processing</h5>
                        <p>Bank verifies and processes your application.</p>
                    </div>
                `,
                benefits: `
                    <li>0.5% concession on interest rate</li>
                    <li>No collateral for loans up to certain limits</li>
                    <li>Flexible repayment tenure</li>
                    <li>Lower processing fee</li>
                `,
                importantPoints: `
                    <li>Women must have majority ownership</li>
                    <li>Entrepreneurship Development Program participation preferred</li>
                `
            },
            'bmb': {
                tag: 'SCHEME',
                name: 'Bharatiya Mahila Bank',
                overview: 'Bharatiya Mahila Bank offers exclusive loan schemes designed specifically for women across various business sectors.',
                purpose: `
                    <p>To provide tailored financial solutions for women entrepreneurs and professionals.</p>
                    <ul>
                        <li>Offer exclusive loan products for women</li>
                        <li>Support women in business, education, and personal needs</li>
                        <li>Empower women through financial inclusion</li>
                    </ul>
                `,
                eligibility: `
                    <li><strong>Age:</strong> 18 years and above</li>
                    <li><strong>Gender:</strong> Women</li>
                    <li><strong>Business Type:</strong> Various (business, education, personal)</li>
                `,
                fundingAmount: `
                    <div class="badge-item">Varies by scheme (up to ₹50 Lakh)</div>
                `,
                requiredDocuments: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Income Proof</li>
                    <li>Address Proof</li>
                    <li>Business Plan (if applicable)</li>
                `,
                businessTypes: `
                    <div class="badge-item">Business</div>
                    <div class="badge-item">Education</div>
                    <div class="badge-item">Home</div>
                    <div class="badge-item">Personal</div>
                `,
                applicationProcess: `
                    <div class="step-item">
                        <h5>Choose Scheme</h5>
                        <p>Select the BMB scheme that suits your needs.</p>
                    </div>
                    <div class="step-item">
                        <h5>Collect Documents</h5>
                        <p>Gather all necessary documents as per the scheme.</p>
                    </div>
                    <div class="step-item">
                        <h5>Visit Branch</h5>
                        <p>Submit application at nearest BMB (now SBI women branch) or apply online.</p>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval</h5>
                        <p>After verification, loan will be approved and disbursed.</p>
                    </div>
                `,
                benefits: `
                    <li>Lower interest rates for women</li>
                    <li>Flexible repayment options</li>
                    <li>Quick processing</li>
                    <li>Wide range of loan options</li>
                `,
                importantPoints: `
                    <li>Now part of SBI after merger</li>
                    <li>Check latest schemes from SBI women divisions</li>
                `
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            const pathParts = window.location.pathname.split('/');
            let schemeId = pathParts[pathParts.length - 1];
            
            if (schemeId && schemes[schemeId]) {
                const scheme = schemes[schemeId];
                document.getElementById('schemeTag').textContent = scheme.tag;
                document.getElementById('schemeName').textContent = scheme.name;
                document.getElementById('overview').textContent = scheme.overview;
                document.getElementById('purpose').innerHTML = scheme.purpose;
                document.getElementById('eligibility').innerHTML = scheme.eligibility;
                document.getElementById('fundingAmount').innerHTML = scheme.fundingAmount;
                document.getElementById('requiredDocuments').innerHTML = scheme.requiredDocuments;
                document.getElementById('businessTypes').innerHTML = scheme.businessTypes;
                document.getElementById('applicationProcess').innerHTML = scheme.applicationProcess;
                document.getElementById('benefits').innerHTML = scheme.benefits;
                document.getElementById('importantPoints').innerHTML = scheme.importantPoints;
            }
        });
    </script>
</body>
</html>
