import 'package:flutter/material.dart';

class SavedChatView extends StatefulWidget {
  const SavedChatView({super.key});

  @override
  State<SavedChatView> createState() => _SavedChatViewState();
}

class _SavedChatViewState extends State<SavedChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Chat Translate'),
      ),
    );
  }
}
