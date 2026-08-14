<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Report Volunteer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <style>
        /* Theme Colors */
        :root {
            --lavender-light: #E6E6FA; /* Light Lavender */
            --lavender-dark: #8A2BE2; /* Dark Lavender */
            --golden-star: #FFD700; /* Golden color for stars */
        }

        body {
          background: linear-gradient(to right, #f3e8ff, #e9d5ff); /* Soft Lavender Gradient */
            font-family: 'Poppins', sans-serif;
        }
        
        .report-container {
              max-width: 500px;
            margin: 50px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 10px 20px rgba(123, 44, 191, 0.2);
            border-top: 5px solid #312e81; /* Dark Lavender */
            transition: transform 0.3s ease-in-out;
        }

        .report-container h2 {
            text-align: center;
            color: #6a0572;
            font-weight: bold;
        }

        .form-label {
            font-weight: bold;
            color: #6a0572;
        }

        .form-control {
            border: 2px solid var(--lavender-dark);
            border-radius: 8px;
        }

        .form-control:focus {
            border-color: var(--lavender-dark);
            box-shadow: 0 0 5px var(--lavender-dark);
        }

        /* Star Rating */
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            font-size: 24px;
            color: #ccc;
            cursor: pointer;
            transition: color 0.3s;
        }

        /* Golden fill when selected */
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: var(--golden-star);
        }

        /* Submit Button */
        .btn-submit {
           background: linear-gradient(to right, #312e81, #5a189a); /* Gradient Button */
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-size: 18px;
            font-weight: bold;
            color: white;
            transition: background 0.3s;
        }

        .btn-submit:hover {
           background: linear-gradient(to right, #5a189a, #312e81);
            transform: scale(1.03);
            box-shadow: 0px 5px 12px rgba(123, 44, 191, 0.3);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="report-container">
        <h2>Report Volunteer</h2>
        <form action="${pageContext.request.contextPath}/volunteer/${volunteerId}/report" method="post" enctype="multipart/form-data">
            
            <div class="mb-3">
                <label class="form-label">Your Name</label>
                <input type="text" name="reporterName" class="form-control" placeholder="Enter your name" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Rating</label>
                <div class="star-rating">
                    <input type="radio" name="rating" id="star5" value="5"><label for="star5"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star4" value="4"><label for="star4"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star3" value="3"><label for="star3"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star2" value="2"><label for="star2"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star1" value="1" checked><label for="star1"><i class="fas fa-star"></i></label>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Describe the Issue</label>
                <textarea name="reportText" class="form-control" rows="4" placeholder="Explain your complaint" required></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Upload Evidence (Optional)</label>
                <input type="file" name="evidence" class="form-control">
            </div>

            <button type="submit" class="btn btn-submit w-100">Submit Report</button>

        </form>
    </div>
</div>

</body>
</html>

