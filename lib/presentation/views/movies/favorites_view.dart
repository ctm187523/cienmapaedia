
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class FavoritesView extends ConsumerStatefulWidget {

  //constructor
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState(); 
    
  }


class FavoritesViewState extends ConsumerState<FavoritesView> {

  //propiedades
  bool isLastPage = false;
  bool isLoading = false;
  
  @override
  void initState() {
   
   super.initState();
   loadNextPage(); //llamamos al metodo creado abajo para hacer la peticion al provider
  }

  void loadNextPage() async {

    if ( isLoading || isLastPage ) return;
    isLoading = true;

    final movies = await ref.read(favoriteMovieProvider.notifier).loadNextPage();
    isLoading = false;

    if ( movies.isEmpty) {
      isLastPage = true;
    }

  }
  @override
  Widget build(BuildContext context) {

    //el state de este provider es una Map<int,Movie> nosotros queremos acceder a las movies
    //por lo tanto con values llamamos a los valores(las movies) y con toList() lo convertimos en una lista
    final List<Movie> favoritesMovies = ref.watch(favoriteMovieProvider).values.toList();
   //double height = MediaQuery.of(context).size.height;

   //codigo para mostrar un mensaje en la pantalla de favoritos si la lista esta vacia
   if ( favoritesMovies.isEmpty ){

      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon( Icons.favorite_outline_sharp, size: 60, color: colors.primary,),
            Text('Ohhh no!!', style: TextStyle (fontSize: 30, color: colors.primary),),
            const Text('No tienes películas favoritas', style: TextStyle( fontSize: 20, color: Colors.black45),),

            const SizedBox( height: 20,),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'), 
              child: const Text('Empieza a buscar'))
          ]),
      );
   }

    return Scaffold(
      //usamos el widget MovieMasonry creado en presentation/widgets/movies
      // y le pasamos las movies de favoritos obtenidas arriba mediante el provider
      //y el metodo loadNextPage creado arriba como argumento
      body:  MovieMasonry(
          loadNextpage: loadNextPage,
          movies: favoritesMovies,
        ),
    );  
  }
  
}