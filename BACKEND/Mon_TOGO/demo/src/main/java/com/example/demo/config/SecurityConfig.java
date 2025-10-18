package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/**").permitAll() // Autoriser /api/*
                .requestMatchers("/actuator/**").permitAll() // Autoriser actuator
                .requestMatchers("/h2-console/**").permitAll() // Si vous utilisez H2
                .anyRequest().authenticated() // Autres requêtes nécessitent auth
            );
        
        return http.build();
    }
}