package in.sp.main.Controller;

import in.sp.main.Service.LocationDirectoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
public class LocationApiController {

    @Autowired
    private LocationDirectoryService locationDirectoryService;

    @GetMapping({"/api/locations/states", "/marketplace/api/locations/states"})
    public ResponseEntity<Map<String, Object>> getStates() {
        List<String> states = locationDirectoryService.getStates();
        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("states", states);
        res.put("count", states.size());
        return ResponseEntity.ok(res);
    }

    @GetMapping({"/api/locations/cities", "/marketplace/api/locations/cities"})
    public ResponseEntity<Map<String, Object>> getCities(@RequestParam(value = "state", required = false) String state) {
        List<String> cities = locationDirectoryService.getCities(state);
        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("state", state);
        res.put("cities", cities);
        res.put("count", cities.size());
        return ResponseEntity.ok(res);
    }

    @GetMapping({"/api/locations/areas", "/marketplace/api/locations/areas"})
    public ResponseEntity<Map<String, Object>> getAreas(
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "city", required = false) String city) {
        List<String> areas = locationDirectoryService.getAreas(state, city);
        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("state", state);
        res.put("city", city);
        res.put("areas", areas);
        res.put("count", areas.size());
        return ResponseEntity.ok(res);
    }
}
