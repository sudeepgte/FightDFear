<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Beauty Services</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-5px); }
        .card-title { color: #6a0572; font-weight: bold; }
        .card-text { color: #333; }
        .dashboard-header { margin: 30px 0; text-align: center; color: #6a0572; font-weight: bold; }
        .row .col-md-3 { margin-bottom: 20px; }
        .btn-primary { background-color: #6a0572; border: none; }
        .btn-primary:hover { background-color: #8e44ad; }
        .btn-danger { background-color: #c0392b; border: none; }
        .btn-danger:hover { background-color: #e74c3c; }
    </style>
</head>
<body>

<div class="container">
    <h2 class="dashboard-header">Beauty Services Dashboard</h2>

    <div class="row">

        <!-- View All Salons -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-store fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Explore Salons</h5>
                    <p class="card-text">Discover top-rated salons near you</p>
                    <a href="${pageContext.request.contextPath}/user/salons" class="btn btn-primary">View Salons</a>
                </div>
            </div>
        </div>

        <!-- View Stylists -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-user-tie fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">All Stylists</h5>
                    <p class="card-text">See all stylists (Salon + Independent)</p>
                    <a href="${pageContext.request.contextPath}/user/stylists" class="btn btn-primary">View Stylists</a>
                </div>
            </div>
        </div>

        <!-- Book Appointment -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-calendar-alt fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Book Appointment</h5>
                    <p class="card-text">Book your favorite stylist instantly</p>
                    <a href="${pageContext.request.contextPath}/user/bookings" class="btn btn-primary">My Bookings</a>
                </div>
            </div>
        </div>

        <!-- Ratings & Reviews -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-star fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Ratings & Reviews</h5>
                    <p class="card-text">Read stylist & salon feedback</p>
                    <a href="${pageContext.request.contextPath}/user/stylists" class="btn btn-primary">View Reviews</a>
                </div>
            </div>
        </div>

        <!-- Special Offers -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-tags fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Special Offers</h5>
                    <p class="card-text">Discover latest discounts and deals</p>
                    <a href="${pageContext.request.contextPath}/salon/offers" class="btn btn-primary">View Offers</a>
                </div>
            </div>
        </div>

        <!-- Salon Gallery -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-camera fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Salon Gallery</h5>
                    <p class="card-text">See salon interiors and styles</p>
                    <a href="${pageContext.request.contextPath}/salon/photos" class="btn btn-primary">View Gallery</a>
                </div>
            </div>
        </div>

        <!-- Hygiene Certificate -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-file-medical fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Hygiene Certificate</h5>
                    <p class="card-text">Check salon hygiene certification</p>
                    <a href="${pageContext.request.contextPath}/salon/hygieneForUser" class="btn btn-primary">View Certificate</a>
                </div>
            </div>
        </div>

        <!-- Logout -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-sign-out-alt fa-2x mb-2" style="color:#8e44ad;"></i>
                    <h5 class="card-title">Logout</h5>
                    <p class="card-text">End your current session</p>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

