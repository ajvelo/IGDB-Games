import 'package:igdb_games/domain/game_entity.dart';

abstract class GameRepository {
  Future<List<Game>> fetchGames({required bool isRefresh});
}
