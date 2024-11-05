import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:translator_app/services/translator_services.dart';
import 'package:translator_app/widgets/language_buttons.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class ChatTranslateView extends StatefulWidget {
  const ChatTranslateView({super.key});

  @override
  State<ChatTranslateView> createState() => _ChatTranslateView();
}

class _ChatTranslateView extends State<ChatTranslateView> {
  final ScrollController _scrollController =
      ScrollController(); // Step 1: Create ScrollController

  final TextEditingController _textController = TextEditingController();
  final TranslatorService _translatorService = TranslatorService();
  String originalLanguage = "English";
  String destinationLanguage = "Arabic";
  List<Map<String, dynamic>> chatMessages = [];
  final ImagePicker picker = ImagePicker();
  bool _isImageSelected = false;
  File? _selectedImage;

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

    // Scroll to the bottom after adding the message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // If an image is selected, reset the selected image flag
    if (_isImageSelected) {
      _isImageSelected = false;
      _selectedImage = null; // Reset the selected image
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

    // Scroll to the bottom after adding the translated message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Step 3: Dispose of the ScrollController
    super.dispose();
  }

  void _confirmDeleteMessage(int index) {
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
                    _removeMessage(index);
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

  void _removeMessage(int index) {
    setState(() {
      chatMessages.removeAt(index);
    });
  }

  Future<void> pickImageAndExtractText(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _isImageSelected = true;
        _selectedImage = File(image.path); // Store the selected image
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: LanguageButtons(
          originalLanguage: originalLanguage,
          destinationLanguage: destinationLanguage,
          selectLanguage:
              (context, isSource) {}, // Your language selection logic here
          swapLanguage: () {},
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                final bool isUser = message['type'] == 'user';
                return InkWell(
                  onLongPress: () => _confirmDeleteMessage(index),
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            message['message'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                          if (message['image'] != null)
                            GestureDetector(
                              onTap: () => _openImage(
                                context,
                                message['image'],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.file(
                                  File(message['image']),
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(height: 20),
                          SelectableText(
                            message['time'],
                            style: TextStyle(
                              fontSize: 15,
                              color: isUser ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

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
                          TextField(
                            cursorColor: Color(0xff3375FD),
                            controller: _textController,
                            onChanged: (text) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
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
                          ),
                          // if (_isImageSelected) // Show the selected image as a thumbnail
                          //   Padding(
                          //     padding: const EdgeInsets.only(top: 8.0),
                          //     child: Image.file(
                          //       _selectedImage!,
                          //       height: 100,
                          //       width: 100,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),

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
                                    fit: BoxFit.cover,
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
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: pickImageFromCamera,
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Color(0xff3375FD),
                              ),
                            ),
                            IconButton(
                              onPressed: pickImageFromGallery,
                              icon: Icon(
                                Icons.photo,
                                size: 30,
                                color: Color(0xff3375FD),
                              ),
                            ),
                          ],
                        ),
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
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          )

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Stack(
          //           alignment: Alignment.topRight,
          //           children: [
          //             Column(
          //               children: [
          //                 TextField(
          //                   cursorColor: Color(0xff3375FD),
          //                   controller: _textController,
          //                   onChanged: (text) {
          //                     setState(() {});
          //                   },
          //                   decoration: InputDecoration(
          //                     hintText: 'Type your message...',
          //                     focusedBorder: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(10),
          //                       borderSide: BorderSide(
          //                         width: 2,
          //                         color: Color(0xff3375FD),
          //                       ),
          //                     ),
          //                     enabledBorder: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(10),
          //                       borderSide: BorderSide(
          //                         width: 2,
          //                       ),
          //                     ),
          //                     border: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         color: Color(0xff3375FD),
          //                       ),
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                   ),
          //                 ),
          //                 if (_isImageSelected) // Show the selected image as a thumbnail
          //                   Padding(
          //                     padding: const EdgeInsets.only(top: 8.0),
          //                     child: Image.file(
          //                       _selectedImage!,
          //                       height: 100,
          //                       width: 100,
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //               ],
          //             ),
          //             Positioned(
          //               top: 0,
          //               right: 0,
          //               child: Row(
          //                 children: [
          //                   IconButton(
          //                     onPressed: pickImageFromCamera,
          //                     icon: Icon(
          //                       Icons.camera_alt,
          //                       size: 30,
          //                       color: Color(0xff3375FD),
          //                     ),
          //                   ),
          //                   IconButton(
          //                     onPressed: pickImageFromGallery,
          //                     icon: Icon(
          //                       Icons.photo,
          //                       size: 30,
          //                       color: Color(0xff3375FD),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(width: 5),
          //       CircleAvatar(
          //         radius: 23,
          //         backgroundColor: Color(0xff3375FD),
          //         child: IconButton(
          //           icon: Icon(
          //             _textController.text.isEmpty && !_isImageSelected
          //                 ? Icons.mic
          //                 : Icons.send,
          //             size: 30,
          //             color: Colors.white,
          //           ),
          //           onPressed: _sendMessage,
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
