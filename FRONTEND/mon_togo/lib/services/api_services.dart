import 'dart:convert';
import '../models/message.dart';
import '../models/conversation.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/api', // ← Android Emulator
      // baseUrl: 'http://localhost:8080/api', // ← iOS Simulator
      // baseUrl: 'http://192.168.1.100:8080/api', // ← Réseau local
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<String> sendMessage(String text) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {'message': text},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data['response'];
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<List<Conversation>> getConversations() async {
    try {
      final response = await _dio.get('/conversations');
      return (response.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } catch (e) {
      return []; // Retourne liste vide en cas d'erreur
    }
  }

  static Future<void> deleteConversation(String id) async {
    try {
      await _dio.delete('/conversations/$id');
    } catch (e) {
      throw Exception('Erreur suppression: $e');
    }
  }
}