package com.skcc.watsontest.test.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skcc.watsontest.common.dao.AbstractDAO;

@Repository("testDAO")
public class TestDAO extends AbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTestList(Map<String, Object> map) {
		return (List<Map<String, Object>>)selectList("test.selectTestList",map);
	}
}
