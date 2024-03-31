import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameLocalDatasource {
  Future<List<Game>> fetchGames();
  Future<List<Game>> filterBy(
      {required FilterEnum filter,
      required Status? status,
      required bool isAscending});
  Future<void> saveGames(List<Game> games);
}

class GameLocalDatasourceImpl implements GameLocalDatasource {
  late GameDao dao;

  GameLocalDatasourceImpl({required this.dao});
  @override
  Future<List<Game>> fetchGames() async {
    try {
      final games = await dao.findAllGames();
      if (games.isEmpty) {
        throw CacheException(message: 'empty');
      }
      games
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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
      {required FilterEnum filter,
      required Status? status,
      required bool isAscending}) async {
    final games = await fetchGames();
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
      case FilterEnum.status:
        final filteredGames =
            games.where((game) => game.status == status).toList();
        return filteredGames;
      default:
        return games;
    }
  }
}
