import 'package:floor/floor.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

@dao
abstract class GameDao {
  @Query('SELECT * FROM Game')
  Future<List<Game>> findAllGames();

  @Query('SELECT name FROM Game')
  Future<List<String>> findAllGamesByName();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGames(List<Game> games);

  @Query('SELECT * FROM Game WHERE name LIKE :text')
  Future<List<Game>> searchForGames(String text);
}
