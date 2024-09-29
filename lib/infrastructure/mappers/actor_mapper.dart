
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';


//clase que mapea un objeto de tipo Cast obtenido en cinemapedia/infrastructure/models/moviedb/credits_response.dart
//para transformarlo a la entidad de tipo Actor
class ActorMapper {

  static Actor castToEntity( Cast cast ) => 
    Actor(
      id: cast.id, 
      name: cast.name, 
      //imagen condicion en caso de que no venga
      profilePath: cast.profilePath != null 
       ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }'
       //: 'https://1fid.com/wp-content/uploads/2022/06/no-profile-picture-6-1024x1024.jpg', 
       : 'https://img.freepik.com/vector-gratis/diseno-plano-letrero-foto_23-2149299706.jpg?ga=GA1.1.96884744.1727638030&semt=ais_hybrid',
      character: cast.character
    );
}