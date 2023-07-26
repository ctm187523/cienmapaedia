
//instalamos go router con --> flutter pub add go_router
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';


final appRouter = GoRouter(
  
  initialLocation: '/',

  routes: [

    //usamos ShellRoute en lugar de GoRoute que es mas adecuado para el uso del
    //BottomNavigationBar ver --> https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [

        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
          },
          //rutas hijas de la ruta principal al pulsar una pelicula se direcciona a los detellas dependiendo del id de la pelicula
          routes: [
            GoRoute(
              path: 'movie/:id', //tenemos un parametro en la ruta, el id de la pelicula es un String
              name: MovieScreen.name,
              builder: (context, state) {
                //otenemos el Id de la Url usamos el state.pathParameters y de los parameters obtenemos el id
                //en caso de que no venga mostramos el string no-id
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(movieId: movieId); 
              },
            ),
          ]

        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const FavoritesView();
          }
        )
      ]
    )

    // Rutas padre/hijo
    //LO COMENTAMOS PORQUE USAMOS EN SU LUGAR ShellRoute en el codigo de arriba
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (context, state) => const HomeScreen( childView: HomeView(),),
    //   routes: [
    //     //hacemos la ruta hija de la ruta principal para que siempre pueda volver a la ruta principal el usaurio desde la ruta hija
    //     GoRoute(
    //       path: 'movie/:id', //tenemos un parametro en la ruta, el id de la pelicula es un String
    //       name: MovieScreen.name,
    //       builder: (context, state) {
    //         //otenemos el Id de la Url usamos el state.pathParameters y de los parameters obtenemos el id
    //         //en caso de que no venga mostramos el string no-id
    //         final movieId = state.pathParameters['id'] ?? 'no-id';
    //         return MovieScreen(movieId: movieId); 
    //       },
    //    ),
    //   ]
    // ),
    
  ]
);