import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:translator_app/services/chat_translate_services.dart';
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/views/language_selection_page.dart';
import 'package:translator_app/widgets/camera_and_gallery_chat_button.dart';
import 'package:translator_app/widgets/chat_translate_list_view.dart';
import 'package:translator_app/widgets/chat_translate_text_field.dart';
import 'package:translator_app/widgets/language_buttons.dart';
import 'package:translator_app/widgets/send_and_mic_button.dart';
import 'package:translator_app/widgets/show_small_chat_image.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatTranslateView extends StatefulWidget {
  const ChatTranslateView({super.key});

  @override
  State<ChatTranslateView> createState() => _ChatTranslateView();
}

class _ChatTranslateView extends State<ChatTranslateView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TranslatorService _translatorService = TranslatorService();
  String originalLanguage = "English";
  String destinationLanguage = "Arabic";
  List<Map<String, dynamic>> chatMessages = [];
  final ImagePicker picker = ImagePicker();
  bool _isImageSelected = false;
  File? _selectedImage;
  bool _isListening = false;

  final ChatTranslateServices chatTranslateServices = ChatTranslateServices();

  stt.SpeechToText _speech = stt.SpeechToText();

  void _sendMessage() async {
    if (_textController.text.isEmpty && !_isImageSelected) return;

    final String userMessage = _textController.text;
    final String timestamp =
        DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());

    setState(() {
      chatMessages.add({
        'type': 'user',
        'message': userMessage,
        'time': timestamp,
        'image': _selectedImage != null ? _selectedImage!.path : null,
      });
    });

    if (_isImageSelected) {
      final inputImage = InputImage.fromFile(_selectedImage!);
      final textDetector = GoogleMlKit.vision.textRecognizer();

      try {
        final RecognizedText recognizedText =
            await textDetector.processImage(inputImage);
        String rawText = recognizedText.text;
        setState(() {});
        String translatedText = await _translatorService.translate(
          _translatorService.getLanguageCode(originalLanguage),
          _translatorService.getLanguageCode(destinationLanguage),
          rawText,
        );
        _textController.clear();
        FocusScope.of(context).unfocus();

        setState(() {
          chatMessages.add({
            'type': 'translator',
            'message': translatedText,
            'time': timestamp,
          });
        });
        _isImageSelected = false;
        _selectedImage = null;
      } finally {
        await textDetector.close();
      }
    } else {
      String translatedText = await _translatorService.translate(
        _translatorService.getLanguageCode(originalLanguage),
        _translatorService.getLanguageCode(destinationLanguage),
        userMessage,
      );

      setState(() {
        chatMessages.add({
          'type': 'translator',
          'message': translatedText,
          'time': timestamp,
        });
      });
    }
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDeleteMessage() {
    setState(() {}); // Rebuild the widget to update the UI
    customShowSnackBar(
        context: context, content: 'Message deleted successfully');
  }

  Future<void> pickImageAndExtractText(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _isImageSelected = true;
        _selectedImage = File(image.path); // Store the selected image
      });
    } else {
      setState(() {
        _isImageSelected = false;
        _selectedImage = null;
      });
    }
  }

  void pickImageFromGallery() {
    pickImageAndExtractText(ImageSource.gallery);
  }

  void pickImageFromCamera() {
    pickImageAndExtractText(ImageSource.camera);
  }

  void _openImage(BuildContext context, String imagePath) {
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

  void selectLanguage(BuildContext context, bool isSource) async {
    TranslatorService translatorService = TranslatorService();
    final selectedLanguage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageSelectionPage(
          languages: translatorService.languages,
          selectedLanguage: isSource ? originalLanguage : destinationLanguage,
        ),
      ),
    );

    if (selectedLanguage != null) {
      setState(() {
        if (isSource) {
          originalLanguage = selectedLanguage;
        } else {
          destinationLanguage = selectedLanguage;
        }
      });
    }
  }

  void swapLanguages() {
    setState(() {
      String temp = originalLanguage;
      originalLanguage = destinationLanguage;
      destinationLanguage = temp;
    });
  }

  void _startListening() {
    chatTranslateServices.startListening(
      textController: _textController,
      onListeningStarted: () {
        setState(() {
          _isListening = true;
        });
      },
      onListeningStopped: () {
        setState(() {
          _isListening = false;
        });
      },
      originalLanguage: originalLanguage,
      translatorService: _translatorService,
    );
  }

  void _stopListening() {
    chatTranslateServices.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat With Translator',
        ),
      ),
      body: Column(
        children: [
          LanguageButtons(
            originalLanguage: originalLanguage,
            destinationLanguage: destinationLanguage,
            selectLanguage: selectLanguage,
            swapLanguage: swapLanguages,
          ),
          ChatTranslateListView(
            chatMessages: chatMessages,
            confirmDeletion: (index) {
              chatTranslateServices.confirmDeleteMessage(
                context: context,
                chatMessages: chatMessages,
                index: index,
                onDelete: _onDeleteMessage,
              );
            },
            destinationLanguage: destinationLanguage,
            openImage: _openImage,
            scrollController: _scrollController,
          ),
          // Text Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        children: [
                          ChatTranslateTextField(
                            textController: _textController,
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                          if (_isImageSelected) // Show the selected image as a thumbnail
                            ShowSmallChatImage(
                              selectedImage: _selectedImage,
                              closeImage: () {
                                setState(
                                  () {
                                    _isImageSelected = false; // Hide the image
                                    _selectedImage = null;
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                      CameraAndGalleryChatButtons(
                        pickImageFromCamera: pickImageFromCamera,
                        pickImageFromGallery: pickImageFromGallery,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                SendAndMicButton(
                  isImageSelected: _isImageSelected,
                  textController: _textController,
                  onPressedButton: () {
                    if (_textController.text.isEmpty && !_isImageSelected) {
                      _isListening ? _stopListening() : _startListening();
                    } else {
                      _sendMessage();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
