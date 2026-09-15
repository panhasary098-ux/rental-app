import 'package:final_project/model/chat_message.dart';
import 'package:final_project/service/ai_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatController extends GetxController {
  TextEditingController messageController =
      TextEditingController();

  AiChatService aiChatService =
      AiChatService();

  RxList<ChatMessage> messages =
      <ChatMessage>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingHistory = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadHistory();
  }

  // Welcome Message
  void addWelcomeMessage() {
    messages.add(
      ChatMessage(
        message:
            "Hello, I'm your JoulNow Rental Assistant.\n"
            "Ask me anything about renting, deposits, "
            "rental documents, or contracts.",
        isUser: false,
      ),
    );
  }

  // Load History
  Future<void> loadHistory() async {
    try {
      isLoadingHistory.value = true;

      List<Map<String, dynamic>> history =
          await aiChatService.getHistory();

      messages.clear();

      if (history.isEmpty) {
        addWelcomeMessage();
        return;
      }

      for (Map<String, dynamic> item in history) {
        String role =
            item["role"]?.toString() ?? "";

        String message =
            item["message"]?.toString() ?? "";

        if (message.isEmpty) {
          continue;
        }

        messages.add(
          ChatMessage(
            message: message,
            isUser: role == "user",
          ),
        );
      }
    } catch (e) {
      print(
        "LOAD CHAT HISTORY ERROR: $e",
      );

      messages.clear();

      addWelcomeMessage();
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Send Message
  Future<void> sendMessage() async {
    String message =
        messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    List<Map<String, dynamic>> history =
        buildHistory();

    messages.add(
      ChatMessage(
        message: message,
        isUser: true,
      ),
    );

    messageController.clear();

    await getBotResponse(
      message,
      history,
    );
  }

  // Quick Question
  Future<void> sendQuickQuestion(
    String question,
  ) async {
    if (isLoading.value) {
      return;
    }

    List<Map<String, dynamic>> history =
        buildHistory();

    messages.add(
      ChatMessage(
        message: question,
        isUser: true,
      ),
    );

    await getBotResponse(
      question,
      history,
    );
  }

  // Build History
  List<Map<String, dynamic>> buildHistory() {
    List<Map<String, dynamic>> history = [];

    List<ChatMessage> chatHistory =
        List.from(messages);

    // Remove welcome message if present
    if (
        chatHistory.isNotEmpty &&
        !chatHistory.first.isUser &&
        chatHistory.first.message.contains(
          "JoulNow Rental Assistant",
        )) {
      chatHistory.removeAt(0);
    }

    // Keep recent messages only
    if (chatHistory.length > 10) {
      chatHistory =
          chatHistory.sublist(
        chatHistory.length - 10,
      );
    }

    for (ChatMessage chat in chatHistory) {
      history.add({
        "role":
            chat.isUser ? "user" : "model",
        "text": chat.message,
      });
    }

    return history;
  }

  // Get Bot Response
  Future<void> getBotResponse(
    String userMessage,
    List<Map<String, dynamic>> history,
  ) async {
    try {
      isLoading.value = true;

      String reply =
          await aiChatService.sendMessage(
        message: userMessage,
        history: history,
      );

      messages.add(
        ChatMessage(
          message: reply,
          isUser: false,
        ),
      );
    } catch (e) {
      String errorMessage =
          e.toString();

      if (
          errorMessage.startsWith(
        "Exception: ",
      )) {
        errorMessage =
            errorMessage.replaceFirst(
          "Exception: ",
          "",
        );
      }

      messages.add(
        ChatMessage(
          message:
              "Sorry, I couldn't process your question.\n"
              "$errorMessage",
          isUser: false,
        ),
      );

      print(
        "AI CHAT ERROR: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear Chat
  Future<void> clearChat() async {
    try {
      await aiChatService.clearHistory();

      messages.clear();

      addWelcomeMessage();
    } catch (e) {
      print(
        "CLEAR CHAT ERROR: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to clear chat history.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    messageController.dispose();

    super.onClose();
  }
}