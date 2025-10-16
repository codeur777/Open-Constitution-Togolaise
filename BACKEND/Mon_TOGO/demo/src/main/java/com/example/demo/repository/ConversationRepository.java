package com.example.demo.repository;

import com.example.demo.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, String> {
    List<Conversation> findAllByOrderByUpdatedAtDesc();
    Optional<Conversation> findFirstByOrderByCreatedAtDesc();
}