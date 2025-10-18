package com.example.demo.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.AIResponse;
import com.example.demo.service.ChatService;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody Map<String, String> request) {
        String userMessage = request.get("content");
        
        if (userMessage == null || userMessage.trim().isEmpty()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Le message ne peut pas être vide");
            errorResponse.put("timestamp", LocalDateTime.now());
            return errorResponse;
        }
        
        try {
            // Appeler ChatService qui utilise OpenAI
            AIResponse aiResponse = chatService.processMessage(userMessage);
            
            Map<String, Object> response = new HashMap<>();
            response.put("response", aiResponse.getResponse());
            response.put("timestamp", LocalDateTime.now());
            response.put("status", "success");
            
            return response;
        } catch (Exception e) {
            // En cas d'erreur (ex: problème OpenAI), retourner une réponse d'erreur
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Erreur lors du traitement: " + e.getMessage());
            errorResponse.put("response", "Désolé, je rencontre un problème technique. Réessayez plus tard.");
            errorResponse.put("timestamp", LocalDateTime.now());
            return errorResponse;
        }
    }
}