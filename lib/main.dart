import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_cubit.dart';
import 'package:igdb_games/presentation/pages/main_page.dart';

import 'injection_container.dart' as dependency;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            child: const MainPage(),
            create: (context) =>
                dependency.sl<GameCubit>()..fetchGames(isRefresh: false)),
        BlocProvider(create: (context) => dependency.sl<ScreenshotCubit>())
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
