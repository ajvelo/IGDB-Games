import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/game_state.dart';

class GameCubit extends Cubit<GameState> {
  final GameRepository gameRepository;
  GameCubit({required this.gameRepository}) : super(GameInitialState());

  String _handleErrors({required Object error}) {
    switch (error.runtimeType) {
      case (const (ServerException)):
        return (error as ServerException).message;
      case (const (CacheException)):
        return (error as CacheException).message;
      default:
        return 'Unknown Error';
    }
  }

  fetchGames({required bool isRefresh}) async {
    emit(GameLoadingState());
    try {
      final result = await gameRepository.fetchGames(isRefresh: isRefresh);
      emit(GameLoadedState(games: result));
    } catch (e) {
      emit(GameErrorState(error: _handleErrors(error: e)));
    }
  }

  filterBy({required FilterEnum filter, required bool isAscending}) async {
    emit(GameLoadingState());
    try {
      final result = await gameRepository.filterBy(
          filter: filter, isAscending: isAscending);
      emit(GameLoadedState(games: result));
    } catch (e) {
      emit(GameErrorState(error: _handleErrors(error: e)));
    }
  }
}
