import 'package:flutter/material.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( //ponemos .router para usar go_router creado en appRouter
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme()
    );
  }
}
