package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class JourneyEscalationJob {

    @Autowired
    private JourneyService journeyService;

    // Purpose: periodically check for overdue journeys and alert emergency contacts.
    @Scheduled(fixedDelay = 60_000)
    public void run() {
        journeyService.alertOverdueJourneys();
    }
}

