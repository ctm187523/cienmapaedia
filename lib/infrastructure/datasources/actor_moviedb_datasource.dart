
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDataSource {

  //creamos una instancia de Dio para la peticion http como hicimos en moviedb_datasource.dart
  final dio = Dio(

    BaseOptions(

      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key':Enviroment.theMovieDbKey,
        'languaje': 'es-ES'
      }
    )
  );
  
  //peticion http y mapeo del Json a listado de objetos Actor
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{

    final  response = (await dio.get('/movie/$movieId/credits'));

    final castResponse = CreditsResponse.fromJson( response.data );

    final List<Actor> actors = castResponse.cast.map(
      (cast) => ActorMapper.castToEntity(cast),
    ).toList();

    return actors;

  }
}