import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/game/game_state.dart';

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

  searchForGames({required String text, required int? statusValue}) async {
    try {
      final result = await gameRepository.searchForGames(
          text: text, statusValue: statusValue);
      emit(GameLoadedState(games: result, inSearch: true));
    } catch (e) {
      emit(GameErrorState(error: _handleErrors(error: e)));
    }
  }

  fetchGames(
      {required bool isRefresh,
      required int? statusValue,
      required int page}) async {
    if (page == 0) {
      emit(GameLoadingState());
    }
    try {
      final result = await gameRepository.fetchGames(
          isRefresh: isRefresh, statusValue: statusValue, page: page);
      emit(GameLoadedState(games: result, inSearch: false));
    } catch (e) {
      emit(GameErrorState(error: _handleErrors(error: e)));
    }
  }

  filterBy(
      {required FilterEnum filter,
      required bool isAscending,
      required int? statusValue}) async {
    emit(GameLoadingState());
    try {
      final result = await gameRepository.filterBy(
          filter: filter, isAscending: isAscending, statusValue: statusValue);
      emit(GameLoadedState(games: result, inSearch: false));
    } catch (e) {
      emit(GameErrorState(error: _handleErrors(error: e)));
    }
  }
}
