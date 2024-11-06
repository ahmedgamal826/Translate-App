import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/models/translation_history_model.dart';
import 'package:translator_app/views/translation_details_view.dart';
import 'package:translator_app/widgets/show_snack_bar.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<TranslationHistory>> _favoritesFuture;
  List<TranslationHistory> favorites = [];

  @override
  void initState() {
    super.initState();
    _favoritesFuture = loadFavorites();
  }

  Future<List<TranslationHistory>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesList =
        prefs.getStringList('favorite_translations') ?? [];

    return favoritesList!
        .map((json) => TranslationHistory.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> deleteFavorite(TranslationHistory favorite) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove from favorites
    favorites.removeWhere((item) => item.input == favorite.input);

    // Update SharedPreferences with the new favorites list
    await prefs.setStringList(
      'favorite_translations',
      favorites.map((item) => jsonEncode(item.toJson())).toList(),
    );

    // Update the state to reflect the changes
    setState(() {
      // This will rebuild the widget to reflect the updated favorites
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Translation Favorites'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<TranslationHistory>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites found.'));
          }

          favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TranslationDetailPage(translation: favorite),
                    ),
                  );
                },
                child: Card(
                  color: Color(0xff3375FD),
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      favorite.input,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        // Show confirmation dialog
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text(
                                'Are you sure you want to delete this favorite?',
                                style: TextStyle(fontSize: 20),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      color: Color(0xff3375FD),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
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
                                        Navigator.of(context).pop(true);

                                        customShowSnackBar(
                                          context: context,
                                          content:
                                              'Translation deleted successfully!',
                                        );
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

                        // If the user confirms deletion
                        if (shouldDelete == true) {
                          await deleteFavorite(favorite);
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
