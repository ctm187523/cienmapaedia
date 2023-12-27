
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class MoviePosterLink extends StatelessWidget {


  //propiedades
  final Movie movie;

  //constructor
  const MoviePosterLink({
    super.key,
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${ movie.id }') ,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          //EN EL CODIGO MEJORADO DE FERNANDO HERRERA VER ESTA MISMA CLASE LO HACE DISTINTO Y MIENTRAS LAS IMAGENES NO CARGAN
          //MUESTRA UNAS BOTELLASS
          child: Image.network(movie.posterPath),
        ),
      ),
    );
  }
}