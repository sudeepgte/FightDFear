<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fight The Fire - Home</title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
  <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Custom Styling -->
  <style>
    :root {
      --background-color: #fdf9ff;
      --default-color: #2e0d3a;
      --heading-color: #6a1b9a;
      --accent-color: #8e44ad;
      --surface-color: #ffffff;
      --contrast-color: #ffffff;
    }

    body {
      background-color: var(--background-color);
      color: var(--default-color);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container {
      padding-top: 60px;
      padding-bottom: 60px;
    }

    h1 {
      color: var(--heading-color);
      font-weight: 700;
      margin-bottom: 50px;
      font-size: 2.5rem;
    }

    .card {
      background-color: var(--surface-color);
      border: none;
      border-radius: 16px;
        border: 2px solid #8e44ad;
      padding: 30px 20px;
      text-align: center;
      transition: all 0.3s ease;
      box-shadow: 0 6px 14px rgba(142, 68, 173, 0.2);
      height: 100%;
    }

    .card:hover {
      transform: translateY(-6px);
      box-shadow: 0 10px 20px rgba(142, 68, 173, 0.3);
    }

    .card img {
      width: 90px;
      height: 90px;
      object-fit: cover;
      border-radius: 50%;
      margin-bottom: 20px;
    }

    .card-title {
      color: var(--heading-color);
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 10px;
    }

    .card p {
      font-size: 0.95rem;
      margin-bottom: 20px;
      color: #5a5a5a;
    }

    .btn {
      font-weight: 600;
      border-radius: 30px;
      padding: 10px 20px;
      font-size: 0.9rem;
    }

    .btn-primary {
      background-color: var(--accent-color);
      border: none;
      color: var(--contrast-color);
    }

    .btn-primary:hover {
      background-color: color-mix(in srgb, var(--accent-color), black 15%);
    }

    .btn-outline-primary {
      color: var(--accent-color);
      border: 2px solid var(--accent-color);
      background-color: transparent;
    }

    .btn-outline-primary:hover {
      background-color: var(--accent-color);
      color: var(--contrast-color);
    }

    @media (max-width: 768px) {
      h1 {
        font-size: 2rem;
      }

      .card {
        margin-bottom: 30px;
      }
    }
  </style>
</head>
<body>

<div class="container">
  <h1>Welcome to Fight The Fire</h1>
  <div class="row g-4 justify-content-center">

    <!-- Volunteer Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="${pageContext.request.contextPath}/resources/images/volunteer.jpg" alt="Volunteer">
        <h4 class="card-title">Volunteer</h4>
        <p>Join as a volunteer and lets make the world Fear Free.</p>
        <a href="${pageContext.request.contextPath}/volunteer/register" class="btn btn-primary w-100 mb-2">Register</a>
        <a href="${pageContext.request.contextPath}/volunteer/login" class="btn btn-outline-primary w-100">Login</a>
      </div>
    </div>

    <!-- User Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="${pageContext.request.contextPath}/resources/images/user.png" alt="User">
        <h4 class="card-title">User</h4>
        <p>Enroll for self-defense training and safety features.</p>
        <a href="${pageContext.request.contextPath}/users/register" class="btn btn-primary w-100 mb-2">Register</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary w-100">Login</a>
      </div>
    </div>

    <!-- Martial Arts Centre Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="${pageContext.request.contextPath}/resources/images/martial arts.jpg" alt="Martial Arts Centre">
        <h4 class="card-title">Martial Arts Centre</h4>
        <p>Register your center and help train women in self-defense.</p>
        <a href="${pageContext.request.contextPath}/centres/registerCentre" class="btn btn-primary w-100 mb-2">Register</a>
        <a href="${pageContext.request.contextPath}/centres/login" class="btn btn-outline-primary w-100">Login</a>
      </div>
    </div>

    <!-- Admin Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="${pageContext.request.contextPath}/resources/images/admin.jpg" alt="Admin">
        <h4 class="card-title">Admin</h4>
        <p>Manage the platform and verify registrations.</p>
        <a href="${pageContext.request.contextPath}/admin/loginAdmin" class="btn btn-primary w-100">Login</a>
      </div>
    </div>

<!-- Beauty Salon Card -->
<div class="col-md-6 col-lg-3">
  <div class="card h-100">
    <img src="${pageContext.request.contextPath}/resources/images/beauty_salon.jpg" alt="Beauty Salon">
    <h4 class="card-title">Beauty Salon</h4>
    <p>Register your salon to showcase services, products, and special offers for Girls.</p>
    <a href="${pageContext.request.contextPath}/salons/register" class="btn btn-primary w-100 mb-2">Register</a>
    <a href="${pageContext.request.contextPath}/salons/login" class="btn btn-outline-primary w-100">Login</a>
  </div>
</div>

<div class="col-md-6 col-lg-3">
  <div class="card h-100">
    <img src="${pageContext.request.contextPath}/assets/images/stylist.jfif" alt="Beauty Salon">
    <h4 class="card-title">Stylist</h4>
    <p>Register  to showcase services and special offers for Girls.</p>
    <a href="${pageContext.request.contextPath}/stylists/register" class="btn btn-primary w-100 mb-2">Register</a>
    <a href="${pageContext.request.contextPath}/stylists/login" class="btn btn-outline-primary w-100">Login</a>
  </div>
</div>

    <!-- Women Lawyer Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&q=80&w=2070" alt="Women Lawyer">
        <h4 class="card-title">Women Lawyer</h4>
        <p>Register to provide legal assistance and advocacy for women.</p>
        <a href="${pageContext.request.contextPath}/marketplace/provider/register?category=WOMEN_LAWYER" class="btn btn-primary w-100 mb-2">Register</a>
        <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="btn btn-outline-primary w-100">Login</a>
      </div>
    </div>

    <!-- Fitness Zumba Card -->
    <div class="col-md-6 col-lg-3">
      <div class="card h-100">
        <img src="https://images.unsplash.com/photo-1524594152303-9fd13543fe6e?auto=format&fit=crop&q=80&w=2070" alt="Fitness Zumba">
        <h4 class="card-title">Fitness Zumba</h4>
        <p>Register as a Zumba instructor to lead empowering fitness sessions.</p>
        <a href="${pageContext.request.contextPath}/marketplace/provider/register?category=FITNESS_ZUMBA" class="btn btn-primary w-100 mb-2">Register</a>
        <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="btn btn-outline-primary w-100">Login</a>
      </div>
    </div>

  </div>
</div>

</body>
</html>

