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
  // إضافة متغير لحفظ اتجاه الحركة
  bool isSwapping = false;

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
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500), // زيادة المدة
                transitionBuilder: (child, animation) {
                  if (isSwapping) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  widget.originalLanguage,
                  key: ValueKey<String>(widget.originalLanguage),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xff3375FD),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isSwapping = !isSwapping;
            });
            widget.swapLanguage();
          },
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
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  if (isSwapping) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  widget.destinationLanguage,
                  key: ValueKey<String>(widget.destinationLanguage),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xff3375FD),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
