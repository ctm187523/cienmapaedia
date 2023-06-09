
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
  //a la API no lo llamamos pasamos la referencia a la funcion no usamos los parentesis como en
  //la clase home_screen para llamar a la funcion cuando hacemos la peticion al provider
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying;

  return MoviesNotifier( 
    fetchMoreMovies: fetchMoreMovies
  ); //devolvemos una instancia de la clase creada abajo
});

//provider que nos informara de las peliculas mas populares, es el mismo codigo de arriba
//excepto que en el la variable fecthMoreMovies llamamamos al metodo getPopular, llamamos
//de igual manera a la clase  MoviesNotifier creada abajo
//usamos StateNotifierProvider que es un proveedor de un estado que notifica su cambio
//como parametros genericos tenemos primeramente la clase que lo controla creada abajo
// y el listado de objetos Movie(entidad) que es el state(la data)
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref)  {

  //creamos una referencia al repositorio creado en providers/movies/movies_repository_provider
  //para obtener su metodo getPopular de la clase MoviedbDatasource donde hacemos la peticion
  //a la API, no lo llamamos pasamos la referencia a la funcion no usamos los parentesis como en
  //la clase home_screen para llamar a la funcion cuando hacemos la peticion al provider
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;

  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  ); //devolvemos una instancia de la clase creada abajo
});

//hacemos una llamada a los providers correspondientes como las anteriores para las peliculas que estaran proximamente
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

  final fetchMoreMovies = ref.watch( movieRepositoryProvider).getUpcoming;

  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});



//hacemos una llamada a los providers correspondientes como las anteriores para las peliculas mejor calificadas

  final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {

    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

    return MoviesNotifier(
      fetchMoreMovies: fetchMoreMovies
    );
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
  bool isLoading = false; //booleano para comprobar si estan cargando peliculas y de esta manera no se hagan llamadas simultaneas
  //llamamos a la funcion creada arriba(typedef) MovieCallBack que nos define el tipo de funcion que
  //vamos a recibir por parametros del metodo de arriba nowPlayingMoviesProvider que a su vez la recibe de movieRepositoryProvider
  MovieCallback fetchMoreMovies; 
  
  //constructor
  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]); //arreglo de inicio vacio

  //metodo para modificar el state, el listado de Movie
  Future<void> loadNextPage() async {
    if( isLoading) return; 

    isLoading = true; //lo ponemos en true para indicar que se estan cargando peliculas y no haga llamadas mientras tanto

    currentPage++; //aumentamos en 1 la pagina actual

    final List<Movie> movies = await fetchMoreMovies( page : currentPage);
    //regresamos un nuevo estado y un nuevo estado con las movies que vienen de la peticion de arriba
    //cuando el estado cambia notifica
    state = [...state, ...movies]; 
    await Future.delayed(const Duration(microseconds: 3000)); //  le damos un tiempo antes de cambiar la varialbe de abajo es opcional
    isLoading = false; //una vez actualizado el estado lo ponemos en false para que se puedan cargar mas peliculas de otras paginas
  }

}

