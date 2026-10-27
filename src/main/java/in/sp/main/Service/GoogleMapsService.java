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

import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
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

    public Optional<String> reverseGeocode(double lat, double lng) {
        // 1. Try Google Maps Geocoding API if key configured/available
        String key = apiKey();
        if (key != null && !key.isBlank()) {
            try {
                String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
                        + lat + "," + lng + "&key=" + key;
                String json = restTemplate.getForObject(url, String.class);
                if (json != null && !json.isBlank()) {
                    JsonNode root = mapper.readTree(json);
                    if ("OK".equals(root.path("status").asText())) {
                        JsonNode results = root.path("results");
                        if (results.isArray() && results.size() > 0) {
                            String formatted = results.get(0).path("formatted_address").asText();
                            if (formatted != null && !formatted.isBlank()) {
                                return Optional.of(formatted);
                            }
                        }
                    }
                }
            } catch (Exception ignored) {}
        }

        // 2. Fallback to OpenStreetMap Nominatim reverse geocode
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "FightDFear-Safety/1.0 (safety@fightdfear.org)");
            HttpEntity<Void> entity = new HttpEntity<>(headers);
            String osmUrl = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + lat + "&lon=" + lng + "&zoom=18&addressdetails=1";
            ResponseEntity<String> resp = restTemplate.exchange(
                    osmUrl, HttpMethod.GET, entity, String.class);
            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                JsonNode root = mapper.readTree(resp.getBody());
                String formatted = root.path("display_name").asText();
                if (formatted != null && !formatted.isBlank()) {
                    return Optional.of(formatted);
                }
            }
        } catch (Exception ignored) {}

        return Optional.of(String.format(Locale.ROOT, "Lat: %.5f, Lng: %.5f", lat, lng));
    }

    public List<Map<String, Object>> searchLocations(String query) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (query == null || query.isBlank()) return list;

        // 1. Try Google Geocode/Places
        String key = apiKey();
        if (key != null && !key.isBlank()) {
            try {
                String url = "https://maps.googleapis.com/maps/api/geocode/json?address="
                        + URLEncoder.encode(query.trim(), StandardCharsets.UTF_8) + "&key=" + key;
                String json = restTemplate.getForObject(url, String.class);
                if (json != null && !json.isBlank()) {
                    JsonNode root = mapper.readTree(json);
                    if ("OK".equals(root.path("status").asText())) {
                        JsonNode results = root.path("results");
                        if (results.isArray()) {
                            for (JsonNode res : results) {
                                Map<String, Object> item = new LinkedHashMap<>();
                                item.put("address", res.path("formatted_address").asText(""));
                                JsonNode loc = res.path("geometry").path("location");
                                item.put("lat", loc.path("lat").asDouble());
                                item.put("lng", loc.path("lng").asDouble());
                                list.add(item);
                            }
                            if (!list.isEmpty()) return list;
                        }
                    }
                }
            } catch (Exception ignored) {}
        }

        // 2. Fallback to Nominatim search
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "FightDFear-Safety/1.0 (safety@fightdfear.org)");
            HttpEntity<Void> entity = new HttpEntity<>(headers);
            String osmUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
                    + URLEncoder.encode(query.trim(), StandardCharsets.UTF_8) + "&addressdetails=1&limit=5";
            ResponseEntity<String> resp = restTemplate.exchange(
                    osmUrl, HttpMethod.GET, entity, String.class);
            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                JsonNode root = mapper.readTree(resp.getBody());
                if (root.isArray()) {
                    for (JsonNode res : root) {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("address", res.path("display_name").asText(""));
                        item.put("lat", res.path("lat").asDouble());
                        item.put("lng", res.path("lon").asDouble());
                        list.add(item);
                    }
                }
            }
        } catch (Exception ignored) {}

        return list;
    }

    public record LatLng(double lat, double lng) {}

    public record Directions(int etaMinutes, double remainingKm, String polyline, List<LatLng> points) {}
}
