package in.sp.main.Service;


import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.LiveLocation;
import in.sp.main.Entities.User;
import in.sp.main.Repository.LiveLocationRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class LiveLocationService {

    @Autowired
    private LiveLocationRepository locationRepository;
    @Autowired
    private UserRepository userRepository;

    public LiveLocation startTracking(Long userId, double latitude, double longitude) {
        LiveLocation location = new LiveLocation();
      //  location.setUserId(userId);
        location.setLatitude(latitude);
        location.setLongitude(longitude);
        return locationRepository.save(location);
    }

    public List<LiveLocation> getActiveTracking(Long userId) {
        return locationRepository.findByUserIdAndIsActiveTrue(userId);
    }

    public void stopTracking(Long userId) {
        List<LiveLocation> activeLocations = locationRepository.findByUserIdAndIsActiveTrue(userId);
        for (LiveLocation location : activeLocations) {
            location.setActive(false);
            location.setTrackingEndTime(java.time.LocalDateTime.now());
            locationRepository.save(location);
        }
    }
    public List<LiveLocation> getAllLocations() {
        return locationRepository.findAll();
    }
    public LiveLocation saveLocation(Double latitude, Double longitude, Long userId) {
        LiveLocation location = new LiveLocation();
        location.setLatitude(latitude);
        location.setLongitude(longitude);
        location.setUserId(userId);
        location.setTimestamp(LocalDateTime.now());
        return locationRepository.save(location);
    }
}

