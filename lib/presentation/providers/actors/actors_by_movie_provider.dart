

//provider para recibir la informacion de una pelicula en concreto

import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/actor.dart';


//creamos el Provider
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>>>((ref) {

  //usamos el provider actorRepositoryProvider para en la siguiente linea usar el metodo getActorsByMovie
  //y pasarlo por parametro a la clase creada abajo MovieMapNotifier
  final actorsRepository = ref.watch( actorRepositoryProvider );


  return ActorsByMovieNotifier( getActors: actorsRepository.getActorsByMovie); //pasamos la referencia sin parentesis getMovieById()
});


//creamos un typedef para manejar la funcion que vamos a recibir en la clase MovieMapNotifier
//creada abajo
typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

//creamos un mapa donde tenemos el id de la pelicula(string) y apunta a una lista de instancia de la clase Actor
//queremos manejar una memoria cache para que si esa pelicula ya ha sido cargada anteriormente su lista de actores
//no la vuelva a cargar y use la cargada
class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>> {
  
  final GetActorsCallback getActors;

  //constructor
  ActorsByMovieNotifier({
    required this.getActors
  }): super({});

  Future<void> loadActors(String movieId) async {
    //el state seria el array de movieId en cache, seria la cache en memoria si ya existe salimos
    //y no cargamos la lista de actores de la pelicula seleccionada
    if( state[movieId ] != null) return;

    final List<Actor> actors = await getActors( movieId );

    //creamos un nuevo estado para manejar la cache, usamos el spread ... con los movieId almacenados
    // y almacenamos la nueva movie 
    state = { ...state, movieId: actors};

  }

}