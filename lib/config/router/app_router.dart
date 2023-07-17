
//instalamos go router con --> flutter pub add go_router
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';


final appRouter = GoRouter(
  
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        //hacemos la ruta hija de la ruta principal para que siempre pueda volver a la ruta principal el usaurio desde la ruta hija
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
    
  ]
);