

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

//provider para manejar un String, la ultima pelicula buscada
final searchQueryProvider = StateProvider<String>((ref) => '');

//provider para manejar todas las peliculas anteriormente buscadas
//como argumentos usamos la clase creada abaja y lo que sera el state(List<Movie>)
final searchMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {

  //obtenemos el provider, movieRepositoryProvider para obtener de el en el codigo de abajo
  //el metodo searchMovies de la clase MoviedbDatasource 
  final movieRepository = ref.read( movieRepositoryProvider );

  return SearchMoviesNotifier(
    searchMovies: movieRepository.searchMovies, //mandamos la referencia a la funcion searchMovies sin argumentos
    ref: ref
  );
});

//creamos el tipo de funcion que tenemos que recibir por parametro en la clase creada abajo
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {

  //propiedades
  final SearchMoviesCallback  searchMovies;
  final Ref ref; //obtenemos el ref para obtener los providers de RiverPood creados

  //constructor
  SearchMoviesNotifier( {

    required this.searchMovies,
    required this.ref
  }): super([]);

  Future<List<Movie>> searchMoviesByquery( String query ) async {

    final List<Movie>  movies = await searchMovies(query);

    
    //usamos la propiedad ref obtenida en el constructor para usar
    //el provider creado arriba en este mismo archivo
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies; //no ponemos spread [...movies] porque es un nuevo objeto como resultado de una nueva busqueda, no quiero mantener las anteriores

    return movies;
  }
}