import 'package:example/src/pages/home/venda_page.dart';
import 'package:example/src/pages/home/venda_digitada_page.dart';
import 'package:example/src/pages/home/venda_tef_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences preferences;
  const HomePage({super.key, required this.preferences});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example Agente Clisitef'),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                child: Text('Configuraçoes'),
              ),
              Tab(
                child: Text('Venda digitada'),
              ),
              Tab(
                child: Text('Venda pinpad'),
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            VendaPage(
              preferences: widget.preferences,
              tabController: tabController,
            ),
            VendaDigitadaPage(tabController: tabController),
            VendaPinpadPage(tabController: tabController)
          ],
        ),
      ),
    );
  }
}
