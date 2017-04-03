package com.skcc.watsontest.intro.controller;

import java.io.IOException;
import java.net.SocketTimeoutException;
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
import com.ibm.watson.developer_cloud.conversation.v1.model.Intent;
import com.ibm.watson.developer_cloud.conversation.v1.model.MessageRequest;
import com.ibm.watson.developer_cloud.conversation.v1.model.MessageResponse;
import com.skcc.watsontest.intro.service.IntroService;
import com.skcc.watsontest.common.utils.CommandMap;

@Controller
public class IntroController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource(name="introService")
	private IntroService introService;
	
	private ConversationService service ;
	
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
		
		session.setMaxInactiveInterval(600); //default 30분, 10초간 유효
		
		MessageResponse response;
		 service = new ConversationService(ConversationService.VERSION_DATE_2016_09_20);
		service.setUsernameAndPassword(user_name, user_pw);
		MessageRequest newMessage = new MessageRequest.Builder().build();
		response = service.message(work_id, newMessage).execute();
		
		
		session.setAttribute("ContextMap", response.getContext()); //담기는 값은 뭐든지 가능( 객체도 가능)
		map = response.getOutput();
		
		System.out.println(response);
		
		resultText = map.get("text").toString();
        
		return resultText;
	}
	
	
public Map<String,String> conversation(String message, HttpServletRequest request) throws Exception {
		
		Map<String,String> resultMap = new HashMap<String,String>();
		
		String resultText = "";
		Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> cmap = new HashMap<String,Object>();
		
		HttpSession session = request.getSession(true);

		
		MessageResponse response;
		System.out.println("Session == " + session.getAttribute("ContextMap"));
		if(session != null){
			cmap = (Map<String, Object>) session.getAttribute("ContextMap");
		}
		
		 service = new ConversationService(ConversationService.VERSION_DATE_2016_09_20);
		service.setUsernameAndPassword(user_name, user_pw);
		MessageRequest newMessage = new MessageRequest.Builder().inputText(message).context(cmap).build();
		
		//test
//		newMessage = newMessage.newBuilder().intent(new Intent("Purchase_mphone",1.0)).build();
		
		logger.debug("CONTEXT MAP="+cmap +"][newMessage" + newMessage);
		
		try {
			response = service.message(work_id, newMessage).execute();
			
			map = response.getOutput();
			
			logger.debug("NODE="+map.get("nodes_visited")+"]");
			
			 if( !("[anything_else]".equals(map.get("nodes_visited").toString()))  ){
				logger.debug("정상 다이얼로그====");
				if(!"".equals(session.getAttribute("ContextMap")) || session.getAttribute("ContextMap") != null){
					session.setAttribute("PrevContextMap", cmap);
				}
				session.setAttribute("ContextMap", response.getContext());
				session.setAttribute("PreviousText", response.getOutput().get("text"));
				logger.debug("정상 다이얼로그 이전 응답 =" +session.getAttribute("PreviousText"));
			} else {
				if(!"".equals(session.getAttribute("PrevContextMap")) ||  session.getAttribute("PrevContextMap") != null){
					session.setAttribute("ContextMap", session.getAttribute("PrevContextMap"));
				}
				logger.debug("비 정상 다이얼로그====");
				logger.debug("ANYTHING ELSE YOU NEED====");
				logger.debug("WHAT I SAID EARLIER=" +session.getAttribute("PreviousText"));
			//	session.setAttribute("PreviousText", response);
			}
			
			logger.debug("context map start ====");
			System.out.println(session.getAttribute("ContextMap"));
			
			logger.debug("reponse start ===");

			logger.debug(response);
			
			resultText = map.get("text").toString();
			String resultNodeVisited = map.get("nodes_visited").toString();
			//String resultNodeVisitedFiltered = resultNodeVisited.replaceAll("\\[", "").replaceAll("\\]", "");
			
	       // String nodesTest = "[S_feeling, S_phone, S_kids]";
	        String[] nodesArray = resultNodeVisited.replaceAll("\\[", "").replaceAll("\\]", "").split(",");
			
	        //최종 도착 노드 - visit 순서 중 마지막 
	        String resultNodeVisitedFiltered = nodesArray[nodesArray.length-1];
	        
			resultMap.put("resultText", map.get("text").toString());
			resultMap.put("resultNodeVisited", map.get("nodes_visited").toString());
			
			logger.debug("FINAL NODE VISITED IS ### " + resultNodeVisitedFiltered);
			
			
		//	resultMap.put("", value)
		} catch (Exception e) {
			try{
				 if(e instanceof SocketTimeoutException) {
                     throw new SocketTimeoutException();
				 } else {
					 e.printStackTrace() ;
					 resultMap.put("resultText", "죄송합니다. 다시 한 번 말씀 해 주시겠어요?");
				 }
			}catch (SocketTimeoutException f){
				logger.debug("Exception Occured ==== );"
						 );
				e.printStackTrace() ;
				resultMap.put("resultText", " 통신 중 에러가 발생하였습니다  ");
			}
			
		}
		
		
		
		return resultMap;
	}
	
	@RequestMapping(value = "call.do", produces = "application/json; charset=utf8")
	public @ResponseBody String call(CommandMap commandMap, HttpServletRequest request) throws Exception {
		String message = "";
		Map<String,String> returnMap = new HashMap<String,String>();
		// 전달받은 파라미터 출력
		if (commandMap.isEmpty() == false) {
			Iterator<Entry<String, Object>> iterator = commandMap.getMap().entrySet().iterator();
			Entry<String, Object> entry = null;
			while (iterator.hasNext()) {
				entry = iterator.next();
				logger.debug("key : " + entry.getKey() + ", value : " + entry.getValue());
				message = (String) entry.getValue();
			}
			returnMap = conversation(message, request);
		}
		
		String jsonStr = "";
		
		if ("[anything_else]".equals(returnMap.get("resultNodeVisited").toString())){
			//lastSentence = con
			jsonStr = "{ \"resultCd\" : \"A\" ,"
					+ " \"message\" : \""+ returnMap.get("resultText") +"\" "
					+ " }";
		}else if (returnMap.get("resultNodeVisited").toString().indexOf("E_") > 0){
			
			jsonStr = "{ \"resultCd\" : \"E\" ,"
					+ " \"message\" : \""+ returnMap.get("resultText") +"\" ,"
					+ " \"resultProduct\" : \""+ returnMap.get("resultNodeVisited") +"\" "
					+ " }";
			
		}else {
			jsonStr = "{ \"resultCd\" : \"S\" ,"
					+ " \"message\" : \""+ returnMap.get("resultText") +"\" "
					+ " }";
		}
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
