

import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

//clase para implementar el repositorio, llama al datasource
//hereda de MoviesRepository creado en cinemapedia/domain/repositories/
class MovieRepositoryImpl extends MoviesRepository {

  //propiedades
  final MoviesDataSource datasource;

  //constructor
  MovieRepositoryImpl(this.datasource); //creamos una propiedad de tipo MoviesDataSoruce
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {

    //usamos la propiedad datasource creada arriba
    return datasource.getNowPlaying(page : page);
  }

}