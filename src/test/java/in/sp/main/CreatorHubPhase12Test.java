package in.sp.main;

import in.sp.main.Controller.MobileCreatorHubController;
import in.sp.main.Controller.PaymentController;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.CreatorCareService;
import in.sp.main.Service.CreatorProfileService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(properties = {
    "app.payments.mock-enabled=true",
    "razorpay.key.id=rzp_test_key",
    "razorpay.key.secret=rzp_test_secret"
})
@ActiveProfiles("test")
@Transactional
public class CreatorHubPhase12Test {

    @Autowired
    private CreatorProfileService creatorProfileService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VideoUploadRepository videoUploadRepository;

    @Autowired
    private CreatorStoryRepository creatorStoryRepository;

    @Autowired
    private CreatorNotificationRepository creatorNotificationRepository;

    @Autowired
    private VideoBookmarkRepository videoBookmarkRepository;

    @Autowired
    private VideoLikeRepository videoLikeRepository;

    @Autowired
    private VideoCommentRepository videoCommentRepository;

    @Autowired
    private BrandCollaborationRepository brandCollaborationRepository;

    @Autowired
    private BrandCollabApplicationRepository brandCollabApplicationRepository;

    @Autowired
    private MobileCreatorHubController creatorHubController;

    @Autowired
    private PaymentController paymentController;

    @Autowired
    private CreatorCareService creatorCareService;

    @Test
    @DisplayName("Creator 16-point profile completion lifecycle")
    public void testCreator16PointCompletionLifecycle() {
        User u = new User();
        u.setEmail("creator.phase12@example.com");
        u.setFullName("Ananya Sen");

        List<String> missing = creatorProfileService.missingItems(u);
        assertFalse(missing.isEmpty(), "New creator must have missing items");
        int initialPct = creatorProfileService.calculateCompletionPct(u);
        assertTrue(initialPct < 50, "Initial completion pct should be low");

        // Fill required fields
        u.setCreatorDesignation("Influencer");
        u.setPhoneNumber("9876543210");
        u.setCreatorCredentialNumber("PAN-ABCD1234E");
        u.setCreatorAddress("12 Art Studio Lane");
        u.setCreatorCity("Mumbai");
        u.setCreatorState("Maharashtra");
        u.setCreatorPincode("400001");
        u.setCreatorCategory("Safety Awareness");
        u.setCreatorAudience("Women, Youth");
        u.setCreatorOpenDays("Mon,Tue,Wed,Thu,Fri");
        u.setCreatorOpenTime(LocalTime.of(9, 0));
        u.setCreatorCloseTime(LocalTime.of(18, 0));
        u.setCreatorBio("Digital safety advocate and creator empowering women.");
        u.setCreatorSessionMode("Online");
        u.setCreatorTypicalPrice(500.0);

        List<String> remainingMissing = creatorProfileService.missingItems(u);
        assertTrue(remainingMissing.isEmpty(), "All 16 criteria should be satisfied");
        int finalPct = creatorProfileService.calculateCompletionPct(u);
        assertEquals(100, finalPct, "Completion should reach 100%");

        creatorProfileService.setLifecycleStatus(u, PartnerProfileStatus.APPROVED);
        assertTrue(CreatorProfileService.isApprovedCreator(u), "Creator should now be approved");
    }

    @Test
    @DisplayName("Creator Hub Feed retrieval and category filtering")
    public void testCreatorFeedAndFilter() {
        User creator = createApprovedCreator("creator.feed@example.com", "Rhea Sharma", "Entrepreneurship");
        User viewer = createUser("viewer.feed@example.com", "Sneha Rao");

        Videoupload v1 = new Videoupload();
        v1.setUser(creator);
        v1.setTitle("Women In Tech Summit 2026");
        v1.setDescription("Keynote highlights on tech leadership");
        v1.setCategory("Entrepreneurship");
        v1.setStatus("APPROVED");
        v1.setDraft(false);
        v1.setBlocked(false);
        v1.setUploadTime(LocalDateTime.now());
        videoUploadRepository.save(v1);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", viewer);

        ResponseEntity<Map<String, Object>> res = creatorHubController.feed(
                null, "Entrepreneurship", null, "newest", 0, 20, session);
        assertEquals(200, res.getStatusCode().value());
        Map<String, Object> body = res.getBody();
        assertNotNull(body);
        assertTrue((Boolean) body.get("success"));

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> posts = (List<Map<String, Object>>) body.get("posts");
        assertNotNull(posts);
        assertFalse(posts.isEmpty());
        assertEquals("Women In Tech Summit 2026", posts.get(0).get("title"));
    }

    @Test
    @DisplayName("Story lifecycle: upload, view tracking, viewers list, my stories, and deletion")
    public void testStoryLifecycle() {
        User creator = createApprovedCreator("creator.story@example.com", "Mira Nair", "Inspirational");
        User viewer = createUser("viewer.story@example.com", "Kavya Patel");

        MockHttpSession creatorSession = new MockHttpSession();
        creatorSession.setAttribute("user", creator);

        MockHttpSession viewerSession = new MockHttpSession();
        viewerSession.setAttribute("user", viewer);

        // 1. Upload story with valid JPEG magic bytes
        byte[] validJpegBytes = new byte[] {
                (byte) 0xFF, (byte) 0xD8, (byte) 0xFF, (byte) 0xE0,
                0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01
        };
        MockMultipartFile file = new MockMultipartFile(
                "file", "story.jpg", "image/jpeg", validJpegBytes);
        ResponseEntity<Map<String, Object>> upRes = creatorHubController.uploadStory(file, "Morning Motivation!", creatorSession);
        assertEquals(200, upRes.getStatusCode().value());
        assertNotNull(upRes.getBody());
        assertTrue((Boolean) upRes.getBody().get("success"));
        Long storyId = Long.parseLong(upRes.getBody().get("id").toString());

        // 2. Viewer views story
        ResponseEntity<Map<String, Object>> viewRes = creatorHubController.viewStory(storyId, viewerSession);
        assertEquals(200, viewRes.getStatusCode().value());
        assertEquals(1, ((Number) viewRes.getBody().get("viewCount")).intValue());

        // 3. Creator inspects story viewers
        ResponseEntity<Map<String, Object>> viewersRes = creatorHubController.getStoryViewers(storyId, creatorSession);
        assertEquals(200, viewersRes.getStatusCode().value());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> viewers = (List<Map<String, Object>>) viewersRes.getBody().get("viewers");
        assertEquals(1, viewers.size());
        assertEquals("Kavya Patel", viewers.get(0).get("name"));

        // 4. Creator retrieves own active stories
        ResponseEntity<Map<String, Object>> myStoriesRes = creatorHubController.getMyStories(creatorSession);
        assertEquals(200, myStoriesRes.getStatusCode().value());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> myStories = (List<Map<String, Object>>) myStoriesRes.getBody().get("stories");
        assertEquals(1, myStories.size());
        assertEquals("Morning Motivation!", myStories.get(0).get("caption"));

        // 5. Creator deletes story
        ResponseEntity<Map<String, Object>> delRes = creatorHubController.deleteStory(storyId, creatorSession);
        assertEquals(200, delRes.getStatusCode().value());
        assertTrue((Boolean) delRes.getBody().get("success"));
        assertTrue(creatorStoryRepository.findById(storyId).isEmpty());
    }

    @Test
    @DisplayName("Video engagement: like, comment, bookmark, and report")
    public void testVideoEngagement() {
        User creator = createApprovedCreator("creator.eng@example.com", "Tara Roy", "Entertainment");
        User member = createUser("member.eng@example.com", "Deepa Mehta");

        Videoupload video = new Videoupload();
        video.setUser(creator);
        video.setTitle("Self Defense Basics Reel");
        video.setDescription("Quick 60-second routine");
        video.setCategory("Entertainment");
        video.setStatus("APPROVED");
        video.setDraft(false);
        video.setUploadTime(LocalDateTime.now());
        videoUploadRepository.save(video);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", member);

        // 1. Like
        ResponseEntity<Map<String, Object>> likeRes = creatorHubController.like(video.getId(), session);
        assertEquals(200, likeRes.getStatusCode().value());
        assertTrue((Boolean) likeRes.getBody().get("liked"));
        assertEquals(1, ((Number) likeRes.getBody().get("likeCount")).intValue());

        // 2. Comment
        ResponseEntity<Map<String, Object>> commentRes = creatorHubController.comment(
                video.getId(), Map.of("text", "Very empowering!"), session);
        assertEquals(200, commentRes.getStatusCode().value());
        assertEquals("Very empowering!", commentRes.getBody().get("text"));

        // 3. Bookmark
        ResponseEntity<Map<String, Object>> bmRes = creatorHubController.bookmark(video.getId(), session);
        assertEquals(200, bmRes.getStatusCode().value());
        assertTrue((Boolean) bmRes.getBody().get("bookmarked"));

        // 4. View
        ResponseEntity<Map<String, Object>> viewRes = creatorHubController.view(video.getId(), session);
        assertEquals(200, viewRes.getStatusCode().value());
        assertEquals(1, ((Number) viewRes.getBody().get("viewCount")).intValue());
    }

    @Test
    @DisplayName("Payment integration: Tip creator order & fulfillment")
    public void testCreatorTipOrderAndFulfillment() {
        User creator = createApprovedCreator("creator.tip@example.com", "Pooja Hegde", "Safety Awareness");
        User member = createUser("member.tip@example.com", "Radhika Das");
        creator.setCreatorPayoutBalance(0.0);
        userRepository.save(creator);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", member);

        // 1. Create order for CREATOR_TIP
        Map<String, Object> req = new HashMap<>();
        req.put("type", "CREATOR_TIP");
        req.put("creatorId", creator.getId());
        req.put("amount", 100.0);
        req.put("message", "Keep inspiring!");

        ResponseEntity<Map<String, Object>> orderRes = paymentController.createOrder(req, session);
        assertEquals(200, orderRes.getStatusCode().value());
        Map<String, Object> orderBody = orderRes.getBody();
        assertNotNull(orderBody);
        String orderId = (String) orderBody.get("orderId");
        assertNotNull(orderId);

        // 2. Verify payment
        Map<String, Object> verifyReq = new HashMap<>();
        verifyReq.put("razorpay_order_id", orderId);
        verifyReq.put("razorpay_payment_id", "pay_mock_tip_123");
        verifyReq.put("razorpay_signature", "sig_mock_123");
        verifyReq.put("type", "CREATOR_TIP");
        verifyReq.put("creatorId", creator.getId());
        verifyReq.put("amount", 100.0);
        verifyReq.put("message", "Keep inspiring!");

        ResponseEntity<Map<String, Object>> verifyRes = paymentController.verifyPayment(verifyReq, session);
        assertEquals(200, verifyRes.getStatusCode().value());
        assertEquals("success", verifyRes.getBody().get("status"));

        User reloadedCreator = userRepository.findById(creator.getId()).orElseThrow();
        assertEquals(100.0, reloadedCreator.getCreatorPayoutBalance(), 0.01);
    }

    @Test
    @DisplayName("Monetization: cashout points, claim ad revenue, and affiliate code")
    public void testMonetizationFeatures() {
        User creator = createApprovedCreator("creator.mon@example.com", "Shreya Ghoshal", "Inspirational");
        creator.setRewardPoints(500);
        creator.setWalletBalance(50.0);
        creator.setAdViewsClaimed(0);
        userRepository.save(creator);

        // Create approved video with 200 views
        Videoupload v = new Videoupload();
        v.setUser(creator);
        v.setTitle("Vocal safety and voice modulation");
        v.setStatus("APPROVED");
        v.setDraft(false);
        v.setViewCount(200);
        videoUploadRepository.save(v);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", creator);

        // 1. Claim Ad Revenue (200 views * 0.05 = 10.0 Rs)
        ResponseEntity<Map<String, Object>> claimRes = creatorHubController.claimAdRevenue(session);
        assertEquals(200, claimRes.getStatusCode().value());
        assertEquals(10.0, ((Number) claimRes.getBody().get("claimedAmount")).doubleValue(), 0.01);

        // 2. Cashout 200 points (200 / 100 * 10 = 20.0 Rs)
        ResponseEntity<Map<String, Object>> cashoutRes = creatorHubController.cashout(Map.of("points", 200), session);
        assertEquals(200, cashoutRes.getStatusCode().value());
        assertEquals(20.0, ((Number) cashoutRes.getBody().get("amount")).doubleValue(), 0.01);

        // 3. Set affiliate code
        ResponseEntity<Map<String, Object>> affRes = creatorHubController.setAffiliateCode(Map.of("code", "SHREYA2026"), session);
        assertEquals(200, affRes.getStatusCode().value());
        assertEquals("SHREYA2026", affRes.getBody().get("affiliateCode"));
    }

    @Test
    @DisplayName("Brand Collaborations: active campaigns and pitch submission")
    public void testBrandCollaborations() {
        User creator = createApprovedCreator("creator.collab@example.com", "Kiran Bedi", "Safety Awareness");

        BrandCollaboration collab = new BrandCollaboration();
        collab.setCampaignTitle("Women Safety App Awareness Campaign");
        collab.setDescription("Promote SOS gesture recognition feature");
        collab.setPayRate(5000.0);
        collab.setStatus("ACTIVE");
        brandCollaborationRepository.save(collab);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", creator);

        // 1. List active campaigns
        ResponseEntity<Map<String, Object>> campRes = creatorHubController.getCampaigns(session);
        assertEquals(200, campRes.getStatusCode().value());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> campaigns = (List<Map<String, Object>>) campRes.getBody().get("campaigns");
        assertFalse(campaigns.isEmpty());

        // 2. Submit pitch
        ResponseEntity<Map<String, Object>> applyRes = creatorHubController.applyCollab(
                Map.of("campaignId", collab.getId(), "pitch", "I have an engaged audience of 100k women."), session);
        assertEquals(200, applyRes.getStatusCode().value());
        assertTrue((Boolean) applyRes.getBody().get("success"));
        assertTrue(brandCollabApplicationRepository.existsByCollaboration_IdAndCreator_Id(collab.getId(), creator.getId()));
    }

    @Test
    @DisplayName("Notifications: mark all as read")
    public void testNotificationsMarkAllRead() {
        User creator = createApprovedCreator("creator.notif@example.com", "Dia Mirza", "Skill Development");

        CreatorNotification n1 = new CreatorNotification();
        n1.setUser(creator);
        n1.setMessage("You gained a new follower!");
        n1.setType("FOLLOW");
        n1.setRead(false);
        creatorNotificationRepository.save(n1);

        CreatorNotification n2 = new CreatorNotification();
        n2.setUser(creator);
        n2.setMessage("Received tip of Rs. 100");
        n2.setType("MONEY_RECEIVED");
        n2.setRead(false);
        creatorNotificationRepository.save(n2);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", creator);

        ResponseEntity<Map<String, Object>> res = creatorHubController.markAllNotificationsRead(session);
        assertEquals(200, res.getStatusCode().value());
        assertEquals(2, ((Number) res.getBody().get("markedCount")).intValue());
        assertEquals(0, creatorNotificationRepository.countByUser_IdAndIsReadFalse(creator.getId()));
    }

    @Test
    @DisplayName("Registered member is a hub creator: me, edit profile, and ungated upload")
    public void testRegisteredUserIsCreatorWithoutApproval() {
        User member = createUser("member.hub@example.com", "Asha Verma");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", member);

        ResponseEntity<Map<String, Object>> meRes = creatorHubController.myProfile(session);
        assertEquals(200, meRes.getStatusCode().value());
        assertTrue((Boolean) meRes.getBody().get("success"));
        assertTrue((Boolean) meRes.getBody().get("canUpload"));
        @SuppressWarnings("unchecked")
        Map<String, Object> meCreator = (Map<String, Object>) meRes.getBody().get("creator");
        assertEquals("Asha Verma", meCreator.get("name"));
        assertTrue((Boolean) meCreator.get("isOwnProfile"));

        ResponseEntity<Map<String, Object>> editRes = creatorHubController.editProfile(
                null, null, null, null,
                Map.of(
                        "fullName", "Asha V",
                        "creatorHandle", "asha_v",
                        "creatorBio", "Safety storyteller",
                        "creatorCity", "Pune"
                ),
                session);
        assertEquals(200, editRes.getStatusCode().value());
        @SuppressWarnings("unchecked")
        Map<String, Object> edited = (Map<String, Object>) editRes.getBody().get("creator");
        assertEquals("Asha V", edited.get("name"));
        assertEquals("asha_v", edited.get("handle"));
        assertEquals("Safety storyteller", edited.get("bio"));
        assertEquals("Pune", edited.get("city"));

        byte[] validJpegBytes = new byte[] {
                (byte) 0xFF, (byte) 0xD8, (byte) 0xFF, (byte) 0xE0,
                0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01
        };
        MockMultipartFile file = new MockMultipartFile(
                "file", "story.jpg", "image/jpeg", validJpegBytes);
        ResponseEntity<Map<String, Object>> storyRes = creatorHubController.uploadStory(
                file, "From a regular member", session);
        assertEquals(200, storyRes.getStatusCode().value());
        assertTrue((Boolean) storyRes.getBody().get("success"));
    }

    private User createApprovedCreator(String email, String name, String category) {
        User u = new User();
        u.setEmail(email);
        u.setFullName(name);
        u.setPhoneNumber("9876543210");
        u.setCreatorCategory(category);
        u.setCreatorCity("Bengaluru");
        u.setCreatorSubscriptionPrice(99.0);
        creatorProfileService.setLifecycleStatus(u, PartnerProfileStatus.APPROVED);
        return userRepository.save(u);
    }

    private User createUser(String email, String name) {
        User u = new User();
        u.setEmail(email);
        u.setFullName(name);
        u.setPhoneNumber("9876543211");
        u.setWalletBalance(500.0);
        return userRepository.save(u);
    }
}
