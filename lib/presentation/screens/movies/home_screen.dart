
import 'package:cinemapedia/presentation/providers/providers.dart';
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

  //estado inicial cargamos la primera pagina
  @override
  void initState() {
    super.initState();
    //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider 
    //para al iniciar la aplicacion se carguen las peliculas
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();

    //llamamos al provider para obtener las peliculas populares
     ref.read( popularMoviesProvider.notifier ).loadNextPage();

    //llamamos al provider para obtener las peliculas que vendran proximamente
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();

    //llamamos al provider para obtener las peliculas mejor calificadas
    ref.read( topRatedMoviesProvider.notifier).loadNextPage();
  }
  @override
  Widget build(BuildContext context) {

    //llamamos al provider initialLoadingProvaider que devuelve un booleano
    //para saber si esta cargada la data y si no esta mostrar un loading
    final intialloading = ref.watch(intialLoadingProvider);

    //si no esta cargada la data usamos el widget creado en presentation/widgets/shared
    //para mostrar el loading
    if(intialloading) return const FullScreenLoader();

    //en caso contrario mostramos las peliculas

    //llamamos al provider  para obtener el listado de peliculas, si no ponemos el notifier
    //como arriba en el initState nos devuelve la data el listado de peliculas el segundo argumento de nowPlayingMoviesProvider
    //como usamos ref.watch obtenemos el valor del estado 
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    //usamos el provider que retorna las 6 primeras peliculas para el slideShow(carrusel)
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    //obtenemos las peliculas mas populares
    final popularMovies = ref.watch( popularMoviesProvider );

    //obtenemos las peliculas que vendran proximamente
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

    //obtenemos las peliculas mejor calificadas
    final topRateMovies = ref.watch( topRatedMoviesProvider );

  
    
    //usamos SingleChildScrollView para en este caso usar varios scrolls horizontales
    //usando la clase creada MoviesSlideshow en presentation/widgets/movies y que no se desborde
    //si usaramos Column con el segundo scroll horizontal ya se desbordaria
    //COMENTAMOS LO DE ABAJO Y LO HAREMOS CON CustomScrollView PARA QUE AL HACER SCROLL HACIA ABAJO 
    //EL MENU DONDE ESTA EL TITULO DE LA APLICACION Y EL BUSCADOR APARECIERAN TAN PRONTO
    //EMPIEZO A HACER SCROLL HACIA ABAJO

    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       //usamos el widget CustomAppBar creado por mi en widgets/shared
    //       const CustomAppbar(),
    
    //       //usamos la clase creada en presentation/widgets/movies para crear un carrusel,
    //       //le pasamos las peliculas obtenidas arriba con el provider moviesSlideshowProvider
    //       MoviesSlideshow(movies: slideShowMovies),
          
    //       //usamos el widget creado en presentation/widgets/movies, para mostrar las peliculas
    //       //le pasamos la variable que contiene el provider nowPlayingMoviesProvider creado arriba
    //       MovieHorizontalListView(
    //         movies: nowPlayingMovies,
    //         title: 'En cines',
    //         subTitle: 'Lunes 20' ,
    //         loadNextPage: () { 
    //           //Usamos el read, lo usamos si estamos entro de un callback o funciones
    //            //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
    //            //nuevas peliculas de otra pagina
    //           ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //         },
    //       ),
    //       //creamos otro scroll horizantal horizontal usando la clase creada MovieHorizontalListView
    //       //en presentation/widgets/movies
    //        MovieHorizontalListView(
    //         movies: nowPlayingMovies,
    //         title: 'Próximamente',
    //         subTitle: 'En este mes',
    //         loadNextPage: () { 
    //           //Usamos el read, lo usamos si estamos entro de un callback o funciones
    //            //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
    //            //nuevas peliculas de otra pagina
    //           ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //         },
    //       ),
    //       //creamos otro scroll horizantal horizontal usando la clase creada MovieHorizontalListView
    //       //en presentation/widgets/movies
    //        MovieHorizontalListView(
    //         movies: nowPlayingMovies,
    //         title: 'Populares',
    //         //subTitle: 'Lunes 20' ,
    //         loadNextPage: () { 
    //           //Usamos el read, lo usamos si estamos entro de un callback o funciones
    //            //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
    //            //nuevas peliculas de otra pagina
    //           ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //         },
    //       ),
    //       //creamos otro scroll horizantal horizontal usando la clase creada MovieHorizontalListView
    //       //en presentation/widgets/movies
    //        MovieHorizontalListView(
    //         movies: nowPlayingMovies,
    //         title: 'Mejor calificadas',
    //         subTitle: 'Desde siempre' ,
    //         loadNextPage: () { 
    //           //Usamos el read, lo usamos si estamos entro de un callback o funciones
    //            //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
    //            //nuevas peliculas de otra pagina
    //           ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    //         },
    //       ),
          
    //       const SizedBox( height: 10),
    //     ],
    //   ),
    // );


    //usamos CustomScrollView en lugar de SingleChildScrollView PARA QUE AL HACER SCROLL HACIA ABAJO 
    //EL MENU DONDE ESTA EL TITULO DE LA APLICACION Y EL BUSCADOR APARECIERAN TAN PRONTO
    //EMPIEZO A HACER SCROLL HACIA ABAJO

    return CustomScrollView(
      //los slivers son widgets que trabajan directamente con el ScrollView
      slivers: [

        //cambiamos el appbar respecto el codigo comentado(CustomAppbar creado por mi en widgets/shared)arriba es una appbar tradicional
        //pero funciona directamente con el scroll
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(), //usamos el CustomAppbar creado creado por mi en widgets/shared
          ),

        ),
        //usamos el widget SliverList, que es como un ListView 
        SliverList(delegate: SliverChildBuilderDelegate(  //los delegate son las funciones para crear los widgets dentro de la lista
            (context, index) {
              //colocamos gran parte del codigo de arriba comentado,cambiamos el appbar
              return Column(
                children: [
                 
                 //usamos el widget CustomAppBar creado por mi en widgets/shared
                 //lo comentamos ya que aqui no lo usamos de la misma manera que el codigo comentado arriba
                 //en su lugar usamos el creado arriba de tipo SliverAppBar para que funcione directamente con el scroll
                 //const CustomAppbar(),
            
                  //usamos la clase creada en presentation/widgets/movies para crear un carrusel,
                  //le pasamos las peliculas obtenidas arriba con el provider moviesSlideshowProvider
                  MoviesSlideshow(movies: slideShowMovies),
                  
                  //usamos el widget creado en presentation/widgets/movies, para mostrar las peliculas
                  //le pasamos la variable que contiene el provider nowPlayingMoviesProvider creado arriba
                  MovieHorizontalListView(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Lunes 20' ,
                    loadNextPage: () { 
                      //Usamos el read, lo usamos si estamos entro de un callback o funciones
                      //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
                      //nuevas peliculas de otra pagina
                      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                    },
                  ),

                  //creamos otro scroll horizontal usando la clase creada MovieHorizontalListView
                  //en presentation/widgets/movies
                  MovieHorizontalListView(
                    movies: upcomingMovies,
                    title: 'Próximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () { 
                      //Usamos el read, lo usamos si estamos entro de un callback o funciones
                      //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
                      //nuevas peliculas de otra pagina
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  //creamos otro scroll horizontal usando la clase creada MovieHorizontalListView
                  //en presentation/widgets/movies, para obtener las peliculas mas populares
                  MovieHorizontalListView(
                    movies: popularMovies,
                    title: 'Populares',
                    //subTitle: 'Lunes 20' ,
                    loadNextPage: () { 
                      //Usamos el read, lo usamos si estamos entro de un callback o funciones
                      //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
                      //nuevas peliculas de otra pagina
                      ref.read(popularMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  //creamos otro scroll horizantal horizontal usando la clase creada MovieHorizontalListView
                  //en presentation/widgets/movies
                  MovieHorizontalListView(
                    movies: topRateMovies,
                    title: 'Mejor calificadas',
                    subTitle: 'Desde siempre' ,
                    loadNextPage: () { 
                      //Usamos el read, lo usamos si estamos entro de un callback o funciones
                      //llamamos al metodo loadNextPage del provider nowPlayingMoviesProvider para cargar
                      //nuevas peliculas de otra pagina
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  
                  const SizedBox( height: 10),
                ],
              );
            },
            childCount: 1
          )
        )
      ],
    );
  }
}