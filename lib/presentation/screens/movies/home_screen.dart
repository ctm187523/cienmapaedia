
import 'package:cinemapedia/presentation/views/movies/popular_view.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

import '../../views/views.dart';


class HomeScreen extends StatelessWidget {

  //propiedades
  //name para poder usarlo en go_router
  static const name = 'home-screen';
  final int pageIndex; //variable que indica el indice de la vista(home,categories,favorites) que queremos mostrar

  //constructor
  const HomeScreen({
    super.key,
    required this.pageIndex
  });

  //creamos un listado de Widgets con las Views
  final viewRoutes = const <Widget>[
    HomeView(),
    PopularView(),  //<--- categorias View
    FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //usamos la clase de Flutter IndexedStack para preservar el estado
      body: IndexedStack(
        index: pageIndex, //indice de la view que quiero mostrar
        children: viewRoutes, //usamos el array creado arriba
      ),
      //usamos el widget creado en widgets/shared
      bottomNavigationBar: CustomButtomNavigation( currentIndex: pageIndex),
    );
  }
}

