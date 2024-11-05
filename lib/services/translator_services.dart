// lib/translator.dart
import 'package:translator/translator.dart';

class TranslatorService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translate(String src, String des, String input) async {
    if (src.isEmpty || des.isEmpty) {
      return "Fail to translate";
    }

    var translation = await _translator.translate(input, from: src, to: des);
    return translation.text;
  }

  List<String> languages = [
    'English',
    'Arabic',
    'German',
    'French',
    'Hindi',
    'Italian',
    'Spanish',
    'Russian'
  ];

  String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Hindi':
        return 'hi';
      case 'Arabic':
        return 'ar';
      case 'German':
        return 'de';
      case 'French':
        return 'fr';
      case 'Italian':
        return 'it';
      case 'Spanish':
        return 'es';
      case 'Russian':
        return 'ru';
      default:
        return '--';
    }
  }
}
