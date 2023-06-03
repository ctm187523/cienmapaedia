import 'package:flutter/material.dart';

//he instalado para manejar las variables de entorno el siguiente paquete --> flutter pub add flutter_dotenv
//para usarlo en el archivo pubspec.yaml he insertado el siguiente codigo:
// assets:
//   - .env
//seguidamente importo el paquete:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';

//para usar las variables de entorno ponemos el siguiente codigo en el main -> Future<void> y el async
Future<void> main() async{

  //inicializamos el paquete dotenv importado arriba para que lea las variables de entorno de manera global
  await dotenv.load(fileName: '.env');
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( //ponemos .router para usar go_router creado en appRouter
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme()
    );
  }
}
