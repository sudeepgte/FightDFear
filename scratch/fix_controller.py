import sys
path = 'src/main/java/in/sp/main/Controller/DoctorController.java'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

target = '        session.setAttribute("loggedDoctor", d);\n        model.addAttribute("doctor", d);'
replacement = '        session.setAttribute("loggedDoctor", d);\n        if (d.getProfileCompletionPct() == null || d.getProfileCompletionPct() < 100) return "redirect:/doctors/profile-completion";\n        model.addAttribute("doctor", d);'
if target in content:
    content = content.replace(target, replacement)
    print("Replaced!")
else:
    print("Not found.")

target_skip = '        if ("skip".equals(action)) {\n            return "redirect:/doctors/dashboard";\n        }'
if target_skip in content:
    content = content.replace(target_skip, '')
    print("Removed skip!")
else:
    print("Skip not found.")
    
with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
