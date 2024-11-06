import 'package:flutter/material.dart';

class DeleteChatDialog extends StatelessWidget {
  DeleteChatDialog({super.key, required this.removeMessage});

  void Function()? removeMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Message',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this message?',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              color: Color(0xff3375FD),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            MaterialButton(
              color: Color(0xff3375FD),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: removeMessage,
            ),
          ],
        )
      ],
    );
  }
}
