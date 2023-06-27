

//instalo Riverpod para manejar el estado con -> flutter pub add flutter_riverpod
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//creamos un provider de solo lectura es inmutable proporciona a los demas providers
//la informacion 
final actorRepositoryProvider = Provider((ref) {

  //mandamos la implementacion del repositorio creada en infrastructure/datasources
  //si al dia de mañana queremos cambiar el datasource solo tendriamos que cambiar
  //ActorMovieDatasource por la fuente de datos que queramos utilizar
  return ActorRepositoryImpl( ActorMovieDbDatasource( ));
});