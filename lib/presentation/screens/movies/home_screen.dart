
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  //name para poder usarlo en go_router
  static const name = 'home-screen';

  //constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text( Enviroment.theMovieDbKey), //usamos la clase creada en config/constant donde tenemos constantes que contienen el acceso a las variables de entorno
      ),
    );
  }
}