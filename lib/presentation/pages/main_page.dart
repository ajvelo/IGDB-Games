import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/presentation/cubit/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state is GameLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GameLoadedState) {
            final games = state.games;
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<GameCubit>().fetchGames(isRefresh: true),
              child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https:${game.imageCover}",
                        height: 100,
                        width: 50,
                      ),
                    ),
                    title: Text(game.name),
                    subtitle: Text(
                      game.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            );
          } else if (state is GameErrorState) {
            return Center(
              child: Text(state.error),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
