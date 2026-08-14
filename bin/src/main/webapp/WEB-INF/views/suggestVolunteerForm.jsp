<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Suggest a Volunteer</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

<style>
    /* ============================================
       ROOT VARIABLES (your brand colors)
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
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        background: var(--light-bg);
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 20px;
    }

    .form-card {
        background: #ffffff;
        border-radius: 20px;
        padding: 30px;
        max-width: 550px;
        margin: 60px auto;
        box-shadow: var(--shadow-md);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .form-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
    }

    h3 {
        text-align: center;
        color: var(--primary-purple);
        font-weight: 700;
        margin-bottom: 25px;
    }

    label {
        font-weight: 600;
        color: var(--primary-purple);
        margin-bottom: 6px;
        display: inline-block;
        transition: color 0.2s;
    }
    label:hover {
        color: var(--primary-purple-light);
    }

    .form-control {
        border-radius: 12px;
        padding: 12px;
        border: 1px solid rgba(123, 44, 191, 0.3);
        transition: all 0.2s;
    }
    .form-control:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        outline: none;
    }

    .btn-purple {
        background: var(--gradient-primary);
        border: none;
        color: #fff;
        font-weight: 600;
        padding: 12px;
        width: 100%;
        border-radius: 40px;
        margin-top: 10px;
        transition: all 0.2s;
        cursor: pointer;
        box-shadow: var(--shadow-sm);
    }
    .btn-purple:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        filter: brightness(1.02);
    }
    .btn-purple:active {
        transform: translateY(0);
    }

    .note {
        font-size: 13px;
        color: rgba(74, 14, 120, 0.6);
        text-align: center;
        margin-top: 15px;
    }

    /* Focus outline for accessibility */
    .btn-purple:focus-visible,
    .form-control:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
    }

    /* Custom scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
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
</style>
</head>

<body>

<div class="form-card">

    <h3>Suggest a Volunteer</h3>

    <form action="${pageContext.request.contextPath}/users/suggest-volunteer"
          method="post" enctype="multipart/form-data">

        <div class="mb-3">
            <label>Full Name</label>
            <input type="text" name="name" class="form-control"
                   placeholder="Enter volunteer name" required>
        </div>

        <div class="mb-3">
            <label>Email Address</label>
            <input type="email" name="email" class="form-control"
                   placeholder="Enter email address" required>
        </div>

        <div class="mb-3">
            <label>Phone Number</label>
            <input type="text" name="phone" class="form-control"
                   placeholder="Enter phone number" required>
        </div>

        <div class="mb-3">
            <label>Government ID (PDF / Image)</label>
            <input type="file" name="govtId" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-purple">
            Submit Suggestion
        </button>

        <p class="note">
            Your suggestion will be reviewed by the admin before approval.
        </p>
    </form>

</div>

</body>
</html>

