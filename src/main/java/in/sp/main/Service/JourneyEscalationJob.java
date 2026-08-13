package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import net.javacrumbs.shedlock.spring.annotation.SchedulerLock;

@Component
public class JourneyEscalationJob {

    @Autowired
    private JourneyService journeyService;

    // Purpose: periodically check for overdue journeys and alert emergency contacts.
    @Scheduled(fixedDelay = 60_000)
    @SchedulerLock(name = "JourneyEscalationJob_run", lockAtLeastFor = "50s", lockAtMostFor = "5m")
    public void run() {
        journeyService.alertOverdueJourneys();
    }
}

