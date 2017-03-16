package com.skcc.watsontest.test.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.skcc.watsontest.test.dao.TestDAO;

@Service("testService")
public class TestServiceImpl implements TestService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="testDAO")
	private TestDAO testDAO;
	
	@Override
	public List<Map<String, Object>> selectTestList(Map<String,Object>map) throws Exception{
		return testDAO.selectTestList(map);
	}
}
