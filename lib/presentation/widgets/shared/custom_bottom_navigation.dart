
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigation extends StatelessWidget {

  //constructor
  const CustomButtomNavigation({super.key});

  //metodo para saber que opcion del ButtomNavigationBar se a presionado Inicio, Categorias,Favoritos
  //recibimos el path gracias al GoRouterState.of(context).location y con un switch devolvemos el indice
  // del boton seleccionado 0 Inicio,1 Categorias, 2 Favoritos
 int getCurrentIndex( BuildContext context) {

    final String location = GoRouterState.of(context).location;

    switch (location) {
      case '/':
        return 0; //no hace falta poner el break porque el return sale de la funcion
      case '/categories':
        return 1;
      case '/favorites':
        return 2;
      default:
        return 0;
    }
  }

  //metodo que da la funcionalidad cuando se presiona un bottom del ButtomNavigationBar
  void onItemTapped ( BuildContext context, int index){

    switch (index) {
      case 0:
        context.go('/'); //mandamos al home
        break;
      case 1:
        context.go('/'); 
        break;
      case 2:
        context.go('/favorites'); //mandamos a favoritos
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0, //quitamos la linea superior
      //tiene que ser minimo dos items ver video --> https://www.youtube.com/watch?v=HB5WMcxAmQQ
     
      //recibimos el indice del boton seleccionado /0 Inicio,1 Categorias, 2 Favoritos
      //gracias al metodo getCurrentIndex creado arriba, y queda seleccionado el boton de la opcion elejida
      currentIndex: getCurrentIndex(context),
      //recibimos la opcion seleccionado del ButtomNavigationBar, en el value recibimos el numero del item seleccionado
      //0 Inicio,1 Categorias, 2 Favoritos
      onTap: (value){
        onItemTapped(context, value); //llamamos a la funcion creada arriba
      },
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