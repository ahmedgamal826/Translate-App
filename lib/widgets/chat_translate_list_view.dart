import 'dart:io';

import 'package:flutter/material.dart';

class ChatTranslateListView extends StatefulWidget {
  ChatTranslateListView({
    super.key,
    required this.scrollController,
    required this.chatMessages,
    required this.destinationLanguage,
    required this.openImage,
    required this.confirmDeletion,
  });

  final ScrollController scrollController;
  final List<Map<String, dynamic>> chatMessages;
  final String destinationLanguage;
  final Function(BuildContext, String) openImage;
  final Function(int) confirmDeletion;

  @override
  State<ChatTranslateListView> createState() => _ChatTranslateListViewState();
}

class _ChatTranslateListViewState extends State<ChatTranslateListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.chatMessages.length,
        itemBuilder: (context, index) {
          final message = widget.chatMessages[index];
          final bool isUser = message['type'] == 'user';
          return InkWell(
            onLongPress: () => widget.confirmDeletion(index),
            child: Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      textAlign: widget.destinationLanguage == "Arabic"
                          ? TextAlign.right
                          : TextAlign.left,
                      message['message'] ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                    if (message['image'] != null)
                      GestureDetector(
                        onTap: () => widget.openImage(
                          context,
                          message['image'],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.file(
                            File(message['image']),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    SelectableText(
                      message['time'],
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
