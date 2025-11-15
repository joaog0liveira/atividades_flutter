import 'package:flutter/material.dart';
import 'package:my_tasks/views/file_view.dart';
import 'package:provider/provider.dart';

import 'viewmodels/database_viewmodel.dart';
import 'viewmodels/file_viewmodel.dart';

import 'viewmodels/shared_preferences_viewmodel.dart';
import 'views/database_view.dart';

import 'views/shared_preferences_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPreferencesViewModel()),
        ChangeNotifierProvider(create: (_) => FileViewModel()),
        ChangeNotifierProvider(create: (_) => DatabaseViewModel()),
      ],
      child: MaterialApp(
        title: 'MyTasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MyTasks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.settings),
                text: 'SharedPrefs',
              ),
              Tab(
                icon: Icon(Icons.folder),
                text: 'File',
              ),
              Tab(
                icon: Icon(Icons.storage),
                text: 'SQLite',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SharedPreferencesView(),
            FileView(),
            DatabaseView(),
          ],
        ),
      ),
    );
  }
}
