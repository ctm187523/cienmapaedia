

import 'package:cinemapedia/domain/entities/movie.dart';

//clase abstract para no ser instanciada, los repositorios son los que llamaran
//los datasources, porque el repositorio es el que permitira cambiar el datasource
//cambiar otro servicio el origen de datos
abstract class MovieRepository{

  //metodo abstracto sin ser implementado que traera las peliculas que estan actualmente en cartelera
  //por defecto devuelve 1 como el numero de pagina ya que la aplicacion sera paginada
  //devuelve un Future de tipo List y el List de tipo de la entidad Movie creada en entities
  Future<List<Movie>> getNowPlaying({ int page = 1});
  
}