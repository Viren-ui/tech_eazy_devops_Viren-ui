package com.techeazy.devops;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

	    @GetMapping("/")
	        public String home() {
			        return "✅ Successfully Deployed on Cloud!";
				    }
}

