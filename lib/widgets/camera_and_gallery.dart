import 'package:flutter/material.dart';

class CameraAndGallery extends StatefulWidget {
  CameraAndGallery({
    super.key,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
  });

  void Function()? pickImageFromCamera;
  void Function()? pickImageFromGallery;

  @override
  State<CameraAndGallery> createState() => _CameraAndGalleryState();
}

class _CameraAndGalleryState extends State<CameraAndGallery> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Row(
        children: [
          IconButton(
            onPressed: widget.pickImageFromCamera,
            icon: Icon(
              Icons.camera_alt,
              size: 30,
              color: Color(0xff3375FD),
            ),
          ),
          IconButton(
            onPressed: widget.pickImageFromGallery,
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
