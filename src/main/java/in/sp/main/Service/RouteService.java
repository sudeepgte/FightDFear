package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class RouteService {

    @Value("${google.maps.apiKey:}")
    private String googleMapsApiKey;

    public String fetchRoutes(String origin, String destination) {
        if (googleMapsApiKey == null || googleMapsApiKey.isBlank()) {
            throw new IllegalStateException("google.maps.apiKey / GOOGLE_MAPS_API_KEY is not configured");
        }
        String url = "https://maps.googleapis.com/maps/api/directions/json?origin="
                     + origin + "&destination=" + destination
                     + "&key=" + googleMapsApiKey;

        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(url, String.class);
    }
}
