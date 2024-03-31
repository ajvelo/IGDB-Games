import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game/game_state.dart';
import 'package:igdb_games/presentation/pages/game_detail_page.dart';
import 'package:igdb_games/presentation/widgets/filter_dialog.dart';
import 'package:igdb_games/presentation/widgets/game_card.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterOptionsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => showFilterOptions(context),
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            if (state is GameLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GameLoadedState) {
              final games = state.games;
              if (games.isEmpty) {
                return noGamesFound(context);
              } else {
                return gamesFound(context, games);
              }
            } else if (state is GameErrorState) {
              return Center(
                child: TextButton(
                  onPressed: () async {
                    await context.read<GameCubit>().fetchGames(isRefresh: true);
                  },
                  child: Text(
                    state.error,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.red),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  RefreshIndicator gamesFound(BuildContext context, List<Game> games) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GameCubit>().fetchGames(isRefresh: true);
      },
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GameDetailPage(
                    game: game,
                  ),
                ));
              },
              child: GameCard(
                imageUrl: game.imageCover,
                name: game.name,
                summary: game.summary,
                ranking: game.totalRating,
                status: game.status,
              ),
            ),
          );
        },
      ),
    );
  }

  Center noGamesFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No filters match your results.',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await context.read<GameCubit>().fetchGames(isRefresh: false);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Clear filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
