import 'package:flutter/material.dart';
import 'package:mining_app/feature/dashboard/presentation/pages/message_page.dart';
import 'package:mining_app/feature/dashboard/presentation/pages/dashboard_page.dart';

import 'core/di/injection.dart' as di;

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
      // home: MessagePage(closeThisPage: () {  },),
      home: DashboardPage(),
    );
  }
}