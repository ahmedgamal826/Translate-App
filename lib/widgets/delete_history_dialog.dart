import 'package:flutter/material.dart';

class DeleteHistoryDialog extends StatelessWidget {
  DeleteHistoryDialog({super.key, required this.deleteTranslation});

  void Function() deleteTranslation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Translation'),
      content: Text(
        'Are you sure you want to delete this translation?',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              color: Color(0xff3375FD),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            MaterialButton(
              color: Color(0xff3375FD),
              onPressed: deleteTranslation,
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
