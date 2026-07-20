package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	
	/*
	 * @RequestMapping("/") public String homepage(Model model) { return
	 * "redirect:/index.html";
	 * 
	 * }
	 */
	@RequestMapping({"/", "/index.html"})
	public String homepage1(Model model)
	{
		return "index";
	}

	@RequestMapping("/heatmap")
	public String heatMapPage(Model model) {
		return "heatmap";
	}
}
