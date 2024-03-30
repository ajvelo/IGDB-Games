import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<List<Game>> fetchGames({required bool isRefresh});
  Future<List<Game>> filterBy(
      {required FilterEnum filter, required bool isAscending});
  Future<List<String>> fetchScreenShots({required int gameId});
}
