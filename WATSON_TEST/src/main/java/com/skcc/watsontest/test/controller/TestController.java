package com.skcc.watsontest.test.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.skcc.watsontest.test.service.TestService;

@Controller
public class TestController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="testService")
	private TestService testService;
	
	@RequestMapping(value="/home.do")
	public ModelAndView selectTestList(Map<String, Object> commandMap,Locale locale) throws Exception{
		ModelAndView mv = new ModelAndView("home");
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);
		mv.addObject("serverTime", formattedDate);
		
		List<Map<String, Object>> list = testService.selectTestList(commandMap);
		mv.addObject("list", list);
		return mv;
	}
}
