package in.sp.main.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GoogleMapsService {

    private static final String FALLBACK_KEY = "AIzaSyCr_gUF2YzV16dICNphMfnkyjBFurYLKaM";
    private static final Pattern MAPS_Q = Pattern.compile("[?&]q=(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)");
    private static final Pattern MAPS_AT = Pattern.compile("@(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)");

    @Value("${google.maps.apiKey:}")
    private String configuredKey;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper mapper = new ObjectMapper();

    public String apiKey() {
        if (configuredKey != null && !configuredKey.isBlank()) return configuredKey.trim();
        return FALLBACK_KEY;
    }

    public Optional<LatLng> geocode(String address) {
        if (address == null || address.isBlank()) return Optional.empty();
        Optional<LatLng> fromLink = parseMapsLink(address);
        if (fromLink.isPresent()) return fromLink;
        try {
            String url = "https://maps.googleapis.com/maps/api/geocode/json?address="
                    + URLEncoder.encode(address.trim(), StandardCharsets.UTF_8)
                    + "&key=" + apiKey();
            String json = restTemplate.getForObject(url, String.class);
            if (json == null || json.isBlank()) return Optional.empty();
            JsonNode root = mapper.readTree(json);
            if (!"OK".equals(root.path("status").asText())) return Optional.empty();
            JsonNode loc = root.path("results").path(0).path("geometry").path("location");
            if (loc.isMissingNode()) return Optional.empty();
            return Optional.of(new LatLng(loc.path("lat").asDouble(), loc.path("lng").asDouble()));
        } catch (Exception ex) {
            return Optional.empty();
        }
    }

    public Optional<Directions> directions(LatLng origin, LatLng dest) {
        if (origin == null || dest == null) return Optional.empty();
        try {
            String url = "https://maps.googleapis.com/maps/api/directions/json?origin="
                    + origin.lat() + "," + origin.lng()
                    + "&destination=" + dest.lat() + "," + dest.lng()
                    + "&mode=driving&key=" + apiKey();
            String json = restTemplate.getForObject(url, String.class);
            if (json == null || json.isBlank()) return Optional.empty();
            JsonNode root = mapper.readTree(json);
            if (!"OK".equals(root.path("status").asText())) return Optional.empty();
            JsonNode route = root.path("routes").path(0);
            JsonNode leg = route.path("legs").path(0);
            int seconds = leg.path("duration").path("value").asInt(0);
            int meters = leg.path("distance").path("value").asInt(0);
            String encoded = route.path("overview_polyline").path("points").asText(null);
            List<LatLng> points = decodePolyline(encoded);
            int minutes = (int) Math.max(1, Math.ceil(seconds / 60.0));
            double km = Math.round((meters / 1000.0) * 10.0) / 10.0;
            return Optional.of(new Directions(minutes, km, encoded, points));
        } catch (Exception ex) {
            return Optional.empty();
        }
    }

    public double haversineKm(LatLng a, LatLng b) {
        if (a == null || b == null) return 0;
        double r = 6371.0;
        double dLat = Math.toRadians(b.lat() - a.lat());
        double dLng = Math.toRadians(b.lng() - a.lng());
        double sinLat = Math.sin(dLat / 2);
        double sinLng = Math.sin(dLng / 2);
        double h = sinLat * sinLat
                + Math.cos(Math.toRadians(a.lat())) * Math.cos(Math.toRadians(b.lat())) * sinLng * sinLng;
        double km = 2 * r * Math.asin(Math.min(1, Math.sqrt(h)));
        return Math.round(km * 10.0) / 10.0;
    }

    public List<LatLng> decodePolyline(String encoded) {
        List<LatLng> path = new ArrayList<>();
        if (encoded == null || encoded.isBlank()) return path;
        try {
        int index = 0;
        int lat = 0;
        int lng = 0;
        while (index < encoded.length()) {
            int result = 0;
            int shift = 0;
            int b;
            do {
                b = encoded.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20 && index < encoded.length());
            lat += ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
            result = 0;
            shift = 0;
            do {
                b = encoded.charAt(index++) - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20 && index < encoded.length());
            lng += ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
            path.add(new LatLng(lat / 1e5, lng / 1e5));
        }
        return path;
        } catch (Exception ex) {
            return path;
        }
    }

    private Optional<LatLng> parseMapsLink(String raw) {
        Matcher q = MAPS_Q.matcher(raw);
        if (q.find()) {
            return Optional.of(new LatLng(Double.parseDouble(q.group(1)), Double.parseDouble(q.group(2))));
        }
        Matcher at = MAPS_AT.matcher(raw);
        if (at.find()) {
            return Optional.of(new LatLng(Double.parseDouble(at.group(1)), Double.parseDouble(at.group(2))));
        }
        return Optional.empty();
    }

    public record LatLng(double lat, double lng) {}

    public record Directions(int etaMinutes, double remainingKm, String polyline, List<LatLng> points) {}
}
