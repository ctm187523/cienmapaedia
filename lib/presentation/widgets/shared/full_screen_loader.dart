
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});


  //creamos un Stream con el array messages creado en el interior
  Stream<String> getLoadingMessages(){

     final messages = <String>[
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'La estan peinando',
      'Esto esta tardando mas de lo esperado :(',
  ];
    //retornamos los String en un periodo de 1200 milisegundos
    return Stream.periodic( const Duration(milliseconds: 1200 ), (step) {

      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),

          //usamos un StreamBuilder con el Stream creado arriba con el array messages
          StreamBuilder(
            stream: getLoadingMessages(), //llamamos al stream creado arriba
            builder: (context, snapshot) {
              
              //si no tenemos datos mostramos un texto que diga cargando...
              if( !snapshot.hasData) return Text('Cargando...');
              return Text ( snapshot.data!); //si tenemos data la mostramos ponemos el signo para indicar que si hay data
            },
          ),
        ],
      ),
    );
  }
}