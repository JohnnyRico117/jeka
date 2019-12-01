import 'package:flutter/material.dart';

import 'package:jeka/ui/theme.dart';
import 'package:jeka/ui/screens/login.dart';
import 'package:jeka/ui/screens/settings.dart';
import 'package:jeka/ui/screens/profile.dart';
//import 'package:sabawa/ui/screens/projects.dart';
import 'package:jeka/controller/tab_controller.dart';

class JekaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabawa',
      theme: buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => JekaTabController(),
        '/login': (context) => LoginScreen(),
        '/settings': (context) => Settings(),
        '/profile': (context) => Profile(),
//        //'/friends': (context) => Friends(),
//        '/projects': (context) => Projects(),
      },
    );
  }
}