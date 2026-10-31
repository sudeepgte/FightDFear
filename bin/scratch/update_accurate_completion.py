import re

# 1. Update SalonController.java
controller_path = r"c:\Users\Hp\git\FightDFear\src\main\java\in\sp\main\Controller\SalonController.java"
with open(controller_path, "r", encoding="utf-8") as f:
    controller_src = f.read()

# Replace the old mock completion calculation in dashboard
old_dash_calc = """        // Calculate profile completion percentage
        int completionPercentage = 10;
        if(loggedSalon.getName() != null && !loggedSalon.getName().isEmpty() && loggedSalon.getPhone() != null && !loggedSalon.getPhone().isEmpty()) completionPercentage += 5;
        if(loggedSalon.getSalonCategory() != null && !loggedSalon.getSalonCategory().isEmpty()) completionPercentage += 15;
        completionPercentage += 10; // services done
        if(loggedSalon.getProfileImageUrl() != null && !loggedSalon.getProfileImageUrl().isEmpty()) completionPercentage += 15;
        if(loggedSalon.getHasAc() != null && (loggedSalon.getHasAc() || loggedSalon.getHasWifi() || loggedSalon.getHasParking())) completionPercentage += 15;
        if(loggedSalon.getBusinessRegistrationUrl() != null && !loggedSalon.getBusinessRegistrationUrl().isEmpty()) completionPercentage += 10;
        if(loggedSalon.getSocialMediaJson() != null && !loggedSalon.getSocialMediaJson().isEmpty() && !loggedSalon.getSocialMediaJson().contains("\\"instagram\\":\\"\\"")) completionPercentage += 10;
        if(loggedSalon.getPreferencesJson() != null && !loggedSalon.getPreferencesJson().isEmpty()) completionPercentage += 10;
        if(completionPercentage > 100) completionPercentage = 100;
        model.addAttribute("completionPercentage", completionPercentage);"""

new_dash_calc = """        // Calculate accurate profile completion percentage
        int completionPercentage = calculateAccurateSalonCompletion(loggedSalon, model);"""

controller_src = controller_src.replace(old_dash_calc, new_dash_calc)

# Replace the populateProfileModel in SalonController
old_populate_model = """    private void populateProfileModel(Model model, Salon salon) {
        model.addAttribute("salon", salon);

        int completionPercentage = 10; // Base 10% just for registering
        
        boolean basicDone = salon.getName() != null && !salon.getName().isEmpty() && salon.getPhone() != null && !salon.getPhone().isEmpty();
        if(basicDone) completionPercentage += 5;
        model.addAttribute("stepBasicInfo", basicDone);
        
        boolean detailsDone = salon.getSalonCategory() != null && !salon.getSalonCategory().isEmpty();
        if(detailsDone) completionPercentage += 15;
        model.addAttribute("stepSalonDetails", detailsDone);
        
        boolean servicesDone = true; // mock for now, assuming they have default service or wait until services module
        if(servicesDone) completionPercentage += 10;
        model.addAttribute("stepServices", servicesDone);
        
        boolean photosDone = salon.getProfileImageUrl() != null && !salon.getProfileImageUrl().isEmpty();
        if(photosDone) completionPercentage += 15;
        model.addAttribute("stepPhotos", photosDone);
        
        boolean facilitiesDone = salon.getHasAc() != null && (salon.getHasAc() || salon.getHasWifi() || salon.getHasParking());
        if(facilitiesDone) completionPercentage += 15;
        model.addAttribute("stepFacilities", facilitiesDone);
        
        boolean docsDone = salon.getBusinessRegistrationUrl() != null && !salon.getBusinessRegistrationUrl().isEmpty();
        if(docsDone) completionPercentage += 10;
        model.addAttribute("stepDocs", docsDone);
        model.addAttribute("docsCount", docsDone ? 5 : 0);
        model.addAttribute("docsTotal", 5);
        
        boolean socialDone = salon.getSocialMediaJson() != null && !salon.getSocialMediaJson().isEmpty() && !salon.getSocialMediaJson().contains("\\"instagram\\":\\"\\"");
        if(socialDone) completionPercentage += 10;
        model.addAttribute("stepSocial", socialDone);
        model.addAttribute("socialCount", socialDone ? 4 : 0);
        model.addAttribute("socialTotal", 4);
        
        boolean prefDone = salon.getPreferencesJson() != null && !salon.getPreferencesJson().isEmpty();
        if(prefDone) completionPercentage += 10;
        model.addAttribute("stepPref", prefDone);
        
        if (completionPercentage > 100) completionPercentage = 100;
        model.addAttribute("completionPercentage", completionPercentage);"""

new_populate_model = """    private void populateProfileModel(Model model, Salon salon) {
        model.addAttribute("salon", salon);
        calculateAccurateSalonCompletion(salon, model);"""

controller_src = controller_src.replace(old_populate_model, new_populate_model)

# Add calculateAccurateSalonCompletion helper method before populateProfileModel
accurate_method = """    private int calculateAccurateSalonCompletion(Salon salon, Model model) {
        int filled = 0;
        final int total = 20;

        // Step 1: Basic Information (8 milestones)
        boolean hasName = salon.getName() != null && salon.getName().trim().length() >= 3;
        if (hasName) filled++;

        boolean hasType = (salon.getSalonType() != null && !salon.getSalonType().isBlank())
                || (salon.getSalonCategory() != null && !salon.getSalonCategory().isBlank());
        if (hasType) filled++;

        boolean hasBio = salon.getBio() != null && salon.getBio().trim().length() >= 10;
        if (hasBio) filled++;

        boolean hasPhone = salon.getPhone() != null && salon.getPhone().trim().matches("^[6-9]\\\\d{9}$");
        if (hasPhone) filled++;

        boolean hasEmail = salon.getEmail() != null && salon.getEmail().trim().matches("^[^@\\\\s]+@[^@\\\\s]+\\\\.[^@\\\\s]+$");
        if (hasEmail) filled++;

        boolean hasAddress = salon.getAddress() != null && salon.getAddress().trim().length() >= 5;
        if (hasAddress) filled++;

        boolean hasState = salon.getState() != null && !salon.getState().isBlank();
        if (hasState) filled++;

        boolean hasCity = salon.getCity() != null && !salon.getCity().isBlank();
        if (hasCity) filled++;

        boolean hasPincode = salon.getPincode() != null && salon.getPincode().trim().matches("^\\\\d{6}$");

        boolean stepBasicInfo = hasName && hasType && hasBio && hasPhone && hasAddress && hasState && hasCity && hasPincode;
        if (model != null) model.addAttribute("stepBasicInfo", stepBasicInfo);

        // Step 2: Salon Details (4 milestones)
        boolean hasCategory = salon.getSalonCategory() != null && !salon.getSalonCategory().isBlank();
        if (hasCategory) filled++;

        int currentYear = java.time.Year.now().getValue();
        boolean hasYear = salon.getEstablishedYear() != null && salon.getEstablishedYear() >= 1900 && salon.getEstablishedYear() <= currentYear;
        if (hasYear) filled++;

        boolean hasChairs = salon.getTotalChairs() != null && salon.getTotalChairs() >= 1;
        if (hasChairs) filled++;

        boolean hasSize = salon.getSalonSizeSqFt() != null && salon.getSalonSizeSqFt() >= 50;
        if (hasSize) filled++;

        boolean stepSalonDetails = hasCategory && hasChairs && hasSize;
        if (model != null) model.addAttribute("stepSalonDetails", stepSalonDetails);

        // Step 3: Services (1 milestone)
        List<in.sp.main.Entities.Service1> services = (salon.getId() != null && serviceRepository != null)
                ? serviceRepository.findBySalonId(salon.getId())
                : List.of();
        boolean stepServices = services != null && !services.isEmpty();
        if (stepServices) filled++;
        if (model != null) model.addAttribute("stepServices", stepServices);

        // Step 4: Photos (2 milestones)
        boolean hasProfileImg = salon.getProfileImageUrl() != null && !salon.getProfileImageUrl().isBlank() && !salon.getProfileImageUrl().contains("ui-avatars");
        if (hasProfileImg) filled++;

        boolean hasCoverImg = (salon.getCoverImageUrl() != null && !salon.getCoverImageUrl().isBlank())
                || (salon.getInteriorImagesJson() != null && !salon.getInteriorImagesJson().isBlank() && !salon.getInteriorImagesJson().equals("[]"));
        if (hasCoverImg) filled++;

        boolean stepPhotos = hasProfileImg || hasCoverImg;
        if (model != null) model.addAttribute("stepPhotos", stepPhotos);

        // Step 5: Facilities (1 milestone)
        boolean stepFacilities = Boolean.TRUE.equals(salon.getHasAc())
                || Boolean.TRUE.equals(salon.getHasWifi())
                || Boolean.TRUE.equals(salon.getHasParking())
                || Boolean.TRUE.equals(salon.getHasPowerBackup());
        if (stepFacilities) filled++;
        if (model != null) model.addAttribute("stepFacilities", stepFacilities);

        // Step 6: Documents (2 milestones)
        int docsCount = 0;
        if (salon.getBusinessRegistrationUrl() != null && !salon.getBusinessRegistrationUrl().isBlank()) docsCount++;
        if (salon.getSalonLicenseUrl() != null && !salon.getSalonLicenseUrl().isBlank()) docsCount++;
        if (salon.getGstCertificateUrl() != null && !salon.getGstCertificateUrl().isBlank()) docsCount++;
        if (salon.getHygieneCertificateUrl() != null && !salon.getHygieneCertificateUrl().isBlank()) docsCount++;
        if (salon.getFireSafetyUrl() != null && !salon.getFireSafetyUrl().isBlank()) docsCount++;

        if (docsCount >= 1) filled++;
        if (docsCount >= 2) filled++;
        boolean stepDocs = docsCount > 0;
        if (model != null) {
            model.addAttribute("stepDocs", stepDocs);
            model.addAttribute("docsCount", docsCount);
            model.addAttribute("docsTotal", 5);
        }

        // Step 7: Social Media (1 milestone)
        int socialCount = 0;
        String smJson = salon.getSocialMediaJson();
        if (smJson != null && !smJson.isBlank()) {
            try {
                com.fasterxml.jackson.databind.JsonNode smNode = new com.fasterxml.jackson.databind.ObjectMapper().readTree(smJson);
                if (smNode.has("instagram") && !smNode.get("instagram").asText().isBlank()) socialCount++;
                if (smNode.has("facebook") && !smNode.get("facebook").asText().isBlank()) socialCount++;
                if (smNode.has("website") && !smNode.get("website").asText().isBlank()) socialCount++;
            } catch (Exception ignored) {}
        }
        if (socialCount == 0 && salon.getWebsite() != null && !salon.getWebsite().isBlank()) {
            socialCount++;
        }
        if (socialCount > 0) filled++;
        boolean stepSocial = socialCount > 0;
        if (model != null) {
            model.addAttribute("stepSocial", stepSocial);
            model.addAttribute("socialCount", socialCount);
            model.addAttribute("socialTotal", 3);
        }

        // Step 8: Preferences (1 milestone)
        boolean stepPref = salon.getPreferencesJson() != null && !salon.getPreferencesJson().isBlank() && !salon.getPreferencesJson().equals("{}");
        if (stepPref) filled++;
        if (model != null) model.addAttribute("stepPref", stepPref);

        int pct = Math.min(100, (int) Math.round((100.0 * filled) / total));
        if (model != null) model.addAttribute("completionPercentage", pct);
        return pct;
    }
"""

controller_src = controller_src.replace("    private void populateProfileModel(Model model, Salon salon) {", accurate_method + "\n    private void populateProfileModel(Model model, Salon salon) {")

with open(controller_path, "w", encoding="utf-8") as f:
    f.write(controller_src)

print("SalonController updated with accurate completion calculation.")
