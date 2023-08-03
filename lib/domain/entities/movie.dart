
//esta clase sera la entidad como queremos tratar la Movie independientemente
//del origen de datos que utilizemos para obtener los datos

import 'package:isar/isar.dart';

//archivo que se creara de forma automatica para la base de datos Isar, crea esquemas, paginacion, etc
//al escribir la instruccion de abajo y ejecutar --> flutter pub run build_runner build ver --> https://isar.dev/es/tutorials/quickstart.html#_3-ejecuta-el-generador-de-codigo
part 'movie.g.dart'; 

//usamos el decorador para usar la base de datos Isar
//previamente instalada con dos instrucciones:
//flutter pub add isar isar_flutter_libs
//flutter pub add -d isar_generator build_runner
//ver documentacion de Isar en --> https://isar.dev/es/
@collection 
class Movie {

  //usamos el id para identificar la entidad en la base de datos Isar
  //lo ponemos opcional para que Isar asigne de forma autoincrementada por defecto
  //el Id 1,2,3 etc.
  Id? isarId; 
  
  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount
  });
}