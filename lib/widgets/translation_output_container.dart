import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class TranslationOutputContainer extends StatelessWidget {
  TranslationOutputContainer({
    super.key,
    required this.output,
    required this.destinationLanguage,
    required this.speakOutputText,
  });

  final String output;
  final String destinationLanguage;
  final void Function() speakOutputText;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff3375FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 65,
            ),
            child: Center(
              child: SelectableText(
                output,
                textAlign: destinationLanguage == 'Arabic'
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    // to copy text
                    Clipboard.setData(ClipboardData(text: output)).then((_) {
                      customShowSnackBar(
                        context: context,
                        content: 'تم نسخ النص إلى الحافظة',
                      );
                    });
                  },
                  icon: Icon(
                    Icons.copy_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: speakOutputText,
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
