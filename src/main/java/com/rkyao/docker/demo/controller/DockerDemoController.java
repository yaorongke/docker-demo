package com.rkyao.docker.demo.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * desc
 *
 * @author yaorongke
 * @date 2022/1/26
 */
@RestController
@RequestMapping("/docker")
public class DockerDemoController {

    /**
     * localhost:8090/docker-demo/docker/test01?id=1
     * @return
     */
    @RequestMapping("/test01")
    public String test01(String id) {
        return "This is docker test04, id: " + id;
    }

}
