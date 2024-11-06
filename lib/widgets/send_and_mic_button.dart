import 'package:flutter/material.dart';

class SendAndMicButton extends StatelessWidget {
  SendAndMicButton({
    super.key,
    required this.isImageSelected,
    required this.textController,
    required this.onPressedButton,
  });

  bool isImageSelected;
  final TextEditingController textController;
  void Function()? onPressedButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isImageSelected
          ? const EdgeInsets.only(bottom: 110)
          : const EdgeInsets.only(),
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Color(0xff3375FD),
        child: IconButton(
          icon: Icon(
            textController.text.isEmpty && !isImageSelected
                ? Icons.mic
                : Icons.send,
            size: 30,
            color: Colors.white,
          ),
          onPressed: onPressedButton,
        ),
      ),
    );
  }
}
