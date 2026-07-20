<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Update Martial Arts Center</title>
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
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        font-family: Arial, sans-serif;
        background-color: var(--light-bg);
        color: var(--dark-bg);
        padding: 30px;
        margin: 0;
    }

    h2 {
        text-align: center;
        color: var(--primary-purple);
        margin-bottom: 20px;
    }

    form {
        max-width: 500px;
        margin: 0 auto;
        background: #fff;
        border: 2px solid var(--primary-purple);
        border-radius: 12px;
        padding: 25px;
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.3s ease;
    }
    form:hover {
        box-shadow: var(--shadow-md);
    }

    label {
        font-weight: bold;
        color: var(--primary-purple);
        display: block;
        margin-bottom: 6px;
    }

    input[type="text"],
    input[type="password"],
    input[type="email"],
    input[type="file"],
    .form-input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin-bottom: 15px;
        transition: all 0.3s ease;
    }

    input[type="text"]:focus,
    input[type="password"]:focus,
    input[type="email"]:focus {
        border-color: var(--primary-purple);
        outline: none;
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
    }

    input[type="checkbox"] {
        accent-color: var(--primary-purple);
        margin-right: 6px;
    }

    button {
        background: var(--primary-purple);
        color: white;
        font-size: 16px;
        font-weight: bold;
        border: none;
        padding: 12px 18px;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
    }

    button:hover {
        background: var(--primary-purple-light);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .form-section {
        margin-bottom: 18px;
    }

    @media (max-width: 576px) {
        body {
            padding: 20px;
        }
        form {
            padding: 20px;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole form */
    form {
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

    /* 2. Button ripple effect on click (micro-interaction) */
    button {
        position: relative;
        overflow: hidden;
    }
    button::after {
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
    button:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    button:focus-visible,
    input:focus-visible,
    .form-input:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 4. Custom scrollbar (matches brand purple) */
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

    /* 5. Label hover effect – subtle color shift */
    label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    label:hover {
        color: var(--primary-purple-light);
        transform: translateX(2px);
    }

    /* 6. Input placeholder styling (softer) */
    input::placeholder, .form-input::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    input:focus::placeholder, .form-input:focus::placeholder {
        opacity: 0.6;
    }

    /* 7. Heading hover effect – subtle text shadow */
    h2 {
        transition: text-shadow 0.2s;
    }
    h2:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.15);
    }

    /* 8. Input hover effect – border darkens (preserves focus ring) */
    input:hover, .form-input:hover {
        border-color: var(--primary-purple-light);
    }

    /* 9. Form section hover effect – subtle background */
    .form-section {
        transition: background 0.2s, padding 0.2s;
        border-radius: 8px;
        padding: 2px 4px;
        margin-left: -4px;
        margin-right: -4px;
    }
    .form-section:hover {
        background: rgba(123, 44, 191, 0.04);
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    form.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>
<h2>Update Martial Arts Center</h2>

<form:form 
    action="${pageContext.request.contextPath}/centres/update/${center.id}" 
    method="post" 
    modelAttribute="center"
    enctype="multipart/form-data">

    <!-- Name -->
    <div class="form-section">
        <label>Center Name</label>
        <form:input path="name" cssClass="form-input"/>
    </div>

    <!-- Location -->
    <div class="form-section">
        <label>Location</label>
        <form:input path="location" cssClass="form-input"/>
    </div>

    <!-- Phone -->
    <div class="form-section">
        <label>Phone Number</label>
        <form:input path="phoneNumber" cssClass="form-input"/>
    </div>

    <!-- Email -->
    <div class="form-section">
        <label>Email</label>
        <form:input path="email" cssClass="form-input"/>
    </div>

    <!-- Password -->
    <div class="form-section">
        <label>Password</label>
        <form:password path="password" cssClass="form-input"/>
    </div>

    <!-- About Center -->
    <div class="form-section">
        <label>About the Centre</label>
        <form:textarea path="about" cssClass="form-input" rows="4"/>
    </div>

    <!-- How we teach -->
    <div class="form-section">
        <label>How We Teach</label>
        <form:textarea path="howWeTeach" cssClass="form-input" rows="4"/>
    </div>

    <!-- What we offer -->
    <div class="form-section">
        <label>What We Offer</label>
        <form:textarea path="whatWeOffer" cssClass="form-input" rows="4"/>
    </div>

    <!-- File Upload -->
    <div class="form-section">
        <label>Upload New Trainer Certificate (Optional)</label>
        <input type="file" name="file" class="form-input"/>
    </div>

    <!-- Gallery Photos -->
    <div class="form-section">
        <label>Upload Gallery Photos (Optional)</label>
        <input type="file" name="galleryPhotos" class="form-input" multiple/>
    </div>

    <!-- Martial Arts Types -->
    <div class="form-section">
        <label>Martial Arts Types</label><br>
        <c:forEach var="type" items="${allTypes}">
            <input type="checkbox" name="types" value="${type.id}"
                   <c:if test="${fn:contains(selectedTypeIds, type.id)}">checked</c:if> />
            ${type.name}<br>
        </c:forEach>
    </div>

    <button type="submit">Update</button>
</form:form>

</body>
</html>

