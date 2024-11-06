import 'package:flutter/material.dart';

class TranslateButton extends StatelessWidget {
  TranslateButton({
    super.key,
    required this.originalLanguage,
    required this.destinationLanguage,
    required this.isTranslating,
    required this.onPressed,
  });

  final String originalLanguage;
  final String destinationLanguage;
  bool isTranslating;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
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
    );
  }
}
