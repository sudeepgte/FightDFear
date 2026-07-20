package in.sp.main.Service;

import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import weka.classifiers.trees.J48;
import weka.core.DenseInstance;
import weka.core.Instances;
import weka.core.Attribute;
import weka.core.converters.ConverterUtils.DataSource;
import weka.core.SerializationHelper;

@Service
public class AISafetyService {
    private static final Logger logger = LoggerFactory.getLogger(AISafetyService.class);
    private J48 model;
    private boolean modelAvailable = false;

    public AISafetyService() {
        try {
            File modelFile = new File("safety_model.model");
            if (modelFile.exists()) {
                logger.info("🤖 Loading pre-trained safety model...");
                model = (J48) SerializationHelper.read(modelFile.getAbsolutePath());
                modelAvailable = true;
                logger.info("✅ Safety model loaded successfully");
            } else {
                logger.warn("⚠️ No pre-trained model found. Attempting to train...");
                trainModel();
            }
        } catch (Exception e) {
            logger.error("❌ Failed to load/train AI safety model: {}", e.getMessage());
            logger.warn("⚠️ AI safety predictions will be unavailable until model is trained");
            logger.info("💡 To enable: Add crime_data.arff to project root directory");
            modelAvailable = false;
        }
    }

    public void trainModel() throws Exception {
        File arffFile = new File("crime_data.arff");
        
        if (!arffFile.exists()) {
            logger.error("❌ Training data file not found: crime_data.arff");
            logger.info("💡 Please add the ARFF file to project root directory");
            throw new RuntimeException("Training data file not found: crime_data.arff");
        }
        
        logger.info("📊 Training safety model with crime_data.arff...");
        
        // ✅ Use DataSource instead of FileReader
        DataSource source = new DataSource(arffFile.getAbsolutePath());
        Instances dataset = source.getDataSet();
        
        if (dataset == null || dataset.numInstances() == 0) {
            throw new RuntimeException("Training dataset is empty or invalid");
        }
        
        // ✅ Set class index dynamically
        dataset.setClassIndex(dataset.numAttributes() - 1);

        model = new J48();
        model.buildClassifier(dataset);

        SerializationHelper.write("safety_model.model", model);
        modelAvailable = true;
        
        logger.info("✅ Safety model trained and saved successfully");
        logger.info("📈 Training instances: {}", dataset.numInstances());
        logger.info("📊 Attributes: {}", dataset.numAttributes());
    }

    /**
     * Predict safety level based on crime statistics
     * @param crimeRate Overall crime rate
     * @param nightTimeCrime Night time crime index
     * @param policeStations Number of police stations nearby
     * @return "Safe" or "Unsafe"
     */
    public String predictSafety(int crimeRate, int nightTimeCrime, int policeStations) throws Exception {
        if (!modelAvailable || model == null) {
            logger.warn("⚠️ AI model not available. Returning default prediction: Unsafe");
            return "Unsafe"; // Default to safe side
        }
        
        //  Define attributes
        ArrayList<Attribute> attributes = new ArrayList<>();
        attributes.add(new Attribute("crime_rate"));
        attributes.add(new Attribute("night_time_crime"));
        attributes.add(new Attribute("police_stations"));

        List<String> classValues = List.of("Unsafe", "Safe");
        attributes.add(new Attribute("safety_label", classValues));

        Instances dataset = new Instances("PredictSafety", attributes, 0);
        dataset.setClassIndex(dataset.numAttributes() - 1); // ✅ Fix class index

        //  Create an instance with correct size
        DenseInstance instance = new DenseInstance(dataset.numAttributes());
        instance.setValue(attributes.get(0), crimeRate);
        instance.setValue(attributes.get(1), nightTimeCrime);
        instance.setValue(attributes.get(2), policeStations);

        dataset.add(instance);

        double result = model.classifyInstance(dataset.firstInstance());
        String prediction = classValues.get((int) result);
        
        logger.info("🔮 AI Prediction: crimeRate={}, nightCrime={}, police={}, result={}", 
                   crimeRate, nightTimeCrime, policeStations, prediction);
        
        return prediction;
    }
    
    /**
     * Check if AI model is available
     */
    public boolean isModelAvailable() {
        return modelAvailable;
    }
}
