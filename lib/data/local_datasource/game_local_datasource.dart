import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/domain/game_entity.dart';

abstract class GameLocalDatasource {
  Future<List<Game>> fetchGames();
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
}
