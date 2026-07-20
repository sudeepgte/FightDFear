package in.sp.main.Service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class RouteService {
    
    private final String GOOGLE_MAPS_API_KEY = "YOUR_GOOGLE_MAPS_API_KEY";

    public String fetchRoutes(String origin, String destination) {
        String url = "https://maps.googleapis.com/maps/api/directions/json?origin=" 
                     + origin + "&destination=" + destination 
                     + "&key=" + GOOGLE_MAPS_API_KEY;
        
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(url, String.class);
    }
}
