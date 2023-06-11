
//he instalado con -->flutter pub add card_swiper, card_swipper para crear un carrusel
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
//instalamos animated_do de fernado herrera para hacer animaciones con --> flutter pub add animate_do
import 'package:animate_do/animate_do.dart';

class MoviesSlideshow extends StatelessWidget {

  //propiedades
  final List<Movie> movies;

  //constuctor
  const MoviesSlideshow({
    super.key,
    required this.movies
    });

  @override
  Widget build(BuildContext context) {

    //propiedades
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity, //coje todo el ancho posible
      child: Swiper( //usamos para el carrusel el paquete instalada card/swipper(ver arriba)
        viewportFraction: 0.8, //propiedad para ver el slide anterior y el que sigue
        scale: 0.9, //lo escalamos mas pequeño
        autoplay: true, //lo ponemos el autoplay en true para que vayan pasando constantemente las imagenes
        pagination: SwiperPagination(  //propiedad para paginar las peliculas,
          margin: const EdgeInsets.only( top: 0), //creamos un margen de los puntos con el carrusel de peliculas
          builder: DotSwiperPaginationBuilder( //ponemos los puntitos de debajo de las imagenes
            activeColor: colors.primary, //color de la pagina activa
            color: colors.secondary //color de las paginas inactivas
          ) 
        ), 
        itemCount: movies.length,
        itemBuilder: (context, index) {
          //usamos la clase creda abajo y le pasamos como argumento las movies recibidas en los parametros de la clase
          return _Slide(movie: movies[index]); 
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  //propiedades
  final Movie movie;

  //constructor
  const _Slide({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    //propiedades
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20), //redondeado de la sobra
      boxShadow: const [ //sombreado
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10, //difuminado
          offset: Offset(0, 10) //como se vera la sombra en x e y,probar valores para ver resultados
        )
      ]
    );


    return Padding(
      padding: const EdgeInsets.only( bottom: 30),
      child: DecoratedBox(
        decoration: decoration, //usamos la propidad decoration creada arriba
        child: ClipRRect( //El ClipRect nos permite hacer redondeados en los bordes paracido a border-radius
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath, //le pasamos el atributo backdropPath de la movie recibida donde contiene la url de la imagen,
            fit: BoxFit.cover, //toma la imagen el espacio que le damos 
            //creamos un fondo de color black12 mientras se carga la imagen
            loadingBuilder: (context, child, loadingProgress) {
              if ( loadingProgress != null ){
                return const DecoratedBox(
                  decoration: BoxDecoration( color: Colors.black12)
                );
              }

              // si no esta en carga devolvemos la imagen, usamos el efecto del paquete
              //animate_do de Fernado Herrera FadeIn para que la imagen tenga el efecto
              return FadeIn(child: child); 
            },
          )
        )
      ),
    );
  }
}