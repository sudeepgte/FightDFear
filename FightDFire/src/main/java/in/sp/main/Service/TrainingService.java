package in.sp.main.Service;


import java.util.List;
import java.util.Optional;

import in.sp.main.Entities.TrainingProgress;

public interface TrainingService {
    List<TrainingProgress> getAllTrainingProgress();
    Optional<TrainingProgress> getTrainingProgressById(Long id);
    void saveTrainingProgress(TrainingProgress trainingProgress);
}
