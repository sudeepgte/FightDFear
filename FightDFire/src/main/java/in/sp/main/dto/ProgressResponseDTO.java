package in.sp.main.dto;

import java.util.List;
import java.util.Map;

public class ProgressResponseDTO {
    private Map<String, Integer> skills;
    private String currentBelt;
    private int beltProgress;
    private int trainingStreak;
    private List<String> recentAchievements;

    public ProgressResponseDTO() {}

    public ProgressResponseDTO(Map<String, Integer> skills, String currentBelt, int beltProgress, int trainingStreak, List<String> recentAchievements) {
        this.skills = skills;
        this.currentBelt = currentBelt;
        this.beltProgress = beltProgress;
        this.trainingStreak = trainingStreak;
        this.recentAchievements = recentAchievements;
    }

    public Map<String, Integer> getSkills() { return skills; }
    public void setSkills(Map<String, Integer> skills) { this.skills = skills; }

    public String getCurrentBelt() { return currentBelt; }
    public void setCurrentBelt(String currentBelt) { this.currentBelt = currentBelt; }

    public int getBeltProgress() { return beltProgress; }
    public void setBeltProgress(int beltProgress) { this.beltProgress = beltProgress; }

    public int getTrainingStreak() { return trainingStreak; }
    public void setTrainingStreak(int trainingStreak) { this.trainingStreak = trainingStreak; }

    public List<String> getRecentAchievements() { return recentAchievements; }
    public void setRecentAchievements(List<String> recentAchievements) { this.recentAchievements = recentAchievements; }
}
