import 'package:floor/floor.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

@dao
abstract class GameDao {
  @Query('SELECT * FROM Game')
  Future<List<Game>> findAllGames();

  @Query('SELECT name FROM Game')
  Future<List<String>> findAllGamesByName();

  @Query('SELECT * FROM Game WHERE id = :id')
  Future<Game?> findGameById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGames(List<Game> games);
}
