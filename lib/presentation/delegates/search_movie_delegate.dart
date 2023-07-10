
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

//creamos una clase que hereda de SearchDelegate, como parametro ponemos que retorna una Movie es opcional
// esta clase SearchDelegate la usamos para manejar las busquedas en la aplicacion
//en este caso la busqueda de peliculas, tenemos que sobreescribir 4 metodos + 1 opcional
class SearchMovieDelegate extends SearchDelegate<Movie?> {

  //metodos ha sobreescribir de la clase SearchDelegate

  //metodo no obligatorio para sobreescribir que cambia el Label del buscador que viene
  //por defecto
  @override
  String get searchFieldLabel => "Buscar Película";

  //regresa una lista de widgets, que son los que aparecen al hacer click al icono de la lupa
  //para realizar la busqueda
  @override
  List<Widget>? buildActions(BuildContext context) {

    //print(' quuery: $query'); //vemos en consola lo que se introduce en la caja de busqueda
    
    return [
      
      //ponemos un IconButton y usamos query de SearchDelegate para que al ser pulsado borre la caja de texto donde introducimos la busqueda
      //solo se muestra si la caja de busqueda no esta vacia
      if (query.isNotEmpty)
        FadeIn( //usamos FadeIn del paquete de Fernando Herrera
          child: IconButton(
            onPressed: () => query = '', 
            icon: const Icon(Icons.clear)
          ),
        ),
    ];
  }


  //opcional, se usa para salir de la busqueda
  @override
  Widget? buildLeading(BuildContext context) {
   
   //para salir de la busqueda usamos el boton que llama a la funcion close de la clase SearchDelegate
   //el primer parametro es el contexto y es sugundo seria el resultado de lo que queremos mostrar al cerrar
   //como no devolvemos nada ponemos null, el icono es una flecha de back que al ser pulsado no retorna nada
   return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon( Icons.arrow_back_ios_new_outlined)
    );
  }

  //regresamos un Widget con los resultados
  @override
  Widget buildResults(BuildContext context) {
    
    return const Text('BuildAResults');

  }

  //
  @override
  Widget buildSuggestions(BuildContext context) {
    
     return const Text('BuildSugestions');
  }


}