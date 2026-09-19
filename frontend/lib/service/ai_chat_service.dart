import 'dart:convert';
import 'package:final_project/service/auth_service.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  String baseUrl = "http://10.0.2.2:8000/api";
  AuthService authService = AuthService();

  // Send Message
  Future<String> sendMessage({
    required int conversationId,
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/ai/chat"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "conversation_id": conversationId,
        "message": message,
        "history": history,
      }),
    );

    print("AI STATUS: ${response.statusCode}");
    print("AI RESPONSE: ${response.body}");

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 503) {
      throw Exception(
        data["message"] ??
            "The AI assistant is busy. Please try again shortly.",
      );
    }

    if (response.statusCode == 429) {
      throw Exception(
        data["message"] ??
            "The AI assistant has reached its temporary usage limit.",
      );
    }

    if (response.statusCode == 200) {
      return data["reply"] ?? "No response from assistant.";
    }

    if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    }

    if (response.statusCode == 403) {
      throw Exception("You cannot access this conversation.");
    }

    if (response.statusCode == 404) {
      throw Exception("Conversation not found.");
    }

    if (response.statusCode == 422) {
      throw Exception("Please enter a valid question.");
    }

    throw Exception(
      data["message"] ??
          "Server error: ${response.statusCode}",
    );
  }

  // Create Conversation
  Future<Map<String, dynamic>> createConversation() async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/ai/conversations"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "CREATE CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "CREATE CONVERSATION RESPONSE: ${response.body}",
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(
        data["conversation"],
      );
    }

    if (response.statusCode == 401) {
      throw Exception(
        "Unauthorized. Please login again.",
      );
    }

    throw Exception(
      data["message"] ??
          "Unable to create conversation.",
    );
  }

  // Get Conversations
  Future<List<Map<String, dynamic>>>
      getConversations() async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/ai/conversations"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "GET CONVERSATIONS STATUS: ${response.statusCode}",
    );

    print(
      "GET CONVERSATIONS RESPONSE: ${response.body}",
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        data["conversations"] ?? [],
      );
    }

    if (response.statusCode == 401) {
      throw Exception(
        "Unauthorized. Please login again.",
      );
    }

    throw Exception(
      data["message"] ??
          "Unable to load conversations.",
    );
  }

  // Get Conversation
  Future<Map<String, dynamic>> getConversation(
    int conversationId,
  ) async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.get(
      Uri.parse(
        "$baseUrl/ai/conversations/$conversationId",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "GET CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "GET CONVERSATION RESPONSE: ${response.body}",
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    if (response.statusCode == 401) {
      throw Exception(
        "Unauthorized. Please login again.",
      );
    }

    if (response.statusCode == 403) {
      throw Exception(
        "You cannot access this conversation.",
      );
    }

    if (response.statusCode == 404) {
      throw Exception(
        "Conversation not found.",
      );
    }

    throw Exception(
      data["message"] ??
          "Unable to load conversation.",
    );
  }

  // Delete Conversation
  Future<void> deleteConversation(
    int conversationId,
  ) async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.delete(
      Uri.parse(
        "$baseUrl/ai/conversations/$conversationId",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "DELETE CONVERSATION STATUS: ${response.statusCode}",
    );

    print(
      "DELETE CONVERSATION RESPONSE: ${response.body}",
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 401) {
      throw Exception(
        "Unauthorized. Please login again.",
      );
    }

    if (response.statusCode == 403) {
      throw Exception(
        "You cannot delete this conversation.",
      );
    }

    if (response.statusCode == 404) {
      throw Exception(
        "Conversation not found.",
      );
    }

    throw Exception(
      data["message"] ??
          "Unable to delete conversation.",
    );
  }
}