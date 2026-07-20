package in.sp.main.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

// Purpose: enable @Scheduled tasks (used for Journey Safety Tracker escalation).
@Configuration
@EnableScheduling
public class SchedulingConfig {}

