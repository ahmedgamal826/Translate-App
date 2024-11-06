import 'package:flutter/material.dart';

class CameraAndGalleryChatButtons extends StatelessWidget {
  CameraAndGalleryChatButtons({
    super.key,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
  });

  void Function()? pickImageFromCamera;
  void Function()? pickImageFromGallery;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}
