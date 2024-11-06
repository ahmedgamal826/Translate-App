import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Import the speech_to_text package
import 'package:translator_app/models/translation_history_model.dart';
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/views/language_selection_page.dart';
import 'package:translator_app/widgets/language_buttons.dart';
import 'package:translator_app/widgets/loading_dots.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';
import 'package:translator_app/widgets/text_field.dart';

final _formKey = GlobalKey<FormState>();

class TranslateView extends StatefulWidget {
  const TranslateView({super.key});

  @override
  State<TranslateView> createState() => _TranslateView();
}

class _TranslateView extends State<TranslateView> {
  TextEditingController languageController = TextEditingController();
  bool isTranslating = false;
  String originalLanguage = "English";
  String destinationLanguage = "Arabic";
  String output = "";
  final TranslatorService _translatorService = TranslatorService();
  stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize the SpeechToText instance

  FlutterTts _flutterTts = FlutterTts(); // Initialize FlutterTts instance

  bool _isListening = false; // Track the listening state
  final ImagePicker picker = ImagePicker(); // Intialize ImagePicker Instance

  String emojiRegex = r'(\p{Emoji})';

  ScrollController scrollController = ScrollController();

  Future<void> pickImageAndExtractText() async {
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('From where do you want to take the photo?'),
          actions: [
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      ImageSource.camera,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      ImageSource.gallery,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo,
                          size: 30,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
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

        setState(() {
          languageController.text = formattedText.toString();
        });

        await textDetector.close();
      }
    }
  }

  void translate(String src, String des, String input) async {
    setState(() {
      isTranslating = true;
    });

    final emojiMatches = RegExp(emojiRegex).allMatches(input);
    final emojis = emojiMatches.map((match) => match.group(0)).toList();

    String cleanedInput = input.replaceAll(RegExp(emojiRegex), '');

    saveTranslation(input, output);

    String translation =
        await _translatorService.translate(src, des, cleanedInput);

    for (var emoji in emojis) {
      translation = '$emoji $translation';
    }

    setState(() {
      output = translation.trim();
      isTranslating = false;
    });
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

  void clearInputs() {
    languageController.clear(); // Clear the input text field
    setState(() {
      output = ""; // Clear the output
      _stopListening();
      _flutterTts.stop(); // Stop the TTS when clearing inputs
      isTranslating = false;
    });
  }

  void _startListening() async {
    if (!_isListening) {
      _isListening = true;
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              languageController.text = result
                  .recognizedWords; // Set the recognized words to the input field
            });
          },
          localeId: _translatorService.getLanguageCode(
            originalLanguage,
          ), // Use the selected source language
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _isListening = false;
      _speech.stop();
    }
  }

//////////////////////////////

  Future<void> saveTranslation(String input, String output) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history =
        prefs.getStringList('translation_history') ?? [];

    final translation = TranslationHistory(
      input: input,
      output: output,
      time: DateTime.now(),
    );
    history!.add(jsonEncode(translation.toJson()));

    await prefs.setStringList('translation_history', history);
  }

  void speakOutputText() async {
    String textToSpeak = output.isNotEmpty ? output : languageController.text;

    print('Text to speak: $textToSpeak');

    await _flutterTts
        .setLanguage(_translatorService.getLanguageCode(destinationLanguage));
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

  void speakInputText() async {
    // Use the input text from the languageController instead of output
    String textToSpeak = languageController.text;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Translation'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              LanguageButtons(
                originalLanguage: originalLanguage,
                destinationLanguage: destinationLanguage,
                selectLanguage: selectLanguage,
                swapLanguage: swapLanguages,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        TranslateTextField(
                          languageController: languageController,
                          language: originalLanguage,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: clearInputs,
                          ),
                        ),
                        Positioned(
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
                                  onPressed: _isListening
                                      ? _stopListening
                                      : _startListening,
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
                              MaterialButton(
                                onPressed: () {
                                  if (languageController.text.isNotEmpty) {
                                    translate(
                                      _translatorService
                                          .getLanguageCode(originalLanguage),
                                      _translatorService
                                          .getLanguageCode(destinationLanguage),
                                      languageController.text,
                                    );

                                    // Scroll to the bottom after adding the message
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                color: Color(0xff3676F4),
                                child: SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          isTranslating ? '' : 'Translate',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isTranslating)
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.black),
                  ],
                ),
              ),
              SizedBox(height: 10),
              isTranslating == true
                  ? LoadingDots()
                  : output.isNotEmpty
                      ? Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff3375FD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 65,
                                ),
                                child: Center(
                                  child: SelectableText(
                                    output,
                                    textAlign: destinationLanguage == 'Arabic'
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              right: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        // to copy text
                                        Clipboard.setData(
                                                ClipboardData(text: output))
                                            .then((_) {
                                          customShowSnackBar(
                                            context: context,
                                            content: 'تم نسخ النص إلى الحافظة',
                                          );
                                        });
                                      },
                                      icon: Icon(
                                        Icons.copy_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: speakOutputText,
                                      icon: Icon(
                                        Icons.volume_up,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
