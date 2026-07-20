package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
public class TrainingProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String moduleName;
    private int progressPercentage;
    private boolean jobAssistanceRequested;
    private boolean financialLiteracyAccessed;

    public TrainingProgress() {}

    public TrainingProgress(String moduleName, int progressPercentage, boolean jobAssistanceRequested, boolean financialLiteracyAccessed) {
        this.moduleName = moduleName;
        this.progressPercentage = progressPercentage;
        this.jobAssistanceRequested = jobAssistanceRequested;
        this.financialLiteracyAccessed = financialLiteracyAccessed;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }

    public int getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(int progressPercentage) { this.progressPercentage = progressPercentage; }

    public boolean isJobAssistanceRequested() { return jobAssistanceRequested; }
    public void setJobAssistanceRequested(boolean jobAssistanceRequested) { this.jobAssistanceRequested = jobAssistanceRequested; }

    public boolean isFinancialLiteracyAccessed() { return financialLiteracyAccessed; }
    public void setFinancialLiteracyAccessed(boolean financialLiteracyAccessed) { this.financialLiteracyAccessed = financialLiteracyAccessed; }
}
