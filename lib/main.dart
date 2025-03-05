import 'package:flutter/material.dart';
import 'feature/installation/presentation/pages/installation_screen.dart';
import 'feature/installation/di/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Installation Wizard',
      theme: ThemeData.dark(),
      home: InstallationScreen(),
    );
  }
}