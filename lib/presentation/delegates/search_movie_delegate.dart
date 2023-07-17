
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

//definimos el tipo de funcion que usaremos como parametro para hacer la peticion al provider
//que obtendremos por parametro al crear esta clase
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query );


//creamos una clase que hereda de SearchDelegate, como parametro ponemos que retorna una Movie es opcional
// esta clase SearchDelegate la usamos para manejar las busquedas en la aplicacion
//en este caso la busqueda de peliculas, tenemos que sobreescribir 4 metodos + 1 opcional
class SearchMovieDelegate extends SearchDelegate<Movie?> {

  //Propiedades
  final SearchMoviesCallback searchMovies;  //variable del tipo definido arriba

  //usamos un StreamController para controlar las peticiones http si no lo usamos
  //cada vez que insertamos una letra en el buscador o borramos letras del buscador 
  //hace una peticion y debemos controllar esto.
  //usamos broadcast porque podriamos escuchar el stream desde varios lugares cada vez que se redibuja una peticion
  //nos volvemos a subscribir al StreamController, multiples listeners
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast(); 

  //stream para controllar el spinner del buscador para que se visualize mientras realiza la busqueda
  StreamController<bool> isLoadingStream = StreamController.broadcast(); 

  //propiedad que usamos para cuando el usuario no inserta nada en un tiempo en el buscador emita la busqueda
  Timer? _debounceTimer; 
  
  //propiedad para obtener la lista inical de busquedas
  List<Movie> initalMovies;

  //constructor
  SearchMovieDelegate({
    required this.searchMovies,
    required this.initalMovies
  });

  //funcion encargada para emitir el nuevo resultado de las peliculas si pasado 500 milisegundos
  //no se escribe nada en el buscador creamos un debounce
  void _onQueryChanged( String query) {

    //print('Query string cambió');

    //usamos la variable del stream booleano para que notifique que esta cargando las peliculas es decir true
    isLoadingStream.add(true);

    //si la variable _debounceTimer creada arriba esta activa lo limpiamos con cancel
    if ( _debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    //si durante 500 milisegundos no se pulsa ninguna tecla se hace la peticion http
    _debounceTimer = Timer( const Duration( milliseconds: 500), () async{
      //print('Buscando peliculas');
      // if ( query.isEmpty ) {
      //   debouncedMovies.add([]); //si esta vacio retornamos un String vacio usamos la variable debounceMovies creada arriba
      //   return; //colocamos return para no hacer un else y poder salir
      // }

      //si no esta vacio le pasamos a la variable que viene por parametro en el constructor
      //searchMovies la query que es lo que introduce el usuario en el buscador
      final movies = await searchMovies( query );
      //insertamos las peliculas pedidas basandose en el buscador en la varialbe debounceMovies creada arriba
      debouncedMovies.add(movies); 
      initalMovies = movies; //colocamos las movies recibidas de la peticion en la variable initialMovies para que las reciba en el metodo buildResult ver video BuildResult
      isLoadingStream.add(false); //cambiamos el estado del stream para que no salga el spiner
    });
  }

  //funcion para limpiar los streams en memoria del debounceMovies creado arriba que es de tipo StreamController
  void clearStreams() {
    debouncedMovies.close();
  }

  //funcion utilizada en los metodos buildResults y buildSuggestions
  Widget buildResultsAndSuggestion() {

     return StreamBuilder(
      initialData: initalMovies,
      stream: debouncedMovies.stream,
      builder: ( context, snapshot){

        //obtenemos la data(listado de movies) o un string vacio
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index){
            //llamamos a la clase privada creada abajo y le pasamos las peliculas encontradas
            //le mandamos la referencia de la funcion al ser pulsada una de las peliculas que sera la funcion close
            //que ya viene con la clase que hemos heredado SearchDelegate y se ocupa de la navegacion
            //y tambien llamamos al metodo creado arriba clearStreams para borrar los streams en memoria
            return _MovieItem(
              movie: movies[index],
              onMovieSelected: (context,movie) {
                clearStreams();
                close(context, movie);
              }
            );
          },
        );
      }
    );
  }

  //metodos ha sobreescribir de la clase SearchDelegate

  //metodo no obligatorio para sobreescribir que cambia el Label del buscador que viene
  //por defecto
  @override
  String get searchFieldLabel => "Buscar Película";

  //regresa una lista de widgets, que son los que aparecen al hacer click al icono de la lupa
  //para realizar la busqueda
  @override
  List<Widget>? buildActions(BuildContext context) {

    //print(' query: $query'); //vemos en consola lo que se introduce en la caja de busqueda
    
    return [
      
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot){

          if(snapshot.data ?? false){ //si no viene la data ponemos que es false
            //ponemos un IconButton y usamos query de SearchDelegate para que al ser pulsado borre la caja de texto donde introducimos la busqueda
           return  SpinPerfect( 
              duration: const Duration(seconds: 20),
              spins: 10, //da 10 vueltas por segundo es spinner
              infinite: true,
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
          }
          return FadeIn( //usamos FadeIn del paquete de Fernando Herrera
            animate: query.isNotEmpty,  //solo se muestra si la caja de busqueda no esta vacia
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.clear)
              ),
            );
          }
        ),
    
    ];
  }


  //opcional, se usa para salir de la busqueda
  @override
  Widget? buildLeading(BuildContext context) {
   
   //para salir de la busqueda usamos el boton que llama a la funcion close de la clase SearchDelegate
   //el primer parametro es el contexto y es segundo seria el resultado de lo que queremos mostrar al cerrar
   //como no devolvemos nada ponemos null, el icono es una flecha de back que al ser pulsado no retorna nada
   //antes llamamos al metodo creado arriba clearStreams para borrar los streams en memoria
   return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null); 
      },
      icon: const Icon( Icons.arrow_back_ios_new_outlined)
    );
  }

  //regresamos un Widget con los resultados al pulsar enter en el buscador
  @override
  Widget buildResults(BuildContext context) {

   return buildResultsAndSuggestion();

  }

  //se dispara cuando hacemos la peticion, a cada letra que introducimos se dispara
  //tenemos que controlarlo para que se dispare cuando ya tenemos la pelicula a buscar
  @override
  Widget buildSuggestions(BuildContext context) {

    //llamamos a la funcion creada arriba cada vez que pulsamos/borramos una letra del buscador
    //le pasamos el query de de SearchDelegate que es lo que vamos escribiendo en el buscador
    _onQueryChanged(query); 
    
    //retornamos un FutureBuilder ya que usamos el parametro recibido al instanciar la clase
    //que es un Future, LO CAMBIAMOS Y EN SU LUGAR USAMOS UN STREAMBUILDER PARA USAR EL STREAMCONTROLLER
    //CREADO ARRIBA Y PODER CONTROLAR EL TEXTO INSERTADO EN EL BUSCADOR Y NO HAGA UNA PETICION CADA VEZ QUE
    //INSERTAMOS O BORRAMOS UNA LETRA EN EL BUSCADOR(VER METODO CREADO ARRIBA buildResultsAndSuggestion())
     return buildResultsAndSuggestion();
  }
}

class _MovieItem extends StatelessWidget {

  //propiedades
  final Movie movie;
  //funcion que recibimos por parametro para que se ejecute al seleccionar una 
  //de las peliculas de la busqueda, usamos Function de tipo generico
  final Function onMovieSelected;

  //constructor
  const _MovieItem(
    { 
    required this.movie, 
    required this.onMovieSelected
    }
  );

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size; //obtenemos las medidas del dispositivo

    //usamos el widget GestureDetector para que al pulsar una de las peliculas de la busqueda
    //nos dirijamos a la pelicula
    return GestureDetector(
      //usamos el metodo onTap de GestureDetector para ver una pelicula seleccionada del listado encontrado basado en el buscador
      //usamos la propiedad recibida por parametro onMovieSelected que es una funcion
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
    
            //image
            SizedBox(
              width: size.width * 0.2, //usamos la variable size obtenida arriba y ocupamos un 20 por ciento
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  //colocamos un loadingBuilder opcional
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                  ),
              ),
            ),
    
            const SizedBox(width: 10),
    
            //Descripcion de la pelicula
            SizedBox(
              width: size.width * 0.7, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
    
                  //para la descripcion si el texto es mayor que 100 lo cortamos en 100
                  //y le ponemos los 3 puntos suspensivos
                  ( movie.overview.length > 100)
                    ?  Text('${movie.overview.substring(0,100)}...')
                    :  Text( movie.overview),
    
                  Row(
                    children: [
                      Icon( Icons.star_half_rounded, color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text( 
                       //usamos la clase creada HumanFormats en config/helpers/human_formats
                       HumanFormats.number( movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  )
                  
                ],
              ), //usamos el 70 por ciento del ancho del dispositivo
            ),
          ],
        ),
      ),
    );
  }
}