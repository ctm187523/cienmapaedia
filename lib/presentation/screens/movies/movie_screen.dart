
//mostramos una pelicula en particular
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';


//la clase hereda de ConsuemerStatefulWidget para tener in initState para poder saber
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

//creamos una clase para manejar los slivers del CustomScrollView creado arriba
class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;
  
  
  //constructor
  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    //obtenemos las dimensiones del dispositivo
    final size = MediaQuery.of( context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      //usamos el 70 % de la pantalla con la variable size hemos hallado arriba las medidas del dispositivo
      expandedHeight: size.height * 0.7, 
      foregroundColor: Colors.white,
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

            //creamos un gradiente
            const  SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    //hacemos un gradiente vertical comienza en el centro de arriba y termina en el centro de abajo
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    //ponemos los stops qu empieze en el 70 por ciento y acabe en el 100 por cien
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87
                    ]
                  )
                )),
            ),
           
            //creamos otro gradiente para que se vea bien la flecha de la izquierda
            //para ir hacia atras
            const  SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    //hacemos un gradiente horizontal para empezar desde la izquierda
                    begin: Alignment.topLeft,
                    //ponemos los stops qu empieze en el 0 de la izquierda y finalize en el 30 porciento 
                    stops: [0.0, 0.3],
                    colors: [
                      Colors.black87,
                      Colors.transparent
                    ]
                  )
                )),
            )
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