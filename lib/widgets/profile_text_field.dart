import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff3375FD),
        hintText: label,
        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff3375FD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff3375FD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff3375FD)),
        ),
      ),
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
