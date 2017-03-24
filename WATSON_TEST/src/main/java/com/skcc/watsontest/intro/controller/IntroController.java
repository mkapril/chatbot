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
	
	private final String RESULT_FEELING = "S_feeling";
	private final String RESULT_KIDS    = "S_kids_01"; 
	private final String RESULT_IPHONE  = "s_phone_list_02";
	
	String NuguImg  = "http://shop.tworld.co.kr/pimg/phone/accessory/A05162_1.jpg";
	String NuguLink = "http://shop.tworld.co.kr/handler/AccessoryMall-AccView?CATEGORY_ID=10010006&ACCESSORY_ID=A05162&callGnb=02";
	String NuguName = "[UO] NUGU 음성인식 디바이스"; 
	
	String kidsImg = "http://shop.tworld.co.kr/pimg/phone/MZ/MZ01/default/MZ01_001_13.jpg";
	String kidsLink = "http://shop.tworld.co.kr/handler/PhoneDetail?callGnb=01&PRODUCT_GRP_ID=000001892";
	String kidsName ="헬로키티폰";
	
	String iPhoneImg = "http://shop.tworld.co.kr/pimg/phone/CG/CGNQ/default/CGNQ_001_16.jpg";
	String iPhoneLink = "http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001972&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=AA1C28&callGnb=01";
	String iPhoneName = "iPhone 7 (PRODUCT) RED";
	
	
	
	String[][] productArr = {{ RESULT_FEELING, NuguImg , NuguLink, NuguName }
							,{ RESULT_KIDS   , kidsImg , kidsLink, kidsName }
							,{ RESULT_IPHONE , iPhoneImg, iPhoneLink, iPhoneName}
							};
	
	
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
			
			logger.debug("RESPONSE START =====");
			logger.debug(response);
			
			if(!"[exception]".equals(map.get("nodes_visited").toString()) ){
				session.setAttribute("ContextMap", response.getContext());
			}
			
			System.out.println(response);
			
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
			
			
			for (int i=0; i < productArr.length; i++){
				if (productArr[i][0].equals(resultNodeVisitedFiltered)){ // 최종 노드 도달 
					resultMap.put("resultProductImg", productArr[i][1]);
					resultMap.put("resultProductLink", productArr[i][2]);
					resultMap.put("resultProductName", productArr[i][3]);
					logger.debug("resultProductImg [" +resultMap.get("resultProductImg")+"]");
					logger.debug("resultProductLink [" +resultMap.get("resultProductLink")+"]");
					logger.debug("resultProductName [" +resultMap.get("resultProductName")+"]");
				}
			}
		//	resultMap.put("", value)
		} catch (Exception e) {
			try{
				 if(e instanceof SocketTimeoutException) {
                     throw new SocketTimeoutException();
				 } else {
					 e.printStackTrace() ;
					 resultMap.put("resultText", "알 수 없는 에러가  발생하였습니다  ");
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
		
		jsonStr = "{ \"resultCd\" : \"S\" ,"
				+ " \"message\" : \""+ returnMap.get("resultText") +"\" ,"
				+ " \"resultProductImg\" : \""+ returnMap.get("resultProductImg") +"\" ,"
				+ " \"resultProductLink\" : \""+ returnMap.get("resultProductLink") +"\" ,"
				+ " \"resultProductName\" : \""+ returnMap.get("resultProductName") +"\" "
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
