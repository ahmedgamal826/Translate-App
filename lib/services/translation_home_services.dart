import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

import 'package:translator_app/widgets/camera_and_gallery_dialog.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  final ImagePicker picker = ImagePicker();

  String emojiRegex = r'(\p{Emoji})';
  bool isTranslating = false;
  String originalLanguage = "English";
  String destinationLanguage = "Arabic";
  String output = "";

  // Pick image and extract text from it
  Future<void> pickImageAndExtractText(
      BuildContext context, Function(String) onTextExtracted) async {
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return CameraAndGalleryDialog();
      },
    );

    if (pickedSource != null) {
      final XFile? image = await picker.pickImage(source: pickedSource);
      if (image != null) {
        final inputImage = InputImage.fromFile(File(image.path));
        final textDetector = GoogleMlKit.vision.textRecognizer();

        final RecognizedText recognizedText =
            await textDetector.processImage(inputImage);

        String rawText = recognizedText.text;

        List<String> lines = rawText.split('\n');

        StringBuffer formattedText = StringBuffer();
        for (String line in lines) {
          String paddedLine = line.trim();
          while (paddedLine.length < 50) {
            paddedLine += ' ';
          }
          formattedText.writeln(paddedLine);
        }

        onTextExtracted(formattedText.toString());

        await textDetector.close();
      }
    }
  }

  // Translate text from one language to another
  Future<void> translate(String src, String des, String input,
      Function(String) onTranslationComplete) async {
    isTranslating = true;

    final emojiMatches = RegExp(emojiRegex).allMatches(input);
    final emojis = emojiMatches.map((match) => match.group(0)).toList();

    String cleanedInput = input.replaceAll(RegExp(emojiRegex), '');

    try {
      Translation translation =
          await _translator.translate(cleanedInput, from: src, to: des);

      String translatedText = translation.text;

      for (var emoji in emojis) {
        translatedText = '$emoji $translatedText';
      }

      output = translatedText.trim();
    } catch (e) {
      output = "Translation failed: $e";
    }

    isTranslating = false;
    onTranslationComplete(output);
  }

  // Swap the source and destination languages
  void swapLanguages(Function(String, String) onLanguagesSwapped) {
    String temp = originalLanguage;
    originalLanguage = destinationLanguage;
    destinationLanguage = temp;

    onLanguagesSwapped(originalLanguage, destinationLanguage);
  }

  // Clear the input and output
  void clearInputs(Function onClear) {
    output = "";
    isTranslating = false;
    onClear();
  }
}
