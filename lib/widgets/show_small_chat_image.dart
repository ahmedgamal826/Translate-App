import 'dart:io';

import 'package:flutter/material.dart';

class ShowSmallChatImage extends StatelessWidget {
  ShowSmallChatImage({
    super.key,
    required this.selectedImage,
    required this.closeImage,
  });

  File? selectedImage;
  void Function() closeImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Image.file(
            selectedImage!,
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
          onPressed: closeImage,
        ),
      ],
    );
  }
}
