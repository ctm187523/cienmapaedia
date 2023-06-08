
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

//provider que nos informara de las peliculas que estan en el momento actual en el cine
//usamos StateNotifierProvider que es un proveedor de un estado que notifica su cambio
//como parametros genericos tenemos primeramente la clase que lo controla creada abajo
// y el listado de objetos Movie(entidad) que es el state(la data)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref)  {

  //creamos una referencia al repositorio creado en providers/movies/movies_repository_provider
  //para obtener su metodo getNowPlaying de la clase MoviedbDatasource donde hacemos la peticion
  //a la API 
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;

  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  ); //devolvemos una instancia de la clase creada abajo
});

//typedef son funciones definidas por mi, la usamos para cargar las siguientes peliculas
//usado en la clase MoviesNotifier creada abajo, definimos el tipo de funcion que esperamos recibir
//que sera la funcion de MovieRepositoryImpl --> Future<List<Movie>> getNowPlaying({int page = 1})
//ya que en la clase movieRepositoryProvider nos provee de esa clase MovieRepositoryImp con su funcion correspondiente
typedef MovieCallback = Future<List<Movie>> Function({ int page });

//clase que proporciona el listado de peliculas que estaran en el cine
//usamos el provider StateNotifier
class MoviesNotifier extends StateNotifier<List<Movie>> {

  //propiedades
  int currentPage = 0; //pagina actual
  //llamamos a la funcion creada arriba(typedef) MovieCallBack que nos define el tipo de funcion que
  //vamos a recibir por parametros del metodo de arriba nowPlayingMoviesProvider que a su vez la recibe de movieRepositoryProvider
  MovieCallback fetchMoreMovies; 
  
  //constructor
  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]); //arreglo de inicio vacio

  //metodo para modificar el state, el listado de Movie
  Future<void> loadNextPage() async {
    currentPage++; //aumentamos en 1 la pagina actual

    final List<Movie> movies = await fetchMoreMovies( page : currentPage);
    //regresamos un nuevo estado y un nuevo estado con las movies que vienen de la peticion de arriba
    //cuando el estado cambia notifica
    state = [...state, ...movies]; 
  }

}

