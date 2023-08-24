
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie.dart';
import '../widgets.dart';


//clase para manejar el listado de favoritos
//he instalado --> flutter pub add flutter_staggered_grid_view
//para manejar el listado de favoritos como un grid
class MovieMasonry extends StatefulWidget {

  //propiedades
  final List<Movie> movies;
  final VoidCallback? loadNextpage;

  //constructor
  const MovieMasonry({
    super.key, 
    required this.movies, 
    this.loadNextpage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  //creamos un objeto ScrollController para manejar el infinite Scroll
  final scrollController = ScrollController();

  @override
  void initState() {

    super.initState();
    //colocamos un listener al objeto ScrollController
    scrollController.addListener(() {

        //si es nulo salimos 
        if( widget.loadNextpage == null ) return;
        //si la posicion del scroll + 100 pixeles es mayor a la maxima posicion del scroll
        //llamaos al metodo recibido por parametro en la clase loadnextPage() para cargar
        //mas peliculas de favoritos ubicadas en el local storage
        if( (scrollController.position.pixels +100) >= scrollController.position.maxScrollExtent){
            widget.loadNextpage!();
        }
        
    });
  }

  @override
  void dispose() {
    
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //usamos el widgeet MasonryGridView importado instalado y importado arriba
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, //items que muestra a lo ancho
        mainAxisSpacing: 10, //espacio vertical entre items
        crossAxisSpacing: 10, //espacio horizontal entre items
        itemCount: widget.movies.length,
        itemBuilder: (context, index){

          //creamos una condicion que si el indice es 1(el segundo elemento
          //ya que es 0,1,2,etc) retorne una columna con un height de 40
          //y asi le damos un toque distinto haciendo que la columna del medio
          //quede desplazada
          if( index == 1){
            return Column(
              children: [
                 const SizedBox(height: 40),
                 MoviePosterLink(movie: widget.movies[index])
              ],
            );
          }
          //usamos el widget MoviePosterLink creado por nosotros en
          //presentations/widgets/movies
          return MoviePosterLink( movie: widget.movies[index] );
        },
      ),
    );
  }
}