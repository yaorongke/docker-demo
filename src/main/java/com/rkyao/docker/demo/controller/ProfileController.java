package com.rkyao.docker.demo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * class
 *
 * @author Administrator
 * @date 2022/2/21
 */
@RestController
@RequestMapping("/profile")
public class ProfileController {

    @Value("${name}")
    private String name;

    /**
     * localhost:8090/docker-demo/profile/getConfig
     *
     * @return
     */
    @RequestMapping("/getConfig")
    public Map<String, String> getConfig() {
        Map<String, String> map = new HashMap<>();
        map.put("name", name);
        return map;
    }

}
