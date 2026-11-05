package in.sp.main.Config;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Expose the permanent uploads directory as static resources under /uploads/**.
 * Complements UploadsController so product/seller images remain reachable after restart.
 */
@Configuration
public class UploadResourceConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Uploads are served only by UploadsController (extension + path-traversal checks).
        // A raw static mapping would bypass those controls.
    }
}
