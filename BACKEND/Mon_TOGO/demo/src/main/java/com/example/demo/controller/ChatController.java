package com.example.demo.controller;

import com.example.demo.model.AIResponse;
import com.example.demo.model.Conversation;
import com.example.demo.model.Message;
import com.example.demo.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Pour Flutter
public class ChatController {

    @Autowired
    private ChatService chatService;

    @PostMapping("/chat")
    public ResponseEntity<AIResponse> sendMessage(@RequestBody Message message) {
        AIResponse response = chatService.processMessage(message.getContent());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/conversations")
    public ResponseEntity<List<Conversation>> getConversations() {
        return ResponseEntity.ok(chatService.getAllConversations());
    }

    @DeleteMapping("/conversations/{id}")
    public ResponseEntity<Void> deleteConversation(@PathVariable String id) {
        chatService.deleteConversation(id);
        return ResponseEntity.ok().build();
    }
}