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
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff3375FD)),
        ),
      ),
      style: TextStyle(fontSize: 18),
    );
  }
}
