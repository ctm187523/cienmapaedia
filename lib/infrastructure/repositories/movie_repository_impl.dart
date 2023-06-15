

import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

//clase para implementar el repositorio, llama al datasource
//hereda de MoviesRepository creado en cinemapedia/domain/repositories/
class MovieRepositoryImpl extends MoviesRepository {

  //propiedades 
  //objeto MoviesDataSource el padre, le pasamos el padre porque de esta manera podemos pasarle diferentes datasources 
  //en caso de que cambiemos la fuente de datos ya que todas las fuentes de datos(datasources) heredan de MoviesDataSource
  final MoviesDataSource datasource; 

  //constructor
  MovieRepositoryImpl(this.datasource); //creamos una propiedad de tipo MoviesDataSoruce
  
  //implementamos los metodos obligatorios que heredan de la clase abstracta
  //MoviesReositories
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {

    //usamos la propiedad datasource creada arriba y el metodo correspondiente
    return datasource.getNowPlaying(page : page);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
   
   //usamos la propiedad datasource creada arriba y el metodo correspondiente
   return datasource.getPopular(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    
    //usamos la propiedad datasource creada arriba y el metodo correspondiente
   return datasource.getTopRated(page: page);

  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    
    //usamos la propiedad datasource creada arriba y el metodo correspondiente
    return datasource.getUpcoming(page: page);

  }

}