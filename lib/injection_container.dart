import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:igdb_games/data/game_remote_datasource.dart';
import 'package:igdb_games/data/game_repository.dart';
import 'package:igdb_games/data/local_datasource/game_cache_helper.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/game_cubit.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  // Datasources
  sl.registerLazySingleton<GameRemoteDatasource>(
      () => GameRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<GameLocalDatasource>(
      () => GameLocalDatasourceImpl(dao: sl<GameDao>()));

  final completer = Completer<void>();

  // GameDao
  sl.registerLazySingleton<GameDao>(() => sl<AppDatabase>().gameDao);

  // AppDatabase
  sl.registerSingletonAsync<AppDatabase>(() async {
    final database =
        $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await database;
    completer.complete();
    return database;
  });

  await completer.future;

  // Repositories
  sl.registerLazySingleton<GameRepository>(
      () => GameRepositoryImpl(localDatasource: sl(), remoteDatasource: sl()));

  // Cubit
  sl.registerFactory(() => GameCubit(gameRepository: sl()));

  // Misc
  sl.registerLazySingleton(() => Dio());
}
