<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .global-footer {
        background-color: #FFF1F2 !important; /* light pink background */
        color: #0F172A !important;
        border-top: 1px solid #FFE4E6;
        padding-top: 35px;
        padding-bottom: 20px;
        font-family: 'Inter', sans-serif;
    }
    .global-footer h4 {
        color: #F43F5E !important; /* pink titles */
        font-weight: 800;
        font-size: 13px;
        letter-spacing: 1px;
        text-transform: uppercase;
        margin-bottom: 15px;
        border-bottom: 1px solid #FFE4E6;
        padding-bottom: 8px;
        font-family: 'Poppins', sans-serif;
    }
    .global-footer ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .global-footer ul li {
        margin-bottom: 8px;
    }
    .global-footer a {
        color: #475569 !important;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        transition: 0.3s;
    }
    .global-footer a:hover {
        color: #F43F5E !important;
    }
    .global-footer-bottom {
        border-top: 1px solid #FFE4E6;
        margin-top: 25px;
        padding-top: 15px;
        text-align: center;
        font-weight: 700;
        color: #E11D48;
        font-size: 14px;
    }
</style>

<footer id="footer" class="footer position-relative global-footer">
    <div class="container footer-top">
      <div class="row gy-4">
        
        <!-- Column 1: PLATFORM -->
        <div class="col-6 col-md-6 col-lg-3 footer-links mb-4 mb-lg-0">
          <h4>PLATFORM</h4>
          <ul>
            <li><a href="${pageContext.request.contextPath}/sos">Safety</a></li>
            <li><a href="${pageContext.request.contextPath}/sos">Emergency SOS</a></li>
            <li><a href="${pageContext.request.contextPath}/marketplace">Marketplace</a></li>
            <li><a href="${pageContext.request.contextPath}/women-events">Events</a></li>
            <li><a href="${pageContext.request.contextPath}/community">Community</a></li>
          </ul>
        </div>

        <!-- Column 2: WELLNESS -->
        <div class="col-6 col-md-6 col-lg-3 footer-links mb-4 mb-lg-0">
          <h4>WELLNESS</h4>
          <ul>
            <li><a href="${pageContext.request.contextPath}/doctors/list">Women Doctors</a></li>
            <li><a href="${pageContext.request.contextPath}/fitness">Fitness</a></li>
            <li><a href="${pageContext.request.contextPath}/centres">Wellness Centres</a></li>
            <li><a href="${pageContext.request.contextPath}/beauty">Beauty & Self Care</a></li>
          </ul>
        </div>

        <!-- Column 3: BUSINESS -->
        <div class="col-6 col-md-6 col-lg-3 footer-links mb-4 mb-lg-0">
          <h4>BUSINESS</h4>
          <ul>
            <li><a href="${pageContext.request.contextPath}/entrepreneur">Entrepreneurs</a></li>
            <li><a href="${pageContext.request.contextPath}/investors">Women Investors</a></li>
            <li><a href="${pageContext.request.contextPath}/opportunities">Opportunities</a></li>
            <li><a href="${pageContext.request.contextPath}/networking">Networking</a></li>
          </ul>
        </div>

        <!-- Column 4: RESOURCES -->
        <div class="col-6 col-md-6 col-lg-3 footer-links mb-4 mb-lg-0">
          <h4>RESOURCES</h4>
          <ul>
            <li><a href="${pageContext.request.contextPath}/awareness">Awareness</a></li>
            <li><a href="${pageContext.request.contextPath}/safety-tips">Safety Tips</a></li>
            <li><a href="${pageContext.request.contextPath}/health-resources">Health Resources</a></li>
            <li><a href="${pageContext.request.contextPath}/centres">Self Defense</a></li>
          </ul>
        </div>

      </div>
      
      <!-- Footer Copyright Section -->
      <div class="global-footer-bottom">
          &copy; Copyright Fight D Fear All Rights Reserved
      </div>

    </div>

</footer>


  </footer>
  <c:if test="${not empty _csrf}">
    <input type="hidden" id="_global_footer_csrf" name="${_csrf.parameterName}" value="${_csrf.token}" />
  </c:if>
  <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>


