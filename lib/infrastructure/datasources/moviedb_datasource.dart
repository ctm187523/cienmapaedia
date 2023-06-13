

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';

//instalamos y importamos dio(similar a axios) para hacer llamadas http --> flutter pub add dio
import 'package:dio/dio.dart';

//clase especializada para obtener los datos de moviedb, si quisieramos usar otra fuente de datos
//hariamos otra clase para acceder a esos datos, hereda de la clase abstacta creada en 
//domain/datasources/movies_datasource debemos de implementar(override) sus metodos, lo hacemos asyncrono el metodo
class MoviedbDatasource extends MoviesDataSource {

  //instanciamos la clase importada arriba Dio para hacer llamadas http, usamos baseUrl para poner
  //la base a la llamada http que nunca va a cambiar
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    //mandamos en los queryParameteres el api_key sacado de la clase envieronment creada en constants/environment y tiene acceso a las varaibles de entorno
    //y como segundo parametro el lenguaje que queremos utilizar en la aplicacion
    queryParameters: {
      'api_key':Enviroment.theMovieDbKey,
      'languaje': 'es-ES'
    }
    )
  );
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{
   
   //ponemos con get el path para recibir las peliculas
   final response = await dio.get('/movie/now_playing', 
    queryParameters: {
      'page': page //mandamos el numero de pagina que queremos ver
    }
   );

  //creamos una variable donde almacenamos la respuesta  a la url, pero antes procesamos la respuesta
  //usando la clase MovieDbResponse de infrastructure/models/moviedb/ donde transformamos el JSON recibido
  // a una instancia de la clase MovieDbResponse
   final movieDBResponse = MovieDbResponse.fromJson(response.data);

   //creamos un List de tipo de la entidad Movie de entities/movie, le pasamos la respuesta de arriba
   //transformada a un objeto MovieDbResponse, necesitamos obtener un objeto Movie(la entidad),
   //para ello usamos del objeto MovieDbResponse la propiedad result que contiene las movies
   //lo recorremos con un map todas las movies usando la clase MovieMapper de infrastructure/mappers y su metodo movieDBToEntity
   //para transformar a una entidad(objeto Movie) las peliculas recibidas de tipo MovieMovieDB, finalmente con toList creamos la lista
   final List<Movie> movies = movieDBResponse.results
   .where((moviedb) => moviedb.posterPath != 'no-poster') //hacemos un filtro con where por si no viene el poster, en ese caso si recibimos no-poster implementado en MovieMapper no inserte la pelicula en la lista
   .map(
    (moviedb) => MovieMapper.movieDBToEntity(moviedb),
    ).toList();
   
   return movies;
  }

}