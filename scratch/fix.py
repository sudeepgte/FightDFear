import re

with open('src/main/java/in/sp/main/Service/FitnessTrainerProfileService.java', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove all injected blocks first
bad_block = '''if (PartnerLifecycleSupport.blank(trainer.getCertificationsPath())) {
            missing.add("10. Documents & Certification");
        }
        if (PartnerLifecycleSupport.blank(trainer.getGalleryPhotos())) {
            missing.add("11. Studio photos");
        }
        '''
content = content.replace(bad_block, '')

# Now insert it exactly once before the last return missing; in missingItems
# Let's find missingItems function
pattern = r'(if \(PartnerLifecycleSupport\.blank\(trainer\.getSessionMode\(\)\) \|\| trainer\.getTypicalPrice\(\) == null\) \{\s*missing\.add\("8\. Typical session"\);\s*\})(\s*return missing;\s*\})'
replacement = r'\1\n        if (PartnerLifecycleSupport.blank(trainer.getCertificationsPath())) {\n            missing.add("10. Documents & Certification");\n        }\n        if (PartnerLifecycleSupport.blank(trainer.getGalleryPhotos())) {\n            missing.add("11. Studio photos");\n        }\2'

new_content = re.sub(pattern, replacement, content)

with open('src/main/java/in/sp/main/Service/FitnessTrainerProfileService.java', 'w', encoding='utf-8') as f:
    f.write(new_content)
