package com.skcc.watsontest.test.service;

import java.util.List;
import java.util.Map;

public interface TestService {
	List<Map<String, Object>> selectTestList(Map<String,Object>map) throws Exception;
}
