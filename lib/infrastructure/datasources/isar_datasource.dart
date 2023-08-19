
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

//classe para acceder a las peliculas almacenadas en el Storage en este caso usamos Isar
class IsarDatasource extends LocalStorageDatasource{

  //propiedades
  //ponemos late porque puede que la base de datos no este aun lista
  late Future<Isar> db;

  //constructor
  IsarDatasource() {
    db = openDB(); //llamamos al metodo de abajo para conectar con la base de datos local del dispositivo(Isar)
  }

  Future<Isar> openDB() async {

    //instalamos el paquete --> flutter pub add path_provider
    //para localizar el PATH donde almacenaremos la base de datos
    final dir = await getApplicationDocumentsDirectory();

    //comprobamos si tenemos alguna instancia, en caso contrario creamos la instancia
    //de la base de datos
    if ( Isar.instanceNames.isEmpty) {
      return await Isar.open( 
        [ MovieSchema ], //usamos el Schema creado cuando instalamos Isar en domain/entities/movie.g.dart
        inspector: true, 
        directory: dir.path,
      );
    }

    //si ya tenemos una instancia, regresamos la instancia
    return Future.value(Isar.getInstance());
  }
   
  
  //metodo para comprobar si la pelicula que queremos poner en favoritos ya existe
  @override
  Future<bool> isMovieFavorite(int movieId) async{
    
    final isar = await db; //esperamos que la base de datos este lista

    //creamos las querys, ponemos Movie? porque podria no venir
    final Movie? isFavoriteMovie = await isar.movies //usamos el esquema movies con isar.movies
      .filter() //hacemos un filtro en la base de datos
      .idEqualTo(movieId) //comprobamos si algun elemento de la base de datos coincide con el id pasado por parametro
      .findFirst(); //queremos el primer resultado encontrado
   
      //creamos un valor booleano, si isFavorite es null no se ha encontrado ninguna coincidencia
      //manda true en caso contrario false
      return isFavoriteMovie != null;
  }

  //metodo que devuelve el listado de movies que estan en favoritos
  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async{
    
    final isar = await db; //esperamos que la base de datos este lista
    return isar.movies.where()
      .offset(offset) //usamos el argumento del metodo offset que indica el numero de elementos a mostrar
      .limit(limit) //usamos el arguemto del metodo limit servira para la paginacion, de 10 en 10 etc
      .findAll(); 

  }

  //Metodo para borrar una pelicula de la base de datos si esta existe o insertarla si no existe
  //Realizamos una transaccion(grabar,eliminar,actualizar) con la base datos
  @override
  Future<void> toggleFavorite(Movie movie) async{
    
    final isar = await db; //esperamos que la base de datos este lista

    //comprobamos si la pelicula esta en la base de datos
    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();

      //si la pelicula existe la borramos
      if ( favoriteMovie != null) {
        //creamos una transacciomn con isar.writeTxnSync
        //usamos el metodo deleteSync y como argumento la variable favoriteMovie
        //creada justa arriba y usamos el Id de la indexacion creada de la base da datos ver 
        //domain/entities/movie.dart el campo --> Id? isarId; 
        isar.writeTxnSync(() => isar.movies.deleteSync( favoriteMovie.isarId!));
        return;
      }

      //en caso contrario la insertamos
      //creamos una transacciomn con isar.writeTxnSync
      isar.writeTxnSync(() => isar.movies.putSync(movie));
  }

}