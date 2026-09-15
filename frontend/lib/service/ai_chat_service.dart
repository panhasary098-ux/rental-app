import 'dart:convert';

import 'package:final_project/service/auth_service.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  String baseUrl = "http://10.0.2.2:8000/api";

  AuthService authService = AuthService();

  Future<String> sendMessage({
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
      body: jsonEncode({"message": message, "history": history}),
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

    if (response.statusCode == 200) {
      return data["reply"] ?? "No response from assistant.";
    }

    if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    }

    if (response.statusCode == 422) {
      throw Exception("Please enter a valid question.");
    }

    throw Exception(data["message"] ?? "Server error: ${response.statusCode}");
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/ai/chat/history"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data["messages"] ?? []);
    }

    throw Exception(data["message"] ?? "Unable to load chat history.");
  }

  Future<void> clearHistory() async {
    String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in.");
    }

    final response = await http.delete(
      Uri.parse("$baseUrl/ai/chat/history"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(data["message"] ?? "Unable to clear chat history.");
  }
}
