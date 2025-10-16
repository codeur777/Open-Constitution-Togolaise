package com.example.demo.service;

import com.example.demo.model.Conversation;
import com.example.demo.repository.ConversationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConversationHistoryService {

    @Autowired
    private ConversationRepository repository;

    public List<Conversation> getHistory() {
        return repository.findAllByOrderByUpdatedAtDesc();
    }

    public void save(Conversation conversation) {
        repository.save(conversation);
    }
}