package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Repository.WomenProductOrderRepository;

@Service
public class ProductDeliveryTrackingService {

    private static final int ROUTE_REFRESH_SECONDS = 25;

    @Autowired
    private WomenProductOrderRepository orderRepo;
    @Autowired
    private GoogleMapsService maps;

    @Transactional
    public WomenProductOrder ensureGeocoded(WomenProductOrder order) {
        if (order == null) return null;
        boolean recentlyTried = order.getRouteUpdatedAt() != null
                && order.getRouteUpdatedAt().isAfter(LocalDateTime.now().minusMinutes(2));
        boolean changed = false;
        if (order.getDropLat() == null || order.getDropLng() == null) {
            if (!recentlyTried) {
                Optional<GoogleMapsService.LatLng> drop = maps.geocode(order.getShippingAddress());
                if (drop.isPresent()) {
                    order.setDropLat(drop.get().lat());
                    order.setDropLng(drop.get().lng());
                    changed = true;
                } else {
                    order.setRouteUpdatedAt(LocalDateTime.now());
                    changed = true;
                }
            }
        }
        if ((order.getPickupLat() == null || order.getPickupLng() == null) && order.getSeller() != null) {
            if (!recentlyTried) {
                Optional<GoogleMapsService.LatLng> pickup = maps.geocode(order.getSeller().getAddress());
                if (pickup.isPresent()) {
                    order.setPickupLat(pickup.get().lat());
                    order.setPickupLng(pickup.get().lng());
                    changed = true;
                } else {
                    order.setRouteUpdatedAt(LocalDateTime.now());
                    changed = true;
                }
            }
        }
        if (order.getRoutePolyline() == null
                && order.getPickupLat() != null && order.getPickupLng() != null
                && order.getDropLat() != null && order.getDropLng() != null
                && !recentlyTried) {
            Optional<GoogleMapsService.Directions> dir = maps.directions(
                    new GoogleMapsService.LatLng(order.getPickupLat(), order.getPickupLng()),
                    new GoogleMapsService.LatLng(order.getDropLat(), order.getDropLng()));
            if (dir.isPresent()) {
                order.setEtaMinutes(dir.get().etaMinutes());
                order.setRemainingKm(dir.get().remainingKm());
                order.setRoutePolyline(dir.get().polyline());
            }
            order.setRouteUpdatedAt(LocalDateTime.now());
            changed = true;
        }
        return changed ? orderRepo.save(order) : order;
    }

    @Transactional
    public WomenProductOrder updateCourierLocation(WomenProductOrder order, double lat, double lng) {
        if (order == null) return null;
        order.setCourierLat(lat);
        order.setCourierLng(lng);
        order.setCourierLocationAt(LocalDateTime.now());
        ensureGeocoded(order);
        refreshRouteIfNeeded(order, false);
        return orderRepo.save(order);
    }

    @Transactional
    public WomenProductOrder refreshRouteIfNeeded(WomenProductOrder order, boolean force) {
        if (order == null || order.getCourierLat() == null || order.getCourierLng() == null) return order;
        if (!force && order.getRouteUpdatedAt() != null
                && order.getRouteUpdatedAt().isAfter(LocalDateTime.now().minusSeconds(ROUTE_REFRESH_SECONDS))) {
            return order;
        }
        GoogleMapsService.LatLng origin = new GoogleMapsService.LatLng(order.getCourierLat(), order.getCourierLng());
        GoogleMapsService.LatLng dest = destinationFor(order);
        if (dest == null) return order;
        Optional<GoogleMapsService.Directions> dir = maps.directions(origin, dest);
        if (dir.isPresent()) {
            GoogleMapsService.Directions d = dir.get();
            order.setEtaMinutes(d.etaMinutes());
            order.setRemainingKm(d.remainingKm());
            order.setRoutePolyline(d.polyline());
            order.setRouteUpdatedAt(LocalDateTime.now());
        } else {
            order.setRemainingKm(maps.haversineKm(origin, dest));
            order.setRouteUpdatedAt(LocalDateTime.now());
        }
        return order;
    }

    @Transactional
    public Map<String, Object> trackPayload(WomenProductOrder order) {
        ensureGeocoded(order);
        String status = WomenProductOrderLifecycleService.canonical(order.getStatus());
        boolean live = isLive(status) && order.getCourierLat() != null && order.getCourierLng() != null;
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("orderId", order.getId());
        m.put("status", status);
        m.put("live", live);
        m.put("canLiveTrack", isLive(status) || "DELIVERED".equals(status));
        m.put("trackingNote", order.getTrackingNote());
        m.put("shippingAddress", order.getShippingAddress());
        m.put("etaMinutes", order.getEtaMinutes());
        m.put("remainingKm", order.getRemainingKm());
        m.put("courierUpdatedAt", order.getCourierLocationAt() == null ? null : order.getCourierLocationAt().toString());
        if (order.getProduct() != null) {
            m.put("productName", order.getProduct().getName());
        }
        if (order.getSeller() != null) {
            m.put("sellerName", order.getSeller().getBusinessName());
            m.put("pickupAddress", order.getSeller().getAddress());
        }
        if (order.getDeliveryPartner() != null) {
            m.put("deliveryName", order.getDeliveryPartner().getFullName());
            m.put("deliveryPhone", order.getDeliveryPartner().getPhone());
            m.put("deliveryVehicle", order.getDeliveryPartner().getVehicleType());
        }
        m.put("courier", point(order.getCourierLat(), order.getCourierLng(), "Delivery partner",
                order.getDeliveryPartner() == null ? null : order.getDeliveryPartner().getFullName()));
        m.put("pickup", point(order.getPickupLat(), order.getPickupLng(), "Pickup",
                order.getSeller() == null ? null : order.getSeller().getBusinessName()));
        m.put("drop", point(order.getDropLat(), order.getDropLng(), "Drop", order.getShippingAddress()));
        List<Map<String, Object>> route = new ArrayList<>();
        for (GoogleMapsService.LatLng p : maps.decodePolyline(order.getRoutePolyline())) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("lat", p.lat());
            row.put("lng", p.lng());
            route.add(row);
        }
        m.put("route", route);
        return m;
    }

    public static boolean isLive(String status) {
        return WomenProductOrderLifecycleService.isLiveDelivery(status);
    }

    private GoogleMapsService.LatLng destinationFor(WomenProductOrder order) {
        String status = WomenProductOrderLifecycleService.canonical(order.getStatus());
        if (("ASSIGNED".equals(status) || "PICKED_UP".equals(status))
                && order.getPickupLat() != null && order.getPickupLng() != null) {
            return new GoogleMapsService.LatLng(order.getPickupLat(), order.getPickupLng());
        }
        if (order.getDropLat() != null && order.getDropLng() != null) {
            return new GoogleMapsService.LatLng(order.getDropLat(), order.getDropLng());
        }
        if (order.getPickupLat() != null && order.getPickupLng() != null) {
            return new GoogleMapsService.LatLng(order.getPickupLat(), order.getPickupLng());
        }
        return null;
    }

    private static Map<String, Object> point(Double lat, Double lng, String label, String snippet) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("lat", lat);
        m.put("lng", lng);
        m.put("label", label);
        m.put("snippet", snippet);
        return m;
    }

}
