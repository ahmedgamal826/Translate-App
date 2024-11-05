import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  final List<String> languages;
  final String selectedLanguage;

  const LanguageSelectionPage({
    Key? key,
    required this.languages,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;
  List<String> filteredLanguages = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.selectedLanguage;
    filteredLanguages = widget.languages; // Initialize with all languages
  }

  void filterLanguages(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredLanguages = widget.languages
            .where((language) =>
                language.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredLanguages =
            widget.languages; // Reset to all languages if query is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3375FD),
        title: Text(
          'Select Language',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterLanguages(value);
              },
              decoration: InputDecoration(
                labelText: 'Search Language',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = filteredLanguages[index];
                return ListTile(
                  title: Text(language),
                  trailing: selectedLanguage == language
                      ? Icon(
                          Icons.check,
                          color: Colors.blue,
                          size: 30,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3676F4),
        onPressed: () {
          Navigator.pop(context, selectedLanguage);
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
