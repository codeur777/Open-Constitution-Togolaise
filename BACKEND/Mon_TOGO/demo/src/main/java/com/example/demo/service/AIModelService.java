package com.example.demo.service;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.openai.OpenAiChatModel;

@Service
public class AIModelService {

    private static final Logger logger = LoggerFactory.getLogger(AIModelService.class);
    private final ChatLanguageModel model;
    private final boolean isConfigured;

    public AIModelService(@Value("${openai.api.key}") String apiKey) {
    // Nettoyer la clé de tout caractère invisible
    String cleanedKey = apiKey.trim().replaceAll("[^\\x00-\\x7F]", "");
    
    logger.info("🔍 Clé brute length: {}", apiKey.length());
    logger.info("🔍 Clé nettoyée length: {}", cleanedKey.length());
    logger.info("🔍 Clé commence par: {}", cleanedKey.substring(0, Math.min(8, cleanedKey.length())));
    
    if (cleanedKey.isBlank() || cleanedKey.startsWith("${")) {
        logger.error("❌ Clé API OpenAI non configurée !");
        this.model = null;
        this.isConfigured = false;
    } else {
        this.model = OpenAiChatModel.builder()
            .apiKey(cleanedKey) // Utiliser la clé nettoyée
            .modelName("gpt-3.5-turbo")
            .temperature(0.7)
            .timeout(Duration.ofSeconds(60))
            .build();
        this.isConfigured = true;
        logger.info("✅ OpenAI configuré avec succès");
    }
}

    public String generateResponse(String userMessage) {
        if (!isConfigured || model == null) {
            logger.warn("⚠️ OpenAI non configuré, utilisation de réponse par défaut");
            return generateFallbackResponse(userMessage);
        }

        try {
            logger.info("🤖 Envoi de la requête à OpenAI...");
            
            String systemPrompt = """
                Tu es un assistant juridique spécialisé dans la CONSTITUTION TOGOLAISE et les LOIS TOGOLAISES.
                Réponds UNIQUEMENT en FRANÇAIS, de manière CLAIRE, PRÉCISE et OFFICIELLE.
                
                Catégories principales :
                1. Constitution togolaise (articles exacts)
                2. Visa et immigration
                3. Titres fonciers
                4. Droits et devoirs citoyens
                5. Procédures administratives
                
                TOUJOURS :
                - Citer l'article de loi exact si possible
                - Donner des étapes précises
                - Utiliser un ton professionnel
                - Rester concis et clair
                
                Si tu ne connais pas la réponse exacte, dis-le honnêtement.
                """;
            
            String fullPrompt = systemPrompt + "\n\nQuestion de l'utilisateur: " + userMessage;
            String response = model.generate(fullPrompt);
            
            logger.info("✅ Réponse reçue d'OpenAI");
            return response;
            
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'appel à OpenAI: {}", e.getMessage(), e);
            return "Désolé, je rencontre un problème technique pour répondre à votre question. " +
                   "Erreur: " + e.getMessage();
        }
    }

    private String generateFallbackResponse(String userMessage) {
        String lowerMessage = userMessage.toLowerCase();
        
        if (lowerMessage.contains("bonjour") || lowerMessage.contains("salut")) {
            return "Bonjour ! Je suis votre assistant pour la Constitution togolaise. " +
                   "Comment puis-je vous aider aujourd'hui ?";
        } else if (lowerMessage.contains("constitution")) {
            return "La Constitution togolaise a été adoptée le 27 septembre 1992. " +
                   "Elle établit le Togo comme une République démocratique.";
        } else if (lowerMessage.contains("merci")) {
            return "De rien ! N'hésitez pas si vous avez d'autres questions sur la législation togolaise.";
        } else if (lowerMessage.contains("au revoir") || lowerMessage.contains("bye")) {
            return "Au revoir ! À bientôt !";
        } else {
            return "⚠️ Service OpenAI non disponible actuellement. " +
                   "Veuillez configurer votre clé API dans application.properties. " +
                   "Votre question: \"" + userMessage + "\"";
        }
    }
}