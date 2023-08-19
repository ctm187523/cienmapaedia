
import 'package:cinemapedia/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/local_storage_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Usamos RiverPood para crear el provider
final localStorageRepositoryProvider = Provider((ref) {

  //devolvemos una instancia del datasource IsarDatasource()
  return LocalStorageRepositoryImp( IsarDatasource());

});