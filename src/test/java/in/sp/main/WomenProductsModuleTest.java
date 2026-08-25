package in.sp.main;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Service.WomenProductOrderLifecycleService;
import in.sp.main.Service.WomenProductsCareService;
import in.sp.main.Util.ProductCategories;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class WomenProductsModuleTest {

    @Test
    void canonicalCategoriesMatchWebShop() {
        assertEquals(WomenProduct.CATEGORY_CODES, ProductCategories.CODES);
        assertEquals("SKINCARE", ProductCategories.normalize("Skincare"));
        assertEquals("SKINCARE", ProductCategories.normalize("BEAUTY"));
        assertEquals("CLOTHING", ProductCategories.normalize("FASHION"));
        assertEquals("WELLNESS", ProductCategories.normalize("FITNESS"));
        assertTrue(ProductCategories.isKnown("HAIRCARE"));
        assertFalse(ProductCategories.isKnown("NOT_A_CATEGORY"));
    }

    @Test
    void filterMatchesCanonicalAndLegacyMobileCodes() {
        assertTrue(ProductCategories.matchesFilter("SKINCARE", null));
        assertTrue(ProductCategories.matchesFilter("SKINCARE", "SKINCARE"));
        assertTrue(ProductCategories.matchesFilter("HAIRCARE", "BEAUTY"));
        assertTrue(ProductCategories.matchesFilter("CLOTHING", "FASHION"));
        assertTrue(ProductCategories.matchesFilter("ACCESSORIES", "FASHION"));
        assertFalse(ProductCategories.matchesFilter("SKINCARE", "CLOTHING"));
        assertTrue(ProductCategories.matchesFilter("WELLNESS", "FITNESS"));
    }

    @Test
    void publicImagePathNormalizesUploads() {
        assertNull(WomenProduct.toPublicUploadPath(null));
        assertEquals("/uploads/a.jpg", WomenProduct.toPublicUploadPath("a.jpg"));
        assertEquals("/uploads/a.jpg", WomenProduct.toPublicUploadPath("uploads/a.jpg"));
        assertEquals("/uploads/a.jpg", WomenProduct.toPublicUploadPath("C:/data/uploads/a.jpg"));
        assertEquals("https://cdn.example/x.png", WomenProduct.toPublicUploadPath("https://cdn.example/x.png"));

        WomenProduct p = new WomenProduct();
        p.setImagePath("photo.png");
        p.setAdditionalImagePaths("one.jpg, two.jpg");
        assertEquals("/uploads/photo.png", p.getPublicImagePath());
        assertFalse(p.isRemoteImage());
        assertEquals(2, p.getPublicAdditionalImagePaths().size());
    }

    @Test
    void discountAndListingRules() {
        WomenProduct p = new WomenProduct();
        p.setPrice(80d);
        p.setOriginalPrice(100d);
        assertEquals(20, p.getDiscountPercent());

        p.setActive(true);
        p.setDeleted(false);
        assertFalse(p.isListedForShop());

        WomenProductSeller seller = new WomenProductSeller();
        seller.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        p.setSeller(seller);
        assertTrue(p.isListedForShop());

        seller.setPartnerProfileStatus(PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        assertFalse(p.isListedForShop());

        seller.setPartnerProfileStatus(null);
        seller.setVerificationStatus(VerificationStatus.VERIFIED);
        assertTrue(seller.isApprovedForCatalog());
        assertTrue(p.isListedForShop());
    }

    @Test
    void cancelPolicyMatchesMobileRules() {
        assertTrue(isCancellableStatus("PLACED"));
        assertTrue(isCancellableStatus("CONFIRMED"));
        assertTrue(isCancellableStatus("PROCESSING"));
        assertTrue(isCancellableStatus("PACKED"));
        assertTrue(isCancellableStatus("READY_FOR_PICKUP"));
        assertFalse(isCancellableStatus("ASSIGNED"));
        assertFalse(isCancellableStatus("SHIPPED"));
        assertFalse(isCancellableStatus("DELIVERED"));
        assertFalse(isCancellableStatus("CANCELLED"));
        assertEquals("PLACED", WomenProductsCareService.normStatus("PENDING"));
        assertEquals("SHIPPED", WomenProductsCareService.normStatus("SHIPPED"));
        assertEquals("PICKED_UP", WomenProductsCareService.normStatus("PICKED_UP"));
    }

    @Test
    void orderLifecycleTransitionsAreControlled() {
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("PLACED", "CONFIRMED"));
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("CONFIRMED", "PROCESSING"));
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("PROCESSING", "PACKED"));
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("PACKED", "SHIPPED"));
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("SHIPPED", "OUT_FOR_DELIVERY"));
        assertTrue(WomenProductOrderLifecycleService.sellerMaySet("OUT_FOR_DELIVERY", "DELIVERED"));
        assertFalse(WomenProductOrderLifecycleService.sellerMaySet("CONFIRMED", "READY_FOR_PICKUP"));
        assertFalse(WomenProductOrderLifecycleService.sellerMaySet("DELIVERED", "PROCESSING"));
        assertFalse(WomenProductOrderLifecycleService.sellerMaySet("CANCELLED", "SHIPPED"));
        assertTrue(WomenProductOrderLifecycleService.deliveryMaySet("ASSIGNED", "PICKED_UP"));
        assertTrue(WomenProductOrderLifecycleService.deliveryMaySet("ASSIGNED", "OUT_FOR_DELIVERY"));
        assertTrue(WomenProductOrderLifecycleService.deliveryMaySet("PICKED_UP", "IN_TRANSIT"));
        assertFalse(WomenProductOrderLifecycleService.deliveryMaySet("DELIVERED", "OUT_FOR_DELIVERY"));

        WomenProductOrder placed = new WomenProductOrder();
        placed.setStatus("READY_FOR_PICKUP");
        assertTrue(WomenProductOrderLifecycleService.canAssign(placed));
        placed.setStatus("CANCELLED");
        assertFalse(WomenProductOrderLifecycleService.canAssign(placed));
        placed.setStatus("DELIVERED");
        assertFalse(WomenProductOrderLifecycleService.canAssign(placed));
    }

    /** Mirrors {@link WomenProductsCareService#canCancel} without loading Spring beans. */
    private static boolean isCancellableStatus(String status) {
        WomenProductOrder o = new WomenProductOrder();
        o.setStatus(status);
        return WomenProductOrderLifecycleService.canCancel(o);
    }
}
