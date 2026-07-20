package in.sp.main.Service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import in.sp.main.Entities.SafeRoute;
import in.sp.main.Repository.SafeRouteRepository;

@Service
public class SafeRouteService {

    @Autowired
    private SafeRouteRepository safeRouteRepository;

    public void addSafeRoute(SafeRoute safeRoute) {
        safeRouteRepository.save(safeRoute);
    }

    public List<SafeRoute> getAllRoutes() {
        return safeRouteRepository.findAll();
    }

    public void deleteRoute(Long id) {
        safeRouteRepository.deleteById(id);
    }
}
