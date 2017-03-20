package com.skcc.watsontest.intro.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.skcc.watsontest.intro.dao.IntroDAO;

@Service("introService")
public class IntroServiceImpl implements IntroService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="introDAO")
	private IntroDAO introDAO;
	
	@Override
	public List<Map<String, Object>> selectTestList(Map<String,Object>map) throws Exception{
		return introDAO.selectTestList(map);
	}
}
