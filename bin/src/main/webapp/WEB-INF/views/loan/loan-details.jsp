<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-purple: #7C2D5E;
            --l-purple: #b34a8b;
            --f-purple: #7C2D5E;
            --f-pink: #DB2777;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #fdf4f9 0%, #f8e8f2 100%);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary-purple) 0%, var(--l-purple) 100%);
            padding: 20px 0;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-link {
            color: var(--white) !important;
            margin: 0 15px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            transform: translateY(-2px);
            text-shadow: 0 2px 8px rgba(255, 255, 255, 0.4);
        }

        /* Main Container */
        .container-main {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* Page Title */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-title {
            color: var(--primary-purple);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        /* Loan Details Card */
        .details-card {
            background: var(--white);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(124, 45, 94, 0.1);
            margin-bottom: 30px;
        }

        .loan-tag {
            display: inline-block;
            background: #ffd700;
            color: #333;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }

        .loan-name {
            color: var(--primary-purple);
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        /* Section Cards */
        .section-card {
            background: rgba(179, 74, 139, 0.05);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
        }

        .section-card h3 {
            color: var(--primary-purple);
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-card h3 i {
            font-size: 1.1rem;
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .info-item {
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.08);
        }

        .info-item strong {
            color: var(--primary-purple);
            display: block;
            margin-bottom: 8px;
        }

        /* Lists */
        .list-style {
            list-style: none;
            padding: 0;
        }

        .list-style li {
            padding: 10px 0;
            border-bottom: 1px solid rgba(124, 45, 94, 0.1);
            padding-left: 25px;
            position: relative;
        }

        .list-style li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: var(--primary-purple);
            font-weight: bold;
        }

        .list-style li:last-child {
            border-bottom: none;
        }

        /* Process Steps */
        .process-steps {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .step-item {
            flex: 1;
            min-width: 150px;
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.08);
        }

        .step-item h5 {
            color: var(--primary-purple);
            margin-bottom: 8px;
        }

        /* Related Loans */
        .related-card {
            background: var(--white);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.08);
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .related-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(124, 45, 94, 0.15);
        }

        .related-card h4 {
            color: var(--primary-purple);
            font-weight: 600;
            margin: 0;
        }

        /* Back Button */
        .back-btn {
            background: linear-gradient(135deg, var(--primary-purple) 0%, var(--l-purple) 100%);
            color: var(--white);
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(124, 45, 94, 0.4);
            color: var(--white);
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 1.8rem;
            }

            .loan-name {
                font-size: 1.5rem;
            }

            .details-card {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="navbar navbar-expand-lg">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/" style="color: white; font-weight: 700; font-size: 1.5rem;">
                    🔥 Fight D' Fear
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" style="border-color: white;">
                    <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/user-dashboard">Dashboard</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container-main">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/loan" class="back-btn mb-4">
            <i class="fas fa-arrow-left"></i> Back to Loan Hub
        </a>

        <!-- Loan Details Card -->
        <div class="details-card">
            <div class="loan-tag" id="loanTag">POPULAR</div>
            <h1 class="loan-name" id="loanName">Business Loan</h1>
            <a href="${pageContext.request.contextPath}/loan/application" class="btn btn-lg mt-4 px-5 fw-bold" style="background: linear-gradient(135deg, var(--f-purple), var(--f-pink)); color: white; border: none;">
                <i class="fas fa-paper-plane me-2"></i> Apply Now
            </a>

            <!-- Overview -->
            <div class="section-card">
                <h3><i class="fas fa-info-circle"></i> Overview</h3>
                <p id="overview">What is a Business Loan?</p>
            </div>

            <!-- Loan Amount -->
            <div class="section-card">
                <h3><i class="fas fa-rupee-sign"></i> Loan Amount</h3>
                <div id="loanAmount">
                    <p><strong>Minimum Amount:</strong> ₹50,000</p>
                    <p><strong>Maximum Amount:</strong> ₹50,00,000</p>
                </div>
            </div>

            <!-- Interest Rate -->
            <div class="section-card">
                <h3><i class="fas fa-percent"></i> Interest Rate</h3>
                <div id="interestRate">
                    <strong>Current Interest Range:</strong> 10% - 15% per annum
                </div>
            </div>

            <!-- Repayment Period -->
            <div class="section-card">
                <h3><i class="fas fa-calendar-alt"></i> Repayment Period</h3>
                <div id="repaymentPeriod">
                    <strong>Loan Duration:</strong> 12 months to 60 months
                </div>
            </div>

            <!-- Eligibility -->
            <div class="section-card">
                <h3><i class="fas fa-user-check"></i> Eligibility</h3>
                <div id="eligibility">
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women entrepreneurs aged 21-55 years</li>
                        <li>Minimum 2 years of business experience</li>
                        <li>Annual turnover of at least ₹10 lakhs</li>
                        <li>Good credit score (700+)</li>
                    </ul>
                </div>
            </div>

            <!-- Documents Required -->
            <div class="section-card">
                <h3><i class="fas fa-file-alt"></i> Documents Required</h3>
                <ul class="list-style" id="documents">
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Business Registration Certificate</li>
                    <li>Bank Statement (Last 6 months)</li>
                    <li>Income Tax Returns (Last 2 years)</li>
                    <li>Business Plan</li>
                </ul>
            </div>

            <!-- Loan Process -->
            <div class="section-card">
                <h3><i class="fas fa-tasks"></i> Loan Process</h3>
                <div class="process-steps" id="loanProcess">
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval</h5>
                    </div>
                    <div class="step-item">
                        <h5>Disbursement</h5>
                    </div>
                </div>
            </div>

            <!-- Benefits -->
            <div class="section-card">
                <h3><i class="fas fa-star"></i> Benefits</h3>
                <ul class="list-style" id="benefits">
                    <li>Business Growth</li>
                    <li>Flexible Repayment</li>
                    <li>Government Support</li>
                    <li>Easy EMI</li>
                </ul>
            </div>

            <!-- Things to Know -->
            <div class="section-card">
                <h3><i class="fas fa-lightbulb"></i> Things to Know</h3>
                <ul class="list-style" id="thingsToKnow">
                    <li>Interest Rate</li>
                    <li>Processing Fee</li>
                    <li>EMI</li>
                    <li>Repayment Rules</li>
                </ul>
            </div>
        </div>

        <!-- Related Loans -->
        <div class="section-card">
            <h3><i class="fas fa-link"></i> Related Loans</h3>
            <div class="row g-4">
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/personal" class="related-card" data-loan="personal">
                        <h4>Personal Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/home" class="related-card" data-loan="home">
                        <h4>Home Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/gold" class="related-card" data-loan="gold">
                        <h4>Gold Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/vehicle" class="related-card" data-loan="vehicle">
                        <h4>Vehicle Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/business" class="related-card" data-loan="business">
                        <h4>Business Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/mudra" class="related-card" data-loan="mudra">
                        <h4>Mudra Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/education" class="related-card" data-loan="education">
                        <h4>Education Loan</h4>
                    </a>
                </div>
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/loan/details/msme" class="related-card" data-loan="msme">
                        <h4>MSME Loan</h4>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        const loans = {
            'business': {
                tag: 'POPULAR',
                name: 'Business Loan',
                overview: 'What is a Business Loan?',
                loanAmount: {
                    min: '₹50,000',
                    max: '₹50,00,000'
                },
                interestRate: '10% - 15% per annum',
                repaymentPeriod: '12 months to 60 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women entrepreneurs aged 21-55 years</li>
                        <li>Minimum 2 years of business experience</li>
                        <li>Annual turnover of at least ₹10 lakhs</li>
                        <li>Good credit score (700+)</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Business Registration Certificate</li>
                    <li>Bank Statement (Last 6 months)</li>
                    <li>Income Tax Returns (Last 2 years)</li>
                    <li>Business Plan</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval</h5>
                    </div>
                    <div class="step-item">
                        <h5>Disbursement</h5>
                    </div>
                `,
                benefits: `
                    <li>Business Growth</li>
                    <li>Flexible Repayment</li>
                    <li>Government Support</li>
                    <li>Easy EMI</li>
                `,
                thingsToKnow: `
                    <li>Interest Rate</li>
                    <li>Processing Fee</li>
                    <li>EMI</li>
                    <li>Repayment Rules</li>
                `
            },
            'mudra': {
                tag: 'GOVERNMENT',
                name: 'Mudra Loan',
                overview: 'What is a Mudra Loan?',
                loanAmount: {
                    min: '₹50,000',
                    max: '₹10,00,000'
                },
                interestRate: '8% - 12% per annum',
                repaymentPeriod: '36 months to 60 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women micro-entrepreneurs</li>
                        <li>Small business owners</li>
                        <li>No minimum credit score</li>
                        <li>Business in manufacturing, trading, or services</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Business Address Proof</li>
                    <li>Bank Statement (Last 6 months)</li>
                    <li>Business Registration (if applicable)</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Visit Bank/MFI</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval</h5>
                    </div>
                    <div class="step-item">
                        <h5>Disbursement</h5>
                    </div>
                `,
                benefits: `
                    <li>No collateral required</li>
                    <li>Low interest rates</li>
                    <li>Government-backed scheme</li>
                    <li>Easy repayment</li>
                `,
                thingsToKnow: `
                    <li>Three categories: Shishu, Kishore, Tarun</li>
                    <li>Processing fee: 0% - 1%</li>
                    <li>No prepayment penalty</li>
                `
            },
            'education': {
                tag: 'EDUCATION',
                name: 'Education Loan',
                overview: 'What is an Education Loan?',
                loanAmount: {
                    min: '₹50,000',
                    max: '₹50,00,000'
                },
                interestRate: '9% - 13% per annum',
                repaymentPeriod: '60 months to 180 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women students aged 16-35 years</li>
                        <li>Admission in recognized institution</li>
                        <li>Co-applicant required</li>
                        <li>Good academic record</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Admission Letter</li>
                    <li>Fee Structure</li>
                    <li>Academic Marksheets</li>
                    <li>Co-applicant Documents</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Collect Documents</h5>
                    </div>
                    <div class="step-item">
                        <h5>Apply Online/Offline</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Sanction</h5>
                    </div>
                `,
                benefits: `
                    <li>Moratorium period available</li>
                    <li>Tax benefits under section 80E</li>
                    <li>Low interest rates for women</li>
                    <li>Flexible repayment options</li>
                `,
                thingsToKnow: `
                    <li>Interest during moratorium period</li>
                    <li>Processing fee: 1% - 2%</li>
                    <li>Repayment starts after course completion</li>
                `
            },
            'msme': {
                tag: 'MSME',
                name: 'MSME Loan',
                overview: 'What is an MSME Loan?',
                loanAmount: {
                    min: '₹1,00,000',
                    max: '₹1,00,00,000'
                },
                interestRate: '9.5% - 16% per annum',
                repaymentPeriod: '12 months to 84 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>MSME registered businesses</li>
                        <li>Women-owned enterprises</li>
                        <li>Minimum 1 year in business</li>
                        <li>Minimum annual turnover ₹10 lakhs</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>MSME Certificate</li>
                    <li>Business Plan</li>
                    <li>Bank Statement (Last 12 months)</li>
                    <li>ITR (Last 2 years)</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>MSME Registration Check</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Preparation</h5>
                    </div>
                    <div class="step-item">
                        <h5>Online Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Bank Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval & Disbursal</h5>
                    </div>
                `,
                benefits: `
                    <li>Government subsidies available</li>
                    <li>Flexible tenure</li>
                    <li>Quick approval</li>
                    <li>Overdraft facility available</li>
                `,
                thingsToKnow: `
                    <li>MSME registration mandatory</li>
                    <li>Processing fee: 1% - 2%</li>
                    <li>Prepayment allowed</li>
                `
            },
            'personal': {
                tag: 'POPULAR',
                name: 'Personal Loan',
                overview: 'What is a Personal Loan?',
                loanAmount: {
                    min: '₹50,000',
                    max: '₹20,00,000'
                },
                interestRate: '10.5% - 18% per annum',
                repaymentPeriod: '12 months to 60 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women aged 21-58 years</li>
                        <li>Salaried or self-employed with regular income</li>
                        <li>Minimum monthly income of ₹20,000</li>
                        <li>Good credit score (650+)</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Income Proof (Salary slips / ITR)</li>
                    <li>Address Proof</li>
                    <li>Bank Statement (Last 3 months)</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Collect Documents</h5>
                    </div>
                    <div class="step-item">
                        <h5>Fill Online Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval & Disbursal</h5>
                    </div>
                `,
                benefits: `
                    <li>No collateral required</li>
                    <li>Quick approval in 24-48 hours</li>
                    <li>Flexible end-use</li>
                    <li>Easy EMI options</li>
                `,
                thingsToKnow: `
                    <li>Processing fee: 1% - 2.5%</li>
                    <li>Prepayment charges may apply</li>
                    <li>Higher interest rate for lower credit score</li>
                `
            },
            'home': {
                tag: 'HOME',
                name: 'Home Loan',
                overview: 'What is a Home Loan?',
                loanAmount: {
                    min: '₹5,00,000',
                    max: '₹5,00,00,000'
                },
                interestRate: '8.5% - 12% per annum',
                repaymentPeriod: '5 years to 30 years',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women aged 21-65 years</li>
                        <li>Salaried or self-employed with stable income</li>
                        <li>Good credit score (700+)</li>
                        <li>Property to be purchased as collateral</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Income Proof</li>
                    <li>Address Proof</li>
                    <li>Property Documents</li>
                    <li>Bank Statement (Last 6 months)</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Property Selection</h5>
                    </div>
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Property Valuation & Legal Check</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approval & Disbursement</h5>
                    </div>
                `,
                benefits: `
                    <li>Lower interest rates</li>
                    <li>Long repayment tenure</li>
                    <li>Tax benefits under 80C and 24</li>
                    <li>Government schemes for women</li>
                `,
                thingsToKnow: `
                    <li>Property as collateral</li>
                    <li>Processing fee: 0.5% - 1.5%</li>
                    <li>Foreclosure available after 6 months</li>
                `
            },
            'gold': {
                tag: 'SECURED',
                name: 'Gold Loan',
                overview: 'What is a Gold Loan?',
                loanAmount: {
                    min: '₹10,000',
                    max: '₹50,00,000'
                },
                interestRate: '7% - 14% per annum',
                repaymentPeriod: '3 months to 36 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women aged 18-65 years</li>
                        <li>Owner of gold jewellery</li>
                        <li>No income proof required</li>
                        <li>Quick documentation</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Gold jewellery to be pledged</li>
                    <li>Address Proof</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Visit Branch / Apply Online</h5>
                    </div>
                    <div class="step-item">
                        <h5>Gold Evaluation</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Documents</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Approved</h5>
                    </div>
                    <div class="step-item">
                        <h5>Receive Funds</h5>
                    </div>
                `,
                benefits: `
                    <li>Instant approval in hours</li>
                    <li>Lower interest rates</li>
                    <li>No income proof needed</li>
                    <li>Flexible repayment options</li>
                `,
                thingsToKnow: `
                    <li>Gold as collateral</li>
                    <li>LTV ratio up to 75-90%</li>
                    <li>Safe custody of gold</li>
                `
            },
            'vehicle': {
                tag: 'VEHICLE',
                name: 'Vehicle Loan',
                overview: 'What is a Vehicle Loan?',
                loanAmount: {
                    min: '₹50,000',
                    max: '₹1,00,00,000'
                },
                interestRate: '8% - 13% per annum',
                repaymentPeriod: '12 months to 84 months',
                eligibility: `
                    <p><strong>Who can apply?</strong></p>
                    <ul class="list-style">
                        <li>Women aged 21-65 years</li>
                        <li>Salaried or self-employed with stable income</li>
                        <li>Minimum monthly income ₹20,000</li>
                        <li>Good credit score (650+)</li>
                    </ul>
                `,
                documents: `
                    <li>Aadhaar Card</li>
                    <li>PAN Card</li>
                    <li>Income Proof</li>
                    <li>Address Proof</li>
                    <li>Vehicle Quotation</li>
                    <li>Bank Statement (Last 3 months)</li>
                `,
                loanProcess: `
                    <div class="step-item">
                        <h5>Select Vehicle</h5>
                    </div>
                    <div class="step-item">
                        <h5>Check Eligibility</h5>
                    </div>
                    <div class="step-item">
                        <h5>Submit Application</h5>
                    </div>
                    <div class="step-item">
                        <h5>Document Verification</h5>
                    </div>
                    <div class="step-item">
                        <h5>Loan Disbursal & Delivery</h5>
                    </div>
                `,
                benefits: `
                    <li>Quick processing</li>
                    <li>Up to 100% financing on certain models</li>
                    <li>Flexible repayment tenure</li>
                    <li>Special schemes for women</li>
                `,
                thingsToKnow: `
                    <li>Vehicle as hypothecation</li>
                    <li>Processing fee: 0.5% - 2%</li>
                    <li>Foreclosure allowed</li>
                `
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            const pathParts = window.location.pathname.split('/');
            let loanId = pathParts[pathParts.length - 1];
            
            if (loanId && loans[loanId]) {
                const loan = loans[loanId];
                document.getElementById('loanTag').textContent = loan.tag;
                document.getElementById('loanName').textContent = loan.name;
                document.getElementById('overview').textContent = loan.overview;
                document.getElementById('loanAmount').innerHTML = `
                    <p><strong>Minimum Amount:</strong> ${loan.loanAmount.min}</p>
                    <p><strong>Maximum Amount:</strong> ${loan.loanAmount.max}</p>
                `;
                document.getElementById('interestRate').innerHTML = `
                    <strong>Current Interest Range:</strong> ${loan.interestRate}
                `;
                document.getElementById('repaymentPeriod').innerHTML = `
                    <strong>Loan Duration:</strong> ${loan.repaymentPeriod}
                `;
                document.getElementById('eligibility').innerHTML = loan.eligibility;
                document.getElementById('documents').innerHTML = loan.documents;
                document.getElementById('loanProcess').innerHTML = loan.loanProcess;
                document.getElementById('benefits').innerHTML = loan.benefits;
                document.getElementById('thingsToKnow').innerHTML = loan.thingsToKnow;
            }
        });
    </script>
</body>
</html>
