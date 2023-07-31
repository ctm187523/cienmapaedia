
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

//heredamos de ConsumerWidget para usar los providers
class CustomAppbar extends ConsumerWidget {

  //constructor
  const CustomAppbar({super.key});

  //en el build gracias a que hereda de ConsumerWidget tenemos acceso al ref para usar el provider
  @override
  Widget build(BuildContext context,WidgetRef ref) {

  final colors = Theme.of(context).colorScheme;
  final titleStyle = Theme.of(context).textTheme.titleMedium;

  //usamos SafeArea que es un widget que inserta a su hijo con suficiente relleno para evitar intrusiones por parte del sistema operativo.
  //Por ejemplo, esto sangrará al hijo lo suficiente como para evitar la barra de estado en la parte superior de la pantalla.
  //También sangrará al hijo con la cantidad necesaria para evitar The Notch en el iPhone X u otras características físicas creativas similares de la pantalla.
    return SafeArea(
      bottom: false, //quitamos el padding que deja en el bottom(parte inferior)
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10),
        child: SizedBox(
          width: double.infinity, //le damos todo el ancho que podamos con infinity
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary,),
              const SizedBox( width: 5 ),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(), //con Spacer toma todo el espacio, es como un flex y manda al IconButton de abajo al final de la fila
              IconButton(onPressed: () {

                //usamos el ref del build gracias a heredar de ConsumerWidget para acceder a los providers
                 final searchedMovies = ref.read( searchMoviesProvider );

                 //usamos el ref para traer el provider de Riverpood searchQueryProvider
                 //donde se almacena la ultima peticion realizada
                 final searchQuery = ref.read(searchQueryProvider);

                //usamos la funcion de Flutter showSearch que se encarga de manejar las busquedas, el delegate es el encargado
                //de las busquedas, es de tipo SearchDelegate<Dynamic> es Dynamic porqwe puede devolver cualquier cosa la pelicula
                //entera el id, etc
                //usamos el delegate creado en presentations/delegate/SearchMovieDelegate que devuelve una clase que hereda de SearchDelegate
                showSearch<Movie?>(
                  query: searchQuery, //con query mantenemos la busqueda anterior le pasamos el provider creado arriba
                  context: context,
                  delegate: SearchMovieDelegate(
                    initalMovies: searchedMovies,
                    //usamos la referencia  del provider searchMoviesProvider, no lo llamamos
                    //se lo pasamos a la clase search_movie_delegate
                    searchMovies: ref.read( searchMoviesProvider.notifier).searchMoviesByquery
                  )
                  ).then((movie ) { //usamos el then como si fuera una promesa recibimos la movie
                    //seleccionada de la lista facilitada basada en lo introducido en el buscador
                    //si viene la pelicula no es null navegamos a la ruta donde visualizamos
                    //la pelicula por id creada en presentation/screens/movies/movie_screen
                    //referenciada en GoRoute en config/router
                    if( movie == null ) return;
                    context.push('/home/0/movie/${movie.id}');
                  });
                  //print(movie?.title);
              }, 
              icon: const Icon(Icons.search))
            ],
          ),
        ),
      )
    );
  }
}