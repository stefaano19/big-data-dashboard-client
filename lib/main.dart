import 'package:flutter/material.dart';
import 'package:progetto_big_data_frontend/views/datapage.dart';
import 'package:progetto_big_data_frontend/views/homepage.dart';
import 'package:progetto_big_data_frontend/views/informationpage.dart';
import 'package:progetto_big_data_frontend/views/mappage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produzione Animale',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.white, // Sfondo bianco per lo scaffold
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Testo scuro per visibilità
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Produzione Animale",
          style: TextStyle(fontStyle: FontStyle.italic ,color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Query su Mappa"),
            Tab(text: "Informazioni dettagliate"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomePage(),
          MapPage(),
          InformationPage(),
        ],
      ),
    );
  }
}