
//mostramos una pelicula en particular
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

    //hacemos la peticion http, usamos red ya que esta dentro de un metodo
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
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
      appBar: AppBar(
        title: Text('MovieId: ${widget.movieId}'),
      ),
    );
  }
}