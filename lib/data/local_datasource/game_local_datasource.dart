import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameLocalDatasource {
  Future<List<Game>> fetchGames({required int? statusValue});
  Future<List<Game>> filterBy(
      {required FilterEnum filter, required bool isAscending});
  Future<void> saveGames(List<Game> games);
}

class GameLocalDatasourceImpl implements GameLocalDatasource {
  late GameDao dao;

  GameLocalDatasourceImpl({required this.dao});
  @override
  Future<List<Game>> fetchGames({required int? statusValue}) async {
    List<Game> games = await dao.findAllGames();
    try {
      if (games.isEmpty) {
        throw CacheException(message: 'empty');
      }
      games.sort(
        (a, b) => a.id.compareTo(b.id),
      );

      if (statusValue != null) {
        games = games
            .where((element) => element.status.value == statusValue)
            .toList();
      }
      return games;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<void> saveGames(games) async {
    await dao.insertGames(games);
  }

  @override
  Future<List<Game>> filterBy(
      {required FilterEnum filter, required bool isAscending}) async {
    final games = await fetchGames(statusValue: null);
    switch (filter) {
      case FilterEnum.name:
        isAscending
            ? games.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
            : games.sort(
                (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        return games;
      case FilterEnum.ranking:
        isAscending
            ? games.sort((a, b) => b.totalRating.compareTo(a.totalRating))
            : games.sort((a, b) => a.totalRating.compareTo(b.totalRating));
        return games;
      default:
        return games;
    }
  }
}
