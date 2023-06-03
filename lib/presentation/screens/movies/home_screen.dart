
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  //name para poder usarlo en go_router
  static const name = 'home-screen';

  //constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Placeholder(),
    );
  }
}