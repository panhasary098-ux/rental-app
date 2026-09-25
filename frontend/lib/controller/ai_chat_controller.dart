import 'package:final_project/model/chat_message.dart';
import 'package:final_project/model/property.dart';
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

  RxList<Map<String, dynamic>> conversations =
      <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingHistory = false.obs;
  RxBool isLoadingConversations = false.obs;

  RxnInt currentConversationId =
      RxnInt();

  RxString currentConversationTitle =
      "New Chat".obs;

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  // Initialize Chat
  Future<void> initializeChat() async {
    try {
      isLoadingHistory.value = true;

      List<Map<String, dynamic>> conversationList =
          await aiChatService.getConversations();

      conversations.assignAll(
        conversationList,
      );

      if (conversationList.isEmpty) {
        await createNewChat(
          forceCreate: true,
        );

        return;
      }

      Map<String, dynamic> latestConversation =
          conversationList.first;

      int? conversationId =
          parseConversationId(
        latestConversation["id"],
      );

      if (conversationId == null) {
        await createNewChat(
          forceCreate: true,
        );

        return;
      }

      await openConversation(
        conversationId,
      );
    } catch (e) {
      print(
        "INITIALIZE CHAT ERROR: $e",
      );

      messages.clear();
      addWelcomeMessage();
    } finally {
      isLoadingHistory.value = false;
    }
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

  // Check Empty Chat
  bool isCurrentChatEmpty() {
    if (currentConversationId.value == null) {
      return true;
    }

    if (messages.isEmpty) {
      return true;
    }

    if (
        messages.length == 1 &&
        !messages.first.isUser &&
        messages.first.message.contains(
          "JoulNow Rental Assistant",
        )
    ) {
      return true;
    }

    return false;
  }

  // Create New Chat
  Future<void> createNewChat({
    bool forceCreate = false,
  }) async {
    if (isLoading.value) {
      return;
    }

    // Don't Create Duplicate Empty Chat
    if (
        !forceCreate &&
        currentConversationId.value != null &&
        isCurrentChatEmpty()
    ) {
      messageController.clear();

      currentConversationTitle.value =
          "New Chat";

      return;
    }

    try {
      isLoadingHistory.value = true;

      Map<String, dynamic> conversation =
          await aiChatService.createConversation();

      int? conversationId =
          parseConversationId(
        conversation["id"],
      );

      if (conversationId == null) {
        throw Exception(
          "Invalid conversation ID.",
        );
      }

      currentConversationId.value =
          conversationId;

      currentConversationTitle.value =
          conversation["title"]
                      ?.toString()
                      .trim()
                      .isNotEmpty ==
                  true
              ? conversation["title"].toString()
              : "New Chat";

      messageController.clear();

      messages.clear();

      addWelcomeMessage();

      await loadConversations();
    } catch (e) {
      print(
        "CREATE NEW CHAT ERROR: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to create a new chat.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Load Conversations
  Future<void> loadConversations() async {
    try {
      isLoadingConversations.value = true;

      List<Map<String, dynamic>> conversationList =
          await aiChatService.getConversations();

      conversations.assignAll(
        conversationList,
      );
    } catch (e) {
      print(
        "LOAD CONVERSATIONS ERROR: $e",
      );
    } finally {
      isLoadingConversations.value = false;
    }
  }

  // Open Conversation
  Future<void> openConversation(
    int conversationId,
  ) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoadingHistory.value = true;

      Map<String, dynamic> data =
          await aiChatService.getConversation(
        conversationId,
      );

      Map<String, dynamic> conversation =
          Map<String, dynamic>.from(
        data["conversation"] ?? {},
      );

      List<Map<String, dynamic>> history =
          List<Map<String, dynamic>>.from(
        data["messages"] ?? [],
      );

      currentConversationId.value =
          conversationId;

      String? title =
          conversation["title"]?.toString();

      if (
          title == null ||
          title.trim().isEmpty
      ) {
        currentConversationTitle.value =
            "New Chat";
      } else {
        currentConversationTitle.value =
            title;
      }

      messageController.clear();

      messages.clear();

      if (history.isEmpty) {
        addWelcomeMessage();
        return;
      }

      for (
        Map<String, dynamic> item
        in history
      ) {
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
        "OPEN CONVERSATION ERROR: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to open this conversation.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
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

    int? conversationId =
        currentConversationId.value;

    if (conversationId == null) {
      await createNewChat(
        forceCreate: true,
      );

      conversationId =
          currentConversationId.value;
    }

    if (conversationId == null) {
      Get.snackbar(
        "Error",
        "Unable to start a conversation.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

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
      conversationId,
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

    int? conversationId =
        currentConversationId.value;

    if (conversationId == null) {
      await createNewChat(
        forceCreate: true,
      );

      conversationId =
          currentConversationId.value;
    }

    if (conversationId == null) {
      Get.snackbar(
        "Error",
        "Unable to start a conversation.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

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
      conversationId,
      question,
      history,
    );
  }

  // Build History
  List<Map<String, dynamic>> buildHistory() {
    List<Map<String, dynamic>> history = [];

    List<ChatMessage> chatHistory =
        List.from(
      messages,
    );

    // Remove Welcome Message
    if (
        chatHistory.isNotEmpty &&
        !chatHistory.first.isUser &&
        chatHistory.first.message.contains(
          "JoulNow Rental Assistant",
        )
    ) {
      chatHistory.removeAt(0);
    }

    // Keep Recent Messages
    if (chatHistory.length > 10) {
      chatHistory =
          chatHistory.sublist(
        chatHistory.length - 10,
      );
    }

    for (
      ChatMessage chat
      in chatHistory
    ) {
      history.add({
        "role":
            chat.isUser
                ? "user"
                : "model",

        "text":
            chat.message,
      });
    }

    return history;
  }

  // Get Bot Response
  Future<void> getBotResponse(
    int conversationId,
    String userMessage,
    List<Map<String, dynamic>> history,
  ) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> response =
          await aiChatService.sendMessage(
        conversationId:
            conversationId,
        message:
            userMessage,
        history:
            history,
      );

      String reply =
          response["reply"]?.toString() ??
              "";

      if (reply.trim().isEmpty) {
        throw Exception(
          "AI did not return a response.",
        );
      }

      List<Property> properties = [];

      dynamic propertyData =
          response["properties"];

      if (propertyData is List) {
        for (
          dynamic item
          in propertyData
        ) {
          if (item is Map) {
            try {
              Property property =
                  Property.fromJson(
                Map<String, dynamic>.from(
                  item,
                ),
              );

              properties.add(
                property,
              );
            } catch (e) {
              print(
                "AI PROPERTY PARSE ERROR: $e",
              );
            }
          }
        }
      }

      print(
        "AI PROPERTY COUNT: ${properties.length}",
      );

      messages.add(
        ChatMessage(
          message: reply,
          isUser: false,
          properties: properties,
        ),
      );

      await loadConversations();

      Map<String, dynamic>?
          currentConversation;

      for (
        Map<String, dynamic> conversation
        in conversations
      ) {
        int? id =
            parseConversationId(
          conversation["id"],
        );

        if (
            id ==
            conversationId
        ) {
          currentConversation =
              conversation;

          break;
        }
      }

      if (
          currentConversation != null
      ) {
        String? title =
            currentConversation["title"]
                ?.toString();

        if (
            title != null &&
            title.trim().isNotEmpty
        ) {
          currentConversationTitle.value =
              title;
        }
      }
    } catch (e) {
      String errorMessage =
          e.toString();

      if (
          errorMessage.startsWith(
            "Exception: ",
          )
      ) {
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
    if (isLoading.value) {
      return;
    }

    int? conversationId =
        currentConversationId.value;

    if (conversationId == null) {
      messages.clear();

      addWelcomeMessage();

      await createNewChat(
        forceCreate: true,
      );

      return;
    }

    try {
      isLoadingHistory.value = true;

      await aiChatService.deleteConversation(
        conversationId,
      );

      currentConversationId.value =
          null;

      currentConversationTitle.value =
          "New Chat";

      messageController.clear();

      messages.clear();

      await createNewChat(
        forceCreate: true,
      );
    } catch (e) {
      print(
        "CLEAR CHAT ERROR: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to clear chat.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Delete Conversation
  Future<void> deleteConversation(
    int conversationId,
  ) async {
    if (isLoading.value) {
      return;
    }

    try {
      await aiChatService.deleteConversation(
        conversationId,
      );

      bool isCurrentConversation =
          currentConversationId.value ==
              conversationId;

      await loadConversations();

      if (!isCurrentConversation) {
        return;
      }

      currentConversationId.value =
          null;

      currentConversationTitle.value =
          "New Chat";

      messageController.clear();

      messages.clear();

      if (conversations.isEmpty) {
        await createNewChat(
          forceCreate: true,
        );

        return;
      }

      int? nextConversationId =
          parseConversationId(
        conversations.first["id"],
      );

      if (nextConversationId == null) {
        await createNewChat(
          forceCreate: true,
        );

        return;
      }

      await openConversation(
        nextConversationId,
      );
    } catch (e) {
      print(
        "DELETE CONVERSATION ERROR: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to delete conversation.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // Conversation ID
  int? parseConversationId(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? "",
    );
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}