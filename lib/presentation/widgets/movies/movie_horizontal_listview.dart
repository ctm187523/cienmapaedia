
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/movie.dart';

//heredamos de StatefulWidget para poder usar estados, usamos un listener para cargar
//las siguientes paginas de movies
class MovieHorizontalListView extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  //propiedad para cuando se llega al final cargar las siguientes peliculas 
  //de tipo VoidCallback, hacer el infiniteScroll, es opcional no tiene porque
  //cargar mas peliculas al final
  //La utilidad principal de VoidCallback es permitir que una función o un bloque 
  //de código se pase como argumento a otro widget o componente Flutter. Al hacerlo,
  // se puede invocar esa función o bloque de código en respuesta a un evento específico.
  final VoidCallback? loadNextPage; 

  //constructor
  const MovieHorizontalListView({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage
    });

  @override
  State<MovieHorizontalListView> createState() => _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {

  final scrollController = ScrollController(); //creamos un objeto de tipo ScrollController, para poner pausa, saber en que punto estamos,etc

  //usamos el estado inicial
  @override
  void initState() {

    super.initState();
    //agregamos un listener para cada uno de los listview que creamos
    scrollController.addListener(() { 

      if ( widget.loadNextPage == null ) return; //si no viene el loadNextPage ya que es opcional salimos

      //si tenemos un callback(loadNextPage) lo llamamos si llega a la posicion maxima con un margen de 200 pixeles
      if (scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent){

        widget.loadNextPage!(); //llamamos a la proxima pagina para que cargue las siguientes peliculas, ponemos el signo ! para indicar que no sera null, ya que previamente lo comprobamos
      }
    });
  }

  //usamos el dispose para hacer la limpieza de los listview que ya no usamos al ser destruido
  //cuando usamos el listener debemos usar el dispose

@override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 350,
      child: Column(
        children: [

          //ponemos una condicion de que se muestre si no es nulo, ponemos
          //widget.title y widget.subtitle porque heredamos de StatefulWidget y estamos
          //dentro del state
          if( widget.title != null || widget.subTitle != null)
            _Title( title: widget.title, subTitle: widget.subTitle), //llamamos al widget creado abajo

            //usamos un ListView.builder(ya que las peliculas que vamos a recibir no estan definidas), es la diferencia
            //entre usar ListView o un ListView.builder, el builder lo crea de manera perezosa 
            //el ListView sin el builder lo almacena en memoria.
            //Para crear un scroll horizontal para mostrar las películas
            //usamos el Widget Expanded para que el ListView tenga un tamaño específico
            Expanded(
              child: ListView.builder(
                controller: scrollController, //asociamos el scrollControler que es listener al ListView
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal, //ponemos que sera horizontal el scroll
                physics: const BouncingScrollPhysics(), //fisicas similares para Android y Ios
                itemBuilder: (context, index){
                  return _Slide(movie: widget.movies[index]); //usamos la clase creada abajo
                }
              )
            )
        ],
      ),
    );
  }
}


//clase para el titulo
class _Title extends StatelessWidget {
  
  //propiedades
  final String? title;
  final String? subTitle;
  
  //constructor
  const _Title({
    
    this.title,
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only( top: 10), //lo separamos 10 unidades de arriba
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [

          if( title != null)
            //ponemos ! de que lo tenemos porque antes lo evaluamos, usamos el estilo creado arriba
            Text(title!, style: titleStyle),

          const Spacer(), //creamos una separacion

           if( subTitle != null)
            //le damos el estilo de un FilledButton y el onPressed no hace nada
            FilledButton.tonal(
              style: const ButtonStyle( visualDensity: VisualDensity.compact), //hacemos el boton mas pequeño
              onPressed: (){}, 
               //ponemos ! de que lo tenemos porque antes lo evaluamos
              child: Text( subTitle! )
            )
        ],
      ),
    );
  }
}

//clase para manejar el scroll horizontal de las peliculas
class _Slide extends StatelessWidget {

  //propiedades
  final Movie movie;

  //constructor
  const _Slide({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    //creamos el estilo para el texto
    final textStyle = Theme.of(context).textTheme;

    //usamos el Widget Container que nos permite poner margenes
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //alineamos los hijos al inicio
        children: [

          //mostramos las imagenes
          SizedBox(
            width: 150,
            //usamos un ClipRRect para usarlo como un BorderRadius
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover, //usamos BoxFit.cover para que todas las imagenes sean del mismo tamaño
                width: 150,
                //se ejecuta cuando se carga la imagen, ponemos la condicion que si aun esta cargando
                //muestre un CircularProgressIndicator en caso contrario retorna el child que contiene las movies
                //usando el FadeIn de Fernando Alonso
                loadingBuilder: (context, child, loadingProgress) {
                 if ( loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator( strokeWidth: 2)),
                    );
                 }
                return FadeIn(child: child); //usamos el efecto FadeIn de animate_do de Fernando Herrera
                } ,
              ),
            )
          ),

          const SizedBox(height: 5), //creamos una separacion vertical
          //mostramos el titulo
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2, //le damos como maximo 2 lineas para el titulo
              style: textStyle.titleSmall, //usamos la propiedad textStyle creada arriba
            ),
          ),

          //Rating (Valoraciones de la pelicula)
          Row(children: [
            Icon( Icons.star_half_outlined, color: Colors.yellow.shade800),
            const SizedBox( width: 3), //separacion horizontal de 3 pixeles
            Text('${ movie.voteAverage }' , style:  textStyle.bodyMedium?.copyWith( color: Colors.yellow.shade800)),
            const SizedBox(width: 10),  //separacion horizontal de 10 pixeles
            //usamos la clase HumanFormats para formatear numeros creada en config/helpers
            Text( HumanFormats.number(movie.popularity), style: textStyle.bodySmall),
            ],
          )   
        ],
      ),
    );
  }
}

