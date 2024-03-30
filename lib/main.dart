import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/data/game_remote_datasource.dart';
import 'package:igdb_games/data/game_repository.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/presentation/cubit/game_cubit.dart';
import 'package:igdb_games/presentation/pages/main_page.dart';
import 'package:igdb_games/data/local_datasource/game_cache_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('game.db').build();
  final dao = database.gameDao;
  runApp(MyApp(dao));
}

class MyApp extends StatelessWidget {
  final GameDao dao;
  const MyApp(this.dao, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          child: const MainPage(),
          create: (context) => GameCubit(
              gameRepository: GameRepositoryImpl(
                  localDatasource: GameLocalDatasourceImpl(dao: dao),
                  remoteDatasource: GameRemoteDataSourceImpl(dio: Dio())))
            ..fetchGames(isRefresh: false),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const MainPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
