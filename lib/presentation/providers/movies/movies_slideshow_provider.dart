
//provider para que no muestre todas las peliculas recibidas en el carrusel(slideshow)
import 'package:cinemapedia/domain/entities/movie.dart';

import 'movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref){

  //obtenemos las peliculas del provider creado anteriormente nowPlayingMoviesProvider
  final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider);

  if ( nowPlayingMovies.isEmpty) return []; //si esta vacio retornamos un array vacio

  return nowPlayingMovies.sublist(0,6); //si no esta vacio retornamos las 6 primeras peliculas 
});