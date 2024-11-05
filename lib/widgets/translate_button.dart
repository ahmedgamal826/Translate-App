import 'package:flutter/material.dart';

class TranslateButton extends StatefulWidget {
  TranslateButton({super.key, required this.onPressed});

  void Function()? onPressed;

  @override
  State<TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends State<TranslateButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: Color(0xff3676F4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'Translate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
