package in.sp.main.Service;



import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.TrainingProgress;
import in.sp.main.Repository.TrainingProgressRepository;

@Service
public class TrainingServiceImpl implements TrainingService {

    @Autowired
    private TrainingProgressRepository trainingProgressRepository;

    @Override
    public List<TrainingProgress> getAllTrainingProgress() {
        return trainingProgressRepository.findAll();
    }

    @Override
    public Optional<TrainingProgress> getTrainingProgressById(Long id) {
        return trainingProgressRepository.findById(id);
    }

    @Override
    public void saveTrainingProgress(TrainingProgress trainingProgress) {
        trainingProgressRepository.save(trainingProgress);
    }
}
