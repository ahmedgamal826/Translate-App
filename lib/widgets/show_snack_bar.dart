import 'package:flutter/material.dart';

void customShowSnackBar({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textAlign: TextAlign.center,
          content,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
