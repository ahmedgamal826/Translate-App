import 'package:flutter/material.dart';

class ChatTranslateTextField extends StatefulWidget {
  ChatTranslateTextField({
    super.key,
    required this.textController,
    required this.onChanged,
  });

  final TextEditingController textController;
  void Function(String)? onChanged;

  @override
  State<ChatTranslateTextField> createState() => _ChatTranslateTextFieldState();
}

class _ChatTranslateTextFieldState extends State<ChatTranslateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color(0xff3375FD),
      controller: widget.textController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(right: 90, left: 10),
        hintText: 'Type your message...',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
            color: Color(0xff3375FD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff3375FD),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
