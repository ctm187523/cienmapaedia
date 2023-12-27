# cinemapedia

# Dev

1.Copiar el .env.template y renombrarlo a .env
2.Cambiar las variables de entorno (TheMovieDb)
3.Cmbioa en la entidad hay que ejecutar el comando
```
flutter pub run build_runner build
```

#Produccion
Para cambiar nombre aplicación:
```
 instalacion:
 flutter pub add change_app_package_name

 uso:
 flutter pub run change_app_package_name:main com.newpackage.nameaplication
```

Para cambiar el icono de la aplicacion
´´´
flutter pub run flutter_launcher_icons

´´´

Para cambiar el splash
´´´
   usar este con la version -> flutter_native_splash: ^2.2.19 
  flutter pub run flutter_native_splash:create
´´´