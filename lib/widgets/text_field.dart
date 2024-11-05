import 'package:flutter/material.dart';

class TranslateTextField extends StatelessWidget {
  final TextEditingController languageController;
  final String language;

  const TranslateTextField({
    Key? key,
    required this.language,
    required this.languageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 10,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      textDirection:
          language == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 70),
        hintText: 'Write text to translate',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        errorStyle: TextStyle(color: Colors.red, fontSize: 20),
      ),
      controller: languageController,
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter text to translate'
          : null,
    );
  }
}
