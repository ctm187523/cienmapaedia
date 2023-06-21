
//creamos una clase abstracta proque no queremos que hayan instancias de esta clase
//aqui definimos como tienen que ser los origenes de datos de donde vamos a obtener las peliculas
//independientemente del origen de datos que utilizemos
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDataSource{

  //metodo abstracto sin ser implementado que traera las peliculas que estan actualmente en cartelera
  //por defecto devuelve 1 como el numero de pagina ya que la aplicacion sera paginada
  //devuelve un Future de tipo List y el List de tipo de la entidad Movie creada en entities
  Future<List<Movie>> getNowPlaying({ int page = 1});

  //metodo para obtener las peliculas mas populares
  Future<List<Movie>> getPopular({ int page = 1});

  //metodo para obtener las peliculas que estaran proximamente
  Future<List<Movie>> getUpcoming({ int page = 1});

  //metodo para obtener las peliculas mejor calificadas
  Future<List<Movie>> getTopRated({ int page = 1});

  //metodo para obtener información de una pelicula en concreto
  Future<Movie> getMovieById(String id);
  
}