// class TranslationHistory {
//   final String input;
//   final String output;
//   bool isFavorite;
//   final DateTime time;

//   TranslationHistory({
//     required this.input,
//     required this.output,
//     this.isFavorite = false,
//     required this.time,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'input': input,
//       'output': output,
//       'isFavorite': isFavorite,
//       'time': time.toIso8601String(),
//     };
//   }

//   static TranslationHistory fromJson(Map<String, dynamic> json) {
//     return TranslationHistory(
//       input: json['input'] ?? '',
//       output: json['output'] ?? '',
//       isFavorite: json['isFavorite'] ?? false,
//       time: DateTime.parse(json['time']) ,
//     );
//   }
// }

class TranslationHistory {
  final String input;
  final String output;
  bool isFavorite;
  final DateTime time;

  TranslationHistory({
    required this.input,
    required this.output,
    this.isFavorite = false,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'input': input,
      'output': output,
      'isFavorite': isFavorite,
      'time': time.toIso8601String(),
    };
  }

  static TranslationHistory fromJson(Map<String, dynamic> json) {
    return TranslationHistory(
      input: json['input'] ?? '',
      output: json['output'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      time: DateTime.parse(
        json['time'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
