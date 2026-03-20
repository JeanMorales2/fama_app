import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'data/datasources/local/app_database.dart';
import 'presentation/pages/destinations_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  //  await AppDatabase().deleteDatabaseFile(); 

  runApp(const FamaApp());
}

class FamaApp extends StatelessWidget {
  const FamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAMA App',
      debugShowCheckedModeBanner: false,
      home: const DestinationsPage(),
    );
  }
}