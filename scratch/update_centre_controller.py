p = 'src/main/java/in/sp/main/Controller/MartialArtsCenterController.java'
with open(p, 'r', encoding='utf-8') as f:
    content = f.read()

target1 = """    @RequestMapping(value = "/profile-completion", method = RequestMethod.GET)
    public String showProfileCompletion(HttpSession session, Model model) {
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            return "redirect:/centres/login";
        }
        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        model.addAttribute("center", center);
        return "centreProfileCompletion";
    }"""

repl1 = """    @RequestMapping(value = "/profile-completion", method = RequestMethod.GET)
    public String showProfileCompletion(HttpSession session, Model model) {
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            return "redirect:/centres/login";
        }
        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        if (center.getGalleryPhotos() != null) {
            center.getGalleryPhotos().size();
        }
        if (center.getAvailableDays() != null) {
            center.getAvailableDays().size();
        }
        center = centreProfileService.refreshCompletion(center);
        session.setAttribute("loggedCentre", center);
        model.addAttribute("center", center);
        return "centreProfileCompletion";
    }"""

target2 = '@PostMapping("/submitVerification")'
repl2 = '@PostMapping(value = {"/submitVerification", "/submit-verification"})'

assert target1 in content, 'target1 not found'
assert target2 in content, 'target2 not found'

content = content.replace(target1, repl1, 1).replace(target2, repl2, 1)

with open(p, 'w', encoding='utf-8', newline='') as f:
    f.write(content)

print('Updated MartialArtsCenterController successfully')
