
import 'package:flutter_dotenv/flutter_dotenv.dart';

//creamos esta clase para tener as varaibles de entorno estaticas
//para que sean mas faciles de manejar importamos dotenv para obtener las 
//variables de entorno
class Enviroment {
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'no hay api key';
}