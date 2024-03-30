import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/game_model.dart';
import 'package:igdb_games/data/game_remote_datasource.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/game_entity.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDatasource remoteDatasource;
  final GameLocalDatasource localDatasource;

  GameRepositoryImpl(
      {required this.localDatasource, required this.remoteDatasource});

  Future<List<Game>> _fetchFromRemote() async {
    final results = await remoteDatasource.fetchGames();
    final games = results.map((gameModels) => gameModels.toEntity()).toList();
    await localDatasource.saveGames(games);
    return games;
  }

  @override
  Future<List<Game>> fetchGames({required bool isRefresh}) async {
    try {
      if (isRefresh) {
        return _fetchFromRemote();
      } else {
        final gamesFromCache = await localDatasource.fetchGames();
        return gamesFromCache;
      }
    } on ServerException catch (e) {
      throw e.toString();
    } on CacheException catch (e) {
      if (e.message == 'empty') {
        return _fetchFromRemote();
      } else {
        throw e.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
