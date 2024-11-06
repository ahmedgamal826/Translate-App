import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/widgets/delete_chat_dialog.dart';

class ChatTranslateServices {
  final TranslatorService _translatorService = TranslatorService();
  final ImagePicker picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();

  final TranslatorService translatorService = TranslatorService();

  Future<void> sendMessage(
      BuildContext context,
      TextEditingController textController,
      List<Map<String, dynamic>> chatMessages,
      ScrollController scrollController,
      bool isImageSelected,
      File? selectedImage) async {
    if (textController.text.isEmpty && !isImageSelected) return;

    final String userMessage = textController.text;
    final String timestamp =
        DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());

    chatMessages.add({
      'type': 'user',
      'message': userMessage,
      'time': timestamp,
      'image': selectedImage != null ? selectedImage.path : null,
    });

    // Scroll to the bottom after adding the message
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    if (isImageSelected) {
      final inputImage = InputImage.fromFile(selectedImage!);
      final textDetector = GoogleMlKit.vision.textRecognizer();

      try {
        final RecognizedText recognizedText =
            await textDetector.processImage(inputImage);
        String rawText = recognizedText.text;

        // Translate the extracted text
        String translatedText = await _translatorService.translate(
          _translatorService
              .getLanguageCode("English"), // Replace with actual languages
          _translatorService.getLanguageCode("Arabic"),
          rawText,
        );

        chatMessages.add({
          'type': 'translator',
          'message': translatedText,
          'time': timestamp,
        });
      } finally {
        await textDetector.close();
      }
    } else {
      String translatedText = await _translatorService.translate(
        _translatorService
            .getLanguageCode("English"), // Replace with actual languages
        _translatorService.getLanguageCode("Arabic"),
        userMessage,
      );

      chatMessages.add({
        'type': 'translator',
        'message': translatedText,
        'time': timestamp,
      });
    }

    // Clear text controller
    textController.clear();
    FocusScope.of(context).unfocus();
  }

  ///////////////////////////////////

  void scrollBottom(ScrollController scrollController) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ////////////////////////// Yes ////////////////////////////

  void confirmDeleteMessage({
    required BuildContext context,
    required List<Map<String, dynamic>> chatMessages,
    required int index,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteChatDialog(
          removeMessage: () {
            FocusScope.of(context).unfocus(); // Hide the keyboard
            removeMessage(chatMessages, index);
            Navigator.of(context).pop(); // Close the dialog
            onDelete(); // Call the callback to update UI or show a SnackBar
          },
        );
      },
    );
  }

  void removeMessage(List<Map<String, dynamic>> chatMessages, int index) {
    chatMessages.removeAt(index);
  }

  /////////////////////////////////////////////////

  Future<void> pickImageAndExtractText(
      ImageSource source, Function(File?) onImagePicked) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      onImagePicked(
          File(image.path)); // Call the callback with the selected image
    } else {
      onImagePicked(
          null); // Call the callback with null if no image was selected
    }
  }

  // Methods to pick image from gallery or camera
  void pickImageFromGallery(
      BuildContext context, Function(File?) onImagePicked) {
    pickImageAndExtractText(ImageSource.gallery, onImagePicked);
  }

  void pickImageFromCamera(
      BuildContext context, Function(File?) onImagePicked) {
    pickImageAndExtractText(ImageSource.camera, onImagePicked);
  }

  // Image opening method
  void openImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: PhotoView(
            imageProvider: FileImage(File(imagePath)),
            heroAttributes: PhotoViewHeroAttributes(tag: imagePath),
          ),
        ),
      ),
    );
  }

/////////////////////// Yes //////////////////////
  Future<void> startListening({
    required TextEditingController textController,
    required VoidCallback onListeningStarted,
    required VoidCallback onListeningStopped,
    required String originalLanguage,
    required TranslatorService translatorService,
  }) async {
    bool isListening = false;

    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == "listening") {
          isListening = true;
          onListeningStarted();
        } else if (val == "notListening") {
          isListening = false;
          onListeningStopped();
        }
      },
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          textController.text = result.recognizedWords;
        },
        localeId: translatorService.getLanguageCode(originalLanguage),
      );

      // onScrollToBottom();
      textController.clear();
    } else {
      print("Speech recognition is not available.");
    }
  }

  void stopListening() {
    _speech.stop();
  }
}
