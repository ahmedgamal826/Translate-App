import 'package:flutter/material.dart';
import 'package:translator_app/views/chat_translate_view.dart';
import 'package:translator_app/views/favourite_view.dart';
import 'package:translator_app/views/history_view.dart';
import 'package:translator_app/views/translate_view.dart';
import 'package:translator_app/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff3375FD),
          title: Text(
            'Translate',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.chat), text: 'Chat'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.star), text: 'Favorite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TranslateView(),
            ChatTranslateView(),
            HistoryView(),
            FavoritesScreen()
          ],
        ),
      ),
    );
  }
}
