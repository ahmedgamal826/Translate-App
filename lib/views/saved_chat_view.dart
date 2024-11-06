// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SavedChatTranslator extends StatefulWidget {
//   @override
//   _SavedChatTranslatorState createState() => _SavedChatTranslatorState();
// }

// class _SavedChatTranslatorState extends State<SavedChatTranslator> {
//   List<Map<String, dynamic>> savedChats = [];

//   @override
//   void initState() {
//     super.initState();
//     loadSavedChats();
//   }

//   void loadSavedChats() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       savedChats = prefs.getStringList('savedChats') ?? [];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('المحادثات المحفوظة'),
//       ),
//       body: ListView.builder(
//         itemCount: savedChats.length,
//         itemBuilder: (context, index) {
//           return index % 2 == 0
//               ? Card(
//                   color: Colors.red,
//                   child: ListTile(
//                     title: Text(savedChats[index]),
//                   ),
//                 )
//               : Card(
//                   color: Colors.green,
//                   child: ListTile(
//                     title: Text(savedChats[index]),
//                   ),
//                 );
//         },
//       ),
//     );
//   }
// }
