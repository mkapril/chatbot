package com.skcc.watsontest.intro.service;

import java.util.List;
import java.util.Map;

public interface IntroService {
	List<Map<String, Object>> selectTestList(Map<String,Object>map) throws Exception;
}
