
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {

  //constructor
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {

  final colors = Theme.of(context).colorScheme;
  final titleStyle = Theme.of(context).textTheme.titleMedium;

  //usamos SafeArea que es un widget que inserta a su hijo con suficiente relleno para evitar intrusiones por parte del sistema operativo.
  //Por ejemplo, esto sangrará al hijo lo suficiente como para evitar la barra de estado en la parte superior de la pantalla.
  //También sangrará al hijo con la cantidad necesaria para evitar The Notch en el iPhone X u otras características físicas creativas similares de la pantalla.
    return SafeArea(
      bottom: false, //quitamos el padding que deja en el bottom
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10),
        child: SizedBox(
          width: double.infinity, //le damos todo el ancho que podamos con infinity
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary,),
              const SizedBox( width: 5 ),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(), //con Spacer toma todo el espacio, es como un flex y manda al IconButton de abajo al final de la fila
              IconButton(onPressed: () {

              }, 
              icon: const Icon(Icons.search))
            ],
          ),

        ),
      )
    );
  }
}