import 'package:flutter/material.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class ProfileButtons extends StatelessWidget {
  ProfileButtons({
    super.key,
    required this.OnPressedProfile,
    required this.btnText,
    required this.backgroundColor,
    required this.snackBarContent,
  });

  void Function() OnPressedProfile;
  final String btnText;
  Color backgroundColor;
  final String snackBarContent;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        OnPressedProfile();

        customShowSnackBar(context: context, content: snackBarContent);

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
