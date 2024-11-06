// // lib/translator.dart
// import 'package:translator/translator.dart';

// class TranslatorService {
//   final GoogleTranslator _translator = GoogleTranslator();

//   Future<String> translate(String src, String des, String input) async {
//     if (src.isEmpty || des.isEmpty) {
//       return "Fail to translate";
//     }

//     var translation = await _translator.translate(input, from: src, to: des);
//     return translation.text;
//   }

//   List<String> languages = [
//     'English',
//     'Arabic',
//     'German',
//     'French',
//     'Hindi',
//     'Italian',
//     'Spanish',
//     'Russian'
//   ];

//   String getLanguageCode(String language) {
//     switch (language) {
//       case 'English':
//         return 'en';
//       case 'Hindi':
//         return 'hi';
//       case 'Arabic':
//         return 'ar';
//       case 'German':
//         return 'de';
//       case 'French':
//         return 'fr';
//       case 'Italian':
//         return 'it';
//       case 'Spanish':
//         return 'es';
//       case 'Russian':
//         return 'ru';
//       default:
//         return '--';
//     }
//   }
// }

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
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Portuguese',
    'Dutch',
    'Greek',
    'Turkish',
    'Swedish',
    'Norwegian',
    'Polish',
    'Thai',
    'Vietnamese',
    'Czech',
    'Hungarian',
    'Romanian',
    'Bulgarian',
    'Danish',
    'Finnish',
    'Hindi',
    'Indonesian',
    'Malay',
    'Filipino',
    'Hebrew',
    'Swahili',
    'Tamil',
    'Telugu',
    'Urdu',
    'Bengali',
    'Punjabi',
    'Persian',
    'Arabic (Egyptian)',
    'Vietnamese (Vietnam)',
    'Catalan',
    'Ukrainian',
    'Serbian',
    'Croatian',
    'Lithuanian',
    'Latvian',
    'Estonian',
    'Slovak',
    'Slovenian',
    'Afrikaans',
    'Bengali (India)',
    'Marathi',
    'Kannada',
    'Gujarati',
    'Punjabi (India)',
    'Nepali',
    'Malayalam',
    'Sinhala',
    'Pashto',
    'Amharic',
    'Somali'
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
      case 'Chinese':
        return 'zh';
      case 'Japanese':
        return 'ja';
      case 'Korean':
        return 'ko';
      case 'Portuguese':
        return 'pt';
      case 'Dutch':
        return 'nl';
      case 'Greek':
        return 'el';
      case 'Turkish':
        return 'tr';
      case 'Swedish':
        return 'sv';
      case 'Norwegian':
        return 'no';
      case 'Polish':
        return 'pl';
      case 'Thai':
        return 'th';
      case 'Vietnamese':
        return 'vi';
      case 'Czech':
        return 'cs';
      case 'Hungarian':
        return 'hu';
      case 'Romanian':
        return 'ro';
      case 'Bulgarian':
        return 'bg';
      case 'Danish':
        return 'da';
      case 'Finnish':
        return 'fi';
      case 'Indonesian':
        return 'id';
      case 'Malay':
        return 'ms';
      case 'Filipino':
        return 'tl';
      case 'Hebrew':
        return 'he';
      case 'Swahili':
        return 'sw';
      case 'Tamil':
        return 'ta';
      case 'Telugu':
        return 'te';
      case 'Urdu':
        return 'ur';
      case 'Bengali':
        return 'bn';
      case 'Punjabi':
        return 'pa';
      case 'Persian':
        return 'fa';
      case 'Ukrainian':
        return 'uk';
      case 'Catalan':
        return 'ca';
      case 'Serbian':
        return 'sr';
      case 'Croatian':
        return 'hr';
      case 'Lithuanian':
        return 'lt';
      case 'Latvian':
        return 'lv';
      case 'Estonian':
        return 'et';
      case 'Slovak':
        return 'sk';
      case 'Slovenian':
        return 'sl';
      case 'Afrikaans':
        return 'af';
      case 'Marathi':
        return 'mr';
      case 'Kannada':
        return 'kn';
      case 'Gujarati':
        return 'gu';
      case 'Punjabi (India)':
        return 'pa';
      case 'Nepali':
        return 'ne';
      case 'Malayalam':
        return 'ml';
      case 'Sinhala':
        return 'si';
      case 'Pashto':
        return 'ps';
      case 'Amharic':
        return 'am';
      case 'Somali':
        return 'so';
      default:
        return '--';
    }
  }
}
