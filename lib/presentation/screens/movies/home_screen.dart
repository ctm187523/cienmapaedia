
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';



class HomeScreen extends StatelessWidget {


  //propiedades
  //name para poder usarlo en go_router
  static const name = 'home-screen';
  final Widget childView; //vista que queremos mostrar(view), la vista es como un screen pero parcial ya que abajo tenemos los botones para seleccionar inicio,categorias,favoritos

  //constructor
  const HomeScreen({
    super.key,
    required this.childView
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      //usamos el widget creado en widgets/shared
      bottomNavigationBar: CustomButtomNavigation(),
    );
  }
}
