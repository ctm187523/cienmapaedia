
//clase abstracta para manejar la base da datos creada en este caso Isar
import '../entities/movie.dart';

abstract class LocalStorageDatasource {

  //Metodo para recibir la pelicula perteneciente a favoritos
  Future<void> toggleFavorite( Movie movie);

  //metodo para saber si la pelicula esta en los favoritos
  Future<bool> isMovieFavorite( int movieId);

  //metodo para hacer una paginacion de la lista de peliculas agregadas a favoritos
  Future<List<Movie>> loadMovies( {int limit = 10, offset = 0});
}