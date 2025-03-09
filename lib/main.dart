import 'package:flutter/material.dart';
import 'package:mining_app/feature/installation/presentation/pages/installation_page.dart';

import 'core/di/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Installation Wizard',
      theme: ThemeData.dark(),
      home: InstallationPage(),
    );
  }
}