
//clase para leer los diferentes modelos de datasourcerecibido y crear la entidad
//de la clase Movie para que sea independeinte de la fuente de datos que usemos

import '../../domain/entities/movie.dart';
import '../models/moviedb/movie_moviedb.dart';

class MovieMapper {
  //creamos un metodo estatico de tipo Movie que es la entidad de domain/entities, 
  //recibe un argumento de tipo MovieMovieDb de models/moviedb
  static Movie movieDBToEntity(MovieMovieDb moviedb) => Movie(
      adult: moviedb.adult,
      //si el backdropPath(la imagen) no viene vacia la mostramos si no viene
      //ponemos una imagen que muestra que no se ha encontrado la imagen
      backdropPath: (moviedb.backdropPath != '' )
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(), //mapeamos todos los elementos y los convertimos a String(ya que vienen como enteros) luego con toList lo transformamos a un List
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      //hacemos como arriba con el backdropPath con esta imagen tambien
      posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
}
