package com.example.demo.service;

import com.example.demo.model.AIResponse;
import com.example.demo.model.Conversation;
import com.example.demo.model.Message;
import com.example.demo.repository.ConversationRepository;
import com.example.demo.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class ChatService {

    @Autowired
    private AIModelService aiModelService;
    
    @Autowired
    private ConversationRepository conversationRepository;
    
    @Autowired
    private MessageRepository messageRepository;

       public AIResponse processMessage(String content) {
        Optional<Conversation> optionalConversation = conversationRepository.findFirstByOrderByCreatedAtDesc();
        Conversation conversation = optionalConversation.orElse(null);
        if (conversation == null) {
            conversation = new Conversation();
            conversation.setId(UUID.randomUUID().toString());
            conversation.setTitle("Nouvelle conversation");
            conversationRepository.save(conversation);
        }

        Message userMessage = new Message();
        userMessage.setContent(content);
        userMessage.setIsUser(true);
        userMessage.setConversationId(conversation.getId());
        userMessage.setCreatedAt(LocalDateTime.now());
        messageRepository.save(userMessage);

        String aiResponse = aiModelService.generateResponse(content);

        Message aiMessage = new Message();
        aiMessage.setContent(aiResponse);
        aiMessage.setIsUser(false);
        aiMessage.setConversationId(conversation.getId());
        aiMessage.setCreatedAt(LocalDateTime.now());
        messageRepository.save(aiMessage);

        conversation.setLastMessage(aiResponse);
        conversation.setUpdatedAt(LocalDateTime.now());
        conversationRepository.save(conversation);

        return new AIResponse(aiResponse);
    }

    public List<Conversation> getAllConversations() {
        return conversationRepository.findAll();
    }

    public void deleteConversation(String id) {
        conversationRepository.deleteById(id);
        messageRepository.deleteByConversationId(id);
    }
}