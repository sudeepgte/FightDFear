<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h3>Submit Review for ${stylist.firstName} ${stylist.lastName}</h3>
    <form action="${pageContext.request.contextPath}/users/reviews/add" method="post">
        <input type="hidden" name="stylist.id" value="${stylist.id}"/>
        <div class="mb-3">
            <label>Rating (1–5)</label>
            <input type="number" name="rating" min="1" max="5" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label>Comment</label>
            <textarea name="comment" class="form-control" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit Review</button>
    </form>
</div>

