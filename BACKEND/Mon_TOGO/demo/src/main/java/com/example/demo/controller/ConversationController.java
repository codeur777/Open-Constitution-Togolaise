package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/conversations")
@CrossOrigin(origins = "*")
public class ConversationController {

    // Stockage temporaire en mémoire (à remplacer par une base de données)
    private static final Map<String, Map<String, Object>> conversations = new HashMap<>();
    
    @GetMapping
    public List<Map<String, Object>> getAllConversations() {
        return new ArrayList<>(conversations.values());
    }
    
    @PostMapping
    public Map<String, Object> createConversation(@RequestBody Map<String, String> request) {
        String id = UUID.randomUUID().toString();
        String title = request.getOrDefault("title", "Nouvelle conversation");
        
        Map<String, Object> conversation = new HashMap<>();
        conversation.put("id", id);
        conversation.put("title", title);
        conversation.put("lastMessage", "");
        conversation.put("createdAt", LocalDateTime.now().toString());
        conversation.put("updatedAt", LocalDateTime.now().toString());
        
        conversations.put(id, conversation);
        
        return conversation;
    }
    
    @GetMapping("/{id}")
    public Map<String, Object> getConversation(@PathVariable String id) {
        Map<String, Object> conversation = conversations.get(id);
        if (conversation == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Conversation non trouvée");
            return error;
        }
        return conversation;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, String> deleteConversation(@PathVariable String id) {
        conversations.remove(id);
        
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Conversation supprimée");
        return response;
    }
    
    @GetMapping("/{id}/messages")
    public List<Map<String, Object>> getMessages(@PathVariable String id) {
        // Pour l'instant, retourne une liste vide
        // TODO: Implémenter le stockage des messages
        return new ArrayList<>();
    }
}