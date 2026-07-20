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
