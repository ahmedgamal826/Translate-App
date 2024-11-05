import 'package:flutter/material.dart';

class LanguageButtons extends StatefulWidget {
  LanguageButtons(
      {super.key,
      required this.originalLanguage,
      required this.destinationLanguage,
      required this.selectLanguage,
      required this.swapLanguage});

  final String originalLanguage;
  final String destinationLanguage;
  final Function(BuildContext, bool) selectLanguage;
  void Function() swapLanguage;

  @override
  State<LanguageButtons> createState() => _LanguageButtonsState();
}

class _LanguageButtonsState extends State<LanguageButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffF1F1F1),
          ),
          onPressed: () => widget.selectLanguage(context, true),
          child: Row(
            children: [
              Text(
                widget.originalLanguage,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        IconButton(
          onPressed: widget.swapLanguage,
          icon: Icon(
            Icons.swap_horiz,
            color: Color(0xff3375FD),
            size: 33,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffF1F1F1),
          ),
          onPressed: () => widget.selectLanguage(context, false),
          child: Row(
            children: [
              Text(
                widget.destinationLanguage,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ],
    );
  }
}
