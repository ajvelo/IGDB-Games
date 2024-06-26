import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/models/game_model.dart';
import 'package:igdb_games/data/remote_datasource/game_remote_datasource.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDatasource remoteDatasource;
  final GameLocalDatasource localDatasource;

  GameRepositoryImpl(
      {required this.localDatasource, required this.remoteDatasource});

  Future<List<Game>> _fetchFromRemote(
      {required int? statusValue, required int page}) async {
    final results =
        await remoteDatasource.fetchGames(statusValue: statusValue, page: page);
    final games = results.map((gameModels) => gameModels.toEntity()).toList();
    await localDatasource.saveGames(games);
    return localDatasource.fetchGames(statusValue: statusValue);
  }

  @override
  Future<List<Game>> fetchGames(
      {required bool isRefresh,
      required int? statusValue,
      required int page}) async {
    try {
      if (isRefresh) {
        return _fetchFromRemote(statusValue: statusValue, page: page);
      } else {
        final gamesFromCache =
            await localDatasource.fetchGames(statusValue: statusValue);
        return gamesFromCache;
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on CacheException catch (e) {
      if (e.message == 'empty') {
        return _fetchFromRemote(statusValue: statusValue, page: page);
      } else {
        throw e.message;
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<List<Game>> filterBy(
      {required FilterEnum filter,
      required bool isAscending,
      required int? statusValue}) async {
    try {
      final gamesFromCache = await localDatasource.filterBy(
          filter: filter, isAscending: isAscending, statusValue: statusValue);
      return gamesFromCache;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<String>> fetchScreenShots({required int gameId}) async {
    try {
      final screenshots =
          await remoteDatasource.fetchScreenShots(gameId: gameId);
      return screenshots.map((e) => e.url).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<List<Game>> searchForGames(
      {required String text, required int? statusValue}) async {
    try {
      final games = await localDatasource.searchForGames(
          text: text, statusValue: statusValue);
      return games;
    } catch (e) {
      throw e.toString();
    }
  }
}
