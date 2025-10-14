package com.example.demo.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = "*") // ✅ autorise Flutter à se connecter
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        return "Bonjour depuis Spring Boot 🚀";
    }
}
