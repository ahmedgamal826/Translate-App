import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator_app/models/translation_history_model.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class TranslationDetailPage extends StatelessWidget {
  final TranslationHistory translation;

  TranslationDetailPage({required this.translation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3375FD),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3375FD),
        title: Text(
          'Translation Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              // Copy text to clipboard
              Clipboard.setData(ClipboardData(text: translation.input));
              customShowSnackBar(
                context: context,
                content: 'Copied to clipboard!',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              SelectableText(
                translation.input,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
