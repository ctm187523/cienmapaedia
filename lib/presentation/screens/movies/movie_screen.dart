
//mostramos una pelicula en particular

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import '../../../domain/entities/movie.dart';


//la clase hereda de ConsumerStatefulWidget para tener in initState para poder saber
//cuando estoy cargando y obtener informacions de los providers
class MovieScreen extends  ConsumerStatefulWidget{

  static const name = 'movie-screen';

  //propiedades
  final String movieId;
  
  //constructor
  const MovieScreen({
    super.key,
     required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    //hacemos la peticion http, usamos read ya que esta dentro de un metodo
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    //usamos el provider moveInfoProvider y de el obtenemos la movie que tenga el id de la peticion
    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];
    
    //comprobamos que no sea nulo
    if( movie == null ){
      return const Scaffold(body: Center(child: CircularProgressIndicator( strokeWidth: 2)));
    }


    return Scaffold(
    //usamos CustomScrollView para usar el scroll de la descripcion de la pelicula

     body: CustomScrollView(
      physics: const ClampingScrollPhysics(), 
      slivers: [
        _CustomSliverAppBar(movie: movie),
        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) => _MovieDetails(movie: movie),
          childCount: 1 //solo ponemos un elemento
        ))
      ],//evita el efecto rebote de ios
     ),
    );
  }
}

//creamos un provider con una variable para manejar un booleano para que 
//el corazon de favoritos se muestre en rojo o no, usamos el provider FutureProvider
//usamos un FutureProvider que sirve si tenemos una tarea asincrona
//usamos .family para poder usar parametros en este caso en int movieId
//emite un booleano y como argumento pide un entero
//ponemos autoDispose para que refresque la informacion
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){

  //usamos el repository localStorageRepositoryProvider creado en presentation/providers/stroage
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  //devolvemos el estado de la pelicula si esta o no en favoritos
  return localStorageRepository.isMovieFavorite(movieId);
});

//creamos una clase para manejar los slivers del CustomScrollView creado arriba
class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;
  
  
  //constructor
  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //tomamos la instancia del Provider creado arriba isFavoriteProvider para manejar
    //el icono del corazon de favoritos para mostrarlo en rojo o no dependiendo si la 
    //pelicula seleccionada esta o no en favoritos, mandamos un entero del id de la pelicula
    //como argumento y recibimos un valor booleano
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    //obtenemos las dimensiones del dispositivo
    final size = MediaQuery.of( context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      //usamos el 70 % de la pantalla con la variable size hemos hallado arriba las medidas del dispositivo
      expandedHeight: size.height * 0.7, 
      foregroundColor: Colors.white,
      actions: [
        //colocamos el boton de favoritos para que al ser seleccionado se registre en la pantalla
        //de favoritos
        IconButton(onPressed: () async{

          //usamos el Provider localStorageRepositoryProvider y su meto toggleFavorite
          //para que al pulsar el corazon de favoritos añada y elimine la pelicula de favoritos
          //ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
          //COMENTAMOS LO DE ARRIBA PORQUE EN SU LUGAR USAMOS LA SIGUIENTE INSTRUCCION
          //USAMOS EL PROVIDER favoriteMovieProvider
          await ref.read( favoriteMovieProvider.notifier).toogleFavorite(movie);

          //volvemos a hacer la peticion para actualizar el estado del booleano y poner el corazon o no en rojo
          //con invalidate, invalida el estado del provider y lo regresa a su estado original
          ref.invalidate(isFavoriteProvider(movie.id));
        },
        icon: isFavoriteFuture.when( //usamos la variable isFavoriteFuture creada arriba
          //la data es el valor booleano recibido(isFavorite es el nombre que le damos al argumento
          //podemos usar otro), si es true mostramos el corazon rojo en caso contrario sin color)
          data: (isFavorite) => isFavorite
           ? const Icon( Icons.favorite_rounded, color: Colors.red,) 
           : const Icon( Icons.favorite_border)
          , 
          error: ( _, __) => throw UnimplementedError(), //mostramos los erres si el caso
          loading: () => const CircularProgressIndicator(strokeWidth: 2,))
      ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        //Stack permite poner widgets encima de otros
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network( //colocamos la imagen
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: ( context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
          
           //creamos un gradiente usando la clase privada creada abajo _Customgradient
           //este gradiente es para el corazon de favoritos
           const _CustomGradient( 
              //hacemos un gradiente vertical comienza arriba a la derecha y 
              //termina abajo a la izquierda
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft, 
               //ponemos los stops que empieze en el 0 por ciento y acabe en el 20 por ciento
              stops: [0.0, 0.2], 
              colors: [  Colors.black54, Colors.transparent]
            ),

          //creamos otro gradiente usando la clase privada creada abajo _Customgradient
          //este gradiente es para la imagen central
           const _CustomGradient( 
              //hacemos un gradiente vertical comienza arriba en el centro y 
              //termina abajo en el centro
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
               //ponemos los stops que empieze en el 70 por ciento y acabe en el 100 por ciento
              stops: [0.8, 1.0], 
              colors: [ Colors.transparent, Colors.black54]
            ),


          //creamos otro gradiente para que se vea bien la flecha de la izquierda
          //para ir hacia atras
           const _CustomGradient( 
              //hacemos un gradiente vertical comienza arriba en la izquierda
              //no usamos el end lo ponemos opcional
              begin: Alignment.topLeft, 
               //ponemos los stops que empieze en el 0 por ciento y acabe en el 30 por ciento
              stops: [0.0, 0.3], 
              colors: [ Colors.black87, Colors.transparent]
            ),

          ],
        ),
       ),
    );
  }
}

//clase para los detalles de las peliculas
class _MovieDetails extends StatelessWidget {

  final Movie movie;

  //constructor
  const _MovieDetails({

    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    //obtenemos las medidas del dispositivo
    final size = MediaQuery.of(context).size; 
    final textStyle = Theme.of(context).textTheme;


    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: size.width * 0.3
              ),
            ),

            const SizedBox( width: 10 ),

            //Descripcion de la pelicula
            SizedBox(
              width: (size.width -40) * 0.7,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( movie.title, style:  textStyle.titleLarge),
                  Text( movie.overview),

                ],
              ),
            )
          ],

        ),
        
        ),

        //Generos de la película
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only( right: 10),
                //especie de botones circulares para contener el texto
                child: Chip(
                  label: Text( gender),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
          
          ),
        
        //mostramos la lista de actores usando la clase privada creada abajo
        _ActorsByMovie(movieId: movie.id.toString()),
        

        const SizedBox( height: 50) 
      ],
    );
  }
}

//clase para obtener informacion de los actores
class _ActorsByMovie extends ConsumerWidget {
  

  //propiedades
  final String movieId;
  
  //constructor
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    //usamos el provider que nos da la informacion de los actores
    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if( actorsByMovie[movieId] == null ){
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    //buscamos los actores de una pelicula en concreto usando el parametro movieId
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index){
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ), 
                  ),
                ),
                const SizedBox( height: 5),
                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '',
                 maxLines: 2,
                 style: const TextStyle( fontWeight:  FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),
              ]),
          );
        }
      ),
    );
  }
}

//clase privada que realiza gradientes usada en la clase _CustomSliverAppBar creada arriba
class _CustomGradient extends StatelessWidget {

  //propiedades 
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;
  

  const _CustomGradient({
    
    this.begin = Alignment.centerLeft, //valor por defecto por si no viene en los arguementos
    this.end = Alignment.centerRight, //valor por defecto por si no viene en los arguementos
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //hacemos un gradiente vertical comienza en el centro de arriba y termina en el centro de abajo
              begin: begin,
              end: end,
              //ponemos los stops qu empieze en el 70 por ciento y acabe en el 100 por cien
              stops: stops,
              colors: colors
            )
          )),
      );
  }
}

