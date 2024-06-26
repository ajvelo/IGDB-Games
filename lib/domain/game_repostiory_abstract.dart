import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<List<Game>> fetchGames(
      {required bool isRefresh, required int? statusValue, required int page});
  Future<List<Game>> filterBy(
      {required FilterEnum filter,
      required bool isAscending,
      required int? statusValue});
  Future<List<String>> fetchScreenShots({required int gameId});
  Future<List<Game>> searchForGames(
      {required String text, required int? statusValue});
}
