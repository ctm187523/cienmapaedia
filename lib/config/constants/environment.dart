
import 'package:flutter_dotenv/flutter_dotenv.dart';

//creamos esta clase para tener las varaibles de entorno estaticas
//para que sean mas faciles de manejar importamos dotenv en la main.dart para obtener las 
//variables de entorno
class Enviroment {
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'no hay api key';
}