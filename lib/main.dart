import 'package:flutter/material.dart';

//he instalado para manejar las variables de entorno el siguiente paquete --> flutter pub add flutter_dotenv
//para usarlo en el archivo pubspec.yaml he insertado el siguiente codigo:
// assets:
//   - .env
//seguidamente importo el paquete:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//para usar las variables de entorno ponemos el siguiente codigo en el main -> Future<void> y el async
Future<void> main() async{

  //linea de codigo para manejar el splash screen creado en la ultima seccion para produccion seccion 31
  //es opcional esta linea de codigo
  //esta primera linea muestra el splash screen en la linea 55 del archivo home_view cuando esta inicializada la aplicacion removemos el spash screen
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  
  //inicializamos el paquete dotenv importado arriba para que lea las variables de entorno de manera global
  await dotenv.load(fileName: '.env');
  
  //envolvemos la clase Main en el ProviderScope de Riverpod para obtener el estado de forma global
  runApp(
    const ProviderScope(child: MainApp()));
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
