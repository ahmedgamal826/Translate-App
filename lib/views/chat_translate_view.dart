import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/services/chat_translate_services.dart';
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/views/language_selection_page.dart';
import 'package:translator_app/widgets/camera_and_gallery.dart';
import 'package:translator_app/widgets/chat_translate_list_view.dart';
import 'package:translator_app/widgets/chat_translate_text_field.dart';
import 'package:translator_app/widgets/language_buttons.dart';
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
  bool _isListening = false; // Track the listening state

  stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize the SpeechToText instance

  FlutterTts _flutterTts = FlutterTts(); // Initialize FlutterTts instance
  final ChatTranslateServices chatService =
      ChatTranslateServices(); // Use ChatService

  void sendMessage() async {
    await chatService.sendMessage(context, _textController, chatMessages,
        _scrollController, _isImageSelected, _selectedImage);
    setState(() {
      // Reset image selection state after sending message
      _isImageSelected = false;
      _selectedImage = null;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Step 3: Dispose of the ScrollController
    super.dispose();
  }

  void confirmDeleteMessage(int index) {
    chatService.confirmDeleteMessage(context, index, (index) {
      chatService.removeMessage(chatMessages, index);
      setState(() {});
    });
  }

  // Method to handle image selection from gallery
  void pickImageFromGallery() {
    chatService.pickImageFromGallery(context, (File? image) {
      setState(() {
        _isImageSelected = image != null;
        _selectedImage = image; // Store the selected image
      });
    });
  }

  // Method to handle image selection from camera
  void pickImageFromCamera() {
    chatService.pickImageFromCamera(context, (File? image) {
      setState(() {
        _isImageSelected = image != null;
        _selectedImage = image; // Store the selected image
      });
    });
  }

  void openImage(BuildContext context, String imagePath) {
    chatService.openImage(context, imagePath);
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

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == "listening") {
            setState(() {
              _isListening = true;
            });
          } else if (val == "notListening") {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
          localeId: _translatorService.getLanguageCode(
            originalLanguage,
          ),
        );

        // Scroll to the bottom after adding the translated message
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        _textController.clear();
        FocusScope.of(context).unfocus();
      } else {
        print("Speech recognition is not available.");
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      _isListening = false;
      _speech.stop();
    }
  }

  void speakInputText() async {
    // Use the input text from the languageController instead of output
    String textToSpeak = _textController.text;

    // Log the text to speak for debugging
    print('Text to speak: $textToSpeak');

    // Set the language for TTS
    await _flutterTts.setLanguage(_translatorService
        .getLanguageCode(originalLanguage)); // Use originalLanguage for input
    await _flutterTts.setPitch(1.0);

    // Only speak if the text is not empty
    if (textToSpeak.isNotEmpty) {
      try {
        await _flutterTts.speak(textToSpeak);
        print('Speaking: $textToSpeak'); // Log that speaking is happening
      } catch (e) {
        print('Error speaking: $e'); // Log any errors that occur
      }
    } else {
      print('Nothing to speak'); // Inform that there's nothing to say
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Chat With Translator'),
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
            confirmDeletion: confirmDeleteMessage,
            destinationLanguage: destinationLanguage,
            openImage: openImage,
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
                            onChanged: (text) {
                              setState(() {});
                            },
                            textController: _textController,
                          ),
                          if (_isImageSelected) // Show the selected image as a thumbnail
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                  ),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isImageSelected =
                                          false; // Hide the image
                                      _selectedImage =
                                          null; // Reset the selected image
                                    });
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                      CameraAndGallery(
                        pickImageFromCamera: pickImageFromCamera,
                        pickImageFromGallery: pickImageFromGallery,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: _isImageSelected
                      ? const EdgeInsets.only(bottom: 110)
                      : const EdgeInsets.only(),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Color(0xff3375FD),
                    child: IconButton(
                        icon: Icon(
                          _textController.text.isEmpty && !_isImageSelected
                              ? Icons.mic
                              : Icons.send,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_textController.text.isEmpty &&
                              !_isImageSelected) {
                            _isListening ? _stopListening() : _startListening();
                          } else {
                            sendMessage();
                          }
                        }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
