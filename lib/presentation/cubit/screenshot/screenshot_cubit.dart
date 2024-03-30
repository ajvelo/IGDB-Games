import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_state.dart';

class ScreenshotCubit extends Cubit<ScreenShotState> {
  final GameRepository gameRepository;
  ScreenshotCubit({required this.gameRepository})
      : super(ScreenShotInitialState());

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

  fetchScreenShots({required int gameId}) async {
    emit(ScreenShotLoadingState());
    try {
      final result = await gameRepository.fetchScreenShots(gameId: gameId);
      emit(ScreenShotLoadedState(urls: result));
    } catch (e) {
      emit(ScreenShotErrorState(error: _handleErrors(error: e)));
    }
  }
}
