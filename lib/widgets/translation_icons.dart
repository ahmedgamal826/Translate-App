import 'package:flutter/material.dart';
import 'package:translator_app/widgets/translate_button.dart';

class TranslationIcons extends StatelessWidget {
  TranslationIcons({
    super.key,
    required this.pickImageAndExtractText,
    required this.speakInputText,
    required this.startAndStopListening,
    required this.originalLanguage,
    required this.destinationLanguage,
    required this.isTranslating,
    required this.languageController,
    required this.OnpressedTranslateButton,
  });

  final void Function() pickImageAndExtractText;
  final void Function() speakInputText;
  final void Function() startAndStopListening;
  final void Function() OnpressedTranslateButton;

  final String originalLanguage;
  final String destinationLanguage;
  bool isTranslating;
  final TextEditingController languageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: IconButton(
              onPressed: pickImageAndExtractText,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: IconButton(
              onPressed: startAndStopListening,
              icon: Icon(
                Icons.mic,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: IconButton(
              onPressed: speakInputText,
              icon: Icon(
                Icons.volume_up,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 30),
          TranslateButton(
              originalLanguage: originalLanguage,
              destinationLanguage: destinationLanguage,
              isTranslating: isTranslating,
              onPressed: OnpressedTranslateButton),
        ],
      ),
    );
  }
}
