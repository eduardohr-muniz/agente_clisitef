import 'package:example/src/pages/home/venda_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences preferences;
  const HomePage({super.key, required this.preferences});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example Agente Clisitef'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Venda'),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          VendaPage(
            preferences: widget.preferences,
          )
        ]),
      ),
    );
  }
}
