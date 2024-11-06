import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAndGalleryDialog extends StatelessWidget {
  const CameraAndGalleryDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
