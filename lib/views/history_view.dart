import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/models/translation_history_model.dart';
import 'package:translator_app/views/translation_details_view.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TranslationHistory> translationHistoryList = [];

  @override
  void initState() {
    super.initState();
    loadTranslationHistory();
  }

  Future<void> loadTranslationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history =
        prefs.getStringList('translation_history') ?? [];

    setState(() {
      translationHistoryList = history!
          .map((item) => TranslationHistory.fromJson(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> deleteTranslation(
      BuildContext context, TranslationHistory translation) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history =
        prefs.getStringList('translation_history') ?? [];

    history!
        .removeWhere((item) => jsonDecode(item)['input'] == translation.input);
    await prefs.setStringList('translation_history', history);

    setState(() {
      translationHistoryList.remove(translation);
    });

    customShowSnackBar(
        context: context, content: 'Translation deleted successfully.');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: translationHistoryList.isEmpty
          ? Center(child: Text('No history found.'))
          : ListView.builder(
              itemCount: translationHistoryList.length,
              itemBuilder: (context, index) {
                final translation = translationHistoryList[index];
                return Card(
                  color: Color(0xff3375FD),
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        translation.input,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd – hh:mm a')
                            .format(translation.time),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TranslationDetailPage(translation: translation),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            translation.isFavorite = !translation.isFavorite;
                            final prefs = await SharedPreferences.getInstance();
                            final List<String>? favorites =
                                prefs.getStringList('favorite_translations') ??
                                    [];

                            if (translation.isFavorite) {
                              favorites!.add(jsonEncode(translation.toJson()));
                              await prefs.setStringList(
                                  'favorite_translations', favorites);
                              customShowSnackBar(
                                  context: context,
                                  content:
                                      'Translation is added to favourites');
                            }
                          },
                          icon: Icon(
                            translation.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Translation'),
                                  content: Text(
                                    'Are you sure you want to delete this translation?',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                          onPressed: () {
                                            deleteTranslation(
                                                context, translation);
                                          },
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
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}