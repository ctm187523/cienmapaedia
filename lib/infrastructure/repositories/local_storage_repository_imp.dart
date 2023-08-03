
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImp extends LocalStorageReposotory {

  //propiedades
  //recibimos cualquier tipo de datasource 
  final LocalStorageDatasource datasource;

  //constructor
  LocalStorageRepositoryImp(this.datasource);
  

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    
    return datasource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    
    return datasource.toggleFavorite(movie);
  }

}