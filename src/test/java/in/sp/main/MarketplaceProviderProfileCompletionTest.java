package in.sp.main;

import in.sp.main.Controller.LocationApiController;
import in.sp.main.Controller.MarketplaceController;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Service.LocationDirectoryService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
public class MarketplaceProviderProfileCompletionTest {

    @Autowired
    private LocationDirectoryService locationDirectoryService;

    @Autowired
    private LocationApiController locationApiController;

    @Autowired
    private MarketplaceController marketplaceController;

    @Autowired
    private ServiceProviderRepository providerRepo;

    @Test
    @DisplayName("Scenario 4 & 5: Location Directory Service provides 36 States/UTs, cascading cities and areas")
    public void testLocationDirectoryService() {
        // 1. Verify 36 States/UTs
        List<String> states = locationDirectoryService.getStates();
        assertNotNull(states);
        assertEquals(36, states.size());
        assertTrue(states.contains("Maharashtra"));
        assertTrue(states.contains("Karnataka"));
        assertTrue(states.contains("Delhi"));
        assertTrue(states.contains("Tamil Nadu"));

        // 2. Cascading cities for Maharashtra
        List<String> mhCities = locationDirectoryService.getCities("Maharashtra");
        assertNotNull(mhCities);
        assertTrue(mhCities.size() >= 20);
        assertTrue(mhCities.contains("Mumbai"));
        assertTrue(mhCities.contains("Pune"));
        assertFalse(mhCities.contains("Bengaluru")); // Belongs to Karnataka

        // 3. Cascading areas for Mumbai
        List<String> mumbaiAreas = locationDirectoryService.getAreas("Maharashtra", "Mumbai");
        assertNotNull(mumbaiAreas);
        assertTrue(mumbaiAreas.size() >= 15);
        assertTrue(mumbaiAreas.contains("Bandra West"));
        assertTrue(mumbaiAreas.contains("Andheri West"));

        // 4. Empty result handling for unknown city
        List<String> unknownAreas = locationDirectoryService.getAreas("Maharashtra", "NonExistentCity");
        assertNotNull(unknownAreas);
        assertTrue(unknownAreas.isEmpty());
    }

    @Test
    @DisplayName("Location REST API endpoints return JSON data for states, cities, and areas")
    public void testLocationApiController() {
        ResponseEntity<Map<String, Object>> statesRes = locationApiController.getStates();
        assertTrue((Boolean) statesRes.getBody().get("success"));
        assertEquals(36, statesRes.getBody().get("count"));

        ResponseEntity<Map<String, Object>> citiesRes = locationApiController.getCities("Karnataka");
        assertTrue((Boolean) citiesRes.getBody().get("success"));
        List<?> cities = (List<?>) citiesRes.getBody().get("cities");
        assertTrue(cities.contains("Bengaluru Urban"));

        ResponseEntity<Map<String, Object>> areasRes = locationApiController.getAreas("Karnataka", "Bengaluru Urban");
        assertTrue((Boolean) areasRes.getBody().get("success"));
        List<?> areas = (List<?>) areasRes.getBody().get("areas");
        assertTrue(areas.contains("Indiranagar"));
        assertTrue(areas.contains("Koramangala"));
    }

    @Test
    @DisplayName("Scenario 14: Dynamic Profile Completion Percentage is calculated from actual filled fields")
    public void testDynamicProfileCompletionCalculation() {
        ServiceProvider p = new ServiceProvider();
        assertEquals(0, MarketplaceController.calculateProfileCompletionPct(p));

        p.setFullName("Priya Sharma");
        assertEquals(10, MarketplaceController.calculateProfileCompletionPct(p));

        p.setEmail("priya.sharma@example.com");
        assertEquals(20, MarketplaceController.calculateProfileCompletionPct(p));

        p.setCategory(ProviderCategory.YOGA_TRAINER);
        assertEquals(30, MarketplaceController.calculateProfileCompletionPct(p));

        p.setPhone("9876543210");
        assertEquals(40, MarketplaceController.calculateProfileCompletionPct(p));

        p.setState("Maharashtra");
        assertEquals(50, MarketplaceController.calculateProfileCompletionPct(p));

        p.setCity("Mumbai");
        assertEquals(60, MarketplaceController.calculateProfileCompletionPct(p));

        p.setServiceArea("Bandra West");
        assertEquals(70, MarketplaceController.calculateProfileCompletionPct(p));

        p.setDescription("Certified Yoga and Meditation master with 8 years of personalized wellness training.");
        assertEquals(80, MarketplaceController.calculateProfileCompletionPct(p));

        p.setQualification("M.Sc Yoga Science & RYT-500");
        assertEquals(90, MarketplaceController.calculateProfileCompletionPct(p));

        p.setIdentityDocumentPath("/uploads/identity_doc_123.pdf");
        assertEquals(100, MarketplaceController.calculateProfileCompletionPct(p));
    }

    @Test
    @DisplayName("Scenario 12, 13 & 15: Full Profile Submission, Draft Saving, and Status Transitions")
    public void testProfileSaveAndSubmitWorkflow() {
        String testEmail = "test.provider." + System.currentTimeMillis() + "@example.com";
        ServiceProvider provider = new ServiceProvider();
        provider.setFullName("Ananya Verma");
        provider.setEmail(testEmail);
        provider.setPassword("encodedpass123");
        provider.setCategory(ProviderCategory.BABYSITTER);
        provider.setVerificationStatus(VerificationStatus.PENDING);
        provider.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
        provider.setProfileCompletionPct(20);
        provider = providerRepo.save(provider);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedProvider", provider);

        // 1. Test Draft Save (incomplete data allowed, does not submit for admin review)
        Model model = new ExtendedModelMap();
        RedirectAttributes ra = new RedirectAttributesModelMap();
        String draftResult = marketplaceController.providerProfileCompletionSubmit(
                "9876543210",
                "Maharashtra",
                "Mumbai",
                "Andheri West",
                "Plot 42, Link Road",
                "400053",
                "Andheri West, Mumbai, Maharashtra",
                "Initial brief note",
                "BABYSITTER",
                "Ananya Childcare",
                "Diploma in Early Childhood",
                "4 years",
                "Mon - Fri",
                "08:00 AM",
                "06:00 PM",
                "English, Hindi",
                450.0,
                "draft",
                null,
                null,
                session,
                model,
                ra
        );

        assertEquals("redirect:/marketplace/provider/profile-completion", draftResult);
        ServiceProvider draftProvider = providerRepo.findById(provider.getId()).orElseThrow();
        assertEquals(PartnerProfileStatus.PROFILE_INCOMPLETE, draftProvider.getPartnerProfileStatus());
        assertEquals("Maharashtra", draftProvider.getState());
        assertEquals("Mumbai", draftProvider.getCity());
        assertEquals("Andheri West", draftProvider.getServiceArea());

        // 2. Test Validation Failure on Submit with invalid phone
        Model submitFailModel = new ExtendedModelMap();
        RedirectAttributes failRa = new RedirectAttributesModelMap();
        String failResult = marketplaceController.providerProfileCompletionSubmit(
                "123", // invalid phone
                "Maharashtra",
                "Mumbai",
                "Andheri West",
                "Plot 42",
                "400053",
                null,
                "Experienced childcare professional dedicated to safe and engaging child development.",
                "BABYSITTER",
                "Ananya Childcare",
                "Diploma",
                "4 years",
                "Mon - Fri",
                "08:00 AM",
                "06:00 PM",
                "English, Hindi",
                500.0,
                "submit",
                null,
                null,
                session,
                submitFailModel,
                failRa
        );
        assertEquals("marketplace/provider-profile-completion", failResult);
        assertTrue(submitFailModel.containsAttribute("error"));

        // 3. Test Successful Submission for Admin Verification
        Model validModel = new ExtendedModelMap();
        RedirectAttributes validRa = new RedirectAttributesModelMap();
        MockMultipartFile validPdf = new MockMultipartFile(
                "identityDoc",
                "aadhaar_card.pdf",
                "application/pdf",
                "%PDF-1.4\nMock PDF content for identity verification\n%%EOF".getBytes()
        );

        String successResult = marketplaceController.providerProfileCompletionSubmit(
                "9876543210",
                "Maharashtra",
                "Mumbai",
                "Andheri West",
                "Plot 42, Link Road",
                "400053",
                null,
                "Experienced and caring childcare specialist with certified first aid training and infant care expertise.",
                "BABYSITTER",
                "Ananya Childcare Services",
                "Certified Childcare Specialist",
                "5 Years",
                "Mon - Sat",
                "08:00 AM",
                "07:00 PM",
                "English, Hindi",
                500.0,
                "submit",
                validPdf,
                null,
                session,
                validModel,
                validRa
        );

        assertEquals("redirect:/marketplace/provider/dashboard", successResult);
        ServiceProvider submittedProvider = providerRepo.findById(provider.getId()).orElseThrow();
        assertEquals(PartnerProfileStatus.PENDING_ADMIN_APPROVAL, submittedProvider.getPartnerProfileStatus());
        assertEquals(VerificationStatus.PENDING, submittedProvider.getVerificationStatus());
        assertNotNull(submittedProvider.getSubmittedForVerificationAt());
        assertTrue(submittedProvider.getProfileCompletionPct() >= 90);

        // Cleanup
        providerRepo.delete(submittedProvider);
    }

    @Test
    @DisplayName("Scenario 16: Changes Requested Resubmission moves to Re-verification queue")
    public void testChangesRequestedResubmissionWorkflow() {
        String testEmail = "reverify.provider." + System.currentTimeMillis() + "@example.com";
        ServiceProvider provider = new ServiceProvider();
        provider.setFullName("Ritu Chawla");
        provider.setEmail(testEmail);
        provider.setPassword("encodedpass123");
        provider.setCategory(ProviderCategory.TUTOR);
        provider.setVerificationStatus(VerificationStatus.CHANGES_REQUESTED);
        provider.setPartnerProfileStatus(PartnerProfileStatus.CHANGES_REQUESTED);
        provider.setChangesRequestedNote("Please update your official contact phone and specify your tutoring locality.");
        provider = providerRepo.save(provider);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedProvider", provider);

        Model model = new ExtendedModelMap();
        RedirectAttributes ra = new RedirectAttributesModelMap();
        String result = marketplaceController.providerProfileCompletionSubmit(
                "9123456789",
                "Delhi",
                "Delhi",
                "Dwarka",
                "Sector 12, Dwarka",
                "110078",
                null,
                "Experienced mathematics and science tutor teaching students for over 7 years with proven results.",
                "TUTOR",
                "Ritu Tutoring Hub",
                "M.Sc Mathematics, B.Ed",
                "7 Years",
                "Mon - Sat",
                "04:00 PM",
                "08:00 PM",
                "English, Hindi",
                600.0,
                "submit",
                null,
                null,
                session,
                model,
                ra
        );

        assertEquals("redirect:/marketplace/provider/dashboard", result);
        ServiceProvider resubmitted = providerRepo.findById(provider.getId()).orElseThrow();
        assertEquals(PartnerProfileStatus.READY_FOR_VERIFICATION, resubmitted.getPartnerProfileStatus());
        assertEquals(VerificationStatus.RE_VERIFICATION, resubmitted.getVerificationStatus());

        // Cleanup
        providerRepo.delete(resubmitted);
    }

    @Test
    @DisplayName("Skip for now: Incomplete provider can open dashboard without redirect, features remain locked")
    public void testSkipToProviderDashboardAllowed() {
        String testEmail = "skip.provider." + System.currentTimeMillis() + "@example.com";
        ServiceProvider provider = new ServiceProvider();
        provider.setFullName("Sneha Patil");
        provider.setEmail(testEmail);
        provider.setPassword("encodedpass123");
        provider.setCategory(ProviderCategory.HOME_BAKER);
        provider.setVerificationStatus(VerificationStatus.PENDING);
        provider.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
        provider = providerRepo.save(provider);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedProvider", provider);

        Model model = new ExtendedModelMap();
        String viewName = marketplaceController.providerDashboard(session, model);

        // Asserts dashboard page is returned rather than redirecting back to profile-completion
        assertEquals("marketplace/provider-dashboard", viewName);
        assertNotNull(model.getAttribute("provider"));

        // Cleanup
        providerRepo.delete(provider);
    }

    @Test
    @DisplayName("Profile completion page sets null partner profile status to PROFILE_INCOMPLETE and loads model")
    public void testProviderProfileCompletionPageNullStatusHandling() {
        String testEmail = "incomplete.provider." + System.currentTimeMillis() + "@example.com";
        ServiceProvider provider = new ServiceProvider();
        provider.setFullName("Meera Nair");
        provider.setEmail(testEmail);
        provider.setPassword("encodedpass123");
        provider.setCategory(ProviderCategory.BEAUTICIAN);
        provider.setVerificationStatus(VerificationStatus.PENDING);
        provider.setPartnerProfileStatus(null);
        provider = providerRepo.save(provider);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedProvider", provider);

        Model model = new ExtendedModelMap();
        String view = marketplaceController.providerProfileCompletionPage(session, model);

        assertEquals("marketplace/provider-profile-completion", view);
        ServiceProvider loaded = (ServiceProvider) model.getAttribute("provider");
        assertNotNull(loaded);
        assertEquals(PartnerProfileStatus.PROFILE_INCOMPLETE, loaded.getPartnerProfileStatus());

        // Cleanup
        providerRepo.delete(loaded);
    }
}
