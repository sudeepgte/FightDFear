<%@ page language="java" pageEncoding="UTF-8"%>

<style>
    .global-footer {
        background-color: #1e1b4b !important;
        color: rgba(255, 255, 255, 0.8) !important;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }
    .global-footer h4, .global-footer p {
        color: white !important;
    }
    .global-footer a {
        color: rgba(255, 255, 255, 0.8) !important;
    }
    .global-footer a:hover {
        color: #f43f5e !important;
    }
    .global-footer .sitename {
        color: #f43f5e !important;
    }
</style>

<footer id="footer" class="footer position-relative global-footer">
    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center">
          Fight D Fear
          </a>
             
  <div class="pt-3">
    <p class="fw-semibold">Our Values</p>
	<p>Empowering women to stay safe, strong, and supported through awareness, self-defense, and action.</p>
    <p>Awareness • Safety • Equality • Empowerment</p>
    <p class="mt-2">Building a safer tomorrow, together.</p>
  </div>
</div>
        <div class="col-lg-2 col-md-3 footer-links">
          <h4>Useful Links</h4>
          <ul>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/about">About us</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates#services">Services</a></li>
             <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
              </ul>
        
        </div>

      <div class="col-lg-2 col-md-3 footer-links">
  <h4>Our Services</h4>
  <ul>
    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/sos/dashboard">Emergency Assistance</a></li>
    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/video/allVideos">Safety Education</a></li>
    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Self-defense Training</a></li>
    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/stories">Community Support</a></li>
  </ul>
</div>

<div class="col-lg-4 col-md-12">
  <h4>Follow Us</h4>
  <p>Stay connected with us for safety updates, resources, and tips. Empower yourself and others!</p>
  <jsp:include page="/WEB-INF/views/fragments/social-follow.jsp" />
</div>


      </div>
    </div>

    <div class="container copyright text-center mt-4">
      <p> &copy; Copyright <strong class="px-1 sitename">Fight D Fear</strong> All Rights Reserved</p>
      <div class="credits">
        <!-- All the links in the footer should remain intact. -->
        <!-- You can delete the links only if you've purchased the pro version. -->
        <!-- Licensing information: https://bootstrapmade.com/license/ -->
        <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
       <!--  Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> -->
      </div>
    </div>

  </footer>

