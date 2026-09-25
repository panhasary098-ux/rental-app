import 'dart:convert';

import 'package:final_project/service/auth_service.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  String baseUrl =
      "http://10.0.2.2:8000/api";

  AuthService authService =
      AuthService();

  // Send Message
  Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    String? token =
        await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication token not found.",
      );
    }

    final response =
        await http.post(
      Uri.parse(
        "$baseUrl/ai/chat",
      ),
      headers: {
        "Accept":
            "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "conversation_id":
            conversationId,
        "message":
            message,
        "history":
            history,
      }),
    );

    print(
      "AI STATUS: ${response.statusCode}",
    );

    print(
      "AI RESPONSE: ${response.body}",
    );

    dynamic decoded;

    try {
      decoded =
          jsonDecode(
        response.body,
      );
    } catch (e) {
      throw Exception(
        "Invalid server response.",
      );
    }

    if (response.statusCode == 200) {
      if (
          decoded is Map &&
          decoded["success"] == true
      ) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }

      throw Exception(
        decoded is Map
            ? decoded["message"]?.toString() ??
                "Unable to get AI response."
            : "Unable to get AI response.",
      );
    }

    if (decoded is Map) {
      String message =
          decoded["message"]?.toString() ??
              "Unable to get AI response.";

      throw Exception(
        message,
      );
    }

    throw Exception(
      "Unable to get AI response.",
    );
  }

  // Create Conversation
  Future<Map<String, dynamic>>
      createConversation() async {
    String? token =
        await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication token not found.",
      );
    }

    final response =
        await http.post(
      Uri.parse(
        "$baseUrl/ai/conversations",
      ),
      headers: {
        "Accept":
            "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    print(
      "CREATE CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "CREATE CONVERSATION RESPONSE: ${response.body}",
    );

    dynamic decoded;

    try {
      decoded =
          jsonDecode(
        response.body,
      );
    } catch (e) {
      throw Exception(
        "Invalid server response.",
      );
    }

    if (
        response.statusCode == 200 ||
        response.statusCode == 201
    ) {
      if (
          decoded is Map &&
          decoded["success"] == true
      ) {
        return Map<String, dynamic>.from(
          decoded["conversation"] ?? {},
        );
      }

      throw Exception(
        decoded is Map
            ? decoded["message"]?.toString() ??
                "Unable to create conversation."
            : "Unable to create conversation.",
      );
    }

    throw Exception(
      decoded is Map
          ? decoded["message"]?.toString() ??
              "Unable to create conversation."
          : "Unable to create conversation.",
    );
  }

  // Get Conversations
  Future<List<Map<String, dynamic>>>
      getConversations() async {
    String? token =
        await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication token not found.",
      );
    }

    final response =
        await http.get(
      Uri.parse(
        "$baseUrl/ai/conversations",
      ),
      headers: {
        "Accept":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    print(
      "GET CONVERSATIONS STATUS: ${response.statusCode}",
    );

    print(
      "GET CONVERSATIONS RESPONSE: ${response.body}",
    );

    dynamic decoded;

    try {
      decoded =
          jsonDecode(
        response.body,
      );
    } catch (e) {
      throw Exception(
        "Invalid server response.",
      );
    }

    if (response.statusCode == 200) {
      if (
          decoded is Map &&
          decoded["success"] == true
      ) {
        List<dynamic> data =
            decoded["conversations"] ?? [];

        return data
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item,
              ),
            )
            .toList();
      }

      throw Exception(
        decoded is Map
            ? decoded["message"]?.toString() ??
                "Unable to load conversations."
            : "Unable to load conversations.",
      );
    }

    throw Exception(
      decoded is Map
          ? decoded["message"]?.toString() ??
              "Unable to load conversations."
          : "Unable to load conversations.",
    );
  }

  // Get Conversation
  Future<Map<String, dynamic>>
      getConversation(
    int conversationId,
  ) async {
    String? token =
        await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication token not found.",
      );
    }

    final response =
        await http.get(
      Uri.parse(
        "$baseUrl/ai/conversations/$conversationId",
      ),
      headers: {
        "Accept":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    print(
      "GET CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "GET CONVERSATION RESPONSE: ${response.body}",
    );

    dynamic decoded;

    try {
      decoded =
          jsonDecode(
        response.body,
      );
    } catch (e) {
      throw Exception(
        "Invalid server response.",
      );
    }

    if (response.statusCode == 200) {
      if (
          decoded is Map &&
          decoded["success"] == true
      ) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }

      throw Exception(
        decoded is Map
            ? decoded["message"]?.toString() ??
                "Unable to load conversation."
            : "Unable to load conversation.",
      );
    }

    throw Exception(
      decoded is Map
          ? decoded["message"]?.toString() ??
              "Unable to load conversation."
          : "Unable to load conversation.",
    );
  }

  // Delete Conversation
  Future<void> deleteConversation(
    int conversationId,
  ) async {
    String? token =
        await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication token not found.",
      );
    }

    final response =
        await http.delete(
      Uri.parse(
        "$baseUrl/ai/conversations/$conversationId",
      ),
      headers: {
        "Accept":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    print(
      "DELETE CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "DELETE CONVERSATION RESPONSE: ${response.body}",
    );

    dynamic decoded;

    try {
      decoded =
          jsonDecode(
        response.body,
      );
    } catch (e) {
      throw Exception(
        "Invalid server response.",
      );
    }

    if (
        response.statusCode == 200 &&
        decoded is Map &&
        decoded["success"] == true
    ) {
      return;
    }

    throw Exception(
      decoded is Map
          ? decoded["message"]?.toString() ??
              "Unable to delete conversation."
          : "Unable to delete conversation.",
    );
  }
}