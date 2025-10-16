package com.example.demo.service;

import dev.langchain4j.data.message.AiMessage;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.openai.OpenAiChatModel;
// filepath: d:\Open-Constitution-Togolaise\BACKEND\Mon_TOGO\demo\src\main\java\com\example\demo\service\AIModelService.java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AIModelService {

    private final ChatLanguageModel model;

    public AIModelService(@Value("${openai.api.key}") String apiKey) {
        this.model = OpenAiChatModel.builder()
            .apiKey(apiKey)
            .modelName("gpt-4")
            .temperature(0.1)
            .build();
    }

    public String generateResponse(String userMessage) {
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
            - Citer l'article de loi exact
            - Donner des étapes précises
            - Utiliser un ton professionnel
            - Format markdown pour clarté
            
            Exemple réponse :
            **Article 1 - La République**
            Le Togo est une République...
            """;
        return model.generate(systemPrompt + "\n\nQuestion: " + userMessage);
    }
}