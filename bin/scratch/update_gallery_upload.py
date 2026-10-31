p = 'src/main/java/in/sp/main/Controller/MartialArtsCenterController.java'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

target = """            if (galleryFiles != null) {
                for (MultipartFile f : galleryFiles) {
                    if (f != null && !f.isEmpty()) {
                        center.getGalleryPhotos().add(fileuploadService.saveFile(f));
                    }
                }
            }"""

repl = """            if (galleryFiles != null) {
                if (center.getGalleryPhotos() == null) {
                    center.setGalleryPhotos(new ArrayList<>());
                }
                for (MultipartFile f : galleryFiles) {
                    if (f != null && !f.isEmpty()) {
                        String saved = fileuploadService.saveFile(f);
                        if (saved != null && !saved.isBlank()) {
                            center.getGalleryPhotos().add(saved);
                        }
                    }
                }
            }"""

assert target in content, 'gallery target not found'
content = content.replace(target, repl, 1)

with open(p, 'w', encoding='utf-8', newline='') as f:
    f.write(content)

print('Updated gallery upload handling in MartialArtsCenterController')
