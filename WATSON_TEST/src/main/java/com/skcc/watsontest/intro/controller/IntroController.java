package com.skcc.watsontest.intro.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.watson.developer_cloud.conversation.v1.ConversationService;
import com.ibm.watson.developer_cloud.conversation.v1.model.MessageRequest;
import com.ibm.watson.developer_cloud.conversation.v1.model.MessageResponse;
import com.skcc.watsontest.intro.service.IntroService;
import com.skcc.watsontest.common.utils.CommandMap;

@Controller
public class IntroController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource(name="introService")
	private IntroService introService;
	
	private final String user_name  = 	"5c7d9eff-ce1b-4911-a733-c20a2a78bef5";
	private final String user_pw	=	"otP7i11utmfj";
	private final String work_id	= 	"9ef72967-08b9-4270-b16f-08f8e01f1ad1";
	
	@RequestMapping(value="/intro.do")
	public ModelAndView intro(Map<String, Object> commandMap) throws Exception{
		ModelAndView mv = new ModelAndView("intro");
		
		return mv;
	}
	

	
	public String firstConversation(HttpServletRequest request) {
		
		String resultText = "";
		Map<String,Object> map = new HashMap<String,Object>();
		
		HttpSession session = request.getSession(true);
		
		//Session이 있으면 읽고 없으면 생성 안함
//		HttpSession session = request.getSession(false);
		
		session.setMaxInactiveInterval(10); //default 30분, 10초간 유효
		
		MessageResponse response;
		ConversationService service = new ConversationService(ConversationService.VERSION_DATE_2016_09_20);
		service.setUsernameAndPassword(user_name, user_pw);
		MessageRequest newMessage = new MessageRequest.Builder().build();
		response = service.message(work_id, newMessage).execute();
		
		
		session.setAttribute("ContextMap", response.getContext()); //담기는 값은 뭐든지 가능( 객체도 가능)
		map = response.getOutput();
		
		System.out.println(response);
		
		resultText = map.get("text").toString();
        
		return resultText;
	}
	
	public String conversation(String message, HttpServletRequest request) {
		
		String resultText = "";
		Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> cmap = new HashMap<String,Object>();
		
		HttpSession session = request.getSession(true);

		
		MessageResponse response;
		System.out.println("Session == " + session.getAttribute("ContextMap"));
		if(session != null){
			cmap = (Map<String, Object>) session.getAttribute("ContextMap");
		}
		
		ConversationService service = new ConversationService(ConversationService.VERSION_DATE_2016_09_20);
		service.setUsernameAndPassword(user_name, user_pw);
		MessageRequest newMessage = new MessageRequest.Builder().inputText(message).context(cmap).build();
		response = service.message(work_id, newMessage).execute();
		
		map = response.getOutput();
		
		if(!"[exception]".equals(map.get("nodes_visited").toString()) ){
			session.setAttribute("ContextMap", response.getContext());
		}
		
		System.out.println(response);
		
		resultText = map.get("text").toString();
        
		return resultText;
	}
	
	@RequestMapping(value = "call.do", produces = "application/json; charset=utf8")
	public @ResponseBody String call(CommandMap commandMap, HttpServletRequest request) throws Exception {
		String message = "";
		// 전달받은 파라미터 출력
		if (commandMap.isEmpty() == false) {
			Iterator<Entry<String, Object>> iterator = commandMap.getMap().entrySet().iterator();
			Entry<String, Object> entry = null;
			while (iterator.hasNext()) {
				entry = iterator.next();
				logger.debug("key : " + entry.getKey() + ", value : " + entry.getValue());
				message = (String) entry.getValue();
			}
			message = conversation(message, request);
		}
		
		String jsonStr = "";
		
		jsonStr = "{ \"resultCd\" : \"S\" ,"
				+ " \"message\" : \""+ message +"\""
				+ " }";
		return jsonStr;
	}
	@RequestMapping(value = "fcall.do", produces = "application/json; charset=utf8")
	public @ResponseBody String firstCall(CommandMap commandMap, HttpServletRequest request) throws Exception {
		String message = "";
		
		message = firstConversation(request);
		
		String jsonStr = "";
		
		jsonStr = "{ \"resultCd\" : \"S\" ,"
				+ " \"message\" : \""+ message +"\""
				+ " }";
		return jsonStr;
	}
	
}
