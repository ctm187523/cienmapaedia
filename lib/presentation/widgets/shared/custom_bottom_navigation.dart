
import 'package:flutter/material.dart';

class CustomButtomNavigation extends StatelessWidget {
  const CustomButtomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0, //quitamos la linea superior
      //tiene que ser minimo dos items ver video --> https://www.youtube.com/watch?v=HB5WMcxAmQQ
      items: const [
        BottomNavigationBarItem(
          icon: Icon( Icons.home_max),
          label: 'Inicio'
        ),
         BottomNavigationBarItem(
          icon: Icon( Icons.label_outline),
          label: 'Categorías'
        ),
         BottomNavigationBarItem(
          icon: Icon( Icons.favorite_border_outlined),
          label: 'Favoritos'
        ),
      ]);
  }
}