package com.skcc.watsontest.intro.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skcc.watsontest.common.dao.AbstractDAO;

@Repository("introDAO")
public class IntroDAO extends AbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTestList(Map<String, Object> map) {
		return (List<Map<String, Object>>)selectList("test.selectTestList",map);
	}
}
