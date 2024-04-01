import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game/game_state.dart';
import 'package:igdb_games/presentation/pages/game_detail_page.dart';
import 'package:igdb_games/presentation/widgets/filter_dialog.dart';
import 'package:igdb_games/presentation/widgets/game_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final scrollController = ScrollController();
  Status? status;
  int page = 0;

  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterOptionsDialog();
      },
    );
  }

  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      page++;
      await context
          .read<GameCubit>()
          .fetchGames(isRefresh: true, statusValue: status?.value, page: page);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
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
                return Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                            spacing: 8, children: _getFilterChips(context))),
                    gamesFound(context, games)
                  ],
                );
              }
            } else if (state is GameErrorState) {
              return Center(
                child: TextButton(
                  onPressed: () async {
                    await context.read<GameCubit>().fetchGames(
                        isRefresh: true,
                        statusValue: status?.value,
                        page: page);
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

  List<Widget> _getFilterChips(BuildContext context) {
    return [
          FilterChip(
            label: Text(
              'All',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: status == null ? Colors.white : Colors.black),
            ),
            backgroundColor: status == null ? Colors.black : Colors.white,
            onSelected: (value) async {
              status = null;
              await context.read<GameCubit>().fetchGames(
                  isRefresh: true, statusValue: status?.value, page: 0);
              setState(() {});
            },
          )
        ] +
        Status.values
            .map((e) => FilterChip(
                  backgroundColor: status == e ? Colors.black : Colors.white,
                  label: Text(
                    e.displayName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: status == e ? Colors.white : Colors.black),
                  ),
                  onSelected: (value) async {
                    status = e;
                    await context.read<GameCubit>().fetchGames(
                        isRefresh: true, statusValue: status?.value, page: 0);
                    setState(() {});
                  },
                ))
            .toList();
  }

  Widget gamesFound(BuildContext context, List<Game> games) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<GameCubit>().fetchGames(
              isRefresh: true, statusValue: status?.value, page: page);
        },
        child: ListView.builder(
          controller: scrollController,
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
              status = null;
              await context
                  .read<GameCubit>()
                  .fetchGames(isRefresh: false, statusValue: null, page: 0);
              setState(() {});
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
