import 'package:final_project/controller/ai_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});

  final AiChatController controller = Get.put(
    AiChatController(),
  );

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  final Color primaryColor = Color(0xFF03045E);
  final Color backgroundColor = Color(0xFFF5F6F8);
  final Color borderColor = Color(0xFFE7E8EC);
  final Color mutedTextColor = Color(0xFF7C7F8C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,

      // Chat History
      endDrawer: buildChatHistoryDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 76,

        // Back
        leadingWidth: 58,

        leading: Center(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },

            child: Container(
              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(
                  12,
                ),
                border: Border.all(
                  color: borderColor,
                ),
              ),

              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryColor,
                size: 17,
              ),
            ),
          ),
        ),

        titleSpacing: 0,

        // AI Header
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(
                  14,
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(
                      0.18,
                    ),
                    blurRadius: 12,
                    offset: Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),

            SizedBox(
              width: 11,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    "JoulNow AI",

                    style: TextStyle(
                      color: Color(0xFF161724),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(
                    height: 3,
                  ),

                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,

                        decoration: BoxDecoration(
                          color: Color(0xFF22A06B),
                          shape: BoxShape.circle,
                        ),
                      ),

                      SizedBox(
                        width: 6,
                      ),

                      Text(
                        "Rental Assistant",

                        style: TextStyle(
                          color: mutedTextColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // History And Clear
        actions: [
          // History
          Center(
            child: GestureDetector(
              onTap: () async {
                await controller.loadConversations();

                scaffoldKey.currentState
                    ?.openEndDrawer();
              },

              child: Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F8),

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  border: Border.all(
                    color: borderColor,
                  ),
                ),

                child: Icon(
                  Icons.history_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 8,
          ),

          // Clear Chat
          Padding(
            padding: EdgeInsets.only(
              right: 12,
            ),

            child: Center(
              child: GestureDetector(
                onTap: () {
                  showClearChatDialog();
                },

                child: Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F8),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),

                    border: Border.all(
                      color: borderColor,
                    ),
                  ),

                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFF777A86),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            1,
          ),

          child: Container(
            height: 1,
            color: Color(0xFFEEEFF2),
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            // Messages
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoadingHistory.value) {
                    return Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    );
                  }

                  if (controller.messages.isEmpty &&
                      !controller.isLoading.value) {
                    return buildEmptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      18,
                      16,
                      18,
                    ),

                    itemCount:
                        controller.messages.length +
                        (controller.isLoading.value
                            ? 1
                            : 0),

                    itemBuilder: (
                      context,
                      index,
                    ) {
                      if (index ==
                          controller.messages.length) {
                        return buildTypingIndicator();
                      }

                      var message =
                          controller.messages[index];

                      return buildMessageBubble(
                        message.message,
                        message.isUser,
                      );
                    },
                  );
                },
              ),
            ),

            // Composer Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                border: Border(
                  top: BorderSide(
                    color: Color(0xFFEEEFF2),
                  ),
                ),
              ),

              child: Column(
                children: [
                  // Quick Questions
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 13,
                    ),

                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal,

                      child: Row(
                        children: [
                          buildQuickQuestion(
                            icon: Icons
                                .description_outlined,
                            title:
                                "Rental Documents",
                          ),

                          buildQuickQuestion(
                            icon: Icons
                                .home_outlined,
                            title:
                                "Before Renting",
                          ),

                          buildQuickQuestion(
                            icon: Icons
                                .payments_outlined,
                            title:
                                "Security Deposit",
                          ),

                          buildQuickQuestion(
                            icon: Icons
                                .edit_document,
                            title:
                                "Rental Contract",
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Message Input
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      12,
                    ),

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,

                      children: [
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 52,
                              maxHeight: 120,
                            ),

                            decoration: BoxDecoration(
                              color: Color(
                                0xFFF6F7F9,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              border: Border.all(
                                color: borderColor,
                              ),
                            ),

                            child: TextField(
                              controller: controller
                                  .messageController,

                              minLines: 1,
                              maxLines: 4,

                              textInputAction:
                                  TextInputAction.send,

                              onSubmitted: (
                                value,
                              ) {
                                controller
                                    .sendMessage();
                              },

                              style: TextStyle(
                                color: Color(
                                  0xFF1E1F2B,
                                ),
                                fontSize: 14,
                                height: 1.35,
                              ),

                              decoration:
                                  InputDecoration(
                                hintText:
                                    "Ask JoulNow AI...",

                                hintStyle:
                                    TextStyle(
                                  color: Color(
                                    0xFF999CA8,
                                  ),
                                  fontSize: 14,
                                ),

                                contentPadding:
                                    EdgeInsets
                                        .symmetric(
                                  horizontal: 17,
                                  vertical: 15,
                                ),

                                border:
                                    InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        // Send Button
                        GestureDetector(
                          onTap: () {
                            controller
                                .sendMessage();
                          },

                          child: Container(
                            width: 52,
                            height: 52,

                            decoration:
                                BoxDecoration(
                              color:
                                  primaryColor,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                17,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor
                                      .withOpacity(
                                    0.20,
                                  ),

                                  blurRadius: 12,

                                  offset: Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),

                            child: Icon(
                              Icons
                                  .arrow_upward_rounded,
                              color:
                                  Colors.white,
                              size: 23,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Disclaimer
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                    ),

                    child: Text(
                      "AI responses may not always be accurate.",

                      style: TextStyle(
                        color: Color(
                          0xFFA0A2AB,
                        ),
                        fontSize: 9.5,
                        fontWeight:
                            FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chat History Drawer
  Widget buildChatHistoryDrawer() {
    return Drawer(
      width: Get.width * 0.86,
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            24,
          ),
          bottomLeft: Radius.circular(
            24,
          ),
        ),
      ),

      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                16,
                14,
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: primaryColor,

                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),

                    child: Icon(
                      Icons
                          .forum_outlined,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),

                  SizedBox(
                    width: 11,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          "Chat History",

                          style: TextStyle(
                            color: Color(
                              0xFF171823,
                            ),
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),

                        SizedBox(
                          height: 2,
                        ),

                        Text(
                          "Your JoulNow AI conversations",

                          style: TextStyle(
                            color:
                                mutedTextColor,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },

                    child: Container(
                      width: 36,
                      height: 36,

                      decoration:
                          BoxDecoration(
                        color: Color(
                          0xFFF5F6F8,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          11,
                        ),

                        border:
                            Border.all(
                          color:
                              borderColor,
                        ),
                      ),

                      child: Icon(
                        Icons.close_rounded,
                        color: Color(
                          0xFF666975,
                        ),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: Color(
                0xFFEEEFF2,
              ),
            ),

            // New Chat
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                12,
              ),

              child: GestureDetector(
                onTap: () async {
                  Get.back();

                  await controller
                      .createNewChat();
                },

                child: Container(
                  width: double.infinity,

                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: primaryColor,

                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor
                            .withOpacity(
                          0.14,
                        ),
                        blurRadius: 12,
                        offset: Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Icon(
                        Icons
                            .add_comment_outlined,
                        color: Colors.white,
                        size: 19,
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      Text(
                        "New Chat",

                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 13.5,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Conversations
            Expanded(
              child: Obx(
                () {
                  if (controller
                      .isLoadingConversations
                      .value) {
                    return Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              primaryColor,
                        ),
                      ),
                    );
                  }

                  if (controller
                      .conversations
                      .isEmpty) {
                    return buildEmptyHistory();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      12,
                      2,
                      12,
                      20,
                    ),

                    itemCount:
                        controller
                            .conversations
                            .length,

                    itemBuilder: (
                      context,
                      index,
                    ) {
                      Map<String, dynamic>
                          conversation =
                          controller
                              .conversations[
                            index
                          ];

                      return buildConversationItem(
                        conversation,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Conversation Item
  Widget buildConversationItem(
    Map<String, dynamic> conversation,
  ) {
    int? conversationId =
        controller.parseConversationId(
      conversation["id"],
    );

    String title =
        conversation["title"]
                ?.toString()
                .trim() ??
            "";

    if (title.isEmpty) {
      title = "New Chat";
    }

    int messageCount =
        int.tryParse(
          conversation["messages_count"]
                  ?.toString() ??
              "0",
        ) ??
        0;

    return Obx(
      () {
        bool isSelected =
            conversationId != null &&
            controller
                    .currentConversationId
                    .value ==
                conversationId;

        return Container(
          margin: EdgeInsets.only(
            bottom: 7,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFFF2F3F8)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color: isSelected
                  ? primaryColor
                      .withOpacity(
                      0.15,
                    )
                  : Colors.transparent,
            ),
          ),

          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior:
                      HitTestBehavior
                          .opaque,

                  onTap: () async {
                    if (
                        conversationId ==
                        null
                    ) {
                      return;
                    }

                    Get.back();

                    await controller
                        .openConversation(
                      conversationId,
                    );
                  },

                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(
                      13,
                      12,
                      8,
                      12,
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,

                          decoration:
                              BoxDecoration(
                            color: isSelected
                                ? primaryColor
                                : Color(
                                    0xFFF5F6F8,
                                  ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),

                          child: Icon(
                            Icons
                                .chat_bubble_outline_rounded,
                            color: isSelected
                                ? Colors.white
                                : primaryColor,
                            size: 18,
                          ),
                        ),

                        SizedBox(
                          width: 11,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                title,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    TextStyle(
                                  color: Color(
                                    0xFF272833,
                                  ),
                                  fontSize:
                                      13,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight
                                              .w700
                                          : FontWeight
                                              .w600,
                                ),
                              ),

                              SizedBox(
                                height: 4,
                              ),

                              Text(
                                messageCount ==
                                        1
                                    ? "1 message"
                                    : "$messageCount messages",

                                style:
                                    TextStyle(
                                  color:
                                      mutedTextColor,
                                  fontSize:
                                      10.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Delete Conversation
              GestureDetector(
                onTap: () {
                  if (
                      conversationId ==
                      null
                  ) {
                    return;
                  }

                  showDeleteConversationDialog(
                    conversationId,
                    title,
                  );
                },

                child: Padding(
                  padding:
                      EdgeInsets.only(
                    right: 12,
                  ),

                  child: Container(
                    width: 34,
                    height: 34,

                    decoration:
                        BoxDecoration(
                      color: Color(
                        0xFFF7F7F9,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),

                    child: Icon(
                      Icons
                          .delete_outline_rounded,
                      color: Color(
                        0xFF8A8D98,
                      ),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Empty History
  Widget buildEmptyHistory() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                color: Color(
                  0xFFF3F4F7,
                ),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Icon(
                Icons
                    .chat_bubble_outline_rounded,
                color: primaryColor,
                size: 25,
              ),
            ),

            SizedBox(
              height: 15,
            ),

            Text(
              "No conversations yet",

              style: TextStyle(
                color: Color(
                  0xFF252631,
                ),
                fontSize: 15,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            SizedBox(
              height: 6,
            ),

            Text(
              "Start a new chat with JoulNow AI.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    mutedTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AI Message
  Widget buildMessageBubble(
    String message,
    bool isUser,
  ) {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,

        child: Container(
          constraints: BoxConstraints(
            maxWidth: Get.width * 0.76,
          ),

          margin: EdgeInsets.only(
            left: 55,
            bottom: 16,
          ),

          padding: EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: primaryColor,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                19,
              ),
              topRight: Radius.circular(
                19,
              ),
              bottomLeft: Radius.circular(
                19,
              ),
              bottomRight: Radius.circular(
                6,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(
                  0.12,
                ),
                blurRadius: 10,
                offset: Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Text(
            message,

            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: 17,
        right: 35,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // Robot
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: primaryColor,

              borderRadius:
                  BorderRadius.circular(
                11,
              ),
            ),

            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),

          SizedBox(
            width: 9,
          ),

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.only(
                  topLeft: Radius.circular(
                    6,
                  ),
                  topRight: Radius.circular(
                    19,
                  ),
                  bottomLeft:
                      Radius.circular(
                    19,
                  ),
                  bottomRight:
                      Radius.circular(
                    19,
                  ),
                ),

                border: Border.all(
                  color: borderColor,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(
                      0.035,
                    ),
                    blurRadius: 12,
                    offset: Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Text(
                message,

                style: TextStyle(
                  color: Color(
                    0xFF292A35,
                  ),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight:
                      FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Question
  Widget buildQuickQuestion({
    required IconData icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        controller.sendQuickQuestion(
          title,
        );
      },

      child: Container(
        margin: EdgeInsets.only(
          right: 9,
        ),

        padding: EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            13,
          ),

          border: Border.all(
            color: borderColor,
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: primaryColor,
              size: 16,
            ),

            SizedBox(
              width: 7,
            ),

            Text(
              title,

              style: TextStyle(
                color: Color(
                  0xFF40414D,
                ),
                fontSize: 11.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Typing Indicator
  Widget buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 17,
        right: 80,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: primaryColor,

              borderRadius:
                  BorderRadius.circular(
                11,
              ),
            ),

            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),

          SizedBox(
            width: 9,
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              border: Border.all(
                color: borderColor,
              ),
            ),

            child: Row(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                SizedBox(
                  width: 14,
                  height: 14,

                  child:
                      CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: primaryColor,
                  ),
                ),

                SizedBox(
                  width: 9,
                ),

                Text(
                  "Thinking",

                  style: TextStyle(
                    color:
                        mutedTextColor,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Empty State
  Widget buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color: primaryColor,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor
                        .withOpacity(
                      0.18,
                    ),
                    blurRadius: 22,
                    offset: Offset(
                      0,
                      8,
                    ),
                  ),
                ],
              ),

              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),

            SizedBox(
              height: 22,
            ),

            Text(
              "How can I help?",

              style: TextStyle(
                color: Color(
                  0xFF171823,
                ),
                fontSize: 24,
                fontWeight:
                    FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),

            SizedBox(
              height: 9,
            ),

            Text(
              "Ask about renting, deposits, documents,\ncontracts, or finding the right place.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: mutedTextColor,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Clear Chat Dialog
  void showClearChatDialog() {
    Get.dialog(
      Dialog(
        backgroundColor:
            Colors.transparent,

        insetPadding:
            EdgeInsets.symmetric(
          horizontal: 28,
        ),

        child: Container(
          padding: EdgeInsets.all(
            22,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              22,
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 52,
                height: 52,

                decoration:
                    BoxDecoration(
                  color: Color(
                    0xFFF4F4F7,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Icon(
                  Icons
                      .delete_outline_rounded,
                  color: primaryColor,
                  size: 25,
                ),
              ),

              SizedBox(
                height: 17,
              ),

              Text(
                "Clear conversation?",

                style: TextStyle(
                  color: Color(
                    0xFF171823,
                  ),
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Text(
                "This will permanently delete your current conversation.",

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color:
                      mutedTextColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              SizedBox(
                height: 22,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                        OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },

                      style:
                          OutlinedButton
                              .styleFrom(
                        foregroundColor:
                            primaryColor,

                        side: BorderSide(
                          color:
                              borderColor,
                        ),

                        padding:
                            EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),

                      child: Text(
                        "Cancel",
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        ElevatedButton(
                      onPressed: () {
                        Get.back();

                        controller
                            .clearChat();
                      },

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            primaryColor,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        padding:
                            EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),

                      child: Text(
                        "Clear",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete Conversation Dialog
  void showDeleteConversationDialog(
    int conversationId,
    String title,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor:
            Colors.transparent,

        insetPadding:
            EdgeInsets.symmetric(
          horizontal: 28,
        ),

        child: Container(
          padding: EdgeInsets.all(
            22,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              22,
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 52,
                height: 52,

                decoration:
                    BoxDecoration(
                  color: Color(
                    0xFFF4F4F7,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Icon(
                  Icons
                      .delete_outline_rounded,
                  color: primaryColor,
                  size: 25,
                ),
              ),

              SizedBox(
                height: 17,
              ),

              Text(
                "Delete conversation?",

                style: TextStyle(
                  color: Color(
                    0xFF171823,
                  ),
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Text(
                "\"$title\" will be permanently deleted.",

                textAlign:
                    TextAlign.center,

                maxLines: 2,

                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  color:
                      mutedTextColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              SizedBox(
                height: 22,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                        OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },

                      style:
                          OutlinedButton
                              .styleFrom(
                        foregroundColor:
                            primaryColor,

                        side: BorderSide(
                          color:
                              borderColor,
                        ),

                        padding:
                            EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),

                      child: Text(
                        "Cancel",
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        ElevatedButton(
                      onPressed: () async {
                        Get.back();

                        await controller
                            .deleteConversation(
                          conversationId,
                        );
                      },

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            primaryColor,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        padding:
                            EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),

                      child: Text(
                        "Delete",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}