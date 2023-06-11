
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends StatelessWidget {

  //name para poder usarlo en go_router
  static const name = 'home-screen';

  //constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      //usamos el widget creado en widgets/shared
      bottomNavigationBar: CustomButtomNavigation(),
    );
  }
}

//clase donde usamos ConsumerStatefulWidget para obtener el estado de los providers de Riverpod
//y ademas al ser StatefulWidget podemos tener un estado inicial con initState
class _HomeView extends ConsumerStatefulWidget {
  
  //constructor
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState(); //instancia de la clase de abajo
}

//la clase ponemos que herede de ConsumerSate tenemos acceso al ref(al estado de Riverpod)
class _HomeViewState extends ConsumerState<_HomeView> {

  //estado inicial
  @override
  void initState() {
    super.initState();
    //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider 
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
  }
  @override
  Widget build(BuildContext context) {

    //llamamos al provider  para obtener el listado de peliculas, si no ponemos el notifier
    //como arriba en el initState nos devuelve la data el listado de peliculas el segundo argumento de nowPlayingMoviesProvider
    //como usamos ref.watch obtenemos el valor del estado 
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    final slideShowMovies = ref.watch(moviesSlideshowProvider); //usamos el provider que retorna las 6 primeras peliculas para el slideShow(carrusel)
    
    return Column(
      children: [
        //usamos el widget CustomAppBar creado por mi en widgets/shared
        const CustomAppbar(),

        //usamos la clase creada en widgets/movies para crear un carrusel,
        //le pasamos las peliculas obtenidas arriba con el provider moviesSlideshowProvider
        MoviesSlideshow(movies: slideShowMovies),
        
        //usamos el widget creado en presentation/widgets/movies, para mostrar las peliculas
        //le pasamos la variable que contiene el provider nowPlayingMoviesProvider creado arriba
        MovieHorizontalListView(
          movies: nowPlayingMovies,
          title: 'En cines',
          subTitle: 'Lunes 20' ,
        )
      ],
    );
  }
}