import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class ChatTranslateServices {
  final TranslatorService _translatorService = TranslatorService();
  final ImagePicker picker = ImagePicker();

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

  void confirmDeleteMessage(
      BuildContext context, int index, Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Message',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this message?',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Color(0xff3375FD),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                MaterialButton(
                  color: Color(0xff3375FD),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    onDelete(
                        index); // Call the delete function passed as a callback
                    Navigator.of(context).pop(); // Close the dialog
                    customShowSnackBar(
                      context: context,
                      content: 'Message deleted successfully',
                    );
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // This method removes a message from the list
  void removeMessage(List<Map<String, dynamic>> chatMessages, int index) {
    chatMessages.removeAt(index);
  }

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
}
