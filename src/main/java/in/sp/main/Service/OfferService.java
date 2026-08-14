package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import in.sp.main.Entities.Offer;
import in.sp.main.Entities.OfferBooking;
import in.sp.main.Repository.OfferRepository;
import in.sp.main.Repository.OfferBookingRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class OfferService {

    @Autowired
    private OfferRepository offerRepository;

    @Autowired
    private OfferBookingRepository offerBookingRepository;

    // Save or update offer
    public void saveOffer(Offer offer) {
        if (offer == null) {
            throw new IllegalArgumentException("Offer is required.");
        }
        if (offer.getTitle() == null || offer.getTitle().isBlank()) {
            throw new IllegalArgumentException("Offer Title is required.");
        }
        if (offer.getDescription() == null || offer.getDescription().isBlank()) {
            throw new IllegalArgumentException("Detailed Description is required.");
        }
        if (offer.getOriginalPrice() <= 0) {
            throw new IllegalArgumentException("Original Price must be greater than zero.");
        }
        if (offer.getOfferPrice() < 0 || offer.getOfferPrice() >= offer.getOriginalPrice()) {
            throw new IllegalArgumentException("Offer Price must be less than the Original Price.");
        }
        if (offer.getStartDate() == null || offer.getEndDate() == null) {
            throw new IllegalArgumentException("Campaign start and end dates are required.");
        }
        if (!offer.getEndDate().isAfter(offer.getStartDate())) {
            throw new IllegalArgumentException("Campaign End Date must be after the Campaign Start Date.");
        }
        if (offer.getDiscountPercent() <= 0 || offer.getDiscountPercent() >= 100) {
            throw new IllegalArgumentException("Discount must be a number greater than 0 and less than 100.");
        }
        offer.setActive(true);
        offerRepository.save(offer);
    }

    // Get all active offers (within date range)
    public List<Offer> getAllActiveOffers() {
        List<Offer> offers = offerRepository.findByActiveTrue();
        for (Offer offer : offers) {
            if (offer.getEndDate().isBefore(LocalDate.now())) {
                offer.setActive(false);
                offerRepository.save(offer);
            }
        }
        return offerRepository.findByActiveTrue();
    }

    public List<Offer> getOffersBySalonId(Long salonId) {
        return offerRepository.findBySalonId(salonId);
    }

    public void deactivateOffer(int id) {
        Offer offer = offerRepository.findById(id).orElse(null);
        if (offer != null) {
            offer.setActive(false);
            offerRepository.save(offer);
        }
    }

    public Offer getOfferById(int id) {
        return offerRepository.findById(id).orElse(null);
    }

    public void deleteOffer(int id) {
        offerRepository.deleteById(id);
    }

    public Offer getOfferById(Long id) {
        Optional<Offer> offer = offerRepository.findById(id);
        return offer.orElse(null);
    }

    public List<Offer> getActiveOffers() {
        LocalDate today = LocalDate.now();
        return offerRepository.findByActiveTrueAndEndDateGreaterThanEqual(today);
    }

    // ---------------------- OFFER BOOKING MANAGEMENT ----------------------

    public void saveOfferBooking(OfferBooking booking) {
        offerBookingRepository.save(booking);
    }

    public List<OfferBooking> getOfferBookingsBySalonId(Long salonId) {
        return offerBookingRepository.findBySalonId(salonId);
    }

    public List<Offer> getOfferBookingsByUser(String fullName) {
        return offerRepository.findByUser_FullName(fullName);
    }
}
