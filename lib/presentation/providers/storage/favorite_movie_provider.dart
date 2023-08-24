
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';



final favoriteMovieProvider = StateNotifierProvider<StorageMoviesNotifier,Map<int,Movie> >((ref) {

  final localStorageRepository =ref.watch( localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageReposotory: localStorageRepository);
});

//clase que hereda de StateNotifier y maneja un mapa con un entero
//que es el id de la pelicula y una pelicula asociada a ese id
class StorageMoviesNotifier extends StateNotifier<Map<int , Movie>> {
  
  //propiedades
  int page = 0;
  final LocalStorageReposotory localStorageReposotory;

  //constructor
  StorageMoviesNotifier({
    required this.localStorageReposotory
  }): super({});

  Future<List<Movie>> loadNextPage() async {

    final movies = await localStorageReposotory.loadMovies(offset: page * 10, limit: 20); 
    page ++;
    
    //creamos una variable final del tipo que hemos puesto al crear la classe <int, Movie>
    //y heredar del StateNotifier
    final tempMoviesMap = <int, Movie>{};
    //recorremos un un bucle for con las movies y usamos la variable creada
    //arriba para tiparlo 
    for ( final movie in movies ){
      tempMoviesMap[movie.id] = movie;
    }
    //actualizamos el state
    state = { ...state, ...tempMoviesMap };

    return movies;
  }

  //metodo para que al pulsar el corazon de favoritos en la pantalla de favoritos
  //se modifique dinamicamente sin tener que refrescar la pantalla para ver el efecto
  Future<void> toogleFavorite ( Movie movie ) async{

    await localStorageReposotory.toggleFavorite(movie);
    //preguntamos si la pelicula esta en el state
    final bool isMovieInFavorites = state[movie.id] != null;

    if ( isMovieInFavorites ) {

      state.remove(movie.id);
      state = { ...state};
    }else  {
      state = { ...state, movie.id: movie};
    }
  }
}