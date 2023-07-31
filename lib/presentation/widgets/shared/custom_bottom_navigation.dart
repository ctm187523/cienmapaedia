import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigation extends StatelessWidget {


  //propiedades
  final int currentIndex;


  //constructor
  const CustomButtomNavigation({
    super.key,
    required this.currentIndex
  });

   //metodo que da la funcionalidad cuando se presiona un bottom del ButtomNavigationBar
  void onItemTapped ( BuildContext context, int index){

    switch (index) {
      case 0:
        context.go('/home/0'); //mandamos al home, ver en home_screen.dart la configuracion de las rutas
        break;
      case 1:
        context.go('/home/1'); 
        break;
      case 2:
        context.go('/home/2'); //mandamos a favoritos
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0, //quitamos la linea superior
        currentIndex: currentIndex, //recibimos el currentIndex de los argumentos recibidos en el constructor
        
        //metodo que recibe que opcion del custom_bottom_navigation ha sido seleccionada
        onTap: (value) {
          onItemTapped(context, value);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline), label: 'Categorías'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), label: 'Favoritos'),
        ]);
  }
}
