import 'package:flutter/material.dart';
import 'package:translator_app/views/chat_translate_view.dart';
import 'package:translator_app/views/favourite_view.dart';
import 'package:translator_app/views/history_view.dart';
import 'package:translator_app/views/saved_chat_view.dart';
import 'package:translator_app/views/translate_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff3375FD),
          title: Text(
            'Translate',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                // منطق القائمة المنبثقة هنا
              },
              itemBuilder: (BuildContext context) {
                return {'Settings', 'Profile', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(icon: Icon(Icons.chat), text: 'Chat'),
              Tab(icon: Icon(Icons.save), text: 'Saved'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.star), text: 'Favorite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TranslateView(),
            ChatTranslateView(),
            SavedChatView(),
            HistoryPage(),
            FavoritesScreen()
          ],
        ),
      ),
    );
  }
}
