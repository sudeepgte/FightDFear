package in.sp.main.Service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.Category;
import in.sp.main.Entities.Video;
import in.sp.main.Repository.VideoRepository;
import jakarta.transaction.Transactional;

@Service
public class VideoService {

    @Autowired
    private VideoRepository videoRepository;

    @Transactional
    public void uploadVideo(Video video) {
    	 System.out.println("Saving video: " + video.getTitle() + " | Category: " + video.getCategory());
        videoRepository.save(video);
        System.out.println("video saved");
    }

    public List<Video> getVideosByCategory(Category category) {
        return videoRepository.findByCategory(category);
    }

    public List<Video> getVideosByCategoryAndType(Category category, boolean isReel) {
        return videoRepository.findByCategoryAndIsReel(category, isReel);
    }

    public List<Video> getAllVideos() {
        return videoRepository.findAll();
    }

    public List<Video> getVideosByType(boolean isReel) {
        return videoRepository.findByIsReel(isReel);
    }
    
    @Transactional
    public Video updateVideo(Long id, Video updatedVideo) {
        return videoRepository.findById(id).map(video -> {
            video.setTitle(updatedVideo.getTitle());
            video.setCategory(updatedVideo.getCategory());
            video.setFilePath(updatedVideo.getFilePath());
            return videoRepository.save(video);
        }).orElseThrow(() -> new RuntimeException("Video not found with ID: " + id));
    }

    @Transactional
    public void deleteVideo(Long id) {
        if (videoRepository.existsById(id)) {
            videoRepository.deleteById(id);
        } else {
            throw new RuntimeException("Video not found with ID: " + id);
        }
    }
    public Video getVideoById(Long id) {
        return videoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Video not found with ID: " + id));
    }
}
