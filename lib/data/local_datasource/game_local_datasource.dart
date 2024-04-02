import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameLocalDatasource {
  Future<List<Game>> fetchGames({required int? statusValue});
  Future<List<Game>> filterBy(
      {required FilterEnum filter,
      required bool isAscending,
      required int? statusValue});
  Future<void> saveGames(List<Game> games);
  Future<List<Game>> searchForGames(
      {required String text, required int? statusValue});
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
      games = _filterByStatus(statusValue: statusValue, games: games);
      return games
        ..sort(
          (a, b) => a.key.compareTo(b.key),
        );
    } catch (e) {
      if (e is CacheException) rethrow;
      throw e.toString();
    }
  }

  List<Game> _filterByStatus(
      {required int? statusValue, required List<Game> games}) {
    if (statusValue != null) {
      return games
          .where((element) => element.status.value == statusValue)
          .toList();
    } else {
      return games;
    }
  }

  @override
  Future<void> saveGames(games) async {
    await dao.insertGames(games);
  }

  @override
  Future<List<Game>> filterBy(
      {required FilterEnum filter,
      required bool isAscending,
      required int? statusValue}) async {
    final games = await fetchGames(statusValue: statusValue);
    switch (filter) {
      case FilterEnum.name:
        isAscending
            ? games.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
            : games.sort(
                (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));

      case FilterEnum.ranking:
        isAscending
            ? games.sort((a, b) => b.totalRating.compareTo(a.totalRating))
            : games.sort((a, b) => a.totalRating.compareTo(b.totalRating));

      default:
        return games;
    }
    return games;
  }

  @override
  Future<List<Game>> searchForGames(
      {required String text, required int? statusValue}) async {
    final games = await dao.searchForGames('%$text%');
    return _filterByStatus(statusValue: statusValue, games: games);
  }
}
