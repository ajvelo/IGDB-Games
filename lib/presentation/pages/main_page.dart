import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<GameCubit>().fetchGames(isRefresh: true),
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
            } else if (state is GameErrorState) {
              return Center(
                child: Text(state.error),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
