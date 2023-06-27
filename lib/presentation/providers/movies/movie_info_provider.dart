
//provider para recibir la informacion de una pelicula en concreto

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';
import 'movies_repository_provider.dart';


//creamos el Provider
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {

  //usamos el provider movieRepositoryProvider para en la siguiente linea usar el metodo getMovieId
  //y pasarlo por parametro a la clase creada abajo MovieMapNotifier
  final movieRepository = ref.watch( movieRepositoryProvider );


  return MovieMapNotifier(getMovie: movieRepository.getMovieById); //pasamos la referencia sin parentesis getMovieById()
});


//creamos un typedef para manejar la funcion que vamos a recibir en la clase MovieMapNotifier
//creada abajo
typedef GetMovieCallBack = Future<Movie>Function(String movieId);

//creamos un mapa donde tenemos el id de la pelicula y apunta a una instancia de la clase Movie
//queremos manejar una memoria cache para que si esa pelicula ya ha sido cargada anteriormente
//no la vuelva a cargar y use la cargada
class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  
  final GetMovieCallBack getMovie;

  //constructor
  MovieMapNotifier({
    required this.getMovie
  }): super({});

  Future<void> loadMovie(String movieId) async {
    //el state seria el array de movieId en cache, seria la cache en memoria si ya existe salimos
    //y no cargamos la pelicula seleccionada a mostrar
    if( state[movieId ] != null) return;


    final movie = await getMovie( movieId );

    //creamos un nuevo estado para manejar la cache, usamos el spread ... con los moviId almacenados
    // y almacenamos la nueva movie 
    state = { ...state, movieId: movie};

  }

}