

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

//instalamos y importamos dio(similar a axios) para hacer llamadas http --> flutter pub add dio
import 'package:dio/dio.dart';

//clase especializada para obtrener los datos de moviedb, si quisieramos usar otra fuente de datos
//hariamos otra clase para acceder a esos datos, hereda de la clase abstacta creada en 
//domain/datasources/movies_datasource debemos de implementar(override) sus metodos, lo hacemos asyncrono el metodo
class MoviedbDatasource extends MoviesDataSource {

  //insatnciamos la clase importada arriba Dio para hacer llamadas http, usamos baseUrl para poner
  //la base a la llamada http que nunca va a cambiar
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    //mandamos en los queryParameteres el api_key sacado de la clase envieronment creada en constants/environment y tiene acceso a las varaibles de entorno
    //y como segundo parametro el lenguaje que queremos utilizar en la aplicacion
    queryParameters: {
      'api_key':Enviroment.theMovieDbKey,
      'languaje': 'es-ES'
    }
  ));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{
   
   //ponemos con get el path para recibir las peliculas
   final response = await dio.get('/movie/now_playing');
   //creamos un List de tipo de la entidad Movie de entities/movie
   final List<Movie> movies = [];
   
   return [];
  }

}