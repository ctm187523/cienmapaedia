

//provider para determinar si tenemos la data para mostrar el loading en caso de que no

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final intialLoadingProvider = Provider<bool>((ref)  {

  //evaluamos si la data de los providers esta vacia con el metodo isEmpty de Riverpod
  //si esta vacio obtenemos un boolean como true
  final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider ).isEmpty;
  final popularMovies = ref.watch( popularMoviesProvider ).isEmpty;
  final upcomingMovies = ref.watch( upcomingMoviesProvider ).isEmpty;
  final topRateMovies = ref.watch( topRatedMoviesProvider ).isEmpty;

  //evaluamos el estado si hay alguno en true retornamos true, osea que estan vacios
  if ( nowPlayingMovies || popularMovies || upcomingMovies || topRateMovies ) return true;
  
  return false; //ya esta cargada la data y todos los providers estan en false
});