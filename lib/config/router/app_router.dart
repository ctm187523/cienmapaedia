
//instalamos go router con --> flutter pub add go_router
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';


final appRouter = GoRouter(
  
  initialLocation: '/home/0',

  //en esta rama fin-seccion-16-B, que es una continuacion del main, no usamos en
  //este archivo el ShellRoute como hicimos en la rama fin-seccion-16-A que es como
  //el equipo de Flutter recomienda si usamos un ButtonNavigationBar, pero el problema
  //esta que al presionar un boton del menu inferior se pierde el estado si despues volvemos
  //a la opcion que teniamos anteriormente por eso se hace de otra manera alternativa
  //al realizado en la rama fin-seccion-16-A y asi poder mantener el estado
  routes: [
    GoRoute(
      path: '/home/:page',//recibimos la variable page cual es la ruta(view) que queremos recibir, home,categories,favorites
      name: HomeScreen.name,
      builder: (context, state) {

        //obtenemos el page del path (3 lineas arriba), en caso de que no venga obtenemos un String 0
        final pageIndex = state.pathParameters['page'] ?? '0';

        //devolvemos la vista que queremos visualizar(home,favorites,etc), pasandole por parametro el indice
        //hacemos un casting de String a Int
        return HomeScreen( pageIndex: int.parse(pageIndex));
      },
      //rutas hijas
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

    //en caso de que no coincida la ruta redirigimos al home
    GoRoute(
      path: '/',
      //ponemos _ , __ para indicar que no usaremos los atributos que pide 
      redirect:  ( _ , __ ) => '/home/0' 
    )
    
  ]
);