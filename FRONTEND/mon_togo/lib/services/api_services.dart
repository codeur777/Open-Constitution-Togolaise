import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/conversation.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      // Choisissez l'URL appropriée selon votre cas d'usage
      baseUrl: 'http://192.168.1.67:8081/api', // ← Android Emulator
      // baseUrl: 'http://localhost:8081/api',  // ← iOS Simulator
      // baseUrl: 'http://VOTRE_IP:8081/api',   // ← Appareil physique (même réseau WiFi)

      // Timeouts augmentés
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),

      // Headers par défaut
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('[DIO] $obj'), // Logger pour debug
    ),
  );

  /// Test de connexion au serveur
  static Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/test');
      print('✅ Connexion réussie: ${response.data}');
      return true;
    } on DioException catch (e) {
      print('❌ Erreur de connexion: ${_handleDioError(e)}');
      return false;
    }
  }

  /// Envoyer un message au chatbot
  static Future<String> sendMessage(String text) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {'content': text},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['response'] ?? 'Réponse vide';
      } else {
        throw Exception('Réponse invalide du serveur');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Récupérer toutes les conversations
  static Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final response = await _dio.get('/conversations');

      if (response.statusCode == 200 && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data as List);
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Erreur lors de la récupération des conversations: ${_handleDioError(e)}');
      return [];
    } catch (e) {
      print('Erreur inattendue: $e');
      return [];
    }
  }

  /// Supprimer une conversation
  static Future<void> deleteConversation(String id) async {
    try {
      final response = await _dio.delete('/conversations/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Échec de la suppression');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Créer une nouvelle conversation (retourne des données brutes)
  static Future<Map<String, dynamic>> createConversation(String title) async {
    try {
      final response = await _dio.post(
        '/conversations',
        data: {'title': title},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Échec de la création de la conversation');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Récupérer les messages d'une conversation
  static Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await _dio.get('/conversations/$conversationId/messages');

      if (response.statusCode == 200 && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data as List);
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Erreur lors de la récupération des messages: ${_handleDioError(e)}');
      return [];
    }
  }

  /// Gestion des erreurs Dio
  static String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Timeout de connexion. Vérifiez votre connexion réseau.';
      case DioExceptionType.sendTimeout:
        return 'Timeout lors de l\'envoi. Réessayez.';
      case DioExceptionType.receiveTimeout:
        return 'Timeout lors de la réception. Le serveur met trop de temps à répondre.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?.toString() ?? 'Erreur inconnue';
        return 'Erreur serveur ($statusCode): $message';
      case DioExceptionType.cancel:
        return 'Requête annulée.';
      case DioExceptionType.connectionError:
        return 'Erreur de connexion. Vérifiez que le serveur est démarré et accessible.';
      case DioExceptionType.badCertificate:
        return 'Certificat SSL invalide.';
      case DioExceptionType.unknown:
      default:
        return 'Erreur réseau: ${e.message ?? "Inconnue"}';
    }
  }
}